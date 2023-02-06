local gears = require('gears')

return {
    rounded_rect = function(cr, width, height)
      return gears.shape.rounded_rect(cr, width, height, 5)
    end,
}
