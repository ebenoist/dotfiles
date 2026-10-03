-- Send `eb:` lines from a markdown buffer to a named claude pane.
--   :Watch <name>   bind this buffer to an agent; every :w sends what is new
--   :Watch! <name>  same, but send the markers already in the file
--   <leader>s       send the marker under the cursor now, no save
--   :WatchStop      unbind
-- Agents register themselves from the claude side with `agent <name>`.

local M = {}

local ROOT = (vim.env.XDG_CACHE_HOME or vim.env.HOME .. "/.cache") .. "/plan-watch"
local CACHE = ROOT .. "/agents"
local BOUND = ROOT .. "/bound"
local ns = vim.api.nvim_create_namespace("planwatch")

-- The agent never sees the /watch instructions when nvim drives the binding,
-- so the first delivery carries them.
local PREAMBLE = "These lines come from Erik's buffer, not the TUI. "
  .. "Answer in this pane. Never edit that file."

local state = {}

-- ✓ "eb: drop the hook"   ✓ "- eb: rewrite in ruby"   ✓ "<!-- eb: ask first -->"
-- ✗ "web: see notes"      ✗ "eb:" (no text)           ✗ "describe: eb: nested"
local function marker(line)
  local rest = line:gsub("^%s+", "")
  rest = rest:gsub("^[-*>]%s+", "")
  rest = rest:gsub("^<!%-%-%s*", "")
  local text = rest:match("^eb:%s*(.-)%s*$")
  if not text then
    return nil
  end
  text = text:gsub("%s*%-%->$", "")
  return text ~= "" and text or nil
end

local function log_path(file)
  return (file:gsub("%.md$", "")) .. ".log.md"
end

-- Append through the buffer when the log is loaded so an open window updates
-- live, and write it back so the on-disk fallback stays in sync.
local function log_append(file, lines)
  local path = log_path(file)
  local buf = vim.fn.bufnr(path)

  if buf == -1 or not vim.api.nvim_buf_is_loaded(buf) then
    vim.fn.writefile(lines, path, "a")
    return
  end

  local last = vim.api.nvim_buf_line_count(buf)
  if last == 1 and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == "" then
    last = 0
  end
  vim.api.nvim_buf_set_lines(buf, last, last, false, lines)

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
  end
  if vim.bo[buf].modified then
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("silent write")
    end)
  end
end

local function scan(buf)
  local found = {}
  for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local text = marker(line)
    if text then
      table.insert(found, { line = i, text = text })
    end
  end
  return found
end

local function agents()
  local found = {}
  for _, file in ipairs(vim.fn.glob(CACHE .. "/*.json", false, true)) do
    local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(file), "\n"))
    if ok then
      table.insert(found, data)
    end
  end
  table.sort(found, function(a, b)
    return a.name < b.name
  end)
  return found
end

local function names(list)
  return vim.tbl_map(function(a)
    return a.name
  end, list)
end

local function resolve(want)
  local list = agents()
  if #list == 0 then
    return nil, "no agents registered -- run /name <agent> in a claude pane"
  end

  if want and want ~= "" then
    for _, agent in ipairs(list) do
      if agent.name == want then
        return agent
      end
    end
    return nil, "no agent named " .. want .. " -- known: " .. table.concat(names(list), ", ")
  end

  if #list > 1 then
    return nil, "name an agent -- known: " .. table.concat(names(list), ", ")
  end
  return list[1]
end

local function zellij(agent, action, arg)
  local cmd = { "zellij" }
  if agent.session and agent.session ~= "" then
    vim.list_extend(cmd, { "-s", agent.session })
  end
  vim.list_extend(cmd, { "action", action, "-p", tostring(agent.pane), arg })
  return vim.system(cmd, { text = true }):wait()
end

-- `zellij action paste -p <id>` exits 0 for a pane id that no longer exists, so
-- a closed agent would swallow every send. `agent <name>` renames the pane, and
-- renamed panes show up in the layout dump, so the name is the liveness token.
local function alive(agent)
  local cmd = { "zellij" }
  if agent.session and agent.session ~= "" then
    vim.list_extend(cmd, { "-s", agent.session })
  end
  vim.list_extend(cmd, { "action", "dump-layout" })

  local result = vim.system(cmd, { text = true }):wait()
  if result.code ~= 0 then
    return false
  end
  return result.stdout:find('name="' .. agent.name .. '"', 1, true) ~= nil
end

local function deliver(st, path, items)
  if not alive(st.agent) then
    return false, st.agent.name .. " is gone -- run `agent " .. st.agent.name .. "` in its pane"
  end

  local body = {}
  if st.greeted then
    table.insert(body, "[planwatch] " .. vim.fn.fnamemodify(path, ":t"))
  else
    table.insert(body, "[planwatch] " .. path)
    table.insert(body, PREAMBLE)
    table.insert(body, "")
  end
  for _, m in ipairs(items) do
    table.insert(body, string.format("%s:%d  %s", path, m.line, m.text))
  end

  local result = zellij(st.agent, "paste", table.concat(body, "\n"))
  if result.code ~= 0 then
    return false, vim.trim(result.stderr or "zellij paste failed")
  end

  -- let the pane close the bracketed paste before the CR submits it
  vim.defer_fn(function()
    zellij(st.agent, "write", "13")
  end, 150)

  st.greeted = true
  for _, m in ipairs(items) do
    st.sent[m.text] = true
  end
  return true
end

-- Signs mark what has not been sent. A clean gutter means the buffer is flushed.
local function refresh(buf)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  local st = state[buf]
  if not st then
    return
  end
  for _, m in ipairs(scan(buf)) do
    if not st.sent[m.text] then
      vim.api.nvim_buf_set_extmark(buf, ns, m.line - 1, 0, {
        sign_text = ">",
        sign_hl_group = "DiagnosticSignWarn",
      })
    end
  end
end

local function send(buf, items)
  local st = state[buf]
  local file = vim.api.nvim_buf_get_name(buf)
  local ok, err = deliver(st, file, items)
  refresh(buf)
  if ok then
    local entry = {}
    for _, m in ipairs(items) do
      table.insert(entry, "## " .. os.date("%H:%M") .. "  " .. m.text)
    end
    table.insert(entry, "")
    log_append(file, entry)
    vim.notify(string.format("planwatch: %d -> %s", #items, st.agent.name))
  else
    vim.notify("planwatch: " .. err, vim.log.levels.ERROR)
  end
end

local function bind(buf, want, replay)
  local agent, err = resolve(want)
  if not agent then
    vim.notify("planwatch: " .. err, vim.log.levels.ERROR)
    return false
  end

  if not alive(agent) then
    vim.notify("planwatch: " .. agent.name .. " is gone -- run `agent " .. agent.name
      .. "` in its pane", vim.log.levels.ERROR)
    return false
  end

  local st = { agent = agent, sent = {}, greeted = false }
  if not replay then
    for _, m in ipairs(scan(buf)) do
      st.sent[m.text] = true
    end
  end
  state[buf] = st

  vim.fn.mkdir(BOUND, "p")
  vim.fn.writefile({ vim.json.encode({
    agent = agent.name,
    server = vim.v.servername,
    file = vim.api.nvim_buf_get_name(buf),
    log = log_path(vim.api.nvim_buf_get_name(buf)),
  }) }, BOUND .. "/" .. agent.name .. ".json")

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("planwatch_" .. buf, { clear = true }),
    buffer = buf,
    callback = function()
      M.flush(buf)
    end,
  })

  refresh(buf)
  vim.notify(string.format("planwatch: %s -> %s (pane %s)",
    vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t"), agent.name, agent.pane))
  return true
end

function M.flush(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local st = state[buf]
  if not st then
    return
  end

  local fresh = vim.tbl_filter(function(m)
    return not st.sent[m.text]
  end, scan(buf))

  if #fresh == 0 then
    refresh(buf)
    return
  end
  send(buf, fresh)
end

function M.cell()
  local buf = vim.api.nvim_get_current_buf()
  if not state[buf] and not bind(buf, nil, false) then
    return
  end

  local row = vim.api.nvim_win_get_cursor(0)[1]
  local text = marker(vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1] or "")
  if not text then
    vim.notify("planwatch: no eb: marker on this line", vim.log.levels.WARN)
    return
  end
  send(buf, { { line = row, text = text } })
end

-- Called over RPC by `planlog`, which drops the text in a file so nothing has
-- to survive two layers of shell and vimscript quoting. First line is the agent.
function M.log(payload)
  local lines = vim.fn.readfile(payload)
  local agent = table.remove(lines, 1)
  table.insert(lines, "")

  for buf, st in pairs(state) do
    if st.agent.name == agent and vim.api.nvim_buf_is_valid(buf) then
      log_append(vim.api.nvim_buf_get_name(buf), lines)
      return true
    end
  end
  return false
end

function M.stop(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local st = state[buf]
  if st then
    vim.fn.delete(BOUND .. "/" .. st.agent.name .. ".json")
  end
  pcall(vim.api.nvim_del_augroup_by_name, "planwatch_" .. buf)
  state[buf] = nil
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  vim.notify("planwatch: detached")
end

function M.setup()
  local group = vim.api.nvim_create_augroup("planwatch", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "markdown",
    callback = function(ev)
      vim.api.nvim_buf_create_user_command(ev.buf, "Watch", function(a)
        bind(ev.buf, a.args, a.bang)
      end, {
        nargs = "?",
        bang = true,
        complete = function()
          return names(agents())
        end,
        desc = "send eb: markers to a claude pane (! replays existing)",
      })

      vim.api.nvim_buf_create_user_command(ev.buf, "WatchLog", function()
        vim.cmd("vsplit " .. vim.fn.fnameescape(log_path(vim.api.nvim_buf_get_name(ev.buf))))
      end, { desc = "open the planwatch log beside this buffer" })

      vim.api.nvim_buf_create_user_command(ev.buf, "WatchStop", function()
        M.stop(ev.buf)
      end, { desc = "unbind this buffer from its claude pane" })

      vim.keymap.set("n", "<leader>s", M.cell, {
        buffer = ev.buf,
        desc = "planwatch: send the marker under the cursor",
      })
    end,
  })

  vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
    group = group,
    callback = function(ev)
      state[ev.buf] = nil
    end,
  })
end

return M
