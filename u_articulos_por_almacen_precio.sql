update articulos_por_almacen
set precio_venta = costo/existencia
where precio_fijo = 'N'
and existencia > 0;