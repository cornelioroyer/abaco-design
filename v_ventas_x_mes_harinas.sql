

drop view v_ventas_x_mes_harinas;

create view v_ventas_x_mes_harinas as
select Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes,
(select trim(gral_valor_grupos.desc_valor_grupo)
from gral_valor_grupos, articulos_agrupados
where gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and gral_valor_grupos.grupo = 'CLA'
and gral_valor_grupos.aplicacion = 'INV'
and articulos_agrupados.articulo = articulos.articulo) as descripcion,
factura2.articulo,
sum(factura2.cantidad*factmotivos.signo) as cantidad,
sum(f_desglose_factura_x_linea(factura2.almacen, factura2.tipo, factura2.num_documento, factura2.caja, factura2.linea, '100LBS')) as quintales,
sum(f_desglose_factura_x_linea(factura2.almacen, factura2.tipo, factura2.num_documento, factura2.caja, factura2.linea, 'VENTA_NETA')) as venta
from factura1, factura2, clientes, articulos,
        factmotivos, almacen, gralcompanias, vendedores
where vendedores.codigo = clientes.vendedor
and almacen.compania = gralcompanias.compania
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
group by 1, 2, 3, 4;

