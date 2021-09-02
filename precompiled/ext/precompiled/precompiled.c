#include "precompiled.h"

VALUE rb_mRCEE;
VALUE rb_mPrecompiled;
VALUE rb_cPrecompiledExtension;

static VALUE
rb_precompiled_extension_class_do_something(VALUE self)
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
Init_precompiled(void)
{
  rb_mRCEE = rb_define_module("RCEE");
  rb_mPrecompiled = rb_define_module_under(rb_mRCEE, "Precompiled");
  rb_cPrecompiledExtension = rb_define_class_under(rb_mPrecompiled, "Extension", rb_cObject);
  rb_define_singleton_method(rb_cPrecompiledExtension, "do_something",
                             rb_precompiled_extension_class_do_something, 0);
}
