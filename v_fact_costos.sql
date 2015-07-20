drop view v_fact_costos;
create view v_fact_costos as
select factura2.almacen, factura1.fecha_factura,almacen.desc_almacen,factura1.num_documento,factura1.cliente,   
      factmotivos.descripcion, factura2.articulo,articulos.desc_articulo, gralcompanias.nombre as nombre_cia,
      factura1.nombre_cliente, articulos.orden_impresion,
      factmotivos.signo,  (factura2.cantidad * factmotivos.signo) as cantidad,   
      (((factura2.precio * factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) as venta,   
      (eys2.costo * factmotivos.signo) as costo,   
      vendedores.codigo, vendedores.nombre as nombre_vendedor, almacen.compania
from eys2, factura2, factura2_eys2, almacen,factura1,factmotivos,articulos,gralcompanias,vendedores
where factura2.almacen = factura2_eys2.almacen 
and   factura2_eys2.articulo = factura2.articulo 
and   factura2_eys2.tipo = factura2.tipo 
and   factura2_eys2.num_documento = factura2.num_documento
and   factura2_eys2.factura2_linea = factura2.linea
and   eys2.articulo = factura2_eys2.articulo
and   eys2.almacen = factura2_eys2.almacen
and   eys2.no_transaccion = factura2_eys2.no_transaccion
and   eys2.linea = factura2_eys2.eys2_linea
and   factura1.almacen = almacen.almacen
and   factura1.almacen = factura2.almacen
and   factura1.tipo = factura2.tipo
and   factura1.num_documento = factura2.num_documento
and   factmotivos.tipo = factura1.tipo
and   factura2.articulo = articulos.articulo
and   gralcompanias.compania = almacen.compania
and   vendedores.codigo = factura1.codigo_vendedor
and   factura1.status <> 'A'