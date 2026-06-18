# About

Explains use of a few common backup tools.

## restic

Works well for full system backups.

### Initialize a backup repository

To host the backup repository on Google Drive requires `rclone`. First,
initialize an `rclone` remote:

    # Create a Google Drive (drive) remote named "gdrive".
    # You will be asked for consent to create an OAuth token, but a
    # better option (higher quota) is to pass client_id and client_secret
    # for an OAuth2.0 client (for more details, see the rclone section).
    #
    # A "gdrive" remote will be set up in ${HOME}/.config/rclone/rclone.conf
    rclone config create gdrive drive

Then initialize the backup repository (you will be prompted for a password to
protect repository access):

    restic init -r rclone:gdrive:/backups/restic/${HOSTNAME}

### Backup

Back up to the remote Google Drive repository initialized earlier. A file with
`filepath.Match` compatible expressions (that support the `**` wildcard) can be
used to filter out disposable files. Use the `--dry-run` and `-vv` flags to see
what will be backed up.

    export RESTIC_PASSWORD="<password>"
    export RESTIC_PACK_SIZE=64 # MiB
    export RESTIC_REPOSITORY=rclone:gdrive:/backups/restic/${HOSTNAME}
    restic backup ${HOME} --exclude-file ~/backups/restic-excludes.txt

### Incremental backup

Simply run the `backup` command again to create a new snapshot. `restic` uses
the existing snapshot to deduplicate.

    restic backup ${HOME} --exclude-file ~/backups/restic-excludes.txt

### Watch remote contents (list snapshots)

    export RESTIC_REPOSITORY=rclone:gdrive:/backups/restic/${HOSTNAME}
    # List snapshots.
    restic snapshots
    # List files in latest snapshot.
    restic ls latest

Alternatively mount the repository snapshot and browse it in the filesystem:

    # Note: mount goes away on ctrl-c.
    restic mount /tmp/mnt

### Full restore to a <directory>

    restic restore latest --target /tmp/restored

### Restore of a certain folder/file

To selectively `restore` a specific file/folder from a snapshot, use the
`--include` (`-i`) flag:

    export RESTIC_REPOSITORY=rclone:gdrive:/backups/restic/${HOSTNAME}
    restic restore <snapshot-id> --target /tmp/restored --include /path/in/backup

## Rclone

Works well for backing up a smaller number of files or just generally
transferring stuff to and from the cloud.

### Initialize a Google Drive remote

Just running the below command will offer to create an OAuth 2.0 token for us,
however that token appears to come with very low limits, which is why it is
better to first create a personal OAuth2.0 Google API client and pass its
`client_id` and `client_secret` to `rclone`.

    rclone config create gdrive drive

The procedure for creating an OAuth2.0 client for the Google API is laid out
here: https://console.cloud.google.com/apis/credentials. In short:

1. Select/Create a Google Cloud Project
2. Enable Google Drive API: `APIs & Services` > `+ Enable APIs ...` >
   `Google Drive`
3. Configure OAuth consent screen: `APIs & Services` > `OAuth consent screen`
4. Create an OAuth Client ID and secret: `APIs & Services` > `Credentials` (note
   down the `client_id` and `client_secret`).
5. Set up `rclone` to use the client: when running: paste `client_id` and
   `client_secret` when prompted by `rclone config`.

A remote named `gdrive` will be set up in `${HOME}/.config/rclone/rclone.conf`

### Backup

Back up to the "gdrive" Google Drive remote initialized earlier:

    rclone sync -v --progress gdrive:backups/${HOSTNAME} ${HOME} \
       --exclude-from ~/backups/rclone-exclude.txt

### Watch remote contents

List folders:

    rclone lsd gdrive:<folder>

List files (recursive):

    rclone ls gdrive:<folder>

List files (shallow):

    rclone ls --max-depth=2 gdrive:<folder>

### Full restore to a local folder

    rclone copy gdrive:/folder/path /tmp/restored
