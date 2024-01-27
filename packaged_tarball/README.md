# RCEE::PackagedTarball

This gem is part of the Ruby C Extensions Explained project at https://github.com/flavorjones/ruby-c-extensions-explained

## Summary

Many third-party libraries have their own build process based on tools like "autoconf" or "cmake". For those libraries, it might be really challenging to just copy the C files and let MakeMakefile compile them. In those situations, it's possible to package the entire upstream tarball and use that at installation time.


## Details

An important tool that we rely on for building third-party libraries is [`flavorjones/mini_portile`](https://github.com/flavorjones/mini_portile). It is able to configure a tarball distribution that relies on "autoconf" or "cmake" and compile it into a library that we can link against.

We add the tarball to the gemspec so that it's packaged with the rest of the gem:

``` ruby
Gem::Specification.new do |spec|
  # ...
  spec.files         << "ports/archives/yaml-0.2.5.tar.gz"
  # ...
end
```

The `extconf.rb` is about to get more complicated. To help manage the complexity, we'll use a module with a `.configure` method:

``` ruby
module RCEE
  module PackagedTarball
    module ExtConf
      class << self
        def configure
          configure_packaged_libraries
          create_makefile("rcee/packaged_tarball/packaged_tarball")
        end
      end
    end
  end
end

RCEE::PackagedTarball::ExtConf.configure
```

The `ExtConf` contains a method `configure_packaged_libraries` which uses `mini_portile` to download the library (if necessary); verify the checksum; extract the files; configure, compile, and link it; and finally configure `MakeMakefile` to find the headers and the library:

``` ruby
def configure_packaged_libraries
  recipe = libyaml_recipe

  # ensure libyaml has already been unpacked, configured, and compiled
  unless File.exist?(File.join(recipe.target, recipe.host, recipe.name, recipe.version))
    recipe.cook
  end

  # use the packaged libyaml
  recipe.activate
  pkg_config(File.join(recipe.path, "lib", "pkgconfig", "yaml-0.1.pc"))

  # assert that we can build against the packaged libyaml
  unless have_library("yaml", "yaml_get_version", "yaml.h")
    abort("\nERROR: *** could not find libyaml development environment ***\n\n")
  end
end

def libyaml_recipe
  MiniPortile.new("yaml", "0.2.5").tap do |recipe|
    recipe.files = [{
      url: "https://github.com/yaml/libyaml/releases/download/0.2.5/yaml-0.2.5.tar.gz",
      sha256: "c642ae9b75fee120b2d96c712538bd2cf283228d2337df2cf2988e3c02678ef4"
    }]
    recipe.target = File.join(PACKAGE_ROOT_DIR, "ports")
  end
end
```

Of special note, we're able to use `pkgconfig` to do much of our extension configuration, which allows us to have a pretty clean configuration. This is one advantage to using upstream distributions.

Note that all of those steps happen *before* the Makefile is created, so that the Makefile will contain the appropriate paths and flags to build our extension against libyaml.


## Testing

See [.github/workflows/packaged_source.yml](../.github/workflows/packaged_source.yml)

Key things to note:

- matrix across all supported Rubies and platforms
- caching the compiled library speeds up builds as well as avoids re-downloading the tarball over and over
  - note that the cache key includes the platform and the hash of extconf.rb


## What Can Go Wrong

If you run `gem install rcee_packaged_tarball` and see this in action, You'll note that PackagedTarball is significantly slower than PackagedSource, and that's because MiniPortile is running additional configuration steps to build the library.

Maintainers now have an additional responsibility to keep that library up-to-date and secure for your users.
