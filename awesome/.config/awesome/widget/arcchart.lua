local setmetatable = setmetatable
local awful        = require('awful')
local wibox        = require('wibox')
local gtable       = require("gears.table")
local beautiful    = require('beautiful')
local xresources   = require('beautiful.xresources')
local dpi          = xresources.apply_dpi

local obj = { mt = {} }

function obj:set_value(value)
    local arc   = self:get_children_by_id('arc')[1]
    local label = arc.label

    if not value or value < 0 then
        value = 0
    end

    if value > arc.max_value then
        value = 100
    end

    self._private.current_value = value
    label.text = value
    arc.colors = self._private.pick_colour(value)
    arc:set_value(value)
end

function obj:get_value()
    return self._private.current_value
end

local new = function(args)
    args = args or {}
    local max_value = args.max_value or 100

    local widget = wibox.widget {
        {
            {
                valign = 'center',
                align  = 'center',
                text   = args.inner_text,
                font   = beautiful.font,
                widget = wibox.widget.textbox,
            },
            {
                {
                    id     = 'label',
                    valign = 'center',
                    align  = 'center',
                    font   = beautiful.font_name .. ' 20',
                    widget = wibox.widget.textbox,
                },
                id            = 'arc',
                max_value     = max_value,
                value         = 0,
                thickness     = 8,
                start_angle   = 4.70,
                rounded_edge  = true,
                bg            = beautiful.sub_text,
                widget        = wibox.container.arcchart,
            },
            spacing = dpi(5),
            layout  = wibox.layout.fixed.vertical,
        },
        margins = dpi(5),
        layout  = wibox.container.margin,
    }

    widget._private.pick_colour = args.colours
    gtable.crush(widget, obj, true)
    return widget
end

function obj.mt:__call(...)
    return new(...)
end

return setmetatable(obj, obj.mt)
