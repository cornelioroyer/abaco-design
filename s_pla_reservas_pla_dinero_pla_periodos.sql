select pla_dinero.concepto, pla_dinero.monto, pla_reservas_pp.* 
from pla_reservas_pp, pla_dinero, pla_periodos
where pla_dinero.id = pla_reservas_pp.id_pla_dinero
and pla_dinero.id_periodos = pla_periodos.id
and pla_periodos.compania = 1199
and pla_periodos.dia_d_pago >= '2014-05-01'
and pla_dinero.codigo_empleado = '160001'
order by 1
