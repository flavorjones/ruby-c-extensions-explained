# Ruby C Extensions, Explained

## Background

Hello there! Welcome to Ruby C Extensions, Explained.

This repository, and the example ruby gems in it, were originally written as companion materials for some conference talks being given in 2021 by Mike Dalessio (@flavorjones).

- [RubyKaigi 2021 talk](https://rubykaigi.org/2021-takeout/presentations/flavorjones.html)
- [RubyConf 2021 talk](https://rubyconf.org/program/sessions#session-1214)


## Usage

Each of the gems in this repository demonstrate a different strategy for integrating with (or packaging up) third-party libraries. A brief explanation of each strategy is later in this document, and each gem is in a distinct subdirectory.

I'm planning to expand the reading materials to include everything from the talks; until then, I appreciate your patience with my sparse descriptions.

Each gem builds on the previous one if you tackle them in this order:

- [/isolated](./isolated)
- [/system](./system)
- [/packaged_source](./packaged_source)
- [/packaged_tarball](./packaged_tarball)
- [/precompiled](./precompiled)


## Installation

These are actual, working gems! And they've all been pushed to rubygems.org:

- `gem install rcee_isolated`
- `gem install rcee_system`
- `gem install rcee_packaged_source`
- `gem install rcee_packaged_tarball`
- `gem install rcee_precompiled`

Or they can all be installed as dependencies of the meta-gem `rcee`:

- `gem install rcee`


## Strategies

A few commonly-followed approaches have emerged in the Ruby ecosystem. Broadly categorized, the
strategies are:

### Strategy 0, "isolated"

A self-contained C extension (no third-party libraries).

See subdirectory [/isolated](./isolated).

Real-world examples:

- https://github.com/bcrypt-ruby/bcrypt-ruby


### Strategy 1, "system"

Find and use an third-party library already installed on the target system.

See subdirectory [/system](./system).

Real-world examples:

- https://github.com/rmagick/rmagick
- https://github.com/sparklemotion/sqlite3-ruby


### Strategy 2a, "packaged_source"

Package the source code for the third-party library, and compile it into the C extension during installation.

See subdirectory [/packaged_source](./packaged_source).

Real-world examples:

- https://github.com/ruby/psych
- https://github.com/rubys/nokogumbo
- https://github.com/rubys/sassc-ruby


### Strategy 2b, "packaged_tarball"

Package the tarball distribution for the third-party library, use its configuration toolchain and build a library that the C extension can link against.

See subdirectory [/packaged_tarball](./packaged_tarball).


Real-world examples:

- https://github.com/sparklemotion/nokogiri
- https://github.com/kwilczynski/ruby-magic


### Strategy 3, "precompiled"

Precompile the library and C extension ahead-of-time for a subset of platforms; fall back to `packaged_tarball` strategy for other platforms.

See subdirectory [/precompiled](./precompiled)

Real-world examples:

- https://github.com/sparklemotion/nokogiri
- https://github.com/kwilczynski/ruby-magic
- https://github.com/grpc/grpc/tree/master/src/ruby


## Strategy Combinations

These strategies can also be combined!

### "system", fallback to "packaged"

Real-world examples:

- https://github.com/ruby/psych


### "precompiled", fall back to "packaged", leave option for "system"

Real-world examples:

- https://github.com/sparklemotion/nokogiri
- https://github.com/kwilczynski/ruby-magic
