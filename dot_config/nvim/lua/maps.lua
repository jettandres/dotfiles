vim.keymap.set('n', '<C-n>', '<cmd>set hlsearch!<cr>',
  { noremap = true, silent = true, desc = 'Disable highlight search' })
vim.keymap.set('n', 'j', 'gj', { noremap = true, silent = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true, silent = true })

-- fzf-lua mappings
vim.keymap.set('n', '<C-p>', '<cmd>FzfLua files<cr>', { noremap = true, silent = true, desc = 'Open files' })
vim.keymap.set('n', '<C-f>', '<cmd>FzfLua live_grep<cr>', { noremap = true, silent = true, desc = 'Find files' })
vim.keymap.set('n', '<leader>ff', '<cmd>FzfLua lgrep_curbuf<cr>',
  { noremap = true, silent = true, desc = 'Find files in buffer' })

vim.keymap.set('n', '<leader>p', '<cmd>FzfLua buffers<cr>', { noremap = true, silent = true, desc = 'Open buffer list' })
vim.keymap.set('n', '<C-h>', '<cmd>FzfLua helptags<cr>', { noremap = true, silent = true, desc = 'Search help' })
vim.keymap.set('n', '<leader><esc>', '<cmd>FzfLua keymaps<cr>',
  { noremap = true, silent = true, desc = 'Search keymaps' })

-- quickfix mappings
vim.keymap.set('n', '<M-k>', '<cmd>cprev<cr>', { noremap = true, silent = true, desc = 'Quickfix previous' })
vim.keymap.set('n', '<M-j>', '<cmd>cnext<cr>', { noremap = true, silent = true, desc = 'Quickfix next' })
vim.keymap.set('n', '<leader>fq', '<cmd>copen<cr>', { noremap = true, silent = true, desc = 'Open quickfix list' })

-- buffer mappings
vim.keymap.set('n', '<M-h>', '<cmd>bprev<cr>', { noremap = true, silent = true, desc = 'Buffer list previous' })
vim.keymap.set('n', '<M-l>', '<cmd>bnext<cr>', { noremap = true, silent = true, desc = 'Buffer list next' })

-- nvim tree mappings
vim.keymap.set('n', '<C-b>', '<cmd>Oil<cr>', { noremap = true, silent = true, desc = 'Open filetree' })

-- vim-fugitive mappings
vim.keymap.set('n', '<leader>fc', '<cmd>Gvdiffsplit!<cr>',
  { noremap = true, silent = true, desc = 'vim-fugitive: Fix merge conflicts' })
vim.keymap.set('n', '<leader>dgh', '<cmd>diffget //2<cr>',
  { noremap = true, silent = true, desc = 'vim-fugitive: Accept left (fix merge conflicts)' })
vim.keymap.set('n', '<leader>dgl', '<cmd>diffget //3<cr>',
  { noremap = true, silent = true, desc = 'vim-fugitive: Accept right (fix merge conflicts)' })
vim.keymap.set('n', '<C-l>', '<cmd>lua MiniDiff.toggle_overlay()<cr>',
  { noremap = true, silent = true, desc = 'Toggle diff overlay' })

-- markdown-preview mappings
--vim.keymap.set('n', '<leader>md', '<cmd>MarkdownPreviewToggle<cr>', options)

-- swagger-preview mappings
--vim.keymap.set('n', '<leader>sp', '<cmd>SwaggerPreviewToggle<cr>', options)

-- treesitter syntax highlighting fix. 08/2025 might not be needed?
-- vim.keymap.set('n', '<leader>w', '<C-o><cmd>write | edit | TSBufEnable highlight<cr>', options)
