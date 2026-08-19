-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration
local config = wezterm.config_builder()

-- Color scheme
-- Abernathy, Afterglow, Andromeda, Apple System Colors, Apprentice (Gogh), Arthur, Ashes (base16), Atom, ayu, Breath Silverfox (Gogh), Brewer (base16)
config.color_scheme = 'Brewer (base16)'

-- New windows geometry
config.initial_cols = 212
config.initial_rows = 24

-- Font
config.font_size = 13

-- Window position on startup
wezterm.on('gui-startup', function()
  local tab, pane, window = wezterm.mux.spawn_window {
    position = {
      x = 0,
      y = 1020,
    }
  }
end)

-- Cursor styles
config.default_cursor_style = 'BlinkingBar'
config.cursor_thickness = '3px'
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- Pane styles
-- Dim and desaturate inactive panes
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.2,
}

-- Enable scroll bar
config.enable_scroll_bar = true

-- Allow Option key to compose symbols
config.send_composed_key_when_left_alt_is_pressed = true

-- Keybinds
local keybinds = require 'keybinds'
keybinds.apply_to_config(config)

-- Plugins
-- AI plugin
-- Work, but got JSON parsing error inside plugin itself, need to be fixed.
local ai_helper = wezterm.plugin.require 'https://github.com/Michal1993r/ai-helper.wezterm.git'
ai_helper.apply_to_config(config, {
  type = "ollama",
  ollama_path = "/usr/local/bin/ollama",
  model = "gemma4:e4b",
})

-- Return configuration to wezterm
return config
