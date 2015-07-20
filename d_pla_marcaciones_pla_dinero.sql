

-- set search_path to planilla;

rollback work;

begin work;

    delete from pla_marcaciones 
    using pla_tarjeta_tiempo, pla_periodos
    where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
    and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
    and pla_periodos.compania in (1365)
    and pla_periodos.year = 2015
    and pla_periodos.tipo_de_planilla = '2'
    and pla_periodos.numero_planilla= 14
    and pla_marcaciones.entrada >= '2015-01-01';

    delete from pla_dinero
    using pla_periodos
    where pla_dinero.id_periodos = pla_periodos.id
    and pla_periodos.compania in (1365)
    and pla_periodos.year = 2015
    and pla_periodos.tipo_de_planilla = '2'
    and pla_dinero.tipo_de_calculo = '1'
    and pla_periodos.numero_planilla= 14
    and pla_dinero.id_pla_cheques_1 is null;

    delete from pla_turnos_x_dia;

    delete from pla_marcaciones_movicell;

commit work;

/*

and pla_tarjeta_tiempo.codigo_empleado in ('0140')

*/


