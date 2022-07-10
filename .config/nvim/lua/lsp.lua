-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- TODO: add other language servers
local servers = { 'eslint', 'tsserver', 'gopls', 'sumneko_lua' }
local lspconfig = require('lspconfig')

local saga = require('lspsaga')
local saga_action = require('lspsaga.action')
local saga_sighelper = require('lspsaga.signaturehelp')
local saga_rename = require('lspsaga.rename')
local saga_prevdef = require('lspsaga.definition')
local saga_diagnostic = require('lspsaga.diagnostic')

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = function(_, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<leader>e', saga_diagnostic.show_line_diagnostics, opts)
      vim.keymap.set('n', '[e', saga_diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']e', saga_diagnostic.goto_next, opts)
      vim.keymap.set('n', '<leader>E', vim.diagnostic.setloclist, opts)

      -- lspsaga mappings
      vim.keymap.set('n', 'gh', '<cmd>Lspsaga lsp_finder<cr>', opts)
      vim.keymap.set('n', '<leader>ac', '<cmd>Lspsaga code_action<cr>', opts)
      vim.keymap.set('v', '<leader>ac', '<cmd><C-U>Lspsaga range_code_action<cr>', opts)
      vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<cr>', { silent = true })
      vim.keymap.set('n', '<C-j>', function()
        saga_action.smart_scroll_with_saga(1)
      end, { silent = true })
      vim.keymap.set('n', '<C-k>', function()
        saga_action.smart_scroll_with_saga(-1)
      end, { silent = true })
      vim.keymap.set('n', '<C-k>', saga_sighelper.signature_help, opts)
      vim.keymap.set('n', '<leader>rn', saga_rename.lsp_rename, opts)

      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set('n', 'gD', saga_prevdef.preview_definition, bufopts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
      vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)

      vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
      vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)

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
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
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

-- lspsaga setup
saga.init_lsp_saga({
  border_style = "rounded",
  finder_action_keys = {
    open = "o",
    vsplit = "s",
    split = "i",
    tabe = "t",
    quit = "q",
    scroll_down = "<C-j>",
    scroll_up = "<C-k>",
  },
  code_action_icon = "🤔",
})
