return {
  { "nvim-lua/plenary.nvim",
    event = { "VeryLazy" }
  },
  { "kyazdani42/nvim-web-devicons" },
  { "nvim-telescope/telescope-fzf-native.nvim",
    event = { "VeryLazy" },
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
  },
  { "nvim-telescope/telescope.nvim",
    config = function()
      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ['<C-j>'] = 'move_selection_next',
              ['<C-k>'] = 'move_selection_previous',
            },
            n = {
              ['<leader>fd'] = 'send_selected_to_qflist',
            }
          }
        }
      })
    end,
    dependencies = { { 'nvim-lua/plenary.nvim' } }
  }
}
