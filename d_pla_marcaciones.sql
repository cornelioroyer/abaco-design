

set search_path to planilla;

delete from pla_marcaciones
using pla_tarjeta_tiempo, pla_periodos, pla_empleados, pla_departamentos, pla_proyectos
where pla_empleados.id_pla_proyectos = pla_proyectos.id
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
and pla_tarjeta_tiempo.compania = pla_empleados.compania
and pla_tarjeta_tiempo.codigo_empleado = pla_empleados.codigo_empleado
and pla_empleados.departamento = pla_departamentos.id
and pla_periodos.compania in (1353)
and pla_periodos.year = 2015
and pla_periodos.tipo_de_planilla = '2'
and pla_periodos.numero_planilla = 18

-- select f_pla_crear_tarjetas_de_tiempo(754, '2')

/*

and f_to_date(pla_marcaciones.entrada) in ('2015-08-10');

and extract(dow from pla_marcaciones.entrada) = 0;

and trim(pla_proyectos.proyecto) = '10000010'

and pla_departamentos.departamento = '03'

and pla_periodos.numero_planilla= 14
delete from pla_dinero
using pla_periodos
where pla_periodos.compania in (1142)
and pla_dinero.id_periodos = pla_periodos.id
and pla_periodos.tipo_de_planilla = '3'
and pla_dinero.tipo_de_calculo = '1'
and pla_periodos.year = 2014
and pla_periodos.numero_planilla = 5;
*/


--and f_to_date(pla_marcaciones.entrada) = '2013-12-07'


-- set search_path to 'planilla';
/*
delete from pla_marcaciones 
using pla_tarjeta_tiempo, pla_periodos, pla_empleados, pla_departamentos
where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
and pla_tarjeta_tiempo.compania = pla_empleados.compania
and pla_tarjeta_tiempo.codigo_empleado = pla_empleados.codigo_empleado
and pla_empleados.departamento = pla_departamentos.id
and pla_departamentos.departamento = '09'
and pla_periodos.compania in (745)
and pla_periodos.year = 2013
and pla_periodos.tipo_de_planilla = '3'
and pla_periodos.numero_planilla= 25
and pla_marcaciones.entrada >= '2013-11-22';
*/


-- select f_planilla_regular(990, '2');
