
rollback work;
begin work;
/*
alter table factura8 add column caja char(3);
alter table adc_notas_debito_1 add column caja char(3);
alter table fact_informe_ventas add column caja char(3);
alter table factura2_eys2 add column caja char(3);

alter table factura7 add column caja char(3);
--alter table fact_list_despachos add column caja char(3);
alter table tal_ot1 add column caja char(3);

alter table adc_informe1 add column caja char(3);
alter table adc_house_factura1 add column caja char(3);
alter table adc_manejo_factura1 add column caja char(3);


alter table fac_pagos add column caja char(3);
alter table adc_facturas_recibos add column caja char(3);
alter table inv_despachos add column caja char(3);

alter table factura2 add column caja char(3);
alter table factura3 add column caja char(3);
alter table factura4 add column caja char(3);
alter table factura5 add column caja char(3);
alter table cxcdocm add column caja char(3);
alter table cxchdocm add column caja char(3);
alter table cxctrx1 add column caja char(3);
alter table cxc_recibo1 add column caja char(3);
alter table rela_cxctrx1_cglposteo add column caja char(3);
alter table rela_cxc_recibo1_cglposteo add column caja char(3);
alter table cxcmorosidad add column caja char(3);
alter table cxc_recibo3 add column caja char(3);
alter table cxc_recibo2 add column caja char(3);
alter table cxc_recibo2 add column caja_aplicar char(3);


alter table cxctrx2 add column caja char(3);
alter table cxctrx2 add column caja_aplicar char(3);
alter table rela_factura1_cglposteo add column caja char(3);
alter table bcomotivos add column caja char(3);
alter table cxctrx3 add column caja char(3);


alter table cxcdocm
drop constraint fk_cxcdocm_ref_37303_cxcdocm;




update cxctrx2
set caja = '01';
update cxctrx2
set caja_aplicar = '01';
update rela_factura1_cglposteo
set caja = '01';
update bcomotivos
set caja = '01';
update cxctrx3
set caja = '01';





update cxctrx1
set caja = '01';
update cxc_recibo1
set caja = '01';
update rela_cxctrx1_cglposteo
set caja = '01';
update rela_cxc_recibo1_cglposteo
set caja = '01';
update cxcmorosidad
set caja = '01';
update cxc_recibo2
set caja = '01';
update cxc_recibo2
set caja_aplicar = '01';



update factura2
set caja = '01';


update factura3
set caja = '01';
update factura4
set caja = '01';
update factura5
set caja = '01';
update cxcdocm
set caja = '01';
*/



update cxchdocm
set caja = '01';


--rollback work;
commit work;
