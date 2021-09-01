#include "packaged_tarball.h"

VALUE rb_mPackagedTarball;
VALUE rb_cPackagedTarballExtension;

static VALUE
rb_packaged_tarball_extension_class_do_something(VALUE self)
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
Init_packaged_tarball(void)
{
  rb_mPackagedTarball = rb_define_module("PackagedTarball");
  rb_cPackagedTarballExtension = rb_define_class_under(rb_mPackagedTarball, "Extension", rb_cObject);
  rb_define_singleton_method(rb_cPackagedTarballExtension, "do_something",
                             rb_packaged_tarball_extension_class_do_something, 0);
}
