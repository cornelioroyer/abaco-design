

update pla_horas
set minutos_implemento = 0, implemento = null, minutos_ampliacion = 0, id_pla_eventos = null
from pla_marcaciones, pla_tarjeta_tiempo, pla_periodos
where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_marcaciones.id = pla_horas.id_marcaciones
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_tarjeta_tiempo.compania = 1353
and pla_periodos.year = 2015
and pla_periodos.tipo_de_planilla = '2'
and pla_periodos.numero_planilla in (11,12)
and date(pla_marcaciones.entrada) between '2015-06-11' and '2015-07-15';
