select factura2.almacen, factura1.fecha_factura,almacen.desc_almacen,
factura1.num_documento,factura1.cliente,   
factmotivos.descripcion, factura2.articulo,articulos.desc_articulo, 
gralcompanias.nombre as nombre_cia,
factura1.nombre_cliente, articulos.orden_impresion,
factmotivos.signo,  (factura2.cantidad * factmotivos.signo) as cantidad,
((factmotivos.signo* factura2.precio * factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global) as venta,   
(eys2.costo * factmotivos.signo) as costo,   
vendedores.codigo, vendedores.nombre as nombre_vendedor, almacen.compania,
gral_grupos_aplicacion.desc_grupo, gral_grupos_aplicacion.grupo,
gral_valor_grupos.desc_valor_grupo, gral_valor_grupos.codigo_valor_grupo
from gralcompanias, almacen, factura1, factura2, vendedores, factmotivos, factura2_eys2,
articulos, articulos_agrupados, gral_valor_grupos, eys2, gral_grupos_aplicacion
where almacen.compania = gralcompanias.compania
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.num_documento = factura2.num_documento
and factura1.almacen = almacen.almacen
and factura1.codigo_vendedor = vendedores.codigo
and factura1.tipo = factura1.tipo
and factura2_eys2.articulo = factura2.articulo 
and factura2_eys2.tipo = factura2.tipo 
and factura2_eys2.num_documento = factura2.num_documento
and factura2_eys2.factura2_linea = factura2.linea
and factura2.articulo = articulos.articulo
and factura2.articulo = articulos_agrupados.articulo
and articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and factura2_eys2.articulo = eys2.articulo
and factura2_eys2.almacen = eys2.almacen
and factura2_eys2.no_transaccion = eys2.no_transaccion
and factura2_eys2.eys2_linea = eys2.linea
and gral_grupos_aplicacion.grupo = gral_valor_grupos.grupo
