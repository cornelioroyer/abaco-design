delete from pla_tarjeta_tiempo
using pla_periodos
where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_periodos.tipo_de_planilla = '2'
and pla_tarjeta_tiempo.compania = 1289
