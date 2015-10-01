
--set search_path to dba;


rollback work;


drop view cgl_cglposteo;
drop view cgl_saldo_aux1;
drop view cxc_cxcfact1;
drop view cxc_hijos;
drop view cxc_madres;
drop view cxp_ajustes_madres;
drop view eys1_eys2_agrupado;
drop view f_conytram_resumen;
drop view fac_facturas;
drop view fac_facturas_cxc;
drop view fac_notas_credito;
drop view fact_despachos;
drop view fact_totales;
drop view fact_ventas;
drop view inv_ventas;
drop view v_bcocircula;
drop view v_cgl_financiero;
drop view v_cgl_presupuesto;
drop view v_cos_traspasos;
drop view v_cxc_resumen_x_dia;
drop view v_cxp_ajustes_hijos;
drop view v_cxp_ajustes_madres;
drop view v_cxp_facturas;
drop view v_cxp_pagos;
drop view v_div_socios;
drop view v_eys1_eys2 cascade;
drop view v_eys1_eys2_x_clase;
drop view v_eys1_eys2_x_mes;
drop view v_eys1_eys2_x_subtipo;
drop view v_eys1_eys2_x_tipo;
drop view v_fact_costos;
drop view v_fact_ventas;
drop view v_fact_ventas_x_clase;
drop view v_fact_ventas_x_clase_detalladas;
drop view v_fact_vtas_detalladas;
drop view v_factura1_factura2;
drop view v_hp_barcos;
drop view v_nomctrac_x_cuenta;
drop view v_nomhoras;
drop view v_oc1_oc2;
drop view v_pla_horas_valorizadas;
drop view v_pla_horas_valorizadas_x_dia;
drop view v_cxc_recibos_madres;
drop view v_cxc_recibos_hijos;
drop view v_cxc_resumen_x_mes;
drop view v_stock;
drop view v_estado_d_resultado;
drop view v_nomctrac_neto;
drop view v_tal_ot2_ot3;
drop view v_pla_acumulados;
drop view v_cxc_empleados_detalle;
drop view v_cxc_empleados_saldos;
drop view v_comprobante_de_pago;
drop view v_pla_historial;
drop view v_pla_reservas_x_departamento;
drop view v_f_conytram;
drop view v_cglsldoaux1;
drop view v_cglposteo;
drop view v_cgl_financiero_x_cuenta;
drop view v_cxpdocm;
drop view v_cxcdocm_cxc;
drop view v_cxcdocm_fac;
drop view v_factura1_cglposteo;
drop view v_afi_trx_cglposteo;
drop view v_eys1_cglposteo;
drop view v_cxpfact1_cglposteo;
drop view v_cgl_financiero_cglsldocuenta;
drop view v_kardex;
drop view v_factura_cglposteo;
drop view v_fac_resumen_z;
drop view v_fact_costos_x_grupo;
drop view v_fac_totales;
drop view v_ventas_x_mes;
drop view v_dividendos_e_intereses;
drop view v_produccion;
drop view v_consumo_trigo;
drop view v_consumo;
drop view v_list_cobros_airsea;
drop view v_ventas_costos;
drop view v_ventas_x_cliente_harinas;
drop view v_fact_ventas_harinas;
drop view v_fact_ventas_harinas_by_date;
drop view v_ventas_x_mes_harinas;
drop view v_cxcdocm_cxchdocm;
drop view v_fac_declaracion_impuestos;
drop view v_cxp_facturas_por_rubros;
drop view v_cxp_declaracion_impuestos;
drop view v_factura1_factura2_x_tdi;
drop view v_cxc_recibos;
drop view v_formulario_43_dgi;
drop view v_cgl_financiero_x_cuenta_detallado;
drop view v_pla_salario_neto;
drop view v_apc_clientes;
drop view v_apc_refere;
drop view v_factura1_factura2_x_cat;
drop view v_cglposteo_detalle_excel;
drop view v_cos_produccion;
drop view v_comprobante_inventario cascade;
drop view v_cxcdocm_fac_fiscal cascade;
drop view v_cgl_presupuesto_detallado;
drop view v_mov_inv_x_sdi cascade;
drop view v_formulario_72_dgi cascade;
drop view v_cglsldoaux2 cascade;
drop view v_cheques;
drop view v_ventas_x_categoria;
drop view v_costos_x_categoria;
drop view v_estado_d_balance;


create view v_estado_d_balance as
select c.compania, c.year, c.periodo, b.cuenta, b.nombre, 
(c.debito-c.credito) as corriente, (c.balance_inicio+c.debito-c.credito) as acumulado
from cglniveles a, cglcuentas b, cglsldocuenta c
where a.nivel = b.nivel
and b.cuenta = c.cuenta
and b.tipo_cuenta = 'B'
and a.recibe = 'S';


create view v_costos_x_categoria as
select almacen.compania, eys1.almacen, eys1.no_transaccion,
invmotivos.desc_motivo as d_motivo,
Anio(eys1.fecha) as anio,
Mes(eys1.fecha) as mes, 
eys1.fecha as fecha,
eys2.articulo, 
articulos.desc_articulo,
gralcompanias.nombre as nombre_de_cia,
trim(gral_valor_grupos.codigo_valor_grupo) as categoria,
trim(gral_valor_grupos.desc_valor_grupo) as d_categoria,
(eys2.cantidad * invmotivos.signo) as cantidad,
(eys2.costo * invmotivos.signo) as costo
from almacen, eys1, eys2, invmotivos, articulos, gralcompanias, articulos_agrupados, gral_valor_grupos
where eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.almacen = almacen.almacen
and eys1.motivo = invmotivos.motivo
and eys2.articulo = articulos.articulo
and almacen.compania = gralcompanias.compania
and articulos_agrupados.articulo = eys2.articulo
and gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and eys1.fecha >= '2014-01-01'
and eys1.aplicacion_origen <> 'COM'
and gral_valor_grupos.grupo = 'CAT'
and gral_valor_grupos.aplicacion = 'INV';




create view v_ventas_x_categoria as
select almacen.compania,
factura1.almacen, 
factura1.caja,
factura1.tipo as tipo,
factura1.num_documento,
factura1.cajero, 
factmotivos.descripcion as d_tipo,
factura1.cliente, 
trim(factura1.nombre_cliente) as nombre_cliente, 
factura1.forma_pago,
vendedores.nombre as nombre_del_vendedor,
factura1.codigo_vendedor, almacen.desc_almacen,
Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes, 
factura1.fecha_factura as fecha,
factura2.articulo, articulos.desc_articulo,
gralcompanias.nombre as nombre_de_cia,
gral_valor_grupos.codigo_valor_grupo as codigo_categoria,
trim(gral_valor_grupos.desc_valor_grupo) as categoria,
articulos.orden_impresion,
(factura2.cantidad * factmotivos.signo) as cantidad,
(((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) as venta
from almacen, factura1, factura2, factmotivos, clientes, articulos, vendedores, 
gralcompanias, articulos_agrupados, gral_valor_grupos, gral_forma_de_pago
where factura1.forma_pago = gral_forma_de_pago.forma_pago
and almacen.compania = gralcompanias.compania
and factura1.codigo_vendedor = vendedores.codigo
and articulos_agrupados.articulo = articulos.articulo
and gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and almacen.almacen = factura1.almacen
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura1.tipo = factmotivos.tipo
and factura1.tipo <> 'DA'
and factura1.cliente = clientes.cliente
and factura2.articulo = articulos.articulo
and gral_valor_grupos.grupo = 'CAT'
and gral_valor_grupos.aplicacion = 'INV'
and factura1.status <> 'A'
and factura1.fecha_factura >= '2014-01-01'
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' 
or factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S');



create view v_cheques as
select bcoctas.compania, trim(bcoctas.desc_ctabco) as cuenta, 
Anio(bcocheck1.fecha_cheque) as anio,
Mes(bcocheck1.fecha_cheque) as mes, 
Extract(week from bcocheck1.fecha_cheque) as semana,
bcocheck1.fecha_cheque, 
bcocheck1.no_cheque, 
bcocheck1.paguese_a, 
bcocheck1.en_concepto_de,
(case when bcocheck1.status = 'A' then 0 else bcocheck1.monto end) as monto
from bcoctas, bcocheck1, bcomotivos
where bcoctas.cod_ctabco = bcocheck1.cod_ctabco
and bcocheck1.motivo_bco = bcomotivos.motivo_bco
and bcomotivos.aplica_cheques = 'S';



create view v_cxcdocm_cxc as
select cxc_recibo1.almacen, cxc_recibo1.caja, cxc_recibo1.cliente, cxc_recibo1.documento, cxc_recibo1.documento as docmto_aplicar,
cxc_recibo1.motivo_cxc, cxc_recibo1.documento as docmto_ref, cxc_recibo1.motivo_cxc as motivo_ref, cxc_recibo1.fecha as fecha_posteo,
cxc_recibo1.fecha as fecha_docmto, cxc_recibo1.fecha as fecha_vmto, cxc_recibo1.observacion as obs_docmto, cxc_recibo1.referencia, 'CXC' as aplicacion_origen,
(cxc_recibo1.efectivo + cxc_recibo1.cheque + cxc_recibo1.otro) as monto
from cxc_recibo1, cxc_recibo3, clientes, cglcuentas
where cxc_recibo1.almacen = cxc_recibo3.almacen
and cxc_recibo1.cliente = clientes.cliente
and clientes.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'B'
and cglcuentas.naturaleza = 1
and cxc_recibo1.consecutivo = cxc_recibo3.consecutivo
and cxc_recibo1.status <> 'A'
and not exists 
(select * from cxc_recibo2
where cxc_recibo2.almacen = cxc_recibo1.almacen
and cxc_recibo2.caja = cxc_recibo1.caja
and cxc_recibo2.consecutivo = cxc_recibo1.consecutivo
and cxc_recibo2.monto_aplicar <> 0)
union
select cxc_recibo2.almacen_aplicar, cxc_recibo2.caja_aplicar, cxc_recibo1.cliente, cxc_recibo1.documento, cxc_recibo2.documento_aplicar,
cxc_recibo1.motivo_cxc, cxc_recibo2.documento_aplicar, cxc_recibo2.motivo_aplicar, cxc_recibo1.fecha,
cxc_recibo1.fecha, cxc_recibo1.fecha, cxc_recibo1.observacion, cxc_recibo1.referencia, 'CXC', 
cxc_recibo2.monto_aplicar
from cxc_recibo1, cxc_recibo2, clientes, cglcuentas
where cxc_recibo1.almacen = cxc_recibo2.almacen
and cxc_recibo1.cliente = clientes.cliente
and clientes.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'B'
and cglcuentas.naturaleza = 1
and cxc_recibo1.consecutivo = cxc_recibo2.consecutivo
and cxc_recibo2.monto_aplicar <> 0
and cxc_recibo1.status <> 'A'
and exists
    (select * from cxcdocm
    where cxcdocm.almacen = cxc_recibo2.almacen_aplicar
    and cxcdocm.cliente = cxc_recibo1.cliente
    and cxcdocm.documento = cxc_recibo2.documento_aplicar
    and cxcdocm.caja = cxc_recibo2.caja_aplicar
    and cxcdocm.docmto_aplicar = cxc_recibo2.documento_aplicar
    and cxcdocm.motivo_cxc = cxc_recibo2.motivo_aplicar)
union    
select almacen, 
f_caja_default(cxc_saldos_iniciales.almacen),
cliente, documento, documento, motivo_cxc, documento, motivo_cxc,
fecha, fecha, fecha, null, null, 'CXC', 
monto
from cxc_saldos_iniciales
union
select cxcfact1.almacen, 
(select caja from fac_cajas 
where fac_cajas.almacen = cxcfact1.almacen and status = 'A'),
cxcfact1.cliente, cxcfact1.no_factura,
cxcfact1.no_factura, cxcfact1.motivo_cxc, cxcfact1.no_factura, cxcfact1.motivo_cxc,
cxcfact1.fecha_posteo_fact, cxcfact1.fecha_posteo_fact, cxcfact1.fecha_vence_fact,
trim(cxcfact1.obs_fact), null, 'CXC', 
-sum(cxcfact2.monto * rubros_fact_cxc.signo_rubro_fact_cxc)
from cxcfact1, cxcfact2, rubros_fact_cxc 
where cxcfact1.almacen = cxcfact2.almacen
and cxcfact1.no_factura = cxcfact2.no_factura
and cxcfact2.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
group by cxcfact1.aplicacion, 2, cxcfact1.almacen, cxcfact1.cliente, cxcfact1.no_factura, 
cxcfact1.motivo_cxc, cxcfact1.fecha_posteo_fact, cxcfact1.fecha_vence_fact,
cxcfact1.obs_fact
union
select cxctrx1.almacen, cxctrx1.caja, cxctrx1.cliente, 
cxctrx1.docm_ajuste_cxc, cxctrx1.docm_ajuste_cxc, cxctrx1.motivo_cxc, 
cxctrx1.docm_ajuste_cxc, cxctrx1.motivo_cxc,
cxctrx1.fecha_posteo_ajuste_cxc, cxctrx1.fecha_posteo_ajuste_cxc,
cxctrx1.fecha_posteo_ajuste_cxc, trim(cxctrx1.obs_ajuste_cxc), 
trim(cxctrx1.referencia), 'CXC',
sum(cxctrx1.cheque + cxctrx1.efectivo)
from cxctrx1, clientes, cglcuentas
where cxctrx1.cliente = clientes.cliente
and clientes.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'B'
and cglcuentas.naturaleza = 1
and not exists
(select * from cxctrx2
where cxctrx2.almacen = cxctrx1.almacen
and cxctrx2.sec_ajuste_cxc = cxctrx1.sec_ajuste_cxc
and cxctrx2.caja = cxctrx1.caja
and cxctrx2.monto <> 0)
group by cxctrx1.almacen, cxctrx1.caja, cxctrx1.cliente, cxctrx1.docm_ajuste_cxc, 
cxctrx1.motivo_cxc, cxctrx1.fecha_posteo_ajuste_cxc, cxctrx1.referencia, cxctrx1.obs_ajuste_cxc
union
select cxctrx1.almacen, cxctrx2.caja_aplicar, cxctrx1.cliente, 
cxctrx1.docm_ajuste_cxc, cxctrx2.aplicar_a, cxctrx1.motivo_cxc, 
cxctrx2.aplicar_a, cxctrx2.motivo_cxc,
cxctrx1.fecha_posteo_ajuste_cxc, cxctrx1.fecha_posteo_ajuste_cxc,
cxctrx1.fecha_posteo_ajuste_cxc, 
trim(cxctrx1.obs_ajuste_cxc), trim(cxctrx1.referencia),
'CXC', 
sum(cxctrx2.monto)
from cxctrx1, cxctrx2, cxcdocm, clientes, cglcuentas
where cxctrx1.sec_ajuste_cxc = cxctrx2.sec_ajuste_cxc
and cxctrx1.caja = cxctrx2.caja
and cxctrx1.cliente = clientes.cliente
and clientes.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'B'
and cglcuentas.naturaleza = 1
and cxctrx1.almacen = cxctrx2.almacen
and cxcdocm.almacen = cxctrx2.almacen
and cxcdocm.cliente = cxctrx1.cliente
and cxcdocm.documento = cxctrx2.aplicar_a
and cxcdocm.docmto_aplicar = cxctrx2.aplicar_a
and cxcdocm.caja = cxctrx2.caja_aplicar
and cxcdocm.motivo_cxc = cxctrx2.motivo_cxc
and cxctrx2.monto <> 0
group by cxctrx1.almacen, cxctrx1.caja, cxctrx2.caja_aplicar, cxctrx1.cliente, cxctrx1.docm_ajuste_cxc, cxctrx2.aplicar_a, 
cxctrx1.motivo_cxc, cxctrx2.motivo_cxc, cxctrx1.fecha_posteo_ajuste_cxc,
cxctrx1.obs_ajuste_cxc, cxctrx1.referencia
union
select adc_cxc_1.almacen, 
f_caja_default(adc_cxc_1.almacen),
adc_manifiesto.from_agent, trim(adc_cxc_1.documento),
trim(adc_cxc_1.documento), trim(adc_cxc_1.motivo_cxc),
trim(adc_cxc_1.documento), trim(adc_cxc_1.motivo_cxc),
adc_cxc_1.fecha, adc_cxc_1.fecha, adc_cxc_1.fecha, trim(adc_cxc_1.observacion),
trim(adc_manifiesto.no_referencia), 'CXC', 
adc_cxc_1.monto
from adc_cxc_1, adc_manifiesto, fact_referencias
where adc_cxc_1.compania = adc_manifiesto.compania
and adc_cxc_1.consecutivo = adc_manifiesto.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
and fact_referencias.tipo = 'I'
and adc_cxc_1.cliente is null
union
select adc_cxc_1.almacen, 
f_caja_default(adc_cxc_1.almacen),
adc_manifiesto.to_agent, trim(adc_cxc_1.documento),
trim(adc_cxc_1.documento), trim(adc_cxc_1.motivo_cxc),
trim(adc_cxc_1.documento), trim(adc_cxc_1.motivo_cxc),
adc_cxc_1.fecha, adc_cxc_1.fecha, adc_cxc_1.fecha, trim(adc_cxc_1.observacion),
trim(adc_manifiesto.no_referencia), 'CXC', 
adc_cxc_1.monto
from adc_cxc_1, adc_manifiesto, fact_referencias
where adc_cxc_1.compania = adc_manifiesto.compania
and adc_cxc_1.consecutivo = adc_manifiesto.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
and fact_referencias.tipo <> 'I'
and adc_cxc_1.cliente is null
union
select adc_cxc_1.almacen, 
f_caja_default(adc_cxc_1.almacen),
adc_cxc_1.cliente, trim(adc_cxc_1.documento),
trim(adc_cxc_1.documento), trim(adc_cxc_1.motivo_cxc),
trim(adc_cxc_1.documento), trim(adc_cxc_1.motivo_cxc),
adc_cxc_1.fecha, adc_cxc_1.fecha, adc_cxc_1.fecha, trim(adc_cxc_1.observacion),
trim(adc_manifiesto.no_referencia), 'CXC', 
adc_cxc_1.monto
from adc_cxc_1, adc_manifiesto, fact_referencias
where adc_cxc_1.compania = adc_manifiesto.compania
and adc_cxc_1.consecutivo = adc_manifiesto.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_cxc_1.cliente is not null;




create view v_ventas_x_cliente_harinas as
select gralcompanias.nombre, almacen.compania, 
factura1.fecha_factura, 
Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes, 
Extract(week from factura1.fecha_factura) as semana,
factura1.almacen,
(select trim(gral_valor_grupos.desc_valor_grupo)
from gral_valor_grupos, articulos_agrupados
where gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and gral_valor_grupos.grupo = 'CLA'
and gral_valor_grupos.aplicacion = 'INV'
and articulos_agrupados.articulo = articulos.articulo) as descripcion,
(select trim(gral_valor_grupos.desc_valor_grupo) 
from gral_valor_grupos, clientes_agrupados
where gral_valor_grupos.codigo_valor_grupo = clientes_agrupados.codigo_valor_grupo
and gral_valor_grupos.grupo = 'CAT'
and gral_valor_grupos.aplicacion = 'CXC'
and clientes_agrupados.cliente = clientes.cliente) as categoria_cliente,
factura1.cliente, clientes.nomb_cliente, 
factura1.tipo, 
trim(factmotivos.descripcion) as tipo_de_documento,
articulos.orden_impresion, 
clientes.vendedor as vendedor, 
Trim(vendedores.nombre) as nombre_vendedor,
factura1.forma_pago, factura1.num_documento, factura2.linea,
factura2.articulo, articulos.desc_articulo,
(factura2.cantidad*factmotivos.signo) as cantidad,
(factmotivos.signo*factura2.cantidad*convmedi.factor) as quintales,
(case when factmotivos.promocion = 'S' then 0 else (factmotivos.signo*factura2.precio*factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global end) as venta
from factura1, factura2, clientes, articulos, convmedi,
        factmotivos, almacen, gralcompanias, vendedores
where vendedores.codigo = clientes.vendedor
and almacen.compania = gralcompanias.compania
and articulos.unidad_medida = convmedi.old_unidad
and convmedi.new_unidad = '100LBS'
and factura1.almacen = almacen.almacen
and clientes.cliente = factura1.cliente
and factmotivos.tipo = factura1.tipo
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' or factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S'
or factmotivos.promocion = 'S')
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura2.articulo = articulos.articulo
and articulos.servicio = 'N'
and factura1.status <> 'A';


create view v_ventas_x_mes_harinas as
select Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes, 
gral_valor_grupos.desc_valor_grupo as descripcion, 
factura2.articulo, 
sum(factmotivos.signo*factura2.cantidad) as cantidad,
sum(factmotivos.signo*factura2.cantidad*convmedi.factor) as quintales,
sum(factmotivos.signo*((factura2.precio*factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global)) as venta
from articulos, convmedi, factura1, factura2,
articulos_agrupados, gral_valor_grupos, factmotivos
where gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and factmotivos.tipo = factura1.tipo
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' or factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S')
and gral_valor_grupos.grupo = 'CLA'
and gral_valor_grupos.aplicacion = 'INV'
and articulos_agrupados.articulo = articulos.articulo
and articulos.unidad_medida = convmedi.old_unidad
and convmedi.new_unidad = '100LBS'
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.num_documento = factura2.num_documento
and factura1.caja = factura2.caja
and factura2.articulo = articulos.articulo
and factura1.status <> 'A'
group by 1, 2, 3, 4
union
select Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes, gral_valor_grupos.desc_valor_grupo as descripcion, 
factura2.articulo, 
sum(factmotivos.signo*factura2.cantidad) as cantidad,
sum(factmotivos.signo*factura2.cantidad*convmedi.factor) as quintales, 0
from articulos, convmedi, factura1, factura2,
articulos_agrupados, gral_valor_grupos, factmotivos
where gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and factmotivos.tipo = factura1.tipo
and factmotivos.promocion = 'S'
and gral_valor_grupos.grupo = 'CLA'
and gral_valor_grupos.aplicacion = 'INV'
and articulos_agrupados.articulo = articulos.articulo
and articulos.unidad_medida = convmedi.old_unidad
and convmedi.new_unidad = '100LBS'
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura2.articulo = articulos.articulo
and factura1.status <> 'A'
group by 1, 2, 3, 4;




create view v_cglsldoaux2 as
select cglposteo.compania, cglposteo.cuenta, 
cglposteoaux2.auxiliar, 
cglposteo.year, cglposteo.periodo, 
sum(cglposteoaux2.debito) as debito, 
sum(cglposteoaux2.credito) as credito
from cglposteo, cglposteoaux2
where cglposteo.consecutivo = cglposteoaux2.consecutivo
and (cglposteoaux2.debito <> 0 or cglposteoaux2.credito <> 0)
group by 1, 2, 3, 4, 5;


create view v_formulario_72_dgi as
select cglposteo.compania, 
cglposteo.fecha_comprobante, 
trim(cglposteo.cuenta) as cuenta,
f_cglposteo(consecutivo, 'TIPO_DE_PERSONA') as tipo_de_persona, 
f_cglposteo(consecutivo, 'RUC') as ruc, 
f_cglposteo(consecutivo, 'DV') as dv, 
f_cglposteo(consecutivo, 'NOMBRE') as nombre, 
(debito-credito) as monto
from cglposteo, cglcuentas
where cglposteo.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'R'
and fecha_comprobante >= '2012-01-01'
and periodo <> 13
order by fecha_comprobante, cuenta;


create view v_fact_ventas_harinas as
select factura2.linea, almacen.compania, almacen.almacen, factura1.num_documento,
        factura1.codigo_vendedor as vendedor, factura1.cliente, factura1.nombre_cliente, factura1.fecha_factura,
        anio(factura1.fecha_factura) as anio, mes(factura1.fecha_factura) as mes, 
        factura1.forma_pago, factura2.articulo, 
        f_desglose_factura_x_linea(factura2.almacen, factura2.tipo, factura2.num_documento, factura2.caja, factura2.linea, 'VENTA_NETA') as venta,
        f_desglose_factura_x_linea(factura2.almacen, factura2.tipo, factura2.num_documento, factura2.caja, factura2.linea, '100LBS') as cantidad
FROM almacen, factmotivos, factura1, factura2, articulos
WHERE almacen.almacen = factura1.almacen
and factura1.tipo = factmotivos.tipo
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.num_documento = factura2.num_documento
and factura1.caja = factura2.caja
and factura2.articulo = articulos.articulo
and articulos.servicio = 'N'
and factura1.status <> 'A'
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' 
or factmotivos.devolucion = 'S' 
or factmotivos.nota_credito = 'S'
or factmotivos.promocion = 'S');




/*
create view v_ventas_x_cliente_harinas as
select gralcompanias.nombre, almacen.compania, factura1.fecha_factura, Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes, factura1.almacen, gral_valor_grupos.desc_valor_grupo as descripcion,
factura1.cliente, clientes.nomb_cliente, factura1.tipo, articulos.orden_impresion, 
factura1.codigo_vendedor as vendedor, 
Trim(vendedores.nombre) as nombre_vendedor,
factura1.forma_pago, factura1.num_documento, factura2.linea,
factura2.articulo, articulos.desc_articulo,
(factura2.cantidad*factmotivos.signo) as cantidad,
f_desglose_factura_x_linea(factura2.almacen, factura2.tipo, factura2.num_documento, factura2.caja, factura2.linea, '100LBS') as quintales,
f_desglose_factura_x_linea(factura2.almacen, factura2.tipo, factura2.num_documento, factura2.caja, factura2.linea, 'VENTA_NETA') as venta
from factura1, factura2, clientes, articulos_agrupados, articulos,
        gral_valor_grupos, factmotivos, almacen, gralcompanias, vendedores
where vendedores.codigo = clientes.vendedor
and almacen.compania = gralcompanias.compania
and factura1.almacen = almacen.almacen
and clientes.cliente = factura1.cliente
and gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and factmotivos.tipo = factura1.tipo
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' or factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S'
or factmotivos.promocion = 'S')
and gral_valor_grupos.grupo = 'CLA'
and gral_valor_grupos.aplicacion = 'INV'
and articulos_agrupados.articulo = articulos.articulo
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura2.articulo = articulos.articulo
and factura1.status <> 'A';
*/


create view v_mov_inv_x_sdi as
select Anio(eys1.fecha) as anio, Mes(eys1.fecha) as mes, 
invmotivos.desc_motivo,
Trim(eys2.articulo) as articulo, 
Trim(articulos.desc_articulo) as desc_articulo, gral_valor_grupos.desc_valor_grupo,
sum(eys2.cantidad*invmotivos.signo) as cantidad, 
(case when sum(eys2.cantidad) = 0 then 0 else (sum(eys2.costo)/sum(eys2.cantidad)) end) as cu,
sum(eys2.costo) as costo
from eys1, eys2, invmotivos, articulos, articulos_agrupados, gral_valor_grupos
where articulos_agrupados.articulo = articulos.articulo
and articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and gral_valor_grupos.grupo = 'SDI'
and eys2.articulo = articulos.articulo
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys1.fecha >= '2009-01-01'
group by 1, 2, 3, 4, 5, 6
order by 1, 2, 3;


create view v_cgl_presupuesto_detallado as
SELECT cgl_presupuesto.compania, 
cgl_presupuesto.cuenta, cglcuentas.nombre,   
cgl_presupuesto.anio, cgl_presupuesto.mes, 
-(cgl_presupuesto.monto * cglcuentas.naturaleza) as monto
FROM cgl_presupuesto, cglcuentas
WHERE cgl_presupuesto.cuenta = cglcuentas.cuenta;


create view v_comprobante_inventario as
select gralcompanias.compania, trim(gralcompanias.nombre) as nombre_cia, eys1.almacen, 
eys1.no_transaccion, articulos_por_almacen.cuenta, cglcuentas.nombre as nombre_cuenta,
trim(articulos.desc_articulo) as desc_articulo, trim(articulos.articulo) as articulo, 
invmotivos.motivo, invmotivos.desc_motivo,
(invmotivos.signo*eys2.cantidad) as cantidad, (invmotivos.signo*eys2.costo) as monto,
Sign(invmotivos.signo*eys2.costo) as signo
from eys1, eys2, almacen, articulos, gralcompanias, invmotivos, articulos_por_almacen,
cglcuentas
where eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.almacen = almacen.almacen
and almacen.compania = gralcompanias.compania
and eys2.articulo = articulos.articulo
and eys1.motivo = invmotivos.motivo
and articulos_por_almacen.almacen = eys2.almacen
and articulos_por_almacen.articulo = eys2.articulo
and articulos_por_almacen.cuenta = cglcuentas.cuenta
union
select gralcompanias.compania, trim(gralcompanias.nombre), eys1.almacen, 
eys1.no_transaccion, eys3.cuenta, cglcuentas.nombre as nombre_cuenta, null, null, 
invmotivos.motivo, invmotivos.desc_motivo, 0,
(invmotivos.signo*-eys3.monto),
Sign(invmotivos.signo*-eys3.monto)
from eys1, almacen, eys3, gralcompanias, invmotivos, cglcuentas
where eys1.almacen = eys3.almacen
and eys1.no_transaccion = eys3.no_transaccion
and eys1.almacen = almacen.almacen
and almacen.compania = gralcompanias.compania
and eys1.motivo = invmotivos.motivo
and eys3.cuenta = cglcuentas.cuenta;



create view v_cos_produccion as
SELECT Anio(a.fecha) as anio, Mes(a.fecha) as mes, b.articulo, c.desc_articulo, 
Sum(b.cantidad) as cantidad, Sum(b.costo) as costo
FROM cos_trx a, cos_produccion b, articulos c  
WHERE a.compania = b.compania AND a.secuencia = b.secuencia 
AND b.articulo = c.articulo  and Anio(a.fecha) >= 2010 
GROUP BY Anio(a.fecha), Mes(a.fecha), b.articulo, c.desc_articulo  
union  
select Anio(a.fecha), Mes(a.fecha), b.articulo, c.desc_articulo, 
-Sum(b.cantidad), Sum(b.costo)  
from eys1 a, eys2 b, articulos c  
where a.almacen = b.almacen  and a.no_transaccion = b.no_transaccion  
and a.motivo in ('12','20')  and b.articulo = c.articulo  and Anio(a.fecha) >= 2010 
group by Anio(a.fecha), Mes(a.fecha), b.articulo, c.desc_articulo;



create view v_cglposteo_detalle_excel as
SELECT gralcompanias.nombre as nombre_compania, cglposteo.compania, 
cglcuentas.nombre as descripcion_cuenta, cglposteo.fecha_comprobante as fecha,
cglposteo.aplicacion_origen as aplicacion_origen,
cglposteo.cuenta,  cglposteo.secuencia, 
 f_cglposteo(cglposteo.consecutivo, 'NOMBRE') as nombre, 
Trim(cglposteo.descripcion) as descripcion, cglposteo.debito, cglposteo.credito
FROM cglcuentas, cglposteo, gralcompanias
WHERE cglposteo.cuenta = cglcuentas.cuenta 
AND cglposteo.compania = gralcompanias.compania 
AND cglposteo.fecha_comprobante>='2011-01-01';



create view v_factura1_factura2_x_cat as
select almacen.compania, factura1.almacen, factura1.cajero, factura1.tipo, factmotivos.descripcion,
factura1.num_documento, factura1.cliente, factura1.nombre_cliente, factura1.forma_pago,
vendedores.nombre as nombre_del_vendedor,
factura1.codigo_vendedor, almacen.desc_almacen,
Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes, factura1.fecha_factura,
factura1.fecha_factura as fecha_cobro,
factura2.articulo, articulos.desc_articulo,
gralcompanias.nombre as nombre_de_cia,
gral_valor_grupos.desc_valor_grupo,
articulos.orden_impresion,
(factura2.cantidad * factmotivos.signo) as cantidad,
(((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) as venta,
(((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) / factura2.cantidad) as precio,
((((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) - f_factura2_costo(factura2.almacen, factura2.caja, factura2.tipo,factura2.num_documento,factura2.linea,'COSTO')) as margen,
f_saldo_documento_cxc(factura1.almacen, factura1.caja, factura1.cliente, factura1.tipo,
    Trim(to_char(factura1.num_documento, '9999999')), current_date) as saldo
from almacen, factura1, factura2, factmotivos, clientes, articulos, vendedores, 
gralcompanias, articulos_agrupados, gral_valor_grupos, gral_forma_de_pago
where factura1.forma_pago = gral_forma_de_pago.forma_pago
and almacen.compania = gralcompanias.compania
and factura1.codigo_vendedor = vendedores.codigo
and articulos_agrupados.articulo = articulos.articulo
and gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and almacen.almacen = factura1.almacen
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura1.tipo = factmotivos.tipo
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' or factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S')
and factura1.cliente = clientes.cliente
and factura2.articulo = articulos.articulo
and factura2.cantidad <> 0
and gral_valor_grupos.grupo = 'CAT'
and gral_valor_grupos.aplicacion = 'INV'
and factura1.status <> 'A'
and (gral_forma_de_pago.dias = 0
         or f_saldo_documento_cxc(factura1.almacen, factura1.caja, factura1.cliente, factura1.tipo,
    Trim(to_char(factura1.num_documento, '9999999')), current_date) > 0)
and factura1.fecha_factura >= '2012-01-01'
union
select almacen.compania, factura1.almacen, factura1.cajero, factura1.tipo, factmotivos.descripcion,
factura1.num_documento, factura1.cliente, factura1.nombre_cliente, factura1.forma_pago,
vendedores.nombre as nombre_del_vendedor,
factura1.codigo_vendedor, almacen.desc_almacen,
Anio(cxcdocm.fecha_posteo) as anio,
Mes(cxcdocm.fecha_posteo) as mes, factura1.fecha_factura,
cxcdocm.fecha_posteo as fecha_cobro,
factura2.articulo, articulos.desc_articulo,
gralcompanias.nombre as nombre_de_cia,
gral_valor_grupos.desc_valor_grupo,
articulos.orden_impresion,
(factura2.cantidad * factmotivos.signo) as cantidad,
(((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) as venta,
(((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) / factura2.cantidad) as precio,
((((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) - f_factura2_costo(factura2.almacen, factura2.caja, factura2.tipo,factura2.num_documento,factura2.linea,'COSTO')) as margen,
f_saldo_documento_cxc(factura1.almacen, factura1.caja, factura1.cliente, factura1.tipo,
    Trim(to_char(factura1.num_documento, '9999999')), current_date) as saldo
from almacen, factura1, factura2, factmotivos, clientes, articulos, vendedores, 
gralcompanias, articulos_agrupados, gral_valor_grupos, cxcdocm, cxcmotivos
where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
and cxcmotivos.cobros = 'S'
and cxcdocm.almacen = factura1.almacen
and cxcdocm.cliente = factura1.cliente
and cxcdocm.docmto_aplicar = Trim(to_char(factura1.num_documento, '999999999'))
and cxcdocm.motivo_ref = factura1.tipo
and almacen.compania = gralcompanias.compania
and factura1.codigo_vendedor = vendedores.codigo
and articulos_agrupados.articulo = articulos.articulo
and gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and almacen.almacen = factura1.almacen
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura1.tipo = factmotivos.tipo
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' or factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S')
and factura1.cliente = clientes.cliente
and factura2.articulo = articulos.articulo
and factura2.cantidad <> 0
and gral_valor_grupos.grupo = 'CAT'
and gral_valor_grupos.aplicacion = 'INV'
and factura1.status <> 'A'
and cxcdocm.fecha_posteo >= '2012-01-01'
and f_saldo_documento_cxc(factura1.almacen, factura1.caja, factura1.cliente, factura1.tipo,
    Trim(to_char(factura1.num_documento, '9999999')), cxcdocm.fecha_posteo) = 0;
    

create view v_cxp_declaracion_impuestos as
select gralcompanias.nombre, cglposteo.compania, 
f_cglposteo(cglposteo.consecutivo, 'NOMBRE') as nombre_proveedor,
f_cglposteo(cglposteo.consecutivo, 'PROVEEDOR') as proveedor,
f_cglposteo(cglposteo.consecutivo, 'TIPO') as tipo,
f_cglposteo(cglposteo.consecutivo, 'DOCUMENTO') as documento,
cglposteo.fecha_comprobante as fecha,
f_cglposteo(cglposteo.consecutivo, 'OBSERVACION') as observacion,
f_cglposteo_itbms(cglposteo.consecutivo, 'COMPRA_GRAVADA') as compra_gravada,
f_cglposteo_itbms(cglposteo.consecutivo, 'COMPRA_EXCENTA') as compra_excenta,
f_cglposteo_itbms(cglposteo.consecutivo, 'ITBMS') as impuesto
from cglposteo, gral_impuestos, gralcompanias
where cglposteo.cuenta = gral_impuestos.cuenta
and cglposteo.compania = gralcompanias.compania
and aplicacion_origen <> 'FAC'
and fecha_comprobante >= '2010-01-01' 
union
select gralcompanias.nombre, cxpfact1.compania, proveedores.nomb_proveedor,
cxpfact1.proveedor, 'FACTURA', cxpfact1.fact_proveedor, cxpfact1.fecha_posteo_fact_cxp,
cxpfact1.obs_fact_cxp, 0,
(select sum(cxpfact2.monto) from cxpfact2
where cxpfact2.compania = cxpfact1.compania
and cxpfact2.proveedor = cxpfact1.proveedor
and cxpfact2.fact_proveedor = cxpfact1.fact_proveedor), 0
from cxpfact1, gralcompanias, proveedores
where cxpfact1.compania = gralcompanias.compania
and cxpfact1.proveedor = proveedores.proveedor
and fecha_posteo_fact_cxp >= '2010-01-01' 
and not exists
(select * from cxpfact2, gral_impuestos
where cxpfact2.cuenta = gral_impuestos.cuenta
and cxpfact2.compania = cxpfact1.compania
and cxpfact2.proveedor = cxpfact1.proveedor
and cxpfact2.fact_proveedor = cxpfact1.fact_proveedor);



create view v_apc_refere as
select f_id(clientes.tipo_de_persona, clientes.id, 'IDENT1') as ident1,
f_id(clientes.tipo_de_persona, clientes.id, 'IDENT2') as ident2,
f_id(clientes.tipo_de_persona, clientes.id, 'IDENT3') as ident3,
f_id(clientes.tipo_de_persona, clientes.id, 'IDENT4') as ident4,
case when clientes.tipo_de_persona = '2' then '2' else '1' end as tipo_clie,
'E' as cod_grupo_econ,
'07' as tipo_asoc,
'080006' as ident_asoc,
trim(clientes.cliente) as cuenta,
'DM080006' as user_id,
'P30' as tipo_forma_pago,
'LCR' as tipo_relacion,
trim(to_char(clientes.fecha_apertura,'mm/dd/yyyy')) as fec_inicio_rel,
'' as fec_fre,
clientes.limite_credito as monto_original,
f_apc(clientes.cliente, 'SALDO', '2010-11-30') as saldo_actual,
0 as num_pagos,
0 as importe_pago,
f_apc(clientes.cliente, 'FECHA_ULTIMO_PAGO', '2010-11-30') as fec_ultimo_pago,
f_apc(clientes.cliente, 'MONTO_ULTIMO_PAGO', '2010-11-30') as monto_ultimo_pago,
'' as fec_liq,
0 as tipo_comporta,
1 as estatus_ref,
f_apc(clientes.cliente, 'NUMERO_DIAS_ATRASO', '2010-11-30') as num_dias_atraso,
'' as monto_codificado,
'' as tipo_cifra,
'' as observacion,
'11/30/2010' as fec_corte,
trim(clientes.nomb_cliente) as nom_fiador,
trim(clientes.id) as ced_fiador
from clientes;

create view v_apc_clientes as
select f_id(clientes.tipo_de_persona, clientes.id, 'IDENT1') as ident1,
f_id(clientes.tipo_de_persona, clientes.id, 'IDENT2') as ident2,
f_id(clientes.tipo_de_persona, clientes.id, 'IDENT3') as ident3,
f_id(clientes.tipo_de_persona, clientes.id, 'IDENT4') as ident4,
case when clientes.tipo_de_persona = '2' then '2' else '1' end as tipo_clie,
f_get_nombre(cliente, 'APELLIDO_PATERNO') as apel_pater,
f_get_nombre(cliente, 'APELLIDO_MATERNO') as apel_mater,
'' as apel_casad,
f_get_nombre(cliente, 'PRIMER_NOMBRE') as primer_nom,
f_get_nombre(cliente, 'SEGUNDO_NOMBRE') as segundo_no,
'1' as sexo_clie,
'' as seguro_soc,
'' as estado_civil,
f_get_nombre(cliente, 'NOMBRE_LEGAL') as nom_legal,
'' as nomb_comerc, trim(clientes.direccion1) as direc_clie, 
'' as fec_nac_in,
clientes.tel1_cliente as telef_casa,
clientes.fax_cliente as telef_fax1,
clientes.tel2_cliente as telef_fax2,
'' as telef_otro, 
'' as telef_celu,
'' as lug_trab,
'' as direc_trab,
'' as position_t,
0 as ingreso_me,
'' as fac_ingres, '' as telef_ofic, '' as telef_ofic2, '' as nom_conyug,
'' as apel_conyug, '' as ced_conyug, '' as nom_padre, '' as apel_padre,
'' as nom_madre, '' as ape_madre
from clientes, gral_forma_de_pago
where clientes.forma_pago = gral_forma_de_pago.forma_pago
and clientes.id is not null;

create view v_pla_salario_neto as
select nomctrac.compania, tipo_calculo, nomctrac.tipo_planilla, nomctrac.year, 
nomctrac.numero_planilla, nomtpla2.dia_d_pago, rhuempl.nombre_del_empleado, 
nomctrac.codigo_empleado, sum(nomctrac.monto*nomconce.signo) as monto
from nomctrac, nomconce, nomtpla2, rhuempl
where nomctrac.cod_concepto_planilla = nomconce.cod_concepto_planilla
and nomctrac.tipo_planilla = nomtpla2.tipo_planilla
and nomctrac.year = nomtpla2.year
and nomctrac.numero_planilla = nomtpla2.numero_planilla
and nomctrac.compania = rhuempl.compania
and nomctrac.codigo_empleado = rhuempl.codigo_empleado
and nomctrac.year >= 2010
and rhuempl.forma_de_pago = 'T'
and rhuempl.fecha_terminacion is null
group by 1, 2, 3, 4, 5, 6, 7, 8;


create view v_cgl_financiero_x_cuenta_detallado as
select  cglposteo.compania, cgl_financiero.no_informe, Anio(cglposteo.fecha_comprobante) as anio,  
Mes(cglposteo.fecha_comprobante) as mes, Trim(cglposteo.cuenta) as cuenta, 
trim(cglcuentas.nombre) as nombre_cuenta, Trim(cgl_financiero.d_fila) as d_fila, 
trim(cglposteo.descripcion) as descripcion, -(cglposteo.debito-cglposteo.credito) as monto
from cglposteo, cgl_financiero, cglcuentas
where cglposteo.cuenta = cgl_financiero.cuenta
and cgl_financiero.cuenta = cglcuentas.cuenta
and cglposteo.periodo <> 13;


create view v_formulario_43_dgi as
select cxpfact1.compania, proveedores.tipo_de_persona, trim(proveedores.id_proveedor) as ruc,
Trim(proveedores.dv_proveedor) as dv, 
trim(proveedores.nomb_proveedor) as nomb_proveedor,
trim(cxpfact1.fact_proveedor) as fact_proveedor, cxpfact1.fecha_posteo_fact_cxp as fecha, 
proveedores.concepto, 
proveedores.tipo_de_compra, 
f_cxpfact2(cxpfact1.compania, cxpfact1.proveedor, cxpfact1.fact_proveedor, 'MONTO') as monto,
f_cxpfact2(cxpfact1.compania, cxpfact1.proveedor, cxpfact1.fact_proveedor, 'ITBMS') as itbms
from cxpfact1, proveedores, gralcompanias
where cxpfact1.proveedor = proveedores.proveedor
and cxpfact1.compania = gralcompanias.compania
and cxpfact1.fecha_posteo_fact_cxp >= '2010-01-01'
union
select cxpajuste1.compania, proveedores.tipo_de_persona, trim(proveedores.id_proveedor) as ruc,
Trim(proveedores.dv_proveedor) as dv, 
trim(proveedores.nomb_proveedor) as nomb_proveedor,
trim(cxpajuste1.docm_ajuste_cxp) as fact_proveedor, cxpajuste1.fecha_posteo_ajuste_cxp as fecha, 
proveedores.concepto, 
proveedores.tipo_de_compra, 
f_cxpajuste1(cxpajuste1.compania, cxpajuste1.sec_ajuste_cxp, 'MONTO'),
f_cxpajuste1(cxpajuste1.compania, cxpajuste1.sec_ajuste_cxp, 'ITBMS')
from proveedores, cxpajuste1, gralcompanias
where cxpajuste1.proveedor = proveedores.proveedor
and cxpajuste1.compania = gralcompanias.compania
union
select almacen.compania, clientes.tipo_de_persona, trim(clientes.id),
trim(clientes.dv), trim(clientes.nomb_cliente),
trim(to_char(factura1.num_documento, '9999999999')),
factura1.fecha_factura,
clientes.concepto,
clientes.tipo_de_compra,
-f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento, factura1.caja, 'DA'),
0
from factura1, clientes, almacen
where factura1.cliente = clientes.cliente
and factura1.almacen = almacen.almacen
and factura1.tipo = 'DA'
and factura1.fecha_factura >= '2010-01-01'
union
select bcoctas.compania, cglauxiliares.tipo_persona, trim(cglauxiliares.id),
trim(cglauxiliares.dv), trim(cglauxiliares.nombre),
trim(to_char(bcocheck1.no_cheque, '99999999')),
bcocheck1.fecha_cheque, cglauxiliares.concepto, cglauxiliares.tipo_de_compra,
f_bcocheck2(bcocheck2.cod_ctabco, bcocheck2.motivo_bco, bcocheck2.no_cheque, bcocheck2.linea, 'MONTO'),
f_bcocheck2(bcocheck2.cod_ctabco, bcocheck2.motivo_bco, bcocheck2.no_cheque, bcocheck2.linea, 'ITBMS')
from bcoctas, bcocheck1, bcocheck2, cglauxiliares, cglcuentas
where bcoctas.cod_ctabco = bcocheck1.cod_ctabco
and bcocheck1.cod_ctabco = bcocheck2.cod_ctabco
and bcocheck1.motivo_bco = bcocheck2.motivo_bco
and bcocheck1.no_cheque = bcocheck2.no_cheque
and bcocheck2.auxiliar1 = cglauxiliares.auxiliar
and bcocheck1.fecha_cheque >= '2010-01-01'
and bcocheck1.status <> 'A'
and bcocheck1.aplicacion = 'BCO'
and cglcuentas.cuenta = bcocheck2.cuenta
and cglcuentas.tipo_cuenta = 'R'
union
select adc_manifiesto.compania, proveedores.tipo_de_persona, trim(proveedores.id_proveedor), trim(proveedores.dv_proveedor),
trim(proveedores.nomb_proveedor), trim(adc_master.container), adc_manifiesto.fecha, proveedores.concepto,
proveedores.tipo_de_compra, sum(f_adc_master_cargo(adc_manifiesto.compania, adc_manifiesto.consecutivo, adc_master.linea_master)), 0
from navieras, adc_manifiesto, adc_master, proveedores
where navieras.cod_naviera = adc_manifiesto.cod_naviera
and navieras.proveedor = proveedores.proveedor
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.fecha >= '2010-01-01'
group by adc_manifiesto.compania, proveedores.tipo_de_persona, proveedores.id_proveedor, proveedores.dv_proveedor,
proveedores.nomb_proveedor, adc_master.container, adc_manifiesto.fecha, proveedores.concepto,
proveedores.tipo_de_compra;

/*
union
select cajas.compania, cglauxiliares.tipo_persona, Trim(cglauxiliares.id),
Trim(cglauxiliares.dv), Trim(cglauxiliares.nombre),
trim(to_char(caja_trx1.numero_trx, '999999')),
caja_trx1.fecha_posteo, cglauxiliares.concepto, cglauxiliares.tipo_de_compra,  
f_caja_trx2(caja_trx2.caja, caja_trx2.numero_trx, caja_trx2.linea, 'MONTO'),
f_caja_trx2(caja_trx2.caja, caja_trx2.numero_trx, caja_trx2.linea, 'ITBMS')
from cajas, caja_trx1, caja_trx2, cglauxiliares
where cajas.caja = caja_trx1.caja
and caja_trx1.caja = caja_trx2.caja
and caja_trx1.numero_trx = caja_trx2.numero_trx
and caja_trx2.auxiliar_1 = cglauxiliares.auxiliar
and caja_trx1.fecha_posteo >= '2010-01-01'
*/






create view v_cxc_recibos as
select almacen.compania, gralcompanias.nombre as nombre_cia,
    cxc_recibo1.almacen, almacen.desc_almacen,   
    cxc_recibo1.caja,
    cobradores.nombre_cobrador,
    cxc_recibo1.cliente, cxc_recibo1.nombre as nomb_cliente,   
    cxc_recibo1.consecutivo, cxc_recibo1.documento, cxc_recibo1.fecha, 
    cxc_recibo1.status, cxcmotivos.desc_motivo_cxc,
    cxc_recibo1.usuario, cxc_recibo1.cobrador,
    case when cxc_recibo1.status = 'A' then 0 else cxc_recibo1.cheque end as cheque,   
    case when cxc_recibo1.status = 'A' then 0 else cxc_recibo1.efectivo end as efectivo,   
    case when cxc_recibo1.status = 'A' then 0 else cxc_recibo1.otro end as otro
from cxc_recibo1, almacen, gralcompanias, cxcmotivos, cobradores
where almacen.almacen = cxc_recibo1.almacen and  
      gralcompanias.compania = almacen.compania and 
      cxc_recibo1.cobrador = cobradores.cobrador and
      cxc_recibo1.motivo_cxc = cxcmotivos.motivo_cxc;




create view v_factura1_factura2_x_tdi as
select almacen.compania, factura1.almacen, factura1.cajero, factura1.tipo, factmotivos.descripcion,
factura1.num_documento, factura1.cliente, factura1.nombre_cliente, factura1.forma_pago,
factura1.codigo_vendedor, almacen.desc_almacen,
Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes, factura1.fecha_factura,
factura2.articulo, articulos.desc_articulo,
vendedores.nombre as nombre_del_vendedor,
gralcompanias.nombre as nombre_de_cia,
gral_valor_grupos.desc_valor_grupo,
articulos.orden_impresion,
(factura2.cantidad * factmotivos.signo) as cantidad,
(((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) as venta,
(((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) / factura2.cantidad) as precio,
((((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) - f_factura2_costo(factura2.almacen, factura2.caja, factura2.tipo,factura2.num_documento,factura2.linea,'COSTO')) as margen
from almacen, factura1, factura2, factmotivos, clientes, articulos, vendedores, 
gralcompanias, articulos_agrupados, gral_valor_grupos
where almacen.compania = gralcompanias.compania
and factura1.codigo_vendedor = vendedores.codigo
and articulos_agrupados.articulo = articulos.articulo
and gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and almacen.almacen = factura1.almacen
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura1.tipo = factmotivos.tipo
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' or factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S')
and factura1.cliente = clientes.cliente
and factura2.articulo = articulos.articulo
and factura2.cantidad <> 0
and gral_valor_grupos.grupo = 'TDI'
and gral_valor_grupos.aplicacion = 'INV'
and factura1.status <> 'A';


/*
union
select gralcompanias.nombre, cajas.compania, Trim(caja_trx1.concepto),
null, 'CAJA MENUDA', trim(to_char(caja_trx1.numero_trx, '9999999999')),
caja_trx1.fecha_posteo, Trim(caja_trx1.concepto),
(cglposteo.debito-cglposteo.credito), 0
from caja_trx1, rela_caja_trx1_cglposteo, cglposteo, cajas, gralcompanias, cglcuentas
where caja_trx1.caja = cajas.caja
and caja_trx1.caja = rela_caja_trx1_cglposteo.caja
and caja_trx1.numero_trx = rela_caja_trx1_cglposteo.numero_trx
and rela_caja_trx1_cglposteo.consecutivo = cglposteo.consecutivo
and cajas.compania = gralcompanias.compania
and cglposteo.cuenta = cglcuentas.cuenta
and cglposteo.cuenta not in (select cuenta from gral_impuestos)
union
select gralcompanias.nombre, cajas.compania, Trim(caja_trx1.concepto),
null, 'CAJA MENUDA', trim(to_char(caja_trx1.numero_trx, '9999999999')),
caja_trx1.fecha_posteo, Trim(caja_trx1.concepto), 0, (cglposteo.debito-cglposteo.credito)
from caja_trx1, rela_caja_trx1_cglposteo, cglposteo, cajas, gralcompanias, cglcuentas, caja_tipo_trx
where caja_trx1.caja = cajas.caja
and caja_tipo_trx.tipo_trx = caja_trx1.tipo_trx
and caja_tipo_trx.signo = -1
and caja_trx1.caja = rela_caja_trx1_cglposteo.caja
and caja_trx1.numero_trx = rela_caja_trx1_cglposteo.numero_trx
and rela_caja_trx1_cglposteo.consecutivo = cglposteo.consecutivo
and cajas.compania = gralcompanias.compania
and cglposteo.cuenta = cglcuentas.cuenta
and cglposteo.cuenta in (select cuenta from gral_impuestos);


union
select gralcompanias.nombre, bcoctas.compania, bcocheck1.paguese_a,
null, 'CHEQUE', trim(to_char(bcocheck1.no_cheque,'9999999999')),
bcocheck1.fecha_posteo, bcocheck1.en_concepto_de, 0,
(cglposteo.debito-cglposteo.credito)
from bcocheck1, rela_bcocheck1_cglposteo, cglposteo, bcoctas, gralcompanias
where bcocheck1.cod_ctabco = bcoctas.cod_ctabco
and bcocheck1.cod_ctabco = rela_bcocheck1_cglposteo.cod_ctabco
and bcocheck1.motivo_bco = rela_bcocheck1_cglposteo.motivo_bco
and bcocheck1.no_cheque = rela_bcocheck1_cglposteo.no_cheque
and rela_bcocheck1_cglposteo.consecutivo = cglposteo.consecutivo
and bcoctas.compania = gralcompanias.compania
and cglposteo.cuenta in (select cuenta from gral_impuestos group by 1)
and bcocheck1.proveedor is null
and bcocheck1.status <> 'A'
and bcocheck1.aplicacion in ('BCO')
union
select gralcompanias.nombre, bcoctas.compania, bcocheck1.paguese_a,
null, 'CHEQUE', trim(to_char(bcocheck1.no_cheque,'9999999999')),
bcocheck1.fecha_posteo, bcocheck1.en_concepto_de, 
(cglposteo.debito+cglposteo.credito), 0
from bcocheck1, rela_bcocheck1_cglposteo, cglposteo, bcoctas, gralcompanias
where bcocheck1.cod_ctabco = bcoctas.cod_ctabco
and bcocheck1.cod_ctabco = rela_bcocheck1_cglposteo.cod_ctabco
and bcocheck1.motivo_bco = rela_bcocheck1_cglposteo.motivo_bco
and bcocheck1.no_cheque = rela_bcocheck1_cglposteo.no_cheque
and rela_bcocheck1_cglposteo.consecutivo = cglposteo.consecutivo
and bcoctas.compania = gralcompanias.compania
and cglposteo.cuenta not in (select cuenta from gral_impuestos group by 1)
and bcocheck1.proveedor is null
and bcocheck1.status <> 'A'
and bcocheck1.aplicacion in ('BCO')
and cglposteo.cuenta <> bcoctas.cuenta
union
select gralcompanias.nombre, bcoctas.compania, Trim(bcotransac1.obs_transac_bco),
null, 'TRANSACCION BANCO', trim(bcotransac1.no_docmto),
bcotransac1.fecha_posteo, bcotransac1.obs_transac_bco, 0,
(cglposteo.debito-cglposteo.credito)
from bcotransac1, rela_bcotransac1_cglposteo, cglposteo, bcoctas, gralcompanias
where bcotransac1.cod_ctabco = bcoctas.cod_ctabco
and bcotransac1.cod_ctabco = rela_bcotransac1_cglposteo.cod_ctabco
and bcotransac1.sec_transacc = rela_bcotransac1_cglposteo.sec_transacc
and rela_bcotransac1_cglposteo.consecutivo = cglposteo.consecutivo
and bcoctas.compania = gralcompanias.compania
and cglposteo.cuenta in (select cuenta from gral_impuestos group by 1)
union
select gralcompanias.nombre, bcoctas.compania, Trim(bcotransac1.obs_transac_bco),
null, 'TRANSACCION BANCO', trim(bcotransac1.no_docmto),
bcotransac1.fecha_posteo, bcotransac1.obs_transac_bco,
(cglposteo.debito-cglposteo.credito), 0
from bcotransac1, rela_bcotransac1_cglposteo, cglposteo, bcoctas, gralcompanias, cglcuentas
where bcotransac1.cod_ctabco = bcoctas.cod_ctabco
and bcotransac1.cod_ctabco = rela_bcotransac1_cglposteo.cod_ctabco
and bcotransac1.sec_transacc = rela_bcotransac1_cglposteo.sec_transacc
and rela_bcotransac1_cglposteo.consecutivo = cglposteo.consecutivo
and bcoctas.compania = gralcompanias.compania
and cglposteo.cuenta = cglcuentas.cuenta
and cglposteo.cuenta not in (select cuenta from gral_impuestos group by 1)
and cglposteo.cuenta <> bcoctas.cuenta
*/

create view v_cxp_facturas_por_rubros as
select cxpfact1.compania,  gralcompanias.nombre,
        proveedores.nomb_proveedor, proveedores.proveedor,   
         cxpfact1.fecha_posteo_fact_cxp,   
         cxpfact1.fact_proveedor,   
         cxpfact2.rubro_fact_cxp,   
         cxpfact1.obs_fact_cxp,   
         rubros_fact_cxp.orden,   
         (cxpfact2.monto * rubros_fact_cxp.signo_rubro_fact_cxp) as monto
    FROM cxpfact1,   
         cxpfact2,   
         rubros_fact_cxp,   
         proveedores,   
         gralcompanias  
   WHERE cxpfact2.proveedor = cxpfact1.proveedor and  
         cxpfact1.compania = cxpfact2.compania and  
         cxpfact2.fact_proveedor = cxpfact1.fact_proveedor and  
         cxpfact2.rubro_fact_cxp = rubros_fact_cxp.rubro_fact_cxp and  
         proveedores.proveedor = cxpfact1.proveedor and  
         gralcompanias.compania = cxpfact1.compania;

create view v_fac_declaracion_impuestos as 
select almacen.compania, gralcompanias.nombre, factura1.almacen, factura1.tipo, factura1.fecha_factura, factmotivos.descripcion,
factura1.num_documento, factura1.nombre_cliente,
case when gral_forma_de_pago.dias = 0 then f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento, factura1.caja, 'VTA_GRAVADA') else 0 end as venta_gravada_contado,
case when gral_forma_de_pago.dias = 0 then 0 else f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,  factura1.caja, 'VTA_GRAVADA') end as venta_gravada_credito,
case when gral_forma_de_pago.dias = 0 then f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,  factura1.caja, 'VTA_EXCENTA') else 0 end as venta_excenta_contado,
case when gral_forma_de_pago.dias = 0 then 0 else f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,  factura1.caja, 'VTA_EXCENTA') end as venta_excenta_credito,
case when gral_forma_de_pago.dias = 0 then f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,  factura1.caja, 'IMPUESTO') else 0 end as impuesto_contado,
case when gral_forma_de_pago.dias = 0 then 0 else f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,  factura1.caja, 'IMPUESTO') end as impuesto_credito,
case when gral_forma_de_pago.dias = 0 then f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,  factura1.caja, 'TOTAL') else 0 end as total_contado,
case when gral_forma_de_pago.dias = 0 then 0 else f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,  factura1.caja, 'TOTAL') end as total_credito
from factura1, factmotivos, almacen, gralcompanias, gral_forma_de_pago
where factura1.forma_pago = gral_forma_de_pago.forma_pago
and factura1.tipo = factmotivos.tipo
and factura1.almacen = almacen.almacen
and almacen.compania = gralcompanias.compania
and factura1.status <> 'A'
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' or factmotivos.nota_credito = 'S' 
    or factmotivos.devolucion = 'S');




create view v_cxcdocm_cxchdocm as
select almacen.compania, cxcdocm.almacen, cliente, cxcdocm.motivo_cxc, documento, docmto_aplicar, docmto_ref, motivo_ref, fecha_posteo as fecha, (cxcdocm.monto*cxcmotivos.signo) as monto 
from cxcdocm, cxcmotivos, almacen
where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
and cxcdocm.almacen = almacen.almacen
union
select almacen.compania, cxchdocm.almacen, cliente, cxchdocm.motivo_cxc, documento, docmto_aplicar, docmto_ref, motivo_ref, fecha_posteo, (cxchdocm.monto*cxcmotivos.signo) 
from cxchdocm, cxcmotivos, almacen
where cxchdocm.motivo_cxc = cxcmotivos.motivo_cxc
and cxchdocm.almacen = almacen.almacen;



create view v_ventas_costos as
select almacen.compania, factura2.almacen, factura1.fecha_factura, almacen.desc_almacen,
       factura1.num_documento, factura1.cliente, clientes.nomb_cliente as nombre_del_cliente,  
       factmotivos.descripcion,   
       factura2.articulo,   
       articulos.desc_articulo,   
       gralcompanias.nombre,   
       factmotivos.signo,   
       factura1.codigo_vendedor,
       vendedores.nombre as nombre_vendedor,
       (factura2.cantidad * factmotivos.signo) as cantidad,   
       (((factura2.precio * factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) as venta,
        f_factura2_costo(factura2.almacen, factura2.caja, factura2.tipo, factura2.num_documento, factura2.linea, 'COSTO') as costo
    FROM factura2,
         almacen,   
         factura1,   
         factmotivos,   
         articulos,   
         gralcompanias,
         vendedores,
         clientes
   WHERE factura1.almacen = almacen.almacen
          and factura1.cliente = clientes.cliente
         and factura1.codigo_vendedor = vendedores.codigo
         and factura1.almacen = factura2.almacen
         and factura1.tipo = factura2.tipo
         and factura1.num_documento = factura2.num_documento
         and factura1.caja = factura2.caja
         and factmotivos.tipo = factura1.tipo
         and factura2.articulo = articulos.articulo
         and gralcompanias.compania = almacen.compania
         and factmotivos.cotizacion = 'N'
         and factura1.status <> 'A';


create view fact_despachos as
select almacen.compania, almacen.almacen, factura1.tipo, factura1.num_documento, 
factura1.codigo_vendedor as vendedor, factura1.cliente, factura1.despachar, 
factura1.fecha_despacho, factura1.fecha_factura, 
anio(factura1.fecha_factura) as anio, mes(factura1.fecha_factura) as mes, 
factura1.forma_pago, factura2.articulo, 
sum((factura2.precio * factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global) as venta, 
sum(factura2.cantidad) as cantidad
from almacen, factmotivos, factura1, factura2, articulos
where factura1.almacen = almacen.almacen
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura1.tipo = factmotivos.tipo
and factura2.articulo = articulos.articulo
and articulos.servicio = 'N'
and factura1.status <> 'A'
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' 
or factmotivos.donacion = 'S'
or factmotivos.promocion = 'S')
group by almacen.compania, almacen.almacen, factura1.tipo, factura1.num_documento, 
factura1.codigo_vendedor, factura1.cliente, factura1.despachar, 
factura1.fecha_despacho, factura1.fecha_factura, 
anio(factura1.fecha_factura), mes(factura1.fecha_factura), 
factura1.forma_pago, factura2.articulo;



create view v_list_cobros_airsea as
select almacen.compania, clientes.nomb_cliente, cxctrx1.fecha_posteo_ajuste_cxc as fecha,
         cxctrx1.motivo_cxc, cxctrx1.cliente, cxctrx1.cheque, cxctrx1.efectivo, 0 as otro,
         cxctrx1.docm_ajuste_cxc as documento, gralcompanias.nombre as nombre_cia, cxctrx1.almacen
from cxctrx1, almacen, gralcompanias, cxcmotivos, clientes  
where almacen.compania = gralcompanias.compania
  and cxctrx1.almacen = almacen.almacen
  and cxctrx1.motivo_cxc = cxcmotivos.motivo_cxc
  and cxctrx1.cliente = clientes.cliente
union
select adc_cxc_1.compania, clientes.nomb_cliente, adc_cxc_1.fecha, adc_cxc_1.motivo_cxc,
    adc_cxc_1.cliente, 0,0,adc_cxc_1.monto, adc_cxc_1.documento, gralcompanias.nombre,
    adc_cxc_1.almacen
from adc_cxc_1, clientes, gralcompanias
where adc_cxc_1.cliente = clientes.cliente
and adc_cxc_1.compania = gralcompanias.compania;

create view v_consumo as
select Anio(eys1.fecha), Mes(eys1.fecha), eys2.articulo, articulos.desc_articulo,
-sum(eys2.cantidad*invmotivos.signo) as cantidad, 
case when sum(eys2.cantidad) = 0 then 0  else (sum(eys2.costo)/sum(eys2.cantidad)) end as cu,
sum(eys2.costo) as costo
from eys1, eys2, invmotivos, articulos
where eys2.articulo = articulos.articulo
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys1.aplicacion_origen in ('COS')
and eys1.motivo = '14'
group by 1, 2, 3, 4
order by 1, 2, 3;


/*
create view v_consumo as
select Anio(eys1.fecha), Mes(eys1.fecha), eys2.articulo, articulos.desc_articulo,
-sum(eys2.cantidad*invmotivos.signo) as cantidad, (sum(eys2.costo)/sum(eys2.cantidad)) as cu,
sum(eys2.costo) as costo
from eys1, eys2, invmotivos, articulos
where eys2.articulo = articulos.articulo
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys1.aplicacion_origen in ('COS')
and eys1.motivo = '14'
group by 1, 2, 3, 4
order by 1, 2, 3;
*/


create view v_ventas_x_mes as
select Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes, gral_valor_grupos.desc_valor_grupo as descripcion,
factura2.articulo,
sum(factura2.cantidad) as cantidad,
sum((factura2.precio*factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global) as venta
from factura1, factura2, factmotivos, articulos_agrupados, gral_valor_grupos
where factura2.articulo = articulos_agrupados.articulo
and articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and gral_valor_grupos.grupo = 'CLA'
and gral_valor_grupos.aplicacion = 'INV'
and factmotivos.tipo = factura1.tipo
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S') 
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura1.status <> 'A'
group by 1, 2, 3, 4
order by 1, 2, 3;


create view v_produccion as
select Anio(eys1.fecha), Mes(eys1.fecha), gral_valor_grupos.desc_valor_grupo as descripcion,
eys2.articulo, articulos.desc_articulo, articulos.orden_impresion,
sum(eys2.cantidad*invmotivos.signo), sum(eys2.cantidad*invmotivos.signo*convmedi.factor) as quintales
from eys1, eys2, invmotivos, articulos, articulos_agrupados,
gral_valor_grupos, convmedi
where articulos.articulo = articulos_agrupados.articulo
and articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and gral_valor_grupos.grupo = 'CLA'
and gral_valor_grupos.aplicacion = 'INV'
and eys2.articulo = articulos.articulo
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys1.motivo in ('01','12','20')
and articulos.unidad_medida = convmedi.old_unidad
and convmedi.new_unidad = '100LBS'
group by 1, 2, 3, 4, 5, 6
order by 1, 2, 3;

create view v_consumo_trigo as
select Anio(eys1.fecha) as anio, Mes(eys1.fecha) as mes, 
invmotivos.desc_motivo,
Trim(eys2.articulo) as articulo, 
Trim(articulos.desc_articulo) as desc_articulo, gral_valor_grupos.desc_valor_grupo,
sum(eys2.cantidad*invmotivos.signo) as cantidad, 
(case when sum(eys2.cantidad) = 0 then 0 else (sum(eys2.costo)/sum(eys2.cantidad)) end) as cu,
sum(eys2.costo) as costo
from eys1, eys2, invmotivos, articulos, articulos_agrupados, gral_valor_grupos
where articulos_agrupados.articulo = articulos.articulo
and articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and gral_valor_grupos.grupo = 'SDI'
and eys2.articulo = articulos.articulo
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys1.fecha >= '2009-01-01'
group by 1, 2, 3, 4, 5, 6
order by 1, 2, 3;


create view v_dividendos_e_intereses as
select Anio(cglposteo.fecha_comprobante) as anio, Mes(cglposteo.fecha_comprobante) as mes,
cgl_financiero.d_fila as cuenta, -sum(debito-credito) as monto
from cglposteo, cgl_financiero
where cglposteo.cuenta = cgl_financiero.cuenta
and cgl_financiero.no_informe = 8
and compania = '03'
and cglposteo.periodo <> 13
group by 1, 2, 3;



create view v_fac_totales as
select almacen.compania, factura1.almacen, factmotivos.descripcion, factura1.tipo, factura1.num_documento, factura1.cliente, 
factura1.nombre_cliente, factura1.fecha_factura, Anio(factura1.fecha_factura),
Mes(factura1.fecha_factura),
f_monto_factura_new(factura1.almacen, factura1.tipo, factura1.num_documento, factura1.caja) as contado,
0 as credito
from factura1, factmotivos, gral_forma_de_pago, almacen
where factura1.tipo = factmotivos.tipo
and factura1.almacen = almacen.almacen
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and gral_forma_de_pago.dias = 0
and factura1.status <> 'A'
and factmotivos.cotizacion = 'N'
and factmotivos.donacion = 'N'
union
select almacen.compania, factura1.almacen, factmotivos.descripcion, factura1.tipo, factura1.num_documento, factura1.cliente, 
factura1.nombre_cliente, factura1.fecha_factura, Anio(factura1.fecha_factura),
Mes(factura1.fecha_factura), 0, 
f_monto_factura_new(factura1.almacen, factura1.tipo, factura1.num_documento, factura1.caja)
from factura1, factmotivos, gral_forma_de_pago, almacen
where factura1.tipo = factmotivos.tipo
and factura1.almacen = almacen.almacen
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and gral_forma_de_pago.dias <> 0
and factura1.status <> 'A'
and factmotivos.cotizacion = 'N'
and factmotivos.donacion = 'N'
union
select almacen.compania, factura1.almacen, factmotivos.descripcion, factura1.tipo, factura1.num_documento, factura1.cliente, 
factura1.nombre_cliente, factura1.fecha_factura, Anio(factura1.fecha_factura),
Mes(factura1.fecha_factura), 0, 0
from factura1, factmotivos, gral_forma_de_pago, almacen
where factura1.tipo = factmotivos.tipo
and factura1.almacen = almacen.almacen
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and factura1.status = 'A'
and factmotivos.cotizacion = 'N'
and factmotivos.donacion = 'N';



create view v_fac_resumen_z as
select almacen.compania, gralcompanias.nombre, gralcompanias.id_tributario, 
gralcompanias.dv, factura1.almacen, almacen.desc_almacen, factura1.caja, factura1.tipo, 
factura1.num_documento, factura1.sec_z, fac_cajas.serie, fac_cajas.modelo,
gral_forma_de_pago.dias, fac_z.fecha as fecha, fac_z.hora as hora,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento, factura1.caja, 'VENTA') as venta,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,factura1.caja,'DESCUENTO') as descuento,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,factura1.caja,'VTA_GRAVADA') as venta_gravada,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,factura1.caja,'DEVOLUCION') as devoluciones,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,factura1.caja,'IMPUESTO') as impuesto,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,factura1.caja,'EFECTIVO') as efectivo,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,factura1.caja,'CHEQUE') as cheque,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,factura1.caja,'TARJETA_CREDITO') as tarjeta_credito,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,factura1.caja,'TARJETA_DEBITO') as tarjeta_debito,
f_desglose_factura(factura1.almacen, factura1.tipo, factura1.num_documento,factura1.caja,'OTRO') as otro
from almacen, factura1, gral_forma_de_pago, factmotivos, fac_z, gralcompanias, fac_cajas
where factura1.almacen = fac_cajas.almacen
and factura1.caja = fac_cajas.caja
and almacen.compania = gralcompanias.compania
and factura1.almacen = fac_z.almacen
and factura1.caja = fac_z.caja
and factura1.sec_z = fac_z.sec_z
and almacen.almacen = factura1.almacen
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and factura1.tipo = factmotivos.tipo
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' or factmotivos.devolucion = 'S');

create view v_fact_costos_x_grupo as
select factura1.cajero, factura1.almacen, factura1.tipo, factura1.num_documento, factura1.fecha_factura,almacen.desc_almacen,
factura1.cliente, factmotivos.descripcion, factura2.articulo,articulos.desc_articulo, 
gralcompanias.nombre as nombre_cia,
factura1.nombre_cliente, articulos.orden_impresion,
factura1.caja, factura1.sec_z, gral_forma_de_pago.dias,
factmotivos.signo,  (factura2.cantidad * factmotivos.signo) as cantidad,
round((((factura2.precio * factura2.cantidad) - (factura2.descuento_linea + factura2.descuento_global))*factmotivos.signo),2) as venta,   
f_factura2_costo(factura1.almacen, factura1.caja, factura1.tipo, factura1.num_documento,factura2.linea,'IMPUESTO') as impuesto,
f_factura2_costo(factura1.almacen, factura1.caja, factura1.tipo, factura1.num_documento,factura2.linea,'COSTO') as costo,
vendedores.codigo, vendedores.nombre as nombre_vendedor, almacen.compania,
gral_grupos_aplicacion.desc_grupo, gral_grupos_aplicacion.grupo,
gral_valor_grupos.desc_valor_grupo, gral_valor_grupos.codigo_valor_grupo
from gralcompanias, almacen, factura1, factura2, vendedores, factmotivos,
articulos, articulos_agrupados, gral_valor_grupos, gral_grupos_aplicacion, gral_forma_de_pago
where factura1.forma_pago = gral_forma_de_pago.forma_pago
and almacen.compania = gralcompanias.compania
and factura1.tipo = factmotivos.tipo
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura1.almacen = almacen.almacen
and factura1.codigo_vendedor = vendedores.codigo
and factura1.tipo = factura1.tipo
and factura2.articulo = articulos.articulo
and factura2.articulo = articulos_agrupados.articulo
and articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and gral_grupos_aplicacion.grupo = gral_valor_grupos.grupo
and factura1.status <> 'A'
and factmotivos.cotizacion = 'N'
and gral_grupos_aplicacion.aplicacion = 'INV';


create view v_factura_cglposteo as
select cglposteo.compania, factura1.num_documento, factura1.cliente,   
         factura1.nombre_cliente,   
         cglposteo.cuenta,   
         cglposteo.fecha_comprobante as fecha,   
         gralcompanias.nombre,   
         'RESUMEN DE FACTURAS POR CUENTA DE MAYOR' as titulo,
         sum(cglposteo.debito-cglposteo.credito) as monto
from gralcompanias, factura1, cglposteo, rela_factura1_cglposteo
where gralcompanias.compania = cglposteo.compania
and factura1.almacen = rela_factura1_cglposteo.almacen
and factura1.tipo = rela_factura1_cglposteo.tipo
and factura1.caja = rela_factura1_cglposteo.caja
and factura1.num_documento = rela_factura1_cglposteo.num_documento
and cglposteo.consecutivo = rela_factura1_cglposteo.consecutivo
group by cglposteo.compania, factura1.num_documento, factura1.cliente,   
         factura1.nombre_cliente,   
         cglposteo.cuenta,   
         cglposteo.fecha_comprobante,
         gralcompanias.nombre
union
select almacen.compania, factura1.num_documento, factura1.cliente,   
         factura1.nombre_cliente, eys2.cuenta,
         eys1.fecha,   
         gralcompanias.nombre,   
         'RESUMEN DE FACTURAS POR CUENTA DE MAYOR' as titulo,
         -(eys2.costo*invmotivos.signo)
from gralcompanias, factura1, factura2_eys2, eys2, almacen, eys1, invmotivos
where gralcompanias.compania = almacen.compania
and factura1.almacen = almacen.almacen
and factura1.almacen = factura2_eys2.almacen
and factura1.tipo = factura2_eys2.tipo
and factura1.caja = factura2_eys2.caja
and factura1.num_documento = factura2_eys2.num_documento
and eys2.articulo = factura2_eys2.articulo
and eys2.almacen = factura2_eys2.almacen
and eys2.no_transaccion = factura2_eys2.no_transaccion
and eys2.linea = factura2_eys2.eys2_linea
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
union
select almacen.compania, factura1.num_documento, factura1.cliente,   
         factura1.nombre_cliente, articulos_por_almacen.cuenta,
         eys1.fecha,   
         gralcompanias.nombre,   
         'RESUMEN DE FACTURAS POR CUENTA DE MAYOR' as titulo,
         (eys2.costo*invmotivos.signo)
from gralcompanias, factura1, factura2_eys2, eys2, almacen, eys1, invmotivos, articulos_por_almacen
where gralcompanias.compania = almacen.compania
and factura1.almacen = almacen.almacen
and factura1.almacen = factura2_eys2.almacen
and factura1.tipo = factura2_eys2.tipo
and factura1.caja = factura2_eys2.caja
and factura1.num_documento = factura2_eys2.num_documento
and eys2.articulo = factura2_eys2.articulo
and eys2.almacen = factura2_eys2.almacen
and eys2.no_transaccion = factura2_eys2.no_transaccion
and eys2.linea = factura2_eys2.eys2_linea
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys2.almacen = articulos_por_almacen.almacen
and eys2.articulo = articulos_por_almacen.articulo;

create view v_kardex as
select almacen.compania, almacen.desc_almacen, gralcompanias.nombre, tal_ot1.almacen, cast(tal_ot1.no_orden as char(15)) as no_orden, 
tal_ot1.nombre_cliente, tal_ot1.cliente, cast(tal_ot1.numero_factura as char(15)) as numero_factura, tal_ot1.fecha as fecha_ot,
tal_ot2.fecha_despacho as fecha, eys2.articulo, sum(invmotivos.signo*eys2.cantidad) as cantidad, 
sum(invmotivos.signo*eys2.costo) as costo, eys1.aplicacion_origen, articulos.desc_articulo
from gralcompanias, tal_ot1, tal_ot2, tal_ot2_eys2, eys2, almacen, invmotivos, eys1, articulos
where tal_ot1.almacen = almacen.almacen
and eys2.articulo = articulos.articulo
and eys1.motivo = invmotivos.motivo
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and almacen.compania = gralcompanias.compania
and tal_ot1.almacen = tal_ot2.almacen
and tal_ot1.tipo = tal_ot2.tipo
and tal_ot1.no_orden = tal_ot2.no_orden
and tal_ot2.almacen = tal_ot2_eys2.almacen
and tal_ot2.no_orden = tal_ot2_eys2.no_orden
and tal_ot2.tipo = tal_ot2_eys2.tipo
and tal_ot2.linea = tal_ot2_eys2.linea_tal_ot2
and tal_ot2.articulo = tal_ot2_eys2.articulo
and eys2.almacen = tal_ot2_eys2.almacen
and eys2.articulo = tal_ot2_eys2.articulo
and eys2.no_transaccion = tal_ot2_eys2.no_transaccion
and eys2.linea = tal_ot2_eys2.linea_eys2
group by almacen.compania, almacen.desc_almacen, gralcompanias.nombre, tal_ot1.almacen, tal_ot1.no_orden,
tal_ot1.nombre_cliente, tal_ot1.cliente, tal_ot1.numero_factura, 
tal_ot1.fecha,
tal_ot2.fecha_despacho, eys2.articulo, eys1.aplicacion_origen, articulos.desc_articulo
union
select almacen.compania, almacen.desc_almacen, gralcompanias.nombre, eys1.almacen, 
cast(cxpfact1.numero_oc as char(15)),
proveedores.nomb_proveedor, proveedores.proveedor, cxpfact1.fact_proveedor, eys1.fecha, eys1.fecha, eys2.articulo, 
eys2.cantidad*invmotivos.signo, invmotivos.signo*eys2.costo, eys1.aplicacion_origen,
articulos.desc_articulo
from gralcompanias, almacen, eys1, eys2, cxpfact1, invmotivos, proveedores, articulos
where gralcompanias.compania = almacen.compania
and cxpfact1.proveedor = proveedores.proveedor
and eys2.articulo = articulos.articulo
and eys1.motivo = invmotivos.motivo
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys2.compania = cxpfact1.compania
and eys2.proveedor = cxpfact1.proveedor
and eys2.almacen = almacen.almacen
and eys2.fact_proveedor = cxpfact1.fact_proveedor
union
select almacen.compania, almacen.desc_almacen, gralcompanias.nombre, eys1.almacen, cast(eys1.no_transaccion as char(15)),
null, null, cast(eys1.no_transaccion as char(15)), eys1.fecha, eys1.fecha, eys2.articulo, 
sum(eys2.cantidad*invmotivos.signo), sum(invmotivos.signo*eys2.costo), eys1.aplicacion_origen,
articulos.desc_articulo
from gralcompanias, almacen, eys1, eys2, invmotivos, articulos
where gralcompanias.compania = almacen.compania
and eys2.articulo = articulos.articulo
and eys1.motivo = invmotivos.motivo
and eys1.almacen = eys2.almacen
and eys2.almacen = almacen.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys2.proveedor is null
and eys1.aplicacion_origen = 'INV'
group by almacen.compania, almacen.desc_almacen, gralcompanias.nombre, eys1.almacen, eys1.no_transaccion,
eys1.no_transaccion, eys1.fecha, eys1.fecha, eys2.articulo, 
eys1.aplicacion_origen, articulos.desc_articulo
union
select almacen.compania, almacen.desc_almacen, gralcompanias.nombre, eys1.almacen, cast(eys1.no_transaccion as char(15)),
factura1.nombre_cliente, factura1.cliente, cast(factura1.num_documento as char(15)), factura1.fecha_factura,
eys1.fecha, eys2.articulo, sum(eys2.cantidad*invmotivos.signo), sum(invmotivos.signo*eys2.costo), 
eys1.aplicacion_origen, articulos.desc_articulo
from gralcompanias, almacen, factura1, factura2_eys2, eys2, eys1, invmotivos, articulos
where gralcompanias.compania = almacen.compania
and eys2.articulo = articulos.articulo
and eys1.motivo = invmotivos.motivo
and factura1.almacen = almacen.almacen
and factura1.almacen = factura2_eys2.almacen
and factura1.tipo = factura2_eys2.tipo
and factura1.num_documento = factura2_eys2.num_documento
and factura2_eys2.articulo = eys2.articulo
and factura2_eys2.almacen = eys2.almacen
and factura2_eys2.no_transaccion = eys2.no_transaccion
and factura2_eys2.eys2_linea = eys2.linea
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
group by almacen.compania, almacen.desc_almacen, gralcompanias.nombre, eys1.almacen, eys1.no_transaccion,
factura1.nombre_cliente, factura1.cliente, factura1.num_documento, factura1.fecha_factura,
eys1.fecha, eys2.articulo, eys1.aplicacion_origen, articulos.desc_articulo;



create view v_cgl_financiero_cglsldocuenta as
select cglsldocuenta.compania, gralcompanias.nombre,
cgl_financiero.no_informe, 
gralperiodos.inicio, cgl_financiero.d_fila, cglsldocuenta.cuenta, 
cglsldocuenta.debito, cglsldocuenta.credito, cglcuentas.nombre as d_cuenta
from cgl_financiero, cglsldocuenta, gralperiodos, gralcompanias, cglcuentas
where cgl_financiero.cuenta = cglsldocuenta.cuenta
and cglsldocuenta.compania = gralperiodos.compania
and cglsldocuenta.year = gralperiodos.year
and cglsldocuenta.periodo = gralperiodos.periodo
and gralperiodos.aplicacion = 'CGL'
and cglsldocuenta.compania = gralcompanias.compania
and cglsldocuenta.cuenta = cglcuentas.cuenta
and (cglsldocuenta.debito <> 0 or cglsldocuenta.credito <> 0);


create view v_cxpfact1_cglposteo as
select gralcompanias.compania, gralcompanias.nombre, proveedores.proveedor,
proveedores.nomb_proveedor, cxpfact1.fecha_posteo_fact_cxp, cxpfact1.fact_proveedor, 
trim(cxpfact1.obs_fact_cxp) as observacion, cxpfact1.usuario, gral_usuarios.nombre as nombre_d_usuario,
cglposteo.cuenta, cglcuentas.nombre as d_cuenta,
cglposteoaux1.auxiliar, cglposteo.debito, cglposteo.credito, 
((cglposteo.debito-cglposteo.credito)/Abs(cglposteo.debito-cglposteo.credito)) as signo
from gral_usuarios right outer join cxpfact1 on gral_usuarios.usuario = cxpfact1.usuario,
cglposteoaux1 RIGHT OUTER JOIN cglposteo ON cglposteoaux1.consecutivo = cglposteo.consecutivo,
gralcompanias, rela_cxpfact1_cglposteo, proveedores, cglcuentas
where gralcompanias.compania = cxpfact1.compania
and cxpfact1.compania = rela_cxpfact1_cglposteo.compania
and cxpfact1.proveedor = rela_cxpfact1_cglposteo.proveedor
and cxpfact1.fact_proveedor = rela_cxpfact1_cglposteo.fact_proveedor
and rela_cxpfact1_cglposteo.consecutivo = cglposteo.consecutivo
and proveedores.proveedor = cxpfact1.proveedor
and cglcuentas.cuenta = cglposteo.cuenta;




create view v_eys1_cglposteo as
select cglposteo.compania, gralcompanias.nombre, eys1.almacen, eys1.no_transaccion, 
eys1.motivo, invmotivos.desc_motivo, trim(eys1.observacion) as observacion,
cglposteo.cuenta, cglcuentas.nombre as d_cuenta, eys1.fecha,
cglposteoaux1.auxiliar, cglposteo.debito, cglposteo.credito, 
((cglposteo.debito-cglposteo.credito) / Abs(cglposteo.debito-cglposteo.credito)) as signo
from cglposteoaux1 RIGHT OUTER JOIN cglposteo ON cglposteoaux1.consecutivo = cglposteo.consecutivo,
eys1, rela_eys1_cglposteo, invmotivos, gralcompanias, cglcuentas
where cglposteo.compania = gralcompanias.compania
and cglposteo.cuenta = cglcuentas.cuenta
and cglposteo.consecutivo = rela_eys1_cglposteo.consecutivo
and eys1.motivo = invmotivos.motivo
and eys1.almacen = rela_eys1_cglposteo.almacen
and eys1.no_transaccion = rela_eys1_cglposteo.no_transaccion;



create view v_afi_trx_cglposteo as
select cglposteo.compania, gralcompanias.nombre, afi_trx1.codigo, activos.descripcion, afi_trx1.observacion, afi_trx1.no_trx, cglposteo.fecha_comprobante, 
cglposteo.cuenta, trim(cglcuentas.nombre) as d_cuenta, cglposteoaux1.auxiliar, cglposteo.debito, cglposteo.credito, 
((cglposteo.debito-cglposteo.credito)/ Abs(cglposteo.debito-cglposteo.credito)) as signo
from cglposteoaux1 RIGHT OUTER JOIN cglposteo ON cglposteoaux1.consecutivo = cglposteo.consecutivo,
rela_afi_trx1_cglposteo, afi_trx1, gralcompanias, activos, cglcuentas
where rela_afi_trx1_cglposteo.consecutivo = cglposteo.consecutivo
and rela_afi_trx1_cglposteo.compania = afi_trx1.compania
and rela_afi_trx1_cglposteo.no_trx = afi_trx1.no_trx
and cglposteo.compania = gralcompanias.compania
and activos.compania = afi_trx1.compania
and activos.codigo = afi_trx1.codigo
and cglposteo.cuenta = cglcuentas.cuenta;



create view v_factura1_cglposteo as
select cglposteo.compania, rela_factura1_cglposteo.almacen, rela_factura1_cglposteo.caja, rela_factura1_cglposteo.tipo,
rela_factura1_cglposteo.num_documento, cglposteo.consecutivo, cglposteo.cuenta, 
cglposteo.debito, cglposteo.credito
from rela_factura1_cglposteo, cglposteo
where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo;


create view v_cxcdocm_fac_fiscal as
select factura1.almacen as almacen, trim(factura1.caja) as caja,
factura1.cliente as cliente, 
trim(to_char(factura1.num_documento, '9999999999')) as documento,
trim(to_char(factura1.num_documento, '9999999999')) as docmto_aplicar,
factura1.tipo as motivo_cxc, 
trim(factura1.almacen_aplica) as almacen_ref,
trim(factura1.caja_aplica) as caja_ref,
trim(to_char(factura1.num_documento, '9999999999')) as docmto_ref,
factura1.tipo as motivo_ref, 
factura1.fecha_factura as fecha_posteo, 
factura1.fecha_factura as fecha_docmto,
factura1.fecha_vencimiento as fecha_vmto, 
trim(factura1.observacion) as obs_docmto,
factura1.no_referencia as referencia, 'FAC' as aplicacion_origen, 
-sum(factura4.monto * rubros_fact_cxc.signo_rubro_fact_cxc * factmotivos.signo) as monto 
from factura1, factmotivos, factura4, rubros_fact_cxc, gral_forma_de_pago, clientes, cglcuentas
where factura1.tipo = factmotivos.tipo 
and factmotivos.factura_fiscal = 'S'
and factura1.cliente = clientes.cliente
and clientes.cuenta = cglcuentas.cuenta
and cglcuentas.naturaleza = 1
and cglcuentas.tipo_cuenta = 'B'
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and gral_forma_de_pago.dias > 0
and factura1.status <> 'A'
and factura1.almacen = factura4.almacen 
and factura1.tipo = factura4.tipo
and factura1.caja = factura4.caja
and factura1.num_documento = factura4.num_documento
and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
and factura1.tipo <> 'DA'
group by factura1.almacen_aplica, factura1.caja_aplica, factura1.almacen, factura1.caja, factura1.cliente, factura1.num_documento,
factura1.tipo, factura1.fecha_factura, factura1.fecha_vencimiento, factura1.observacion,
factura1.no_referencia
union
select factura1.almacen as almacen, factura1.caja, factura1.cliente as cliente, 
trim(to_char(factura1.num_documento, '9999999999')) as documento,
trim(to_char(factura1.num_factura, '9999999999')) as docmto_aplicar,
factura1.tipo as motivo_cxc, 
trim(factura1.almacen_aplica) as almacen_ref,
trim(factura1.caja_aplica) as caja_ref,
trim(to_char(factura1.num_factura, '9999999999')) as docmto_ref,
trim(factura1.tipo_aplica) as motivo_ref, 
factura1.fecha_factura as fecha_posteo, 
factura1.fecha_factura as fecha_docmto,
factura1.fecha_vencimiento as fecha_vmto, trim(factura1.observacion) as obs_docmto,
factura1.no_referencia as referencia, 'FAC' as aplicacion_origen, 
sum(factura4.monto * rubros_fact_cxc.signo_rubro_fact_cxc * factmotivos.signo) as monto 
from factura1, factmotivos, factura4, rubros_fact_cxc, gral_forma_de_pago, clientes, cglcuentas
where factura1.tipo = factmotivos.tipo 
and factura1.cliente = clientes.cliente
and clientes.cuenta = cglcuentas.cuenta
and cglcuentas.naturaleza = 1
and cglcuentas.tipo_cuenta = 'B'
and factmotivos.devolucion = 'S'
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and gral_forma_de_pago.dias > 0
and factura1.status <> 'A'
and factura1.almacen = factura4.almacen 
and factura1.tipo = factura4.tipo
and factura1.caja = factura4.caja
and factura1.num_documento = factura4.num_documento
and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
and factura1.num_factura <> 0
and factura1.tipo <> 'DA'
and exists
    (select * from factura1 a
        where a.almacen = factura1.almacen_aplica
        and a.caja = factura1.caja_aplica
        and a.tipo = factura1.tipo_aplica
        and a.num_documento = factura1.num_factura
        and a.cliente = factura1.cliente)
group by factura1.almacen_aplica, factura1.caja_aplica, factura1.tipo_aplica, factura1.almacen, factura1.caja, factura1.cliente, factura1.num_documento,
factura1.tipo, factura1.fecha_factura, factura1.fecha_vencimiento, factura1.observacion,
factura1.no_referencia, factura1.num_factura;


create view v_cxcdocm_fac as
select factura1.almacen as almacen, trim(factura1.caja) as caja, factura1.cliente as cliente, 
trim(to_char(factura1.num_documento, '9999999999')) as documento,
trim(to_char(factura1.num_documento, '9999999999')) as docmto_aplicar,
factura1.tipo as motivo_cxc, 
trim(to_char(factura1.num_documento, '9999999999')) as docmto_ref,
factura1.tipo as motivo_ref, 
factura1.fecha_factura as fecha_posteo, 
factura1.fecha_factura as fecha_docmto,
factura1.fecha_vencimiento as fecha_vmto, trim(factura1.observacion) as obs_docmto,
factura1.no_referencia as referencia, 'FAC' as aplicacion_origen, 
-sum(factura4.monto * rubros_fact_cxc.signo_rubro_fact_cxc * factmotivos.signo) as monto 
from factura1, factmotivos, factura4, rubros_fact_cxc, gral_forma_de_pago, clientes, cglcuentas
where factura1.tipo = factmotivos.tipo 
and factmotivos.factura = 'S' 
and factura1.cliente = clientes.cliente
and clientes.cuenta = cglcuentas.cuenta
and cglcuentas.naturaleza = 1
and cglcuentas.tipo_cuenta = 'B'
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and gral_forma_de_pago.dias > 0
and factura1.status <> 'A'
and factura1.almacen = factura4.almacen 
and factura1.tipo = factura4.tipo
and factura1.caja = factura4.caja
and factura1.num_documento = factura4.num_documento
and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
and factura1.tipo <> 'DA'
group by factura1.almacen, factura1.caja, factura1.cliente, factura1.num_documento,
factura1.tipo, factura1.fecha_factura, factura1.fecha_vencimiento, factura1.observacion,
factura1.no_referencia
union
select factura1.almacen as almacen, factura1.caja, factura1.cliente as cliente, 
trim(to_char(factura1.num_documento, '9999999999')) as documento,
trim(to_char(factura1.num_factura, '9999999999')) as docmto_aplicar,
factura1.tipo as motivo_cxc, 
trim(to_char(factura1.num_factura, '9999999999')) as docmto_ref,
(select tipo from factmotivos where factura = 'S') as motivo_ref, 
factura1.fecha_factura as fecha_posteo, 
factura1.fecha_factura as fecha_docmto,
factura1.fecha_vencimiento as fecha_vmto, trim(factura1.observacion) as obs_docmto,
factura1.no_referencia as referencia, 'FAC' as aplicacion_origen, 
sum(factura4.monto * rubros_fact_cxc.signo_rubro_fact_cxc * factmotivos.signo) as monto 
from factura1, factmotivos, factura4, rubros_fact_cxc, gral_forma_de_pago, clientes, cglcuentas
where factura1.tipo = factmotivos.tipo 
and factura1.cliente = clientes.cliente
and clientes.cuenta = cglcuentas.cuenta
and cglcuentas.naturaleza = 1
and cglcuentas.tipo_cuenta = 'B'
and (factmotivos.devolucion = 'S' or factmotivos.nota_credito = 'S')
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and gral_forma_de_pago.dias > 0
and factura1.status <> 'A'
and factura1.almacen = factura4.almacen 
and factura1.tipo = factura4.tipo
and factura1.caja = factura4.caja
and factura1.num_documento = factura4.num_documento
and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
and factura1.num_factura <> 0
and factura1.tipo <> 'DA'
and exists
    (select * from factura1 a
        where a.almacen = factura1.almacen
        and a.tipo in (select tipo from factmotivos where factura = 'S')
        and a.num_documento = factura1.num_factura
        and a.caja = factura1.caja
        and a.cliente = factura1.cliente)
group by factura1.almacen, factura1.caja, factura1.cliente, factura1.num_documento,
factura1.tipo, factura1.fecha_factura, factura1.fecha_vencimiento, factura1.observacion,
factura1.no_referencia, factura1.num_factura
union
select factura1.almacen as almacen, factura1.caja, factura1.cliente as cliente, 
trim(to_char(factura1.num_documento, '9999999999')) as documento,
trim(to_char(factura1.num_documento, '9999999999')) as docmto_aplicar,
factura1.tipo as motivo_cxc, 
trim(to_char(factura1.num_documento, '9999999999')) as docmto_ref,
factura1.tipo as motivo_ref, 
factura1.fecha_factura as fecha_posteo, 
factura1.fecha_factura as fecha_docmto,
factura1.fecha_vencimiento as fecha_vmto, trim(factura1.observacion) as obs_docmto,
factura1.no_referencia as referencia, 'FAC' as aplicacion_origen, 
sum(factura4.monto * rubros_fact_cxc.signo_rubro_fact_cxc * factmotivos.signo) as monto 
from factura1, factmotivos, factura4, rubros_fact_cxc, gral_forma_de_pago,
clientes, cglcuentas
where factura1.tipo = factmotivos.tipo 
and (factmotivos.devolucion = 'S' or factmotivos.nota_credito = 'S')
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and factura1.cliente = clientes.cliente
and clientes.cuenta = cglcuentas.cuenta
and cglcuentas.naturaleza = 1
and cglcuentas.tipo_cuenta = 'B'
and gral_forma_de_pago.dias > 0
and factura1.status <> 'A'
and factura1.almacen = factura4.almacen 
and factura1.tipo = factura4.tipo
and factura1.caja = factura4.caja
and factura1.num_documento = factura4.num_documento
and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
and factura1.num_factura = 0
and factura1.tipo <> 'DA'
group by factura1.almacen, factura1.caja, factura1.cliente, factura1.num_documento,
factura1.tipo, factura1.fecha_factura, factura1.fecha_vencimiento, factura1.observacion,
factura1.no_referencia, factura1.num_factura;

/*
esta condicion la quite para el caso de express....cuando termine ponerla nuevamente
and factura1.fecha_factura <= '2013-12-31'
*/

/*
union
select factura1.almacen as almacen, factura1.cliente as cliente, 
trim(to_char(factura1.num_documento, '9999999999')) as documento,
trim(to_char(factura1.num_documento, '9999999999')) as docmto_aplicar,
factura1.tipo as motivo_cxc, 
trim(to_char(factura1.num_documento, '9999999999')) as docmto_ref,
factura1.tipo as motivo_ref, 
factura1.fecha_factura as fecha_posteo, 
factura1.fecha_factura as fecha_docmto,
factura1.fecha_vencimiento as fecha_vmto, trim(factura1.observacion) as obs_docmto,
factura1.no_referencia as referencia, 'FAC' as aplicacion_origen, 
sum(factura4.monto * rubros_fact_cxc.signo_rubro_fact_cxc * factmotivos.signo) as monto 
from factura1, factmotivos, factura4, rubros_fact_cxc, gral_forma_de_pago
where factura1.tipo = factmotivos.tipo and factmotivos.nota_credito = 'S' 
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and gral_forma_de_pago.dias > 0
and factura1.status <> 'A'
and factura1.almacen = factura4.almacen 
and factura1.tipo = factura4.tipo
and factura1.num_documento = factura4.num_documento
and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
and factura1.num_factura = 0
group by factura1.almacen, factura1.cliente, factura1.num_documento,
factura1.tipo, factura1.fecha_factura, factura1.fecha_vencimiento, factura1.observacion,
factura1.no_referencia, factura1.num_factura;
*/

create view v_cxpdocm as
select cxpfact1.compania, cxpfact1.proveedor, cxpfact1.fact_proveedor as documento, 
cxpfact1.fact_proveedor as docmto_aplicar, cxpfact1.motivo_cxp, 
cxpfact1.motivo_cxp as motivo_cxp_ref,
cxpfact1.aplicacion_origen, cxpfact1.fecha_posteo_fact_cxp as fecha_posteo, 
cxpfact1.vence_fact_cxp as fecha_vencimiento, sum(cxpfact2.monto*rubros_fact_cxp.signo_rubro_fact_cxp) as monto, 
cxpfact1.usuario, trim(cxpfact1.obs_fact_cxp) as obs_docmto
from cxpfact1, cxpfact2, rubros_fact_cxp, cxpmotivos, proveedores, cglcuentas, gral_forma_de_pago
where cxpfact1.forma_pago = gral_forma_de_pago.forma_pago
and gral_forma_de_pago.dias > 0
and cxpfact1.proveedor = cxpfact2.proveedor and cxpfact1.fact_proveedor = cxpfact2.fact_proveedor 
and cxpfact1.compania = cxpfact2.compania and cxpfact2.rubro_fact_cxp = rubros_fact_cxp.rubro_fact_cxp 
and cxpfact1.motivo_cxp = cxpmotivos.motivo_cxp and cxpfact1.proveedor = proveedores.proveedor 
and proveedores.cuenta = cglcuentas.cuenta and cglcuentas.naturaleza = -1 and cxpmotivos.factura = 'S'
group by cxpfact1.proveedor, cxpfact1.compania, cxpfact1.fact_proveedor, cxpfact1.motivo_cxp, 
cxpfact1.aplicacion_origen, fecha_posteo, cxpfact1.vence_fact_cxp, cxpfact1.usuario, cxpfact1.obs_fact_cxp
union
select bcoctas.compania, bcocheck1.proveedor, trim(to_char(bcocheck1.no_cheque, '9999999999')),
bcocheck3.aplicar_a, bcomotivos.motivo_cxp, bcocheck3.motivo_cxp, 'BCO',
bcocheck1.fecha_posteo, bcocheck1.fecha_posteo, bcocheck3.monto, bcocheck1.usuario, 
case when bcocheck1.proveedor is null then trim(bcocheck1.en_concepto_de) else 
(select trim(obs_docmto) from cxpdocm where cxpdocm.proveedor = bcocheck1.proveedor
and cxpdocm.compania = bcoctas.compania
and cxpdocm.documento = bcocheck3.aplicar_a
and cxpdocm.docmto_aplicar = bcocheck3.aplicar_a
and cxpdocm.motivo_cxp = bcocheck3.motivo_cxp) end
from bcocheck1, bcocheck3, bcoctas, bcomotivos, cxpdocm
where bcocheck1.cod_ctabco = bcocheck3.cod_ctabco 
and bcocheck1.no_cheque = bcocheck3.no_cheque 
and bcocheck1.motivo_bco = bcocheck3.motivo_bco 
and bcocheck1.cod_ctabco = bcoctas.cod_ctabco 
and bcocheck1.motivo_bco = bcomotivos.motivo_bco and bcocheck1.status <> 'A' 
and cxpdocm.compania = bcoctas.compania and cxpdocm.proveedor = bcocheck1.proveedor 
and cxpdocm.documento = bcocheck3.aplicar_a and cxpdocm.docmto_aplicar = bcocheck3.aplicar_a 
and cxpdocm.motivo_cxp = bcocheck3.motivo_cxp and bcomotivos.aplica_cheques = 'S' 
and bcocheck1.proveedor is not null and bcocheck3.monto <> 0
and bcomotivos.motivo_cxp is not null
union
select bcoctas.compania, bcotransac1.proveedor, bcotransac1.no_docmto,
bcotransac3.aplicar_a, bcomotivos.motivo_cxp, bcotransac3.motivo_cxp, 'BCO',
bcotransac1.fecha_posteo, bcotransac1.fecha_posteo, bcotransac3.monto,
bcotransac1.usuario, trim(bcotransac1.obs_transac_bco)
from bcotransac1, bcotransac3, bcoctas, cxpdocm, bcomotivos
where bcotransac1.cod_ctabco = bcotransac3.cod_ctabco
and bcotransac1.sec_transacc = bcotransac3.sec_transacc
and bcotransac1.cod_ctabco = bcoctas.cod_ctabco
and cxpdocm.compania = bcoctas.compania
and cxpdocm.proveedor = bcotransac1.proveedor
and trim(cxpdocm.documento) = trim(bcotransac3.aplicar_a)
and trim(cxpdocm.docmto_aplicar) = trim(bcotransac3.aplicar_a)
and cxpdocm.motivo_cxp = bcotransac3.motivo_cxp 
and bcotransac1.proveedor is not null
and bcotransac1.motivo_bco = bcomotivos.motivo_bco
and bcomotivos.motivo_cxp is not null
union
select cxpajuste1.compania, cxpajuste1.proveedor, cxpajuste1.docm_ajuste_cxp, 
cxpajuste1.docm_ajuste_cxp, cxpajuste1.motivo_cxp, cxpajuste1.motivo_cxp, 'CXP',
cxpajuste1.fecha_posteo_ajuste_cxp, cxpajuste1.fecha_posteo_ajuste_cxp, 
sum(cxpajuste3.monto), current_user, trim(cxpajuste1.obs_ajuste_cxp)
from cxpajuste1, cxpajuste3, proveedores, cglcuentas
where cxpajuste1.proveedor = proveedores.proveedor
and proveedores.cuenta = cglcuentas.cuenta
and cxpajuste1.compania = cxpajuste3.compania 
and cxpajuste1.sec_ajuste_cxp = cxpajuste3.sec_ajuste_cxp 
and cglcuentas.naturaleza = -1
and not exists 
(select * from cxpajuste2 
where cxpajuste2.compania = cxpajuste1.compania 
and cxpajuste2.sec_ajuste_cxp = cxpajuste1.sec_ajuste_cxp
and cxpajuste2.monto <> 0)
group by cxpajuste1.compania, cxpajuste1.proveedor, cxpajuste1.docm_ajuste_cxp,
cxpajuste1.motivo_cxp, cxpajuste1.fecha_posteo_ajuste_cxp,
cxpajuste1.obs_ajuste_cxp
union
select cxpajuste1.compania, cxpajuste1.proveedor, cxpajuste1.docm_ajuste_cxp,
cxpajuste2.aplicar_a, cxpajuste1.motivo_cxp, 
cxpajuste2.motivo_cxp, 'CXP', cxpajuste1.fecha_posteo_ajuste_cxp, 
cxpajuste1.fecha_posteo_ajuste_cxp, sum(cxpajuste2.monto), 
current_user, trim(cxpajuste1.obs_ajuste_cxp)
from cxpajuste1, cxpajuste2, cxpdocm, proveedores, cglcuentas
where cxpajuste1.proveedor = proveedores.proveedor
and proveedores.cuenta = cglcuentas.cuenta
and cglcuentas.naturaleza = -1
and cxpajuste1.compania = cxpajuste2.compania 
and cxpajuste1.sec_ajuste_cxp = cxpajuste2.sec_ajuste_cxp 
and cxpajuste1.compania = cxpdocm.compania 
and cxpajuste1.proveedor = cxpdocm.proveedor 
and cxpajuste2.aplicar_a = cxpdocm.documento 
and cxpajuste2.aplicar_a = cxpdocm.docmto_aplicar 
and cxpajuste2.motivo_cxp = cxpdocm.motivo_cxp
and cxpajuste2.monto <> 0
and cxpajuste1.status <> 'A'
group by cxpajuste1.compania, cxpajuste1.proveedor, cxpajuste1.docm_ajuste_cxp,
cxpajuste2.aplicar_a, cxpajuste1.motivo_cxp, 
cxpajuste2.motivo_cxp, cxpajuste1.fecha_posteo_ajuste_cxp, trim(cxpajuste1.obs_ajuste_cxp)
union
select compania, proveedor, factura, factura, motivo_cxp, motivo_cxp, 'CXP',
fecha, fecha, sum(saldo), current_user, null from cxp_saldos_iniciales
group by compania, proveedor, factura, motivo_cxp, fecha
union
select adc_manifiesto.compania, navieras.proveedor, trim(adc_master.container),
trim(adc_master.container), 
(select motivo_cxp from cxpmotivos where factura = 'S'), 
(select motivo_cxp from cxpmotivos where factura = 'S'), 
'CXP',
adc_manifiesto.fecha, adc_manifiesto.fecha, 
sum(f_adc_master_cargo(adc_manifiesto.compania, adc_manifiesto.consecutivo, adc_master.linea_master)),
current_user, trim(adc_master.no_bill) || ' / ' || trim(adc_manifiesto.no_referencia)
from navieras, adc_manifiesto, adc_master, proveedores, cglcuentas
where navieras.proveedor = proveedores.proveedor
and proveedores.cuenta = cglcuentas.cuenta
and cglcuentas.naturaleza = -1
and navieras.cod_naviera = adc_manifiesto.cod_naviera
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
group by adc_manifiesto.compania, navieras.proveedor, adc_master.container,
adc_manifiesto.fecha, cargo_prepago, adc_master.no_bill, adc_manifiesto.no_referencia
union
select compania, proveedor, factura, factura, motivo_cxp, motivo_cxp, 'CXP',
fecha, fecha, sum(saldo), current_user, null 
from cxp_saldos_iniciales
group by compania, proveedor, factura, motivo_cxp, fecha
union
select adc_cxp_1.compania, case when adc_cxp_1.proveedor is null then trim(navieras.proveedor) else 
trim(adc_cxp_1.proveedor) end,
adc_cxp_1.documento,
adc_cxp_1.documento, adc_cxp_1.motivo_cxp, adc_cxp_1.motivo_cxp,
'CXP', adc_cxp_1.fecha, adc_cxp_1.fecha, adc_cxp_1.monto, current_user,
trim(adc_cxp_1.observacion) as observacion
from adc_manifiesto, navieras, adc_cxp_1, proveedores, cglcuentas
where adc_cxp_1.proveedor = proveedores.proveedor
and proveedores.cuenta = cglcuentas.cuenta
and cglcuentas.naturaleza = -1
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.compania = adc_cxp_1.compania
and adc_manifiesto.consecutivo = adc_cxp_1.consecutivo
and adc_cxp_1.status <> 'A';




create view v_cgl_financiero_x_cuenta as
select  cglsldocuenta.compania, cgl_financiero.no_informe, cglsldocuenta.year, 
cglsldocuenta.periodo, Trim(cglsldocuenta.cuenta) as cuenta, 
trim(cglcuentas.nombre) as nombre_cuenta, Trim(cgl_financiero.d_fila) as d_fila, 
Sum(cglsldocuenta.debito-cglsldocuenta.credito) as corriente, 
Sum(cglsldocuenta.balance_inicio+cglsldocuenta.debito-cglsldocuenta.credito) as acumulado
from cglsldocuenta, cgl_financiero, cglcuentas
where cglsldocuenta.cuenta = cgl_financiero.cuenta
and cgl_financiero.cuenta = cglcuentas.cuenta
group by 1, 2, 3, 4, 5, 6, 7;


create view v_cglposteo as
select compania, year, periodo, cglposteo.cuenta, 
trim(cglcuentas.nombre) as nombre_cuenta, 
sum(debito) as debito, sum(credito) as credito, sum(debito-credito) as monto
from cglposteo, cglcuentas
where cglposteo.cuenta = cglcuentas.cuenta
group by 1, 2, 3, 4, 5;

create view v_cglsldoaux1 as
select cglposteo.compania, cglposteo.cuenta, 
cglposteoaux1.auxiliar, 
cglposteo.year, cglposteo.periodo, 
sum(cglposteoaux1.debito) as debito, 
sum(cglposteoaux1.credito) as credito
from cglposteo, cglposteoaux1
where cglposteo.consecutivo = cglposteoaux1.consecutivo
and (cglposteoaux1.debito <> 0 or cglposteoaux1.credito <> 0)
group by 1, 2, 3, 4, 5;




create view v_f_conytram as
select f_conytram.tipo, almacen, no_documento as num_documento, 
trim(cast(no_documento as char(10))) as documento, 
clientes.cliente, fecha_factura, Anio(fecha_factura) as anio, Mes(fecha_factura) as mes, 
monto_manejo * factmotivos.signo as manejo, 
monto_documentacion*factmotivos.signo as confeccion, 
(otros_ingresos1*factmotivos.signo) as sellos, 
(otros_ingresos2*factmotivos.signo) as manejo_documentacion, 
(otros_ingresos3*factmotivos.signo) as tramites, 
(otros_ingresos4*factmotivos.signo) as otros_ingresos, 
(valor_x_linea*factmotivos.signo) as valor_x_linea, 
(monto_cod1+monto_cod2+monto_cod3)*factmotivos.signo as cod, 
monto_aduana*factmotivos.signo as aduana, monto_acarreo*factmotivos.signo as acarreo, itbms*factmotivos.signo as itbms,
(otros_servicios*factmotivos.signo) as otros_servicios,
(otros_servicios+monto_manejo+monto_documentacion+otros_ingresos1+otros_ingresos2+otros_ingresos3+otros_ingresos4+monto_cod1+monto_cod2+monto_cod3+monto_aduana+monto_acarreo+valor_x_linea+itbms+cair)*factmotivos.signo as total,
clientes.nomb_cliente as nombre_cliente, f_conytram.cair*factmotivos.signo as cair
from f_conytram, clientes, factmotivos
where f_conytram.cliente = clientes.cliente 
and f_conytram.tipo = factmotivos.tipo
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' 
or factmotivos.nota_credito = 'S')
and f_conytram.status <> 'A'
and not exists
    (select * from factura1
        where factura1.almacen = f_conytram.almacen
        and factura1.tipo = '8'
        and factura1.num_factura = f_conytram.no_documento);


create view v_pla_reservas_x_departamento as
select nomctrac.compania, nomtpla2.dia_d_pago, rhuempl.departamento, pla_reservas.concepto_reserva,
pla_afectacion_contable.cuenta, sum(nomctrac.monto*nomconce.signo) as base,
sum(pla_reservas.monto) as reserva
from rhuempl, pla_afectacion_contable, nomconce, nomtpla2, nomctrac, pla_reservas
where nomctrac.codigo_empleado = pla_reservas.codigo_empleado
and nomctrac.compania = pla_reservas.compania
and nomctrac.tipo_calculo = pla_reservas.tipo_calculo
and nomctrac.cod_concepto_planilla = pla_reservas.cod_concepto_planilla
and nomctrac.tipo_planilla = pla_reservas.tipo_planilla
and nomctrac.numero_planilla = pla_reservas.numero_planilla
and nomctrac.year = pla_reservas.year
and nomctrac.numero_documento = pla_reservas.numero_documento
and nomctrac.tipo_planilla = nomtpla2.tipo_planilla
and nomctrac.numero_planilla = nomtpla2.numero_planilla
and nomctrac.year = nomtpla2.year
and rhuempl.compania = nomctrac.compania
and rhuempl.codigo_empleado = nomctrac.codigo_empleado
and pla_afectacion_contable.departamento = rhuempl.departamento
and pla_afectacion_contable.cod_concepto_planilla = pla_reservas.concepto_reserva
and nomctrac.cod_concepto_planilla = nomconce.cod_concepto_planilla
group by 1, 2, 3, 4, 5;



create view v_pla_historial as
SELECT nomctrac.compania, nomctrac.codigo_empleado, nomtpla2.dia_d_pago AS fecha,
nomctrac.cod_concepto_planilla,  nom_tipo_de_calculo.descripcion, 
sum(nomctrac.monto * nomconce.signo) AS monto 
FROM nomctrac, nomconce, nom_tipo_de_calculo, nomtpla2
WHERE nomctrac.tipo_planilla = nomtpla2.tipo_planilla
AND nomctrac.numero_planilla = nomtpla2.numero_planilla
AND nomctrac.year = nomtpla2.year
AND nomctrac.cod_concepto_planilla = nomconce.cod_concepto_planilla
AND nomctrac.tipo_calculo = nom_tipo_de_calculo.tipo_calculo
GROUP BY nomctrac.compania, nomctrac.codigo_empleado, nomtpla2.dia_d_pago,
nomctrac.cod_concepto_planilla,  nom_tipo_de_calculo.descripcion
UNION 
SELECT pla_preelaborada.compania, pla_preelaborada.codigo_empleado, pla_preelaborada.fecha,
pla_preelaborada.cod_concepto_planilla, 'SALARIOS' AS descripcion, 
sum(pla_preelaborada.monto * nomconce.signo) AS monto 
FROM pla_preelaborada, nomconce
WHERE pla_preelaborada.cod_concepto_planilla = nomconce.cod_concepto_planilla
GROUP BY pla_preelaborada.compania, pla_preelaborada.codigo_empleado, pla_preelaborada.fecha,
pla_preelaborada.cod_concepto_planilla
union
SELECT pla_riesgos_profesionales.compania, pla_riesgos_profesionales.codigo_empleado, pla_riesgos_profesionales.hasta AS fecha, 
'100', 'RIESGOS PROF.' as descripcion, sum(pla_riesgos_profesionales.monto)
FROM pla_riesgos_profesionales
GROUP BY pla_riesgos_profesionales.compania, pla_riesgos_profesionales.codigo_empleado, pla_riesgos_profesionales.hasta;


CREATE VIEW v_comprobante_de_pago AS
    SELECT rhuempl.compania, rhuempl.codigo_empleado, 
    rhuempl.nombre_del_empleado, gralcompanias.nombre, 
    nomtpla2.desde, nomtpla2.hasta, nomtpla.descrip_tplanilla, 
    rhucargo.descripcion_cargo, departamentos.descripcion AS d_departamento, 
    rhuempl.numero_cedula, rhuempl.numero_ss, rhuempl.tasaporhora, 
    rhuempl.grup_impto_renta, rhuempl.num_dependiente, 
    nom_tipo_de_calculo.descripcion AS d_calculo, 
    nomctrac.tipo_calculo, nomctrac.tipo_planilla, nomctrac.numero_planilla, 
    nomctrac.year, nomtpla2.dia_d_pago 
FROM rhuempl, gralcompanias, nomctrac, nomtpla2, nomtpla, rhucargo, departamentos, nom_tipo_de_calculo 
WHERE gralcompanias.compania = rhuempl.compania 
AND nomctrac.codigo_empleado = rhuempl.codigo_empleado 
AND nomctrac.compania = rhuempl.compania
AND nomtpla2.tipo_planilla = nomctrac.tipo_planilla
AND nomtpla2.numero_planilla = nomctrac.numero_planilla
AND nomtpla2.year = nomctrac.year
AND nomtpla2.tipo_planilla = nomtpla.tipo_planilla
AND rhuempl.codigo_cargo = rhucargo.codigo_cargo
AND departamentos.codigo = rhuempl.departamento
AND nom_tipo_de_calculo.tipo_calculo = nomctrac.tipo_calculo
GROUP BY rhuempl.compania, rhuempl.codigo_empleado, rhuempl.nombre_del_empleado, 
gralcompanias.nombre, nomtpla2.desde, nomtpla2.hasta, nomtpla.descrip_tplanilla, 
rhucargo.descripcion_cargo, departamentos.descripcion, rhuempl.numero_cedula, 
rhuempl.numero_ss, rhuempl.tasaporhora, rhuempl.grup_impto_renta, 
rhuempl.num_dependiente, nom_tipo_de_calculo.descripcion, nomctrac.tipo_calculo, 
nomctrac.tipo_planilla, nomctrac.numero_planilla, nomctrac.year, nomtpla2.dia_d_pago;

create view v_cxc_empleados_saldos as
select rhuempl.compania, gralcompanias.nombre, cglposteo.cuenta, rhuempl.codigo_empleado, 
rhuempl.nombre_del_empleado, rhuempl.tipo_planilla,
sum(cglposteoaux1.debito - cglposteoaux1.credito) as saldo
from cglposteoaux1, cglposteo, rhuempl, gralcompanias
where cglposteoaux1.consecutivo = cglposteo.consecutivo
and cglposteo.compania = rhuempl.compania
and trim(cglposteoaux1.auxiliar) = trim(rhuempl.codigo_empleado)
and gralcompanias.compania = rhuempl.compania
group by 1, 2, 3, 4, 5, 6
having sum(cglposteoaux1.debito - cglposteoaux1.credito) <> 0;


create view v_cxc_empleados_detalle as
select gralcompanias.nombre, rhuempl.compania, cglposteo.cuenta, rhuempl.codigo_empleado, 
rhuempl.tipo_planilla, rhuempl.nombre_del_empleado,
cglposteo.fecha_comprobante, cglposteoaux1.debito, cglposteo.credito, nomtpla.descrip_tplanilla as d_tipo_planila
from cglposteoaux1, cglposteo, rhuempl, nomtpla, gralcompanias
where cglposteoaux1.consecutivo = cglposteo.consecutivo
and cglposteo.compania = rhuempl.compania
and trim(cglposteoaux1.auxiliar) = trim(rhuempl.codigo_empleado)
and rhuempl.tipo_planilla = nomtpla.tipo_planilla
and rhuempl.compania = gralcompanias.compania;

create view v_pla_acumulados as
SELECT nom_conceptos_para_calculo.cod_concepto_planilla, nomctrac.compania, 
nomctrac.codigo_empleado, nomtpla2.dia_d_pago AS fecha, nomtpla2.year as anio, 
nom_tipo_de_calculo.descripcion, 
sum(nomctrac.monto * nomconce.signo) AS monto 
FROM nomctrac, nomconce, nom_tipo_de_calculo, nomtpla2, nom_conceptos_para_calculo 
WHERE nomctrac.tipo_planilla = nomtpla2.tipo_planilla
AND nomctrac.numero_planilla = nomtpla2.numero_planilla
AND nomctrac.year = nomtpla2.year
AND nomctrac.cod_concepto_planilla = nomconce.cod_concepto_planilla
AND nomctrac.tipo_calculo = nom_tipo_de_calculo.tipo_calculo
AND nomctrac.cod_concepto_planilla = nom_conceptos_para_calculo.concepto_aplica
GROUP BY nom_conceptos_para_calculo.cod_concepto_planilla, nomctrac.compania, nomctrac.codigo_empleado, 
nomtpla2.dia_d_pago, nomtpla2.year, nom_tipo_de_calculo.descripcion
UNION 
SELECT nom_conceptos_para_calculo.cod_concepto_planilla, pla_preelaborada.compania, 
pla_preelaborada.codigo_empleado, pla_preelaborada.fecha, Anio(pla_preelaborada.fecha),
'SALARIOS' AS descripcion, 
sum(pla_preelaborada.monto * nomconce.signo) AS monto 
FROM pla_preelaborada, nomconce, nom_conceptos_para_calculo 
WHERE pla_preelaborada.cod_concepto_planilla = nomconce.cod_concepto_planilla
AND pla_preelaborada.cod_concepto_planilla = nom_conceptos_para_calculo.concepto_aplica
GROUP BY nom_conceptos_para_calculo.cod_concepto_planilla, pla_preelaborada.compania, 
pla_preelaborada.codigo_empleado, pla_preelaborada.fecha
union
SELECT nom_conceptos_para_calculo.cod_concepto_planilla,
pla_riesgos_profesionales.compania, 
pla_riesgos_profesionales.codigo_empleado, 
pla_riesgos_profesionales.hasta AS fecha, 
Anio(pla_riesgos_profesionales.hasta),
'RIESGOS PROF.' as descripcion, 
pla_riesgos_profesionales.monto 
FROM pla_riesgos_profesionales, nom_conceptos_para_calculo
where nom_conceptos_para_calculo.concepto_aplica = '210'
GROUP BY 1,pla_riesgos_profesionales.compania, 
pla_riesgos_profesionales.codigo_empleado, 
pla_riesgos_profesionales.hasta,
pla_riesgos_profesionales.monto;


create view v_tal_ot2_ot3 as
select articulos.desc_articulo, tal_ot2.articulo, null as nombre_del_empleado, 
null as codigo_empleado, articulos.servicio as servicio, tal_ot2.descripcion,   
tal_ot2.servicio as operacion, tal_ot2.almacen, tal_ot2.tipo, tal_ot2.no_orden,
sum(tal_ot2.cantidad) as cantidad, sum(tal_ot2.extension) as extension
from tal_ot2, articulos  
where tal_ot2.articulo = articulos.articulo
group by articulos.desc_articulo, tal_ot2.articulo,
articulos.servicio,
tal_ot2.descripcion,
tal_ot2.servicio,
tal_ot2.almacen,
tal_ot2.tipo,
tal_ot2.no_orden
union
select tal_servicios.descripcion, tal_ot3.servicio, rhuempl.nombre_del_empleado,   
tal_ot3.codigo_empleado, '1' as servicio, tal_ot3.observacion,   
tal_ot3.servicio as operacion, tal_ot3.almacen, tal_ot3.tipo, tal_ot3.no_orden,
sum(tal_ot3.horas), sum(tal_ot3.extension)
from tal_ot3, tal_servicios, rhuempl
where tal_servicios.servicio = tal_ot3.servicio
and rhuempl.codigo_empleado = tal_ot3.codigo_empleado
group by tal_servicios.descripcion, 
tal_ot3.servicio, 
rhuempl.nombre_del_empleado,   
tal_ot3.codigo_empleado, 
tal_ot3.observacion,   
tal_ot3.servicio,
tal_ot3.almacen,
tal_ot3.tipo,
tal_ot3.no_orden;


create view v_nomctrac_neto as
select compania, codigo_empleado, tipo_calculo, nomctrac.tipo_planilla,
nomctrac.numero_planilla, nomctrac.year, nomtpla2.dia_d_pago, sum(nomconce.signo*nomctrac.monto) as neto
from nomctrac, nomconce, nomtpla2
where nomctrac.cod_concepto_planilla = nomconce.cod_concepto_planilla
and nomctrac.tipo_planilla = nomtpla2.tipo_planilla
and nomctrac.numero_planilla = nomtpla2.numero_planilla
and nomctrac.year = nomtpla2.year
group by 1, 2, 3, 4, 5, 6, 7;

create view v_estado_d_resultado as
select c.compania, c.year, c.periodo, b.cuenta, b.nombre, 
-(c.debito-c.credito) as corriente, -(c.balance_inicio+c.debito-c.credito) as acumulado
from cglniveles a, cglcuentas b, cglsldocuenta c
where a.nivel = b.nivel
and b.cuenta = c.cuenta
and b.tipo_cuenta = 'R'
and a.recibe = 'S';

create view v_stock as
select almacen.compania, eys1.almacen, eys2.articulo, articulos.desc_articulo, 
sum(eys2.cantidad * invmotivos.signo) as existencia,
sum(eys2.costo * invmotivos.signo) as costo
from eys1, eys2, invmotivos, articulos, almacen
where eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys2.articulo = articulos.articulo
and eys1.almacen = almacen.almacen
group by 1, 2, 3, 4;

create view v_div_socios as
select div_libro_d_acciones.compania, div_socios.socio, div_socios.nombre1, 
sum(no_d_acciones) as no_d_acciones
from div_socios, div_libro_d_acciones
where div_socios.socio = div_libro_d_acciones.socio
and div_libro_d_acciones.status = 'A'
group by 1, 2, 3;

create view v_pla_horas_valorizadas_x_dia as
select nomhoras.compania, trim(rhuempl.nombre_del_empleado) as nombre, nomhoras.codigo_empleado, nomhoras.fecha_laborable,
nomtpla2.tipo_planilla, 
nomtpla2.year, nomtpla2.numero_planilla, nomhoras.tipodhora,
pla_rela_horas_conceptos.cod_concepto_planilla, 
trim(nomtipodehoras.descripcion) as tipo_de_hora,
nomtpla2.dia_d_pago,
nomtipodehoras.recargo,
nomtipodehoras.signo,
round(sum((nomhoras.horas + (nomhoras.minutos/60))*nomtipodehoras.signo), 2) as horas,
round((sum((nomhoras.horas + (nomhoras.minutos/60))*nomtipodehoras.signo)*avg(nomtipodehoras.recargo*nomhoras.tasaporhora)), 2) as monto
from nomtpla2, nomhoras, pla_rela_horas_conceptos, 
nomtipodehoras, rhuempl
where rhuempl.compania = nomhoras.compania
and rhuempl.codigo_empleado = nomhoras.codigo_empleado
and nomtpla2.tipo_planilla = nomhoras.tipo_planilla
and nomtpla2.numero_planilla = nomhoras.numero_planilla
and nomtpla2.year = nomhoras.year
and pla_rela_horas_conceptos.tipodhora = nomhoras.tipodhora
and nomtipodehoras.tipodhora = nomhoras.tipodhora
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13;

create view v_pla_horas_valorizadas as
select nomhoras.compania, nomhoras.codigo_empleado, nomtpla2.tipo_planilla, 
nomtpla2.year, nomtpla2.numero_planilla, nomhoras.tipodhora,
pla_rela_horas_conceptos.cod_concepto_planilla, 
nomtpla2.dia_d_pago,
nomtipodehoras.recargo,
round(sum((nomhoras.horas + (nomhoras.minutos/60))*nomtipodehoras.signo), 2) as horas,
round((sum((nomhoras.horas + (nomhoras.minutos/60))*nomtipodehoras.signo)*avg(nomtipodehoras.recargo*nomhoras.tasaporhora)), 2) as monto
from nomtpla2, nomhoras, pla_rela_horas_conceptos, nomtipodehoras
where nomtpla2.tipo_planilla = nomhoras.tipo_planilla
and nomtpla2.numero_planilla = nomhoras.numero_planilla
and nomtpla2.year = nomhoras.year
and pla_rela_horas_conceptos.tipodhora = nomhoras.tipodhora
and nomtipodehoras.tipodhora = nomhoras.tipodhora
group by 1, 2, 3, 4, 5, 6, 7, 8, 9;


create view v_oc1_oc2 as
select oc1.numero_oc, oc1.proveedor, oc1.compania, oc1.status,
oc1.fecha, oc2.articulo, oc2.cantidad, oc2.costo, 
(oc2.descuento) as descuento,
articulos.desc_articulo, gralcompanias.nombre, gralcompanias.telefono1,
gralcompanias.telefono2, gralcompanias.fax, gralcompanias.e_mail,
proveedores.nomb_proveedor, oc1.observacion, oc2.d_articulo, oc2.linea
from oc1, oc2, articulos, gralcompanias, proveedores
where oc1.compania = oc2.compania
and oc1.numero_oc = oc2.numero_oc
and articulos.articulo = oc2.articulo
and oc1.compania = gralcompanias.compania
and oc1.proveedor = proveedores.proveedor;


CREATE VIEW v_nomhoras AS
SELECT nomhoras.codigo_empleado, nomhoras.compania, nomhoras.tipo_planilla, 
    nomhoras.numero_planilla, nomhoras.tipodhora, nomhoras."year", nomhoras.tasaporhora, 
    (sum(nomhoras.horas) + sum((nomhoras.minutos / (60)::numeric))) AS horas 
FROM nomhoras 
GROUP BY nomhoras.codigo_empleado, nomhoras.compania, nomhoras.tipo_planilla, 
nomhoras.numero_planilla, nomhoras.tipodhora, nomhoras."year", nomhoras.tasaporhora;




create view v_nomctrac_x_cuenta as
select rhuempl.compania, nomtpla2.dia_d_pago, pla_afectacion_contable.cuenta,
sum(nomctrac.monto * nomconce.signo) as monto
from nomctrac, rhuempl, nomconce, pla_afectacion_contable, nomtpla2
where nomctrac.compania = rhuempl.compania
and nomctrac.codigo_empleado = rhuempl.codigo_empleado
and nomctrac.cod_concepto_planilla = nomconce.cod_concepto_planilla
and pla_afectacion_contable.departamento = rhuempl.departamento
and pla_afectacion_contable.cod_concepto_planilla = nomctrac.cod_concepto_planilla
and nomtpla2.tipo_planilla = nomctrac.tipo_planilla
and nomtpla2.numero_planilla = nomctrac.numero_planilla 
and nomtpla2.year = nomctrac.year
and nomtpla2.dia_d_pago >= '2014-01-01'
group by 1, 2, 3
order by 1, 2, 3;

create view v_factura1_factura2 as
select almacen.compania, factura1.almacen, factura1.cajero, factura1.tipo, factmotivos.descripcion,
factura1.num_documento, factura1.cliente, factura1.nombre_cliente, factura1.forma_pago,
gral_forma_de_pago.dias,
factura1.codigo_vendedor, almacen.desc_almacen,
Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes, factura1.fecha_factura,
factura1.fecha_despacho,
factura2.articulo, articulos.desc_articulo,
vendedores.nombre as nombre_del_vendedor,
fact_referencias.descripcion as referencia,
gralcompanias.nombre as nombre_de_cia,
articulos.orden_impresion,
f_factura1_ciudad(factura1.almacen, factura1.tipo, factura1.num_documento, factura1.caja) as ciudad,
(factura2.cantidad * factmotivos.signo) as cantidad,
(((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) as venta,
(((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) / factura2.cantidad) as precio,
((((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) - f_factura2_costo(factura2.almacen, factura2.caja, factura2.tipo,factura2.num_documento,factura2.linea,'COSTO')) as margen
from almacen, factura1, factura2, factmotivos, clientes, articulos, 
vendedores, gralcompanias, gral_forma_de_pago, fact_referencias
where factura1.referencia = fact_referencias.referencia
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and almacen.compania = gralcompanias.compania
and factura1.codigo_vendedor = vendedores.codigo
and almacen.almacen = factura1.almacen
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura1.tipo = factmotivos.tipo
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' or factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S')
and factura1.cliente = clientes.cliente
and factura2.articulo = articulos.articulo
and factura2.cantidad <> 0
and factura1.fecha_factura >= '2014-01-01'
and factura1.status <> 'A';

/*
create view v_fact_vtas_detalladas as
select d.linea, a.compania, a.almacen, c.num_documento, 
c.codigo_vendedor as vendedor, c.cliente, 
c.fecha_factura, Anio(c.fecha_factura) as anio, Mes(c.fecha_factura) as mes, c.forma_pago, 
d.articulo, (((d.precio*d.cantidad)-d.descuento_linea-d.descuento_global)*b.signo) as venta, 
(d.cantidad*b.signo) as cantidad
from almacen a, factmotivos b, factura1 c, factura2 d, articulos e
where a.almacen = c.almacen and b.tipo = c.tipo and c.almacen = d.almacen 
and c.tipo = d.tipo and c.num_documento = d.num_documento and d.articulo = e.articulo 
and ( b.factura = 'S' or b.devolucion = 'S' ) and c.status <> 'A' ;
*/


create view v_fact_vtas_detalladas as
select almacen.compania, factura1.almacen, factura1.tipo, factura1.num_documento, 
factura1.codigo_vendedor as vendedor, factura1.cliente, factura1.fecha_factura,
Anio(factura1.fecha_factura) as anio, Mes(factura1.fecha_factura) as mes,
factura1.forma_pago, factura2.linea, factura2.articulo, 
(((factura2.precio*factura2.cantidad)-factura2.descuento_linea-factura2.descuento_global)*factmotivos.signo) as venta, 
(factura2.cantidad*factmotivos.signo) as cantidad
from almacen, factmotivos, factura1, factura2, articulos
where almacen.almacen = factura1.almacen
and factmotivos.tipo = factura1.tipo
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura2.articulo = articulos.articulo
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' or factmotivos.devolucion = 'S' or factmotivos.nota_credito = 'S')
and factura1.status <> 'A';

create view v_fact_ventas_x_clase_detalladas as
select Anio(factura1.fecha_factura), Mes(factura1.fecha_factura), factura1.fecha_factura, factura1.num_documento,
gral_valor_grupos.desc_valor_grupo as descripcion, 
factura1.cliente, clientes.nomb_cliente,
(factura2.cantidad*convmedi.factor) as quintales,
((factura2.precio*factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global) as venta,
(((factura2.precio*factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global)/(factura2.cantidad*convmedi.factor)) as precio
from articulos, convmedi, factura1, factura2, clientes, articulos_agrupados, gral_valor_grupos, factmotivos
where gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and factura1.cliente = clientes.cliente
and factmotivos.tipo = factura1.tipo
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S')
and gral_valor_grupos.grupo = 'CLA'
and gral_valor_grupos.aplicacion = 'INV'
and articulos_agrupados.articulo = articulos.articulo
and articulos.unidad_medida = convmedi.old_unidad
and convmedi.new_unidad = '100LBS'
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura2.articulo = articulos.articulo
and factura2.cantidad <> 0
and factura1.status <> 'A'
order by 1, 2, 3, 4, 5;



create view v_fact_ventas_x_clase as
select Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes, gral_valor_grupos.desc_valor_grupo as descripcion, 
factura1.cliente, clientes.nomb_cliente,
sum(factura2.cantidad*convmedi.factor) as quintales,
sum((factura2.precio*factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global) as venta
from articulos, convmedi, factura1, factura2, clientes, articulos_agrupados, gral_valor_grupos, factmotivos
where gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and factura1.cliente = clientes.cliente
and factmotivos.tipo = factura1.tipo
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S')
and gral_valor_grupos.grupo = 'CLA'
and gral_valor_grupos.aplicacion = 'INV'
and articulos_agrupados.articulo = articulos.articulo
and articulos.unidad_medida = convmedi.old_unidad
and convmedi.new_unidad = '100LBS'
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura2.articulo = articulos.articulo
and factura1.status <> 'A'
group by 1, 2, 3, 4, 5
order by 1, 2, 3, 4, 5;


create view v_fact_ventas_harinas_by_date as
select a.compania, a.almacen, c.fecha_factura, d.articulo, 
sum(((((d.precio*d.cantidad)-d.descuento_linea-d.descuento_global))*b.signo)) as venta, 
sum((d.cantidad*f.factor*b.signo)) as cantidad 
from almacen a, factmotivos b, factura1 c, factura2 d, articulos e, convmedi f
where a.almacen = c.almacen and b.tipo = c.tipo and c.almacen = d.almacen and c.tipo = d.tipo 
and c.num_documento = d.num_documento and d.articulo = e.articulo 
and c.caja = d.caja
and e.servicio = 'N'
and e.unidad_medida = f.old_unidad and f.new_unidad = '100LBS' 
and (b.factura = 'S' or b.devolucion = 'S' or b.factura_fiscal = 'S') and c.status > 'A'
group by 1, 2, 3, 4;


create view v_fact_costos as
select factura2.almacen, factura1.fecha_factura,almacen.desc_almacen,
factura1.num_documento,factura1.cliente,   
factmotivos.descripcion, factura2.articulo,articulos.desc_articulo, 
gralcompanias.nombre as nombre_cia,
factura1.nombre_cliente, articulos.orden_impresion,
factmotivos.signo,  (factura2.cantidad * factmotivos.signo) as cantidad,
((factmotivos.signo* factura2.precio * factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global) as venta,   
(eys2.costo * factmotivos.signo) as costo,   
vendedores.codigo, vendedores.nombre as nombre_vendedor, almacen.compania
from eys2, factura2, factura2_eys2, almacen,factura1,factmotivos,articulos,
gralcompanias,vendedores
where factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura2.almacen = factura2_eys2.almacen 
and factura2_eys2.articulo = factura2.articulo 
and factura2_eys2.tipo = factura2.tipo 
and factura2_eys2.num_documento = factura2.num_documento
and factura2.caja = factura2_eys2.caja
and factura2_eys2.factura2_linea = factura2.linea
and eys2.articulo = factura2_eys2.articulo
and eys2.almacen = factura2_eys2.almacen
and eys2.no_transaccion = factura2_eys2.no_transaccion
and eys2.linea = factura2_eys2.eys2_linea
and factura1.almacen = almacen.almacen
and factmotivos.tipo = factura1.tipo
and factura2.articulo = articulos.articulo
and gralcompanias.compania = almacen.compania
and vendedores.codigo = factura1.codigo_vendedor
and factura1.status <> 'A'
and factmotivos.cotizacion = 'N';



create view v_cgl_presupuesto as
SELECT cgl_presupuesto.compania, cgl_financiero.no_informe, 
cgl_presupuesto.anio, cgl_presupuesto.mes, 
cgl_financiero.d_fila, 
Sum(cgl_presupuesto.monto * cglcuentas.naturaleza) as monto
FROM cgl_presupuesto, cgl_financiero, cglcuentas
WHERE cgl_presupuesto.cuenta = cgl_financiero.cuenta
and cgl_presupuesto.cuenta = cglcuentas.cuenta
GROUP BY 1, 2, 3, 4, 5;


create view v_cgl_financiero as
SELECT a.compania, b.no_informe, a.year, a.periodo, b.d_fila, 
Sum(a.debito-a.credito) as corriente, 
Sum(a.balance_inicio+a.debito-a.credito) as acumulado
FROM cglsldocuenta a, cgl_financiero b
WHERE (a.cuenta=b.cuenta)
GROUP BY a.compania, b.no_informe, a.year, a.periodo, b.d_fila
ORDER BY a.compania, b.no_informe, a.year, a.periodo, b.d_fila;




create view v_bcocircula as
select cod_ctabco, motivo_bco, proveedor,
sec_transacc as no_docmto_sys, no_docmto, fecha_posteo,
substring(trim(obs_transac_bco) from 1 for 60) as concepto, 
'' as a_nombre, 
monto
from bcotransac1
union 
select bcocheck1.cod_ctabco, bcocheck1.motivo_bco, bcocheck1.proveedor,
bcocheck1.no_cheque as no_docmto_sys, bcocheck1.docmto_fuente, bcocheck1.fecha_posteo,
bcocheck1.en_concepto_de as concepto, bcocheck1.paguese_a as a_nombre, bcocheck1.monto
from bcocheck1, bcomotivos
where bcocheck1.status <> 'A'
and bcocheck1.motivo_bco = bcomotivos.motivo_bco
and bcomotivos.aplica_cheques = 'S'
union
select bcocheck1.cod_ctabco, bcocheck1.motivo_bco, bcocheck1.proveedor,
bcocheck1.no_cheque as no_docmto_sys, bcocheck1.docmto_fuente, bcocheck1.fecha_posteo,
bcocheck1.en_concepto_de as concepto, bcocheck1.paguese_a as a_nombre, 0
from bcocheck1, bcomotivos
where bcocheck1.status = 'A'
and bcocheck1.motivo_bco = bcomotivos.motivo_bco
and bcomotivos.aplica_cheques = 'S';



create view v_cxp_pagos as
select bcoctas.compania, bcocheck1.proveedor, bcocheck1.docmto_fuente, 
bcocheck3.aplicar_a, bcomotivos.motivo_cxp as motivo_bco, bcocheck3.motivo_cxp, bcocheck3.monto, bcocheck1.fecha_posteo
from bcocheck1, bcocheck3, bcoctas, bcomotivos, cxpdocm
where bcocheck1.cod_ctabco = bcocheck3.cod_ctabco 
and bcocheck1.no_cheque = bcocheck3.no_cheque 
and bcocheck1.motivo_bco = bcocheck3.motivo_bco 
and bcocheck1.cod_ctabco = bcoctas.cod_ctabco 
and bcocheck1.motivo_bco = bcomotivos.motivo_bco and bcocheck1.status <> 'A' 
and cxpdocm.compania = bcoctas.compania and cxpdocm.proveedor = bcocheck1.proveedor 
and cxpdocm.documento = bcocheck3.aplicar_a and cxpdocm.docmto_aplicar = bcocheck3.aplicar_a 
and cxpdocm.motivo_cxp = bcocheck3.motivo_cxp and bcomotivos.aplica_cheques = 'S' 
and bcocheck1.proveedor is not null and bcocheck3.monto <> 0
and bcomotivos.motivo_cxp is not null
union
select bcoctas.compania, bcotransac1.proveedor, bcotransac1.no_docmto,
bcotransac3.aplicar_a, bcomotivos.motivo_cxp as motivo_bco, bcotransac3.motivo_cxp,
bcotransac3.monto, bcotransac1.fecha_posteo
from bcotransac1, bcotransac3, bcoctas, cxpdocm, bcomotivos
where bcotransac1.cod_ctabco = bcotransac3.cod_ctabco
and bcotransac1.sec_transacc = bcotransac3.sec_transacc
and bcotransac1.cod_ctabco = bcoctas.cod_ctabco
and cxpdocm.compania = bcoctas.compania
and cxpdocm.proveedor = bcotransac1.proveedor
and cxpdocm.documento = bcotransac3.aplicar_a and cxpdocm.docmto_aplicar = bcotransac3.aplicar_a
and cxpdocm.motivo_cxp = bcotransac3.motivo_cxp 
and bcotransac1.proveedor is not null
and bcotransac1.motivo_bco = bcomotivos.motivo_bco
and bcomotivos.motivo_cxp is not null;





create view v_cxp_ajustes_madres as
select cxpajuste1.compania, cxpajuste1.proveedor, cxpajuste1.docm_ajuste_cxp, 
cxpajuste1.motivo_cxp, cxpajuste1.fecha_posteo_ajuste_cxp,
sum(cxpajuste3.monto) as monto
from cxpajuste1, cxpajuste3
where cxpajuste1.compania = cxpajuste3.compania and cxpajuste1.sec_ajuste_cxp = cxpajuste3.sec_ajuste_cxp 
and not exists 
(select * from cxpajuste2 
where cxpajuste2.compania = cxpajuste1.compania 
and cxpajuste2.sec_ajuste_cxp = cxpajuste1.sec_ajuste_cxp
and cxpajuste2.monto <> 0)
group by 1, 2, 3, 4, 5;



create view v_cxp_ajustes_hijos as
select  cxpajuste1.compania, cxpajuste1.proveedor, cxpajuste1.docm_ajuste_cxp as documento, 
cxpajuste2.aplicar_a as docmto_aplicar, cxpajuste1.motivo_cxp as motivo_cxp, 
cxpajuste2.motivo_cxp as motivo_cxp_ref, cxpajuste1.fecha_posteo_ajuste_cxp, cxpajuste2.monto as monto
from cxpajuste1, cxpajuste2, cxpdocm
where cxpajuste1.compania = cxpajuste2.compania 
and cxpajuste1.sec_ajuste_cxp = cxpajuste2.sec_ajuste_cxp 
and cxpajuste1.compania = cxpdocm.compania 
and cxpajuste1.proveedor = cxpdocm.proveedor 
and cxpajuste2.aplicar_a = cxpdocm.documento 
and cxpajuste2.aplicar_a = cxpdocm.docmto_aplicar 
and cxpajuste2.motivo_cxp = cxpdocm.motivo_cxp
and cxpajuste2.monto <> 0 ;



create view v_cxp_facturas as
select cxpfact1.proveedor, cxpfact1.compania, cxpfact1.fact_proveedor, cxpfact1.motivo_cxp, 
cxpfact1.aplicacion_origen, cxpfact1.fecha_posteo_fact_cxp as fecha_posteo, 
cxpfact1.vence_fact_cxp, sum(cxpfact2.monto*rubros_fact_cxp.signo_rubro_fact_cxp) as monto, 
cxpfact1.usuario, cxpfact1.obs_fact_cxp
from cxpfact1, cxpfact2, rubros_fact_cxp, cxpmotivos, proveedores, cglcuentas
where cxpfact1.proveedor = cxpfact2.proveedor and cxpfact1.fact_proveedor = cxpfact2.fact_proveedor 
and cxpfact1.compania = cxpfact2.compania and cxpfact2.rubro_fact_cxp = rubros_fact_cxp.rubro_fact_cxp 
and cxpfact1.motivo_cxp = cxpmotivos.motivo_cxp and cxpfact1.proveedor = proveedores.proveedor 
and proveedores.cuenta = cglcuentas.cuenta and cglcuentas.naturaleza = -1 and cxpmotivos.factura = 'S'
group by cxpfact1.proveedor, cxpfact1.compania, cxpfact1.fact_proveedor, cxpfact1.motivo_cxp, 
cxpfact1.aplicacion_origen, fecha_posteo, cxpfact1.vence_fact_cxp, cxpfact1.usuario, cxpfact1.obs_fact_cxp;




create view v_fact_ventas as
select d.linea, a.compania, a.almacen, c.num_documento, c.codigo_vendedor as vendedor, c.cliente, 
c.fecha_factura, Anio(c.fecha_factura) as anio, Mes(c.fecha_factura) as mes, c.forma_pago, d.articulo, 
(b.signo*((d.precio*d.cantidad)-d.descuento_linea-d.descuento_global)) as venta, (b.signo*(d.cantidad)) as cantidad
from almacen a, factmotivos b, factura1 c, factura2 d, articulos e
where a.almacen = c.almacen and b.tipo = c.tipo and c.almacen = d.almacen 
and c.caja = d.caja
and c.tipo = d.tipo and c.num_documento = d.num_documento and d.articulo = e.articulo 
and ( b.factura_fiscal = 'S' or b.factura = 'S' or b.devolucion = 'S' ) and c.status <> 'A' ;



create view fac_notas_credito as
select 'FAC' as aplicacion, factura1.almacen, factura1.tipo, factura1.documento, 
trim(cast(factura1.num_factura as char(25))) as docmto_aplicar, 
factura1.cliente, factura1.fecha_factura, 
sum(factura4.monto*rubros_fact_cxc.signo_rubro_fact_cxc*factmotivos.signo) as monto
from factura1, factmotivos, factura4, rubros_fact_cxc, gral_forma_de_pago
where factura1.forma_pago = gral_forma_de_pago.forma_pago and gral_forma_de_pago.dias > 0 
and factura1.tipo = factmotivos.tipo and ( factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S' ) 
and factura1.status > 'A' and factura1.almacen = factura4.almacen and factura1.tipo = factura4.tipo 
and factura1.num_documento = factura4.num_documento 
and factura1.caja = factura4.caja
and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
group by factura1.almacen, factura1.tipo, factura1.documento, factura1.cliente, factura1.fecha_factura, factura1.num_factura;



create view fac_facturas_cxc as
select 'FAC' as aplicacion, factura1.almacen, factura1.tipo, factura1.documento, factura1.cliente, 
factura1.fecha_factura, factura1.hbl, 
-sum(factura4.monto*rubros_fact_cxc.signo_rubro_fact_cxc*factmotivos.signo) as monto
from factura1, factmotivos, factura4, rubros_fact_cxc, gral_forma_de_pago
where factura1.forma_pago = gral_forma_de_pago.forma_pago and gral_forma_de_pago.dias > 0 
and factura1.tipo = factmotivos.tipo 
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' 
or factmotivos.nota_credito = 'S')
and factura1.status <> 'A' 
and factura1.almacen = factura4.almacen and factura1.tipo = factura4.tipo 
and factura1.caja = factura4.caja
and factura1.num_documento = factura4.num_documento and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
group by factura1.almacen, factura1.tipo, factura1.documento, factura1.cliente, factura1.fecha_factura, factura1.hbl;



create view v_hp_barcos as
select molino, tipo_de_trigo, Anio(fecha), Mes(fecha), 
(sum(costo)/sum(toneladas)) as costo,
sum(costo) as sum_costo,
sum(toneladas) as sum_toneladas
from hp_barcos
group by 1, 2, 3, 4;

create view v_cos_traspasos as
select almacen.compania, Anio(eys1.fecha), Mes(eys1.fecha),
gral_valor_grupos.desc_valor_grupo, invmotivos.desc_motivo, invmotivos.motivo,
sum(eys2.cantidad * invmotivos.signo) as cantidad,
sum(eys2.costo * invmotivos.signo) as costo
from almacen, eys1, eys2, invmotivos, articulos_agrupados, gral_valor_grupos, 
cos_consumo_eys2, cos_consumo
where cos_consumo_eys2.secuencia = cos_consumo.secuencia
and cos_consumo_eys2.compania = cos_consumo.compania
and cos_consumo_eys2.linea = cos_consumo.linea
and cos_consumo.para_producir is not null
and cos_consumo_eys2.articulo = eys2.articulo
and cos_consumo_eys2.almacen = eys2.almacen
and cos_consumo_eys2.no_transaccion = eys2.no_transaccion
and cos_consumo_eys2.eys2_linea = eys2.linea
and almacen.almacen = eys1.almacen
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys2.articulo = articulos_agrupados.articulo
and articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and gral_valor_grupos.grupo = 'SDI'
group by 1, 2, 3, 4, 5, 6;

create view inv_ventas as
select Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes, gral_valor_grupos.desc_valor_grupo as descripcion, 
sum(factmotivos.signo*factura2.cantidad*convmedi.factor) as quintales,
sum((factmotivos.signo*factura2.precio*factura2.cantidad) - (factura2.descuento_linea*factmotivos.signo) - (factura2.descuento_global*factmotivos.signo)) as venta
from articulos, convmedi, factura1, factura2,
articulos_agrupados, gral_valor_grupos, factmotivos
where gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and factmotivos.tipo = factura1.tipo
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' 
or factmotivos.nota_credito = 'S')
and gral_valor_grupos.grupo = 'CLA'
and gral_valor_grupos.aplicacion = 'INV'
and articulos_agrupados.articulo = articulos.articulo
and articulos.unidad_medida = convmedi.old_unidad
and convmedi.new_unidad = '100LBS'
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura2.articulo = articulos.articulo
and factura1.status <> 'A'
group by 1, 2, 3
order by 1, 2, 3;



create view v_eys1_eys2_x_tipo as
select almacen.compania, eys1.fecha,
gral_valor_grupos.desc_valor_grupo, gral_valor_grupos.codigo_valor_grupo, 
invmotivos.desc_motivo, invmotivos.motivo,
sum(eys2.cantidad * invmotivos.signo) as cantidad,
sum(eys2.costo * invmotivos.signo) as costo
from almacen, eys1, eys2, invmotivos, articulos_agrupados, gral_valor_grupos
where almacen.almacen = eys1.almacen
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys2.articulo = articulos_agrupados.articulo
and articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and gral_valor_grupos.grupo = 'GRA'
group by 1, 2, 3, 4, 5, 6;



create view v_eys1_eys2_x_subtipo as
select almacen.compania, Anio(eys1.fecha), Mes(eys1.fecha),
gral_valor_grupos.desc_valor_grupo, invmotivos.desc_motivo, invmotivos.motivo,
sum(eys2.cantidad * invmotivos.signo) as cantidad,
sum(eys2.costo * invmotivos.signo) as costo
from almacen, eys1, eys2, invmotivos, articulos_agrupados, gral_valor_grupos
where almacen.almacen = eys1.almacen
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys2.articulo = articulos_agrupados.articulo
and articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and gral_valor_grupos.grupo = 'SDI'
group by 1, 2, 3, 4, 5, 6;





create view v_eys1_eys2_x_mes as
select eys1.aplicacion_origen, almacen.compania, 
almacen.almacen, eys1.motivo, invmotivos.desc_motivo,
invmotivos.signo, eys2.articulo, Anio(eys1.fecha), Mes(eys1.fecha),
sum(eys2.cantidad * invmotivos.signo) as cantidad,
sum(eys2.costo * invmotivos.signo) as costo
from almacen, eys1, eys2, invmotivos, articulos_por_almacen
where almacen.almacen = eys1.almacen
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys2.almacen = articulos_por_almacen.almacen
and eys2.articulo = articulos_por_almacen.articulo
group by 1, 2, 3, 4, 5, 6, 7, 8, 9;


create view v_eys1_eys2_x_clase as
select almacen.compania, Anio(eys1.fecha), Mes(eys1.fecha),
gral_valor_grupos.desc_valor_grupo, invmotivos.desc_motivo, invmotivos.motivo,
sum(eys2.cantidad * invmotivos.signo * convmedi.factor) as cantidad,
sum(eys2.costo * invmotivos.signo) as costo
from almacen, eys1, eys2, invmotivos, articulos_agrupados, gral_valor_grupos, convmedi, articulos
where almacen.almacen = eys1.almacen
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys2.articulo = articulos_agrupados.articulo
and articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and articulos.articulo = eys2.articulo
and articulos.unidad_medida = convmedi.old_unidad
and convmedi.new_unidad = '100LBS'
and gral_valor_grupos.grupo = 'CLA'
group by 1, 2, 3, 4, 5, 6;

create view v_eys1_eys2 as
select eys1.aplicacion_origen, almacen.compania, 
almacen.almacen, eys1.motivo, invmotivos.signo,
eys2.articulo, eys1.fecha, 
articulos_por_almacen.cuenta, 
articulos_por_almacen.ubicacion,
articulos_por_almacen.precio_venta,
sum(eys2.cantidad * invmotivos.signo) as cantidad,
sum(eys2.costo * invmotivos.signo) as costo,
Anio(eys1.fecha) as anio,
Mes(eys1.fecha) as mes
from almacen, eys1, eys2, invmotivos, articulos_por_almacen, articulos
where almacen.almacen = eys1.almacen
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys2.almacen = articulos_por_almacen.almacen
and eys2.articulo = articulos_por_almacen.articulo
and articulos.articulo = articulos_por_almacen.articulo
and articulos.servicio = 'N'
group by 1, 2, 3, 4, 5, 6, 7, 8, 9,10;




CREATE VIEW cxc_hijos AS
SELECT 'CXC' AS aplicacion, a.almacen, a.cliente, 
    a.docm_ajuste_cxc, b.aplicar_a, a.motivo_cxc, b.motivo_cxc AS motivo_ref, 
    a.fecha_posteo_ajuste_cxc AS fecha_posteo, sum(b.monto) AS monto 
FROM cxctrx1 a, cxctrx2 b, cxcdocm c 
WHERE a.sec_ajuste_cxc = b.sec_ajuste_cxc AND a.almacen = b.almacen
AND c.almacen = b.almacen AND c.cliente = a.cliente
AND c.documento = b.aplicar_a AND c.docmto_aplicar = b.aplicar_a
AND c.motivo_cxc = b.motivo_cxc and b.monto <> 0
GROUP BY a.almacen, a.cliente, a.docm_ajuste_cxc, b.aplicar_a, 
a.motivo_cxc, b.motivo_cxc, a.fecha_posteo_ajuste_cxc;

create view v_cxc_recibos_hijos as
select cxc_recibo1.documento, cxc_recibo2.documento_aplicar, cxc_recibo1.cliente,
cxc_recibo1.motivo_cxc, cxc_recibo2.almacen_aplicar as almacen, cxc_recibo2.motivo_aplicar,
cxc_recibo1.fecha, cxc_recibo2.monto_aplicar as monto, 
cxc_recibo1.observacion, cxc_recibo1.referencia
from cxc_recibo1, cxc_recibo2, cxcdocm
where cxc_recibo1.almacen = cxc_recibo2.almacen
and cxc_recibo1.consecutivo = cxc_recibo2.consecutivo
and cxc_recibo2.documento_aplicar = cxcdocm.documento
and cxc_recibo2.documento_aplicar = cxcdocm.docmto_aplicar
and cxc_recibo1.cliente = cxcdocm.cliente
and cxc_recibo2.motivo_aplicar = cxcdocm.motivo_cxc
and cxc_recibo2.almacen_aplicar = cxcdocm.almacen
and cxc_recibo2.monto_aplicar <> 0
and cxc_recibo1.status <> 'A';

create view v_cxc_recibos_madres as
select cxc_recibo1.documento, cxc_recibo1.cliente, cxc_recibo1.motivo_cxc, 
cxc_recibo1.almacen, cxc_recibo1.fecha,
(cxc_recibo1.efectivo + cxc_recibo1.cheque + cxc_recibo1.otro) as monto,
cxc_recibo1.observacion, cxc_recibo1.referencia
from cxc_recibo1, cxc_recibo3
where cxc_recibo1.almacen = cxc_recibo3.almacen
and cxc_recibo1.consecutivo = cxc_recibo3.consecutivo
and cxc_recibo1.status <> 'A'
and not exists 
(select * from cxc_recibo2
where cxc_recibo2.almacen = cxc_recibo1.almacen
and cxc_recibo2.consecutivo = cxc_recibo1.consecutivo
and cxc_recibo2.monto_aplicar <> 0);



create view v_cxc_resumen_x_dia as 
select cxcdocm.aplicacion_origen, clientes.cuenta, almacen.compania, cxcdocm.almacen,
Anio(cxcdocm.fecha_posteo), Mes(cxcdocm.fecha_posteo),
cxcdocm.fecha_posteo, 
cxcdocm.cliente, cxcmotivos.signo,
(case when cxcmotivos.signo = 1 then sum(cxcdocm.monto*cxcmotivos.signo) else 0 end) as debito,
(case when cxcmotivos.signo = -1 then sum(cxcdocm.monto*cxcmotivos.signo) else 0 end) as credito
from cxcdocm, cxcmotivos, almacen, clientes
where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
and cxcdocm.cliente = clientes.cliente
and cxcdocm.almacen = almacen.almacen
group by 1, 2, 3, 4, 5, 6, 7, 8, 9;


create view v_cxc_resumen_x_mes
as
select cxcdocm.aplicacion_origen, clientes.cuenta, almacen.compania, cxcdocm.almacen,
Anio(cxcdocm.fecha_posteo), Mes(cxcdocm.fecha_posteo),
cxcdocm.motivo_cxc, sum(cxcdocm.monto*cxcmotivos.signo)
from almacen, cxcdocm, cxcmotivos, clientes
where almacen.almacen = cxcdocm.almacen
and clientes.cliente = cxcdocm.cliente
and cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
group by 1, 2, 3, 4, 5, 6, 7;








CREATE VIEW cgl_cglposteo AS
    SELECT cglposteo.compania, cglposteo.cuenta, cglcuentas.nombre, 
    cglposteo."year", 
    cglposteo.periodo, sum((cglposteo.debito - cglposteo.credito)) AS monto 
FROM cglposteo, cglcuentas 
WHERE ((cglcuentas.cuenta = cglposteo.cuenta) 
AND (cglcuentas.tipo_cuenta = 'R'::bpchar)) 
GROUP BY cglposteo.compania, cglposteo.cuenta, cglcuentas.nombre, 
cglposteo."year", cglposteo.periodo;

create view cgl_saldo_aux1 as
 select cglposteo.compania, cglposteo.cuenta, cglposteoaux1.auxiliar, sum(cglposteoaux1.debito-cglposteoaux1.credito) as saldo
 from cglposteo, cglposteoaux1
 where cglposteo.consecutivo = cglposteoaux1.consecutivo
 group by cglposteo.compania, cglposteo.cuenta, cglposteoaux1.auxiliar;

CREATE VIEW cxc_cxcfact1 AS
SELECT 'CXC' AS aplicacion, a.almacen, a.cliente, a.no_factura, 
a.motivo_cxc, a.fecha_posteo_fact AS fecha_posteo, 
a.fecha_vence_fact AS fecha_vencimiento, 
(- sum((b.monto * "numeric"(c.signo_rubro_fact_cxc)))) AS monto 
FROM cxcfact1 a, cxcfact2 b, rubros_fact_cxc c 
WHERE (((a.almacen = b.almacen) AND (a.no_factura = b.no_factura)) 
AND (b.rubro_fact_cxc = c.rubro_fact_cxc)) 
GROUP BY a.aplicacion, a.almacen, a.cliente, a.no_factura, a.motivo_cxc, 
a.fecha_posteo_fact, a.fecha_vence_fact;


CREATE VIEW cxc_madres AS
SELECT 'CXC' AS aplicacion, cxctrx1.almacen, cxctrx1.cliente, 
cxctrx1.docm_ajuste_cxc AS documento, cxctrx1.motivo_cxc, 
cxctrx1.fecha_posteo_ajuste_cxc AS fecha_posteo, 
sum((cxctrx1.cheque + cxctrx1.efectivo)) AS monto, cxctrx1.referencia 
FROM cxctrx1 
WHERE (NOT (EXISTS (SELECT cxctrx2.aplicar_a, cxctrx2.sec_ajuste_cxc, cxctrx2.almacen, 
cxctrx2.motivo_cxc, cxctrx2.monto 
FROM cxctrx2 
WHERE ((cxctrx2.almacen = cxctrx1.almacen) 
AND (cxctrx2.sec_ajuste_cxc = cxctrx1.sec_ajuste_cxc))))) 
GROUP BY cxctrx1.almacen, cxctrx1.cliente, cxctrx1.docm_ajuste_cxc, 
cxctrx1.motivo_cxc, cxctrx1.fecha_posteo_ajuste_cxc, cxctrx1.referencia;

CREATE VIEW cxp_ajustes_madres AS    
SELECT cxpajuste1.aplicacion, cxpajuste1.compania, cxpajuste1.proveedor, 
cxpajuste1.docm_ajuste_cxp, cxpajuste1.motivo_cxp, sum(cxpajuste3.monto) AS monto, 
cxpajuste1.fecha_posteo_ajuste_cxp 
FROM cxpajuste1, cxpajuste3 
WHERE (((cxpajuste1.compania = cxpajuste3.compania) 
AND (cxpajuste1.sec_ajuste_cxp = cxpajuste3.sec_ajuste_cxp)) 
AND (NOT (EXISTS (SELECT cxpajuste2.compania, cxpajuste2.sec_ajuste_cxp, 
cxpajuste2.aplicar_a, cxpajuste2.motivo_cxp, cxpajuste2.monto 
FROM cxpajuste2 WHERE ((cxpajuste2.compania = cxpajuste1.compania) 
AND (cxpajuste2.sec_ajuste_cxp = cxpajuste1.sec_ajuste_cxp)))))) 
GROUP BY cxpajuste1.aplicacion, cxpajuste1.compania, cxpajuste1.proveedor, 
cxpajuste1.docm_ajuste_cxp, cxpajuste1.motivo_cxp, cxpajuste1.fecha_posteo_ajuste_cxp;


CREATE VIEW fac_facturas AS
    SELECT 'FAC' AS aplicacion, factura1.almacen, factura1.tipo, factura1.documento, 
    factura1.cliente, factura1.fecha_factura, factura1.hbl, 
    (- sum(((factura4.monto * (rubros_fact_cxc.signo_rubro_fact_cxc)) * (factmotivos.signo)))) AS monto 
    FROM factura1, factmotivos, factura4, rubros_fact_cxc 
    WHERE (((((((factura1.tipo = factmotivos.tipo) 
    AND (factmotivos.factura = 'S'::bpchar)) AND (factura1.status > 'A'::bpchar)) 
    AND (factura1.almacen = factura4.almacen)) AND (factura1.tipo = factura4.tipo)) AND (factura1.num_documento = factura4.num_documento)) 
    AND (factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc)) 
    and factura1.caja = factura4.caja
    GROUP BY factura1.almacen, factura1.tipo, factura1.documento, factura1.cliente, factura1.fecha_factura, factura1.hbl;


CREATE VIEW fact_totales AS
    SELECT factura1.fecha_factura, factura1.almacen, factura1.tipo, factura1.num_documento, gral_forma_de_pago.dias, 
    factura1.cliente, factura1.documento, factura1.nombre_cliente,
    (- sum((factura4.monto * (rubros_fact_cxc.signo_rubro_fact_cxc)))) AS monto 
    FROM factura1, factura4, gral_forma_de_pago, rubros_fact_cxc, factmotivos 
    WHERE factura1.almacen = factura4.almacen
    AND factura1.tipo = factura4.tipo AND factura1.num_documento = factura4.num_documento
    and factura1.caja = factura4.caja
    AND factura1.forma_pago = gral_forma_de_pago.forma_pago
    AND factura1.tipo = factmotivos.tipo AND factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
    AND factura1.status <> 'A'
    AND factmotivos.donacion = 'N' AND factmotivos.cotizacion = 'N' 
    GROUP BY factura1.fecha_factura, factura1.almacen, factura1.tipo, factura1.num_documento, gral_forma_de_pago.dias, factura1.cliente, factura1.documento,
    factura1.nombre_cliente;


create view f_conytram_resumen as
select tipo, almacen, no_documento as num_documento, 
trim(cast(no_documento as char(10))) as documento, 
clientes.cliente, fecha_factura, monto_manejo as manejo, 
monto_documentacion as confeccion, 
(otros_ingresos1+otros_ingresos2+otros_ingresos3+otros_ingresos4+valor_x_linea) as otros_ingresos, 
(monto_cod1+monto_cod2+monto_cod3) as cod, 
monto_aduana as aduana, monto_acarreo as acarreo, itbms,
(monto_manejo+monto_documentacion+otros_ingresos1+otros_ingresos2+otros_ingresos3+otros_ingresos4+monto_cod1+monto_cod2+monto_cod3+monto_aduana+monto_acarreo+valor_x_linea+itbms+cair) as total,
clientes.nomb_cliente as nombre_cliente, f_conytram.cair
from f_conytram, clientes 
where f_conytram.cliente = clientes.cliente 
and tipo in (select tipo from factmotivos where cotizacion = 'N' and donacion = 'N');



CREATE VIEW eys1_eys2_agrupado AS
    SELECT b.almacen, anio(b.fecha) AS anio, mes(b.fecha) AS mes, 
    c.articulo, b.motivo, a.desc_motivo, 
    sum((c.cantidad * "numeric"(a.signo))) AS cantidad, 
    sum((c.costo * "numeric"(a.signo))) AS costo 
    FROM invmotivos a, eys1 b, eys2 c 
    WHERE (((a.motivo = b.motivo) AND (b.almacen = c.almacen)) 
    AND (b.no_transaccion = c.no_transaccion)) 
    GROUP BY b.almacen, anio(b.fecha), mes(b.fecha), c.articulo, b.motivo, 
    a.desc_motivo;


CREATE VIEW fact_ventas AS
    SELECT d.linea, a.compania, a.almacen, c.num_documento, 
    c.codigo_vendedor AS vendedor, c.cliente, 
    c.fecha_factura, anio(c.fecha_factura) AS anio, mes(c.fecha_factura) AS mes, 
    c.forma_pago, d.articulo, 
    (((d.precio * d.cantidad) - d.descuento_linea) - d.descuento_global) AS venta, 
    d.cantidad FROM almacen a, factmotivos b, factura1 c, factura2 d, articulos e 
    WHERE ((((((((a.almacen = c.almacen) AND (b.tipo = c.tipo)) 
    AND (c.almacen = d.almacen)) AND (c.tipo = d.tipo)) 
    AND (c.num_documento = d.num_documento)) AND (d.articulo = e.articulo)) 
    AND ((b.factura = 'S'::bpchar) OR (b.devolucion = 'S'::bpchar))) 
    AND (c.status > 'A'::bpchar))
    and c.caja = d.caja;
    
    
    


/*
create view v_ventas_x_mes_harinas as
select Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes,
(select trim(gral_valor_grupos.desc_valor_grupo)
from gral_valor_grupos, articulos_agrupados
where gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and gral_valor_grupos.grupo = 'CLA'
and gral_valor_grupos.aplicacion = 'INV'
and articulos_agrupados.articulo = articulos.articulo) as descripcion,
factura2.articulo,
sum(factura2.cantidad*factmotivos.signo) as cantidad,
sum(f_desglose_factura_x_linea(factura2.almacen, factura2.tipo, factura2.num_documento, factura2.caja, factura2.linea, '100LBS')) as quintales,
sum(f_desglose_factura_x_linea(factura2.almacen, factura2.tipo, factura2.num_documento, factura2.caja, factura2.linea, 'VENTA_NETA')) as venta
from factura1, factura2, clientes, articulos,
        factmotivos, almacen, gralcompanias, vendedores
where vendedores.codigo = clientes.vendedor
and almacen.compania = gralcompanias.compania
and factura1.almacen = almacen.almacen
and clientes.cliente = factura1.cliente
and factmotivos.tipo = factura1.tipo
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' or factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S'
or factmotivos.promocion = 'S')
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura2.articulo = articulos.articulo
and factura1.status <> 'A'
group by 1, 2, 3, 4;

create view v_ventas_x_cliente_harinas as
select gralcompanias.nombre, almacen.compania, factura1.fecha_factura, 
Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes, factura1.almacen, 
(select trim(gral_valor_grupos.desc_valor_grupo)
from gral_valor_grupos, articulos_agrupados
where gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and gral_valor_grupos.grupo = 'CLA'
and gral_valor_grupos.aplicacion = 'INV'
and articulos_agrupados.articulo = articulos.articulo) as descripcion,
(select trim(gral_valor_grupos.desc_valor_grupo) 
from gral_valor_grupos, clientes_agrupados
where gral_valor_grupos.codigo_valor_grupo = clientes_agrupados.codigo_valor_grupo
and gral_valor_grupos.grupo = 'CAT'
and gral_valor_grupos.aplicacion = 'CXC'
and clientes_agrupados.cliente = clientes.cliente) as categoria_cliente,
factura1.cliente, clientes.nomb_cliente, factura1.tipo, articulos.orden_impresion, 
factura1.codigo_vendedor as vendedor, 
Trim(vendedores.nombre) as nombre_vendedor,
factura1.forma_pago, factura1.num_documento, factura2.linea,
factura2.articulo, articulos.desc_articulo,
(factura2.cantidad*factmotivos.signo) as cantidad,
f_desglose_factura_x_linea(factura2.almacen, factura2.tipo, factura2.num_documento, factura2.caja, factura2.linea, '100LBS') as quintales,
f_desglose_factura_x_linea(factura2.almacen, factura2.tipo, factura2.num_documento, factura2.caja, factura2.linea, 'VENTA_NETA') as venta
from factura1, factura2, clientes, articulos,
        factmotivos, almacen, gralcompanias, vendedores
where vendedores.codigo = clientes.vendedor
and almacen.compania = gralcompanias.compania
and factura1.almacen = almacen.almacen
and clientes.cliente = factura1.cliente
and factmotivos.tipo = factura1.tipo
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' or factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S'
or factmotivos.promocion = 'S')
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura2.articulo = articulos.articulo
and factura1.status <> 'A';


*/
    
