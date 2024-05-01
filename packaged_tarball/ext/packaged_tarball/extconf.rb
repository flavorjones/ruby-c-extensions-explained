require "mkmf"
require "mini_portile2"

module RCEE
  module PackagedTarball
    module ExtConf
      PACKAGE_ROOT_DIR = File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))

      class << self
        def configure
          configure_packaged_libraries

          create_makefile("rcee/packaged_tarball/packaged_tarball")
        end

        def configure_packaged_libraries
          recipe = libyaml_recipe

          # ensure libyaml has already been unpacked, configured, and compiled
          unless File.exist?(File.join(recipe.target, recipe.host, recipe.name, recipe.version))
            recipe.cook
          end

          # use the packaged libyaml
          recipe.activate
          pkg_config(File.join(recipe.path, "lib", "pkgconfig", "yaml-0.1.pc"))

          # assert that we can build against the packaged libyaml
          unless find_header("yaml.h") && have_library("yaml", "yaml_get_version", "yaml.h")
            abort("\nERROR: *** could not find libyaml development environment ***\n\n")
          end
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
            recipe.patch_files = Dir[File.join(PACKAGE_ROOT_DIR, "patches", "libyaml", "*.patch")].sort
            recipe.target = File.join(PACKAGE_ROOT_DIR, "ports")
          end
        end
      end
    end
  end
end

# run "ruby ./ext/packaged_tarball/extconf.rb -- --download-dependencies" to download the tarball
if arg_config("--download-dependencies")
  RCEE::PackagedTarball::ExtConf.download
  exit!(0)
end

RCEE::PackagedTarball::ExtConf.configure
