drop view v_ventas_costos;
create view v_ventas_costos as
select factura2.almacen,   
       factura1.fecha_factura,   
       almacen.desc_almacen,   
       factura1.num_documento,   
       factura1.cliente,   
       factmotivos.descripcion,   
       factura2.articulo,   
       articulos.desc_articulo,   
       gralcompanias.nombre,   
       factmotivos.signo,   
       (factura2.cantidad * factmotivos.signo) as cantidad,   
       (((factura2.precio * factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) as venta,
        f_factura2_costo(factura2.almacen, factura2.tipo, factura2.num_documento, factura2.linea, 'COSTO')
    FROM factura2,
         almacen,   
         factura1,   
         factmotivos,   
         articulos,   
         gralcompanias  
   WHERE factura1.almacen = almacen.almacen
         and factura1.almacen = factura2.almacen
         and factura1.tipo = factura2.tipo
         and factura1.num_documento = factura2.num_documento
         and factmotivos.tipo = factura1.tipo
         and factura2.articulo = articulos.articulo
         and gralcompanias.compania = almacen.compania
         and factura1.status <> 'A'
         and factura1.num_documento = 5155
