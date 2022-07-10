vim.api.nvim_create_autocmd({ 'BufEnter', 'BufAdd', 'BufNew', 'BufNewFile', 'BufWinEnter' }, {
	group = vim.api.nvim_create_augroup('treesitter_fold_workaround', {}),
	callback = function()
		vim.opt.foldmethod = 'expr'
		vim.opt.foldexpr   = 'nvim_treesitter#foldexpr()'
	end
})

vim.api.nvim_create_autocmd('BufWritePost', {
	group = vim.api.nvim_create_augroup('packer_nvim_auto_install_plugins', {}),
	pattern = 'plugins.lua',
	command = 'source <afile> | PackerSync'
})

vim.api.nvim_create_autocmd('BufWritePre', {
	group = vim.api.nvim_create_augroup('format_on_save', {}),
	pattern = '*',
	callback = function()
		vim.lsp.buf.formatting_sync()
	end
})
