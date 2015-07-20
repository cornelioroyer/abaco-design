delete from pla_preelaborada where cod_concepto_planilla = '101';

insert into pla_preelaborada(cod_concepto_planilla,
codigo_empleado, compania, fecha, monto)
select '101',codigo_empleado, '03', fecha, sum(salext)
from tmp_acumulados2
where codigo_empleado in
(select codigo_empleado from rhuempl)
group by codigo_empleado, fecha;

delete from pla_preelaborada where monto = 0;