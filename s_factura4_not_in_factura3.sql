select factura4.* from factura1, factura4, factmotivos
where factura1.almacen = factura4.almacen
and factura1.tipo = factura4.tipo
and factura1.num_documento = factura4.num_documento
and factura1.tipo = factmotivos.tipo
and factmotivos.factura = 'S'
and factura1.fecha_factura > '2010-04-01'
and factura4.rubro_fact_cxc = 'ITBMS'
and factura4.monto <> 0
and factura1.status <> 'A'
and not exists
(select * from factura3
where factura3.almacen = factura1.almacen
and factura3.tipo = factura1.tipo
and factura3.num_documento = factura1.num_documento
and factura3.monto <> 0)
order by factura4.num_documento