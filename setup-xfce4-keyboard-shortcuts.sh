#!/bin/bash

set -e
#
# A script that sets up keyboard shortcuts in XFCE/XFWM.
#

# backup existing shortcuts
ts=$(date +%Y%m%d-%H%M%S)
if [ -f ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml ]; then
    # make a backup of existing shortcuts
    cp ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml.${ts}
fi

#
# Shortcuts to clear
#
(cat <<EOF
# remove default shortcuts for weird buttons
XF86Display
XF86Music
XF86WWW
XF86HomePage
XF86Mail
XF86Calculator
XF86Messenger
XF86Explorer
# remove mousepad shortcut
<Super>e
# remove email shortcut
<Super>m
# remove terminal shortcut
<Super>t
# remove web browser shortcut
<Super>w
# remove display settings shortcut
<Super>p
# remove various default application shortcuts (libreoffice, etc)
<Super>1
<Super>2
<Super>3
<Super>4
<Super>r
<Super>f
# remove xfce4-appfinder shortcut
<Alt>F3
# remove whisker menu shortcut
<Primary>Escape
# remove 'move window to workspace 1..9'
<Primary><Alt>1
<Primary><Alt>2
<Primary><Alt>3
<Primary><Alt>4
<Primary><Alt>5
<Primary><Alt>6
<Primary><Alt>7
<Primary><Alt>8
<Primary><Alt>9
# alternative forumalations for keypress 1-9 (maybe more recent xfce versions?)
<Primary><Alt>KP_1
<Primary><Alt>KP_2
<Primary><Alt>KP_3
<Primary><Alt>KP_4
<Primary><Alt>KP_5
<Primary><Alt>KP_6
<Primary><Alt>KP_7
<Primary><Alt>KP_8
<Primary><Alt>KP_9
# remove 'move window to previous/next workspace'
<Primary><Alt>Home
<Primary><Alt>End
# remove 'show desktop'
<Primary><Alt>d
# remove 'switch window for same application'
<Super>Tab
# remove 'toggle above'
<Alt>F12
# remove 'raise window'
<Shift><Alt>Page_Up
# remove 'lower window'
<Shift><Alt>Page_Down
# remove 'maximize window vertically'
<Alt>F6
EOF
) | while read row; do
    if echo ${row} | egrep -q '^[ ]*#'; then
	# skip comments
	continue
    fi
    shortcut=$(echo ${row} | awk -F'|' '{print $1}' | xargs)
    echo "clearing xfce keyboard shortcut: \"${shortcut}\""
    xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/commands/default/${shortcut}"
    xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/commands/custom/${shortcut}"
    xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/xfwm4/default/${shortcut}"
    xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/${shortcut}"
done


#
# xfwm window manager shortcuts
#
(cat <<EOF
# Ctrl+Shift+arrow => move window to a different workspace
<Primary><Shift><Alt>Right    | move_window_right_workspace_key
<Primary><Shift><Alt>Left     | move_window_left_workspace_key
<Primary><Shift><Alt>Up       | move_window_up_workspace_key
<Primary><Shift><Alt>Down     | move_window_down_workspace_key
# Ctrl+Shift+<keypad> => tile window in different directions
<Primary><Shift>7    |  tile_up_left_key
<Primary><Shift>4    |  tile_left_key
<Primary><Shift>6    |  tile_right_key
<Primary><Shift>2    |  tile_down_key
<Primary><Shift>8    |  tile_up_key
<Primary><Shift>9    |  tile_up_right_key
<Primary><Shift>1    |  tile_down_left_key
<Primary><Shift>3    |  tile_down_right_key
# Ctrl+Shift+<keypad5> twice will move a tiled window to its original position
<Primary><Shift>5    |  maximize_vert_key
EOF
) | while read row; do
    if echo ${row} | egrep -q '^[ ]*#'; then
	# skip comments
	continue
    fi
    shortcut=$(echo ${row} | awk -F'|' '{print $1}' | xargs)
    command=$(echo ${row}  | awk -F'|' '{print $2}' | xargs)
    echo "adding xfce keyboard shortcut: \"${shortcut}\" => \"${command}\""
    xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/commands/default/${shortcut}"
    xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/commands/custom/${shortcut}"
    xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/${shortcut}"
    xfconf-query --create --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/${shortcut}" --type string --set "${command}"
done

#
# command shortcuts
#

(cat <<EOF
<Primary><Alt>t       |  xfce4-terminal
Super_L               |  xfce4-appfinder
<Shift><Alt>Left      |  xdotool mousemove_relative -- -20 0
<Shift><Alt>Right     |  xdotool mousemove_relative -- 20 0
<Shift><Alt>Up        |  xdotool mousemove_relative -- -0 -20
<Shift><Alt>Down      |  xdotool mousemove_relative -- 0 20
# Left mouse click
<Shift><Alt>Return    |  xdotool keyup alt+Shift_L click 1
# Right mouse click
<Shift><Alt>Backspace |  xdotool keyup alt+Shift_L click 3
EOF
) | while read row; do
    if echo ${row} | egrep -q '^[ ]*#'; then
	# skip comments
	continue
    fi
    shortcut=$(echo ${row} | awk -F'|' '{print $1}' | xargs)
    command=$(echo ${row}  | awk -F'|' '{print $2}' | xargs)
    echo "adding xfce keyboard shortcut: \"${shortcut}\" => \"${command}\""
    xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/commands/default/${shortcut}"
    xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/commands/custom/${shortcut}"
    xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/${shortcut}"
    xfconf-query --create --channel xfce4-keyboard-shortcuts --property "/commands/custom/${shortcut}" --type string --set "${command}"
done
