# Contributing

Some short notes on how to operate this repository.

## Building all the gems

From the top-level directory:

``` sh
rake package
```

All the gem files will be placed into the `./gems` subdirectory.


## Bumping the gem versions

First edit the top-level `rcee.gemspec` with the desired version number.

Then, from the top-level directory:

``` sh
rake version:set
```

which will update the `lib/*/version.rb` file for all the gems. Make sure to commit these changes.
