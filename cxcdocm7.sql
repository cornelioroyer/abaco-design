select * from cxcdocm
where documento = docmto_aplicar
and motivo_cxc = motivo_ref
and aplicacion_origen = 'FAC'
and fecha_posteo >= '2002-12-1'
and not exists
(select * from factura1
where factura1.almacen = cxcdocm.almacen
and factura1.documento = cxcdocm.documento
and factura1.tipo = cxcdocm.motivo_cxc
and factura1.cliente = cxcdocm.cliente);

