local packer = require('packer')
local use = packer.use

-- Automatically install and setup packer.nvim on any machine
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
  install_path })
end

return packer.startup(function()
  use 'wbthomason/packer.nvim'

  -- performance benchmarking / improvements
  use 'dstein64/vim-startuptime'
  use 'lewis6991/impatient.nvim'

  -- treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }
  use 'nvim-treesitter/nvim-treesitter-context'

  -- lsp setup
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'j-hui/fidget.nvim'

  -- git
  use 'mhinz/vim-signify'
  use 'tpope/vim-fugitive'

  -- telescope
  use 'nvim-lua/plenary.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use {
    'nvim-telescope/telescope.nvim',
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-j>'] = 'move_selection_next',
              ['<C-k>'] = 'move_selection_previous',
            },
            n = {
              ['<leader>fd'] = 'send_selected_to_qflist',
            }
          },
        },
      }
      require('telescope').load_extension('fzf')
    end,
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

  -- nvim-tree
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
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

  -- nvim-dap
  use 'mfussenegger/nvim-dap'
  use {
    'leoluz/nvim-dap-go',
    config = function()
      require('dap-go').setup()
    end
  }
  use { 'rcarriga/nvim-dap-ui',
  requires = { 'mfussenegger/nvim-dap' },
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
}
use { 'theHamsta/nvim-dap-virtual-text',
config = function()
  require('nvim-dap-virtual-text').setup()
end
        }

        -- enhancements
        use 'andymass/vim-matchup'
        use {
          'windwp/nvim-autopairs',
          config = function()
            require("nvim-autopairs").setup()
          end
        }
        use {
          'windwp/nvim-ts-autotag',
          config = function()
            require('nvim-ts-autotag').setup()
          end
        }
        use {
          "folke/trouble.nvim",
          requires = "kyazdani42/nvim-web-devicons",
          config = function()
            require("trouble").setup()
          end
        }

        -- theme
        use 'folke/tokyonight.nvim'

        -- lualine
        use {
          'nvim-lualine/lualine.nvim',
          requires = { 'kyazdani42/nvim-web-devicons', opt = true }
        }

        -- markdown-preview
        use({
          "iamcco/markdown-preview.nvim",
          run = function() vim.fn["mkdp#util#install"]() end,
        })

        -- Automatically set up config after cloning packer.nvim
        if packer_bootstrap then
          packer.sync()
        end
      end)
