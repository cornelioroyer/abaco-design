drop view fact_ventas_harinas;

/*==============================================================*/
/* View: fact_ventas_harinas                                    */
/*==============================================================*/
create view fact_ventas_harinas as
select d.linea, a.compania, a.almacen, c.num_documento, c.codigo_vendedor as vendedor, c.cliente, 
c.fecha_factura, Anio(c.fecha_factura) as anio, Mes(c.fecha_factura) as mes, c.forma_pago, 
d.articulo, 
((((d.precio*d.cantidad)-d.descuento_linea-d.descuento_global))*b.signo) as venta, 
(d.cantidad*f.factor*b.signo) as cantidad 
from almacen a, factmotivos b, factura1 c, factura2 d, articulos e, convmedi f
where a.almacen = c.almacen and b.tipo = c.tipo and c.almacen = d.almacen and c.tipo = d.tipo 
and c.num_documento = d.num_documento and d.articulo = e.articulo 
and e.unidad_medida = f.old_unidad and f.new_unidad = '100LBS' 
and (b.factura = 'S' or b.devolucion = 'S') and c.status > 'A';



drop view fac_notas_credito;

/*==============================================================*/
/* View: fac_notas_credito                                      */
/*==============================================================*/
create view fac_notas_credito as
select 'FAC' as aplicacion, factura1.almacen, factura1.tipo, factura1.documento, 
trim(cast(factura1.num_factura as char(25))) as docmto_aplicar, 
factura1.cliente, factura1.fecha_factura, 
sum(factura4.monto*rubros_fact_cxc.signo_rubro_fact_cxc*factmotivos.signo) as monto
from factura1, factmotivos, factura4, rubros_fact_cxc, gral_forma_de_pago
where factura1.forma_pago = gral_forma_de_pago.forma_pago and gral_forma_de_pago.dias > 0 and factura1.tipo = factmotivos.tipo and ( factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S' ) and factura1.status > 'A' and factura1.almacen = factura4.almacen and factura1.tipo = factura4.tipo and factura1.num_documento = factura4.num_documento and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
group by factura1.almacen, factura1.tipo, factura1.documento, factura1.cliente, factura1.fecha_factura, factura1.num_factura;




drop view cxp_ajustes_hijos;

create view cxp_ajustes_hijos as
select 'CXP' as aplicacion, cxpajuste1.compania, cxpajuste1.proveedor, cxpajuste1.docm_ajuste_cxp as documento, 
cxpajuste2.aplicar_a as docmto_aplicar, cxpajuste1.motivo_cxp as motivo_cxp, 
cxpajuste2.motivo_cxp as motivo_cxp_ref, cxpajuste1.fecha_posteo_ajuste_cxp, sum(cxpajuste2.monto) as monto
from cxpajuste1, cxpajuste2, cxpdocm
where cxpajuste1.compania = cxpajuste2.compania and cxpajuste1.sec_ajuste_cxp = cxpajuste2.sec_ajuste_cxp 
and cxpajuste1.compania = cxpdocm.compania 
and cxpajuste1.proveedor = cxpdocm.proveedor 
and cxpajuste2.aplicar_a = cxpdocm.documento 
and cxpajuste2.aplicar_a = cxpdocm.docmto_aplicar 
and cxpajuste2.motivo_cxp = cxpdocm.motivo_cxp
group by cxpajuste1.compania, cxpajuste1.proveedor, cxpajuste1.docm_ajuste_cxp,
cxpajuste2.aplicar_a, cxpajuste1.motivo_cxp, cxpajuste2.motivo_cxp, cxpajuste1.fecha_posteo_ajuste_cxp;



drop view f_conytram_resumen;
create view f_conytram_resumen as
select tipo, almacen, no_documento as num_documento, trim(cast(no_documento as char(10))) as documento, 
clientes.cliente, fecha_factura, monto_manejo as manejo, 
monto_documentacion as confeccion, (otros_ingresos1+otros_ingresos2+otros_ingresos3+otros_ingresos4+valor_x_linea) as otros_ingresos, 
(monto_cod1+monto_cod2+monto_cod3) as cod, 
monto_aduana as aduana, monto_acarreo as acarreo, itbms,
(monto_manejo+monto_documentacion+otros_ingresos1+otros_ingresos2+otros_ingresos3+otros_ingresos4+monto_cod1+monto_cod2+monto_cod3+monto_aduana+monto_acarreo+valor_x_linea+itbms) as total,
clientes.nomb_cliente as nombre_cliente
from f_conytram, clientes where f_conytram.cliente = clientes.cliente and tipo in (select tipo from factmotivos where cotizacion = 'N' and donacion = 'N');



drop view cxc_hijos;

create view cxc_hijos as
select 'CXC' as aplicacion, a.almacen, a.cliente, a.docm_ajuste_cxc, b.aplicar_a, a.motivo_cxc, 
b.motivo_cxc as motivo_ref, a.fecha_posteo_ajuste_cxc as fecha_posteo, sum(b.monto) as monto
from cxctrx1 a, cxctrx2 b, cxcdocm c
where a.sec_ajuste_cxc = b.sec_ajuste_cxc 
and a.almacen = b.almacen 
and c.almacen = b.almacen 
and c.cliente = a.cliente 
and c.documento = b.aplicar_a 
and c.docmto_aplicar = b.aplicar_a 
and c.motivo_cxc = b.motivo_cxc
group by a.almacen, a.cliente, a.docm_ajuste_cxc, b.aplicar_a, a.motivo_cxc, b.motivo_cxc, a.fecha_posteo_ajuste_cxc;



