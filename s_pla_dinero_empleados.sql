
select f_pla_seguro_educativo(pla_dinero.compania, pla_dinero.codigo_empleado, pla_periodos.id, '5')
from pla_dinero, pla_periodos
where pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.tipo_de_calculo = '5'
and pla_periodos.compania = 1353
and pla_periodos.year = 2015
and pla_periodos.numero_planilla = 11
group by pla_dinero.compania, pla_dinero.codigo_empleado, pla_periodos.id



/*

f_pla_seguro_social(pla_periodos.compania, pla_reclamos.codigo_empleado,

pla_periodos.id, '5')
select f_pla_reclamos_pla_dinero(pla_periodos.compania, pla_reclamos.codigo_empleado,
pla_reclamos.tipo_de_planilla, pla_reclamos.year, pla_reclamos.numero_planilla)
from pla_reclamos, pla_periodos
where pla_periodos.compania = pla_reclamos.compania
and pla_periodos.tipo_de_planilla = pla_reclamos.tipo_de_planilla
and pla_periodos.year = pla_reclamos.year
and pla_periodos.numero_planilla = pla_reclamos.numero_planilla
and pla_periodos.compania = 1353
and pla_periodos.year = 2015
and pla_periodos.numero_planilla = 11
group by 1
order by 1


select codigo_empleado from pla_dinero, pla_periodos
where pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.compania = 1353
and pla_dinero.tipo_de_calculo = '5'
and pla_periodos.year = 2015
and pla_periodos.numero_planilla = 11
group by 1

*/

