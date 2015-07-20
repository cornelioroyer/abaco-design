
rollback work;

begin work;

drop index i4_factura2;

drop index i3_factura2;

drop index i2_factura2;

drop index i1_factura2;


alter table factura2
   drop constraint pk_factura2 cascade;

update factura2
set caja = almacen
where caja is null;
   

alter table factura2
   add constraint pk_factura2 primary key (almacen, tipo, caja, num_documento, linea);

/*==============================================================*/
/* Index: i1_factura2                                           */
/*==============================================================*/
create unique index i1_factura2 on factura2 (
almacen,
tipo,
num_documento,
linea,
caja
);

/*==============================================================*/
/* Index: i2_factura2                                           */
/*==============================================================*/
create  index i2_factura2 on factura2 (
almacen,
tipo,
num_documento,
caja
);

/*==============================================================*/
/* Index: i3_factura2                                           */
/*==============================================================*/
create  index i3_factura2 on factura2 (
articulo
);

/*==============================================================*/
/* Index: i4_factura2                                           */
/*==============================================================*/
create  index i4_factura2 on factura2 (
almacen,
articulo
);


alter table factura2_eys2
   add constraint fk_factura2_ref_17355_factura2 foreign key (almacen, tipo, caja, num_documento, factura2_linea)
      references factura2 (almacen, tipo, caja, num_documento, linea)
      on delete cascade on update cascade;

alter table factura3
   add constraint fk_factura3_ref_10271_factura2 foreign key (almacen, tipo, caja, num_documento, linea)
      references factura2 (almacen, tipo, caja, num_documento, linea)
      on delete cascade on update cascade;
      
commit work;
      
