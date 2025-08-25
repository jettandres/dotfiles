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
    if client:supports_method('textDocument/implementation') then
      -- Create a keymap for vim.lsp.buf.implementation ...
    end

    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    if client:supports_method('textDocument/completion') then
      -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      --local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      --client.server_capabilities.completionProvider.triggerCharacters = chars

      --vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
    end

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', {clear=false}),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

