--[[
    Setup and start after everything was already loaded
]]

local awful = awful

-- compositor
awful.spawn.single_instance("picom")

-- wallpaper
local function set_wallpaper(s)
    awful.spawn("refresh-wallpaper")
end

awful.screen.connect_for_each_screen(function(scr)
    set_wallpaper(scr)
    scr:connect_signal(
        "property::geometry", 
        set_wallpaper
    )
end)

