local dap = require('dap')

local options = { noremap = true, silent = true }

vim.keymap.set('n', '<C-n>', '<cmd>set hlsearch!<cr>', options)

-- telescope mappings
vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files<cr>', options)
vim.keymap.set('n', '<C-f>', '<cmd>Telescope live_grep<cr>', options)
vim.keymap.set('n', '<leader>p', '<cmd>Telescope buffers<cr>', options)
vim.keymap.set('n', '<C-h>', '<cmd>Telescope help_tags<cr>', options)

-- nvim tree mappings
vim.keymap.set('n', '<C-b>', '<cmd>NvimTreeFindFileToggle<cr>', options)

-- vim-fugitive mappings
vim.keymap.set('n', '<leader>fc', '<cmd>Gvdiffsplit!<cr>', options)

-- nvim-dap mappings
vim.keymap.set('n', '<leader>d1', dap.step_out, options)
vim.keymap.set('n', '<leader>d2', dap.continue, options)
vim.keymap.set('n', '<leader>d3', dap.step_over, options)
vim.keymap.set('n', '<leader>d4', dap.step_into, options)
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, options)
vim.keymap.set('n', '<leader>dr', dap.repl.open, options)
vim.keymap.set('n', '<leader>dl', dap.run_last, options)
