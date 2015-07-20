
drop view v_ventas_x_categoria;
drop view v_costos_x_categoria;

create view v_costos_x_categoria as
select almacen.compania, eys1.almacen, eys1.no_transaccion,
invmotivos.desc_motivo as d_motivo,
Anio(eys1.fecha) as anio,
Mes(eys1.fecha) as mes, 
eys1.fecha as fecha,
eys2.articulo, 
articulos.desc_articulo,
gralcompanias.nombre as nombre_de_cia,
trim(gral_valor_grupos.codigo_valor_grupo) as categoria,
trim(gral_valor_grupos.desc_valor_grupo) as d_categoria,
(eys2.cantidad * invmotivos.signo) as cantidad,
(eys2.costo * invmotivos.signo) as costo
from almacen, eys1, eys2, invmotivos, articulos, gralcompanias, articulos_agrupados, gral_valor_grupos
where eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.almacen = almacen.almacen
and eys1.motivo = invmotivos.motivo
and eys2.articulo = articulos.articulo
and almacen.compania = gralcompanias.compania
and articulos_agrupados.articulo = eys2.articulo
and gral_valor_grupos.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
and eys1.fecha >= '2014-01-01'
and eys1.aplicacion_origen <> 'COM'
and gral_valor_grupos.grupo = 'CAT'
and gral_valor_grupos.aplicacion = 'INV';




create view v_ventas_x_categoria as
select almacen.compania,
factura1.almacen, 
factura1.caja,
factura1.tipo as tipo,
factura1.num_documento,
factura1.cajero, 
factmotivos.descripcion as d_tipo,
factura1.cliente, 
trim(factura1.nombre_cliente) as nombre_cliente, 
factura1.forma_pago,
vendedores.nombre as nombre_del_vendedor,
factura1.codigo_vendedor, almacen.desc_almacen,
Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes, 
factura1.fecha_factura as fecha,
factura2.articulo, articulos.desc_articulo,
gralcompanias.nombre as nombre_de_cia,
gral_valor_grupos.codigo_valor_grupo as codigo_categoria,
trim(gral_valor_grupos.desc_valor_grupo) as categoria,
articulos.orden_impresion,
(factura2.cantidad * factmotivos.signo) as cantidad,
(((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) as venta
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
and factura1.tipo <> 'DA'
and factura1.cliente = clientes.cliente
and factura2.articulo = articulos.articulo
and gral_valor_grupos.grupo = 'CAT'
and gral_valor_grupos.aplicacion = 'INV'
and factura1.status <> 'A'
and factura1.fecha_factura >= '2014-01-01'
and (factmotivos.factura = 'S' or factmotivos.factura_fiscal = 'S' 
or factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S');

