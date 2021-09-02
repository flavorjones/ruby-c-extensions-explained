#include "precompiled.h"

VALUE rb_mRCEE;
VALUE rb_mPrecompiled;
VALUE rb_cPrecompiledExtension;

static VALUE
rb_precompiled_extension_class_do_something(VALUE self)
{
  int major, minor, patch;

  yaml_get_version(&major, &minor, &patch);

  return rb_sprintf("libyaml version %d.%d.%d", major, minor, patch);
}

void
Init_precompiled(void)
{
  rb_mRCEE = rb_define_module("RCEE");
  rb_mPrecompiled = rb_define_module_under(rb_mRCEE, "Precompiled");
  rb_cPrecompiledExtension = rb_define_class_under(rb_mPrecompiled, "Extension", rb_cObject);
  rb_define_singleton_method(rb_cPrecompiledExtension, "do_something",
                             rb_precompiled_extension_class_do_something, 0);
}
