-- Install package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- remap <Leader> key to space
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

require("lazy").setup("plugins")

-- General setup
require("settings")
require("maps")
require("autocmd")

vim.lsp.enable({
  'gopls',
  'luals',
  'tsls',
  'svelte',
  'css',
})

require("lspsetup")
require("minisetup")

-- Theme
vim.cmd.colorscheme('minischeme')
