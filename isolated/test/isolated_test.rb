# frozen_string_literal: true

require "test_helper"

class IsolatedTest < MiniTest::Spec
  describe "Isolated" do
    it "defines a class" do
      assert(defined?(::Isolated::Extension))
    end

    it "defines a method" do
      result = ::Isolated::Extension.do_something
      puts "\ndo_something returned #{result.inspect}"
      assert(result)
    end
  end
end
