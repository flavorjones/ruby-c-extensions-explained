# frozen_string_literal: true

require "test_helper"

class PackagedTarballTest < Minitest::Spec
  describe "PackagedTarball" do
    it "defines a class" do
      assert(defined?(::PackagedTarball::Extension))
    end

    it "defines a method" do
      result = ::PackagedTarball::Extension.do_something
      puts "\ndo_something returned #{result.inspect}"
      assert(result)
    end
  end
end
