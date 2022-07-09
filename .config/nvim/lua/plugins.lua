local packer = require('packer')
local use = packer.use

-- Automatically install and setup packer.nvim on any machine
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return packer.startup(function() 
   use 'wbthomason/packer.nvim'
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

  -- Automatically set up config after cloning packer.nvim
  if packer_bootstrap then
    packer.sync()
  end
end)
