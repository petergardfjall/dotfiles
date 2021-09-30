# APT (Advanced Package Tool) commands

- `apt-get`: APT's package handling utility. A robust dependency resolver, more
  scripting-compatible, and less intensive in terms of resource consumption than
  `apt`.
- `apt-cache`: display and search information stored in APT's internal
  database. It's a cache in the sense that it operates on the latest retrieved
  sources listed in the `sources.list` file.
- `apt`: a more user-friendly frontend for `apt-get` and `apt-cache`

# Debian archives
For more details see "Debian package management internals" in the "Debian
Reference".

Meta data files for each distribution are stored under `dist/<codename>` on each
Debian mirror site, like "http://deb.debian.org/debian/". Key files:

- `Release`: dist-level archive description and integrity information.
  `http://deb.debian.org/debian/dists/stretch/Release`
- `Release`: archive-level description.
  `http://deb.debian.org/debian/dists/stretch/main/binary-amd64/Release`
- `Packages`: concatenated debian/control file for binary packages.
  `<repo>/dists/<dist>/<area>/binary-<arch>/Packages.gz`
  `http://deb.debian.org/debian/dists/stretch/main/binary-amd64/Packages.gz`
- `Sources`: concatenated debian/control file for source packages.
  `<repo>/dists/<dist>/<area>/source/Sources.gz`
  `http://deb.debian.org/debian/dists/stretch/main/source/Sources.gz`


# Configuration
To see all configuration settings for `apt`:

    # `man apt.conf` for descriptions
    apt-config dump

# Upgrade
The `apt upgrade` command is used to install available upgrades of all packages
currently installed on the system. The upgrade is controlled; under no
circumstances are currently installed packages removed, or packages not already
installed retrieved and installed. New versions of currently installed packages
that cannot be upgraded without changing the install status of another package
will be left at their current version.

If you want to upgrade, while allowing packages to be added or removed to
fulfill dependencies, use the `apt dist-upgrade` sub command.

# APT key management
APT uses GPG signatures to ensure integrity. `apt-key` can be used to manage
trusted keys.

    # list keys
    apt-key list

    # add GPG file
    # NOTE: instead of this command a keyring can be placed
    #       directly in the /etc/apt/trusted.gpg.d/ directory with a
    #       descriptive name and either "gpg" or "asc" file extension.
    apt-key add <file>
    cat <file> | apt-key add -

    # delete key
    apt-key del <keyid>

# Reinstall
To completely reinstall a package run (for example to replace mistakenly deleted
files):

    apt install --reinstall openjdk-11-jdk

# Show installed packages:

    apt list --installed

# List packages known to apt/dpkg

    # displays the list of all the packages that appear in the cache
    apt-cache pkgnames

    # displays the headers of all available versions of all packages
    apt-cache dumpavail


# Show metadata/contents of a package
Show information about a package:

    apt-cache show openjdk-11-jdk

Show available versions of a package:

    # nice tabular format
    apt-cache madison perl

    apt-cache show perl | grep Version

List file contents of a package:

    dpkg -L openjdk-11-jdk

Show dependencies of a package:

    apt-cache depends openjdk-11-jdk
    # only print `Depends` and `Pre-Depends` relations
    apt-cache depends --important openjdk-11-jdk

    # show available versions, reverse (downstream) dependencies, and
    # forward  (upstream) dependencies for each version.
    apt-cache showpkg openjdk-11-jdk

Show dependencies of a package recursively:

    apt-cache depends --recurse --important perl

From which apt repo does a package come from:

    # the repo should be deducable from the control file
    # `/var/lib/apt/lists/<repo>` (slashes are substituted or underscores)
    apt-cache showpkg google-chrome-stable

# Search package names/descriptions by regexp

Show all packages containing `ssh` in name or descriptions:

    apt-cache search ssh


# Search for package that owns a file
Search package that contains a given file:

    dpkg -S /usr/lib/jvm/java-11-openjdk-amd64/bin/jconsole

In some cases one needs to search for the right path. For example:

    $ dpkg -S /usr/lib/jvm/default-java/bin
    dpkg-query: no path found matching pattern /usr/lib/jvm/default-java/bin

    $ dpkg -S /usr/lib/jvm/default-java/
    default-jre-headless: /usr/lib/jvm/default-java

# Why is a package installed?

    $ aptitude why ruby
    i   vagrant Depends ruby
