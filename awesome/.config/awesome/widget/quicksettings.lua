local awful       = require('awful')
local wibox       = require('wibox')
local beautiful   = require('beautiful')
local xresources  = require('beautiful.xresources')
local dpi         = xresources.apply_dpi
local gears       = require('gears')
local timer       = require('gears.timer')
local gfs         = require('gears.filesystem')
local hand_cursor = require('widget.hand_cursor')
local json        = require("json")

local function worker(context)
    local configure_layout = function(layout)
        return function()
            local s = awful.screen.focused()
            local tag = s.selected_tag

            awful.layout.set(layout, tag)
        end
    end

    local create_update_func = function(layout, widget)
        return function(t)
            if awful.layout.get(t.screen) == layout then
                widget:on()
            else
                widget:off()
            end
        end
    end

    local items = {
        {
            icon    = '',
            font    = beautiful.icon_font('Regular'),
            command = function()
                awful.spawn.spawn('xdg-screensaver lock')
            end,
        },
        {
            icon    = '',
            font    = beautiful.icon_font('Regular'),
            command = configure_layout(awful.layout.suit.max),

            init_listeners = function(widget)
                local update = create_update_func(awful.layout.suit.max, widget)
                tag.connect_signal('property::selected', update)
                tag.connect_signal('property::layout', update)
            end
        },
        {
            icon    = '',
            font    = beautiful.icon_font('Regular'),
            command = configure_layout(awful.layout.suit.tile.left),

            init_listeners = function(widget)
                local update = create_update_func(awful.layout.suit.tile.left, widget)
                tag.connect_signal('property::selected', update)
                tag.connect_signal('property::layout', update)
            end
        },
        {
            icon    = '',
            font    = beautiful.icon_font('Regular'),
            command = configure_layout(awful.layout.suit.floating),

            init_listeners = function(widget)
                local update = create_update_func(awful.layout.suit.floating, widget)
                tag.connect_signal('property::selected', update)
                tag.connect_signal('property::layout', update)
            end
        },
        {
            icon    = '',
            font    = beautiful.icon_font('Regular'),

            init_listeners = function(widget)
                awful.spawn.easy_async_with_shell("rfkill -J", function(stdout, stderr)
                    if stderr ~= '' then
                        return
                    end

                    stdout = json.decode(stdout)
                    local enabled = true

                    for _, device in ipairs(stdout.rfkilldevices) do
                        if device.soft == 'unblocked' then
                            enabled = false
                            break
                        end
                    end

                    if enabled then
                        widget:on()
                    else
                        widget:off()
                    end
                end)
            end,

            command = function(widget)
                awful.spawn('rfkill toggle all')

                if widget:is_on() then
                    widget:off()
                else
                    widget:on()
                end
            end,
        },
        {
            icon    = '',
            font    = beautiful.icon_font('Regular'),

            command = function(widget)
                local powered = widget:is_on()
                local value   = powered and 'off' or 'on'

                awful.spawn('bluetoothctl power ' ..  value)

                if powered then
                    widget:off()
                else
                    widget:on()
                end
            end,

            async_update = function(widget)
                awful.spawn.easy_async_with_shell("bluetoothctl show | rg Powered | awk '{print $2}'", function(stdout)
                    stdout = stdout:gsub('%s+', '')
                    if stdout == 'yes' then
                        widget:on()
                    else
                        widget:off()
                    end
                end)
            end,
        },
        {
            icon = '',
            font = beautiful.icon_font('Solid'),
            command = function() end,
        },
        {
            icon = '',
            font = beautiful.icon_font('Solid'),

            init_listeners = function(widget)
                context:on('context::loaded', function()
                    awful.spawn.easy_async('nmcli radio wifi', function(stdout)
                        stdout = stdout:gsub('%s+', '')
                        if stdout == 'enabled' then
                            widget:on()
                        else
                            widget:off()
                        end
                    end)
                end)
            end,

            command = function(widget)
                local powered = widget:is_on()
                local value   = powered and 'off' or 'on'

                awful.spawn('nmcli radio wifi ' ..  value)

                if powered then
                    widget:off()
                else
                    widget:on()
                end
            end,
        },
        {
            icon = '',
            font = beautiful.icon_font('Solid'),

            init_listeners = function(widget)
                local callback
                callback = function()
                    awful.spawn.easy_async("pa-cli sink is-muted", function(stdout, stderr)
                        if stderr ~= '' then
                            print('Error while getting speakers state')
                            print('Retrying in 15 secs')
                            timer.start_new(15, callback)
                            return
                        end

                        stdout = stdout:gsub('%s+', '')
                        if stdout == '0' then
                            widget:off()
                        else
                            widget:on()
                        end
                    end)
                end

                context:on('context::loaded', callback)
                context:on('volume::muted', callback)
            end,

            command = function(widget)
                awful.spawn('pa-cli sink mute')

                if widget:is_on() then
                    widget:off()
                else
                    widget:on()
                end
            end,
        },
        {
            icon    = '',
            font    = beautiful.icon_font('Solid'),

            init_listeners = function(widget)
                local callback

                callback = function()
                    awful.spawn.easy_async("pa-cli source is-muted", function(stdout, stderr)
                        if stderr ~= '' then
                            print('Error while getting microphone state')
                            print('Retrying in 15 secs')
                            timer.start_new(15, callback)
                            return
                        end

                        stdout = stdout:gsub('%s+', '')
                        if stdout == '0' then
                            widget:off()
                        else
                            widget:on()
                        end
                    end)
                end

                context:on('context::loaded', callback)
                context:on('microphone::muted', callback)
            end,

            command = function(widget)
                awful.spawn('pa-cli source mute')

                if widget:is_on() then
                    widget:off()
                else
                    widget:on()
                end
            end,
        },
        {
            icon    = '',
            font    = beautiful.icon_font('Solid'),
            command = function(widget)
                awful.spawn.with_shell('scrot $HOME/Pictures/Screenshots/%d-%b-%Y-%H%M%S.png')
            end,
        },
        {
            icon    = '',
            font    = beautiful.icon_font('Solid'),
            command = function()
                awful.spawn('systemctl reboot')
            end,
        },
    }

    local settings = wibox.widget {
        expand          = true,
        homogeneous     = true,
        spacing         = dpi(10),
        forced_num_cols = 4,
        widget          = wibox.layout.grid
    }

    for _, item in ipairs(items) do
        local row = wibox.widget {
            {
                {
                    text   = item.icon,
                    align  = 'center',
                    valign = 'center',
                    font   = item.font,
                    widget = wibox.widget.textbox
                },
                margins = dpi(10),
                widget  = wibox.container.margin
            },
            forced_width  = dpi(50),
            forced_height = dpi(50),
            shape   = gears.shape.circle,
            bg      = beautiful.background3,
            widget  = wibox.container.background,

            is_on = function(self)
                return self.powered
            end,

            on = function(self)
                self.powered = true
                self.fg = beautiful.fg_focus
                self.bg = beautiful.bg_focus
            end,

            off = function(self)
                self.powered = false
                self.fg = beautiful.fg_normal
                self.bg = beautiful.background3
            end
        }

        hand_cursor(row)

        row:buttons(awful.util.table.join(awful.button({}, 1, function()
            item.command(row)
        end)))

        if item.init_listeners then
            item.init_listeners(row)
        end

        if item.sync_update then
            item.sync_update(row)
        end

        if item.async_update then
            item.async_update(row)
        end

        settings:add(row)
    end

    local panel = wibox.widget {
        {
            {
                text = 'Settings',
                align = 'left',
                widget = wibox.widget.textbox
            },
            fg   = beautiful.sub_text,
            widget = wibox.container.background,
        },
        settings,
        spacing = dpi(10),
        widget = wibox.layout.fixed.vertical,
    }

    return panel
end

return worker
