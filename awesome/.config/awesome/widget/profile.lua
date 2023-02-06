local os          = os
local awful       = require('awful')
local watch       = require('awful.widget.watch')
local wibox       = require('wibox')
local gears       = require('gears')
local gfs         = require('gears.filesystem')
local beautiful   = require('beautiful')
local shape       = require('widget.shape')
local xresources  = require('beautiful.xresources')
local dpi         = xresources.apply_dpi
local hand_cursor = require('widget.hand_cursor')
local ICONS_DIR   = gfs.get_configuration_dir() .. 'assets/profile/'

local create_action = function(icon, onclick)
    local widget = wibox.widget {
        {
            {
                text   = icon,
                font   = beautiful.icon_font('Regular'),
                widget = wibox.widget.textbox
            },
            margins = dpi(10),
            widget  = wibox.container.margin
        },
        bg      = beautiful.bg_normal,
        shape   = shape.rounded_rect,
        widget  = wibox.container.background,
    }

    widget:buttons(
        awful.util.table.join(
            awful.button({}, 1, onclick)
        )
    )

    hand_cursor(widget)
    return widget
end

return function()
    local username = wibox.widget {
        {
            text   = os.getenv('USER'),
            font   = beautiful.font_extra_bold .. ' 17',
            align  = "center",
            valign = "center",
            widget = wibox.widget.textbox,
        },
        fg = beautiful.bg_normal,
        widget = wibox.container.background
    }

    local actions = wibox.widget {
        create_action('', function()
            awful.spawn('systemctl poweroff')
        end),

        create_action('', awesome.quit),

        spacing = dpi(7),
        widget  = wibox.layout.fixed.horizontal
    }

    local background = wibox.widget {
        image = ICONS_DIR .. 'background2.jpg',
        resize = false,
        opacity = 0.75,
        widget = wibox.widget.imagebox,
    }

    local profile_image = wibox.widget {
        image         = ICONS_DIR .. 'profile.png',
        resize        = true,
        valign        = 'center',
        halign        = 'center',
        shape         = shape.rounded_rect,
        forced_width  = dpi(100),
        forced_height = dpi(100),
        widget        = wibox.widget.imagebox,
    }

    return wibox.widget {
        background,
        {
            {
                {
                    {
                        nil,
                        {
                            profile_image,
                            username,
                            widget = wibox.layout.fixed.vertical
                        },
                        nil,
                        expand = 'none',
                        widget = wibox.layout.align.horizontal,
                    },
                    nil,
                    {
                        nil,
                        nil,
                        actions,
                        expand = 'none',
                        widget = wibox.layout.align.horizontal,
                    },
                    expand = 'none',
                    widget = wibox.layout.align.vertical,
                },
                margins = dpi(10),
                widget = wibox.container.margin,
            },
            shape = shape.rounded_rect,
            forced_width = dpi(240),
            forced_height = dpi(195),
            widget = wibox.container.background,
        },
        layout = wibox.layout.stack,
    }
end
