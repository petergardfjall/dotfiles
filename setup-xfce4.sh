#!/bin/bash

set -e

#
# Links xfce4 settings files from ~/.config/xfce4/
# Any existing files are backed up under ~/.config/xfce4/backup.
#

scriptdir=$(dirname ${0})

src=~/dotfiles/xfce4
dest=~/.config/xfce4
backup=~/.config/xfce4/backup

mkdir -p ${dest}

for file in $(ls -1 ~/dotfiles/xfce4); do
    if [ -h ${dest}/${file} ]; then
	echo "[WARN] symlink already exists for ${dest}/${file}. Ignoring ..."
	continue
    fi

    if [ -e ${dest}/${file} ]; then
	# destination exists => take backup
	echo "[INFO] ${file} exists in ${dest}. Moving to ${backup} ..."
	mkdir -p ${backup}
	mv ${dest}/${file} ${backup}/${file}
    fi

    echo "[INFO] linking ${dest}/${file} => ${src}/${file} ..."
    ln -s ${src}/${file} ${dest}/${file}
done

echo "[INFO] setting up xfce keyboard shortcuts ..."
${scriptdir}/setup-xfce4-keyboard-shortcuts.sh
