# dotfiles

This is a collection of dot files that I find useful in my day-to-day work. Feel
free to use them.

# Installation instructions

1. Install git
2. Run the following in a terminal

   ```bash
   cd ~ && git clone --recursive https://github.com/petergardfjall/dotfiles.git`
   ```

You now have the dotfiles directory/git repository in your home folder.

## xfce window manager

Run the following script to populate the `~/config/xfce4` directory with
symlinks to the xfce4 settings files in this repo:

```bash
~/dotfiles/setup-xfce4.sh
```

You need to log out and log back in for all changes to take effect.

## emacs

Assuming no prior emacs configuration, you can simply run the following command:

```bash
ln -s ~/dotfiles/emacs-init.el ~/.emacs
```

## vim

Install the [Vundle](https://github.com/VundleVim/Vundle.vim) plugin manager and
make use of the `.vimrc` provided in this directory.

```bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
ln -s ~/dotfiles/vim/vimrc ~/.vimrc
```

NOTE: on first launch of `vim`, run `:PluginInstall` to have Vundle install the
plugins configured in `vimrc`.

## Visual Studio Code

```bash
mkdir -p ~/.config/Code/User/
sudo ln -sfn ~/dotfiles/vscode/settings.json ~/.config/Code/User/settings.json
sudo ln -sfn ~/dotfiles/vscode/keybindings.json ~/.config/Code/User/keybindings.json
# install extensions
~/dotfiles/vscode/install-extensions.sh
```

## bash

The `~/dotfiles/bash/` directory contains additional files to load into your
shell environment. Any secrets/host-specific settings should be placed under the
`~/dotfiles/bash/bash.local/` directory and are ignored by this git repo.

Append the following to your `~/.bashrc` file

```bash
#
# source additional configuration modules
#
source ~/dotfiles/bash.includes
```

Then append the following to your `~/.profile` file:

```bash
#
# source additional configuration modules
#
source ~/dotfiles/bash.includes
```
