#!/bin/bash

#
# Links xfce4 settings files from ~/.config/xfce4/
# Any existing files are backed up under ~/.config/xfce4/backup.
#

src=~/dotfiles/xfce4
dest=~/.config/xfce4
backup=~/.config/xfce4/backup

mkdir -p ${dest}

for file in $(ls -1 ~/dotfiles/xfce4); do
    if [ -f ${dest}/${file} ]; then
	# destination exists => take backup
	echo "[INFO] ${file} exists in ${dest}. Backing up to ${backup} ..."
	mkdir -p ${backup}
	cp -r ${dest}/${file} ${backup}/${file}
    fi

    echo "[INFO] linking ${dest}/${file} => ${src}/${file} ..."
    ln -s ${src}/${file} ${dest}/${file}
done
