return {
  {
    "jettandres/neopi",
    config = function()
      require("neopi").setup({
        backend = "acpx",
        acpx = {
          command = "acpx",
          agent = "pi",
          format = "text",
          permissions = "approve-all",
        },
      })
    end,
  },
}
