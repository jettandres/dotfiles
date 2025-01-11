return {
  "kyazdani42/nvim-tree.lua",
  event = { "VeryLazy" },
  dependencies = {{ "kyazdani42/nvim-web-devicons" }},
  tag = 'nightly',
  config = function()
    require('nvim-tree').setup({
      filters = {
        dotfiles = false,
        exclude = { '.env.*' }
      },
    })
  end
}
