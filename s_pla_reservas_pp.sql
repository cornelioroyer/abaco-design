select pla_reservas_pp.monto, pla_dinero.monto*pla_conceptos.signo
from pla_reservas_pp, pla_dinero, pla_periodos, pla_conceptos
where pla_reservas_pp.id_pla_dinero = pla_dinero.id
and pla_dinero.concepto = pla_conceptos.concepto
and pla_periodos.id = pla_dinero.id_periodos
and pla_periodos.compania = 745
and pla_periodos.tipo_de_planilla = '3'
and pla_periodos.year = 2012
and pla_periodos.numero_planilla = 11
and pla_reservas_pp.concepto = '404'
and pla_dinero.id_pla_proyectos = 1016
