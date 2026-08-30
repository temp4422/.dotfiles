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

-- Disable window title bar but enable the resizable border
config.window_decorations = "RESIZE"

-- Set tab title to directory, or "ssh <username>" when connected via SSH
function tab_title(tab_info)
  local pane = tab_info.active_pane

  -- Detect SSH
  if pane.foreground_process_name then
    local process = pane.foreground_process_name:match('([^/]+)$')

    if process == 'ssh' then
      local title = pane.title
      local username = title:match('^([^@]+)@')

      if username then
        return 'ssh ' .. username
      end

      return 'ssh'
    end
  end

  -- Default: current working directory
  local cwd = pane.current_working_dir

  if cwd and cwd.file_path then
    return cwd.file_path:match('([^/]+)/?$') or cwd.file_path
  end

  return pane.title
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab_title(tab)

  return {
    { Text = ' ' .. title .. ' ' }
  }
end)

-- Disable quit prompt
config.window_close_confirmation = 'NeverPrompt'

-- Keybinds
-- Set the Global Preference to Physical keybinds; Fix input/layout-independent keybinds
config.key_map_preference = 'Physical'
-- Set keybinds in keybinds.lua
local keybinds = require 'keybinds'
keybinds.apply_to_config(config)

-- Plugins
-- AI plugin
local ai_helper = wezterm.plugin.require 'https://github.com/Michal1993r/ai-helper.wezterm.git'
ai_helper.apply_to_config(config, {
  -- type = "ollama",
  -- api_url = "/usr/local/bin/ollama",
  type = "http",
  api_url = "http://localhost:11434/v1/chat/completions",
  model = "llama3.1:8b",
  system_prompt = [[
    You are a CLI and macOS assistant.

    Answer directly and concisely.
    For simple questions, give only the answer.

    Return ONLY valid JSON with exactly two fields:

    {
      "message": "short explanation",
      "command": "shell command or empty string"
    }

    Do not use Markdown.
    Do not use code fences.
    The command must be directly executable.
    ]],
})

-- Return configuration to wezterm
return config
