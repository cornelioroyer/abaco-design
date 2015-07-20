select * from cxcdocm
where aplicacion_origen = 'FAC' and documento = '470835'
and documento = docmto_aplicar
and not exists
(select factura1.almacen, factura1.tipo,
factura1.num_documento, gral_forma_de_pago.dias, factura1.cliente, factura1.documento,
 -sum(factura4.monto*rubros_fact_cxc.signo_rubro_fact_cxc) as monto
from factura1, factura4, gral_forma_de_pago,
rubros_fact_cxc
where factura1.almacen = factura4.almacen
and factura1.tipo = factura4.tipo
and factura1.num_documento = factura4.num_documento
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc
and factura1.status > 'A'
and factura1.documento = cxcdocm.documento
and factura1.almacen = cxcdocm.almacen
and factura1.fecha_factura = cxcdocm.fecha_posteo
and factura1.tipo = cxcdocm.motivo_cxc
and gral_forma_de_pago.dias > 0
group by factura1.almacen, factura1.tipo, factura1.num_documento, gral_forma_de_pago.dias,
factura1.cliente, factura1.documento
having (-sum(factura4.monto*rubros_fact_cxc.signo_rubro_fact_cxc) - cxcdocm.monto) <> cast('0.00' as decimal))
