%% ============================================================
%%   Database name:  MODEL_2                                   
%%   DBMS name:      Sybase SQL Anywhere                       
%%   Created on:     27/09/99  4:57 PM                         
%% ============================================================

if exists(select 1 from sys.systable where table_name='Encuesta' and table_type='BASE') then
   drop table Encuesta
end if
/

if exists(select 1 from sys.systable where table_name='Tipo_de_Empresa' and table_type='BASE') then
   drop table Tipo_de_Empresa
end if
/

if exists(select 1 from sys.systable where table_name='Origen_del_Sistema' and table_type='BASE') then
   drop table Origen_del_Sistema
end if
/

if exists(select 1 from sys.systable where table_name='Cantidad_de_Empleados' and table_type='BASE') then
   drop table Cantidad_de_Empleados
end if
/

create datatype T_money numeric(19,4)  
/

create datatype T_smallmoney numeric(10,4)  
/

create datatype T_datetime timestamp  
/

create datatype T_smalldatetime timestamp  
/

create datatype T_text long varchar  
/

create datatype T_image long binary  
/

create datatype T_bit tinyint not null 
/

create datatype T_sysname varchar(30) not null 
/

create table DBA.cglauxiliares
(
    codigo             char(10)              not null,
    nombre             char(30)              not null,
    primary key (codigo)
)
/

create table DBA.cglconceptos
(
    codigo             char(3)               not null,
    descripcion        char(50)              not null,
    primary key (codigo)
)
/

create table DBA.cglniveles
(
    nivel              char(2)               not null,
    descripcion        char(30)              not null,
    posicion_inicial   smallint              not null,
    posicion_final     smallint              not null,
    recibe             char(1)                       ,
    primary key (nivel)
)
/

create table DBA.gralaplicaciones
(
    aplicacion         char(3)               not null,
    descripcion        char(20)              not null,
    menu               char(20)              not null,
    primary key (aplicacion)
)
/

create table DBA.gralcompanias
(
    compania           char(2)               not null,
    nombre             char(30)              not null,
    direccion          char(30)              not null,
    id_tributario      char(20)              not null,
    primary key (compania)
)
/

create table DBA.cglcuentas
(
    cuenta             char(24)              not null,
    nombre             char(30)              not null,
    nivel              char(2)               not null,
    naturaleza         smallint              not null,
    auxiliar_1         char(1)               not null,
    auxiliar_2         char(1)               not null,
    efectivo           char(1)               not null,
    tipo_cuenta        char(1)               not null,
    primary key (cuenta),
    check (
            (auxiliar_1='S' or auxiliar_1='N') and (auxiliar_2='S' or auxiliar_2='N') and (efectivo='S' or efectivo='N') and (naturaleza=1 or naturaleza=-1) and (tipo_cuenta='B' or tipo_cuenta='R'))
)
/

create table DBA.cglperiodico2
(
    compania           char(2)               not null,
    num_transaccion    integer               not null,
    cuenta             char(24)              not null,
    monto              numeric(10,2)         not null,
    primary key (compania, num_transaccion, cuenta)
)
/

create table DBA.cglsaux1_anual
(
    compania           char(2)               not null,
    cuenta             char(24)              not null,
    auxiliar           char(10)              not null,
    year               smallint              not null,
    saldo_inicial      numeric(10,2)         not null,
    primary key (compania, cuenta, auxiliar, year)
)
/

create table DBA.cglsaux2_anual
(
    compania           char(2)               not null,
    cuenta             char(24)              not null,
    auxiliar           char(10)              not null,
    year               smallint              not null,
    saldo_inicial      numeric(10,2)         not null,
    primary key (compania, cuenta, auxiliar, year)
)
/

create table DBA.cglsctas_anual
(
    compania           char(2)               not null,
    cuenta             char(24)              not null,
    year               smallint              not null,
    saldo_inicial      numeric(10,2)         not null,
    primary key (compania, cuenta, year)
)
/

create table DBA.cglcomprobante2
(
    cuenta             char(24)              not null,
    secuencia          integer               not null,
    compania           char(2)               not null,
    aplicacion         char(3)               not null,
    year               smallint              not null,
    periodo            smallint              not null,
    monto              numeric(10,2)         not null,
    primary key (cuenta, secuencia, compania, aplicacion, year, periodo)
)
/

create table DBA.gralparametros
(
    parametro          char(20)              not null,
    aplicacion         char(3)               not null,
    descripcion        char(40)              not null,
    primary key (parametro, aplicacion)
)
/

create table gralsecuencias
(
    aplicacion         char(3)               not null,
    parametro          char(20)              not null,
    descripcion        char(40)              not null,
    primary key (aplicacion, parametro)
)
/

create table DBA.cglperiodico1
(
    compania           char(2)               not null,
    num_transaccion    integer               not null,
    concepto           char(3)               not null,
    estado             char(1)               not null,
    usuario_captura    char(10)              not null,
    usuario_actulizo   char(10)              not null,
    fecha_captura      timestamp                     ,
    fecha_actualizo    timestamp                     ,
    descripcion        char(50)              not null,
    primary key (compania, num_transaccion)
)
/

create table DBA.gralperiodos
(
    compania           char(2)               not null,
    aplicacion         char(3)               not null,
    year               smallint              not null,
    periodo            smallint              not null,
    descripcion        char(20)              not null,
    inicio             date                  not null,
    final              date                  not null,
    estado             char(1)               not null,
    primary key (compania, aplicacion, year, periodo),
    check (
            estado='A' or estado='I')
)
/

create table DBA.cglcomprobante1
(
    secuencia          integer               not null,
    aplicacion_origen  char(3)               not null,
    concepto           char(3)               not null,
    compania           char(2)               not null,
    aplicacion         char(3)               not null,
    year               smallint              not null,
    periodo            smallint              not null,
    estado             char(1)               not null,
    usuario_captura    char(10)              not null,
    usuario_actualiza  char(10)              not null,
    fecha_comprobante  date                  not null,
    fecha_captura      timestamp                     ,
    fecha_actualiza    timestamp                     ,
    descripcion        char(50)              not null,
    primary key (secuencia, compania, aplicacion, year, periodo)
)
/

create table DBA.cglcomprobante3
(
    auxiliar1          char(10)              not null,
    cuenta             char(24)              not null,
    secuencia          integer               not null,
    compania           char(2)               not null,
    aplicacion         char(3)               not null,
    year               smallint              not null,
    periodo            smallint              not null,
    monto              numeric(10,2)         not null,
    primary key (auxiliar1, cuenta, secuencia, compania, aplicacion, year, periodo)
)
/

create table DBA.cglcomprobante4
(
    auxiliar2          char(10)              not null,
    cuenta             char(24)              not null,
    secuencia          integer               not null,
    compania           char(2)               not null,
    aplicacion         char(3)               not null,
    year               smallint              not null,
    periodo            smallint              not null,
    monto              numeric(10,2)         not null,
    primary key (auxiliar2, cuenta, secuencia, compania, aplicacion, year, periodo)
)
/

create table DBA.cglhistposteo
(
    consecutivo        integer               not null,
    compania           char(2)               not null,
    cuenta             char(24)              not null,
    auxiliar_1         char(10)                      ,
    auxiliar_2         char(10)                      ,
    monto              numeric(10,2)         not null,
    comprobante        char(10)              not null,
    fecha_posteo       date                  not null,
    concepto           char(3)               not null,
    descripcion        char(50)              not null,
    usuario_capturo    char(10)              not null,
    usuario_actualizo  char(10)              not null,
    fecha_captura      timestamp                     ,
    fecha_actualiza    timestamp                     ,
    aplicacion_origen  char(3)               not null,
    referencia         integer               not null,
    estado             char(1)               not null,
    primary key (consecutivo)
)
/

create table DBA.cglperiodico3
(
    compania           char(2)               not null,
    num_transaccion    integer               not null,
    cuenta             char(24)              not null,
    auxiliar1          char(10)              not null,
    monto              numeric(10,2)         not null,
    primary key (compania, num_transaccion, cuenta, auxiliar1)
)
/

create table DBA.cglperiodico4
(
    compania           char(2)               not null,
    num_transaccion    integer               not null,
    cuenta             char(24)              not null,
    auxiliar2          char(10)              not null,
    monto              numeric(10,2)         not null,
    primary key (compania, num_transaccion, cuenta, auxiliar2)
)
/

create table DBA.cglpervalidos
(
    compania           char(2)               not null,
    num_transaccion    integer               not null,
    aplicacion         char(3)               not null,
    year               smallint              not null,
    mes                smallint              not null,
    primary key (compania, num_transaccion, aplicacion, year, mes)
)
/

create table DBA.cglposteo
(
    consecutivo        integer               not null
        default autoincrement,
    compania           char(2)               not null,
    cuenta             char(24)              not null,
    auxiliar_1         char(10)                      ,
    auxiliar_2         char(10)                      ,
    monto              numeric(10,2)         not null,
    comprobante        char(10)              not null,
    fecha_posteo       date                  not null,
    concepto           char(3)               not null,
    descripcion        char(50)              not null,
    usuario_capturo    char(10)              not null,
    usuario_actualizo  char(10)              not null,
    fecha_captura      timestamp                     ,
    fecha_actualiza    timestamp                     ,
    aplicacion_origen  char(3)               not null,
    referencia         integer               not null,
    estado             char(1)               not null,
    primary key (consecutivo)
)
/

create table DBA.cglsaux1_mensual
(
    compania           char(2)               not null,
    cuenta             char(24)              not null,
    auxiliar           char(10)              not null,
    year               smallint              not null,
    mes                smallint              not null,
    debito             numeric(10,2)         not null,
    credito            numeric(10,2)         not null,
    balance            numeric(10,2)         not null,
    primary key (compania, cuenta, auxiliar, year, mes)
)
/

create table DBA.cglsaux2_mensual
(
    compania           char(2)               not null,
    cuenta             char(24)              not null,
    auxiliar           char(10)              not null,
    year               smallint              not null,
    mes                smallint              not null,
    debito             numeric(10,2)         not null,
    credito            numeric(10,2)         not null,
    balance            numeric(10,2)         not null,
    primary key (compania, cuenta, auxiliar, year, mes)
)
/

create table DBA.cglsctas_mensual
(
    compania           char(2)               not null,
    cuenta             char(24)              not null,
    year               smallint              not null,
    mes                smallint              not null,
    debito             numeric(10,2)         not null,
    credito            numeric(10,2)         not null,
    balance            numeric(10,2)         not null,
    primary key (compania, cuenta, year, mes)
)
/

create table gralparaxcia
(
    compania           char(2)               not null,
    parametro          char(20)              not null,
    aplicacion         char(3)               not null,
    valor              char(20)              not null,
    primary key (compania, parametro, aplicacion)
)
/

create table gralsecxcia
(
    aplicacion         char(3)               not null,
    parametro          char(20)              not null,
    compania           char(2)               not null,
    gra_aplicacion     char(3)               not null,
    year               smallint              not null,
    periodo            smallint              not null,
    secuencia          integer               not null,
    primary key (aplicacion, parametro, compania, gra_aplicacion, year, periodo)
)
/

alter table DBA.cglcuentas
    add foreign key cglniveles (nivel)
       references DBA.cglniveles (nivel) on update restrict on delete restrict
/

alter table DBA.cglperiodico2
    add foreign key cglcuentas (cuenta)
       references DBA.cglcuentas (cuenta) on update restrict on delete restrict
/

alter table DBA.cglperiodico2
    add foreign key cglperiodico1 (compania, num_transaccion, num_transaccion)
       references DBA.cglperiodico1 (compania, num_transaccion, num_transaccion) on update restrict on delete restrict
/

alter table DBA.cglsaux1_anual
    add foreign key cglauxiliares (auxiliar)
       references DBA.cglauxiliares (codigo) on update restrict on delete restrict
/

alter table DBA.cglsaux1_anual
    add foreign key cglcuentas (cuenta)
       references DBA.cglcuentas (cuenta) on update restrict on delete restrict
/

alter table DBA.cglsaux1_anual
    add foreign key gralcompanias (compania)
       references DBA.gralcompanias (compania) on update restrict on delete restrict
/

alter table DBA.cglsaux2_anual
    add foreign key cglauxiliares (auxiliar)
       references DBA.cglauxiliares (codigo) on update restrict on delete restrict
/

alter table DBA.cglsaux2_anual
    add foreign key cglcuentas (cuenta)
       references DBA.cglcuentas (cuenta) on update restrict on delete restrict
/

alter table DBA.cglsaux2_anual
    add foreign key gralcompanias (compania)
       references DBA.gralcompanias (compania) on update restrict on delete restrict
/

alter table DBA.cglsctas_anual
    add foreign key cglcuentas (cuenta)
       references DBA.cglcuentas (cuenta) on update restrict on delete restrict
/

alter table DBA.cglsctas_anual
    add foreign key gralcompanias (compania)
       references DBA.gralcompanias (compania) on update restrict on delete restrict
/

alter table DBA.cglcomprobante2
    add foreign key FK_CGLCOMPR_REF_759_CGLCUENT (cuenta)
       references DBA.cglcuentas (cuenta) on update restrict on delete restrict
/

alter table DBA.cglcomprobante2
    add foreign key FK_CGLCOMPR_REF_763_CGLCOMPR (secuencia, compania, aplicacion, year, periodo)
       references DBA.cglcomprobante1 (secuencia, compania, aplicacion, year, periodo) on update restrict on delete restrict
/

alter table DBA.gralparametros
    add foreign key FK_GRALPARA_REF_687_GRALAPLI (aplicacion)
       references DBA.gralaplicaciones (aplicacion) on update restrict on delete restrict
/

alter table gralsecuencias
    add foreign key FK_GRALSECU_REF_707_GRALAPLI (aplicacion)
       references DBA.gralaplicaciones (aplicacion) on update restrict on delete restrict
/

alter table DBA.cglperiodico1
    add foreign key cglconceptos (concepto)
       references DBA.cglconceptos (codigo) on update restrict on delete restrict
/

alter table DBA.cglperiodico1
    add foreign key gralcompanias (compania)
       references DBA.gralcompanias (compania) on update restrict on delete restrict
/

alter table DBA.gralperiodos
    add foreign key gralcompanias (compania)
       references DBA.gralcompanias (compania) on update restrict on delete restrict
/

alter table DBA.cglcomprobante1
    add foreign key cglconceptos (concepto)
       references DBA.cglconceptos (codigo) on update restrict on delete restrict
/

alter table DBA.cglcomprobante1
    add foreign key gralaplicaciones (aplicacion_origen)
       references DBA.gralaplicaciones (aplicacion) on update restrict on delete restrict
/

alter table DBA.cglcomprobante1
    add foreign key FK_CGLCOMPR_REF_737_GRALPERI (compania, aplicacion, year, periodo)
       references DBA.gralperiodos (compania, aplicacion, year, periodo) on update restrict on delete restrict
/

alter table DBA.cglcomprobante3
    add foreign key cglauxiliares (auxiliar1)
       references DBA.cglauxiliares (codigo) on update restrict on delete restrict
/

alter table DBA.cglcomprobante3
    add foreign key FK_CGLCOMPR_REF_779_CGLCOMPR (cuenta, secuencia, compania, aplicacion, year, periodo)
       references DBA.cglcomprobante2 (cuenta, secuencia, compania, aplicacion, year, periodo) on update restrict on delete restrict
/

alter table DBA.cglcomprobante4
    add foreign key cglauxiliares (auxiliar2)
       references DBA.cglauxiliares (codigo) on update restrict on delete restrict
/

alter table DBA.cglcomprobante4
    add foreign key FK_CGLCOMPR_REF_798_CGLCOMPR (cuenta, secuencia, compania, aplicacion, year, periodo)
       references DBA.cglcomprobante2 (cuenta, secuencia, compania, aplicacion, year, periodo) on update restrict on delete restrict
/

alter table DBA.cglhistposteo
    add foreign key cglauxiliares (auxiliar_1)
       references DBA.cglauxiliares (codigo) on update restrict on delete restrict
/

alter table DBA.cglhistposteo
    add foreign key cglauxiliares001 (auxiliar_2)
       references DBA.cglauxiliares (codigo) on update restrict on delete restrict
/

alter table DBA.cglhistposteo
    add foreign key cglconceptos (concepto)
       references DBA.cglconceptos (codigo) on update restrict on delete restrict
/

alter table DBA.cglhistposteo
    add foreign key cglcuentas (cuenta)
       references DBA.cglcuentas (cuenta) on update restrict on delete restrict
/

alter table DBA.cglhistposteo
    add foreign key gralcompanias (compania)
       references DBA.gralcompanias (compania) on update restrict on delete restrict
/

alter table DBA.cglperiodico3
    add foreign key cglauxiliares (auxiliar1)
       references DBA.cglauxiliares (codigo) on update restrict on delete restrict
/

alter table DBA.cglperiodico3
    add foreign key cglperiodico2 (compania, num_transaccion, cuenta, num_transaccion, cuenta)
       references DBA.cglperiodico2 (compania, num_transaccion, cuenta, num_transaccion, cuenta) on update restrict on delete restrict
/

alter table DBA.cglperiodico4
    add foreign key cglauxiliares (auxiliar2)
       references DBA.cglauxiliares (codigo) on update restrict on delete restrict
/

alter table DBA.cglperiodico4
    add foreign key cglperiodico2 (compania)
       references DBA.cglperiodico2 (compania) on update restrict on delete restrict
/

alter table DBA.cglpervalidos
    add foreign key cglperiodico1 (compania)
       references DBA.cglperiodico1 (compania) on update restrict on delete restrict
/

alter table DBA.cglposteo
    add foreign key cglauxiliares (auxiliar_1)
       references DBA.cglauxiliares (codigo) on update restrict on delete restrict
/

alter table DBA.cglposteo
    add foreign key cglauxiliares001 (auxiliar_2)
       references DBA.cglauxiliares (codigo) on update restrict on delete restrict
/

alter table DBA.cglposteo
    add foreign key cglconceptos (concepto)
       references DBA.cglconceptos (codigo) on update restrict on delete restrict
/

alter table DBA.cglposteo
    add foreign key cglcuentas (cuenta)
       references DBA.cglcuentas (cuenta) on update restrict on delete restrict
/

alter table DBA.cglposteo
    add foreign key gralcompanias (compania)
       references DBA.gralcompanias (compania) on update restrict on delete restrict
/

alter table DBA.cglsaux1_mensual
    add foreign key cglsaux1_anual (compania, cuenta, auxiliar, year)
       references DBA.cglsaux1_anual (compania, cuenta, auxiliar, year) on update restrict on delete restrict
/

alter table DBA.cglsaux2_mensual
    add foreign key cglsaux2_anual (compania, cuenta, auxiliar, year)
       references DBA.cglsaux2_anual (compania, cuenta, auxiliar, year) on update restrict on delete restrict
/

alter table DBA.cglsctas_mensual
    add foreign key cglsctas_anual (compania, cuenta, year)
       references DBA.cglsctas_anual (compania, cuenta, year) on update restrict on delete restrict
/

alter table gralparaxcia
    add foreign key FK_GRALPARA_REF_692_GRALCOMP (compania)
       references DBA.gralcompanias (compania) on update restrict on delete restrict
/

alter table gralparaxcia
    add foreign key FK_GRALPARA_REF_697_GRALPARA (parametro, aplicacion)
       references DBA.gralparametros (parametro, aplicacion) on update restrict on delete restrict
/

alter table gralsecxcia
    add foreign key FK_GRALSECX_REF_714_GRALSECU (aplicacion, parametro)
       references gralsecuencias (aplicacion, parametro) on update restrict on delete restrict
/

alter table gralsecxcia
    add foreign key FK_GRALSECX_REF_721_GRALPERI (compania, year, periodo, aplicacion)
       references DBA.gralperiodos (compania, year, periodo, aplicacion) on update restrict on delete restrict
/

commit
/

