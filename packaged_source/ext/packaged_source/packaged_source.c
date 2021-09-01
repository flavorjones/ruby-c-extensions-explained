#include "packaged_source.h"

VALUE rb_mRCEE;
VALUE rb_mPackagedSource;
VALUE rb_cPackagedSourceExtension;

static VALUE
rb_packaged_source_extension_class_do_something(VALUE self)
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
Init_packaged_source(void)
{
  rb_mRCEE = rb_define_module("RCEE");
  rb_mPackagedSource = rb_define_module_under(rb_mRCEE, "PackagedSource");
  rb_cPackagedSourceExtension = rb_define_class_under(rb_mPackagedSource, "Extension", rb_cObject);
  rb_define_singleton_method(rb_cPackagedSourceExtension, "do_something",
                             rb_packaged_source_extension_class_do_something, 0);
}
