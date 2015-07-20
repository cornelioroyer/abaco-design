select * from cxcdocm
where documento = docmto_aplicar
and motivo_cxc = motivo_ref
and aplicacion_origen = 'FAC'
and fecha_posteo >= '2002-12-1'
and not exists
(select * from factura1, factura4, rubros_fact_cxc
where factura1.almacen = factura4.almacen
and factura1.tipo = factura4.tipo
and factura1.num_documento = factura4.num_documento
and facutra4.rubro
factura1.almacen = cxcdocm.almacen
and factura1.documento = cxcdocm.documento
and factura1.tipo = cxcdocm.motivo_cxc
and factura1.cliente = cxcdocm.cliente

