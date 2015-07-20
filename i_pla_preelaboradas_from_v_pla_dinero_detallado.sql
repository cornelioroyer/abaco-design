
insert into pla_preelaboradas(compania, codigo_empleado, concepto, fecha, monto)
select 1357, codigo_empleado, concepto, fecha, sum(monto)
from v_pla_dinero_detallado
where compania = 1261
and exists 
(select * from pla_empleados
where pla_empleados.compania = 1357
and pla_empleados.codigo_empleado = v_pla_dinero_detallado.codigo_empleado)
group by codigo_empleado, concepto, fecha

