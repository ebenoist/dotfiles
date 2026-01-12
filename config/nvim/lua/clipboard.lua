-- Configure clipboard to work seamlessly in both local and remote sessions
-- Uses Neovim's built-in OSC52 support (v0.10+) for remote sessions

local M = {}

M.setup = function()
  local is_remote = os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY")

  if is_remote then
    -- Cache for yanked text (since OSC 52 paste doesn't work over mosh)
    local clipboard_cache = {}

    local function osc52_copy(reg)
      local osc52 = require('vim.ui.clipboard.osc52')
      return function(lines)
        clipboard_cache[reg] = lines
        osc52.copy(reg)(lines)
      end
    end

    vim.g.clipboard = {
      name = 'OSC 52',
      copy = {
        ['+'] = osc52_copy('+'),
        ['*'] = osc52_copy('*'),
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
