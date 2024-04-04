local setmetatable = setmetatable
local awful        = require('awful')
local timer        = require('gears.timer')
local beautiful    = require('beautiful')
local wibox        = require('wibox')

local obj = { mt = {} }

local update = function(widget, n)
  return function()
    local cmd = string.format('pa-cli source adjust-volume %d', n)

    awful.spawn(cmd)
    local current_value = widget:get_value()
    widget:set_value(current_value + n)
  end
end

local refresh = function(widget)
    local callback
    callback = function()
        awful.spawn.easy_async('pa-cli source get-volume', function(stdout, stderr)
            if stderr ~= '' then
                print('Error while getting microphone volume')
                print('Retrying in 15 secs')
                timer.start_new(15, callback)
                return
            end

            widget:set_value(tonumber(stdout))
        end)
    end

    return callback
end

local new = function(context)
    local widget = require('widget.arcchart')({
        inner_text = 'Microphone',

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
            awful.button({}, 4, update(widget, 2)),
            awful.button({}, 5, update(widget, -2))
        )
    )

    context:on('microphone::changed', refresh(widget))
    context:on('context::loaded', refresh(widget))

    return widget
end

function obj.mt:__call(...)
    return new(...)
end

return setmetatable(obj, obj.mt)
