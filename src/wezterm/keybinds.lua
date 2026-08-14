local wezterm = require 'wezterm'
local module = {}

function module.apply_to_config(config)
  --#region Make CMD behave like CTRL by default
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
  --#endregion

  --#region Default key table keybinds
  local my_custom_keybinds = {
    -- Fix home/end in karabiner-elements

    -- Below keybinds are commented out because they are already set above with CMD -> CTRL mapping
    -- Interrupt
    -- { key = 'c',          mods = 'CMD',       action = wezterm.action.SendKey { key = 'c', mods = 'CTRL' } },
    -- Select all
    -- { key = 'a',          mods = 'CMD',       action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' } },
    -- Undo
    -- { key = 'z',          mods = 'CMD',       action = wezterm.action.SendKey { key = 'z', mods = 'CTRL' } },
    -- Clear scrollback and viewport
    -- { key = 'k',          mods = 'CMD',       action = wezterm.action.ClearScrollback 'ScrollbackAndViewport' },

    -- Fix clipboard paste
    { key = 'v',          mods = 'CMD',       action = wezterm.action.PasteFrom 'Clipboard' },
    -- Split pane horizontally
    { key = 'd',          mods = 'CMD|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    -- Close pane
    { key = 'w',          mods = 'CMD',       action = wezterm.action.CloseCurrentPane { confirm = true } },
    -- Select pane
    { key = 'LeftArrow',  mods = 'CMD|OPT',   action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'CMD|OPT',   action = wezterm.action.ActivatePaneDirection 'Right' },
    -- Copy Mode
    { key = 'c',          mods = 'CMD|SHIFT', action = wezterm.action.ActivateCopyMode },
    -- Search history
    { key = 'r',          mods = 'CMD|SHIFT', action = wezterm.action.SendKey { key = 'r', mods = 'OPT' } },
    -- Redo
    { key = 'z',          mods = 'CMD|SHIFT', action = wezterm.action.SendKey { key = 'z', mods = 'OPT' } },
    -- action = wezterm.action.SendString("\x1bz")
    -- action = wezterm.action.SendString("\27z")
    -- Alternative send escape sequence "\x1bz" equal to "^[z" and is set in zsh widgets
    -- Meaning: send esc+z or meta+z (OPT or ESCAPE acts as meta key)
    -- https://wezterm.org/config/keys.html#configuring-key-assignments
    -- https://wezterm.org/config/lua/keyassignment/SendString.html


  }

  -- Add my custom keybinds to the config
  for _, keybinding in ipairs(my_custom_keybinds) do
    table.insert(config.keys, keybinding)
  end
  --#endregion

  --#region Copy Mode key table keybinds
  local copy_mode_keybinds = {
    { key = 'c', mods = 'CMD|SHIFT', action = wezterm.action.CopyMode 'Close' },
    { key = 'c', mods = 'CMD',       action = wezterm.action.Multiple { { CopyTo = 'ClipboardAndPrimarySelection' }, { CopyMode = 'Close' } } },
  }

  -- Copy Mode import default_key_tables
  config.key_tables = {
    copy_mode = wezterm.gui.default_key_tables().copy_mode,
  }

  -- Add my custom table keybinds to the config
  for _, keybinding in ipairs(copy_mode_keybinds) do
    table.insert(config.key_tables.copy_mode, keybinding)
  end
  --#endregion
end

return module
