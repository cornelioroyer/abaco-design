update articulos_por_almacen
set existencia = v_stock.existencia, costo = v_stock.costo
where articulos_por_almacen.almacen = v_stock.almacen
and articulos_por_almacen.articulo = v_stock.articulo;