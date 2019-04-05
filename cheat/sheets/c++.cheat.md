## The tour

## Language basics

C++ is a compiled language. Each source file is processed by a compiler,
producing object files, which are combined by a linker into an executable.

An executable program is created for a specific hardware/system combination; it
is not portable, say, from a Mac to a Windows PC. When we talk about portability
of C++ programs, we usually mean portability of source code; that is, the source
code can be successfully compiled and run on a variety of systems.

The ISO C++ standard defines two kinds of entities:
- Core language features (built-in types, language constructs).
- The standard library.

C++ is statically typed. The type of every entity (e.g., object, value, name,
and expression) must be known to the compiler at its point of use.

- A *type* defines a set of possible values and operations (for an object).
- An *object* is some memory that holds a value of some type.
- A *value* is a set of bits interpreted according to a type.
- A *variable* is a named object.

Each *fundamental type* corresponds directly to hardware facilities and has a
fixed size that deter- mines the range of values that can be stored in it.

The size of a type is implementation-defined and can be found out with the
`sizeof` operator.

    sizeof(int)  // often 4

Sizes of C++ objects are expressed in terms of multiples of the size of a
`char`, so by definition the size of a `char` is `1`. It is *guaranteed* that:

- a `char` has at least 8 bits
- a `short` at least 16 bits
- a `long` at least 32 bits

`sizeof` and `<limits>` can be used to find sizes.

    cout << "size of long: " << sizeof(1L) << "\n";
    cout << "largest float: " << std::numeric_limits<float>::max() << "\n";

## Initialization

C++ offers different notations for expressing initialization, such as the
universal form based on *initializer lists* `{}` and `=`. The `{}`-list form
prevents narrowing conversions (that would lose information):

    double d1 = 2.3;
    double d2 {2.3};
    std::complex<double> z = 1;
    std::complex<double> z2 {d1,d2};
    std::complex<double> z3 = {1,2};  // the = is optional
    std::vector<int> v {1,2,3,4,5,6}; // a vector of ints

`auto` can be used as type when the type can be deduced from the initializer:

    auto b = true;    // a bool
    auto ch = 'x';    // a char
    auto i = 123;     // an int
    auto d = 1.2;     // a double
    auto z = sqrt(y); // z has the type of whatever sqr t(y) returns

    // place a copy of each value in v in x
    int v[] = {0,1,2}
    for (auto x : v) {
        cout << x << "\n";
    }

    // have x refer to each element in v
    int v[] = {0,1,2}
    for (auto& x : v) {
        x++;
    }

    // modifiers such as const can be used
    for (const auto& x : v) { ... }

## Constants

C++ supports two notions of immutability:
- `const`: primarily used to specify interfaces, so that data can be passed to
  functions without fear of it being modified. The compiler enforces constness.
- `constexpr` : "to be evaluated at compile time". Primarily to specify
  constants. A function to be used in constant expressions must be declared
  `constexpr` (such functions must be "simple").

## Pointers, arrays, loops

     T a[n];  // T[n]: array of n Ts
     T∗ p;    // T*: pointer to T
     T& r;    // T&: reference to T
     T f(A);  // T(A): function taking argument of type A and returning T

In an expression, prefix unary `∗` means "contents of" and prefix unary `&`
means "address of". In a declaration, `&` means "reference to".

    char∗ p = &v[3]; // p points to v's four th element
    char x = ∗p;     // *p is the object that p points to
    char& r = x;

`nullptr` is used to represent "no object available". `0` and `NULL` are often
seen in older code.


---------



## Types and declarations
(The C++ Programming Language, Chapter 6)

C++ has a set of *fundamental types* corresponding to the most common basic
storage units of a computer and the most common ways of using them to hold data:

- Boolean: `bool`
  - `true == 1` and `false == 0` when converted to integer
  - in arithmetic and logical expressions: `0 == false` and `nonzero == true`
  - a pointer can implicitly be converted to `bool`:

        if (p) { ... }    // equivalent to if (p != nullptr) { ... }

- Character types:
  - `char`: default character type for program text. Usually 8 bits. Safe to
    assume that the character set includes decimal digits, english alphabet
    letters, and basic punctuation. Whether `char` is signed or unsigned is
    implementation-defined. One solution is to avoid plain `char`.
    Literal: `'a'`.
  - `signed char`: like char but guaranteed to be signed, capable of holding
    both positive and negative values.
  - `unsigned char`: like char but guaranteed to be unsigned.
  - `wchar_t`: for larger character sets such as Unicode. Size is impl-defined,
    but large enough to hold the largest character set supported by the
    implementation's locale.
    Literal: `L'a'`.
  - `char16_t`: for holding 16-bit character sets, such as UTF-16.
    Literal: `u'a'`.
  - `char32_t`: for holding 32-bit character sets, such as UTF-32.
    Literal: `U'a'`

- Integer types: come in "plain", `signed` and `unsigned` and four sizes:
  - `short int` (aka `short`)
  - plain `int`
  - `long int` (aka `long`)
  - `long long int` (aka `long long`).

  Can use `int16_t`, `int64_t` and friends from `<cstdint>` for more control.
  `size_t` from `<cstddef>` is an unsigned int that can hot the size in bytes of
  every object.
  - Literals:

        int i = 99;    // decimal literal
        int i = 077;   // octal literal - leading '0'
        int i = 0xff;  // hexadecimal literal - leading '0x'

- Floating-point types:
  - `float` (single precision)
  - `double` (double precision)
  - `long double` (extended precision)
  - Literals: `1.23` `.23` `0.23` `1.2e10` `1.23e−15`

- Void type: `void`

        void∗ pv;  // pointer to object of unknown type

String literals:

    auto s0 =   "hello"; // const char*
    auto s1 = u8"hello"; // const char*, encoded as UTF-8
    auto s2 =  L"hello"; // const wchar_t*
    auto s3 =  u"hello"; // const char16_t*, encoded as UTF-16
    auto s4 =  U"hello"; // const char32_t*, encoded as UTF-32

    // Raw string literals containing unescaped \ and "
    auto R0 =   R"("Hello \ world")"; // const char*
    auto R1 = u8R"("Hello \ world")"; // const char*, encoded as UTF-8
    auto R2 =  LR"("Hello \ world")"; // const wchar_t*
    auto R3 =  uR"("Hello \ world")"; // const char16_t*, encoded as UTF-16
    auto R4 =  UR"("Hello \ world")"; // const char32_t*, encoded as UTF-32

    // Combining string literals with standard s-suffix
    auto S0 =   "hello"s; // std::string
    auto S1 = u8"hello"s; // std::string
    auto S2 =  L"hello"s; // std::wstring
    auto S3 =  u"hello"s; // std::u16string
    auto S4 =  U"hello"s; // std::u32string

We can construct other types using declarator operators:
- Pointer types: `int∗`
- Array types: `char[]`
- Reference types: `double&`, `vector<int>&&`

A user can also define user-defined types:
- Classes: `struct`s and `class`es
- Enumeration types (specific sets of values): `enum`, `enum class`


*Initialization*:
An initializer can use one of four syntactic styles:

    X a1 {v};    // recommended: introduced in C++11. no narrowing conversions.
    X a2 = {v};  // common in C
    X a3 = v;    // common in C
    X a4(v);     // function-style initializer (use constructor)

Prefer initializer `{}` unless the type is `auto`, then use `=`.

    auto i1 = 99;   // i1 is an int
    auto i2 = {99}; // warning: i2 is an std::initializer_list<int>

    vector<int> v1 {99}; // v1 is a vector of 1 element with the value 99
    vector<int> v2(99);  // warning: a vector of 99 elements (each with value 0)

The empty initializer list, `{}` , is used to indicate a default value.

    int x4 {};           // 0
    double d4 {};        // 0.0
    char∗ p {};          // nullptr
    vector<int> v4{};    // empty vector
    string s4 {};        // ""

Local variables and objects created on the free store (sometimes called dynamic
objects or heap objects) are not initialized by default unless they are
of user-defined types with a default constructor

    int x;                     // x does not have a well-defined value
    char buf[1024];            // buf[i] does not have a well-defined value
    int* p {new int};          // *p does not have a well-defined value
    char* q {new char[1024]};  // q[i] does not have a well-defined value

    string s;                  // s=="" because of string's default constructor
    vector<char> v;            // v=={} because of vector's default constructor

    string* ps {new string};   // *ps is "" because of string's default constr

Use `{}` to initialize local/new-created local variables:

    int x {};                  // x is 0
    char buf[1024] {};         // buf[i] is 0 for all i

    int* p {new int{10}};      // *p is 10
    char* q {new char[1024]{}};  // q[i] is 0 for all i

Complex objects can also be created with initializer lists (note: the `=` is
redundant):

    int a[] = { 1, 2 };             // array initializer
    struct S { int x, string s };
    S s = { 1, "Helios" };          // struct initializer
    complex<double> z = { 0, pi };  // uses constructor
    vector<int> v = { 0, 1, 2, 3 }; // uses list constructor

*decltype*:
To deduce a type we can use `decltype(expr)`. This is typically used in generic
programming to express types that depend on template parameters:

    // return type can be deduced since C++14
    template<typename T, typename U>
    auto add(T t, U u) -> decltype(t + u)
    {
        return t+u;
    }

*L-values and R-values*:

- L-value: an expression that refers to an object. ("something that can be on
  the left-hand side of an assignment").
- R-value: roughly means "a value that is not an lvalue", such as a temporary
  value like the value returned by a function.

*Lifetimes*:

The *lifetime* of an object starts when its constructor completes and ends when
its destructor starts executing. Objects of types without a declared
constructor, such as an `int`, can be considered to have default constructors
and destructors that do nothing.

We can classify objects based on their lifetimes:
- Automatic: an object declared in a function is created when its definition is
  encountered and destroyed when its name goes out of scope. Typically
  stack-allocated.
- Static: objects declared in global or namespace scope and statics declared in
  functions or classes are created and initialized once (only) and "live" until
  the program terminates (§15.4.3).
- Free store: Using the new and delete operators, we can create objects whose
  lifetimes are controlled directly.
- Temporary objects (e.g., intermediate results in a computation or an object
  used to hold a value for a reference to const argument): their lifetime is
  determined by their use. Typically, temporary objects are automatic.
- Thread-local objects; that is, objects declared `thread_local`: such
  objects are created and destroyed with their thread.

*Type aliases*:

The `using` keyword can be used to define type aliases:

    using Pchar = char∗; // pointer to character
    using PF = int(∗)(double); // pointer to function: f(double) -> int

For good and bad, type aliases are synonyms for other types rather than distinct
types.

An older syntax with `typedef` fulfills the same purpose:

    typedef int int32_t;      // equivalent to "using int32_t = int;"
    typedef short int16_t;    // equivalent to "using int16_t = short;"
    typedef void(∗PtoF)(int); // equivalent to "using PtoF = void(*)(int);"




## Pointers, Arrays, References
(The C++ Programming Language, Chapter 7)

*Pointers*:

For a type `T` , `T∗` is the type "pointer to T". In declarations, `*` is a
suffix to the type name. In expressions, it's the dereference operator.

    char  c = 'a';
    char∗ p = &c; // p holds the address of c; & is the address-of operator
    char c2 = ∗p; // c2 == 'a'; * is the dereference operator

    int∗ pi;          // pointer to int
    char∗∗ ppc;       // pointer to pointer to char
    int∗ ap[15];      // array of 15 pointers to ints
    int (∗fp)(char∗); // pointer to function of type f(char*) -> int
    int∗ f(char∗);    // function with char* argument; returns a pointer to int

`void *` is a "pointer to an object of unknown type":

    int∗ pi = &i;

    void∗ pv = pi; // ok: implicit conversion of int* to void*
    ∗pv;           // error: can't dereference void*
    ++pv;          // error: can't increment (size of type pointed to unknown)

    int∗ pi2 = static_cast<int∗>(pv); // explicit conversion back to int*

The primary use for `void∗` is for passing pointers to/from functions not
allowed to make assumptions about types. Typically only seen in low-level system
calls (like `malloc`).

    void* alloc(size_t n);

Use `nullptr` (instead of `NULL` or `0`) to make code more readable.

    int* pi = nullptr;

*Arrays*:

Arrays are can be accessed with pointers (and pointer arithmetic):

    int v[] = { 1, 2, 3, 4 };
    int∗ p1 = v;       // pointer to v[0]
    int∗ p2 = &v[0];   // pointer to initial element (p1 == p2)
    int∗ p3 = v+4;     // pointer to one-beyond-last element

In fact array subscripting is defined in terms of pointer operations:

    a[j] == ∗(&a[0]+j) == ∗(a+j) == ∗(j+a) == j[a]

Curiously enough this is always true: `a[j] == j[a]`.

Pointer arithmetic depends on the size of the type `T`. `p+1` will be
`sizeof(T)` larger than (the integer value of) `p`.

Arrays cannot be passed by-value. An array is passed as a pointer to its first
element. When used as a parameter, the first dimension of an array is simply
treated as a pointer. Any array bound specified is ignored. Either pass the
length of the array as second argument or use `std::array`, `std::vector`,
`std::string`).

    void f(double arg[10]) {}  // these are equivalent
    void f(double *arg) {}

A multidimensional array is laid out as a sequence of elements in memory
(`m[3][5]` laid out as `m[15]`). For multi-dimensional arrays, you need to pass
the first dimension as an explicit argument:

    void print1(int m[][5], int dim1) {
        for (int i = 0; i != dim1; i++) {
            for (int j = 0; j != 5; j++)
              cout << m[i][j] << '\t';
        }
    }

    // equivalently, but obscure
    void print2(int *m, int dim1, int dim2) {
        ...
             cout << *(m + i*dim2 + j) << '\t';
    }

    int v[3][5] = { {0,1,2,3,4}, {10,11,12,13,14}, {20,21,22,23,24} };
    print1(v, 5);
    print2(&v[0][0], 3, 5);

For most cases, `std::array` or `std::vector` should be preferred as a safer
alternative.

*Const*:

C++ offers two related meanings of "constant":
- `constexpr`: Evaluate at compile time.
- `const`: Do not modify in this scope.

To express this notion of immutability after initialization, we can add const to
the definition of an object. An object declared const cannot be assigned to, it
must be initialized.

    const int model = 90;            // model is a const
    const int v[] = { 1, 2, 3, 4 };  // v[i] is a const
    const int x;                     // error: no initializer

    // declaring something const ensures that its value will not change within
    // its scope:

    model = 200; // error
    v[2] = 3;    // error

Note that `const` modifies a type; it restricts how an object can be used.

    void g(const T∗ p) { // cannot modify *p here }

    void h() {
        T val;   // can modify val here
        g(&val); // val cannot be modified here
    }

Prefixing a declaration of a pointer with `const` makes the object, but not the
pointer, a constant. To declare a pointer itself, rather than the object pointed
to, a constant, we use the *declarator operator* `∗const` instead of plain `∗`.

    char s[] = "hello";

    char ∗const cp = s;        // const pointer to char
    char const∗ pc = s;        // pointer to const char
    const char∗ pc2 = s;       // pointer to const char (equivalent to pc)
    const char ∗const cpc = s; // const pointer to const


    cp[3] = 'a';  // OK
    cp = p;       // error: cp is constant

    pc[3] = 'g';  // error: pc points to constant
    pc = p;       // OK

    cpc[3] = 'a'; // error: cpc points to constant
    cpc = p;      // error: cpc is constant


*References*:

Like a pointer, a reference is an alias for an object. It is usually implemented
to hold a machine address of an object (no performance overhead compared to
pointers). There is no "null reference" - a reference always refers to an
object.

To reflect the lvalue/rvalue and const /non- const distinctions, there are three kinds of references:

- *lvalue references*: refers to object whose value we want to change
- *const references*: refers to object whose value we do not want to change
- *rvalue references*: refers to objects whose value we do not need to preserve
  after we have used it (e.g., a temporary). We want to know if a reference
  refers to a temporary, because if it does, we can sometimes turn an expensive
  copy operation into a cheap move operation. An object (such as a `string` or a
  `list`) that is represented by a small descriptor pointing to a potentially
  huge amount of information can be simply and cheaply moved if we know that the
  source isn't going to be used again.

Examples:

    string var {"Cambridge"};
    string f();

    string& r1 {var};         // lvalue reference, bind r1 to var (an lvalue)
    string& r2 {f()};         // error: f() is an rvalue
    string& r3 {"Princeton"}; // error: cannot bind to temporar y
    const string cr1& {"Harvard"}; // OK: make temporary and bind to cr1

    string&& rr1 {f()};      // rvalue reference, bind rr1 to temporary
    string&& rr2 {var};      // error: var is an lvalue
    string&& rr3 {"Oxford"}; // rr3 refers to a temporary holding "Oxford"



    string a(x);         // x is an lvalue
    string b(x + y);     // x + y is an rvalue
    string c(get_str()); // return value from get_str() is an rvalue

The `&&` declarator operator means "rvalue reference". We do not use `const`
rvalue references; most of the benefits from using rvalue references involve
writing to the object to which it refers. Both a `const` lvalue reference and an
`rvalue` reference can bind to an rvalue. However, the purposes will be
fundamentally different:

- We use rvalue references to implement a "destructive read" for optimization of
  what would otherwise have required a copy.
- We use a `const` lvalue reference to prevent modification of an argument.

The `std::move()` function can be used to turn an lvalue into an rvalue
reference.

    string x;

    string new_x {std::move(x)};  // NOTE: x may NOT be used from this point on
    // string new_x {static_cast<string&&>(x); // equivalent

All standard-library containers provide move constructors and move assignment.
Also, their operations that insert new elements, such as `insert()` and
`push_back()`, have versions that take rvalue references.

References can be used as return values, for example, when a function can be
used both on the left-hand and right-hand sides of an assigmnent.

    class list {
    public:
        int& operator[] (const int index);
        const int& operator[] (const int index) const;
    };

    list l {1,2,3};
    cout << l[0];   // uses const int& operator[]
    l[0] = 1;       // uses int& operator[]

## Structures, unions, and enumerations
(The C++ Programming Language, Chapter 8)

    struct Address {
        const char∗ name;
        int number;
        const char∗ street;
        const char∗ town;
        char state[2];
    };

    // Can initialize via memberwise intialization.
    Address jd = { "Jim Dandy", 61, "South St", "New Providence", {'N','J'} };

A `struct` is a simple form of class with all members `public`. So a struct can
have member functions and even constructors. A constructor is needed if you need
to reorder arguments, validate or modify arguments.

    struct Points {
        vector<Point> elem;// must contain at least one Point
        Points(Point p0) { elem.push_back(p0);}
        // ...
    };
    Points x0;               // error: no default constructor
    Points x1{ {100,200} };

The name of a type becomes available for use immediately after it has been
encountered and not just after the complete declaration has been seen. However,
it is not possible to declare new objects of a struct until its complete
declaration has been.

    // OK
    struct Link {
        Link∗ previous;
        Link∗ successor;
    };

    // error: recursive definition
    //        the compiler is not able to determine the size of No_good
    struct No_good {
        No_good member;
    };

To allow two structs to refer to each other:

    struct List; // struct name declaration: List to be defined later

    struct Link {
        Link∗ pre;
        Link∗ suc;
        List∗ member_of;
        int data;
    };

    struct List {
        Link∗ head;
    };

Sometimes, we want to treat an object as just "plain old data" (POD) (a
contiguous sequence of bytes in memory) and not worry about more advanced
semantic notions, such as run-time polymorphism, user-defined copy semantics,
etc. Often, the reason is to be able to move objects around in the most
efficient way (e.g. via `std::memcpy()`). So, a POD is an object that can be
manipulated as "just data" without worrying about complications of class
layouts or user-defined semantics for construction, copy, and move. For example:

    struct S0 { };        // POD
    struct S1 { int a; }; // POD

    // no POD (no default constructor)
    struct S2 { int a; S2(int aa) : a(aa) { } };
    // no POD (user-defined default constructor)
    struct S3 { int a; S3(int aa) : a(aa) { } S3() {} };
    // POD (has a default constructor)
    struct S4 { int a; S4(int aa) : a(aa) { } S4() = default; };
    // no POD (has a virtual function)
    struct S5 { virtual void f(); /* ... */ };


    struct S6 : S1 { };         // POD
    struct S7 : S0 { int b; };  // POD
    struct S8 : S1 { int b; };  // not a POD (data in both S1 and S8
    struct S9 : S0, S1 {};      // POD

The `is_pod<T>::value` type property predicate from `<type_traits>` can
determine if a type is a POD.

A `union` is a struct in which all members are allocated at the same address so
that the union occupies only as much space as its largest member. A `union` can
only hold a value for one member at a time.

    union Value {
        char∗ s;
        int i;
    };

The language doesn't keep track of which kind of value is held by a union , so
the programmer must do that:

    struct Entry {
        char∗ name;
        Type t;
        Value v; // use v.s if t==str; use v.i if t==num
    };

    void f(Entry∗ p) {
        if (p−>t == str)
            cout << p−>v.s;
        // ...
    }

There are two kinds of enumerations:
1. `enum classes`, for which the enumerator names (e.g., red ) are local to the
  `enum` and their values do not implicitly convert to other types.
2. "Plain `enums`" for which the enumerator names are in the same scope as the
   enum and their values implicitly convert to integers.

In general, prefer `enum class`es because they cause fewer surprises.

    enum class Traffic_light { red, yellow, green };
    enum class Warning { green, yellow, orang e, red }; // fire alert levels

    Warning a1 = 7;               // error: no int->Warning conversion
    int a2 = green;               // error: green not in scope
    int a3 = Warning::green;      // error: no Warning->int conversion
    Warning a4 = Warning::green;  // OK


## Statements
(The C++ Programming Language, Chapter 9)

It is usually a good idea to introduce the variable into the smallest scope
possible. A variable can be declared in a condition:

    if (double d = prim(true)) {
        left /= d;
        break;
    }

A `break` breaks out of the nearest enclosing switch or iteration statement.

## Expressions and operations
(The C++ Programming Language, Chapter 10 and 11)

A few less obvious operators:
- `typeid(type)`: type identification
- `typeid(expr)`: runtime type identification
- `dynamic_cast<type>(expr)`: runtime checked conversion
- `static_cast<type>(expr)`: compile-time checked conversion
- `reinterpret_cast<type>(expr)`: unchecked conversion
- `const_cast<type>(expr)`: const conversion
- `sizeof expr`: size of object
- `sizeof(type)`: size of type

There are alternate keywords for the logical and bit operators. For example:

    bool b = not (x or y) and z;
    int x4 = ~(x1 bitor x2) bitand x3;

is equivalent to:

    bool b = !(x || y) && z;
    int x4 = ~(x1 | x2) & x3;

*Order of evaluation*:
The order of evaluation of subexpressions within an
expression is undefined. In particular, you cannot assume that the expression is
evaluated left-to-right.

    int x = f(2)+g(3); // undefined whether f() or g() is called first
    v[i] = i++;        // undefined result: evaluated as either v[1]=1 or v[2]=1

The operators `,` (comma), `&&` (logical and), and `||` (logical or) guarantee
that their left-hand operand is evaluated before their right-hand operand.

*Constant expressions*:

C++ offers two related meanings of "constant":
- `constexpr`: Enables/ensures compile-time evaluation.
- `const`: Do not modify in this scope -- specify immutability in interfaces.

*Conversions*:

The fundamental types can be implicitly converted in too many ways. For example:

    void f(double d) {
        char c = d;   // warn: floating-point to char conversion
    }

Luckily, compilers often warn about such questionable conversions. Also, the
`{}`-initializer syntax prevents narrowing. For example:

    void f(double d) {
        char c {d};  // error: double to char conversion may lose information
    }

If potentially narrowing conversions are unavoidable, consider using some form
of run-time checked conversion function, such as `narrow_cast<>()`.

Some conversion rules:
- An integer can be converted to another integer type.
- A floating-point value can be converted to another floating-point type. If the
  source value can be exactly represented in the destination type, the result is
  the original numeric value. If the source value is between two adjacent
  destination values, the result is one of those values. Otherwise, the behavior
  is undefined.
- Any pointer to an object type can be implicitly converted to a `void∗`.  A
  pointer (reference) to a derived class can be implicitly converted to a
  pointer (reference) to an accessible and unambiguous base.
- Pointer, integral, and floating-point values can be implicitly converted to
  value converts to `true`; a zero value converts to `false`.

        if (p) { do_something(∗p); }

        // copy a (zero-terminated) char array (C-style string
        while (∗p++ = ∗q++) ;

- When a floating-point value is converted to an integer value, the fractional
  part is discarded. Loss of precision occurs if an integral value cannot be
  represented exactly as a value of the floating type.

*Free store*:

The operator `new` creates objects, and the operator `delete` can be used to
destroy them. Objects allocated by new are said to be "on the free store" (also,
"on the heap" or "in dynamic memory").

*Memory management*:

The main problems with free store are:
- *Leaked objects*: People use `new` and then forget to `delete` the allocated
  object.
- *Premature deletion*: People `delete` an object that they have some other
  pointer to and later use that other pointer (a.k.a. *dangling pointer*).
- *Double deletion*: An object is deleted twice, invoking its destructor (if
  any) twice.

As alternatives to "naked" `new` and `delete`s there are two general
recommendations w.r.t. resource management:

1. Don't put objects on the free store if you don't have to; prefer scoped
   (stack allocated) variables.
2. When you construct an object on the free store, place its pointer into a
   manager object (sometimes called a handle) with a destructor that will
   destroy it. Examples are string, vector and all the other standard-library
   containers, unique_ptr, and shared_ptr. Wherever possible, have that manager
   object be a scoped variable. Many classical uses of free store can be
   eliminated by using move semantics to return large objects represented as
   manager objects from functions. This is commonly known as *RAII* (Resource
   Acquisition is Initialization).

`new` belongs in constructors and similar operations, `delete` belongs in
destructors, and together they provide a coherent memory management strategy. In
addition, `new` is often used in arguments to resource handles (such as
`unique_ptr`).

When `new` cannot find memory to allocate, the allocator throws a
standard-library `bad_alloc` exception:

    try {
        char ∗ p = new char[10000];
    } catch(bad_alloc) {
        cerr << "Memory exhausted!\n";
    }

Be careful: the `new` operator is not guaranteed to throw when you run out of
physical main memory. On a system with virtual memory, it can consume a lot of
disk space and take a long time doing so before the exception is thrown. We can
specify what new should do upon memory exhaustion by defining a *new handler*:
`set_new_handler(my_new_handler)`.

One can override the `new` operator to allocate objects somewhere other than the
free store (default).

*Lambda Expressions*:

A lambda expression ("lambda function", "lambda"), is a simplified notation for
defining and using an anonymous function object. Instead of defining a named
class with an `operator()`, later making an object of that class, and finally
invoking it, we use a lambda as a shorthand. This is particularly useful when we
want to pass an operation as an argument to an algorithm. A lambda expression
consists of a sequence of parts:
- A possibly empty *capture list*, specifying what names from the definition
  environment can be used in the lambda expression's body, and whether those are
  copied or accessed by reference. The capture list is delimited by `[]`.
- An optional *parameter list*, specifying what arguments the lambda expression
  requires. The parameter list is delimited by `()`.
- An optional `mutable` specifier, indicating that the lambda expression's body
  may modify the state of the lambda (i.e., change the lambda's copies of
  variables captured by value).
- An optional return type declaration of the form `−> type`.
- A *body*, specifying the code to be executed. The body is delimited by `{}`.

        // output v[i] to os if v[i] is an even number
        void print_modulo(const vector<int>& v, ostream& os) {
            for_each(begin(v), end(v),
                [&os](int x) { if (x % 2 == 0) os << x << '\n'; }
            );
        }


The capture list, `[&os]` , becomes member variables and a constructor to
initialize them. The `&` before `os` means that we should store a reference (an
absence of `&` denotes pass a copy). The equivalent function object:

    class Modulo_print {
        ostream& os; // members to hold the capture list
    public:
        Modulo_print(ostream& s) :os(s) {}

        void operator()(int x) const {
             if (x % 2 == 0) os << x << '\n';
        }
    };

    // output v[i] to os if v[i] is an even number
    void print_modulo(const vector<int>& v, ostream& os) {
        for_each(begin(v), end(v), Modulo_print{os});
    }

It is often a good idea to name the lambda:

    // output v[i] to os if v[i] is an even number
    void print_modulo(const vector<int>& v, ostream& os) {
        auto print_even = [&os] (int x) { if (x % 2 == 0) os << x << '\n'; };
        for_each(begin(v), end(v), print_even);
    }

Some lambdas require no access to their local environment. Such lambdas are
defined with the empty lambda introducer `[]`:

    void algo(vector<int>& v) {
        sort(v.begin(), v.end(), [](int x, int y) { return abs(x)<abs(y); });
    }

A lambda introducer can take various forms:

- `[]`: an empty capture list. This implies that no local names from the
  surrounding context can be used in the lambda body. For such lambda
  expressions, data is obtained from arguments or from nonlocal variables.
- `[&]`: implicitly capture by reference. All local names can be used. All local
  variables are accessed by reference.
- `[=]`: implicitly capture by value. All local names can be used. All names
  refer to copies of the local variables taken at the point of call of the
  lambda expression.
- `[ capture-list ]`: explicit capture; the capture-list is the list of names of
  local variables to be captured (i.e., stored in the object) by reference or by
  value. Variables with names preceded by `&` are captured by reference. Other
  variables are captured by value.
- `[&, capture-list ]`: implicitly capture by reference all local variables with
  names not mentioned in the list. The capture list can contain `this`. Listed
  names cannot be preceded by `&`. Variables named in the capture list are
  captured by value.
- `[=, capture-list ]`: implicitly capture by value all local variables with
  names not mentioned in the list. The capture list cannot contain `this`. The
  listed names must be preceded by `&`. Variables named in the capture list are
  captured by reference.

When passing a lambda to another thread, capturing by value (`[=]`) is typically
best: accessing another thread's stack through a reference or a pointer can be
most disruptive (to perfor- mance or correctness), and trying to access the
stack of a terminated thread can lead to extremely difficult-to-find errors.

A lambda might outlive its caller. This can happen if we pass a lambda to a
different thread or if the callee stores away the lambda for later use:

    void setup(Menu& m) {
      Point p1, p2, p3;
      // compute positions of p1, p2, and p3
      m.add("draw triangle",[&]{ m.draw(p1,p2,p3); }); // probable disaster
      // ...
    }

Assuming that `add()` is an operation that adds a (name,action) pair to a menu,
we are left with a time bomb: the `setup()` completes and later - maybe minutes
later - a user presses the draw triangle button and the lambda tries to access
the long-gone local variables. A lambda that wrote to a variable caught by
reference would be even worse in that situation. If a lambda might outlive its
caller, we must make sure that all local information (if any) is copied into the
closure object and that values are returned through the return mechanism or
through suitable arguments. For the `setup()` example, that is easily done:

    m.add("draw triangle",[=]{ m.draw(p1,p2,p3); });

Think of the capture list as the initializer list for the closure object and
`[=]` and `[&]` as short-hand notation.

We can include class members in the set of names potentially captured by adding
`this` to the capture list. Members are always captured by reference. That is,
`[this]` implies that members are accessed through this rather than copied into
the lambda. Unfortunately, `[this]` and `[=]` are incompatible.

    class Request {
    public:
      // parse and store request
      Request(const string& s);

      future<void> execute() {
        return async([this]() { results = oper(values); });
      }
    private:
      function<map<string,string>(const map<string,string>&)> oper;
      map<string,string> values;
      map<string,string> results;
    };

Usually, we don't want to modify the state of the function object (the closure),
so by default we can't. That is, the `operator()()` for the generated function
object is a `const` member function. If we really want to modify the state (as
opposed to modifying the state of some variable captured by reference), we can
declare the lambda `mutable`:

    void algo(vector<int>& v) {
      int count = v.siz e();
      std::generate(v.begin(),v.end(), [count]()mutable{ return −−count; });
    }

The `−−count` decrements the copy of `v`'s size stored in the closure.

A lambda expression's return type can be deduced from its body. That is not also
done for a function (in C++11, it *is* supported in C++14).

    double y = 1.0;

    [&]{ f(y); }                            // return type is void
    auto z1 = [=](int x){ return x+y; }     // return type is double
    auto z3 =[y]() { return (y) ? 1 : 2; }  // return type is int
    auto z4 = [=,y]()−>int { if (y) return 1; else return 2; } // explicit type

In addition to using a lambda as an argument, we can use it to initialize a
variable declared `auto` or `std::function<R(AL)>` where `R` is the lambda's
return type and `AL` is its argument list of types.

A lambda that doesn't capture can be assigned to a pointer to function of an
appropriate type:

    double (∗p1)(double) = [](double a) { return sqrt(a); };

*Explicit Type Conversion*:

C++ offers explicit type conversion operations of varying
convenience and safety. In order of preference/safety:

- Construction, using the `{}` notation, providing type-safe construction of new
  values.
- Named conversions, providing conversions of various degrees of nastiness:
  - `const_cast` for getting write access to something declared const. Converts
    between types that differ only in const and volatile qualifiers
  - `static_cast` for reversing a well-defined implicit conversion. Converts
    between related types such as one pointer type to another in the same class
    hierarchy, an integral type to an enumeration, or a floating-point type to
    an integral type.
  - `reinterpret_cast` for changing the meaning of bit patterns. Handles
    conversions between unrelated types such as an integer to a pointer or a
    pointer to an unrelated pointer type.
  - `dynamic_cast` for dynamically checked class hierarchy navigation. Does
    run-time checked conversion of pointers and references into a class
    hierarchy.
  - C-style casts, providing any of the named conversions and some combinations
    of those.
- Functional notation, providing a different notation for C-style
  casts. A.k.a. "function-style cast":

         void f(double d) {
           int i = int(d);      // truncate d
           complex z = complex(d); // make a complex from d
           // ...
         }

  It is best avoided. Prefer `T{v}` conversions over `T(e)` for well-behaved
  construction and use the named casts (e.g., `static_cast`) for other
  conversions.


## Functions
(The C++ Programming Language, Chapter 12)

A function declaration can contain a variety of specifiers and modifiers:
- The return type may be either prefix or suffix (using `auto`).

        auto to_string(int a) −> string;   // suffix return type

  A suffix return type is needed in function template declarations in which the
  return type depends on the arguments.

        template<class T, class U>
        auto product(const vector<T>& x, const vector<U>& y) −> decltype(x∗y);

- `inline`: hint to have function calls implemented by inlining the body.
- `constexpr`: possible to evaluate the function at compile time if given
  constant expressions as arguments.
- `noexcept`: may not throw an exception.
- A linkage specification, for example, `static`.
- `[[noreturn]]`: will not return using the normal call/return mechanism.
In addition, a *member function* may be specified as:
- `virtual`: can be overridden in a derived class.
- `override`: must be overriding a virtual function from a base class.
- `final`: cannot be overriden in a derived class.
- `static`: class function not associated with a particular object.
- `const`: may not modify its object.

If a local variable is declared `static`, a single, statically allocated object
will be used to represent that variable in all calls of the function. It will
be initialized only the first time a thread of execution reaches its definition.

    void f(int a) {
      while (a−−) {
        static int n = 0; // initialized once
        int x = 0;        // initialized 'a' times in each call of f()
        cout << "n == " << n++ << ", x == " << x++ << '\n';
      }
    }

A static local variable allows the function to preserve information between
calls without introducing a global variable that might be accessed and
corrupted by other functions.

The absence of `const` in the declaration of a reference argument is taken as a
statement of intent to modify the variable:

    void f(Large& arg); // assume that f() modifies arg

Similarly, declaring a pointer argument `const` tells readers that the value of
an object pointed to by that argument is not changed by the function:

    int strlen(const char∗);                  // length of a C-style string
    char∗ strcpy(char∗ to, const char∗ from); // copy C-style string
    int strcmp(const char∗, const char∗);     // compare C-style strings

Preferred ways of passing arguments:
1. Use pass-by-value for small objects.
2. Use pass-by-`const`-reference to pass large values that are read-only.
3. Return a result value rather than modifying an object through an argument.
4. Use rvalue references to implement move and forwarding.
5. Pass a pointer if "no object" is a valid alternative (and represent "no
   object" by `nullptr`).
6. Use pass-by-reference only if you have to.

An array parameter type is equivalent to a parameter of pointer type. All these
are equivalent (note that `std::vector` or `std:array` should be prefered):

    void odd(int∗ p);
    void odd(int a[]);
    void odd(int buf[1020]);

To support functions with unknown number of arguments:
1. Use a variadic template: allows us to handle an arbitrary number of arbitrary
   types in a type-safe manner by writing a small template metaprogram.
2. Use an `initializer_list` as the argument type. This allows us to handle an
   arbitrary number of arguments of a single type in a type-safe manner.
3. Terminate the argument list with the ellipsis `...`, which means "and maybe
   some more arguments". This allows us to handle an arbitrary number of
   (almost) arbitrary types by using some macros from `<cstdarg>`. This C-style
   solution is not inherently type-safe and can be hard to use with
   sophisticated user-defined types.

Default function arguments can be provided for trailing arguments:

    int f(int, int ={0}, char∗ =nullptr);  // OK
    int g(int =0, int ={0}, char∗);        // error
    int h(int =0, int, char∗ =nullptr);  // error

Using the same name for operations on different types is called *overloading*.

    void print(int);           // print an int
    void print(const char∗);   // print a C-style string

The compiler uses a fairly complicated set of resolution rules to determine
which function to call when there are overloaded functions. Sometimes the
developer is surprised to find which function is called. Still, overloading is
useful and a lot nicer than `print_int`, `print_double`, etc.  One can also add
an explicit type conversion to resolve a specific call.

    void f(char);
    void f(long);
    void f(char*);
    void f(int*);

    f(static_cast<int∗>(0));

Return types are *not* considered in overload resolutions.

Like a (data) object, the code generated for a function body is placed in memory
somewhere, so it has an address. We can have a pointer to a function just as we
can have a pointer to an object. There are only two things one can do to a
function: call it and take its address.

    void error(string s) { /* ... */ }

    void (∗efct)(string);

    // pointer to function taking a string argument and returning nothing
    void f() {
      efct = &error;
      efct("error");
    }

Using `&` to get the address of a function is optional:

    void (∗f1)(string) = &error;
    void (∗f2)(string) = error;

You can take the address of an overloaded function by assigning to or
initializing a pointer to function. In that case, the type of the target is
used to select from the set of overloaded functions:

    void f(int);
    int f(char);

    void (∗pf1)(int) = &f;   // void f(int)
    int (∗pf2)(char) = &f;   // int f(char)
    void (∗pf3)(char) = &f;  // error : no void f(char)

It is also possible to take the address of member functions, but a pointer to
member function is quite different from a pointer to (nonmember) function.

`std::function` is a general-purpose function wrapper. Instances of
`std::function` can store, copy, and invoke any Callable target -- functions,
lambda expressions, bind expressions, or other function objects, as well as
pointers to member functions and pointers to data members.

    struct Foo {
        Foo(int num) : num_(num) {}
        void print_add(int i) const { std::cout << num_+i << '\n'; }
        int num_;
    };

    void print_num(int i) {
        std::cout << i << '\n';
    }

    struct PrintNum {
        void operator()(int i) const {
            std::cout << i << '\n';
        }
    };

    int main() {
        // store a free function
        std::function<void(int)> f_display = print_num;
        f_display(-9);

        // store a lambda
        std::function<void()> f_display_42 = []() { print_num(42); };
        f_display_42();

        // store the result of a call to std::bind
        std::function<void()> f_display_31337 = std::bind(print_num, 31337);
        f_display_31337();

        // store a call to a member function
        std::function<void(const Foo&, int)> f_add_display = &Foo::print_add;
        const Foo foo(314159);
        f_add_display(foo, 1);

        // store a call to a member function and object
        using std::placeholders::_1;
        std::function<void(int)> f_add_display2 = std::bind( &Foo::print_add, foo, _1 );
        f_add_display2(2);

        // store a call to a member function and object ptr
        std::function<void(int)> f_add_display3 = std::bind( &Foo::print_add, &foo, _1 );
        f_add_display3(3);

        // store a call to a function object
        std::function<void(int)> f_display_obj = PrintNum();
        f_display_obj(18);
    }

*Macros*:

Macros are very important in C but have far fewer uses in C++. The first rule
about macros is: don't use them unless you have to. One use of macros is almost
impossible to avoid. The directive `#ifndef` as a "header include guard":

    #ifndef MYHEADER_H
    #define MYHEADER_H
    ...   // This will be seen by the compiler only once
    #endif /* MYHEADER_H */

A few macros are predefined by the compiler:

- `__cplusplus`: defined in a C++ compilation (and not in a C compilation). Its
  value is `201103L` in a `C++11` program.
- `__DATE__`: date in "yyyy:mm:dd" format.
- `__TIME__`: time in "hh:mm:ss" format.
- `__FILE__` name of current source file.
- `__LINE__` source line number within the current source file.
- `__FUNC__` an implementation-defined C-style string naming the current
  function.
- `__STDC__`: defined in a C compilation (and not in a C++ compilation).
- `__STDCPP_THREADS__`: 1 if a program can have more than one thread of
  execution; otherwise undefined.



## Exceptions
(The C++ Programming Language, Chapter 13)

An exception can be of any type that can be copied, but it is strongly
recommended to use only user-defined types specifically defined for that
purpose.

    struct Range_error {};

    void f(int n) {
        if (n<0 || max<n) throw Range_error {};
        // ...
    }

An exception is caught by code that has expressed interest in handling a
particular type of exception (a `catch`-clause).

    void f() {
        try {
            throw E{};
        } catch(H) {
            // when do we get here?
        }
    }

The handler is invoked:
1. If `H` is the same type as `E`.
2. If `H` is an unambiguous public base of `E`.
3. If `H` and `E` are pointer types and 1. or 2. holds for the types to which
   they refer.
4. If `H` is a reference and 1. or 2. holds for the type to which `H` refers.

The standard library also defines a small hierarchy of exception classes. An
exception can carry information about the error it represents. Its type
represents the kind of error, and whatever data it holds represents the
particular occurrence of that error. For example, the standard-library
exceptions contain a string value, which can be used to transmit information
such as the location of the throw. The standard library exception classes, such
as `std::runtime_error` and `std::out_of_range`, take a string argument as a
constructor argument and have a virtual function `what()`:

    struct MyError : std::runtime_error {
        const char∗ what() const noexcept { return "MyError"; }
    };

    void g(int n) {
        if (n)
            throw std::runtime_error{"I give up!"};
        else
            throw MyError{};
    }

    void f(int n) {
        try {
            void g(n);
        } catch (std::exception& e) {
            cerr << e.what() << '\n';
        }
    }


`<stdexcept>` in the standard library provides a small hierarchy of exception
classes with a common base `exception`. This catches every *standard libary
exception*:

    void m() {
        try {
            // ... do something ...
        } catch (std::exception& err) {
            // handles every standard library exception
            // ... cleanup ...
            throw; // rethrow
        }
    }

To catch all exceptions, use `catch(...)`.

        try {
            // ... do something ...
        } catch (...) {
            // handle every exception
        }

There are programs that for practical and historical reasons cannot use
exceptions. For example:

- A time-critical component of an embedded system where an operation must be
  guaranteed to complete in a specific maximum time.
- A large old program in which resource management is an ad hoc mess (e.g., free
  store is unsystematically "managed" using "naked" pointers, `new`s, and
  `delete`s), rather than relying on some systematic scheme, such as resource
  handles (e.g., string and vector).

*Resource Acquisition Is Initialization (RAII)*:

When a function acquires a resource - that is, it opens a file, allocates some
memory from the free store, acquires a mutex, etc. - it is often essential for
the future running of the system that the resource be properly released.

    // naive code: file descriptor will leak if an exception is thrown mid-way
    void use_file(const char∗ filename) {
      FILE∗ f = fopen(filename,"r");

      // use f ...

      fclose(f);
    }

It is important that resources are released in opposite order of acquisition:

     void acquire() {
       // acquire resource 1
       // ...
       // acquire resource n

       // ... use resources ...

       // release resource n
       // ...
       // release resource 1
     }

Thus, we can handle such resource acquisition and release problems using
stack-allocated objects of classes with constructors and destructors. ne than
its traditional counterpart.  This technique for managing resources using local
objects is usually referred to as "Resource Acquisition Is Initialization"
(RAII). This is a general technique that relies on the properties of
constructors and destructors and their interaction with exception handling.

    class File_ptr {
        FILE∗ p;
    public:
        File_ptr(const char∗ name, const char∗ mode)
            : p{fopen(name, mode)}
        {
          if (p==nullptr)
            throw runtime_error{"File_ptr: Can't open file"};
        }

        ~File_ptr() { fclose(p); }
    };



    // RAII: exception-safe code
    void use_file(const char∗ filename) {
      FilePtr f(filename, "r");

      // use f ...

    }  // f goes out of scope -> destructor called -> file closed

The most common resource is memory, and `string`, `vector`, and the other
standard containers use RAII to implicitly manage acquisition and
release. Compared to ad hoc memory management using `new` and `delete`, this
saves lots of work and avoids lots of errors.  When a pointer to an object,
rather than a local object, is needed, consider using the standard library types
`unique_ptr` and `shared_ptr`.

In older C++ code, you may find exception specifications. For example:

    void f(int) throw(Bad,Worse); // may only throw Bad or Worse exceptions
    void g(int) throw();          // may not throw

This feature has not been a success and is deprecated. Don't use it.

We can transfer an exception thrown on one thread to a handler on another thread
using the standard-library function `current_exception()`:

    try {
        // ... do the work ...
    } catch(...) {
        prom.set_exception(current_exception());
    }

There is a fundamental language rule that when an exception is thrown from a
constructor, subobjects (including bases) that have already been completely
constructed will be properly destroyed.

## Namespaces
(The C++ Programming Language, Chapter 14)

C++ does not provide a single language feature supporting the notion of a
module; there is no module construct (will be in C++20). Instead, modularity is
expressed through combinations of other language facilities, such as functions,
classes, and namespaces, and source code organization.

The notion of a namespace is provided to directly represent the notion of a set
of facilities that directly belong together, for example, the code of a
library. The members of a namespace are in the same scope and can refer to each
other without special notation, whereas access from outside the namespace
requires explicit notation.

A member can be declared within a namespace definition and defined later using
the `<namespace-name>::<member-name>` notation.

    // declaration
    namespace Parser {
        double expr(bool);
        ...
    }

    // definition
    double Parser::expr(bool b) {
        // ...
    }

    // use
    double val = Parser::expr();

The global scope is a namespace and can be explicitly referred to using `::`:

    int f();    // global function

    int g() {
        int f;
        f();    // error: can't call an int
        ::f();  // OK: call global function
    }

The `using` declaration is used to bring a namespaced construct into a scope.

    using std::string; // use "string" to mean "std::string"

To prevent confusion, keep `using` as local as possible.

    namespace N {
        void f(int);
        void f(string);
    };

    void g(){
        using N::f;
        f(789);
        f("Bruce");
    }

We can also use a `using`-directive to request that every name from a namespace
be accessible in our scope without qualification.

    using namespace std;

A namespace is open; that is, you can add names to it from several separate
namespace declarations.

    namespace A {
         int f();   // now A has member f()
    }
    namespace A {
        int g();    // now A has two members, f() and g()
    }

That way, the members of a namespace need not be placed contiguously in a single
file.

One can provide a short alias for a longer namespace name:

    // use namespace alias to shorten names:
    namespace ATT = American_Telephone_and_Telegraph;

    ATT::do_something();

Namespaces can be nested:

    namespace X {
        void g();

        namespace Y {
            void f();
            void ff();
        }
    }

    void X::Y::ff() {
        f();
        g();
    }

    void X::g() {
        f();     // error: no f() in X
        Y::f();  // OK
    }

    ...

    int main() {
        f();        // error: no global f()
        Y::f();     // error: no global Y
        X::Y::f();  // OK
    }

## Source Files and Programs
(The C++ Programming Language, Chapter 15)

A user presents a *source file* to the compiler. The file is then preprocessed;
that is, macro processing is done and `#include` directives bring in
headers. The result of preprocessing is called a *translation unit*.

To enable separate compilation, the programmer must supply declarations
providing the type information needed to analyze a translation unit in isolation
from the rest of the program.

The *linker* is the program that binds together the separately compiled parts. A
linker is sometimes (confusingly) called a *loader*. Linking can be done
completely before a program starts to run. Alternatively, new code can be added
to the running program ("dynamically linked") later.

A program is a collection of separately compiled units combined by a
linker. Every function, object, type, etc., used in this collection must have a
unique definition.

The return type of `main()` is `int`, and the following two versions of `main()`
are supported by all implementations:

    int main() { /* ... */ }
    int main(int argc, char∗ argv[]) { /* ... */ }

The organization of a program into source files is commonly called the *physical
structure* of a program. The physical separation of a program into separate
files should be guided by the logical structure of the program. The same
dependency concerns that guide the composition of programs out of namespaces
guide its composition into source files. However, the logical and physical
structures of a program need not be identical.

The types in all declarations of the same object, function, class, etc., must be
consistent. Consequently, the source code submitted to the compiler and later
linked together must be consistent. The most common method of achieving
consistency for declarations in different translation units is to
`#include` header files containing interface information in source files
containing executable code and/or data definitions.

As a rule of thumb, a header may contain:

- Named namespaces:                `namespace N { /∗ ... ∗/ }`
- inline namespaces:               `inline namespace N { /∗ ... ∗/ }`
- Type definitions:                `struct Point { int x, y; };`
- Template declarations:           `template<class T> class Z;`
- Template definitions:            `template<class T> class V { /∗ ... ∗/ };`
- Function declarations:           `extern int strlen(const char∗);`
- inline function definitions:     `inline char get(char∗ p) { /∗ ... ∗/ }`
- constexpr func defs: `constexpr int fac(int n) {return (n<2) ? 1 : fac(n−1);}`
- Data declarations:               `extern int a;`
- const definitions:               `const float pi = 3.141593;`
- constexpr definitions:           `constexpr float pi2 = pi∗pi;`
- Enumerations:                    `enum class Light { red, yellow, green };`
- Name declarations:               `class Matrix;`
- Type aliases:                    `using value_type = long;`
- Compile-time assertions:         `static_assert(4<=sizeof(int),"small ints");`
- Include directives:              `#include<algorithm>`
- Macro definitions:               `#define VERSION 12.03`
- Conditional compilation directives: `#ifdef __cplusplus`
- Comments:                           `// bla bla`

Conversely, a header should *never* contain:

- Ordinary function definitions: `char get(char∗ p) {return ∗p++; }`
- Data definitions:              `int a;`
- Aggregate definitions:         `short tbl[] = { 1, 2, 3 };`
- Unnamed namespaces:            `namespace { /∗ ... ∗/ }`
- `using`-directives:              `using namespace Foo;`

Header files are conventionally suffixed by `.h` , and files containing function
or data definitions are suffixed by `.cpp`. Other conventions, such as `.c`,
`.C`, `.cxx`, `.cc`, `.hh` , and `.hpp` are also found.

A given class, enumeration, and template, etc., must be defined exactly once in
a program. Unfortunately, the language rule cannot be that simple. For example,
the definition of a class may be composed through macro expansion, and a def-
inition of a class may be textually included in two source files by `#include`
directives. In fact, a "file" isn't a concept that is part of the C++ language
definition; there exist implementations that do not store programs in source
files. Consequently, the rule in the standard that says that there must be a
unique definition of a class, template, etc., is phrased in a somewhat more
complicated and subtle manner. This rule is com- monly referred to as *the
one-definition rule* ("the ODR"). That is, two definitions of a class, template,
or inline function are accepted as examples of the same unique definition if and
only if [1] they appear in different translation units, and [2] they are
token-for-token identical, and [3] the meanings of those tokens are the same in
both translation units.

The intent of the ODR is to allow inclusion of a class definition in different
translation units from a common source file.

*Include guards*:

For larger programs a header containing class definitions or inline functions
can easily get `#include`d twice in the same compilation unit. To prevent such
repeated inclusion of headers one typically makes use of *include guards* (or
*header guards*):

    // error.h:
    #ifndef CALC_ERROR_H
    #define CALC_ERROR_H

    namespace Error {
        // ...
    }

    #endif // CALC_ERROR_H

The contents of the file between the #ifndef and #endif are ignored by the
compiler if `CALC_ERROR_H` is defined. Thus, the first time error.h is seen
during a compilation, its contents are read and `CALC_ERROR_H` is given a value.
Should the compiler be presented with `error.h` again during the compilation,
the contents are ignored. This is a piece of macro hackery, but it works and it
is pervasive in the C and C++ worlds. The standard headers all have include
guards.

Header files are included in essentially arbitrary contexts, and there is no
namespace protection against macro name clashes. Consequently, choose rather
long and ugly names for include guards.

In principle, a variable defined outside any function (that is, global,
namespace, and class static variables) is initialized before `main()` is
invoked. Such nonlocal variables in a translation unit are initialized in their
definition order. There is no guaranteed order of initialization of global
variables in different translation units. Beware though: if multiple threads are
used, each will do the run-time initialization.

    int x = 3;
    int y = sqrt(++x);

`sqrt(++x)` in one thread may happen before or after the other thread manages to
increment `x`. So, the value of `y` may be `sqrt(4)` or `sqrt(5)`.


If a program is terminated using the standard-library function `exit()`, the
destructors for constructed static objects are called. However, if the program
is terminated using the standard-library function `abort()`, they are not.

The C (and C++) standard-library function `atexit()` offers the possibility to
have code executed at program termination. For example:

    void my_cleanup();

    void somewhere() {
        if (atexit(&my_cleanup)==0) {
            // my_cleanup will be called at normal termination
        } else {
            // oops: too many atexit functions
        }
    }

This strongly resembles the automatic invocation of destructors for global
variables at program termination. An argument to `atexit()` cannot take
arguments or return a result, and there is an implementation-defined limit to
the number of atexit functions. A nonzero value returned by atexit() indicates
that the limit is reached. These limitations make `atexit()`, in essence, a C
workaround for the lack of destructors.

## Classes (user-defined types)
(The C++ Programming Language, Chapter 16)

A very brief summary of classes:
- A class is a user-defined type.
- Member functions can define the meaning of initialization (creation), copy,
  move, and cleanup (destruction).
- The `public` members provide the class's interface and the `private` members
  provide implementation details.
- A `struct` is a class where members are by default `public`.

        // equivalent declarations
        struct S { /* ... */ };
        class  S { public: /* ... */ };


A type/class is called *concrete* (or a *concrete class*) if its representation
is part of its definition. This distinguishes it from abstract classes and
classes in class hierarchies which provide an interface to a variety of
implementations. Concrete classes are very similar to, and used much like,
*built-in types* such as `int` and `char`. Sometimes, concrete types are also
referred to as *value types*. Having the representation available allows us:

- To place objects on the stack, in statically allocated memory, and in other
  objects.
- To copy and move objects.
- To refer directly to named objects (as opposed to accessing through pointers
  and references)

By default, objects can be copied and copy assigned. The compiler generates a
default *copy constructor* and a default *copy assignment operator*. Both use
memberwise copy. If the user doesn't declare a constructor, the compiler also
generates a *default constructor* (without arguments); it calls the default
constructors of the bases and of the non-static class members.

    class Date {
      int d, m, y;
    public:
      // implicitly defined (generated by the compiler)
      // Date() = default;                       // default constructor
      // Date(const Date&) = default;            // copy constructor
      // Date& operator=(const Date&) = default; // copy assignment
    };

A default constructor is used if no arguments are specified or an empty
initializer list is given:

    Date d1;
    Date d2 {};

When a class has a constructor, all objects of that class will need to be
initialized by a constructor call (and a default constructor is no longer
generated implicitly; but default copy and move constructors are still
generated).

    class Date {
      int d, m, y;
    public:
      Date(int dd, int mm, int yy); // constructor
    };

    ...

    Date today = Date(23,6,1983);
    Date xmas(25,12,1990);          // abbreviated form
    Date my_birthday;               // error: initializer missing
    Date release1_0(10,12);         // error: third argument missing

    // {}-initializer syntax (recommended)
    Date today = Date {23,6,1983};
    Date xmas {25,12,1990};         // abbreviated form
    Date release1_0 {10,12};        // error: third argument missing

Constructors obey the same overloading rules as do ordinary functions:

    class Date {
      int d, m, y;
    public:

      Date(int, int, int); // day, month, year
      Date(int, int);      // day, month, today's year
      Date(int);           // day, today's month and year
      Date();              // default Date: today
      Date(const string&); // date in string representation

      // implicitly defined
      // Date(const Date&) = default;            // copy constructor
      // Date& operator=(const Date&) = default; // copy assignment
    };

The number of related functions can be reduced by using *default arguments*:

    class Date {
      int d, m, y;
    public:
      Date(int dd = 0, int mm = 0, int yy = 0);
    };

We can also add initializers to data members "in-class":

    struct { int d, m, y} date_initializer = { 1, 1, 19790 };

    class Date {
      int d {date_initializer.d};
      int m {date_initializer.m};
      int y {date_initializer.y};
    public:
      Date(int, int, int);
      Date(int, int);
      Date(int);
      Date();
    }

Now, each constructor has `d`, `m`, and `y` initialized unless it does it
itself. That is, now:

     Date::Date(int dd)
       : d{dd}
     {
       ...
     }

is equivalent to:

     Date::Date(int dd)
       :d{dd}, m{date_initializer.m}, y{date_initializer.y}
     {
        ...
     }

This constructor makes use of a *member initializer list* (`: d{dd} ...`). Some
details: the members' constructors are called before the body of the containing
class's own constructor is executed. The constructors are called in the order in
which the members are declared in the class rather than the order in which the
members appear in the initializer list.

A reference or `const` member *must* be initialized.

*Explicit Constructors*:

By default, a constructor invoked by a single argument acts as an implicit
conversion from its argument type to its type. For example:

    std::complex<double> d {1}  // d == 1 + 0i

Such implicit conversions can be useful, like for complex numbers. However, they
can also be a significant source of confusion and errors.

    void my_fct(Date d);

    void f() {
       Date d {15};  // plausible: x becomes {15,today.m,today.y}

       my_fct(15);   // obscure
       d = 15;       // obscure
    }

We can declare a constructor `explicit`: such a constructor can only be used for
initialization and explicit conversions.

    class Date {
      int d, m, y;
    public:
      explicit Date(int dd = 0, int mm = 0, int yy = 0);
    };

    Date d1 {15};        // OK: considered explicit
    Date d2 = Date{15};  // OK: explicit
    Date d3 = {15};      // error: = init cannot do implicit conversions
    Date d4 = 15;        // error: = init cannot do implicit conversions

    void f()  {
      my_fct(15);       // error: arg passing does not do implicit conversions
      my_fct({15});     // error: arg passing does not do implicit conversions
      my_fct(Date{15}); // OK: explicit
    }

By default, declare a constructor that can be called with a single argument
`explicit`. You need a good reason not to do so (as for `complex`).

*Immutability via const member functions*:

The `const` specifier declares that a member function does not modify the state
of its object (it provides immutability).

     class Date {
       int d, m, y;
     public:
       int day() const { return d; }
       int month() const { return m; }
       int year() const;
       void add_year(int n);
     }

     int Date::year() const {
       return ++y; // error: attempt to change member value in const function
     }

A member *can* be defined as `mutable` to allow it to be modified even in a
`const` object, but often it is better to place the data that needs modification
in a separate object and access it indirectly (`const` does not apply
transitively to objects accessed through pointers or references).

*Static Members*:

Class members declared `static` exist on the class-level. For a static variable
there is exactly one copy (not one per object). A `static` member function can
be called without a particular object.

If used, a `static` member - a function or data member - must be defined
somewhere. The keyword `static` is not repeated in the definition of a static
member.

    //
    // date.h
    //
    class Date {
      int d, m, y;
      static Date default_date;
    public:
      Date(int dd = 0, int mm = 0, int yy = 0);
      static void set_default(int dd, int mm, int yy);
    };

    //
    // date.cpp
    //
    Date Date::default_date {16,12,1770}; // definition of Date::default_date

    void Date::set_default(int d, int m, int y) {
        default_date = {d,m,y};
    }

     Date::Date(int dd, int mm, int yy) {
         d = dd ? dd : default_date.d;
         m = mm ? mm : default_date.m;
         y = yy ? yy : default_date.y;
     }


*Member Types (nested class)*:

Types and type aliases can be members of a class. A *member class* (often called
a *nested class*) can refer to types and static members of its enclosing class.
A nested class has access to members of its enclosing class, even to private
members (just as a member function has), but has no notion of a current object
of the enclosing class.

    // tree.h

    template<typename T>
    class Tree {
        using value_type = T;                // member alias
        enum Policy { rb, splay, treeps };   // member enum

        class Node {                         // member class
            Node∗ right;
            Node∗ left;
            value_type value;
          public:
            void f(Tree∗);
        };

        Node∗ top;
    public:
         void g(const T&);
    };

    // tree.cpp

    template<typename T>
    void Tree::Node::f(Tree∗ p) {
        top = right;                // error: no object of type Tree specified
        p−>top = right;             // OK
        value_type v = left−>value; // OK: value_type not associated with object
    }

Member classes are more a notational convenience than a feature of fundamental
importance. On the other hand, member aliases are important as the basis of
generic programming techniques relying on associated types.

## Construction, Cleanup, Copy and Move
(The C++ Programming Language, Chapter 17)

    string ident(string arg) { // string passed by value (copied into arg)
        return arg;            // move the value of arg out of ident() to caller
    }

    int main ()  {
        string s1 {"Adams"}; // initialize string (construct in s1).
        s1 = ident(s1);      // copy s1 into ident()
                             // move the result of ident(s1) into s1;
                             // s1's value is "Adams".

        string s2 {"Pratchett"};  // initialize string (construct in s2)
        s1 = s2;                  // copy the value of s2 into s1
                                  // both s1 and s2 have the value "Pratchett".
    }  // s1's and s2's destructors are called to release heap-allocated
       // space for their strings

The difference between *move* and *copy* is that after a copy two objects must
have the same value, whereas after a move the source of the move is not required
to have its original value. Moves can be used when the source object will not be
used again.

Constructors, copy and move assignment operations, and destructors directly
support a view of lifetime and resource management (e.g. RAII).

Constructors, destructors, and copy and move operations for a type are not
logically separate.  We must define them as a matched set or suffer logical or
performance problems. If a class X has a destructor that performs a nontrivial
task, such as free-store deallocation or lock release, the class is likely to
need the full complement of functions:

    class X {
        X(Sometype);            // "ordinary" constructor
        X();                    // default constructor
        X(const X&);            // copy constructor
        X(X&&);                 // move constructor
        X& operator=(const X&); // copy assignment: clean up target and copy
        X& operator=(X&&);      // move assignment: clean up target and move
        ~X();                   // destructor
    };

There are five situations in which an object is copied or moved:
- As the source of an assignment
- As an object initializer
- As a function argument
- As a function return value
- As an exception

In all cases, the copy or move constructor will be applied (unless it can be
optimized away).

Constructors and destructors interact correctly with class hierarchies. A
constructor builds a class object "from the bottom up":
1. first, the constructor invokes its base class constructors,
2. then, it invokes the member constructors, and
3. finally, it executes its own body.

A destructor "tears down" an object in the reverse order:
1. first, the destructor executes its own body,
2. then, it invokes its member destructors, and
3. finally, it inv okes its base class destructors.

In particular, a `virtual` base is constructed before any base that might use it
and destroyed after all such bases. This ordering ensures that a base or a
member is not used before it has been initialized or used after it has been
destroyed.

A destructor can be declared to be `virtual`, and usually should be for a class
with a `virtual` function. The reason we need a `virtual` destructor is that an
object usually manipulated through the interface provided by a base class is
often also `delete`d through that interface:

    class Shape {
    public:
        virtual void draw() = 0;
        virtual ~Shape();
    };

    class Circle : public Shape {
    public:
        void draw();
        ~Circle();
    };


Bases of a derived class are initialized in the same way non-static data members
are. If a base requires an initializer, it must be provided as a base
initializer in a constructor.

    class B1 { B1(); };   // has default constructor
    class B2 { B2(int); } // no default constructor

    struct D1 : B1, B2 {
        D1(int i) : B1{}, B2{i} {}   // must call B2(int).
    };

It's possible to define one constructor in terms of another using a *delegating
constructor*/*forwarding constructor* in the member initializer:

    class X {
      int a;
    public:
      X(int x) { if (0<x && x<=max) a=x; else throw Bad_X(x); }
      X() : X{42} { }
      X(string s) : X{to<int>(s)} {}
    };

Delegating by calling another constructor in a constructor's member and base
initializer list is very different from explicitly calling a constructor in the
body of a constructor. The `X{42}` simply creates a new unnamed object (a
temporary) and does nothing with it.

      X() { X{42}; } // likely error

We can specify an initializer for a non- static data member in the class
declaration.

    class A {
    public:
      int a {7};
      int b = 77;
    };

A constructor will use such an in-class initializer, so that the above code is
equivalent to:

    class A {
    public:
      int a; int b;
    A() : a{7}, b{77} {};

If a member is initialized by both an in-class initializer and a constructor,
only the constructor's initialization is done (it "overrides" the default).

A `static` class member is statically allocated rather than part of each object
of the class. Generally, the static member declaration acts as a declaration for
a definition outside the class.

     // node.h
     class Node {
       static int node_count;  // declaration
     };

     // node.cpp
     int Node::node_count = 0;  // definition


*Copy vs Move*:

When we need to transfer a value from `a` to `b`, we usually have two options:
- Copy is the conventional meaning of `x=y;` that is, the effect is that the
  values of `x` and `y` are both equal to `y`'s value before the assignment.
- Move leaves `x` with `y`'s former value and `y` in some moved-from state. For
  the most interesting cases, containers, that moved-from state is "empty".

- A move cannot throw, whereas a copy might (because it may need to acquire a
  resource).
- A move is often more efficient than a copy.
- A move operation *should* leave the source object in a valid but unspecified
  state because it will eventually be destroyed and the destructor cannot
  destroy an object left in an invalid state. Also, standard-library algorithms
  rely on being able to assign to (using move or copy) a moved-from object. So,
  design your moves not to throw, and to leave their source objects in a state
  that allows destruction and assignment.
- To save us from repetitive work, copy and move have default definitions. Use
  the default copy and move constructor unless you have a specific reason not to
  (like pointers or resource handles which would, for instance, be copied
  memberwise).

*Copy*:

Copy for a class X is defined by two operations:
- Copy constructor: `X(const X&)`
- Copy assignment:  `X& operator=(const X&)`

What does a copy constructor or copy assignment have to do to be considered "a
proper copy operation"? In addition to be declared with a correct type, a copy
operation must have the proper *copy semantics*.

- *Equivalence*: After `x=y`, operations on x and y should give the same
  result. In particular, if `==` is defined for their type, we should have
  `x==y` and `f(x)==f(y)` for any function `f()`.
- Independence: After `x=y`, operations on `x` should not implicitly change the
  state of `y`.

The default menaing of copy is memeberwise copy. However, we need to be careful
when pointers/resource handles are involved. For such members we need to do a
"deep copy". An exception to this rule is *immutable* state, which is not a
problem to share.

A copy constructor and a copy assignment differ in that a copy constructor
initializes uninitialized memory, whereas the copy assignment operator must
correctly deal with an object that has already been constructed and may own
resources. In some cases, copy assignment should protect against
self-assignment, `m=m`.

For the purposes of copying, a base is just a member: to copy an object of a
derived class you have to copy its bases:

    struct B1 {
        ...
        B1(const B1&);
    };

    struct B2 {
        ...
        B2(const B2&);
    };

    struct D : B1, B2 {
        D(const D& a) :B1{a}, B2{a}, m1{a.m1}, m2{a.m2} {}

        B1 m1;
        B2 m2;
    };


*Move*:

Consider the obvious implementation of `swap()`:

    template<class T>
    void swap(T& a, T& b) {
        const T tmp = a;   // put a copy of a into tmp
        a = b;             // put a copy of b into a
        b = tmp;           // put a copy of tmp into b
    };

This works well enough for `int`s but what if we use `swap` with `string`s, each
of 10000 characters (or large `Matrix`es)? The cost of copying those data
structures could be significant, and we really only wanted to exchange a pair of
values.

The idea behind a move assignment is to handle lvalues separately from rvalues:
copy assignment and copy constructors take lvalues whereas move assignment and
move constructors take rvalues. For a return value, the move constructor is
chosen.  We can define Matrix ’s move constructor to simply take the
representation from its source and replace it with an empty Matrix (which is
cheap to destroy).

    template<class T>
    Matrix<T>::Matrix(Matrix&& a)
      : dim{a.dim}, elem{a.elem}  // grab a's representation
    {
        a.dim = {0,0};            // clear a's representation
        a.elem = nullptr;
    }

For move assignment, we can do a swap (the idea behind using a swap to implement
a move assignment is that the source is just about to be destroyed, so we can
just let the destructor for the source do the necessary cleanup work for us):

    template<class T>
    Matrix<T>& Matrix<T>::operator=(Matrix&& a)
    {
        std::swap(dim,a.dim);      // swap representations
        std::swap(elem,a.elem);

        return ∗this;
    }


In a few cases, such as for a return value, the language rules say that tje
compiler can use a move operation (because the next action is defined to destroy
the element). However, in general we have to tell it by giving an rvalue
reference argument. For example:

    template<class T>
    void swap(T& a, T& b)
    {
        T tmp = std::move(a);
        a = std::move(b);
        b = std::move(tmp);
    }

`std::move()` returns an rvalue reference to its argument: `move(x)` means "give
me an rvalue reference to x".  That is, `std::move(x)` does not move anything;
instead, it allows a user to move x. A better name would have been `std:rval()`.

Having move operations affects the idiom for returning large objects from
functions. Performance-wise, it is perfectly fine to return a large
stack-allocated object if it defines a move constructor, the "return by value"
is both simple to use and efficient.

*Generated Default Constructors and Operators*:

Writing conventional operations, such as a copy and a destructor, can be tedious
and error-prone, so the compiler can generate them for us as needed. By default,
a class provides:
- A default constructor: `X()`
- A copy constructor: `X(const X&)`
- A copy assignment: `X& operator=(const X&)`
- A move constructor: `X(X&&)`
- A move assignment: `X& operator=(X&&)`
- A destructor: `~X()`

The compiler generates each of these operations if a program uses it. However,
if the programmer takes control by defining one or more of those operations, the
generation of related operations is suppressed:
- If the programmer declares any constructor for a class, the default
  constructor is not generated for that class.
- If the programmer declares a copy operation, a move operation, or a destructor
  for a class, no copy operation, move operation, or destructor is generated for
  that class.

The default meaning of each generated operation, as implemented when the
compiler generates it, is to apply the operation to each base and non-static
data member of the class. That is, we get memberwise copy, memberwise default
construction, etc.

        struct S {
            string a;
            int b;
        };

        S f(S arg) {
            S s0 {};     // default construction: {"",0}
            S s1 {s0};   // copy constr uction
            s1 = arg;    // copy assignment
            return s1;   // move constr uction
        }

We can be explicit about which functions are generated by using `= default` and
`= delete`. The use of `= default` is needed in case we have defined a
non-default constructor and *also* want a default constructor to be generated.

    class gslice {
        gslice() = default;
        ~gslice() = default;
        gslice(const gslice&) = default;
        gslice(gslice&&) = default;
        gslice& operator=(const gslice&) = default;
        gslice& operator=(gslice&&) = default;
    };


When we `= delete` a function we state that it does not exist so that it is an
error to try to use it (implicitly or explicitly). The most obvious use is to
eliminate otherwise defaulted functions. For example, it is common to want to
prevent the copying of classes used as bases because such copying easily leads
to "slicing":

    class Base {
        Base& operator=(const Base&) = delete; // disallow copying
        Base(const Base&) = delete;

        Base& operator=(Base&&) = delete;      // disallow moving
        Base(Base&&) = delete;
    };

    Base x1;
    Base x2 {x1}; // error : no copy constructor

For every class, we should ask:
1. Is a default constructor needed (because the default one is not adequate or
   has been suppressed by another constructor)?
2. Is a destructor needed (e.g., because some resource needs to be released)?
3. Are copy operations needed (because the default copy semantics is not
   adequate, e.g., because the class is meant to be a base class or because it
   contains pointers to objects that must be deleted by the class)?
4. Are move operations needed (because the default semantics is not adequate,
   e.g., because an empty object doesn’t make sense)?


Some general advice:
- If a constructor acquires a resource, its class needs a destructor to release
  the resource.
- If a class has a `virtual` function, it needs a `virtual` destructor.
- If a class has a reference member, it probably needs copy operations (copy
  constructor and copy assignment).
- If a class is a resource handle, it probably needs copy and move operations.
- If a class has a pointer member, it probably needs a destructor and
  non-default copy operations.
- If a class is a resource handle, it needs a constructor, a destructor, and
  non-default copy operations.
- If a default constructor, assignment, or destructor is appropriate, let the
  compiler generate it (`= default`).
- Make sure that copy assignments are safe for self-assignment.

## Tools
- Compiler: clang, g++
- Build/packaging: CMake

## Project structure

## CMake
CMake is a build file generator that uses a compiler-independent configuration
language. It enables building, testing and packaging of software. It is
cross-platform and can generate build files for different tools (make, xcode,
ninja, vs).
