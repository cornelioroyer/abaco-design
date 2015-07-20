drop function f_bcotransac1_bcocircula_insert() cascade;
drop function f_bcotransac1_bcocircula_delete() cascade;
drop function f_bcotransac1_bcocircula_update() cascade;

drop function f_bcocheck1_bcocircula_insert() cascade;
drop function f_bcocheck1_bcocircula_delete() cascade;
drop function f_bcocheck1_bcocircula_update() cascade;

drop function f_bcocheck1_bcocircula(char(2), char(2), int4) cascade;
drop function f_bcotransac1_bcocircula(char(2), int4) cascade;

drop function f_bcotransac1_cglposteo(char(3), int4);
drop function f_rela_bcotransac1_cglposteo_delete() cascade;

drop function f_bcocheck1_cglposteo(char(3), char(2), int4);
drop function f_rela_bcocheck1_cglposteo_delete() cascade;

drop function f_bcotransac2_after_update() cascade;
drop function f_bcotransac2_after_delete() cascade;
drop function f_bcocheck2_after_delete() cascade;
drop function f_bcocheck2_after_update() cascade;
drop function f_postea_bco(char(2)) cascade;
drop function f_bcocheck1_before_delete() cascade;
drop function f_bcocheck1_before_update() cascade;
drop function f_bcotransac3_after_delete() cascade;
drop function f_bcotransac3_after_update() cascade;

drop function f_cxpfact1_after_delete() cascade;
drop function f_cxpfact1_after_update() cascade;
drop function f_cxpfact2_after_delete() cascade;
drop function f_cxpfact2_after_update() cascade;

drop function f_rela_cxpfact1_cglposteo_delete() cascade;
drop function f_rela_cxpfact1_cglposteo_update() cascade;

drop function f_monto_factura_cxp(char(2), char(6), char(25));
drop function f_saldo_docmto_cxp(char(2), char(6), char(10),  char(3), date);
drop function f_cxpfact1_cxpdocm(char(2), char(6), char(25));
drop function f_cxpfact1_cglposteo(char(2), char(6), char(25));
drop function f_cxpdocm_after_delete() cascade;
drop function f_cxpdocm_after_update() cascade;
drop function f_update_cxpdocm(char(2)) cascade;
drop function f_postea_cxp(char(2)) cascade;

alter table bcotransac1
rename column no_docmto to documento;

alter table bcotransac1
add column no_docmto char(25);

update bcotransac1
set no_docmto = documento;

alter table bcotransac1
alter column no_docmto set not null;

alter table bcotransac1
drop column documento cascade;

