drop table tmp_cxctrx1;

create table tmp_cxctrx1  (
   sec_ajuste_cxc       int4                           not null,
   motivo_cxc           char(3)                        not null,
   cliente              char(6)                        not null,
   almacen              char(2)                        not null,
   docm_ajuste_cxc      char(10)                       not null,
   fecha_doc_ajuste_cxc date                           not null,
   fecha_posteo_ajuste_cxc date                           not null,
   obs_ajuste_cxc       text,
   status               char(1)                        not null,
   usuario              char(10)                       not null,
   fecha_captura        timestamp                      not null
)
;

insert into tmp_cxctrx1 (sec_ajuste_cxc, motivo_cxc, cliente, almacen, docm_ajuste_cxc, fecha_doc_ajuste_cxc, fecha_posteo_ajuste_cxc, obs_ajuste_cxc, status, usuario, fecha_captura)
select sec_ajuste_cxc, motivo_cxc, cliente, almacen, docm_ajuste_cxc, fecha_doc_ajuste_cxc, fecha_posteo_ajuste_cxc, obs_ajuste_cxc, status, usuario, fecha_captura
from cxctrx1

drop table cxctrx1;

create table cxctrx1  (
   sec_ajuste_cxc       int4                           not null,
   motivo_cxc           char(3)                        not null,
   cliente              char(6)                        not null,
   almacen              char(2)                        not null,
   docm_ajuste_cxc      char(10)                       not null,
   fecha_doc_ajuste_cxc date                           not null,
   fecha_posteo_ajuste_cxc date                           not null,
   obs_ajuste_cxc       text,
   status               char(1)                        not null,
   usuario              char(10)                       not null,
   fecha_captura        timestamp                      not null,
   efectivo             decimal(10,2)                  not null,
   cheque               decimal(10,2)                  not null,
   primary key (sec_ajuste_cxc, almacen)
)
;

insert into cxctrx1 (sec_ajuste_cxc, motivo_cxc, cliente, almacen, docm_ajuste_cxc, fecha_doc_ajuste_cxc, fecha_posteo_ajuste_cxc, obs_ajuste_cxc, status, usuario, fecha_captura, efectivo, cheque)
select sec_ajuste_cxc, motivo_cxc, cliente, almacen, docm_ajuste_cxc, fecha_doc_ajuste_cxc, fecha_posteo_ajuste_cxc, obs_ajuste_cxc, status, usuario, fecha_captura, ?, ?
from tmp_cxctrx1

drop table tmp_cxctrx1;

create table inv_conversion  (
   convertir_d          char(10)                       not null,
   convertir_a          char(10)                       not null,
   factor               decimal(12,5)                  not null,
   primary key (convertir_d, convertir_a)
)
;

alter table invparal
   add constraint FK_REFERENCE_336_GRALPARAMETRO foreign key (parametro, aplicacion)
      references gralparametros (parametro, aplicacion)
 on update restrict
 on delete restrict;

alter table invparal
   add constraint FK_REFERENCE_337_ALMACEN foreign key (almacen)
      references almacen (almacen)
 on update restrict
 on delete restrict;

alter table inv_conversion
   add constraint FK_REFERENCE_339_UNIDAD_MEDIDA foreign key (convertir_d)
      references unidad_medida (unidad_medida)
 on update restrict
 on delete restrict;

alter table inv_conversion
   add constraint FK_REFERENCE_340_UNIDAD_MEDIDA foreign key (convertir_a)
      references unidad_medida (unidad_medida)
 on update restrict
 on delete restrict;

alter table cxctrx1
   add constraint FK_REF_32495_CXCMOTIVOS foreign key (motivo_cxc)
      references cxcmotivos (motivo_cxc)
 on update restrict
 on delete restrict;

alter table cxctrx1
   add constraint FK_REF_32499_CLIENTES foreign key (cliente)
      references clientes (cliente)
 on update restrict
 on delete restrict;

alter table cxctrx1
   add constraint FK_REF_38779_ALMACEN foreign key (almacen)
      references almacen (almacen)
 on update restrict
 on delete restrict;

