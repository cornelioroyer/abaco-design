

rollback work;


begin work;
drop index i1_factura1;

alter table factura1
   drop constraint pk_factura1 cascade; 
   
update factura1
set caja = almacen
where caja is null;   

alter table factura1
   add constraint pk_factura1 primary key (almacen, tipo, caja, num_documento);

create unique index i1_factura1 on factura1 (
almacen,
tipo,
caja,
num_documento
);


/*
alter table adc_facturas_recibos
add column caja char(3);
*/

alter table adc_facturas_recibos
   add constraint fk_adc_fact_reference_factura1 foreign key (fac_almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete restrict on update cascade;

/*
alter table adc_house_factura1
add column caja char(3);
*/

alter table adc_house_factura1
   add constraint fk_adc_hous_reference_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;


alter table adc_informe1 add column caja char(3);
alter table adc_informe1
   add constraint fk_adc_info_reference_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;


-- alter table adc_manejo_factura1 add column caja char(3);
alter table adc_manejo_factura1
   add constraint fk_adc_mane_reference_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;

alter table adc_notas_debito_1 add column caja char(3);
alter table adc_notas_debito_1
   add constraint fk_adc_nota_reference_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete restrict on update cascade;

alter table fac_pagos add column caja char(3);
alter table fac_pagos
   add constraint fk_fac_pago_reference_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;


alter table fact_informe_ventas add column caja char(3);
alter table fact_informe_ventas
   add constraint fk_fact_inf_reference_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;


alter table fact_list_despachos add column caja char(3);
alter table fact_list_despachos
   add constraint fk_fact_lis_reference_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;



alter table factura2 add column caja char(3);
alter table factura2
   add constraint fk_factura2_ref_10268_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;

alter table factura4 add column caja char(3);
alter table factura4
   add constraint fk_factura4_ref_10274_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;

alter table factura5 add column caja char(3);
alter table factura5
   add constraint fk_factura5_ref_10849_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;

alter table factura6 add column caja char(3);
alter table factura6
   add constraint fk_factura6_ref_10850_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;

alter table factura7 add column caja char(3);
alter table factura7
   add constraint fk_factura7_ref_13516_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;
      
/*
alter table factura8 add column caja char(3);
*/
alter table factura8
   add constraint fk_factura8_reference_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete restrict on update cascade;

alter table inv_despachos add column caja char(3);
alter table inv_despachos
   add constraint fk_inv_desp_reference_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;


alter table rela_factura1_cglposteo add column caja char(3);
alter table rela_factura1_cglposteo
   add constraint fk_rela_fac_ref_11999_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;

alter table tal_ot1 add column caja char(3);
alter table tal_ot1
   add constraint fk_tal_ot1_reference_factura1 foreign key (almacen, tipo_factura, caja, numero_factura)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete restrict on update cascade;

commit work;
