local o = vim.o
local wo = vim.wo
local bo = vim.bo

-- global-local options
o.splitbelow = true
o.ignorecase = true
o.smartcase = true

-- window-local options
wo.number = true
wo.relativenumber = true
wo.signcolumn = "yes"

-- buffer-local options
bo.expandtab = true
bo.shiftwidth = 2
bo.autoindent = true
bo.smartindent=true