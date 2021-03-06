# frozen_string_literal: true

require "test_helper"

class PackagedSourceTest < Minitest::Spec
  describe "PackagedSource" do
    it "defines a class" do
      assert(defined?(::RCEE::PackagedSource::Extension))
    end

    it "defines a method" do
      result = ::RCEE::PackagedSource::Extension.do_something
      puts "\ndo_something returned #{result.inspect}"
      assert(result)
    end
  end
end
