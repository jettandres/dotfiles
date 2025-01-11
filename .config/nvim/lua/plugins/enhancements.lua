return {
	{ "andymass/vim-matchup" },
	{ "windwp/nvim-autopairs",
	  event = "InsertEnter",
          config = function ()
		local npairs = require("nvim-autopairs")
		npairs.setup({
			check_ts = true,
                        fast_wrap = {},
		})
          end
        },
	{ "windwp/nvim-ts-autotag" },
	{
		"folke/trouble.nvim",
		event = { "VeryLazy" },
		dependencies = { { "kyazdani42/nvim-web-devicons" } }
	},
	{
		  "iamcco/markdown-preview.nvim",
		  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		  build = "cd app && yarn install",
		  init = function()
			  vim.g.mkdp_filetypes = { "markdown" }
		  end,
		  ft = { "markdown" },
	}
}
