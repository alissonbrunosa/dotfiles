return {
  listeners = {},
  on = function(self, event, callback)
    if not self.listeners[event] then
      self.listeners[event] = {}
    end

    table.insert(self.listeners[event], callback)
  end,

  emit = function(self, event)
    local listeners = self.listeners[event]
    if listeners then
      for _, callback in ipairs(listeners) do
        callback()
      end
    end
  end,

  user = {
      city = 'Berlin',
      weather_api = {
          lat     = '52.56391412016415',
          lon     = '13.211747020656674',
          units   = 'metric',
          appid   = 'wheather-appid',
          exclude = 'minutely,daily',
      },
  },
}
