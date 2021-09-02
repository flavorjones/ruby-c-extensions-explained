# frozen_string_literal: true

require "test_helper"

class PrecompiledTest < Minitest::Spec
  describe "Precompiled" do
    it "defines a class" do
      assert(defined?(::RCEE::Precompiled::Extension))
    end

    it "defines a method" do
      result = ::RCEE::Precompiled::Extension.do_something
      puts "\ndo_something returned #{result.inspect}"
      assert(result)
    end
  end
end
