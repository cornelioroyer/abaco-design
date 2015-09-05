

update pla_dinero
set id_periodos = 356527
from pla_periodos
where pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.compania = 880
and pla_periodos.tipo_de_planilla = '2'
and tipo_de_calculo = '7'
and codigo_empleado in ('562', '800', '124')
and pla_periodos.year = 2015
and pla_periodos.numero_planilla = 15;

