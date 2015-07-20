drop view fact_despachos;
create view fact_despachos as
select almacen.compania, almacen.almacen, factura1.tipo, factura1.num_documento, 
factura1.codigo_vendedor as vendedor, factura1.cliente, factura1.despachar, 
factura1.fecha_despacho, factura1.fecha_factura, 
anio(factura1.fecha_factura) as anio, mes(factura1.fecha_factura) as mes, 
factura1.forma_pago, factura2.articulo, 
sum((factura2.precio * factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global) as venta, 
sum(factura2.cantidad) as cantidad
from almacen, factmotivos, factura1, factura2, articulos
WHERE factura1.almacen = almacen.almacen
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.num_documento = factura2.num_documento
and factura1.tipo = factmotivos.tipo
and factura2.articulo = articulos.articulo
and articulos.servicio = 'N'
and factura1.status <> 'A'
and (factmotivos.factura = 'S' 
or factmotivos.donacion = 'S'
or factmotivos.promocion = 'S')
group by almacen.compania, almacen.almacen, factura1.tipo, factura1.num_documento, 
factura1.codigo_vendedor, factura1.cliente, factura1.despachar, 
factura1.fecha_despacho, factura1.fecha_factura, 
anio(factura1.fecha_factura), mes(factura1.fecha_factura), 
factura1.forma_pago, factura2.articulo

