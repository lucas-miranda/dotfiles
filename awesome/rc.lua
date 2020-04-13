-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
gears = require("gears")
awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
wibox = require("wibox")

-- Theme handling library
beautiful = require("beautiful")

-- Notification library
naughty = require("naughty")
menubar = require("menubar")
hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- Variables
-----------------------------

-- local
local config_dir = awful.util.getdir("config")

-- global
terminal = "kitty"
editor = "nvim"
editor_cmd = terminal .. " -e " .. editor

-- keys
modkey = "Mod4"
super_key = "Mod4"
alt_key = "Mod1"
shift_key = "Shift"
control_key = "Control"

mouse_id = {
    button_left = 1,
    button_right = 3,
    scroll_up = 4,
    scroll_down = 5
}

-- Load
-----------------------------

dofile(config_dir .. "/config/layouts.lua")
dofile(config_dir .. "/config/globalkeys.lua")
dofile(config_dir .. "/config/client.lua")
dofile(config_dir .. "/config/bars.lua")
dofile(config_dir .. "/config/rules.lua")
dofile(config_dir .. "/config/mediakeys.lua")
dofile(config_dir .. "/config/handlers/naughty.lua")

-- Post-Load
-----------------------------

root.keys(globalkeys)
dofile(config_dir .. "/start.lua")
