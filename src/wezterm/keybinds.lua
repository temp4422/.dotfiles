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

    -- Search
    { key = 'f',          mods = 'CMD',       action = act.Search 'CurrentSelectionOrEmptyString' },
    -- Fix clipboard paste
    { key = 'v',          mods = 'CMD',       action = act.PasteFrom 'Clipboard' },
    -- Copy Mode
    { key = 'c',          mods = 'CMD|SHIFT', action = act.ActivateCopyMode },
    -- New tab in home dir
    { key = "t",          mods = "CMD",       action = wezterm.action.SpawnCommandInNewTab { args = { os.getenv("SHELL"), "-l" }, cwd = os.getenv("HOME") } },
    -- Split pane horizontally
    { key = 'd',          mods = 'CMD|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    -- Close pane
    { key = 'w',          mods = 'CMD',       action = act.CloseCurrentPane { confirm = false } },
    -- Select pane
    { key = 'LeftArrow',  mods = 'CMD|OPT',   action = act.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'CMD|OPT',   action = act.ActivatePaneDirection 'Right' },
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


    -- Scroll buffer
    { key = 'UpArrow',    mods = 'OPT',       action = act.ScrollByLine(-1) },
    { key = 'DownArrow',  mods = 'OPT',       action = act.ScrollByLine(1) },

    { key = 'PageUp',     mods = 'OPT',       action = act.ScrollByPage(-1) },
    { key = 'PageDown',   mods = 'OPT',       action = act.ScrollByPage(1) },

    { key = 'Home',       mods = 'OPT',       action = act.ScrollToTop },
    { key = 'End',        mods = 'OPT',       action = act.ScrollToBottom },

  }

  -- Add my custom keybinds to the config
  for _, keybinding in ipairs(my_custom_keybinds) do
    table.insert(config.keys, keybinding)
  end
  --#endregion

  --#region Copy Mode key table keybinds
  local SHIFT_ON = false

  local copy_mode_keybinds = {
    -- Examples:
    -- { key = 'f', mods = 'CMD',       action = act.Multiple { { CopyMode = 'MoveForwardWord' }, { CopyMode = 'MoveForwardWord' }, } },
    -- { key = 'f', mods = 'CMD',       action = when_shift_on(act.Multiple { { CopyMode = 'MoveForwardWord' }, { CopyMode = 'MoveForwardWord' }, }), },
    -- { key = 'f', mods = 'CMD',       action = act.Multiple { { CopyTo = 'ClipboardAndPrimarySelection' }, set_shift(true), }, },

    -- send multiple commands with delay wezterm.sleep_ms(500)
    -- Timing issue: use action_callback with a short sleep_ms delay to ensure asynchronous GUI/clipboard actions finish before the next action starts.
    -- https://github.com/wezterm/wezterm/discussions/5384
    -- {
    --   key = 'LeftArrow',
    --   mods = 'SHIFT',
    --   action = wezterm.action_callback(function(window, pane)
    --     window:perform_action(act.CopyMode { SetSelectionMode = 'Cell' }, pane)
    --     wezterm.sleep_ms(500)
    --     window:perform_action(act.CopyMode('MoveLeft'), pane)
    --     SHIFT_ON = true
    --   end),
    -- },

    { key = 'c', mods = 'CMD|SHIFT', action = act.CopyMode 'Close' },
    { key = 'c', mods = 'CMD',       action = act.Multiple { { CopyTo = 'ClipboardAndPrimarySelection' }, { CopyMode = 'Close' } } },

    -- shift select by character
    {
      key = 'LeftArrow',
      mods = 'SHIFT',
      action = wezterm.action_callback(function(window, pane)
        if not SHIFT_ON then
          window:perform_action(act.CopyMode { SetSelectionMode = 'Cell' }, pane)
          SHIFT_ON = true
        end
        window:perform_action(act.CopyMode 'MoveLeft', pane)
      end),
    },
    {
      key = 'LeftArrow',
      mods = 'NONE',
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(act.CopyMode('ClearSelectionMode'), pane)
        window:perform_action(act.CopyMode('MoveLeft'), pane)
        SHIFT_ON = false
      end),
    },

    {
      key = 'RightArrow',
      mods = 'SHIFT',
      action = wezterm.action_callback(function(window, pane)
        if not SHIFT_ON then
          window:perform_action(act.CopyMode { SetSelectionMode = 'Cell' }, pane)
          SHIFT_ON = true
        end
        window:perform_action(act.CopyMode 'MoveRight', pane)
      end),
    },
    {
      key = 'RightArrow',
      mods = 'NONE',
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(act.CopyMode('ClearSelectionMode'), pane)
        window:perform_action(act.CopyMode('MoveRight'), pane)
        SHIFT_ON = false
      end),
    },

    {
      key = 'UpArrow',
      mods = 'SHIFT',
      action = wezterm.action_callback(function(window, pane)
        if not SHIFT_ON then
          window:perform_action(act.CopyMode { SetSelectionMode = 'Cell' }, pane)
          SHIFT_ON = true
        end
        window:perform_action(act.CopyMode 'MoveUp', pane)
      end),
    },
    {
      key = 'UpArrow',
      mods = 'NONE',
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(act.CopyMode('ClearSelectionMode'), pane)
        window:perform_action(act.CopyMode('MoveUp'), pane)
        SHIFT_ON = false
      end),
    },

    {
      key = 'DownArrow',
      mods = 'SHIFT',
      action = wezterm.action_callback(function(window, pane)
        if not SHIFT_ON then
          window:perform_action(act.CopyMode { SetSelectionMode = 'Cell' }, pane)
          SHIFT_ON = true
        end
        window:perform_action(act.CopyMode 'MoveDown', pane)
      end),
    },
    {
      key = 'DownArrow',
      mods = 'NONE',
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(act.CopyMode('ClearSelectionMode'), pane)
        window:perform_action(act.CopyMode('MoveDown'), pane)
        SHIFT_ON = false
      end),
    },

    -- shift select by line home/end pageup/pagedown
    {
      key = 'Home',
      mods = 'SHIFT',
      action = wezterm.action_callback(function(window, pane)
        if not SHIFT_ON then
          window:perform_action(act.CopyMode { SetSelectionMode = 'Cell' }, pane)
          SHIFT_ON = true
        end
        window:perform_action(act.CopyMode 'MoveToStartOfLine', pane)
      end),
    },
    {
      key = 'Home',
      mods = 'NONE',
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(act.CopyMode('ClearSelectionMode'), pane)
        window:perform_action(act.CopyMode('MoveToStartOfLine'), pane)
        SHIFT_ON = false
      end),
    },

    {
      key = 'End',
      mods = 'SHIFT',
      action = wezterm.action_callback(function(window, pane)
        if not SHIFT_ON then
          window:perform_action(act.CopyMode { SetSelectionMode = 'Cell' }, pane)
          SHIFT_ON = true
        end
        window:perform_action(act.CopyMode 'MoveToEndOfLineContent', pane)
      end),
    },
    {
      key = 'End',
      mods = 'NONE',
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(act.CopyMode('ClearSelectionMode'), pane)
        window:perform_action(act.CopyMode('MoveToEndOfLineContent'), pane)
        SHIFT_ON = false
      end),
    },

    {
      key = 'PageUp',
      mods = 'SHIFT',
      action = wezterm.action_callback(function(window, pane)
        if not SHIFT_ON then
          window:perform_action(act.CopyMode { SetSelectionMode = 'Cell' }, pane)
          SHIFT_ON = true
        end
        window:perform_action(act.CopyMode 'PageUp', pane)
      end),
    },
    {
      key = 'PageUp',
      mods = 'NONE',
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(act.CopyMode('ClearSelectionMode'), pane)
        window:perform_action(act.CopyMode('PageUp'), pane)
        SHIFT_ON = false
      end),
    },

    {
      key = 'PageDown',
      mods = 'SHIFT',
      action = wezterm.action_callback(function(window, pane)
        if not SHIFT_ON then
          window:perform_action(act.CopyMode { SetSelectionMode = 'Cell' }, pane)
          SHIFT_ON = true
        end
        window:perform_action(act.CopyMode 'PageDown', pane)
      end),
    },
    {
      key = 'PageDown',
      mods = 'NONE',
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(act.CopyMode('ClearSelectionMode'), pane)
        window:perform_action(act.CopyMode('PageDown'), pane)
        SHIFT_ON = false
      end),
    },

    -- shift select by word
    -- WezTerm (and underlying terminal modifier systems) treats the left and right Command (CMD / SUPER) keys on macOS as equivalent
    -- BUT for left/right movement CMD is remaped to OPT in karabiner
    {
      key = 'LeftArrow',
      mods = 'OPT|SHIFT',
      action = wezterm.action_callback(function(window, pane)
        if not SHIFT_ON then
          window:perform_action(act.CopyMode { SetSelectionMode = 'Cell' }, pane)
          SHIFT_ON = true
        end
        window:perform_action(act.CopyMode 'MoveBackwardWord', pane)
      end),
    },
    {
      key = 'LeftArrow',
      mods = 'OPT',
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(act.CopyMode('ClearSelectionMode'), pane)
        window:perform_action(act.CopyMode('MoveBackwardWord'), pane)
        SHIFT_ON = false
      end),
    },

    {
      key = 'RightArrow',
      mods = 'OPT|SHIFT',
      action = wezterm.action_callback(function(window, pane)
        if not SHIFT_ON then
          window:perform_action(act.CopyMode { SetSelectionMode = 'Cell' }, pane)
          SHIFT_ON = true
        end
        window:perform_action(act.CopyMode 'MoveForwardWord', pane)
      end),
    },
    {
      key = 'RightArrow',
      mods = 'OPT',
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(act.CopyMode('ClearSelectionMode'), pane)
        window:perform_action(act.CopyMode('MoveForwardWord'), pane)
        SHIFT_ON = false
      end),
    },

    -- for up/down it still CMD not OPT
    {
      key = 'UpArrow',
      mods = 'CMD|SHIFT',
      action = wezterm.action_callback(function(window, pane)
        if not SHIFT_ON then
          window:perform_action(act.CopyMode { SetSelectionMode = 'Cell' }, pane)
          SHIFT_ON = true
        end
        window:perform_action(act.CopyMode 'MoveToViewportTop', pane)
      end),
    },
    {
      key = 'UpArrow',
      mods = 'CMD',
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(act.CopyMode('ClearSelectionMode'), pane)
        window:perform_action(act.CopyMode('MoveToViewportTop'), pane)
        SHIFT_ON = false
      end),
    },

    {
      key = 'DownArrow',
      mods = 'CMD|SHIFT',
      action = wezterm.action_callback(function(window, pane)
        if not SHIFT_ON then
          window:perform_action(act.CopyMode { SetSelectionMode = 'Cell' }, pane)
          SHIFT_ON = true
        end
        window:perform_action(act.CopyMode 'MoveToViewportBottom', pane)
      end),
    },
    {
      key = 'DownArrow',
      mods = 'CMD',
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(act.CopyMode('ClearSelectionMode'), pane)
        window:perform_action(act.CopyMode('MoveToViewportBottom'), pane)
        SHIFT_ON = false
      end),
    },

    -- shift select to top/bottom of buffer
    {
      key = 'Home',
      mods = 'OPT|SHIFT',
      action = wezterm.action_callback(function(window, pane)
        if not SHIFT_ON then
          window:perform_action(act.CopyMode { SetSelectionMode = 'Cell' }, pane)
          SHIFT_ON = true
        end
        window:perform_action(act.CopyMode 'MoveToScrollbackTop', pane)
      end),
    },
    {
      key = 'End',
      mods = 'OPT|SHIFT',
      action = wezterm.action_callback(function(window, pane)
        if not SHIFT_ON then
          window:perform_action(act.CopyMode { SetSelectionMode = 'Cell' }, pane)
          SHIFT_ON = true
        end
        window:perform_action(act.CopyMode 'MoveToScrollbackBottom', pane)
      end),
    }

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
