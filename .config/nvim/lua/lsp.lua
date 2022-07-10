-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- TODO: add other language servers
local servers = { 'eslint', 'tsserver', 'gopls', 'sumneko_lua' }
local lspconfig = require('lspconfig')

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = function(client, bufnr)
      -- Enable format on save capabilities
      client.server_capabilities.documentFormattingProvider = true
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      local bufopts = { noremap = true, silent = true, buffer = bufnr }

      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, bufopts)
      vim.keymap.set('n', '[e', vim.diagnostic.goto_prev, bufopts)
      vim.keymap.set('n', ']e', vim.diagnostic.goto_next, bufopts)
      vim.keymap.set('n', '<leader>E', vim.diagnostic.setloclist, bufopts)

      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)

      vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
      vim.keymap.set('n', '<leader>ac', vim.lsp.buf.code_action, bufopts)
    end,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true)
        },
        telemetry = {
          enable = false,
        },
      },
    },
  }
end

-- luasnip setup
local luasnip = require('luasnip')
-- nvim-cmp setup
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
