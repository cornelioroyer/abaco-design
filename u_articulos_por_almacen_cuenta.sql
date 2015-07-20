

update articulos_por_almacen
set cuenta = '6100104'
from articulos
where articulos_por_almacen.articulo = articulos.articulo
and articulos.servicio = 'S';



/*
update articulos_por_almacen
set cuenta = '4100402'
from articulos, cglcuentas
where articulos_por_almacen.cuenta = cglcuentas.cuenta
and articulos_por_almacen.articulo = articulos.articulo
and articulos.servicio = 'S'
and cglcuentas.tipo_cuenta = 'B';
*/

