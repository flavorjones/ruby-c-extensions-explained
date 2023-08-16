#include "system.h"

VALUE rb_mRCEE;
VALUE rb_mSystem;
VALUE rb_cSystemExtension;

static VALUE
rb_system_extension_class_do_something(VALUE self)
{
  int major, minor, patch;

  yaml_get_version(&major, &minor, &patch);

  return rb_sprintf("libyaml version %d.%d.%d", major, minor, patch);
}


RUBY_FUNC_EXPORTED void
Init_system(void)
{
  rb_mRCEE = rb_define_module("RCEE");
  rb_mSystem = rb_define_module_under(rb_mRCEE, "System");
  rb_cSystemExtension = rb_define_class_under(rb_mSystem, "Extension", rb_cObject);
  rb_define_singleton_method(rb_cSystemExtension, "do_something",
                             rb_system_extension_class_do_something, 0);
}
