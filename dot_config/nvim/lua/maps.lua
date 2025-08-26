local options = { noremap = true, silent = true }

vim.keymap.set('n', '<C-n>', '<cmd>set hlsearch!<cr>', options)
vim.keymap.set('n', 'j', 'gj', options)
vim.keymap.set('n', 'k', 'gk', options)

-- fzf-lua mappings
vim.keymap.set('n', '<C-p>', '<cmd>FzfLua files<cr>', options)
vim.keymap.set('n', '<C-f>', '<cmd>FzfLua live_grep<cr>', options)
vim.keymap.set('n', '<leader>ff', '<cmd>FzfLua lgrep_curbuf<cr>', options)
--
vim.keymap.set('n', '<leader>p', '<cmd>FzfLua buffers<cr>', options)
vim.keymap.set('n', '<C-h>', '<cmd>FzfLua helptags<cr>', options)
vim.keymap.set('n', '<leader><esc>', '<cmd>FzfLua keymaps<cr>', options)

-- quickfix mappings
vim.keymap.set('n', '<M-k>', '<cmd>cprev<cr>', options)
vim.keymap.set('n', '<M-j>', '<cmd>cnext<cr>', options)
vim.keymap.set('n', '<leader>fq', '<cmd>copen<cr>', options)

-- buffer mappings
vim.keymap.set('n', '<M-h>', '<cmd>bprev<cr>', options)
vim.keymap.set('n', '<M-l>', '<cmd>bnext<cr>', options)

-- nvim tree mappings
vim.keymap.set('n', '<C-b>', '<cmd>Oil<cr>', options)

-- vim-fugitive mappings
--vim.keymap.set('n', '<leader>fc', '<cmd>Gvdiffsplit!<cr>', options)
--vim.keymap.set('n', 'gh', '<cmd>diffget //2<cr>', options)
--vim.keymap.set('n', 'gl', '<cmd>diffget //3<cr>', options)

-- markdown-preview mappings
--vim.keymap.set('n', '<leader>md', '<cmd>MarkdownPreviewToggle<cr>', options)

-- swagger-preview mappings
--vim.keymap.set('n', '<leader>sp', '<cmd>SwaggerPreviewToggle<cr>', options)

-- treesitter syntax highlighting fix
vim.keymap.set('n', '<leader>w', '<C-o><cmd>write | edit | TSBufEnable highlight<cr>', options)

-- nvim-lint automatic fixing
-- Autofix entire buffer with eslint_d and then re-run linter
vim.keymap.set("n", "<leader>fa", function()
  -- Save cursor position
  vim.cmd("normal! mF")
  -- Run eslint_d on the whole buffer
  vim.cmd("%!eslint_d --stdin --fix-to-stdout --stdin-filename " .. vim.fn.expand("%:p"))
  -- Restore cursor
  vim.cmd("normal! `F")
  -- Trigger lint refresh
  require("lint").try_lint()
end, { desc = "eslint_d fix whole buffer" })

-- Autofix visual selection with eslint_d
vim.keymap.set("v", "<leader>fa",
  ":!eslint_d --stdin --fix-to-stdout<CR>gv",
  { noremap = true, silent = true, desc = "eslint_d fix selection" }
)
