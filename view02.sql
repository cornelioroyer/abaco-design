drop view fact_ventas_harinas;
create view fact_ventas_harinas as
select a.compania, a.almacen, c.num_documento, c.codigo_vendedor, c.cliente, 
c.fecha_factura, Anio(c.fecha_factura) as anio, Mes(c.fecha_factura) as mes,
c.forma_pago, d.articulo, ((d.precio*d.cantidad)-d.descuento_linea-d.descuento_global) as venta, 
(d.cantidad*f.factor) as cantidad
from almacen a, factmotivos b, factura1 c, factura2 d, articulos e, convmedi f
where a.almacen = c.almacen
and b.tipo = c.tipo
and c.almacen = d.almacen
and c.tipo = d.tipo
and c.num_documento = d.num_documento
and d.articulo = e.articulo
and e.unidad_medida = f.old_unidad
and f.new_unidad = '100LBS'
and b.factura = 'S' and c.status <> 'A'
