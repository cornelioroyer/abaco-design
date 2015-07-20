
drop table bcocheck1 cascade;
create table bcocheck1 (
cod_ctabco           char(2)              not null,
motivo_bco           char(2)              not null,
no_cheque            int4                 not null,
no_solicitud         int4                 not null,
proveedor            char(6)              null,
paguese_a            char(60)             not null,
fecha_solicitud      date                 not null,
fecha_cheque         date                 not null,
fecha_posteo         date                 not null,
usuario              char(10)             not null,
fecha_captura        timestamp            not null,
docmto_fuente        char(10)             not null,
en_concepto_de       text                 null,
status               char(1)              not null,
monto                decimal(10,2)        not null,
aplicacion           char(3)              null
);

alter table bcocheck1
   add constraint pk_bcocheck1 primary key (cod_ctabco, no_cheque, motivo_bco);

create unique index i1_bcocheck1 on bcocheck1 (
cod_ctabco,
no_cheque,
motivo_bco
);

create  index i2_bcocheck1 on bcocheck1 (
cod_ctabco,
no_cheque,
motivo_bco,
fecha_posteo,
monto
);

create  index i3_bcocheck1 on bcocheck1 (
cod_ctabco,
no_solicitud,
no_cheque,
fecha_posteo
);

alter table bcocheck1
   add constraint fk_bcocheck_ref_28311_bcoctas foreign key (cod_ctabco)
      references bcoctas (cod_ctabco)
      on delete restrict on update restrict;

alter table bcocheck1
   add constraint fk_bcocheck_ref_28380_bcomotiv foreign key (motivo_bco)
      references bcomotivos (motivo_bco)
      on delete restrict on update cascade;

alter table bcocheck1
   add constraint fk_bcocheck_ref_28322_proveedo foreign key (proveedor)
      references proveedores (proveedor)
      on delete restrict on update restrict;

alter table bcocheck1
   add constraint fk_bcocheck_reference_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;


drop table bcocheck2 cascade;
create table bcocheck2 (
linea                int4                 not null,
cuenta               char(24)             not null,
cod_ctabco           char(2)              not null,
no_cheque            int4                 not null,
auxiliar1            char(10)             null,
auxiliar2            char(10)             null,
motivo_bco           char(2)              not null,
monto                decimal(10,2)        not null
);

alter table bcocheck2
   add constraint pk_bcocheck2 primary key (linea, cod_ctabco, no_cheque, motivo_bco);

create unique index i1_bcocheck2 on bcocheck2 (
linea,
cod_ctabco,
no_cheque,
motivo_bco
);

create  index i2_bcocheck2 on bcocheck2 (
cod_ctabco,
no_cheque,
motivo_bco
);

create  index i3_bcocheck2 on bcocheck2 (
linea,
cuenta,
cod_ctabco,
no_cheque,
auxiliar1,
motivo_bco
);

create  index i4_bcocheck2 on bcocheck2 (
monto
);

alter table bcocheck2
   add constraint fk_bcocheck_ref_38797_bcocheck foreign key (cod_ctabco, no_cheque, motivo_bco)
      references bcocheck1 (cod_ctabco, no_cheque, motivo_bco)
      on delete cascade on update cascade;

alter table bcocheck2
   add constraint fk_bcocheck_ref_44473_cglauxil foreign key (auxiliar1)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table bcocheck2
   add constraint fk_bcocheck_ref_44477_cglauxil foreign key (auxiliar2)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table bcocheck2
   add constraint fk_bcocheck_ref_28345_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

drop table bcocheck3 cascade;
create table bcocheck3 (
cod_ctabco           char(2)              not null,
motivo_bco           char(2)              not null,
no_cheque            int4                 not null,
aplicar_a            char(25)             not null,
motivo_cxp           char(3)              not null,
monto                decimal(10,2)        not null
);

alter table bcocheck3
   add constraint pk_bcocheck3 primary key (motivo_cxp, cod_ctabco, no_cheque, aplicar_a, motivo_bco);

create unique index i1_bcocheck3 on bcocheck3 (
motivo_cxp,
cod_ctabco,
no_cheque,
aplicar_a,
motivo_bco
);

create  index i2_bcocheck3 on bcocheck3 (
motivo_cxp,
cod_ctabco,
no_cheque
);

create  index i3_bcocheck3 on bcocheck3 (
aplicar_a
);

alter table bcocheck3
   add constraint fk_bcocheck_ref_38804_bcocheck foreign key (cod_ctabco, no_cheque, motivo_bco)
      references bcocheck1 (cod_ctabco, no_cheque, motivo_bco)
      on delete cascade on update cascade;

alter table bcocheck3
   add constraint fk_bcocheck_ref_28367_cxpmotiv foreign key (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on delete restrict on update cascade;


drop table rela_bcocheck1_cglposteo cascade;
create table rela_bcocheck1_cglposteo (
cod_ctabco           char(2)              not null,
no_cheque            int4                 not null,
motivo_bco           char(2)              not null,
consecutivo          int4                 not null
);

alter table rela_bcocheck1_cglposteo
   add constraint pk_rela_bcocheck1_cglposteo primary key (cod_ctabco, no_cheque, motivo_bco, consecutivo);

create unique index i1_rela_bcocheck1_cglposteo on rela_bcocheck1_cglposteo (
cod_ctabco,
no_cheque,
motivo_bco,
consecutivo
);

create  index i2_rela_bcocheck1_cglposteo on rela_bcocheck1_cglposteo (
cod_ctabco,
no_cheque,
motivo_bco
);

create  index i3_rela_bcocheck1_cglposteo on rela_bcocheck1_cglposteo (
consecutivo
);

alter table rela_bcocheck1_cglposteo
   add constraint fk_rela_bco_ref_70271_bcocheck foreign key (cod_ctabco, no_cheque, motivo_bco)
      references bcocheck1 (cod_ctabco, no_cheque, motivo_bco)
      on delete cascade on update cascade;

alter table rela_bcocheck1_cglposteo
   add constraint fk_rela_bco_ref_70281_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;


