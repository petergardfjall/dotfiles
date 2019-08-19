## Set up

Pass uses `gpg` for decryption and encryption of the passwords (in fact, `pass`
uses `gpg2`, so ensure its installed).

Initialize a password store with a particular PGP key:

    pass init <gpg-id or email>

Note that you need to trust the key:

    $ gpg --edit-key <gpg-id or email>
    ...
    gpg> trust
    ...
    Please decide how far you trust this user to correctly verify other users' keys
    (by looking at passports, checking fingerprints from different sources, etc.)

      1 = I don't know or won't say
      2 = I do NOT trust
      3 = I trust marginally
      4 = I trust fully
      5 = I trust ultimately
      m = back to the main menu

    Your decision? 5
    Do you really want to set this key to ultimate trust? (y/N) y
    ...
    gpg> save

Environment variables can be used to alter where `pass` looks to do store and
`git` operations via:

    PASSWORD_STORE_DIR=/path/to/store

One can use aliases to set up different pass contexts, which helps when
collaborating with different teams. For example, add aliases to your
`~/.bashrc`:

    alias passred="PASSWORD_STORE_DIR=~/.pass/red pass"
    alias passblue="PASSWORD_STORE_DIR=~/.pass/blue pass"

Add these for bash-completion to your `~/.bash_completion` and make sure
`bash-completion` is installed:

    source /usr/share/bash-completion/completions/pass

    _passred(){
        PASSWORD_STORE_DIR=~/.pass/red/ _pass
    }
    complete -o filenames -o nospace -F _passred passred

    _passblue(){
        PASSWORD_STORE_DIR=~/.pass/blue/ _pass
    }
    complete -o filenames -o nospace -F _passblue passblue

Now you can initialize into `~/.pass/red` and `~/.pass/blue` and have two pass
contexts with the `passred` and `passblue` aliases. You can generalize this
further into as many contexts as you like.

    # get password in red context
    passred /red/pass

    # insert context in blue context
    passblue insert /blue/password


## Basic usage

Create a new password, with a descriptive hierarchical name.

    pass insert archlinux.org/wiki/username

Generate a new random password (`n` is the desired password length):

    pass generate archlinux.org/wiki/username <n>

Retreive a password, (enter the gpg passphrase at the prompt):

    pass archlinux.org/wiki/username

Users of Xorg with `xclip` installed can retrieve the password directly onto the
clipboard temporarily (it gets cleared after a few seconds):

    pass -c archlinux.org/wiki/username

Remove a password:

    pass rm archlinux.org/wiki/username


## Version control

Create a Git repository for `pass`. Either, create a private
github/gitlab/bitbucket repo or run `git init --bare ~/.password-store` to
create a bare repository you can push to.

    # Create local password store
    pass init <gpg key id>
    # Enable management of local changes through Git
    pass git init
    # Add the the remote git repository as 'origin'
    pass git remote add origin user@server:~/.password-store
    # Push your local Pass history
    pass git push -u --all

Now you can use the standard `git` commands, prefixed by `pass`. For example:
`pass git add`, `pass git commit`, `pass git push`, or `pass git pull`. Pass
will automatically create commits when you use it to modify your password store.

## More details

https://www.passwordstore.org/
https://wiki.archlinux.org/index.php/Pass
