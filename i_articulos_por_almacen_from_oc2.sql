
insert into articulos_por_almacen (almacen, articulo, cuenta, precio_venta,
minimo, maximo, usuario, fecha_captura, dias_piso, existencia, costo)
select '01', articulo, '120000', 999999, 0, 0, 'dba', today(), 0, 0, 0
from oc2
where articulo not in
(select articulo from articulos_por_almacen
where almacen = '01')
group by articulo;
