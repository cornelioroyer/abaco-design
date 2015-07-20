/*
alter table navieras
add column proveedor char(6) references proveedores;

update navieras
set proveedor = '1841';

alter table navieras
alter column proveedor set not null;

alter table fact_referencias
add column tipo char(1);

update fact_referencias
set tipo = 'I';

alter table fact_referencias
alter column tipo set not null;

alter table fact_referencias
add column medio char(1);

update fact_referencias
set medio = 'A';

alter table fact_referencias
alter column medio set not null;


*/

drop index i1_as_parametros_contables cascade;

drop table adc_parametros_contables cascade;

create table adc_parametros_contables (
referencia           char(2)              not null,
ciudad               char(10)             not null,
cta_ingreso          char(24)             not null,
cta_costo            char(24)             not null
);

alter table adc_parametros_contables
   add constraint pk_adc_parametros_contables primary key (referencia, ciudad);

create unique index i1_as_parametros_contables on adc_parametros_contables (
referencia,
ciudad
);

alter table adc_parametros_contables
   add constraint fk_adc_para_reference_fact_ref foreign key (referencia)
      references fact_referencias (referencia)
      on delete restrict on update cascade;

alter table adc_parametros_contables
   add constraint fk_adc_para_reference_fac_ciud foreign key (ciudad)
      references fac_ciudades (ciudad)
      on delete restrict on update restrict;

alter table adc_parametros_contables
   add constraint fk_adc_para_reference_cglcuent_ingreso foreign key (cta_ingreso)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table adc_parametros_contables
   add constraint fk_adc_para_reference_cglcuent_costo foreign key (cta_costo)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;
      
drop index i1_as_manifiesto cascade;

drop table adc_manifiesto cascade;

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
vapor                char(60)             not null,
usuario_captura      char(10)             not null,
fecha_captura        timestamp            not null
);

alter table adc_manifiesto
   add constraint pk_adc_manifiesto primary key (compania, consecutivo);

create unique index i1_as_manifiesto on adc_manifiesto (
compania,
consecutivo
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
      



drop table adc_containers cascade;

create table adc_containers (
tamanio              char(5)              not null
);

alter table adc_containers
   add constraint pk_adc_containers primary key (tamanio);


drop index i1_as_master cascade;

drop index i2_as_master cascade;

drop table adc_master cascade;

create table adc_master (
compania             char(2)              not null,
consecutivo          int4                 not null,
linea_master         int4                 not null,
no_bill              char(25)             not null,
tamanio              char(5)              not null,
container            char(25)             not null,
sello                char(25)             null,
cargo                decimal(10,2)        not null,
gtos_d_origen        decimal(10,2)        not null,
cargo_prepago        char(1)              not null,
gtos_prepago         char(1)              not null,
pkgs                 char(90)             not null,
cbm                  decimal(12,4)        not null,
kgs                  decimal(12,4)        not null,
observacion          text                 not null
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
      
drop index i1_as_house cascade;

drop index i2_as_house cascade;

drop index i3_as_house cascade;

drop table adc_house cascade;

create table adc_house (
compania             char(2)              not null,
consecutivo          int4                 not null,
linea_master         int4                 not null,
linea_house          int4                 not null,
cliente              char(10)             not null,
almacen              char(2)              null,
tipo                 char(3)              null,
num_documento        int4                 null,
embarcador           char(100)            not null,
no_house             char(25)             not null,
cargo                decimal(10,2)        not null,
cargo_prepago        char(1)              not null,
gtos_d_origen        decimal(10,2)        not null,
gtos_prepago         char(1)              not null,
observacion          text                 null,
direccion1           char(50)             null,
direccion2           char(50)             null
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

create  index i3_as_house on adc_house (
almacen,
tipo,
num_documento
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
   add constraint fk_adc_hous_reference_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete restrict on update cascade;
      
      


drop index i1_as_manejo cascade;

drop index i2_as_manejo cascade;

drop index i3_as_manejo cascade;

drop table adc_manejo cascade;

create table adc_manejo (
compania             char(2)              not null,
consecutivo          int4                 not null,
linea_master         int4                 not null,
linea_house          int4                 not null,
linea_manejo         int4                 not null,
articulo             char(15)             not null,
almacen              char(2)              not null,
tipo                 char(3)              null,
num_documento        int4                 null,
cargo                decimal(10,2)        not null,
observacion          text                 null
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

alter table adc_manejo
   add constraint fk_adc_mane_reference_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete restrict on update restrict;