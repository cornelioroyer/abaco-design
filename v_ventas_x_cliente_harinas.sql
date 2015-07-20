drop view v_ventas_x_cliente_harinas;

create view v_ventas_x_cliente_harinas as
select gralcompanias.nombre, almacen.compania, factura1.fecha_factura, 
Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes, factura1.almacen, 
(select trim(gral_valor_grupos.desc_valor_grupo)
from gral_valor_grupos, articulos_agrupados
where gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and gral_valor_grupos.grupo = 'CLA'
and gral_valor_grupos.aplicacion = 'INV'
and articulos_agrupados.articulo = articulos.articulo) as descripcion,
(select trim(gral_valor_grupos.desc_valor_grupo) 
from gral_valor_grupos, clientes_agrupados
where gral_valor_grupos.codigo_valor_grupo = clientes_agrupados.codigo_valor_grupo
and gral_valor_grupos.grupo = 'CAT'
and gral_valor_grupos.aplicacion = 'CXC'
and clientes_agrupados.cliente = clientes.cliente) as categoria_cliente,
factura1.cliente, clientes.nomb_cliente, factura1.tipo, articulos.orden_impresion, 
factura1.codigo_vendedor as vendedor, 
Trim(vendedores.nombre) as nombre_vendedor,
factura1.forma_pago, factura1.num_documento, factura2.linea,
factura2.articulo, articulos.desc_articulo,
sum(factura2.cantidad*factmotivos.signo) as cantidad,
sum(factmotivos.signo*factura2.cantidad*convmedi.factor) as quintales,
sum(case when factmotivos.promocion = 'S' then 0 else (factmotivos.signo*((factura2.precio*factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global)) end) as venta
from factura1, factura2, clientes, articulos, convmedi,
        factmotivos, almacen, gralcompanias, vendedores
where vendedores.codigo = clientes.vendedor
and almacen.compania = gralcompanias.compania
and articulos.unidad_medida = convmedi.old_unidad
and convmedi.new_unidad = '100LBS'
and factura1.almacen = almacen.almacen
and clientes.cliente = factura1.cliente
and factmotivos.tipo = factura1.tipo
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' or factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S'
or factmotivos.promocion = 'S')
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura2.articulo = articulos.articulo
and factura1.status <> 'A'
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19;



