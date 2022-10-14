bky = hs.hotkey.modal.new(hyper, "b")

function bky:entered()
  hs.notify.new({ title = "Booky Shortcuts",
    informativeText = "1 - mktp standup notes \n2 - mktp standup call \n3 - mktp jira web \n4 - mktp jira app"
  }):send()
end

function bky:exited()
  hs.notify.new({ title = "Booky Shortcuts Exited" }):send()
end

bky:bind("", "escape", function()
  bky:exit()
end)

bky:bind("", "1", function()
  hs.execute("open https://bit.ly/BkyWebStatus")
  bky:exit()
end)

bky:bind("", "2", function()
  hs.execute("open https://bit.ly/BkyWeb")
  bky:exit()
end)

bky:bind("", "3", function()
  hs.execute("open https://bit.ly/3CTksMK")
  bky:exit()
end)

bky:bind("", "4", function()
  hs.execute("open https://bit.ly/3yEIYhU")
  bky:exit()
end)
