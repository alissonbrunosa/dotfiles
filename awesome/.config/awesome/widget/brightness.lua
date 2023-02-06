local setmetatable = setmetatable
local gtable       = require('gears.table')
local awful        = require('awful')
local beautiful    = require('beautiful')
local wibox        = require('wibox')

local obj = { mt = {} }

local up = function(widget)
    return function()
      awful.spawn('light -A 5')
      local current_value = widget:get_value()
      widget:set_value(current_value + 5)
    end
end

function obj:refresh()
    awful.spawn.easy_async('light -G', function(stdout)
        local value = tonumber(stdout)
        value = math.floor(value)
        self:set_value(value)
    end)
end

local down = function(widget)
    return function()
      awful.spawn('light -U 5')
      local current_value = widget:get_value()
      widget:set_value(current_value - 5)
    end
end

local new = function(context)
    local widget = require('widget.arcchart')({
        inner_text = 'Brightness',

        colours = function(value)
            if value <= 65 then
                return { beautiful.full }
            elseif value > 65 and value <= 75 then
                return { beautiful.three_quarter }
            elseif value > 75 and value <= 85 then
                return { beautiful.two_quarter }
            else
                return { beautiful.one_quarter }
            end
        end,
    })

    widget:buttons(
        awful.util.table.join(
            awful.button({}, 4, up(widget)),
            awful.button({}, 5, down(widget))
        )
    )

    gtable.crush(widget, obj, true)
    local fun = function(value)
        widget:refresh()
    end

    context:on('brightness::changed', fun)
    context:on('context::loaded', fun)

    return widget
end

function obj.mt:__call(...)
    return new(...)
end

return setmetatable(obj, obj.mt)
