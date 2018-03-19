#!/bin/bash

#
# A script that sets up keyboard shortcuts in XFCE/XFWM.
#

# backup existing shortcuts
ts=$(date +%Y%m%d-%H%M%S)
cp ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts-${ts}.xml

#
# Shortcuts to clear
#
(cat <<EOF
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
EOF
) | while read row; do
    if echo ${row} | egrep -q '^[ ]*#'; then
	# skip comments
	continue
    fi
    shortcut=$(echo ${row} | awk -F'|' '{print $1}' | xargs)
    echo "clearing xfce keyboard shortcut: \"${shortcut}\""
    xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/command/default/${shortcut}"
    xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/commands/custom/${shortcut}"
    xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/xfwm4/default/${shortcut}"
    xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/${shortcut}"

done



#
# xfwm window manager shortcuts
#
(cat <<EOF
# Ctrl+Shift+<keypad> => tile window in different directions
<Primary><Shift>KP_Home       |  tile_up_left_key
<Primary><Shift>KP_Left       |  tile_left_key
<Primary><Shift>KP_Right      |  tile_right_key
<Primary><Shift>KP_Down       |  tile_down_key
<Primary><Shift>KP_Up         |  tile_up_key
<Primary><Shift>KP_Page_Up    |  tile_up_right_key
<Primary><Shift>KP_End        |  tile_down_left_key
<Primary><Shift>KP_Page_Down  |  tile_down_right_key
EOF
) | while read row; do
    if echo ${row} | egrep -q '^[ ]*#'; then
	# skip comments
	continue
    fi
    shortcut=$(echo ${row} | awk -F'|' '{print $1}' | xargs)
    command=$(echo ${row}  | awk -F'|' '{print $2}' | xargs)
    echo "adding xfce keyboard shortcut: \"${shortcut}\" => \"${command}\""
    xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/commands/custom/${shortcut}"
    xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/${shortcut}"
    xfconf-query --create --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/${shortcut}" --type string --set "${command}"
done

#
# command shortcuts
#

(cat <<EOF
<Control><Alt>t       |  exo-open --launch TerminalEmulator
Super_L               |  xfce4-appfinder
<Shift><Alt>Left      |  xdotool mousemove_relative -- -100 0
<Shift><Alt>Right     |  xdotool mousemove_relative -- 100 0
<Shift><Alt>Up        |  xdotool mousemove_relative -- -0 -100
<Shift><Alt>Down      |  xdotool mousemove_relative -- 0 100
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
    xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/commands/custom/${shortcut}"
    xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/${shortcut}"
    xfconf-query --create --channel xfce4-keyboard-shortcuts --property "/commands/custom/${shortcut}" --type string --set "${command}"
done
