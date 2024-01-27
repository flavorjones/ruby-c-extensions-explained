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


## Making a release

- update versions
  - [ ] bump the versions in `rcee.gemspec`
  - [ ] `rake version:set`
  - [ ] update `CHANGELOG.md`
  - [ ] git commit
  - [ ] git tag
- build
  - [ ] `rake clean clobber`
  - [ ] `rake package`
- push
  - [ ] `for gem in gems/*.gem ; do gem push $gem ; done`
  - [ ] `git push && git push --tags`
  - [ ] release marker at https://github.com/flavorjones/ruby-c-extensions-explained/releases
