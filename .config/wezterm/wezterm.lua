local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Set the color scheme to Catppuccin Macchiato
config.color_scheme = "Catppuccin Macchiato"

-- Use IntoneMono Nerd Font
config.font = wezterm.font("IntoneMono Nerd Font")
config.font_size = 12.0

-- Remove window padding
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- Disable tab bar if you want a cleaner look
config.enable_tab_bar = false

-- Other optional settings you might want to customize
config.window_background_opacity = 1.0
config.window_decorations = "TITLE | RESIZE"
config.enable_scroll_bar = false
config.hide_mouse_cursor_when_typing = true
config.audible_bell = "Disabled"

-- Set the default to wsl ubuntu
default_domain = 'WSL:Ubuntu'

-- Return the configuration
return config