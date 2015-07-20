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
   drop constraint fk_adc_para_reference_cglcuent_costo ;
alter table adc_parametros_contables
   add constraint fk_adc_para_reference_cglcuent_costo foreign key (cta_costo)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;
alter table adc_parametros_contables
   drop constraint fk_adc_para_reference_cglcuent_ingreso ;
alter table adc_parametros_contables
   add constraint fk_adc_para_reference_cglcuent_ingreso foreign key (cta_ingreso)
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
   drop constraint fk_fac_para_reference_cglcuent ;
alter table fac_parametros_contables
   add constraint fk_fac_para_reference_cglcuent foreign key (vtas_exentas)
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