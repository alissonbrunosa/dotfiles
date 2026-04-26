local wezterm = require('wezterm')

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
-- config.font = wezterm.font 'Fira Code'
config.font = wezterm.font 'Rec Mono Duotone'

config.font_size = 23
config.default_cursor_style = 'BlinkingBlock'
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 6,
  right = 0,
  top = 0,
  bottom = 0,
}

local act = wezterm.action
config.leader = { mods = 'CTRL', key = 'Space', timeout_milliseconds = 1000 }
config.keys = {
  -- Send C-a when pressing C-a twice
  { mods = "LEADER", key = "c", action = act.ActivateCopyMode },
  { mods = "LEADER", key = "v", action = act.SplitVertical{ domain = "CurrentPaneDomain" } },
  { mods = "LEADER", key = "h", action = act.SplitHorizontal{ domain = "CurrentPaneDomain" } },
  { mods = "LEADER", key = "q", action = act.CloseCurrentPane{ confirm = true } },
  { mods = "SUPER",  key = "n", action = act.DisableDefaultAssignment },
}

config.color_scheme = 'Catppuccin Latte'

return config
