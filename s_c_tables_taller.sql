
drop table tal_precios_x_cliente cascade;
drop table tal_servicios cascade;

/*==============================================================*/
/* Table: tal_precios_x_cliente                                 */
/*==============================================================*/
create table tal_precios_x_cliente (
cliente              char(10)             not null,
precio               decimal(10,2)        not null,
constraint pk_tal_precios_x_cliente primary key (cliente)
);

/*==============================================================*/
/* Index: i1_tal_precios_x_cliente                              */
/*==============================================================*/
create unique index i1_tal_precios_x_cliente on tal_precios_x_cliente (
cliente
);

/*==============================================================*/
/* Index: i2_tal_precios_x_cliente                              */
/*==============================================================*/
create  index i2_tal_precios_x_cliente on tal_precios_x_cliente (
cliente
);

alter table tal_precios_x_cliente
   add constraint fk_tal_prec_reference_clientes foreign key (cliente)
      references clientes (cliente)
      on delete cascade on update cascade;




/*==============================================================*/
/* Table: tal_servicios                                         */
/*==============================================================*/
create table tal_servicios (
servicio             char(15)             not null,
descripcion          char(100)            not null,
articulo             char(15)             not null,
horas_libro          decimal(10,2)        not null,
tasaporhora          decimal(10,2)        not null,
constraint pk_tal_servicios primary key (servicio)
);

/*==============================================================*/
/* Index: i1_tal_servicios                                      */
/*==============================================================*/
create  index i1_tal_servicios on tal_servicios (
servicio
);

/*==============================================================*/
/* Index: i2_tal_servicios                                      */
/*==============================================================*/
create  index i2_tal_servicios on tal_servicios (
articulo
);

alter table tal_servicios
   add constraint fk_tal_serv_reference_articulo foreign key (articulo)
      references articulos (articulo)
      on delete restrict on update restrict;



drop table tal_equipo cascade;

/*==============================================================*/
/* Table: tal_equipo                                            */
/*==============================================================*/
create table tal_equipo (
compania             char(2)              not null,
codigo               char(15)             not null,
descripcion          char(200)            not null,
activo               char(15)             null,
serial               char(100)            null,
anio                 int4                 null,
modelo               char(100)            null,
motor                char(100)            null,
embrague             char(100)            null,
tipo_embrague        char(100)            null,
eje_delantero        char(100)            null,
eje_trasero          char(100)            null,
llantas              char(100)            null,
placa                char(100)            null,
color                char(100)            null,
status               char(1)              not null,
inventario           char(1)              not null,
desc_tecnica         text                 null,
constraint pk_tal_equipo primary key (codigo, compania)
);

/*==============================================================*/
/* Index: i1_tal_equipo                                         */
/*==============================================================*/
create unique index i1_tal_equipo on tal_equipo (
codigo
);

/*==============================================================*/
/* Index: i2_tal_equipo                                         */
/*==============================================================*/
create  index i2_tal_equipo on tal_equipo (
activo,
compania
);

alter table tal_equipo
   add constraint fk_tal_equi_reference_activos foreign key (activo, compania)
      references activos (codigo, compania)
      on delete restrict on update restrict;



drop table tal_ot1 cascade;

/*==============================================================*/
/* Table: tal_ot1                                               */
/*==============================================================*/
create table tal_ot1 (
almacen              char(2)              not null,
tipo                 char(1)              not null,
no_orden             int4                 not null,
cliente              char(10)             not null,
nombre_cliente       char(200)            not null,
codigo               char(15)             null,
empleado_responsable char(7)              not null,
compania             char(2)              not null,
tipo_factura         char(3)              null,
numero_factura       int4                 null,
forma_pago           char(2)              not null,
referencia           char(2)              not null,
observacion          text                 null,
kilometraje          int4                 not null,
tipo_de_mantenimiento char(1)              not null,
usuario              char(10)             not null,
fecha_captura        timestamp            not null,
fecha                date                 not null,
fecha_entrega        date                 not null,
status               char(1)              not null,
placa                char(30)             not null,
facturar             char(1)              not null,
serie                char(90)             null,
fecha_cierre         date                 null,
garantia             char(1)              not null,
direccion_1          varchar(100)         null,
direccion_2          varchar(100)         null,
e_mail_1             char(1)              not null,
e_mail_2             char(1)             not null,
no_cotizacion        varchar(60)          null,
no_oc                varchar(60)          null,
reportes_enviados    char(1)              not null,
reportes_finales     char(1)              not null,
trabajo_visitado     char(1)              not null,
trabajo_realizado    char(1)             not null,
memo_piezas          text                 null,
memo_mo              text                 null,
constraint pk_tal_ot1 primary key (almacen, no_orden, tipo)
);

/*==============================================================*/
/* Index: i1_tal_ot1                                            */
/*==============================================================*/
create unique index i1_tal_ot1 on tal_ot1 (
tipo,
no_orden,
almacen
);

/*==============================================================*/
/* Index: i2_tal_ot1                                            */
/*==============================================================*/
create  index i2_tal_ot1 on tal_ot1 (
cliente
);

/*==============================================================*/
/* Index: i3_tal_ot1                                            */
/*==============================================================*/
create  index i3_tal_ot1 on tal_ot1 (
codigo
);

/*==============================================================*/
/* Index: i4_tal_ot1                                            */
/*==============================================================*/
create  index i4_tal_ot1 on tal_ot1 (
almacen,
tipo_factura,
numero_factura
);

alter table tal_ot1
   add constraint fk_tal_ot1_reference_tal_equi foreign key (codigo, compania)
      references tal_equipo (codigo, compania)
      on delete restrict on update cascade;

alter table tal_ot1
   add constraint fk_tal_ot1_reference_612_rhuempl foreign key (empleado_responsable, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table tal_ot1
   add constraint fk_tal_ot1_reference_factura1 foreign key (almacen, tipo_factura, numero_factura)
      references factura1 (almacen, tipo, num_documento)
      on delete restrict on update cascade;

alter table tal_ot1
   add constraint fk_tal_ot1_reference_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update restrict;

alter table tal_ot1
   add constraint fk_tal_ot1_reference_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update restrict;

alter table tal_ot1
   add constraint fk_tal_ot1_reference_gral_for foreign key (forma_pago)
      references gral_forma_de_pago (forma_pago)
      on delete restrict on update cascade;

alter table tal_ot1
   add constraint fk_tal_ot1_reference_fact_ref foreign key (referencia)
      references fact_referencias (referencia)
      on delete restrict on update cascade;



drop table tal_ot2 cascade;

/*==============================================================*/
/* Table: tal_ot2                                               */
/*==============================================================*/
create table tal_ot2 (
almacen              char(2)              not null,
no_orden             int4                 not null,
tipo                 char(1)              not null,
linea                integer              not null,
articulo             char(15)             not null,
servicio             char(15)             not null,
descripcion          text                 null,
despachar            char(1)              not null,
usuario_captura      char(10)             not null,
fecha_captura        timestamp            not null,
fecha_despacho       date                 null,
cantidad             decimal(12,2)        not null,
extension            decimal(12,2)        not null,
autorizar            char(1)              not null,
usuario_autorizo     char(10)             null,
fecha_autorizo       timestamp            null,
constraint pk_tal_ot2 primary key (no_orden, tipo, almacen, linea, articulo)
);

/*==============================================================*/
/* Index: i1_tal_ot2                                            */
/*==============================================================*/
create unique index i1_tal_ot2 on tal_ot2 (
no_orden,
almacen,
tipo,
articulo,
linea
);

/*==============================================================*/
/* Index: i2_tal_ot2                                            */
/*==============================================================*/
create  index i2_tal_ot2 on tal_ot2 (
no_orden,
almacen,
tipo
);

/*==============================================================*/
/* Index: i3_tal_ot2                                            */
/*==============================================================*/
create  index i3_tal_ot2 on tal_ot2 (
almacen,
articulo
);

/*==============================================================*/
/* Index: i4_tal_ot2                                            */
/*==============================================================*/
create  index i4_tal_ot2 on tal_ot2 (
fecha_despacho
);

alter table tal_ot2
   add constraint fk_tal_ot2_reference_tal_ot1 foreign key (almacen, no_orden, tipo)
      references tal_ot1 (almacen, no_orden, tipo)
      on delete cascade on update cascade;

alter table tal_ot2
   add constraint fk_tal_ot2_reference_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete restrict on update cascade;

alter table tal_ot2
   add constraint fk_tal_ot2_reference_tal_serv foreign key (servicio)
      references tal_servicios (servicio)
      on delete cascade on update cascade;


drop table tal_ot3 cascade;

/*==============================================================*/
/* Table: tal_ot3                                               */
/*==============================================================*/
create table tal_ot3 (
almacen              char(2)              not null,
no_orden             int4                 not null,
tipo                 char(1)              not null,
linea                int4                 not null,
compania             char(2)              not null,
codigo_empleado      char(7)              not null,
servicio             char(15)             not null,
observacion          text                 null,
horas                decimal(12,2)        not null,
extension            decimal(12,2)        not null,
constraint pk_tal_ot3 primary key (almacen, no_orden, tipo, linea)
);

/*==============================================================*/
/* Index: i1_tal_ot3                                            */
/*==============================================================*/
create unique index i1_tal_ot3 on tal_ot3 (
almacen,
no_orden,
linea,
tipo
);

/*==============================================================*/
/* Index: i2_tal_ot3                                            */
/*==============================================================*/
create  index i2_tal_ot3 on tal_ot3 (
almacen,
no_orden
);

/*==============================================================*/
/* Index: i3_tal_ot3                                            */
/*==============================================================*/
create  index i3_tal_ot3 on tal_ot3 (
almacen
);

/*==============================================================*/
/* Index: i4_tal_ot3                                            */
/*==============================================================*/
create  index i4_tal_ot3 on tal_ot3 (
compania,
codigo_empleado
);

/*==============================================================*/
/* Index: i5_tal_ot3                                            */
/*==============================================================*/
create  index i5_tal_ot3 on tal_ot3 (
servicio
);

alter table tal_ot3
   add constraint fk_tal_ot3_reference_tal_ot1 foreign key (almacen, no_orden, tipo)
      references tal_ot1 (almacen, no_orden, tipo)
      on delete cascade on update cascade;

alter table tal_ot3
   add constraint fk_tal_ot3_reference_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table tal_ot3
   add constraint fk_tal_ot3_reference_tal_serv foreign key (servicio)
      references tal_servicios (servicio)
      on delete cascade on update cascade;



drop table tal_ot2_eys2 cascade;

/*==============================================================*/
/* Table: tal_ot2_eys2                                          */
/*==============================================================*/
create table tal_ot2_eys2 (
no_orden             int4                 not null,
tipo                 char(1)              not null,
almacen              char(2)              not null,
linea_tal_ot2        integer              not null,
articulo             char(15)             not null,
no_transaccion       int4                 not null,
linea_eys2           int4                 not null,
constraint pk_tal_ot2_eys2 primary key (no_orden, tipo, almacen, linea_tal_ot2, articulo)
);

/*==============================================================*/
/* Index: i1_tal_ot2_eys2                                       */
/*==============================================================*/
create unique index i1_tal_ot2_eys2 on tal_ot2_eys2 (
no_orden,
tipo,
almacen,
linea_tal_ot2,
articulo
);

/*==============================================================*/
/* Index: i2_tal_ot2_eys2                                       */
/*==============================================================*/
create  index i2_tal_ot2_eys2 on tal_ot2_eys2 (
almacen,
articulo,
no_transaccion,
linea_eys2
);

/*==============================================================*/
/* Index: i3_tal_ot2_eys2                                       */
/*==============================================================*/
create  index i3_tal_ot2_eys2 on tal_ot2_eys2 (
almacen,
no_transaccion
);

alter table tal_ot2_eys2
   add constraint fk_tal_ot2__reference_tal_ot2 foreign key (no_orden, tipo, almacen, linea_tal_ot2, articulo)
      references tal_ot2 (no_orden, tipo, almacen, linea, articulo)
      on delete cascade on update cascade;

alter table tal_ot2_eys2
   add constraint fk_tal_ot2__reference_eys2 foreign key (articulo, almacen, no_transaccion, linea_eys2)
      references eys2 (articulo, almacen, no_transaccion, linea)
      on delete cascade on update cascade;
