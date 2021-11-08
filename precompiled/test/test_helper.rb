# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "rcee/precompiled"
puts "testing RCEE::Precompiled #{RCEE::Precompiled::VERSION}"

require "minitest/autorun"
