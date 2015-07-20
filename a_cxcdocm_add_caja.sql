
rollback work;

begin work;
drop function f_rela_cxc_recibo1_cglposteo_after_delete() cascade;
drop function f_cxc_recibo1_after_delete() cascade;
drop function f_cxc_recibo1_before_update() cascade;
drop function f_cxc_recibo2_before_insert() cascade;
drop function f_cxc_recibo2_before_delete() cascade;
drop function f_cxc_recibo2_before_update() cascade;
drop function f_cxc_recibo2_after_delete() cascade;
drop function f_cxc_recibo2_after_update() cascade;

drop function f_cxc_recibo3_before_delete() cascade;
drop function f_cxc_recibo3_before_update() cascade;
drop function f_cxc_recibo3_after_delete() cascade;
drop function f_cxc_recibo3_after_update() cascade;

drop function f_cxctrx1_before_insert() cascade;
drop function f_cxctrx1_before_update() cascade;
drop function f_cxctrx1_before_delete() cascade;
drop function f_cxctrx1_after_delete() cascade;
drop function f_cxctrx1_after_update() cascade;

drop function f_rela_cxctrx1_cglposteo_after_delete() cascade;

drop function f_cxctrx2_before_insert() cascade;
drop function f_cxctrx2_before_update() cascade;
drop function f_cxctrx2_before_delete() cascade;
drop function f_cxctrx2_after_update() cascade;
drop function f_cxctrx2_after_delete() cascade;

drop function f_cxctrx3_before_delete() cascade;
drop function f_cxctrx3_before_update() cascade;
drop function f_cxctrx3_after_delete() cascade;
drop function f_cxctrx3_after_update() cascade;


drop function f_clientes_before_update() cascade;
drop function f_clientes_before_insert() cascade;
drop function f_clientes_after_insert() cascade;
drop function f_clientes_after_update() cascade;
drop function f_cxc_recibo1_before_insert() cascade;

drop function f_cxcdocm_after_insert() cascade;
drop function f_cxcdocm_after_delete() cascade;
drop function f_cxcdocm_after_update() cascade;
drop function f_cxcdocm_before_insert() cascade;
drop function f_cxcdocm_before_update() cascade;
drop function f_cxcdocm_before_delete() cascade;
commit work;

begin work;

alter table cxcdocm add column caja char(3);
alter table cxchdocm add column caja char(3);

update cxcdocm
set caja = almacen;

update cxchdocm
set caja = almacen;

commit work;
