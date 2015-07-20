drop view v_matame;
create view v_matame as
select almacen, articulo, existencia, costo
from invbalance
where almacen = '03'
and year = 2007
and periodo = 10
union
select almacen, articulo, cantidad, costo
from v_eys1_eys2
where almacen = '03'
and anio = 2007
and mes = 11