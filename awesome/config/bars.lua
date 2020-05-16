local gears = gears
local awful = awful
local wibox = wibox
local beautiful = beautiful

-- select main screen
local main_screen = screen.primary

-- wibox
main_screen.wibar = awful.wibar({ position = "top", screen = main_screen })

-- tags
awful.tag({ "1", "2", "3", "4", "5" }, main_screen, awful.layout.layouts[1])

-- Bar Widgets
-----------------------

-- prompt
main_screen.prompt = awful.widget.prompt {
    prompt = " λ ",
}

-- layout box
main_screen.layoutbox = awful.widget.layoutbox(s)
main_screen.layoutbox:buttons(gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end)
))

-- text clock
local textclock = wibox.widget.textclock("  %H:%M, %a %d/%m/%Y")

-- media sensors
local media_sensors = awful.widget.watch(
    "amixer get Master", 
    0.5, 
    function (widget, stdout)
        local _, _, volume = string.find(stdout, "%[(%d+)%%%]")
        local output = ""

        if volume == nil then
            output = "-"
        else
            output = string.format("%d%%", volume)
        end

        widget:set_text(output)
    end
)

-- network sensors
local network_sensors = awful.widget.watch(
    "wget -q --spider https://www.archlinux.org/", 
    3, 
    function (widget, stdout, stderr, exitreason, exitcode)
        local output = " " -- default: not connected

        if exitreason == "exit" and exitcode == 0 then
            output = "  " -- connected icon
        end

        widget:set_text(output)
    end
)

-- hard disk sensor
local hard_disk_sensor = awful.widget.watch(
    'bash -c "df -h | /bin/grep -E "/dev/sda[0-9]+""',
    10,
    function (widget, stdout)
        local _, _, free_space = string.find(stdout, "([0-9,]+%w+)%s+%d+%%%s+.+$")
        local output = "--"

        if free_space ~= nil and free_space ~= "" then
            output = free_space
        end

        widget:set_text(output)
    end
)

local hard_disk_image_box = wibox.widget.imagebox(
    beautiful.sensor_harddisk,
    false,
    gears.shape.rectangle
)

-- taglist buttons
local taglist_buttons = gears.table.join(
    awful.button(
        { }, mouse_id.button_left, 
        function(t) 
            t:view_only() 
        end
    ),
    awful.button( 
        { }, mouse_id.button_right, 
        awful.tag.viewtoggle
    ),
    awful.button(
        { super_key }, mouse_id.button_right, 
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
    ),
    awful.button(
        { }, mouse_id.scroll_up, 
        function(t) 
            awful.tag.viewnext(t.screen) 
        end
    ),
    awful.button(
        { }, mouse_id.scroll_down, 
        function(t) 
            awful.tag.viewprev(t.screen) 
        end
    )
)

local tasklist_buttons = gears.table.join(
    awful.button(
        { }, mouse_id.scroll_up, 
        function ()
            awful.client.focus.byidx(1)
        end
    ),
    awful.button(
        { }, mouse_id.scroll_down, 
        function ()
            awful.client.focus.byidx(-1)
        end
    )
)

-- taglist
main_screen.taglist = awful.widget.taglist {
    screen  = main_screen,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
}

-- tasklist
main_screen.tasklist = awful.widget.tasklist {
    screen  = main_screen,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons
}

-- Add widgets to the wibox
main_screen.wibar:setup {
    layout = wibox.layout.align.horizontal,

    -- left widgets
    {
        layout = wibox.layout.fixed.horizontal,
        wibox.container.margin(main_screen.taglist, 5, 5, 0, 0)
    },

    -- middle widget
    main_screen.tasklist,

    -- right widgets
    {
        layout = wibox.layout.fixed.horizontal,
        wibox.container.margin(main_screen.prompt, 5, 5, 0, 0),
        {
            layout = wibox.container.margin,
            left = 5,
            right = 5,
            {
                layout = wibox.container.background,
                bg = beautiful.sensor_bg,
                {
                    layout = wibox.container.margin,
                    left = 5,
                    right = 5,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        spacing = 15,
                        fill_space = true,
                        {
                            layout = wibox.layout.fixed.horizontal,
                            spacing = 5,
                            fill_space = true,
                            {
                                widget = wibox.widget.textbox,
                                markup = "<big>  </big>",
                                align = "center",
                                valign = "center"
                            },
                            network_sensors
                        },
                        {
                            layout = wibox.layout.fixed.horizontal,
                            spacing = 3,
                            fill_space = true,
                            {
                                widget = wibox.widget.textbox,
                                markup = "<big> </big>",
                                align = "center",
                                valign = "center"
                            },
                            hard_disk_sensor
                        }
                    }
                }
            }
        },
        wibox.widget.systray(),
        wibox.container.margin(textclock, 5, 5, 0, 0),
        wibox.container.margin(media_sensors, 5, 10, 0, 0),
        main_screen.layoutbox
    }
}

-- Key Bindings
-----------------------

for i, tag in ipairs(main_screen.tags) do
    key = tag.name

    if tonumber(key) ~= nil then
        key = "#" .. tonumber(tag.name) + 9
    end

    globalkeys = gears.table.join(
        globalkeys,

        -- switch to tag
        awful.key(
            { super_key }, key,
            function ()
                tag:view_only()
            end,
            { description = "view tag #"..i, group = "tag" }
        ),

        -- move client to tag
        awful.key(
            { super_key, shift_key }, key,
            function ()
                if client.focus then
                    client.focus:move_to_tag(tag)
                end
            end,
            { description = "move focused client to tag #"..i, group = "tag" }
        )
    )
end
