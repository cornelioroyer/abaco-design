drop view v_fact_costos_x_grupo;

create view v_fact_costos_x_grupo as
select factura1.cajero, factura1.almacen, factura1.tipo, factura1.num_documento, factura1.fecha_factura,almacen.desc_almacen,
factura1.cliente, factmotivos.descripcion, factura2.articulo,articulos.desc_articulo, 
gralcompanias.nombre as nombre_cia,
factura1.nombre_cliente, articulos.orden_impresion,
factura1.caja, factura1.sec_z, gral_forma_de_pago.dias,
factmotivos.signo,  (factura2.cantidad * factmotivos.signo) as cantidad,
round((((factura2.precio * factura2.cantidad) - (factura2.descuento_linea + factura2.descuento_global))*factmotivos.signo),2) as venta,   
f_factura2_costo(factura1.almacen, factura1.tipo, factura1.num_documento,factura2.linea,'IMPUESTO') as impuesto,
f_factura2_costo(factura1.almacen, factura1.tipo, factura1.num_documento,factura2.linea,'COSTO') as costo,
vendedores.codigo, vendedores.nombre as nombre_vendedor, almacen.compania,
gral_grupos_aplicacion.desc_grupo, gral_grupos_aplicacion.grupo,
gral_valor_grupos.desc_valor_grupo, gral_valor_grupos.codigo_valor_grupo
from gralcompanias, almacen, factura1, factura2, vendedores, factmotivos,
articulos, articulos_agrupados, gral_valor_grupos, gral_grupos_aplicacion, gral_forma_de_pago
where factura1.forma_pago = gral_forma_de_pago.forma_pago
and almacen.compania = gralcompanias.compania
and factura1.tipo = factmotivos.tipo
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.num_documento = factura2.num_documento
and factura1.almacen = almacen.almacen
and factura1.codigo_vendedor = vendedores.codigo
and factura1.tipo = factura1.tipo
and factura2.articulo = articulos.articulo
and factura2.articulo = articulos_agrupados.articulo
and articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and gral_grupos_aplicacion.grupo = gral_valor_grupos.grupo
and factura1.status <> 'A'
and factmotivos.cotizacion = 'N'
and gral_grupos_aplicacion.aplicacion = 'INV';
