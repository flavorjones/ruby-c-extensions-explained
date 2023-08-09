# frozen_string_literal: true

begin
  require_relative "lib/rcee/precompiled/version"
rescue LoadError
  puts "WARNING: Could not load RCEE::Precompiled::VERSION"
end

Gem::Specification.new do |spec|
  spec.name          = "rcee_precompiled"
  spec.version       = defined?(RCEE::Precompiled::VERSION) ? RCEE::Precompiled::VERSION : "0.0.0"
  spec.authors       = ["Mike Dalessio"]
  spec.email         = ["mike.dalessio@gmail.com"]

  spec.summary       = "Example gem demonstrating a basic C extension."
  spec.description   = "Part of a project to explain how Ruby C extensions work."
  spec.homepage      = "https://github.com/flavorjones/ruby-c-extensions-explained"
  spec.required_ruby_version = ">= 2.7.0"
  spec.license = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = [
    ".gitignore",
    "Gemfile",
    "README.md",
    "Rakefile",
    "ext/precompiled/extconf.rb",
    "ext/precompiled/precompiled.c",
    "ext/precompiled/precompiled.h",
    "lib/rcee/precompiled.rb",
    "lib/rcee/precompiled/version.rb",
    "ports/archives/yaml-0.2.5.tar.gz",
    "rcee_precompiled.gemspec",
  ]

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/precompiled/extconf.rb"]

  spec.add_dependency "mini_portile2"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
