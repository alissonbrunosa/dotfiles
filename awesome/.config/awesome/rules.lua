local awful     = require('awful')
local beautiful = require('beautiful')
local dpi       = require("beautiful.xresources").apply_dpi

-- Rules to apply to new clients (through the "manage" signal).
return function(clientkeys, clientbuttons)
    return {
        {
            rule_any = {
                class = {
                    "[Aa]lacritty",
                    "kitty",
                    "wezterm",
                    "[Ff]irefox",
                },
            },
            properties = {
                tag = "I",
                switchtotag = true
            },
        },

        -- Slack
        {
            rule = { class = "[Ss]lack" },
            properties = {
                tag = "II",
                switchtotag = true
            },
        },

        -- Telegram
        {
            rule = { class = "[Tt]elegram" },
            properties = {
                tag = "II",
                switchtotag = true
            },
        },

        -- Utilities
        {
            rule_any = {
                class = {
                    "Pcmanfm",
                    "obsidian",
                    "Zathura",
                }
            },
            properties = {
                tag = "III",
                switchtotag = true
            },
        },

        -- VPN Client
        {
            rule = { class = "[Ff]orti[Cc]lient" },
            properties = {
                tag = "IV",
                switchtotag = true
            },
        },

        -- Spotify
        {
            rule = { class = "[Ss]potify" },
            properties = {
                tag = "VI",
                switchtotag = true
            },
        },
        {
            rule_any = {
                name  = { "Picture-in-Picture", "Picture in picture" },
            },
            properties = {
                x = 3170,
                y = 1771,
                width  = dpi(640),
                height = dpi(360),
                sticky = true,
                focusable = false,
            },
        },
        {
            rule = {
                class = "Brave-browser",
                role  = "pop-up",
                type  = "normal",
            },
            properties = {
                floating = true,
                ontop = true,
                focusable = false,
                x = 3500,
                y = 1568,
            }
        },

        -- All clients will match this rule.
        {
            rule = { },
            properties = {
                border_color = beautiful.border_normal,
                focus        = awful.client.focus.filter,
                raise        = true,
                keys         = clientkeys,
                buttons      = clientbuttons,
                screen       = awful.screen.preferred,
                placement    = awful.placement.no_overlap + awful.placement.no_offscreen,
                border_width = beautiful.border_width,
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
                    "control_panel",
                    "Control_panel",
                },

                -- Note that the name property shown in xprop might be set slightly after creation of the client
                -- and the name shown there might not match defined rules here.
                name = {
                    "Event Tester",  -- xev.
                    "Choose Application",
                    "Export Image",
                },
                role = {
                    "Dialog",        -- Firefox Download dialog.
                    "AlarmWindow",   -- Thunderbird's calendar.
                    "ConfigManager", -- Thunderbird's about:config.
                    "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
                },
                type = {
                    "[Dd]ialog",
                }
            },
            properties = {
                floating  = true,
                placement = awful.placement.centered,
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
