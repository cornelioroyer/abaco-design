drop index i4_rela_nomctrac_cglposteo;

drop index i3_rela_nomctrac_cglposteo;

drop index i2_rela_nomctrac_cglposteo;

drop index i1_rela_nomctrac_cglposteo;


/*==============================================================*/
/* Index: i1_rela_nomctrac_cglposteo                            */
/*==============================================================*/
create unique index i1_rela_nomctrac_cglposteo on rela_nomctrac_cglposteo (
codigo_empleado,
compania,
tipo_calculo,
cod_concepto_planilla,
tipo_planilla,
numero_planilla,
year,
numero_documento,
consecutivo
);

/*==============================================================*/
/* Index: i2_rela_nomctrac_cglposteo                            */
/*==============================================================*/
create  index i2_rela_nomctrac_cglposteo on rela_nomctrac_cglposteo (
codigo_empleado,
compania,
tipo_calculo,
cod_concepto_planilla,
tipo_planilla,
numero_planilla,
year,
numero_documento
);

/*==============================================================*/
/* Index: i3_rela_nomctrac_cglposteo                            */
/*==============================================================*/
create  index i3_rela_nomctrac_cglposteo on rela_nomctrac_cglposteo (
consecutivo
);

/*==============================================================*/
/* Index: i4_rela_nomctrac_cglposteo                            */
/*==============================================================*/
create  index i4_rela_nomctrac_cglposteo on rela_nomctrac_cglposteo (
codigo_empleado,
compania,
tipo_calculo,
tipo_planilla,
numero_planilla,
year
);

alter table rela_nomctrac_cglposteo
   drop constraint fk_rela_nom_reference_nomctrac ;
alter table rela_nomctrac_cglposteo
   add constraint fk_rela_nom_reference_nomctrac foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;

alter table rela_nomctrac_cglposteo
   drop constraint fk_rela_nom_reference_cglposte ;
alter table rela_nomctrac_cglposteo
   add constraint fk_rela_nom_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;



drop index i3_pla_reservas_cglposteo;

drop index i2_pla_reservas_cglposteo;

drop index i1_pla_reservas_cglposteo;


/*==============================================================*/
/* Index: i1_pla_reservas_cglposteo                             */
/*==============================================================*/
create unique index i1_pla_reservas_cglposteo on rela_pla_reservas_cglposteo (
codigo_empleado,
compania,
tipo_calculo,
cod_concepto_planilla,
tipo_planilla,
numero_planilla,
year,
numero_documento,
concepto_reserva,
consecutivo
);

/*==============================================================*/
/* Index: i2_pla_reservas_cglposteo                             */
/*==============================================================*/
create  index i2_pla_reservas_cglposteo on rela_pla_reservas_cglposteo (
consecutivo
);

/*==============================================================*/
/* Index: i3_pla_reservas_cglposteo                             */
/*==============================================================*/
create  index i3_pla_reservas_cglposteo on rela_pla_reservas_cglposteo (
codigo_empleado,
compania,
tipo_calculo,
cod_concepto_planilla,
tipo_planilla,
numero_planilla,
year,
numero_documento,
concepto_reserva
);

alter table rela_pla_reservas_cglposteo
   drop constraint fk_rela_pla_reference_pla_rese ;
alter table rela_pla_reservas_cglposteo
   add constraint fk_rela_pla_reference_pla_rese foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento, concepto_reserva)
      references pla_reservas (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento, concepto_reserva)
      on delete cascade on update cascade;

alter table rela_pla_reservas_cglposteo
   drop constraint fk_rela_pla_reference_cglposte ;
alter table rela_pla_reservas_cglposteo
   add constraint fk_rela_pla_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;





drop index i3_pla_reservas;

drop index i2_pla_reservas;

drop index i1_pla_reservas;


/*==============================================================*/
/* Index: i1_pla_reservas                                       */
/*==============================================================*/
create unique index i1_pla_reservas on pla_reservas (
codigo_empleado,
compania,
tipo_calculo,
cod_concepto_planilla,
tipo_planilla,
numero_planilla,
year,
numero_documento,
concepto_reserva
);

/*==============================================================*/
/* Index: i2_pla_reservas                                       */
/*==============================================================*/
create  index i2_pla_reservas on pla_reservas (
codigo_empleado,
compania,
tipo_calculo,
cod_concepto_planilla,
tipo_planilla,
numero_planilla,
year,
numero_documento
);

/*==============================================================*/
/* Index: i3_pla_reservas                                       */
/*==============================================================*/
create  index i3_pla_reservas on pla_reservas (
tipo_planilla,
numero_planilla,
year
);

alter table pla_reservas
   drop constraint fk_pla_rese_reference_nomctrac ;
alter table pla_reservas
   add constraint fk_pla_rese_reference_nomctrac foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;

alter table pla_reservas
   drop constraint fk_pla_rese_reference_nomconce ;
alter table pla_reservas
   add constraint fk_pla_rese_reference_nomconce foreign key (concepto_reserva)
      references nomconce (cod_concepto_planilla)
      on delete restrict on update cascade;

alter table rela_pla_reservas_cglposteo
   drop constraint fk_rela_pla_reference_pla_rese ;
alter table rela_pla_reservas_cglposteo
   add constraint fk_rela_pla_reference_pla_rese foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento, concepto_reserva)
      references pla_reservas (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento, concepto_reserva)
      on delete cascade on update cascade;
