# General

For local documentation: Use `godoc-open.sh` or `godoc -http localhost:1234`.

## Types
Go's basic types are:

- boolean: `bool`
- string: `string`
- integer numbers: `int`, `int8`, `int16`, `int32`, `int64`, `uint`, `uint8`,
  `uint16`, `uint32`, `uint64`, `uintptr`,`byte` (alias for `uint8`), `rune`
  (alias for `int32` -- represents a Unicode code point).

  The `int`, `uint`, and `uintptr` types are usually 32 bits wide on 32-bit
  systems and 64 bits wide on 64-bit systems. Use `int` unless you have a
  specific reason to use a sized or unsigned integer type.

- floating point numbers: `float32`, `float64`
- complex numbers: `complex64`, `complex128`

The *zero value* is:
- `0` for numeric types,
- `false` for the boolean type, and
- `""` (the empty string) for strings.

`T(v)` converts the value `v` to the type `T`:

    i := 42
    f := float64(i)

A *type assertion* provides access to an interface value's underlying concrete
value.

    var i interface{} = "hello"
    s := i.(string)
    fmt.Println(s)

If `i` does not hold a `string`, the statement will trigger a panic. To test
whether an interface value holds a specific type, a type assertion can return
two values: the underlying value and a boolean value that reports whether the
assertion succeeded (the "comma, ok" idiom).

     t, ok := i.(T)

A common use of the comma-ok idiom is to test if a value is of a certain type
and, if so, take some action:

     if err, ok := err.(SomeType); ok {
         // do something with error
     }

Constants can be character, string, boolean, or numeric values.

    const (
        Pi = 3.14
        E  = 2.71
    )

For "type alias" definitions where two types (such as `Sequence` and `[]int`
below) are the same if we ignore the type name, it's legal to convert between
them. It's an idiom in Go programs to convert the type of an expression to
access a different set of methods.

    type Sequence []int

    // sorted print
    func (s Sequence) String() string {
        s = s.Copy()
        sort.IntSlice(s).Sort() // convert to sort.IntSlice: type IntSlice []int
        return fmt.Sprint([]int(s)) // convert to []int
    }


## Packages

A convention is that the package name is the base name of its source directory;
the package in `src/encoding/base64` is imported as `"encoding/base64"` but has
name `base64`. This is a *convention*, it would have been perfectly ok to name
the package `b64`.

The importer of a package will use the name to refer to its contents, so
exported names in the package can use that fact to avoid stutter. For instance,
the buffered reader type in the `bufio` package is called `Reader`, not
`BufReader`, because users see it as `bufio.Reader`.


### Package organization
(source: https://www.brianketelsen.com/slides/gcru18-best/)
Two key areas of code organization that will make a huge impact on the
usability, testability, and functionality of your code:

- Package Naming
- Package Organization

The goal should be to write code that is easy to understand, easy to refactor,
and easy for someone else to maintain.

Regarding naming, name your packages after what they provide, not what they
contain. Remember that a package's name is both a description of its purpose,
and a name space prefix.


#### Library organization
For *libraries*, packages should contain code with a single purpose (look at the
standard library): `archive`, `container`, `math`, `path`, `net`, `io`.

- Packages names describe their purpose
- It's very easy to see what a package does by looking at the name
- Names are generally short
- When necessary, use a descriptive parent package and several children
  implementing the functionality - like the `encoding` package (`encoding/json`,
  `encoding/pem`)

#### Application organization
For *applications*, the package organization is subtly different. The difference
is the command, the executable that ties all of those packages together. Most
libraries focus on providing a singularly scoped function; logging, encoding,
network access. Your application will tie all of those libraries together to
create a tool or service, which will be much larger in scope.

When building an *application*, you should organize your code into packages, but
those packages should be centered on two categories:
- Domain Types
- Services

*Domain Types* model your business functionality and objects. *Services* are
packages that operate on or with the domain types.

A domain type is the substance of your application. If you have an inventory
application, your domain types might include `Product` and `Supplier`. The
package containing your domain types should also define the interfaces between
your domain types and the rest of the world. These interfaces define the things
you want to do with your domain types (`ProductService`, `SupplierStorage`).

Your domain type package should be the root of your application repository. This
makes it clear to anyone opening the codebase what types are being used, and
what operations will be performed on those types. The domain type package, or
root package of your application should not have any external dependencies. It
exists for the sole purpose of describing your types and their behaviors. The
implementations of your domain interfaces should be in separate packages,
organized by dependency. Here, dependencies include external data sources and
transport logic (http, RPC). You should have one package per dependency. This
makes testing simple, allows for easy substitution/replacement and avoids
circular dependencies.

A strategy to achive this is presented by Ben Johnson
(https://medium.com/@benbjohnson/standard-package-layout-7cdbc8391fc1,
https://talks.bjk.fyi/gcru18-best.html#/). It pushes the domain model to the top
of the project and separates subpackages by dependency.

It involves 4 simple tenets:

1. Root package is for domain types. Your application has a logical, high-level
   language that describes how data and processes interact. This is your
   *domain*. Place domain types in the root package. This package only contains
   simple data types like a `User` struct for holding user data or a
   `UserService` interface for fetching or saving user data. *The root package
   should not depend on any other package in your application!*

2. Group subpackages by (external) dependency. Subpackages exist as an adapter
   between your domain and your implementation. Your `UserService` might be
   backed by PostgreSQL. You can introduce a postgres subpackage in your
   application that provides a `postgres.UserService`. No imports should occur
   between subpackages. Instead, they are connected to via interfaces/types in
   the domain model. Dependencies communicate solely through our common domain
   language. One can use the same approach and group packages by dependency even
   for standard library dependencies. For instance, the `net/http` package is
   just another dependency. We can isolate it as well by including an `http`
   subpackage in our application.

3. Use a shared `mock` subpackage. Since dependencies are isolated from other
   dependencies by domain interfaces, we can use these connection points to
   inject mock implementations.

4. Main package ties together dependencies. It wires the dependencies together
   by injecting domain interface implementations.

A concrete example: https://github.com/benbjohnson/wtf


Inside a package separate code into logical concerns. If the package deals with
multiple types, keep the logic for each type in its own source file.


### Package renaming

The `gomvpkg` comes in handy when you want to rename a package and have all
references updated (very tedious when done manually).

    gomvpkg -from github.com/myapp/pkg/types -to github.com/myapp/pkg/pkg/domain/app -vcs_mv_cmd "git mv {{.Src}} {{.Dst}}"

Note: it appears to only work when the project is on your `GOPATH`.


## The init function
Each source file can define one or more `init` functions to set up whatever
state is required; `init` is called after all the variable declarations in the
package have evaluated their initializers, and those are evaluated only after
all the imported packages have been initialized.

Some packages are imported just for their side-effects. The `net/http/pprof`
package registers HTTP handlers that provide debugging information.

    import _ "net/http/pprof"

Similarly, the `database/sql` drivers often use an `init` method to register
themselves.

    import _ "github.com/lib/pq"   // postgresql


## Builtin

Package `builtin` provides *documentation* (they aren't actually declared there)
for built-in identifiers: https://golang.org/pkg/builtin/.

Examples are:
- output: `print`, `println`
- slices: `append`, `copy`
- map: `delete`
- creation:
  - `new`: returns a pointer to a newly allocated zero value of type T. That is,
    it does not initialize the memory, it only zeros it. It's helpful to arrange
    your data structures such that the zero value can be used directly. Since
    the zero-value of both `sync.Mutex` and `bytes.Buffer` is usable, it follows
    that a SyncedBuffer can be used off the bat.

         type SyncedBuffer struct {
             lock    sync.Mutex
             buffer  bytes.Buffer
         }
         ...
         p := new(SyncedBuffer)  // type *SyncedBuffer
         var v SyncedBuffer      // type  SyncedBuffer

  - `make`: creates slices, maps, and channels only, and it returns an
    initialized (not zeroed) value of type `T` (*not* `*T`).

        v := make([]int, 10, 100)   // slice of length 10, capacity 100
        ch := make(chan int)        // creates a 'chan int'
        m := make(map[string]int)   // creates a string->int map

- size: `len`,  `cap`
- channels: `close(c chan<- Type)`
- error handling: `panic`, `recover`


## Looping

Three forms:

    // Like a C for
    for init; condition; post { }

    // Like a C while
    for condition { }

    // Like a C for(;;)
    for { }

One can use `range` to iterate over slice, map or reading from a channel.

     for key, value := range oldMap {
         newMap[key] = value
     }

## Switch

Use commas to separate multiple expressions in a single `case`:

    func shouldEscape(c byte) bool {
        switch c {
        case ' ', '?', '&', '=', '#', '+', '%':
            return true
        }
        return false
    }

An alternative to an `if-else` is to use a `switch` without expression:

    switch {
    case t.Hour() < 12:
        fmt.Println("It's before noon")
    default:
        fmt.Println("It's after noon")
    }

Use a "type switch" to compare types instead of values:

    whatAmI := func(i interface{}) {
        switch t := i.(type) {
        case bool:
            fmt.Println("I'm a bool")
        case int:
            fmt.Println("I'm an int")
        default:
            fmt.Printf("Don't know type %T\n", t)
        }
    }
    whatAmI(true)
    whatAmI(1)
    whatAmI("hey")


Switch cases evaluate cases from top to bottom, stopping when a case succeeds.

    // does not call `f` if `i==0`.
    switch i {
    case 0:
    case f():
    }

Each `case` can be an expression. For example `today + 1`.


## Defer

A defer statement defers the execution of a function until the surrounding
function returns. The deferred call's arguments are evaluated immediately, but
the function call is not executed until the surrounding function returns.
Deferred function calls are pushed onto a stack. When a function returns, its
deferred calls are executed in LIFO order. This reclaims resources in opposite
order of acquisition.

    f, err := os.Open(path)
    if err != nil {
        return nil, errors.Wrap(err, "open failed")
    }
    defer f.Close()
    ...

## Panics

For fatal conditions (where the normal error return-value is inapproriate), For
this purpose, there is a built-in `panic` function that raises a run-time error
that will abort the program (unless recovered from). The function takes a single
argument of arbitrary type (like string/error) to be printed as the program
dies.

When `panic` is called, including implicitly for run-time errors such as
indexing a slice out of bounds or failing a type assertion, it immediately stops
execution of the current function and begins unwinding the stack of the
goroutine, running any deferred functions along the way. If that unwinding
reaches the top of the goroutine's stack, the program dies. However, it is
possible to use the built-in function recover to regain control of the goroutine
and resume normal execution. Note that deferred functions can modify named
return values.

    func myFun() (err error) {
        defer func() {
            if e := recover(); e != nil {
                fmt.Printf("recovered from error: %s\n", e)

                // handle error
                err = errors.New("did not go well: " + e)

                // ... or re-panic
                // panic(err)
            }
        }()

        panic("error occured!")
    }

## Formatting

The formatted I/O from package `fmt` supports these format specifiers:

General:
- `%v`: the value in a default format.For compound objects, the elements are
  printed using these rules, recursively, laid out like this:

        struct:             {field0 field1 ...}
        array, slice:       [elem0 elem1 ...]
        maps:               map[key1:value1 key2:value2 ...]
        pointer to above:   &{}, &[], &map[]

- `%+v`: same as `%v`, but When printing `struct`s, field names are written
- `%#v`: a Go-syntax representation of the value.
- `%T`:  a Go-syntax representation of the *type* of the value.
- `%%`:  a literal percent sign; consumes no value

Boolean:
- `%t`: the word `true` or `false`.

Integer:
- `%b`: base 2
- `%c`: the character represented by the corresponding Unicode code point
- `%d`: base 10
- `%o`: base 8
- `%q`: a single-quoted character literal safely escaped with Go syntax.
- `%x`: base 16, with lower-case letters for a-f
- `%X`: base 16, with upper-case letters for A-F
- `%U`: Unicode format: U+1234; same as "U+%04X"

Floating-point:
- `%b`: decimalless scientific notation with exponent a power of two.
- `%e`:  scientific notation (`-1.234456e+78`
- `%E`:  scientific notation (`-1.234456E+78`)
- `%f`: decimal point but no exponent, e.g. `123.456`. Width is specified by an
  optional number immediately preceding the verb. Precision is specified after
  the (optional) width by a period followed by a number.

        %f     default width, default precision
        %9f    width 9, default precision
        %.2f   default width, precision 2
        %9.2f  width 9, precision 2
        %9.f   width 9, precision 0

- `%F`:  synonym for `%f`
- `%g`:  `%e` for large exponents, `%f` otherwise.
- `%G`:  `%E` for large exponents, `%F` otherwise

String and slice of bytes (treated equivalently with these verbs):
- `%s`: the uninterpreted bytes of the string or slice
- `%q`: a double-quoted string safely escaped with Go syntax
- `%x`: base 16, lower-case, two characters per byte
- `%X`: base 16, upper-case, two characters per byte

Slice:
- `%p`: address of 0th element in base 16 notation, with leading `0x`

Pointer:
- `%p`: base 16 notation, with leading `0x`



## Errors

Go programs express error state with error values.

The error type is a built-in interface similar to `fmt.Stringer`:

    type error interface {
        Error() string
    }

It's a common practice to declare errors at the top of a source file.

    var (
        ErrInternal      = errors.New("regexp: internal error")
        ErrUnmatchedLpar = errors.New("regexp: unmatched '('")
        ErrUnmatchedRpar = errors.New("regexp: unmatched ')'")
    )

    ...

    return nil, ErrUnmatchedLpar

The traditional error handling idiom in Go is roughly akin to

    if err != nil {
        return err
    }

which when applied recursively up the call stack results in error reports
without context or debugging information. The `github.com/pkg/errors` package
allows context to be added to the failure path in their code in a way that does
not destroy the original value of the error (e.g. to include a stacktrace, much
like a panic does). It provides functions `Wrap`, `Wrapf` and `WithStack` which
record a stack trace at the point they are invoked.

    import "github.com/pkg/errors"

    func main() {
            err := errors.New("error")
            err = errors.Wrap(err, "open failed")
            err = errors.Wrap(err, "read config failed")

            fmt.Println(err)         // "read config failed: open failed: error"
            fmt.Printf("%+v\n", err) // prints the error with stacktrace
    }

The `%+v` prints each frame of the error's stacktrace in detail.

Note: for cases when we have no additional message to add but only want to
provide stacktrace details we can use:

    if err != nil {
        return errors.WithStack(err)  // annotate with stacktrace
    }


## Arrays

Arrays are useful when planning the detailed layout of memory and sometimes can
help avoid allocation, but primarily they are a building block for slices.

Note though that:
- Arrays are values. Assigning one array to another copies all the elements.
- If you pass an array to a function, it will receive a copy of the array, not a
  pointer to it. If you want C-like behavior and efficiency, pass a pointer to
  the array.
- The size of an array is part of its type. The types `[10]int` and `[20]int`
  are distinct.


## Slices

Slices wrap arrays to give a more general, powerful, and convenient interface to
sequences of data. Slices hold references to an underlying array, and if you
assign one slice to another, both refer to the same array.  Note: Go types read
from left to right `[]string` "slice of string".

A slice has both a *length* and a *capacity*. The length of a slice is the
number of elements it contains. The capacity of a slice is the number of
elements in the underlying array, counting from the first element in the slice.

The zero-value for a slice is `nil`, which in effect is a zero capacity
slice. No need to use `make()`. Note that `append` works on `nil` slices.

    var v []string
    v = append(v, "foo", "bar")  // we can append without make()

    s := make([]string, 3)       // create slice of 3 zero-valued strings
    s[0] = "a"
    s[1] = "b"
    s[2] = "c"
    fmt.Println(s[:])    // "abc"
    fmt.Println(s[1:])   // "bc"
    fmt.Println(s[1:2])  // "b"
    fmt.Println(s[1:3])  // "bc"
    fmt.Println(s[:2])   // "ab"

Iterate:

    for item := range v { ... }

    for index, item := range v { ... }

Merge two slices:

    var v1 := []string{"foo", "bar"}
    var v2 := []string{"baz"}
    v1 = append(v1, v2...)

Sort a slice

    var values = []int{3,1,2}
    comp := func(i,j int) bool { return values[i] < values[j] }
    sort.SliceIsSorted(values, comp)  // false
    sort.Slice(values, func(i,j int) bool { return values[i] < values[j] })
    sort.SliceIsSorted(values, comp)  // true

Binary search:

    a := []int{55, 45, 36, 28, 21, 15, 10, 6, 3, 1}
    x := 6
    i := sort.Search(len(a), func(i int) bool { return a[i] <= x })
    fmt.Println(i)  // -> 7

Sort strings:

    var strList = []string{"foo","bar","baz"}
    sort.Strings(strList)

Search strings:

    sort.SearchStrings(strList, "baz")  // -> 2


## Maps

The zero value of a map is `nil`. A `nil` map has no keys, nor can keys be
added. Use `make` to create a `map`.

    m := make(map[string]int)
    m["a"] = 1
    m["b"] = 2
    delete(m, "b")


Map keys may be of any type that is comparable. The language spec defines this
precisely, but in short, comparable types are boolean, numeric, string, pointer,
channel, and interface types, and structs or arrays that contain only those
types. Notably absent from the list are slices, maps, and functions; these types
cannot be compared using `==`, and may not be used as map keys.

If the requested key doesn't exist, we get the value type's zero value.

    m["c"] // -> 0

Optional second return value marks presence of key

    if _, ok := m["foo"]; ok {
        fmt.Println("contains key foo")
    }

Map literals:

    var letters = map[string]int{ "a": 1, "b": 2}

    type Vertex struct {
        Lat, Long float64
    }

    var m = map[string]Vertex{
        "Bell Labs": {40.68433, -74.39967},
        "Google":    {37.42202, -122.08408},
    }

Range over keys and values:

    for k, v := range m {
        fmt.Printf("%s -> %s\n", k, v)
    }

Range over keys only:

    for k := range m {
        fmt.Printf("key: %s\n", k)
    }

A `map[T]bool` is an idiomatic way of representing a set in Go.

## Embedding

See https://golang.org/doc/effective_go.html#embedding

Go does not provide subclassing, but it does have the ability to “borrow” pieces
of an implementation by *embedding* types within a struct or interface.

Interface embedding is very simple.

    type Reader interface {
        Read(p []byte) (n int, err error)
    }

    type Writer interface {
        Write(p []byte) (n int, err error)
    }

    // ReadWriter combines the Reader and Writer interfaces.
    type ReadWriter interface {
        Reader
        Writer
    }

The same basic idea applies to structs.

     // bufio.ReadWriter stores pointers to a Reader and a Writer.
     // It implements io.ReadWriter.
     type ReadWriter struct {
         *Reader  // *bufio.Reader
         *Writer  // *bufio.Writer
     }

     var r *Reader = ...
     var w *Writer = ...
     rw := &bufio.ReadWriter{r, w}
     // rw := &bufio.ReadWriter{Reader: r, Writer: w}

The embedded elements are pointers to structs and of course must be initialized
to point to valid structs before they can be used. The ReadWriter struct could
be written to be composed as below, however then but then to promote the methods
of the fields and to satisfy the io interfaces, we would also need to provide
forwarding methods

    type ReadWriter struct {
        reader *Reader
        writer *Writer
    }

    // forwarding method for Reader.Read()
    func (rw *ReadWriter) Read(p []byte) (n int, err error) {
        return rw.reader.Read(p)
    }

By embedding the structs directly, we avoid this bookkeeping. The methods of
embedded types come along for free, so that `bufio.ReadWriter` not only has the
methods of `bufio.Reader` and `bufio.Writer`, it also satisfies all three
interfaces: `io.Reader`, `io.Writer`, and `io.ReadWriter`.

When we embed a type, the methods of that type become methods of the outer type,
but when they are invoked the receiver of the method is the inner type, not the
outer one. When `Read` is invoked on a `bufio.ReadWriter`, it has exactly the
same effect as the forwarding method above; the receiver is the reader field of
the ReadWriter, not the ReadWriter itself.

If we need to refer to an embedded field directly, the type name of the field,
ignoring the package qualifier, serves as a field name, as it did in the Read
method of our ReadWriter struct.

    var rw ReadWriter = ...
    rw.Write(...)  // equivalent to rw.Writer.Write(...)

## Functions

Functions are values and can be passed around just like other values.

    func compute(fn func(float64, float64) float64) float64 {
        return fn(3, 4)
    }

    ...

    hypot := func(x, y float64) float64 {
        return math.Sqrt(x*x + y*y)
    }
    fmt.Println(compute(hypot))    // prints "5"

A closure is a function value that references variables from outside its
body. The function may access and assign to the referenced variables; in this
sense the function is "bound" to the variables.

    func adder(start int) func(int) int {
        sum := start  // becomes part of the returned functions closure
        return func(x int) int {
            sum += x
            return sum
        }
    }
    ...
    next := adder(1)
    fmt.Println(next(2))  // -> 3
    fmt.Println(next(1))  // -> 4

Go does not have classes. However, you can define *methods* on types.  A method
is a function with a *receiver argument*.

    type Vertex struct {
        X, Y float64
    }

    func (v Vertex) Abs() float64 {
        return math.Sqrt(v.X*v.X + v.Y*v.Y)
    }

You can declare a method on non-struct types, too. However, you can only
declare a method with a receiver whose type is defined in the same package as
the method, which prevents us from modifying built-in types such as `int`.

    type MyFloat float64

    func (f MyFloat) Abs() float64 {
        if f < 0 {
            return float64(-f)
        }
        return float64(f)
    }

You can declare methods with *pointer receivers* or *value receivers*.

    func (v Vertex) ScaleVal(f float64)  {
        v.X = v.X * f
        v.Y = v.Y * f
    }

    func (v *Vertex) ScalePtr(f float64) {
        v.X = v.X * f
        v.Y = v.Y * f
    }

    func main() {
        v := Vertex{3, 4}

        v.ScaleVal(10)  // (by-value: no change to v)
        fmt.Println(v)  // -> 3, 4
        v.ScalePtr(10)  // (by-reference: modifies v)
        fmt.Println(v)  // -> 30, 40
    }

Use pointer receivers when:

- You want to change the state of the receiver in a method. This is not possible
  with a value receiver, which copies by value.
- If the struct you're defining the method on is very large, copying it would be
  far too expensive. It's a bit more complicated than pointers always being more
  efficient: modern computers are quick at copying memory, heap allocations are
  expensive (as can garbage collection be), so don't use pointers because you
  *think* they might give you better performance (prove it by benchmarking!). If
  memory copying is a limiting factor for you performance-wise, you're in a good
  place. Default to using values except when you *need* the semantics a pointer
  provides.

Also, for a single type, *be consistent in the use of value/pointer receivers*.

The return values a Go function can be given names and used as regular
variables, just like the incoming parameters. When named, they are initialized
to the zero values for their types when the function begins; if the function
executes a `return` statement without arguments (*naked return*), the current
values of the result parameters are used as the returned values.

    func split(sum int) (x, y int) {
        x = sum * 4 / 9
        y = sum - x
        return
    }


## Strings

Convert string to bytes:

    []byte("Here is a string....")

Convert bytes to string:

     string(byteArray[:])

Use a `ByteBuffer` as an `io.Writer` to capture a string:

    var buf bytes.Buffer
    fmt.Fprintf(&buf, "hello world")
    buf.String() // "hello world"

Split and join:

    s := strings.Split("4.0.0.RELEASE", ".")  // []string{"4","0","0","RELEASE"}
    strings.Join(s[:3], ".")  // "4.0.0"

Create an `io.Reader` from a string:

    strings.NewReader("hello world")


## Regular expressions

The syntax of the regular expressions accepted is the same general syntax used
by Perl, Python, and other languages. More precisely, it is the syntax accepted
by RE2: https://github.com/google/re2/wiki/Syntax

There are a few intersting functions:

- Without first compiling a `regexp.Regexp`:

        // true if string contains *any* match of the pattern
        matched, _ := regexp.MatchString(`foo.*`, "seafood")

        // true if byte slice contains *any* match of the pattern
        matched, _ := regexp.Match(`foo.*`, []byte(`seafood`))

- By compiling a `regexp.Regexp`. Use `MustCompile` in an `init` function or in
  a package-global `var` declaration to compile a pattern (will panic on error).

        var (
            // semantic versions are of form 0.0.1-alpha.preview+123.github,
            // not 4.0.1.RC1 (cannot have dot after patch version number)
            NonSemverVersion = regexp.MustCompile(`([0-9]\.){3}\S+`)
        )

        func main() {
            v1 := "4.0.0.RELEASE"
            v2 := "0.0.1-alpha"

            for _, ver := range []string{v1, v2} {
                if NonSemverVersion.Match([]byte(ver)) {
                    fmt.Printf("version '%s' matched\n", ver)
                }
            }
         }

`Regexp` has several methods:
- `Match(b []byte) bool`: does `b` contain any match of the regexp?
- `Find(b []byte) []byte`: leftmost match in `b` of the regexp
- `FindAll(b []byte, n int) [][]byte`: all matches in `b` of the regexp.
- `ReplaceAllString(src, repl string) string`: returns a copy of `src`,
  replacing matches of the `Regexp` with the replacement string `repl`. Inside
  `repl`, `$` signs are interpreted so that `$1` represents the text of the
  first submatch (capture group).
- `FindStringSubmatch`: returns a slice of strings holding the text of the
  leftmost match of the regular expression and the matches, if any, of its
  subexpressions, as defined by the 'Submatch' description in the package
  comment. A return value of `nil` indicates no match.

        pattern := regexp.MustCompile(`lastModifiedDate:(\S+)`)
        m := pattern.FindStringSubmatch("lastModifiedDate:2018-05-01")
        if m == nil {
            fmt.Println("no match")
        } else {
            fmt.Printf("matched: '%s'\n", m[1])
        }

## Time

Parsing time is carried out via `time.Parse`:

    func Parse(layout, value string) (Time, error)

Parses a formatted string and returns the time value it represents. The layout
defines the format via a reference time: `Mon Jan 2 15:04:05 -0700 MST 2006`.

    time1 := "2018-01-12T12:15:45"
    time2 := "24/12 2019 15:00:10"
    time3 := "2019-04-18T00:25:38-04:00"
    time4 := "2019-04-18T00:25:38.000Z"

    t1, _ := time.Parse("2006-01-02T15:04:05", time1)
    fmt.Println(t1.UTC())

    t2, _ := time.Parse("02/1 2006 15:04:05", time2)
    fmt.Println(t2.UTC())

    t3, _ := time.Parse("2006-01-02T15:04:05-07:00", time3)
    fmt.Println(t3.UTC())

    t4, _ := time.Parse(time.RFC3339, time4)
    fmt.Println(t4.UTC())


## Enumerations

Enumerated constants are created using the `iota` enumerator. Since `iota` can
be part of an expression and expressions can be implicitly repeated, it is easy
to build intricate sets of values. The ability to attach a method such as
`String` to any user-defined type makes it possible for arbitrary values to
format themselves automatically for printing. `time.Duration` is defined in a
similar fashion.

    type ByteSize float64

    const (
        _           = iota // ignore first value by assigning to blank
        KB ByteSize = 1 << (10 * iota)
        MB
        GB
    )

    func (b ByteSize) String() string {
        switch {
        case b >= GB:
            return fmt.Sprintf("%.2fGB", b/GB)
        case b >= MB:
            return fmt.Sprintf("%.2fMB", b/MB)
        case b >= KB:
            return fmt.Sprintf("%.2fKB", b/KB)
        }
        return fmt.Sprintf("%.2fB", b)
    }


## Stack vs heap allocation

Generally speaking, we want our data on the stack (for reasons of performance:
no dereferencing, cache friendliness (locality), and less garbage collection
overhead).

When possible, the Go compilers will allocate variables that are local to a
function in that function's stack frame. However, if the compiler cannot prove
that the variable is not referenced after the function returns, then the
compiler must allocate the variable on the garbage-collected heap to avoid
dangling pointer errors.

In current compilers, if a variable has its address taken, that variable is a
candidate for allocation on the heap. However, a basic "escape analysis"
recognizes some cases when such variables will not live past the return from the
function and can reside on the stack.


## I/O and files

Check if a file/directory exists

    if _, err := os.Stat("/path/to/whatever"); os.IsNotExist(err) {
        return err
    }

Create a directory:

    // error is of type *os.PathError
    err := os.Mkdir("/my/dir", 0744)
    err := os.MkdirAll("/my/dir", 0744)

Read an entire file into a string:

    data, err := ioutil.ReadFile("/tmp/dat")

Open a file for reading:

     f, err := os.Open("/tmp/dat")
     if err != nil { ... }
     defer f.Close()

Open a file for writing:

     f, err := os.OpenFile("/tmp/dat", os.O_WRONLY|os.O_CREATE, 0644)
     if err != nil { ... }
     defer f.Close()

Read line-by-line with `Scanner`:

     s := bufio.NewScanner(f)
     for s.Scan() {
         fmt.Printf(s.Text() + "\n")
     }

Read line-by-line with a `bufio.Reader`:

    r := bufio.NewReader(f)
    for {
        line, err := r.ReadString('\n')
        fmt.Print(line)
        if err != nil {
            if err == io.EOF {
                break
            } else {
                return fmt.Errorf("failed to read line: %s", err)
            }
        }
    }



## JSON

Reading and writing data is accomplished with the `encoding/json` package.

Encoding a data structure into JSON is performed via `Marshal`:

    func Marshal(v interface{}) ([]byte, error)

Decoding JSON into a data structure is done via `Unmarshal`:

    func Unmarshal(data []byte, v interface{}) error

It is possible to annotate fields to customize how they are encoded/decoded:

*NOTE: The json package only accesses exported fields of struct types (those
that begin with an uppercase letter).*

    type Message struct {
        Name string     `json:"name"`
        Body string
        Time int
    }

    m := Message{"Alice", "Hello", 1554284294}
    b, _ := json.Marshal(m)
    fmt.Println(string(b)) // {"name":"Alice","Body":"Hello","Time":1554284294}


    var m2 Message
    err := json.Unmarshal(b, &m)


Custom marshalling/unmarshalling for a user-defined type can be provided by
writing `MarshalJSON` and `UnmarshalJSON` methods for the type.

    type Duration time.Duration

    func (d Duration) MarshalJSON() ([]byte, error) {
        return json.Marshal(fmt.Sprintf("%s", time.Duration(d)))
    }

    func (d *Duration) UnmarshalJSON(b []byte) error {
        var v interface{}
        if err := json.Unmarshal(b, &v); err != nil {
            return err
        }
        switch value := v.(type) {
        case float64:
            *d = Duration(time.Duration(value))
            return nil
        case string:
            tmp, err := time.ParseDuration(value)
            if err != nil {
                return err
            }
            *d = Duration(tmp)
            return nil
        default:
            return errors.New("invalid duration")
        }
    }

When we want to parse one entry at a time from a long (potentially infinite)
stream of JSON, we can use `json.NewDecoder(io.Reader)`. Consider a very large
document which we don't want to load in its entirety into memory:

    {
      ...
      "persons": [
        { "name": "foo", "age": 30 },
        ... millions of entries
      ]
      ...
    }

The following snippet shows how to read it element-by-element

        jsonStr := `
          {
            "animals": ["zebra", "giraffe"],
            "persons": [
               { "name": "foo", "age": 30 },
               { "name": "bar", "age": 35 }
             ],
             "cars": ["volvo"]
          }`

        type Person struct {
            Name string `json:"name"`
            Age  int    `json:"age"`
        }

        dec := json.NewDecoder(strings.NewReader(jsonStr))
        // read tokens until we reach "persons"
        for {
            token, _ := dec.Token()
            fmt.Printf("read token: %v (%T)\n", token, token)
            if token == "persons" {
                break
            }
        }

        // read the opening bracket of the persons array
        _, _ = dec.Token()
        // now start reading items, one-at-a-time
        for dec.More() {
            var person Person
            _ = dec.Decode(&person)
            fmt.Printf("person %#v\n", person)
        }



## XML parsing

Stream-based parsing (one entry at a time). Suitable for very large files.

    // element to be parsed from XML stream
    type Product struct {
        Name string `xml:"name,attr"`
        Type string `xml:"type,attr"`
    }

    ...

    src, _ := os.Open(xmlPath)
    defer src.Close()

    decoder := xml.NewDecoder(src)
    for {
        token, _ := decoder.Token()
        switch elem := token.(type) {
        case xml.StartElement:
            // If we just read a StartElement token and its name is "prod-item"
            if elem.Name.Local == "prod-item" {
                var product Product
                _ := decoder.DecodeElement(&cpeItem, &elem)
                // do something with product ...
            }
        default:
            log.Debug().Msgf("ignoring token %s", elem)
        }
    }

    if err == io.EOF {
        // normal exit
        return nil
    }


## Database

The `database/sql` package provides a generic interface around SQL(-like)
databases. A driver is needed to connect: http://golang.org/s/sqldrivers.

    import "database/sql"
    import _ "github.com/go-sql-driver/mysql"


    // func Open(driverName, dataSourceName string) (*DB, error)

    db, err := sql.Open("mysql", "user:password@/dbname")

`DB` is a database handle representing a pool of zero or more underlying
connections. It's safe for concurrent use by multiple goroutines. In fact, it is
encouraged to share a single `DB` instance between goroutines, since creating
more than one `DB` comes with a resource overhead (each has its own connection
pool, etc). Although it's idiomatic to `Close()` the database when you're
finished with it, the `sql.DB` object is designed to be long-lived. Create one
`sql.DB` object for each distinct datastore you need to access, and keep it
until the program is done accessing that datastore.

Open may just validate its arguments without creating a connection to the
database. To verify that the data source name is valid, call `DB.Ping()`.

    err = db.Ping()
    if err != nil {
        // do something here
    }

`Query()` is used for data retrieval of multiple rows:

    rows, err := db.Query("SELECT name FROM users WHERE age = $1", age)
    if err != nil {
        handleErr(err)
    }
    defer rows.Close()  // important: release connection!

    for rows.Next() {
        var name string
        if err := rows.Scan(&name); err != nil {
            handleErr(err)
        }
        ...
    }

    // important: check for errors after rows.Next() returns false!
    if err := rows.Err(); err != nil {

        handleErr(err)
    }

`QueryRow()` is used for single-row queries:

    var age int64
    err := db.QueryRow("SELECT age FROM users WHERE name = $1", name).Scan(&age)
    if err != nil {
        handleErr(err)
    }

`Exec` is used for data manipulation:

    result, err := db.Exec(
       "INSERT INTO users (name, age) VALUES ($1, $2)", "foobar", 27)
    if err != nil {
        handleErr(err)
    }

    fmt.Printf("updated %d rows.\n", res.RowsAffected())

To ensure that a transaction is always commited or rolled back (to ensure that
the underlying database connection isn't leaked), and to reduce the amount of
code, the following pattern can be used.

    type txFunc func(*sql.Tx) error

    // executes f within a transaction and handles closing of the transaction.
    func inTx(db *sql.DB, f txFunc) (err error) {
        tx, err := db.Begin()
        if err != nil {
            return errors.Wrapf(err, "failed to start transaction")
        }

        // make sure that we always end the transaction:
        // - rollback on error from the txFunc or a panic
        // - commit otherwise
        defer func() {
            if r := recover(); r != nil {
                tx.Rollback()
                panic(r) // re-panic
            }
            if err != nil {
                tx.Rollback()
                return
            }
            err = tx.Commit()
        }()

        err = f(tx)
        return
    }


    ...

    // executes within a transaction with guaranteed cleanup
    func (db *sql.DB) insertAdmin(name string) error {
        return inTx(db, func(tx *sql.Tx) error {
            _, err := tx.Exec("INSERT INTO people (name) VALUES ($1)", name)
            if err != nil {
                return err
            }

            _, err = tx.Exec("INSERT INTO groups (name, person) VALUES ('admins', $1)", name)
            if err != nil {
                return err
            }

            return nil
        })
    }

Note that helper types are available to read (`Scan`) database columns which may
have `NULL` values. For example, `sql.NullString`, `sql.NullInt`

    var nick  sql.NullString
    _ = db.QueryRow("SELECT nick FROM users WHERE name = $1", name).Scan(&nick)
    if nick.Valid {
        fmt.Printf("%s's nickname is %s", name, nick)
    } else {
        fmt.Printf("%s does not have a nickname", name)
    }


## Logging

- TODO: zerolog


## Command-line parsing
Simple command-line parsing can be done with the standard librar `flag` package:

    var flagvar int

    func init() {
        flag.IntVar(&flagvar, "flagname", 1234, "help message for flagname")
    }

    func main() {
        flag.Parse()
        fmt.Printf("flag value: %d\n", flagvar)
    }

For more complex command-line tools, with sub-commands, and which allows flags
to be input either via command-line options or environment variables, the
`viper/cobra` packages are useful:

    // main.go
    func main() {
        Execute()
    }

    // root.go
    func init() {
        // persistent: can be used in sub-commands
        rootCmd.PersistentFlags().String("host", "localhost", "Server host")
        rootCmd.PersistentFlags().Int("port", 1234, "Server port.")

        // Viper to access command-line flags (this allows us to also support
        // passing environment variables in place of flags).
        viper.BindPFlag("host", rootCmd.PersistentFlags().Lookup("host"))
        viper.BindPFlag("port", rootCmd.PersistentFlags().Lookup("port"))
        // Allow --port to be given as FTPCLIENT_PORT.
        viper.SetEnvPrefix("ftpclient")
        // environment variables use undescores ("_") rather than dashes ("-")
        viper.SetEnvKeyReplacer(strings.NewReplacer("-", "_"))
        viper.BindEnv("host")
        viper.BindEnv("port")
    }

    // rootCmd represents the base command when called without any subcommands
    var rootCmd = &cobra.Command{
        Use:   "ftpclient",
        Short: "An FTP client.",
        Long: `Longer description ...`,
    }

    func Execute() {
        if err := rootCmd.Execute(); err != nil {
            fmt.Println(err)
            os.Exit(1)
        }
    }

    // get.go : ftpclient get <path>
    func init() {
        rootCmd.AddCommand(getCmd)

        getCmd.Flags().String("mode", "binary", "Download mode")
        viper.BindPFlag("mode", getCmd.PersistentFlags().Lookup("mode"))
        viper.BindEnv("mode")
    }

    var getCmd = &cobra.Command{
        Use:   "get <path>",
        Short: "Get a file path from server.",
        Args:  cobra.ExactArgs(1),
        Run: func(cmd *cobra.Command, args []string) {
            c := ftp.NewClient(viper.GetString("host"), viper.GetInt("port"))
            defer c.Close()
            c.Download(viper.GetString("mode"))
            ...
        },
    }


## User input from stdio


    func Prompt(warning string) {
        fmt.Println(warning)
        var r string
        for {
            if r = prompt("Are you sure? (y/n)"); r != "y" && r != "n" {
                fmt.Printf("Please answer y/n.\n")
                continue
            }
            break
        }
        if r == "n" {
            fmt.Printf("aborting ...\n")
            os.Exit(1)
        }
        // ... proceed
    }

    func prompt(question string) string {
        reader := bufio.NewReader(os.Stdin)
        fmt.Printf(question + " ")
        response, err := reader.ReadString('\n')
        if err != nil {
            fmt.Println("aborting ...")
            os.Exit(1)
        }
        return strings.Trim(response, " \n")
    }


## Concurrency: Goroutines and channels

A *goroutine* is lightweight, costing little more than the allocation of stack
space. And the stacks start small, so they are cheap, and grow by allocating
(and freeing) heap storage as required. Goroutines are multiplexed onto multiple
OS threads so if one should block, such as while waiting for I/O, others
continue to run.

Besides the well-known thread synchronization primitives such as `sync.Mutex`
and `sync.Cond` Go offers a message-passing synchronization mechanism in
*channels*. Go channels can be viewed as a type-safe generalization of Unix
pipes.

TODO


## Tests
Tests are written in files ending in `_test.go` and use the `testing` package.

    import "testing"

    func TestSum(t *testing.T) {
        total := Sum(5, 5)
        if total != 10 {
           t.Errorf("Sum was incorrect, got: %d, want: %d.", total, 10)
        }
    }

Run tests via:

    go test -v
    go test -v ./pkg/...

With coverage

    go test -v -cover -coverprofile=coverage/coverage.txt ./pkg/... ./cmd/...
    # view in browser
    go tool cover -html coverage/coverage.txt

Table-driven tests are common in Go:

    func TestSum(t *testing.T) {
        tables := []struct {
            x int
            y int
            n int
        }{
            {1, 1, 2},
            {1, 2, 3},
            {2, 2, 4},
            {5, 2, 7},
        }

        for _, table := range tables {
            total := Sum(table.x, table.y)
            if total != table.n {
                t.Errorf("Sum of (%d+%d) was incorrect, got: %d, want: %d.", table.x, table.y, total, table.n)
            }
        }
    }

## stretchr/testify
Libraries like https://github.com/stretchr/testify can be used to simplify
testing:

    package yours

    import (
      "testing"
      "github.com/stretchr/testify/assert"
    )

    func TestSomething(t *testing.T) {
      assert.Equal(t, 123, 123, "they should be equal")
      assert.NotEqual(t, 123, 456, "they should not be equal")
      assert.Nil(t, object)
      if assert.NotNil(t, object) {
        assert.Equal(t, "Something", object.Value)
      }
    }

Every `assert` func returns a bool indicating whether the assertion was
successful or not, this is useful for if you want to go on making further
assertions under certain conditions.

To test many things you can also avoid specifying the `t` variable by:

    assert := assert.New(t)
    assert.Equal(123, 123, "they should be equal")
    assert.NotEqual(123, 456, "they should not be equal")

The `require` package provides same global functions as the assert package, but
instead of returning a boolean result they terminate current test.

    func TestSomething(t *testing.T) {
      require.Equal(t, 123, 456, "not equal, terminating test ...")
      // will not run
      require.Equal(t, 123, 123, "expected to be equal")


One can also test that a given function panics:

        failingFunc := func() {
            GoCrazyAndPanic()
        }

        assert.Panics(t, failingFunc)


## Mocking
A simple `mock` package https://github.com/stretchr/testify#mock-package:
As an example:

    type Runner interface {
        // Run executes an external command as a sub-process.
        Run(command *Command) error
    }

    // RunnerMock is a mocked object that implements the Runner interface
    type RunnerMock struct {
        mock.Mock
    }

    func (m *RunnerMock) Run(cmd *Command) error {
        args := m.Called(cmd)
        return args.Error(0)
    }

    func TestSomething(t *testing.T) {
            ...
            callerOfRunner := Caller{mockRunner}

            //
            // set up mock expectations
            //

            // On successful executions, these Run() calls should be made
            mockRunner.On("Run", expectedCmd1).Return(nil)
            mockRunner.On("Run", expectedCmd1).Return(nil)

            //
            // make calls
            //
            err := callerOfRunner.Call()
            assert.Nil(err, "expected Prepare() call to succeed")

             // verify that expected mock calls were made
            mockRunner.AssertExpectations(t)
    }


## Versioning

It is common to want a semantic version for a program (and to have the git
commit part of that version string). This can be achieved by having the linker
set a version field at compile-time. For example, add a `pkg/version/version.go`
like this:

    package version

    import (
        "github.com/Masterminds/semver"
    )

    // Versioning metadata.
    var (
        // Version is the release version of the program, such as '1.2.3'. The
        // version must follow the semantic version format (https://semver.org)
        // `MAJOR.MINOR.PATCH`, optionally followed by a hyphen and an
        // additional string, for example `1.2.3-alpha.1`.  The complete program
        // version, will be produced by appending GitCommit to Version, to
        // produce somehting like `1.2.3-alpha.1+c282415`.
        Version = "0.0.1"

        // GitCommit is a piece of version metadata (a git commit) that will be
        // appended to the Version to form the complete version. This is
        // intended to be set by the linker at build-time to a unique commit
        // prefix such as `c282415` (produce via `git rev-parse --short HEAD`).
        GitCommit string
    )

    // FullVersion returns the full semantic version of the program. It is a
    // concatenation of the Version (`1.2.3-alpha.1`) and the GitCommit (if one is
    // set), for example: `1.2.3-alpha.1+c282415`.
    func FullVersion() *semver.Version {
        versionString := Version
        if GitCommit != "" {
            versionString += "+" + GitCommit
        }

        return semver.MustParse(versionString)
    }

Then add something like this to your build (in this case, using `Makefile`):

    # GIT_COMMIT is the GitCommit that will be "injected" into the program version
    # to form the full version. It can be passed directly from the command line via:
    # "make compile GIT_COMMIT=abc1234".
    GIT_COMMIT?=$(shell git rev-parse --short HEAD)

    ...

    build:
        go build -ldflags "-X github.com/my/service/pkg/version.GitCommit=$(GIT_COMMIT)";
    ...



## Profiling
https://golang.org/pkg/runtime/pprof/
https://jvns.ca/blog/2017/09/24/profiling-go-with-pprof/
https://coder.today/tech/2018-11-10_profiling-your-golang-app-in-3-steps/

TODO: https://github.com/golang/go/wiki/Performance#cpu-profiler
TODO: https://github.com/golang/go/wiki/Performance#memory-profiler


https://golang.org/pkg/net/http/pprof/

https://github.com/elastisys/kube-insight-logserver#run
https://github.com/elastisys/kube-insight-logserver/blob/master/pkg/server/http.go#L51
