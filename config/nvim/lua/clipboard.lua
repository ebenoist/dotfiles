-- Configure clipboard to work seamlessly in both local and remote sessions
-- Relies on the terminal (Zellij/Ghostty) handling OSC 52 natively.

local M = {}

M.setup = function()
  local is_remote = os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY") or os.getenv("MOSH_SERVER_PID")

  if is_remote then
    -- Use Neovim's built-in OSC 52 (v0.10+) — Zellij forwards it natively
    local osc52 = require('vim.ui.clipboard.osc52')
    -- Cache for yanked text (OSC 52 paste doesn't work over mosh)
    local clipboard_cache = {}

    vim.g.clipboard = {
      name = 'OSC 52',
      copy = {
        ['+'] = function(lines) clipboard_cache['+'] = lines; osc52.copy('+')(lines) end,
        ['*'] = function(lines) clipboard_cache['*'] = lines; osc52.copy('*')(lines) end,
      },
      paste = {
        ['+'] = function() return clipboard_cache['+'] or {} end,
        ['*'] = function() return clipboard_cache['*'] or {} end,
      },
    }
  end

  -- Highlight yanked text briefly
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
    end
  })
end

return M
