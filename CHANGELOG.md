# Changelog

## v0.5.0.1 / 2024-03-01

- `precompiled` uses `rake-compiler` v1.2.7 to ensure `required_rubygems_version` is set properly in the gemspec , see https://github.com/rake-compiler/rake-compiler/pull/236 for more details.


## v0.5.0 / 2024-01-27

### Added

- `precompiled` now supports the `arm-linux-musl` platform.
- `precompiled` now supports the `aarch64-linux-musl` platform.
- `precompiled` now supports the `x86-linux-musl` platform.
- `precompiled` now supports the `x86_64-linux-musl` platform.
- `precompiled` gem now supports Ruby 3.2 and 3.3, and drops support for Ruby 2.6 and 2.7
- The `extconf.rb` file in `packaged_tarball` and `precompiled` now use a `ExtConf` module pattern for encapsulation.


## 0.4.0 / 2022-05-19

### Added

- `precompiled` gem now supports Ruby 3.1 and drops support for Ruby 2.5
- `precompiled` gem now supports the `aarch64-linux` platform.
- `precompiled` gem now supports the `arm-linux` platform.
- `precompiled` gem now supports the `x86-linux` platform.
- `precompiled` gem now supports the `x64-mingw-ucrt` platform for Ruby 3.1


## 0.3.0 / 2021-11-08

### Fixed

- `precompiled` gem now builds correctly when compiling from source on Windows.


### Added

- Full test coverage for all gems can be inspected at https://github.com/flavorjones/ruby-c-extensions-explained/actions and in `.github/workflows/`.


## 0.2.0 / 2021-09-10

### Added

- Updated READMEs for individual gems.


## 0.1.1 / 2021-09-02

### Fixed

- The `rcee` gem dependencies are now properly named (with underscores, not dashes)


## 0.1.0 / 2021-09-02

First release.
