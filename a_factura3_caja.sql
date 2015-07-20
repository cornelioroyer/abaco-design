drop index i2_factura3;

drop index i1_factura3;

alter table factura3
   drop constraint pk_factura3;
   
alter table factura3
   add constraint pk_factura3 primary key (almacen, tipo, caja, num_documento, linea, impuesto);

/*==============================================================*/
/* Index: i1_factura3                                           */
/*==============================================================*/
create unique index i1_factura3 on factura3 (
almacen,
tipo,
num_documento,
linea,
impuesto,
caja
);

/*==============================================================*/
/* Index: i2_factura3                                           */
/*==============================================================*/
create  index i2_factura3 on factura3 (
almacen,
tipo,
num_documento,
linea,
caja
);

alter table factura3
   add constraint fk_factura3_ref_10271_factura2 foreign key (almacen, tipo, caja, num_documento, linea)
      references factura2 (almacen, tipo, caja, num_documento, linea)
      on delete cascade on update cascade;

