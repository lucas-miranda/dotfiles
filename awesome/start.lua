--[[
    Setup and start after everything was already loaded
]]

local awful = awful

-- compositor
awful.spawn.single_instance("picom")

-- wallpaper
local function set_wallpaper(s)
    awful.spawn(home_dir .. "/.local/bin/refresh-wallpaper")
end

awful.screen.connect_for_each_screen(function(scr)
    set_wallpaper(scr)
    scr:connect_signal(
        "property::geometry", 
        set_wallpaper
    )
end)

-- start default programs
awful.spawn.spawn("kitty", { tag = "1" })
awful.spawn.spawn("spotify", { tag = "5" })
