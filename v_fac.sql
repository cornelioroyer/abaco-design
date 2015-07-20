drop view v_factura1_factura2;
drop view fact_despachos;



create view v_factura1_factura2 as
select almacen.compania, factura1.almacen, factura1.tipo, factmotivos.descripcion,
factura1.num_documento, factura1.cliente, factura1.nombre_cliente, factura1.forma_pago,
factura1.codigo_vendedor, almacen.desc_almacen,
Anio(factura1.fecha_factura),
Mes(factura1.fecha_factura), factura1.fecha_factura,
factura2.articulo, articulos.desc_articulo,
vendedores.nombre as nombre_del_vendedor,
gralcompanias.nombre as nombre_de_cia,
articulos.orden_impresion,
(factura2.cantidad * factmotivos.signo) as cantidad,
(((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) as venta,
(((factura2.cantidad * factura2.precio) - factura2.descuento_linea - factura2.descuento_global) / factura2.cantidad) as precio
from almacen, factura1, factura2, factmotivos, clientes, articulos, vendedores, gralcompanias
where almacen.compania = gralcompanias.compania
and factura1.codigo_vendedor = vendedores.codigo
and almacen.almacen = factura1.almacen
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.num_documento = factura2.num_documento
and factura1.tipo = factmotivos.tipo
and (factmotivos.factura = 'S' or factmotivos.nota_credito = 'S' or factmotivos.devolucion = 'S')
and factura1.cliente = clientes.cliente
and factura2.articulo = articulos.articulo
and factura2.cantidad <> 0
and factura1.status <> 'A';



drop view v_fact_ventas_harinas;
create view v_fact_ventas_harinas as
select d.linea, a.compania, a.almacen, c.num_documento, c.codigo_vendedor as vendedor, c.cliente, 
c.fecha_factura, Anio(c.fecha_factura) as anio, Mes(c.fecha_factura) as mes, c.forma_pago, 
d.articulo, 
((((d.precio*d.cantidad)-d.descuento_linea-d.descuento_global))*b.signo) as venta, 
(d.cantidad*f.factor*b.signo) as cantidad 
from almacen a, factmotivos b, factura1 c, factura2 d, articulos e, convmedi f
where a.almacen = c.almacen and b.tipo = c.tipo and c.almacen = d.almacen and c.tipo = d.tipo 
and c.num_documento = d.num_documento and d.articulo = e.articulo 
and e.servicio = 'N'
and e.unidad_medida = f.old_unidad and f.new_unidad = '100LBS' 
and (b.factura = 'S' or b.devolucion = 'S') and c.status > 'A';




CREATE VIEW fact_despachos AS
SELECT a.compania, a.almacen, c.tipo, c.num_documento, 
    c.codigo_vendedor AS vendedor, c.cliente, c.despachar, c.fecha_despacho, 
    c.fecha_factura, anio(c.fecha_factura) AS anio, 
    mes(c.fecha_factura) AS mes, c.forma_pago, 
    d.articulo, (((d.precio * d.cantidad) - d.descuento_linea) - d.descuento_global) AS venta, 
    d.cantidad FROM almacen a, factmotivos b, factura1 c, factura2 d 
WHERE (((((((a.almacen = c.almacen) AND (b.tipo = c.tipo)) AND (c.almacen = d.almacen)) 
AND (c.tipo = d.tipo)) AND (c.num_documento = d.num_documento)) 
AND ((b.factura = 'S'::bpchar) OR (b.donacion = 'S'::bpchar))) 
AND (c.status > 'A'::bpchar));


