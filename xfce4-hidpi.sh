#!/bin/bash

set -e

function die {
    echo "error: ${1}"
    exit 1
}

[ -z "${1}" ] && die "must specify on|off"

if [ "${1}" = "on" ]; then
    enable=true
elif [ "${1}" = "off" ]; then
    enable=false
else
    die "argument must be either 'on' or 'off'"
fi

high_dpi_env_path=~/dotfiles/bash/bash.local/high-dpi
if ${enable}; then
    echo "Enabling High-DPI settings ..."
    # Set window scaling factor x2 (> Appearance > Settings)
    xfconf-query -c xsettings -p /Gdk/WindowScalingFactor -s 2
    # Use a high-dpi friendly window manager theme.x
    xfconf-query -c xfwm4 -p /general/theme -s Default-hdpi
    # Scale mouse cursor: 24 -> 48 pixels (> Mouse > Theme).
    xfconf-query -c xsettings -p /Gtk/CursorThemeSize -s 48
else
    echo "Disabling High-DPI settings ..."
    # Set normal window scaling factor x1 (> Appearance > Settings).
    xfconf-query -c xsettings -p /Gdk/WindowScalingFactor -s 1
    # Use default window manager theme.
    xfconf-query -c xfwm4 -p /general/theme -s Default
    # Default size mouse cursor: 24 pixels (> Mouse > Theme).
    xfconf-query -c xsettings -p /Gtk/CursorThemeSize -s 24
fi
