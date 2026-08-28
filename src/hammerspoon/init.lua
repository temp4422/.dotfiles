-- ln -s ~/.dotfiles/src/hammerspoon/init.lua ~/.hammerspoon/init.lua

-- Source - https://superuser.com/a/1918149
-- Posted by Ricky Boyce
-- Retrieved 2026-08-03, License - CC BY-SA 4.0

-- Fix Undefined global `hs`
---@diagnostic disable: undefined-global


local function sendKey(mods, key)
  local kc = hs.keycodes.map[key]
  if not kc then return end

  hs.eventtap.event.newKeyEvent(mods, kc, true):post()  -- KeyDown
  hs.eventtap.event.newKeyEvent(mods, kc, false):post() -- KeyUp
end

-- local function isAIChatVisible()
--   -- local app = hs.application.frontmostApplication() always shows com.apple.finder
--   local window = hs.window.frontmostWindow()
--   local application = window:application()
--   local id = application:bundleID()
--   -- hs.alert.show(id)
--   return id == "com.openai.chat" --or id == "com.raycast.macos"
-- end

-- Can't set F21!? Watch F18 key in Finder. Set in Karabiner: cmd+backspace -> f18 -> Move to Bin
f18tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  if event:getKeyCode() == hs.keycodes.map["f18"] then
    local element = hs.uielement.focusedElement()
    -- if isAIChatVisible() or (element and element:role() == "AXTextField") then
    if (element and element:role() == "AXTextField") then
      -- sendKey({"fn"}, "delete") -- editing → delete character
      -- hs.eventtap.keyStroke({"fn"}, "delete")
      sendKey({}, "forwarddelete") -- Fn isn't a standard modifier key in macOS, can't reliably synthesize Fn+Delete. Send the forward-delete key code directly.
    else
      sendKey({ "cmd" }, "delete") -- not editing → move file to Trash
    end
    return true                    -- swallow original F18
  end
  return false
end)
f18tap:start()

-- Watch F19 key in Finder. Set in karabiner: enter -> f19 -> Open
f19tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  if event:getKeyCode() == hs.keycodes.map["f19"] then
    local element = hs.uielement.focusedElement()
    if (element and element:role() == "AXTextField") then
      sendKey({}, "return")   -- user is renaming → send normal Enter
    else
      sendKey({ "cmd" }, "o") -- open selection → send Cmd+O
    end
    return true
  end
  return false
end)
f19tap:start()

-- Watch F20 key in Finder. Set in karabiner: backspace -> f20 -> Enclosing Folder
f20tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  if event:getKeyCode() == hs.keycodes.map["f20"] then
    local element = hs.uielement.focusedElement()
    if (element and element:role() == "AXTextField") then
      sendKey({}, "delete")    -- Delete
    else
      sendKey({ "cmd" }, "up") -- Cmd+↑
    end
    return true
  end
  return false
end)
f20tap:start()
