drop view v_factura1_factura2;
create view v_factura1_factura2 as
select almacen.compania, factura1.almacen, factura1.tipo, factmotivos.descripcion,
factura1.num_documento, factura1.cliente, factura1.nombre_cliente, factura1.forma_pago,
factura1.codigo_vendedor, almacen.desc_almacen,
Anio(factura1.fecha_factura),
Mes(factura1.fecha_factura), factura1.fecha_factura,
factura2.articulo, articulos.desc_articulo,
vendedores.nombre as nombre_del_vendedor,
gralcompanias.nombre as nombre_de_cia,
articulos.orden_impresion,
(factura2.cantidad * factmotivos.signo) as cantidad,
(((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) as venta,
(((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) / factura2.cantidad) as precio
from almacen, factura1, factura2, factmotivos, clientes, articulos, vendedores, gralcompanias
where almacen.compania = gralcompanias.compania
and factura1.codigo_vendedor = vendedores.codigo
and almacen.almacen = factura1.almacen
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.num_documento = factura2.num_documento
and factura1.tipo = factmotivos.tipo
and (factmotivos.factura = 'S' or factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S')
and factura1.cliente = clientes.cliente
and factura2.articulo = articulos.articulo
and factura2.cantidad <> 0
and factura1.status <> 'A'