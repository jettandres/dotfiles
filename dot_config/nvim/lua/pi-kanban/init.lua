-- pi-kanban: Vimwiki-based kanban board with Pi RPC orchestration
--
-- Multi-project aware. Each project gets its own wiki subdirectory.
--
-- Commands:
--   :PiKanban           Open projects hub / current project board
--   :PiKanbanNew        Create a new ticket
--   :PiKanbanWork       Trigger Pi for the current ticket
--   :PiKanbanDelete     Delete the current ticket
--
-- Keymaps (global):
--   <leader>tb  Board / projects hub
--   <leader>tn  New ticket
--   <leader>tw  Trigger work
--   <leader>td  Delete ticket

local M = {}

local PROJECTS = require("pi-kanban.projects")
local WIKI_ROOT = vim.fn.expand("~/vimwiki")
local GLOBAL_TEMPLATE = WIKI_ROOT .. "/template.md"

-- ── Current project tracking ───────────────────────────────────────

M.current_project = nil   -- set when entering a project board

-- ── Helpers ─────────────────────────────────────────────────────────

local function project_dir(project)
  return WIKI_ROOT .. "/" .. project.wiki
end

local function tickets_dir(project)
  return project_dir(project) .. "/tickets"
end

local function board_index(project)
  return project_dir(project) .. "/index.md"
end

local function project_template(project)
  return project_dir(project) .. "/template.md"
end

-- ── Frontmatter parsing ────────────────────────────────────────────

local function parse_frontmatter(filepath)
  local fm = {}
  local f = io.open(filepath, "r")
  if not f then return nil end
  local line = f:read("*l")
  if not line or not line:match("^%-%-%-%s*$") then f:close(); return nil end
  while true do
    line = f:read("*l")
    if not line then break end
    if line:match("^%-%-%-%s*$") then break end
    local key, val = line:match("^([%w-]+):%s*(.*)$")
    if key then
      fm[key] = val:match("^%s*(.-)%s*$")
    end
  end
  f:close()
  return fm
end

local function get_frontmatter_status(filepath)
  local fm = parse_frontmatter(filepath)
  return fm and fm.status
end

-- Forward declaration (referenced by open_projects before definition)
local open_board

-- ── Projects list ──────────────────────────────────────────────────

local function open_projects()
  local lines = {}
  local function add(s) table.insert(lines, s) end

  add("# Projects")
  add("")
  add("> <CR> = open project board | <leader>tn = new ticket in current project")
  add("")

  for slug, proj in pairs(PROJECTS) do
    local desc = proj.description and (" — " .. proj.description) or ""
    add(string.format("- [[%s/index|%s]]%s", proj.wiki, proj.name, desc))
  end
  add("")
  add("---")
  add("*Add projects in ~/.config/nvim/lua/pi-kanban/projects.lua*")

  -- Write + open
  local projects_index = WIKI_ROOT .. "/index.md"
  vim.fn.mkdir(WIKI_ROOT, "p")
  vim.fn.writefile(lines, projects_index)
  vim.cmd("edit " .. projects_index)

  local buf = vim.api.nvim_get_current_buf()
  M.current_project = nil

  -- <CR> opens the selected project board
  vim.keymap.set("n", "<CR>", function()
    local line = vim.api.nvim_get_current_line()
    local link = line:match("%[%[([^|%]]+)%]%]")
    if not link then
      link = line:match("%[%[([^|%]]+)|.-%]%]")
    end
    if link then
      -- Extract project slug: "tripurr/index" or "tripurr/index.md" → "tripurr"
      local slug = link:match("^([^/]+)/")
      if slug and PROJECTS[slug] then
        open_board(PROJECTS[slug])
      else
        vim.cmd("edit " .. WIKI_ROOT .. "/" .. link)
      end
    end
  end, { buffer = buf, desc = "Open project" })

  vim.keymap.set("n", "<BS>", "<C-o>", { buffer = buf, desc = "Go back" })
  vim.keymap.set("n", "<leader>tb", open_projects, { buffer = buf, desc = "Refresh projects" })
end

-- ── Board (per project) ────────────────────────────────────────────

function open_board(project)
  if not project then
    -- Called from board's <leader>tb — go back to projects
    open_projects()
    return
  end

  M.current_project = project
  local tdir = tickets_dir(project)
  vim.fn.mkdir(tdir, "p")

  -- Scan tickets
  local columns = { TODO = {}, ["IN PROGRESS"] = {}, ["IN REVIEW"] = {}, DONE = {} }
  local order = { "TODO", "IN PROGRESS", "IN REVIEW", "DONE" }
  local names = {}

  local handle = vim.loop.fs_scandir(tdir)
  if handle then
    while true do
      local name, _ = vim.loop.fs_scandir_next(handle)
      if not name then break end
      if name:match("%.md$") then table.insert(names, name) end
    end
  end
  table.sort(names)

  for _, name in ipairs(names) do
    local filepath = tdir .. "/" .. name
    local fm = parse_frontmatter(filepath)
    if fm and fm.status then
      local ticket = {
        id = fm.id or "?",
        title = fm.title or name:gsub("%.md$", ""),
        status = fm.status,
        labels = fm.labels or "",
        branch = fm.branch or "",
        ["pr-url"] = fm["pr-url"] or "",
        filename = name,
      }
      local col = columns[ticket.status] or columns.TODO
      table.insert(col, ticket)
    end
  end

  -- Build content
  local lines = {}
  local function add(s) table.insert(lines, s) end

  add("# " .. project.name .. " — Kanban")
  add("")
  add(string.format(
    "> <leader>tb = projects | <leader>tn = new ticket | <leader>tw = trigger | <CR>/<BS> = navigate | %s",
    os.date("%H:%M")))
  add("")

  for _, status in ipairs(order) do
    local col = columns[status]
    add("## " .. status .. " (" .. #col .. ")")
    add("")
    if #col == 0 then
      add("_no tickets_")
    else
      for _, t in ipairs(col) do
        local link = string.format("[[tickets/%s|#%s %s]]", t.filename, t.id, t.title)
        local label = ""
        if t.labels ~= "" then
          local tags = {}
          for lbl in t.labels:gmatch("[^,%s]+") do
            table.insert(tags, "`" .. lbl .. "`")
          end
          label = " " .. table.concat(tags, " ")
        end
        local pr = ""
        if t["pr-url"] ~= "" and t["pr-url"]:match("%S") then
          pr = "  🔗 [PR](" .. t["pr-url"] .. ")"
        end
        local branch = ""
        if t.branch ~= "" and t.branch:match("%S") then
          branch = "  ⎇ `" .. t.branch .. "`"
        end
        add(string.format("- [ ] %s%s%s%s", link, label, branch, pr))
      end
    end
    add("")
  end

  -- Write + open
  local index_path = board_index(project)
  vim.fn.mkdir(project_dir(project), "p")
  vim.fn.writefile(lines, index_path)
  vim.cmd("edit " .. index_path)

  local buf = vim.api.nvim_get_current_buf()

  -- Link navigation
  vim.keymap.set("n", "<CR>", function()
    local line = vim.api.nvim_get_current_line()
    local link = line:match("%[%[([^|%]]+)%]%]")
    if not link then
      link = line:match("%[%[([^|%]]+)|.-%]%]")
    end
    if link then
      vim.cmd("edit " .. project_dir(project) .. "/" .. link)
    end
  end, { buffer = buf, desc = "Open ticket" })

  vim.keymap.set("n", "<BS>", "<C-o>", { buffer = buf, desc = "Go back" })
  vim.keymap.set("n", "<leader>tb", function() open_board() end, { buffer = buf, desc = "Projects hub" })
end

-- ── Find project from current buffer ───────────────────────────────

local function find_project()
  -- First check if we have a current project set
  if M.current_project then
    -- Verify it still exists in the registry
    for slug, proj in pairs(PROJECTS) do
      if proj == M.current_project then return proj end
    end
    M.current_project = nil
  end

  -- Try to detect from the current file path
  local file = vim.api.nvim_buf_get_name(0)
  for slug, proj in pairs(PROJECTS) do
    local pattern = "^" .. vim.pesc(project_dir(proj)) .. "/"
    if file:match(pattern) then
      M.current_project = proj
      return proj
    end
  end

  -- Fallback: use first project
  for _, proj in pairs(PROJECTS) do
    M.current_project = proj
    return proj
  end
  return nil
end

-- ── Status change detection ────────────────────────────────────────

local function on_buf_write_post(args)
  local proj = find_project()
  if not proj then return end

  local file = vim.api.nvim_buf_get_name(args.buf)
  if not file:match("^" .. vim.pesc(tickets_dir(proj)) .. "/.*%.md$") then return end

  local new_status = get_frontmatter_status(file)
  if not new_status then return end

  local old_status = vim.b[args.buf]._pi_kanban_old_status
  vim.b[args.buf]._pi_kanban_old_status = new_status

  -- Debug: always show what we detected
  vim.notify(string.format("pi-kanban: %s → %s", old_status or "nil", new_status), vim.log.levels.INFO)

  if old_status == "TODO" and new_status == "IN PROGRESS" then
    M.trigger_work(file, "new")
  elseif old_status == "IN REVIEW" and new_status == "IN PROGRESS" then
    M.trigger_work(file, "resume")
  end
end

-- ── Trigger Pi orchestrator ─────────────────────────────────────────

function M.trigger_work(filepath, mode)
  mode = mode or "new"

  local fm = parse_frontmatter(filepath)
  if not fm then
    vim.notify("pi-kanban: cannot parse ticket frontmatter", vim.log.levels.ERROR)
    return
  end

  if mode == "resume" and not fm["session-path"] then
    vim.notify("pi-kanban: no session-path in ticket — use --new instead", vim.log.levels.ERROR)
    return
  end

  if mode == "resume" then
    local lines = vim.fn.readfile(filepath)
    local in_feedback, has_content = false, false
    for _, line in ipairs(lines) do
      if line:match("^## Review Feedback") then
        in_feedback = true
      elseif in_feedback and line:match("^## ") then
        break
      elseif in_feedback and line:match("%S") then
        has_content = true; break
      end
    end
    if not has_content then
      vim.notify("pi-kanban: add notes under '## Review Feedback' before resuming", vim.log.levels.WARN)
      return
    end
  end

  local ticket_id = fm.id or "unknown"
  local flag = mode == "resume" and "--resume" or "--new"
  local cmd = { vim.fn.expand("~/.local/bin/tripurr-ticket-work"), flag, filepath }

  vim.notify(string.format("pi-kanban #%s: starting Pi (%s)...", ticket_id, mode), vim.log.levels.INFO)

  -- Build shell-escaped command string
  local escaped = {}
  for _, c in ipairs(cmd) do
    table.insert(escaped, vim.fn.shellescape(c))
  end

  vim.cmd("botright 12split")
  vim.cmd("terminal " .. table.concat(escaped, " "))
  local term_buf = vim.api.nvim_get_current_buf()
  vim.cmd("setlocal nonumber norelativenumber nobuflisted")

  vim.api.nvim_create_autocmd("TermClose", {
    buffer = term_buf,
    once = true,
    callback = function()
      local ticket_buf = vim.fn.bufnr(filepath)
      if ticket_buf > 0 then
        pcall(function()
          vim.api.nvim_buf_call(ticket_buf, function()
            vim.cmd("edit!")
            vim.b._pi_kanban_old_status = get_frontmatter_status(filepath)
          end)
        end)
      end
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(term_buf) then
          local win = vim.fn.bufwinid(term_buf)
          if win >= 0 then pcall(vim.api.nvim_win_close, win, true) end
        end
      end, 3000)
      vim.notify(string.format("pi-kanban #%s: done", ticket_id), vim.log.levels.INFO)
    end,
  })
end

-- ── New ticket ─────────────────────────────────────────────────────

local function new_ticket()
  local proj = find_project()
  if not proj then
    vim.notify("pi-kanban: no project found — open a project board first", vim.log.levels.WARN)
    return
  end

  -- Use project-specific template, fall back to global
  local template = project_template(proj)
  if vim.fn.filereadable(template) == 0 then
    template = GLOBAL_TEMPLATE
  end
  if vim.fn.filereadable(template) == 0 then
    vim.notify("pi-kanban: no template found. Run :PiKanbanNew from a project board first.", vim.log.levels.ERROR)
    return
  end

  local title = vim.fn.input("Ticket title: ")
  if title == "" then
    vim.notify("pi-kanban: cancelled", vim.log.levels.WARN)
    return
  end

  local tdir = tickets_dir(proj)
  vim.fn.mkdir(tdir, "p")

  -- Generate sequential ID
  local max_id = 0
  local handle = vim.loop.fs_scandir(tdir)
  if handle then
    while true do
      local name, _ = vim.loop.fs_scandir_next(handle)
      if not name then break end
      local id_match = name:match("^(%d+)")
      if id_match then
        local n = tonumber(id_match)
        if n and n > max_id then max_id = n end
      end
    end
  end
  local ticket_id = string.format("%03d", max_id + 1)

  local slug = title:lower():gsub("[^%w%s-]", ""):gsub("%s+", "-"):gsub("-+", "-"):match("^%-*(.-)%-*$")
  if slug == "" then slug = "ticket" end
  local filename = string.format("%s-%s.md", ticket_id, slug)
  local filepath = tdir .. "/" .. filename

  local lines = vim.fn.readfile(template)
  local new_lines = {}
  for _, line in ipairs(lines) do
    line = line:gsub("TICKET_ID", ticket_id)
    line = line:gsub("TICKET_TITLE", title)
    line = line:gsub("CREATED_DATE", os.date("%Y-%m-%d"))
    -- Auto-fill repo from project config
    line = line:gsub("REPO_PLACEHOLDER", proj.repo or "")
    table.insert(new_lines, line)
  end

  vim.fn.writefile(new_lines, filepath)
  vim.cmd("edit " .. filepath)
  vim.b._pi_kanban_old_status = "TODO"

  vim.notify(string.format("pi-kanban: created ticket #%s — %s", ticket_id, title), vim.log.levels.INFO)
end

-- ── Delete ticket ──────────────────────────────────────────────────

local function delete_ticket()
  local proj = find_project()
  if not proj then
    vim.notify("pi-kanban: not in a project", vim.log.levels.WARN)
    return
  end

  local file = vim.api.nvim_buf_get_name(0)
  if not file:match("^" .. vim.pesc(tickets_dir(proj)) .. "/.*%.md$") then
    vim.notify("pi-kanban: not a ticket file", vim.log.levels.WARN)
    return
  end

  local fm = parse_frontmatter(file)
  if not fm then
    vim.notify("pi-kanban: cannot parse ticket", vim.log.levels.ERROR)
    return
  end

  local ticket_id = fm.id or "?"
  local title = fm.title or file
  local branch = (fm.branch or ""):match("%S") and fm.branch or nil
  local msg = string.format("Delete ticket #%s — %s?", ticket_id, title)
  if branch then
    msg = msg .. string.format("\nBranch '%s' exists. Also remove worktree + branch?", branch)
  end
  if vim.fn.confirm(msg, "&Yes\n&No", 2) ~= 1 then
    vim.notify("pi-kanban: cancelled", vim.log.levels.WARN)
    return
  end

  local cleanup = {}
  if branch and proj.repo then
    local basename = vim.fn.fnamemodify(file, ":t:r")
    local worktree_path = vim.fn.fnamemodify(proj.repo, ":h") .. "/" .. basename
    if vim.fn.isdirectory(worktree_path) == 1 then
      vim.fn.system({ "git", "-C", proj.repo, "worktree", "remove", worktree_path, "--force" })
      table.insert(cleanup, "worktree removed: " .. worktree_path)
    end
    local branches = vim.fn.systemlist({ "git", "-C", proj.repo, "branch", "--list", branch })
    if #branches > 0 then
      vim.fn.system({ "git", "-C", proj.repo, "branch", "-D", branch })
      table.insert(cleanup, "branch deleted: " .. branch)
    end
  end

  vim.fn.delete(file)
  vim.cmd("bdelete!")

  vim.notify(string.format("pi-kanban: deleted ticket #%s — %s", ticket_id, title), vim.log.levels.INFO)
  if #cleanup > 0 then
    vim.notify("  " .. table.concat(cleanup, " | "), vim.log.levels.INFO)
  end

  -- Refresh board
  if proj then
    local board_buf = vim.fn.bufnr(board_index(proj))
    if board_buf > 0 then open_board(proj) end
  end
end

-- ── Manual trigger ─────────────────────────────────────────────────

local function manual_trigger()
  local proj = find_project()
  if not proj then
    vim.notify("pi-kanban: not in a project", vim.log.levels.WARN)
    return
  end

  local file = vim.api.nvim_buf_get_name(0)
  if not file:match("^" .. vim.pesc(tickets_dir(proj)) .. "/.*%.md$") then
    vim.notify("pi-kanban: not a ticket file", vim.log.levels.WARN)
    return
  end

  local fm = parse_frontmatter(file)
  if not fm then
    vim.notify("pi-kanban: cannot parse ticket", vim.log.levels.ERROR)
    return
  end

  local status = fm.status
  if status == "TODO" then
    M.trigger_work(file, "new")
  elseif status == "IN REVIEW" then
    M.trigger_work(file, "resume")
  else
    M.trigger_work(file, "new")
  end
end

-- ── Public entry point: open projects or focused board ─────────────

local function open_kanban()
  -- If explicitly on a project board buffer, refresh it
  for slug, proj in pairs(PROJECTS) do
    local file = vim.api.nvim_buf_get_name(0)
    if file == board_index(proj) then
      open_board(proj)
      return
    end
  end
  -- Default: open projects hub
  open_projects()
end

-- ── Setup ──────────────────────────────────────────────────────────

function M.setup()
  vim.fn.mkdir(WIKI_ROOT, "p")

  -- Ensure each registered project has its wiki directory + template
  for slug, proj in pairs(PROJECTS) do
    vim.fn.mkdir(project_dir(proj), "p")
    vim.fn.mkdir(tickets_dir(proj), "p")
    -- Copy global template to project if project doesn't have one
    local pt = project_template(proj)
    if vim.fn.filereadable(pt) == 0 and vim.fn.filereadable(GLOBAL_TEMPLATE) == 1 then
      vim.fn.system({ "cp", GLOBAL_TEMPLATE, pt })
    end
  end

  -- Ensure global template exists
  if vim.fn.filereadable(GLOBAL_TEMPLATE) == 0 then
    local tpl = {
      "---",
      "id: TICKET_ID",
      "title: TICKET_TITLE",
      "status: TODO",
      "created: CREATED_DATE",
      "labels: ",
      "project: triplang",
      "repo: REPO_PLACEHOLDER",
      "session-path:   # auto-filled by orchestrator after Pi runs",
      "branch:         # auto-filled by orchestrator after Pi runs",
      "pr-url:         # auto-filled by orchestrator after Pi runs",
      "---",
      "",
      "## Description",
      "",
      "<!-- What needs to be done? -->",
      "",
      "## Acceptance Criteria",
      "",
      "- [ ] ",
      "",
      "## Notes",
      "",
      "<!-- Implementation hints, links, or context -->",
      "",
      "## Review Feedback",
      "",
      "<!-- Filled in when moving IN REVIEW → IN PROGRESS for rework -->",
    }
    vim.fn.writefile(tpl, GLOBAL_TEMPLATE)
  end

  -- Commands
  vim.api.nvim_create_user_command("PiKanban", open_kanban, {})
  vim.api.nvim_create_user_command("PiKanbanNew", new_ticket, {})
  vim.api.nvim_create_user_command("PiKanbanWork", manual_trigger, {})
  vim.api.nvim_create_user_command("PiKanbanDelete", delete_ticket, {})
  vim.api.nvim_create_user_command("PiKanbanLog", function()
    local log = nil
    local file = vim.api.nvim_buf_get_name(0)

    -- If we're on a ticket, use its ID
    local fm = parse_frontmatter(file)
    if fm and fm.id then
      log = "/tmp/tripurr-ticket-" .. fm.id .. ".log"
    else
      -- If on a board, extract ticket ID from line under cursor
      local line = vim.api.nvim_get_current_line()
      local id_match = line:match("%[#(%d+)%]")
      if id_match then
        log = "/tmp/tripurr-ticket-" .. id_match .. ".log"
      end
    end

    if log and vim.fn.filereadable(log) == 1 then
      vim.cmd("botright 12split | view " .. log)
      vim.cmd("normal! G")
    elseif log then
      vim.notify("pi-kanban: no log yet for this ticket (Pi hasn't run)", vim.log.levels.WARN)
    else
      vim.notify("pi-kanban: not on a ticket or board", vim.log.levels.WARN)
    end
  end, {})

  vim.api.nvim_create_user_command("PiKanbanWorktree", function()
    local file = vim.api.nvim_buf_get_name(0)
    local fm = parse_frontmatter(file)
    if not fm or not fm.repo then
      -- Try extracting ticket ID from board line
      local line = vim.api.nvim_get_current_line()
      local id_match = line:match("%[#(%d+)%]")
      if id_match then
        -- Find the ticket file in any project
        for _, proj in pairs(PROJECTS) do
          local tdir = tickets_dir(proj)
          local handle = vim.loop.fs_scandir(tdir)
          if handle then
            while true do
              local name, _ = vim.loop.fs_scandir_next(handle)
              if not name then break end
              if name:match("^" .. id_match .. "%-") then
                file = tdir .. "/" .. name
                fm = parse_frontmatter(file)
                break
              end
            end
          end
          if fm then break end
        end
      end
    end

    if not fm or not fm.repo then
      vim.notify("pi-kanban: no project repo found in ticket", vim.log.levels.WARN)
      return
    end

    local branch = fm.branch and fm.branch:match("%S") and fm.branch
    local worktree = nil

    -- Use git worktree list to find the matching worktree
    if branch and fm.repo then
      local out = vim.fn.systemlist(
        { "git", "-C", fm.repo, "worktree", "list" }
      )
      for _, line in ipairs(out) do
        -- Format: "/path/to/worktree HASH [branch-name]"
        if line:find(vim.pesc("[" .. branch .. "]"), 1, true) then
          worktree = line:match("^(%S+)")
          break
        end
      end
    end

    -- Fallback: scan parent directory for ticket-id-prefixed folders
    if not worktree and fm.repo then
      local parent = vim.fn.fnamemodify(fm.repo, ":h")
      local prefix = (fm.id or "") .. "-"
      local handle = vim.loop.fs_scandir(parent)
      if handle then
        while true do
          local name, _ = vim.loop.fs_scandir_next(handle)
          if not name then break end
          if name:match("^" .. vim.pesc(prefix)) then
            local candidate = parent .. "/" .. name
            if vim.fn.isdirectory(candidate) == 1 then
              worktree = candidate
              break
            end
          end
        end
      end
    end

    if not worktree then
      vim.notify("pi-kanban: worktree not found for this ticket", vim.log.levels.WARN)
      return
    end

    vim.notify(string.format("pi-kanban: branch=%s worktree=%s", branch or "nil", worktree or "nil"), vim.log.levels.INFO)
    vim.cmd("Oil " .. worktree)
  end, {})

  -- Autocmds for status change detection (on ticket writes)
  local group = vim.api.nvim_create_augroup("PiKanban", { clear = true })

  vim.api.nvim_create_autocmd({ "BufRead", "BufWritePre" }, {
    group = group,
    callback = function(args)
      local file = vim.api.nvim_buf_get_name(args.buf)
      for _, proj in pairs(PROJECTS) do
        if file:match("^" .. vim.pesc(tickets_dir(proj)) .. "/.*%.md$") then
          vim.b[args.buf]._pi_kanban_old_status = get_frontmatter_status(file)
          break
        end
      end
    end,
  })

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    callback = on_buf_write_post,
  })

  -- Global keymaps
  vim.keymap.set("n", "<leader>tb", open_kanban, { desc = "pi-kanban: board / projects" })
  vim.keymap.set("n", "<leader>tn", new_ticket, { desc = "pi-kanban: new ticket" })
  vim.keymap.set("n", "<leader>tw", manual_trigger, { desc = "pi-kanban: trigger work" })
  vim.keymap.set("n", "<leader>tl", function()
    vim.cmd("PiKanbanLog")
  end, { desc = "pi-kanban: view log" })
  vim.keymap.set("n", "<leader>td", delete_ticket, { desc = "pi-kanban: delete ticket" })
  vim.keymap.set("n", "<leader>to", function()
    vim.cmd("PiKanbanWorktree")
  end, { desc = "pi-kanban: open worktree" })
end

return M
