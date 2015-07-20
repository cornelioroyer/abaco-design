drop table tmp_cxpfact1;
drop table tmp_cxpfact2;
drop table tmp_cxpfact3;
create table tmp_cxpfact1  (
   proveedor            char(6)                        not null,
   fact_proveedor       char(10)                       not null,
   forma_pago           char(2)                        not null,
   numero_oc            int4,
   compania             char(2)                        not null,
   motivo_cxp           char(3)                        not null,
   aplicacion_origen    char(3)                        not null,
   oc1_compania         char(2),
   vence_fact_cxp       date                           not null,
   fecha_factura_cxp    date                           not null,
   fecha_posteo_fact_cxp date                           not null,
   obs_fact_cxp         text,
   status               char(1)                        not null,
   usuario              char(10)                       not null,
   fecha_captura        timestamp                      not null,
   primary key (proveedor, fact_proveedor, compania)
)
;

create table tmp_cxpfact2  (
   proveedor            char(6)                        not null,
   fact_proveedor       char(10)                       not null,
   rubro_fact_cxp       char(15)                       not null,
   linea                int4                           not null,
   compania             char(2)                        not null,
   auxiliar1            char(10),
   auxiliar2            char(10),
   cuenta               char(24),
   monto                decimal(10,2)                  not null,
   primary key (proveedor, fact_proveedor, rubro_fact_cxp, linea, compania)
)
;

create table tmp_cxpfact3  (
   proveedor            char(6)                        not null,
   fact_proveedor       char(10)                       not null,
   aplicar_a            char(10)                       not null,
   compania             char(2)                        not null,
   motivo_cxp           char(3)                        not null,
   monto                decimal                        not null,
   primary key (proveedor, fact_proveedor, aplicar_a, compania, motivo_cxp)
)
;

alter table tmp_cxpfact1
   add constraint FK_REF_22592_PROVEEDORES foreign key (proveedor)
      references proveedores (proveedor)
 on update restrict
 on delete restrict;

alter table tmp_cxpfact1
   add constraint FK_REF_22597_GRAL_FORMA_DE foreign key (forma_pago)
      references gral_forma_de_pago (forma_pago)
 on update restrict
 on delete restrict;

alter table tmp_cxpfact2
   add constraint FK_REF_22635_CXPFACT1 foreign key (proveedor, fact_proveedor, compania)
      references tmp_cxpfact1 (proveedor, fact_proveedor, compania)
 on update cascade
 on delete cascade;

alter table tmp_cxpfact2
   add constraint FK_REF_22642_RUBROS_FACT_C foreign key (rubro_fact_cxp)
      references rubros_fact_cxp (rubro_fact_cxp)
 on update restrict
 on delete restrict;

alter table tmp_cxpfact1
   add constraint FK_REF_22656_OC1 foreign key (numero_oc, oc1_compania)
      references oc1 (numero_oc, compania)
 on update restrict
 on delete restrict;

alter table tmp_cxpfact3
   add constraint FK_REF_22660_CXPFACT1 foreign key (proveedor, fact_proveedor, compania)
      references tmp_cxpfact1 (proveedor, fact_proveedor, compania)
 on update cascade
 on delete cascade;

alter table tmp_cxpfact1
   add constraint FK_REF_23669_GRALCOMPANIAS foreign key (compania)
      references gralcompanias (compania)
 on update restrict
 on delete restrict;

alter table tmp_cxpfact1
   add constraint FK_REF_25847_CXPMOTIVOS foreign key (motivo_cxp)
      references cxpmotivos (motivo_cxp)
 on update restrict
 on delete restrict;

alter table tmp_cxpfact3
   add constraint FK_REF_38827_CXPMOTIVOS foreign key (motivo_cxp)
      references cxpmotivos (motivo_cxp)
 on update restrict
 on delete restrict;

alter table tmp_cxpfact1
   add constraint FK_REF_43431_GRALAPLICACIO foreign key (aplicacion_origen)
      references gralaplicaciones (aplicacion)
 on update restrict
 on delete restrict;

alter table tmp_cxpfact2
   add constraint FK_REF_54544_CGLAUXILIARES foreign key (auxiliar1)
      references cglauxiliares (auxiliar)
 on update restrict
 on delete restrict;

alter table tmp_cxpfact2
   add constraint FK_REF_54548_CGLAUXILIARES foreign key (auxiliar2)
      references cglauxiliares (auxiliar)
 on update restrict
 on delete restrict;

alter table tmp_cxpfact2
   add constraint FK_REF_64317_CGLCUENTAS foreign key (cuenta)
      references cglcuentas (cuenta)
 on update restrict
 on delete restrict;

