vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "PULLREQ_EDITMSG", "COMMIT_EDITMSG" },
  callback = function() vim.bo.syntax = "gitcommit" end,
})

vim.opt_local.spell = true
vim.opt_local.spelllang = "en"
vim.opt_local.spellfile = vim.fn.expand("$HOME/.config/nvim/spell/en.utf-8.add")

vim.opt_local.textwidth = 72
vim.opt_local.colorcolumn = "73"
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.list = false

vim.opt_local.scrolloff = 0
