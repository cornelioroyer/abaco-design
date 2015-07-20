set search_path to planilla;

delete from pla_dinero
using pla_periodos
where pla_dinero.id_periodos = pla_periodos.id
and pla_periodos.compania in (1142)
and pla_dinero.concepto = '119'
and pla_dinero.tipo_de_calculo = '1'
and pla_periodos.year = 2014
and pla_periodos.tipo_de_planilla = '3'
and pla_periodos.numero_planilla= 9
and pla_dinero.id_pla_cheques_1 is null
