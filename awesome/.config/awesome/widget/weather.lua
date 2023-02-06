local awful      = require('awful')
local watch      = require('awful.widget.watch')
local wibox      = require('wibox')
local gears      = require('gears')
local beautiful  = require('beautiful')
local dpi        = beautiful.xresources.apply_dpi
local filesystem = require('gears.filesystem')
local json       = require('json')

local GET_FORECAST_CMD = [[bash -c "curl -s --show-error -X GET '%s'"]]

local icon_map = {
  ['01d'] = '',
  ['02d'] = '',
  ['03d'] = '',
  ['04d'] = '',
  ['09d'] = '',
  ['10d'] = '',
  ['11d'] = '',
  ['13d'] = '',
  ['50d'] = '',
  ['01n'] = '',
  ['02n'] = '',
  ['03n'] = '',
  ['04n'] = '',
  ['09n'] = '',
  ['10n'] = '',
  ['11n'] = '',
  ['13n'] = '',
  ['50n'] = ''
}

local hourly_widget = function()
    local widget = wibox.widget({
        {
            {
                id     = 'time',
                font   = beautiful.font_name .. '  9.5',
                widget = wibox.widget.textbox,
            },
            widget = wibox.container.place,
        },
        {
            {
                id     = 'icon',
                align  = 'center',
                valign = 'center',
                font   = beautiful.weather_icon_font .. ' 25',
                widget = wibox.widget.textbox,
            },
            widget = wibox.container.place,
        },
        {
            {
                id     = 'tempareture',
                font   = beautiful.font_name .. ' 9.5',
                widget = wibox.widget.textbox,
            },
            widget = wibox.container.place,
        },
        spacing = dpi(2),
        layout = wibox.layout.fixed.vertical,
    })

    widget.update = function(result)
        local time = widget:get_children_by_id('time')[1]
        local icon = widget:get_children_by_id('icon')[1]
        local temp = widget:get_children_by_id('tempareture')[1]

        temp:set_markup(math.floor(result.temp) .. '°')
        time:set_text(os.date('%I%p', tonumber(result.dt)))

        icon:set_text(icon_map[result.weather[1].icon])
        icon:emit_signal('widget::redraw_needed')
    end

    return widget
end

local to_query = function(weather_api_params)
    params = ''
    for k, v in pairs(weather_api_params) do
        params = params .. k .. '=' .. v .. '&'
    end

    return params
end

function worker(context)
    local current_weather_widget = wibox.widget({
        {
            {
                id = 'icon',
                font = beautiful.weather_icon_font .. ' 45',
                align = 'center',
                widget = wibox.widget.textbox,
            },
            {
                {
                    {
                        id = 'description',
                        font = beautiful.font_name .. ' 10.5',
                        widget = wibox.widget.textbox,
                    },
                    {
                        id = 'humidity',
                        font = beautiful.font_name .. ' 9.5',
                        widget = wibox.widget.textbox,
                    },
                    {
                        id = 'feels_like',
                        font = beautiful.font_name .. ' 9.5',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.vertical,
                },
                widget = wibox.container.place,
            },
            spacing = dpi(10),
            layout = wibox.layout.fixed.horizontal,
        },
        nil,
        {
            {
                id = 'tempareture_current',
                align = 'right',
                font = beautiful.font_name .. ' 30',
                widget = wibox.widget.textbox,
            },
            widget = wibox.container.background,
        },
        expand = 'none',
        layout = wibox.layout.align.horizontal,
    })

    local hourly_widget_1 = hourly_widget()
    local hourly_widget_2 = hourly_widget()
    local hourly_widget_3 = hourly_widget()
    local hourly_widget_4 = hourly_widget()
    local hourly_widget_5 = hourly_widget()

    local weather_widget = wibox.widget {
        {
            {
                text   = context.user.city or 'Weather',
                font   = beautiful.font_name .. ' 16',
                align  = 'center',
                widget = wibox.widget.textbox,
            },
            fg     = beautiful.fg_title,
            widget = wibox.container.background,
        },
        current_weather_widget,
        {
            hourly_widget_1,
            hourly_widget_2,
            hourly_widget_3,
            hourly_widget_4,
            hourly_widget_5,
            layout = wibox.layout.flex.horizontal,
        },
        spacing = dpi(10),
        layout = wibox.layout.fixed.vertical,
    }

    local url = 'https://api.openweathermap.org/data/2.5/onecall?' .. to_query(context.user.weather_api)

    watch(string.format(GET_FORECAST_CMD, url), 600, function(_, stdout, stderr)
        if stderr == '' then
            local result = json.decode(stdout)
            local icon = current_weather_widget:get_children_by_id('icon')[1]
            local description = current_weather_widget:get_children_by_id('description')[1]
            local humidity = current_weather_widget:get_children_by_id('humidity')[1]
            local temp_current = current_weather_widget:get_children_by_id('tempareture_current')[1]
            local feels_like = current_weather_widget:get_children_by_id('feels_like')[1]
            icon:set_text(icon_map[result.current.weather[1].icon])
            icon:emit_signal('widget::redraw_needed')
            description:set_text(result.current.weather[1].description:gsub('^%l', string.upper))
            humidity:set_text('Humidity: ' .. result.current.humidity .. '%')
            temp_current:set_markup(math.floor(result.current.temp) .. '°')
            feels_like:set_markup('Feels like: ' .. math.floor(result.current.feels_like) .. '<sup><span>°</span></sup>')
            -- Hourly widget setup
            hourly_widget_1.update(result.hourly[1])
            hourly_widget_2.update(result.hourly[2])
            hourly_widget_3.update(result.hourly[3])
            hourly_widget_4.update(result.hourly[4])
            hourly_widget_5.update(result.hourly[5])
        end
    end)

    return weather_widget
end

return worker
