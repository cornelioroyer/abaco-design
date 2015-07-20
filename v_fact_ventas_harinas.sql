create view v_fact_ventas_harinas as
select factura2.linea, almacen.compania, almacen.almacen, factura1.num_documento,
        factura1.codigo_vendedor as vendedor, factura1.cliente, factura1.fecha_factura,
        anio(factura1.fecha_factura) as anio, mes(factura1.fecha_factura) as mes, 
        factura1.forma_pago, factura2.articulo, 
        (factura2.cantidad*convmedi.factor*factmotivos.signo) as quintales,
        (factmotivos.signo*((factura2.precio*factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global)) as venta
        
        (factura2.precio * factura2.cantidad) - factura2.descuento_linea - factura2.descuento_global) * b.signo) as venta, 
    ((d.cantidad * f.factor) * b.signo) AS cantidad 
FROM almacen a, factmotivos b, factura1 c, factura2 d, articulos e, convmedi f 
WHERE a.almacen = c.almacen AND (b.tipo = c.tipo)) 
AND (c.almacen = d.almacen)) AND (c.tipo = d.tipo)) 
AND (c.num_documento = d.num_documento)) AND (d.articulo = e.articulo)) 
AND (e.servicio = 'N'::bpchar)) AND (e.unidad_medida = f.old_unidad)) 
AND (f.new_unidad = '100LBS'::bpchar)) AND ((b.factura = 'S'::bpchar) 
OR (b.devolucion = 'S'::bpchar))) AND (c.status > 'A'::bpchar));

