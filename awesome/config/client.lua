local gears = gears
local awful = awful
local wibox = wibox
local beautiful = beautiful

-- Key Bindings
-----------------------

clientkeys = gears.table.join(
    awful.key(
        { super_key }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }
    ),
    awful.key(
        { super_key }, "q",
        function (c) 
            c:kill()
        end,
        { description = "close", group = "client" }
    ),
    awful.key(
        { super_key }, "w", 
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
    ),
    awful.key(
        { super_key, "Control" }, "Return", 
        function (c) 
            c:swap(awful.client.getmaster()) 
        end,
        { description = "move to master", group = "client" }
    ),
    awful.key(
        { super_key }, "o",
        function (c) 
            c:move_to_screen()
        end,
        { description = "move to screen", group = "client" }
    ),
    awful.key(
        { super_key }, "t",
        function (c) 
            c.ontop = not c.ontop
        end,
        { description = "toggle keep on top", group = "client" }
    ),
    awful.key(
        { super_key }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        { description = "minimize", group = "client" }
    ),
    awful.key(
        { super_key }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }
    ),
    awful.key(
        { super_key, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = "(un)maximize vertically", group = "client" }
    ),
    awful.key(
        { super_key, "Shift" }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        { description = "(un)maximize horizontally", group = "client" }
    )
)

-- Mouse Bindings
-----------------------

clientbuttons = gears.table.join(
    awful.button(
        { }, mouse_id.button_left, 
        function (c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
        end
    ),
    awful.button(
        { super_key }, mouse_id.button_left, 
        function (c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.move(c)
        end
    ),
    awful.button(
        { super_key }, mouse_id.button_right, 
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end
    )
)


-- Signals
-----------------------

-- When a new client appears.
client.connect_signal(
    "manage", 
    function (c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- if not awesome.startup then awful.client.setslave(c) end

        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
    "request::titlebars", 
    function(c)
        -- buttons for the titlebar
        local buttons = gears.table.join(
            awful.button(
                { }, mouse_id.button_left, 
                function()
                    c:emit_signal("request::activate", "titlebar", { raise = true })
                    awful.mouse.client.move(c)
                end
            ),
            awful.button(
                { }, mouse_id.button_right, 
                function()
                    c:emit_signal("request::activate", "titlebar", { raise = true })
                    awful.mouse.client.resize(c)
                end
            )
        )

        awful.titlebar(c):setup {
            layout = wibox.layout.align.horizontal,

            -- Left
            {
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout  = wibox.layout.fixed.horizontal
            },

            -- Middle
            { 
                -- Title
                {
                    align  = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = buttons,
                layout  = wibox.layout.flex.horizontal
            },

            -- Right
            {
                awful.titlebar.widget.floatingbutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.ontopbutton(c),
                awful.titlebar.widget.closebutton(c),
                layout = wibox.layout.fixed.horizontal()
            }
        }
    end
)

-- enable sloppy focus, so that focus follows mouse.
client.connect_signal(
    "mouse::enter", 
    function(c)
        c:emit_signal("request::activate", "mouse_enter", { raise = false })
    end
)

client.connect_signal(
    "focus", 
    function(c) 
        c.border_color = beautiful.border_focus 
    end
)

client.connect_signal(
    "unfocus", 
    function(c) 
        c.border_color = beautiful.border_normal 
    end
)
