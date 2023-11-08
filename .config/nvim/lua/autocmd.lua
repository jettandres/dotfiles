-- custom file types
vim.api.nvim_create_autocmd({ 'BufNew', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('fastlane', {}),
  pattern = 'Fastfile',
  command = 'set ft=ruby'
})

vim.api.nvim_create_autocmd({ 'BufNew', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('mp-sjs', {}),
  pattern = '*.sjs',
  command = 'set ft=javascript'
})

vim.api.nvim_create_autocmd({ 'BufNew', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('mp-axml', {}),
  pattern = '*.axml',
  command = 'set ft=xml'
})

vim.api.nvim_create_autocmd({ 'BufNew', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('mp-acss', {}),
  pattern = '*.acss',
  command = 'set ft=css'
})

vim.api.nvim_create_autocmd({ 'BufNew', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('env', {}),
  pattern = '.env.*',
  command = 'set ft=sh'
})

-- nvim-dap-ui
local dap, dapui = require('dap'), require('dapui')
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close({})
end
