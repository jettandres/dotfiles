return {
  'Exafunction/codeium.vim',
  event = 'BufEnter',
  config = function ()
    vim.g.codeium_disable_bindings = 1

    -- Accept suggestion
    vim.keymap.set('i', '<Right>', function ()
      return vim.fn['codeium#Accept']()
    end, { expr = true, silent = true })

    -- Enable Chat
    vim.keymap.set('n', '<leader>h', function ()
      return vim.fn['codeium#Chat']()
    end, { silent = true })

    -- Cycle completions with Ctrl + Right and Ctrl + Left
    vim.keymap.set('i', '<C-Right>', '<cmd>call codeium#CycleCompletions(1)<cr>', { expr = true, silent = true })
    vim.keymap.set('i', '<C-Left>', '<cmd>call codeium#CycleCompletions(-1)<cr>', { expr = true, silent = true })

    -- Default bindings
    vim.keymap.set('i', '<C-;>', '<cmd>codeium#Clear()<cr>', { expr = true, silent = true })
  end
}
