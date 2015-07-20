drop view v_fact_ventas_x_clase_detalladas;
create view v_fact_ventas_x_clase_detalladas as
select Anio(factura1.fecha_factura), Mes(factura1.fecha_factura), factura1.fecha_factura, factura1.num_documento,
gral_valor_grupos.desc_valor_grupo as descripcion, 
factura1.cliente, clientes.nomb_cliente,
(factura2.cantidad*convmedi.factor) as quintales,
((factura2.precio*factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global) as venta,
(((factura2.precio*factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global)/(factura2.cantidad*convmedi.factor)) as precio
from articulos, convmedi, factura1, factura2, clientes, articulos_agrupados, gral_valor_grupos, factmotivos
where gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and factura1.cliente = clientes.cliente
and factmotivos.tipo = factura1.tipo
and factmotivos.factura = 'S'
and gral_valor_grupos.grupo = 'CLA'
and gral_valor_grupos.aplicacion = 'INV'
and articulos_agrupados.articulo = articulos.articulo
and articulos.unidad_medida = convmedi.old_unidad
and convmedi.new_unidad = '100LBS'
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.num_documento = factura2.num_documento
and factura2.articulo = articulos.articulo
and factura2.cantidad <> 0
and factura1.status <> 'A'
order by 1, 2, 3, 4, 5