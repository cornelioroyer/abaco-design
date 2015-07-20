/*==============================================================*/
/* Database name:  Database                                     */
/* DBMS name:      PostgreSQL 7                                 */
/* Created on:     19-01-2002 7:31:45 PM                        */
/*==============================================================*/


drop table tmp_rhuempl;

begin work;
/*==============================================================*/
/* Table : tmp_rhuempl                                          */
/*==============================================================*/
create table tmp_rhuempl (
codigo_empleado      char(7)              not null,
codigo_cargo         char(2)              not null,
apellido_paterno     char(30),
apellido_materno     char(30),
apellido_casada      char(30),
primer_nombre        char(30)             not null,
segundo_nombre       char(30),
nombre_del_empleado  char(50),
tipo_contrato        char(1),
estado_civil         char(1)              not null default '1',
fecha_inicio         date                 not null,
fecha_terminacion    date,
fecha_nacimiento     date                 not null,
fecha_ulti_aumento   date,
tipo_de_salario      char(1)              not null default '1',
salario_bruto        numeric(7,2)         not null default 9,
rata_por_hora        numeric(6,2)         not null default 8,
monto_ult_aumento    numeric(7,2)         not null default 9,
forma_de_pago        char(1)              not null default '1',
tipo_calculo_ir      char(1)              not null default '1',
cod_id_turnos        char(2)              not null default '2',
cuenta               char(24)             not null default '24',
compania             char(2)              not null default '2',
tipo_planilla        char(2)              not null default '2',
grup_impto_renta     char(1)              not null default '1',
num_dependiente      int4                 not null default 11,
departamento         char(3)              not null default '3',
telefono_1           char(14)             null default '14',
telefono_2           char(14)             null default '14',
status               char(1)              not null default '1',
sexo_empleado        char(1)              not null default '1',
numero_cedula        char(15)             not null default '15',
numero_ss            char(13)             null default '13',
direccion1           char(50)             null default '50',
direccion2           char(50)             null default '50',
direccion3           char(50)             null default '50',
direccion4           char(50)             null default '50',
cta_bco_empleado     char(20)             null default '20',
tipo_d_turno         char(1)              not null default '1',
tasaporhora          numeric(12,5)        null default 14,
sindicalizado        char(1)              null default '1',
turnosabado          char(2)              null default '2'
);

insert into tmp_rhuempl (codigo_empleado, codigo_cargo, apellido_paterno, apellido_materno, apellido_casada, 
primer_nombre, segundo_nombre, nombre_del_empleado, tipo_contrato, estado_civil, fecha_inicio, 
fecha_terminacion, fecha_nacimiento, fecha_ulti_aumento, tipo_de_salario, salario_bruto, rata_por_hora, 
monto_ult_aumento, forma_de_pago, tipo_calculo_ir, cod_id_turnos, cuenta, compania, tipo_planilla, 
grup_impto_renta, num_dependiente, departamento, telefono_1, telefono_2, status, sexo_empleado, 
numero_cedula, numero_ss, direccion1, direccion2, direccion3, direccion4, cta_bco_empleado, 
tipo_d_turno, tasaporhora, sindicalizado, turnosabado)
select codigo_empleado, codigo_cargo, apellido_paterno, apellido_materno, apellido_casada, 
primer_nombre, segundo_nombre, nombre_del_empleado, tipo_contrato, estado_civil, fecha_inicio, 
fecha_terminacion, fecha_nacimiento, fecha_ulti_aumento, tipo_de_salario, salario_bruto, rata_por_hora, 
monto_ult_aumento, forma_de_pago, tipo_calculo_ir, cod_id_turnos, cuenta, compania, tipo_planilla, 
grup_impto_renta, num_dependiente, departamento, telefono_1, telefono_2, status, sexo_empleado, 
numero_cedula, numero_ss, direccion1, direccion2, direccion3, direccion4, cta_bco_empleado, tipo_d_turno, 
tasaporhora, sindicalizado, turnosabado
from rhuempl;

drop table rhuempl;


/*==============================================================*/
/* Table : rhuempl                                              */
/*==============================================================*/
create table rhuempl (
codigo_empleado      CHAR(7)              not null,
codigo_cargo         CHAR(2)              not null,
apellido_paterno     CHAR(30)             null,
apellido_materno     CHAR(30)             null,
apellido_casada      CHAR(30)             null,
primer_nombre        CHAR(30)             not null,
segundo_nombre       CHAR(30)             null,
nombre_del_empleado  CHAR(50)             null,
tipo_contrato        CHAR(1)              not null,
estado_civil         CHAR(1)              not null,
fecha_inicio         DATE                 not null,
fecha_terminacion    DATE                 null,
fecha_nacimiento     DATE                 not null,
fecha_ulti_aumento   DATE                 null,
tipo_de_salario      CHAR(1)              not null 
      constraint CKC_TIPO_DE_SALARIO_RHUEMPL check (tipo_de_salario in ('F','H')),
salario_bruto        DECIMAL(7,2)         not null,
monto_ult_aumento    DECIMAL(7,2)         not null,
forma_de_pago        CHAR(1)              not null 
      constraint CKC_FORMA_DE_PAGO_RHUEMPL check (forma_de_pago in ('E','C','T','N')),
tipo_calculo_ir      CHAR(1)              not null 
      constraint CKC_TIPO_CALCULO_IR_RHUEMPL check (tipo_calculo_ir in ('R','P','N')),
cod_id_turnos        CHAR(2)              not null,
cuenta               CHAR(24)             not null,
compania             CHAR(2)              not null,
tipo_planilla        CHAR(2)              not null,
grup_impto_renta     CHAR(1)              not null,
num_dependiente      INT4                 not null,
departamento         CHAR(3)              not null,
turnosabado          CHAR(2)              not null,
auxiliar             CHAR(10)             not null,
telefono_1           CHAR(14)             null,
telefono_2           CHAR(14)             null,
status               CHAR(1)              not null 
      constraint CKC_STATUS_RHUEMPL check (status in ('A','I','V','L')),
sexo_empleado        CHAR(1)              not null 
      constraint CKC_SEXO_EMPLEADO_RHUEMPL check (sexo_empleado in ('M','F')),
numero_cedula        CHAR(15)             not null,
numero_ss            CHAR(13)             null,
direccion1           CHAR(50)             null,
direccion2           CHAR(50)             null,
direccion3           CHAR(50)             null,
direccion4           CHAR(50)             null,
cta_bco_empleado     CHAR(20)             null,
tipo_d_turno         char(1)              not null 
      constraint CKC_TIPO_D_TURNO_RHUEMPL check (tipo_d_turno in ('R','F')),
tasaporhora          decimal(12,5)        not null,
sindicalizado        char(1)              not null,
constraint PK_RHUEMPL primary key (codigo_empleado, compania)
);


insert into rhuempl (codigo_empleado, codigo_cargo, apellido_paterno, apellido_materno, apellido_casada, 
primer_nombre, segundo_nombre, nombre_del_empleado, tipo_contrato, estado_civil, fecha_inicio, 
fecha_terminacion, fecha_nacimiento, fecha_ulti_aumento, 
tipo_de_salario, salario_bruto, monto_ult_aumento, forma_de_pago, tipo_calculo_ir, cod_id_turnos, cuenta, 
compania, tipo_planilla, grup_impto_renta, num_dependiente, departamento, turnosabado, auxiliar, telefono_1, 
telefono_2, status, sexo_empleado, numero_cedula, numero_ss, direccion1, direccion2, direccion3, 
direccion4, cta_bco_empleado, tipo_d_turno, tasaporhora, sindicalizado)
select codigo_empleado, codigo_cargo, apellido_paterno, apellido_materno, apellido_casada, 
primer_nombre, segundo_nombre, nombre_del_empleado, tipo_contrato, estado_civil, fecha_inicio, 
fecha_terminacion, fecha_nacimiento, fecha_ulti_aumento, tipo_de_salario, salario_bruto, monto_ult_aumento, 
forma_de_pago, tipo_calculo_ir, cod_id_turnos, cuenta, compania, tipo_planilla, grup_impto_renta, num_dependiente, 
departamento, turnosabado, '01', telefono_1, telefono_2, status, sexo_empleado, numero_cedula, 
numero_ss, direccion1, direccion2, direccion3, direccion4, cta_bco_empleado, tipo_d_turno, 
tasaporhora, sindicalizado
from tmp_rhuempl;

drop table tmp_rhuempl;

alter table rhuempl
   add constraint FK_RHUEMPL_REF_19059_RHUCARGO foreign key (codigo_cargo)
      references rhucargo (codigo_cargo)
      on delete restrict on update restrict;

alter table rhuempl
   add constraint FK_RHUEMPL_REF_19060_RHUTURNO foreign key (cod_id_turnos)
      references rhuturno (cod_id_turnos)
      on delete restrict on update restrict;

alter table rhuempl
   add constraint FK_RHUEMPL_REF_19550_NOMTPLA foreign key (tipo_planilla)
      references nomtpla (tipo_planilla)
      on delete restrict on update restrict;

alter table rhuempl
   add constraint FK_RHUEMPL_REF_20441_RHUCLVIM foreign key (grup_impto_renta, num_dependiente)
      references rhuclvim (grup_impto_renta, num_dependiente)
      on delete restrict on update restrict;

alter table rhuempl
   add constraint FK_RHUEMPL_REFERENCE_DEPARTAM foreign key (departamento)
      references departamentos (codigo)
      on delete restrict on update restrict;

alter table rhuempl
   add constraint FK_RHUEMPL_REFERENCE_RHUTURNO foreign key (turnosabado)
      references rhuturno (cod_id_turnos)
      on delete restrict on update restrict;

alter table rhuempl
   add constraint FK_RHUEMPL_REFERENCE_CGLAUXIL foreign key (auxiliar)
      references cglauxiliares (auxiliar)
      on delete restrict on update restrict;

alter table rhuempl
   add constraint FK_RHUEMPL_REF_19061_CGLCUENT foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table rhuempl
   add constraint FK_RHUEMPL_REF_19295_GRALCOMP foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update restrict;

alter table rhugremp
   add constraint FK_RHUGREMP_REF_19061_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table nom_otros_ingresos
   add constraint FK_NOM_OTRO_REF_21623_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table rhuturno_x_dia
   add constraint FK_RHUTURNO_REFERENCE_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table nomacrem
   add constraint FK_NOMACREM_REF_19291_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table pla_historial_descuentos
   add constraint FK_PLA_HIST_REFERENCE_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table pla_historial_pagos
   add constraint FK_PLA_HIST_REFERENCE_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table pla_preelaborada
   add constraint FK_PLA_PREE_REFERENCE_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table plareemplazos
   add constraint FK_PLAREEMP_REFERENCE_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table plareemplazos
   add constraint FK_PLAREEMP_REFERENCE_RHUEMPL foreign key (reemplazo, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table pladeduccionesadicionales
   add constraint FK_PLADEDUC_REFERENCE_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table placertificadosmedico
   add constraint FK_PLACERTI_REFERENCE_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table plapermisosindical
   add constraint FK_PLAPERMI_REFERENCE_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table sobre_ingresos
   add constraint FK_SOBRE_IN_REFERENCE_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table sobre_deducciones
   add constraint FK_SOBRE_DE_REFERENCE_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table sobre_totales
   add constraint FK_SOBRE_TO_REFERENCE_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table sobre_acumulados
   add constraint FK_SOBRE_AC_REFERENCE_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table sobre_desgloce
   add constraint FK_SOBRE_DE_REFERENCE_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table pla_informe
   add constraint FK_PLA_INFO_REF_23421_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table pla_saldo_acreedores
   add constraint FK_PLA_SALD_REFERENCE_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table nomhrtrab
   add constraint FK_NOMHRTRA_REF_19299_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table pla_vacacion1
   add constraint FK_PLA_VACA_REF_23155_RHUEMPL foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

commit work;