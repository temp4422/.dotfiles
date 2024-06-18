-- hs.hotkey.bind({"cmd"}, "s", function()
--   hs.alert.show("Hello World!")
-- end)

-- cmd + tab window switcher to function like Windows
-- https://apple.stackexchange.com/questions/402787/reuse-cmdtab-for-hammerspoon-application-switcher +  setDefaultFilter{}
switcher = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter{})
function mapCmdTab(event)
    local flags = event:getFlags()
    local chars = event:getCharacters()
    if chars == "\t" and flags:containExactly{'cmd'} then
        switcher:next()
        return true
    elseif chars == string.char(25) and flags:containExactly{'cmd','shift'} then
        switcher:previous()
        return true
    end
end
tapCmdTab = hs.eventtap.new({hs.eventtap.event.types.keyDown}, mapCmdTab)
tapCmdTab:start()