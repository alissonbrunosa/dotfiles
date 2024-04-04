---------------------------
---------- Theme ----------
---------------------------

local theme_assets = require('beautiful.theme_assets')
local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi

local gfs = require('gears.filesystem')
local themes_path = gfs.get_themes_dir()
local config_path  = gfs.get_configuration_dir()

local theme = {}

theme.master_width_factor = 0.55

theme.font_name       = 'Iosevka Medium'
theme.font_extra_bold = 'Iosevka Extrabold'
theme.font            = theme.font_name .. ' 9.5'

theme.icon_font  = function(type)
  return 'Font Awesome 6 Free ' .. type .. ' 14'
end

theme.weather_icon_font = 'Weather Icons'

theme.one_quarter   = '#DD6777'
theme.two_quarter   = '#fab387'
theme.three_quarter = '#ECD3A0'
theme.full          = '#90CEAA'

theme.bg_normal     = '#0d0f18'
theme.bg_widget     = '#151720'
theme.background3   = '#313244'
theme.bg_focus      = '#86AAEC'
theme.bg_urgent     = '#F38BA8'
theme.bg_minimize   = '#444444'

theme.fg_title      = '#BD92E5'
theme.fg_subtitle   = '#ecd3a0'
theme.fg_normal     = '#A5B6CF'
theme.sub_text      = '#272B31'
theme.fg_focus      = '#11111B'
theme.fg_urgent     = '#ffffff'
theme.fg_minimize   = '#ffffff'

theme.useless_gap   = dpi(2)
theme.border_width  = dpi(2)
theme.border_normal = '#0d0f18'
theme.border_focus  = '#bd92e5'
theme.border_marked = '#ebcb8b'

theme.taglist_fg          = theme.fg_title
theme.taglist_bg          = theme.bg_widget
theme.taglist_bg_empty    = theme.bg_widget
theme.taglist_bg_volatile = theme.bg_widget
theme.taglist_bg_occupied = theme.bg_widget
theme.taglist_fg_focus    = theme.fg_focus
theme.taglist_bg_focus    = theme.bg_focus
theme.taglist_fg_urgent   = theme.fg_normal
theme.taglist_bg_urgent   = theme.one_quarter

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = '#ff0000'

-- Generate taglist squares:
-- local taglist_square_size = dpi(4)
-- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
--     taglist_square_size, theme.fg_normal
-- )
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
--     taglist_square_size, theme.fg_normal
-- )

-- Variables set for theming notifications:
theme.notification_bg = theme.bg_normal
theme.notification_fg = theme.fg_normal
theme.notification_font = theme.font
theme.notification_height = dpi(75)
theme.notification_max_width = dpi(300)
theme.notification_border_color = '#88c0d0'
theme.notification_icon_size = dpi(64)

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path..'default/submenu.png'
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

theme.wallpaper = config_path .. 'assets/wallpaper.jpg'

return theme
