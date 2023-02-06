local awful         = require('awful')
local beautiful     = require('beautiful')
local dpi           = require("beautiful.xresources").apply_dpi

-- Rules to apply to new clients (through the "manage" signal).
return function(clientkeys, clientbuttons)
    return {
        -- kitty
        {
            rule_any = { class = { "[Aa]lacritty", "kitty" } },
            properties = {
                tag = "1",
                switchtotag = true
            },
        },

        -- Firefox
        {
            rule = { class = "[Ff]irefox" },
            properties = {
                tag = "1",
                switchtotag = true
            },
        },

        -- Slack
        {
            rule = { class = "[Ss]lack" },
            properties = {
                tag = "2",
                switchtotag = true
            },
        },

        -- Telegram
        {
            rule = { class = "[Tt]elegram" },
            properties = {
                tag = "2",
                switchtotag = true
            },
        },

        -- File Manager
        {
            rule = { class = "Pcmanfm" },
            properties = {
                tag = "3",
                switchtotag = true
            },
        },

        -- Spotify
        {
            rule = { class = "[Ss]potify" },
            properties = {
                tag = "6",
                switchtotag = true
            },
        },
        {
            rule = {
                name = "Picture-in-Picture",
                class = "[Ff]irefox"
            },
            properties = {
                x       =  dpi(2952),
                y       =  dpi(1162),
                width   =  dpi(1024),
                height  =  dpi(768),
                sticky  =  true
            },
        },

        -- All clients will match this rule.
        {
            rule = { },
            properties = {
                border_color  =  beautiful.border_normal,
                focus         =  awful.client.focus.filter,
                raise         =  true,
                keys          =  clientkeys,
                buttons       =  clientbuttons,
                screen        =  awful.screen.preferred,
                placement     =  awful.placement.no_overlap + awful.placement.no_offscreen,
                border_width  =  beautiful.border_width,
            }
        },

        -- Floating clients.
        {
            rule_any = {
                instance = {
                    "DTA",  -- Firefox addon DownThemAll.
                    "copyq",  -- Includes session name in class.
                    "pinentry",
                },
                class = {
                    "Arandr",
                    "Blueman-manager",
                    "Gcr-prompter",
                    "Gpick",
                    "Kruler",
                    "MessageWin",  -- kalarm.
                    "Sxiv",
                    "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                    "Wpa_gui",
                    "veromix",
                    "Xdg-desktop-portal-gtk",
                    "xtightvncviewer",
                    "Zenity",
                },

                -- Note that the name property shown in xprop might be set slightly after creation of the client
                -- and the name shown there might not match defined rules here.
                name = {
                    "Event Tester",  -- xev.
                    "Choose Application",
                },
                role = {
                    "Dialog",        -- Firefox Download dialog.
                    "AlarmWindow",   -- Thunderbird's calendar.
                    "ConfigManager", -- Thunderbird's about:config.
                    "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
                }
            },
            properties = {
                floating  = true,
                placement = awful.placement.centered
            }
        },

        -- Add titlebars to normal clients and dialogs
        {
            rule_any = {
                type = { "normal", "dialog" }
            },
            properties = { titlebars_enabled = false }
        },

        -- Ignore dock window
        {
            rule = {
                type = "dock",
            },
            properties = {
                focusable = false,
                border_width = dpi(0),
            },
        },
    }
end
