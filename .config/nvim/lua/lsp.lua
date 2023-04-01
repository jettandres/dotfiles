-- Manage lsp servers with mason.nvim
local lsp_installer = require('mason')
local mason_lspconfig = require('mason-lspconfig')
lsp_installer.setup {}
mason_lspconfig.setup()

-- Setup lsp loading status
require('fidget').setup()

-- Auto-complete setup with luasnip and nvim-cmp
local luasnip = require('luasnip')
local cmp = require('cmp')

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-k>'] = cmp.mapping.scroll_docs(-4),
    ['<C-j>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on {
  'confirm_done',
  cmp_autopairs.on_confirm_done()
}

-- LSP config
local lspconfig = require('lspconfig')

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local on_attach = function(client, bufnr)
  if client.name == 'tsserver' then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  else
    -- Enable format on save capabilities
    client.server_capabilities.documentFormattingProvider = true
  end

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  -- dap-go mappings
  if client.name == 'gopls' then
    local dapgo = require('dap-go')
    local dap = require('dap')

    vim.keymap.set('n', '<leader>td', dapgo.debug_test, bufopts)
    vim.keymap.set('n', '<leader>tt', '<cmd>!go test<cr>', bufopts)
    vim.keymap.set('n', '<leader>tr', '<cmd>!go run .<cr>', bufopts)

    vim.keymap.set('n', '<F1>', dap.step_out, bufopts)
    vim.keymap.set('n', '<F2>', dap.continue, bufopts)
    vim.keymap.set('n', '<F3>', dap.step_over, bufopts)
    vim.keymap.set('n', '<F4>', dap.step_into, bufopts)
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, bufopts)
    vim.keymap.set('n', '<F7>', dap.repl.open, bufopts)
    vim.keymap.set('n', '<F8>', dap.run_last, bufopts)
  end

  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, bufopts)
  vim.keymap.set('n', '[e', vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set('n', ']e', vim.diagnostic.goto_next, bufopts)
  vim.keymap.set('n', '<leader>E', '<cmd>Trouble document_diagnostics<cr>', bufopts)

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)

  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)

  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ac', vim.lsp.buf.code_action, bufopts)

  if client.server_capabilities.documentFormattingProvider then
    -- format on save
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('format_on_save', {}),
      pattern = '*.go',
      callback = function()
        vim.lsp.buf.format()
      end
    })
  end
end

-- util functions to filter node_modules during Go To Definition
local function filter(arr, fn)
  if type(arr) ~= "table" then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

local function filterReactDTS(value)
    return string.match(value.targetUri, 'react/index.d.ts') == nil
end

mason_lspconfig.setup_handlers({
  function (server_name)
    lspconfig[server_name].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
  ["lua_ls"] = function ()
    lspconfig.lua_ls.setup {
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          library = {
            vim.api.nvim_get_runtime_file("", true),
            "/Users/jett/.hammerspoon/Spoons/EmmyLua.spoon/annotations"
          }
        },
        telemetry = {
          enable = false,
        },
      },
    },
  }
  end,
  ["tsserver"] = function ()
    lspconfig.tsserver.setup {
      handlers = {
        ['textDocument/definition'] = function(err, result, method, ...)
          if vim.tbl_islist(result) and #result > 1 then
            local filtered_result = filter(result, filterReactDTS)
            return vim.lsp.handlers['textDocument/definition'](err, filtered_result, method, ...)
          end

          vim.lsp.handlers['textDocument/definition'](err, result, method, ...)
        end
      }
    }
  end
})

local null_ls = require('null-ls')

null_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  sources = {
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.diagnostics.hadolint,
  },
}

-- change diagnostic symbols in gutter
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
