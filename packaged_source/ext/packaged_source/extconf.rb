require "mkmf"

$VPATH << "$(srcdir)/yaml"
$srcs = Dir.glob("#{$srcdir}/{,yaml/}*.c").map { |n| File.basename(n) }.sort

append_cppflags("-I$(srcdir)/yaml")
find_header("yaml.h")
have_header("config.h") # defines HAVE_CONFIG_H macro

create_makefile("rcee/packaged_source/packaged_source")
