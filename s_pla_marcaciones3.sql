
insert int pla_marcaciones(id_pla_tarjeta_de_tiempo, id_pla_proyectos
compania, turno, entrada, salida, entrada_descando, salida_descanso, status, autorizado)
select pla_marcaciones3.*
from pla_tarjeta_tiempo, pla_periodos, pla_marcaciones3
where pla_tarjeta_tiempo.id = pla_marcaciones3.id_tarjeta_de_tiempo
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_tarjeta_tiempo.compania = 1075
and pla_periodos.year = 2014
and pla_periodos.tipo_de_planilla = '2'
and pla_periodos.numero_planilla = 12;
