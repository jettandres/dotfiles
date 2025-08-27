-- custom file types
vim.api.nvim_create_autocmd({ 'BufNew', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('fastlane', {}),
  pattern = 'Fastfile',
  command = 'set ft=ruby'
})

vim.api.nvim_create_autocmd({ 'BufNew', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('mp-sjs', {}),
  pattern = '*.sjs',
  command = 'set ft=javascript'
})

vim.api.nvim_create_autocmd({ 'BufNew', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('mp-axml', {}),
  pattern = '*.axml',
  command = 'set ft=xml'
})

vim.api.nvim_create_autocmd({ 'BufNew', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('mp-acss', {}),
  pattern = '*.acss',
  command = 'set ft=css'
})

vim.api.nvim_create_autocmd({ 'BufNew', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('env', {}),
  pattern = '.env.*',
  command = 'set ft=sh'
})

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  group = vim.api.nvim_create_augroup('sql lsp', { clear = true }),
  pattern = '*.sql',
  command = '!sqlfluff lint % --dialect postgres'
})

-- nvim-dap-ui
--local dap, dapui = require('dap'), require('dapui')
--dap.listeners.after.event_initialized["dapui_config"] = function()
--  dapui.open({})
--end
--dap.listeners.before.event_terminated["dapui_config"] = function()
--  dapui.close({})
--end
--dap.listeners.before.event_exited["dapui_config"] = function()
--  dapui.close({})
--end

-- built-in nvim lsp
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

-- keymaps specific to typescript-language-server only
vim.api.nvim_create_autocmd('Filetype', {
  group = vim.api.nvim_create_augroup('my.lsp.ts_ls.keymaps', { clear = false }),
  pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  callback = function()
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
  end
})

-- keymaps for lsp
vim.api.nvim_create_autocmd('Filetype', {
  group = vim.api.nvim_create_augroup('my.lsp.general.keymaps', { clear = false }),
  pattern = { 'go', 'lua', }, -- add as needed
  callback = function(args)
    vim.keymap.set('n', '<leader>fa', function()
      vim.lsp.buf.format({ bufnr = args.buf, timeout_ms = 1000 })
    end, { desc = 'format the current file in buffer' })
  end
})
