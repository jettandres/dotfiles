bky = hs.hotkey.modal.new(hyper, "b")

function bky:entered()
  hs.notify.new({ title = "Booky Pull Requests",
    informativeText = "1 - OP\n2 - CMS\n3 - MA"
  }):send()
end

function bky:exited()
  hs.notify.new({ title = "Booky Shortcuts Exited" }):send()
end

bky:bind("", "escape", function()
  bky:exit()
end)

bky:bind("", "1", function()
  hs.execute("open https://github.com/scrambledeggs/booky-merchant/pulls")
  bky:exit()
end)

bky:bind("", "2", function()
  hs.execute("open https://github.com/scrambledeggs/booky-merchant-dash/pulls")
  bky:exit()
end)

bky:bind("", "3", function()
  hs.execute("open https://github.com/scrambledeggs/booky-merchant-app/pulls")
  bky:exit()
end)
