drop index i_fk_adc_fact_reference_factura1 cascade;

create index i_fk_adc_fact_reference_factura1 on adc_facturas_recibos (fac_almacen, tipo, caja, num_documento);


alter table adc_facturas_recibos
   drop constraint fk_adc_fact_reference_factura1  cascade;

alter table adc_facturas_recibos
   add constraint fk_adc_fact_reference_factura1 foreign key (fac_almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete restrict on update cascade;

drop index i_fk_adc_hous_reference_factura1 cascade;

create index i_fk_adc_hous_reference_factura1 on adc_house_factura1 (almacen, tipo, caja, num_documento);


alter table adc_house_factura1
   drop constraint fk_adc_hous_reference_factura1  cascade;

alter table adc_house_factura1
   add constraint fk_adc_hous_reference_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;

drop index i_fk_adc_info_reference_factura1 cascade;

create index i_fk_adc_info_reference_factura1 on adc_informe1 (almacen, tipo, caja, num_documento);


alter table adc_informe1
   drop constraint fk_adc_info_reference_factura1  cascade;

alter table adc_informe1
   add constraint fk_adc_info_reference_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;

drop index i_fk_adc_mane_reference_factura1 cascade;

create index i_fk_adc_mane_reference_factura1 on adc_manejo_factura1 (almacen, tipo, caja, num_documento);


alter table adc_manejo_factura1
   drop constraint fk_adc_mane_reference_factura1  cascade;

alter table adc_manejo_factura1
   add constraint fk_adc_mane_reference_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;

drop index i_fk_adc_nota_reference_factura1 cascade;

create index i_fk_adc_nota_reference_factura1 on adc_notas_debito_1 (almacen, tipo, caja, num_documento);


alter table adc_notas_debito_1
   drop constraint fk_adc_nota_reference_factura1  cascade;

alter table adc_notas_debito_1
   add constraint fk_adc_nota_reference_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete restrict on update cascade;

drop index i_fk_fac_pago_reference_factura1 cascade;

create index i_fk_fac_pago_reference_factura1 on fac_pagos (almacen, tipo, caja, num_documento);


alter table fac_pagos
   drop constraint fk_fac_pago_reference_factura1  cascade;

alter table fac_pagos
   add constraint fk_fac_pago_reference_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;

drop index i_fk_fact_inf_reference_factura1 cascade;

create index i_fk_fact_inf_reference_factura1 on fact_informe_ventas (almacen, tipo, caja, num_documento);


alter table fact_informe_ventas
   drop constraint fk_fact_inf_reference_factura1  cascade;

alter table fact_informe_ventas
   add constraint fk_fact_inf_reference_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;

drop index i_fk_fact_lis_reference_factura1 cascade;

create index i_fk_fact_lis_reference_factura1 on fact_list_despachos (almacen, tipo, caja, num_documento);


alter table fact_list_despachos
   drop constraint fk_fact_lis_reference_factura1  cascade;

alter table fact_list_despachos
   add constraint fk_fact_lis_reference_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;

drop index i_fk_factura1_ref_10094_vendedor cascade;

create index i_fk_factura1_ref_10094_vendedor on factura1 (codigo_vendedor);


alter table factura1
   drop constraint fk_factura1_ref_10094_vendedor  cascade;

alter table factura1
   add constraint fk_factura1_ref_10094_vendedor foreign key (codigo_vendedor)
      references vendedores (codigo)
      on delete restrict on update restrict;

drop index i_fk_factura1_ref_99208_almacen cascade;

create index i_fk_factura1_ref_99208_almacen on factura1 (almacen);


alter table factura1
   drop constraint fk_factura1_ref_99208_almacen  cascade;

alter table factura1
   add constraint fk_factura1_ref_99208_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;

drop index i_fk_factura1_ref_99219_factmoti cascade;

create index i_fk_factura1_ref_99219_factmoti on factura1 (tipo);


alter table factura1
   drop constraint fk_factura1_ref_99219_factmoti  cascade;

alter table factura1
   add constraint fk_factura1_ref_99219_factmoti foreign key (tipo)
      references factmotivos (tipo)
      on delete restrict on update cascade;

drop index i_fk_factura1_ref_99224_clientes cascade;

create index i_fk_factura1_ref_99224_clientes on factura1 (cliente);


alter table factura1
   drop constraint fk_factura1_ref_99224_clientes  cascade;

alter table factura1
   add constraint fk_factura1_ref_99224_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

drop index i_fk_factura1_ref_99230_gral_for cascade;

create index i_fk_factura1_ref_99230_gral_for on factura1 (forma_pago);


alter table factura1
   drop constraint fk_factura1_ref_99230_gral_for  cascade;

alter table factura1
   add constraint fk_factura1_ref_99230_gral_for foreign key (forma_pago)
      references gral_forma_de_pago (forma_pago)
      on delete restrict on update cascade;

drop index i_fk_factura1_reference_gralapli cascade;

create index i_fk_factura1_reference_gralapli on factura1 (aplicacion);


alter table factura1
   drop constraint fk_factura1_reference_gralapli  cascade;

alter table factura1
   add constraint fk_factura1_reference_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

drop index i_fk_factura1_ciu_origen cascade;

create index i_fk_factura1_ciu_origen on factura1 (ciudad_origen);


alter table factura1
   drop constraint fk_factura1_ciu_origen  cascade;

alter table factura1
   add constraint fk_factura1_ciu_origen foreign key (ciudad_origen)
      references fac_ciudades (ciudad)
      on delete restrict on update restrict;

drop index i_fk_factura1_ciu_destino cascade;

create index i_fk_factura1_ciu_destino on factura1 (ciudad_destino);


alter table factura1
   drop constraint fk_factura1_ciu_destino  cascade;

alter table factura1
   add constraint fk_factura1_ciu_destino foreign key (ciudad_destino)
      references fac_ciudades (ciudad)
      on delete restrict on update restrict;

drop index i_fk_factura1_agente_ref_clientes cascade;

create index i_fk_factura1_agente_ref_clientes on factura1 (agente);


alter table factura1
   drop constraint fk_factura1_agente_ref_clientes  cascade;

alter table factura1
   add constraint fk_factura1_agente_ref_clientes foreign key (agente)
      references clientes (cliente)
      on delete restrict on update cascade;

drop index i_fk_factura1_reference_destinos cascade;

create index i_fk_factura1_reference_destinos on factura1 (cod_destino);


alter table factura1
   drop constraint fk_factura1_reference_destinos  cascade;

alter table factura1
   add constraint fk_factura1_reference_destinos foreign key (cod_destino)
      references destinos (cod_destino)
      on delete restrict on update restrict;

drop index i_fk_factura1_reference_navieras cascade;

create index i_fk_factura1_reference_navieras on factura1 (cod_naviera);


alter table factura1
   drop constraint fk_factura1_reference_navieras  cascade;

alter table factura1
   add constraint fk_factura1_reference_navieras foreign key (cod_naviera)
      references navieras (cod_naviera)
      on delete restrict on update restrict;

drop index i_fk_factura1_reference_fac_caja cascade;

create index i_fk_factura1_reference_fac_caja on factura1 (caja, almacen);


alter table factura1
   drop constraint fk_factura1_reference_fac_caja  cascade;

alter table factura1
   add constraint fk_factura1_reference_fac_caja foreign key (caja, almacen)
      references fac_cajas (caja, almacen)
      on delete restrict on update cascade;

drop index i_fk_factura1_reference_fac_caje cascade;

create index i_fk_factura1_reference_fac_caje on factura1 (cajero);


alter table factura1
   drop constraint fk_factura1_reference_fac_caje  cascade;

alter table factura1
   add constraint fk_factura1_reference_fac_caje foreign key (cajero)
      references fac_cajeros (cajero)
      on delete restrict on update cascade;

drop index i_fk_factura1_reference_choferes cascade;

create index i_fk_factura1_reference_choferes on factura1 (chofer);


alter table factura1
   drop constraint fk_factura1_reference_choferes  cascade;

alter table factura1
   add constraint fk_factura1_reference_choferes foreign key (chofer)
      references choferes (chofer)
      on delete restrict on update cascade;

drop index i_fk_factura1_reference_fact_ref cascade;

create index i_fk_factura1_reference_fact_ref on factura1 (referencia);


alter table factura1
   drop constraint fk_factura1_reference_fact_ref  cascade;

alter table factura1
   add constraint fk_factura1_reference_fact_ref foreign key (referencia)
      references fact_referencias (referencia)
      on delete restrict on update restrict;

drop index i_fk_factura2_ref_10268_factura1 cascade;

create index i_fk_factura2_ref_10268_factura1 on factura2 (almacen, tipo, caja, num_documento);


alter table factura2
   drop constraint fk_factura2_ref_10268_factura1  cascade;

alter table factura2
   add constraint fk_factura2_ref_10268_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;

drop index i_fk_factura4_ref_10274_factura1 cascade;

create index i_fk_factura4_ref_10274_factura1 on factura4 (almacen, tipo, caja, num_documento);


alter table factura4
   drop constraint fk_factura4_ref_10274_factura1  cascade;

alter table factura4
   add constraint fk_factura4_ref_10274_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;

drop index i_fk_factura5_ref_10849_factura1 cascade;

create index i_fk_factura5_ref_10849_factura1 on factura5 (almacen, tipo, caja, num_documento);


alter table factura5
   drop constraint fk_factura5_ref_10849_factura1  cascade;

alter table factura5
   add constraint fk_factura5_ref_10849_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;

drop index i_fk_factura6_ref_10850_factura1 cascade;

create index i_fk_factura6_ref_10850_factura1 on factura6 (almacen, tipo, caja, num_documento);


alter table factura6
   drop constraint fk_factura6_ref_10850_factura1  cascade;

alter table factura6
   add constraint fk_factura6_ref_10850_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;

drop index i_fk_factura7_ref_13516_factura1 cascade;

create index i_fk_factura7_ref_13516_factura1 on factura7 (almacen, tipo, caja, num_documento);


alter table factura7
   drop constraint fk_factura7_ref_13516_factura1  cascade;

alter table factura7
   add constraint fk_factura7_ref_13516_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;

drop index i_fk_factura8_reference_factura1 cascade;

create index i_fk_factura8_reference_factura1 on factura8 (almacen, tipo, caja, num_documento);


alter table factura8
   drop constraint fk_factura8_reference_factura1  cascade;

alter table factura8
   add constraint fk_factura8_reference_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete restrict on update cascade;

drop index i_fk_inv_desp_reference_factura1 cascade;

create index i_fk_inv_desp_reference_factura1 on inv_despachos (almacen, tipo, caja, num_documento);


alter table inv_despachos
   drop constraint fk_inv_desp_reference_factura1  cascade;

alter table inv_despachos
   add constraint fk_inv_desp_reference_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;

drop index i_fk_rela_fac_ref_11999_factura1 cascade;

create index i_fk_rela_fac_ref_11999_factura1 on rela_factura1_cglposteo (almacen, tipo, caja, num_documento);


alter table rela_factura1_cglposteo
   drop constraint fk_rela_fac_ref_11999_factura1  cascade;

alter table rela_factura1_cglposteo
   add constraint fk_rela_fac_ref_11999_factura1 foreign key (almacen, tipo, caja, num_documento)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete cascade on update cascade;

drop index i_fk_tal_ot1_reference_factura1 cascade;

create index i_fk_tal_ot1_reference_factura1 on tal_ot1 (almacen, tipo_factura, caja, numero_factura);


alter table tal_ot1
   drop constraint fk_tal_ot1_reference_factura1  cascade;

alter table tal_ot1
   add constraint fk_tal_ot1_reference_factura1 foreign key (almacen, tipo_factura, caja, numero_factura)
      references factura1 (almacen, tipo, caja, num_documento)
      on delete restrict on update cascade;
