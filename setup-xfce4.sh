#!/bin/bash

set -e

ts=$(date +%Y%m%d-%H%M)

function info () {
    echo -e "\e[32m${1}\e[0m"
}

function warn () {
    echo -e "\e[32m${1}\e[0m"
}

#
# Links xfce4 settings files from ~/.config/xfce4/
# Any existing files are backed up under ~/.config/xfce4/backup.
#

scriptdir=$(dirname ${0})

src=~/dotfiles/xfce4
dest=~/.config/xfce4
backup=~/.config/xfce4/backup

mkdir -p ${dest}
mkdir -p ${backup}

# Kill the running xfconfd since otherwise it will overwrite our custom
# xfce4-panel.xml with the session panel. We'll restart it at the end of the
# script by restarting the xfce4-panel.
warn "temporarily killing xfconfd ..."
pkill xfconfd || warn "xfconfd does not appear to be running ..."

# for each flie in ~/dotfiles/xfce4/, make a symlink to it from
# ~/.config/xfce4
for file in $(cd ${src} && find -type f | sed 's#^./##'); do
    if [ -h ${dest}/${file} ]; then
        info "symlink already exists for ${dest}/${file}. Ignoring ..."
        continue
    fi

    if [ -e ${dest}/${file} ]; then
        # destination exists => take backup
        warn "${file} file exists in ${dest}. Moving to ${backup} ..."
        backup_path="${backup}/${ts}-${file}"
        # ensure backup directory exists
        backup_dir=$(dirname ${backup_path})
        mkdir -p ${backup_dir}
        mv ${dest}/${file} ${backup_path}
    fi

    destpath="${dest}/${file}"
    info "linking ${destpath} => ${src}/${file} ..."
    # ensure destination directory exists
    destdir=$(dirname ${destpath})
    mkdir -p ${destdir}
    ln -s ${src}/${file} ${destpath}
done

info "restarting xfce4-panel (should restart xfconfd) ..."
# may not be possible when not in X11 mode
xfce4-panel --restart || warn "could not restart xfce4-panel, not in graphical mode?"
# this should take care of restarting xfcond when not in X11 mode
xfconf-query --list > /dev/null 2>&1

echo "setting up xfce keyboard shortcuts ..."
${scriptdir}/setup-xfce4-keyboard-shortcuts.sh

echo "applying some general xfce settings ..."
# Disable not zoom desktop on Alt+mousewheel.
xfconf-query --set false --channel xfwm4 --property /general/zoom_desktop
# Disable mousewheel workspace switching.
xfconf-query --set false --channel xfwm4 --property /general/scroll_workspaces
