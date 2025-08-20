#!/bin/sh
nvidia-settings -l &
#xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --output DP-0 --primary --preferred --mode 1920x1080 --rate 144
#xrandr --auto
#xrandr --output HDMI-1 --auto --primary --preferred --output LVDS-1 --off

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

xrdb $HOME/.Xresources

# user definitions
export TERMINAL="kitty"
export BROWSER="firefox"
export PATH="$HOME/.local/bin:$HOME/.ghcup/bin:$PATH"

# start wm
exec $HOME/.cache/xmonad/xmonad-x86_64-linux

#alsactl --file $HOME/.config/asound.state restore

# starts picom
if [[ -x "$(command -v picom)" ]]
then
    killall -q picom
    while pgrep -u $UID -x picom >/dev/null; do sleep 1; done
    picom --no-frame-pacing -b &> /dev/null
fi

# desktop background
if [[ -f "$HOME/.local/bin/refresh-wallpaper" ]]
then
    $HOME/.local/bin/refresh-wallpaper &> /dev/null &
fi

# load normal.xkb
xkbcomp $HOME/normal.xkb $DISPLAY

# decrease mouse accel speed a little bit
xinput --set-prop 9 'libinput Accel Speed' -.25
