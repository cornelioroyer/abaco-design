select pla_dinero.*
from pla_periodos, pla_dinero, pla_reservas_pp
where pla_periodos.id = pla_dinero.id_periodos
and pla_dinero.id = pla_reservas_pp.id_pla_dinero
and pla_periodos.compania = 1261
and pla_periodos.tipo_de_planilla = '2'
and pla_periodos.year = 2014
and pla_periodos.numero_planilla = 13
order by pla_dinero.concepto, pla_reservas_pp.concepto
