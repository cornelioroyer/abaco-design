select documento, documento, cliente,
tipo, almacen, documento, tipo, 'FAC', 'N',
fecha_factura, fecha_factura, monto,
fecha_factura, 'R', 'dba', today(),
today()
from fact_totales
where dias > 0 and monto > 0 and not exists
(select * from cxcdocm
where cxcdocm.documento = fact_totales.documento
and cxcdocm.docmto_aplicar = fact_totales.documento
and cxcdocm.cliente = fact_totales.cliente
and cxcdocm.motivo_cxc = fact_totales.tipo
and cxcdocm.almacen = fact_totales.almacen)
order by almacen, fecha_factura, documento
