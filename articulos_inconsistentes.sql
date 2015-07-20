select articulos_por_almacen.articulo from articulos, articulos_por_almacen, cglcuentas
where articulos.articulo = articulos_por_almacen.articulo
and articulos_por_almacen.cuenta = cglcuentas.cuenta
and trim(cglcuentas.tipo_cuenta) = 'R'
and articulos.servicio = 'N'
order by 1