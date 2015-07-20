select factura1.almacen, factura1.fecha_factura, factura1.num_documento,
factura1.cliente, factura1.nombre_cliente, gral_valor_grupos.desc_valor_grupo, 
(factura2.precio * factura2.cantidad) as monto
from factura1, factura2, factmotivos, almacen, articulos_agrupados, gral_valor_grupos
where factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.tipo = factmotivos.tipo
and factmotivos.factura = 'S'
and factura2.articulo = articulos_agrupados.articulo
and articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and factura1.num_documento = factura2.num_documento
and factura1.status <> 'A'
and gral_valor_grupos.grupo = 'TDI'
and factura1.almacen = almacen.almacen
and almacen.compania = '03'
and Anio(factura1.fecha_factura) = 2004
order by factura1.almacen, factura1.fecha_factura, factura1.num_documento,
gral_valor_grupos.desc_valor_grupo