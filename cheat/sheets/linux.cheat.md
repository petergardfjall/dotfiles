# About
This document contains an unsorted collection of linux-related admin tasks.


## User management

Normal users:

    sudo adduser newuser
    sudo addgroup newgroup

    # add to group 'sudo'
    usermod -aG sudo newuser

    sudo deluser --remove-home newuser

System users:

    sudo adduser --system sysuser
    sudo addgroup --system sysgroup


## Key management

Create an `ssh` key:

    ssh-keygen -f mykey
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"


## Processes

Process relationships can be shown with `pstree`:

    # processes rooted at a certain pid
    pstree <pid>
    # for a certain user
    pstree <user>


## Disk usage
Report system disk space usage:

    # for all partitions
    df -h
    # only for partition where <dir> is at
    df -h /some/dir

Disk usage in a directory tree

    # note: the -h flag to `sort`
    du -h | sort -h
    du -h --max-depth=1 | sort -h


## Filesystem encryption

Generally speaking, full disk encryption should be used for sensitive data,
since directory encryption typically misses out on alternative sources where
sensitive data can be picked up, such as `/tmp`, log/database files (`/var`),
the file system cache, swap space, etc.

In case of a shared computer, one might not want a single shared password
between users. Also one might want to complement full disk encryption with
directory-level encryption (with a secret selected by the user). For these
cases, there are solutions that operate using a stacked encrypted filesystem
like `gocryptfs` (which operates in userspace -- FUSE) or one that operates in
kernel space such as `fscrypt`.

A good overview of options is provided on the Arch Linux wiki page about "data
at rest".

An example with `gocryptfs`:

    mkdir dir.enc dir
    # enter secret password and ALSO TAKE NOTE of the "emergency master key"
    gocryptfs -init dir.enc/

    # mount: need to enter secret password
    gocryptfs dir.enc/ dir

    # the encrypted directory can stay mounted for the user session, or be
    # unmounted manually
    fusermount -u dir

An example with `fscrypt`, which is a high-level tool for managing linux
filesystem encryption (the kernel part is sometimes also referred to as
`fscrypt`):

    # Check which directories on our system support encryption
    fscrypt status

    # first-time initialization to create global configuration files:
    # `/etc/fscrypt.conf` and `/.fscrypt`
    sudo fscrypt setup

    # If file system on which encryption is to be used isn't the root file
    # system, it needs to be prepared for use. This creates the directory
    # `<mountpoint>/.fscrypt` to store fscrypt policies and protectors.
    sudo fscrypt setup <mountpoint>     # e.g. `fscrypt setup /home`

    # initialize encryption on a new empty directory
    mkdir <mountpoint>/dir1
    # will be prompted for which protector to use, select `pam_passphrase`
    # to have a protector that uses login password to unlock the directory.
    fscrypt encrypt <mountpoint>/dir1

    # show encryption status
    fscrypt status <mountpoint>/dir1

    # lock/unlock an encrypted directory
    fscrypt lock <mountpoint>/dir1
    fscrypt unlock <mountpoint>/dir1

To encrypt a home directory:

    sudo -i
    mv /home/<user>/ /home/<user>.original
    mkdir /home/<user> && chown -R <user>:<user> /home/<user>/
    fscrypt encrypt /home/<user> --user <user>
    cp -a -T /home/<user>.original /home/<user>
    rm -rf /home/<user>.original


## Docker

Remove unused docker data. This will remove all stopped containers, all networks
not used by at least one container, all dangling images, all dangling build
cache.

    docker system prune


## Archiving

### tar

Regular directory compression:

    # gzip-compressed tar with the content of foo.git/ and foo.git/ as the
    # first entry
    $ tar czvf foo.tar.gz foo.git/
    $ tar tzvf foo.tar.gz
    foo.git/
    foo.git/HEAD
    foo.git/hooks/
    ...

"Ground directory compression" (select a particular subtree):

    # gzip-compressed tar with the content of foo.git/ and foo.git/* as
    # immediate entries
    # first entry
    $ tar czvf foo.tar.gz -C foo.git/ .
    $ tar tzvf foo.tar.gz
    ./
    ./HEAD
    ./hooks/
    ...

Decrompress a `tar.gz` to a particular destination directory with `-C`:

    tar xzvf foo.tar.gz -C foo/

Strip first directory level:

    tar xf archive.tar --strip-components=1

## Zip

Regular directory compression:

    zip -r archive.zip dir/ foo-0.8.1.orig/

Add multiple entries:

    zip -r archive.zip dir1/ dir2/ file1 file2

List content of zip file:

    unzip -l archive.zip

Unzip to a different destination directory

    unzip archive.zip -d /dest/path

## Hardware information commands

List high-level details about your system on a software-level (distro, kernel,
desktop) and hardware-level (CPU, graphics, audio, networking, drives,
partitions, sensors).

    # note: -z masks out personally identifying information like MAC/IP address
    inxi -Fxz

Similar information (but with more details concerning e.g. memory hardware and
network interfaces) can be obtained with:

    lshw -short

*CPU details*: either `lshw -C cpu` or `lscpu`.

    sudo lshw -C cpu
    lscpu | grep -i "Model name"

*Memory details*: either `dmidecode -t memory` or `lshw -C memory`

    # list each memory stick and its capacity
    sudo dmidecode -t memory
    # show cache sizes and memory cards
    sudo lshw -short -C memory

*Disks and filesystems*:

    # display one line for each disk device
    sudo lshw -short -C disk

    # list disks with all their defined partitions and mount points
    lsblk

    # list disks (devices and mountpoints) with used space
    df -h

*Network*:

    # shod details about network card
    sudo lshw -C network

    # show network interfaces
    ifconfig -a

    # more commonly used these days
    ip link show

    # show default gateway and routing tables
    ip route | column -t
    route -n
    netstat -r

    # list open tcp and udp listening ports and the owning processes
    sudo netstat -lnptu


*PCI devices*: `lspci` shows information about PCI buses and connected devices.

    # list all PCI devices with domain/bus/device identifiers (like '00:00.0')
    # in the left-most column. for example search for graphics card
    $ sudo lspci | grep -i vga
    01:00.0 VGA compatible controller: NVIDIA Corporation G98 [Quadro NVS 295] (rev a1)

    # now show more details about that card
    sudo lspci -v -s 01:00.0

## Performance troubleshooting commands
At the Netflix Performance Engineering team, the first 60 seconds of an
optimized performance investigation at the command line might look like this:

- `uptime`: a quick way to view load averages. This gives a high level idea of
  resource load (or demand), but can't be properly understood without other
  tools. The three numbers are exponentially damped moving sum averages with a 1
  min, 5 min, and 15 min constant. In the example below, the load averages show
  a recent increase, hitting 30 for the 1 minute value, compared to 19 for the
  15 minute value. That the numbers are this large means a lot of something:
  probably CPU demand; `vmstat` or `mpstat` will confirm.

        $ uptime
        23:51:26 up 21:31, 1 user, load average: 30.02, 26.43, 19.02

- `dmesg | tail`: views the last 10 system messages, if there are any. Look for
  errors that can cause performance issues. The example includes the oom-killer,
  and TCP dropping a request.

        $ dmesg | tail
        [1880957.563150] perl invoked oom-killer: gfp_mask=0x280da, order=0, oom_score_adj=0
        [...]
        [1880957.563400] Out of memory: Kill process 18694 (perl) score 246 or sacrifice child
        [1880957.563408] Killed process 18694 (perl) total-vm:1972392kB, anon-rss:1953348kB, file-rss:0kB
        [2320864.954447] TCP: Possible SYN flooding on port 7001. Dropping request.  Check SNMP counters.

- `vmstat 1`: Short for virtual memory stat (1 second summary). It prints a
  summary of key server statistics on each line. Colums to check:

  - `r`: Number of processes running on CPU and waiting for a turn. This
    provides a better signal than load averages for determining CPU saturation,
    as it does not include I/O. To interpret: an `r` value greater than the CPU
    count is saturation.

   - `free`: Free memory in kilobytes. If there are too many digits to count,
     you have enough free memory. Use `free -mh` for more details.

   - `si`, `so`: Swap-ins and swap-outs. If these are non-zero, you're out of
     memory.

   - `us`, `sy`, `id`, `wa`, `st`: breakdowns of CPU time, on average across all
     CPUs. They are user time, system time (kernel), idle, wait I/O, and stolen
     time (by other guests, or with Xen, the guest's own isolated driver
     domain).

  The CPU time breakdowns will confirm if the CPUs are busy, by adding user +
  system time. A constant degree of wait I/O points to a disk bottleneck; this
  is where the CPUs are idle, because tasks are blocked waiting for pending disk
  I/O. You can treat wait I/O as another form of CPU idle, one that gives a clue
  as to why they are idle.

  System time is necessary for I/O processing. A high system time average, over
  20%, can be interesting to explore further: perhaps the kernel is processing
  the I/O inefficiently.  If CPU time is almost entirely in user-level, that
  points to application level usage instead.


- `mpstat -P ALL 1`: prints CPU time breakdowns per CPU, which can be used to
  check for an imbalance. A single hot CPU can be evidence of a single-threaded
  application.


- `pidstat 1`: a little like `top`'s per-process summary, but prints a rolling
  summary instead of clearing the screen. This can be useful for watching
  patterns over time, and also recording what you saw (copy-n-paste) into a
  record of your investigation.

- `iostat -xz 1`: for understanding block devices (disks), both the workload
  applied and the resulting performance.

  - `r/s`, `w/s`, `rkB/s`, `wkB/s`: These are the delivered reads, writes, read
    Kbytes, and write Kbytes per second to the device. Use these for workload
    characterization. A performance issue may simply be due to excessive load.

  - `await`: The average time for the I/O in milliseconds. This is the time that
    the application suffers, as it includes both time queued and time being
    serviced. Larger than expected average times can be an indicator of device
    saturation, or device problems.

  - `avgqu-sz`: The average number of requests issued to the device. Values
    greater than 1 can be evidence of saturation (although devices can typically
    operate on requests in parallel, especially virtual devices which front
    multiple back-end disks.)

  - `%util`: Device utilization. This is really a busy percent, showing the time
    each second that the device was doing work. Values greater than 60%
    typically lead to poor performance (which should be seen in await), although
    it depends on the device. Values close to 100% usually indicate saturation.

- `free -mh`: We just want to check that these aren't near-zero in size, which
  can lead to higher disk I/O (confirm using `iostat`), and worse performance.
  Linux uses free memory for the caches, but can reclaim it quickly if
  applications need it. So in a way the `buff/cache` memory should be included
  in the `free` memory column.

- `sar -n DEV 1`: Use this tool to check network interface throughput: rxkB/s
  and txkB/s, as a measure of workload, and also to check if any limit has been
  reached. Look for high bandwidths and high `%ifutil`.

- `sar -n TCP,ETCP 1`: This is a summarized view of some key TCP metrics. These include:

  - `active/s`: Num locally-initiated TCP connections/s (`connect()`s).

  - `passive/s`: Num remotely-initiated TCP connections/s (`accept()`s).

  - `retrans/s`: Number of TCP retransmits per second.

  The active and passive counts are often useful as a rough measure of server
  load: number of new accepted connections (passive), and number of downstream
  connections (active). It might help to think of active as outbound, and
  passive as inbound, but this isn't strictly true (e.g., consider a localhost
  to localhost connection).

  Retransmits are a sign of a network or server issue; it may be an unreliable
  network (e.g., the public Internet), or it may be due a server being
  overloaded and dropping packets.

- `top`: includes many of the metrics mentioned earlier. Can be handy to run to
  see if anything looks wildly different from the earlier commands, which would
  indicate that load is variable.

  A downside is that it is harder to see patterns over time, which may be more
  clear in tools like `vmstat` and `pidstat`, which provide rolling
  output. Evidence of intermittent issues can also be lost if you don't pause
  the output quick enough (`Ctrl-S` to pause, `Ctrl-Q` to continue), and the
  screen clears.


## Network troubleshooting
TODO: Other tools useful for network troubleshooting: `iftop`, `bmon`
`ifconfig` `ip link show`
`ip route | column -t`, `route`
`netstat`
`lsof`

## Fonts
List available fonts:

    fc-list
    fc-list : family style file spacing

Install a new font by downloading the `.ttf` files that define the font to
either `/usr/share/fonts/` (global installation) or `~/.local/share/fonts/`
(user installation). Then regenerate the font cache with `fc-cache -f`.

    mkdir -p ~/.local/share/fonts
    cp SourceCodePro-*.ttf ~/.local/share/fonts
    # regenerate font cache
    fc-cache -f


## Copy changed files
Sometimes one wants to copy all changes made to a directory in one place (say
host A) and apply those changes to a different directory (say on host
B). `rsync` can be used for this:

    # NOTE the trailing slash (it means 'the contents of path' rather than
    # 'path' itself)
    rsync --update -av --dry-run user@host:/path/ .


## Laptop as desktop
When the laptop is used as a desktop computer (connected to an external display)
it's nice to be able to run with the lid closed to keep things tidy looking.

1. Prevent machine from suspending when lid is closed. Add the following setting
   to `/etc/systemd/logind.conf`:

        HandleLidSwitch=ignore

   Restart the login daemon: `sudo systemctl restart systemd-logind` for the
   setting to take effect.

   *NOTE*: also make sure there are no xfce power manager user settings that
   could interfere.

2. Next, we'd like the lock screen to not blank and freeze: Update
   `/usr/bin/xflock4`: make sure it runs the lightdm greeter by adding this
   first in the list processed by the `for lock_cmd in` loop:

        dm-tool switch-to-greeter

3. For the lightdm greeter to appear on the display where the cursor is at, we
   set `active-monitor=#cursor` in `/etc/lightdm/lightdm-gtk-greeter.conf`.


## List kernel configuration
Kernal configuration parameters/variables, such as `CONFIG_FS_ENCRYPTION`, can
be found via:

    cat /boot/config-$(uname -r)


## Close user processes on logout
If `systemd` is built with `--without-kill-user-processes`, setting
`KillUserProcesses` is set to no by default. This setting causes user processes
not to be killed when the user logs out. To change this behavior in order to
have all user processes killed on the user's logout, set `KillUserProcesses=yes`
in `/etc/systemd/logind.conf`

Note that changing this setting breaks terminal multiplexers such as tmux and
GNU Screen.
