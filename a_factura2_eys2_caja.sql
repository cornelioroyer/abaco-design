drop index i3_factura2_eys2;

drop index i2_factura2_eys2;

drop index i1_factura2_eys2;
alter table factura2_eys2
   drop constraint pk_factura2_eys2;


alter table factura2_eys2
   add constraint pk_factura2_eys2 primary key (tipo, caja, num_documento, factura2_linea, almacen);

/*==============================================================*/
/* Index: i1_factura2_eys2                                      */
/*==============================================================*/
create unique index i1_factura2_eys2 on factura2_eys2 (
almacen,
tipo,
num_documento,
factura2_linea,
caja
);

/*==============================================================*/
/* Index: i2_factura2_eys2                                      */
/*==============================================================*/
create  index i2_factura2_eys2 on factura2_eys2 (
almacen,
articulo,
no_transaccion,
eys2_linea
);

/*==============================================================*/
/* Index: i3_factura2_eys2                                      */
/*==============================================================*/
create  index i3_factura2_eys2 on factura2_eys2 (
almacen,
tipo,
num_documento,
factura2_linea,
caja
);

