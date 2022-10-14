local hyper = { "cmd", "alt", "ctrl", "shift" }

hs.hotkey.bind(hyper, "R", function()
  hs.reload()
end)

hs.hotkey.bind(hyper, "1", function()
  hs.execute("open https://bit.ly/BkyWebStatus")
end)

hs.hotkey.bind(hyper, "2", function()
  hs.execute("open https://bit.ly/BkyWeb")
end)

hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall:andUse("EmmyLua")

spoon.SpoonInstall:andUse("WindowGrid",
  {
    config = { gridGeometries = { { "6x4" } } },
    hotkeys = { show_grid = { hyper, "g" } },
    start = true,
    disabled = true
  }
)

hs.notify.new({ title = "Hammerspoon", informativeText = "Config loaded" }):send()
