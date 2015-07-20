drop view v_cxcdocm;
create view v_cxcdocm as
select factura1.almacen, factura1.cliente, 
trim(to_char(factura1.num_documento, '9999999999')) as documento,
trim(to_char(factura1.num_documento, '9999999999')) as docmto_aplicar,
factura1.tipo as motivo_cxc, trim(to_char(factura1.num_documento, '9999999999')) as docmto_ref,
factura1.tipo as motivo_ref, factura1.fecha_factura as fecha_posteo, factura1.fecha_factura as fecha_docmto,
factura1.fecha_vencimiento as fecha_vmto, trim(factura1.observacion) as obs_docmto,
factura1.no_referencia as referencia, 'FAC' as aplicacion_origen, 
-sum(factura4.monto * rubros_fact_cxc.signo_rubro_fact_cxc * factmotivos.signo) as monto 
from factura1, factmotivos, factura4, rubros_fact_cxc 
where factura1.tipo = factmotivos.tipo and factmotivos.factura = 'S' 
and factura1.status <> 'A'
and factura1.almacen = factura4.almacen 
and factura1.tipo = factura4.tipo
and factura1.num_documento = factura4.num_documento
and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
group by factura1.almacen, factura1.cliente, factura1.num_documento,
factura1.tipo, factura1.fecha_factura, factura1.fecha_vencimiento, factura1.observacion,
factura1.no_referencia
union
select factura1.almacen, factura1.cliente, 
trim(to_char(factura1.num_documento, '9999999999')) as documento,
trim(to_char(factura1.num_factura, '9999999999')) as docmto_aplicar,
factura1.tipo as motivo_cxc, trim(to_char(factura1.num_factura, '9999999999')) as docmto_ref,
(select a.tipo from factura1 a where a.almacen = factura1.almacen
and a.num_documento = factura1.num_factura),
factura1.fecha_factura as fecha_posteo, factura1.fecha_factura as fecha_docmto,
factura1.fecha_vencimiento as fecha_vmto, trim(factura1.observacion) as obs_docmto,
factura1.no_referencia as referencia, 'FAC' as aplicacion_origen, 
-sum(factura4.monto * rubros_fact_cxc.signo_rubro_fact_cxc * factmotivos.signo) as monto 
from factura1, factmotivos, factura4, rubros_fact_cxc 
where factura1.tipo = factmotivos.tipo and factmotivos.devolucion = 'S' 
and factura1.status <> 'A'
and factura1.almacen = factura4.almacen 
and factura1.tipo = factura4.tipo
and factura1.num_documento = factura4.num_documento
and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
and factura1.num_factura <> 0
group by factura1.almacen, factura1.cliente, factura1.num_documento,
factura1.tipo, factura1.fecha_factura, factura1.fecha_vencimiento, factura1.observacion,
factura1.no_referencia, factura1.num_factura
union
select cxc_recibo1.almacen, cxc_recibo1.cliente, cxc_recibo1.documento, cxc_recibo1.documento,
cxc_recibo1.motivo_cxc, cxc_recibo1.documento, cxc_recibo1.motivo_cxc, cxc_recibo1.fecha,
cxc_recibo1.fecha, cxc_recibo1.fecha, cxc_recibo1.observacion, cxc_recibo1.referencia, 'CXC', 
(cxc_recibo1.efectivo + cxc_recibo1.cheque + cxc_recibo1.otro)
from cxc_recibo1, cxc_recibo3
where cxc_recibo1.almacen = cxc_recibo3.almacen
and cxc_recibo1.consecutivo = cxc_recibo3.consecutivo
and cxc_recibo1.status <> 'A'
and not exists 
(select * from cxc_recibo2
where cxc_recibo2.almacen = cxc_recibo1.almacen
and cxc_recibo2.consecutivo = cxc_recibo1.consecutivo
and cxc_recibo2.monto_aplicar <> 0)
union
select cxc_recibo2.almacen_aplicar, cxc_recibo1.cliente, cxc_recibo1.documento, cxc_recibo2.documento_aplicar,
cxc_recibo1.motivo_cxc, cxc_recibo2.documento_aplicar, cxc_recibo2.motivo_aplicar, cxc_recibo1.fecha,
cxc_recibo1.fecha, cxc_recibo1.fecha, cxc_recibo1.observacion, cxc_recibo1.referencia, 'CXC', 
cxc_recibo2.monto_aplicar
from cxc_recibo1, cxc_recibo2, cxcdocm
where cxc_recibo1.almacen = cxc_recibo2.almacen
and cxc_recibo1.consecutivo = cxc_recibo2.consecutivo
and cxc_recibo2.documento_aplicar = cxcdocm.documento
and cxc_recibo2.documento_aplicar = cxcdocm.docmto_aplicar
and cxc_recibo1.cliente = cxcdocm.cliente
and cxc_recibo2.motivo_aplicar = cxcdocm.motivo_cxc
and cxc_recibo2.almacen_aplicar = cxcdocm.almacen
and cxc_recibo2.monto_aplicar <> 0
and cxc_recibo1.status <> 'A'
union
select almacen, cliente, documento, documento, motivo_cxc, documento, motivo_cxc,
fecha, fecha, fecha, null, null, 'CXC', monto
from cxc_saldos_iniciales
union
select cxcfact1.almacen, cxcfact1.cliente, cxcfact1.no_factura,
cxcfact1.no_factura, cxcfact1.motivo_cxc, cxcfact1.no_factura, cxcfact1.motivo_cxc,
cxcfact1.fecha_posteo_fact, cxcfact1.fecha_posteo_fact, cxcfact1.fecha_vence_fact,
trim(cxcfact1.obs_fact), null, 'CXC', 
-sum(cxpfact2.monto * rubros_fact_cxc.signo_rubro_fact_cxc)
from cxcfact1, cxcfact2, rubros_fact_cxc 
where cxcfact1.almacen = cxcfact2.almacen
and cxcfact1.no_factura = cxcfact2.no_factura
and cxcfact2.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
group by cxcfact1.aplicacion, cxcfact1.almacen, cxcfact1.cliente, cxcfact1.no_factura, 
cxcfact1.motivo_cxc, cxcfact1.fecha_posteo_fact, cxcfact1.fecha_vence_fact,
cxcfact1.obs_fact
union
select cxctrx1.almacen, cxctrx1.cliente, 
cxctrx1.docm_ajuste_cxc, cxctrx1.docm_ajuste_cxc, cxctrx1.motivo_cxc, 
cxctrx1.docm_ajuste_cxc, cxctrx1.motivo_cxc,
cxctrx1.fecha_posteo_ajuste_cxc, cxctrx1.fecha_posteo_ajuste_cxc,
cxctrx1.fecha_posteo_ajuste_cxc, trim(cxctrx1.obs_ajuste_cxc), trim(cxctrx1.referencia), 'CXC',
sum(cxctrx1.cheque + cxctrx1.efectivo)
from cxctrx1
where not exists
(select * from cxctrx2
where cxctrx2.almacen = cxctrx1.almacen
and cxctrx2.sec_ajuste_cxc = cxctrx1.sec_ajuste_cxc
and cxctrx2.monto <> 0)
group by cxctrx1.almacen, cxctrx1.cliente, cxctrx1.docm_ajuste_cxc, 
cxctrx1.motivo_cxc, cxctrx1.fecha_posteo_ajuste_cxc, cxctrx1.referencia, cxctrx1.obs_ajuste_cxc
union
select cxctrx1.almacen, cxctrx1.cliente, 
cxctrx1.docm_ajuste_cxc, cxctrx2.aplicar_a, cxctrx1.motivo_cxc, 
cxctrx2.aplicar_a, cxctrx2.motivo_cxc,
cxctrx1.fecha_posteo_ajuste_cxc, cxctrx1.fecha_posteo_ajuste_cxc,
cxctrx1.fecha_posteo_ajuste_cxc, trim(cxctrx1.obs_ajuste_cxc), trim(cxctrx1.referencia),
'CXC', sum(cxctrx2.monto)
from cxctrx1, cxctrx2, cxcdocm
where cxctrx1.sec_ajuste_cxc = cxctrx2.sec_ajuste_cxc
and cxctrx1.almacen = cxctrx2.almacen
and cxcdocm.almacen = cxctrx2.almacen
and cxcdocm.cliente = cxctrx1.cliente
and cxcdocm.documento = cxctrx2.aplicar_a
and cxcdocm.docmto_aplicar = cxctrx2.aplicar_a
and cxcdocm.motivo_cxc = cxctrx2.motivo_cxc
and cxctrx2.monto <> 0
group by cxctrx1.almacen, cxctrx1.cliente, cxctrx1.docm_ajuste_cxc, cxctrx2.aplicar_a, 
cxctrx1.motivo_cxc, cxctrx2.motivo_cxc, cxctrx1.fecha_posteo_ajuste_cxc,
cxctrx1.obs_ajuste_cxc, cxctrx1.referencia;

