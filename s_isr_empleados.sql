select nombre, apellido, codigo_empleado, Round(f_isr(compania, codigo_empleado, tipo_de_planilla, 2010),2) as renta
from pla_empleados
where compania in (745, 747, 747)
and fecha_terminacion_real is null
and status in ('A','V')
order by 1, 2