
drop table tmp_cias_expiradas;

create table tmp_cias_expiradas as
select pla_empleados.compania as compania, pla_companias.nombre, count(*) 
from pla_empleados, pla_companias
where pla_empleados.compania = pla_companias.compania
group by 1, 2
order by 3 desc
limit 10

