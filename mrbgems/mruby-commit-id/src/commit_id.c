#include <mruby.h>

void mrb_mruby_commit_id_gem_init(mrb_state *mrb)
{
    mrb_define_global_const(mrb, "MRUBY_COMMIT_ID", mrb_str_new_lit(mrb, "%COMMIT_ID%"));
}

void mrb_mruby_commit_id_gem_final(mrb_state *mrb)
{
}
