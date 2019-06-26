# Emacs Lisp

Emacs can be thought of as a giant REPL. Like, e.g., bash and python, it Reads
in an expression, Evaluates it, Prints the results, and Loops to read the next
expression.

In Emacs’ case, the REPL is started when we launch the Emacs application. Every
time we interact with the editor, we're just executing some code in the context
of that REPL. Every keystroke, mouse click, and menu action correspond to
evaluating an expression in this REPL.

Similarly, your `.emacs` file is just the first code that's executed by that
REPL after it starts.

To evaluate an expression, for example, go to the `*scratch*` buffer, enter an
expression, like `(+ 1 1)`, and run `C-j` to have the last expression
evaluated. Or, in any buffer, place the cursor after an expression and evaluate
it with `C-x C-e`.


## Language basics

Lisp is short for `LIS`t `P`rocessing language. Lists are the basis of Lisp.
Lists are always enclosed by parenthesis.

In Lisp, both data and programs are represented the same way; they are both
lists of words, numbers, or other lists, separated by whitespace and surrounded
by parentheses. (Since a program looks like data, one program may easily serve
as data for another; this is a very powerful feature of Lisp.)

    ;; the empty list
    ()

    ;; a list of symbols
    '(rose violet daisy buttercup)

    ;; symbols and a string
    '(this list includes "a string between quotation marks.")

    ;; nested lists
    '(this list has (a list inside of it))

    ;; a function call
    (+ 1 2)

All Lisp *expressions* (sometimes called *forms*) are made up of lists. A (list)
expression is, in turn, made up of *atoms*. Atoms can be thought of as
expression leaf nodes and are strings (`"foo bar"`, numbers (`3`, `3.0`),
symbols (`+`, `foo`, `forward-line`).

The printed representation of both atoms and lists are called *symbolic
expressions* or, more concisely, `sexp`.


## Atoms and basic types

The simplest objects in Elisp are called *atoms*. These evaluate to themselves
and come in three forms:

- Integers: `42`
- Floats:   `3.0`
- Strings:  `"foobar"`. Always double-quoted.
- Booleans: the symbol `t` or the symbol `nil`. In Emacs Lisp, every value is
  *truthy* except `nil` and the empty list `()` (which are equivalent). Notably,
  `0` and `""` are both truthy.

  The functions `and`, `or`, and `not` are used as logical operators.

        ;; => 7. returns the last argument, if they're all truthy (else nil)
        (and t "" 0 7)

        ;; => "foo". returns the first truthy value (else nil).
        (or nil "foo" '() "bar")

        ;; => t
        (not nil)

- Symbols: a symbol can serve as a variable, as a function name, to hold a
  property list, or it may serve as a distinct value with a particular meaning
  (such as `nil`).

Lisp expressions are either atoms or function calls (there are also *macros*
though: a macro translates a Lisp expression into another expression that is to
be evaluated in place of the original expression). Function calls use prefix
notation and are enclosed in parenthesis:

    ;; call 1 + 2 + 3
    (+ 1 2 3)

When evaluating a function, Lisp first evaluates the arguments to the function,
the applies the function to those arguments.

    ;; => (+ 6 2) => 8
    (+ (* 2 3)
       (/ 8 4))


Emacs Lisp has several built-in data structures such as vectors, hashtables, and
bit-vectors but there's no syntax for them; they're created with function calls.


## Lists
Evaluating a list such as

    ;; error: "Invalid function: 1"
    (1 2 3)

won't work since Emacs tries to call a function `1` (`Invalid function: 1`).  To
refer to a list without evaluating it (treating it as *data*, not *code*) we can
use the `quote` function.

    ;; => (1 2 3)
    (quote (1 2 3))

    ;; equivalent
    '(1 2 3)

    ;; on nested lists
    '(1 2 (3 4 5) (6 (7)))

    ;; A quoted list that looks like a function call
    ;; => (+ 1 2 3)
    '(+ 1 2 3)

Note that the emty list `()` evaluates to `nil`. They are identical.  You can
append elements to `nil` to construct a list.

The `list` function can also be used to create a list, but it evaluates its
arguments:

    ;; => (1 2 3)
    (list 1 (+ 1 1) 3)

    ;; => (1 (+ 1 1) 3)
    (quote (1 (+ 1 1) 3))

There are also *backquote* lists, which is a form of templating system, where
elements are selectively evaluated:

    ;; => (1 2 (+ 1 2))
    `(1 ,(+ 1 1) (+ 1 2))

There are several functions that can be used to manipulate lists:

- `car`: gives the head of the list

        ;; => 1
        (car '(1 2 3))


- `cdr`: the tail of the list

        ;; => (2 3)
        (cdr '(1 2 3))
        ;; => nil
        (cdr '(1))

- `null`: determines if a list is empty (`()` or `nil`)

- `cons`: construct a list

        ;; (2)
        (cons 2 nil)
        ;; => (1 2)
        (cons 1 '(2))
        ;; => (1 2 3)
        (cons 1 (cons 2 (cons 3 '())))

- `append`: append a list to another list

        ;; => (1 2 3 4)
        (append '(1 2) '(3 4))

## Pairs and Associative Lists
TODO

## Variables

Trying to evaluate an undefined variable raises an error:

    ;; error: Symbol's value as variable is void: some-list
    some-list

The error means that the symbol `some-list` doesn't point to a variable. The
`set` function is used to assign values to variables.

    (set 'some-list '(1 2 3))

`set` takes the name of a variable (quoted, so it's not evaluated) and a value,
and sets the variable to that value. In practice, it's more common to use the `setq` macro, which wraps the first variable in a call to `quote`.

    (setq some-list '(1 2 3))

    ;; equivalent
    (set  (quote some-list) '(1 2 3))

`setq` defines a variable *globally*.

Locally scoped variables are defined with a `let` expression.

    (let ((a 1)
          (b 5))
        (message "a is %d" a)
        (message "b is %d" b))

`let` doesn't allow an earlier defined variable to be referenced when defining
another. For such cases, use `let*`.

    (let* ((a 1)
           (b (+ a 1))
        (message "a is %d" a)
        (message "b is %d" b))


## Functions
TODO

*Predicates*: functions, such as `=` or `null`, that just return `t` or
`nil`. They are often suffixed with `-p`.

    ;; => t
    (= (+ 2 2) 4)

*Lambdas*: TODO

## Equality
TODO


## Conditionals
TODO


## Looping
TODO

## Emacs library
- hooks


## References
https://www.gnu.org/software/emacs/manual/html_mono/eintr.html#index-Evaluating-inner-lists-38
http://steve-yegge.blogspot.com/2008/01/emergency-elisp.html?m=1
https://harryrschwartz.com/2014/04/08/an-introduction-to-emacs-lisp.html
