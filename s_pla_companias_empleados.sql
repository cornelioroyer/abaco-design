
select pla_companias.nombre, count(*)
from pla_companias, pla_empleados
where pla_companias.compania = pla_empleados.compania
and pla_empleados.status in ('A','V')
and pla_companias.fecha_de_expiracion >= current_date
group by 1
order by 1


