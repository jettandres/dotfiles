return { 
  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'L3MON4D3/LuaSnip' },
  { 'jose-elias-alvarez/null-ls.nvim', event = { "VeryLazy" } },
  { 'j-hui/fidget.nvim', branch = "legacy", event = { "VeryLazy" } },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim'},

  -- Golang Debugging
  { 'mfussenegger/nvim-dap', event = { "VeryLazy" } },
  { 'leoluz/nvim-dap-go' },

  { 'rcarriga/nvim-dap-ui',
  event = { "VeryLazy" },
  dependencies = { 'mfussenegger/nvim-dap' },
  config = function()
    require('dapui').setup({
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            "breakpoints",
            "stacks",
            "watches",
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            "repl",
          },
          size = 0.25,
          position = "bottom",
        },
      },
     })
   end
  },
  { 'theHamsta/nvim-dap-virtual-text' }
}
