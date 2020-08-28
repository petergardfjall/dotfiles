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


## Redirecting output

Redirect `stderr` to a file

    cat nop.txt 2> error.txt

Redirecting `stdout` and `stderr` to separate files:

    ls -al /tmp/somefile 2> /tmp/stderr 1> /tmp/stdout

Redirecting both `stderr` and `stdout` to a file:

    cmd > /tmp/alloutput 2>&1


## Scripting: executing commands over ssh

    ssh <host> bash -s < /my/script.sh



## Scripting: coloring output

    echo -e "NORMAL \e[32m GREEN \e[0m NORMAL"



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

### Signals and traps

Use `trap` to run code on certain signals:

    trap "{ echo "interrupted ..."; }" SIGINT SIGTERM

or execute commands when the shell exits:

    trap "{ kill ${MY_PID}; }" EXIT


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
