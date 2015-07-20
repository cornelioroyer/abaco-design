
insert into pla_preelaboradas(compania, codigo_empleado, concepto,
fecha, monto)
select 1304, codigo_empleado, concepto_acumula, fecha, sum(monto*pla_conceptos.signo)
from v_pla_acumulados, pla_conceptos
where v_pla_acumulados.concepto_acumula = pla_conceptos.concepto
and v_pla_acumulados.compania = 749
and exists 
(select * from pla_empleados
where pla_empleados.compania = 1304
and v_pla_acumulados.codigo_empleado = pla_empleados.codigo_empleado)
group by codigo_empleado, concepto_acumula, fecha;

