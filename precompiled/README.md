# RCEE::Precompiled

This gem is part of the Ruby C Extensions Explained project at https://github.com/flavorjones/ruby-c-extensions-explained

## Summary

Installation time is an important aspect of developer happiness, and the Packaged strategies can make your users very unhappy.

One way to speed up installation time is to precompile the extension, so that during `gem install` files are simply being unpacked, and the entire configure/compile/link process is avoided completely. This can be tricky to set up, and requires that you test across all the target platforms; but makes for much happier users.

Note, however, that it's necessary to _also_ ship the vanilla (platform=ruby) gem as a fallback for platforms you haven't pre-compiled for.

In the nine months since Nokogiri v1.11 started shipping precompiled native gems, we've seen over 45 million gem installations, and essentially zero support issues have been opened. Twitter complaints dropped to near zero. Page views of the Nokogiri installation tutorial dropped by half.

Precompiled Nokogiri gems have been an unmitigated success and have made both users and maintainers happy.


## Details

An important tool we rely on for precompiling is [`rake-compiler/rake-compiler-dock`](https://github.com/rake-compiler/rake-compiler-dock), maintained by Lars Kanis. `rake-compiler-dock` is a Docker-based build environment that uses `rake-compiler` to _cross compile_ for all of these major platforms.

What this means is, I can run my normal gem build process in a docker container on my Linux machine, and it will build gems that I run on Windows and MacOS.

This is really powerful stuff, and once we assume that we can cross-compile reliably, the remaining problems boil down to modifying how we build the gemfile and making sure we test gems adequately on the target platforms.

First, we need to add some features to our `Rake::ExtensionTask` in `Rakefile`:

``` ruby
cross_rubies = ["3.2.0", "3.1.0", "3.0.0", "2.7.0"]
cross_platforms = [
  "x64-mingw32",
  "x64-mingw-ucrt",
  "x86-linux",
  "x86_64-linux",
  "aarch64-linux",
  "x86_64-darwin",
  "arm64-darwin",
]
ENV["RUBY_CC_VERSION"] = cross_rubies.join(":")

Rake::ExtensionTask.new("precompiled", rcee_precompiled_spec) do |ext|
  ext.lib_dir = "lib/rcee/precompiled"
  ext.cross_compile = true
  ext.cross_platform = cross_platforms
  ext.cross_config_options << "--enable-cross-build" # so extconf.rb knows we're cross-compiling
  ext.cross_compiling do |spec|
    # remove things not needed for precompiled gems
    spec.dependencies.reject! { |dep| dep.name == "mini_portile2" }
    spec.files.reject! { |file| File.fnmatch?("*.tar.gz", file) }
  end
end
```

This does the following:

- set up some local variables to indicate what ruby versions and which platforms we will build for
- set an environment variable to let rake-compiler know which ruby versions we'll build
- tell the extension task to turn on cross-compiling features, including additional rake tasks
- signal to our `extconf.rb` when we're cross-compiling (in case its behavior needs to change)
- finally, in a block that is only run when cross-compiling, we modify the gemspec to remove things we don't need in native gems:
  - the tarball
  - the dependency on `mini_portile`

Next we need some new rake tasks:

``` ruby
namespace "gem" do
  cross_platforms.each do |platform|
    desc "build native gem for #{platform}"
    task platform do
      RakeCompilerDock.sh(<<~EOF, platform: platform)
        gem install bundler --no-document &&
        bundle &&
        bundle exec rake gem:#{platform}:buildit
      EOF
    end

    namespace platform do
      # this runs in the rake-compiler-dock docker container
      task "buildit" do
        # use Task#invoke because the pkg/*gem task is defined at runtime
        Rake::Task["native:#{platform}"].invoke
        Rake::Task["pkg/#{rcee_precompiled_spec.full_name}-#{Gem::Platform.new(platform)}.gem"].invoke
      end
    end
  end
end
```

The top task (or, really, _set_ of tasks) runs on the host system, and invokes the lower task within the appropriate docker container to cross-compile for that platform. So the bottom task is doing most of the work, and it's doing it inside a guest container. Please note that the worker is both building the extension *and* packaging the gem according to the gemspec that was just modified by our extensiontask cross-compiling block.

Changes to the `extconf.rb`:

``` ruby
def configure_cross_compilers
  RbConfig::CONFIG["CC"] = RbConfig::MAKEFILE_CONFIG["CC"] = ENV["CC"] if ENV["CC"]
  ENV["CC"] = RbConfig::CONFIG["CC"]
end
```

This makes sure that the cross-compiler is the compiler used within the guest container (and not the native linux compiler).

``` ruby
def cross_build?
  enable_config("cross-build")
end
```

The cross-compile rake task signals to `extconf.rb` that it's cross-compiling by using a commandline flag that we can inspect. We'll need this for `libyaml` to make sure that set the appropriate flags during precompilation (flags which shouldn't be set when compiling natively).

``` ruby
  # pass some environment variables to the libyaml configuration for cross-compilation
  if cross_build?
    ENV.to_h.tap do |env|
      # -fPIC is necessary for linking into a shared library
      env["CFLAGS"] = [env["CFLAGS"], "-fPIC"].join(" ")
      env["SUBDIRS"] = "include src" # libyaml: skip tests

      recipe.configure_options += env.map { |key, value| "#{key}=#{value.strip}" }
    end
  end
```

The rest of the extconf changes are related to configuring libyaml at build time. We need to set the -fPIC option so we can mix static and shared libraries together. (This should probably always be set.)

The "SUBDIRS" environment variable is something that's very specific to libyaml, though: it tells libyaml's autoconf build system to skip running the tests. We have to do this because although we can *generate* binaries for other platforms, we can't actually *run* them.

We have one more small change we'll need to make to how the extension is required. Let's take a look at the directory structure in the packaged gem:

``` text
lib
└── rcee
    ├── precompiled
    │   ├── 2.7
    │   │   └── precompiled.so
    │   ├── 3.0
    │   │   └── precompiled.so
    │   ├── 3.1
    │   │   └── precompiled.so
    │   ├── 3.2
    │   │   └── precompiled.so
    │   └── version.rb
    └── precompiled.rb
```

You can see that we have FOUR c extensions in this gem, one for each minor version of Ruby that we support. Remember that a C extension is specific to an architecture and a version of Ruby. For example, if we're running Ruby 3.0.1, then we need to load the extension in the 3.0 directory. Let's make sure we do that.

In `lib/rcee/precompiled.rb`, we'll replace the normal `require` with:

``` ruby
begin
  # load the precompiled extension file
  ruby_version = /(\d+\.\d+)/.match(::RUBY_VERSION)
  require_relative "precompiled/#{ruby_version}/precompiled"
rescue LoadError
  # fall back to the extension compiled upon installation.
  require "rcee/precompiled/precompiled"
end
```

Go ahead and try it! `gem install rcee_precompiled`. If you're on windows, linux, or macos you should get a precompiled version that installs in under a second. Everyone else (hello FreeBSD people!) it'll take a few more seconds to build the vanilla gem's packaged tarball.


## Testing

See [.github/workflows/precompiled.yml](../.github/workflows/precompiled.yml)

Key things to note:

- matrix across all supported Rubies and platforms (for compile-from-source installation testing)
- test native gems for a variety of platforms
  - use rake-compiler-dock images to build the gems
  - then install on native platforms and verify that it passes tests

Note that there's additional complexity because of how we test:

- see new script bin/test-gem-build which artificially bumps the VERSION string to double-check we're testing the packaged version of the gem (which the tests output)
- see new script bin/test-gem-install which installs the gem, deletes the local source code, and runs the tests against the installed gem
- the gemspec handles a missing version file (because we delete the local source code during testing)


## What Can Go Wrong

This strategy isn't perfect. Remember what I said earlier, that a compiled C extension is specific to

- the minor version of ruby (e.g., 3.0)
- the machine architecture (e.g., x86_64)
- the system libraries

The precompiled strategy mostly takes care of the first two, but there are still edge cases for system libraries. The big gotcha is that linux libc is not the same as linux musl, and we've had to work around this a few times in Nokogiri.

I'm positive that there are more edge cases that will be found as users add more platforms and as more gems start precompiling. I'm willing to bet money that you can break this by setting some Ruby compile-time flags on your system. I'm honestly surprised it works as well as it has. (Worth noting: the `sassc` gem stopped shipping native gems for linux because of the musl incompatibilities.)

So the lesson here is: make sure you have an automated test pipeline that will build a gem and test it on the target platform! This takes time to set up, but it will save you time and effort in the long run.
