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

theme.master_width_factor = 0.5

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

theme.useless_gap   = dpi(10)
theme.border_width  = dpi(4)
theme.border_normal = '#6C7086'
theme.border_focus  = '#CBA6F7'
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

--theme.wallpaper = config_path .. 'assets/wallpaper.png'
--theme.wallpaper = themes_path .. 'default/background.png'
theme.wallpaper = config_path .. 'assets/ship.jpg'

return theme
