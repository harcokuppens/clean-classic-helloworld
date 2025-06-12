# Debugging in Clean

Debugging in Clean is done by adding tracing to the program. This document outlines
the primary methods for tracing program execution in Clean: `ctrace` and
`print_graph`.

When you want to add tracing to a Clean program you best can use the `->>` operator
to easily add trace statements at the end of lines, and which later can also be
easily removed.

When the function `->>` cannot print a value, then use the `->>-` operator instead,
and when trace message get printed in the wrong order one can use the `ctrace_tn` or
`print_graph` functions in a guard to enforce evaluation at the right time.

**Table of contents**

<!--ts-->
<!-- prettier-ignore -->
   * [Overview tracing Methods](#overview-tracing-methods)
   * [Tracing with trace and -&gt;&gt;](#tracing-with-trace-and--)
      * [Usage of trace_n vs. trace_tn](#usage-of-trace_n-vs-trace_tn)
      * [Tracing the Final Result of a Function](#tracing-the-final-result-of-a-function)
      * [Adding Traces to Functions with Existing Guards](#adding-traces-to-functions-with-existing-guards)
      * [Problem: toString Constraint](#problem-tostring-constraint)
   * [Tracing with ctrace and  -&gt;&gt;](#tracing-with-ctrace-and---)
      * [Configuration of internal show](#configuration-of-internal-show)
   * [Tracing with print_graph and -&gt;&gt;-](#tracing-with-print_graph-and---)
      * [Wrapper print_graph](#wrapper-print_graph)
      * [Usage of print_graph](#usage-of-print_graph)
      * [The -&gt;&gt;- Operator](#the----operator)
   * [Conclusion](#conclusion)
<!--te-->

## Overview tracing Methods

There are three basic methods for tracing in Clean:

1.  **`trace`**:

    - Prints output to `stderr` (standard error).
    - The value to printed by the `trace` is required to be an `toString` instance.
    - Define in the `StdDebug` module in the standard library.

2.  **`ctrace`**:

    - Prints output to `stderr` (standard error).
    - Often used with the `->>` binary operator form.
    - The `ctrace` function uses an internal function which can convert many types to
      string, however for to complex types it can fail.
    - The letter 'c' stands for custom. It is adviced to use this improved `ctrace`
      function instead of the `trace` function in the standard library.
    - Defined in the `CustomDebug` module.

3.  **`print_graph`**:
    - Prints output to `stdout` (standard output).
    - Often used with the `->>-` binary operator form (defined in `CustomDebug`).
    - Will always succeed in printing the graph representation of the value.
    - Defined in the `CustomDebug` module.

It's important to note that all three tracing methods may fail when the traced
expression is not evaluated due to laziness. In that case you best can use
`ctrace_tn` or `print_graph` in a guard to ensure it gets evaluated.

The `trace` function and its variants are defined in the `StdDebug` module, part of
Clean's standard library.

The `ctrace` and `print_graph` functions and the `->>` and `->>-` operators are
defined in the `CustomDebug` custom library module.

## Tracing with `trace` and `->>`

The `trace` function family is found in `StdEnv/StdDebug.dcl`. Here are the relevant
declarations:

```clean
import StdClass

from StdString import instance toString	{#Char},instance toString Int

// The following functions should only be used for debugging,
// because these functions have side effects

trace :: !msg .a -> .a | toString msg	// write toString msg to stderr
                                        // before evaluating a

trace_n :: !msg .a -> .a | toString msg	// write toString msg and newline to stderr
                                        // before evaluating a


trace_t :: !msg -> Bool | toString msg	// write toString msg to stderr
                                        // result is True

trace_tn :: !msg -> Bool | toString msg	// write toString msg and newline to stderr
                                        // result is True
```

These functions require the message argument (`msg`) to have a `toString` instance.

### Usage of `trace_n` vs. `trace_tn`

Consider a function `myfunc`:

```clean
myfunc ..
    ..
    = bla
```

**Using `trace_n`:**

```clean
myfunc ..
    ..
    = trace_n msg bla
```

In this case, `trace_n msg bla` will print the message _before_ evaluating `bla`.
However, due to Clean's laziness, `bla` might not be evaluated immediately if its
value isn't needed right away. This means the `trace_n` call might not be executed
when you expect.

**Using `trace_tn`:**

```clean
myfunc ..
    ..
    | trace_tn msg    // -> always executed because a guard must be evaluated!!
        = bla
```

Here, `trace_tn msg` is placed in a guard. Guards _must_ be evaluated to determine
which alternative to take. Since `trace_tn` always returns `True`, this guard
effectively acts as an "always true" guard that also has the side effect of printing
the message. This ensures the trace message is printed whenever `myfunc` is called
and reaches this guard, regardless of whether `bla`'s value is immediately needed.

**Advice:** Prefer `trace_tn` (in a guard) over `trace_n` to ensure the trace is
always executed when the function is called.

**Reference:** in the book 'Functional Programming in CLEAN'

- `trace` is discussed at section '3.9.4 Insufficient memory'
- `trace_n` is discussed at section '5.1.2 Tracing Program Execution' being wrapped
  in operator '--->'

### Tracing the Final Result of a Function

To trace the final result of a function, you can add a `trace_tn` guard before the
result:

**Original:**

```clean
myfunc ..
    ..
    = bla
```

**With tracing the result:**

```clean
import StdDebug

myfunc ..
    ..
    | trace_tn msg    // => outputs msg to stderr
        = bla         // then returns result bla
```

You can print multiple messages by combining `trace_tn` calls in a guard using `&&`:

```clean
import StdDebug

myfunc ..
    ..
    | trace_tn msg1 && trace_tn msg2 && trace_tn msg3 // (True && True && True) is True
        = bla
```

### Adding Traces to Functions with Existing Guards

If your function already has guards, you can add a trace message by adding a guard
that is always false _after_ the trace call. `trace_tn` always returns `True`, so
`not (trace_tn msg)` is always `False`.

**Original:**

```clean
myfunc ..
    | x == 0 = ..
    | x == 1 = ..
    ..
```

**With trace added:**

```clean
import StdDebug

myfunc ..
    | x == 0 = ..
    | not (trace_tn msg) // => prints msg to stderr
        = undef          // => never reached, but must be there
    | x == 1 = ..        // Note: `undef` represents an undefined value; evaluating it yields a runtime error.
    ..
```

This extra guard doesn't change the function's logic but ensures `msg` is printed
whenever this part of the function is evaluated.

### Problem: `toString` Constraint

The main problem with `trace` and its variants is that the message argument must
implement the `toString` type class. This is not always convenient, especially for
custom or complex data structures you just want to quickly inspect. You might need to
write `instance toString` code just for debugging purposes.

**Reference:** Below example is discussed in the book 'Functional Programming in
CLEAN' in section '5.1.2 Tracing Program Execution'.

**Example:**

Consider tracing the input `n` in a fibonacci function:

```clean
module fibtrace

import StdEnv

fib n = (if (n<2) 1 (fib (n-1) + fib (n-2)))

Start = fib 4
```

If we try to use a custom operator `--->` wrapping `trace_n` to print `("fib ", n)`:

```clean
module fibtrace

import StdEnv
import StdDebug

// define debugging operator '--->' wrapping trace_n
(--->) infix :: a !b -> a | toString b
(--->) value message = trace_n message value

fib n = (if (n<2) 1 (fib (n-1) + fib (n-2)))     ---> ("fib ", n) // PROBLEM HERE

Start = fib 4
```

**PROBLEM:** The tuple `("fib ", n)` does not automatically implement the `toString`
type class.

**FIX:** Manually define the `toString` instance for tuples:

```clean
module fibtrace

import StdEnv
import StdDebug

// define debugging operator '--->' wrapping trace_n
(--->) infix :: a !b -> a | toString b
(--->) value message = trace_n message value

// make (a,b) instance of toString
instance toString (a,b) | toString a & toString b where
    toString (a,b) = "(" +++ toString a +++ "," +++ toString b +++ ")"

fib n = (if (n<2) 1 (fib (n-1) + fib (n-2)))      ---> ("fib ", n)

Start = fib 4
```

Defining `toString` instances can be cumbersome when you just want a quick look at a
value.

## Tracing with `ctrace` and `->>`

To address the `toString` constraint, the `CustomDebug` library provides

- `ctrace_n` instead of `trace_n`
- `ctrace_tn` instead of `trace_tn`
- `->>` operator which is similar to the custom `--->` in previous section

These functions use internally a function (`show`) that can convert _almost any_
value to a string without needing a `toString` instance.

The above example becomes simpler by importing `CustomDebug`:

```clean
module fibtrace

import StdEnv
import CustomDebug

fib n = (if (n<2) 1 (fib (n-1) + fib (n-2)))     ->> ("fib ", n)

Start = fib 4
```

### Configuration of internal `show`

The `->>` operator is defined in `WrapDebug/CustomDebug.icl` as:

```clean
(->>) infixl 0 :: !.a .b -> .a;
(->>) value debugValue
    = debugAfter debugValue show value; // -> uses 'show' function
```

The `->>` is defined as an infix operator with low precedence (0) so that you can
easily place it at the end of an expression to inspect its value. Its left
ascociative so that you can chain several `->>` trace calls after each other.

It uses the internal `show` function which is also used by the `ctrace` functions.
The `show` function is defined in `WrapDebug/CustomDebug.icl` and relies on the
function `debugAfter` from `WrapDebug/Debug.dcl`.

From `WrapDebug/Debug.dcl`:

```clean
debugAfter :: .a !(DebugShowFunction .a) !.b -> .b
```

This function is somewhat similar to `trace :: !msg .a -> .a | toString msg`, but
instead of taking a message type with a `toString` constraint, it takes a
`DebugShowFunction .a` argument, which is a function capable of showing the value of
type `.a`.

Now we can explain how the definition of `->>` works:

1.  The `->>` operator takes the `value` (left-hand side) and `debugValue`
    (right-hand side, the message/value to show).

2.  It calls `debugAfter`, passing `debugValue`, the function `show`, and `value`.

3.  The `show` function is defined in `WrapDebug/CustomDebug.icl` and calls
    `debugShowWithOptions`:

    ```clean
    // show function with debug options
    show
        = debugShowWithOptions
            [DebugMaxChars 79, DebugMaxDepth 5, DebugMaxBreadth 20];
    ```

4.  `debugShowWithOptions` is a generic function that can represent _any_ value as a
    string based on the provided options, _without_ requiring a specific `toString`
    instance for that value's type. It prints this string representation to `stderr`.

5.  `debugAfter` then returns the original `value`, allowing the program execution to
    continue as if the `->>` operator wasn't there (except for the side effect of
    printing).

In `WrapDebug/CustomDebug.icl` you can customize the definition of `show` to
customize the printing of trace output. Currently the it has the following
definition:

```clean
show =	debugShowWithOptions [];
```

Making `show` print everything.

## Tracing with `print_graph` and `->>-`

The `_print_graph` is a low-level code function used by the Clean runtime to print
the graph representation of a value, including the final result of the `Start`
function.

**ADVANTAGE:** `_print_graph` (and wrappers around it) will _always_ succeed in
printing the graph, unlike `->>` which might encounter issues with certain types or
complex structures where `show` might not produce a complete or desired
representation. `_print_graph` prints to `stdout`.

### Wrapper `print_graph`

To use `_print_graph` conveniently in your Clean source, you can define a wrapper
function using a `code` block:

```clean
print_graph :: !.a -> Bool;
print_graph a = code {
    .d 1 0         // Describes the function's input/output stack usage
    jsr _print_graph // Call the low-level print_graph function
    .o 0 0         // Output stack usage
    pushB TRUE     // Push a boolean True onto the stack as the result
}
```

This `print_graph` function takes any value of type `.a` and returns `Bool` (`True`)
after printing the graph of `.a` to `stdout`.

### Usage of `print_graph`

Similar to `trace_tn`, `print_graph` is best used in a guard:

**Original source:**

```clean
myfunc ..
    ..
    = bla
```

**With `trace_tn` (prints to stderr):**

```clean
myfunc ..
    ..
    | trace_tn msg // -> always executed, because a guard must be evaluated!!
        = bla      // => prints to stderr
```

**With `print_graph` (prints to stdout):**

```clean
myfunc ..
    ..
    | print_graph msg // -> always executed, because a guard must be evaluated!!
        = bla         // => prints to stdout instead
```

### The `->>-` Operator

Similar to `->>`, a binary operator `->>-` is defined using `print_graph` to provide
a convenient syntax for tracing to `stdout` that always succeeds in showing the
graph. This operator is also typically defined in `CustomDebug`.

```clean
(->>-) infixl 0 :: a !b -> a;
(->>-) value msg
    | print_graph msg // prints msg (on rhs of operator) to stdout
        = value;      // returns value (on lhs of operator, as if the operator and rhs were not there)
    | otherwise       // never reached
        = undef;      // Note: undef represents an undefined value, evaluating it yields a runtime error.
```

This operator takes a `value` on the left and a `msg` on the right. It calls
`print_graph msg` in a guard, which prints the graph of `msg` to `stdout`. Since
`print_graph` returns `True`, the first alternative is always taken, returning the
original `value`. The `otherwise = undef` part is a fallback that is never reached
but necessary for the function definition.

Both `->>` and `->>-` are defined in the `CustomDebug` module. By importing
`CustomDebug`, you gain access to both operators, allowing you to choose whether to
print to `stderr` using the `show` function (`->>`) or to `stdout` using
`print_graph` (`->>-`). Use `->>-` when `->>` fails or when you prefer output on
`stdout` with a guaranteed graph representation.

## Conclusion

When you want to add tracing to a Clean program you best can use the `->>` operator
to easily add trace statements at the end of lines, and which later can also be
easily removed.

When the function `->>` cannot print a value, then use the `->>-` operator instead,
and when trace message get printed in the wrong order one can use the `ctrace_tn` or
`print_graph` functions in a guard to enforce evaluation at the right time.
