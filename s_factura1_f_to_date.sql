



select almacen, caja, tipo, cliente, num_documento, fecha_factura, fecha_captura from factura1
where f_to_date(fecha_captura) = '2014-09-24'
order by num_documento


/*


update factura1
set fecha_factura = f_to_date(fecha_captura)
where f_to_date(fecha_captura) = '2014-12-09'

f_to_date(fecha_captura) = '2014-09-24'
num_documento in (3808)

*/
