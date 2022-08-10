local hyper = { "cmd", "alt", "ctrl", "shift" }

hs.hotkey.bind(hyper, "W", function()
  hs.notify.new({ title = "Ola amigo", informativeText = "Hello World" }):send()
end)

hs.hotkey.bind(hyper, "R", function()
  hs.reload()
end)

hs.notify.new({ title = "Hammerspoon", informativeText = "Config loaded" }):send()
