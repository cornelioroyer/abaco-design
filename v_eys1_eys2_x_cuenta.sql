
drop view v_eys1_eys2_x_cuenta ;

create view v_eys1_eys2_x_cuenta as
select almacen.compania, articulos_por_almacen.cuenta, eys1.fecha, 
articulos_por_almacen.articulo, eys1.no_transaccion,
sum(eys2.costo * invmotivos.signo) as debito, 0 as credito
from almacen, eys1, eys2, invmotivos, articulos_por_almacen
where almacen.almacen = eys1.almacen
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys2.almacen = articulos_por_almacen.almacen
and eys2.articulo = articulos_por_almacen.articulo
group by 1, 2, 3, 4, 5
having sum(eys2.costo * invmotivos.signo) > 0
union
select almacen.compania, articulos_por_almacen.cuenta, eys1.fecha, 
articulos_por_almacen.articulo, eys1.no_transaccion, 
0, sum(eys2.costo * invmotivos.signo)
from almacen, eys1, eys2, invmotivos, articulos_por_almacen
where almacen.almacen = eys1.almacen
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys2.almacen = articulos_por_almacen.almacen
and eys2.articulo = articulos_por_almacen.articulo
group by 1, 2, 3, 4, 5
having sum(eys2.costo * invmotivos.signo) < 0

