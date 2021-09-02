#include "packaged_tarball.h"

VALUE rb_mRCEE;
VALUE rb_mPackagedTarball;
VALUE rb_cPackagedTarballExtension;

static VALUE
rb_packaged_tarball_extension_class_do_something(VALUE self)
{
  int major, minor, patch;

  yaml_get_version(&major, &minor, &patch);

  return rb_sprintf("libyaml version %d.%d.%d", major, minor, patch);
}

void
Init_packaged_tarball(void)
{
  rb_mRCEE = rb_define_module("RCEE");
  rb_mPackagedTarball = rb_define_module_under(rb_mRCEE, "PackagedTarball");
  rb_cPackagedTarballExtension = rb_define_class_under(rb_mPackagedTarball, "Extension", rb_cObject);
  rb_define_singleton_method(rb_cPackagedTarballExtension, "do_something",
                             rb_packaged_tarball_extension_class_do_something, 0);
}
