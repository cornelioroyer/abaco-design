update factura1
set fecha_despacho = fecha_factura,
despachar = 'S'
where tipo in
(select tipo from factmotivos where (factura = 'S' or devolucion = 'S'))
and status <> 'A'
and fecha_factura >= '2004-01-01';
