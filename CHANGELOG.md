# Changelog

## next / unreleased

### `precompiled`

The `precompiled` gem has been upgraded to rake-compiler-dock v1.9.1.


## v0.6.0 / 2024-12-14

### `precompiled`

The `precompiled` gem has added Ruby 3.4 and dropped Ruby 3.0 from the precompiled native gems.


## v0.5.1 / 2024-01-28

### `precompiled`

- The `precompiled` gem has switched from building `-linux` platform gems (implicit `gnu`) to explicit `-linux-gnu` platform gems, and now supports these platforms:
  - `aarch64-linux-gnu`
  - `aarch64-linux-musl`
  - `arm-linux-gnu`
  - `arm-linux-musl`
  - `arm64-darwin`
  - `x64-mingw-ucrt`
  - `x64-mingw32`
  - `x86-linux-gnu`
  - `x86-linux-musl`
  - `x86_64-darwin`
  - `x86_64-linux-gnu`
  - `x86_64-linux-musl`


## v0.5.0.1 / 2024-03-01

- `precompiled` uses `rake-compiler` v1.2.7 to ensure `required_rubygems_version` is set properly in the gemspec , see https://github.com/rake-compiler/rake-compiler/pull/236 for more details.


## v0.5.0 / 2024-01-27

### Improved

- The `extconf.rb` file in `packaged_tarball` and `precompiled` now use a `ExtConf` module pattern for encapsulation.

### `precompiled`

- The `precompiled` gem now supports Ruby 3.2 and 3.3, and drops support for Ruby 2.6 and 2.7
- The `precompiled` gem has added `musl` support for linux, and now supports these platforms:
  - `aarch64-linux`
  - `aarch64-linux-musl`
  - `arm-linux`
  - `arm-linux-musl`
  - `arm64-darwin`
  - `x64-mingw-ucrt`
  - `x64-mingw32`
  - `x86-linux`
  - `x86-linux-musl`
  - `x86_64-darwin`
  - `x86_64-linux`
  - `x86_64-linux-musl`


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
