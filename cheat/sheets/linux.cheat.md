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


## Docker

Remove unused docker data. This will remove all stopped containers, all networks
not used by at least one container, all dangling images, all dangling build
cache.

    docker system prune


## Performance troubleshooting (at Netflix)
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
Other tools useful for network troubleshooting: `iftop`, `bmon`
