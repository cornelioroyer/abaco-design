alter table articulos_agrupados
   add constraint FK_ARTICULO_REF_12550_ARTICULO foreign key (articulo)
      references articulos (articulo)
      on delete restrict on update cascade;


alter table articulos_por_almacen
   add constraint FK_ARTICULO_REF_13275_ARTICULO foreign key (articulo)
      references articulos (articulo)
      on delete restrict on update cascade;

alter table productos_sustitutos
   add constraint FK_PRODUCTO_REF_16981_ARTICULO foreign key (articulo)
      references articulos (articulo)
      on delete restrict on update cascade;

alter table productos_sustitutos
   add constraint FK_PRODUCTO_REF_16985_ARTICULO foreign key (art_articulo)
      references articulos (articulo)
      on delete restrict on update cascade;

alter table oc2
   add constraint FK_OC2_REF_17848_ARTICULO foreign key (articulo)
      references articulos (articulo)
      on delete restrict on update cascade;

alter table cos_consumo
   add constraint FK_COS_CONS_REFERENCE_ARTICULO foreign key (para_producir)
      references articulos (articulo)
      on delete restrict on update cascade;

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















