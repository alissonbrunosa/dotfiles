local awful      = require('awful')
local watch      = require('awful.widget.watch')
local wibox      = require('wibox')
local gears      = require('gears')
local gfs        = require('gears.filesystem')
local beautiful  = require('beautiful')
local xresources = require('beautiful.xresources')
local dpi        = xresources.apply_dpi

local shape       = require('widget.shape')
local hand_cursor = require('widget.hand_cursor')
local clock       = require('widget.clock')
local battery     = require('widget.battery')
local profile     = require('widget.profile')
local calendar    = require('widget.calendar')
local volume      = require('widget.volume')
local microphone  = require('widget.microphone')
local brightness  = require('widget.brightness')
local settings    = require('widget.quicksettings')
local weather     = require('widget.weather')

local create_left_column = function(context)
    return {
        {
            clock(),
            widget  = wibox.container.background,
            bg      = beautiful.bg_widget,
            shape   = shape.rounded_rect,
        },
        {
            {
                calendar(context),
                margins = dpi(10),
                widget  = wibox.container.margin,
            },
            widget  = wibox.container.background,
            bg      = beautiful.bg_widget,
            shape   = shape.rounded_rect,
        },
        {
            {
                weather(context),
                margins = dpi(10),
                widget  = wibox.container.margin,
            },
            shape   = shape.rounded_rect,
            widget  = wibox.container.background,
            bg      = beautiful.bg_widget,
        },
        spacing      = dpi(10),
        forced_width = dpi(320),
        widget       = wibox.layout.fixed.vertical
    }
end

local system_box = function(widget)
    return wibox.widget {
        widget,
        bg            = beautiful.bg_widget,
        shape         = shape.rounded_rect,
        forced_width  = dpi(120),
        forced_height = dpi(120),
        widget        = wibox.container.background,
    }
end

local create_right_column = function(context)
    return {
        profile(),
        {
            system_box(battery()),
            system_box(brightness(context)),
            system_box(volume(context)),
            system_box(microphone(context)),
            expand          = true,
            homogeneous     = true,
            spacing         = dpi(10),
            forced_num_cols = 2,
            forced_num_rows = 2,
            widget = wibox.layout.grid
        },
        {
            {
                settings(context),
                margins = dpi(10),
                widget = wibox.container.margin,
            },
            shape   = shape.rounded_rect,
            widget  = wibox.container.background,
            bg      = beautiful.bg_widget,
        },
        forced_width = dpi(260),
        spacing      = dpi(10),
        widget       = wibox.layout.fixed.vertical
    }
end


local create_panel = function(context)
    return wibox.widget {
        {
            {
                create_left_column(context),
                create_right_column(context),
                spacing = dpi(10),
                widget = wibox.layout.fixed.horizontal
            },
            margins = dpi(10),
            widget  = wibox.container.margin,
        },
        widget = wibox.container.background,
    }
end

local function worker(context)
    local popup = awful.popup {
        ontop        = true,
        visible      = false,
        border_width = dpi(1),
        shape        = shape.rounded_rect,
        offset       = { y = dpi(5) },
        widget       = create_panel(context),
    }

    local home_widget = wibox.widget {
        {
            {
                id     = 'icon',
                text   = '',
                font   = beautiful.icon_font('Regular'),
                widget = wibox.widget.textbox,
            },
            margins = dpi(2),
            widget  = wibox.container.margin
        },
        forced_width = dpi(30),
        widget = wibox.container.background,
    }

    function home_widget:toggle()
        if popup.visible then
            context:emit('calendar:reset')
            popup.visible = not popup.visible
        else
            if mouse.current_widget_geometry then
                popup:move_next_to(mouse.current_widget_geometry)
            else
                awful.placement.centered(popup, { honor_workarea = true })
                popup.visible = true
            end
        end
    end

    hand_cursor(home_widget)
    home_widget:buttons(
        awful.util.table.join(
            awful.button({}, 1, home_widget.toggle)
        )
    )

    return home_widget
end

return worker
