local options = { noremap = true, silent = true }

vim.keymap.set('n', '<C-n>', '<cmd>set hlsearch!<cr>', options)
vim.keymap.set('n', 'j', 'gj', options)
vim.keymap.set('n', 'k', 'gk', options)

-- telescope mappings
vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files<cr>', options)
vim.keymap.set('n', '<C-f>', '<cmd>Telescope live_grep<cr>', options)
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope current_buffer_fuzzy_find<cr>', options)
vim.keymap.set('n', '<leader>p', '<cmd>Telescope buffers<cr>', options)
vim.keymap.set('n', '<C-h>', '<cmd>Telescope help_tags<cr>', options)
vim.keymap.set('n', '<leader><esc>', '<cmd>Telescope keymaps<cr>', options)

-- quickfix mappings
vim.keymap.set('n', '<M-k>', '<cmd>cprev<cr>', options)
vim.keymap.set('n', '<M-j>', '<cmd>cnext<cr>', options)

-- nvim tree mappings
vim.keymap.set('n', '<C-b>', '<cmd>NvimTreeFindFileToggle<cr>', options)

-- vim-fugitive mappings
vim.keymap.set('n', '<leader>fc', '<cmd>Gvdiffsplit!<cr>', options)

-- markdown-preview mappings
vim.keymap.set('n', '<leader>md', '<cmd>MarkdownPreviewToggle<cr>', options)

-- treesitter syntax highlighting fix
vim.keymap.set('n', '<leader>w', '<C-o><cmd>write | edit | TSBufEnable highlight<cr>', options)
