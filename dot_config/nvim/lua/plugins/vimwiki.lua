return {
  "vimwiki/vimwiki",
  branch = "dev",
  keys = {
    { "<leader>tb", desc = "Tripurr board" },
    { "<leader>tn", desc = "Tripurr new ticket" },
    { "<leader>tw", desc = "Tripurr trigger work" },
  },
  init = function()
    vim.g.vimwiki_list = {
      {
        path = "~/vimwiki/tripurr",
        syntax = "markdown",
        ext = ".md",
        path_html = "~/vimwiki/tripurr/html",
        custom_wiki2html = "",
        auto_tags = 0,
        auto_diary_index = 0,
        auto_generate_links = 0,
        auto_generate_tags = 0,
      },
    }
    vim.g.vimwiki_global_ext = 0
    vim.g.vimwiki_markdown_link_ext = 0
    vim.g.vimwiki_auto_header = 0
    vim.g.vimwiki_diary_rel_path = ""
    vim.g.vimwiki_dir_link = ""
    vim.g.vimwiki_use_calendar = 0
    vim.g.vimwiki_folding = ""
  end,
}
