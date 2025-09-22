require "mkmf"

dir_config('libyaml')
unless find_header("yaml.h") && find_library("yaml", "yaml_get_version")
  abort("\nERROR: *** could not find libyaml development environment ***\n\n")
end

create_makefile("rcee/system/system")
