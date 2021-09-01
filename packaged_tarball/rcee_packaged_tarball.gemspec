# frozen_string_literal: true

require_relative "lib/rcee/packaged_tarball/version"

Gem::Specification.new do |spec|
  spec.name          = "rcee_packaged_tarball"
  spec.version       = RCEE::PackagedTarball::VERSION
  spec.authors       = ["Mike Dalessio"]
  spec.email         = ["mike.dalessio@gmail.com"]

  spec.summary       = "Write a short summary, because RubyGems requires one."
  spec.description   = "Write a longer description or delete this line."
  spec.homepage      = "https://example.com"
  spec.required_ruby_version = ">= 2.4.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/packaged_tarball/extconf.rb"]

  spec.add_dependency "mini_portile2"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
