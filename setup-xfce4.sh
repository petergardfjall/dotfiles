#!/bin/bash

here=$(dirname $(realpath ${0}))

set -e

function info () {
    echo -e "\e[32m${1}\e[0m"
}

function warn () {
    echo -e "\e[32m${1}\e[0m"
}

#
# Apply saved xfce4-panel profile.
# - A profile is exported via: "xfce4-panel-profiles save profile.tar.bz2"
#
info "applying xfce4-panel profile ..."
# Note: for the time being this appears to kill the panel due to [1].
#       Should this happen just try 'xfce4-panel &' from a terminal.
# [1] https://bugs.launchpad.net/ubuntu/+source/xfce4-panel/+bug/2064846
xfce4-panel-profiles load ${here}/xfce4/xfce4-panel-profile.tar.bz2

#
# Apply saved terminal settings.
#
cp ${here}/xfce4/xfce4-terminal.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml

echo "setting up xfce keyboard shortcuts ..."
${here}/setup-xfce4-keyboard-shortcuts.sh

echo "applying some general xfce settings ..."
# Disable not zoom desktop on Alt+mousewheel.
xfconf-query --set false --channel xfwm4 --property /general/zoom_desktop
# Disable mousewheel workspace switching.
xfconf-query --set false --channel xfwm4 --property /general/scroll_workspaces
# Disable roll-up of window with mousewheel on title bar.
xfconf-query --set false --channel xfwm4 --property /general/mousewheel_rollup
