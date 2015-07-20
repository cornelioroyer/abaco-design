select pla_dinero.concepto, pla_dinero.monto, pla_reservas_pp.concepto, 
pla_reservas_pp.monto
from pla_periodos, pla_dinero, pla_reservas_pp
where pla_periodos.id = pla_dinero.id_periodos
and pla_dinero.id = pla_reservas_pp.id_pla_dinero
and pla_periodos.compania = 1199
and pla_periodos.dia_d_pago >= '2014-01-01'
and pla_dinero.codigo_empleado = '160003'
order by pla_dinero.concepto, pla_reservas_pp.concepto
