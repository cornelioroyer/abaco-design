/*
delete from pla_reservas_pp using pla_dinero, pla_periodos
where pla_reservas_pp.id_pla_dinero = pla_dinero.id
and pla_dinero.id_periodos = pla_periodos.id
and pla_periodos.tipo_de_planilla = '1'
and pla_periodos.compania = 745
and pla_periodos.year = 2009
and pla_reservas_pp.concepto in ('408','409','420','430');
*/


select pla_reservas_pp.* from pla_reservas_pp, pla_dinero, pla_periodos
where pla_reservas_pp.id_pla_dinero = pla_dinero.id
and pla_dinero.id_periodos = pla_periodos.id
and pla_periodos.tipo_de_planilla = '1'
and pla_periodos.compania = 745
and pla_periodos.year = 2009
and pla_reservas_pp.concepto in ('408','409','420','430')