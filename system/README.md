# RCEE::System

This gem is part of the Ruby C Extensions Explained project at https://github.com/flavorjones/ruby-c-extensions-explained

## Context

In the `isolated` gem, I mentioned that one goal of a C extension might be to optimize performance. This is the case for BCrypt.

But there's another, more common, reason to write a C extension, which is to talk to a third-party library. Many Ruby gems use C extensions solely to integrate with a third-party library. Some examples:

- nokogiri → libxml2, libxslt, libgumbo
- psych → libyaml
- sqlite3 → libsqlite3
- rmagick → libMagick
- grpc → libgrpc

These gems have a thin-ish wrapper of Ruby and C that work together to make the library's features available as idiomatic Ruby.


## Summary

This gem, as well as all the following gems, will call `libyaml` as an example third-party integration, and will require that `libyaml` be installed ahead of time on the target system.

Some real-world gems that use this "system" strategy are ruby-sqlite3 and rmagick.


## Details

This gem's C code is located in `ext/system/system.c`:

``` C
static VALUE
rb_system_extension_class_do_something(VALUE self)
{
  int major, minor, patch;

  yaml_get_version(&major, &minor, &patch);

  return rb_sprintf("libyaml version %d.%d.%d", major, minor, patch);
}
```

That's pretty simple, but is enough to demonstrate the integration with `libyaml` works.

The `extconf.rb` is still simple (and similar to `isolated/ext/isolated/extconf.rb` but contains this additional block:

``` ruby
dir_config('libyaml')
unless find_header("yaml.h") && find_library("yaml", "yaml_get_version")
  abort("\nERROR: *** could not find libyaml development environment ***\n\n")
end
```

`dir_config` is optional and mostly for users on MacOS as most ruby installers build Ruby with the `--with-libyaml-dir=/opt/homebrew/opt/libyaml` flag. The `dir_config` allows for this flag to be taken in consideration and help Ruby determine where to search for the yaml library.

`find_header` and `find_library` are `MakeMakefile` helper methods which will search your system's standard directories looking for files. If it finds them, it makes sure the compile step will be able to find `yaml.h`, and the link step will be able to find the `libyaml` library file.

We ask `find_header` to look for the `yaml.h` header file because that's what our C code needs (see `ext/system/system.h`). We ask `find_library` to look for a library named `libyaml` and check that it has the function `yaml_get_version()` defined in it.

(We don't need to call `find_library` for every function we intend to use; we just need to provide one function from the library so that `MakeMakefile` can verify that linking will succeed.)

If these methods succeed, the `Makefile` recipe looks something like this. Note the include directory is added for the compile step, and the library directory and name are added to the link step.

``` sh
# `create_makefile` recipe is something like this

# compile phase:
gcc -c -I/path/to/ruby/include -I/path/to/libyaml/include system.c -o system.o

# link phase:
gcc -shared \
  -L/path/to/ruby/lib -lruby \
  -L/path/to/libyaml/lib -lyaml \
  -lc -lm \
  system.o -o system.so
```

If you run `ldd` on the generated `system.so` you should see `libyaml` listed, something like:

``` text
	libyaml-0.so.2 => /usr/lib/x86_64-linux-gnu/libyaml-0.so.2 (0x00007f345a3dc000)
```


## Testing

See [.github/workflows/system.yml](../.github/workflows/system.yml)

Key things to note:

- matrix across all supported Rubies and platforms
- use the github action `ruby/setup-ruby-pkgs@v1` to install system libraries on each platform


## What Can Go Wrong

In addition to what's enumerated in `isolated`'s README ...

If `MakeMakefile` methods fail to find the third-party library (or fail to compile and link against it), then the user will see an error message, and have to go figure out how to install `libyaml` on their system.

If the third-party library is installed into non-standard directories by the package manager, your `extconf.rb` may need special logic. `rmagick` needs to do a lot of this.

If the third-party library has compile-time flags to control whether features are turned on or off, then your `extconf.rb` may need to test for that with `have_func` and your C code will need to handle the case where those methods aren't implemented.

The version of the third-party library may be older or newer than you expected, and either contain bugs or be missing new features, which also require additional code complexity.
