local setmetatable = setmetatable
local awful        = require('awful')
local wibox        = require('wibox')
local watch        = require('awful.widget.watch')
local gtable       = require('gears.table')
local beautiful    = require('beautiful')

local obj = { mt = {} }

local new = function()
    local widget = require('widget.arcchart')({
        inner_text = 'Battery',
        min_value  = 0,
        max_value  = 99,
        colours = function(value)
          if value <= 25 then
            return { beautiful.one_quarter }
          elseif value > 25 and value <= 50 then
            return { beautiful.two_quarter }
          elseif value > 50 and value <= 75 then
            return { beautiful.three_quarter }
          else
            return { beautiful.full }
          end
        end
    })

    local BATTERY_LEVEL_CMD = [[ sh -c 'cat /sys/class/power_supply/BAT0/capacity' ]]

    local update = function(widget, stdout, stderr)
        if stderr ~= '' then
            -- TODO: improve error notification
            return
        end

        stdout = stdout:gsub('%s+', '')
        local value = tonumber(stdout)
        widget:set_value(value)
    end

    watch(BATTERY_LEVEL_CMD, 300, update, widget)

    return widget
end

function obj.mt:__call(...)
    return new(...)
end

return setmetatable(obj, obj.mt)
