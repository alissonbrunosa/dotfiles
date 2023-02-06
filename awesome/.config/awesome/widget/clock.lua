local os = os
local setmetatable = setmetatable

local gears      = require('gears')
local gtable     = require('gears.table')
local timer      = require('gears.timer')
local wibox      = require('wibox')
local beautiful  = require('beautiful')
local xresources = require('beautiful.xresources')
local dpi        = xresources.apply_dpi

local glib       = require("lgi").GLib
local TimeZone   = glib.TimeZone
local DateTime   = glib.DateTime

local DateTime_new_now = DateTime.new_now

local create_number = function()
    local number = wibox.widget {
        font   = beautiful.font_name .. ' Bold 70',
        widget = wibox.widget.textbox
    }

    return wibox.widget {
        number,
        fg = beautiful.fg_title,
        widget = wibox.container.background,
        update = function(self, value)
            number:set_markup(value)
        end,
    }
end

local calc_timeout = function(real_timeout)
    return real_timeout - os.time() % real_timeout
end

local obj = {  mt = {} }

local new = function()
    local dot = wibox.widget {
        wibox.widget.base.empty_widget(),
        forced_width  = dpi(12),
        forced_height = dpi(12),
        shape         = gears.circle,
        bg            = beautiful.fg_subtitle,
        widget        = wibox.container.background,
    }

    local colon = wibox.widget {
        nil,
        {
            dot,
            dot,
            spacing = dpi(10),
            widget  = wibox.layout.fixed.vertical
        },
        nil,
        expand = 'none',
        widget = wibox.layout.align.vertical,
    }
    local hour   = create_number()
    local minute = create_number()
    local widget  = wibox.widget {
        nil,
        {
            hour,
            colon,
            minute,
            spacing = dpi(5),
            widget  = wibox.layout.fixed.horizontal
        },
        nil,
        expand = 'none',
        widget = wibox.layout.align.horizontal,
    }

    gtable.crush(widget, obj, true)
    widget._private.refresh = function()
        local now = DateTime_new_now(TimeZone.new_local())

        local h = now:format('%H')
        local m = now:format('%M')

        hour:update(h)
        minute:update(m)

        widget._timer.timeout = calc_timeout(60)
        widget._timer:again()

        return true
    end

    widget._timer = timer.weak_start_new(0, widget._private.refresh)

    return widget
end

function obj.mt:__call(...)
    return new(...)
end

return setmetatable(obj, obj.mt)
