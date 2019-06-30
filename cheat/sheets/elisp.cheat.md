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

There are two common ways to evaluate Lisp expressions:
- Place the cursor after an expression (in any buffer) and then evaluate it with
  `C-x C-e`. The result shows in the echo area.
- Write an expression in the `*scratch*` buffer, like `(+ 1 1)`, and run `C-j`
  to have the last expression evaluated and output on the next line.


## Documentation
To open the Emacs Lisp reference manual inside Emacs, type `C-h i` and search
for `lisp`.


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

Lisp programs are made up of *expressions* (sometimes called *forms*), which are
either single *atoms* or *lists* of atoms. Atoms can be thought of as expression
leaf nodes and are strings (`"foo bar"`), numbers (`3`, `3.0`), symbols (`+`,
`foo`, `forward-line`).

The printed representation of both atoms and lists are called *symbolic
expressions* or, more concisely, `sexp`.


## Atoms and basic types

The simplest objects in Elisp are called *atoms*. These evaluate to themselves
and come in three forms:

- Integers: `42`
- Floats:   `3.0`
- Strings:  `"foobar"`. Always double-quoted. Can extend several lines.

        (message "A string with
        a line-break")

  Some functions that operate on strings: `concat`, `upcase`, `substring`.
  More can be found in the Elisp reference (`C-h i`).


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
  (such as `nil`). If you evaluate a variable symbol `'flowers` (note the quote)
  you get the symbol itself, `flowers`.

        (setq flowers '(rose lily))
        ; => flowers
        'flowers
        ; => (rose lily)
        flowers

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
When you evaluate a list, the Lisp interpreter looks at the first symbol in the
list and then tries to call the function definition bound to that symbol. A
single-quote `'` tells the Lisp interpreter that it should return the following
expression as written, and not evaluate it.

Hence, evaluating a list such as

    ;; error: "Invalid function: 1"
    (1 2 3)

won't work since Emacs tries to call a function `1`. To refer to a list without
evaluating it (treating it as *data*, not *code*) we can use the `quote`
function.

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
Lists in Lisp are not a primitive data type; they are built up from *cons
cells*. A cons cell is an ordered pair -- the `car` and the `cdr`. A list is a
series of cons cells chained together, so that each cell refers to the next one
and the last cell's `cdr` is terminated with a `nil`.

*Dotted pair notation* is a general syntax for cons cells that represents the
`car` and `cdr` explicitly.

    (a . b)

stands for a cons cell whose `car` is the object `a` and whose `cdr` is the
object `b`. Dotted pair notation can be used to express lists:

    ;; equivalent to (1 2 3)
    (1 . (2. (3 . nil)))

However, the notation is more commonly used to create *pairs* and *association
lists* (also known as *alists*). An association list is a specially-constructed
list whose elements are cons cells. In each element, the `car` is considered a
key, and the `cdr` is considered an associated value.

    (setq alist-of-colors
          '((rose . red)
            (lily . white)
            (buttercup . yellow)))

There are several functions to work on alists: `assoc`, `rassoc`, `assq`,
`alist-get`, `rassq`.

There is also hash tables in elisp, which are much more efficient for large data
structures (`make-hash-table`, `gethash`, `puthash`, `remhash`, `clrhash`, etc).


## Variables
Trying to evaluate an undefined variable raises an error:

    ;; error: Symbol's value as variable is void: some-list
    some-list

The error means that the symbol `some-list` doesn't point to a variable. The
`set` function is used to assign values to variables (or rather, make a symbol
point to a value):

    (set 'some-list '(1 2 3))

`set` takes the name of a variable (quoted, so it's not evaluated) and a value,
and sets the variable to that value. In practice, it's more common to use the
`setq` macro, which wraps the first variable in a call to `quote`.

    (setq some-list '(1 2 3))

    ;; equivalent
    (set  (quote some-list) '(1 2 3))

`setq` can also be used to assign multiple variables at once:

    (setq
     trees '(pine fir oak maple)
     herbivores '(gazelle antelope zebra))

Note that `setq` defines a variable *globally*.

Locally scoped variables are defined with a `let` expression. Unbound variables
can also be declared; their initial value will be `nil`.

    (let ((a 1)
          b
          (c 5))
        (message "a is %d" a)
        (message "b is %s" b)
        (message "c is %d" c))

After `let` has created and bound the variables, it executes the code in the
body of the `let`, and returns the value of the last expression in the body, as
the value of the whole expression.

`let` doesn't allow an earlier defined variable to be referenced when defining
another. For such cases, use `let*`.

    (let* ((a 1)
           (b (+ a 1))
        (message "a is %d" a)
        (message "b is %d" b))


You can declare a variable, optionally giving it some runtime documentation,
with `defvar` or `defconst`.  You can always change the value of any `defvar` or
`defconst` variable using `setq`. The only difference between the two is that
`defconst` makes it clearer to the programmer that the value is not intended to
change.

    (defconst pi 3.14159 "A gross approximation of pi.")

    (defvar lsp-clients (make-hash-table :test 'eql)
      "Hash table server-id -> client.")

The doc string of a variable is available via `M-x describe-variable`.

You can find the source of a variable definition with `M-x find-variable`.


## Equality
There are different functions for testing different types of equality:

- `=` tests numbers (and markers) for equality. E.g. `(= 2 (+ 1 1))` is `t`.
- `string=` (`string-equal`): tests strings for equality.
- `equal`: deep (structural) equality comparison between two objects. Similar to
  Java's `Object.equals`.

        (equal '(1 2 (3 4)) (list 1 2 (list 3 (* 2 2))))  ; true

- `eq`: returns true if two objects are the same. Works for ints, symbols,
  interned strings, and object references.


## Comparison
- Numeric comparison: `=`, `/=`, `<`, `>`, `<=`, `>=`, `min`, `max`
- String comparison: `string=`, `string<` (`string-lessp`)


## Flow control


### Conditional execution
If expression:

    (if (>= 3 2)
      (message "hello there"))

If you need multiple expressions (statements) in the then-expr, use `progn`:

    (if (zerop 0)
        (progn
          (do-something)
          (do-something-else)
          (etc-etc-etc)))

Alternatively, one can use a `when` expression (there is also an `unless`):

    (when (zerop 0)
        (do-something)
        (do-something-else)
        (etc-etc-etc))

If-else expression:

    (if (today-is-friday)         ; test-expr
        (message "yay, friday")   ; then-expr
      (message "boo, other day")) ; else-expr

If-elseif-else:

    (if 'sunday
        (message "sunday!")      ; then-expr
      (if 'saturday              ; else-if
          (message "saturday!")  ; next then-expr
        (message ("weekday!")))) ; final else

There are two `switch`-like statements: `cond` and `case`. `cond` is really just
a flat way of expressing multi-arm if statements:

    (cond
       ((= n 1) "one")
       ((= n 2) "two")
       ((= n 3) "three")
       (t "many!"))

The `'cl` (Common Lisp) package bundled with Emacs provides a more switch-like
construct for comparing numbers or symbols:

    (case n
      (1 "one")
      (2 "two")
      (3 "three")
      (otherwise "many!"))


### Looping
While:

    (setq x 10)
    (while (plusp x)   ; while x is positive
      (message "%d" x)
      (decf x))        ; subtract 1 from x

Iterate over a list with `while`:

    (setq animals '(gazelle giraffe lion tiger))
    (while animals
        (print (car animals))
        (setq animals (cdr animals)))

Iterate over a list with `dolist` (a third argument can be given to `dolist`
which becomes the symbol to return when the iteration completes):

    (dolist (a animals)
      (print a))

Use `dotimes` to loop a particular number of iterations (can be used with only
two argumetns, the third argument is what `dotimes` will return on completion):

    (let (values)
      (dotimes (i 3 values)
        (setq values (cons i values))))

Lisp's `catch/throw` can be used to achieve `break` and `continue` in loops.

Breaking out of a loop:

    (setq x 0 total 0)
    (catch 'break
      (while t
        (incf total x)
        (if (> (incf x) 10)
            (throw 'break total))))

To `continue` a loop, put a `catch` expression just inside the loop, at the top.

    (setq x 0 total 0)
    (while (<= x 10)
      (catch 'continue
        (incf x)
        (if (zerop (% x 2))
            (throw 'continue nil))
        (incf total x)))


### Errors
Emacs Lisp has a `try/catch` like error handling via its condition system and
the `condition-case` expression:

    (condition-case nil
        (progn
          (do-something)
          (do-something-else))
      (error
       (message "oh no!")
       (do-recovery-stuff)))

A `finally`-like construct is provided via `unwind-protect`.

    (unwind-protect
        (progn
          (do-something)
          (do-something-else))
      (first-finally-expr)
      (second-finally-expr))


## Functions
A function is defined with the `defun` macro:

    (defun function-name (arguments...)
      "optional-documentation..."
      (interactive argument-passing-info)
      (body ...))

A function always returns a value when it is evaluated (unless it gets an
error). A lisp function by default returns the value of the last expression
executed in the function.

Note: early returns in Emacs Lisp can be achieved the same way you do `break`
and `continue` using `catch/throw`.

    (defun day-name ()
      (let ((date (calendar-day-of-week (calendar-current-date))))  ; 0-6
        (catch 'return
          (case date
            (0
             (throw 'return "Sunday"))
            (6
             (throw 'return "Saturday"))
            (t
             (throw 'return "weekday"))))))

If you want your function to be available as a `M-x <function>` command, put
`(interactive)` as the first expression in the body after the doc string. If the
function takes arguments, there are several ways to tell `(interactive)` about
these argumetns and their kind (e.g. a file, buffer).

The doc string of a function is available via `M-x describe-function`.

You can find the source of a function definition with `M-x find-function`.

As an example, a recursive definition of a linear search with an
`if-elseif-else`:

    (defun contains-p (values val)
      "Finds out if val is a member of the values list."
      (if (not values)
          nil
        (if (= (car values) val)
            t
          (contains-p (cdr values) val))))

*Predicates*: functions, such as `=` or `null`, that just return `t` or
`nil`. They are often suffixed with `p`.

    ;; => t
    (= (+ 2 2) 4)

Emacs Lisp does not have reference arguments, but has *dynamic scope*, which
means that a function can modify variables on the callers stack. Use with
caution!

    (defun foo ()
      (let ((x 6))  ; define a local (i.e., stack) variable x initialized to 6
        (bar)       ; call bar
        x))         ; return x

    (defun bar ()
      (setq x 7))   ; finds and modifies x in the caller's stack frame

If you invoke `(foo)` the return value is `7`.


*Lambdas* (or anonymous functions) can be declared via the `lambda` macro:

    ; declare a lambda (to no use...)
    (lambda (x) (* x x x))

    ; call a lambda: => 25
    ((lambda (x) (* x x)) 5)

Like `set` binds a variable to a value, `fset` binds a function to a symbol:

    ; assign to a symbol
    (fset 'sq (lambda (x) (* x x)))
    ; => 9
    (sq 3)

Lambdas are most useful when combined with higher-order functions (`mapcar`
applies a function to each element of a list):

    ; => (1 4 9 16)
    (mapcar (lambda (x) (* x x)) '(1 2 3 4))
    (mapcar 'sq '(1 2 3 4))

`funcall` can be used to create higher-order functions:

    (defun apply-to (fn values)
      "Apply function fn to each element of values list."
      (let
          ((out nil))
        (while values
          (push (funcall fn (car values)) out)
          (setq values (cdr values)))
        (reverse out)))

    ; => (1 4 9)
    (apply-to (lambda (x) (* x x)) '(1 2 3))

There are some useful built-in higher-order functions:

    ;; common lisp library
    (require 'cl)

    ; => (0 2 4 6 8)
    (remove-if 'oddp '(0 1 2 3 4 5 6 7 8 9))
    ; => (1 3 5 7 9)
    (remove-if-not 'oddp '(0 1 2 3 4 5 6 7 8 9))

    ; => ("FOO" "BAR" "BAZ")
    (mapcar 'upcase '("foo" "bar" "baz"))




## Emacs library

The `message` function outputs a (possibly formatted) string in the echo area.

    (message "The name of this buffer is: %s." (buffer-name))


TODO: Emacs supports the notion of *buffer-local* variables. You can use the
function `make-variable-buffer-local` to declare a variable as buffer-local.


TODO: hooks



## References
http://steve-yegge.blogspot.com/2008/01/emergency-elisp.html?m=1
https://harryrschwartz.com/2014/04/08/an-introduction-to-emacs-lisp.html
