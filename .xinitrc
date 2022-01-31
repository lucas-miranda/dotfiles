#!/bin/sh
nvidia-settings -l &
xrandr --setprovideroutputsource modesetting NVIDIA-0
#xrandr --auto
xrandr --output HDMI-1 --auto --primary --preferred --output LVDS-1 --off

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

xrdb ~/.Xresources

# user definitions
export TERMINAL="kitty"
export BROWSER="firefox"
export PATH="$HOME/.local/bin:$HOME/.ghcup/bin:$PATH"

# start wm
#exec i3
exec ~/.cache/xmonad/xmonad-x86_64-linux
