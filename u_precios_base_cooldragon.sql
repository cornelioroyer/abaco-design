update articulos_por_almacen
set precio_venta = (costo/existencia) * 2.2
where precio_fijo = 'N'
and existencia > 0;