## Command-line
- `Ctrl+r`: search command history



## Scripting: basics

Run commands in a sub-shell. Variables set in the sub-shell are not visible to
the calling process.

    (command; command)

Return the *value* of the commands run in `command_list`. Just like `$VAR` gives
the value of `VAR`.

    $(command_list)

Pass output of `command_list` as stdin to `cmd`.

    cmd <(command_list)
    grep root <(cat /etc/passwd)

Pass output of multiple commands as stdin to a command.

    comm <(ls -l) <(ls -al)


`test` is a conditional test with multiple possible comparisons. `-f` tests file
existence. `-z`: string length is zero. `-n`: string length is non-zero. Integer
comparisons: `-eq`, `-gt`, `-ge`, `-lt`, `-le`, `-ne`.

    test -f /etc/passwd

Shorthand for `test` command.

    [ EXPR ]

Repeat until `command` gives non-zero exit.

    while command; do cmd; done

Conditionals:

    if command; then cmd; else cmd; fi

Arithmetic:

    $(( 4 + 5 ))

Multi-line "here-document".

    cat <<EOF
    A B C
    1 2 3
    EOF

Line-by-line processing.

    cat file | while read line; do echo $line; done
    while read line; do echo $line; done < /dev/stdin

    # if we want `read` to keep whitespace
    IFS=''
    cat file | while read line; do echo $line; done

Arrays:

    databases=("db1" "db2" "db3")
    for db in "${databases[@]}"; do
        psql -c "SELECT pg_size_pretty(pg_database_size('${db}')) AS db_size;"
    done

Associative array/map/hash table/dictionary:

    # declare associative array
    declare -A animals
    # assign key-value pairs
    animals=( ["cow"]="moo" ["dog"]="woof")

    # .. or in shorter form
    declare -A animals=( ["moo"]="cow" ["woof"]="dog")

    # get value
    echo ${animals[cow]}  # => moo

    # set value
    animals[cat]="meow"

    # expand keys (notice the !)
    echo ${!animals[@]}

    # expand values
    echo ${animals[@]}

    # iterate over
    for a in "${!animals[@]}"; do
        echo "${a} says: ${animals[${a}]}"
    done

## Redirecting output

Redirect `stderr` to a file

    cat nop.txt 2> error.txt

Redirecting `stdout` and `stderr` to separate files:

    ls -al /tmp/somefile 2> /tmp/stderr 1> /tmp/stdout

Redirecting both `stderr` and `stdout` to a file:

    cmd > /tmp/alloutput 2>&1

Echoing to `stderr` by redirecting `stdout` to `stderr`:

    echo "error" 1>&2

Echoing to `stderr` by copying `stderr` to `stdout`:

     >&2 echo "error"


## Scripting: executing commands over ssh

    ssh <host> bash -s < /my/script.sh

## Scripting: coloring output

    echo -e "NORMAL \e[31m RED \e[0m NORMAL"
    echo -e "NORMAL \e[32m GREEN \e[0m NORMAL"
    echo -e "NORMAL \e[33m ORANGE \e[0m NORMAL"


## Arithmetic

Basic arithmetic can be done with double parenthesis.

    a="3"
    (( a++ ))   # a == 4, doesn't print anything
    $(( a++ ))  # a == 5, prints "4"
    $(( ++a ))  # a == 6, prints "6"
    $(( a+=2 )) # a == 6, prints "9"

    a=$(( ${a} + 4 ))  # => 7
    # dollar sign is optional for variables
    a=$(( a + 4 ))     # => 11

One can also used the built-in `let` function to do arithmetic when one needs to
save it to a variable.

    a=1

    let a=a+2           # => 3
    # quote to allow whitespace
    let "a = 2*a + 10"  # => 16

    b=2
    let "a = a*b"       # => 6
    # increment operator
    let a++             # => 7

`expr` is similar to `let` except instead of saving the result to a variable it
instead prints the answer. Unlike `let` you don't need to enclose the expression
in quotes, but whitespace is needed between arguments.

    expr 1 + 2
    expr 2 * $a

## Scripting: command-line parsing

    for arg in ${@}; do
        case ${arg} in
            --opt1=*)
                opt1=${arg/*=/}
                ;;
            --opt2=*)
                opt2=${arg/*=/}
                ;;
            --enable-x)
                enable_x=true
                ;;
            --help)
                print_usage
                exit 0
                ;;
            --*)
                die_with_error "unrecognized option: ${arg}"
                ;;
            *)
                # no option, assume only positional arguments left
                break
                ;;
        esac
        shift
    done
    arg1=${1}
    arg2=${2}
    ...

### Scripting: prompting for input

    while [ "${answer}" != "yes" ] && [ "${answer}" != "no" ]; do
        read -p "Overwrite directory (yes/no)? " answer
    done
    if [ "${answer}" != "yes" ]; then
        echo "Aborting ..."
        exit 0
    fi

## Scripting: debugging
To see each executed command

    set -x

To not have variables in commands expanded, instead use:

    set -v

### Jobs

    # create background job
    sleep 10s &

    # list jobs
    jobs

    # join first background job
    wait %1

### Signals and traps

Use `trap` to run code on certain signals:

    trap "{ echo "interrupted ..."; }" SIGINT SIGTERM

or execute commands when the shell exits:

    trap "{ kill ${MY_PID}; }" EXIT


### Line/byte processing
Process first N lines:

    cat file | head -N
    # bytes
    cat file | head --bytes=N

Process last N lines:

    cat file | tail -N
    # bytes
    cat file | tail --bytes=-N

Process lines starting at N:

    cat file | tail --lines=+N
    # bytes
    cat file | tail --bytes=+N

Process lines [A,B]:

    cat file | tail --lines=+A | head -[B-A+1]
    # alternatively
    sed -n 'A,B p' file

    # bytes [A,B]
    cat file | tail --bytes=+A | head --bytes=+[B-A+1]


### String manipulation

Substring removal from front:

     file=node-ssh-key.gpg
     echo ${file#node-}  # => ssh-key

Substring removal from back:

     file=node-ssh-key.gpg
     echo ${file%.gpg}   # => node-ssh-key

Substring replacement:

     # replace first match
     file=node-ssh-key.gpg
     echo ${file/ssh/secret}   # => node-secret-key.gpg

     # replace all matches
     file=node-ssh-key.sshkey
     echo ${file//ssh/gpg}     # => node-gpg-key.gpgkey

### Regular expressions

The `=~` operator can be used to match strings against regular expressions, and
capture patterns.

    # captures <image-name> and <image-path> in lines containing:
    #
    #  ![<image-name>](<image-path>)
    #
    imageref_regexp="!\[([^]]+)\]\(([^)]+)\)"
    line='   ![An image](path/to/image.png)'
    if [[ ${line} =~ ${imageref_regexp} ]]; then
        image_ref="${BASH_REMATCH[0]}"
        image_name="${BASH_REMATCH[1]}"
        image_path="${BASH_REMATCH[2]}"
        echo "match: ${image_ref}"
        echo "capture group 1: ${image_name}"
        echo "capture group 2: ${image_path}"
    fi
