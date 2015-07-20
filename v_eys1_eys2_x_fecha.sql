drop view v_eys1_eys2_x_fecha;
create view v_eys1_eys2_x_fecha as
select gralcompanias.nombre as nombre_cia, gralcompanias.compania, almacen.almacen, 
eys2.articulo, articulos.desc_articulo, eys1.fecha, articulos_por_almacen.cuenta, 
sum(eys2.cantidad * invmotivos.signo) as cantidad,
sum(eys2.costo * invmotivos.signo) as costo
from almacen, eys1, eys2, invmotivos, articulos_por_almacen, gralcompanias, articulos
where almacen.almacen = eys1.almacen
and eys2.articulo = articulos.articulo
and almacen.compania = gralcompanias.compania
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys2.almacen = articulos_por_almacen.almacen
and eys2.articulo = articulos_por_almacen.articulo
group by 1, 2, 3, 4, 5, 6, 7;
