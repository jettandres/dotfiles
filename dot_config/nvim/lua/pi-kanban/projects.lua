-- Project registry for Tripurr kanban boards
-- Each project gets its own wiki subdirectory and kanban board.
--
-- Add entries here for each project you want to track.

return {
  tripurr = {
    name = "Tripurr",
    repo = "/home/jettandres/codes/triplang",
    wiki = "tripurr",          -- subdirectory under ~/vimwiki/
    description = "AI-assisted travel itinerary builder",
  },
  -- Add more projects:
  -- ["my-project"] = {
  --   name = "My Project",
  --   repo = "/home/jettandres/codes/my-project",
  --   wiki = "my-project",
  --   description = "What this project does",
  -- },
}
