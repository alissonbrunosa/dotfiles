local setmetatable = setmetatable
local awful        = require('awful')
local gears        = require('gears')
local wibox        = require('wibox')
local beautiful    = require('beautiful')

local obj = { mt = {} }

local function fetch_volume(widget)
    awful.spawn.easy_async('pa-cli source get-volume', function(stdout, stderr)
        if stderr ~= '' or not stdout then
            print('Error fetching microphone volume')
            print(stderr)
            return
        end

        local val = tonumber(stdout:match('%d+'))
        if val then
            widget:set_value(val)
        end
    end)
end

local function update_volume(widget, delta)
    local cmd = string.format('pa-cli source adjust-volume %d', delta)
    awful.spawn.easy_async(cmd, function(_, stderr)
        if stderr ~= '' then
            print('Error adjusting microphone volume')
            print(stderr)
            return
        end

        fetch_volume(widget)
    end)
end

local function new(context)
    local widget = require('widget.arcchart')({
        inner_text = 'Microphone',

        colours = function(value)
            if value <= 65 then return { beautiful.full } end
            if value <= 75 then return { beautiful.three_quarter } end
            if value <= 85 then return { beautiful.two_quarter } end
            return { beautiful.one_quarter }
        end,
    })

    widget:buttons(gears.table.join(
        awful.button({}, 4, function() update_volume(widget, 2) end),
        awful.button({}, 5, function() update_volume(widget, -2) end)
    ))

    local function refresh_all()
        fetch_volume(widget)
    end

    if context then
        local signals = {'microphone::changed', 'context::loaded', 'source::changed'}
        for _, sig in ipairs(signals) do
            context:on(sig, refresh_all)
        end
    end

    gears.timer.delayed_call(refresh_all)

    return widget
end

function obj.mt:__call(...)
    return new(...)
end

return setmetatable(obj, obj.mt)
