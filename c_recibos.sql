drop index i1_cxc_recibo1 cascade;

drop index i2_cxc_recibo1 cascade;

drop table cxc_recibo1 cascade;

/*==============================================================*/
/* Table: cxc_recibo1                                           */
/*==============================================================*/
create table cxc_recibo1 (
almacen              CHAR(2)              not null,
consecutivo          INT4                 not null,
motivo_cxc           CHAR(3)              not null,
cliente              CHAR(10)             not null,
nombre               char(60)             not null,
cobrador             CHAR(2)              not null,
documento            char(25)             not null,
fecha                date                 not null,
status               char(1)              not null,
usuario              char(10)             not null,
fecha_captura        TIMESTAMP            not null,
cheque               decimal(10,2)        not null,
efectivo             decimal(10,2)        not null,
otro                 decimal(10,2)        not null,
referencia           char(40)             null,
observacion          TEXT                 null,
constraint PK_CXC_RECIBO1 primary key (almacen, consecutivo)
);

/*==============================================================*/
/* Index: i1_cxc_recibo1                                        */
/*==============================================================*/
create unique index i1_cxc_recibo1 on cxc_recibo1 (
almacen,
consecutivo
);

/*==============================================================*/
/* Index: i2_cxc_recibo1                                        */
/*==============================================================*/
create unique index i2_cxc_recibo1 on cxc_recibo1 (
almacen,
documento
);

alter table cxc_recibo1
   add constraint FK_CXC_RECI_REFERENCE_ALMACEN foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update restrict;

alter table cxc_recibo1
   add constraint FK_CXC_RECI_REFERENCE_CXCMOTIV foreign key (motivo_cxc)
      references cxcmotivos (motivo_cxc)
      on delete restrict on update restrict;

alter table cxc_recibo1
   add constraint FK_CXC_RECI_REFERENCE_CLIENTES foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update restrict;

alter table cxc_recibo1
   add constraint FK_CXC_RECI_REFERENCE_COBRADOR foreign key (cobrador)
      references cobradores (cobrador)
      on delete restrict on update cascade;
drop index i1_cxc_recibo2;

drop index i2_cxc_recibo2;

drop table cxc_recibo2;

/*==============================================================*/
/* Table: cxc_recibo2                                           */
/*==============================================================*/
create table cxc_recibo2 (
almacen              CHAR(2)              not null,
consecutivo          INT4                 not null,
almacen_aplicar      char(2)              not null,
documento_aplicar    char(25)             not null,
motivo_aplicar       char(3)              not null,
monto_aplicar        decimal(10,2)        not null,
constraint PK_CXC_RECIBO2 primary key (almacen, consecutivo, almacen_aplicar, documento_aplicar, motivo_aplicar)
);

/*==============================================================*/
/* Index: i1_cxc_recibo2                                        */
/*==============================================================*/
create unique index i1_cxc_recibo2 on cxc_recibo2 (
almacen,
consecutivo,
almacen_aplicar,
documento_aplicar,
motivo_aplicar
);

/*==============================================================*/
/* Index: i2_cxc_recibo2                                        */
/*==============================================================*/
create  index i2_cxc_recibo2 on cxc_recibo2 (
almacen,
consecutivo
);

alter table cxc_recibo2
   add constraint FK_CXC_RECI_REFERENCE_CXC_RECI foreign key (almacen, consecutivo)
      references cxc_recibo1 (almacen, consecutivo)
      on delete cascade on update cascade;
drop index i1_cxc_recibo3;

drop index i2_cxc_recibo3;

drop table cxc_recibo3;

/*==============================================================*/
/* Table: cxc_recibo3                                           */
/*==============================================================*/
create table cxc_recibo3 (
almacen              CHAR(2)              not null,
consecutivo          INT4                 not null,
linea                INT4                 not null,
cuenta               CHAR(24)             not null,
auxiliar             CHAR(10)             null,
monto                decimal(10,2)        not null,
constraint PK_CXC_RECIBO3 primary key (almacen, consecutivo, linea)
);

/*==============================================================*/
/* Index: i1_cxc_recibo3                                        */
/*==============================================================*/
create unique index i1_cxc_recibo3 on cxc_recibo3 (
almacen,
consecutivo,
linea
);

/*==============================================================*/
/* Index: i2_cxc_recibo3                                        */
/*==============================================================*/
create  index i2_cxc_recibo3 on cxc_recibo3 (
almacen,
consecutivo
);

alter table cxc_recibo3
   add constraint FK_CXC_RECI_REFERENCE_CXC_RECI foreign key (almacen, consecutivo)
      references cxc_recibo1 (almacen, consecutivo)
      on delete cascade on update cascade;

alter table cxc_recibo3
   add constraint FK_CXC_RECI_REFERENCE_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table cxc_recibo3
   add constraint FK_CXC_RECI_REFERENCE_CGLAUXIL foreign key (auxiliar)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;
      
drop table cxc_recibo4 cascade;

/*==============================================================*/
/* Table: cxc_recibo4                                           */
/*==============================================================*/
create table cxc_recibo4 (
almacen              CHAR(2)              not null,
consecutivo          INT4                 not null,
la_suma_de           char(100)            not null,
forma_d_pago         char(20)             not null,
aplicar_a            text                 null,
titulo               char(60)             not null,
usuario              char(10)             not null,
constraint PK_CXC_RECIBO4 primary key (almacen, consecutivo)
);

alter table cxc_recibo4
   add constraint FK_CXC_RECI_REFERENCE_CXC_RECI foreign key (almacen, consecutivo)
      references cxc_recibo1 (almacen, consecutivo)
      on delete cascade on update cascade;
drop table cxc_recibo5;

/*==============================================================*/
/* Table: cxc_recibo5                                           */
/*==============================================================*/
create table cxc_recibo5 (
almacen              CHAR(2)              not null,
consecutivo          INT4                 not null,
aplicar_a            char(25)             not null,
monto                decimal(10,2)        not null,
referencia1          char(100)            null,
referencia2          char(100)            null,
constraint PK_CXC_RECIBO5 primary key (almacen, consecutivo, aplicar_a, monto)
);

alter table cxc_recibo5
   add constraint FK_CXC_RECI_REFERENCE_CXC_RECI foreign key (almacen, consecutivo)
      references cxc_recibo4 (almacen, consecutivo)
      on delete cascade on update cascade;
      
