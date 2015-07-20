
select pla_tarjeta_tiempo.codigo_empleado, pla_marcaciones.entrada, count(*)
from pla_tarjeta_tiempo, pla_marcaciones, pla_periodos
where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_tarjeta_tiempo.compania = 960
and pla_periodos.year = 2014
and date(pla_marcaciones.entrada) >= '2014-12-12'
group by 1, 2
having count(*) > 1
order by 1, 2

/*
and pla_periodos.tipo_de_planilla = '2'
and pla_periodos.numero_planilla = 14
having count(*) > 1
and trim(pla_tarjeta_tiempo.codigo_empleado) = '0569'

*/
