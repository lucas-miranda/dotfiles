local audio_card_id = 0

globalkeys = gears.table.join(
    globalkeys,

    -- volume

    awful.key(
        { }, "XF86AudioRaiseVolume",
        function() 
            awful.spawn(string.format("amixer --card %d --quiet set Master 2dB+", audio_card_id)) 
        end,
        { description = "raise master volume", group = "media" }
    ),

    awful.key(
        { super_key }, "equal",
        function() 
            awful.spawn(string.format("amixer --card %d --quiet set Master 2dB+", audio_card_id)) 
        end,
        { description = "raise master volume", group = "media" }
    ),

    awful.key(
        { }, "XF86AudioLowerVolume",
        function() 
            awful.spawn(string.format("amixer --card %d --quiet set Master 2dB-", audio_card_id)) 
        end,
        { description = "lower master volume", group = "media" }
    ),

    awful.key(
        { super_key }, "minus",
        function() 
            awful.spawn(string.format("amixer --card %d --quiet set Master 2dB-", audio_card_id)) 
        end,
        { description = "lower master volume", group = "media" }
    ),

    -- mute

    awful.key(
        { }, "XF86AudioMute",
        function() 
            awful.spawn("amixer -D pulse set Master toggle") 
        end,
        { description = "mute master volume", group = "media" }
    ),

    -- play / pause

    awful.key(
        { }, "XF86AudioPlay",
        function() 
            awful.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
        end,
        { description = "player / pause", group = "media" }
    ),

    -- next track

    awful.key(
        { }, "XF86AudioNext",
        function() 
            awful.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
        end,
        { description = "request next track", group = "media" }
    ),

    awful.key(
        { super_key }, "bracketleft",
        function() 
            awful.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
        end,
        { description = "request next track", group = "media" }
    ),

    -- previous track

    awful.key(
        { }, "XF86AudioPrev",
        function() 
            awful.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
        end,
        { description = "request previous track", group = "media" }
    ),

    awful.key(
        { super_key }, "bracketright",
        function() 
            awful.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
        end,
        { description = "request previous track", group = "media" }
    ),

    -- others

    awful.key(
        { super_key }, "v",
        function() 
            awful.spawn("pavucontrol")
        end,
        { description = "spawns pavucontrol", group = "media" }
    )
)
