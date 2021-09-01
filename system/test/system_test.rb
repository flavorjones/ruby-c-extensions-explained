# frozen_string_literal: true

require "test_helper"

class SystemTest < Minitest::Spec
  describe "System" do
    it "defines a class" do
      assert(defined?(::RCEE::System::Extension))
    end

    it "defines a method" do
      result = ::RCEE::System::Extension.do_something
      puts "\ndo_something returned #{result.inspect}"
      assert(result)
    end
  end
end
