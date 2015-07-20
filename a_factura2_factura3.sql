alter table factura3
   drop constraint fk_factura3_ref_10271_factura2;

alter table factura3
   drop constraint fk_factura3_reference_gral_imp;


drop index i1_factura2 cascade;

drop index i2_factura2 cascade;

drop index i3_factura2 cascade;

drop index i4_factura2 cascade;

alter table factura2
   drop constraint pk_factura2;
   
alter table factura2
   add constraint pk_factura2 primary key (almacen, tipo, num_documento, linea);
   
   
alter table factura2
   drop constraint fk_factura2_ref_10268_factura1;

alter table factura2
   drop constraint fk_factura2_reference_unidad_m;

alter table factura2
   drop constraint fk_factura2_articulos_por_almacen;
   
   
create unique index i1_factura2 on factura2 (
almacen,
tipo,
num_documento,
linea
);

create  index i2_factura2 on factura2 (
almacen,
tipo,
num_documento
);

create  index i3_factura2 on factura2 (
articulo
);

create  index i4_factura2 on factura2 (
almacen,
articulo
);


alter table factura2
   add constraint fk_factura2_ref_10268_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table factura2
   add constraint fk_factura2_reference_unidad_m foreign key (unidad_medida)
      references unidad_medida (unidad_medida)
      on delete restrict on update restrict;

alter table factura2
   add constraint fk_factura2_articulos_por_almacen foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete restrict on update cascade;
      

drop index i1_factura3 cascade;

drop index i2_factura3 cascade;

alter table factura3
   drop constraint pk_factura3;

alter table factura3
   add constraint pk_factura3 primary key (almacen, tipo, num_documento, linea, impuesto);

create unique index i1_factura3 on factura3 (
almacen,
tipo,
num_documento,
linea,
impuesto
);

create  index i2_factura3 on factura3 (
almacen,
tipo,
num_documento,
linea
);

alter table factura3
   add constraint fk_factura3_ref_10271_factura2 foreign key (almacen, tipo, num_documento, linea)
      references factura2 (almacen, tipo, num_documento, linea)
      on delete cascade on update cascade;

alter table factura3
   add constraint fk_factura3_reference_gral_imp foreign key (impuesto)
      references gral_impuestos (impuesto)
      on delete restrict on update cascade;

