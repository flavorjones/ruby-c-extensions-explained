# RCEE::PackagedSource

This gem is part of the Ruby C Extensions Explained project at https://github.com/flavorjones/ruby-c-extensions-explained

## Summary

Some gems, like nokogumbo and psych, include the third-party library's C files.

This means the gem is *redistributing* the library -- so be careful with licensing implications if you do this. Packaging third-party libraries is a little more work for gem maintainers to set up, but may simplify your codebase and make installation more reliable.


## Details

This gem has simply copied the source files from `libyaml`, along with that library's LICENSE file, into the extensions directory:

``` text
ext/
└── packaged_source
    ├── extconf.rb
    ├── packaged_source.c
    ├── packaged_source.h
    └── yaml
        ├── LICENSE
        ├── api.c
        ├── config.h
        ├── dumper.c
        ├── emitter.c
        ├── loader.c
        ├── parser.c
        ├── reader.c
        ├── scanner.c
        ├── writer.c
        ├── yaml.h
        └── yaml_private.h
```

The `extconf.rb` contains some new code:

``` ruby
$VPATH << "$(srcdir)/yaml"
$srcs = Dir.glob("#{$srcdir}/{,yaml/}*.c").map { |n| File.basename(n) }.sort
append_cppflags("-I$(srcdir)/yaml")

find_header("yaml.h")
have_header("config.h")
```

It first configures `MakeMakefile` to pay attention to the `./yaml` directory as well as the C and header files. It then verifies that `yaml.h` can be found (we could skip this since we're packing it and setting the include path manually). Finally, a libyaml-specific action is taken which is to make sure `config.h` can be found and that the `HAVE_CONFIG_H` macro is set so that `yaml.h` is compiled properly.

The `Makefile` recipe looks something like:

``` sh
# `create_makefile` recipe is something like this

# compile phase:
gcc -c -I/path/to/ruby/include -I/path/to/libyaml/include packaged_source.c -o packaged_source.o
gcc -c -I/path/to/ruby/include -I/path/to/libyaml/include yaml/api.c -o api.o
gcc -c -I/path/to/ruby/include -I/path/to/libyaml/include yaml/dumper.c -o dumper.o
gcc -c -I/path/to/ruby/include -I/path/to/libyaml/include yaml/emitter.c -o emitter.o
gcc -c -I/path/to/ruby/include -I/path/to/libyaml/include yaml/loader.c -o loader.o
gcc -c -I/path/to/ruby/include -I/path/to/libyaml/include yaml/parser.c -o parser.o
gcc -c -I/path/to/ruby/include -I/path/to/libyaml/include yaml/reader.c -o reader.o
gcc -c -I/path/to/ruby/include -I/path/to/libyaml/include yaml/scanner.c -o scanner.o
gcc -c -I/path/to/ruby/include -I/path/to/libyaml/include yaml/writer.c -o writer.o

# link phase:
gcc -shared \
  -L/path/to/ruby/lib -lruby \
  -lyaml \
  -lc -lm \
  packaged_source.o api.o dumper.o emitter.o loader.o parser.o reader.o scanner.o writer.o \
  -o packaged_source.so
```

Now we're able to rely on a specific version of the library existing with known configuration, allowing us to avoid much real-world complexity in our `extconf.rb`, and our code.


## Testing

See [.github/workflows/packaged_source.yml](../.github/workflows/packaged_source.yml)

Key things to note:

- testing is simpler than `system` because there are no external dependencies
- matrix across all supported Rubies and platforms


## What Can Go Wrong

In addition to what's enumerated in `isolated`'s README ...

This strategy works pretty well for simple cases, but looking at the recipe, we can see that the libyaml code is being treated as if it were part of the Ruby C extension that we wrote. That's limiting, because the same compilation step must be shared across the extension code and the third-party library, and we need to be careful about filename collisions between the two filesets.

Maintainers now have an additional responsibility to keep that library up-to-date and secure for your users.
