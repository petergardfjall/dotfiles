# Troubleshooting

## Print JVM flags
The JVM flags in use can be printed via:

     java -XX:+PrintFlagsFinal -version


## Memory issues
When it comes to memory leaks, which eventually manifest themselves as an
`OutOfMemoryError` (OoM) being thrown, one can get the JVM to dump its heap (via
`jmap`), which outputs a `.hprof` file that can be analyzed by the Memory
Analyzer Tool (mat). There is also a JVM option
`-XX:+HeapDumpOnOutOfMemoryError`, which writes a `java_pid<pid>.hprof` file on
OoM errors.

Note: if a heap dump has been written to disk it should be renamed/moved before
restarting the JVM, since otherwise the JVM will refuse to write to the same
file, should it encounter a new OoM error.

If you ever need to enter a running Docker container and trigger a heap dump on the JVM you could use the following commands:

    docker exec -it <container name> /bin/bash
    # .. inside container, determine JVM pid
    ps auxwww | grep java

    # dump heap to /tmp/jvm.hprof
    jmap -dump:format=b,file=/tmp/jvm.hprof <jvmpid>
    # ... OR, if that fails, which may happen, try this alternate command
    jcmd <jvmpid> GC.heap_dump /tmp/jvm.hprof

    # copy to host for analysis
    docker cp <container>:/tmp/jvm.hprof local.hprof


Besides the heap (which should represent the vast majority of a Java
application's memory usage) the JVM also uses native memory for things such as
thread stacks, direct memory buffers, JIT compilation, garbage collection,
etc. By passing `-XX:NativeMemoryTracking=summary` to the JVM, a native memory
summary can be produced via `jcmd <jvmpid> VM.native_memory`.

`visualvm` is a generally useful tool that can be used to monitor the resource
usage of a running container (given that it can connect to the JMX port of the
JVM).


## Threading issues
When a Java process is running, but seemingly not doing any progress (e.g.,
indicated by an unresponsive API or a log file not receiving any further
output), a threading issue may be at hand.

`jstack` is an OpenJDK JVM debugging tool which may be handy for such
cases. `jstack` allows you to dump a snapshot of stack traces for all running
threads in the JVM. This is particularly useful when debugging an unresponsive
application (to find out if a certain thread have deadlocked/died/been starved,
etc).

    docker exec  <container name> -- jstack <jvmpid>


## Containerization
Older versions of the JVM did not realize that it was running in a
container/cgroups-constrained environment but always assumed it was running on
the host. More recent versions of Java support flags such as
`XX:+UseContainerSupport` and `-XX:MaxRAMPercentage=75.0` in addition to the
`-Xmx4096m` heap control flags.
