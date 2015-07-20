
drop view v_factura1_factura2_donaciones cascade;

create view v_factura1_factura2_donaciones as
select almacen.compania, factura1.almacen, factura1.cajero, factura1.tipo, 
factmotivos.descripcion,
factura1.num_documento, factura1.cliente, factura1.nombre_cliente, factura1.forma_pago,
gral_forma_de_pago.dias,
factura1.codigo_vendedor, almacen.desc_almacen,
Anio(factura1.fecha_factura) as anio,
Mes(factura1.fecha_factura) as mes, factura1.fecha_factura,
factura2.articulo, articulos.desc_articulo,
vendedores.nombre as nombre_del_vendedor,
fact_referencias.descripcion as referencia,
gralcompanias.nombre as nombre_de_cia,
articulos.orden_impresion,
f_factura1_ciudad(factura1.almacen, factura1.tipo, factura1.num_documento, factura1.caja) as ciudad,
(factura2.cantidad * factmotivos.signo) as cantidad
from almacen, factura1, factura2, factmotivos, clientes, articulos, 
vendedores, gralcompanias, gral_forma_de_pago, fact_referencias
where factura1.referencia = fact_referencias.referencia
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and almacen.compania = gralcompanias.compania
and factura1.codigo_vendedor = vendedores.codigo
and almacen.almacen = factura1.almacen
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.caja = factura2.caja
and factura1.num_documento = factura2.num_documento
and factura1.tipo = factmotivos.tipo
and factmotivos.donacion = 'S'
and factura1.cliente = clientes.cliente
and factura2.articulo = articulos.articulo
and factura2.cantidad <> 0
and factura1.status <> 'A';
