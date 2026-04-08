local awful      = require('awful')
local wibox      = require('wibox')
local beautiful  = require('beautiful')
local xresources = require('beautiful.xresources')
local dpi        = xresources.apply_dpi

local obj = { mt = {} }

local create_row = function(device, context)
    local row = wibox.widget {
        {
            {
                text = device.name,
                align = 'left',
                font   = beautiful.font_extra_bold .. ' 12',
                widget = wibox.widget.textbox
            },
            margins = 10,
            layout = wibox.container.margin
        },
        bg = beautiful.bg_normal,
        widget = wibox.container.background
    }

    row:connect_signal("mouse::enter", function(c)
        c:set_fg(beautiful.fg_focus)
        c:set_bg(beautiful.bg_focus)
    end)

    row:connect_signal("mouse::leave", function(c)
        c:set_fg(beautiful.fg_normal)
        c:set_bg(beautiful.bg_normal)
    end)

    local old_cursor, old_wibox
    row:connect_signal("mouse::enter", function()
        local wb = mouse.current_wibox
        old_cursor, old_wibox = wb.cursor, wb
        wb.cursor = "hand1"
    end)
    row:connect_signal("mouse::leave", function()
        if old_wibox then
            old_wibox.cursor = old_cursor
            old_wibox = nil
        end
    end)

    row:connect_signal("button::press", function()
        context:emit('sink:select', device)
    end)

    return row
end

local create_body = function(body)
    return wibox.widget {
        body,
        bg     = beautiful.bg_widget,
        widget = wibox.container.background,
    }
end

local new = function(context)
    local rows = { layout = wibox.layout.fixed.vertical }
    table.insert(rows, create_row({ name = 'Navi 31 HDMI/DP Audio Digital Stereo (HDMI 2)' }, context))
    table.insert(rows, create_row({ name = 'RØDE PodMic USB Analog Stereo' }, context))

    local pane = wibox.widget {
        create_body(rows),
        minimum_width = dpi(300),
        widget = wibox.container.background,
    }

    local dialog = awful.popup {
        widget        = pane,
        ontop         = true,
        visible       = false,
        minimum_width = dpi(450),
        border_width  = 1,
        border_color  = beautiful.bg_focus,
        screen        = awful.screen.focused(),
        placement     = function(c)
            awful.placement.centered(c, { honor_workarea = true })
        end,
    }

    function pane:toggle()
        if dialog.visible then
            dialog.visible = not dialog.visible
        else
            dialog.visible = true
        end
    end

    context:on('sink:select', function(device)
        dialog.visible = false
    end)

    return pane
end

function obj.mt:__call(...)
    return new(...)
end

return setmetatable(obj, obj.mt)

