# dotfiles
This is a collection of dot files that I find useful in my day-to-day work.
Feel free to use them.

# Installation instructions

1. Install git
2. Run the following in a terminal `cd ~ && git clone https://github.com/petergardfjall/dotfiles.git`

You now have the dotfiles directory/git repository in your home folder.

## emacs

Assuming no prior emacs configuration, you can simply run the following command:
    
    ln -s ~/dotfiles/emacs.init ~/.emacs

If you have prior emacs configuration, simply append the code in `~/dotfiles/emacs.init` to your `~/.emacs` file.

## bash

Append the following to your `~/.bashrc` file

    #
    # source additional configuration modules
    #
    for f in $(ls ~/dotfiles/bash/*); do
        source $f
    done

Then append the following to your `~/.profile` file:

    #
    # source additional configuration modules
    #
    for f in $(ls ~/dotfiles/profile/*); do
        source $f
    done

## screen
If you don't already have a screen configuration file, use the provided one by running:

    ln -s ~/dotfiles/screen/screenrc ~/.screenrc
