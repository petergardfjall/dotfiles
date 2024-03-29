#!/bin/bash

set -e
#
# A script that sets up keyboard shortcuts in XFCE/XFWM.
#

# backup existing shortcuts
ts=$(date +%Y%m%d-%H%M%S)
if [ -f ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml ]; then
    # make a backup of existing shortcuts
    mkdir -p ~/.config/xfce4/backup
    cp ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml ~/.config/xfce4/backup/xfce4-keyboard-shortcuts.xml.${ts}
fi

#
# Clear any shortcuts in the "custom" category. And don't touch the "override"
# property.
#
shortcut_properties=$(xfconf-query --list --channel xfce4-keyboard-shortcuts | (grep custom || true) | (egrep -v 'override$' || true) )
for shortcut_property in ${shortcut_properties}; do
    echo "clearing xfce keyboard shortcut: ${shortcut_property}"
    xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "${shortcut_property}"
done

#
# Set up xfwm window manager shortcuts
#
(cat <<EOF
<Alt>F4            | close_window_key
<Alt>F6            | stick_window_key
<Alt>F8            | resize_window_key
<Alt>F9            | hide_window_key
<Alt>F10           | maximize_window_key
<Alt>F12           | above_key
Escape             | cancel_key
<Alt><Space>       | popup_menu_key
#
# Alt+Tab and Alt+Shift+Tab => cycle windows in workspace
#
<Alt>Tab           | cycle_windows_key
<Alt><Shift>Tab    | cycle_reverse_windows_key
#
# Ctrl+Alt+arrow => move to a different workspace
#
<Primary><Shift><Alt>M | move_window_key
<Primary><Alt>Right    | right_workspace_key
<Primary><Alt>Left     | left_workspace_key
<Primary><Alt>Up       | up_workspace_key
<Primary><Alt>Down     | down_workspace_key
#
# Ctrl+Shift+arrow => move window to a different workspace
#
<Primary><Shift><Alt>Right    | move_window_right_workspace_key
<Primary><Shift><Alt>Left     | move_window_left_workspace_key
<Primary><Shift><Alt>Up       | move_window_up_workspace_key
<Primary><Shift><Alt>Down     | move_window_down_workspace_key
#
# Ctrl+Shift+<keypad> => tile window in different directions
#
<Primary><Shift>7    |  tile_up_left_key
<Primary><Shift>4    |  tile_left_key
<Primary><Shift>6    |  tile_right_key
<Primary><Shift>2    |  tile_down_key
<Primary><Shift>8    |  tile_up_key
<Primary><Shift>9    |  tile_up_right_key
<Primary><Shift>1    |  tile_down_left_key
<Primary><Shift>3    |  tile_down_right_key
#
# Ctrl+Shift+<keypad5> twice will move a tiled window to its original
# position
#
<Primary><Shift>5      |  maximize_vert_key
<Primary><Shift><Alt>M | move_window_key
EOF
) | while read row; do
    if echo ${row} | egrep -q '^[ ]*#'; then
        # skip comments
        continue
    fi
    shortcut=$(echo ${row} | awk -F'|' '{print $1}' | xargs)
    command=$(echo ${row}  | awk -F'|' '{print $2}' | xargs)
    echo "adding xfce keyboard shortcut: \"${shortcut}\" => \"${command}\""
    # xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/commands/default/${shortcut}"
    # xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/commands/custom/${shortcut}"
    # xfconf-query --reset  --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/${shortcut}"
    xfconf-query --create --channel xfce4-keyboard-shortcuts --property "/xfwm4/custom/${shortcut}" --type string --set "${command}"
done

#
# Set up command shortcuts
#

(cat <<EOF
<Alt>F1               |  xfce4-popup-applicationsmenu
<Alt>F2               |  xfce4-appfinder --collapsed
<Alt>F3               |  xfce4-appfinder
<Primary><Alt>Delete  |  xflock4
<Primary><Alt>l       |  xflock4
<Primary><Alt>t       |  xfce4-terminal
<Super>a              |  xfce4-appfinder
# Full screen screenshot
<Alt>Insert           | xfce4-screenshooter -f
# Focused window screenshot
<Primary><Alt>Insert  | xfce4-screenshooter -w
#
# Mouse pointer movement with Super+arrow. Additional modifier keys
# to move slower:
# Super+arrow            => move mouse pointer (long)
# Super+Alt+arrow        => move mouse pointer (medium)
# Super+Alt+Ctrl+arrow   => move mouse pointer (short)
# <Super>+,              => left mouse click
# <Super>+.              => right mouse click
#
<Super>Left                | xdotool mousemove_relative -- -120 0
<Super>Right               | xdotool mousemove_relative --  120 0
<Super>Up                  | xdotool mousemove_relative --  0 -120
<Super>Down                | xdotool mousemove_relative --  0  120
<Super><Alt>Left           | xdotool mousemove_relative -- -40 0
<Super><Alt>Right          | xdotool mousemove_relative --  40 0
<Super><Alt>Up             | xdotool mousemove_relative --  0 -40
<Super><Alt>Down           | xdotool mousemove_relative --  0  40
<Super><Alt><Primary>Left  | xdotool mousemove_relative -- -10 0
<Super><Alt><Primary>Right | xdotool mousemove_relative --  10 0
<Super><Alt><Primary>Up    | xdotool mousemove_relative --  0 -10
<Super><Alt><Primary>Down  | xdotool mousemove_relative --  0  10
<Super>comma               | xdotool click 1
<Super>period              | xdotool click 3
EOF
) | while read row; do
    if echo ${row} | egrep -q '^[ ]*#'; then
        # skip comments
        continue
    fi
    shortcut=$(echo ${row} | awk -F'|' '{print $1}' | xargs)
    command=$(echo ${row}  | awk -F'|' '{print $2}' | xargs)
    echo "adding xfce keyboard shortcut: \"${shortcut}\" => \"${command}\""
    xfconf-query --create --channel xfce4-keyboard-shortcuts --property "/commands/custom/${shortcut}" --type string --set "${command}"
done
