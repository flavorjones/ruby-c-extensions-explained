#include "isolated.h"

VALUE rb_mRCEE;
VALUE rb_mIsolated;
VALUE rb_cIsolatedExtension;

static VALUE
rb_isolated_extension_class_do_something(VALUE self)
{
  /* todo: perform CPU-intensive operation */
  return rb_str_new_cstr("something has been done");
}

void
Init_isolated(void)
{
  rb_mRCEE = rb_define_module("RCEE");
  rb_mIsolated = rb_define_module_under(rb_mRCEE, "Isolated");
  rb_cIsolatedExtension = rb_define_class_under(rb_mIsolated, "Extension", rb_cObject);
  rb_define_singleton_method(rb_cIsolatedExtension, "do_something",
                             rb_isolated_extension_class_do_something, 0);
}
