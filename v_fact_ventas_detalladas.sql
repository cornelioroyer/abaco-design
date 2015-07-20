select d.linea, a.compania, a.almacen, c.num_documento, c.codigo_vendedor as vendedor, c.cliente, 
c.fecha_factura, Anio(c.fecha_factura) as anio, Mes(c.fecha_factura) as mes, c.forma_pago, 
d.articulo, ((d.precio*d.cantidad)-d.descuento_linea-d.descuento_global) as venta, (d.cantidad) as cantidad
from almacen a, factmotivos b, factura1 c, factura2 d, articulos e
where a.almacen = c.almacen and b.tipo = c.tipo and c.almacen = d.almacen 
and c.tipo = d.tipo and c.num_documento = d.num_documento and d.articulo = e.articulo 
and ( b.factura = 'S' or b.devolucion = 'S' ) and c.status > 'A' ;
