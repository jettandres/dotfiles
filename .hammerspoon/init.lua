hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function ()
  hs.notify.new({title="Ola amigo", informativeText="Hello World"}):send()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function ()
  hs.reload()
end)

hs.notify.new({title="Hammerspoon", informativeText="Config loaded"}):send()
