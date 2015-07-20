begin work;
alter table factura2
   add constraint fk_factura2_ref_10268_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;
commit work;


begin work;
alter table factura4
   add constraint fk_factura4_ref_10274_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table factura5
   add constraint fk_factura5_ref_10849_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;
commit work;

begin work;
alter table factura6
   add constraint fk_factura6_ref_10850_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table rela_factura1_cglposteo
   add constraint fk_rela_fac_ref_11999_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete restrict on update cascade;

alter table factura7
   add constraint fk_factura7_ref_13516_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table fact_list_despachos
   add constraint fk_fact_lis_reference_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete restrict on update restrict;
commit work;