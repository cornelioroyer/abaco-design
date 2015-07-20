alter table activos
   drop constraint fk_activos_ref_110445_marcas  cascade;
alter table activos
   add constraint fk_activos_ref_110445_marcas foreign key (marca)
      references marcas (codigo)
      on delete restrict on update restrict;

alter table activos
   drop constraint fk_activos_ref_110464_afi_grup  cascade;
alter table activos
   add constraint fk_activos_ref_110464_afi_grup foreign key (grupo)
      references afi_grupos_1 (codigo)
      on delete restrict on update restrict;

alter table activos
   drop constraint fk_activos_ref_110496_seccione  cascade;
alter table activos
   add constraint fk_activos_ref_110496_seccione foreign key (seccion, departamento)
      references secciones (seccion, codigo)
      on delete restrict on update restrict;

alter table activos
   drop constraint fk_activos_ref_112520_afi_tipo  cascade;
alter table activos
   add constraint fk_activos_ref_112520_afi_tipo foreign key (tipo_activo)
      references afi_tipo_activo (codigo)
      on delete restrict on update restrict;

alter table activos
   drop constraint fk_activos_ref_122140_gralcomp  cascade;
alter table activos
   add constraint fk_activos_ref_122140_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table activos
   drop constraint fk_activos_ref_123353_activos  cascade;
alter table activos
   add constraint fk_activos_ref_123353_activos foreign key (act_codigo, compania)
      references activos (codigo, compania)
      on delete restrict on update cascade;

alter table adc_house
   drop constraint fk_adc_hous_reference_634_adc_mast  cascade;
alter table adc_house
   add constraint fk_adc_hous_reference_634_adc_mast foreign key (compania, consecutivo, linea_master)
      references adc_master (compania, consecutivo, linea_master)
      on delete cascade on update cascade;

alter table adc_house
   drop constraint fk_adc_hous_reference_640_clientes  cascade;
alter table adc_house
   add constraint fk_adc_hous_reference_640_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table adc_house
   drop constraint fk_adc_hous_reference_660_almacen  cascade;
alter table adc_house
   add constraint fk_adc_hous_reference_660_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;

alter table adc_house
   drop constraint fk_adc_hous_reference_662_destinos  cascade;
alter table adc_house
   add constraint fk_adc_hous_reference_662_destinos foreign key (cod_destino)
      references destinos (cod_destino)
      on delete restrict on update restrict;

alter table adc_house_factura1
   drop constraint fk_adc_hous_reference_643_factura1  cascade;
alter table adc_house_factura1
   add constraint fk_adc_hous_reference_643_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table adc_house_factura1
   drop constraint fk_adc_hous_reference_658_adc_hous  cascade;
alter table adc_house_factura1
   add constraint fk_adc_hous_reference_658_adc_hous foreign key (compania, consecutivo, linea_master, linea_house)
      references adc_house (compania, consecutivo, linea_master, linea_house)
      on delete cascade on update cascade;

alter table adc_informe1
   drop constraint fk_adc_info_reference_667_adc_mast  cascade;
alter table adc_informe1
   add constraint fk_adc_info_reference_667_adc_mast foreign key (compania, consecutivo, linea_master)
      references adc_master (compania, consecutivo, linea_master)
      on delete cascade on update cascade;

alter table adc_informe1
   drop constraint fk_adc_info_reference_668_factura1  cascade;
alter table adc_informe1
   add constraint fk_adc_info_reference_668_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table adc_manejo
   drop constraint fk_adc_mane_reference_635_adc_hous  cascade;
alter table adc_manejo
   add constraint fk_adc_mane_reference_635_adc_hous foreign key (compania, consecutivo, linea_master, linea_house)
      references adc_house (compania, consecutivo, linea_master, linea_house)
      on delete cascade on update cascade;

alter table adc_manejo
   drop constraint fk_adc_mane_reference_642_articulo  cascade;
alter table adc_manejo
   add constraint fk_adc_mane_reference_642_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete restrict on update cascade;

alter table adc_manejo_factura1
   drop constraint fk_adc_mane_reference_650_adc_mane  cascade;
alter table adc_manejo_factura1
   add constraint fk_adc_mane_reference_650_adc_mane foreign key (compania, consecutivo, linea_master, linea_house, linea_manejo)
      references adc_manejo (compania, consecutivo, linea_master, linea_house, linea_manejo)
      on delete cascade on update cascade;

alter table adc_manejo_factura1
   drop constraint fk_adc_mane_reference_659_factura1  cascade;
alter table adc_manejo_factura1
   add constraint fk_adc_mane_reference_659_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table adc_manifiesto
   drop constraint fk_adc_mani_reference_clientes_to  cascade;
alter table adc_manifiesto
   add constraint fk_adc_mani_reference_clientes_to foreign key (to_agent)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table adc_manifiesto
   drop constraint fk_adc_mani_reference_632_gralcomp  cascade;
alter table adc_manifiesto
   add constraint fk_adc_mani_reference_632_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table adc_manifiesto
   drop constraint fk_adc_mani_reference_clientes_from  cascade;
alter table adc_manifiesto
   add constraint fk_adc_mani_reference_clientes_from foreign key (from_agent)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table adc_manifiesto
   drop constraint fk_adc_mani_reference_637_navieras  cascade;
alter table adc_manifiesto
   add constraint fk_adc_mani_reference_637_navieras foreign key (cod_naviera)
      references navieras (cod_naviera)
      on delete restrict on update cascade;

alter table adc_manifiesto
   drop constraint fk_adc_mani_reference_fac_ciud_origen  cascade;
alter table adc_manifiesto
   add constraint fk_adc_mani_reference_fac_ciud_origen foreign key (ciudad_origen)
      references fac_ciudades (ciudad)
      on delete restrict on update cascade;

alter table adc_manifiesto
   drop constraint fk_adc_mani_reference_fac_ciud_destino  cascade;
alter table adc_manifiesto
   add constraint fk_adc_mani_reference_fac_ciud_destino foreign key (ciudad_destino)
      references fac_ciudades (ciudad)
      on delete restrict on update cascade;

alter table adc_manifiesto
   drop constraint fk_adc_mani_reference_644_fact_ref  cascade;
alter table adc_manifiesto
   add constraint fk_adc_mani_reference_644_fact_ref foreign key (referencia)
      references fact_referencias (referencia)
      on delete restrict on update cascade;

alter table adc_manifiesto
   drop constraint fk_adc_mani_reference_672_vendedor  cascade;
alter table adc_manifiesto
   add constraint fk_adc_mani_reference_672_vendedor foreign key (vendedor)
      references vendedores (codigo)
      on delete restrict on update restrict;

alter table adc_master
   drop constraint fk_adc_mast_reference_633_adc_mani  cascade;
alter table adc_master
   add constraint fk_adc_mast_reference_633_adc_mani foreign key (compania, consecutivo)
      references adc_manifiesto (compania, consecutivo)
      on delete cascade on update cascade;

alter table adc_master
   drop constraint fk_adc_mast_reference_641_adc_cont  cascade;
alter table adc_master
   add constraint fk_adc_mast_reference_641_adc_cont foreign key (tamanio)
      references adc_containers (tamanio)
      on delete restrict on update restrict;

alter table adc_master
   drop constraint fk_adc_mast_reference_666_adc_tipo  cascade;
alter table adc_master
   add constraint fk_adc_mast_reference_666_adc_tipo foreign key (tipo)
      references adc_tipo_de_contenedor (tipo)
      on delete restrict on update cascade;

alter table adc_parametros_contables
   drop constraint fk_adc_para_reference_645_fact_ref  cascade;
alter table adc_parametros_contables
   add constraint fk_adc_para_reference_645_fact_ref foreign key (referencia)
      references fact_referencias (referencia)
      on delete restrict on update cascade;

alter table adc_parametros_contables
   drop constraint fk_adc_para_reference_646_fac_ciud  cascade;
alter table adc_parametros_contables
   add constraint fk_adc_para_reference_646_fac_ciud foreign key (ciudad)
      references fac_ciudades (ciudad)
      on delete restrict on update restrict;

alter table adc_parametros_contables
   drop constraint fk_adc_para_reference_cglcuent_ingreso  cascade;
alter table adc_parametros_contables
   add constraint fk_adc_para_reference_cglcuent_ingreso foreign key (cta_ingreso)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table adc_parametros_contables
   drop constraint fk_adc_para_reference_cglcuent_costo  cascade;
alter table adc_parametros_contables
   add constraint fk_adc_para_reference_cglcuent_costo foreign key (cta_costo)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table adc_parametros_contables
   drop constraint fk_adc_para_reference_661_cglcuent  cascade;
alter table adc_parametros_contables
   add constraint fk_adc_para_reference_661_cglcuent foreign key (cta_gasto)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table afi_depreciacion
   drop constraint fk_afi_depr_ref_122150_activos  cascade;
alter table afi_depreciacion
   add constraint fk_afi_depr_ref_122150_activos foreign key (codigo, compania)
      references activos (codigo, compania)
      on delete restrict on update cascade;

alter table afi_depreciacion
   drop constraint fk_afi_depr_ref_122157_gralperi  cascade;
alter table afi_depreciacion
   add constraint fk_afi_depr_ref_122157_gralperi foreign key (compania, aplicacion, year, periodo)
      references gralperiodos (compania, aplicacion, year, periodo)
      on delete restrict on update restrict;

alter table afi_grupos_2
   drop constraint fk_afi_grup_ref_110458_afi_grup  cascade;
alter table afi_grupos_2
   add constraint fk_afi_grup_ref_110458_afi_grup foreign key (codigo)
      references afi_grupos_1 (codigo)
      on delete restrict on update restrict;

alter table afi_listado2
   drop constraint fk_afi_list_reference_465_afi_depr  cascade;
alter table afi_listado2
   add constraint fk_afi_list_reference_465_afi_depr foreign key (codigo, compania, aplicacion, year, periodo)
      references afi_depreciacion (codigo, compania, aplicacion, year, periodo)
      on delete cascade on update cascade;

alter table afi_tipo_activo
   drop constraint fk_afi_tipo_ref_113573_cgltipoc  cascade;
alter table afi_tipo_activo
   add constraint fk_afi_tipo_ref_113573_cgltipoc foreign key (tipo_comp)
      references cgltipocomp (tipo_comp)
      on delete restrict on update restrict;

alter table afi_tipo_activo
   drop constraint fk_afi_tipo_ref_117749_cglcuent  cascade;
alter table afi_tipo_activo
   add constraint fk_afi_tipo_ref_117749_cglcuent foreign key (cuenta_activo)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table afi_tipo_activo
   drop constraint fk_afi_tipo_ref_117753_cglcuent  cascade;
alter table afi_tipo_activo
   add constraint fk_afi_tipo_ref_117753_cglcuent foreign key (cuenta_depreciacion)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table afi_tipo_activo
   drop constraint fk_afi_tipo_ref_119953_cglcuent  cascade;
alter table afi_tipo_activo
   add constraint fk_afi_tipo_ref_119953_cglcuent foreign key (cuenta_gasto)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table afi_tipo_trx
   drop constraint fk_afi_tipo_ref_113578_cgltipoc  cascade;
alter table afi_tipo_trx
   add constraint fk_afi_tipo_ref_113578_cgltipoc foreign key (tipo_comp)
      references cgltipocomp (tipo_comp)
      on delete restrict on update restrict;

alter table afi_trx1
   drop constraint fk_afi_trx1_reference_671_activos  cascade;
alter table afi_trx1
   add constraint fk_afi_trx1_reference_671_activos foreign key (codigo, compania)
      references activos (codigo, compania)
      on delete restrict on update restrict;

alter table afi_trx2
   drop constraint fk_afi_trx2_reference_673_afi_trx1  cascade;
alter table afi_trx2
   add constraint fk_afi_trx2_reference_673_afi_trx1 foreign key (compania, no_trx)
      references afi_trx1 (compania, no_trx)
      on delete cascade on update cascade;

alter table afi_trx2
   drop constraint fk_afi_trx2_reference_675_cglcuent  cascade;
alter table afi_trx2
   add constraint fk_afi_trx2_reference_675_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete cascade on update cascade;

alter table afi_trx2
   drop constraint fk_afi_trx2_reference_678_cglauxil  cascade;
alter table afi_trx2
   add constraint fk_afi_trx2_reference_678_cglauxil foreign key (auxiliar)
      references cglauxiliares (auxiliar)
      on delete cascade on update cascade;

alter table almacen
   drop constraint fk_almacen_ref_13269_gralcomp  cascade;
alter table almacen
   add constraint fk_almacen_ref_13269_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table articulos
   drop constraint fk_articulo_ref_6133_unidad_m  cascade;
alter table articulos
   add constraint fk_articulo_ref_6133_unidad_m foreign key (unidad_medida)
      references unidad_medida (unidad_medida)
      on delete restrict on update restrict;

alter table articulos_abc
   drop constraint fk_articulo_reference_552_articulo  cascade;
alter table articulos_abc
   add constraint fk_articulo_reference_552_articulo foreign key (articulo)
      references articulos (articulo)
      on delete cascade on update cascade;

alter table articulos_abc
   drop constraint fk_articulo_reference_553_gralcomp  cascade;
alter table articulos_abc
   add constraint fk_articulo_reference_553_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete cascade on update cascade;

alter table articulos_agrupados
   drop constraint fk_articulo_ref_12550_articulo  cascade;
alter table articulos_agrupados
   add constraint fk_articulo_ref_12550_articulo foreign key (articulo)
      references articulos (articulo)
      on delete cascade on update cascade;

alter table articulos_agrupados
   drop constraint fk_articulo_ref_21604_gral_val  cascade;
alter table articulos_agrupados
   add constraint fk_articulo_ref_21604_gral_val foreign key (codigo_valor_grupo)
      references gral_valor_grupos (codigo_valor_grupo)
      on delete cascade on update cascade;

alter table articulos_por_almacen
   drop constraint fk_articulo_ref_13275_articulo  cascade;
alter table articulos_por_almacen
   add constraint fk_articulo_ref_13275_articulo foreign key (articulo)
      references articulos (articulo)
      on delete restrict on update cascade;

alter table articulos_por_almacen
   drop constraint fk_articulo_ref_13279_almacen  cascade;
alter table articulos_por_almacen
   add constraint fk_articulo_ref_13279_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;

alter table articulos_por_almacen
   drop constraint fk_articulo_ref_42015_cglcuent  cascade;
alter table articulos_por_almacen
   add constraint fk_articulo_ref_42015_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table bco_cheques_temporal
   drop constraint fk_bco_cheq_reference_530_bcocheck  cascade;
alter table bco_cheques_temporal
   add constraint fk_bco_cheq_reference_530_bcocheck foreign key (cod_ctabco, no_cheque, motivo_bco)
      references bcocheck1 (cod_ctabco, no_cheque, motivo_bco)
      on delete cascade on update cascade;

alter table bco_cheques_temporal
   drop constraint fk_bco_cheq_reference_531_cglcuent  cascade;
alter table bco_cheques_temporal
   add constraint fk_bco_cheq_reference_531_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete cascade on update cascade;

alter table bcobalance
   drop constraint fk_bcobalan_ref_31049_bcoctas  cascade;
alter table bcobalance
   add constraint fk_bcobalan_ref_31049_bcoctas foreign key (cod_ctabco)
      references bcoctas (cod_ctabco)
      on delete restrict on update restrict;

alter table bcobalance
   drop constraint fk_bcobalan_ref_31053_gralperi  cascade;
alter table bcobalance
   add constraint fk_bcobalan_ref_31053_gralperi foreign key (compania, aplicacion, year, periodo)
      references gralperiodos (compania, aplicacion, year, periodo)
      on delete restrict on update restrict;

alter table bcocheck1
   drop constraint fk_bcocheck_ref_28311_bcoctas  cascade;
alter table bcocheck1
   add constraint fk_bcocheck_ref_28311_bcoctas foreign key (cod_ctabco)
      references bcoctas (cod_ctabco)
      on delete restrict on update restrict;

alter table bcocheck1
   drop constraint fk_bcocheck_ref_28322_proveedo  cascade;
alter table bcocheck1
   add constraint fk_bcocheck_ref_28322_proveedo foreign key (proveedor)
      references proveedores (proveedor)
      on delete restrict on update restrict;

alter table bcocheck1
   drop constraint fk_bcocheck_ref_28380_bcomotiv  cascade;
alter table bcocheck1
   add constraint fk_bcocheck_ref_28380_bcomotiv foreign key (motivo_bco)
      references bcomotivos (motivo_bco)
      on delete restrict on update cascade;

alter table bcocheck1
   drop constraint fk_bcocheck_reference_507_gralapli  cascade;
alter table bcocheck1
   add constraint fk_bcocheck_reference_507_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table bcocheck2
   drop constraint fk_bcocheck_ref_28345_cglcuent  cascade;
alter table bcocheck2
   add constraint fk_bcocheck_ref_28345_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table bcocheck2
   drop constraint fk_bcocheck_ref_38797_bcocheck  cascade;
alter table bcocheck2
   add constraint fk_bcocheck_ref_38797_bcocheck foreign key (cod_ctabco, no_cheque, motivo_bco)
      references bcocheck1 (cod_ctabco, no_cheque, motivo_bco)
      on delete cascade on update cascade;

alter table bcocheck2
   drop constraint fk_bcocheck_ref_44473_cglauxil  cascade;
alter table bcocheck2
   add constraint fk_bcocheck_ref_44473_cglauxil foreign key (auxiliar1)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table bcocheck2
   drop constraint fk_bcocheck_ref_44477_cglauxil  cascade;
alter table bcocheck2
   add constraint fk_bcocheck_ref_44477_cglauxil foreign key (auxiliar2)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table bcocheck3
   drop constraint fk_bcocheck_ref_28367_cxpmotiv  cascade;
alter table bcocheck3
   add constraint fk_bcocheck_ref_28367_cxpmotiv foreign key (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on delete restrict on update cascade;

alter table bcocheck3
   drop constraint fk_bcocheck_ref_38804_bcocheck  cascade;
alter table bcocheck3
   add constraint fk_bcocheck_ref_38804_bcocheck foreign key (cod_ctabco, no_cheque, motivo_bco)
      references bcocheck1 (cod_ctabco, no_cheque, motivo_bco)
      on delete cascade on update cascade;

alter table bcocheck4
   drop constraint fk_bcocheck_reference_431_bcocheck  cascade;
alter table bcocheck4
   add constraint fk_bcocheck_reference_431_bcocheck foreign key (cod_ctabco, no_cheque, motivo_bco)
      references bcocheck1 (cod_ctabco, no_cheque, motivo_bco)
      on delete cascade on update cascade;

alter table bcocircula
   drop constraint fk_bcocircu_ref_31026_bcoctas  cascade;
alter table bcocircula
   add constraint fk_bcocircu_ref_31026_bcoctas foreign key (cod_ctabco)
      references bcoctas (cod_ctabco)
      on delete restrict on update restrict;

alter table bcocircula
   drop constraint fk_bcocircu_ref_31032_bcomotiv  cascade;
alter table bcocircula
   add constraint fk_bcocircu_ref_31032_bcomotiv foreign key (motivo_bco)
      references bcomotivos (motivo_bco)
      on delete restrict on update cascade;

alter table bcocircula
   drop constraint fk_bcocircu_ref_31042_proveedo  cascade;
alter table bcocircula
   add constraint fk_bcocircu_ref_31042_proveedo foreign key (proveedor)
      references proveedores (proveedor)
      on delete restrict on update restrict;

alter table bcocircula
   drop constraint fk_bcocircu_reference_498_gralapli  cascade;
alter table bcocircula
   add constraint fk_bcocircu_reference_498_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table bcoctas
   drop constraint fk_bcoctas_ref_27092_bancos  cascade;
alter table bcoctas
   add constraint fk_bcoctas_ref_27092_bancos foreign key (banco)
      references bancos (banco)
      on delete restrict on update cascade;

alter table bcoctas
   drop constraint fk_bcoctas_ref_27103_cglcuent  cascade;
alter table bcoctas
   add constraint fk_bcoctas_ref_27103_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table bcoctas
   drop constraint fk_bcoctas_ref_28318_gralcomp  cascade;
alter table bcoctas
   add constraint fk_bcoctas_ref_28318_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table bcoctas
   drop constraint fk_bcoctas_ref_67703_cglauxil  cascade;
alter table bcoctas
   add constraint fk_bcoctas_ref_67703_cglauxil foreign key (auxiliar1)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table bcoctas
   drop constraint fk_bcoctas_ref_67707_cglauxil  cascade;
alter table bcoctas
   add constraint fk_bcoctas_ref_67707_cglauxil foreign key (auxiliar2)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table bcomotivos
   drop constraint fk_bcomotiv_ref_74651_cgltipoc  cascade;
alter table bcomotivos
   add constraint fk_bcomotiv_ref_74651_cgltipoc foreign key (tipo_comp)
      references cgltipocomp (tipo_comp)
      on delete restrict on update restrict;

alter table bcomotivos
   drop constraint fk_bcomotiv_reference_545_cxpmotiv  cascade;
alter table bcomotivos
   add constraint fk_bcomotiv_reference_545_cxpmotiv foreign key (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on delete restrict on update cascade;

alter table bcotransac1
   drop constraint fk_bcotrans_ref_29665_bcoctas  cascade;
alter table bcotransac1
   add constraint fk_bcotrans_ref_29665_bcoctas foreign key (cod_ctabco)
      references bcoctas (cod_ctabco)
      on delete restrict on update restrict;

alter table bcotransac1
   drop constraint fk_bcotrans_ref_30995_bcomotiv  cascade;
alter table bcotransac1
   add constraint fk_bcotrans_ref_30995_bcomotiv foreign key (motivo_bco)
      references bcomotivos (motivo_bco)
      on delete restrict on update cascade;

alter table bcotransac1
   drop constraint fk_bcotrans_ref_31008_proveedo  cascade;
alter table bcotransac1
   add constraint fk_bcotrans_ref_31008_proveedo foreign key (proveedor)
      references proveedores (proveedor)
      on delete restrict on update restrict;

alter table bcotransac1
   drop constraint fk_bcotrans_reference_509_gralapli  cascade;
alter table bcotransac1
   add constraint fk_bcotrans_reference_509_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table bcotransac2
   drop constraint fk_bcotrans_ref_29680_bcotrans  cascade;
alter table bcotransac2
   add constraint fk_bcotrans_ref_29680_bcotrans foreign key (cod_ctabco, sec_transacc)
      references bcotransac1 (cod_ctabco, sec_transacc)
      on delete cascade on update cascade;

alter table bcotransac2
   drop constraint fk_bcotrans_ref_30991_cglcuent  cascade;
alter table bcotransac2
   add constraint fk_bcotrans_ref_30991_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table bcotransac2
   drop constraint fk_bcotrans_ref_44481_cglauxil  cascade;
alter table bcotransac2
   add constraint fk_bcotrans_ref_44481_cglauxil foreign key (auxiliar1)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table bcotransac2
   drop constraint fk_bcotrans_ref_44485_cglauxil  cascade;
alter table bcotransac2
   add constraint fk_bcotrans_ref_44485_cglauxil foreign key (auxiliar2)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table bcotransac3
   drop constraint fk_bcotrans_ref_29684_bcotrans  cascade;
alter table bcotransac3
   add constraint fk_bcotrans_ref_29684_bcotrans foreign key (cod_ctabco, sec_transacc)
      references bcotransac1 (cod_ctabco, sec_transacc)
      on delete cascade on update cascade;

alter table bcotransac3
   drop constraint fk_bcotrans_ref_31001_cxpmotiv  cascade;
alter table bcotransac3
   add constraint fk_bcotrans_ref_31001_cxpmotiv foreign key (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on delete restrict on update cascade;

alter table caja_tipo_trx
   drop constraint fk_caja_tip_ref_129674_cgltipoc  cascade;
alter table caja_tipo_trx
   add constraint fk_caja_tip_ref_129674_cgltipoc foreign key (tipo_comp)
      references cgltipocomp (tipo_comp)
      on delete restrict on update restrict;

alter table caja_trx1
   drop constraint fk_caja_trx_ref_115606_cajas  cascade;
alter table caja_trx1
   add constraint fk_caja_trx_ref_115606_cajas foreign key (caja)
      references cajas (caja)
      on delete restrict on update restrict;

alter table caja_trx1
   drop constraint fk_caja_trx_ref_115645_caja_tip  cascade;
alter table caja_trx1
   add constraint fk_caja_trx_ref_115645_caja_tip foreign key (tipo_trx)
      references caja_tipo_trx (tipo_trx)
      on delete restrict on update restrict;

alter table caja_trx2
   drop constraint fk_caja_trx_ref_115620_caja_trx  cascade;
alter table caja_trx2
   add constraint fk_caja_trx_ref_115620_caja_trx foreign key (numero_trx, caja)
      references caja_trx1 (numero_trx, caja)
      on delete cascade on update cascade;

alter table caja_trx2
   drop constraint fk_caja_trx_cglaux  cascade;
alter table caja_trx2
   add constraint fk_caja_trx_cglaux foreign key (auxiliar_1)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table caja_trx2
   drop constraint fk_caja_trx_ref_118865a_cglauxil  cascade;
alter table caja_trx2
   add constraint fk_caja_trx_ref_118865a_cglauxil foreign key (auxiliar_2)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table caja_trx2
   drop constraint fk_caja_trx_ref_128522_cglcuent  cascade;
alter table caja_trx2
   add constraint fk_caja_trx_ref_128522_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table cajas
   drop constraint fk_cajas_ref_115598_cglcuent  cascade;
alter table cajas
   add constraint fk_cajas_ref_115598_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table cajas
   drop constraint fk_cajas_ref_115651_gralcomp  cascade;
alter table cajas
   add constraint fk_cajas_ref_115651_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table cajas
   drop constraint fk_cajas_ref_145598_cglauxil  cascade;
alter table cajas
   add constraint fk_cajas_ref_145598_cglauxil foreign key (auxiliar_1)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cajas
   drop constraint fk_cajas_ref_145602_cglauxil  cascade;
alter table cajas
   add constraint fk_cajas_ref_145602_cglauxil foreign key (auxiliar_2)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cajas_balance
   drop constraint fk_cajas_ba_ref_115656_cajas  cascade;
alter table cajas_balance
   add constraint fk_cajas_ba_ref_115656_cajas foreign key (caja)
      references cajas (caja)
      on delete restrict on update restrict;

alter table cajas_balance
   drop constraint fk_cajas_ba_ref_115660_gralperi  cascade;
alter table cajas_balance
   add constraint fk_cajas_ba_ref_115660_gralperi foreign key (compania, aplicacion, year, periodo)
      references gralperiodos (compania, aplicacion, year, periodo)
      on delete restrict on update restrict;

alter table cgl_comprobante1
   drop constraint fk_cgl_comp_reference_589_gralcomp  cascade;
alter table cgl_comprobante1
   add constraint fk_cgl_comp_reference_589_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table cgl_comprobante2
   drop constraint fk_cgl_comp_reference_590_cgl_comp  cascade;
alter table cgl_comprobante2
   add constraint fk_cgl_comp_reference_590_cgl_comp foreign key (compania, secuencia)
      references cgl_comprobante1 (compania, secuencia)
      on delete cascade on update cascade;

alter table cgl_comprobante2
   drop constraint fk_cgl_comp_reference_591_cglcuent  cascade;
alter table cgl_comprobante2
   add constraint fk_cgl_comp_reference_591_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table cgl_comprobante2
   drop constraint fk_cgl_comp_reference_592_cglauxil  cascade;
alter table cgl_comprobante2
   add constraint fk_cgl_comp_reference_592_cglauxil foreign key (auxiliar)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cgl_financiero
   drop constraint fk_cgl_fina_reference_473_cglcuent  cascade;
alter table cgl_financiero
   add constraint fk_cgl_fina_reference_473_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table cgl_presupuesto
   drop constraint fk_cgl_pres_reference_555_cglcuent  cascade;
alter table cgl_presupuesto
   add constraint fk_cgl_pres_reference_555_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table cgl_presupuesto
   drop constraint fk_cgl_pres_reference_556_gralcomp  cascade;
alter table cgl_presupuesto
   add constraint fk_cgl_pres_reference_556_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete cascade on update cascade;

alter table cglauxxaplicacion
   drop constraint fk_cglauxxa_ref_20634_gralapli  cascade;
alter table cglauxxaplicacion
   add constraint fk_cglauxxa_ref_20634_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table cglauxxaplicacion
   drop constraint fk_cglauxxa_ref_955_cglauxil  cascade;
alter table cglauxxaplicacion
   add constraint fk_cglauxxa_ref_955_cglauxil foreign key (auxiliar)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cglcomprobante1
   drop constraint fk_cglcompr_ref_8110_cgltipoc  cascade;
alter table cglcomprobante1
   add constraint fk_cglcompr_ref_8110_cgltipoc foreign key (tipo_comp)
      references cgltipocomp (tipo_comp)
      on delete restrict on update restrict;

alter table cglcomprobante1
   drop constraint fk_cglcompr_reference_349_gralcomp  cascade;
alter table cglcomprobante1
   add constraint fk_cglcompr_reference_349_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table cglcomprobante1
   drop constraint fk_cglcompr_reference_354_gralapli  cascade;
alter table cglcomprobante1
   add constraint fk_cglcompr_reference_354_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table cglcomprobante2
   drop constraint fk_cglcompr_ref_7501_cglcuent  cascade;
alter table cglcomprobante2
   add constraint fk_cglcompr_ref_7501_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table cglcomprobante2
   drop constraint fk_cglcompr_ref_763_cglcompr  cascade;
alter table cglcomprobante2
   add constraint fk_cglcompr_ref_763_cglcompr foreign key (secuencia, compania, aplicacion, year, periodo)
      references cglcomprobante1 (secuencia, compania, aplicacion, year, periodo)
      on delete cascade on update cascade;

alter table cglcomprobante3
   drop constraint fk_cglcompr_ref_3433_cglcompr  cascade;
alter table cglcomprobante3
   add constraint fk_cglcompr_ref_3433_cglcompr foreign key (linea, secuencia, compania, aplicacion, year, periodo)
      references cglcomprobante2 (linea, secuencia, compania, aplicacion, year, periodo)
      on delete cascade on update cascade;

alter table cglcomprobante3
   drop constraint fk_cglcompr_ref_7516_cglauxil  cascade;
alter table cglcomprobante3
   add constraint fk_cglcompr_ref_7516_cglauxil foreign key (auxiliar)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cglcomprobante4
   drop constraint fk_cglcompr_ref_3414_cglcompr  cascade;
alter table cglcomprobante4
   add constraint fk_cglcompr_ref_3414_cglcompr foreign key (linea, secuencia, compania, aplicacion, year, periodo)
      references cglcomprobante2 (linea, secuencia, compania, aplicacion, year, periodo)
      on delete cascade on update cascade;

alter table cglcomprobante4
   drop constraint fk_cglcompr_ref_7512_cglauxil  cascade;
alter table cglcomprobante4
   add constraint fk_cglcompr_ref_7512_cglauxil foreign key (auxiliar)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cglctasxaplicacion
   drop constraint fk_cglctasx_ref_20638_gralapli  cascade;
alter table cglctasxaplicacion
   add constraint fk_cglctasx_ref_20638_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table cglctasxaplicacion
   drop constraint fk_cglctasx_ref_944_cglcuent  cascade;
alter table cglctasxaplicacion
   add constraint fk_cglctasx_ref_944_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table cglcuentas
   drop constraint cglniveles  cascade;
alter table cglcuentas
   add constraint cglniveles foreign key (nivel)
      references cglniveles (nivel)
      on delete restrict on update restrict;

alter table cglperiodico1
   drop constraint fk_cglperio_ref_7895_cgltipoc  cascade;
alter table cglperiodico1
   add constraint fk_cglperio_ref_7895_cgltipoc foreign key (tipo_comp)
      references cgltipocomp (tipo_comp)
      on delete restrict on update restrict;

alter table cglperiodico1
   drop constraint fk_cglperio_reference_350_gralcomp  cascade;
alter table cglperiodico1
   add constraint fk_cglperio_reference_350_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table cglperiodico2
   drop constraint fk_cglperio_ref_7899_cglcuent  cascade;
alter table cglperiodico2
   add constraint fk_cglperio_ref_7899_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table cglperiodico2
   drop constraint fk_cglperio_ref_9616_cglperio  cascade;
alter table cglperiodico2
   add constraint fk_cglperio_ref_9616_cglperio foreign key (compania, secuencia)
      references cglperiodico1 (compania, secuencia)
      on delete cascade on update cascade;

alter table cglperiodico3
   drop constraint fk_cglperio_ref_9936_cglperio  cascade;
alter table cglperiodico3
   add constraint fk_cglperio_ref_9936_cglperio foreign key (compania, secuencia, linea)
      references cglperiodico2 (compania, secuencia, linea)
      on delete cascade on update cascade;

alter table cglperiodico3
   drop constraint fk_cglperio_ref_9946_cglauxil  cascade;
alter table cglperiodico3
   add constraint fk_cglperio_ref_9946_cglauxil foreign key (auxiliar)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cglperiodico4
   drop constraint fk_cglperio_ref_9957_cglperio  cascade;
alter table cglperiodico4
   add constraint fk_cglperio_ref_9957_cglperio foreign key (compania, secuencia, linea)
      references cglperiodico2 (compania, secuencia, linea)
      on delete cascade on update cascade;

alter table cglperiodico4
   drop constraint fk_cglperio_ref_9967_cglauxil  cascade;
alter table cglperiodico4
   add constraint fk_cglperio_ref_9967_cglauxil foreign key (auxiliar)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cglposteo
   drop constraint fk_cglposte_ref_8363_cglcuent  cascade;
alter table cglposteo
   add constraint fk_cglposte_ref_8363_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table cglposteo
   drop constraint fk_cglposte_ref_8388_cgltipoc  cascade;
alter table cglposteo
   add constraint fk_cglposte_ref_8388_cgltipoc foreign key (tipo_comp)
      references cgltipocomp (tipo_comp)
      on delete restrict on update restrict;

alter table cglposteo
   drop constraint fk_cglposte_reference_388_gralperi  cascade;
alter table cglposteo
   add constraint fk_cglposte_reference_388_gralperi foreign key (compania, aplicacion, year, periodo)
      references gralperiodos (compania, aplicacion, year, periodo)
      on delete restrict on update cascade;

alter table cglposteoaux1
   drop constraint fk_cglposte_ref_8370_cglposte  cascade;
alter table cglposteoaux1
   add constraint fk_cglposte_ref_8370_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table cglposteoaux1
   drop constraint fk_cglposte_ref_8382_cglauxil  cascade;
alter table cglposteoaux1
   add constraint fk_cglposte_ref_8382_cglauxil foreign key (auxiliar)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cglposteoaux2
   drop constraint fk_cglposte_ref_8374_cglposte  cascade;
alter table cglposteoaux2
   add constraint fk_cglposte_ref_8374_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table cglposteoaux2
   drop constraint fk_cglposte_ref_8378_cglauxil  cascade;
alter table cglposteoaux2
   add constraint fk_cglposte_ref_8378_cglauxil foreign key (auxiliar)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cglrecurrente
   drop constraint fk_cglrecur_ref_9596_cglperio  cascade;
alter table cglrecurrente
   add constraint fk_cglrecur_ref_9596_cglperio foreign key (compania, secuencia)
      references cglperiodico1 (compania, secuencia)
      on delete restrict on update restrict;

alter table cglrecurrente
   drop constraint fk_cglrecur_reference_355_gralapli  cascade;
alter table cglrecurrente
   add constraint fk_cglrecur_reference_355_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table cglsldoaux1
   drop constraint fk_cglsldoa_ref_7308_cglauxil  cascade;
alter table cglsldoaux1
   add constraint fk_cglsldoa_ref_7308_cglauxil foreign key (auxiliar)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cglsldoaux1
   drop constraint fk_cglsldoa_reference_584_cglsldoc  cascade;
alter table cglsldoaux1
   add constraint fk_cglsldoa_reference_584_cglsldoc foreign key (compania, year, periodo, cuenta)
      references cglsldocuenta (compania, year, periodo, cuenta)
      on delete cascade on update cascade;

alter table cglsldoaux2
   drop constraint fk_cglsldoa_ref_7312_cglauxil  cascade;
alter table cglsldoaux2
   add constraint fk_cglsldoa_ref_7312_cglauxil foreign key (auxiliar)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cglsldoaux2
   drop constraint fk_cglsldoa_reference_585_cglsldoc  cascade;
alter table cglsldoaux2
   add constraint fk_cglsldoa_reference_585_cglsldoc foreign key (compania, year, periodo, cuenta)
      references cglsldocuenta (compania, year, periodo, cuenta)
      on delete cascade on update cascade;

alter table cglsldocuenta
   drop constraint fk_cglsldoc_reference_346_gralcomp  cascade;
alter table cglsldocuenta
   add constraint fk_cglsldoc_reference_346_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table cglsldocuenta
   drop constraint fk_cglsldoc_reference_586_cglcuent  cascade;
alter table cglsldocuenta
   add constraint fk_cglsldoc_reference_586_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table clientes
   drop constraint fk_clientes_ref_120011_vendedor  cascade;
alter table clientes
   add constraint fk_clientes_ref_120011_vendedor foreign key (vendedor)
      references vendedores (codigo)
      on delete restrict on update restrict;

alter table clientes
   drop constraint fk_clientes_ref_125722_listas_d  cascade;
alter table clientes
   add constraint fk_clientes_ref_125722_listas_d foreign key (lista_de_precio)
      references listas_de_precio_1 (secuencia)
      on delete restrict on update restrict;

alter table clientes
   drop constraint fk_clientes_ref_32463_gral_for  cascade;
alter table clientes
   add constraint fk_clientes_ref_32463_gral_for foreign key (forma_pago)
      references gral_forma_de_pago (forma_pago)
      on delete restrict on update restrict;

alter table clientes
   drop constraint fk_clientes_ref_32562_cglcuent  cascade;
alter table clientes
   add constraint fk_clientes_ref_32562_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table clientes
   drop constraint fk_clientes_ref_45637_clientes  cascade;
alter table clientes
   add constraint fk_clientes_ref_45637_clientes foreign key (cli_cliente)
      references clientes (cliente)
      on delete cascade on update cascade;

alter table clientes_agrupados
   drop constraint fk_clientes_ref_32439_clientes  cascade;
alter table clientes_agrupados
   add constraint fk_clientes_ref_32439_clientes foreign key (cliente)
      references clientes (cliente)
      on delete cascade on update cascade;

alter table clientes_agrupados
   drop constraint fk_clientes_ref_32443_gral_val  cascade;
alter table clientes_agrupados
   add constraint fk_clientes_ref_32443_gral_val foreign key (codigo_valor_grupo)
      references gral_valor_grupos (codigo_valor_grupo)
      on delete restrict on update restrict;

alter table clientes_exentos
   drop constraint fk_clientes_reference_502_gral_imp  cascade;
alter table clientes_exentos
   add constraint fk_clientes_reference_502_gral_imp foreign key (impuesto)
      references gral_impuestos (impuesto)
      on delete restrict on update restrict;

alter table clientes_exentos
   drop constraint fk_clientes_reference_503_clientes  cascade;
alter table clientes_exentos
   add constraint fk_clientes_reference_503_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table clientes_exentos
   drop constraint fk_clientes_reference_550_cglcuent  cascade;
alter table clientes_exentos
   add constraint fk_clientes_reference_550_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update restrict;

alter table clientes_x_volumen
   drop constraint fk_clientes_reference_496_clientes  cascade;
alter table clientes_x_volumen
   add constraint fk_clientes_reference_496_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table comparacion_ventas
   drop constraint fk_comparac_reference_480_gral_val  cascade;
alter table comparacion_ventas
   add constraint fk_comparac_reference_480_gral_val foreign key (codigo_valor_grupo)
      references gral_valor_grupos (codigo_valor_grupo)
      on delete restrict on update restrict;

alter table comparacion_ventas
   drop constraint fk_comparac_reference_481_gralcomp  cascade;
alter table comparacion_ventas
   add constraint fk_comparac_reference_481_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table convmedi
   drop constraint fk_convmedi_reference_393_unidad_m  cascade;
alter table convmedi
   add constraint fk_convmedi_reference_393_unidad_m foreign key (old_unidad)
      references unidad_medida (unidad_medida)
      on delete restrict on update restrict;

alter table convmedi
   drop constraint fk_convmedi_reference_394_unidad_m  cascade;
alter table convmedi
   add constraint fk_convmedi_reference_394_unidad_m foreign key (new_unidad)
      references unidad_medida (unidad_medida)
      on delete restrict on update restrict;

alter table cos_calculo
   drop constraint fk_cos_calc_reference_466_cos_prod  cascade;
alter table cos_calculo
   add constraint fk_cos_calc_reference_466_cos_prod foreign key (secuencia, compania, linea)
      references cos_produccion (secuencia, compania, linea)
      on delete cascade on update cascade;

alter table cos_calculo
   drop constraint fk_cos_calc_reference_475_articulo  cascade;
alter table cos_calculo
   add constraint fk_cos_calc_reference_475_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete restrict on update cascade;

alter table cos_consumo
   drop constraint fk_cos_cons_reference_442_cos_trx  cascade;
alter table cos_consumo
   add constraint fk_cos_cons_reference_442_cos_trx foreign key (secuencia, compania)
      references cos_trx (secuencia, compania)
      on delete cascade on update cascade;

alter table cos_consumo
   drop constraint fk_cos_cons_reference_444_unidad_m  cascade;
alter table cos_consumo
   add constraint fk_cos_cons_reference_444_unidad_m foreign key (unidad_medida)
      references unidad_medida (unidad_medida)
      on delete restrict on update restrict;

alter table cos_consumo
   drop constraint fk_cos_cons_reference_446_articulo  cascade;
alter table cos_consumo
   add constraint fk_cos_cons_reference_446_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete restrict on update cascade;

alter table cos_consumo
   drop constraint fk_cos_cons_reference_474_articulo  cascade;
alter table cos_consumo
   add constraint fk_cos_cons_reference_474_articulo foreign key (para_producir)
      references articulos (articulo)
      on delete restrict on update cascade;

alter table cos_consumo_eys2
   drop constraint fk_cos_cons_reference_448_cos_cons  cascade;
alter table cos_consumo_eys2
   add constraint fk_cos_cons_reference_448_cos_cons foreign key (secuencia, compania, linea)
      references cos_consumo (secuencia, compania, linea)
      on delete cascade on update cascade;

alter table cos_consumo_eys2
   drop constraint fk_cos_cons_reference_449_eys2  cascade;
alter table cos_consumo_eys2
   add constraint fk_cos_cons_reference_449_eys2 foreign key (articulo, almacen, no_transaccion, eys2_linea)
      references eys2 (articulo, almacen, no_transaccion, linea)
      on delete cascade on update cascade;

alter table cos_cuenta_rubro
   drop constraint fk_cos_cuen_reference_450_cglcuent  cascade;
alter table cos_cuenta_rubro
   add constraint fk_cos_cuen_reference_450_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table cos_cuenta_rubro
   drop constraint fk_cos_cuen_reference_451_cos_rubr  cascade;
alter table cos_cuenta_rubro
   add constraint fk_cos_cuen_reference_451_cos_rubr foreign key (rubro)
      references cos_rubros (rubro)
      on delete restrict on update restrict;

alter table cos_produccion
   drop constraint fk_cos_prod_reference_443_cos_trx  cascade;
alter table cos_produccion
   add constraint fk_cos_prod_reference_443_cos_trx foreign key (secuencia, compania)
      references cos_trx (secuencia, compania)
      on delete cascade on update cascade;

alter table cos_produccion
   drop constraint fk_cos_prod_reference_445_unidad_m  cascade;
alter table cos_produccion
   add constraint fk_cos_prod_reference_445_unidad_m foreign key (unidad_medida)
      references unidad_medida (unidad_medida)
      on delete restrict on update restrict;

alter table cos_produccion
   drop constraint fk_cos_prod_reference_447_articulo  cascade;
alter table cos_produccion
   add constraint fk_cos_prod_reference_447_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete restrict on update cascade;

alter table cos_produccion_eys2
   drop constraint fk_cos_prod_reference_454_cos_prod  cascade;
alter table cos_produccion_eys2
   add constraint fk_cos_prod_reference_454_cos_prod foreign key (secuencia, compania, linea)
      references cos_produccion (secuencia, compania, linea)
      on delete cascade on update cascade;

alter table cos_produccion_eys2
   drop constraint fk_cos_prod_reference_455_eys2  cascade;
alter table cos_produccion_eys2
   add constraint fk_cos_prod_reference_455_eys2 foreign key (articulo, almacen, no_transaccion, eys2_linea)
      references eys2 (articulo, almacen, no_transaccion, linea)
      on delete cascade on update cascade;

alter table cos_trx
   drop constraint fk_cos_trx_reference_441_gralcomp  cascade;
alter table cos_trx
   add constraint fk_cos_trx_reference_441_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table cxc_estado_de_cuenta
   drop constraint fk_cxc_esta_reference_392_cxcdocm  cascade;
alter table cxc_estado_de_cuenta
   add constraint fk_cxc_esta_reference_392_cxcdocm foreign key (documento, docmto_aplicar, cliente, motivo_cxc, almacen)
      references cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen)
      on delete cascade on update cascade;

alter table cxc_recibo
   drop constraint fk_cxc_reci_reference_497_cxctrx1  cascade;
alter table cxc_recibo
   add constraint fk_cxc_reci_reference_497_cxctrx1 foreign key (sec_ajuste_cxc, almacen)
      references cxctrx1 (sec_ajuste_cxc, almacen)
      on delete cascade on update cascade;

alter table cxc_recibo1
   drop constraint fk_cxc_reci_reference_570_almacen  cascade;
alter table cxc_recibo1
   add constraint fk_cxc_reci_reference_570_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update restrict;

alter table cxc_recibo1
   drop constraint fk_cxc_reci_reference_571_cxcmotiv  cascade;
alter table cxc_recibo1
   add constraint fk_cxc_reci_reference_571_cxcmotiv foreign key (motivo_cxc)
      references cxcmotivos (motivo_cxc)
      on delete restrict on update restrict;

alter table cxc_recibo1
   drop constraint fk_cxc_reci_reference_572_clientes  cascade;
alter table cxc_recibo1
   add constraint fk_cxc_reci_reference_572_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table cxc_recibo1
   drop constraint fk_cxc_reci_reference_574_cobrador  cascade;
alter table cxc_recibo1
   add constraint fk_cxc_reci_reference_574_cobrador foreign key (cobrador)
      references cobradores (cobrador)
      on delete restrict on update cascade;

alter table cxc_recibo2
   drop constraint fk_cxc_reci_reference_573_cxc_reci  cascade;
alter table cxc_recibo2
   add constraint fk_cxc_reci_reference_573_cxc_reci foreign key (almacen, consecutivo)
      references cxc_recibo1 (almacen, consecutivo)
      on delete cascade on update cascade;

alter table cxc_recibo3
   drop constraint fk_cxc_reci_reference_575_cxc_reci  cascade;
alter table cxc_recibo3
   add constraint fk_cxc_reci_reference_575_cxc_reci foreign key (almacen, consecutivo)
      references cxc_recibo1 (almacen, consecutivo)
      on delete cascade on update cascade;

alter table cxc_recibo3
   drop constraint fk_cxc_reci_reference_576_cglcuent  cascade;
alter table cxc_recibo3
   add constraint fk_cxc_reci_reference_576_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table cxc_recibo3
   drop constraint fk_cxc_reci_reference_577_cglauxil  cascade;
alter table cxc_recibo3
   add constraint fk_cxc_reci_reference_577_cglauxil foreign key (auxiliar)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cxc_recibo4
   drop constraint fk_cxc_reci_reference_578_cxc_reci  cascade;
alter table cxc_recibo4
   add constraint fk_cxc_reci_reference_578_cxc_reci foreign key (almacen, consecutivo)
      references cxc_recibo1 (almacen, consecutivo)
      on delete cascade on update cascade;

alter table cxc_recibo5
   drop constraint fk_cxc_reci_reference_579_cxc_reci  cascade;
alter table cxc_recibo5
   add constraint fk_cxc_reci_reference_579_cxc_reci foreign key (almacen, consecutivo)
      references cxc_recibo4 (almacen, consecutivo)
      on delete cascade on update cascade;

alter table cxc_recibo_detalle
   drop constraint fk_cxc_reci_reference_544_cxc_reci  cascade;
alter table cxc_recibo_detalle
   add constraint fk_cxc_reci_reference_544_cxc_reci foreign key (sec_ajuste_cxc, almacen)
      references cxc_recibo (sec_ajuste_cxc, almacen)
      on delete cascade on update cascade;

alter table cxc_saldos_iniciales
   drop constraint fk_cxc_sald_reference_462_clientes  cascade;
alter table cxc_saldos_iniciales
   add constraint fk_cxc_sald_reference_462_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table cxc_saldos_iniciales
   drop constraint fk_cxc_sald_reference_463_almacen  cascade;
alter table cxc_saldos_iniciales
   add constraint fk_cxc_sald_reference_463_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;

alter table cxc_saldos_iniciales
   drop constraint fk_cxc_sald_reference_464_cxcmotiv  cascade;
alter table cxc_saldos_iniciales
   add constraint fk_cxc_sald_reference_464_cxcmotiv foreign key (motivo_cxc)
      references cxcmotivos (motivo_cxc)
      on delete restrict on update cascade;

alter table cxcbalance
   drop constraint fk_cxcbalan_ref_32545_clientes  cascade;
alter table cxcbalance
   add constraint fk_cxcbalan_ref_32545_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table cxcbalance
   drop constraint fk_cxcbalan_ref_32549_gralperi  cascade;
alter table cxcbalance
   add constraint fk_cxcbalan_ref_32549_gralperi foreign key (compania, aplicacion, year, periodo)
      references gralperiodos (compania, aplicacion, year, periodo)
      on delete restrict on update restrict;

alter table cxcdocm
   drop constraint fk_cxcdocm_ref_37155_clientes  cascade;
alter table cxcdocm
   add constraint fk_cxcdocm_ref_37155_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table cxcdocm
   drop constraint fk_cxcdocm_ref_37159_cxcmotiv  cascade;
alter table cxcdocm
   add constraint fk_cxcdocm_ref_37159_cxcmotiv foreign key (motivo_cxc)
      references cxcmotivos (motivo_cxc)
      on delete restrict on update cascade;

alter table cxcdocm
   drop constraint fk_cxcdocm_ref_37167_almacen  cascade;
alter table cxcdocm
   add constraint fk_cxcdocm_ref_37167_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;

alter table cxcdocm
   drop constraint fk_cxcdocm_ref_37303_cxcdocm  cascade;
alter table cxcdocm
   add constraint fk_cxcdocm_ref_37303_cxcdocm foreign key (docmto_aplicar, docmto_ref, cliente, motivo_ref, almacen)
      references cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen)
      on delete restrict on update restrict;

alter table cxcdocm
   drop constraint fk_cxcdocm_ref_81850_gralapli  cascade;
alter table cxcdocm
   add constraint fk_cxcdocm_ref_81850_gralapli foreign key (aplicacion_origen)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table cxcfact1
   drop constraint fk_cxcfact1_ref_34059_clientes  cascade;
alter table cxcfact1
   add constraint fk_cxcfact1_ref_34059_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table cxcfact1
   drop constraint fk_cxcfact1_ref_34063_almacen  cascade;
alter table cxcfact1
   add constraint fk_cxcfact1_ref_34063_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;

alter table cxcfact1
   drop constraint fk_cxcfact1_ref_34067_gral_for  cascade;
alter table cxcfact1
   add constraint fk_cxcfact1_ref_34067_gral_for foreign key (forma_pago)
      references gral_forma_de_pago (forma_pago)
      on delete restrict on update restrict;

alter table cxcfact1
   drop constraint fk_cxcfact1_ref_35603_cxcmotiv  cascade;
alter table cxcfact1
   add constraint fk_cxcfact1_ref_35603_cxcmotiv foreign key (motivo_cxc)
      references cxcmotivos (motivo_cxc)
      on delete restrict on update cascade;

alter table cxcfact1
   drop constraint fk_cxcfact1_reference_511_gralapli  cascade;
alter table cxcfact1
   add constraint fk_cxcfact1_reference_511_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table cxcfact2
   drop constraint fk_cxcfact2_ref_34072_cxcfact1  cascade;
alter table cxcfact2
   add constraint fk_cxcfact2_ref_34072_cxcfact1 foreign key (almacen, no_factura)
      references cxcfact1 (almacen, no_factura)
      on delete cascade on update cascade;

alter table cxcfact2
   drop constraint fk_cxcfact2_ref_35575_cglcuent  cascade;
alter table cxcfact2
   add constraint fk_cxcfact2_ref_35575_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table cxcfact2
   drop constraint fk_cxcfact2_ref_35592_rubros_f  cascade;
alter table cxcfact2
   add constraint fk_cxcfact2_ref_35592_rubros_f foreign key (rubro_fact_cxc)
      references rubros_fact_cxc (rubro_fact_cxc)
      on delete restrict on update restrict;

alter table cxcfact2
   drop constraint fk_cxcfact2_ref_45615_cglauxil  cascade;
alter table cxcfact2
   add constraint fk_cxcfact2_ref_45615_cglauxil foreign key (auxiliar1)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cxcfact2
   drop constraint fk_cxcfact2_ref_45619_cglauxil  cascade;
alter table cxcfact2
   add constraint fk_cxcfact2_ref_45619_cglauxil foreign key (auxiliar2)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cxcfact3
   drop constraint fk_cxcfact3_ref_35585_cxcfact1  cascade;
alter table cxcfact3
   add constraint fk_cxcfact3_ref_35585_cxcfact1 foreign key (almacen, no_factura)
      references cxcfact1 (almacen, no_factura)
      on delete cascade on update cascade;

alter table cxcfact3
   drop constraint fk_cxcfact3_ref_38815_cxcmotiv  cascade;
alter table cxcfact3
   add constraint fk_cxcfact3_ref_38815_cxcmotiv foreign key (motivo_cxc)
      references cxcmotivos (motivo_cxc)
      on delete restrict on update cascade;

alter table cxchdocm
   drop constraint fk_cxchdocm_reference_651_clientes  cascade;
alter table cxchdocm
   add constraint fk_cxchdocm_reference_651_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update restrict;

alter table cxchdocm
   drop constraint fk_cxchdocm_reference_652_cxcmotiv  cascade;
alter table cxchdocm
   add constraint fk_cxchdocm_reference_652_cxcmotiv foreign key (motivo_cxc)
      references cxcmotivos (motivo_cxc)
      on delete restrict on update restrict;

alter table cxchdocm
   drop constraint fk_cxchdocm_reference_653_almacen  cascade;
alter table cxchdocm
   add constraint fk_cxchdocm_reference_653_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update restrict;

alter table cxchdocm
   drop constraint fk_cxchdocm_reference_654_cxchdocm  cascade;
alter table cxchdocm
   add constraint fk_cxchdocm_reference_654_cxchdocm foreign key (docmto_aplicar, docmto_ref, cliente, motivo_ref, almacen)
      references cxchdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen)
      on delete restrict on update restrict;

alter table cxcmotivos
   drop constraint fk_cxcmotiv_ref_82779_cgltipoc  cascade;
alter table cxcmotivos
   add constraint fk_cxcmotiv_ref_82779_cgltipoc foreign key (tipo_comp)
      references cgltipocomp (tipo_comp)
      on delete restrict on update restrict;

alter table cxcrecibo1
   drop constraint fk_cxcrecib_ref_38746_clientes  cascade;
alter table cxcrecibo1
   add constraint fk_cxcrecib_ref_38746_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table cxcrecibo1
   drop constraint fk_cxcrecib_ref_38750_almacen  cascade;
alter table cxcrecibo1
   add constraint fk_cxcrecib_ref_38750_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;

alter table cxcrecibo1
   drop constraint fk_cxcrecib_ref_38754_cxcmotiv  cascade;
alter table cxcrecibo1
   add constraint fk_cxcrecib_ref_38754_cxcmotiv foreign key (motivo_cxc)
      references cxcmotivos (motivo_cxc)
      on delete restrict on update cascade;

alter table cxcrecibo2
   drop constraint fk_cxcrecib_ref_38758_cxcrecib  cascade;
alter table cxcrecibo2
   add constraint fk_cxcrecib_ref_38758_cxcrecib foreign key (no_recibo, almacen)
      references cxcrecibo1 (no_recibo, almacen)
      on delete restrict on update restrict;

alter table cxcrecibo2
   drop constraint fk_cxcrecib_ref_38819_cxcmotiv  cascade;
alter table cxcrecibo2
   add constraint fk_cxcrecib_ref_38819_cxcmotiv foreign key (motivo_cxc)
      references cxcmotivos (motivo_cxc)
      on delete restrict on update cascade;

alter table cxctrx1
   drop constraint fk_cxctrx1_ref_32495_cxcmotiv  cascade;
alter table cxctrx1
   add constraint fk_cxctrx1_ref_32495_cxcmotiv foreign key (motivo_cxc)
      references cxcmotivos (motivo_cxc)
      on delete restrict on update cascade;

alter table cxctrx1
   drop constraint fk_cxctrx1_ref_32499_clientes  cascade;
alter table cxctrx1
   add constraint fk_cxctrx1_ref_32499_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table cxctrx1
   drop constraint fk_cxctrx1_ref_38779_almacen  cascade;
alter table cxctrx1
   add constraint fk_cxctrx1_ref_38779_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;

alter table cxctrx1
   drop constraint fk_cxctrx1_reference_345_cobrador  cascade;
alter table cxctrx1
   add constraint fk_cxctrx1_reference_345_cobrador foreign key (cobrador)
      references cobradores (cobrador)
      on delete restrict on update cascade;

alter table cxctrx1
   drop constraint fk_cxctrx1_reference_505_gralapli  cascade;
alter table cxctrx1
   add constraint fk_cxctrx1_reference_505_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table cxctrx2
   drop constraint fk_cxctrx2_ref_38790_cxctrx1  cascade;
alter table cxctrx2
   add constraint fk_cxctrx2_ref_38790_cxctrx1 foreign key (sec_ajuste_cxc, almacen)
      references cxctrx1 (sec_ajuste_cxc, almacen)
      on delete cascade on update cascade;

alter table cxctrx2
   drop constraint fk_cxctrx2_ref_38811_cxcmotiv  cascade;
alter table cxctrx2
   add constraint fk_cxctrx2_ref_38811_cxcmotiv foreign key (motivo_cxc)
      references cxcmotivos (motivo_cxc)
      on delete restrict on update cascade;

alter table cxctrx3
   drop constraint fk_cxctrx3_ref_32532_cglcuent  cascade;
alter table cxctrx3
   add constraint fk_cxctrx3_ref_32532_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table cxctrx3
   drop constraint fk_cxctrx3_ref_38783_cxctrx1  cascade;
alter table cxctrx3
   add constraint fk_cxctrx3_ref_38783_cxctrx1 foreign key (sec_ajuste_cxc, almacen)
      references cxctrx1 (sec_ajuste_cxc, almacen)
      on delete cascade on update cascade;

alter table cxctrx3
   drop constraint fk_cxctrx3_ref_45599_cglauxil  cascade;
alter table cxctrx3
   add constraint fk_cxctrx3_ref_45599_cglauxil foreign key (auxiliar1)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cxctrx3
   drop constraint fk_cxctrx3_ref_45603_cglauxil  cascade;
alter table cxctrx3
   add constraint fk_cxctrx3_ref_45603_cglauxil foreign key (auxiliar2)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cxp_saldos_iniciales
   drop constraint fk_cxp_sald_reference_479_proveedo  cascade;
alter table cxp_saldos_iniciales
   add constraint fk_cxp_sald_reference_479_proveedo foreign key (proveedor)
      references proveedores (proveedor)
      on delete restrict on update restrict;

alter table cxp_saldos_iniciales
   drop constraint fk_cxp_sald_reference_512_gralcomp  cascade;
alter table cxp_saldos_iniciales
   add constraint fk_cxp_sald_reference_512_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table cxp_saldos_iniciales
   drop constraint fk_cxp_sald_reference_513_cxpmotiv  cascade;
alter table cxp_saldos_iniciales
   add constraint fk_cxp_sald_reference_513_cxpmotiv foreign key (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on delete restrict on update restrict;

alter table cxpajuste1
   drop constraint fk_cxpajust_ref_23665_proveedo  cascade;
alter table cxpajuste1
   add constraint fk_cxpajust_ref_23665_proveedo foreign key (proveedor)
      references proveedores (proveedor)
      on delete restrict on update restrict;

alter table cxpajuste1
   drop constraint fk_cxpajust_ref_23679_gralcomp  cascade;
alter table cxpajuste1
   add constraint fk_cxpajust_ref_23679_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table cxpajuste1
   drop constraint fk_cxpajust_ref_25851_cxpmotiv  cascade;
alter table cxpajuste1
   add constraint fk_cxpajust_ref_25851_cxpmotiv foreign key (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on delete restrict on update cascade;

alter table cxpajuste1
   drop constraint fk_cxpajust_ref_28363_cxpmotiv  cascade;
alter table cxpajuste1
   add constraint fk_cxpajust_ref_28363_cxpmotiv foreign key (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on delete restrict on update cascade;

alter table cxpajuste1
   drop constraint fk_cxpajust_reference_508_gralapli  cascade;
alter table cxpajuste1
   add constraint fk_cxpajust_reference_508_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table cxpajuste2
   drop constraint fk_cxpajust_ref_25787_cxpajust  cascade;
alter table cxpajuste2
   add constraint fk_cxpajust_ref_25787_cxpajust foreign key (compania, sec_ajuste_cxp)
      references cxpajuste1 (compania, sec_ajuste_cxp)
      on delete cascade on update cascade;

alter table cxpajuste2
   drop constraint fk_cxpajust_ref_38823_cxpmotiv  cascade;
alter table cxpajuste2
   add constraint fk_cxpajust_ref_38823_cxpmotiv foreign key (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on delete restrict on update cascade;

alter table cxpajuste3
   drop constraint fk_cxpajust_ref_25794_cxpajust  cascade;
alter table cxpajuste3
   add constraint fk_cxpajust_ref_25794_cxpajust foreign key (compania, sec_ajuste_cxp)
      references cxpajuste1 (compania, sec_ajuste_cxp)
      on delete cascade on update cascade;

alter table cxpajuste3
   drop constraint fk_cxpajust_ref_25804_cglcuent  cascade;
alter table cxpajuste3
   add constraint fk_cxpajust_ref_25804_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table cxpajuste3
   drop constraint fk_cxpajust_ref_45624_cglauxil  cascade;
alter table cxpajuste3
   add constraint fk_cxpajust_ref_45624_cglauxil foreign key (auxiliar1)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cxpajuste3
   drop constraint fk_cxpajust_ref_45628_cglauxil  cascade;
alter table cxpajuste3
   add constraint fk_cxpajust_ref_45628_cglauxil foreign key (auxiliar2)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cxpbalance
   drop constraint fk_cxpbalan_ref_27041_gralperi  cascade;
alter table cxpbalance
   add constraint fk_cxpbalan_ref_27041_gralperi foreign key (compania, aplicacion, year, periodo)
      references gralperiodos (compania, aplicacion, year, periodo)
      on delete restrict on update restrict;

alter table cxpbalance
   drop constraint fk_cxpbalan_ref_27054_proveedo  cascade;
alter table cxpbalance
   add constraint fk_cxpbalan_ref_27054_proveedo foreign key (proveedor)
      references proveedores (proveedor)
      on delete restrict on update restrict;

alter table cxpdocm
   drop constraint fk_cxpdocm_ref_25811_proveedo  cascade;
alter table cxpdocm
   add constraint fk_cxpdocm_ref_25811_proveedo foreign key (proveedor)
      references proveedores (proveedor)
      on delete restrict on update restrict;

alter table cxpdocm
   drop constraint fk_cxpdocm_ref_25815_gralcomp  cascade;
alter table cxpdocm
   add constraint fk_cxpdocm_ref_25815_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table cxpdocm
   drop constraint fk_cxpdocm_ref_41007_gralapli  cascade;
alter table cxpdocm
   add constraint fk_cxpdocm_ref_41007_gralapli foreign key (aplicacion_origen)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table cxpdocm
   drop constraint fk_cxpdocm_reference_587_cxpdocm  cascade;
alter table cxpdocm
   add constraint fk_cxpdocm_reference_587_cxpdocm foreign key (proveedor, compania, docmto_aplicar, docmto_aplicar_ref, motivo_cxp_ref)
      references cxpdocm (proveedor, compania, documento, docmto_aplicar, motivo_cxp)
      on delete restrict on update restrict;

alter table cxpdocm
   drop constraint fk_cxpdocm_reference_588_cxpmotiv  cascade;
alter table cxpdocm
   add constraint fk_cxpdocm_reference_588_cxpmotiv foreign key (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on delete restrict on update restrict;

alter table cxpfact1
   drop constraint fk_cxpfact1_ref_22592_proveedo  cascade;
alter table cxpfact1
   add constraint fk_cxpfact1_ref_22592_proveedo foreign key (proveedor)
      references proveedores (proveedor)
      on delete restrict on update restrict;

alter table cxpfact1
   drop constraint fk_cxpfact1_ref_22597_gral_for  cascade;
alter table cxpfact1
   add constraint fk_cxpfact1_ref_22597_gral_for foreign key (forma_pago)
      references gral_forma_de_pago (forma_pago)
      on delete restrict on update restrict;

alter table cxpfact1
   drop constraint fk_cxpfact1_ref_22656_oc1  cascade;
alter table cxpfact1
   add constraint fk_cxpfact1_ref_22656_oc1 foreign key (numero_oc, compania)
      references oc1 (numero_oc, compania)
      on delete restrict on update restrict;

alter table cxpfact1
   drop constraint fk_cxpfact1_ref_23669_gralcomp  cascade;
alter table cxpfact1
   add constraint fk_cxpfact1_ref_23669_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table cxpfact1
   drop constraint fk_cxpfact1_ref_25847_cxpmotiv  cascade;
alter table cxpfact1
   add constraint fk_cxpfact1_ref_25847_cxpmotiv foreign key (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on delete restrict on update cascade;

alter table cxpfact1
   drop constraint fk_cxpfact1_ref_43431_gralapli  cascade;
alter table cxpfact1
   add constraint fk_cxpfact1_ref_43431_gralapli foreign key (aplicacion_origen)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table cxpfact2
   drop constraint fk_cxpfact2_ref_22635_cxpfact1  cascade;
alter table cxpfact2
   add constraint fk_cxpfact2_ref_22635_cxpfact1 foreign key (proveedor, fact_proveedor, compania)
      references cxpfact1 (proveedor, fact_proveedor, compania)
      on delete cascade on update cascade;

alter table cxpfact2
   drop constraint fk_cxpfact2_ref_22642_rubros_f  cascade;
alter table cxpfact2
   add constraint fk_cxpfact2_ref_22642_rubros_f foreign key (rubro_fact_cxp)
      references rubros_fact_cxp (rubro_fact_cxp)
      on delete restrict on update restrict;

alter table cxpfact2
   drop constraint fk_cxpfact2_ref_54544_cglauxil  cascade;
alter table cxpfact2
   add constraint fk_cxpfact2_ref_54544_cglauxil foreign key (auxiliar1)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cxpfact2
   drop constraint fk_cxpfact2_ref_54548_cglauxil  cascade;
alter table cxpfact2
   add constraint fk_cxpfact2_ref_54548_cglauxil foreign key (auxiliar2)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table cxpfact2
   drop constraint fk_cxpfact2_ref_64317_cglcuent  cascade;
alter table cxpfact2
   add constraint fk_cxpfact2_ref_64317_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table cxpfact3
   drop constraint fk_cxpfact3_ref_22660_cxpfact1  cascade;
alter table cxpfact3
   add constraint fk_cxpfact3_ref_22660_cxpfact1 foreign key (proveedor, fact_proveedor, compania)
      references cxpfact1 (proveedor, fact_proveedor, compania)
      on delete cascade on update cascade;

alter table cxpfact3
   drop constraint fk_cxpfact3_ref_38827_cxpmotiv  cascade;
alter table cxpfact3
   add constraint fk_cxpfact3_ref_38827_cxpmotiv foreign key (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on delete restrict on update cascade;

alter table cxphdocm
   drop constraint fk_cxphdocm_reference_546_cxphdocm  cascade;
alter table cxphdocm
   add constraint fk_cxphdocm_reference_546_cxphdocm foreign key (proveedor, compania, docmto_aplicar, docmto_aplicar_ref, motivo_cxp_ref)
      references cxphdocm (proveedor, compania, documento, docmto_aplicar, motivo_cxp)
      on delete restrict on update cascade;

alter table cxpmorosidad
   drop constraint fk_cxpmoros_ref_91487_proveedo  cascade;
alter table cxpmorosidad
   add constraint fk_cxpmoros_ref_91487_proveedo foreign key (proveedor)
      references proveedores (proveedor)
      on delete restrict on update restrict;

alter table cxpmorosidad
   drop constraint fk_cxpmoros_ref_91500_gralcomp  cascade;
alter table cxpmorosidad
   add constraint fk_cxpmoros_ref_91500_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table cxpmorosidad
   drop constraint fk_cxpmoros_ref_91503_cxpmotiv  cascade;
alter table cxpmorosidad
   add constraint fk_cxpmoros_ref_91503_cxpmotiv foreign key (motivo_cxp)
      references cxpmotivos (motivo_cxp)
      on delete restrict on update cascade;

alter table cxpmotivos
   drop constraint fk_cxpmotiv_ref_78940_cgltipoc  cascade;
alter table cxpmotivos
   add constraint fk_cxpmotiv_ref_78940_cgltipoc foreign key (tipo_comp)
      references cgltipocomp (tipo_comp)
      on delete restrict on update restrict;

alter table descuentos_por_articulo
   drop constraint fk_descuent_ref_104707_articulo  cascade;
alter table descuentos_por_articulo
   add constraint fk_descuent_ref_104707_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete restrict on update cascade;

alter table descuentos_por_articulo
   drop constraint fk_descuent_ref_104714_descuent  cascade;
alter table descuentos_por_articulo
   add constraint fk_descuent_ref_104714_descuent foreign key (secuencia)
      references descuentos (secuencia)
      on delete cascade on update cascade;

alter table descuentos_por_cliente
   drop constraint fk_descuent_ref_104698_descuent  cascade;
alter table descuentos_por_cliente
   add constraint fk_descuent_ref_104698_descuent foreign key (secuencia)
      references descuentos (secuencia)
      on delete cascade on update cascade;

alter table descuentos_por_cliente
   drop constraint fk_descuent_ref_104702_clientes  cascade;
alter table descuentos_por_cliente
   add constraint fk_descuent_ref_104702_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table descuentos_por_grupo
   drop constraint fk_descuent_ref_104689_descuent  cascade;
alter table descuentos_por_grupo
   add constraint fk_descuent_ref_104689_descuent foreign key (secuencia)
      references descuentos (secuencia)
      on delete cascade on update cascade;

alter table descuentos_por_grupo
   drop constraint fk_descuent_ref_104693_gral_val  cascade;
alter table descuentos_por_grupo
   add constraint fk_descuent_ref_104693_gral_val foreign key (codigo_valor_grupo)
      references gral_valor_grupos (codigo_valor_grupo)
      on delete restrict on update restrict;

alter table div_libro_d_acciones
   drop constraint fk_div_libr_reference_528_div_grup  cascade;
alter table div_libro_d_acciones
   add constraint fk_div_libr_reference_528_div_grup foreign key (grupo)
      references div_grupos (grupo)
      on delete restrict on update restrict;

alter table div_libro_d_acciones
   drop constraint fk_div_libr_reference_529_div_soci  cascade;
alter table div_libro_d_acciones
   add constraint fk_div_libr_reference_529_div_soci foreign key (socio)
      references div_socios (socio)
      on delete restrict on update restrict;

alter table div_movimientos
   drop constraint fk_div_movi_reference_428_div_soci  cascade;
alter table div_movimientos
   add constraint fk_div_movi_reference_428_div_soci foreign key (socio)
      references div_socios (socio)
      on delete restrict on update restrict;

alter table div_movimientos
   drop constraint fk_div_movi_reference_429_div_para  cascade;
alter table div_movimientos
   add constraint fk_div_movi_reference_429_div_para foreign key (fecha)
      references div_parametros_de_pago (fecha)
      on delete restrict on update restrict;

alter table div_movimientos
   drop constraint fk_div_movi_reference_430_bcocheck  cascade;
alter table div_movimientos
   add constraint fk_div_movi_reference_430_bcocheck foreign key (cod_ctabco, no_cheque, motivo_bco)
      references bcocheck1 (cod_ctabco, no_cheque, motivo_bco)
      on delete restrict on update cascade;

alter table div_socios
   drop constraint fk_div_soci_reference_489_div_grup  cascade;
alter table div_socios
   add constraint fk_div_soci_reference_489_div_grup foreign key (grupo)
      references div_grupos (grupo)
      on delete restrict on update restrict;

alter table encuesta
   drop constraint fk_encuesta_ref_13_cantidad  cascade;
alter table encuesta
   add constraint fk_encuesta_ref_13_cantidad foreign key (codigo_de_rango)
      references cantidad_de_empleados (codigo_de_rango)
      on delete restrict on update restrict;

alter table encuesta
   drop constraint fk_encuesta_ref_22_origen_d  cascade;
alter table encuesta
   add constraint fk_encuesta_ref_22_origen_d foreign key (codigo_de_origen)
      references origen_del_sistema (codigo_de_origen)
      on delete restrict on update restrict;

alter table encuesta
   drop constraint fk_encuesta_ref_5_tipo_de_  cascade;
alter table encuesta
   add constraint fk_encuesta_ref_5_tipo_de_ foreign key (tipo_empresa)
      references tipo_de_empresa (tipo_empresa)
      on delete restrict on update restrict;

alter table eys1
   drop constraint fk_eys1_ref_13993_almacen  cascade;
alter table eys1
   add constraint fk_eys1_ref_13993_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;

alter table eys1
   drop constraint fk_eys1_ref_14011_invmotiv  cascade;
alter table eys1
   add constraint fk_eys1_ref_14011_invmotiv foreign key (motivo)
      references invmotivos (motivo)
      on delete restrict on update restrict;

alter table eys2
   drop constraint fk_eys2_ref_14746_articulo  cascade;
alter table eys2
   add constraint fk_eys2_ref_14746_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete restrict on update cascade;

alter table eys2
   drop constraint fk_eys2_ref_14753_eys1  cascade;
alter table eys2
   add constraint fk_eys2_ref_14753_eys1 foreign key (almacen, no_transaccion)
      references eys1 (almacen, no_transaccion)
      on delete cascade on update cascade;

alter table eys3
   drop constraint fk_eys3_ref_41979_eys1  cascade;
alter table eys3
   add constraint fk_eys3_ref_41979_eys1 foreign key (almacen, no_transaccion)
      references eys1 (almacen, no_transaccion)
      on delete cascade on update cascade;

alter table eys3
   drop constraint fk_eys3_ref_42010_cglcuent  cascade;
alter table eys3
   add constraint fk_eys3_ref_42010_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table eys3
   drop constraint fk_eys3_ref_55595_cglauxil  cascade;
alter table eys3
   add constraint fk_eys3_ref_55595_cglauxil foreign key (auxiliar1)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table eys3
   drop constraint fk_eys3_ref_55599_cglauxil  cascade;
alter table eys3
   add constraint fk_eys3_ref_55599_cglauxil foreign key (auxiliar2)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table eys4
   drop constraint fk_eys4_ref_171571_eys2  cascade;
alter table eys4
   add constraint fk_eys4_ref_171571_eys2 foreign key (articulo, almacen, no_transaccion, inv_linea)
      references eys2 (articulo, almacen, no_transaccion, linea)
      on delete cascade on update cascade;

alter table eys4
   drop constraint fk_eys4_ref_171584_cxpfact2  cascade;
alter table eys4
   add constraint fk_eys4_ref_171584_cxpfact2 foreign key (proveedor, fact_proveedor, rubro_fact_cxp, cxp_linea, compania)
      references cxpfact2 (proveedor, fact_proveedor, rubro_fact_cxp, linea, compania)
      on delete cascade on update cascade;

alter table eys6
   drop constraint fk_eys61_reference_eys2  cascade;
alter table eys6
   add constraint fk_eys61_reference_eys2 foreign key (articulo, almacen, no_transaccion, linea)
      references eys2 (articulo, almacen, no_transaccion, linea)
      on delete cascade on update cascade;

alter table eys6
   drop constraint fk_eys62_reference_eys2  cascade;
alter table eys6
   add constraint fk_eys62_reference_eys2 foreign key (articulo, almacen, compra_no_transaccion, compra_linea)
      references eys2 (articulo, almacen, no_transaccion, linea)
      on delete cascade on update cascade;

alter table f_conytram
   drop constraint fk_f_conytr_reference_492_clientes  cascade;
alter table f_conytram
   add constraint fk_f_conytr_reference_492_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table f_conytram
   drop constraint fk_f_conytr_reference_493_almacen  cascade;
alter table f_conytram
   add constraint fk_f_conytr_reference_493_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;

alter table f_conytram
   drop constraint fk_f_conytr_reference_494_factmoti  cascade;
alter table f_conytram
   add constraint fk_f_conytr_reference_494_factmoti foreign key (tipo)
      references factmotivos (tipo)
      on delete restrict on update cascade;

alter table f_conytram
   drop constraint fk_f_conytr_reference_495_bcocheck  cascade;
alter table f_conytram
   add constraint fk_f_conytr_reference_495_bcocheck foreign key (cod_ctabco, ck_aduana, motivo_bco)
      references bcocheck1 (cod_ctabco, no_cheque, motivo_bco)
      on delete restrict on update cascade;

alter table f_conytram
   drop constraint fk_f_conytr_reference_499_choferes  cascade;
alter table f_conytram
   add constraint fk_f_conytr_reference_499_choferes foreign key (chofer)
      references choferes (chofer)
      on delete restrict on update cascade;

alter table f_conytram
   drop constraint fk_f_conytr_reference_500_corredor  cascade;
alter table f_conytram
   add constraint fk_f_conytr_reference_500_corredor foreign key (licencia)
      references corredores (licencia)
      on delete restrict on update cascade;

alter table fac_cambio_de_precios
   drop constraint fk_fac_camb_reference_539_articulo  cascade;
alter table fac_cambio_de_precios
   add constraint fk_fac_camb_reference_539_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete cascade on update cascade;

alter table fac_ciudades
   drop constraint fk_fac_ciud_reference_527_fac_pais  cascade;
alter table fac_ciudades
   add constraint fk_fac_ciud_reference_527_fac_pais foreign key (pais)
      references fac_paises (pais)
      on delete restrict on update restrict;

alter table fac_desc_x_cliente
   drop constraint fk_fac_desc_reference_523_clientes  cascade;
alter table fac_desc_x_cliente
   add constraint fk_fac_desc_reference_523_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update restrict;

alter table fac_desc_x_cliente
   drop constraint fk_fac_desc_reference_524_articulo  cascade;
alter table fac_desc_x_cliente
   add constraint fk_fac_desc_reference_524_articulo foreign key (articulo)
      references articulos (articulo)
      on delete restrict on update cascade;

alter table fac_parametros_contables
   drop constraint fk_fac_para_reference_597_gral_val  cascade;
alter table fac_parametros_contables
   add constraint fk_fac_para_reference_597_gral_val foreign key (codigo_valor_grupo)
      references gral_valor_grupos (codigo_valor_grupo)
      on delete restrict on update restrict;

alter table fac_parametros_contables
   drop constraint fk_fac_para_reference_598_almacen  cascade;
alter table fac_parametros_contables
   add constraint fk_fac_para_reference_598_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update restrict;

alter table fac_parametros_contables
   drop constraint fk_fac_param_contab_cta_ingreso  cascade;
alter table fac_parametros_contables
   add constraint fk_fac_param_contab_cta_ingreso foreign key (cta_de_ingreso)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table fac_parametros_contables
   drop constraint fk_fac_param_contab_cta_costo  cascade;
alter table fac_parametros_contables
   add constraint fk_fac_param_contab_cta_costo foreign key (cta_de_costo)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table fac_parametros_contables
   drop constraint fk_fac_para_reference_601_fact_ref  cascade;
alter table fac_parametros_contables
   add constraint fk_fac_para_reference_601_fact_ref foreign key (referencia)
      references fact_referencias (referencia)
      on delete restrict on update restrict;

alter table fac_parametros_contables
   drop constraint fk_fac_para_reference_679_cglcuent  cascade;
alter table fac_parametros_contables
   add constraint fk_fac_para_reference_679_cglcuent foreign key (vtas_exentas)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table fac_parametros_contables
   drop constraint fk_fac_para_reference_680_cglcuent  cascade;
alter table fac_parametros_contables
   add constraint fk_fac_para_reference_680_cglcuent foreign key (cta_de_gasto)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table fac_promociones
   drop constraint fk_fac_prom_reference_510_articulo  cascade;
alter table fac_promociones
   add constraint fk_fac_prom_reference_510_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete restrict on update cascade;

alter table fac_resumen_semanal
   drop constraint fk_fac_resu_reference_564_fact_ref  cascade;
alter table fac_resumen_semanal
   add constraint fk_fac_resu_reference_564_fact_ref foreign key (referencia)
      references fact_referencias (referencia)
      on delete restrict on update cascade;

alter table fac_vtas_vs_cobros
   drop constraint fk_fac_vtas_reference_541_clientes  cascade;
alter table fac_vtas_vs_cobros
   add constraint fk_fac_vtas_reference_541_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update restrict;

alter table fac_vtas_vs_cobros
   drop constraint fk_fac_vtas_reference_542_almacen  cascade;
alter table fac_vtas_vs_cobros
   add constraint fk_fac_vtas_reference_542_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update restrict;

alter table facparamcgl
   drop constraint fk_facparam_ref_147351_gral_val  cascade;
alter table facparamcgl
   add constraint fk_facparam_ref_147351_gral_val foreign key (codigo_valor_grupo)
      references gral_valor_grupos (codigo_valor_grupo)
      on delete restrict on update restrict;

alter table facparamcgl
   drop constraint fk_facparam_ref_147355_almacen  cascade;
alter table facparamcgl
   add constraint fk_facparam_ref_147355_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;

alter table facparamcgl
   drop constraint fk_facparam_ref_147359_cglauxil  cascade;
alter table facparamcgl
   add constraint fk_facparam_ref_147359_cglauxil foreign key (auxiliar1_ingreso)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table facparamcgl
   drop constraint fk_facparam_ref_147363_cglauxil  cascade;
alter table facparamcgl
   add constraint fk_facparam_ref_147363_cglauxil foreign key (auxiliar2_ingreso)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table facparamcgl
   drop constraint fk_facparam_ref_147367_cglcuent  cascade;
alter table facparamcgl
   add constraint fk_facparam_ref_147367_cglcuent foreign key (cuenta_ingreso)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table facparamcgl
   drop constraint fk_facparam_ref_179082_cglcuent  cascade;
alter table facparamcgl
   add constraint fk_facparam_ref_179082_cglcuent foreign key (cuenta_costo)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table facparamcgl
   drop constraint fk_facparam_ref_180259_cglauxil  cascade;
alter table facparamcgl
   add constraint fk_facparam_ref_180259_cglauxil foreign key (auxiliar1_costo)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table facparamcgl
   drop constraint fk_facparam_ref_180263_cglauxil  cascade;
alter table facparamcgl
   add constraint fk_facparam_ref_180263_cglauxil foreign key (auxiliar2_costo)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table fact_autoriza_descto
   drop constraint fk_fact_aut_reference_549_gral_usu  cascade;
alter table fact_autoriza_descto
   add constraint fk_fact_aut_reference_549_gral_usu foreign key (usuario)
      references gral_usuarios (usuario)
      on delete restrict on update restrict;

alter table fact_estadisticas
   drop constraint fk_fact_est_reference_483_articulo  cascade;
alter table fact_estadisticas
   add constraint fk_fact_est_reference_483_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete restrict on update cascade;

alter table fact_estadisticas
   drop constraint fk_fact_est_reference_484_gral_for  cascade;
alter table fact_estadisticas
   add constraint fk_fact_est_reference_484_gral_for foreign key (forma_pago)
      references gral_forma_de_pago (forma_pago)
      on delete restrict on update restrict;

alter table fact_estadisticas
   drop constraint fk_fact_est_reference_485_vendedor  cascade;
alter table fact_estadisticas
   add constraint fk_fact_est_reference_485_vendedor foreign key (vendedor)
      references vendedores (codigo)
      on delete restrict on update restrict;

alter table fact_informe_ventas
   drop constraint fk_fact_inf_reference_391_almacen  cascade;
alter table fact_informe_ventas
   add constraint fk_fact_inf_reference_391_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;

alter table fact_list_despachos
   drop constraint fk_fact_lis_reference_490_factura1  cascade;
alter table fact_list_despachos
   add constraint fk_fact_lis_reference_490_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table factmotivos
   drop constraint fk_factmoti_ref_152276_cgltipoc  cascade;
alter table factmotivos
   add constraint fk_factmoti_ref_152276_cgltipoc foreign key (tipo_comp)
      references cgltipocomp (tipo_comp)
      on delete restrict on update restrict;

alter table factmotivos
   drop constraint fk_factmoti_reference_387_invmotiv  cascade;
alter table factmotivos
   add constraint fk_factmoti_reference_387_invmotiv foreign key (motivo)
      references invmotivos (motivo)
      on delete restrict on update restrict;

alter table factsobregiro
   drop constraint fk_factsobr_reference_343_clientes  cascade;
alter table factsobregiro
   add constraint fk_factsobr_reference_343_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table factura1
   drop constraint fk_factura1_ref_100942_vendedor  cascade;
alter table factura1
   add constraint fk_factura1_ref_100942_vendedor foreign key (codigo_vendedor)
      references vendedores (codigo)
      on delete restrict on update restrict;

alter table factura1
   drop constraint fk_factura1_ref_99208_almacen  cascade;
alter table factura1
   add constraint fk_factura1_ref_99208_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;

alter table factura1
   drop constraint fk_factura1_ref_99219_factmoti  cascade;
alter table factura1
   add constraint fk_factura1_ref_99219_factmoti foreign key (tipo)
      references factmotivos (tipo)
      on delete restrict on update cascade;

alter table factura1
   drop constraint fk_factura1_ref_99224_clientes  cascade;
alter table factura1
   add constraint fk_factura1_ref_99224_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table factura1
   drop constraint fk_factura1_ref_99230_gral_for  cascade;
alter table factura1
   add constraint fk_factura1_ref_99230_gral_for foreign key (forma_pago)
      references gral_forma_de_pago (forma_pago)
      on delete restrict on update restrict;

alter table factura1
   drop constraint fk_factura1_reference_504_gralapli  cascade;
alter table factura1
   add constraint fk_factura1_reference_504_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table factura1
   drop constraint fk_factura1_reference_514_fact_ref  cascade;
alter table factura1
   add constraint fk_factura1_reference_514_fact_ref foreign key (referencia)
      references fact_referencias (referencia)
      on delete restrict on update cascade;

alter table factura1
   drop constraint fk_factura1_ciu_origen  cascade;
alter table factura1
   add constraint fk_factura1_ciu_origen foreign key (ciudad_origen)
      references fac_ciudades (ciudad)
      on delete restrict on update restrict;

alter table factura1
   drop constraint fk_factura1_ciu_destino  cascade;
alter table factura1
   add constraint fk_factura1_ciu_destino foreign key (ciudad_destino)
      references fac_ciudades (ciudad)
      on delete restrict on update restrict;

alter table factura1
   drop constraint fk_factura1_reference_605_clientes  cascade;
alter table factura1
   add constraint fk_factura1_reference_605_clientes foreign key (agente)
      references clientes (cliente)
      on delete restrict on update restrict;

alter table factura1
   drop constraint fk_factura1_reference_663_destinos  cascade;
alter table factura1
   add constraint fk_factura1_reference_663_destinos foreign key (cod_destino)
      references destinos (cod_destino)
      on delete restrict on update restrict;

alter table factura1
   drop constraint fk_factura1_reference_664_navieras  cascade;
alter table factura1
   add constraint fk_factura1_reference_664_navieras foreign key (cod_naviera)
      references navieras (cod_naviera)
      on delete restrict on update restrict;

alter table factura1
   drop constraint fk_factura1_reference_665_fact_ref  cascade;
alter table factura1
   add constraint fk_factura1_reference_665_fact_ref foreign key (referencia)
      references fact_referencias (referencia)
      on delete restrict on update restrict;

alter table factura2
   drop constraint fk_factura2_ref_102680_factura1  cascade;
alter table factura2
   add constraint fk_factura2_ref_102680_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table factura2
   drop constraint fk_factura2_articulos_por_almacen  cascade;
alter table factura2
   add constraint fk_factura2_articulos_por_almacen foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete restrict on update cascade;

alter table factura2
   drop constraint fk_factura2_reference_518_unidad_m  cascade;
alter table factura2
   add constraint fk_factura2_reference_518_unidad_m foreign key (unidad_medida)
      references unidad_medida (unidad_medida)
      on delete restrict on update restrict;

alter table factura2_eys2
   drop constraint fk_factura2_ref_173539_eys2  cascade;
alter table factura2_eys2
   add constraint fk_factura2_ref_173539_eys2 foreign key (articulo, almacen, no_transaccion, eys2_linea)
      references eys2 (articulo, almacen, no_transaccion, linea)
      on delete cascade on update cascade;

alter table factura2_eys2
   drop constraint fk_factura2_ref_173552_factura2  cascade;
alter table factura2_eys2
   add constraint fk_factura2_ref_173552_factura2 foreign key (almacen, tipo, num_documento, factura2_linea)
      references factura2 (almacen, tipo, num_documento, linea)
      on delete cascade on update cascade;

alter table factura3
   drop constraint fk_factura3_ref_102712_factura2  cascade;
alter table factura3
   add constraint fk_factura3_ref_102712_factura2 foreign key (almacen, tipo, num_documento, linea)
      references factura2 (almacen, tipo, num_documento, linea)
      on delete cascade on update cascade;

alter table factura3
   drop constraint fk_factura3_reference_562_gral_imp  cascade;
alter table factura3
   add constraint fk_factura3_reference_562_gral_imp foreign key (impuesto)
      references gral_impuestos (impuesto)
      on delete restrict on update cascade;

alter table factura4
   drop constraint fk_factura4_ref_102747_factura1  cascade;
alter table factura4
   add constraint fk_factura4_ref_102747_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table factura4
   drop constraint fk_factura4_ref_102757_rubros_f  cascade;
alter table factura4
   add constraint fk_factura4_ref_102757_rubros_f foreign key (rubro_fact_cxc)
      references rubros_fact_cxc (rubro_fact_cxc)
      on delete restrict on update restrict;

alter table factura5
   drop constraint fk_factura5_ref_108492_factura1  cascade;
alter table factura5
   add constraint fk_factura5_ref_108492_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table factura5
   drop constraint fk_factura5_ref_108502_bancos  cascade;
alter table factura5
   add constraint fk_factura5_ref_108502_bancos foreign key (banco)
      references bancos (banco)
      on delete restrict on update cascade;

alter table factura6
   drop constraint fk_factura6_ref_108509_factura1  cascade;
alter table factura6
   add constraint fk_factura6_ref_108509_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table factura6
   drop constraint fk_factura6_ref_108519_bancos  cascade;
alter table factura6
   add constraint fk_factura6_ref_108519_bancos foreign key (banco)
      references bancos (banco)
      on delete restrict on update cascade;

alter table factura7
   drop constraint fk_factura7_ref_135160_factura1  cascade;
alter table factura7
   add constraint fk_factura7_ref_135160_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table funcionarios_cliente
   drop constraint fk_funciona_ref_32454_clientes  cascade;
alter table funcionarios_cliente
   add constraint fk_funciona_ref_32454_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table funcionarios_proveedor
   drop constraint fk_funciona_ref_19659_proveedo  cascade;
alter table funcionarios_proveedor
   add constraint fk_funciona_ref_19659_proveedo foreign key (proveedor)
      references proveedores (proveedor)
      on delete restrict on update restrict;

alter table gral_app_x_usuario
   drop constraint fk_gral_app_reference_568_gral_usu  cascade;
alter table gral_app_x_usuario
   add constraint fk_gral_app_reference_568_gral_usu foreign key (usuario)
      references gral_usuarios (usuario)
      on delete cascade on update cascade;

alter table gral_app_x_usuario
   drop constraint fk_gral_app_reference_569_gralapli  cascade;
alter table gral_app_x_usuario
   add constraint fk_gral_app_reference_569_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table gral_grupos_aplicacion
   drop constraint fk_gral_gru_ref_20647_gralapli  cascade;
alter table gral_grupos_aplicacion
   add constraint fk_gral_gru_ref_20647_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table gral_impuestos
   drop constraint fk_gral_imp_ref_60450_cglauxil  cascade;
alter table gral_impuestos
   add constraint fk_gral_imp_ref_60450_cglauxil foreign key (auxiliar1)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table gral_impuestos
   drop constraint fk_gral_imp_ref_60454_cglauxil  cascade;
alter table gral_impuestos
   add constraint fk_gral_imp_ref_60454_cglauxil foreign key (auxiliar2)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table gral_impuestos
   drop constraint fk_gral_imp_ref_60462_cglcuent  cascade;
alter table gral_impuestos
   add constraint fk_gral_imp_ref_60462_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table gral_valor_grupos
   drop constraint fk_gral_val_ref_20651_gral_gru  cascade;
alter table gral_valor_grupos
   add constraint fk_gral_val_ref_20651_gral_gru foreign key (grupo, aplicacion)
      references gral_grupos_aplicacion (grupo, aplicacion)
      on delete cascade on update cascade;

alter table gral_valor_grupos
   drop constraint fk_gral_val_ref_50384_gral_val  cascade;
alter table gral_valor_grupos
   add constraint fk_gral_val_ref_50384_gral_val foreign key (gra_codigo_valor_grupo)
      references gral_valor_grupos (codigo_valor_grupo)
      on delete cascade on update cascade;

alter table gralparametros
   drop constraint fk_gralpara_ref_20626_gralapli  cascade;
alter table gralparametros
   add constraint fk_gralpara_ref_20626_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table gralparaxapli
   drop constraint fk_gralpara_ref_68724_gralpara  cascade;
alter table gralparaxapli
   add constraint fk_gralpara_ref_68724_gralpara foreign key (parametro, aplicacion)
      references gralparametros (parametro, aplicacion)
      on delete restrict on update restrict;

alter table gralparaxcia
   drop constraint fk_gralpara_ref_692_gralcomp  cascade;
alter table gralparaxcia
   add constraint fk_gralpara_ref_692_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table gralparaxcia
   drop constraint fk_gralpara_ref_697_gralpara  cascade;
alter table gralparaxcia
   add constraint fk_gralpara_ref_697_gralpara foreign key (parametro, aplicacion)
      references gralparametros (parametro, aplicacion)
      on delete restrict on update restrict;

alter table gralperiodos
   drop constraint fk_gralperi_ref_15380_gralcomp  cascade;
alter table gralperiodos
   add constraint fk_gralperi_ref_15380_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table gralperiodos
   drop constraint fk_gralperi_reference_357_gralapli  cascade;
alter table gralperiodos
   add constraint fk_gralperi_reference_357_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table gralsecuencias
   drop constraint fk_gralsecu_ref_20630_gralapli  cascade;
alter table gralsecuencias
   add constraint fk_gralsecu_ref_20630_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;

alter table gralsecxcia
   drop constraint fk_gralsecx_ref_15383_gralperi  cascade;
alter table gralsecxcia
   add constraint fk_gralsecx_ref_15383_gralperi foreign key (compania, aplicacion, year, periodo)
      references gralperiodos (compania, aplicacion, year, periodo)
      on delete restrict on update restrict;

alter table gralsecxcia
   drop constraint fk_gralsecx_ref_714_gralsecu  cascade;
alter table gralsecxcia
   add constraint fk_gralsecx_ref_714_gralsecu foreign key (aplicacion, parametro)
      references gralsecuencias (aplicacion, parametro)
      on delete restrict on update restrict;

alter table hp_barcos
   drop constraint fk_hp_barco_reference_538_hp_molin  cascade;
alter table hp_barcos
   add constraint fk_hp_barco_reference_538_hp_molin foreign key (molino)
      references hp_molinos (molino)
      on delete restrict on update restrict;

alter table imp_oc
   drop constraint fk_imp_oc_ref_62804_gral_imp  cascade;
alter table imp_oc
   add constraint fk_imp_oc_ref_62804_gral_imp foreign key (impuesto)
      references gral_impuestos (impuesto)
      on delete restrict on update restrict;

alter table imp_oc
   drop constraint fk_imp_oc_ref_62808_rubros_f  cascade;
alter table imp_oc
   add constraint fk_imp_oc_ref_62808_rubros_f foreign key (rubro_fact_cxp)
      references rubros_fact_cxp (rubro_fact_cxp)
      on delete restrict on update restrict;

alter table impuestos_facturacion
   drop constraint fk_impuesto_ref_102726_gral_imp  cascade;
alter table impuestos_facturacion
   add constraint fk_impuesto_ref_102726_gral_imp foreign key (impuesto)
      references gral_impuestos (impuesto)
      on delete restrict on update restrict;

alter table impuestos_facturacion
   drop constraint fk_impuesto_ref_102730_rubros_f  cascade;
alter table impuestos_facturacion
   add constraint fk_impuesto_ref_102730_rubros_f foreign key (rubro_fact_cxc)
      references rubros_fact_cxc (rubro_fact_cxc)
      on delete restrict on update restrict;

alter table impuestos_por_grupo
   drop constraint fk_impuesto_ref_142238_gral_val  cascade;
alter table impuestos_por_grupo
   add constraint fk_impuesto_ref_142238_gral_val foreign key (codigo_valor_grupo)
      references gral_valor_grupos (codigo_valor_grupo)
      on delete restrict on update restrict;

alter table impuestos_por_grupo
   drop constraint fk_impuesto_ref_142242_gral_imp  cascade;
alter table impuestos_por_grupo
   add constraint fk_impuesto_ref_142242_gral_imp foreign key (impuesto)
      references gral_impuestos (impuesto)
      on delete restrict on update restrict;

alter table inv_conteo
   drop constraint fk_inv_cont_reference_669_articulo  cascade;
alter table inv_conteo
   add constraint fk_inv_cont_reference_669_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete cascade on update cascade;

alter table inv_conversion
   drop constraint fk_inv_conv_reference_339_unidad_m  cascade;
alter table inv_conversion
   add constraint fk_inv_conv_reference_339_unidad_m foreign key (convertir_d)
      references unidad_medida (unidad_medida)
      on delete restrict on update restrict;

alter table inv_conversion
   drop constraint fk_inv_conv_reference_340_unidad_m  cascade;
alter table inv_conversion
   add constraint fk_inv_conv_reference_340_unidad_m foreign key (convertir_a)
      references unidad_medida (unidad_medida)
      on delete restrict on update restrict;

alter table inv_fifo_lifo
   drop constraint fk_inv_fifo_reference_468_articulo  cascade;
alter table inv_fifo_lifo
   add constraint fk_inv_fifo_reference_468_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete cascade on update cascade;

alter table inv_fisico1
   drop constraint fk_inv_fisi_ref_16179_almacen  cascade;
alter table inv_fisico1
   add constraint fk_inv_fisi_ref_16179_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;

alter table inv_fisico2
   drop constraint fk_inv_fisi_ref_16183_articulo  cascade;
alter table inv_fisico2
   add constraint fk_inv_fisi_ref_16183_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete restrict on update cascade;

alter table inv_fisico2
   drop constraint fk_inv_fisi_ref_16194_inv_fisi  cascade;
alter table inv_fisico2
   add constraint fk_inv_fisi_ref_16194_inv_fisi foreign key (almacen, secuencia)
      references inv_fisico1 (almacen, secuencia)
      on delete cascade on update cascade;

alter table inv_list_balance
   drop constraint fk_inv_list_reference_551_articulo  cascade;
alter table inv_list_balance
   add constraint fk_inv_list_reference_551_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete cascade on update cascade;

alter table inv_list_sugerencias
   drop constraint fk_inv_list_reference_554_articulo  cascade;
alter table inv_list_sugerencias
   add constraint fk_inv_list_reference_554_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete cascade on update cascade;

alter table inv_movimientos
   drop constraint fk_inv_movi_reference_477_invmotiv  cascade;
alter table inv_movimientos
   add constraint fk_inv_movi_reference_477_invmotiv foreign key (motivo)
      references invmotivos (motivo)
      on delete restrict on update restrict;

alter table inv_prestamos
   drop constraint fk_inv_pres_reference_563_articulo  cascade;
alter table inv_prestamos
   add constraint fk_inv_pres_reference_563_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete restrict on update cascade;

alter table invbalance
   drop constraint fk_invbalan_ref_15405_gralperi  cascade;
alter table invbalance
   add constraint fk_invbalan_ref_15405_gralperi foreign key (compania, aplicacion, year, periodo)
      references gralperiodos (compania, aplicacion, year, periodo)
      on delete restrict on update restrict;

alter table invbalance
   drop constraint fk_invbalan_ref_27065_articulo  cascade;
alter table invbalance
   add constraint fk_invbalan_ref_27065_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete restrict on update cascade;

alter table invmotivos
   drop constraint fk_invmotiv_ref_80481_cgltipoc  cascade;
alter table invmotivos
   add constraint fk_invmotiv_ref_80481_cgltipoc foreign key (tipo_comp)
      references cgltipocomp (tipo_comp)
      on delete restrict on update restrict;

alter table invparal
   drop constraint fk_invparal_ref_38767_almacen  cascade;
alter table invparal
   add constraint fk_invparal_ref_38767_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;

alter table invparal
   drop constraint fk_invparal_ref_38771_gralpara  cascade;
alter table invparal
   add constraint fk_invparal_ref_38771_gralpara foreign key (parametro, aplicacion)
      references gralparametros (parametro, aplicacion)
      on delete restrict on update restrict;

alter table invparal
   drop constraint fk_invparal_reference_336_gralpara  cascade;
alter table invparal
   add constraint fk_invparal_reference_336_gralpara foreign key (parametro, aplicacion)
      references gralparametros (parametro, aplicacion)
      on delete restrict on update restrict;

alter table invparal
   drop constraint fk_invparal_reference_337_almacen  cascade;
alter table invparal
   add constraint fk_invparal_reference_337_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;

alter table listas_de_precio_2
   drop constraint fk_listas_d_ref_106557_listas_d  cascade;
alter table listas_de_precio_2
   add constraint fk_listas_d_ref_106557_listas_d foreign key (secuencia)
      references listas_de_precio_1 (secuencia)
      on delete restrict on update restrict;

alter table listas_de_precio_2
   drop constraint fk_listas_d_ref_106561_articulo  cascade;
alter table listas_de_precio_2
   add constraint fk_listas_d_ref_106561_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete restrict on update cascade;

alter table navieras
   drop constraint fk_navieras_reference_649_proveedo  cascade;
alter table navieras
   add constraint fk_navieras_reference_649_proveedo foreign key (proveedor)
      references proveedores (proveedor)
      on delete restrict on update cascade;

alter table nom_ajuste_pagos_acreedores
   drop constraint fk_nom_ajus_reference_432_nomacrem  cascade;
alter table nom_ajuste_pagos_acreedores
   add constraint fk_nom_ajus_reference_432_nomacrem foreign key (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      references nomacrem (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      on delete restrict on update cascade;

alter table nom_conceptos_para_calculo
   drop constraint fk_nom_conc_ref_213653_nomconce  cascade;
alter table nom_conceptos_para_calculo
   add constraint fk_nom_conc_ref_213653_nomconce foreign key (cod_concepto_planilla)
      references nomconce (cod_concepto_planilla)
      on delete cascade on update cascade;

alter table nom_conceptos_para_calculo
   drop constraint fk_nom_conc_ref_657_nomconce  cascade;
alter table nom_conceptos_para_calculo
   add constraint fk_nom_conc_ref_657_nomconce foreign key (concepto_aplica)
      references nomconce (cod_concepto_planilla)
      on delete cascade on update cascade;

alter table nom_otros_ingresos
   drop constraint fk_nom_otro_ref_216217_nom_tipo  cascade;
alter table nom_otros_ingresos
   add constraint fk_nom_otro_ref_216217_nom_tipo foreign key (tipo_calculo)
      references nom_tipo_de_calculo (tipo_calculo)
      on delete restrict on update restrict;

alter table nom_otros_ingresos
   drop constraint fk_nom_otro_ref_216221_nomtpla2  cascade;
alter table nom_otros_ingresos
   add constraint fk_nom_otro_ref_216221_nomtpla2 foreign key (tipo_planilla, numero_planilla, year)
      references nomtpla2 (tipo_planilla, numero_planilla, year)
      on delete restrict on update restrict;

alter table nom_otros_ingresos
   drop constraint fk_nom_otro_ref_216231_rhuempl  cascade;
alter table nom_otros_ingresos
   add constraint fk_nom_otro_ref_216231_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table nom_otros_ingresos
   drop constraint fk_nom_otro_ref_216240_nomconce  cascade;
alter table nom_otros_ingresos
   add constraint fk_nom_otro_ref_216240_nomconce foreign key (cod_concepto_planilla)
      references nomconce (cod_concepto_planilla)
      on delete restrict on update restrict;

alter table nomacrem
   drop constraint fk_nomacrem_ref_192916_rhuempl  cascade;
alter table nomacrem
   add constraint fk_nomacrem_ref_192916_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table nomacrem
   drop constraint fk_nomacrem_ref_192920_cglcuent  cascade;
alter table nomacrem
   add constraint fk_nomacrem_ref_192920_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table nomacrem
   drop constraint fk_nomacrem_ref_192924_rhuacre  cascade;
alter table nomacrem
   add constraint fk_nomacrem_ref_192924_rhuacre foreign key (cod_acreedores)
      references rhuacre (cod_acreedores)
      on delete restrict on update restrict;

alter table nomacrem
   drop constraint fk_nomacrem_ref_192935_nomconce  cascade;
alter table nomacrem
   add constraint fk_nomacrem_ref_192935_nomconce foreign key (cod_concepto_planilla)
      references nomconce (cod_concepto_planilla)
      on delete restrict on update restrict;

alter table nomconce
   drop constraint fk_nomconce_reference_376_cglcuent  cascade;
alter table nomconce
   add constraint fk_nomconce_reference_376_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table nomconce
   drop constraint fk_nomconce_reference_407_nomtipod  cascade;
alter table nomconce
   add constraint fk_nomconce_reference_407_nomtipod foreign key (tipodeconcepto)
      references nomtipodeconcepto (tipodeconcepto)
      on delete restrict on update restrict;

alter table nomctrac
   drop constraint fk_nomctrac_ref_207135_nomtpla2  cascade;
alter table nomctrac
   add constraint fk_nomctrac_ref_207135_nomtpla2 foreign key (tipo_planilla, numero_planilla, year)
      references nomtpla2 (tipo_planilla, numero_planilla, year)
      on delete restrict on update restrict;

alter table nomctrac
   drop constraint fk_nomctrac_reference_368_nomconce  cascade;
alter table nomctrac
   add constraint fk_nomctrac_reference_368_nomconce foreign key (cod_concepto_planilla)
      references nomconce (cod_concepto_planilla)
      on delete restrict on update restrict;

alter table nomctrac
   drop constraint fk_nomctrac_reference_369_nom_tipo  cascade;
alter table nomctrac
   add constraint fk_nomctrac_reference_369_nom_tipo foreign key (tipo_calculo)
      references nom_tipo_de_calculo (tipo_calculo)
      on delete restrict on update restrict;

alter table nomctrac
   drop constraint fk_nomctrac_reference_414_bcocheck  cascade;
alter table nomctrac
   add constraint fk_nomctrac_reference_414_bcocheck foreign key (cod_ctabco, no_cheque, motivo_bco)
      references bcocheck1 (cod_ctabco, no_cheque, motivo_bco)
      on delete restrict on update cascade;

alter table nomctrac
   drop constraint fk_nomctrac_reference_440_rhuempl  cascade;
alter table nomctrac
   add constraint fk_nomctrac_reference_440_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table nomdedu
   drop constraint fk_nomdedu_ref_209656_nomacrem  cascade;
alter table nomdedu
   add constraint fk_nomdedu_ref_209656_nomacrem foreign key (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      references nomacrem (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      on delete cascade on update cascade;

alter table nomdedu
   drop constraint fk_nomdedu_ref_209669_nomperio  cascade;
alter table nomdedu
   add constraint fk_nomdedu_ref_209669_nomperio foreign key (periodo)
      references nomperiodos (periodo)
      on delete restrict on update restrict;

alter table nomdescuentos
   drop constraint fk_nomdescu_reference_403_nomctrac  cascade;
alter table nomdescuentos
   add constraint fk_nomdescu_reference_403_nomctrac foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;

alter table nomdescuentos
   drop constraint fk_nomdescu_reference_404_nomacrem  cascade;
alter table nomdescuentos
   add constraint fk_nomdescu_reference_404_nomacrem foreign key (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      references nomacrem (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      on delete restrict on update cascade;

alter table nomdescuentos
   drop constraint fk_nomdescu_reference_413_bcocheck  cascade;
alter table nomdescuentos
   add constraint fk_nomdescu_reference_413_bcocheck foreign key (cod_ctabco, no_cheque, motivo_bco)
      references bcocheck1 (cod_ctabco, no_cheque, motivo_bco)
      on delete restrict on update cascade;

alter table nomdfer
   drop constraint fk_nomdfer_reference_383_nomtipod  cascade;
alter table nomdfer
   add constraint fk_nomdfer_reference_383_nomtipod foreign key (tipodhora)
      references nomtipodehoras (tipodhora)
      on delete restrict on update restrict;

alter table nomhoras
   drop constraint fk_nomhoras_ref_193017_nomhrtra  cascade;
alter table nomhoras
   add constraint fk_nomhoras_ref_193017_nomhrtra foreign key (fecha_laborable, codigo_empleado, compania, tipo_planilla, numero_planilla, fecha_salida)
      references nomhrtrab (fecha_laborable, codigo_empleado, compania, tipo_planilla, numero_planilla, fecha_salida)
      on delete cascade on update cascade;

alter table nomhoras
   drop constraint fk_nomhoras_reference_381_nomtipod  cascade;
alter table nomhoras
   add constraint fk_nomhoras_reference_381_nomtipod foreign key (tipodhora)
      references nomtipodehoras (tipodhora)
      on delete restrict on update restrict;

alter table nomhoras
   drop constraint fk_nomhoras_reference_399_nomtpla2  cascade;
alter table nomhoras
   add constraint fk_nomhoras_reference_399_nomtpla2 foreign key (tipo_planilla, numero_planilla, year)
      references nomtpla2 (tipo_planilla, numero_planilla, year)
      on delete restrict on update restrict;

alter table nomhrtrab
   drop constraint fk_nomhrtra_ref_192992_rhuempl  cascade;
alter table nomhrtrab
   add constraint fk_nomhrtra_ref_192992_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table nomhrtrab
   drop constraint fk_nomhrtra_ref_193001_rhuturno  cascade;
alter table nomhrtrab
   add constraint fk_nomhrtra_ref_193001_rhuturno foreign key (cod_id_turnos)
      references rhuturno (cod_id_turnos)
      on delete restrict on update restrict;

alter table nomhrtrab
   drop constraint fk_nomhrtra_ref_207116_nomtpla2  cascade;
alter table nomhrtrab
   add constraint fk_nomhrtra_ref_207116_nomtpla2 foreign key (tipo_planilla, numero_planilla, year)
      references nomtpla2 (tipo_planilla, numero_planilla, year)
      on delete restrict on update restrict;

alter table nomrelac
   drop constraint fk_nomrelac_ref_192944_nom_tipo  cascade;
alter table nomrelac
   add constraint fk_nomrelac_ref_192944_nom_tipo foreign key (tipo_calculo)
      references nom_tipo_de_calculo (tipo_calculo)
      on delete restrict on update restrict;

alter table nomrelac
   drop constraint fk_nomrelac_ref_192948_nomconce  cascade;
alter table nomrelac
   add constraint fk_nomrelac_ref_192948_nomconce foreign key (cod_concepto_planilla)
      references nomconce (cod_concepto_planilla)
      on delete restrict on update restrict;

alter table nomtpla2
   drop constraint fk_nomtpla2_ref_207108_nomtpla  cascade;
alter table nomtpla2
   add constraint fk_nomtpla2_ref_207108_nomtpla foreign key (tipo_planilla)
      references nomtpla (tipo_planilla)
      on delete cascade on update cascade;

alter table nomtpla2
   drop constraint fk_nomtpla2_ref_209651_nomperio  cascade;
alter table nomtpla2
   add constraint fk_nomtpla2_ref_209651_nomperio foreign key (periodo)
      references nomperiodos (periodo)
      on delete restrict on update restrict;

alter table oc1
   drop constraint fk_oc1_ref_17828_proveedo  cascade;
alter table oc1
   add constraint fk_oc1_ref_17828_proveedo foreign key (proveedor)
      references proveedores (proveedor)
      on delete restrict on update restrict;

alter table oc1
   drop constraint fk_oc1_ref_17840_gral_for  cascade;
alter table oc1
   add constraint fk_oc1_ref_17840_gral_for foreign key (forma_pago)
      references gral_forma_de_pago (forma_pago)
      on delete restrict on update restrict;

alter table oc1
   drop constraint fk_oc1_ref_61603_gralcomp  cascade;
alter table oc1
   add constraint fk_oc1_ref_61603_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table oc2
   drop constraint fk_oc2_ref_17848_articulo  cascade;
alter table oc2
   add constraint fk_oc2_ref_17848_articulo foreign key (articulo)
      references articulos (articulo)
      on delete restrict on update cascade;

alter table oc2
   drop constraint fk_oc2_ref_97841_oc1  cascade;
alter table oc2
   add constraint fk_oc2_ref_97841_oc1 foreign key (numero_oc, compania)
      references oc1 (numero_oc, compania)
      on delete cascade on update cascade;

alter table oc2
   drop constraint fk_oc2_reference_615_tal_ot2  cascade;
alter table oc2
   add constraint fk_oc2_reference_615_tal_ot2 foreign key (no_orden, tipo, almacen, linea, articulo)
      references tal_ot2 (no_orden, tipo, almacen, linea, articulo)
      on delete restrict on update cascade;

alter table oc3
   drop constraint fk_oc3_ref_96514_imp_oc  cascade;
alter table oc3
   add constraint fk_oc3_ref_96514_imp_oc foreign key (impuesto)
      references imp_oc (impuesto)
      on delete restrict on update restrict;

alter table oc3
   drop constraint fk_oc3_ref_97834_oc1  cascade;
alter table oc3
   add constraint fk_oc3_ref_97834_oc1 foreign key (numero_oc, compania)
      references oc1 (numero_oc, compania)
      on delete cascade on update cascade;

alter table oc4
   drop constraint fk_oc4_ref_17874_otros_ca  cascade;
alter table oc4
   add constraint fk_oc4_ref_17874_otros_ca foreign key (tipo_de_cargo)
      references otros_cargos (tipo_de_cargo)
      on delete restrict on update restrict;

alter table oc4
   drop constraint fk_oc4_ref_97827_oc1  cascade;
alter table oc4
   add constraint fk_oc4_ref_97827_oc1 foreign key (numero_oc, compania)
      references oc1 (numero_oc, compania)
      on delete cascade on update cascade;

alter table otros_cargos
   drop constraint fk_otros_ca_ref_62799_rubros_f  cascade;
alter table otros_cargos
   add constraint fk_otros_ca_ref_62799_rubros_f foreign key (rubro_fact_cxp)
      references rubros_fact_cxp (rubro_fact_cxp)
      on delete restrict on update restrict;

alter table pat
   drop constraint fk_pat_reference_424_gralcomp  cascade;
alter table pat
   add constraint fk_pat_reference_424_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table pat_listado
   drop constraint fk_pat_list_reference_425_gralcomp  cascade;
alter table pat_listado
   add constraint fk_pat_list_reference_425_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table periodos_depre
   drop constraint fk_periodos_reference_352_gralcomp  cascade;
alter table periodos_depre
   add constraint fk_periodos_reference_352_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table pla_afectacion_contable
   drop constraint fk_pla_afec_reference_396_departam  cascade;
alter table pla_afectacion_contable
   add constraint fk_pla_afec_reference_396_departam foreign key (departamento)
      references departamentos (codigo)
      on delete restrict on update restrict;

alter table pla_afectacion_contable
   drop constraint fk_pla_afec_reference_397_cglcuent  cascade;
alter table pla_afectacion_contable
   add constraint fk_pla_afec_reference_397_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table pla_afectacion_contable
   drop constraint fk_pla_afec_reference_398_nomconce  cascade;
alter table pla_afectacion_contable
   add constraint fk_pla_afec_reference_398_nomconce foreign key (cod_concepto_planilla)
      references nomconce (cod_concepto_planilla)
      on delete restrict on update restrict;

alter table pla_ajuste_renta
   drop constraint fk_pla_ajus_reference_486_rhuempl  cascade;
alter table pla_ajuste_renta
   add constraint fk_pla_ajus_reference_486_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table pla_anexo03
   drop constraint fk_pla_anex_reference_459_rhuempl  cascade;
alter table pla_anexo03
   add constraint fk_pla_anex_reference_459_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table pla_balance_acreedores
   drop constraint fk_pla_bala_reference_456_nomacrem  cascade;
alter table pla_balance_acreedores
   add constraint fk_pla_bala_reference_456_nomacrem foreign key (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      references nomacrem (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      on delete cascade on update cascade;

alter table pla_bases_del_calculo
   drop constraint fk_pla_base_reference_543_nomctrac  cascade;
alter table pla_bases_del_calculo
   add constraint fk_pla_base_reference_543_nomctrac foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;

alter table pla_bonos_proyectado
   drop constraint fk_pla_bono_reference_533_rhuempl  cascade;
alter table pla_bonos_proyectado
   add constraint fk_pla_bono_reference_533_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete cascade on update cascade;

alter table pla_carta_ayt
   drop constraint fk_pla_cart_reference_478_rhuempl  cascade;
alter table pla_carta_ayt
   add constraint fk_pla_cart_reference_478_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table pla_comprobante_conceptos
   drop constraint reference_532  cascade;
alter table pla_comprobante_conceptos
   add constraint reference_532 foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;

alter table pla_comprobante_de_pago
   drop constraint fk_pla_comp_reference_540_nomctrac  cascade;
alter table pla_comprobante_de_pago
   add constraint fk_pla_comp_reference_540_nomctrac foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;

alter table pla_comprobante_horas
   drop constraint fk_pla_comp_reference_535_pla_comp  cascade;
alter table pla_comprobante_horas
   add constraint fk_pla_comp_reference_535_pla_comp foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento, usuario)
      references pla_comprobante_conceptos (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento, usuario)
      on delete cascade on update cascade;

alter table pla_comprobante_horas
   drop constraint fk_pla_comp_reference_536_nomtipod  cascade;
alter table pla_comprobante_horas
   add constraint fk_pla_comp_reference_536_nomtipod foreign key (tipodhora)
      references nomtipodehoras (tipodhora)
      on delete cascade on update cascade;

alter table pla_constancias
   drop constraint fk_pla_cons_reference_457_rhuempl  cascade;
alter table pla_constancias
   add constraint fk_pla_cons_reference_457_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table pla_desgloce_horas
   drop constraint fk_pla_desg_reference_453_nomhoras  cascade;
alter table pla_desgloce_horas
   add constraint fk_pla_desg_reference_453_nomhoras foreign key (fecha_laborable, codigo_empleado, compania, tipo_planilla, numero_planilla, fecha_salida, tipodhora, year, acumula)
      references nomhoras (fecha_laborable, codigo_empleado, compania, tipo_planilla, numero_planilla, fecha_salida, tipodhora, year, acumula)
      on delete cascade on update cascade;

alter table pla_desgloce_planilla
   drop constraint fk_pla_desg_reference_452_nomctrac  cascade;
alter table pla_desgloce_planilla
   add constraint fk_pla_desg_reference_452_nomctrac foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;

alter table pla_desglose_de_monedas
   drop constraint fk_pla_desg_reference_602_rhuempl  cascade;
alter table pla_desglose_de_monedas
   add constraint fk_pla_desg_reference_602_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete cascade on update cascade;

alter table pla_desglose_de_monedas
   drop constraint fk_pla_desg_reference_603_nomtpla2  cascade;
alter table pla_desglose_de_monedas
   add constraint fk_pla_desg_reference_603_nomtpla2 foreign key (tipo_planilla, numero_planilla, year)
      references nomtpla2 (tipo_planilla, numero_planilla, year)
      on delete cascade on update cascade;

alter table pla_desglose_de_monedas
   drop constraint fk_pla_desg_reference_604_nom_tipo  cascade;
alter table pla_desglose_de_monedas
   add constraint fk_pla_desg_reference_604_nom_tipo foreign key (tipo_calculo)
      references nom_tipo_de_calculo (tipo_calculo)
      on delete cascade on update cascade;

alter table pla_desglose_planilla
   drop constraint fk_pla_desg_reference_670_nomctrac  cascade;
alter table pla_desglose_planilla
   add constraint fk_pla_desg_reference_670_nomctrac foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;

alter table pla_estructura_listado
   drop constraint fk_pla_estr_reference_422_nomconce  cascade;
alter table pla_estructura_listado
   add constraint fk_pla_estr_reference_422_nomconce foreign key (cod_concepto_planilla)
      references nomconce (cod_concepto_planilla)
      on delete restrict on update restrict;

alter table pla_estructura_listado
   drop constraint fk_pla_estr_reference_423_pla_tipo  cascade;
alter table pla_estructura_listado
   add constraint fk_pla_estr_reference_423_pla_tipo foreign key (tipo_de_columna)
      references pla_tipo_de_columna (tipo_de_columna)
      on delete restrict on update restrict;

alter table pla_extemporaneo
   drop constraint fk_pla_exte_reference_519_rhuempl  cascade;
alter table pla_extemporaneo
   add constraint fk_pla_exte_reference_519_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table pla_extemporaneo
   drop constraint fk_pla_exte_reference_521_nomtipod  cascade;
alter table pla_extemporaneo
   add constraint fk_pla_exte_reference_521_nomtipod foreign key (tipodhora)
      references nomtipodehoras (tipodhora)
      on delete restrict on update restrict;

alter table pla_fondo_de_cesantia
   drop constraint fk_pla_fond_reference_460_rhuempl  cascade;
alter table pla_fondo_de_cesantia
   add constraint fk_pla_fond_reference_460_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table pla_fondo_de_cesantia
   drop constraint fk_pla_fond_reference_461_bcocheck  cascade;
alter table pla_fondo_de_cesantia
   add constraint fk_pla_fond_reference_461_bcocheck foreign key (cod_ctabco, no_cheque, motivo_bco)
      references bcocheck1 (cod_ctabco, no_cheque, motivo_bco)
      on delete restrict on update cascade;

alter table pla_historial_descuentos
   drop constraint fk_pla_hist_reference_378_rhuempl  cascade;
alter table pla_historial_descuentos
   add constraint fk_pla_hist_reference_378_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table pla_historial_descuentos
   drop constraint fk_pla_hist_reference_379_rhuacre  cascade;
alter table pla_historial_descuentos
   add constraint fk_pla_hist_reference_379_rhuacre foreign key (cod_acreedores)
      references rhuacre (cod_acreedores)
      on delete restrict on update restrict;

alter table pla_historial_pagos
   drop constraint fk_pla_hist_reference_377_nomconce  cascade;
alter table pla_historial_pagos
   add constraint fk_pla_hist_reference_377_nomconce foreign key (cod_concepto_planilla)
      references nomconce (cod_concepto_planilla)
      on delete restrict on update restrict;

alter table pla_historial_pagos
   drop constraint fk_pla_hist_reference_380_rhuempl  cascade;
alter table pla_historial_pagos
   add constraint fk_pla_hist_reference_380_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table pla_indemnizaciones
   drop constraint fk_pla_inde_reference_560_rhuempl  cascade;
alter table pla_indemnizaciones
   add constraint fk_pla_inde_reference_560_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete cascade on update cascade;

alter table pla_informe
   drop constraint fk_pla_info_ref_234210_rhuempl  cascade;
alter table pla_informe
   add constraint fk_pla_info_ref_234210_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table pla_informe
   drop constraint fk_pla_info_reference_426_pla_tipo  cascade;
alter table pla_informe
   add constraint fk_pla_info_reference_426_pla_tipo foreign key (tipo_de_columna)
      references pla_tipo_de_columna (tipo_de_columna)
      on delete restrict on update restrict;

alter table pla_ingresos_deducciones
   drop constraint fk_pla_ingr_reference_557_nomconce  cascade;
alter table pla_ingresos_deducciones
   add constraint fk_pla_ingr_reference_557_nomconce foreign key (cod_concepto_planilla)
      references nomconce (cod_concepto_planilla)
      on delete cascade on update cascade;

alter table pla_ingresos_deducciones
   drop constraint fk_pla_ingr_reference_558_rhuempl  cascade;
alter table pla_ingresos_deducciones
   add constraint fk_pla_ingr_reference_558_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete cascade on update cascade;

alter table pla_otros_ingresos_fijos
   drop constraint fk_pla_otro_reference_628_rhuempl  cascade;
alter table pla_otros_ingresos_fijos
   add constraint fk_pla_otro_reference_628_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete cascade on update cascade;

alter table pla_otros_ingresos_fijos
   drop constraint fk_pla_otro_reference_629_nomconce  cascade;
alter table pla_otros_ingresos_fijos
   add constraint fk_pla_otro_reference_629_nomconce foreign key (cod_concepto_planilla)
      references nomconce (cod_concepto_planilla)
      on delete restrict on update cascade;

alter table pla_otros_ingresos_fijos
   drop constraint fk_pla_otro_reference_630_nomperio  cascade;
alter table pla_otros_ingresos_fijos
   add constraint fk_pla_otro_reference_630_nomperio foreign key (periodo)
      references nomperiodos (periodo)
      on delete restrict on update cascade;

alter table pla_planilla_semanal
   drop constraint fk_pla_plan_reference_674_nomctrac  cascade;
alter table pla_planilla_semanal
   add constraint fk_pla_plan_reference_674_nomctrac foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;

alter table pla_preelaborada
   drop constraint fk_pla_pree_reference_405_nomconce  cascade;
alter table pla_preelaborada
   add constraint fk_pla_pree_reference_405_nomconce foreign key (cod_concepto_planilla)
      references nomconce (cod_concepto_planilla)
      on delete restrict on update restrict;

alter table pla_preelaborada
   drop constraint fk_pla_pree_reference_406_rhuempl  cascade;
alter table pla_preelaborada
   add constraint fk_pla_pree_reference_406_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table pla_rela_horas_conceptos
   drop constraint fk_pla_rela_reference_534_nomtipod  cascade;
alter table pla_rela_horas_conceptos
   add constraint fk_pla_rela_reference_534_nomtipod foreign key (tipodhora)
      references nomtipodehoras (tipodhora)
      on delete cascade on update cascade;

alter table pla_rela_horas_conceptos
   drop constraint fk_pla_rela_reference_537_nomconce  cascade;
alter table pla_rela_horas_conceptos
   add constraint fk_pla_rela_reference_537_nomconce foreign key (cod_concepto_planilla)
      references nomconce (cod_concepto_planilla)
      on delete cascade on update cascade;

alter table pla_reloj
   drop constraint fk_pla_relo_reference_471_rhuempl  cascade;
alter table pla_reloj
   add constraint fk_pla_relo_reference_471_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table pla_reservas
   drop constraint fk_pla_rese_reference_624_nomctrac  cascade;
alter table pla_reservas
   add constraint fk_pla_rese_reference_624_nomctrac foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;

alter table pla_reservas
   drop constraint fk_pla_rese_reference_625_nomconce  cascade;
alter table pla_reservas
   add constraint fk_pla_rese_reference_625_nomconce foreign key (concepto_reserva)
      references nomconce (cod_concepto_planilla)
      on delete restrict on update cascade;

alter table pla_resumen_planilla
   drop constraint fk_pla_resu_reference_487_rhuempl  cascade;
alter table pla_resumen_planilla
   add constraint fk_pla_resu_reference_487_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table pla_resumen_planilla
   drop constraint fk_pla_resu_reference_488_nom_tipo  cascade;
alter table pla_resumen_planilla
   add constraint fk_pla_resu_reference_488_nom_tipo foreign key (tipo_calculo)
      references nom_tipo_de_calculo (tipo_calculo)
      on delete restrict on update restrict;

alter table pla_riesgos_profesionales
   drop constraint fk_pla_ries_reference_458_rhuempl  cascade;
alter table pla_riesgos_profesionales
   add constraint fk_pla_ries_reference_458_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table pla_saldo_acreedores
   drop constraint fk_pla_sald_reference_433_rhuempl  cascade;
alter table pla_saldo_acreedores
   add constraint fk_pla_sald_reference_433_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table pla_saldo_acreedores
   drop constraint fk_pla_sald_reference_434_nomacrem  cascade;
alter table pla_saldo_acreedores
   add constraint fk_pla_sald_reference_434_nomacrem foreign key (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      references nomacrem (numero_documento, codigo_empleado, cod_concepto_planilla, compania)
      on delete restrict on update restrict;

alter table pla_vacacion
   drop constraint fk_pla_vaca_reference_476_rhuempl  cascade;
alter table pla_vacacion
   add constraint fk_pla_vaca_reference_476_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table pla_vacacion1
   drop constraint fk_pla_vaca_ref_231556_rhuempl  cascade;
alter table pla_vacacion1
   add constraint fk_pla_vaca_ref_231556_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table pla_vacacion2
   drop constraint fk_pla_vaca_ref_231566_pla_vaca  cascade;
alter table pla_vacacion2
   add constraint fk_pla_vaca_ref_231566_pla_vaca foreign key (codigo_empleado, compania, legal_desde)
      references pla_vacacion1 (codigo_empleado, compania, legal_desde)
      on delete cascade on update cascade;

alter table pla_vacaciones_x_pagar
   drop constraint fk_pla_vaca_reference_561_rhuempl  cascade;
alter table pla_vacaciones_x_pagar
   add constraint fk_pla_vaca_reference_561_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table pla_work1
   drop constraint fk_pla_work_reference_491_rhuempl  cascade;
alter table pla_work1
   add constraint fk_pla_work_reference_491_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table placertificadosmedico
   drop constraint fk_placerti_reference_411_rhuempl  cascade;
alter table placertificadosmedico
   add constraint fk_placerti_reference_411_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table pladeduccionesadicionales
   drop constraint fk_pladeduc_reference_410_rhuempl  cascade;
alter table pladeduccionesadicionales
   add constraint fk_pladeduc_reference_410_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table pladeduccionesadicionales
   drop constraint fk_pladeduc_reference_412_platipod  cascade;
alter table pladeduccionesadicionales
   add constraint fk_pladeduc_reference_412_platipod foreign key (tipo)
      references platipodeduccion (tipo)
      on delete restrict on update restrict;

alter table plapermisos
   drop constraint fk_plapermi_reference_437_rhuempl  cascade;
alter table plapermisos
   add constraint fk_plapermi_reference_437_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table plapermisos
   drop constraint fk_plapermi_reference_439_platipod  cascade;
alter table plapermisos
   add constraint fk_plapermi_reference_439_platipod foreign key (tipodepermiso)
      references platipodepermiso (tipodepermiso)
      on delete restrict on update restrict;

alter table plapermisosindical
   drop constraint fk_plapermi_reference_415_rhuempl  cascade;
alter table plapermisosindical
   add constraint fk_plapermi_reference_415_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table plareemplazos
   drop constraint fk_plareemp_reference_408_rhuempl  cascade;
alter table plareemplazos
   add constraint fk_plareemp_reference_408_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table plareemplazos
   drop constraint fk_plareemp_reference_409_rhuempl  cascade;
alter table plareemplazos
   add constraint fk_plareemp_reference_409_rhuempl foreign key (reemplazo, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table platipodepermiso
   drop constraint fk_platipod_reference_438_nomtipod  cascade;
alter table platipodepermiso
   add constraint fk_platipod_reference_438_nomtipod foreign key (tipodhora)
      references nomtipodehoras (tipodhora)
      on delete restrict on update restrict;

alter table porcentaje_manejo
   drop constraint fk_porcenta_reference_506_clientes  cascade;
alter table porcentaje_manejo
   add constraint fk_porcenta_reference_506_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table precios_por_cliente_1
   drop constraint fk_precios__ref_106584_clientes  cascade;
alter table precios_por_cliente_1
   add constraint fk_precios__ref_106584_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update cascade;

alter table precios_por_cliente_2
   drop constraint fk_precios__ref_106597_precios_  cascade;
alter table precios_por_cliente_2
   add constraint fk_precios__ref_106597_precios_ foreign key (secuencia)
      references precios_por_cliente_1 (secuencia)
      on delete cascade on update cascade;

alter table precios_por_cliente_2
   drop constraint fk_precios__ref_106601_articulo  cascade;
alter table precios_por_cliente_2
   add constraint fk_precios__ref_106601_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete restrict on update cascade;

alter table preventas
   drop constraint fk_preventa_reference_338_articulo  cascade;
alter table preventas
   add constraint fk_preventa_reference_338_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete cascade on update cascade;

alter table preventas
   drop constraint fk_preventa_reference_341_clientes  cascade;
alter table preventas
   add constraint fk_preventa_reference_341_clientes foreign key (cliente)
      references clientes (cliente)
      on delete cascade on update cascade;

alter table preventas
   drop constraint fk_preventa_reference_342_gralperi  cascade;
alter table preventas
   add constraint fk_preventa_reference_342_gralperi foreign key (compania, aplicacion, year, periodo)
      references gralperiodos (compania, aplicacion, year, periodo)
      on delete cascade on update cascade;

alter table productos_sustitutos
   drop constraint fk_producto_ref_16981_articulo  cascade;
alter table productos_sustitutos
   add constraint fk_producto_ref_16981_articulo foreign key (articulo)
      references articulos (articulo)
      on delete restrict on update cascade;

alter table productos_sustitutos
   drop constraint fk_producto_ref_16985_articulo  cascade;
alter table productos_sustitutos
   add constraint fk_producto_ref_16985_articulo foreign key (art_articulo)
      references articulos (articulo)
      on delete restrict on update cascade;

alter table proveedores
   drop constraint fk_proveedo_ref_22587_gral_for  cascade;
alter table proveedores
   add constraint fk_proveedo_ref_22587_gral_for foreign key (forma_pago)
      references gral_forma_de_pago (forma_pago)
      on delete restrict on update restrict;

alter table proveedores
   drop constraint fk_proveedo_ref_22652_cglcuent  cascade;
alter table proveedores
   add constraint fk_proveedo_ref_22652_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table proveedores_agrupados
   drop constraint fk_proveedo_ref_21626_proveedo  cascade;
alter table proveedores_agrupados
   add constraint fk_proveedo_ref_21626_proveedo foreign key (proveedor)
      references proveedores (proveedor)
      on delete cascade on update cascade;

alter table proveedores_agrupados
   drop constraint fk_proveedo_ref_51470_gral_val  cascade;
alter table proveedores_agrupados
   add constraint fk_proveedo_ref_51470_gral_val foreign key (codigo_valor_grupo)
      references gral_valor_grupos (codigo_valor_grupo)
      on delete cascade on update cascade;

alter table rela_activos_cglposteo
   drop constraint fk_rela_act_reference_595_cglposte  cascade;
alter table rela_activos_cglposteo
   add constraint fk_rela_act_reference_595_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_activos_cglposteo
   drop constraint fk_rela_act_reference_596_activos  cascade;
alter table rela_activos_cglposteo
   add constraint fk_rela_act_reference_596_activos foreign key (codigo, compania)
      references activos (codigo, compania)
      on delete cascade on update cascade;

alter table rela_adc_master_cglposteo
   drop constraint fk_rela_adc_reference_656_adc_mast  cascade;
alter table rela_adc_master_cglposteo
   add constraint fk_rela_adc_reference_656_adc_mast foreign key (compania, consecutivo, linea_master)
      references adc_master (compania, consecutivo, linea_master)
      on delete cascade on update cascade;

alter table rela_adc_master_cglposteo
   drop constraint fk_rela_adc_reference_657_cglposte  cascade;
alter table rela_adc_master_cglposteo
   add constraint fk_rela_adc_reference_657_cglposte foreign key (cgl_consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_afi_cglposteo
   drop constraint fk_rela_afi_ref_122180_afi_depr  cascade;
alter table rela_afi_cglposteo
   add constraint fk_rela_afi_ref_122180_afi_depr foreign key (codigo, compania, aplicacion, year, periodo)
      references afi_depreciacion (codigo, compania, aplicacion, year, periodo)
      on delete cascade on update cascade;

alter table rela_afi_cglposteo
   drop constraint fk_rela_afi_ref_122196_cglposte  cascade;
alter table rela_afi_cglposteo
   add constraint fk_rela_afi_ref_122196_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_afi_trx1_cglposteo
   drop constraint fk_rela_afi_reference_676_afi_trx1  cascade;
alter table rela_afi_trx1_cglposteo
   add constraint fk_rela_afi_reference_676_afi_trx1 foreign key (compania, no_trx)
      references afi_trx1 (compania, no_trx)
      on delete cascade on update cascade;

alter table rela_afi_trx1_cglposteo
   drop constraint fk_rela_afi_reference_677_cglposte  cascade;
alter table rela_afi_trx1_cglposteo
   add constraint fk_rela_afi_reference_677_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_bcocheck1_cglposteo
   drop constraint fk_rela_bco_ref_70271_bcocheck  cascade;
alter table rela_bcocheck1_cglposteo
   add constraint fk_rela_bco_ref_70271_bcocheck foreign key (cod_ctabco, no_cheque, motivo_bco)
      references bcocheck1 (cod_ctabco, no_cheque, motivo_bco)
      on delete cascade on update cascade;

alter table rela_bcocheck1_cglposteo
   drop constraint fk_rela_bco_ref_70281_cglposte  cascade;
alter table rela_bcocheck1_cglposteo
   add constraint fk_rela_bco_ref_70281_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_bcotransac1_cglposteo
   drop constraint fk_rela_bco_ref_70286_bcotrans  cascade;
alter table rela_bcotransac1_cglposteo
   add constraint fk_rela_bco_ref_70286_bcotrans foreign key (cod_ctabco, sec_transacc)
      references bcotransac1 (cod_ctabco, sec_transacc)
      on delete cascade on update cascade;

alter table rela_bcotransac1_cglposteo
   drop constraint fk_rela_bco_ref_70293_cglposte  cascade;
alter table rela_bcotransac1_cglposteo
   add constraint fk_rela_bco_ref_70293_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_caja_trx1_cglposteo
   drop constraint fk_rela_caj_ref_119979_cglposte  cascade;
alter table rela_caja_trx1_cglposteo
   add constraint fk_rela_caj_ref_119979_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_caja_trx1_cglposteo
   drop constraint fk_rela_caj_ref_119983_caja_trx  cascade;
alter table rela_caja_trx1_cglposteo
   add constraint fk_rela_caj_ref_119983_caja_trx foreign key (numero_trx, caja)
      references caja_trx1 (numero_trx, caja)
      on delete cascade on update cascade;

alter table rela_cgl_comprobante1_cglposteo
   drop constraint fk_rela_cgl_reference_593_cglposte  cascade;
alter table rela_cgl_comprobante1_cglposteo
   add constraint fk_rela_cgl_reference_593_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_cgl_comprobante1_cglposteo
   drop constraint fk_rela_cgl_reference_594_cgl_comp  cascade;
alter table rela_cgl_comprobante1_cglposteo
   add constraint fk_rela_cgl_reference_594_cgl_comp foreign key (compania, secuencia)
      references cgl_comprobante1 (compania, secuencia)
      on delete cascade on update cascade;

alter table rela_cglcomprobante1_cglposteo
   drop constraint fk_rela_cgl_reference_582_cglcompr  cascade;
alter table rela_cglcomprobante1_cglposteo
   add constraint fk_rela_cgl_reference_582_cglcompr foreign key (secuencia, compania, aplicacion, year, periodo)
      references cglcomprobante1 (secuencia, compania, aplicacion, year, periodo)
      on delete cascade on update cascade;

alter table rela_cglcomprobante1_cglposteo
   drop constraint fk_rela_cgl_reference_583_cglposte  cascade;
alter table rela_cglcomprobante1_cglposteo
   add constraint fk_rela_cgl_reference_583_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_cxc_recibo1_cglposteo
   drop constraint fk_rela_cxc_reference_580_cglposte  cascade;
alter table rela_cxc_recibo1_cglposteo
   add constraint fk_rela_cxc_reference_580_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_cxc_recibo1_cglposteo
   drop constraint fk_rela_cxc_reference_581_cxc_reci  cascade;
alter table rela_cxc_recibo1_cglposteo
   add constraint fk_rela_cxc_reference_581_cxc_reci foreign key (almacen, cxc_consecutivo)
      references cxc_recibo1 (almacen, consecutivo)
      on delete cascade on update cascade;

alter table rela_cxcfact1_cglposteo
   drop constraint fk_rela_cxc_ref_70298_cglposte  cascade;
alter table rela_cxcfact1_cglposteo
   add constraint fk_rela_cxc_ref_70298_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_cxcfact1_cglposteo
   drop constraint fk_rela_cxc_ref_70302_cxcfact1  cascade;
alter table rela_cxcfact1_cglposteo
   add constraint fk_rela_cxc_ref_70302_cxcfact1 foreign key (almacen, no_factura)
      references cxcfact1 (almacen, no_factura)
      on delete cascade on update cascade;

alter table rela_cxctrx1_cglposteo
   drop constraint fk_rela_cxc_ref_71933_cglposte  cascade;
alter table rela_cxctrx1_cglposteo
   add constraint fk_rela_cxc_ref_71933_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_cxctrx1_cglposteo
   drop constraint fk_rela_cxc_ref_71937_cxctrx1  cascade;
alter table rela_cxctrx1_cglposteo
   add constraint fk_rela_cxc_ref_71937_cxctrx1 foreign key (sec_ajuste_cxc, almacen)
      references cxctrx1 (sec_ajuste_cxc, almacen)
      on delete cascade on update cascade;

alter table rela_cxpajuste1_cglposteo
   drop constraint fk_rela_cxp_ref_70325_cglposte  cascade;
alter table rela_cxpajuste1_cglposteo
   add constraint fk_rela_cxp_ref_70325_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_cxpajuste1_cglposteo
   drop constraint fk_rela_cxp_ref_70329_cxpajust  cascade;
alter table rela_cxpajuste1_cglposteo
   add constraint fk_rela_cxp_ref_70329_cxpajust foreign key (compania, sec_ajuste_cxp)
      references cxpajuste1 (compania, sec_ajuste_cxp)
      on delete cascade on update cascade;

alter table rela_cxpfact1_cglposteo
   drop constraint fk_rela_cxp_ref_70310_cglposte  cascade;
alter table rela_cxpfact1_cglposteo
   add constraint fk_rela_cxp_ref_70310_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_cxpfact1_cglposteo
   drop constraint fk_rela_cxp_ref_70314_cxpfact1  cascade;
alter table rela_cxpfact1_cglposteo
   add constraint fk_rela_cxp_ref_70314_cxpfact1 foreign key (proveedor, fact_proveedor, compania)
      references cxpfact1 (proveedor, fact_proveedor, compania)
      on delete cascade on update cascade;

alter table rela_eys1_cglposteo
   drop constraint fk_rela_eys_ref_71945_cglposte  cascade;
alter table rela_eys1_cglposteo
   add constraint fk_rela_eys_ref_71945_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_eys1_cglposteo
   drop constraint fk_rela_eys_ref_71949_eys1  cascade;
alter table rela_eys1_cglposteo
   add constraint fk_rela_eys_ref_71949_eys1 foreign key (almacen, no_transaccion)
      references eys1 (almacen, no_transaccion)
      on delete cascade on update cascade;

alter table rela_factura1_cglposteo
   drop constraint fk_rela_fac_ref_119991_cglposte  cascade;
alter table rela_factura1_cglposteo
   add constraint fk_rela_fac_ref_119991_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_factura1_cglposteo
   drop constraint fk_rela_fac_ref_119995_factura1  cascade;
alter table rela_factura1_cglposteo
   add constraint fk_rela_fac_ref_119995_factura1 foreign key (almacen, tipo, num_documento)
      references factura1 (almacen, tipo, num_documento)
      on delete cascade on update cascade;

alter table rela_nomctrac_cglposteo
   drop constraint fk_rela_nom_reference_520_nomctrac  cascade;
alter table rela_nomctrac_cglposteo
   add constraint fk_rela_nom_reference_520_nomctrac foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      references nomctrac (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento)
      on delete cascade on update cascade;

alter table rela_nomctrac_cglposteo
   drop constraint fk_rela_nom_reference_522_cglposte  cascade;
alter table rela_nomctrac_cglposteo
   add constraint fk_rela_nom_reference_522_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rela_pla_reservas_cglposteo
   drop constraint fk_rela_pla_reference_626_pla_rese  cascade;
alter table rela_pla_reservas_cglposteo
   add constraint fk_rela_pla_reference_626_pla_rese foreign key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento, concepto_reserva)
      references pla_reservas (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento, concepto_reserva)
      on delete cascade on update cascade;

alter table rela_pla_reservas_cglposteo
   drop constraint fk_rela_pla_reference_627_cglposte  cascade;
alter table rela_pla_reservas_cglposteo
   add constraint fk_rela_pla_reference_627_cglposte foreign key (consecutivo)
      references cglposteo (consecutivo)
      on delete cascade on update cascade;

alter table rhu_horas_adicionales
   drop constraint fk_rhu_hora_reference_382_nomtipod  cascade;
alter table rhu_horas_adicionales
   add constraint fk_rhu_hora_reference_382_nomtipod foreign key (tipodhora)
      references nomtipodehoras (tipodhora)
      on delete restrict on update restrict;

alter table rhu_horas_adicionales
   drop constraint fk_rhu_hora_reference_400_rhuturno  cascade;
alter table rhu_horas_adicionales
   add constraint fk_rhu_hora_reference_400_rhuturno foreign key (cod_id_turnos)
      references rhuturno (cod_id_turnos)
      on delete restrict on update restrict;

alter table rhuempl
   drop constraint fk_rhuempl_ref_190599_rhucargo  cascade;
alter table rhuempl
   add constraint fk_rhuempl_ref_190599_rhucargo foreign key (codigo_cargo)
      references rhucargo (codigo_cargo)
      on delete restrict on update restrict;

alter table rhuempl
   drop constraint fk_rhuempl_ref_190603_rhuturno  cascade;
alter table rhuempl
   add constraint fk_rhuempl_ref_190603_rhuturno foreign key (cod_id_turnos)
      references rhuturno (cod_id_turnos)
      on delete restrict on update restrict;

alter table rhuempl
   drop constraint fk_rhuempl_ref_190610_cglcuent  cascade;
alter table rhuempl
   add constraint fk_rhuempl_ref_190610_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table rhuempl
   drop constraint fk_rhuempl_ref_192958_gralcomp  cascade;
alter table rhuempl
   add constraint fk_rhuempl_ref_192958_gralcomp foreign key (compania)
      references gralcompanias (compania)
      on delete restrict on update cascade;

alter table rhuempl
   drop constraint fk_rhuempl_ref_195509_nomtpla  cascade;
alter table rhuempl
   add constraint fk_rhuempl_ref_195509_nomtpla foreign key (tipo_planilla)
      references nomtpla (tipo_planilla)
      on delete restrict on update restrict;

alter table rhuempl
   drop constraint fk_rhuempl_ref_204414_rhuclvim  cascade;
alter table rhuempl
   add constraint fk_rhuempl_ref_204414_rhuclvim foreign key (grup_impto_renta, num_dependiente)
      references rhuclvim (grup_impto_renta, num_dependiente)
      on delete restrict on update restrict;

alter table rhuempl
   drop constraint fk_rhuempl_reference_395_departam  cascade;
alter table rhuempl
   add constraint fk_rhuempl_reference_395_departam foreign key (departamento)
      references departamentos (codigo)
      on delete restrict on update restrict;

alter table rhuempl
   drop constraint fk_rhuempl_reference_416_rhuturno  cascade;
alter table rhuempl
   add constraint fk_rhuempl_reference_416_rhuturno foreign key (turnosabado)
      references rhuturno (cod_id_turnos)
      on delete restrict on update restrict;

alter table rhuempl
   drop constraint fk_rhuempl_reference_436_cglauxil  cascade;
alter table rhuempl
   add constraint fk_rhuempl_reference_436_cglauxil foreign key (auxiliar)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table rhugremp
   drop constraint fk_rhugremp_ref_190614_rhuempl  cascade;
alter table rhugremp
   add constraint fk_rhugremp_ref_190614_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table rhugremp
   drop constraint fk_rhugremp_ref_190618_gral_val  cascade;
alter table rhugremp
   add constraint fk_rhugremp_ref_190618_gral_val foreign key (codigo_valor_grupo)
      references gral_valor_grupos (codigo_valor_grupo)
      on delete restrict on update restrict;

alter table rhuturno_x_dia
   drop constraint fk_rhuturno_reference_401_rhuturno  cascade;
alter table rhuturno_x_dia
   add constraint fk_rhuturno_reference_401_rhuturno foreign key (cod_id_turnos)
      references rhuturno (cod_id_turnos)
      on delete restrict on update restrict;

alter table rhuturno_x_dia
   drop constraint fk_rhuturno_reference_402_rhuempl  cascade;
alter table rhuturno_x_dia
   add constraint fk_rhuturno_reference_402_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table rubros_fact_cxc
   drop constraint fk_rubros_f_ref_35579_cglcuent  cascade;
alter table rubros_fact_cxc
   add constraint fk_rubros_f_ref_35579_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table rubros_fact_cxc
   drop constraint fk_rubros_f_ref_45607_cglauxil  cascade;
alter table rubros_fact_cxc
   add constraint fk_rubros_f_ref_45607_cglauxil foreign key (auxiliar1)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table rubros_fact_cxc
   drop constraint fk_rubros_f_ref_45611_cglauxil  cascade;
alter table rubros_fact_cxc
   add constraint fk_rubros_f_ref_45611_cglauxil foreign key (auxiliar2)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table rubros_fact_cxp
   drop constraint fk_rubros_f_ref_22631_cglcuent  cascade;
alter table rubros_fact_cxp
   add constraint fk_rubros_f_ref_22631_cglcuent foreign key (cuenta)
      references cglcuentas (cuenta)
      on delete restrict on update cascade;

alter table rubros_fact_cxp
   drop constraint fk_rubros_f_ref_52526_cglauxil  cascade;
alter table rubros_fact_cxp
   add constraint fk_rubros_f_ref_52526_cglauxil foreign key (auxiliar1)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table rubros_fact_cxp
   drop constraint fk_rubros_f_ref_52530_cglauxil  cascade;
alter table rubros_fact_cxp
   add constraint fk_rubros_f_ref_52530_cglauxil foreign key (auxiliar2)
      references cglauxiliares (auxiliar)
      on delete restrict on update cascade;

alter table saldo_de_proveedores
   drop constraint fk_saldo_de_reference_344_proveedo  cascade;
alter table saldo_de_proveedores
   add constraint fk_saldo_de_reference_344_proveedo foreign key (proveedor)
      references proveedores (proveedor)
      on delete restrict on update restrict;

alter table secciones
   drop constraint fk_seccione_ref_110488_departam  cascade;
alter table secciones
   add constraint fk_seccione_ref_110488_departam foreign key (codigo)
      references departamentos (codigo)
      on delete restrict on update restrict;

alter table security_info
   drop constraint fk_security_reference_566_security  cascade;
alter table security_info
   add constraint fk_security_reference_566_security foreign key (application, window, control)
      references security_template (application, window, control)
      on delete restrict on update restrict;

alter table security_info
   drop constraint fk_security_reference_567_security  cascade;
alter table security_info
   add constraint fk_security_reference_567_security foreign key (user_name)
      references security_users (name)
      on delete restrict on update restrict;

alter table security_template
   drop constraint fk_security_reference_565_security  cascade;
alter table security_template
   add constraint fk_security_reference_565_security foreign key (application)
      references security_apps (application)
      on delete restrict on update restrict;

alter table sobre_acumulados
   drop constraint fk_sobre_ac_reference_420_rhuempl  cascade;
alter table sobre_acumulados
   add constraint fk_sobre_ac_reference_420_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table sobre_deducciones
   drop constraint fk_sobre_de_reference_418_rhuempl  cascade;
alter table sobre_deducciones
   add constraint fk_sobre_de_reference_418_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table sobre_desgloce
   drop constraint fk_sobre_de_reference_435_rhuempl  cascade;
alter table sobre_desgloce
   add constraint fk_sobre_de_reference_435_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table sobre_ingresos
   drop constraint fk_sobre_in_reference_417_rhuempl  cascade;
alter table sobre_ingresos
   add constraint fk_sobre_in_reference_417_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table sobre_ingresos
   drop constraint fk_sobre_in_reference_421_nomtpla2  cascade;
alter table sobre_ingresos
   add constraint fk_sobre_in_reference_421_nomtpla2 foreign key (tipo_planilla, numero_planilla, year)
      references nomtpla2 (tipo_planilla, numero_planilla, year)
      on delete restrict on update restrict;

alter table sobre_totales
   drop constraint fk_sobre_to_reference_419_rhuempl  cascade;
alter table sobre_totales
   add constraint fk_sobre_to_reference_419_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update cascade;

alter table tal_equipo
   drop constraint fk_tal_equi_reference_607_activos  cascade;
alter table tal_equipo
   add constraint fk_tal_equi_reference_607_activos foreign key (activo, compania)
      references activos (codigo, compania)
      on delete restrict on update restrict;

alter table tal_ot1
   drop constraint fk_tal_ot1_reference_606_tal_equi  cascade;
alter table tal_ot1
   add constraint fk_tal_ot1_reference_606_tal_equi foreign key (codigo, compania)
      references tal_equipo (codigo, compania)
      on delete restrict on update cascade;

alter table tal_ot1
   drop constraint fk_tal_ot1_reference_612_rhuempl  cascade;
alter table tal_ot1
   add constraint fk_tal_ot1_reference_612_rhuempl foreign key (empleado_responsable, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table tal_ot1
   drop constraint fk_tal_ot1_reference_616_factura1  cascade;
alter table tal_ot1
   add constraint fk_tal_ot1_reference_616_factura1 foreign key (almacen, tipo_factura, numero_factura)
      references factura1 (almacen, tipo, num_documento)
      on delete restrict on update cascade;

alter table tal_ot1
   drop constraint fk_tal_ot1_reference_619_clientes  cascade;
alter table tal_ot1
   add constraint fk_tal_ot1_reference_619_clientes foreign key (cliente)
      references clientes (cliente)
      on delete restrict on update restrict;

alter table tal_ot1
   drop constraint fk_tal_ot1_reference_620_almacen  cascade;
alter table tal_ot1
   add constraint fk_tal_ot1_reference_620_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update restrict;

alter table tal_ot1
   drop constraint fk_tal_ot1_reference_622_gral_for  cascade;
alter table tal_ot1
   add constraint fk_tal_ot1_reference_622_gral_for foreign key (forma_pago)
      references gral_forma_de_pago (forma_pago)
      on delete restrict on update cascade;

alter table tal_ot2
   drop constraint fk_tal_ot2_reference_608_tal_ot1  cascade;
alter table tal_ot2
   add constraint fk_tal_ot2_reference_608_tal_ot1 foreign key (almacen, no_orden, tipo)
      references tal_ot1 (almacen, no_orden, tipo)
      on delete cascade on update cascade;

alter table tal_ot2
   drop constraint fk_tal_ot2_reference_611_articulo  cascade;
alter table tal_ot2
   add constraint fk_tal_ot2_reference_611_articulo foreign key (articulo, almacen)
      references articulos_por_almacen (articulo, almacen)
      on delete restrict on update cascade;

alter table tal_ot2
   drop constraint fk_tal_ot2_reference_623_tal_serv  cascade;
alter table tal_ot2
   add constraint fk_tal_ot2_reference_623_tal_serv foreign key (servicio)
      references tal_servicios (servicio)
      on delete cascade on update cascade;

alter table tal_ot2_eys2
   drop constraint fk_tal_ot2__reference_614_tal_ot2  cascade;
alter table tal_ot2_eys2
   add constraint fk_tal_ot2__reference_614_tal_ot2 foreign key (no_orden, tipo, almacen, linea_tal_ot2, articulo)
      references tal_ot2 (no_orden, tipo, almacen, linea, articulo)
      on delete cascade on update cascade;

alter table tal_ot2_eys2
   drop constraint fk_tal_ot2__reference_617_eys2  cascade;
alter table tal_ot2_eys2
   add constraint fk_tal_ot2__reference_617_eys2 foreign key (articulo, almacen, no_transaccion, linea_eys2)
      references eys2 (articulo, almacen, no_transaccion, linea)
      on delete cascade on update cascade;

alter table tal_ot3
   drop constraint fk_tal_ot3_reference_609_tal_ot1  cascade;
alter table tal_ot3
   add constraint fk_tal_ot3_reference_609_tal_ot1 foreign key (almacen, no_orden, tipo)
      references tal_ot1 (almacen, no_orden, tipo)
      on delete cascade on update cascade;

alter table tal_ot3
   drop constraint fk_tal_ot3_reference_610_rhuempl  cascade;
alter table tal_ot3
   add constraint fk_tal_ot3_reference_610_rhuempl foreign key (codigo_empleado, compania)
      references rhuempl (codigo_empleado, compania)
      on delete restrict on update restrict;

alter table tal_ot3
   drop constraint fk_tal_ot3_reference_613_tal_serv  cascade;
alter table tal_ot3
   add constraint fk_tal_ot3_reference_613_tal_serv foreign key (servicio)
      references tal_servicios (servicio)
      on delete cascade on update cascade;

alter table tal_precios_x_cliente
   drop constraint fk_tal_prec_reference_655_clientes  cascade;
alter table tal_precios_x_cliente
   add constraint fk_tal_prec_reference_655_clientes foreign key (cliente)
      references clientes (cliente)
      on delete cascade on update cascade;

alter table tal_servicios
   drop constraint fk_tal_serv_reference_621_articulo  cascade;
alter table tal_servicios
   add constraint fk_tal_serv_reference_621_articulo foreign key (articulo)
      references articulos (articulo)
      on delete restrict on update restrict;

alter table tal_temp
   drop constraint fk_tal_temp_reference_618_tal_ot2  cascade;
alter table tal_temp
   add constraint fk_tal_temp_reference_618_tal_ot2 foreign key (no_orden, tipo, almacen, linea, articulo)
      references tal_ot2 (no_orden, tipo, almacen, linea, articulo)
      on delete cascade on update cascade;

alter table tarifas
   drop constraint fk_tarifas_reference_501_almacen  cascade;
alter table tarifas
   add constraint fk_tarifas_reference_501_almacen foreign key (almacen)
      references almacen (almacen)
      on delete restrict on update cascade;

alter table tipo_transacc
   drop constraint fk_tipo_tra_ref_22603_gralapli  cascade;
alter table tipo_transacc
   add constraint fk_tipo_tra_ref_22603_gralapli foreign key (aplicacion)
      references gralaplicaciones (aplicacion)
      on delete restrict on update restrict;