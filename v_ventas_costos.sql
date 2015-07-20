drop view v_ventas_costos;

create view v_ventas_costos as
select almacen.compania, factura2.almacen, factura1.fecha_factura, almacen.desc_almacen,
       factura1.num_documento, factura1.cliente, clientes.nomb_cliente as nombre_del_cliente,  
       factmotivos.descripcion,   
       factura2.articulo,   
       articulos.desc_articulo,   
       gralcompanias.nombre,   
       factmotivos.signo,   
       factura1.codigo_vendedor,
       vendedores.nombre as nombre_vendedor,
       (factura2.cantidad * factmotivos.signo) as cantidad,   
       (((factura2.precio * factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global) * factmotivos.signo) as venta,
        f_factura2_costo(factura2.almacen, factura2.tipo, factura2.num_documento, factura2.linea, 'COSTO') as costo
    FROM factura2,
         almacen,   
         factura1,   
         factmotivos,   
         articulos,   
         gralcompanias,
         vendedores,
         clientes
   WHERE factura1.almacen = almacen.almacen
          and factura1.cliente = clientes.cliente
         and factura1.codigo_vendedor = vendedores.codigo
         and factura1.almacen = factura2.almacen
         and factura1.tipo = factura2.tipo
         and factura1.num_documento = factura2.num_documento
         and factmotivos.tipo = factura1.tipo
         and factura2.articulo = articulos.articulo
         and gralcompanias.compania = almacen.compania
         and factmotivos.cotizacion = 'N' 
         and factura1.status <> 'A';
