# frozen_string_literal: true

require "bundler"
require "rake/clean"
require "rubygems/package_task"

GEMDIRS = Dir.glob("*/*.gemspec").map { |f| File.dirname(f) }

rcee_spec = Bundler.load_gemspec("rcee.gemspec")
Gem::PackageTask.new(rcee_spec).define

def update_version_string(filepath, version)
  updated_file = File.read(filepath).gsub(/(\s*)VERSION\s*=\s*.*/, %(\\1VERSION = "#{version}"))
  File.open(filepath, "w") { |f| f.write(updated_file) }
end

def in_each_gemdir(&block)
  GEMDIRS.each do |gemdir|
    Dir.chdir(gemdir) do
      puts "=== #{gemdir} ==="
      block.call(gemdir)
    end
  end
end

namespace "version" do
  desc "update the version constant of all the gems to match rcee.gemspec"
  task "set" do
    version = rcee_spec.version

    in_each_gemdir do |gemdir|
      version_path = Dir.glob("lib/**/version.rb").first
      update_version_string(version_path, version)
      puts "updated #{File.join(gemdir, version_path)} to #{version}"
    end
  end
end

desc "create all the gems"
task "package" do
  rm_rf("gems") && mkdir("gems")
  in_each_gemdir do
    sh("bundle")
    sh("bundle exec rake clean")
    sh("bundle exec rake package")
    cp(Dir.glob("pkg/*.gem"), "../gems")
  end
  cp(Dir.glob("pkg/*.gem"), "gems")
end

desc "test all the gems"
task "test" do
  in_each_gemdir do
    sh("bundle") and sh("bundle exec rake compile test")
  end
end

task "clean" do
  in_each_gemdir do
    sh("bundle") and sh("bundle exec rake clean")
  end
end

task "clobber" do
  in_each_gemdir do
    sh("bundle") and sh("bundle exec rake clean clobber")
  end
end

CLEAN.add("pkg")
