drop index i1_cgl_comprobante1 cascade;

drop table cgl_comprobante1 cascade;

create table cgl_comprobante1 (
compania             char(2)              not null,
secuencia            int4                 not null,
fecha                date                 not null,
concepto             text                 not null,
usuario              char(10)             not null,
fecha_captura        timestamp            not null,
constraint pk_cgl_comprobante1 primary key (compania, secuencia)
);

create unique index i1_cgl_comprobante1 on cgl_comprobante1 (
compania,
secuencia
);

alter table cgl_comprobante1
   add constraint fk_cgl_comp_reference_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update restrict;
drop index i1_cgl_comprobante2 cascade;

drop index i2_cgl_comprobante2 cascade;

drop table cgl_comprobante2 cascade;

create table cgl_comprobante2 (
compania             char(2)              not null,
secuencia            int4                 not null,
linea                int4                 not null,
cuenta               char(24)             not null,
auxiliar             char(10)             null,
monto                decimal(12,2)        not null,
constraint pk_cgl_comprobante2 primary key (compania, secuencia, linea)
);

create unique index i1_cgl_comprobante2 on cgl_comprobante2 (
compania,
secuencia,
linea
);

create  index i2_cgl_comprobante2 on cgl_comprobante2 (
compania,
secuencia
);

alter table cgl_comprobante2
   add constraint fk_cgl_comp_reference_cgl_comp foreign key (compania, secuencia)
      references cgl_comprobante1 (compania, secuencia)
      on delete cascade on update cascade;

alter table cgl_comprobante2
   add constraint fk_cgl_comp_reference_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table cgl_comprobante2
   add constraint fk_cgl_comp_reference_cglauxil foreign key (auxiliar)
      references cglauxiliares (auxiliar)
      on delete restrict on update restrict;

drop index i1_rela_cgl_comprobante1_cglpos cascade;

drop index i2_rela_cgl_comprobante1_cglpos cascade;

drop index i3_rela_cgl_comprobante1_cglpos cascade;

drop table rela_cgl_comprobante1_cglposteo cascade;

create table rela_cgl_comprobante1_cglposteo (
consecutivo          int4                 not null,
compania             char(2)              not null,
secuencia            int4                 not null,
constraint pk_rela_cgl_comprobante1_cglpo primary key (consecutivo, compania, secuencia)
);

create unique index i1_rela_cgl_comprobante1_cglpos on rela_cgl_comprobante1_cglposteo (
consecutivo,
compania,
secuencia
);

create  index i2_rela_cgl_comprobante1_cglpos on rela_cgl_comprobante1_cglposteo (
compania,
secuencia
);

create  index i3_rela_cgl_comprobante1_cglpos on rela_cgl_comprobante1_cglposteo (
consecutivo
);

alter table rela_cgl_comprobante1_cglposteo
   add constraint fk_rela_cgl_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_cgl_comprobante1_cglposteo
   add constraint fk_rela_cgl_reference_cgl_comp foreign key (compania, secuencia)
      references cgl_comprobante1 (compania, secuencia)
      on delete cascade on update cascade;

