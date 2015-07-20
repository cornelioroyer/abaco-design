

update factura1
set despachar = 'S', fecha_despacho = fecha_factura
where tipo = '9'
and (despachar = 'N' or fecha_despacho is null)
and fecha_factura >= '2014-03-01'
