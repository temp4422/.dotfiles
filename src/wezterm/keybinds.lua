local wezterm = require 'wezterm'
local act = wezterm.action
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
      action = act.SendKey { key = char, mods = 'CTRL' },
    })
    table.insert(config.keys, {
      key = char,
      mods = 'CMD|SHIFT',
      action = act.SendKey { key = char, mods = 'CTRL|SHIFT' },
    })
  end
  --#endregion

  --#region Default key table keybinds
  local my_custom_keybinds = {
    -- Fix home/end in karabiner-elements

    -- Below keybinds are commented out because they are already set above with CMD -> CTRL mapping
    -- Interrupt
    -- { key = 'c',          mods = 'CMD',       action = act.SendKey { key = 'c', mods = 'CTRL' } },
    -- Select all
    -- { key = 'a',          mods = 'CMD',       action = act.SendKey { key = 'a', mods = 'CTRL' } },
    -- Undo
    -- { key = 'z',          mods = 'CMD',       action = act.SendKey { key = 'z', mods = 'CTRL' } },
    -- Clear scrollback and viewport
    -- { key = 'k',          mods = 'CMD',       action = act.ClearScrollback 'ScrollbackAndViewport' },

    -- Fix clipboard paste
    { key = 'v',          mods = 'CMD',       action = act.PasteFrom 'Clipboard' },
    -- Split pane horizontally
    { key = 'd',          mods = 'CMD|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    -- Close pane
    { key = 'w',          mods = 'CMD',       action = act.CloseCurrentPane { confirm = true } },
    -- Select pane
    { key = 'LeftArrow',  mods = 'CMD|OPT',   action = act.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'CMD|OPT',   action = act.ActivatePaneDirection 'Right' },
    -- Copy Mode
    { key = 'c',          mods = 'CMD|SHIFT', action = act.ActivateCopyMode },
    -- Search history
    { key = 'r',          mods = 'CMD|SHIFT', action = act.SendKey { key = 'r', mods = 'OPT' } },
    -- Redo
    { key = 'z',          mods = 'CMD|SHIFT', action = act.SendKey { key = 'z', mods = 'OPT' } },
    -- action = act.SendString("\x1bz")
    -- action = act.SendString("\27z")
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
  -- local shift_on = false

  -- local function set_shift(value)
  --   return act_callback(function(window, pane)
  --     shift_on = value
  --   end)
  -- end

  -- local function when_shift_on(action)
  --   return act_callback(function(window, pane)
  --     if shift_on then
  --       window:perform_action(action, pane)
  --     end
  --   end)
  -- end


  local copy_mode_keybinds = {
    { key = 'c', mods = 'CMD|SHIFT', action = act.CopyMode 'Close' },
    { key = 'c', mods = 'CMD',       action = act.Multiple { { CopyTo = 'ClipboardAndPrimarySelection' }, { CopyMode = 'Close' } } },
    -- { key = 'f', mods = 'CMD',       action = act.Multiple { { CopyMode = 'MoveForwardWord' }, { CopyMode = 'MoveForwardWord' }, } },
    -- { key = 'f', mods = 'CMD',       action = when_shift_on(act.Multiple { { CopyMode = 'MoveForwardWord' }, { CopyMode = 'MoveForwardWord' }, }), },
    -- { key = 's', mods = 'CMD',       action = act.Multiple { { CopyTo = 'ClipboardAndPrimarySelection' }, set_shift(true), }, },

    -- { key = 'LeftArrow', mods = 'SHIFT',     action = act.Multiple { { CopyMode = 'MoveForwardWord' }, { CopyMode = 'MoveForwardWord' }, } },
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
