# frozen_string_literal: true

require "test_helper"

class IsolatedTest < Minitest::Spec
  describe "Isolated" do
    it "defines a class" do
      assert(defined?(::RCEE::Isolated::Extension))
    end

    it "defines a method" do
      result = ::RCEE::Isolated::Extension.do_something
      puts "\ndo_something returned #{result.inspect}"
      assert(result)
    end
  end
end
