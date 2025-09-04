return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "go", "typescript", "javascript", "json" },
        sync_installed = false,
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
