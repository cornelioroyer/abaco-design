

begin work;
delete from invbalance
where year = 2013
and periodo = 12;
commit work;


begin work;
insert into invbalance (compania, aplicacion, year, periodo, articulo, almacen, existencia, costo)
select compania,'INV',2013,12,articulo,almacen,sum(cantidad), sum(costo)
from v_eys1_eys2
where fecha <= '2013-12-31' 
group by articulo, almacen, compania;
commit work;
