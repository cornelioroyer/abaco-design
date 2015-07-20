drop index i1_pla_tipo_permiso cascade;

drop index i2_pla_tipo_permiso cascade;

drop table pla_tipo_permisos cascade;

create table pla_tipo_permisos (
tipodepermiso        char(2)              not null,
tipodhora            char(2)              not null,
descripcion          char(60)             not null,
pagar                char(1)              not null 
      constraint ckc_pagar_pla_tipo check (pagar in ('S','N'))
);

alter table pla_tipo_permisos
   add constraint pk_pla_tipo_permisos primary key (tipodepermiso);

create unique index i1_pla_tipo_permiso on pla_tipo_permisos (
tipodepermiso
);

create  index i2_pla_tipo_permiso on pla_tipo_permisos (
tipodhora
);

alter table pla_tipo_permisos
   add constraint fk_pla_tipo_permis_ref_nomtipodehoras foreign key (tipodhora)
      references nomtipodehoras (tipodhora)
      on delete restrict on update cascade;


drop index i1_pla_permisos cascade;

drop index i2_pla_permisos cascade;

drop index i3_pla_permisos cascade;

drop table pla_permisos cascade;

create table pla_permisos (
compania             char(2)              not null,
codigo_empleado      char(7)              not null,
tipodepermiso        char(2)              not null,
f_desde              date                 not null,
h_desde              time                 not null,
f_hasta              date                 not null,
h_hasta              time                 not null,
horas                decimal(10,2)        not null,
observacion          text                 null,
usuario              char(10)             not null,
fecha_captura        timestamp            not null
);

alter table pla_permisos
   add constraint pk_pla_permisos primary key (codigo_empleado, compania, tipodepermiso, f_desde, h_desde);

create unique index i1_pla_permisos on pla_permisos (
compania,
codigo_empleado,
tipodepermiso,
f_desde
);

create  index i2_pla_permisos on pla_permisos (
compania,
codigo_empleado
);

create  index i3_pla_permisos on pla_permisos (
tipodepermiso
);

alter table pla_permisos
   add constraint fk_pla_permisos_ref_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table pla_permisos
   add constraint fk_pla_permisos_ref_pla_tipo_permis foreign key (tipodepermiso)
      references pla_tipo_permisos (tipodepermiso)
      on delete restrict on update cascade;

