-- ln -s ~/.dotfiles/src/hammerspoon/init.lua ~/.hammerspoon/init.lua

-- Source - https://superuser.com/a/1918149
-- Posted by Ricky Boyce
-- Retrieved 2026-08-03, License - CC BY-SA 4.0

local function sendKey(mods, key)
  local kc = hs.keycodes.map[key]
  if not kc then return end

  hs.eventtap.event.newKeyEvent(mods, kc, true):post() -- KeyDown
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

-- Watch F19 key in Finder
f19tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
  if event:getKeyCode() == hs.keycodes.map["f19"] then
    local element = hs.uielement.focusedElement()
    -- if isAIChatVisible() or (element and element:role() == "AXTextField") then
    if (element and element:role() == "AXTextField") then
      sendKey({}, "return") -- user is renaming → send normal Enter
    else
      sendKey({"cmd"}, "o") -- open selection → send Cmd+O
    end
    return true -- swallow original F19
  end
  return false
end)
f19tap:start()

-- Watch F20 key in Finder
f20tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
  if event:getKeyCode() == hs.keycodes.map["f20"] then
    local element = hs.uielement.focusedElement()
    -- if isAIChatVisible() or (element and element:role() == "AXTextField") then
    if (element and element:role() == "AXTextField") then
      sendKey({}, "delete") -- Delete
    else
      sendKey({"cmd"}, "up") -- Cmd+↑
    end
    return true
  end
  return false
end)
f20tap:start()

