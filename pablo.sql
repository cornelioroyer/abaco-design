create table tmp_factura3 as
select * from factura3;
create table tmp_factura2 as
select * from factura2;

drop table factura2;

/*==============================================================*/
/* Table : factura2                                             */
/*==============================================================*/
create table factura2 (
almacen              CHAR(2)              not null,
tipo                 CHAR(3)              not null,
num_documento        INT4                 not null,
linea                INT4                 not null,
articulo             CHAR(15)             not null,
cantidad             decimal(12,4)        not null,
precio               decimal(12,4)        not null,
descuento_linea      decimal(10,2)        not null,
descuento_global     decimal(10,2)        not null,
constraint PK_FACTURA2 primary key (almacen, tipo, num_documento, linea)
);

alter table factura2
   add constraint FK_FACTURA2_REF_10268_FACTURA1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table factura2
   add constraint FK_FACTURA2_REF_10269_ARTICULO foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete restrict on update restrict;


drop table factura3;

/*==============================================================*/
/* Table : factura3                                             */
/*==============================================================*/
create table factura3 (
almacen              CHAR(2)              not null,
tipo                 CHAR(3)              not null,
num_documento        INT4                 not null,
linea                INT4                 not null,
impuesto             CHAR(2)              not null,
monto                decimal(12,4)        not null,
constraint PK_FACTURA3 primary key (almacen, tipo, num_documento, linea, impuesto)
);

alter table factura3
   add constraint FK_FACTURA3_REF_10271_FACTURA2 foreign key (almacen, tipo, num_documento, linea)
      references factura2 (almacen, tipo, num_documento, linea)
      on delete cascade on update cascade;

alter table factura3
   add constraint FK_FACTURA3_REF_10273_IMPUESTO foreign key (impuesto)
      references impuestos_facturacion (impuesto)
      on delete restrict on update restrict;


insert into factura2 select * from tmp_factura2;
insert into factura3 select * from tmp_factura3;

alter table factura3
   add constraint FK_FACTURA3_REF_10271_FACTURA2 foreign key (almacen, tipo, num_documento, linea)
      references factura2 (almacen, tipo, num_documento, linea)
      on delete cascade on update cascade;

alter table factura2_eys2
   add constraint FK_FACTURA2_REF_17355_FACTURA2 foreign key (almacen, tipo, num_documento, factura2_linea)
      references factura2 (almacen, tipo, num_documento, linea)
      on delete cascade on update cascade;


