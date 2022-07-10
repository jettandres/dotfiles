local map = vim.api.nvim_set_keymap

local options = { noremap = true, silent = true }
map('n', '<C-n>', ':set hlsearch!<cr>', options)
