require "mkmf"
require "mini_portile2"

package_root_dir = File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))

RbConfig::CONFIG["CC"] = RbConfig::MAKEFILE_CONFIG["CC"] = ENV["CC"] if ENV["CC"]
ENV["CC"] = RbConfig::CONFIG["CC"]

# not needed for libyaml, but generally useful to know whether we're cross-compiling
cross_build_p = enable_config("cross-build")

MiniPortile.new("yaml", "0.2.5").tap do |recipe|
  recipe.files = [{
    url: "https://github.com/yaml/libyaml/releases/download/0.2.5/yaml-0.2.5.tar.gz",
    sha256: "c642ae9b75fee120b2d96c712538bd2cf283228d2337df2cf2988e3c02678ef4",
  }]
  recipe.target = File.join(package_root_dir, "ports")

  # configure the environment that MiniPortile will use for subshells
  ENV.to_h.dup.tap do |env|
    # -fPIC is necessary for linking into a shared library
    env["CFLAGS"] = [env["CFLAGS"], "-fPIC"].join(" ")
    env["SUBDIRS"] = "include src" # libyaml: skip tests

    recipe.configure_options += env.map { |key, value| "#{key}=#{value.strip}" }
  end

  unless File.exist?(File.join(recipe.target, recipe.host, recipe.name, recipe.version))
    recipe.cook
  end

  recipe.activate
  pkg_config(File.join(recipe.path, "lib", "pkgconfig", "yaml-0.1.pc"))
end

unless have_library("yaml", "yaml_get_version", "yaml.h")
  abort("could not find yaml development environment")
end

create_makefile("rcee/precompiled/precompiled")
