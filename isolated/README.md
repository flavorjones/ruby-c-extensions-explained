# RCEE::Isolated

This gem is part of the Ruby C Extensions Explained project at https://github.com/flavorjones/ruby-c-extensions-explained

## Summary

This is the simplest viable C extension gem. It's named "Isolated" it's entirely self-contained, and doesn't call any external libraries.

You might choose to write a C extension like this as a performance optimization if you have some CPU-intensive work to do. The BCrypt gem is a good example of this kind of C extension -- it's iterating over cryptographic math which is simply faster in C than it would be in Ruby.

## Details

This gem's C code is located in `ext/isolated/isolated.c` and includes this singleton method:

``` C
static VALUE
rb_isolated_extension_class_do_something(VALUE self)
{
  /* todo: perform CPU-intensive operation */
  return rb_str_new_cstr("something has been done");
}

void
Init_isolated(void)
{
  rb_mRCEE = rb_define_module("RCEE");
  rb_mIsolated = rb_define_module_under(rb_mRCEE, "Isolated");
  rb_cIsolatedExtension = rb_define_class_under(rb_mIsolated, "Extension", rb_cObject);
  rb_define_singleton_method(rb_cIsolatedExtension, "do_something",
                             rb_isolated_extension_class_do_something, 0);
}
```

The `extconf.rb` is as simple as it gets:

``` ruby
require "mkmf"

create_makefile("rcee/isolated/isolated")
```

"mkmf" is short for MakeMakefile, a Ruby module that's shipped with the standard library. It defines "create_makefile" as well as a handful of other methods for advanced configuration, some of which we'll see in later examples.

The "create_makefile" method is what actually writes the recipe for _compiling_ and _linking_. Because we haven't configured anything, it's going to adopt a set of reasonable defaults.

The output `Makefile` is long and complex, but the recipe it implements is relatively simple and does something like:

``` sh
# `create_makefile` recipe is something like this

# compile phase:
gcc -c -I/path/to/ruby/include isolated.c -o isolated.o

# link phase:
gcc -shared -L/path/to/ruby/lib -lruby -lc -lm isolated.o -o isolated.so
```

That final shared library, `isolated.so`, is loaded like any other Ruby file, via `require` in `lib/rcee/isolated.rb`:

``` ruby
require_relative "isolated/isolated"
```

## Testing

See [.github/workflows/isolated.yml](../.github/workflows/isolated.yml)

Key things to note:

- matrix across all supported versions of Ruby
- matrix across all supported platforms


## What Can Go Wrong

1. Users don't have the compiler toolchain installed (`gcc`, `ld`, `stdio.h`, `libc.so`, etc.)
2. Users don't have the ruby development files installed (`ruby.h`, etc.)
3. Users try to use the compiled extension on a different minor version of Ruby, a different CPU architecture, or a different operating system.
