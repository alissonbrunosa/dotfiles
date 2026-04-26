local setmetatable = setmetatable
local awful        = require('awful')
local timer        = require('gears.timer')
local beautiful    = require('beautiful')
local wibox        = require('wibox')

local obj = { mt = {} }

local adjust_volume = function(widget, n)
  return function()
    local cmd = string.format('pa-cli sink adjust-volume %d', n)

    awful.spawn(cmd)
    local current_value = widget:get_value()
    widget:set_value(current_value + n)
  end
end

local refresh = function(widget, device)
    local callback
    callback = function()
        awful.spawn.easy_async('pa-cli sink get-volume', function(stdout, stderr)
            if stderr ~= '' then
                print('Error while getting speaker volume')
                print(stderr)
                print('Retrying in 10 secs')
                timer.start_new(10, callback)
                return
            end

            widget:set_value(tonumber(stdout))
        end)
    end

    return callback
end

local new = function(context, device)
    local widget = require('widget.arcchart')({
        inner_text = 'Volume',

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
            awful.button({}, 4, adjust_volume(widget, 2)),
            awful.button({}, 5, adjust_volume(widget, -2))
        )
    )

    local refresh_func = refresh(widget, device)

    context:on('volume::changed', refresh_func)
    context:on('context::loaded', refresh_func)
    context:on('sink::changed', refresh_func)

    return widget
end

function obj.mt:__call(...)
    return new(...)
end

return setmetatable(obj, obj.mt)
