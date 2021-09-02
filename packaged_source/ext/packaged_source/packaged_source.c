#include "packaged_source.h"

VALUE rb_mRCEE;
VALUE rb_mPackagedSource;
VALUE rb_cPackagedSourceExtension;

static VALUE
rb_packaged_source_extension_class_do_something(VALUE self)
{
  int major, minor, patch;

  yaml_get_version(&major, &minor, &patch);

  return rb_sprintf("libyaml version %d.%d.%d", major, minor, patch);
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
