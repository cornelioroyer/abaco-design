insert into nom_otros_ingresos (tipo_calculo,
tipo_planilla, numero_planilla, year,
codigo_empleado, compania, cod_concepto_planilla,
status, monto)
select '4','1',1,2010,codigo_empleado, '03', '121', 'A', monto/11
from nomctrac
where tipo_planilla = '1'
and numero_planilla = 49
and year = 2009
and cod_concepto_planilla = '112'