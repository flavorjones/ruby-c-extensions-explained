require "mkmf"
require "mini_portile2"

package_root_dir = File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))

MiniPortile.new("yaml", "0.2.5").tap do |recipe|
  recipe.files = [{
    url: "https://github.com/yaml/libyaml/releases/download/0.2.5/yaml-0.2.5.tar.gz",
    sha256: "c642ae9b75fee120b2d96c712538bd2cf283228d2337df2cf2988e3c02678ef4",
  }]

  recipe.target = File.join(package_root_dir, "ports")
  unless File.exist?(File.join(recipe.target, recipe.host, recipe.name, recipe.version))
    recipe.cook
  end
  recipe.activate
  pkg_config(File.join(recipe.path, "lib", "pkgconfig", "yaml-0.1.pc"))
end

unless have_library("yaml", "yaml_get_version", "yaml.h")
  abort("\nERROR: *** could not find libyaml development environment ***\n\n")
end

create_makefile("rcee/packaged_tarball/packaged_tarball")
