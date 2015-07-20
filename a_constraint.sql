alter table abaco_lock
   drop constraint pk_abaco_lock  cascade;
alter table abaco_lock
   add constraint pk_abaco_lock primary key (bloqueado);

alter table abaco_notas
   drop constraint pk_abaco_notas  cascade;
alter table abaco_notas
   add constraint pk_abaco_notas primary key (usuario);

alter table abaco_work
   drop constraint pk_abaco_work  cascade;
alter table abaco_work
   add constraint pk_abaco_work primary key (usuario, codigo);

alter table activos
   drop constraint pk_activos  cascade;
alter table activos
   add constraint pk_activos primary key (codigo, compania);

alter table adc_containers
   drop constraint pk_adc_containers  cascade;
alter table adc_containers
   add constraint pk_adc_containers primary key (tamanio);

alter table adc_house
   drop constraint pk_adc_house  cascade;
alter table adc_house
   add constraint pk_adc_house primary key (compania, consecutivo, linea_master, linea_house);

alter table adc_house_factura1
   drop constraint pk_adc_house_factura1  cascade;
alter table adc_house_factura1
   add constraint pk_adc_house_factura1 primary key (compania, consecutivo, linea_master, linea_house);

alter table adc_informe1
   drop constraint pk_adc_informe1  cascade;
alter table adc_informe1
   add constraint pk_adc_informe1 primary key (compania, consecutivo, linea_master, almacen, tipo, num_documento, usuario);

alter table adc_manejo
   drop constraint pk_adc_manejo  cascade;
alter table adc_manejo
   add constraint pk_adc_manejo primary key (compania, consecutivo, linea_master, linea_house, linea_manejo);

alter table adc_manejo_factura1
   drop constraint pk_adc_manejo_factura1  cascade;
alter table adc_manejo_factura1
   add constraint pk_adc_manejo_factura1 primary key (compania, consecutivo, linea_master, linea_house, linea_manejo);

alter table adc_manifiesto
   drop constraint pk_adc_manifiesto  cascade;
alter table adc_manifiesto
   add constraint pk_adc_manifiesto primary key (compania, consecutivo);

alter table adc_master
   drop constraint pk_adc_master  cascade;
alter table adc_master
   add constraint pk_adc_master primary key (compania, consecutivo, linea_master);

alter table adc_parametros_contables
   drop constraint pk_adc_parametros_contables  cascade;
alter table adc_parametros_contables
   add constraint pk_adc_parametros_contables primary key (referencia, ciudad);

alter table adc_tipo_de_contenedor
   drop constraint pk_adc_tipo_de_contenedor  cascade;
alter table adc_tipo_de_contenedor
   add constraint pk_adc_tipo_de_contenedor primary key (tipo);

alter table afi_depreciacion
   drop constraint pk_afi_depreciacion  cascade;
alter table afi_depreciacion
   add constraint pk_afi_depreciacion primary key (codigo, compania, aplicacion, year, periodo);

alter table afi_grupos_1
   drop constraint pk_afi_grupos_1  cascade;
alter table afi_grupos_1
   add constraint pk_afi_grupos_1 primary key (codigo);

alter table afi_grupos_2
   drop constraint pk_afi_grupos_2  cascade;
alter table afi_grupos_2
   add constraint pk_afi_grupos_2 primary key (codigo, year);

alter table afi_listado1
   drop constraint pk_afi_listado1  cascade;
alter table afi_listado1
   add constraint pk_afi_listado1 primary key (codigo, compania, usuario);

alter table afi_listado2
   drop constraint pk_afi_listado2  cascade;
alter table afi_listado2
   add constraint pk_afi_listado2 primary key (codigo, compania, aplicacion, year, periodo, usuario);

alter table afi_tipo_activo
   drop constraint pk_afi_tipo_activo  cascade;
alter table afi_tipo_activo
   add constraint pk_afi_tipo_activo primary key (codigo);

alter table afi_tipo_trx
   drop constraint pk_afi_tipo_trx  cascade;
alter table afi_tipo_trx
   add constraint pk_afi_tipo_trx primary key (tipo_trx);

alter table afi_trx1
   drop constraint pk_afi_trx1  cascade;
alter table afi_trx1
   add constraint pk_afi_trx1 primary key (compania, no_trx);

alter table afi_trx2
   drop constraint pk_afi_trx2  cascade;
alter table afi_trx2
   add constraint pk_afi_trx2 primary key (compania, no_trx, linea);

alter table almacen
   drop constraint pk_almacen  cascade;
alter table almacen
   add constraint pk_almacen primary key (almacen);

alter table articulos
   drop constraint pk_articulos  cascade;
alter table articulos
   add constraint pk_articulos primary key (articulo);

alter table articulos_abc
   drop constraint pk_articulos_abc  cascade;
alter table articulos_abc
   add constraint pk_articulos_abc primary key (articulo, usuario, compania);

alter table articulos_agrupados
   drop constraint pk_articulos_agrupados  cascade;
alter table articulos_agrupados
   add constraint pk_articulos_agrupados primary key (articulo, codigo_valor_grupo);

alter table articulos_por_almacen
   drop constraint pk_articulos_por_almacen  cascade;
alter table articulos_por_almacen
   add constraint pk_articulos_por_almacen primary key (articulo, almacen);

alter table bancos
   drop constraint pk_bancos  cascade;
alter table bancos
   add constraint pk_bancos primary key (banco);

alter table bco_cheques_temporal
   drop constraint pk_bco_cheques_temporal  cascade;
alter table bco_cheques_temporal
   add constraint pk_bco_cheques_temporal primary key (consecutivo);

alter table bcobalance
   drop constraint pk_bcobalance  cascade;
alter table bcobalance
   add constraint pk_bcobalance primary key (cod_ctabco, compania, aplicacion, year, periodo);

alter table bcocheck1
   drop constraint pk_bcocheck1  cascade;
alter table bcocheck1
   add constraint pk_bcocheck1 primary key (cod_ctabco, no_cheque, motivo_bco);

alter table bcocheck2
   drop constraint pk_bcocheck2  cascade;
alter table bcocheck2
   add constraint pk_bcocheck2 primary key (linea, cod_ctabco, no_cheque, motivo_bco);

alter table bcocheck3
   drop constraint pk_bcocheck3  cascade;
alter table bcocheck3
   add constraint pk_bcocheck3 primary key (motivo_cxp, cod_ctabco, no_cheque, aplicar_a, motivo_bco);

alter table bcocheck4
   drop constraint pk_bcocheck4  cascade;
alter table bcocheck4
   add constraint pk_bcocheck4 primary key (cod_ctabco, no_cheque, motivo_bco);

alter table bcocircula
   drop constraint pk_bcocircula  cascade;
alter table bcocircula
   add constraint pk_bcocircula primary key (cod_ctabco, motivo_bco, no_docmto_sys, fecha_posteo);

alter table bcoctas
   drop constraint pk_bcoctas  cascade;
alter table bcoctas
   add constraint pk_bcoctas primary key (cod_ctabco);

alter table bcomotivos
   drop constraint pk_bcomotivos  cascade;
alter table bcomotivos
   add constraint pk_bcomotivos primary key (motivo_bco);

alter table bcotransac1
   drop constraint pk_bcotransac1  cascade;
alter table bcotransac1
   add constraint pk_bcotransac1 primary key (cod_ctabco, sec_transacc);

alter table bcotransac2
   drop constraint pk_bcotransac2  cascade;
alter table bcotransac2
   add constraint pk_bcotransac2 primary key (sec_transacc, line, cod_ctabco);

alter table bcotransac3
   drop constraint pk_bcotransac3  cascade;
alter table bcotransac3
   add constraint pk_bcotransac3 primary key (sec_transacc, aplicar_a, motivo_cxp, cod_ctabco);

alter table caja_tipo_trx
   drop constraint pk_caja_tipo_trx  cascade;
alter table caja_tipo_trx
   add constraint pk_caja_tipo_trx primary key (tipo_trx);

alter table caja_trx1
   drop constraint pk_caja_trx1  cascade;
alter table caja_trx1
   add constraint pk_caja_trx1 primary key (numero_trx, caja);

alter table caja_trx2
   drop constraint pk_caja_trx2  cascade;
alter table caja_trx2
   add constraint pk_caja_trx2 primary key (numero_trx, caja, linea);

alter table cajas
   drop constraint pk_cajas  cascade;
alter table cajas
   add constraint pk_cajas primary key (caja);

alter table cajas_balance
   drop constraint pk_cajas_balance  cascade;
alter table cajas_balance
   add constraint pk_cajas_balance primary key (caja, compania, aplicacion, year, periodo);

comment on table cantidad_de_empleados is
'Cantidad de Empleados';

alter table cantidad_de_empleados
   drop constraint pk_cantidad_de_empleados  cascade;
alter table cantidad_de_empleados
   add constraint pk_cantidad_de_empleados primary key (codigo_de_rango);

alter table cgl_comprobante1
   drop constraint pk_cgl_comprobante1  cascade;
alter table cgl_comprobante1
   add constraint pk_cgl_comprobante1 primary key (compania, secuencia);

alter table cgl_comprobante2
   drop constraint pk_cgl_comprobante2  cascade;
alter table cgl_comprobante2
   add constraint pk_cgl_comprobante2 primary key (compania, secuencia, linea);

alter table cgl_financiero
   drop constraint pk_cgl_financiero  cascade;
alter table cgl_financiero
   add constraint pk_cgl_financiero primary key (no_informe, cuenta);

alter table cgl_presupuesto
   drop constraint pk_cgl_presupuesto  cascade;
alter table cgl_presupuesto
   add constraint pk_cgl_presupuesto primary key (cuenta, compania, anio, mes);

alter table cglauxiliares
   drop constraint pk_cglauxiliares  cascade;
alter table cglauxiliares
   add constraint pk_cglauxiliares primary key (auxiliar);

alter table cglauxxaplicacion
   drop constraint pk_cglauxxaplicacion  cascade;
alter table cglauxxaplicacion
   add constraint pk_cglauxxaplicacion primary key (auxiliar, aplicacion);

alter table cglcomprobante1
   drop constraint pk_cglcomprobante1  cascade;
alter table cglcomprobante1
   add constraint pk_cglcomprobante1 primary key (secuencia, compania, aplicacion, year, periodo);

alter table cglcomprobante2
   drop constraint pk_cglcomprobante2  cascade;
alter table cglcomprobante2
   add constraint pk_cglcomprobante2 primary key (linea, secuencia, compania, aplicacion, year, periodo);

alter table cglcomprobante3
   drop constraint pk_cglcomprobante3  cascade;
alter table cglcomprobante3
   add constraint pk_cglcomprobante3 primary key (linea, linea_aux1, secuencia, compania, aplicacion, year, periodo);

alter table cglcomprobante4
   drop constraint pk_cglcomprobante4  cascade;
alter table cglcomprobante4
   add constraint pk_cglcomprobante4 primary key (linea_aux2, linea, secuencia, compania, aplicacion, year, periodo);

alter table cglctasxaplicacion
   drop constraint pk_cglctasxaplicacion  cascade;
alter table cglctasxaplicacion
   add constraint pk_cglctasxaplicacion primary key (cuenta, aplicacion);

alter table cglcuentas
   drop constraint pk_cglcuentas  cascade;
alter table cglcuentas
   add constraint pk_cglcuentas primary key (cuenta);

alter table cglniveles
   drop constraint pk_cglniveles  cascade;
alter table cglniveles
   add constraint pk_cglniveles primary key (nivel);

alter table cglperiodico1
   drop constraint pk_cglperiodico1  cascade;
alter table cglperiodico1
   add constraint pk_cglperiodico1 primary key (compania, secuencia);

alter table cglperiodico2
   drop constraint pk_cglperiodico2  cascade;
alter table cglperiodico2
   add constraint pk_cglperiodico2 primary key (compania, secuencia, linea);

alter table cglperiodico3
   drop constraint pk_cglperiodico3  cascade;
alter table cglperiodico3
   add constraint pk_cglperiodico3 primary key (compania, secuencia, linea, linea_aux);

alter table cglperiodico4
   drop constraint pk_cglperiodico4  cascade;
alter table cglperiodico4
   add constraint pk_cglperiodico4 primary key (compania, secuencia, linea, linea_aux);

alter table cglposteo
   drop constraint pk_cglposteo  cascade;
alter table cglposteo
   add constraint pk_cglposteo primary key (consecutivo);

alter table cglposteoaux1
   drop constraint pk_cglposteoaux1  cascade;
alter table cglposteoaux1
   add constraint pk_cglposteoaux1 primary key (consecutivo, auxiliar, secuencial);

alter table cglposteoaux2
   drop constraint pk_cglposteoaux2  cascade;
alter table cglposteoaux2
   add constraint pk_cglposteoaux2 primary key (consecutivo, auxiliar, secuencial);

alter table cglrecurrente
   drop constraint pk_cglrecurrente  cascade;
alter table cglrecurrente
   add constraint pk_cglrecurrente primary key (compania, secuencia, aplicacion, year, periodo);

alter table cglsldoaux1
   drop constraint pk_cglsldoaux1  cascade;
alter table cglsldoaux1
   add constraint pk_cglsldoaux1 primary key (compania, cuenta, auxiliar, year, periodo);

alter table cglsldoaux2
   drop constraint pk_cglsldoaux2  cascade;
alter table cglsldoaux2
   add constraint pk_cglsldoaux2 primary key (compania, cuenta, auxiliar, year, periodo);

alter table cglsldocuenta
   drop constraint pk_cglsldocuenta  cascade;
alter table cglsldocuenta
   add constraint pk_cglsldocuenta primary key (compania, year, periodo, cuenta);

alter table cgltipocomp
   drop constraint pk_cgltipocomp  cascade;
alter table cgltipocomp
   add constraint pk_cgltipocomp primary key (tipo_comp);

alter table choferes
   drop constraint pk_choferes  cascade;
alter table choferes
   add constraint pk_choferes primary key (chofer);

alter table clientes
   drop constraint pk_clientes  cascade;
alter table clientes
   add constraint pk_clientes primary key (cliente);

alter table clientes_agrupados
   drop constraint pk_clientes_agrupados  cascade;
alter table clientes_agrupados
   add constraint pk_clientes_agrupados primary key (cliente, codigo_valor_grupo);

alter table clientes_exentos
   drop constraint pk_clientes_exentos  cascade;
alter table clientes_exentos
   add constraint pk_clientes_exentos primary key (impuesto, cliente);

alter table clientes_x_volumen
   drop constraint pk_clientes_x_volumen  cascade;
alter table clientes_x_volumen
   add constraint pk_clientes_x_volumen primary key (cliente, grupo);

alter table cobradores
   drop constraint pk_cobradores  cascade;
alter table cobradores
   add constraint pk_cobradores primary key (cobrador);

alter table comparacion_ventas
   drop constraint pk_comparacion_ventas  cascade;
alter table comparacion_ventas
   add constraint pk_comparacion_ventas primary key (cliente, codigo_valor_grupo, compania);

alter table convmedi
   drop constraint pk_convmedi  cascade;
alter table convmedi
   add constraint pk_convmedi primary key (old_unidad, new_unidad);

alter table corredores
   drop constraint pk_corredores  cascade;
alter table corredores
   add constraint pk_corredores primary key (licencia);

alter table cos_calculo
   drop constraint pk_cos_calculo  cascade;
alter table cos_calculo
   add constraint pk_cos_calculo primary key (secuencia, compania, linea, usuario);

alter table cos_consumo
   drop constraint pk_cos_consumo  cascade;
alter table cos_consumo
   add constraint pk_cos_consumo primary key (secuencia, compania, linea);

alter table cos_consumo_eys2
   drop constraint pk_cos_consumo_eys2  cascade;
alter table cos_consumo_eys2
   add constraint pk_cos_consumo_eys2 primary key (articulo, almacen, no_transaccion, eys2_linea);

alter table cos_cuenta_rubro
   drop constraint pk_cos_cuenta_rubro  cascade;
alter table cos_cuenta_rubro
   add constraint pk_cos_cuenta_rubro primary key (cuenta);

alter table cos_produccion
   drop constraint pk_cos_produccion  cascade;
alter table cos_produccion
   add constraint pk_cos_produccion primary key (secuencia, compania, linea);

alter table cos_produccion_eys2
   drop constraint pk_cos_produccion_eys2  cascade;
alter table cos_produccion_eys2
   add constraint pk_cos_produccion_eys2 primary key (articulo, almacen, no_transaccion, eys2_linea);

alter table cos_rubros
   drop constraint pk_cos_rubros  cascade;
alter table cos_rubros
   add constraint pk_cos_rubros primary key (rubro);

alter table cos_trx
   drop constraint pk_cos_trx  cascade;
alter table cos_trx
   add constraint pk_cos_trx primary key (secuencia, compania);

alter table cxc_balance_clientes
   drop constraint pk_cxc_balance_clientes  cascade;
alter table cxc_balance_clientes
   add constraint pk_cxc_balance_clientes primary key (cliente, compania, usuario);

alter table cxc_estado_d_cta_airsea
   drop constraint pk_cxc_estado_d_cta_airsea  cascade;
alter table cxc_estado_d_cta_airsea
   add constraint pk_cxc_estado_d_cta_airsea primary key (documento, docmto_aplicar, cliente, motivo_cxc, almacen, usuario);

alter table cxc_estado_de_cuenta
   drop constraint pk_cxc_estado_de_cuenta  cascade;
alter table cxc_estado_de_cuenta
   add constraint pk_cxc_estado_de_cuenta primary key (documento, docmto_aplicar, cliente, motivo_cxc, almacen);

alter table cxc_recibo
   drop constraint pk_cxc_recibo  cascade;
alter table cxc_recibo
   add constraint pk_cxc_recibo primary key (sec_ajuste_cxc, almacen);

alter table cxc_recibo1
   drop constraint pk_cxc_recibo1  cascade;
alter table cxc_recibo1
   add constraint pk_cxc_recibo1 primary key (almacen, consecutivo);

alter table cxc_recibo2
   drop constraint pk_cxc_recibo2  cascade;
alter table cxc_recibo2
   add constraint pk_cxc_recibo2 primary key (almacen, consecutivo, almacen_aplicar, documento_aplicar, motivo_aplicar);

alter table cxc_recibo3
   drop constraint pk_cxc_recibo3  cascade;
alter table cxc_recibo3
   add constraint pk_cxc_recibo3 primary key (almacen, consecutivo, linea);

alter table cxc_recibo4
   drop constraint pk_cxc_recibo4  cascade;
alter table cxc_recibo4
   add constraint pk_cxc_recibo4 primary key (almacen, consecutivo);

alter table cxc_recibo5
   drop constraint pk_cxc_recibo5  cascade;
alter table cxc_recibo5
   add constraint pk_cxc_recibo5 primary key (almacen, consecutivo, aplicar_a, monto);

alter table cxc_recibo_detalle
   drop constraint pk_cxc_recibo_detalle  cascade;
alter table cxc_recibo_detalle
   add constraint pk_cxc_recibo_detalle primary key (sec_ajuste_cxc, almacen, aplicar_a, monto);

alter table cxc_saldos_iniciales
   drop constraint pk_cxc_saldos_iniciales  cascade;
alter table cxc_saldos_iniciales
   add constraint pk_cxc_saldos_iniciales primary key (cliente, documento, almacen, motivo_cxc);

alter table cxcbalance
   drop constraint pk_cxcbalance  cascade;
alter table cxcbalance
   add constraint pk_cxcbalance primary key (cliente, compania, aplicacion, year, periodo);

alter table cxcdocm
   drop constraint pk_cxcdocm  cascade;
alter table cxcdocm
   add constraint pk_cxcdocm primary key (documento, docmto_aplicar, cliente, motivo_cxc, almacen);

alter table cxcfact1
   drop constraint pk_cxcfact1  cascade;
alter table cxcfact1
   add constraint pk_cxcfact1 primary key (almacen, no_factura);

alter table cxcfact2
   drop constraint pk_cxcfact2  cascade;
alter table cxcfact2
   add constraint pk_cxcfact2 primary key (linea, almacen, no_factura, rubro_fact_cxc);

alter table cxcfact3
   drop constraint pk_cxcfact3  cascade;
alter table cxcfact3
   add constraint pk_cxcfact3 primary key (aplicar_a, almacen, no_factura, motivo_cxc);

alter table cxchdocm
   drop constraint pk_cxchdocm  cascade;
alter table cxchdocm
   add constraint pk_cxchdocm primary key (documento, docmto_aplicar, cliente, motivo_cxc, almacen);

alter table cxcmorosidad
   drop constraint pk_cxcmorosidad  cascade;
alter table cxcmorosidad
   add constraint pk_cxcmorosidad primary key (cliente, usuario, documento, motivo_cxc, compania, almacen, vendedor);

alter table cxcmotivos
   drop constraint pk_cxcmotivos  cascade;
alter table cxcmotivos
   add constraint pk_cxcmotivos primary key (motivo_cxc);

alter table cxcrecibo1
   drop constraint pk_cxcrecibo1  cascade;
alter table cxcrecibo1
   add constraint pk_cxcrecibo1 primary key (no_recibo, almacen);

alter table cxcrecibo2
   drop constraint pk_cxcrecibo2  cascade;
alter table cxcrecibo2
   add constraint pk_cxcrecibo2 primary key (no_recibo, almacen, docm_aplicar, motivo_cxc);

alter table cxctrx1
   drop constraint pk_cxctrx1  cascade;
alter table cxctrx1
   add constraint pk_cxctrx1 primary key (sec_ajuste_cxc, almacen);

alter table cxctrx2
   drop constraint pk_cxctrx2  cascade;
alter table cxctrx2
   add constraint pk_cxctrx2 primary key (aplicar_a, sec_ajuste_cxc, almacen, motivo_cxc);

alter table cxctrx3
   drop constraint pk_cxctrx3  cascade;
alter table cxctrx3
   add constraint pk_cxctrx3 primary key (linea, sec_ajuste_cxc, almacen);

alter table cxp_comprobante
   drop constraint pk_cxp_comprobante  cascade;
alter table cxp_comprobante
   add constraint pk_cxp_comprobante primary key (compania, proveedor, motivo_cxp, documento, cuenta, debito, credito);

alter table cxp_saldos_iniciales
   drop constraint pk_cxp_saldos_iniciales  cascade;
alter table cxp_saldos_iniciales
   add constraint pk_cxp_saldos_iniciales primary key (proveedor, factura, compania);

alter table cxpajuste1
   drop constraint pk_cxpajuste1  cascade;
alter table cxpajuste1
   add constraint pk_cxpajuste1 primary key (compania, sec_ajuste_cxp);

alter table cxpajuste2
   drop constraint pk_cxpajuste2  cascade;
alter table cxpajuste2
   add constraint pk_cxpajuste2 primary key (compania, sec_ajuste_cxp, aplicar_a, motivo_cxp);

alter table cxpajuste3
   drop constraint pk_cxpajuste3  cascade;
alter table cxpajuste3
   add constraint pk_cxpajuste3 primary key (compania, sec_ajuste_cxp, linea);

alter table cxpbalance
   drop constraint pk_cxpbalance  cascade;
alter table cxpbalance
   add constraint pk_cxpbalance primary key (compania, aplicacion, year, periodo, proveedor);

alter table cxpdocm
   drop constraint pk_cxpdocm  cascade;
alter table cxpdocm
   add constraint pk_cxpdocm primary key (proveedor, compania, documento, docmto_aplicar, motivo_cxp);

alter table cxpfact1
   drop constraint pk_cxpfact1  cascade;
alter table cxpfact1
   add constraint pk_cxpfact1 primary key (proveedor, fact_proveedor, compania);

alter table cxpfact2
   drop constraint pk_cxpfact2  cascade;
alter table cxpfact2
   add constraint pk_cxpfact2 primary key (proveedor, fact_proveedor, rubro_fact_cxp, linea, compania);

alter table cxpfact3
   drop constraint pk_cxpfact3  cascade;
alter table cxpfact3
   add constraint pk_cxpfact3 primary key (proveedor, fact_proveedor, aplicar_a, compania, motivo_cxp);

alter table cxphdocm
   drop constraint pk_cxphdocm  cascade;
alter table cxphdocm
   add constraint pk_cxphdocm primary key (proveedor, compania, documento, docmto_aplicar, motivo_cxp);

alter table cxpmorosidad
   drop constraint pk_cxpmorosidad  cascade;
alter table cxpmorosidad
   add constraint pk_cxpmorosidad primary key (proveedor, documento, motivo_cxp);

alter table cxpmotivos
   drop constraint pk_cxpmotivos  cascade;
alter table cxpmotivos
   add constraint pk_cxpmotivos primary key (motivo_cxp);

alter table departamentos
   drop constraint pk_departamentos  cascade;
alter table departamentos
   add constraint pk_departamentos primary key (codigo);

alter table descuentos
   drop constraint pk_descuentos  cascade;
alter table descuentos
   add constraint pk_descuentos primary key (secuencia);

alter table descuentos_por_articulo
   drop constraint pk_descuentos_por_articulo  cascade;
alter table descuentos_por_articulo
   add constraint pk_descuentos_por_articulo primary key (articulo, almacen, secuencia);

alter table descuentos_por_cliente
   drop constraint pk_descuentos_por_cliente  cascade;
alter table descuentos_por_cliente
   add constraint pk_descuentos_por_cliente primary key (secuencia, cliente);

alter table descuentos_por_grupo
   drop constraint pk_descuentos_por_grupo  cascade;
alter table descuentos_por_grupo
   add constraint pk_descuentos_por_grupo primary key (secuencia, codigo_valor_grupo);

alter table destinos
   drop constraint pk_destinos  cascade;
alter table destinos
   add constraint pk_destinos primary key (cod_destino);

alter table div_grupos
   drop constraint pk_div_grupos  cascade;
alter table div_grupos
   add constraint pk_div_grupos primary key (grupo);

alter table div_libro_d_acciones
   drop constraint pk_div_libro_d_acciones  cascade;
alter table div_libro_d_acciones
   add constraint pk_div_libro_d_acciones primary key (certificado);

alter table div_movimientos
   drop constraint pk_div_movimientos  cascade;
alter table div_movimientos
   add constraint pk_div_movimientos primary key (socio, fecha);

alter table div_parametros_de_pago
   drop constraint pk_div_parametros_de_pago  cascade;
alter table div_parametros_de_pago
   add constraint pk_div_parametros_de_pago primary key (fecha);

alter table div_socios
   drop constraint pk_div_socios  cascade;
alter table div_socios
   add constraint pk_div_socios primary key (socio);

alter table empleados
   drop constraint pk_empleados  cascade;
alter table empleados
   add constraint pk_empleados primary key (cedula);

comment on table encuesta is
'Encuesta';

alter table encuesta
   drop constraint pk_encuesta  cascade;
alter table encuesta
   add constraint pk_encuesta primary key (empresa);

alter table eys1
   drop constraint pk_eys1  cascade;
alter table eys1
   add constraint pk_eys1 primary key (almacen, no_transaccion);

alter table eys2
   drop constraint pk_eys2  cascade;
alter table eys2
   add constraint pk_eys2 primary key (articulo, almacen, no_transaccion, linea);

alter table eys3
   drop constraint pk_eys3  cascade;
alter table eys3
   add constraint pk_eys3 primary key (almacen, no_transaccion, cuenta);

alter table eys4
   drop constraint pk_eys4  cascade;
alter table eys4
   add constraint pk_eys4 primary key (articulo, almacen, no_transaccion, inv_linea);

alter table eys6
   drop constraint pk_eys6  cascade;
alter table eys6
   add constraint pk_eys6 primary key (articulo, almacen, no_transaccion, linea, compra_no_transaccion, compra_linea);

alter table f_conytram
   drop constraint pk_f_conytram  cascade;
alter table f_conytram
   add constraint pk_f_conytram primary key (almacen, tipo, no_documento);

alter table fac_cambio_de_precios
   drop constraint pk_fac_cambio_de_precios  cascade;
alter table fac_cambio_de_precios
   add constraint pk_fac_cambio_de_precios primary key (articulo, almacen, viejo, nuevo);

alter table fac_ciudades
   drop constraint pk_fac_ciudades  cascade;
alter table fac_ciudades
   add constraint pk_fac_ciudades primary key (ciudad);

alter table fac_desc_x_cliente
   drop constraint pk_fac_desc_x_cliente  cascade;
alter table fac_desc_x_cliente
   add constraint pk_fac_desc_x_cliente primary key (cliente, articulo);

alter table fac_historico
   drop constraint pk_fac_historico  cascade;
alter table fac_historico
   add constraint pk_fac_historico primary key (almacen, factura, cliente, fecha, producto, anio, mes, cantidad, precio, descuento1, descuento2);

alter table fac_informe_03
   drop constraint pk_fac_informe_03  cascade;
alter table fac_informe_03
   add constraint pk_fac_informe_03 primary key (articulo, almacen, cliente, desde, hasta, usuario);

alter table fac_paises
   drop constraint pk_fac_paises  cascade;
alter table fac_paises
   add constraint pk_fac_paises primary key (pais);

alter table fac_parametros_contables
   drop constraint pk_fac_parametros_contables  cascade;
alter table fac_parametros_contables
   add constraint pk_fac_parametros_contables primary key (codigo_valor_grupo, almacen, referencia);

alter table fac_promociones
   drop constraint pk_fac_promociones  cascade;
alter table fac_promociones
   add constraint pk_fac_promociones primary key (articulo, almacen, desde);

alter table fac_resumen_semanal
   drop constraint pk_fac_resumen_semanal  cascade;
alter table fac_resumen_semanal
   add constraint pk_fac_resumen_semanal primary key (usuario, documento, docmto_aplicar, cliente, motivo_cxc, almacen);

alter table fac_vtas_vs_cobros
   drop constraint pk_fac_vtas_vs_cobros  cascade;
alter table fac_vtas_vs_cobros
   add constraint pk_fac_vtas_vs_cobros primary key (fecha, cliente, almacen);

alter table facparamcgl
   drop constraint pk_facparamcgl  cascade;
alter table facparamcgl
   add constraint pk_facparamcgl primary key (codigo_valor_grupo, almacen);

alter table fact_autoriza_descto
   drop constraint pk_fact_autoriza_descto  cascade;
alter table fact_autoriza_descto
   add constraint pk_fact_autoriza_descto primary key (usuario);

alter table fact_comparativo_de_ventas
   drop constraint pk_fact_comparativo_de_ventas  cascade;
alter table fact_comparativo_de_ventas
   add constraint pk_fact_comparativo_de_ventas primary key (cliente);

alter table fact_estadisticas
   drop constraint pk_fact_estadisticas  cascade;
alter table fact_estadisticas
   add constraint pk_fact_estadisticas primary key (cliente, usuario, articulo, almacen, num_documento, linea);

alter table fact_informe_ventas
   drop constraint pk_fact_informe_ventas  cascade;
alter table fact_informe_ventas
   add constraint pk_fact_informe_ventas primary key (usuario, factura, almacen);

alter table fact_list_despachos
   drop constraint pk_fact_list_despachos  cascade;
alter table fact_list_despachos
   add constraint pk_fact_list_despachos primary key (almacen, tipo, num_documento, usuario);

alter table fact_referencias
   drop constraint pk_fact_referencias  cascade;
alter table fact_referencias
   add constraint pk_fact_referencias primary key (referencia);

alter table factmotivos
   drop constraint pk_factmotivos  cascade;
alter table factmotivos
   add constraint pk_factmotivos primary key (tipo);

alter table factpasetwt
   drop constraint pk_factpasetwt  cascade;
alter table factpasetwt
   add constraint pk_factpasetwt primary key (maquina, fecha, secuencia, producto);

alter table factsobregiro
   drop constraint pk_factsobregiro  cascade;
alter table factsobregiro
   add constraint pk_factsobregiro primary key (fecha, cliente);

alter table factura1
   drop constraint pk_factura1  cascade;
alter table factura1
   add constraint pk_factura1 primary key (almacen, tipo, num_documento);

alter table factura2
   drop constraint pk_factura2  cascade;
alter table factura2
   add constraint pk_factura2 primary key (almacen, tipo, num_documento, linea);

alter table factura2_eys2
   drop constraint pk_factura2_eys2  cascade;
alter table factura2_eys2
   add constraint pk_factura2_eys2 primary key (articulo, almacen, no_transaccion, eys2_linea);

alter table factura3
   drop constraint pk_factura3  cascade;
alter table factura3
   add constraint pk_factura3 primary key (almacen, tipo, num_documento, linea, impuesto);

alter table factura4
   drop constraint pk_factura4  cascade;
alter table factura4
   add constraint pk_factura4 primary key (almacen, tipo, num_documento, rubro_fact_cxc);

alter table factura5
   drop constraint pk_factura5  cascade;
alter table factura5
   add constraint pk_factura5 primary key (almacen, tipo, num_documento, banco, num_cheque);

alter table factura6
   drop constraint pk_factura6  cascade;
alter table factura6
   add constraint pk_factura6 primary key (almacen, tipo, num_documento, banco);

alter table factura7
   drop constraint pk_factura7  cascade;
alter table factura7
   add constraint pk_factura7 primary key (almacen, tipo, num_documento);

alter table fax
   drop constraint pk_fax  cascade;
alter table fax
   add constraint pk_fax primary key (pb_phnum1);

alter table funcionarios_cliente
   drop constraint pk_funcionarios_cliente  cascade;
alter table funcionarios_cliente
   add constraint pk_funcionarios_cliente primary key (cliente, sec_funcionario_clte);

alter table funcionarios_proveedor
   drop constraint pk_funcionarios_proveedor  cascade;
alter table funcionarios_proveedor
   add constraint pk_funcionarios_proveedor primary key (proveedor, sec_funcionario);

alter table gral_app_x_usuario
   drop constraint pk_gral_app_x_usuario  cascade;
alter table gral_app_x_usuario
   add constraint pk_gral_app_x_usuario primary key (usuario, aplicacion);

alter table gral_forma_de_pago
   drop constraint pk_gral_forma_de_pago  cascade;
alter table gral_forma_de_pago
   add constraint pk_gral_forma_de_pago primary key (forma_pago);

alter table gral_grupos_aplicacion
   drop constraint pk_gral_grupos_aplicacion  cascade;
alter table gral_grupos_aplicacion
   add constraint pk_gral_grupos_aplicacion primary key (grupo, aplicacion);

alter table gral_impuestos
   drop constraint pk_gral_impuestos  cascade;
alter table gral_impuestos
   add constraint pk_gral_impuestos primary key (impuesto);

alter table gral_usuarios
   drop constraint pk_gral_usuarios  cascade;
alter table gral_usuarios
   add constraint pk_gral_usuarios primary key (usuario);

alter table gral_valor_grupos
   drop constraint pk_gral_valor_grupos  cascade;
alter table gral_valor_grupos
   add constraint pk_gral_valor_grupos primary key (codigo_valor_grupo);

alter table gral_verificador_contable
   drop constraint pk_gral_verificador_contable  cascade;
alter table gral_verificador_contable
   add constraint pk_gral_verificador_contable primary key (documento, fecha, monto, usuario, cuenta, tipo_de_documento, codigo, titulo, desde, hasta, compania, consecutivo, periodo);

alter table gralaplicaciones
   drop constraint pk_gralaplicaciones  cascade;
alter table gralaplicaciones
   add constraint pk_gralaplicaciones primary key (aplicacion);

alter table gralcompanias
   drop constraint pk_gralcompanias  cascade;
alter table gralcompanias
   add constraint pk_gralcompanias primary key (compania);

alter table gralparametros
   drop constraint pk_gralparametros  cascade;
alter table gralparametros
   add constraint pk_gralparametros primary key (parametro, aplicacion);

alter table gralparaxapli
   drop constraint pk_gralparaxapli  cascade;
alter table gralparaxapli
   add constraint pk_gralparaxapli primary key (parametro, aplicacion);

alter table gralparaxcia
   drop constraint pk_gralparaxcia  cascade;
alter table gralparaxcia
   add constraint pk_gralparaxcia primary key (compania, parametro, aplicacion);

alter table gralperiodos
   drop constraint pk_gralperiodos  cascade;
alter table gralperiodos
   add constraint pk_gralperiodos primary key (compania, aplicacion, year, periodo);

alter table gralsecuencias
   drop constraint pk_gralsecuencias  cascade;
alter table gralsecuencias
   add constraint pk_gralsecuencias primary key (aplicacion, parametro);

alter table gralsecxcia
   drop constraint pk_gralsecxcia  cascade;
alter table gralsecxcia
   add constraint pk_gralsecxcia primary key (aplicacion, parametro, compania, year, periodo);

alter table hp_barcos
   drop constraint pk_hp_barcos  cascade;
alter table hp_barcos
   add constraint pk_hp_barcos primary key (barco, molino, fecha, toneladas, costo, tipo_de_trigo);

alter table hp_molinos
   drop constraint pk_hp_molinos  cascade;
alter table hp_molinos
   add constraint pk_hp_molinos primary key (molino);

alter table imp_oc
   drop constraint pk_imp_oc  cascade;
alter table imp_oc
   add constraint pk_imp_oc primary key (impuesto);

alter table impuestos_facturacion
   drop constraint pk_impuestos_facturacion  cascade;
alter table impuestos_facturacion
   add constraint pk_impuestos_facturacion primary key (impuesto);

alter table impuestos_por_grupo
   drop constraint pk_impuestos_por_grupo  cascade;
alter table impuestos_por_grupo
   add constraint pk_impuestos_por_grupo primary key (codigo_valor_grupo, impuesto);

alter table inconsistencias
   drop constraint pk_inconsistencias  cascade;
alter table inconsistencias
   add constraint pk_inconsistencias primary key (usuario, mensaje, codigo, fecha);

alter table informe_presupuesto
   drop constraint pk_informe_presupuesto  cascade;
alter table informe_presupuesto
   add constraint pk_informe_presupuesto primary key (articulo, almacen, cliente, compania, aplicacion, year, periodo, usuario);

alter table inv_conteo
   drop constraint pk_inv_conteo  cascade;
alter table inv_conteo
   add constraint pk_inv_conteo primary key (articulo, almacen, fecha);

alter table inv_conversion
   drop constraint pk_inv_conversion  cascade;
alter table inv_conversion
   add constraint pk_inv_conversion primary key (convertir_d, convertir_a);

alter table inv_fifo_lifo
   drop constraint pk_inv_fifo_lifo  cascade;
alter table inv_fifo_lifo
   add constraint pk_inv_fifo_lifo primary key (articulo, almacen, fecha_compra, usuario);

alter table inv_fisico1
   drop constraint pk_inv_fisico1  cascade;
alter table inv_fisico1
   add constraint pk_inv_fisico1 primary key (almacen, secuencia);

alter table inv_fisico2
   drop constraint pk_inv_fisico2  cascade;
alter table inv_fisico2
   add constraint pk_inv_fisico2 primary key (almacen, secuencia, linea, articulo);

alter table inv_list_balance
   drop constraint pk_inv_list_balance  cascade;
alter table inv_list_balance
   add constraint pk_inv_list_balance primary key (articulo, almacen, usuario);

alter table inv_list_sugerencias
   drop constraint pk_inv_list_sugerencias  cascade;
alter table inv_list_sugerencias
   add constraint pk_inv_list_sugerencias primary key (articulo, almacen, usuario);

alter table inv_movimientos
   drop constraint pk_inv_movimientos  cascade;
alter table inv_movimientos
   add constraint pk_inv_movimientos primary key (usuario, articulo, almacen, no_transaccion, linea);

alter table inv_prestamos
   drop constraint pk_inv_prestamos  cascade;
alter table inv_prestamos
   add constraint pk_inv_prestamos primary key (articulo, almacen, fecha, cantidad);

alter table invbalance
   drop constraint pk_invbalance  cascade;
alter table invbalance
   add constraint pk_invbalance primary key (compania, aplicacion, year, periodo, articulo, almacen);

alter table invmotivos
   drop constraint pk_invmotivos  cascade;
alter table invmotivos
   add constraint pk_invmotivos primary key (motivo);

alter table invparal
   drop constraint pk_invparal  cascade;
alter table invparal
   add constraint pk_invparal primary key (almacen, parametro, aplicacion);

alter table listas_de_precio_1
   drop constraint pk_listas_de_precio_1  cascade;
alter table listas_de_precio_1
   add constraint pk_listas_de_precio_1 primary key (secuencia);

alter table listas_de_precio_2
   drop constraint pk_listas_de_precio_2  cascade;
alter table listas_de_precio_2
   add constraint pk_listas_de_precio_2 primary key (secuencia, articulo, almacen);

alter table marcas
   drop constraint pk_marcas  cascade;
alter table marcas
   add constraint pk_marcas primary key (codigo);

alter table navieras
   drop constraint pk_navieras  cascade;
alter table navieras
   add constraint pk_navieras primary key (cod_naviera);

alter table nom_ajuste_pagos_acreedores
   drop constraint pk_nom_ajuste_pagos_acreedores  cascade;
alter table nom_ajuste_pagos_acreedores
   add constraint pk_nom_ajuste_pagos_acreedores primary key (numero_documento, codigo_empleado, cod_concepto_planilla, compania, fecha);

alter table nom_conceptos_para_calculo
   drop constraint pk_nom_conceptos_para_calculo  cascade;
alter table nom_conceptos_para_calculo
   add constraint pk_nom_conceptos_para_calculo primary key (cod_concepto_planilla, concepto_aplica);

alter table nom_otros_ingresos
   drop constraint pk_nom_otros_ingresos  cascade;
alter table nom_otros_ingresos
   add constraint pk_nom_otros_ingresos primary key (tipo_calculo, tipo_planilla, numero_planilla, year, codigo_empleado, compania, cod_concepto_planilla);

alter table nom_tipo_de_calculo
   drop constraint pk_nom_tipo_de_calculo  cascade;
alter table nom_tipo_de_calculo
   add constraint pk_nom_tipo_de_calculo primary key (tipo_calculo);

comment on table nomacrem is
'Acreedortes x Empleado';

alter table nomacrem
   drop constraint pk_nomacrem  cascade;
alter table nomacrem
   add constraint pk_nomacrem primary key (numero_documento, codigo_empleado, cod_concepto_planilla, compania);

comment on table nomconce is
'Concepto Utilizados en planilla';

alter table nomconce
   drop constraint pk_nomconce  cascade;
alter table nomconce
   add constraint pk_nomconce primary key (cod_concepto_planilla);

comment on table nomctrac is
'Control de acumulado de planilla';

alter table nomctrac
   drop constraint pk_nomctrac  cascade;
alter table nomctrac
   add constraint pk_nomctrac primary key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento);

alter table nomdedu
   drop constraint pk_nomdedu  cascade;
alter table nomdedu
   add constraint pk_nomdedu primary key (numero_documento, codigo_empleado, cod_concepto_planilla, compania, periodo);

alter table nomdescuentos
   drop constraint pk_nomdescuentos  cascade;
alter table nomdescuentos
   add constraint pk_nomdescuentos primary key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento);

comment on table nomdfer is
'Dias Feriados';

alter table nomdfer
   drop constraint pk_nomdfer  cascade;
alter table nomdfer
   add constraint pk_nomdfer primary key (fecha);

alter table nomhoras
   drop constraint pk_nomhoras  cascade;
alter table nomhoras
   add constraint pk_nomhoras primary key (fecha_laborable, codigo_empleado, compania, tipo_planilla, numero_planilla, fecha_salida, tipodhora, year, acumula);

comment on table nomhrtrab is
'Registro de Horas Trabajadas';

alter table nomhrtrab
   drop constraint pk_nomhrtrab  cascade;
alter table nomhrtrab
   add constraint pk_nomhrtrab primary key (fecha_laborable, codigo_empleado, compania, tipo_planilla, numero_planilla, fecha_salida);

comment on table nomimrta is
'Impuesto sobre la renta';

alter table nomimrta
   drop constraint pk_nomimrta  cascade;
alter table nomimrta
   add constraint pk_nomimrta primary key (sbruto_inicial, sbruto_final);

alter table nomperiodos
   drop constraint pk_nomperiodos  cascade;
alter table nomperiodos
   add constraint pk_nomperiodos primary key (periodo);

comment on table nomrelac is
'Tabla de relación de conceptos';

alter table nomrelac
   drop constraint pk_nomrelac  cascade;
alter table nomrelac
   add constraint pk_nomrelac primary key (tipo_calculo, cod_concepto_planilla);

alter table nomtipodeconcepto
   drop constraint pk_nomtipodeconcepto  cascade;
alter table nomtipodeconcepto
   add constraint pk_nomtipodeconcepto primary key (tipodeconcepto);

alter table nomtipodehoras
   drop constraint pk_nomtipodehoras  cascade;
alter table nomtipodehoras
   add constraint pk_nomtipodehoras primary key (tipodhora);

comment on table nomtpla is
'Tipo de Planilla';

alter table nomtpla
   drop constraint pk_nomtpla  cascade;
alter table nomtpla
   add constraint pk_nomtpla primary key (tipo_planilla);

alter table nomtpla2
   drop constraint pk_nomtpla2  cascade;
alter table nomtpla2
   add constraint pk_nomtpla2 primary key (tipo_planilla, numero_planilla, year);

alter table oc1
   drop constraint pk_oc1  cascade;
alter table oc1
   add constraint pk_oc1 primary key (numero_oc, compania);

alter table oc2
   drop constraint pk_oc2  cascade;
alter table oc2
   add constraint pk_oc2 primary key (linea_oc, numero_oc, compania, articulo);

alter table oc3
   drop constraint pk_oc3  cascade;
alter table oc3
   add constraint pk_oc3 primary key (impuesto, numero_oc, compania);

alter table oc4
   drop constraint pk_oc4  cascade;
alter table oc4
   add constraint pk_oc4 primary key (tipo_de_cargo, numero_oc, compania, linea);

comment on table origen_del_sistema is
'Origen del Sistema';

alter table origen_del_sistema
   drop constraint pk_origen_del_sistema  cascade;
alter table origen_del_sistema
   add constraint pk_origen_del_sistema primary key (codigo_de_origen);

alter table otros_cargos
   drop constraint pk_otros_cargos  cascade;
alter table otros_cargos
   add constraint pk_otros_cargos primary key (tipo_de_cargo);

alter table pat
   drop constraint pk_pat  cascade;
alter table pat
   add constraint pk_pat primary key (concepto, ruc, dv, tipo_per, nombre, monto, factura, fecha, compania);

alter table pat_listado
   drop constraint pk_pat_listado  cascade;
alter table pat_listado
   add constraint pk_pat_listado primary key (tipo_reg, codigo_info, concepto, ruc, digito_verif, tipo_per, nombre, monto, numero_factura, fecha_factura, compania);

alter table payments
   drop constraint pk_payments  cascade;
alter table payments
   add constraint pk_payments primary key (vendor_name, check_number, fecha, cash_account, cash_amount, number_of_distributions, description, gl_account, amount, transaction_period, transaction_number);

alter table periodos_depre
   drop constraint pk_periodos_depre  cascade;
alter table periodos_depre
   add constraint pk_periodos_depre primary key (no_activo, year, compania);

alter table pla_afectacion_contable
   drop constraint pk_pla_afectacion_contable  cascade;
alter table pla_afectacion_contable
   add constraint pk_pla_afectacion_contable primary key (departamento, cuenta, cod_concepto_planilla);

alter table pla_ajuste_renta
   drop constraint pk_pla_ajuste_renta  cascade;
alter table pla_ajuste_renta
   add constraint pk_pla_ajuste_renta primary key (codigo_empleado, compania, anio);

alter table pla_anexo03
   drop constraint pk_pla_anexo03  cascade;
alter table pla_anexo03
   add constraint pk_pla_anexo03 primary key (usuario, anio, codigo_empleado, compania);

alter table pla_balance_acreedores
   drop constraint pk_pla_balance_acreedores  cascade;
alter table pla_balance_acreedores
   add constraint pk_pla_balance_acreedores primary key (numero_documento, codigo_empleado, cod_concepto_planilla, compania, usuario);

alter table pla_bases_del_calculo
   drop constraint pk_pla_bases_del_calculo  cascade;
alter table pla_bases_del_calculo
   add constraint pk_pla_bases_del_calculo primary key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento, descripcion, fecha);

alter table pla_bonos_proyectado
   drop constraint pk_pla_bonos_proyectado  cascade;
alter table pla_bonos_proyectado
   add constraint pk_pla_bonos_proyectado primary key (codigo_empleado, compania);

alter table pla_carta_ayt
   drop constraint pk_pla_carta_ayt  cascade;
alter table pla_carta_ayt
   add constraint pk_pla_carta_ayt primary key (codigo_empleado, compania, usuario);

alter table pla_comprobante_conceptos
   drop constraint pk_pla_comprobante_conceptos  cascade;
alter table pla_comprobante_conceptos
   add constraint pk_pla_comprobante_conceptos primary key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento, usuario);

alter table pla_comprobante_de_pago
   drop constraint pk_pla_comprobante_de_pago  cascade;
alter table pla_comprobante_de_pago
   add constraint pk_pla_comprobante_de_pago primary key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento, usuario, descripcion);

alter table pla_comprobante_desglose
   drop constraint pk_pla_comprobante_desglose  cascade;
alter table pla_comprobante_desglose
   add constraint pk_pla_comprobante_desglose primary key (compania, codigo_empleado);

alter table pla_comprobante_horas
   drop constraint pk_pla_comprobante_horas  cascade;
alter table pla_comprobante_horas
   add constraint pk_pla_comprobante_horas primary key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento, usuario, tipodhora);

alter table pla_constancias
   drop constraint pk_pla_constancias  cascade;
alter table pla_constancias
   add constraint pk_pla_constancias primary key (codigo_empleado, compania, fecha);

alter table pla_datalog
   drop constraint pk_pla_datalog  cascade;
alter table pla_datalog
   add constraint pk_pla_datalog primary key (codigo_empleado, fecha, hora);

alter table pla_desgloce_horas
   drop constraint pk_pla_desgloce_horas  cascade;
alter table pla_desgloce_horas
   add constraint pk_pla_desgloce_horas primary key (fecha_laborable, codigo_empleado, compania, tipo_planilla, numero_planilla, fecha_salida, tipodhora, year, acumula, usuario);

alter table pla_desgloce_planilla
   drop constraint pk_pla_desgloce_planilla  cascade;
alter table pla_desgloce_planilla
   add constraint pk_pla_desgloce_planilla primary key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento, usuario);

alter table pla_desglose_de_monedas
   drop constraint pk_pla_desglose_de_monedas  cascade;
alter table pla_desglose_de_monedas
   add constraint pk_pla_desglose_de_monedas primary key (usuario, codigo_empleado, compania, tipo_planilla, numero_planilla, year, tipo_calculo);

alter table pla_desglose_horas
   drop constraint pk_pla_desglose_horas  cascade;
alter table pla_desglose_horas
   add constraint pk_pla_desglose_horas primary key (usuario, linea);

alter table pla_desglose_planilla
   drop constraint pk_pla_desglose_planilla  cascade;
alter table pla_desglose_planilla
   add constraint pk_pla_desglose_planilla primary key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento, usuario);

alter table pla_estructura_listado
   drop constraint pk_pla_estructura_listado  cascade;
alter table pla_estructura_listado
   add constraint pk_pla_estructura_listado primary key (cod_concepto_planilla, listado, tipo_de_columna);

alter table pla_extemporaneo
   drop constraint pk_pla_extemporaneo  cascade;
alter table pla_extemporaneo
   add constraint pk_pla_extemporaneo primary key (codigo_empleado, compania, tipodhora, fecha);

alter table pla_fdc_desde_hasta
   drop constraint pk_pla_fdc_desde_hasta  cascade;
alter table pla_fdc_desde_hasta
   add constraint pk_pla_fdc_desde_hasta primary key (desde, hasta);

alter table pla_fondo_de_cesantia
   drop constraint pk_pla_fondo_de_cesantia  cascade;
alter table pla_fondo_de_cesantia
   add constraint pk_pla_fondo_de_cesantia primary key (codigo_empleado, compania, desde, hasta);

alter table pla_historial_descuentos
   drop constraint pk_pla_historial_descuentos  cascade;
alter table pla_historial_descuentos
   add constraint pk_pla_historial_descuentos primary key (codigo_empleado, compania, cod_acreedores, fecha);

alter table pla_historial_pagos
   drop constraint pk_pla_historial_pagos  cascade;
alter table pla_historial_pagos
   add constraint pk_pla_historial_pagos primary key (cod_concepto_planilla, fecha, codigo_empleado, compania);

alter table pla_indemnizacion
   drop constraint pk_pla_indemnizacion  cascade;
alter table pla_indemnizacion
   add constraint pk_pla_indemnizacion primary key (anio, secuencia);

alter table pla_indemnizaciones
   drop constraint pk_pla_indemnizaciones  cascade;
alter table pla_indemnizaciones
   add constraint pk_pla_indemnizaciones primary key (usuario, compania, codigo_empleado, fecha_corte);

alter table pla_informe
   drop constraint pk_pla_informe  cascade;
alter table pla_informe
   add constraint pk_pla_informe primary key (codigo_empleado, compania, usuario, tipo_de_columna, fecha);

alter table pla_informe_nomdedu
   drop constraint pk_pla_informe_nomdedu  cascade;
alter table pla_informe_nomdedu
   add constraint pk_pla_informe_nomdedu primary key (numero_documento, codigo_empleado, cod_concepto_planilla, compania, periodo, usuario, nombre_acreedor);

alter table pla_ingresos_deducciones
   drop constraint pk_pla_ingresos_deducciones  cascade;
alter table pla_ingresos_deducciones
   add constraint pk_pla_ingresos_deducciones primary key (compania, codigo_empleado, cod_concepto_planilla, descripcion, monto, ahorro, usuario);

alter table pla_otros_ingresos_fijos
   drop constraint pk_pla_otros_ingresos_fijos  cascade;
alter table pla_otros_ingresos_fijos
   add constraint pk_pla_otros_ingresos_fijos primary key (codigo_empleado, compania, cod_concepto_planilla, periodo);

alter table pla_planilla_semanal
   drop constraint pk_pla_planilla_semanal  cascade;
alter table pla_planilla_semanal
   add constraint pk_pla_planilla_semanal primary key (usuario, codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento, concepto);

alter table pla_preelaborada
   drop constraint pk_pla_preelaborada  cascade;
alter table pla_preelaborada
   add constraint pk_pla_preelaborada primary key (cod_concepto_planilla, codigo_empleado, compania, fecha);

alter table pla_rela_horas_conceptos
   drop constraint pk_pla_rela_horas_conceptos  cascade;
alter table pla_rela_horas_conceptos
   add constraint pk_pla_rela_horas_conceptos primary key (tipodhora);

alter table pla_reloj
   drop constraint pk_pla_reloj  cascade;
alter table pla_reloj
   add constraint pk_pla_reloj primary key (codigo_empleado, compania, fecha, hora);

alter table pla_reservas
   drop constraint pk_pla_reservas  cascade;
alter table pla_reservas
   add constraint pk_pla_reservas primary key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento, concepto_reserva);

alter table pla_resumen_planilla
   drop constraint pk_pla_resumen_planilla  cascade;
alter table pla_resumen_planilla
   add constraint pk_pla_resumen_planilla primary key (usuario, codigo_empleado, compania, no_cheque, tipo_calculo);

alter table pla_riesgos_profesionales
   drop constraint pk_pla_riesgos_profesionales  cascade;
alter table pla_riesgos_profesionales
   add constraint pk_pla_riesgos_profesionales primary key (codigo_empleado, compania, desde, hasta);

alter table pla_saldo_acreedores
   drop constraint pk_pla_saldo_acreedores  cascade;
alter table pla_saldo_acreedores
   add constraint pk_pla_saldo_acreedores primary key (codigo_empleado, compania, numero_documento, cod_concepto_planilla, pago, fecha, usuario);

alter table pla_tipo_de_columna
   drop constraint pk_pla_tipo_de_columna  cascade;
alter table pla_tipo_de_columna
   add constraint pk_pla_tipo_de_columna primary key (tipo_de_columna);

alter table pla_vacacion
   drop constraint pk_pla_vacacion  cascade;
alter table pla_vacacion
   add constraint pk_pla_vacacion primary key (codigo_empleado, compania, f_corte, pagar_desde, pagar_hasta);

alter table pla_vacacion1
   drop constraint pk_pla_vacacion1  cascade;
alter table pla_vacacion1
   add constraint pk_pla_vacacion1 primary key (codigo_empleado, compania, legal_desde);

alter table pla_vacacion2
   drop constraint pk_pla_vacacion2  cascade;
alter table pla_vacacion2
   add constraint pk_pla_vacacion2 primary key (codigo_empleado, compania, legal_desde, pagar_desde);

alter table pla_vacaciones_x_pagar
   drop constraint pk_pla_vacaciones_x_pagar  cascade;
alter table pla_vacaciones_x_pagar
   add constraint pk_pla_vacaciones_x_pagar primary key (codigo_empleado, compania, usuario, fecha_de_corte);

alter table pla_work1
   drop constraint pk_pla_work1  cascade;
alter table pla_work1
   add constraint pk_pla_work1 primary key (codigo_empleado, compania, fecha);

alter table pla_xiii
   drop constraint pk_pla_xiii  cascade;
alter table pla_xiii
   add constraint pk_pla_xiii primary key (desde_actual, hasta_actual);

alter table placertificadosmedico
   drop constraint pk_placertificadosmedico  cascade;
alter table placertificadosmedico
   add constraint pk_placertificadosmedico primary key (codigo_empleado, compania, fecha);

alter table pladeduccionesadicionales
   drop constraint pk_pladeduccionesadicionales  cascade;
alter table pladeduccionesadicionales
   add constraint pk_pladeduccionesadicionales primary key (codigo_empleado, compania, fecha, tipo);

alter table plapermisos
   drop constraint pk_plapermisos  cascade;
alter table plapermisos
   add constraint pk_plapermisos primary key (codigo_empleado, compania, tipodepermiso, fecha);

alter table plapermisosindical
   drop constraint pk_plapermisosindical  cascade;
alter table plapermisosindical
   add constraint pk_plapermisosindical primary key (codigo_empleado, compania, fecha);

alter table plareemplazos
   drop constraint pk_plareemplazos  cascade;
alter table plareemplazos
   add constraint pk_plareemplazos primary key (codigo_empleado, compania, reemplazo, desde, hasta);

alter table platipodeduccion
   drop constraint pk_platipodeduccion  cascade;
alter table platipodeduccion
   add constraint pk_platipodeduccion primary key (tipo);

alter table platipodepermiso
   drop constraint pk_platipodepermiso  cascade;
alter table platipodepermiso
   add constraint pk_platipodepermiso primary key (tipodepermiso);

alter table porcentaje_manejo
   drop constraint pk_porcentaje_manejo  cascade;
alter table porcentaje_manejo
   add constraint pk_porcentaje_manejo primary key (cliente);

alter table precios_por_cliente_1
   drop constraint pk_precios_por_cliente_1  cascade;
alter table precios_por_cliente_1
   add constraint pk_precios_por_cliente_1 primary key (secuencia);

alter table precios_por_cliente_2
   drop constraint pk_precios_por_cliente_2  cascade;
alter table precios_por_cliente_2
   add constraint pk_precios_por_cliente_2 primary key (secuencia, articulo, almacen);

alter table preventas
   drop constraint pk_preventas  cascade;
alter table preventas
   add constraint pk_preventas primary key (articulo, almacen, cliente, compania, aplicacion, year, periodo);

alter table productos_sustitutos
   drop constraint pk_productos_sustitutos  cascade;
alter table productos_sustitutos
   add constraint pk_productos_sustitutos primary key (articulo, sustituto);

alter table proveedores
   drop constraint pk_proveedores  cascade;
alter table proveedores
   add constraint pk_proveedores primary key (proveedor);

alter table proveedores_agrupados
   drop constraint pk_proveedores_agrupados  cascade;
alter table proveedores_agrupados
   add constraint pk_proveedores_agrupados primary key (proveedor, codigo_valor_grupo);

alter table rela_activos_cglposteo
   drop constraint pk_rela_activos_cglposteo  cascade;
alter table rela_activos_cglposteo
   add constraint pk_rela_activos_cglposteo primary key (consecutivo, codigo, compania);

alter table rela_adc_master_cglposteo
   drop constraint pk_rela_adc_master_cglposteo  cascade;
alter table rela_adc_master_cglposteo
   add constraint pk_rela_adc_master_cglposteo primary key (compania, consecutivo, linea_master, cgl_consecutivo);

alter table rela_afi_cglposteo
   drop constraint pk_rela_afi_cglposteo  cascade;
alter table rela_afi_cglposteo
   add constraint pk_rela_afi_cglposteo primary key (codigo, compania, aplicacion, year, periodo, consecutivo);

alter table rela_afi_trx1_cglposteo
   drop constraint pk_rela_afi_trx1_cglposteo  cascade;
alter table rela_afi_trx1_cglposteo
   add constraint pk_rela_afi_trx1_cglposteo primary key (consecutivo);

alter table rela_bcocheck1_cglposteo
   drop constraint pk_rela_bcocheck1_cglposteo  cascade;
alter table rela_bcocheck1_cglposteo
   add constraint pk_rela_bcocheck1_cglposteo primary key (cod_ctabco, no_cheque, motivo_bco, consecutivo);

alter table rela_bcotransac1_cglposteo
   drop constraint pk_rela_bcotransac1_cglposteo  cascade;
alter table rela_bcotransac1_cglposteo
   add constraint pk_rela_bcotransac1_cglposteo primary key (cod_ctabco, sec_transacc, consecutivo);

alter table rela_caja_trx1_cglposteo
   drop constraint pk_rela_caja_trx1_cglposteo  cascade;
alter table rela_caja_trx1_cglposteo
   add constraint pk_rela_caja_trx1_cglposteo primary key (consecutivo, numero_trx, caja);

alter table rela_cgl_comprobante1_cglposteo
   drop constraint pk_rela_cgl_comprobante1_cglpo  cascade;
alter table rela_cgl_comprobante1_cglposteo
   add constraint pk_rela_cgl_comprobante1_cglpo primary key (consecutivo, compania, secuencia);

alter table rela_cglcomprobante1_cglposteo
   drop constraint pk_rela_cglcomprobante1_cglpos  cascade;
alter table rela_cglcomprobante1_cglposteo
   add constraint pk_rela_cglcomprobante1_cglpos primary key (secuencia, compania, aplicacion, year, periodo, consecutivo);

alter table rela_cxc_recibo1_cglposteo
   drop constraint pk_rela_cxc_recibo1_cglposteo  cascade;
alter table rela_cxc_recibo1_cglposteo
   add constraint pk_rela_cxc_recibo1_cglposteo primary key (consecutivo, almacen, cxc_consecutivo);

alter table rela_cxcfact1_cglposteo
   drop constraint pk_rela_cxcfact1_cglposteo  cascade;
alter table rela_cxcfact1_cglposteo
   add constraint pk_rela_cxcfact1_cglposteo primary key (consecutivo, almacen, no_factura);

alter table rela_cxctrx1_cglposteo
   drop constraint pk_rela_cxctrx1_cglposteo  cascade;
alter table rela_cxctrx1_cglposteo
   add constraint pk_rela_cxctrx1_cglposteo primary key (consecutivo, sec_ajuste_cxc, almacen);

alter table rela_cxpajuste1_cglposteo
   drop constraint pk_rela_cxpajuste1_cglposteo  cascade;
alter table rela_cxpajuste1_cglposteo
   add constraint pk_rela_cxpajuste1_cglposteo primary key (consecutivo, compania, sec_ajuste_cxp);

alter table rela_cxpfact1_cglposteo
   drop constraint pk_rela_cxpfact1_cglposteo  cascade;
alter table rela_cxpfact1_cglposteo
   add constraint pk_rela_cxpfact1_cglposteo primary key (consecutivo, proveedor, fact_proveedor, compania);

alter table rela_eys1_cglposteo
   drop constraint pk_rela_eys1_cglposteo  cascade;
alter table rela_eys1_cglposteo
   add constraint pk_rela_eys1_cglposteo primary key (consecutivo, almacen, no_transaccion);

alter table rela_factura1_cglposteo
   drop constraint pk_rela_factura1_cglposteo  cascade;
alter table rela_factura1_cglposteo
   add constraint pk_rela_factura1_cglposteo primary key (consecutivo, almacen, tipo, num_documento);

alter table rela_nomctrac_cglposteo
   drop constraint pk_rela_nomctrac_cglposteo  cascade;
alter table rela_nomctrac_cglposteo
   add constraint pk_rela_nomctrac_cglposteo primary key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento, consecutivo);

alter table rela_pla_reservas_cglposteo
   drop constraint pk_rela_pla_reservas_cglposteo  cascade;
alter table rela_pla_reservas_cglposteo
   add constraint pk_rela_pla_reservas_cglposteo primary key (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento, concepto_reserva, consecutivo);

alter table rhu_horas_adicionales
   drop constraint pk_rhu_horas_adicionales  cascade;
alter table rhu_horas_adicionales
   add constraint pk_rhu_horas_adicionales primary key (cod_id_turnos, tipodhora);

comment on table rhuacre is
'Tabla de Acreedores';

alter table rhuacre
   drop constraint pk_rhuacre  cascade;
alter table rhuacre
   add constraint pk_rhuacre primary key (cod_acreedores);

comment on table rhuacre2 is
'Tabla de Acreedores';

alter table rhuacre2
   drop constraint pk_rhuacre2  cascade;
alter table rhuacre2
   add constraint pk_rhuacre2 primary key (cod_acreedores);

comment on table rhucargo is
'CARGO';

alter table rhucargo
   drop constraint pk_rhucargo  cascade;
alter table rhucargo
   add constraint pk_rhucargo primary key (codigo_cargo);

comment on table rhuclvim is
'Clave de Impuesto sobre la renta';

alter table rhuclvim
   drop constraint pk_rhuclvim  cascade;
alter table rhuclvim
   add constraint pk_rhuclvim primary key (grup_impto_renta, num_dependiente);

comment on table rhuempl is
'Empleado';

alter table rhuempl
   drop constraint pk_rhuempl  cascade;
alter table rhuempl
   add constraint pk_rhuempl primary key (codigo_empleado, compania);

comment on table rhugremp is
'agrupacion empleados';

alter table rhugremp
   drop constraint pk_rhugremp  cascade;
alter table rhugremp
   add constraint pk_rhugremp primary key (codigo_empleado, codigo_valor_grupo);

comment on table rhuturno is
'Turnos o jornada de trabajo';

alter table rhuturno
   drop constraint pk_rhuturno  cascade;
alter table rhuturno
   add constraint pk_rhuturno primary key (cod_id_turnos);

alter table rhuturno_x_dia
   drop constraint pk_rhuturno_x_dia  cascade;
alter table rhuturno_x_dia
   add constraint pk_rhuturno_x_dia primary key (cod_id_turnos, codigo_empleado, compania, desde);

alter table rubros_fact_cxc
   drop constraint pk_rubros_fact_cxc  cascade;
alter table rubros_fact_cxc
   add constraint pk_rubros_fact_cxc primary key (rubro_fact_cxc);

alter table rubros_fact_cxp
   drop constraint pk_rubros_fact_cxp  cascade;
alter table rubros_fact_cxp
   add constraint pk_rubros_fact_cxp primary key (rubro_fact_cxp);

alter table saldo_de_proveedores
   drop constraint pk_saldo_de_proveedores  cascade;
alter table saldo_de_proveedores
   add constraint pk_saldo_de_proveedores primary key (proveedor);

alter table secciones
   drop constraint pk_secciones  cascade;
alter table secciones
   add constraint pk_secciones primary key (codigo, seccion);

alter table security_apps
   drop constraint security_apps_pkey  cascade;
alter table security_apps
   add constraint security_apps_pkey primary key (application);

alter table security_controls
   drop constraint pk_security_controls  cascade;
alter table security_controls
   add constraint pk_security_controls primary key (control);

alter table security_groupings
   drop constraint security_groupings_pkey  cascade;
alter table security_groupings
   add constraint security_groupings_pkey primary key (group_name, user_name);

alter table security_info
   drop constraint security_info_pkey  cascade;
alter table security_info
   add constraint security_info_pkey primary key (application, window, control, user_name);

alter table security_template
   drop constraint security_template_pkey  cascade;
alter table security_template
   add constraint security_template_pkey primary key (application, window, control);

alter table security_users
   drop constraint security_users_pkey  cascade;
alter table security_users
   add constraint security_users_pkey primary key (name);

alter table sobre_acumulados
   drop constraint pk_sobre_acumulados  cascade;
alter table sobre_acumulados
   add constraint pk_sobre_acumulados primary key (codigo_empleado, compania, usuario);

alter table sobre_deducciones
   drop constraint pk_sobre_deducciones  cascade;
alter table sobre_deducciones
   add constraint pk_sobre_deducciones primary key (codigo_empleado, compania, causa_1, deduccion_1, saldo_1, usuario, deduccion_2, saldo_2, prioridad_impresion);

alter table sobre_desgloce
   drop constraint pk_sobre_desgloce  cascade;
alter table sobre_desgloce
   add constraint pk_sobre_desgloce primary key (leyenda, desgloce, usuario, codigo_empleado, compania);

alter table sobre_ingresos
   drop constraint pk_sobre_ingresos  cascade;
alter table sobre_ingresos
   add constraint pk_sobre_ingresos primary key (codigo_empleado, compania, tipo_planilla, numero_planilla, year, usuario, concepto_1, horas_1, valor_hora_1, devengado_1, linea, horas_2, valor_hora_2, devengado_2);

alter table sobre_totales
   drop constraint pk_sobre_totales  cascade;
alter table sobre_totales
   add constraint pk_sobre_totales primary key (codigo_empleado, compania, usuario);

alter table status
   drop constraint pk_status  cascade;
alter table status
   add constraint pk_status primary key (tabla, status);

alter table tal_equipo
   drop constraint pk_tal_equipo  cascade;
alter table tal_equipo
   add constraint pk_tal_equipo primary key (codigo, compania);

alter table tal_ot1
   drop constraint pk_tal_ot1  cascade;
alter table tal_ot1
   add constraint pk_tal_ot1 primary key (almacen, no_orden, tipo);

alter table tal_ot2
   drop constraint pk_tal_ot2  cascade;
alter table tal_ot2
   add constraint pk_tal_ot2 primary key (no_orden, tipo, almacen, linea, articulo);

alter table tal_ot2_eys2
   drop constraint pk_tal_ot2_eys2  cascade;
alter table tal_ot2_eys2
   add constraint pk_tal_ot2_eys2 primary key (no_orden, tipo, almacen, linea_tal_ot2, articulo);

alter table tal_ot3
   drop constraint pk_tal_ot3  cascade;
alter table tal_ot3
   add constraint pk_tal_ot3 primary key (almacen, no_orden, tipo, linea);

alter table tal_precios_x_cliente
   drop constraint pk_tal_precios_x_cliente  cascade;
alter table tal_precios_x_cliente
   add constraint pk_tal_precios_x_cliente primary key (cliente);

alter table tal_servicios
   drop constraint pk_tal_servicios  cascade;
alter table tal_servicios
   add constraint pk_tal_servicios primary key (servicio);

alter table tal_temp
   drop constraint pk_tal_temp  cascade;
alter table tal_temp
   add constraint pk_tal_temp primary key (no_orden, tipo, almacen, linea, articulo, usuario);

alter table tarifas
   drop constraint pk_tarifas  cascade;
alter table tarifas
   add constraint pk_tarifas primary key (almacen, de, a);

comment on table tipo_de_empresa is
'Tipo de Empresa';

alter table tipo_de_empresa
   drop constraint pk_tipo_de_empresa  cascade;
alter table tipo_de_empresa
   add constraint pk_tipo_de_empresa primary key (tipo_empresa);

alter table tipo_transacc
   drop constraint pk_tipo_transacc  cascade;
alter table tipo_transacc
   add constraint pk_tipo_transacc primary key (aplicacion, tipo_transacc);

alter table tipoauto
   drop constraint pk_tipoauto  cascade;
alter table tipoauto
   add constraint pk_tipoauto primary key (tipo_autorizacion);

alter table tipoauto3
   drop constraint pk_tipoauto3  cascade;
alter table tipoauto3
   add constraint pk_tipoauto3 primary key (tipo_autorizacion);

alter table tipocont
   drop constraint pk_tipocont  cascade;
alter table tipocont
   add constraint pk_tipocont primary key (tipo_contenedor);

alter table tipos_seguros
   drop constraint pk_tipos_seguros  cascade;
alter table tipos_seguros
   add constraint pk_tipos_seguros primary key (tipo_seguro);

alter table trabajo
   drop constraint pk_trabajo  cascade;
alter table trabajo
   add constraint pk_trabajo primary key (usuario, codigo);

alter table trabajo2
   drop constraint pk_trabajo2  cascade;
alter table trabajo2
   add constraint pk_trabajo2 primary key (usuario, numero);

alter table unidad_medida
   drop constraint pk_unidad_medida  cascade;
alter table unidad_medida
   add constraint pk_unidad_medida primary key (unidad_medida);

alter table vendedores
   drop constraint pk_vendedores  cascade;
alter table vendedores
   add constraint pk_vendedores primary key (codigo);

alter table vtahist1
   drop constraint pk_vtahist1  cascade;
alter table vtahist1
   add constraint pk_vtahist1 primary key (factura);


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
      