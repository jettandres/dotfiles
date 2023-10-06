-- setup package manager
require("bootstraplazy")
require("lazy").setup("plugins")

require("settings")
require("maps")
require("autocmd")

require("lspsetup")

vim.cmd[[colorscheme tokyonight]]
