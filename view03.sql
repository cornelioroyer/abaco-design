create view fact_ventas_x_mes as
select a.compania, a.almacen, c.cliente, Anio(c.fecha_factura) as anio, Mes(c.fecha_factura) as mes, 
d.articulo, sum(((d.precio*d.cantidad)-d.descuento_linea-d.descuento_global)) as venta, sum(d.cantidad) as cantidad
from almacen a, factmotivos b, factura1 c, factura2 d
where a.almacen = c.almacen and b.tipo = c.tipo and c.almacen = d.almacen and c.tipo = d.tipo 
and c.num_documento = d.num_documento and b.factura = 'S' and c.status > 'A'
group by a.compania, a.almacen, anio, mes, c.cliente, d.articulo
order by a.compania, a.almacen, anio, mes, c.cliente, d.articulo

