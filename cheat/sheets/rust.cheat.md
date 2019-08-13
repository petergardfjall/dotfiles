# Rust in a nutshell
Rust is a systems programming language focusing on safety, speed, and
concurrency.

It achieves memory-safety without using garbage collection by employing an
ownership model that is enforced at compile-time. The compiler neither allows
null pointers, dangling pointers, nor data races. Memory is managed via the
*Resource Acquisition Is Initialization* (RAII) idiom. All values have a unique
owner. Values can be moved (passed as value `T`), and passed by (immutable `&T`
or mutable `&mut T`) references. The safety of using references/pointers
(avoiding dangling pointers) is controlled via *lifetimes*, which are enforced
at compile time by the *borrow checker*.

So Rust's type system ensures that you don't get the kind of memory errors which
are common in C++. Memory leaks, accessing uninitialised memory, and dangling
pointers are all impossible in Rust. A large class of common errors (and
security vulnerabilities) can thus be caught already at compile-time.

There are ways around the ownership/borrowing rules, which may be necessary to
implement low-level system interactions or abstractions, that the programmer
knows to be correct but which the compiler, with its limited rule set, won't
allow. Such code can be placed in `unsafe` blocks.


# Variables and constants
Variables are introduced with `let`. Some notable details:

- By default variables are immutable (similar to `const` variables in C++).
  Mutability is explicitly marked (the `mut` modifier).
- Snake case is the conventional style for function and variable names.
- The type can be explicit or inferred (similar to `auto` in C++).
- *Shadowing*: a variable can be re-declared, which shadows the original.


        fn main() {
            let x1 = 5;
            let x2: i32 = 5; // equivalent

            let mut y = 1;
            y = y + 1;  // OK: mutable

            let x1 = "a"; // OK: shadows prior x

            println!("x1 is {}, x2 is {}, y is {}", x1, x2, y)
        }

Variables follow the RAII idiom. They are dropped when their enclosing scope
ends (runs destructor).

Constants aren't just immutable by default - they're always immutable. A
constant is set at compile-time and may therefore only be set to a constant
expression. Constants can be declared in any scope.

    const MAX_POINTS: u32 = 100_000;
    const THRESHOLD: i32 = 10;


# Primitive Types
All primitive types use copy semantics and are stored on the stack.

- Integer types. Signed (`i8`, `i16`, `i32`, `i64`, `isize`) and unsigned (`u8`,
  `u16`, `u32`, `u64`, `usize`).

        // literals can use visual separators via underscores
        let kilo = 1_000;

        // hex, octal, binary
        let hex = 0xff;
        let oct = 0o77;
        let bin = 0b1111_1111;
        let byte = b'A'; // only for u8

  Numeric types are coerced and cast via `as`.

        let decimal = 65.4321_f32;
        // Explicit conversion
        let integer = decimal as u8;

- Floating-point types: `f32`, `f64`

        let x = 0.0;      // f64 (default on most architectures)
        let x: f32 = 0.0; // f32

- `bool` type

        let t = true;
        let f: bool = false; // with explicit type annotation

- `char` type. Chars and strings are Unicode. Rust's char type is four bytes in
  size and represents a Unicode Scalar Value, which means it can represent a lot
  more than just ASCII.

        let c = 'z';
        let z = 'ℤ';
        let heart_eyed_cat = '😻';

- Tuples -- anonymous, heterogeneous sequences of data.

        let tup = (500, 6.4, 1);
        let (x, y, z) = tup;
        println!("The value of y is: {}", y);

        let x: (i32, f64, u8) = (500, 6.4, 1);
        let five_hundred = x.0;
        let six_point_four = x.1;
        let one = x.2;

- Arrays. Fixed-size, indexable sequence of data. Useful when you want your data
  allocated on the stack rather than the heap. For other cases, use `Vec`.

        let a: [i32; 5] = [1, 2, 3, 4, 5];

        let first = a[0];
        let second = a[1];

        // slices can point to sections of an array
        let slice = &a[2..4];


# Custom types (structs, enums)

- `struct`. Similar to a C/C++ struct without methods. Simply a list of named
  fields.

        struct User {
            username: String,
            email: String,
            sign_in_count: u64,
            active: bool,
        }

  One can use *field-init shorthand* when variables and fields have the same
  name.

        fn build_user(email: String, username: String) -> User {
            User {
                email,
                username,
                active: true,
                sign_in_count: 1,
            }
        }

  Field by field copying can be shortened via *struct update syntax*.

        let user2 = User {
            email: String::from("another@example.com"),
            username: String::from("anotherusername567"),
            ..user1
        };

  Structs with no fields (*unit-like structs*) do not use braces in either their
  definition or literal use (they can be useful sometimes to implement a trait
  when you don't have any data/state to carry).

        struct Electron;
        let x = Electron;

  One can add behavior (methods) via `impl`. To allow `println!` debug output,
  add a `#[derive(Debug)]` attribute to the type .

        #[derive(Debug)]
        struct Rectangle {
            width: u32,
            height: u32,
        }

        impl Rectangle {
            fn area(&self) -> u32 {
                self.width * self.height
            }
        }

        fn main() {
            let rect1 = Rectangle { width: 30, height: 50 };

            println!("rectangle: {:?}", rect1);
            println!(
                "The area of the rectangle is {} square pixels.",
                rect1.area()
            );
        }

  Methods can take ownership of `self`, borrow `self` immutably, or borrow
  `self` mutably, just as they can any other parameter. Having a method that
  takes ownership of the instance by using just `self` as the first parameter is
  rare; it is usually used when the method transforms `self` into something else
  and you want to prevent the caller from using the original instance after the
  transformation.

  A `struct` is allowed to have multiple `impl` blocks.

  `struct`s can store references to data owned by something else, but to do so
  requires the use of lifetimes.

  One can also define associated functions within `impl` blocks that don't take
  `self` as a parameter (often used to define constructors). `String::from` is
  an example.

- *Tuple structs* are named tuples, or alternatively, structs with unnamed
  fields. Their fields must be accessed by destructuring (like a tuple), rather
  than by name. Tuple structs are not very common, but are useful when you want
  to give the whole tuple a name and make the tuple be a different type from
  other tuples, and naming each field as in a regular struct would be verbose or
  redundant.

        // NOTE: parenthesis, not braces!
        struct Color(i32, i32, i32);

        fn main() {
                let black = Color(0, 0, 0);
                let Color(r, g, b) = black;
                println!("red: {}, green: {}, blue: {}", r, g, b);
        }


- `enum`. Enums are like C++ enums or unions -- they are types which can take
  multiple values. However, Rust enums are more powerful. Each variant can
  contain data. In this way they are more like unions than enums in C++. Each
  variant can have different types and amounts of associated data.

        enum IpAddr {
            V4(u8, u8, u8, u8),
            V6(String),
        }
        let home = IpAddr::V4(127, 0, 0, 1);
        let loopback = IpAddr::V6(String::from("::1"));

        enum WebEvent {
            // An enum may either be "unit-like",
            PageLoad,
            PageUnload,
            // ... like tuple structs,
            KeyPress(char),
            Paste(String),
            // ... or like structures.
            Click { x: i64, y: i64 },
        }

  Fields in structs or enums aren't marked as mutable, their mutability is
  inherited. If you want a reference field to be mutable, you have to use `&mut`
  on the field type.

  To use enums we usually use a `match` expression.

        fn inspect(event: WebEvent) {
            match event {
                WebEvent::PageLoad => println!("page loaded"),
                WebEvent::PageUnload => println!("page unloaded"),
                // Destructure `c` from inside the `enum`.
                WebEvent::KeyPress(c) => println!("pressed '{}'.", c),
                WebEvent::Paste(s) => println!("pasted \"{}\".", s),
                // Destructure `Click` into `x` and `y`.
                WebEvent::Click { x, y } => {
                    println!("clicked at x={}, y={}.", x, y);
                },
            }
        }

  Many simple cases of object-oriented polymorphism are better handled in Rust
  using enums.

  One particularly common enum in Rust is `Option<T>`, which is used where
  `null` checks would be used in many other languages.


# Standard library collections
The following common collections are dynamic and stored on the heap.

- String: `std::string::String`. A growable, mutable, owned, UTF-8 encoded
  string type in the standard library. Rust has only one string type in the
  *core* language, which is the *string slice* `str` that is usually seen in its
  borrowed form `&str`. String literals, for example, are stored in the
  program's binary and are therefore string slices.


        let mut s1 = String::new();

        let s2 = String::from("hello");
        let s3 = format!(" world");

        s1.push_str(&s2);
        s1.push_str(&s3);
        println!("{}", s1);

  The `format!()` macro is handy:

        format!("{}-{}-{}", "tic", "tac", "toe");

  String concatenation works with the `+` operator but moves the LHS.

        let s1 = String::from("Hello, ");
        let s2 = String::from("world!");
        let s3 = s1 + &s2; // note s1 has been moved, can no longer be used

  This is due to the method signature, which is roughly

        // note: takes ownership of self (doesn't just borrow via &self)
        fn add(self, s: &str) -> String

  Strings do not support indexing due to Unicode's variable-length encoding of
  chars. If you need to perform operations on individual Unicode scalar values,
  the best way to do so is to use the `chars()` method, which allows you to
  iterate over the characters.

        for c in "hello world".chars() {
          println!("{}", c);
        }

  One can also get a slice of raw bytes, which may work depending on the
  encoding.

        for b in "hello world".bytes() {
          println!("{}", b);
        }

  One can also convert a string to a char vector:

        // Copy chars into a vector, sort and remove duplicates
        let mut chars: Vec<char> = "hello world".chars().collect();
        chars.sort();
        chars.dedup();


- Vector: `std::vec::Vec<T>`.

        {

           let mut v1: Vec<i32> = Vec::new();
           v1.push(1);
           v1.push(2);
           v1.push(3);

           let mut v2 = vec![1, 2, 3];
           let third: &i32 = &v2[2];

           // error: borrowing rules protect us from mutating while there is a
           // reference to an element of the vector (this could make the ref
           // invalid due to reallocation).
           // v2.push(4);

           println!("third element is {}", third)

        } // <- v1 and v2 go out of scope and are dropped here

  Iterating over a vector:

        let v = vec![100, 32, 57];
        for i in &v {
            println!("{}", i);
        }

        // mutate elements
        let mut v = vec![100, 32, 57];
        for i in &mut v {
            *i += 50;
        }

- HashMap: `std::collections::HashMap<T>`.

        use std::collections::HashMap;

        let mut scores = HashMap::new();
        scores.insert(String::from("Blue"), 10);
        scores.insert(String::from("Yellow"), 50);

        for (key, value) in &scores {
            println!("{}: {}", key, value);
        }

  For types that implement the `Copy` trait, like `i32`, values are copied into
  the hash map. For owned values like `String`, keys and values will be moved
  and the hash map will be the owner of those values.

        let key = String::from("Favorite color");
        let val = String::from("Blue");

        let mut map = HashMap::new();
        map.insert(key, val);
        // error: key and val are invalid at this point
        // println!("{} = {}", key, val);

  If we insert references to values into the hash map, the values won't be moved
  into the hash map, but the values that the references point to must be valid
  for at least as long as the hash map is valid.

  The `entry(x).or_insert(y)` comes in handy to insert a value only if a key is
  not present.

         let text = "hello world wonderful world";

         let mut map = HashMap::new();
         for word in text.split_whitespace() {
             let count = map.entry(word).or_insert(0);
             *count += 1;
         }

         println!("{:?}", map);


# Control flow
A block without trailing semi colon is an expression.

    fn main() {
        let v = {
            1
        };
        println!("{}", v);
    }

`if` is an expression:

    fn main() {
        let v = if true { 1 } else { 2 };

        println!("{}", v);
    }

`while` and `loop` are the available looping constructs.

    let mut i = 10;
    while i > 0 {
        println!(i);
        i -= 1;
    }

    let result = loop {
        counter += 1;
        if counter == 10 {
            break counter * 2;
        }
    }

`for .. in` works with iterators and ranges (idiomatic for "countdown looping").

    let a = [10, 20, 30, 40, 50];

    for element in &a {
        println!("the value is: {}", element);
    }

    for v in 0..10 {
        println!("{}", v);
    }

`match` is a `switch` on steroids. It must be exhaustive (cover all cases) and
can deconstruct values. It can include an or operator (`|`) to use the same
action for multiple patterns, and can also use `if` to create conditional match
arms.

    #[derive(Debug)]
    enum IP {
        V4(u8, u8, u8, u8),
        V6(String),
    }

    fn main() {
        let ip1 = IP::V4(127, 0, 0, 1);
        let ip2 = IP::V4(192, 0, 0, 1);
        let ip3 = IP::V6(String::from("::1"));
        let ip4 = IP::V6(String::from("2001:0db8:0000:0000:0000:ff00:0042:8329"));

        for ip in [ip1, ip2, ip3, ip4].iter() {
            print!("checking {:?} ... ", ip);
            match ip {
                IP::V4(127, 0, 0, 1) => println!("IPv4 loopback"),
                IP::V4(p1, p2, p3, p4) => println!("an IPv4 address {}.{}.{}.{}", p1, p2, p3, p4),
                IP::V6(ref addr) if addr == "::1" => println!("IPv6 loopback"),
                _ => println!("something else"),
            }
        }
    }


`if let` is useful when we are only interested in a single case (remember:
`match` must be exhaustive), to handle values that match one pattern while
ignoring the rest.

    let ip = IP::V4(192, 0, 0, 1);

    if let IP::V4(p1, p2, p3, p4) = ip {
        println!("an IPv4 address: {}.{}.{}.{}", p1, p2, p3, p4);
    }

There is also a `while let` which uses a similar pattern.

    while let Some(i) = optional { ... }


# Destructuring
Destructuring is done primarily through the `let` and `match` statements. The
match statement is used when the structure being destructured can have different
variants (such as an `enum`). A `let` expression pulls the variables out into
the current scope, whereas `match` introduces a new scope.

Match arms and `let` expressions can bind to parts of the values being
matched. This allows us to extract/bind values out of `enum` variants and
`struct`s.

    struct Point {
        x: i32,
        y: i32,
        z: i32,
    }

    fn main() {
        let p = Point { x: 0, y: 7, z: 2 };

        let Point { x: a, y: b, z: c } = p;
        println!("a is: {}", a); // -> 0
        println!("b is: {}", b); // -> 7
        println!("c is: {}", c); // -> 2

        let p = Point { x: 10, y: 7, z: 2 };
        // only care about x
        let Point { x: a, .. } = p;
        println!("a is: {}", a); // -> 10
    }


or

    match x {
        Some(50) => println!("Got 50"),
        Some(y) => println!("Matched, y = {:?}", y),
        _ => println!("Default case, x = {:?}", x),
    }

One can use or `|` to capture several values in one match arm:

    let x = 1;

    match x {
        1 | 2 => println!("one or two"),
        3 => println!("three"),
        _ => println!("anything"),
    }

The `...` syntax allows us to match to an inclusive range of values.

    let x = 5;

    match x {
        1...5 => println!("one through five"),
        _ => println!("something else"),
    }


Ignoring remaining parts of a value is done with `..`:

    let p = Point { x: 10, y: 7, z: 2 };
    // only care about x
    let Point { x: a, .. } = p;
    println!("a is: {}", a); // -> 10

A *match guard* is an additional `if` condition specified after the pattern in a
match arm that must also match:

    let num = Some(4);

    match num {
        Some(x) if x < 5 => println!("less than five: {}", x),
        Some(x) => println!("{}", x),
        None => (),
    }

The at operator (`@`) lets us create a variable that holds a value at the same
time we're testing that value to see whether it matches a pattern.

    let x = 1;

    match x {
        e @ 1 ... 5 => println!("got a range element {}", e),
        _ => println!("anything"),
    }

To match references, or destructure to a reference, one can use `&`, `ref` and
`ref mut`. However, note that matching on references has been simplified as of
RFC 2005 (https://github.com/rust-lang/rfcs/pull/2005), nevertheless, the old
reference matching syntax is both valid and common in older code.

    #[derive(Debug)]
    struct Person {
        name: String,
    }

    fn main() {
        let mut p = Person { name: String::from("foo") };

        // note: a `ref` on the LHS is equivalent to an `&` on the RHS.
        // let ref_p = &p;
        // let ref ref_p = p;

        // match the whole struct reference (old, explicit, syntax)
        match &p {
            ref person => println!("name is {}", person.name),
        }

        // match the whole struct reference (uses default binding mode
        // from RFC 2005)
        match &p {
            person => println!("name is {}", person.name),
        }

        // Destructure struct reference with reference to inner field (old
        // syntax)
        match &p {
            &Person { name: ref n } => println!("name is {}", n),
        }

        // Destructure struct reference with reference to inner field (uses
        // default binding mode from RFC 2005)
        match &p {
            Person { name: n } => println!("name is {}", n),
        }

        // Destructure struct reference with mutable reference to inner field.
        match &mut p {
            Person{ name: ref mut n } => n.push_str("bar"),
        }

        // note: would cause a move of name (no 'ref' or 'ref mut')
        // match &p {
        //    &Person { name: n } => println!("name is {}", n),
        // }

        println!("person is {:?}", p); // { name: "foobar" }
    }


# Errors
In Rust, `Result<T, E>` is used for recoverable errors and the `panic!` macro is
used for unrecoverable situations (aborts execution).

When the `panic!` macro executes, your program will print a failure message,
unwind and clean up the stack, and then quit. Set the `RUST_BACKTRACE`
environment variable to get a backtrace.

The standard library makes extensive use of the `Result` enum:

    pub enum Result<T, E> {
        Ok(T),
        Err(E),
    }

For example:

    use std::fs::File;
    use std::io::prelude::*;

    fn main() {
        let mut f = match File::open("foo.txt") {
            Ok(file) => file,
            Err(error) => panic!("Problem opening the file: {:?}", error),
        };

        let mut buf = String::new();
        if let Err(error) = f.read_to_string(&mut buf) {
            panic!("read failed: {:?}", error);
        }

        print!("{}", buf);
    }

Error propagation, for functions returning `Result<T,E>`, is made much more
compact with the *question mark operator* `?`, placed after a `Result` value. If
the value of the `Result` is an `Ok`, the value inside the `Ok` will get
returned from this expression, and the program will continue. If the value is an
`Err`, the `Err` will be returned from the whole function.

    use std::fs::File;
    use std::io;
    use std::io::Read;

    fn read_file(path: &str) -> Result<String, io::Error> {
        let mut f = File::open(path)?;
        let mut s = String::new();
        f.read_to_string(&mut s)?;
        Ok(s)
    }

    fn main() {
        match read_file("foo.txt") {
            Ok(content) => print!("{}", content),
            Err(err) => panic!("failed to read file: {}", err),
        }
    }

A more functional approach to the former call is to use `unwrap_or_else`:

    let content = read_file("foo.txt").unwrap_or_else(|err| panic!("failed to read file: {}", err));

    print!("{}", content);

The `unwrap` method is similar but causes a panic on error. `expect` is yet
another option, that allows you to choose panic message yourself.

`Result<(), Box<dyn Error>>` is a return type that is capable of returning any
error via a trait object `Box<dyn Error>`.


    fn main() -> Result<(), Box<dyn Error>> {
        let content = read_file("foo.txt")?;

        print!("{}", content);
        Ok(())
    }


# Ownership
Ownership is Rust's most unique feature, and it enables Rust to make memory
safety guarantees without needing a garbage collector: memory is managed through
a system of ownership with a set of rules that the compiler checks at compile
time.

In general, Rust has move rather than copy semantics. Primitive types have copy
semantics. Passing a variable to a function will move or copy, just as
assignment does.

The basic ownership rules are these:

- *Single owner*. Each value in Rust has a variable that's called its *owner*.
- There can only be one owner at a time. Move semantics is the default behavior
  (a type may choose to implement the `Copy` trait to default to copy semantics,
  like the primitive types). This means that assigning to another variable or
  passing to a function moves ownership (and invalidates the source, which means
  there will be no "double frees"):

        let x = format!("hello world");
        let y = x;   // String value is moved here x -> y
        println!("y: {}", y);

        // error: x is invalid after being moved from
        //println!("x: {}", x);

        ...

        // Takes ownership of string s.
        fn do_stuff(s: String) {
           ...
        } // <- s is dropped

        let v = String::from("hello world");
        do_stuff(v); // v is moved to do_stuff, invalid from this point on.

  If we *do* want copy semantics (deep copy) for a type such as `String`, we can
  be explicit about it using the `clone` method (given that the type satisfies
  the `Clone` trait). This explicily makes a deep copy and also shows that
  something more expensive (than a pointer copy) is going on.

        let s1 = String::from("hello");
        let s2 = s1.clone();

        println!("s1: {}", s1);
        println!("s2: {}", s2);

- When the owning variable goes out of scope, the value will be dropped/freed
  (according to the RAII idiom) and destructor code is run (if `Drop` trait is
  implemented).


There are roughly three categories of values:

- Non-copyable values: *move* from place to place: assigning a value to another
  variable moves it. This is the default for custom-defined types. Example:
  `money`.
- Clonable values: move from place to place but you can explicitly run custom
  code to make a deep copy. Example: `String`, `Vec` (if elements are copyable).
- Copyable values: type is implicitly copied when accessed. This goes for all
  primitive types (like integer and floating-point numbers) and types that has
  the `Copy` trait. For these, an older variable is still usable after
  assignment. Note that Rust won't let us annotate a type with the `Copy` trait
  if the type, or any of its parts, has implemented the `Drop` trait.


# Borrowing (references)
References allow you to refer to some value without taking ownership of it - the
value it points to will not be dropped when the reference goes out of
scope. Having references in Rust is known as *borrowing*.

There are two types of borrows: shared/immutable and mutable:

- *Shared borrows* `&T`. References are immutable by default. It gives
  temporary, read-only access to data. A reference won't drop its value when its
  scope ends. It doesn't *own* the value, it just *borrows* it. A shared
  reference is immutable. An example of passing a reference in a function call.

        // borrows s (shared/immutably)
        fn len(s: &String) -> usize {
            s.len()
        } // <- note: s is *not* dropped here since it's only borrowed (not owned)

        fn main() {
            let s = String::from("hello");

            // "lend s to len function"
            let length = len(&s);
            println!("s1: {}", length);
        }

  One can, of course, borrow/take references during assignment as well:

        let name = String::from("foo");

        // equivalent assignments
        let r = &name;
        let ref r = name;

- *Mutable borrows* `&mut T`: allows the data to be mutated while it is
  borrowed.

        // take a mutable reference to s
        fn modify(s: &mut String) {
            s.push_str("!")
        }

        fn main() {
            let mut s = String::from("hello");

            // lend s mutably
            modify(&mut s);
            println!("s: {}", s);
        }

  The mutable reference has exclusive access to the value for the entire time of
  the borrow. A mutable value, while borrowed, is frozen and cannot be mutated
  until the borrow ends. No mutation of the original value is allowed during the
  lifetime of a borrow.

        fn main() {
            let mut s = String::from("hello");
            {
                let s2 = &mut s;

                // error: s is frozen here since it's mutably borrowed
                // s.push_str("?");

                s2.push_str("!");
            }
            println!("s: {}", s);
        }

At compile-time the compiler enforces that you can only ever have one of the
following:

- one mutable reference.
- any number of immutable references.

This prevents data races at compile-time.

A reference's scope starts from where it is introduced and continues through the
last time that reference is used.

One of the primary safety goals of Rust is to avoid dangling pointers (where a
pointer outlives the memory it points to). In Rust, it is impossible to have a
dangling borrowed reference. It is only legal to create a borrowed reference to
memory which will live longer than the reference. The lifetime of the reference
must be shorter than the lifetime of the referenced value. The compiler will
ensure that the data will not go out of scope before the reference to the data
does. Hence, no dangling pointers!

Another data type that does not have ownership is the *slice*. A string slice is
a reference to part of a `String`. Just like with any reference, the compiler
will ensure that a reference into a `String` remains valid. String literals are
slices `&str` (it's a slice pointing to that specific point of the binary).

In summary, there are three primary ways of passing data in Rust:
- By (moving) a value: `name: String`. This passes on ownership. The new owner
  controls all access and will free the value when it goes out of scope.
- By shared reference: `name: &String`. A borrow that allows many readers, but
  no writers.
- By mutable reference: `name: &mut String`. A borrow that allows a single
  writer, but no other readers.

To prevent dangling references, every reference in Rust has a lifetime, which is
the scope for which that reference is valid. More on that in the section on
lifetimes.


# Smart pointers
*Smart pointers* are data structures that not only act like a pointer
(implements the `Deref` trait) but also have additional metadata and
capabilities.

In Rust, which uses the concept of ownership and borrowing, a difference between
references (`&T`) and smart pointers is that references are pointers that only
borrow data; in contrast, in many cases, smart pointers *own* the data they
point to (implement the `Drop` trait).

- `Box<T>`. A unique, owning pointer for allocating values on the heap. These
  are similar to C++ `std::unique_ptr` but checked at compile time.

        // p takes ownership
        fn print(p: Box<u32>) {
            println!("value is {}", *p)
        } // <- p goes out of scope and is dropped

        fn main() {
            let ptr = Box::new(5); // allocate space on heap and initialize

            print(ptr); // ptr moved
        }

  Typically used when:

  - we want to use a type whose size can't be known at compile time (like
    recursive data structures such as a tree)

        #[derive(Debug)]
        struct Tree {
            value: u32,
            left: Option<Box<Tree>>,
            right: Option<Box<Tree>>,
        }

        fn main() {
            let tree1 = Tree { value: 1, left: None, right: None, };
            let tree2 = Tree { value: 2, left: None, right: None, };
            let tree3 = Tree {
                value: 1,
                left: Some(Box::new(tree1)),
                right: Some(Box::new(tree2)),
            };

            println!("tree: {:?}", tree3)
        }

  - to explicitly move (rather than copy) a large set of data.
  - polymorphic behavior (accept trait objects like `Box<dyn Draw>` as
    parameter).


- `Rc<T>`. Reference counted pointers that enable multiple ownership. These are
  similar to C++ `std::shared_ptr`, and are useful when we want to read the
  value from several parts of the program without knowing who'll finish last (no
  clear owner). To pass a ref-counted pointer you need to use the `clone`
  method. Rust's type system ensures that the ref-counted variable will not be
  deleted before any references expire. `Rc` objects are limited to a single
  thread and so the ref count operations don't have to be atomic. If you want a
  mutable ref-counted object you need to use a `RefCell` (or `Cell`) wrapped in
  an `Rc`.

        use std::rc::Rc;

        fn main() {
            let a = Rc::new(42);
            println!("count after creating a = {}", Rc::strong_count(&a));
            let b = Rc::clone(&a);
            println!("count after creating b = {}", Rc::strong_count(&a));
            {
                let c = Rc::clone(&a);
                println!("count after creating c = {}", Rc::strong_count(&a));
            }
            println!("count after c goes out of scope = {}", Rc::strong_count(&a));
        }

- `RefCell<T>`. There are situations in which it's useful for a value to mutate
  itself in its methods but appear immutable to other code (e.g. caching,
  mocks). For these cases we need *interior mutability*, a pattern where we
  mutate data even when there are immutable references to that data (normally,
  this action is disallowed by the borrowing rules). `RefCell<T>` allows for
  this. It enforces the borrowing rules at runtime instead of compile time and
  allows parts of immutable objects to be mutated. Through it we can access
  `Ref<T>` and `RefMut<T>`. Internally it uses unsafe code inside a data
  structure to bend Rust's usual rules that govern mutation and borrowing. The
  advantage is that certain memory-safe scenarios are then allowed, whereas they
  are disallowed by the compile-time checks (static analysis, like the Rust
  compiler, is inherently conservative). The `RefCell<T>` type is useful when
  you're sure your code follows the borrowing rules but the compiler is unable
  to understand and guarantee that.

        use std::cell::RefCell;

        #[derive(Debug)]
        struct CallCounter {
            calls: RefCell<String>
        }

        impl CallCounter {
            fn new() -> CallCounter {
                CallCounter{ calls: RefCell::new(String::from("")) }
            }

            fn call(&self, msg: &str) {
                println!("thanks for calling!");
                self.calls.borrow_mut().push_str(format!("{} ", msg).as_str());
            }
        }

        fn main() {
            let cc = CallCounter::new(); // note: immutable reference
            // note: changes internal state (via interior mutability)
            cc.call("hello");
            cc.call("world");
            println!("{:?}", cc)
        }

  `RefCell` is used for types which have move semantics. For copy semantic
  types, there is `Cell`.

  If you're using `Cell`/`RefCell`, you should put them on the smallest object
  you can. That is, prefer to put them on a few fields of a struct, rather than
  the whole struct.

- `Cell<T>`. Similar to `RefCell`, but used for types which have copy semantics
  (like primitive types).

- Raw (`unsafe`) pointers. Raw pointers are like C pointers, just a pointer to
  memory with no restrictions on how they are used (you can't do pointer
  arithmetic without casting). Raw pointers are the only pointer type in Rust
  which can be `null`. They can't be dereferenced (and thus can't be used)
  outside of an `unsafe` block.

Here is a recap of the reasons to choose `Box<T>`, `Rc<T>`, or `RefCell<T>`:

- `Rc<T>` enables multiple owners of the same data; `Box<T>` and `RefCell<T>`
  have single owners.

- `Box<T>` allows immutable or mutable borrows checked at compile time; `Rc<T>`
  allows only immutable borrows checked at compile time; `RefCell<T>` allows
  immutable or mutable borrows checked at runtime.

- Because `RefCell<T>` allows mutable borrows checked at runtime, you can mutate
  the value inside the `RefCell<T>` even when the `RefCell<T>` is immutable.

Note that preventing memory leaks (entirely) is not one of Rust's guarantees in
the same way that disallowing data races at compile time is (meaning memory
leaks are memory safe in Rust). For example, using `Rc<T>` and `RefCell<T>` it's
possible to create cyclic references. In certain cases, `Weak<T>` references can
be used to avoid introducing cycles that prevent a `Rc` pointer from being
freed.




## Lifetimes
Every reference in Rust has a *lifetime*, which is the scope for which that
reference is valid. Most of the time, lifetimes are implicit and inferred (just
like types are inferred most of the time). We must annotate types when multiple
types are possible. Similarly, we must annotate lifetimes when the lifetimes of
references aren't unambiguous. Rust requires us to annotate the relationships
using generic lifetime parameters to ensure that actual references used at
runtime will definitely be valid.

The Rust compiler has a *borrow checker* that compares scopes to determine
whether all borrows are valid. It ensures that referred data always live longer
than the reference. In other words, it protects us, at compile time, from
attempts to use a reference whose value has gone out of scope and been freed
(i.e. dangling references).

    // ERROR: attempt to take a reference to a value with shorter lifetime
    // will be caught by the borrow checker.
    // The lifetime of the reference r ('a) is longer that that of x ('b).
    {
        let r;                // ---------+-- 'a
                              //          |
        {                     //          |
            let x = 5;        // -+-- 'b  |
            r = &x;           //  |       |
        }                     // -+       |
                              //          |
        println!("r: {}", r); //          |
    }                         // ---------+

*Lifetime annotations* describe the relationships of the lifetimes of multiple
references to each other without affecting the lifetimes.

Rust can analyze the code *within* a function without help. However, when a
function has references to or from code outside that function, it becomes very
difficult for Rust to figure out the lifetimes of the parameters or return
values on its own. The lifetimes might be different each time the function is
called. This is why we need to annotate the lifetimes manually. When returning a
reference from a function, the lifetime parameter for the return type needs to
match the lifetime parameter for one of the parameters (if the reference
returned does not refer to one of the parameters, it must refer to a value
created within this function, which would be a dangling reference).

    // Tells Rust that for some lifetime 'a, the function takes two parameters,
    // both of which live at least as long as lifetime 'a. It also tells Rust
    // that the returned reference will live at least as long as lifetime 'a.
    fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
        if x.len() > y.len() {
            x
        } else {
            y
        }
    }

Ultimately, lifetime syntax is about connecting the lifetimes of various
parameters and return values of functions. Once they're connected, Rust has
enough information to allow memory-safe operations and disallow operations that
would create dangling pointers or otherwise violate memory safety.

`struct`s and `enum`s can also hold references. If so, they need to be lifetime
annotated.

    // Both references must outlive this struct
    #[derive(Debug)]
    struct NamedBorrowed<'a> {
        x: &'a i32,
        y: &'a i32,
    }

    // An enum which is either an `i32` or a reference to one.
    #[derive(Debug)]
    enum Either<'a> {
        Num(i32),
        Ref(&'a i32),
    }

Given those definitions, this compiles

    fn main() {
        let double;
        let reference;

        let x = 18;
        let y = 15;
        double = NamedBorrowed { x: &x, y: &y };
        reference = Either::Ref(&x);

        println!("x and y are borrowed in {:?}", double);
        println!("x is borrowed in {:?}", reference);
    }

whereas this fails

    fn main() {
        let double;
        let reference;

        {
            let x = 18;
            let y = 15;
            double = NamedBorrowed { x: &x, y: &y };
            reference = Either::Ref(&x);
        }

        println!("x and y are borrowed in {:?}", double);
        println!("x is borrowed in {:?}", reference);
    }

with this compilation error:

    error[E0597]: `x` does not live long enough
      --> src/main.rs:22:37
       |
    22 |         double = NamedBorrowed { x: &x, y: &y };
       |                                     ^^ borrowed value does not live long enough
    23 |         reference = Either::Ref(&x);
    24 |     }
       |     - `x` dropped here while still borrowed
    25 |
    26 |     println!("x and y are borrowed in {:?}", double);
       |                                              ------ borrow later used here

The compiler comes with *lifetime elision rules*, which allow us to skip
lifetime annotations for certain common cases. When no explicit lifetimes are
given, the compiler will *try* to come up with valid lifetime parameters using
these rules:

- each parameter that is a reference gets its own lifetime parameter
- if there is exactly one input lifetime parameter, that lifetime is assigned to
  all output lifetime parameters
- if there are multiple input lifetime parameters, but one of them is `&self` or
  `&mut self` (i.e., it's a method), the lifetime of `self` is assigned to all
  output lifetime parameters.

The special `'static` lifetime means that a reference lives for the entire
duration of the program.


## Traits
Traits are similar to interfaces in other languages. A lot of functionality in
Rust is modelled via traits. For example, the `Display` trait allows a value to
be written to be (`println!`) formatted via `{}` (it is similar to `toString()`
in Java). As another example, you can give your user-defined type copy semantics
by implementing the `Copy` trait.

As shown in the below example, function parameters can also have *trait bounds*
(`impl Speaker`).

    pub trait Speaker {
        fn speak(&self) -> String;
    }

    #[derive(Debug)]
    struct Human {
        name: String,
    }

    #[derive(Debug)]
    struct Parrot {
        name: String,
        age: u32,
    }

    impl Speaker for Human {
        fn speak(&self) -> String {
            return format!("hello!");
        }
    }

    impl Speaker for Parrot {
        fn speak(&self) -> String {
            return format!("polly!");
        }
    }

    // A parameter with some type that implements the Speaker trait.
    fn listen_to(s: impl Speaker) {
        println!("{}", s.speak());
    }

    fn main() {
        let h = Human {
            name: String::from("barry"),
        };
        let p = Parrot {
            name: String::from("polly"),
            age: 20,
        };

        listen_to(h);
        listen_to(p);
    }


The `impl Speaker` syntax works for straightforward cases but is only syntactic
sugar for *trait bound syntax*:

    pub fn listen_to<T: Speaker>(s: T) { ... }

With trait bound syntax it's possible to specify several bounds

    pub fn listen_to<T: Speaker + Display>(s: T) { ... }

or with a `where` clause, for improved readability in more complex cases:

    fn some_function<T, U>(t: T, u: U) -> i32
        where T: Display + Clone,
              U: Clone + Debug

One restriction to note with trait implementations is that we can implement a
trait on a type only if either the trait or the type is local to our crate. But
we can't implement external traits on external types. Without the rule, two
crates could implement the same trait for the same type, and Rust wouldn't know
which implementation to use.

Trait methods can have a default implementation. Default implementations can
call other methods in the same trait, even if those other methods don't have a
default implementation.

One can also implement traits conditionally, depending on what other traits are
implemented. These are called *blanket implementations*. For example, the
standard library implements the `ToString` trait on any type that implements the
`Display` trait.

Rust provides polymorphism/dynamic dispatch through a feature called *trait
objects*. Trait objects, like `&dyn Foo` or `Box<dyn Foo>`, store a value of any
type that implements the given trait, where the precise type can only be known
at runtime. Since it can be seen as "erasing" the compiler's knowledge about the
specific type of the pointer, trait objects are sometimes referred to as "type
erasure".

To have a function return a trait object, one can use the `Box<dyn Trait>`,
`&dyn Trait`, or `&mut dyn Trait` syntax.

    // Return some type that implements the Trait trait, but don't specify
    // exactly what the type is.
    fn function() -> Box<dyn Trait> {
    }

Similarly, we can accept trait objects as function arguments via
`Box<dyn Trait>`, `&dyn Trait`, or `&mut dyn Trait` syntax.

    fn listen_to(s: &dyn Speaker) {
        println!("{}", s.speak());
    }

    fn main() {
        let human = Human { name: String::from("barry"), };
        let parrot = Parrot { name: String::from("polly"), age: 20, };

        let vec: Vec<Box<dyn Speaker>> = vec![Box::new(human), Box::new(parrot)];
        for v in vec {
            listen_to(&*v);
        }
    }


## Generics
Generics are used to define general functions, `enum`s and `struct`s, which can
then be parameterized ("instantiated") with different concrete types. Either to
hold any type `T` (such as collections) or limited to types satisfying a certain
contract (i.e. trait bounds).

    #[derive(Debug)]
    struct Point<T, U> {
        x: T,
        y: U,
    }

    impl<T, U> Point<T, U> {
        fn x(&self) -> &T {
            &self.x
        }

        fn y(&self) -> &U {
            &self.y
        }
    }

    fn main() {
        let both_int = Point { x: 5, y: 10 };
        let int_and_float = Point { x: 5, y: 4.0 };

        println!("{:?}", both_int);
        println!("{:?}. x is {}, y is {}", int_and_float, int_and_float.x(), int_and_float.y());
    }

The standard library `Error` is another example:

    enum Result<T, E> {
        Ok(T),
        Err(E),
    }

Or generic functions:

    fn count<T>(list: &[T]) -> i32

With trait bounds:

    fn largest<T: PartialOrd>(list: &[T]) -> T


## Closures
A *closure* is a function-like construct that you can store in a
variable. Closures don't need to have their parameters/return type-annotated
like normal `fn` functions do. The compiler infers the types (as for variables
in `let x = <val>`. For example, the following function:

    fn  add_one_v1   (x: u32) -> u32 { x + 1 }

can be represented as a closure by either of the following:

    let add_one_v2 = |x: u32| -> u32 { x + 1 };
    let add_one_v3 = |x|             { x + 1 };
    let add_one_v4 = |x|               x + 1  ;

    println!("10 + 1 = {}", add_one_v4(10));

Types for closures, allowing them to be passed as function parameters or stored
in `struct`s, are provided through the: `Fn`, `FnMut`, or `FnOnce`
traits. `add_one_v4` above has type trait bound `Fn(u32) -> u32`. Note that
regular `fn` functions implement the `Fn` trait too.

    use std::collections::HashMap;

    struct Cacher<T>
    where
        T: Fn(u32) -> u32,
    {
        calculation: T,
        cache: HashMap<u32, u32>,
    }

    impl<T> Cacher<T>
    where
        T: Fn(u32) -> u32,
    {
        fn new(calc: T) -> Cacher<T> {
            Cacher {
                calculation: calc,
                cache: HashMap::new(),
            }
        }

        fn calculate(&mut self, val: u32) -> u32 {
            println!(
                "cached result for argument {}: {}",
                val,
                self.cache.contains_key(&val)
            );
            let val = self.cache.entry(val).or_insert((self.calculation)(val));
            *val
        }
    }

    fn main() {
        let add_one = |x| x + 1;

        let mut cacher = Cacher::new(add_one);

        println!("10 + 1 = {}", cacher.calculate(10));
        println!("10 + 1 = {}", cacher.calculate(10)); // cached
        println!("11 + 1 = {}", cacher.calculate(11));
    }


A closure can capture its environment and access variables from the scope in
which they're defined. Closures can capture variables:

- by reference: `&T`
- by mutable reference: `&mut T`
- by value (move): `T`

Variables are captured by reference and only go lower when required.

    let color = "green";

    // Will borrow (`&`) 'color' and store the borrow and closure in the 'print'
    // variable. It remains borrowed until 'print' goes out of scope.
    let print = || println!("`color`: {}", color);
    print();
    print();

    let mut count = 0;
    // Takes `&mut count`
    //
    // A `mut` is required on `incr` because a `&mut` is stored inside.
    // Thus, calling the closure mutates the closure which requires a `mut`.
    let mut incr = || {
        count += 1;
        println!("`count`: {}", count);
    };

    incr();

Using `move` before the vertical pipes forces a closure to take ownership of
captured variables:

    fn main() {
        // `Vec` has non-copy semantics.
        let haystack = vec![1, 2, 3];

        let contains = move |needle| haystack.contains(needle);

        println!("{}", contains(&1));
        println!("{}", contains(&4));
    }


## Projects, packages, crates and modules
Cargo is the idiomatic way to build Rust programs. It is Rust's package manager
(manages dependencies) and uses `rustc` under the hood to build Rust packages.
`crates.io` is the Rust community's central package registry.

The Rust *module system* includes these concepts:

- *Package*: consists of one or more *crates* that provide a set of
  functionality. A package is defined by a `Cargo.toml` file that describes how
  to build those crates. Dependencies to the project are declared in
  `Cargo.toml` and downloaded by `cargo`. A `use` statement is needed to bring
  paths from the crate into scope.

- *Crate*: a tree of *modules* that produces a library or a binary/binaries. The
  crate root is a source file (defaults to `src/main.rs` for a binary crate and
  `src/lib.rs` for a library crate) that Cargo passes to `rustc` to build the
  library or binary.

- *Modules*: let you control the organization, scope, and privacy of paths. A
  module groups related definitions and control their visibility through the
  `pub` keyword (items are private to a module by default). Items in a parent
  module can't use the private items inside child modules, but items in child
  modules can use the items in their ancestor modules.

- *Path*: a way of naming an item, such as a struct, function, or module. The
  `use` keyword brings a path into scope (adding `use` and a path in a scope is
  similar to creating a symbolic link in the filesystem).

        extern crate postgres; // when using crate external to our package

        use postgres::{Connection, TlsMode};

  An alias can be substituted for a path with `use ...  as x`. `pub use ...`
  re-exports an item such that it also becomes available to clients of our
  module.

A sample project layout:

    .
    ├── Cargo.lock
    ├── Cargo.toml
    ├── benches
    │   └── large-input.rs
    ├── examples
    │   └── simple.rs
    ├── src
    │   ├── bin
    │   │   └── another_executable.rs
    │   ├── lib.rs
    │   └── main.rs
    └── tests
        └── some-integration-tests.rs

- `Cargo.toml` and `Cargo.lock` are stored in the root of your package (package
  root).
- Source code goes in the `src` directory.
- The default library file is `src/lib.rs`.
- The default executable file is `src/main.rs`.
- Other executables can be placed in `src/bin/*.rs`.
- Integration tests go in the `tests` directory (unit tests go in each file
  they're testing).
- Examples go in the `examples` directory.
- Benchmarks go in the `benches` directory.

There are a few options options for organizing modules.

1. Keep modules in the same file (crate root: `src/main.rs` or `src/lib.rs`):

        fn main() {
           greetings::hello();
        }

        mod greetings {
          pub fn hello() {
            println!("Hello, world!");
          }
        }

2. A module goes into its own file under `src/<module>.rs`.

        // ↳ main.rs
        mod greetings; // import greetings module

        fn main() {
          greetings::hello();
        }


        // ↳ greetings.rs
        // No need to wrap the code with a mod declaration.
        // The file itself acts as a module.
        pub fn hello() {
          println!("Hello, world!");
        }

   If `hello` is wrapped in a `mod` declaration, that will act as a nested
   module:

        // ↳ main.rs
        mod phrases;

        fn main() {
          phrases::greetings::hello();
        }

        // ↳ phrases.rs
        pub mod greetings {
          pub fn hello() {
            println!("Hello, world!");
          }
        }

3. A module goes into its own directory under `src/<module>`. `mod.rs` in the
   module root acts as entry point.

        // ↳ main.rs
        mod greetings;

        fn main() {
          greetings::hello();
        }

        // ↳ greetings/mod.rs
        pub fn hello() {
          println!("Hello, world!");
        }

    Other files in the directory module act as sub-modules for `mod.rs`.

        // ↳ main.rs
        mod phrases;

        fn main() {
          phrases::hello()
        }

        // ↳ phrases/mod.rs
        mod greetings;

        pub fn hello() {
          greetings::hello()
        }

        // ↳ phrases/greetings.rs
        pub fn hello() {
          println!("Hello, world!");
        }


We can construct relative paths that begin in the parent module by using `super`
at the start of the path. This is especially useful in tests (which typically go
into their own `tests` module and need to import the items in the module under
test with `use super::*;`).

A few notes on visibility:
- can set `pub` on `mod`, `fn`, `struct`, `struct` fields, `enum`.
- `struct` fields need to be made public on a field-by-field basis.
- a `pub enum` will have all variants public.


## Unsafe
Unsafe Rust exists because, by nature, static analysis is conservative - it's
better for it to reject some valid programs rather than accept some invalid
programs. `unsafe` let's you do things that you know are correct, but which the
compiler fails to see. Also, it is necessary when writing/interacting with low
level systems. One major use case is when interfacing with C code.

`unsafe` blocks allow us to:

- Dereference a raw pointer.
- Call an `unsafe` function or method.
- Access or modify a mutable static variable.
- Implement an *unsafe trait*.

Note: `unsafe` doesn't turn off the borrow checker or disable any other of
Rust's safety checks: if you use a reference in `unsafe` code, it will still be
checked. The `unsafe` keyword only gives you access to the above four features
that are then not checked by the compiler for memory safety.

You will know that any errors related to memory safety must be within an
`unsafe` block, so keep `unsafe` blocks small. To isolate unsafe code as much as
possible, it's best to enclose unsafe code within a safe abstraction and provide
a safe API (parts of the standard library are implemented as safe abstractions
over unsafe code).

Unsafe Rust has two new types called *raw pointers*: `*const T` and `*mut T`.

    let mut num = 5;

    // cast references to raw pointer
    let r1 = &num as *const i32;
    let r2 = &mut num as *mut i32;

    // cast arbitrary memory location to raw pointer
    let address = 0x012345usize;
    let r = address as *const i32;

These raw pointers

- Are allowed to ignore the borrowing rules by having both immutable and mutable
  pointers or multiple mutable pointers to the same location.
- Aren't guaranteed to point to valid memory.
- Are allowed to be `null`.
- Don't implement any automatic cleanup.

We can create raw pointers in safe code; we just can't dereference raw pointers
outside an `unsafe` block.


    unsafe {
        println!("r1 is: {}", *r1);
        println!("r2 is: {}", *r2);
    }

*Unsafe functions* and methods look exactly like regular functions and methods,
but they have an extra `unsafe` before the rest of the definition, which
indicates the function has requirements we need to uphold when we call this
function:

    unsafe fn dangerous() { ... }

    unsafe {
        dangerous();
    }

Rust has a keyword, `extern`, that facilitates the creation and use of a Foreign
Function Interface (FFI) for when you want to interface with a different
language.

    // The "C" part defines which application binary interface (ABI)
    // the external function uses: the ABI defines how to call the function
    // at the assembly level
    extern "C" {
        fn abs(input: i32) -> i32;
    }

    fn main() {
        unsafe {
            println!("Absolute value of -3 according to C: {}", abs(-3));
        }
    }


# Documentation and references
https://doc.rust-lang.org/book/
https://doc.rust-lang.org/stable/rust-by-example
https://github.com/nikomatsakis/intorust/tree/master/docs/tutorial
https://github.com/nrc/r4cppp
https://doc.rust-lang.org/std/
