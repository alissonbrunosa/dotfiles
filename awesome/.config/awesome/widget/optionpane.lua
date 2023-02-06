local awful      = require('awful')
local wibox      = require('wibox')
local beautiful  = require('beautiful')
local xresources = require('beautiful.xresources')
local dpi        = xresources.apply_dpi

local obj = { mt = {} }

local create_button = function(text, colour)
    return wibox.widget {
        {
            {
                text = text,
                align = 'center',
                widget = wibox.widget.textbox,
            },
            left = dpi(20),
            right = dpi(20),
            top = dpi(10),
            bottom = dpi(10),
            widget = wibox.container.margin,
        },
        id = text,
        bg = colour,
        widget = wibox.container.background,
    }
end

local create_title = function(title)
    return wibox.widget {
        {
            {
                text   = title,
                font   = beautiful.font_name .. ' 16',
                align  = 'center',
                widget = wibox.widget.textbox,
            },
            top = dpi(10),
            bottom = dpi(10),
            widget = wibox.container.margin,
        },
        fg     = beautiful.fg_title,
        forced_height = dpi(10),
        widget = wibox.container.background,
    }
end

local create_body = function(body)
    return wibox.widget {
        {
            id     = 'body',
            text   = body,
            font   = beautiful.font_name .. ' 10',
            align  = 'center',
            widget = wibox.widget.textbox,
        },
        bg     = beautiful.bg_widget,
        widget = wibox.container.background,
    }
end

local new = function(args)
    local args = args or {}
    local title = args.title or 'This is a Option Pane'
    local body  = args.title or 'Use body arg to add text to this section'

    local pane = wibox.widget {
        {
            create_title(title),
            create_body(body),
            {
                {
                    nil,
                    {
                        create_button('Yes', beautiful.bg_urgent),
                        create_button('No', beautiful.background3),
                        spacing = dpi(10),
                        forced_height = dpi(100),
                        widget = wibox.layout.fixed.horizontal,
                    },
                    nil,
                    expand = 'none',
                    widget = wibox.layout.align.horizontal,
                },
                margins = dpi(10),
                widget  = wibox.container.margin,
            },
            widget = wibox.layout.flex.vertical,
        },
        forced_width = dpi(300),
        widget = wibox.container.background,
    }

    local dialog = awful.popup {
        widget = pane,
        ontop = true,
        minimum_width = dpi(450),
        border_width = 1,
        border_color = beautiful.bg_focus,
        screen = awful.screen.focused(),
        placement = function(c)
            awful.placement.centered(c, { honor_workarea = true })
        end,
    }

    return dialog
end

function obj.mt:__call(...)
    return new(...)
end

return setmetatable(obj, obj.mt)

