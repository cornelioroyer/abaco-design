drop index i3_factura4;

drop index i2_factura4;

drop index i1_factura4;


alter table factura4
   drop constraint pk_factura4;
   

alter table factura4
   add constraint pk_factura4 primary key (almacen, tipo, caja, num_documento, rubro_fact_cxc);

/*==============================================================*/
/* Index: i1_factura4                                           */
/*==============================================================*/
create unique index i1_factura4 on factura4 (
almacen,
tipo,
num_documento,
rubro_fact_cxc,
caja
);

/*==============================================================*/
/* Index: i2_factura4                                           */
/*==============================================================*/
create  index i2_factura4 on factura4 (
almacen,
tipo,
num_documento,
caja
);

/*==============================================================*/
/* Index: i3_factura4                                           */
/*==============================================================*/
create  index i3_factura4 on factura4 (
rubro_fact_cxc
);

