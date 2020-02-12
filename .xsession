#!/bin/sh

export KITTY_CONFIG_DIRECTORY=~/.config/dev/kitty/
exec qtile -c ~/.config/dev/qtile/config.py
