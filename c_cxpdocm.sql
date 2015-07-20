
drop table cxpdocm cascade;

create table cxpdocm (
compania             char(2)              not null,
proveedor            char(6)              not null,
documento            char(25)             not null,
docmto_aplicar       char(25)             not null,
motivo_cxp           char(3)              not null,
docmto_aplicar_ref   char(25)             not null,
motivo_cxp_ref       char(3)              not null,
fecha_docmto         date                 not null,
fecha_vmto           date                 not null,
fecha_posteo         date                 not null,
fecha_cancelo        date                 not null,
fecha_captura        timestamp            not null,
usuario              char(10)             not null,
status               char(1)              not null,
obs_docmto           text                 null,
referencia           char(40)             null,
uso_interno          char(1)              not null 
      constraint ckc_uso_interno_cxpdocm check (uso_interno in ('S','N')),
aplicacion_origen    char(3)              not null,
monto                decimal(10,2)        not null
);

alter table cxpdocm
   add constraint pk_cxpdocm primary key (proveedor, compania, documento, docmto_aplicar, motivo_cxp);

create unique index i1_cxpdocm on cxpdocm (
proveedor,
compania,
documento,
docmto_aplicar,
motivo_cxp
);

create  index i2_cxpdocm on cxpdocm (
proveedor,
docmto_aplicar,
docmto_aplicar_ref,
motivo_cxp_ref,
compania
);

create  index i3_cxpdocm on cxpdocm (
compania,
documento,
docmto_aplicar
);

alter table cxpdocm
   add constraint fk_cxpdocm_ref_41007_gralapli foreign key (aplicacion_origen)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table cxpdocm
   add constraint fk_cxpdocm_reference_587_cxpdocm foreign key (proveedor, compania, docmto_aplicar, docmto_aplicar_ref, motivo_cxp_ref)
      references cxpdocm (proveedor, compania, documento, docmto_aplicar, motivo_cxp)
      on delete restrict on update restrict;

alter table cxpdocm
   add constraint fk_cxpdocm_reference_588_cxpmotiv foreign key (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on delete restrict on update restrict;

alter table cxpdocm
   add constraint fk_cxpdocm_ref_25811_proveedo foreign key (proveedor)
      references proveedores (proveedor)
      on delete restrict on update restrict;

alter table cxpdocm
   add constraint fk_cxpdocm_ref_25815_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;
