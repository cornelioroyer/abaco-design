drop table tmp_bcocircula;
create table tmp_bcocircula as select * from bcocircula;

begin work;
drop table bcocircula;

/*==============================================================*/
/* Table : bcocircula                                           */
/*==============================================================*/
create table bcocircula (
sec_docmto_circula   INT4                 not null,
cod_ctabco           CHAR(2)              not null,
motivo_bco           CHAR(2)              not null,
proveedor            CHAR(6)              null,
no_docmto_sys        INT4                 not null,
no_docmto_fuente     CHAR(10)             not null,
fecha_transacc       DATE                 not null,
fecha_posteo         DATE                 not null,
status               CHAR(1)              not null,
usuario              CHAR(10)             not null,
fecha_captura        TIMESTAMP            not null,
a_nombre             CHAR(60)             null,
desc_documento       TEXT                 null,
monto                DECIMAL(10,2)        not null,
constraint PK_BCOCIRCULA primary key (sec_docmto_circula),
constraint FK_BCOCIRCU_REF_31026_BCOCTAS foreign key (cod_ctabco)
   references bcoctas (cod_ctabco)
   on delete restrict on update restrict,
constraint FK_BCOCIRCU_REF_31032_BCOMOTIV foreign key (motivo_bco)
   references bcomotivos (motivo_bco)
   on delete restrict on update restrict,
constraint FK_BCOCIRCU_REF_31042_PROVEEDO foreign key (proveedor)
   references proveedores (proveedor)
   on delete restrict on update restrict
);


insert into bcocircula
select sec_docmto_circula, cod_ctabco, motivo_bco,
proveedor, no_docmto_sys, no_docmto_fuente, fecha_transacc,
fecha_posteo, status, usuario, fecha_captura, a_nombre,
desc_documento, monto from tmp_bcocircula;
commit work;