-- OSC 52 always: a persistent zellij session inherits its env from wherever
-- it was started, so SSH_TTY/MOSH_* cannot tell local from remote. OSC 52
-- lands on whichever terminal is attached right now (zellij re-emits it,
-- mosh forwards 52;c, ghostty writes the clipboard).
-- Paste: neither zellij (zellij#2647) nor mosh forwards the OSC 52 query,
-- so register reads come from a cache of our own yanks; cross-app paste is
-- the terminal's own paste (bracketed paste handles it).

local M = {}

-- mosh silently truncates OSC payloads at 16KB (base64, so ~12KB of text)
local MOSH_OSC_CAP = 16 * 1024

local function osc52_copy(reg, cache)
  local copy = require('vim.ui.clipboard.osc52').copy(reg)
  return function(lines)
    cache[reg] = lines
    local bytes = #table.concat(lines, "\n")
    if math.ceil(bytes / 3) * 4 > MOSH_OSC_CAP then
      vim.notify(
        ("yank is %dKB; over mosh's 16KB OSC cap the clipboard will not update")
          :format(math.floor(bytes / 1024)),
        vim.log.levels.WARN
      )
    end
    copy(lines)
  end
end

M.setup = function()
  local cache = {}

  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = osc52_copy('+', cache),
      ['*'] = osc52_copy('*', cache),
    },
    paste = {
      ['+'] = function() return cache['+'] or {} end,
      ['*'] = function() return cache['*'] or {} end,
    },
  }

  -- Highlight yanked text briefly
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
    end
  })
end

return M
