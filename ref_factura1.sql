alter table factura2
   add constraint FK_FACTURA2_REF_10268_FACTURA1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table factura4
   add constraint FK_FACTURA4_REF_10274_FACTURA1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table factura5
   add constraint FK_FACTURA5_REF_10849_FACTURA1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table factura6
   add constraint FK_FACTURA6_REF_10850_FACTURA1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table rela_factura1_cglposteo
   add constraint FK_RELA_FAC_REF_11999_FACTURA1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete restrict on update restrict;

alter table factura7
   add constraint FK_FACTURA7_REF_13516_FACTURA1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

