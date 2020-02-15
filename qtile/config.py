import os, subprocess
from libqtile.config import Key, Screen, Group, Match
from libqtile.command import lazy
from libqtile import bar, widget, hook

#

audio_card_id = 0

# media

def is_spotify_running():
    spotify_processes_b = subprocess.run(["pgrep", "-x", "spotify"], capture_output=True)
    spotify_processes = spotify_processes_b.stdout.decode("utf-8")
    return len(spotify_processes) > 0

def media_playpause(qtile):
    if is_spotify_running():
        qtile.cmd_spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")

def media_next(qtile):
    if not is_spotify_running():
        return

    qtile.cmd_spawn('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next')

def media_previous(qtile):
    if not is_spotify_running():
        return

    qtile.cmd_spawn('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous')

# desktop

def set_wallpaper(path):
    os.system('feh --bg-scale %s' % path)

#

super_key = "mod4"
alt_key = "mod1"

keys = [
    Key([super_key], "r", lazy.spawncmd()),

    # reload qtile configs
    Key([super_key, "shift"], "r", lazy.restart()),

    # switch to next panel in the stack
    Key([alt_key], "Tab", lazy.layout.next()),
    Key([super_key], "k", lazy.layout.down()),
    Key([super_key], "j", lazy.layout.up()),
    Key([super_key], "h", lazy.layout.previous()),
    Key([super_key], "l", lazy.layout.next()),
    Key([super_key, "shift"], "l", lazy.screen.next_group()),
    Key([super_key, "shift"], "h", lazy.screen.prev_group()),
    Key([super_key], "w", lazy.screen.toggle_floating()),

    # close focused window
    Key([alt_key], "F4", lazy.window.kill()),
    Key([super_key], "x", lazy.window.kill()),

    # ~ Audio
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer --card %d --quiet set Master 2dB+" % audio_card_id)),
    Key([super_key], "minus", lazy.spawn("amixer --card %d --quiet set Master 2dB+" % audio_card_id)),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer --card %d --quiet set Master 2dB-" % audio_card_id)),
    Key([super_key], "equal", lazy.spawn("amixer --card %d --quiet set Master 2dB-" % audio_card_id)),
    Key([], "XF86AudioMute", lazy.spawn("amixer -D pulse set Master toggle")),
    Key([], "XF86AudioPlay", lazy.function(media_playpause)),
    Key([], "XF86AudioNext", lazy.function(media_next)),
    Key([super_key], "bracketleft", lazy.function(media_next)),
    Key([], "XF86AudioPrev", lazy.function(media_previous)),
    Key([super_key], "bracketright", lazy.function(media_previous)),
    Key([super_key], "v", lazy.spawn("pavucontrol")),

    # quick launch
    Key([super_key], "t", lazy.spawn("kitty"))
]

widget_defaults = dict(
    font = 'Fira Code',
    fontsize = 13,
    padding = 3
)

screens = [
    #Screen(),
    Screen(
        top=bar.Bar(
            [
                #widget.CurrentLayout(),
                widget.GroupBox(
                    active='878787',
                    inactive='2E2E2E',
                    disable_drag=True,
                    this_current_screen_border='DB6EFF',
                    this_screen_border='DB6EFF',
                    highlight_method='text',
                    urgent_alert_method='text'
                ),
                widget.Spacer(length=20),
                widget.WindowName(
                    foreground='C4C4C4'
                ),
                widget.Prompt(**widget_defaults),
                #widget.Mpris2(
                #    name='spotify',
                #    objname="org.mpris.MediaPlayer2.spotify",
                #    display_metadata=['xesam:title', 'xesam:artist', 'xesam:album'],
                #    scroll_chars=None,
                #    stop_pause_text='',
                #    **widget_defaults
                #),
                #widget.Spacer(length=20),
                widget.Systray(),
                widget.Spacer(length=20),
                widget.Clock(
                    format=' %H:%M, %a %d/%m/%Y', 
                    **widget_defaults
                ),
                widget.Volume(
                    card_id=audio_card_id, 
                    **widget_defaults
                ),
                widget.QuickExit(
                    default_text='[ S ]', 
                    countdown_format='[ {} ]'
                ),
            ],
            24,
        ),
    )
]

groups = [Group(i) for i in 'asdf']

# throwaway groups for random stuff
for i in groups:
    # super + letter of group = switch to group
    keys.append(
            Key([super_key], i.name, lazy.group[i.name].toscreen())
    )

    # super + shift + letter of group = switch to & move focused window to group
    keys.append(
            Key([super_key, 'shift'], i.name, lazy.window.togroup(i.name))
    )

groups.extend([
    Group(
        'music', 
        spawn='spotify', 
        layout='max', 
        init=True,
        exclusive=True,
        persist=True,
        matches=[
            Match(wm_class=['spotify', 'Spotify'], wm_instance_class=['spotify', 'Spotify'])
        ]
    ),
])

focus_on_window_activation = 'never'

#

@hook.subscribe.startup
def autostart():
    set_wallpaper('~/Imagens/1086871-persona-5-wallpapers-1920x1080-for-ipad.jpg')
