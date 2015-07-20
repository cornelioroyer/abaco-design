
drop view v_factura1_factura2_x_cat_coolhouse cascade;

create view v_factura1_factura2_x_cat_coolhouse as
select almacen.compania, factura1.almacen, factura1.cajero, factura1.tipo, factmotivos.descripcion,
factura1.num_documento, factura1.cliente, factura1.nombre_cliente, factura1.forma_pago,
vendedores.nombre as nombre_del_vendedor,
factura1.codigo_vendedor, almacen.desc_almacen,
Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes, factura1.fecha_factura,
factura1.fecha_factura as fecha_cobro,
factura2.articulo, articulos.desc_articulo,
gralcompanias.nombre as nombre_de_cia,
gral_valor_grupos.desc_valor_grupo,
articulos.orden_impresion,
(factura2.cantidad * factmotivos.signo) as cantidad,
(((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) as venta,
(((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) / factura2.cantidad) as precio,
f_factura2_costo(factura2.almacen,factura2.tipo,factura2.num_documento,factura2.linea,'COSTO') as costo,
((((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) - f_factura2_costo(factura2.almacen,factura2.tipo,factura2.num_documento,factura2.linea,'COSTO')) as margen
from almacen, factura1, factura2, factmotivos, clientes, articulos, vendedores, 
gralcompanias, articulos_agrupados, gral_valor_grupos, gral_forma_de_pago
where factura1.forma_pago = gral_forma_de_pago.forma_pago
and almacen.compania = gralcompanias.compania
and factura1.codigo_vendedor = vendedores.codigo
and articulos_agrupados.articulo = articulos.articulo
and gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and almacen.almacen = factura1.almacen
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura1.tipo = factmotivos.tipo
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' or factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S')
and factura1.cliente = clientes.cliente
and factura2.articulo = articulos.articulo
and factura2.cantidad <> 0
and gral_valor_grupos.grupo = 'CAT'
and gral_valor_grupos.aplicacion = 'INV'
and factura1.status <> 'A'
and factura1.fecha_factura >= '2014-01-01'


