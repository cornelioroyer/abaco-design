drop view v_kardex;
create view v_kardex as
select almacen.compania, almacen.desc_almacen, gralcompanias.nombre, tal_ot1.almacen, cast(tal_ot1.no_orden as char(15)) as no_orden, 
tal_ot1.nombre_cliente, tal_ot1.cliente, cast(tal_ot1.numero_factura as char(15)) as numero_factura, tal_ot1.fecha as fecha_ot,
tal_ot2.fecha_despacho as fecha, eys2.articulo, sum(invmotivos.signo*eys2.cantidad) as cantidad, 
sum(invmotivos.signo*eys2.costo) as costo, eys1.aplicacion_origen, articulos.desc_articulo
from gralcompanias, tal_ot1, tal_ot2, tal_ot2_eys2, eys2, almacen, invmotivos, eys1, articulos
where tal_ot1.almacen = almacen.almacen
and eys2.articulo = articulos.articulo
and eys1.motivo = invmotivos.motivo
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and almacen.compania = gralcompanias.compania
and tal_ot1.almacen = tal_ot2.almacen
and tal_ot1.tipo = tal_ot2.tipo
and tal_ot1.no_orden = tal_ot2.no_orden
and tal_ot2.almacen = tal_ot2_eys2.almacen
and tal_ot2.no_orden = tal_ot2_eys2.no_orden
and tal_ot2.tipo = tal_ot2_eys2.tipo
and tal_ot2.linea = tal_ot2_eys2.linea_tal_ot2
and tal_ot2.articulo = tal_ot2_eys2.articulo
and eys2.almacen = tal_ot2_eys2.almacen
and eys2.articulo = tal_ot2_eys2.articulo
and eys2.no_transaccion = tal_ot2_eys2.no_transaccion
and eys2.linea = tal_ot2_eys2.linea_eys2
group by almacen.compania, almacen.desc_almacen, gralcompanias.nombre, tal_ot1.almacen, tal_ot1.no_orden,
tal_ot1.nombre_cliente, tal_ot1.cliente, tal_ot1.numero_factura, 
tal_ot1.fecha,
tal_ot2.fecha_despacho, eys2.articulo, eys1.aplicacion_origen, articulos.desc_articulo
union
select almacen.compania, almacen.desc_almacen, gralcompanias.nombre, eys1.almacen, 
cast(cxpfact1.numero_oc as char(15)),
proveedores.nomb_proveedor, proveedores.proveedor, cxpfact1.fact_proveedor, eys1.fecha, eys1.fecha, eys2.articulo, 
eys2.cantidad*invmotivos.signo, invmotivos.signo*eys2.costo, eys1.aplicacion_origen,
articulos.desc_articulo
from gralcompanias, almacen, eys1, eys2, cxpfact1, invmotivos, proveedores, articulos
where gralcompanias.compania = almacen.compania
and cxpfact1.proveedor = proveedores.proveedor
and eys2.articulo = articulos.articulo
and eys1.motivo = invmotivos.motivo
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys2.compania = cxpfact1.compania
and eys2.proveedor = cxpfact1.proveedor
and eys2.almacen = almacen.almacen
and eys2.fact_proveedor = cxpfact1.fact_proveedor
union
select almacen.compania, almacen.desc_almacen, gralcompanias.nombre, eys1.almacen, cast(eys1.no_transaccion as char(15)),
null, null, cast(eys1.no_transaccion as char(15)), eys1.fecha, eys1.fecha, eys2.articulo, 
sum(eys2.cantidad*invmotivos.signo), sum(invmotivos.signo*eys2.costo), eys1.aplicacion_origen,
articulos.desc_articulo
from gralcompanias, almacen, eys1, eys2, invmotivos, articulos
where gralcompanias.compania = almacen.compania
and eys2.articulo = articulos.articulo
and eys1.motivo = invmotivos.motivo
and eys1.almacen = eys2.almacen
and eys2.almacen = almacen.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys2.proveedor is null
and not exists
(select * from factura2_eys2
where factura2_eys2.almacen = eys1.almacen
and factura2_eys2.no_transaccion = eys1.no_transaccion)
and not exists
(select * from tal_ot2_eys2
where tal_ot2_eys2.almacen = eys1.almacen
and tal_ot2_eys2.no_transaccion = eys1.no_transaccion)
group by almacen.compania, almacen.desc_almacen, gralcompanias.nombre, eys1.almacen, eys1.no_transaccion,
eys1.no_transaccion, eys1.fecha, eys1.fecha, eys2.articulo, 
eys1.aplicacion_origen, articulos.desc_articulo
union
select almacen.compania, almacen.desc_almacen, gralcompanias.nombre, eys1.almacen, cast(eys1.no_transaccion as char(15)),
factura1.nombre_cliente, factura1.cliente, cast(factura1.num_documento as char(15)), factura1.fecha_factura,
eys1.fecha, eys2.articulo, sum(eys2.cantidad*invmotivos.signo), sum(invmotivos.signo*eys2.costo), 
eys1.aplicacion_origen, articulos.desc_articulo
from gralcompanias, almacen, factura1, factura2_eys2, eys2, eys1, invmotivos, articulos
where gralcompanias.compania = almacen.compania
and eys2.articulo = articulos.articulo
and eys1.motivo = invmotivos.motivo
and factura1.almacen = almacen.almacen
and factura1.almacen = factura2_eys2.almacen
and factura1.tipo = factura2_eys2.tipo
and factura1.num_documento = factura2_eys2.num_documento
and factura2_eys2.articulo = eys2.articulo
and factura2_eys2.almacen = eys2.almacen
and factura2_eys2.no_transaccion = eys2.no_transaccion
and factura2_eys2.eys2_linea = eys2.linea
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
group by almacen.compania, almacen.desc_almacen, gralcompanias.nombre, eys1.almacen, eys1.no_transaccion,
factura1.nombre_cliente, factura1.cliente, factura1.num_documento, factura1.fecha_factura,
eys1.fecha, eys2.articulo, eys1.aplicacion_origen, articulos.desc_articulo;

