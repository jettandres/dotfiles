local map = vim.api.nvim_set_keymap

local options = { noremap = true, silent = true }

map('n', '<C-n>', '<cmd>set hlsearch!<cr>', options)

-- telescope mappings
map('n', '<C-p>', '<cmd>Telescope find_files<cr>', options)
map('n', '<C-f>', '<cmd>Telescope live_grep<cr>', options)
map('n', '<leader>p', '<cmd>Telescope buffers<cr>', options)
map('n', '<C-h>', '<cmd>Telescope help_tags<cr>', options)
