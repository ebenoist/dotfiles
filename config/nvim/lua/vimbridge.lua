-- RPC-callable bridge for Claude running in a :terminal split of this nvim.
-- No setup(), no autocmds -- pure library, loaded fresh from disk each call
-- via `dofile` (not require -- ~/bin/vimbuf dofile's this file's absolute
-- path every time, so edits here land without restarting nvim).
--
-- Mirror image of planwatch.lua: that one pushes eb: lines from a markdown
-- buffer out to a separate zellij pane. This lets the pane sitting inside
-- this same nvim process pull buffer state and push edits directly, any
-- filetype.
--
-- Single entrypoint, M.dispatch(request_path): reads {fn, arg} from a JSON
-- file and calls the matching handler below. This is deliberate -- the
-- caller (vimbuf) never interpolates a function name or argument into the
-- vim-expression string it sends over --remote-expr, only a fixed template
-- plus a tempfile path. Picking *what* to call is Lua's job, decided after
-- the JSON is decoded, not string-built beforehand across two languages.

local M = {}

-- Matches eb: anywhere in the line, leading or inline -- "- Rear steps eb:
-- replace these" is as valid as a standalone "eb: fix this" or a
-- "<!-- eb: fix this -->". The %f[%a] frontier requires the char right
-- before "eb" to be a non-letter (or start of line), which is what makes
-- "web: see notes" correctly not match (preceded by the letter "w") without
-- needing separate stripping for every comment-leader style.
-- ✓ "eb: fix this"           ✓ "# eb: fix this"     ✓ "// eb: fix this"
-- ✓ "board eb: fix this"     ✓ "- eb: fix this"     ✓ "<!-- eb: fix this -->"
-- ✗ "web: see notes"         ✗ "eb:" (no text)      ✗ "Deb: fix this"
local function marker(line)
  local text = line:match("%f[%a]eb:%s*(.-)%s*$")
  if not text or text == "" then
    return nil
  end
  text = text:gsub("%s*%-%->$", "")
  return text ~= "" and text or nil
end

local function eligible_buffers()
  local bufs = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf)
      and vim.fn.buflisted(buf) == 1
      and vim.bo[buf].buftype == "" then
      table.insert(bufs, buf)
    end
  end
  return bufs
end

local function do_buffers(_)
  local out = {}
  for _, buf in ipairs(eligible_buffers()) do
    table.insert(out, {
      bufnr = buf,
      name = vim.api.nvim_buf_get_name(buf),
      filetype = vim.bo[buf].filetype,
      modified = vim.bo[buf].modified,
      lines = vim.api.nvim_buf_line_count(buf),
    })
  end
  return out
end

local function do_read(bufnr)
  bufnr = tonumber(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_loaded(bufnr) then
    error("no such buffer: " .. tostring(bufnr))
  end
  return {
    bufnr = bufnr,
    name = vim.api.nvim_buf_get_name(bufnr),
    lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false),
  }
end

local function do_markers(_)
  local out = {}
  for _, buf in ipairs(eligible_buffers()) do
    local name = vim.api.nvim_buf_get_name(buf)
    for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
      local text = marker(line)
      if text then
        table.insert(out, { bufnr = buf, file = name, line = i, text = text })
      end
    end
  end
  return out
end

-- arg: JSON array [{bufnr, start, "end", lines}], 0-indexed half-open
-- exactly like nvim_buf_set_lines -- an empty `lines` deletes the range.
-- Applies against the live buffer, not the file on disk, so it survives
-- unsaved edits and keeps undo history sane. Per-edit failure is data, not
-- an error -- one bad bufnr in a batch shouldn't lose the rest.
local function do_apply(edits)
  local results = {}
  for _, edit in ipairs(edits) do
    local applied, err = pcall(vim.api.nvim_buf_set_lines,
      edit.bufnr, edit.start, edit["end"], false, edit.lines or {})
    table.insert(results, {
      bufnr = edit.bufnr,
      ok = applied,
      error = (not applied) and tostring(err) or nil,
    })
  end
  return { results = results }
end

local function log_path(file)
  return (file:gsub("%.md$", "")) .. ".log.md"
end

-- Writes through the buffer when that log is already open, so a visible
-- window updates live and the save keeps the on-disk copy in sync; falls
-- back to appending on disk otherwise. Same trick as planwatch's
-- log_append, kept as its own copy here rather than exported from there --
-- don't touch that module's working code for this.
local function log_append(file, entry_lines)
  local path = log_path(file)
  local buf = vim.fn.bufnr(path)

  if buf == -1 or not vim.api.nvim_buf_is_loaded(buf) then
    vim.fn.writefile(entry_lines, path, "a")
    return
  end

  local last = vim.api.nvim_buf_line_count(buf)
  if last == 1 and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == "" then
    last = 0
  end
  vim.api.nvim_buf_set_lines(buf, last, last, false, entry_lines)

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
  end
  if vim.bo[buf].modified then
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("silent write")
    end)
  end
end

-- arg: {file, lines}. lines[1] becomes the "## HH:MM  ..." heading, the
-- rest are appended as-is.
local function do_log(arg)
  if not arg.file or arg.file == "" then
    error("missing target file")
  end
  if not arg.lines or #arg.lines == 0 then
    error("nothing to log")
  end

  local entry = { "## " .. os.date("%H:%M") .. "  " .. arg.lines[1] }
  for i = 2, #arg.lines do
    table.insert(entry, arg.lines[i])
  end
  table.insert(entry, "")

  log_append(arg.file, entry)
  return { path = log_path(arg.file) }
end

local HANDLERS = {
  buffers = do_buffers,
  read = do_read,
  markers = do_markers,
  apply = do_apply,
  log = do_log,
}

function M.dispatch(request_path)
  local read_ok, raw = pcall(vim.fn.readfile, request_path)
  if not read_ok then
    return vim.json.encode({ ok = false, error = "cannot read request: " .. request_path })
  end

  local decode_ok, request = pcall(vim.json.decode, table.concat(raw, "\n"))
  if not decode_ok then
    return vim.json.encode({ ok = false, error = "bad json request" })
  end

  local handler = HANDLERS[request.fn]
  if not handler then
    return vim.json.encode({ ok = false, error = "no such function: " .. tostring(request.fn) })
  end

  local call_ok, result = pcall(handler, request.arg)
  if not call_ok then
    return vim.json.encode({ ok = false, error = tostring(result) })
  end
  return vim.json.encode({ ok = true, result = result })
end

return M
