rollback work;
begin work;
drop function f_bcocheck1_cxpdocm_delete() cascade;
drop function f_bcocheck1_cxpdocm_update() cascade;
drop function f_bcocheck3_cxpdocm_insert() cascade;
drop function f_bcocheck3_cxpdocm_delete() cascade;
drop function f_bcocheck3_cxpdocm_update() cascade;
commit work;