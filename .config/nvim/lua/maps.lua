local map = vim.api.nvim_set_keymap

options = { noremap = true, silent = true }
map('n', '<C-n>', ':set hlsearch!<cr>', options)
