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

The `extconf.rb` contains a new block:

``` ruby
MiniPortile.new("yaml", "0.2.5").tap do |recipe|
  recipe.target = File.join(package_root_dir, "ports")
  recipe.files = [{
    url: "https://github.com/yaml/libyaml/releases/download/0.2.5/yaml-0.2.5.tar.gz",
    sha256: "c642ae9b75fee120b2d96c712538bd2cf283228d2337df2cf2988e3c02678ef4",
  }]

  unless File.exist?(File.join(recipe.target, recipe.host, recipe.name, recipe.version))
    recipe.cook
  end

  recipe.activate
  pkg_config(File.join(recipe.path, "lib", "pkgconfig", "yaml-0.1.pc"))
end
```

This block:

- downloads the libyaml tarball if necessary (note that the packaged gem includes the tarball and so this is skipped by end users during `gem install`)
- verifies the checksum of the tarball
- extracts the tarball
- configures the build system (for libyaml, this is "autoconf")
- compile libyaml's source code into object files
- link the object files together into a library we can use
- configure `MakeMakefile` to find the headers and the library

(Of special note, we're able to use `pkgconfig` to do much of our extension configuration, which allows us to have a pretty clean configuration. This is one advantage to using upstream distributions.)

Note that all of those steps happen *before* the Makefile is created -- it's run by `extconf.rb` so that the Makefile will know where to find our libyaml files.


## Testing

See [.github/workflows/packaged_source.yml](../.github/workflows/packaged_source.yml)

Key things to note:

- matrix across all supported Rubies and platforms
- caching the compiled library speeds up builds as well as avoids re-downloading the tarball over and over
  - note that the cache key includes the platform and the hash of extconf.rb


## What Can Go Wrong

If you run `gem install rcee_packaged_tarball` and see this in action, You'll note that PackagedTarball is significantly slower than PackagedSource, and that's because MiniPortile is running additional configuration steps to build the library.

Maintainers now have an additional responsibility to keep that library up-to-date and secure for your users.
