## Basic commands

Create a key (stored under `~/gnupg/pubring.gpg`):

    gpg --gen-key

To list the keys in your public key ring:

    gpg --list-keys

To list the keys in your secret key ring:

    gpg --list-secret-keys


Delete a key-pair:

    # first delete private key (from private key ring):
    gpg --delete-secret-key "ID/name/email"
    # then delete public key (from public key ring):
    gpg --delete-key "ID/name/email"


## Encrypt/decrypt
Encrypt a file `secret.txt` with a given secret key. The output is written to
`secret.txt.gpg`:

    gpg -e -r "ID/name/email" secret.txt

Decrypt a file `secret.txt.gpg` and write the result to `secret.txt`. `gpg`
automatically finds the right decryption key and prompts you with a password.

    gpg -d -o secret.txt secret.txt.gpg


To encrypt symmetrically (with just a passphrase) use. The output is written to
`secret.txt.gpg`:

    gpg --symmetric secret.txt
    # prompt for password should appear

To decrypt symmetrically (with just a passphrase) use:

    gpg -d -o secret.txt secret.txt.gpg


## Import/export

To transfer a key-pair to a different computer:

    #
    # export
    #
    gpg --export -a "ID/name/email" > key.pub
    gpg --export-secret-keys -a "ID/name/email" > key.pri

    #
    # import (on a different host)
    #
    # adds the key.pub to your public key ring.
    gpg --import key.pub
    # adds the key.pri to your private key ring.
    gpg --import key.pri


## Edit a key password
Change the key password of the key.

    gpg --edit-key <KEY-ID>
    # this will enter the gpg prompt
    > passwd
    # you will be prompted for your old password
    # and then for your new password (twice)

    # when done, save
    > save


## Change the password entry method

In X environments, the `gpg-agent` will open a dialog for password entry. In
non-X environments, for example on SSH logins, this is not suitable. The
pinentry program can be specified in `~/.gnupg/gpg-agent.conf`:

    sudo apt-get install pinentry-tty

    sudo ~/.gnupg/gpg-agent.conf <<EOF
    pinentry-program /usr/bin/pinentry-tty
    EOF

Restart the `gpg-agent` which makes it forget cached passwords and reload
configurations:

    echo RELOADAGENT | gpg-connect-agent

