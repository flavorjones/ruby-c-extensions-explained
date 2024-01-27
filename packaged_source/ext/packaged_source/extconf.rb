require "mkmf"

# $VPATH is used as the Makefile's $(VPATH) variable
# see https://www.gnu.org/software/make/manual/html_node/General-Search.html
$VPATH << "$(srcdir)/yaml"

# $srcs is normally set to the list of C files in the extension directory,
# but we need to append the libyaml files to it.
$srcs = Dir.glob("#{$srcdir}/{,yaml/}*.c").map { |n| File.basename(n) }.sort

# and make sure that the C preprocessor includes the yaml directory in its search path
append_cppflags("-I$(srcdir)/yaml")

# assert that we can find the yaml.h header file
abort("could not find yaml.h") unless find_header("yaml.h")

# defines HAVE_CONFIG_H macro
have_header("config.h")

create_makefile("rcee/packaged_source/packaged_source")
