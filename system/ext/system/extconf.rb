# frozen_string_literal: true

require "mkmf"

dir_config "libyaml"
unless find_header('yaml.h') && find_library('yaml', 'yaml_get_version')
  abort("could not find libyaml development environment")
end

create_makefile("system/system")
