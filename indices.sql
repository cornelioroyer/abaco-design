





drop index i2_fac_ciudades cascade;

drop index i1_fac_ciudades cascade;

/*==============================================================*/
/* Index: i1_fac_ciudades                                       */
/*==============================================================*/
create unique index i1_fac_ciudades on fac_ciudades (
ciudad
);

/*==============================================================*/
/* Index: i2_fac_ciudades                                       */
/*==============================================================*/
create  index i2_fac_ciudades on fac_ciudades (
pais
);


alter table adc_house
   drop constraint fk_adc_hous_reference_fac_ciud ;

alter table adc_house
   add constraint fk_adc_hous_reference_fac_ciud foreign key (ciudad)
      references fac_ciudades (ciudad)
      on delete restrict on update restrict;


alter table adc_manifiesto
   drop constraint fk_adc_mani_reference_fac_ciud_origen ;

alter table adc_manifiesto
   add constraint fk_adc_mani_reference_fac_ciud_origen foreign key (ciudad_origen)
      references fac_ciudades (ciudad)
      on delete restrict on update cascade;


alter table adc_manifiesto
   drop constraint fk_adc_mani_reference_fac_ciud_destino ;

alter table adc_manifiesto
   add constraint fk_adc_mani_reference_fac_ciud_destino foreign key (ciudad_destino)
      references fac_ciudades (ciudad)
      on delete restrict on update cascade;


alter table adc_parametros_contables
   drop constraint fk_adc_para_reference_fac_ciud ;

alter table adc_parametros_contables
   add constraint fk_adc_para_reference_fac_ciud foreign key (ciudad)
      references fac_ciudades (ciudad)
      on delete restrict on update restrict;


alter table adc_si
   drop constraint fk_adc_si_ref_fac_ciud ;

alter table adc_si
   add constraint fk_adc_si_ref_fac_ciud foreign key (s_ciudad)
      references fac_ciudades (ciudad)
      on delete restrict on update restrict;


alter table adc_si
   drop constraint fk_adc_si_reference_fac_ciud ;

alter table adc_si
   add constraint fk_adc_si_reference_fac_ciud foreign key (c_ciudad)
      references fac_ciudades (ciudad)
      on delete restrict on update cascade;


alter table adc_si
   drop constraint fk_adc_si_sh_fac_ciud ;

alter table adc_si
   add constraint fk_adc_si_sh_fac_ciud foreign key (sh_ciudad)
      references fac_ciudades (ciudad)
      on delete restrict on update cascade;


alter table adc_si
   drop constraint fk_adc_si_ref2_fac_ciud ;

alter table adc_si
   add constraint fk_adc_si_ref2_fac_ciud foreign key (t_ciudad)
      references fac_ciudades (ciudad)
      on delete restrict on update restrict;


alter table adc_si
   drop constraint fk_adc_si_fd_fac_ciud ;

alter table adc_si
   add constraint fk_adc_si_fd_fac_ciud foreign key (c_final_destination)
      references fac_ciudades (ciudad)
      on delete restrict on update cascade;


alter table fac_ciudades
   drop constraint fk_fac_ciud_reference_fac_pais ;

alter table fac_ciudades
   add constraint fk_fac_ciud_reference_fac_pais foreign key (pais)
      references fac_paises (pais)
      on delete restrict on update restrict;


alter table factura1
   drop constraint fk_factura1_ciu_origen ;

alter table factura1
   add constraint fk_factura1_ciu_origen foreign key (ciudad_origen)
      references fac_ciudades (ciudad)
      on delete restrict on update restrict;


alter table factura1
   drop constraint fk_factura1_ciu_destino ;

alter table factura1
   add constraint fk_factura1_ciu_destino foreign key (ciudad_destino)
      references fac_ciudades (ciudad)
      on delete restrict on update restrict;





drop index i4_rela_nomctrac_cglposteo;

drop index i3_rela_nomctrac_cglposteo;

drop index i2_rela_nomctrac_cglposteo;

drop index i1_rela_nomctrac_cglposteo;

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




drop index i3_nomacrem;

drop index i2_nomacrem;

drop index i1_nomacrem;

create unique index i1_nomacrem on nomacrem (
numero_documento,
codigo_empleado,
cod_concepto_planilla,
compania
);

/*==============================================================*/
/* Index: i2_nomacrem                                           */
/*==============================================================*/
create  index i2_nomacrem on nomacrem (
codigo_empleado,
compania
);

/*==============================================================*/
/* Index: i3_nomacrem                                           */
/*==============================================================*/
create  index i3_nomacrem on nomacrem (
cod_concepto_planilla
);


alter table nom_ajuste_pagos_acreedores
   drop constraint fk_nom_ajus_reference_nomacrem ;

alter table nom_ajuste_pagos_acreedores
   add constraint fk_nom_ajus_reference_nomacrem foreign key (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      references nomacrem (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      on delete restrict on update cascade;


alter table nomacrem
   drop constraint fk_nomacrem_ref_19291_rhuempl ;

alter table nomacrem
   add constraint fk_nomacrem_ref_19291_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;


alter table nomacrem
   drop constraint fk_nomacrem_ref_19292_cglcuent ;

alter table nomacrem
   add constraint fk_nomacrem_ref_19292_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table nomacrem
   drop constraint fk_nomacrem_ref_19292_rhuacre ;

alter table nomacrem
   add constraint fk_nomacrem_ref_19292_rhuacre foreign key (cod_acreedores)
      references rhuacre (cod_acreedores)
      on delete restrict on update cascade;


alter table nomacrem
   drop constraint fk_nomacrem_ref_19293_nomconce ;

alter table nomacrem
   add constraint fk_nomacrem_ref_19293_nomconce foreign key (cod_concepto_planilla)
      references nomconce (cod_concepto_planilla)
      on delete restrict on update restrict;


alter table nomdedu
   drop constraint fk_nomdedu_ref_20965_nomacrem ;

alter table nomdedu
   add constraint fk_nomdedu_ref_20965_nomacrem foreign key (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      references nomacrem (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      on delete cascade on update cascade;


alter table nomdescuentos
   drop constraint fk_nomdescu_reference_nomacrem ;

alter table nomdescuentos
   add constraint fk_nomdescu_reference_nomacrem foreign key (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      references nomacrem (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      on delete restrict on update cascade;


alter table pla_balance_acreedores
   drop constraint fk_pla_bala_reference_nomacrem ;

alter table pla_balance_acreedores
   add constraint fk_pla_bala_reference_nomacrem foreign key (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      references nomacrem (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      on delete cascade on update cascade;


alter table pla_saldo_acreedores
   drop constraint fk_pla_sald_reference_nomacrem ;

alter table pla_saldo_acreedores
   add constraint fk_pla_sald_reference_nomacrem foreign key (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      references nomacrem (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      on delete restrict on update restrict;




drop index i3_nomdescuentos;

drop index i2_nomdescuentos;

drop index i1_nomdescuentos;

create unique index i1_nomdescuentos on nomdescuentos (
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
/* Index: i2_nomdescuentos                                      */
/*==============================================================*/
create  index i2_nomdescuentos on nomdescuentos (
codigo_empleado,
compania,
cod_concepto_planilla,
numero_documento
);

/*==============================================================*/
/* Index: i3_nomdescuentos                                      */
/*==============================================================*/
create  index i3_nomdescuentos on nomdescuentos (
cod_ctabco,
no_cheque,
motivo_bco
);


alter table nomdescuentos
   drop constraint fk_nomdescu_reference_nomctrac ;

alter table nomdescuentos
   add constraint fk_nomdescu_reference_nomctrac foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;


alter table nomdescuentos
   drop constraint fk_nomdescu_reference_nomacrem ;

alter table nomdescuentos
   add constraint fk_nomdescu_reference_nomacrem foreign key (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      references nomacrem (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      on delete restrict on update cascade;


alter table nomdescuentos
   drop constraint fk_nomdescu_reference_bcocheck ;

alter table nomdescuentos
   add constraint fk_nomdescu_reference_bcocheck foreign key (cod_ctabco, no_cheque, motivo_bco)
      references bcocheck1 (cod_ctabco, no_cheque, motivo_bco)
      on delete restrict on update cascade;





drop index i6_nomctrac;

drop index i5_nomctrac;

drop index i4_nomctrac;

drop index i3_nomctrac;

drop index i2_nomctrac;

drop index i1_nomctrac;

create unique index i1_nomctrac on nomctrac (
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
/* Index: i2_nomctrac                                           */
/*==============================================================*/
create  index i2_nomctrac on nomctrac (
cod_ctabco,
no_cheque,
motivo_bco
);

/*==============================================================*/
/* Index: i3_nomctrac                                           */
/*==============================================================*/
create  index i3_nomctrac on nomctrac (
compania,
codigo_empleado,
tipo_calculo,
tipo_planilla,
numero_planilla,
year,
status,
forma_de_registro,
no_cheque
);

/*==============================================================*/
/* Index: i4_nomctrac                                           */
/*==============================================================*/
create  index i4_nomctrac on nomctrac (
tipo_planilla,
numero_planilla,
year
);

/*==============================================================*/
/* Index: i5_nomctrac                                           */
/*==============================================================*/
create  index i5_nomctrac on nomctrac (
compania,
tipo_planilla,
numero_planilla,
year,
no_cheque
);

/*==============================================================*/
/* Index: i6_nomctrac                                           */
/*==============================================================*/
create  index i6_nomctrac on nomctrac (
compania,
codigo_empleado,
tipo_calculo,
tipo_planilla,
year,
numero_planilla,
no_cheque,
monto
);


alter table nomctrac
   drop constraint fk_nomctrac_ref_20713_nomtpla2 ;

alter table nomctrac
   add constraint fk_nomctrac_ref_20713_nomtpla2 foreign key (tipo_planilla, numero_planilla, year)
      references nomtpla2 (tipo_planilla, numero_planilla, year)
      on delete restrict on update restrict;


alter table nomctrac
   drop constraint fk_nomctrac_reference_nomconce ;

alter table nomctrac
   add constraint fk_nomctrac_reference_nomconce foreign key (cod_concepto_planilla)
      references nomconce (cod_concepto_planilla)
      on delete restrict on update restrict;


alter table nomctrac
   drop constraint fk_nomctrac_reference_nom_tipo ;

alter table nomctrac
   add constraint fk_nomctrac_reference_nom_tipo foreign key (tipo_calculo)
      references nom_tipo_de_calculo (tipo_calculo)
      on delete restrict on update restrict;


alter table nomctrac
   drop constraint fk_nomctrac_reference_bcocheck ;

alter table nomctrac
   add constraint fk_nomctrac_reference_bcocheck foreign key (cod_ctabco, no_cheque, motivo_bco)
      references bcocheck1 (cod_ctabco, no_cheque, motivo_bco)
      on delete restrict on update cascade;


alter table nomctrac
   drop constraint fk_nomctrac_reference_rhuempl ;

alter table nomctrac
   add constraint fk_nomctrac_reference_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;


alter table nomdescuentos
   drop constraint fk_nomdescu_reference_nomctrac ;

alter table nomdescuentos
   add constraint fk_nomdescu_reference_nomctrac foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;


alter table pla_bases_del_calculo
   drop constraint fk_pla_base_reference_nomctrac ;

alter table pla_bases_del_calculo
   add constraint fk_pla_base_reference_nomctrac foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;


alter table pla_comprobante_conceptos
   drop constraint reference_532 ;

alter table pla_comprobante_conceptos
   add constraint reference_532 foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;


alter table pla_comprobante_de_pago
   drop constraint fk_pla_comp_reference_nomctrac ;

alter table pla_comprobante_de_pago
   add constraint fk_pla_comp_reference_nomctrac foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;


alter table pla_desgloce_planilla
   drop constraint fk_pla_desg_reference_nomctrac ;

alter table pla_desgloce_planilla
   add constraint fk_pla_desg_reference_nomctrac foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;


alter table pla_desglose_planilla
   drop constraint fk_pla_desg_reference_nomctrac ;

alter table pla_desglose_planilla
   add constraint fk_pla_desg_reference_nomctrac foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;


alter table pla_planilla_semanal
   drop constraint fk_pla_plan_reference_nomctrac ;

alter table pla_planilla_semanal
   add constraint fk_pla_plan_reference_nomctrac foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;


alter table pla_reservas
   drop constraint fk_pla_rese_reference_nomctrac ;

alter table pla_reservas
   add constraint fk_pla_rese_reference_nomctrac foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;


alter table rela_nomctrac_cglposteo
   drop constraint fk_rela_nom_reference_nomctrac ;

alter table rela_nomctrac_cglposteo
   add constraint fk_rela_nom_reference_nomctrac foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;



drop index i2_cglcuentas;

drop index i1_cglcuentas;

/*==============================================================*/
/* Index: i1_cglcuentas                                         */
/*==============================================================*/
create unique index i1_cglcuentas on cglcuentas (
cuenta
);

/*==============================================================*/
/* Index: i2_cglcuentas                                         */
/*==============================================================*/
create  index i2_cglcuentas on cglcuentas (
nombre
);


alter table adc_cxc_2
   drop constraint fk_adc_cxc__reference_cglcuent ;

alter table adc_cxc_2
   add constraint fk_adc_cxc__reference_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table adc_cxp_2
   drop constraint fk_adc_cxp__reference_cglcuent ;

alter table adc_cxp_2
   add constraint fk_adc_cxp__reference_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table adc_parametros_contables
   drop constraint fk_adc_para_reference_cglcuent_ingreso ;

alter table adc_parametros_contables
   add constraint fk_adc_para_reference_cglcuent_ingreso foreign key (cta_ingreso)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table adc_parametros_contables
   drop constraint fk_adc_para_reference_cglcuent_costo ;

alter table adc_parametros_contables
   add constraint fk_adc_para_reference_cglcuent_costo foreign key (cta_costo)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table adc_parametros_contables
   drop constraint fk_adc_para_reference_cglcuent ;

alter table adc_parametros_contables
   add constraint fk_adc_para_reference_cglcuent foreign key (cta_gasto)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;


alter table afi_tipo_activo
   drop constraint fk_afi_tipo_ref_11774_cglcuent ;

alter table afi_tipo_activo
   add constraint fk_afi_tipo_ref_11774_cglcuent foreign key (cuenta_activo)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table afi_tipo_activo
   drop constraint fk_afi_tipo_ref_11775_cglcuent ;

alter table afi_tipo_activo
   add constraint fk_afi_tipo_ref_11775_cglcuent foreign key (cuenta_depreciacion)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table afi_tipo_activo
   drop constraint fk_afi_tipo_ref_11995_cglcuent ;

alter table afi_tipo_activo
   add constraint fk_afi_tipo_ref_11995_cglcuent foreign key (cuenta_gasto)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table afi_trx2
   drop constraint fk_afi_trx2_reference_cglcuent ;

alter table afi_trx2
   add constraint fk_afi_trx2_reference_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete cascade on update cascade;


alter table articulos_por_almacen
   drop constraint fk_articulo_ref_42015_cglcuent ;

alter table articulos_por_almacen
   add constraint fk_articulo_ref_42015_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table bco_cheques_temporal
   drop constraint fk_bco_cheq_reference_cglcuent ;

alter table bco_cheques_temporal
   add constraint fk_bco_cheq_reference_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete cascade on update cascade;


alter table bcocheck2
   drop constraint fk_bcocheck_ref_28345_cglcuent ;

alter table bcocheck2
   add constraint fk_bcocheck_ref_28345_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table bcoctas
   drop constraint fk_bcoctas_ref_27103_cglcuent ;

alter table bcoctas
   add constraint fk_bcoctas_ref_27103_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table bcotransac2
   drop constraint fk_bcotrans_ref_30991_cglcuent ;

alter table bcotransac2
   add constraint fk_bcotrans_ref_30991_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table caja_trx2
   drop constraint fk_caja_trx_ref_12852_cglcuent ;

alter table caja_trx2
   add constraint fk_caja_trx_ref_12852_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table cajas
   drop constraint fk_cajas_ref_11559_cglcuent ;

alter table cajas
   add constraint fk_cajas_ref_11559_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table cf_bco_2
   drop constraint fk_cf_bco_2_reference_cglcuent ;

alter table cf_bco_2
   add constraint fk_cf_bco_2_reference_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;


alter table cf_recibos_2
   drop constraint fk_cf_recib_reference_cglcuent ;

alter table cf_recibos_2
   add constraint fk_cf_recib_reference_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;


alter table cgl_comprobante2
   drop constraint fk_cgl_comp_reference_cglcuent ;

alter table cgl_comprobante2
   add constraint fk_cgl_comp_reference_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table cgl_financiero
   drop constraint fk_cgl_fina_reference_cglcuent ;

alter table cgl_financiero
   add constraint fk_cgl_fina_reference_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table cgl_presupuesto
   drop constraint fk_cgl_pres_reference_cglcuent ;

alter table cgl_presupuesto
   add constraint fk_cgl_pres_reference_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table cglcomprobante2
   drop constraint fk_cglcompr_ref_7501_cglcuent ;

alter table cglcomprobante2
   add constraint fk_cglcompr_ref_7501_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table cglctasxaplicacion
   drop constraint fk_cglctasx_ref_944_cglcuent ;

alter table cglctasxaplicacion
   add constraint fk_cglctasx_ref_944_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table cglcuentas
   drop constraint cglniveles ;

alter table cglcuentas
   add constraint cglniveles foreign key (nivel)
      references cglniveles (nivel)
      on delete restrict on update restrict;


alter table cglperiodico2
   drop constraint fk_cglperio_ref_7899_cglcuent ;

alter table cglperiodico2
   add constraint fk_cglperio_ref_7899_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table cglposteo
   drop constraint fk_cglposte_ref_8363_cglcuent ;

alter table cglposteo
   add constraint fk_cglposte_ref_8363_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table cglsldocuenta
   drop constraint fk_cglsldoc_reference_cglcuent ;

alter table cglsldocuenta
   add constraint fk_cglsldoc_reference_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table clientes
   drop constraint fk_clientes_ref_32562_cglcuent ;

alter table clientes
   add constraint fk_clientes_ref_32562_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table clientes_exentos
   drop constraint fk_clientes_reference_cglcuent ;

alter table clientes_exentos
   add constraint fk_clientes_reference_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;


alter table cos_cuenta_rubro
   drop constraint fk_cos_cuen_reference_cglcuent ;

alter table cos_cuenta_rubro
   add constraint fk_cos_cuen_reference_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table cxc_recibo3
   drop constraint fk_cxc_reci_reference_cglcuent ;

alter table cxc_recibo3
   add constraint fk_cxc_reci_reference_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table cxcfact2
   drop constraint fk_cxcfact2_ref_35575_cglcuent ;

alter table cxcfact2
   add constraint fk_cxcfact2_ref_35575_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table cxctrx3
   drop constraint fk_cxctrx3_ref_32532_cglcuent ;

alter table cxctrx3
   add constraint fk_cxctrx3_ref_32532_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table cxpajuste3
   drop constraint fk_cxpajust_ref_25804_cglcuent ;

alter table cxpajuste3
   add constraint fk_cxpajust_ref_25804_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table cxpfact2
   drop constraint fk_cxpfact2_ref_64317_cglcuent ;

alter table cxpfact2
   add constraint fk_cxpfact2_ref_64317_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table eys2
   drop constraint fk_eys2_reference_cglcuent ;

alter table eys2
   add constraint fk_eys2_reference_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table eys3
   drop constraint fk_eys3_ref_42010_cglcuent ;

alter table eys3
   add constraint fk_eys3_ref_42010_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table fac_cajas
   drop constraint fk_fac_caja_reference_cglcuent ;

alter table fac_cajas
   add constraint fk_fac_caja_reference_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;


alter table fac_parametros_contables
   drop constraint fk_fac_param_contab_cta_ingreso ;

alter table fac_parametros_contables
   add constraint fk_fac_param_contab_cta_ingreso foreign key (cta_de_ingreso)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table fac_parametros_contables
   drop constraint fk_fac_param_contab_cta_costo ;

alter table fac_parametros_contables
   add constraint fk_fac_param_contab_cta_costo foreign key (cta_de_costo)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table fac_parametros_contables
   drop constraint fk_fac_para_ref_cglcuent ;

alter table fac_parametros_contables
   add constraint fk_fac_para_ref_cglcuent foreign key (vtas_exentas)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table fac_parametros_contables
   drop constraint fk_fac_para_reference_cglcuent ;

alter table fac_parametros_contables
   add constraint fk_fac_para_reference_cglcuent foreign key (cta_de_gasto)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table facparamcgl
   drop constraint fk_facparamcgl2_ref_cglcuentas ;

alter table facparamcgl
   add constraint fk_facparamcgl2_ref_cglcuentas foreign key (cuenta_ingreso)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table facparamcgl
   drop constraint fk_facparamcgl3_ref_cglcuentas ;

alter table facparamcgl
   add constraint fk_facparamcgl3_ref_cglcuentas foreign key (cuenta_costo)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table facparamcgl
   drop constraint fk_facparamcgl1_ref_cglcuentas ;

alter table facparamcgl
   add constraint fk_facparamcgl1_ref_cglcuentas foreign key (cta_vta_exenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table facparamcgl
   drop constraint fk_facparam_reference_cglcuent ;

alter table facparamcgl
   add constraint fk_facparam_reference_cglcuent foreign key (cuenta_gastos)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table facparamcgl
   drop constraint fk_facparam_reference_cglcuent ;

alter table facparamcgl
   add constraint fk_facparam_reference_cglcuent foreign key (cuenta_devolucion)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table gral_impuestos
   drop constraint fk_gral_imp_ref_60462_cglcuent ;

alter table gral_impuestos
   add constraint fk_gral_imp_ref_60462_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table nomacrem
   drop constraint fk_nomacrem_ref_19292_cglcuent ;

alter table nomacrem
   add constraint fk_nomacrem_ref_19292_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table nomconce
   drop constraint fk_nomconce_reference_cglcuent ;

alter table nomconce
   add constraint fk_nomconce_reference_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table pat_cuentas
   drop constraint fk_pat_cuen_reference_cglcuent ;

alter table pat_cuentas
   add constraint fk_pat_cuen_reference_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete cascade on update cascade;


alter table pla_afectacion_contable
   drop constraint fk_pla_afec_reference_cglcuent ;

alter table pla_afectacion_contable
   add constraint fk_pla_afec_reference_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table proveedores
   drop constraint fk_proveedo_ref_22652_cglcuent ;

alter table proveedores
   add constraint fk_proveedo_ref_22652_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table rhuempl
   drop constraint fk_rhuempl_ref_19061_cglcuent ;

alter table rhuempl
   add constraint fk_rhuempl_ref_19061_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table rubros_fact_cxc
   drop constraint fk_rubros_f_ref_35579_cglcuent ;

alter table rubros_fact_cxc
   add constraint fk_rubros_f_ref_35579_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;


alter table rubros_fact_cxp
   drop constraint fk_rubros_f_ref_22631_cglcuent ;

alter table rubros_fact_cxp
   add constraint fk_rubros_f_ref_22631_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;




drop index i3_rela_factura1_cglposteo;

drop index i2_rela_factura1_cglposteo;

drop index i1_rela_factura1_cglposteo;


/*==============================================================*/
/* Index: i1_rela_factura1_cglposteo                            */
/*==============================================================*/
create unique index i1_rela_factura1_cglposteo on rela_factura1_cglposteo (
almacen,
tipo,
num_documento,
consecutivo
);

/*==============================================================*/
/* Index: i2_rela_factura1_cglposteo                            */
/*==============================================================*/
create  index i2_rela_factura1_cglposteo on rela_factura1_cglposteo (
almacen,
tipo,
num_documento
);

/*==============================================================*/
/* Index: i3_rela_factura1_cglposteo                            */
/*==============================================================*/
create  index i3_rela_factura1_cglposteo on rela_factura1_cglposteo (
consecutivo
);

alter table rela_factura1_cglposteo
   drop constraint fk_rela_fac_ref_11999_cglposte ;
alter table rela_factura1_cglposteo
   add constraint fk_rela_fac_ref_11999_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_factura1_cglposteo
   drop constraint fk_rela_fac_ref_11999_factura1 ;
alter table rela_factura1_cglposteo
   add constraint fk_rela_fac_ref_11999_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;



drop index i10_factura1;

drop index i9_factura1;

drop index i8_factura1;

drop index i7_factura1;

drop index i6_factura1;

drop index i5_factura1;

drop index i4_factura1;

drop index i3_factura1;

drop index i2_factura1;

drop index i1_factura1;


/*==============================================================*/
/* Index: i1_factura1                                           */
/*==============================================================*/
create unique index i1_factura1 on factura1 (
almacen,
tipo,
num_documento
);

/*==============================================================*/
/* Index: i2_factura1                                           */
/*==============================================================*/
create  index i2_factura1 on factura1 (
almacen
);

/*==============================================================*/
/* Index: i3_factura1                                           */
/*==============================================================*/
create  index i3_factura1 on factura1 (
tipo
);

/*==============================================================*/
/* Index: i4_factura1                                           */
/*==============================================================*/
create  index i4_factura1 on factura1 (
documento
);

/*==============================================================*/
/* Index: i5_factura1                                           */
/*==============================================================*/
create  index i5_factura1 on factura1 (
cliente
);

/*==============================================================*/
/* Index: i6_factura1                                           */
/*==============================================================*/
create  index i6_factura1 on factura1 (
fecha_factura
);

/*==============================================================*/
/* Index: i7_factura1                                           */
/*==============================================================*/
create  index i7_factura1 on factura1 (
almacen,
tipo,
documento,
cliente,
fecha_factura
);

/*==============================================================*/
/* Index: i8_factura1                                           */
/*==============================================================*/
create  index i8_factura1 on factura1 (
aplicacion
);

/*==============================================================*/
/* Index: i9_factura1                                           */
/*==============================================================*/
create  index i9_factura1 on factura1 (
almacen,
caja,
sec_z
);

/*==============================================================*/
/* Index: i10_factura1                                          */
/*==============================================================*/
create  index i10_factura1 on factura1 (
almacen,
caja
);

alter table adc_facturas_recibos
   drop constraint fk_adc_fact_reference_factura1 ;
alter table adc_facturas_recibos
   add constraint fk_adc_fact_reference_factura1 foreign key (fac_almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete restrict on update cascade;

alter table adc_house_factura1
   drop constraint fk_adc_hous_reference_factura1 ;
alter table adc_house_factura1
   add constraint fk_adc_hous_reference_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table adc_informe1
   drop constraint fk_adc_info_reference_factura1 ;
alter table adc_informe1
   add constraint fk_adc_info_reference_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table adc_manejo_factura1
   drop constraint fk_adc_mane_reference_factura1 ;
alter table adc_manejo_factura1
   add constraint fk_adc_mane_reference_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table fac_pagos
   drop constraint fk_fac_pago_reference_factura1 ;
alter table fac_pagos
   add constraint fk_fac_pago_reference_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table fact_list_despachos
   drop constraint fk_fact_lis_reference_factura1 ;
alter table fact_list_despachos
   add constraint fk_fact_lis_reference_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table factura1
   drop constraint fk_factura1_ref_10094_vendedor ;
alter table factura1
   add constraint fk_factura1_ref_10094_vendedor foreign key (codigo_vendedor)
      references vendedores (codigo)
      on delete restrict on update restrict;

alter table factura1
   drop constraint fk_factura1_ref_99208_almacen ;
alter table factura1
   add constraint fk_factura1_ref_99208_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;

alter table factura1
   drop constraint fk_factura1_ref_99219_factmoti ;
alter table factura1
   add constraint fk_factura1_ref_99219_factmoti foreign key (tipo)
      references factmotivos (tipo)
      on delete restrict on update cascade;

alter table factura1
   drop constraint fk_factura1_ref_99224_clientes ;
alter table factura1
   add constraint fk_factura1_ref_99224_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table factura1
   drop constraint fk_factura1_ref_99230_gral_for ;
alter table factura1
   add constraint fk_factura1_ref_99230_gral_for foreign key (forma_pago)
      references gral_forma_de_pago (forma_pago)
      on delete restrict on update restrict;

alter table factura1
   drop constraint fk_factura1_reference_gralapli ;
alter table factura1
   add constraint fk_factura1_reference_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table factura1
   drop constraint fk_factura1_ciu_origen ;
alter table factura1
   add constraint fk_factura1_ciu_origen foreign key (ciudad_origen)
      references fac_ciudades (ciudad)
      on delete restrict on update restrict;

alter table factura1
   drop constraint fk_factura1_ciu_destino ;
alter table factura1
   add constraint fk_factura1_ciu_destino foreign key (ciudad_destino)
      references fac_ciudades (ciudad)
      on delete restrict on update restrict;

alter table factura1
   drop constraint fk_factura1_agente_ref_clientes ;
alter table factura1
   add constraint fk_factura1_agente_ref_clientes foreign key (agente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table factura1
   drop constraint fk_factura1_reference_destinos ;
alter table factura1
   add constraint fk_factura1_reference_destinos foreign key (cod_destino)
      references destinos (cod_destino)
      on delete restrict on update restrict;

alter table factura1
   drop constraint fk_factura1_reference_navieras ;
alter table factura1
   add constraint fk_factura1_reference_navieras foreign key (cod_naviera)
      references navieras (cod_naviera)
      on delete restrict on update restrict;

alter table factura1
   drop constraint fk_factura1_reference_fact_ref ;
alter table factura1
   add constraint fk_factura1_reference_fact_ref foreign key (referencia)
      references fact_referencias (referencia)
      on delete restrict on update restrict;

alter table factura1
   drop constraint fk_factura1_reference_fac_caja ;
alter table factura1
   add constraint fk_factura1_reference_fac_caja foreign key (caja, almacen)
      references fac_cajas (caja, almacen)
      on delete restrict on update cascade;

alter table factura1
   drop constraint fk_factura1_reference_fac_caje ;
alter table factura1
   add constraint fk_factura1_reference_fac_caje foreign key (cajero)
      references fac_cajeros (cajero)
      on delete restrict on update cascade;

alter table factura1
   drop constraint fk_factura1_reference_choferes ;
alter table factura1
   add constraint fk_factura1_reference_choferes foreign key (chofer)
      references choferes (chofer)
      on delete restrict on update cascade;

alter table factura1
   drop constraint fk_factura1_reference_fact_ref ;
alter table factura1
   add constraint fk_factura1_reference_fact_ref foreign key (referencia)
      references fact_referencias (referencia)
      on delete restrict on update restrict;

alter table factura2
   drop constraint fk_factura2_ref_10268_factura1 ;
alter table factura2
   add constraint fk_factura2_ref_10268_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table factura4
   drop constraint fk_factura4_ref_10274_factura1 ;
alter table factura4
   add constraint fk_factura4_ref_10274_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table factura5
   drop constraint fk_factura5_ref_10849_factura1 ;
alter table factura5
   add constraint fk_factura5_ref_10849_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table factura6
   drop constraint fk_factura6_ref_10850_factura1 ;
alter table factura6
   add constraint fk_factura6_ref_10850_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table factura7
   drop constraint fk_factura7_ref_13516_factura1 ;
alter table factura7
   add constraint fk_factura7_ref_13516_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table factura8
   drop constraint fk_factura8_reference_factura1 ;
alter table factura8
   add constraint fk_factura8_reference_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete restrict on update cascade;

alter table inv_despachos
   drop constraint fk_inv_desp_reference_factura1 ;
alter table inv_despachos
   add constraint fk_inv_desp_reference_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table rela_factura1_cglposteo
   drop constraint fk_rela_fac_ref_11999_factura1 ;
alter table rela_factura1_cglposteo
   add constraint fk_rela_fac_ref_11999_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table tal_ot1
   drop constraint fk_tal_ot1_reference_factura1 ;
alter table tal_ot1
   add constraint fk_tal_ot1_reference_factura1 foreign key (almacen, tipo_factura, numero_factura)
      references factura1 (almacen, tipo, num_documento)
      on delete restrict on update cascade;


drop index i9_cglposteo;

drop index i8_cglposteo;

drop index i7_cglposteo;

drop index i6_cglposteo;

drop index i5_cglposteo;

drop index i4_cglposteo;

drop index i3_cglposteo;

drop index i2_cglposteo;

drop index i1_cglposteo;


/*==============================================================*/
/* Index: i1_cglposteo                                          */
/*==============================================================*/
create unique index i1_cglposteo on cglposteo (
consecutivo
);

/*==============================================================*/
/* Index: i2_cglposteo                                          */
/*==============================================================*/
create  index i2_cglposteo on cglposteo (
cuenta
);

/*==============================================================*/
/* Index: i3_cglposteo                                          */
/*==============================================================*/
create  index i3_cglposteo on cglposteo (
fecha_comprobante,
compania
);

/*==============================================================*/
/* Index: i4_cglposteo                                          */
/*==============================================================*/
create  index i4_cglposteo on cglposteo (
compania,
aplicacion,
year,
periodo
);

/*==============================================================*/
/* Index: i5_cglposteo                                          */
/*==============================================================*/
create  index i5_cglposteo on cglposteo (
linea,
cuenta
);

/*==============================================================*/
/* Index: i6_cglposteo                                          */
/*==============================================================*/
create  index i6_cglposteo on cglposteo (
cuenta,
compania,
aplicacion,
year,
periodo,
linea
);

/*==============================================================*/
/* Index: i7_cglposteo                                          */
/*==============================================================*/
create  index i7_cglposteo on cglposteo (
cuenta,
compania,
fecha_comprobante
);

/*==============================================================*/
/* Index: i8_cglposteo                                          */
/*==============================================================*/
create  index i8_cglposteo on cglposteo (
tipo_comp
);

/*==============================================================*/
/* Index: i9_cglposteo                                          */
/*==============================================================*/
create  index i9_cglposteo on cglposteo (
debito,
credito
);

alter table adc_manifiesto_contable
   drop constraint fk_adc_mani_reference_cglposte ;
alter table adc_manifiesto_contable
   add constraint fk_adc_mani_reference_cglposte foreign key (cgl_consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table cglposteo
   drop constraint fk_cglposte_ref_8363_cglcuent ;
alter table cglposteo
   add constraint fk_cglposte_ref_8363_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table cglposteo
   drop constraint fk_cglposte_ref_8388_cgltipoc ;
alter table cglposteo
   add constraint fk_cglposte_ref_8388_cgltipoc foreign key (tipo_comp)
      references cgltipocomp (tipo_comp)
      on delete restrict on update restrict;

alter table cglposteo
   drop constraint fk_cglposte_reference_gralperi ;
alter table cglposteo
   add constraint fk_cglposte_reference_gralperi foreign key (compania, aplicacion, year, periodo)
      references gralperiodos (compania, aplicacion, year, periodo)
      on delete restrict on update cascade;

alter table cglposteoaux1
   drop constraint fk_cglposte_ref_8370_cglposte ;
alter table cglposteoaux1
   add constraint fk_cglposte_ref_8370_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table cglposteoaux2
   drop constraint fk_cglposte_ref_8374_cglposte ;
alter table cglposteoaux2
   add constraint fk_cglposte_ref_8374_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_activos_cglposteo
   drop constraint fk_rela_act_reference_cglposte ;
alter table rela_activos_cglposteo
   add constraint fk_rela_act_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_adc_cxc_1_cglposteo
   drop constraint fk_rela_adc_reference_cglposte ;
alter table rela_adc_cxc_1_cglposteo
   add constraint fk_rela_adc_reference_cglposte foreign key (cgl_consecutivo)
      references cglposteo (consecutivo)
      on delete restrict on update cascade;

alter table rela_adc_cxp_1_cglposteo
   drop constraint fk_rela_adc_reference_cglposte ;
alter table rela_adc_cxp_1_cglposteo
   add constraint fk_rela_adc_reference_cglposte foreign key (cgl_consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_adc_master_cglposteo
   drop constraint fk_rela_adc_reference_cglposte ;
alter table rela_adc_master_cglposteo
   add constraint fk_rela_adc_reference_cglposte foreign key (cgl_consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_afi_cglposteo
   drop constraint fk_rela_afi_ref_12219_cglposte ;
alter table rela_afi_cglposteo
   add constraint fk_rela_afi_ref_12219_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_afi_trx1_cglposteo
   drop constraint fk_rela_afi_reference_cglposte ;
alter table rela_afi_trx1_cglposteo
   add constraint fk_rela_afi_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_bcocheck1_cglposteo
   drop constraint fk_rela_bco_ref_70281_cglposte ;
alter table rela_bcocheck1_cglposteo
   add constraint fk_rela_bco_ref_70281_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_bcotransac1_cglposteo
   drop constraint fk_rela_bco_ref_70293_cglposte ;
alter table rela_bcotransac1_cglposteo
   add constraint fk_rela_bco_ref_70293_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_caja_trx1_cglposteo
   drop constraint fk_rela_caj_ref_11997_cglposte ;
alter table rela_caja_trx1_cglposteo
   add constraint fk_rela_caj_ref_11997_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_cgl_comprobante1_cglposteo
   drop constraint fk_rela_cgl_reference_cglposte ;
alter table rela_cgl_comprobante1_cglposteo
   add constraint fk_rela_cgl_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_cglcomprobante1_cglposteo
   drop constraint fk_rela_cgl_reference_cglposte ;
alter table rela_cglcomprobante1_cglposteo
   add constraint fk_rela_cgl_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_cxc_recibo1_cglposteo
   drop constraint fk_rela_cxc_reference_cglposte ;
alter table rela_cxc_recibo1_cglposteo
   add constraint fk_rela_cxc_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_cxcfact1_cglposteo
   drop constraint fk_rela_cxc_ref_70298_cglposte ;
alter table rela_cxcfact1_cglposteo
   add constraint fk_rela_cxc_ref_70298_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_cxctrx1_cglposteo
   drop constraint fk_rela_cxc_ref_71933_cglposte ;
alter table rela_cxctrx1_cglposteo
   add constraint fk_rela_cxc_ref_71933_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_cxpajuste1_cglposteo
   drop constraint fk_rela_cxp_ref_70325_cglposte ;
alter table rela_cxpajuste1_cglposteo
   add constraint fk_rela_cxp_ref_70325_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_cxpfact1_cglposteo
   drop constraint fk_rela_cxp_ref_70310_cglposte ;
alter table rela_cxpfact1_cglposteo
   add constraint fk_rela_cxp_ref_70310_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_eys1_cglposteo
   drop constraint fk_rela_eys_ref_71945_cglposte ;
alter table rela_eys1_cglposteo
   add constraint fk_rela_eys_ref_71945_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_factura1_cglposteo
   drop constraint fk_rela_fac_ref_11999_cglposte ;
alter table rela_factura1_cglposteo
   add constraint fk_rela_fac_ref_11999_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_nomctrac_cglposteo
   drop constraint fk_rela_nom_reference_cglposte ;
alter table rela_nomctrac_cglposteo
   add constraint fk_rela_nom_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_pla_reservas_cglposteo
   drop constraint fk_rela_pla_reference_cglposte ;
alter table rela_pla_reservas_cglposteo
   add constraint fk_rela_pla_reference_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;



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
