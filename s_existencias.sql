

create table tmp_existencias as
select almacen, articulo, sum(cantidad) as cantidad, sum(costo) as costo
from v_eys1_eys2
where fecha <= '2014-11-28'
group by 1, 2
order by 1, 2
