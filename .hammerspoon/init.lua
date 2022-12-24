hyper = { "cmd", "alt", "ctrl", "shift" }

require("BookyBindings")

hs.hotkey.bind(hyper, "R", function()
  hs.reload()
end)

hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall:andUse("EmmyLua")

hs.notify.new({ title = "Hammerspoon", informativeText = "Config loaded" }):send()
