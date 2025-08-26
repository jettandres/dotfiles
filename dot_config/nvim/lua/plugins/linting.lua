return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    vim.env.ESLINT_D_PPID = vim.fn.getpid()
    lint.linters_by_ft = {
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }

    -- Auto lint on save, insert leave, or buffer enter
    local augroup = vim.api.nvim_create_augroup("nvim_linting", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufEnter" }, {
      group = augroup,
      callback = function() lint.try_lint() end,
    })
  end
}
