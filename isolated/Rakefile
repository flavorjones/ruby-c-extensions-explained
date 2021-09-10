# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubygems/package_task"
require "rake/testtask"
require "rake/extensiontask"

rcee_isolated_spec = Bundler.load_gemspec("rcee_isolated.gemspec")
Gem::PackageTask.new(rcee_isolated_spec).define

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

Rake::ExtensionTask.new("isolated") do |ext|
  ext.lib_dir = "lib/rcee/isolated"
end

task default: [:clobber, :compile, :test]

CLEAN.add("{ext,lib}/**/*.{o,so}", "pkg")
