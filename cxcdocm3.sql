
insert into cxcdocm (documento, docmto_aplicar, cliente,
motivo_cxc, almacen, docmto_ref, motivo_ref,
aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto,
fecha_posteo, status, usuario, fecha_captura, fecha_cancelo)
select factura1.documento, factura1.documento, factura1.cliente,
factura1.tipo, factura1.almacen, factura1.documento, factura1.tipo,
'FAC', 'N', factura1.fecha_factura, factura1.fecha_factura, -sum(factura4.monto*rubros_fact_cxc.signo_rubro_fact_cxc),
factura1.fecha_factura, 'R', 'dba', today(), today() 
from factura1, factura4, gral_forma_de_pago, rubros_fact_cxc, factmotivos
where factura1.almacen = factura4.almacen 
and factura1.tipo = factura4.tipo 
and factura1.num_documento = factura4.num_documento 
and factura1.forma_pago = gral_forma_de_pago.forma_pago 
and factura1.tipo = factmotivos.tipo 
and factura4.rubro_fact_cxc = rubros_fact_cxc.rubro_fact_cxc 
and factura1.status > 'A' 
and factmotivos.donacion = 'N' 
and factmotivos.cotizacion = 'N'
and gral_forma_de_pago.dias > 0
and not exists
(select * from cxcdocm
where documento = factura1.documento
and docmto_aplicar = factura1.documento
and motivo_cxc = factura1.tipo
and almacen = factura1.almacen
and cliente = factura1.cliente)
group by factura1.documento, factura1.cliente, factura1.tipo, factura1.almacen, factura1.fecha_factura


