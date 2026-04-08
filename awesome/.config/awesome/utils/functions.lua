local awful = require('awful')
local client = require('awful.client')

local capi = {
  client = client,
}

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

    take_screnshot = function(command)
      return function()
        awful.spawn.with_shell('flameshot ' .. command .. ' -c -p $HOME/Pictures/Screenshots')
      end
    end,

    focus_client_at = function(idx)
      return function()
        local target = client.next(idx)
        if not target then
          return
        end

        target:emit_signal("request::activate", "client.focus.byidx",{ raise=true })
        if target.minimized or target.fullscreen then
          return
        end

        local g = target:geometry()
        mouse.coords {
          x = g.x + g.width / 2,
          y = g.y + g.height / 2
        }
      end
    end,

    open_music_application = function()
      awful.spawn('flatpak run com.spotify.Client')
    end,
  }
end
