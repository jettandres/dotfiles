return {
  {
    "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      lazy = false,
      config = function ()
        require("nvim-treesitter.configs").setup {
          ensure_install = { "go", "typescript", "javascript", "json" },
          auto_install = true,
          highlight = {
            enable = true
          },
          incremental_selection = {
            enable = true,
            keymaps = {
              node_incremental = "vn",
              node_decremental = "vm",
              scope_incremental = "vc",
            },
          },
          matchup = {
            enable = true
          },
          autotag = {
            enable = true,
          }
        }
      end
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      enable = true,
      max_lines = 1,
      mode = "cursor",
    }
  },
}
