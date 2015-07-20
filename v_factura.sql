drop view v_factura;
create view v_factura as
select gralcompanias.compania, gralcompanias.nombre, gralcompanias.id_tributario, 
gralcompanias.dv, almacen.desc_almacen, almacen.telefono_almacen,
 factura1.cliente, 
 factura1.almacen,
 factura1.tipo,   
 factura1.num_documento,   
 gral_forma_de_pago.desc_forma_pago,   
 factura1.observacion as observacion_factura,   
 factura2.observacion as observacion_articulo,   
 factura1.fecha_factura,   
 vendedores.nombre as nombre_del_vendedor,   
 factura1.direccion1,   
 factura1.direccion2,   
 factura1.direccion3,   
 gral_forma_de_pago.dias,   
 articulos.orden_impresion,   
 articulos.desc_articulo,   
 gralcompanias.mensaje,
 factura1.nombre_cliente, factura2.articulo, 
 factura2.cantidad, factura2.precio, 
 (factura2.descuento_linea + factura2.descuento_global) as descuento, 0 as itbms
FROM almacen,factura1,factura2,gralcompanias,gral_forma_de_pago,articulos,vendedores
WHERE almacen.compania = gralcompanias.compania
and factura1.almacen = almacen.almacen
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.num_documento = factura2.num_documento
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and factura2.articulo = articulos.articulo
and vendedores.codigo = factura1.codigo_vendedor
union
select gralcompanias.compania, gralcompanias.nombre, gralcompanias.id_tributario, 
gralcompanias.dv, almacen.desc_almacen, almacen.telefono_almacen,
 factura1.cliente, 
 factura1.almacen,
 factura1.tipo,   
 factura1.num_documento,   
 gral_forma_de_pago.desc_forma_pago,   
 factura1.observacion as observacion_factura,   
 factura2.observacion as observacion_articulo,   
 factura1.fecha_factura,   
 vendedores.nombre as nombre_del_vendedor,   
 factura1.direccion1,   
 factura1.direccion2,   
 factura1.direccion3,   
 gral_forma_de_pago.dias,   
 articulos.orden_impresion,   
 articulos.desc_articulo,   
 gralcompanias.mensaje,
 factura1.nombre_cliente, factura2.articulo, 0, factura2.precio, 0,
 factura3.monto as itbms
from almacen,factura1,factura2,gralcompanias,gral_forma_de_pago,articulos,vendedores,factura3
WHERE almacen.compania = gralcompanias.compania
and factura1.almacen = almacen.almacen
and factura1.almacen = factura2.almacen
and factura1.tipo = factura2.tipo
and factura1.num_documento = factura2.num_documento
and factura1.forma_pago = gral_forma_de_pago.forma_pago
and factura2.articulo = articulos.articulo
and vendedores.codigo = factura1.codigo_vendedor
and factura2.almacen = factura3.almacen
and factura2.tipo = factura3.tipo
and factura2.num_documento = factura3.num_documento
and factura2.linea = factura3.linea

