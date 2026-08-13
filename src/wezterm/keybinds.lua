local wezterm = require 'wezterm'

local module = {}

function module.apply_to_config(config)
  -- Make CMD behave like CTRL by default
  config.keys = {}
  local alphabet = 'abcdefghijklmnopqrstuvwxyz'
  for i = 1, #alphabet do
    local char = string.sub(alphabet, i, i)
    table.insert(config.keys, {
      key = char,
      mods = 'CMD',
      action = wezterm.action.SendKey { key = char, mods = 'CTRL' },
    })
    table.insert(config.keys, {
      key = char,
      mods = 'CMD|SHIFT',
      action = wezterm.action.SendKey { key = char, mods = 'CTRL|SHIFT' },
    })
  end

  -- Set my custom keybinds
  local my_custom_keys = {
    -- Below keybinds are commented out because they are already set above with CMD -> CTRL mapping
    -- Interrupt
    -- { key = 'c',          mods = 'CMD',       action = wezterm.action.SendKey { key = 'c', mods = 'CTRL' } },
    -- Select all
    -- { key = 'a',          mods = 'CMD',       action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' } },
    -- Undo
    -- { key = 'z',          mods = 'CMD',       action = wezterm.action.SendKey { key = 'z', mods = 'CTRL' } },
    -- Clear scrollback and viewport
    -- { key = 'k',          mods = 'CMD',       action = wezterm.action.ClearScrollback 'ScrollbackAndViewport' },

    -- Split pane horizontally
    { key = 'd',          mods = 'CMD|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    -- Close pane
    { key = 'w',          mods = 'CMD',       action = wezterm.action.CloseCurrentPane { confirm = true } },
    -- Select pane
    { key = 'LeftArrow',  mods = 'CMD|OPT',   action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'CMD|OPT',   action = wezterm.action.ActivatePaneDirection 'Right' },

    -- Redo
    { key = 'z',          mods = 'CMD|SHIFT', action = wezterm.action.SendKey { key = 'z', mods = 'OPT' } },
    -- action = wezterm.action.SendString("\x1bz")
    -- Alternative send escape sequence "\x1bz" equal to "^[z" and is set in zsh widgets
    -- Meaning: send esc+z or meta+z (OPT or ESCAPE acts as meta key)
    -- https://wezterm.org/config/keys.html#configuring-key-assignments
    -- https://wezterm.org/config/lua/keyassignment/SendString.html


    --TODO
    -- Move to beginning/end of line
    -- { key = 'LeftArrow',  mods = 'OPT',       action = wezterm.action.SendString("\x1b[H") },
    -- { key = 'LeftArrow',  mods = 'OPT',       action = wezterm.action.SendString("\27[H") },
  }

  -- Add my custom keybinds to the config
  for _, keybinding in ipairs(my_custom_keys) do
    table.insert(config.keys, keybinding)
  end
end

return module
