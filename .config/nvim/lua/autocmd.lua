vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('packer_nvim_auto_install_plugins', {}),
  pattern = 'plugins.lua',
  callback = function()
    vim.ui.input({ prompt = 'Install plugin updates? (y/n; default=n): ' }, function(input)
      if input == 'y' then
        vim.cmd('source <afile> | PackerSync')
      end
    end)
  end
})

-- custom file types
vim.api.nvim_create_autocmd({ 'BufNew', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('fastlane', {}),
  pattern = 'Fastfile',
  command = 'set ft=ruby'
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
