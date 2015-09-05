

set search_path to planilla;

delete from pla_dinero
using pla_periodos
where pla_dinero.id_periodos = pla_periodos.id
and pla_periodos.compania in (880)
and pla_periodos.tipo_de_planilla = '2'
and pla_periodos.year = 2015
and pla_dinero.tipo_de_calculo in ('3')
and pla_periodos.numero_planilla = 16;



/*

and pla_dinero.monto = 0
and pla_periodos.tipo_de_planilla = '2'


and monto = 0;

and Mes(pla_periodos.dia_d_pago) = 4

delete from pla_dinero
using pla_periodos
where pla_dinero.id_periodos = pla_periodos.id
and pla_periodos.compania in (1324)
and pla_dinero.tipo_de_calculo = '3'
and pla_periodos.year = 2014
and pla_periodos.tipo_de_planilla = '3'
and pla_periodos.dia_d_pago >= '2014-12-01'

*/
