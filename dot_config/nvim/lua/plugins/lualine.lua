-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  opts = {
    options = {
      theme = "auto",
      component_separators = '|',
      section_separators = {},
      globalstatus = false,
    },
    sections = {
      lualine_a = {},
      lualine_b = { 'buffers' },
      lualine_c = {},
      lualine_x = {},
      lualine_y = { 'branch', 'filetype', 'progress' },
      lualine_z = {},
    },
    inactive_sections = {
      lualine_a = { 'filename' },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { 'location' },
    },
    tabline = {},
    extensions = {},
  }
}
