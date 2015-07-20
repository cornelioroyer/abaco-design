

SELECT pla_companias.nombre, count(*)
from pla_empleados, pla_companias
where pla_empleados.compania = pla_companias.compania
and pla_empleados.status in ('A','V') and fecha_terminacion_real is null
group by 1
order by 2 desc
