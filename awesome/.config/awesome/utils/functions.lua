local awful = require('awful')

return function(context)
  return {
    run_launcher = function()
      awful.spawn('appsmenu')
    end,

    lock_screen = function()
      awful.spawn('xdg-screensaver lock')
    end,

    inc_volume = function()
      awful.spawn('pa-cli sink adjust-volume +2')
      context:emit('volume::changed')
    end,

    dec_volume = function()
      awful.spawn('pa-cli sink adjust-volume -2')
      context:emit('volume::changed')
    end,

    mute_audio = function()
      awful.spawn('pa-cli sink mute')
      context:emit('volume::muted')
    end,

    mute_microphone = function(callback)
        awful.spawn('pa-cli source mute')
        context:emit('microphone::muted')
    end,

    inc_brightness = function()
      awful.spawn('light -A 10')
    end,

    dec_brightness = function()
      awful.spawn('light -U 10')
    end,

    take_screnshot = function(type)
      return function()
        -- TODO: implement this
      end
    end,

    focus_client_at = function(idx)
      return function()
        awful.client.focus.byidx(idx)
      end
    end,
  }
end
