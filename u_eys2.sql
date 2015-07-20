update eys2
set cantidad = tmp_precios_bering.cantidad,
costo = tmp_precios_bering.cantidad * to_number(tmp_precios_bering.cu, '99999999.99')
where trim(eys2.articulo) = trim(tmp_precios_bering.articulo)
and tmp_precios_bering.cantidad <> 0