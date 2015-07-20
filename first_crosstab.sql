select * from crosstab('select codigo_empleado,  mes, sum(monto)
from v_pla_acumulados
where compania = 749
and concepto_calcula = ''109''
and anio = 2009
group by 1, 2
order by 1, 2')
as v_pla_acumulados(codigo_empleado char(7), mes1 decimal, mes2 decimal, mes3 decimal, mes4 decimal, mes5 decimal, mes6 decimal)