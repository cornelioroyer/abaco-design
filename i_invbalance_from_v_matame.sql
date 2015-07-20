delete from invbalance
where almacen = '03'
and year = 2007
and periodo = 11;

insert into invbalance(compania, aplicacion,
year, periodo, articulo, almacen, existencia, costo)
select '03','INV',2007,11, articulo, almacen, sum(existencia), sum(costo)
from v_matame
group by almacen, articulo;

