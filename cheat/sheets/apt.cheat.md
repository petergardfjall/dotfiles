
# Upgrade

The `apt upgrade` command is used to install available upgrades of all packages
currently installed on the system. The upgrade is controlled; under no
circumstances are currently installed packages removed, or packages not already
installed retrieved and installed. New versions of currently installed packages
that cannot be upgraded without changing the install status of another package
will be left at their current version.

If you want to upgrade, while allowing packages to be added or removed to
fulfill dependencies, use the `apt dist-upgrade` sub command.


# Reinstall
To completely reinstall a package run (for example to replace mistakenly deleted
files):

    apt install --reinstall openjdk-11-jdk

# Show installed packages:

    apt list --installed


# Show metadata/contents of a package
Show information about a package:

    apt-cache show openjdk-11-jdk

List file contents of a package:

    dpkg -L openjdk-11-jdk

Show dependencies of a package:

    apt-cache showpkg openjdk-11-jdk


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
