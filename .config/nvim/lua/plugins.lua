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

	-- treesitter
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
	}
	use 'nvim-treesitter/nvim-treesitter-context'

	use 'andymass/vim-matchup'

	-- lsp setup
	use 'neovim/nvim-lspconfig'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'saadparwaiz1/cmp_luasnip'
	use 'L3MON4D3/LuaSnip'

	-- git
	use 'mhinz/vim-signify'
	use 'tpope/vim-fugitive'

	-- telescope
	use 'nvim-lua/plenary.nvim'
	use 'kyazdani42/nvim-web-devicons'
	use { 'nvim-telescope/telescope-fzf-native.nvim',
		run = 'make' }
	use {
		'nvim-telescope/telescope.nvim',
		config = function()
			require('telescope').setup {}
			require('telescope').load_extension('fzf')
		end,
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	-- theme
	use 'folke/tokyonight.nvim'

	-- lualine
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}

	-- Automatically set up config after cloning packer.nvim
	if packer_bootstrap then
		packer.sync()
	end
end)
