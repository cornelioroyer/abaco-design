alter table eys4
   add constraint FK_EYS4_REF_17157_EYS2 foreign key (articulo, almacen, no_transaccion, inv_linea)
      references eys2 (articulo, almacen, no_transaccion, linea)
      on delete cascade on update cascade;

alter table factura2_eys2
   add constraint FK_FACTURA2_REF_17353_EYS2 foreign key (articulo, almacen, no_transaccion, eys2_linea)
      references eys2 (articulo, almacen, no_transaccion, linea)
      on delete cascade on update cascade;

alter table cos_consumo_eys2
   add constraint FK_COS_CONS_REFERENCE_EYS2 foreign key (articulo, almacen, no_transaccion, eys2_linea)
      references eys2 (articulo, almacen, no_transaccion, linea)
      on delete cascade on update cascade;
alter table cos_produccion_eys2
   add constraint FK_COS_PROD_REFERENCE_EYS2 foreign key (articulo, almacen, no_transaccion, eys2_linea)
      references eys2 (articulo, almacen, no_transaccion, linea)
      on delete cascade on update cascade;

alter table eys6
   add constraint FK_EYS6_REFERENCE_EYS2 foreign key (articulo, almacen, no_transaccion, linea)
      references eys2 (articulo, almacen, no_transaccion, linea)
      on delete cascade on update cascade;

alter table eys6
   add constraint FK_EYS6_REFERENCE_EYS2 foreign key (articulo, almacen, compra_no_transaccion, compra_linea)
      references eys2 (articulo, almacen, no_transaccion, linea)
      on delete cascade on update cascade;

alter table eys6
   add constraint FK_EYS6_REFERENCE_EYS2 foreign key (articulo, almacen, compra_no_transaccion, compra_linea)
      references eys2 (articulo, almacen, no_transaccion, linea)
      on delete restrict on update restrict;
