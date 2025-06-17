-- Configure clipboard to work seamlessly in both local and remote sessions
-- Uses OSC52 to ensure clipboard content works across SSH/Mosh sessions

local M = {}

M.setup = function()
  -- Use system clipboard
  vim.opt.clipboard = "unnamedplus"

  -- Check if we're in a remote session
  local is_remote = (os.getenv("SSH_CLIENT") ~= nil or os.getenv("SSH_TTY") ~= nil or os.getenv("MOSH_SERVER_PID") ~= nil)
  
  -- Use OSC52 for clipboard operations in remote sessions
  if is_remote then
    vim.g.clipboard = {
      name = 'OSC 52',
      copy = {
        ['+'] = {'clip-helper'},
        ['*'] = {'clip-helper'},
      },
      paste = {
        ['+'] = {
          -- We can't paste from client clipboard directly in remote sessions
          -- This is a limitation we have to live with
          'bash', '-c', 
          "echo 'Remote clipboard paste is not supported. Use terminal paste instead.'"
        },
        ['*'] = {
          'bash', '-c', 
          "echo 'Remote clipboard paste is not supported. Use terminal paste instead.'"
        },
      },
      cache_enabled = true,
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