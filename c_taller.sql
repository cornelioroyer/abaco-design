
drop table tal_ot1 cascade;
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
fecha_cierre         date                 null
);

alter table tal_ot1
   add constraint pk_tal_ot1 primary key (almacen, no_orden, tipo);

create unique index i1_tal_ot1 on tal_ot1 (
tipo,
no_orden,
almacen
);

create  index i2_tal_ot1 on tal_ot1 (
cliente
);

create  index i3_tal_ot1 on tal_ot1 (
codigo
);

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
   add constraint fk_tal_ot1_reference_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update restrict;

alter table tal_ot1
   add constraint fk_tal_ot1_reference_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update restrict;

alter table tal_ot1
   add constraint fk_tal_ot1_reference_612_rhuempl foreign key (empleado_responsable, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table tal_ot1
   add constraint fk_tal_ot1_reference_factura1 foreign key (almacen, tipo_factura, numero_factura)
      references factura1 (almacen, tipo, num_documento)
      on delete restrict on update cascade;

alter table tal_ot1
   add constraint fk_tal_ot1_reference_gral_for foreign key (forma_pago)
      references gral_forma_de_pago (forma_pago)
      on delete restrict on update cascade;

alter table tal_ot1
   add constraint fk_tal_ot1_reference_fact_ref foreign key (referencia)
      references fact_referencias (referencia)
      on delete restrict on update cascade;



drop table tal_ot2 cascade;
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
fecha_autorizo       timestamp            null
);

alter table tal_ot2
   add constraint pk_tal_ot2 primary key (no_orden, tipo, almacen, linea, articulo);

create unique index i1_tal_ot2 on tal_ot2 (
no_orden,
almacen,
tipo,
articulo,
linea
);

create  index i2_tal_ot2 on tal_ot2 (
no_orden,
almacen,
tipo
);

create  index i3_tal_ot2 on tal_ot2 (
almacen,
articulo
);

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
extension            decimal(12,2)        not null
);

alter table tal_ot3
   add constraint pk_tal_ot3 primary key (almacen, no_orden, tipo, linea);

create unique index i1_tal_ot3 on tal_ot3 (
almacen,
no_orden,
linea,
tipo
);

create  index i2_tal_ot3 on tal_ot3 (
almacen,
no_orden
);

create  index i3_tal_ot3 on tal_ot3 (
almacen
);

create  index i4_tal_ot3 on tal_ot3 (
compania,
codigo_empleado
);

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


alter table oc2
   add constraint fk_oc2_reference_tal_ot2 foreign key (no_orden, tipo, almacen, linea, articulo)
      references tal_ot2 (no_orden, tipo, almacen, linea, articulo)
      on delete restrict on update cascade;


alter table tal_ot2_eys2
   add constraint fk_tal_ot2__reference_tal_ot2 foreign key (no_orden, tipo, almacen, linea_tal_ot2, articulo)
      references tal_ot2 (no_orden, tipo, almacen, linea, articulo)
      on delete cascade on update cascade;

alter table tal_temp
   add constraint fk_tal_temp_reference_tal_ot2 foreign key (no_orden, tipo, almacen, linea, articulo)
      references tal_ot2 (no_orden, tipo, almacen, linea, articulo)
      on delete cascade on update cascade;


drop table tal_dev1 cascade;
create table tal_dev1 (
almacen              char(2)              not null,
no_transaccion       int4                 not null,
fecha                date                 not null,
observacion          text                 null,
usuario              char(10)             not null,
fecha_captura        timestamp            not null
);

alter table tal_dev1
   add constraint pk_tal_dev1 primary key (almacen, no_transaccion);

alter table tal_dev1
   add constraint fk_tal_dev1_reference_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;



drop table tal_dev2 cascade;
create table tal_dev2 (
almacen              char(2)              not null,
no_transaccion       int4                 not null,
no_orden             int4                 not null,
tipo                 char(1)              not null,
linea                integer              not null,
articulo             char(15)             not null,
cantidad             decimal(12,4)        not null
);

alter table tal_dev2
   add constraint pk_tal_dev2 primary key (almacen, no_transaccion, no_orden, tipo, linea, articulo);

alter table tal_dev2
   add constraint fk_tal_dev2_reference_tal_ot2 foreign key (no_orden, tipo, almacen, linea, articulo)
      references tal_ot2 (no_orden, tipo, almacen, linea, articulo)
      on delete restrict on update cascade;

alter table tal_dev2
   add constraint fk_tal_dev2_reference_tal_dev1 foreign key (almacen, no_transaccion)
      references tal_dev1 (almacen, no_transaccion)
      on delete cascade on update cascade;



drop table tal_dev2_eys2 cascade;
create table tal_dev2_eys2 (
articulo             char(15)             not null,
almacen              char(2)              not null,
no_transaccion       int4                 not null,
linea_eys2           int4                 not null,
tal_no_transaccion   int4                 not null,
no_orden             int4                 not null,
tipo                 char(1)              not null,
tal_linea            integer              not null
);

alter table tal_dev2_eys2
   add constraint fk_tal_dev2_reference_eys2 foreign key (articulo, almacen, no_transaccion, linea_eys2)
      references eys2 (articulo, almacen, no_transaccion, linea)
      on delete cascade on update cascade;

alter table tal_dev2_eys2
   add constraint fk_tal_dev2_reference_tal_dev2 foreign key (almacen, tal_no_transaccion, no_orden, tipo, tal_linea, articulo)
      references tal_dev2 (almacen, no_transaccion, no_orden, tipo, linea, articulo)
      on delete cascade on update cascade;
