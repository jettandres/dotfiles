local hyper = { "cmd", "alt", "ctrl", "shift" }

hs.hotkey.bind(hyper, "W", function()
  hs.notify.new({ title = "Ola amigo", informativeText = "Hello World" }):send()
end)

hs.hotkey.bind(hyper, "R", function()
  hs.reload()
end)

hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall:andUse("WindowGrid",
  {
    config = { gridGeometries = { { "6x4" } } },
    hotkeys = { show_grid = { hyper, "g" } },
    start = true,
    disabled = true
  }
)

hs.notify.new({ title = "Hammerspoon", informativeText = "Config loaded" }):send()
