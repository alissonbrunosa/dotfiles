return function(widget)
  widget:connect_signal('mouse::enter', function()
    local wibox = mouse.current_wibox
    local cursor = wibox.cursor

    wibox.cursor = 'hand2'
    widget:connect_signal('mouse::leave', function()
        if wibox then
            wibox.cursor = cursor
            wibox = nil
        end
    end)
  end)
end
