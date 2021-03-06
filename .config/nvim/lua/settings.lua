local o = vim.o
local wo = vim.wo
local bo = vim.bo
local g = vim.g

-- global-local options
o.splitbelow = true
o.ignorecase = true
o.smartcase = true
o.updatetime = 100

-- window-local options
wo.number = true
wo.relativenumber = true
wo.signcolumn = "yes"

-- buffer-local options
bo.expandtab = true
bo.shiftwidth = 2
bo.autoindent = true
bo.smartindent = true

-- global-editor options
g.matchup_matchparen_offscreen = { method = "status" }

-- theme settings
g.tokyonight_style = "night"
vim.cmd [[colorscheme tokyonight]]
