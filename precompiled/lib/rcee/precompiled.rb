# frozen_string_literal: true

require_relative "precompiled/version"

begin
  # load the precompiled extension file
  ruby_version = /(\d+\.\d+)/.match(::RUBY_VERSION)
  require_relative "precompiled/#{ruby_version}/precompiled"
rescue LoadError
  # fall back to the extension compiled upon installation.
  # use "require" instead of "require_relative" because non-native gems will place C extension files
  # in Gem::BasicSpecification#extension_dir after compilation (during normal installation), which
  # is in $LOAD_PATH but not necessarily relative to this file
  # (see https://github.com/sparklemotion/nokogiri/issues/2300 for more)
  require "rcee/precompiled/precompiled"
end

module RCEE
  module Precompiled
    class Error < StandardError; end
    # Your code goes here...
  end
end
