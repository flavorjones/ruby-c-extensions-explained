# Ruby C Extensions, Explained

<!-- use "markdown-toc -i README.md" to regenerate the table of contents -->

<!-- toc -->

- [Background](#background)
- [How To Use This Repository](#how-to-use-this-repository)
- [Strategies](#strategies)
  * [Strategy 0, "isolated"](#strategy-0-isolated)
  * [Strategy 1, "system"](#strategy-1-system)
  * [Strategy 2a, "packaged_source"](#strategy-2a-packaged_source)
  * [Strategy 2b, "packaged_tarball"](#strategy-2b-packaged_tarball)
  * [Strategy 3, "precompiled"](#strategy-3-precompiled)
- [Strategy Combinations](#strategy-combinations)
  * ["system", fallback to "packaged"](#system-fallback-to-packaged)
  * ["precompiled", fall back to "packaged", leave option for "system"](#precompiled-fall-back-to-packaged-leave-option-for-system)
- [FAQ](#faq)
  * [How do you test cross-compiling gems on Github Actions?](#how-do-you-test-cross-compiling-gems-on-github-actions)
  * [What's the significance of the flowers you're using as a background image for your RubyKaigi slides?](#whats-the-significance-of-the-flowers-youre-using-as-a-background-image-for-your-rubykaigi-slides)

<!-- tocstop -->

## Background

Hello there! Welcome to Ruby C Extensions, Explained.

This repository, and the example ruby gems in it, were originally written as companion materials for some conference talks being given in 2021 by Mike Dalessio (@flavorjones).

- [RubyKaigi 2021 talk](https://rubykaigi.org/2021-takeout/presentations/flavorjones.html) 2021-09-11
  - This talk focuses mostly on the mechanics of the gems in this repository.
  - [slides](https://docs.google.com/presentation/d/1litUWFDOfIiMRiM39B-eSG5IcJPUG5aKYAAOZ8rWLT0/) and [video](https://rubykaigi.org/2021-takeout/presentations/flavorjones.html)
- [RubyConf 2021 talk](https://rubyconf.org/program/sessions#session-1214) 2021-11-08
  - This talk may cover slightly different material, including an approach to rigorous testing, how to think about Trust in the context of precompilation, and what industrializing precompilation might look like.

## How To Use This Repository

Each of the gems in this repository demonstrate a different strategy for integrating with (or packaging) third-party libraries. A brief explanation of the strategies is below, and the code for each gem is in a distinct subdirectory, along with a README that contains a more complete explanation.

Each gem builds on the previous one if you tackle them in this order:

- [/isolated](./isolated)
- [/system](./system)
- [/packaged_source](./packaged_source)
- [/packaged_tarball](./packaged_tarball)
- [/precompiled](./precompiled)


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


## FAQ

I'll try to answer questions asked during conference Q&A here.

### How do you test cross-compiling gems on Github Actions?

Nokogiri uses the `rake-compiler-dock` OCI images directly to build the gem; and then uses the upload-artifact/download-artifact actions to install that gem on the target system.

See https://github.com/sparklemotion/nokogiri/blob/main/.github/workflows/gem-install.yml for the concrete implementation!


### What's the significance of the flowers you're using as a background image for your RubyKaigi slides?

I tweeted a brief teaser video in which I explained the joke!

<blockquote class="twitter-tweet">
  <p lang="en" dir="ltr">When I edited my RubyKaigi talk about C extensions, some bits had to be cut for time. Here&#39;s a fun teaser that I put together from some of those bits. [video link]
    <a href="https://t.co/wZjSepHNpq">pic.twitter.com/wZjSepHNpq</a>
  </p>
  &mdash; mike dalessio (@flavorjones)
  <a href="https://twitter.com/flavorjones/status/1435979823688691723?ref_src=twsrc%5Etfw">September 9, 2021</a>
</blockquote>

In short, my friend Mark once sent me flowers for my birthday along with a card that read:

``` text
Fetching nokogiri-1.8.0.gem (100%)
Building native extensions. This could take a while...
```

Mark is funny. This was the inspiration for the talk's title.
