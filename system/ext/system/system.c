#include "system.h"

VALUE rb_mSystem;
VALUE rb_cSystemExtension;

static VALUE
rb_system_extension_class_do_something(VALUE self)
{
  int major, minor, patch;
  VALUE list[3];

  yaml_get_version(&major, &minor, &patch);

  list[0] = INT2NUM(major);
  list[1] = INT2NUM(minor);
  list[2] = INT2NUM(patch);

  return rb_ary_new4((long)3, list);
}


void
Init_system(void)
{
  rb_mSystem = rb_define_module("System");
  rb_cSystemExtension = rb_define_class_under(rb_mSystem, "Extension", rb_cObject);
  rb_define_singleton_method(rb_cSystemExtension, "do_something",
                             rb_system_extension_class_do_something, 0);
}
