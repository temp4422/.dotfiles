local wezterm = require 'wezterm'

local module = {}

function module.apply_to_config(config)
  -- Set my custom keybinds
  config.keys = {
    -- Interrupt
    { key = 'c',          mods = 'CMD',       action = wezterm.action.SendKey { key = 'c', mods = 'CTRL' } },
    -- Split pane horizontally
    { key = 'd',          mods = 'CMD|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    -- Close pane
    { key = 'w',          mods = 'CMD',       action = wezterm.action.CloseCurrentPane { confirm = true } },
    -- Select pane
    { key = 'LeftArrow',  mods = 'CMD|OPT',   action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'CMD|OPT',   action = wezterm.action.ActivatePaneDirection 'Right' },
    -- Clear scrollback and viewport
    { key = 'k',          mods = 'CMD',       action = wezterm.action.ClearScrollback 'ScrollbackAndViewport' },

    -- Undo
    { key = 'z',          mods = 'CMD',       action = wezterm.action.SendKey { key = 'z', mods = 'CTRL' } },
    -- Redo
    { key = 'z',          mods = 'CMD|SHIFT', action = wezterm.action.SendKey { key = 'z', mods = 'OPT' } },
    -- action = wezterm.action.SendString("\x1bz")
    -- Alternative send escape sequence "\x1bz" equal to "^[z" and is set in zsh widgets
    -- Meaning: send esc+z or meta+z (OPT or ESCAPE acts as meta key)
    -- https://wezterm.org/config/keys.html#configuring-key-assignments
    -- https://wezterm.org/config/lua/keyassignment/SendString.html

    -- Select all
    { key = 'a',          mods = 'CMD',       action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' } },

    -- Move to beginning/end of line
    -- { key = 'LeftArrow',  mods = 'OPT',       action = wezterm.action.SendString("\x1b[H") },
    -- { key = 'LeftArrow',  mods = 'OPT',       action = wezterm.action.SendString("\27[H") },
  }
end

return module
