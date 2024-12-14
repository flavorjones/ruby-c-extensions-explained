# frozen_string_literal: true

Gem::Specification.new do |spec|
  rcee_version = "0.6.0"

  spec.name          = "rcee"
  spec.version       = rcee_version
  spec.authors       = ["Mike Dalessio"]
  spec.email         = ["mike.dalessio@gmail.com"]

  spec.summary       = "Meta-gem to install all example gems in the RCEE suite."
  spec.description   = "Part of a project to explain how Ruby C extensions work."
  spec.homepage      = "https://github.com/flavorjones/ruby-c-extensions-explained"
  spec.required_ruby_version = ">= 2.6.0"
  spec.license = "MIT"

  spec.add_dependency "rcee_isolated", "= #{rcee_version}"
  spec.add_dependency "rcee_packaged_source", "= #{rcee_version}"
  spec.add_dependency "rcee_packaged_tarball", "= #{rcee_version}"
  spec.add_dependency "rcee_precompiled", "= #{rcee_version}"
  spec.add_dependency "rcee_system", "= #{rcee_version}"
end
