set search_path to planilla;


insert into pla_marcaciones (id_tarjeta_de_tiempo, id_pla_proyectos,
compania, turno, entrada, salida, entrada_descanso, salida_descanso,
status, autorizado)
select b.id_tarjeta_de_tiempo, b.id_pla_proyectos,
b.compania, b.turno, b.entrada, b.salida, b.entrada_descanso, b.salida_descanso,
b.status, b.autorizado
from pla_marcaciones_2 b, pla_tarjeta_tiempo_2 a, pla_periodos c
where a.id = b.id_tarjeta_de_tiempo
and c.id = a.id_periodos
and a.compania = 745
and c.year = 2013
and c.numero_planilla = 8
and c.tipo_de_planilla = '3'

