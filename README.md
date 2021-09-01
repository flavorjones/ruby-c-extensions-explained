# Ruby C Extensions, Explained

This is intended to be an explanatory repository demonstrating a few different strategies for building C extensions. It's a companion repository to some conference talks being given in 2021 by Mike Dalessio (@flavorjones).

# Strategies

A few commonly-followed approaches have emerged in the Ruby ecosystem. Broadly categorized, the
strategies are:

## Strategy 0, "isolated"

A self-contained C extension (no external libraries).

See subdirectory [/isolated](./isolated).

Real-world examples:

- https://github.com/bcrypt-ruby/bcrypt-ruby


## Strategy 1, "system"

Find and use an external library already installed on the target system

See subdirectory [/system](./system).

Real-world examples:

- https://github.com/rmagick/rmagick
- https://github.com/sparklemotion/sqlite3-ruby


## Strategy 2, "packaged"

Package your own source code for the external library, and compile during installation

See subdirectories [/packaged_source](./packaged_source) and [/packaged_tarball](./packaged_tarball).


Real-world examples:

- https://github.com/rubys/nokogumbo
- https://github.com/sass/sassc-ruby


## Strategy 3, "precompiled"

Precompile the library ahead-of-time and package the shared libraries

Real-world examples:

- https://github.com/grpc/grpc/tree/master/src/ruby


## Combinations

These strategies can also be combined, which this repository also demonstrates.

### "system", fallback to "packaged"

Real-world examples:

- https://github.com/ruby/psych

### "precompiled", fall back to "packaged, leave option for "system"

Real-world examples:

https://github.com/sparklemotion/nokogiri
