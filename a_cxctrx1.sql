

rollback work;

begin work;

alter table cxctrx1 add column caja char(3);
alter table cxctrx3 add column caja char(3);
alter table cxctrx2 add column caja char(3);
alter table cxc_recibo add column caja char(3);
alter table cxc_recibo1 add column caja char(3);
alter table cxc_recibo2 add column caja char(3);
alter table cxc_recibo3 add column caja char(3);
alter table cxc_recibo4 add column caja char(3);
alter table adc_facturas_recibos add column caja char(3);
alter table rela_cxctrx1_cglposteo add column caja char(3);
alter table rela_cxc_recibo1_cglposteo add column caja char(3);

update cxctrx1 set caja = almacen;
update cxctrx2 set caja = almacen;
update cxctrx3 set caja = almacen;
update cxc_recibo set caja = almacen;
update rela_cxctrx1_cglposteo set caja = almacen;
update cxc_recibo1 set caja = almacen;
update cxc_recibo2 set caja = almacen;
update cxc_recibo3 set caja = almacen;
update cxc_recibo4 set caja = almacen;
update adc_facturas_recibos set caja = almacen;
update rela_cxc_recibo1_cglposteo set caja = almacen;

drop index i4_cxctrx1;

drop index i3_cxctrx1;

drop index i2_cxctrx1;

drop index i1_cxctrx1;


alter table cxctrx1
   drop constraint pk_cxctrx1 cascade;
   
alter table cxctrx1
   add constraint pk_cxctrx1 primary key (sec_ajuste_cxc, caja, almacen);

/*==============================================================*/
/* Index: i1_cxctrx1                                            */
/*==============================================================*/
create unique index i1_cxctrx1 on cxctrx1 (
sec_ajuste_cxc,
almacen,
caja
);

/*==============================================================*/
/* Index: i2_cxctrx1                                            */
/*==============================================================*/
create  index i2_cxctrx1 on cxctrx1 (
motivo_cxc,
cliente,
almacen,
docm_ajuste_cxc,
fecha_posteo_ajuste_cxc
);

/*==============================================================*/
/* Index: i3_cxctrx1                                            */
/*==============================================================*/
create unique index i3_cxctrx1 on cxctrx1 (
motivo_cxc,
cliente,
almacen,
docm_ajuste_cxc
);

/*==============================================================*/
/* Index: i4_cxctrx1                                            */
/*==============================================================*/
create unique index i4_cxctrx1 on cxctrx1 (
cliente,
almacen,
docm_ajuste_cxc,
caja
);

alter table cxc_recibo
   add constraint fk_cxc_reci_reference_cxctrx1 foreign key (sec_ajuste_cxc, caja, almacen)
      references cxctrx1 (sec_ajuste_cxc, caja, almacen)
      on delete cascade on update cascade;

alter table cxctrx1
   add constraint fk_cxctrx1_reference_fac_caja foreign key (caja, almacen)
      references fac_cajas (caja, almacen)
      on delete restrict on update cascade;

alter table cxctrx2
   add constraint fk_cxctrx2_ref_38790_cxctrx1 foreign key (sec_ajuste_cxc, caja, almacen)
      references cxctrx1 (sec_ajuste_cxc, caja, almacen)
      on delete cascade on update cascade;

alter table cxctrx3
   add constraint fk_cxctrx3_ref_38783_cxctrx1 foreign key (sec_ajuste_cxc, caja, almacen)
      references cxctrx1 (sec_ajuste_cxc, caja, almacen)
      on delete cascade on update cascade;

alter table rela_cxctrx1_cglposteo
   add constraint fk_rela_cxc_ref_71937_cxctrx1 foreign key (sec_ajuste_cxc, caja, almacen)
      references cxctrx1 (sec_ajuste_cxc, caja, almacen)
      on delete cascade on update cascade;



drop index i2_cxc_recibo1;

drop index i1_cxc_recibo1;

alter table cxc_recibo1
   drop constraint pk_cxc_recibo1 cascade;

alter table cxc_recibo1
   add constraint pk_cxc_recibo1 primary key (almacen, caja, consecutivo);

create unique index i1_cxc_recibo1 on cxc_recibo1 (
almacen,
consecutivo,
caja
);

/*==============================================================*/
/* Index: i2_cxc_recibo1                                        */
/*==============================================================*/
create unique index i2_cxc_recibo1 on cxc_recibo1 (
almacen,
documento
);

alter table adc_facturas_recibos
   add constraint fk_adc_fact_reference_cxc_reci foreign key (cxc_almacen, cxc_caja, consecutivo)
      references cxc_recibo1 (almacen, caja, consecutivo)
      on delete restrict on update cascade;

alter table cxc_recibo1
   add constraint fk_cxc_reci_reference_fac_caja foreign key (caja, almacen)
      references fac_cajas (caja, almacen)
      on delete restrict on update restrict;

alter table cxc_recibo2
   add constraint fk_cxc_reci_reference_cxc_reci foreign key (almacen, caja, consecutivo)
      references cxc_recibo1 (almacen, caja, consecutivo)
      on delete cascade on update cascade;

alter table cxc_recibo3
   add constraint fk_cxc_reci_reference_cxc_reci foreign key (almacen, caja, consecutivo)
      references cxc_recibo1 (almacen, caja, consecutivo)
      on delete cascade on update cascade;

alter table cxc_recibo4
   add constraint fk_cxc_reci_reference_cxc_reci foreign key (almacen, caja, consecutivo)
      references cxc_recibo1 (almacen, caja, consecutivo)
      on delete cascade on update cascade;

alter table rela_cxc_recibo1_cglposteo
   add constraint fk_rela_cxc_reference_cxc_reci foreign key (almacen, caja, cxc_consecutivo)
      references cxc_recibo1 (almacen, caja, consecutivo)
      on delete cascade on update cascade;



commit work;





