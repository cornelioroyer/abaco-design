/*==============================================================*/
/* Database name:  Database                                     */
/* DBMS name:      PostgreSQL 7                                 */
/* Created on:     19-01-2002 7:42:44 PM                        */
/*==============================================================*/


begin work;
//drop table tmp_cglcuentas;

/*==============================================================*/
/* Table : tmp_cglcuentas                                       */
/*==============================================================*/
create table tmp_cglcuentas (
cuenta               char(24)             not null default '24',
nombre               char(30)             not null default '30',
nivel                char(2)              not null default '2',
naturaleza           int4                 not null default 11,
auxiliar_1           char(1)              not null default '1',
auxiliar_2           char(1)              not null default '1',
efectivo             char(1)              not null default '1',
tipo_cuenta          char(1)              not null default '1'
);

insert into tmp_cglcuentas (cuenta, nombre, nivel, naturaleza, auxiliar_1, auxiliar_2, efectivo, tipo_cuenta)
select cuenta, nombre, nivel, naturaleza, auxiliar_1, auxiliar_2, efectivo, tipo_cuenta
from cglcuentas;

drop table cglcuentas;


/*==============================================================*/
/* Table : cglcuentas                                           */
/*==============================================================*/
create table cglcuentas (
cuenta               CHAR(24)             not null,
nombre               CHAR(30)             not null,
nivel                CHAR(2)              not null,
naturaleza           INT4                 not null,
auxiliar_1           CHAR(1)              not null,
auxiliar_2           CHAR(1)              not null,
efectivo             CHAR(1)              not null,
tipo_cuenta          CHAR(1)              not null,
status               char(1)              not null 
      constraint CKC_STATUS_CGLCUENT check (status in ('A','I')),
constraint PK_CGLCUENTAS primary key (cuenta),
check ((auxiliar_1='S' or auxiliar_1='N') and (auxiliar_2='S' or auxiliar_2='N') 
and (efectivo='S' or efectivo='N') and (naturaleza=1 or naturaleza=-1) 
and (tipo_cuenta='B' or tipo_cuenta='R'))
);

insert into cglcuentas (cuenta, nombre, nivel, naturaleza, auxiliar_1, auxiliar_2, efectivo, tipo_cuenta, status)
select cuenta, nombre, nivel, naturaleza, auxiliar_1, auxiliar_2, efectivo, tipo_cuenta, 'A'
from tmp_cglcuentas;

drop table tmp_cglcuentas;

/*==============================================================*/
/* Index: i_nombre                                              */
/*==============================================================*/
create unique index i_nombre on cglcuentas (
nombre
);

alter table cglcuentas
   add constraint cglniveles foreign key (nivel)
      references cglniveles (nivel)
      on delete restrict on update restrict;

alter table cglctasxaplicacion
   add constraint FK_CGLCTASX_REF_944_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table gral_impuestos
   add constraint FK_GRAL_IMP_REF_60462_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table cglsldocuenta
   add constraint FK_CGLSLDOC_REF_7296_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table cglsldoaux1
   add constraint FK_CGLSLDOA_REF_7300_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table cglsldoaux2
   add constraint FK_CGLSLDOA_REF_7304_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table cglposteo
   add constraint FK_CGLPOSTE_REF_8363_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table cglcomprobante2
   add constraint FK_CGLCOMPR_REF_7501_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table cglperiodico2
   add constraint FK_CGLPERIO_REF_7899_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table proveedores
   add constraint FK_PROVEEDO_REF_22652_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table cxpajuste3
   add constraint FK_CXPAJUST_REF_25804_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table bcoctas
   add constraint FK_BCOCTAS_REF_27103_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table bcotransac2
   add constraint FK_BCOTRANS_REF_30991_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table cxctrx3
   add constraint FK_CXCTRX3_REF_32532_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table clientes
   add constraint FK_CLIENTES_REF_32562_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table rhuempl
   add constraint FK_RHUEMPL_REF_19061_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table pla_afectacion_contable
   add constraint FK_PLA_AFEC_REFERENCE_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table rubros_fact_cxp
   add constraint FK_RUBROS_F_REF_22631_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table bcocheck2
   add constraint FK_BCOCHECK_REF_28345_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table cxcfact2
   add constraint FK_CXCFACT2_REF_35575_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table rubros_fact_cxc
   add constraint FK_RUBROS_F_REF_35579_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table eys3
   add constraint FK_EYS3_REF_42010_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table articulos_por_almacen
   add constraint FK_ARTICULO_REF_42015_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table cxpfact2
   add constraint FK_CXPFACT2_REF_64317_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table cajas
   add constraint FK_CAJAS_REF_11559_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table afi_tipo_activo
   add constraint FK_AFI_TIPO_REF_11774_CGLCUENT foreign key (cuenta_activo)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table afi_tipo_activo
   add constraint FK_AFI_TIPO_REF_11775_CGLCUENT foreign key (cuenta_depreciacion)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table afi_tipo_activo
   add constraint FK_AFI_TIPO_REF_11995_CGLCUENT foreign key (cuenta_gasto)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table caja_trx2
   add constraint FK_CAJA_TRX_REF_12852_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table facparamcgl
   add constraint FK_FACPARAM_REF_14736_CGLCUENT foreign key (cuenta_ingreso)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table facparamcgl
   add constraint FK_FACPARAM_REF_17908_CGLCUENT foreign key (cuenta_costo)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table nomacrem
   add constraint FK_NOMACREM_REF_19292_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table nomconce
   add constraint FK_NOMCONCE_REFERENCE_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

commit work;

