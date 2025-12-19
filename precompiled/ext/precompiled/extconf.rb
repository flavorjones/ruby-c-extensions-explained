require "mkmf"
require "mini_portile2"

module RCEE
  module Precompiled
    module ExtConf
      PACKAGE_ROOT_DIR = File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))

      class << self
        def configure
          configure_cross_compilers
          configure_packaged_libraries
          create_makefile("rcee/precompiled/precompiled")
        end

        def configure_cross_compilers
          RbConfig::CONFIG["CC"] = RbConfig::MAKEFILE_CONFIG["CC"] = ENV["CC"] if ENV["CC"]
          ENV["CC"] = RbConfig::CONFIG["CC"]
        end

        def configure_packaged_libraries
          recipe = libyaml_recipe

          # pass some environment variables to the libyaml configuration for cross-compilation
          if cross_build?
            ENV.to_h.tap do |env|
              # -fPIC is necessary for linking into a shared library
              env["CFLAGS"] = [env["CFLAGS"], "-fPIC"].join(" ")
              env["SUBDIRS"] = "include src" # libyaml: skip tests

              recipe.configure_options += env.map { |key, value| "#{key}=#{value.strip}" }
            end
          end

          # ensure libyaml has already been unpacked, configured, and compiled
          unless File.exist?(File.join(recipe.target, recipe.host, recipe.name, recipe.version))
            recipe.cook
          end

          # use the packaged libyaml
          recipe.activate
          pkg_config(File.join(recipe.path, "lib", "pkgconfig", "yaml-0.1.pc"))

          # assert that we can build against the packaged libyaml
          unless have_library("yaml", "yaml_get_version", "yaml.h")
            abort("\nERROR: *** could not find libyaml development environment ***\n\n")
          end
        end

        def cross_build?
          enable_config("cross-build")
        end

        def download
          libyaml_recipe.download
        end

        def libyaml_recipe
          MiniPortile.new("yaml", "0.2.5").tap do |recipe|
            recipe.files = [{
              url: "https://github.com/yaml/libyaml/releases/download/0.2.5/yaml-0.2.5.tar.gz",
              sha256: "c642ae9b75fee120b2d96c712538bd2cf283228d2337df2cf2988e3c02678ef4"
            }]
            recipe.target = File.join(PACKAGE_ROOT_DIR, "ports")
            recipe.patch_files = Dir[File.join(PACKAGE_ROOT_DIR, "patches", "libyaml", "*.patch")].sort
          end
        end
      end
    end
  end
end

# run "ruby ./ext/precompiled/extconf.rb -- --download-dependencies" to download the tarball
if arg_config("--download-dependencies")
  RCEE::Precompiled::ExtConf.download
  exit!(0)
end

RCEE::Precompiled::ExtConf.configure
