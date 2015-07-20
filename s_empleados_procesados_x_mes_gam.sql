select pla_dinero.codigo_empleado
from pla_dinero, pla_periodos
where pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.tipo_de_calculo = '1'
and pla_dinero.compania in (1353)
and Anio(pla_periodos.dia_d_pago) = 2015
and Mes(pla_periodos.dia_d_pago) = 6
group by pla_dinero.codigo_empleado
order by pla_dinero.codigo_empleado
