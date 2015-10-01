
rollback work;

/*
begin work;
    update pla_marcaciones
    set turno = 2
    from pla_tarjeta_tiempo, pla_periodos
    where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
    and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
    and pla_periodos.tipo_de_planilla = '3'
    and pla_periodos.year = 2015
    and pla_periodos.numero_planilla = 17
    and f_to_date(pla_marcaciones.entrada) >= '2015-08-01'
    and pla_periodos.compania = 1378;
commit work;

begin work;
    update pp_horarios
    set turno = 2
    from pla_empleados
    where pla_empleados.compania = pp_horarios.compania
    and pla_empleados.codigo_empleado = pp_horarios.codigo_empleado
    and pla_empleados.tipo_de_planilla = '3'
    and pp_horarios.compania = 1378
    and pp_horarios.numero_planilla = 17
    and pp_horarios.fecha >= '2015-08-01';
commit work;

*/

begin work;
    update pp_horarios
    set pla_periodos_id = 469815
    from pla_empleados
    where pla_empleados.compania = pp_horarios.compania
    and pla_empleados.codigo_empleado = pp_horarios.codigo_empleado
    and pla_empleados.tipo_de_planilla = '3'
    and pp_horarios.compania = 1378
    and pp_horarios.numero_planilla = 17
    and pp_horarios.fecha >= '2015-08-01';
commit work;

