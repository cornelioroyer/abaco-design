
drop table adc_manifiesto cascade;
drop table adc_master cascade;
drop table adc_house cascade;
drop table adc_manejo cascade;
create table adc_manifiesto (
compania             char(2)              not null,
consecutivo          int4                 not null,
referencia           char(2)              not null,
no_referencia        char(30)             not null,
to_agent             char(10)             not null,
from_agent           char(10)             not null,
ciudad_origen        char(10)             not null,
ciudad_destino       char(10)             not null,
fecha_departure      date                 not null,
fecha_arrive         date                 not null,
fecha                date                 not null,
cod_naviera          char(2)              not null,
vendedor             char(5)              not null,
puerto_descarga      char(2)              null,
vapor                char(60)             not null,
usuario_captura      char(10)             not null,
fecha_captura        timestamp            not null,
confirmado           char(1)              not null,
divisor              int4                 not null
);

alter table adc_manifiesto
   add constraint pk_adc_manifiesto primary key (compania, consecutivo);

create unique index i1_as_manifiesto on adc_manifiesto (
compania,
consecutivo
);

create unique index i2_as_manifiesto on adc_manifiesto (
no_referencia
);

alter table adc_manifiesto
   add constraint fk_adc_mani_reference_clientes_to foreign key (to_agent)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table adc_manifiesto
   add constraint fk_adc_mani_reference_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table adc_manifiesto
   add constraint fk_adc_mani_reference_clientes_from foreign key (from_agent)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table adc_manifiesto
   add constraint fk_adc_mani_reference_navieras foreign key (cod_naviera)
      references navieras (cod_naviera)
      on delete restrict on update cascade;

alter table adc_manifiesto
   add constraint fk_adc_mani_reference_fac_ciud_origen foreign key (ciudad_origen)
      references fac_ciudades (ciudad)
      on delete restrict on update cascade;

alter table adc_manifiesto
   add constraint fk_adc_mani_reference_fac_ciud_destino foreign key (ciudad_destino)
      references fac_ciudades (ciudad)
      on delete restrict on update cascade;

alter table adc_manifiesto
   add constraint fk_adc_mani_reference_fact_ref foreign key (referencia)
      references fact_referencias (referencia)
      on delete restrict on update cascade;

alter table adc_manifiesto
   add constraint fk_adc_mani_reference_vendedor foreign key (vendedor)
      references vendedores (codigo)
      on delete restrict on update restrict;

alter table adc_manifiesto
   add constraint fk_adc_mani_reference_destinos foreign key (puerto_descarga)
      references destinos (cod_destino)
      on delete restrict on update cascade;


create table adc_master (
compania             char(2)              not null,
consecutivo          int4                 not null,
linea_master         int4                 not null,
no_bill              char(25)             not null,
tamanio              char(5)              not null,
tipo                 char(10)             not null,
container            char(25)             not null,
sello                char(25)             null,
cargo                decimal(10,2)        not null,
cargo_prepago        char(1)              not null,
gtos_d_origen        decimal(10,2)        not null,
gtos_prepago         char(1)              not null,
gtos_destino         decimal(10,2)        not null,
dthc                 decimal(10,2)        not null,
dthc_prepago         char(1)              not null,
pkgs                 decimal(12,4)        not null,
cbm                  decimal(12,4)        not null,
kgs                  decimal(12,4)        not null,
observacion          text                 null
);

alter table adc_master
   add constraint pk_adc_master primary key (compania, consecutivo, linea_master);

create unique index i1_as_master on adc_master (
compania,
consecutivo,
linea_master
);

create  index i2_as_master on adc_master (
compania,
consecutivo
);

alter table adc_master
   add constraint fk_adc_mast_reference_adc_mani foreign key (compania, consecutivo)
      references adc_manifiesto (compania, consecutivo)
      on delete cascade on update cascade;

alter table adc_master
   add constraint fk_adc_mast_reference_adc_cont foreign key (tamanio)
      references adc_containers (tamanio)
      on delete restrict on update restrict;

alter table adc_master
   add constraint fk_adc_mast_reference_adc_tipo foreign key (tipo)
      references adc_tipo_de_contenedor (tipo)
      on delete restrict on update cascade;

create table adc_house (
compania             char(2)              not null,
consecutivo          int4                 not null,
linea_master         int4                 not null,
linea_house          int4                 not null,
cliente              char(10)             not null,
almacen              char(2)              not null,
cod_destino          char(2)              not null,
vendedor             char(5)              not null,
ciudad               char(10)             not null,
anio                 int4                 not null,
secuencia            int4                 not null,
embarcador           char(100)            not null,
no_house             char(25)             not null,
cargo                decimal(10,2)        not null,
cargo_prepago        char(1)              not null,
gtos_d_origen        decimal(10,2)        not null,
gtos_prepago         char(1)              not null,
dthc                 decimal(10,2)        not null,
dthc_prepago         char(1)              not null,
observacion          text                 null,
direccion1           char(50)             null,
direccion2           char(50)             null,
pkgs                 decimal(12,4)        not null,
cbm                  decimal(12,4)        not null,
kgs                  decimal(12,4)        not null,
tipo                 char(1)              not null
);

alter table adc_house
   add constraint pk_adc_house primary key (compania, consecutivo, linea_master, linea_house);

create unique index i1_as_house on adc_house (
compania,
consecutivo,
linea_master,
linea_house
);

create  index i2_as_house on adc_house (
compania,
consecutivo,
linea_master
);

create  index i3_adc_house on adc_house (
compania,
anio,
secuencia
);

alter table adc_house
   add constraint fk_adc_hous_reference_adc_mast foreign key (compania, consecutivo, linea_master)
      references adc_master (compania, consecutivo, linea_master)
      on delete cascade on update cascade;

alter table adc_house
   add constraint fk_adc_hous_reference_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table adc_house
   add constraint fk_adc_hous_reference_destinos foreign key (cod_destino)
      references destinos (cod_destino)
      on delete restrict on update restrict;

alter table adc_house
   add constraint fk_adc_hous_reference_vendedor foreign key (vendedor)
      references vendedores (codigo)
      on delete restrict on update restrict;

alter table adc_house
   add constraint fk_adc_hous_reference_fac_ciud foreign key (ciudad)
      references fac_ciudades (ciudad)
      on delete restrict on update restrict;

alter table adc_house
   add constraint fk_adc_hous_reference_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;

alter table adc_house
   add constraint fk_adc_hous_reference_adc_si foreign key (compania, anio, secuencia)
      references adc_si (compania, anio, secuencia)
      on delete restrict on update cascade;


create table adc_manejo (
compania             char(2)              not null,
consecutivo          int4                 not null,
linea_master         int4                 not null,
linea_house          int4                 not null,
linea_manejo         int4                 not null,
articulo             char(15)             not null,
almacen              char(2)              not null,
cargo                decimal(10,2)        not null,
observacion          text                 null,
fecha                date                 not null
);

alter table adc_manejo
   add constraint pk_adc_manejo primary key (compania, consecutivo, linea_master, linea_house, linea_manejo);

create unique index i1_as_manejo on adc_manejo (
compania,
consecutivo,
linea_master,
linea_house,
linea_manejo
);

create  index i2_as_manejo on adc_manejo (
compania,
consecutivo,
linea_master,
linea_house
);

create  index i3_as_manejo on adc_manejo (
articulo,
almacen
);

alter table adc_manejo
   add constraint fk_adc_mane_reference_adc_hous foreign key (compania, consecutivo, linea_master, linea_house)
      references adc_house (compania, consecutivo, linea_master, linea_house)
      on delete cascade on update cascade;

alter table adc_manejo
   add constraint fk_adc_mane_reference_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete restrict on update cascade;


