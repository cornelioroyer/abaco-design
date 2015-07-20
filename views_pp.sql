set search_path to planilla;

drop view v_pla_implementos_valorizados cascade;
drop view v_pla_horas_valorizadas;
drop view v_pla_horas_valorizadas_old;
drop view v_pla_cheques_empleados_pendientes;
drop view v_pla_retenciones_hechas;
drop view v_pla_acumulados;
drop view v_pla_acumulados_03;
drop view v_pla_acumulados_pla_dinero;
drop view v_pla_dinero_pla_reservas_pp;
drop view v_pla_dinero_detallado;
drop view v_pla_dinero_resumido;
drop view v_pla_costos_x_proyecto;
drop view v_pla_acreedores_pendiente_de_pago;
drop view v_pla_cheques_1_pla_cheques_2;
drop view v_pla_cheques_peachtree;
drop view v_pla_cheques_peachtree2;
drop view v_pla_dinero_cheques;
drop view v_pla_dinero_preelaborada;
drop view v_pla_comprobante_contable;
drop view v_pla_reservas;
drop view v_status_renta;
drop view v_pla_dinero_resumido_corriente;
drop view v_pla_dinero_detallado_proyecto;
drop view v_pla_horas_valorizadas_seceyco;
drop view v_pla_acumulados_isr cascade;
drop view v_pla_dinero_mec cascade;
drop view v_informe_suntracs;
drop view v_planilla_sipe_alianza;
drop view v_pla_horarios_grupo_deg;
drop view v_pla_horarios_movicell;
drop view v_pla_horarios;
drop view v_pla_horarios_suntracs cascade;
drop view v_saldo_pla_retenciones;
drop view v_pp_reservas;
drop view v_planilla_sipe_otros cascade;
drop view v_planilla_sipe_winsoft cascade;
drop view v_planilla_sipe_gam cascade;

create view v_planilla_sipe_gam as
select pla_companias.compania, trim(pla_companias.nombre) as nombre_cia, pla_empleados.codigo_empleado, 
trim(pla_empleados.nombre) as nombre,
trim(pla_empleados.apellido) as apellido,
Anio(pla_periodos.dia_d_pago) as anio,
Mes(pla_periodos.dia_d_pago) as mes,
pla_estructura.columna,
sum(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_periodos, pla_conceptos, pla_columnas, pla_estructura, pla_empleados, 
pla_companias
where pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.concepto = pla_conceptos.concepto
and pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
and pla_dinero.concepto = pla_estructura.concepto
and pla_dinero.compania = pla_companias.compania
and pla_estructura.columna = pla_columnas.columna
and pla_dinero.compania in (1353)
and pla_estructura.listado = 1
and pla_periodos.dia_d_pago >= current_date - 40
group by 1, 2, 3, 4, 5, 6, 7, 8;


create view v_planilla_sipe_winsoft as
select pla_companias.compania, trim(pla_companias.nombre) as nombre_cia, pla_empleados.codigo_empleado, 
trim(pla_empleados.nombre) as nombre,
trim(pla_empleados.apellido) as apellido,
Anio(pla_periodos.dia_d_pago) as anio,
Mes(pla_periodos.dia_d_pago) as mes,
pla_estructura.columna,
sum(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_periodos, pla_conceptos, pla_columnas, pla_estructura, pla_empleados, 
pla_companias
where pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.concepto = pla_conceptos.concepto
and pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
and pla_dinero.concepto = pla_estructura.concepto
and pla_dinero.compania = pla_companias.compania
and pla_estructura.columna = pla_columnas.columna
and pla_dinero.compania in (1341, 1324, 1286, 1287, 1288, 1289, 1290, 1292, 1293, 1294, 1295, 1296, 1297, 1298, 1299, 1300, 1302, 1303, 1305, 1321, 1322, 1340, 1347)
and pla_estructura.listado = 1
and pla_periodos.dia_d_pago >= current_date - 40
group by 1, 2, 3, 4, 5, 6, 7, 8;




/*
create view v_pp_reservas as
select pla_companias.compania, pla_companias.nombre as nombre_compania, 
pla_empleados.nombre, pla_empleados.apellido, pla_empleados.fecha_inicio as fecha_de_inicio,
f_vacacion_proporcional(pla_empleados.compania, codigo_empleado, current_date) as vacacion_proporcional,
f_xiii_proporcional(pla_empleados.compania, codigo_empleado, current_date) as xiii_proporcional,
f_prima_de_antiguedad(pla_empleados.compania, codigo_empleado, current_date) as prima_de_antiguedad,
f_indemnizacion(pla_empleados.compania, codigo_empleado, current_date) as indemnizacion,
(pla_empleados.salario_bruto*2) as preaviso
from pla_empleados, pla_companias
where pla_empleados.compania = pla_companias.compania
and pla_empleados.compania in (1075)
and fecha_terminacion_real is null and pla_empleados.status in ('A','V');
*/


create view v_pp_reservas as
select pla_companias.compania, pla_companias.nombre as nombre_compania, 
pla_empleados.nombre, pla_empleados.apellido, pla_empleados.fecha_inicio as fecha_de_inicio,
f_vacacion_proporcional(pla_empleados.compania, codigo_empleado, '2015-06-30') as vacacion_proporcional,
f_xiii_proporcional(pla_empleados.compania, codigo_empleado, '2015-06-30') as xiii_proporcional,
f_prima_de_antiguedad(pla_empleados.compania, codigo_empleado, '2015-06-30') as prima_de_antiguedad,
f_indemnizacion(pla_empleados.compania, codigo_empleado, '2015-06-30') as indemnizacion,
(pla_empleados.salario_bruto*2) as preaviso
from pla_empleados, pla_companias
where pla_empleados.compania = pla_companias.compania
and pla_empleados.compania in (1075)
and fecha_terminacion_real is null and pla_empleados.status in ('A','V');


create view v_saldo_pla_retenciones as
select pla_retenciones.compania, pla_companias.nombre as nombre_cia,  
trim(pla_empleados.nombre) || '  ' || trim(pla_empleados.apellido) as nombre_empleado,
pla_retenciones.codigo_empleado, pla_departamentos.descripcion as desc_departamento, 
pla_departamentos.departamento, pla_acreedores.nombre as nombre_acreedor, 
pla_acreedores.acreedor, 
pla_retenciones.id,
pla_retenciones.numero_documento,
pla_retenciones.descripcion_descuento, 
pla_retenciones.fecha_inidescto as fecha_inicio_descuento,
pla_retenciones.monto_original_deuda as monto_original_deuda, 
f_saldo_pla_retenciones(pla_retenciones.id, current_date) as saldo
from pla_companias, pla_acreedores, pla_retenciones,  pla_empleados, pla_departamentos
where pla_retenciones.compania = pla_companias.compania
and pla_retenciones.compania = pla_empleados.compania
and pla_retenciones.codigo_empleado = pla_empleados.codigo_empleado
and pla_empleados.departamento = pla_departamentos.id
and pla_retenciones.acreedor = pla_acreedores.acreedor
and pla_retenciones.compania = pla_acreedores.compania
and pla_retenciones.status <> 'I'
and pla_empleados.status in ('A','V');

/*
and pla_retenciones.compania in (1261);
*/

create view v_pla_horarios_suntracs as
select pla_tarjeta_tiempo.compania, pla_tarjeta_tiempo.codigo_empleado,
trim(trim(pla_empleados.nombre) || ' ' || trim(pla_empleados.apellido)) as nombre, 
trim(pla_cargos.descripcion) as cargo,
pla_periodos.numero_planilla as numero_de_planilla,
pla_marcaciones.turno,
f_to_date(pla_marcaciones.entrada) as fecha, 
pla_marcaciones.status, pla_marcaciones.autorizado, 
trim(pla_proyectos.proyecto) as proyecto, 
f_extract_time(pla_marcaciones.entrada) as entrada1, 
f_extract_time(pla_marcaciones.salida) as salida1, 
'' as implemento,
'' as entrada2, '' as salida2,
'' as entrada3, '' as salida3
from pla_tarjeta_tiempo, pla_marcaciones, pla_periodos, pla_empleados, pla_proyectos, pla_cargos
where pla_proyectos.id = pla_marcaciones.id_pla_proyectos
and pla_empleados.cargo = pla_cargos.id
and pla_empleados.compania = pla_tarjeta_tiempo.compania
and pla_empleados.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_tarjeta_tiempo.compania in (1341, 1189, 1353)
and pla_periodos.dia_d_pago >= current_date - 40;

/*
and pla_tarjeta_tiempo.codigo_empleado in ('0105')
*/

create view v_pla_horas_valorizadas_old as
select '1' as tipo_de_calculo, pla_marcaciones.id as id_pla_marcaciones, 
pla_marcaciones.compania, pla_tarjeta_tiempo.codigo_empleado,
trim(pla_empleados.nombre) as nombre, trim(pla_empleados.apellido) as apellido,
date(pla_marcaciones.entrada) as fecha,
pla_empleados.departamento as id_pla_departamentos,
pla_marcaciones.id_pla_proyectos,
pla_periodos.tipo_de_planilla, pla_periodos.year, pla_periodos.numero_planilla,
pla_horas.tipo_de_hora, pla_rela_horas_conceptos.concepto, pla_conceptos.descripcion,
pla_periodos.dia_d_pago, pla_tipos_de_horas.recargo, pla_tipos_de_horas.tiempo_regular, 
pla_tipos_de_horas.signo, 
pla_periodos.id as id_periodos,
sum((pla_horas.minutos)*pla_tipos_de_horas.signo) as minutos,
Round(sum((pla_horas.minutos*pla_tipos_de_horas.signo))*avg(pla_tipos_de_horas.recargo*pla_horas.tasa_por_minuto), 2) as monto
from pla_horas, pla_marcaciones, pla_tarjeta_tiempo, pla_periodos, 
pla_rela_horas_conceptos, pla_tipos_de_horas, pla_conceptos, pla_empleados
where pla_empleados.compania = pla_tarjeta_tiempo.compania
and pla_empleados.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado
and pla_rela_horas_conceptos.concepto = pla_conceptos.concepto
and pla_horas.id_marcaciones = pla_marcaciones.id
and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_horas.tipo_de_hora = pla_rela_horas_conceptos.tipo_de_hora
and pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
and pla_horas.minutos <> 0
and date(pla_marcaciones.entrada) >= '2014-01-01'
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11, 12, 13, 14, 15,16, 17, 18, 19, 20
union
select '5', 0, pla_reclamos.compania, pla_reclamos.codigo_empleado,
trim(pla_empleados.nombre) as nombre, trim(pla_empleados.apellido) as apellido,
pla_reclamos.fecha, pla_reclamos.id_pla_departamentos,
pla_reclamos.id_pla_proyectos,
pla_reclamos.tipo_de_planilla, pla_reclamos.year, pla_reclamos.numero_planilla,
pla_reclamos.tipo_de_hora, pla_rela_horas_conceptos.concepto, pla_conceptos.descripcion,
pla_periodos.dia_d_pago, pla_tipos_de_horas.recargo, pla_tipos_de_horas.tiempo_regular, 
pla_tipos_de_horas.signo, 
pla_periodos.id as id_periodos,
Round(sum((pla_reclamos.horas/60)*pla_tipos_de_horas.signo), 2),
Round(sum((pla_reclamos.horas*pla_tipos_de_horas.signo))*avg(pla_tipos_de_horas.recargo*pla_reclamos.tasa_por_hora),2) as monto
from pla_reclamos, pla_periodos, pla_rela_horas_conceptos, pla_tipos_de_horas, pla_conceptos, pla_empleados
where pla_reclamos.compania = pla_periodos.compania
and pla_reclamos.tipo_de_planilla = pla_periodos.tipo_de_planilla
and pla_reclamos.compania = pla_empleados.compania
and pla_reclamos.codigo_empleado = pla_empleados.codigo_empleado
and pla_reclamos.year = pla_periodos.year
and pla_reclamos.numero_planilla = pla_periodos.numero_planilla
and pla_reclamos.tipo_de_hora = pla_rela_horas_conceptos.tipo_de_hora
and pla_rela_horas_conceptos.concepto = pla_conceptos.concepto
and pla_rela_horas_conceptos.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
and pla_reclamos.fecha >= '2014-01-01'
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11, 12, 13, 14, 15,16, 17, 18, 19, 20;

/*
create view v_pla_horas_valorizadas as
select '1' as tipo_de_calculo, pla_marcaciones.id as id_pla_marcaciones, 
pla_marcaciones.compania, pla_tarjeta_tiempo.codigo_empleado,
trim(pla_empleados.nombre) as nombre, trim(pla_empleados.apellido) as apellido,
date(pla_marcaciones.entrada) as fecha,
pla_empleados.departamento as id_pla_departamentos,
pla_marcaciones.id_pla_proyectos,
pla_periodos.tipo_de_planilla, pla_periodos.year, pla_periodos.numero_planilla,
pla_horas.tipo_de_hora, pla_rela_horas_conceptos.concepto, pla_conceptos.descripcion,
pla_periodos.dia_d_pago, pla_tipos_de_horas.recargo, pla_tipos_de_horas.tiempo_regular, 
pla_tipos_de_horas.signo, 
pla_periodos.id as id_periodos,
sum((pla_horas.minutos)*pla_tipos_de_horas.signo) as minutos,
Round(sum((pla_horas.minutos*pla_tipos_de_horas.signo))*avg(pla_tipos_de_horas.recargo*pla_horas.tasa_por_minuto), 2) as monto
from pla_horas, pla_marcaciones, pla_tarjeta_tiempo, pla_periodos, 
pla_rela_horas_conceptos, pla_tipos_de_horas, pla_conceptos, pla_empleados
where pla_empleados.compania = pla_tarjeta_tiempo.compania
and pla_empleados.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado
and pla_rela_horas_conceptos.concepto = pla_conceptos.concepto
and pla_horas.id_marcaciones = pla_marcaciones.id
and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_horas.tipo_de_hora = pla_rela_horas_conceptos.tipo_de_hora
and pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
and date(pla_marcaciones.entrada) >= '2013-01-01'
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11, 12, 13, 14, 15,16, 17, 18, 19, 20
union
select '5', 0, pla_reclamos.compania, pla_reclamos.codigo_empleado,
trim(pla_empleados.nombre) as nombre, trim(pla_empleados.apellido) as apellido,
pla_reclamos.fecha, pla_reclamos.id_pla_departamentos,
pla_reclamos.id_pla_proyectos,
pla_reclamos.tipo_de_planilla, pla_reclamos.year, pla_reclamos.numero_planilla,
pla_reclamos.tipo_de_hora, pla_rela_horas_conceptos.concepto, pla_conceptos.descripcion,
pla_periodos.dia_d_pago, pla_tipos_de_horas.recargo, pla_tipos_de_horas.tiempo_regular, 
pla_tipos_de_horas.signo, 
pla_periodos.id as id_periodos,
Round(sum((pla_reclamos.horas/60)*pla_tipos_de_horas.signo), 2),
Round(sum((pla_reclamos.horas*pla_tipos_de_horas.signo))*avg(pla_tipos_de_horas.recargo*pla_reclamos.tasa_por_hora),2) as monto
from pla_reclamos, pla_periodos, pla_rela_horas_conceptos, pla_tipos_de_horas, pla_conceptos, pla_empleados
where pla_reclamos.compania = pla_periodos.compania
and pla_reclamos.tipo_de_planilla = pla_periodos.tipo_de_planilla
and pla_reclamos.compania = pla_empleados.compania
and pla_reclamos.codigo_empleado = pla_empleados.codigo_empleado
and pla_reclamos.year = pla_periodos.year
and pla_reclamos.numero_planilla = pla_periodos.numero_planilla
and pla_reclamos.tipo_de_hora = pla_rela_horas_conceptos.tipo_de_hora
and pla_rela_horas_conceptos.concepto = pla_conceptos.concepto
and pla_rela_horas_conceptos.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
and pla_reclamos.fecha >= '2013-01-01'
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11, 12, 13, 14, 15,16, 17, 18, 19, 20;
*/


create view v_pla_horas_valorizadas as
select '1' as tipo_de_calculo, pla_marcaciones.id as id_pla_marcaciones, 
pla_marcaciones.compania, pla_tarjeta_tiempo.codigo_empleado,
trim(pla_empleados.nombre) as nombre, trim(pla_empleados.apellido) as apellido,
date(pla_marcaciones.entrada) as fecha,
pla_empleados.departamento as id_pla_departamentos,
pla_marcaciones.id_pla_proyectos,
pla_periodos.tipo_de_planilla, pla_periodos.year, pla_periodos.numero_planilla,
pla_horas.tipo_de_hora, pla_rela_horas_conceptos.concepto, pla_conceptos.descripcion,
pla_periodos.dia_d_pago, pla_tipos_de_horas.recargo, pla_tipos_de_horas.tiempo_regular, 
pla_tipos_de_horas.signo, 
pla_periodos.id as id_periodos,
((pla_horas.minutos)*pla_tipos_de_horas.signo) as minutos,
Round(((pla_horas.minutos*pla_tipos_de_horas.signo))*(pla_tipos_de_horas.recargo*pla_horas.tasa_por_minuto), 2) as monto
from pla_horas, pla_marcaciones, pla_tarjeta_tiempo, pla_periodos, 
pla_rela_horas_conceptos, pla_tipos_de_horas, pla_conceptos, pla_empleados
where pla_empleados.compania = pla_tarjeta_tiempo.compania
and pla_empleados.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado
and pla_rela_horas_conceptos.concepto = pla_conceptos.concepto
and pla_horas.id_marcaciones = pla_marcaciones.id
and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_horas.tipo_de_hora = pla_rela_horas_conceptos.tipo_de_hora
and pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
and date(pla_marcaciones.entrada) >= '2014-01-01'
union
select '5', 0, pla_reclamos.compania, pla_reclamos.codigo_empleado,
trim(pla_empleados.nombre) as nombre, trim(pla_empleados.apellido) as apellido,
pla_reclamos.fecha, pla_reclamos.id_pla_departamentos,
pla_reclamos.id_pla_proyectos,
pla_reclamos.tipo_de_planilla, pla_reclamos.year, pla_reclamos.numero_planilla,
pla_reclamos.tipo_de_hora, pla_rela_horas_conceptos.concepto, pla_conceptos.descripcion,
pla_periodos.dia_d_pago, pla_tipos_de_horas.recargo, pla_tipos_de_horas.tiempo_regular, 
pla_tipos_de_horas.signo, 
pla_periodos.id as id_periodos,
Round(sum((pla_reclamos.horas/60)*pla_tipos_de_horas.signo), 2),
Round(sum((pla_reclamos.horas*pla_tipos_de_horas.signo))*avg(pla_tipos_de_horas.recargo*pla_reclamos.tasa_por_hora),2) as monto
from pla_reclamos, pla_periodos, pla_rela_horas_conceptos, pla_tipos_de_horas, pla_conceptos, pla_empleados
where pla_reclamos.compania = pla_periodos.compania
and pla_reclamos.tipo_de_planilla = pla_periodos.tipo_de_planilla
and pla_reclamos.compania = pla_empleados.compania
and pla_reclamos.codigo_empleado = pla_empleados.codigo_empleado
and pla_reclamos.year = pla_periodos.year
and pla_reclamos.numero_planilla = pla_periodos.numero_planilla
and pla_reclamos.tipo_de_hora = pla_rela_horas_conceptos.tipo_de_hora
and pla_rela_horas_conceptos.concepto = pla_conceptos.concepto
and pla_rela_horas_conceptos.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
and pla_reclamos.fecha >= '2014-01-01'
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11, 12, 13, 14, 15,16, 17, 18, 19, 20;


create view v_pla_horarios as
select pla_tarjeta_tiempo.compania, pla_tarjeta_tiempo.codigo_empleado,
trim(trim(pla_empleados.nombre) || ' ' || trim(pla_empleados.apellido)) as nombre, 
pla_periodos.numero_planilla as numero_de_planilla,
f_to_date(pla_marcaciones.entrada) as fecha, pla_marcaciones.turno,pla_marcaciones.status, pla_marcaciones.autorizado, 
trim(pla_proyectos.proyecto) as proyecto, null as entrada, null as salida
from pla_tarjeta_tiempo, pla_marcaciones, pla_periodos, pla_empleados, pla_proyectos
where pla_proyectos.id = pla_marcaciones.id_pla_proyectos
and pla_empleados.compania = pla_tarjeta_tiempo.compania
and pla_empleados.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_tarjeta_tiempo.compania in (1075, 1324, 1316, 1341, 1321)
and pla_periodos.dia_d_pago >= '2015-01-01';


create view v_pla_horarios_movicell as
select pla_tarjeta_tiempo.compania, pla_tarjeta_tiempo.codigo_empleado,
trim(trim(pla_empleados.nombre) || ' ' || trim(pla_empleados.apellido)) as nombre, 
pla_periodos.numero_planilla as numero_de_planilla,
f_to_date(pla_marcaciones.entrada) as fecha, pla_marcaciones.turno,'R' as status, pla_marcaciones.autorizado, 
trim(pla_proyectos.proyecto) as proyecto, null as entrada, null as salida
from pla_tarjeta_tiempo, pla_marcaciones, pla_periodos, pla_empleados, pla_proyectos
where pla_proyectos.id = pla_marcaciones.id_pla_proyectos
and pla_empleados.compania = pla_tarjeta_tiempo.compania
and pla_empleados.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_tarjeta_tiempo.compania in (1316, 1341)
and pla_periodos.dia_d_pago >= '2015-01-01';



create view v_pla_horarios_grupo_deg as
select pla_tarjeta_tiempo.compania, pla_tarjeta_tiempo.codigo_empleado,
trim(trim(pla_empleados.nombre) || ' ' || trim(pla_empleados.apellido)) as nombre, 
pla_periodos.numero_planilla as numero_de_planilla,
pla_marcaciones.turno,
f_to_date(pla_marcaciones.entrada) as fecha, 
pla_marcaciones.status, pla_marcaciones.autorizado, 
trim(pla_proyectos.proyecto) as proyecto, null as entrada, null as salida
from pla_tarjeta_tiempo, pla_marcaciones, pla_periodos, pla_empleados, pla_proyectos
where pla_proyectos.id = pla_marcaciones.id_pla_proyectos
and pla_empleados.compania = pla_tarjeta_tiempo.compania
and pla_empleados.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
and pla_tarjeta_tiempo.compania in (1075, 1324, 1316, 1341, 1321, 1322, 1189)
and pla_periodos.dia_d_pago >= '2015-04-01';




create view v_planilla_sipe_alianza as
select pla_companias.compania, trim(pla_companias.nombre) as nombre_cia, pla_empleados.codigo_empleado, 
trim(pla_empleados.nombre) as nombre,
trim(pla_empleados.apellido) as apellido,
Anio(pla_periodos.dia_d_pago) as anio,
Mes(pla_periodos.dia_d_pago) as mes,
pla_estructura.columna,
sum(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_periodos, pla_conceptos, pla_columnas, pla_estructura, pla_empleados, 
pla_companias
where pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.concepto = pla_conceptos.concepto
and pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
and pla_dinero.concepto = pla_estructura.concepto
and pla_dinero.compania = pla_companias.compania
and pla_estructura.columna = pla_columnas.columna
and pla_dinero.compania in (1286, 1287, 1288, 1289, 1290, 1292, 1293, 1294, 1295, 1296, 1297, 1298, 1299, 1300, 1302, 1303, 1305, 1321, 1322, 1340, 1347)
and pla_estructura.listado = 1
and pla_periodos.dia_d_pago >= current_date - 40
group by 1, 2, 3, 4, 5, 6, 7, 8;


create view v_planilla_sipe_otros as
select pla_companias.compania, trim(pla_companias.nombre) as nombre_cia, pla_empleados.codigo_empleado, 
trim(pla_empleados.nombre) as nombre,
trim(pla_empleados.apellido) as apellido,
Anio(pla_periodos.dia_d_pago) as anio,
Mes(pla_periodos.dia_d_pago) as mes,
pla_estructura.columna,
sum(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_periodos, pla_conceptos, pla_columnas, pla_estructura, pla_empleados, 
pla_companias
where pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.concepto = pla_conceptos.concepto
and pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
and pla_dinero.concepto = pla_estructura.concepto
and pla_dinero.compania = pla_companias.compania
and pla_estructura.columna = pla_columnas.columna
and pla_dinero.compania in (1341, 1324)
and pla_estructura.listado = 1
and pla_periodos.dia_d_pago >= current_date - 40
group by 1, 2, 3, 4, 5, 6, 7, 8;




create view v_informe_suntracs as
select pla_dinero.compania, trim(pla_empleados.apellido) as apellido,
trim(pla_empleados.nombre) as nombre,
trim(pla_empleados.cedula) as cedula,
trim(pla_cargos.descripcion) as calificacion,
pla_periodos.dia_d_pago as fecha,
pla_empleados.tasa_por_hora as salario_por_hora,
sum(case when pla_periodos.periodo = 1 and trim(pla_dinero.concepto) <> '108' then pla_dinero.monto * pla_conceptos.signo else 0 end) as primera_bisemana,
sum(case when pla_periodos.periodo = 2 and trim(pla_dinero.concepto) <> '108' then pla_dinero.monto * pla_conceptos.signo else 0 end) as segunda_bisemana,
sum(case when pla_periodos.periodo = 3 and trim(pla_dinero.concepto) <> '108' then pla_dinero.monto * pla_conceptos.signo else 0 end) as tercera_bisemana,
sum(case when trim(pla_dinero.concepto) = '108' then pla_dinero.monto * pla_conceptos.signo else 0 end) as vacaciones
from pla_empleados, pla_dinero, pla_conceptos, 
pla_conceptos_acumulan, pla_periodos,
pla_cargos
where pla_empleados.compania = pla_dinero.compania
and pla_empleados.codigo_empleado = pla_dinero.codigo_empleado
and pla_dinero.concepto = pla_conceptos.concepto
and pla_dinero.id_periodos = pla_periodos.id
and pla_cargos.id = pla_empleados.cargo
and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
and pla_conceptos_acumulan.concepto = '202'
and pla_empleados.sindicalizado = 'S'
group by 1, 2, 3, 4, 5, 6, 7;


create view v_pla_dinero_mec as
select trim(pla_companias.nombre) as desc_compania,
pla_dinero.compania, 
trim(pla_departamentos.descripcion) as desc_departamento,
pla_empleados.departamento as departamento,
trim(pla_proyectos.descripcion) as desc_proyecto,
pla_proyectos.id as id_proyecto,
trim(pla_empleados.apellido) as apellido, 
trim(pla_empleados.nombre) as nombre, 
pla_empleados.codigo_empleado, 
pla_periodos.dia_d_pago as fecha,
pla_conceptos.tipo_de_concepto,
pla_tipos_de_conceptos.descripcion as desc_tipo_de_concepto, 
pla_conceptos.concepto,
pla_conceptos.descripcion as desc_concepto,
pla_tipos_de_planilla.descripcion as desc_tipo_de_planilla,
pla_periodos.tipo_de_planilla,
pla_tipos_de_calculo.descripcion as desc_tipo_de_calculo,
pla_dinero.tipo_de_calculo,
pla_empleados.tipo_de_salario,
pla_periodos.year,
pla_periodos.numero_planilla,
(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_conceptos, pla_empleados, pla_periodos, 
pla_tipos_de_conceptos, pla_tipos_de_calculo, pla_tipos_de_planilla, 
pla_departamentos, pla_proyectos, pla_companias
where pla_dinero.concepto = pla_conceptos.concepto
and pla_companias.compania = pla_dinero.compania
and pla_proyectos.id = pla_dinero.id_pla_proyectos
and pla_empleados.departamento = pla_departamentos.id
and pla_periodos.tipo_de_planilla = pla_tipos_de_planilla.tipo_de_planilla
and pla_periodos.compania = pla_tipos_de_planilla.compania
and pla_dinero.tipo_de_calculo = pla_tipos_de_calculo.tipo_de_calculo
and pla_tipos_de_conceptos.tipo_de_concepto = pla_conceptos.tipo_de_concepto
and pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
and pla_periodos.compania in (745,746,747);

-- and pla_periodos.dia_d_pago >= '2013-01-01'



create view v_pla_acumulados_isr as
select pla_dinero.id, pla_dinero.compania, pla_dinero.codigo_empleado,
pla_empleados.apellido, pla_empleados.nombre,
(select pla_conceptos.descripcion from pla_conceptos
where pla_conceptos.concepto = pla_conceptos_acumulan.concepto) as descripcion_calcula,
pla_conceptos_acumulan.concepto as concepto_calcula,
pla_conceptos.descripcion as descripcion_acumula,
pla_conceptos.concepto as concepto_acumula, 
pla_periodos.dia_d_pago as fecha, 
Anio(pla_periodos.dia_d_pago) as anio,
Mes(pla_periodos.dia_d_pago) as mes,
(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_conceptos_acumulan, pla_dinero, pla_conceptos, pla_periodos, pla_empleados
where pla_conceptos_acumulan.concepto_aplica = pla_dinero.concepto
and pla_empleados.compania = pla_dinero.compania
and pla_empleados.codigo_empleado = pla_dinero.codigo_empleado
and pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.concepto = pla_conceptos.concepto
and pla_empleados.status in ('A', 'V', 'L','I','E')
and Anio(pla_periodos.dia_d_pago) >= 2012
union
select null, pla_preelaboradas.compania, pla_preelaboradas.codigo_empleado,
pla_empleados.apellido, pla_empleados.nombre,
(select pla_conceptos.descripcion from pla_conceptos
where pla_conceptos.concepto = pla_conceptos_acumulan.concepto) as descripcion_calcula,
pla_conceptos_acumulan.concepto as concepto_calcula,
pla_conceptos.descripcion as descripcion_acumula,
pla_conceptos.concepto as concepto_acumula, 
pla_preelaboradas.fecha, 
Anio(pla_preelaboradas.fecha),
Mes(pla_preelaboradas.fecha),
(pla_preelaboradas.monto*pla_conceptos.signo) as monto
from pla_conceptos_acumulan, pla_preelaboradas, pla_conceptos, pla_empleados
where pla_conceptos_acumulan.concepto_aplica = pla_preelaboradas.concepto
and pla_empleados.compania = pla_preelaboradas.compania
and pla_empleados.codigo_empleado = pla_preelaboradas.codigo_empleado
and pla_preelaboradas.concepto = pla_conceptos.concepto
and pla_preelaboradas.fecha >= pla_empleados.fecha_inicio
and Anio(pla_preelaboradas.fecha) >= 2012;


create view v_pla_horas_valorizadas_seceyco as
select pla_marcaciones.id as id_pla_marcaciones, 
pla_marcaciones.compania, pla_tarjeta_tiempo.codigo_empleado,
trim(pla_empleados.nombre) as nombre, trim(pla_empleados.apellido) as apellido,
pla_periodos.desde, pla_periodos.hasta,
date(pla_marcaciones.entrada) as fecha,
pla_marcaciones.entrada as entrada,
pla_marcaciones.salida as salida,
pla_empleados.departamento as id_pla_departamentos,
pla_marcaciones.id_pla_proyectos, trim(pla_proyectos.descripcion) as nombre_proyecto,
pla_periodos.tipo_de_planilla, pla_periodos.year, pla_periodos.numero_planilla,
pla_horas.tipo_de_hora, pla_rela_horas_conceptos.concepto, pla_conceptos.descripcion,
pla_periodos.dia_d_pago, pla_tipos_de_horas.recargo, pla_tipos_de_horas.tiempo_regular, 
pla_tipos_de_horas.signo, 
pla_periodos.id as id_periodos,
((pla_horas.minutos/60)*pla_tipos_de_horas.signo) as horas,
(pla_horas.tasa_por_minuto*60) as tasa_por_hora,
Round(((pla_horas.minutos*pla_tipos_de_horas.signo))*(pla_tipos_de_horas.recargo*pla_horas.tasa_por_minuto), 2) as monto
from pla_horas, pla_marcaciones, pla_tarjeta_tiempo, pla_periodos, 
pla_rela_horas_conceptos, pla_tipos_de_horas, pla_conceptos, pla_empleados, pla_proyectos
where pla_empleados.compania = pla_tarjeta_tiempo.compania
and pla_marcaciones.id_pla_proyectos = pla_proyectos.id
and pla_empleados.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado
and pla_rela_horas_conceptos.concepto = pla_conceptos.concepto
and pla_horas.id_marcaciones = pla_marcaciones.id
and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_horas.tipo_de_hora = pla_rela_horas_conceptos.tipo_de_hora
and pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
and pla_empleados.compania in (1046)
and trim(pla_empleados.codigo_empleado) not in ('000144122141')
and date(pla_marcaciones.entrada) >= '2014-03-01';

/*
create view v_pla_horas_valorizadas_seceyco as
select pla_marcaciones.compania, pla_tarjeta_tiempo.codigo_empleado,
pla_periodos.dia_d_pago, pla_tipos_de_horas.recargo, 
trim(pla_empleados.nombre) || '  ' || trim(pla_empleados.apellido) as nombre_empleado,
Round(sum((pla_horas.minutos)*pla_tipos_de_horas.signo), 2)/60 as horas,
Round(sum((pla_horas.minutos*pla_tipos_de_horas.signo))*avg(pla_tipos_de_horas.recargo*pla_horas.tasa_por_minuto),2) as monto
from pla_horas, pla_marcaciones, pla_tarjeta_tiempo, pla_periodos, 
 pla_tipos_de_horas, pla_empleados
where pla_empleados.compania = pla_tarjeta_tiempo.compania
and pla_empleados.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado
and pla_horas.id_marcaciones = pla_marcaciones.id
and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
and pla_periodos.dia_d_pago >= '2014-03-01'
and pla_empleados.compania in (1142)
group by 1, 2, 3, 4, 5
union
select pla_reclamos.compania, pla_reclamos.codigo_empleado,
pla_reclamos.fecha, pla_tipos_de_horas.recargo,  
trim(pla_empleados.nombre) || '  ' || trim(pla_empleados.apellido) as nombre_empleado,
Round(sum((pla_reclamos.horas/60)*pla_tipos_de_horas.signo), 2)/60,
Round(sum((pla_reclamos.horas*pla_tipos_de_horas.signo))*avg(pla_tipos_de_horas.recargo*pla_reclamos.tasa_por_hora),2) as monto
from pla_reclamos, pla_tipos_de_horas, pla_empleados
where pla_reclamos.compania = pla_empleados.compania
and pla_reclamos.codigo_empleado = pla_empleados.codigo_empleado
and pla_reclamos.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
and pla_reclamos.fecha >= '2014-03-01'
and pla_empleados.compania in (1142)
group by 1, 2, 3, 4, 5;
*/


create view v_pla_dinero_detallado_proyecto as
select pla_dinero.compania, trim(pla_empleados.apellido) as apellido, trim(pla_empleados.nombre) as nombre, 
pla_empleados.codigo_empleado, 
pla_dinero.id_pla_proyectos,
pla_empleados.forma_de_pago,
pla_empleados.status,
pla_conceptos.concepto,
pla_conceptos.descripcion as desc_concepto,
pla_tipos_de_planilla.descripcion as desc_tipo_de_planilla,
pla_periodos.tipo_de_planilla,
pla_tipos_de_calculo.descripcion as desc_tipo_de_calculo,
pla_dinero.tipo_de_calculo,
pla_empleados.tipo_de_salario,
pla_periodos.id as id_pla_periodos,
pla_periodos.year,
pla_periodos.numero_planilla,
pla_periodos.dia_d_pago as fecha,
pla_conceptos.tipo_de_concepto,
pla_tipos_de_conceptos.descripcion as desc_tipo_de_concepto, 
pla_conceptos.prioridad_impresion,
pla_departamentos.descripcion as desc_departamento,
pla_empleados.departamento as departamento,
pla_dinero.id_pla_cheques_1 as id_pla_cheques_1,
(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_conceptos, pla_empleados, pla_periodos, 
pla_tipos_de_conceptos, pla_tipos_de_calculo, pla_tipos_de_planilla, pla_departamentos
where pla_dinero.concepto = pla_conceptos.concepto
and pla_empleados.departamento = pla_departamentos.id
and pla_periodos.tipo_de_planilla = pla_tipos_de_planilla.tipo_de_planilla
and pla_periodos.compania = pla_tipos_de_planilla.compania
and pla_dinero.tipo_de_calculo = pla_tipos_de_calculo.tipo_de_calculo
and pla_tipos_de_conceptos.tipo_de_concepto = pla_conceptos.tipo_de_concepto
and pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado;


create view v_pla_acumulados_03 as
select pla_dinero.id, pla_dinero.compania, pla_dinero.codigo_empleado,
pla_empleados.apellido, pla_empleados.nombre,
(select pla_conceptos.descripcion from pla_conceptos
where pla_conceptos.concepto = pla_conceptos_acumulan.concepto) as descripcion_calcula,
pla_conceptos_acumulan.concepto as concepto_calcula,
pla_conceptos.descripcion as descripcion_acumula,
pla_conceptos.concepto as concepto_acumula, 
pla_periodos.dia_d_pago as fecha, 
Anio(pla_periodos.dia_d_pago) as anio,
Mes(pla_periodos.dia_d_pago) as mes,
(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_conceptos_acumulan, pla_dinero, pla_conceptos, pla_periodos, pla_empleados
where pla_conceptos_acumulan.concepto_aplica = pla_dinero.concepto
and pla_empleados.compania = pla_dinero.compania
and pla_empleados.codigo_empleado = pla_dinero.codigo_empleado
and pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.concepto = pla_conceptos.concepto
union
select null, pla_preelaboradas.compania, pla_preelaboradas.codigo_empleado,
pla_empleados.apellido, pla_empleados.nombre,
(select pla_conceptos.descripcion from pla_conceptos
where pla_conceptos.concepto = pla_conceptos_acumulan.concepto) as descripcion_calcula,
pla_conceptos_acumulan.concepto as concepto_calcula,
pla_conceptos.descripcion as descripcion_acumula,
pla_conceptos.concepto as concepto_acumula, 
pla_preelaboradas.fecha, 
Anio(pla_preelaboradas.fecha),
Mes(pla_preelaboradas.fecha),
(pla_preelaboradas.monto*pla_conceptos.signo) as monto
from pla_conceptos_acumulan, pla_preelaboradas, pla_conceptos, pla_empleados
where pla_conceptos_acumulan.concepto_aplica = pla_preelaboradas.concepto
and pla_empleados.compania = pla_preelaboradas.compania
and pla_empleados.codigo_empleado = pla_preelaboradas.codigo_empleado
and pla_preelaboradas.concepto = pla_conceptos.concepto;

create view v_pla_dinero_resumido_corriente as
select pla_dinero.compania, Trim(pla_empleados.apellido) as apellido, Trim(pla_empleados.nombre) as nombre, 
pla_empleados.codigo_empleado, 
pla_tipos_de_planilla.descripcion as desc_tipo_de_planilla, pla_periodos.tipo_de_planilla,
pla_tipos_de_calculo.descripcion as desc_tipo_de_calculo,
pla_dinero.tipo_de_calculo,
pla_periodos.year,
pla_periodos.numero_planilla,
pla_periodos.dia_d_pago as fecha,
pla_periodos.id as id_pla_periodos,
pla_departamentos.descripcion as desc_departamento,
pla_empleados.departamento as id_pla_departamento,
sum(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_conceptos, pla_empleados, pla_periodos, 
pla_tipos_de_planilla, pla_tipos_de_calculo, pla_departamentos
where pla_dinero.concepto = pla_conceptos.concepto
and pla_empleados.departamento = pla_departamentos.id
and pla_tipos_de_calculo.tipo_de_calculo = pla_dinero.tipo_de_calculo
and pla_periodos.tipo_de_planilla = pla_tipos_de_planilla.tipo_de_planilla
and pla_periodos.compania = pla_tipos_de_planilla.compania
and pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
and pla_tipos_de_planilla.planilla_actual = pla_periodos.numero_planilla
and pla_periodos.status = 'A'
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
having sum(pla_dinero.monto*pla_conceptos.signo) <> 0;


/*
create view v_status_renta as
SELECT pla_companias.nombre as nombre_cia, pla_companias.compania, 
Trim(pla_empleados.nombre) || ' ' || Trim(pla_empleados.apellido) as nombre_empleado, 
pla_empleados.codigo_empleado, 
Round(f_periodos_pago(pla_empleados.compania, pla_empleados.codigo_empleado, pla_empleados.tipo_de_planilla, Cast(Anio(current_date) as int4)),2) as periodos_pagos,
Round(f_acumulado_para(pla_empleados.compania, pla_empleados.codigo_empleado, '106', Cast(Anio(current_date) as int4) ),2) as acumulado,
Round(-f_concepto_pagado(pla_empleados.compania, pla_empleados.codigo_empleado, '106', Cast(Anio(current_date) as int4)) 
+ f_isr(pla_empleados.compania,pla_empleados.codigo_empleado,pla_empleados.tipo_de_planilla,Cast(Anio(current_date) as int4)),2) as impuesto_causado,
Round(f_concepto_pagado(pla_empleados.compania, pla_empleados.codigo_empleado, '106', Cast(Anio(current_date) as int4)),2) as impuesto_retenido,
Round(f_isr(pla_empleados.compania,pla_empleados.codigo_empleado,pla_empleados.tipo_de_planilla,Cast(Anio(current_date) as int4)),2) as renta_pagar
FROM pla_empleados, pla_companias
WHERE pla_empleados.compania = pla_companias.compania
and pla_empleados.fecha_terminacion_real Is Null 
and pla_empleados.status In ('A','V')
ORDER BY 1, 2, 3;
*/


create view v_status_renta as
SELECT pla_companias.nombre as nombre_cia, pla_companias.compania, 
Trim(pla_empleados.nombre) || ' ' || Trim(pla_empleados.apellido) as nombre_empleado, 
pla_empleados.codigo_empleado, 
Round(f_periodos_pago(pla_empleados.compania, pla_empleados.codigo_empleado, pla_empleados.tipo_de_planilla, Cast(Anio(current_date) as int4)),2) as periodos_pagos,
Round(f_acumulado_para(pla_empleados.compania, pla_empleados.codigo_empleado, '106', Cast(Anio(current_date) as int4) ),2) as acumulado,
Round(f_isr_causado(pla_empleados.compania,pla_empleados.codigo_empleado,pla_empleados.tipo_de_planilla,Cast(Anio(current_date) as int4)),2) as impuesto_causado,
-Round(f_concepto_pagado(pla_empleados.compania, pla_empleados.codigo_empleado, '106', Cast(Anio(current_date) as int4)),2) as impuesto_retenido,
Round(f_isr_causado(pla_empleados.compania,pla_empleados.codigo_empleado,pla_empleados.tipo_de_planilla,Cast(Anio(current_date) as int4)) 
 + f_concepto_pagado(pla_empleados.compania, pla_empleados.codigo_empleado, '106', Cast(Anio(current_date) as int4)),2) as renta_pagar
FROM pla_empleados, pla_companias
WHERE pla_empleados.compania = pla_companias.compania
and pla_empleados.fecha_terminacion_real Is Null 
and pla_empleados.status In ('A','V')
ORDER BY 1, 2, 3;




create view v_pla_reservas as
select pla_periodos.compania, pla_empleados.apellido, pla_empleados.nombre,
pla_empleados.codigo_empleado,
pla_dinero.tipo_de_calculo, 
pla_periodos.tipo_de_planilla, pla_periodos.year, pla_periodos.numero_planilla,
pla_dinero.id_pla_departamentos,
pla_dinero.id_pla_proyectos,
pla_periodos.dia_d_pago as fecha, 
pla_conceptos.descripcion as d_concepto_acumula, 
pla_conceptos.concepto as concepto_acumula,
(pla_dinero.monto*pla_conceptos.signo) as monto_acumula,
null as d_concepto_reserva, null as concepto_reserva, 0 as monto_reserva
from pla_periodos, pla_dinero, pla_conceptos, pla_empleados, pla_reservas_pp
where pla_periodos.id = pla_dinero.id_periodos
and pla_dinero.concepto = pla_conceptos.concepto
and pla_empleados.compania = pla_dinero.compania
and pla_empleados.codigo_empleado = pla_dinero.codigo_empleado
and pla_reservas_pp.id_pla_dinero = pla_dinero.id
union
select pla_periodos.compania, pla_empleados.apellido, pla_empleados.nombre,
pla_empleados.codigo_empleado,
pla_dinero.tipo_de_calculo, 
pla_periodos.tipo_de_planilla, pla_periodos.year, pla_periodos.numero_planilla,
pla_dinero.id_pla_departamentos,
pla_dinero.id_pla_proyectos,
pla_periodos.dia_d_pago as fecha, null, null, 0,
pla_conceptos.descripcion as d_concepto_reserva, pla_reservas_pp.concepto as concepto_reserva, 
(pla_reservas_pp.monto*pla_conceptos.signo) as monto_reserva
from pla_periodos, pla_dinero, pla_conceptos, pla_empleados, pla_reservas_pp
where pla_dinero.id = pla_reservas_pp.id_pla_dinero
and pla_periodos.id = pla_dinero.id_periodos
and pla_reservas_pp.concepto = pla_conceptos.concepto
and pla_empleados.compania = pla_dinero.compania
and pla_empleados.codigo_empleado = pla_dinero.codigo_empleado;

create view v_pla_comprobante_contable as
select pla_dinero.compania, pla_periodos.dia_d_pago,
Anio(pla_periodos.dia_d_pago) as anio, Mes(pla_periodos.dia_d_pago) as mes,
pla_cuentas.nombre, pla_cuentas.cuenta,
case when sum(pla_dinero.monto*pla_conceptos.signo) >= 0 then sum(pla_dinero.monto*pla_conceptos.signo) else 0 end as debito,
case when sum(pla_dinero.monto*pla_conceptos.signo) < 0 then sum(pla_dinero.monto*pla_conceptos.signo) else 0 end as credito
from pla_dinero, pla_cuentas, pla_periodos, pla_conceptos
where pla_periodos.id = pla_dinero.id_periodos
and pla_dinero.id_pla_cuentas = pla_cuentas.id
and pla_dinero.concepto = pla_conceptos.concepto
group by 1, 2, 3, 4, 5, 6
union
select pla_dinero.compania, pla_periodos.dia_d_pago,
Anio(pla_periodos.dia_d_pago) as anio, Mes(pla_periodos.dia_d_pago) as mes,
pla_cuentas.nombre, pla_cuentas.cuenta,
case when sum(pla_reservas_pp.monto*pla_conceptos.signo) >= 0 then sum(pla_reservas_pp.monto*pla_conceptos.signo) else 0 end as debito,
case when sum(pla_reservas_pp.monto*pla_conceptos.signo) < 0 then sum(pla_reservas_pp.monto*pla_conceptos.signo) else 0 end as credito
from pla_dinero, pla_cuentas, pla_periodos, pla_conceptos, pla_reservas_pp
where pla_periodos.id = pla_dinero.id_periodos
and pla_reservas_pp.id_pla_dinero = pla_dinero.id
and pla_reservas_pp.id_pla_cuentas = pla_cuentas.id
and pla_reservas_pp.concepto = pla_conceptos.concepto
group by 1, 2, 3, 4, 5, 6;

create view v_pla_dinero_preelaborada as
select pla_dinero.compania, pla_empleados.apellido, 
pla_empleados.nombre, 
pla_empleados.codigo_empleado, 
pla_conceptos.concepto,
pla_conceptos.descripcion as desc_concepto,
pla_tipos_de_planilla.descripcion as desc_tipo_de_planilla,
pla_periodos.tipo_de_planilla,
pla_tipos_de_calculo.descripcion as desc_tipo_de_calculo,
pla_dinero.tipo_de_calculo,
pla_empleados.tipo_de_salario,
pla_periodos.id as id_pla_periodos,
pla_periodos.year,
pla_dinero.mes,
pla_periodos.numero_planilla,
pla_periodos.dia_d_pago as fecha,
pla_conceptos.tipo_de_concepto,
pla_tipos_de_conceptos.descripcion as desc_tipo_de_concepto, 
pla_conceptos.prioridad_impresion,
pla_departamentos.descripcion as desc_departamento,
pla_empleados.departamento as departamento,
pla_dinero.id_pla_cheques_1 as id_pla_cheques_1,
(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_conceptos, pla_empleados, pla_periodos, 
pla_tipos_de_conceptos, pla_tipos_de_calculo, pla_tipos_de_planilla, pla_departamentos
where pla_dinero.concepto = pla_conceptos.concepto
and pla_empleados.departamento = pla_departamentos.id
and pla_periodos.tipo_de_planilla = pla_tipos_de_planilla.tipo_de_planilla
and pla_periodos.compania = pla_tipos_de_planilla.compania
and pla_dinero.tipo_de_calculo = pla_tipos_de_calculo.tipo_de_calculo
and pla_tipos_de_conceptos.tipo_de_concepto = pla_conceptos.tipo_de_concepto
and pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
union
select pla_preelaboradas.compania, 
pla_empleados.apellido, pla_empleados.nombre, 
pla_empleados.codigo_empleado, 
pla_conceptos.concepto,
pla_conceptos.descripcion as desc_concepto,
pla_tipos_de_planilla.descripcion as desc_tipo_de_planilla,
pla_empleados.tipo_de_planilla,
'PLANILLAS PREVIAS', null,
pla_empleados.tipo_de_salario,
null,
Anio(pla_preelaboradas.fecha),
Mes(pla_preelaboradas.fecha),
null,
pla_preelaboradas.fecha,
pla_conceptos.tipo_de_concepto,
pla_tipos_de_conceptos.descripcion as desc_tipo_de_concepto, 
pla_conceptos.prioridad_impresion,
pla_departamentos.descripcion as desc_departamento,
pla_empleados.departamento as departamento,
null, (pla_preelaboradas.monto*pla_conceptos.signo)
from pla_preelaboradas, pla_conceptos, pla_empleados, pla_tipos_de_conceptos,
pla_tipos_de_planilla, pla_departamentos
where pla_preelaboradas.compania = pla_empleados.compania
and pla_preelaboradas.codigo_empleado = pla_empleados.codigo_empleado
and pla_preelaboradas.concepto = pla_conceptos.concepto
and pla_conceptos.tipo_de_concepto = pla_tipos_de_conceptos.tipo_de_concepto
and pla_empleados.departamento = pla_departamentos.id
and pla_empleados.tipo_de_planilla = pla_tipos_de_planilla.tipo_de_planilla
and pla_empleados.compania = pla_tipos_de_planilla.compania;


create view v_pla_dinero_cheques as
    select pla_conceptos.tipo_de_concepto, 
    (pla_dinero.monto*pla_conceptos.signo) as monto,
    pla_dinero.compania, pla_dinero.tipo_de_calculo,
    pla_dinero.id_periodos,
    pla_dinero.id_pla_cuentas,
    pla_dinero.codigo_empleado,
    pla_dinero.concepto,
    pla_conceptos.prioridad_impresion,
    pla_dinero.id as id_pla_dinero,
    pla_dinero.descripcion
    from pla_dinero, pla_conceptos
    where pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.id_pla_cheques_1 is null;
    

create view v_pla_cheques_peachtree2 as
select pla_bancos.compania, Trim(pla_cheques_1.paguese_a) as vendor_name,
pla_cheques_1.no_cheque as check_number, 
Trim(to_char(pla_cheques_1.fecha_cheque, 'dd/mm/yyyy')) as fecha,
pla_cheques_1.fecha_cheque,
Trim(pla_cheques_1.en_concepto_de) as en_concepto_de,
Trim(pla_cuentas.cuenta) as gl_account, Trim(pla_cheques_2.descripcion) as description, 
Trim((select pla_cuentas.cuenta from pla_cuentas
where pla_cuentas.id = pla_bancos.id_pla_cuentas)) as cash_account,
'Yes' as detailed_payments,
(select count(*)-1 from pla_cheques_2
where pla_cheques_2.id_pla_cheques_1 = pla_cheques_1.id) as number_of_distributions,
1 as quantity,
1 as unit_price,
pla_cheques_2.id as id_pla_cheques_2, 
case when trim(pla_cheques_1.status) <> 'A' then pla_cheques_2.monto else 0 end as amount
from pla_cheques_1, pla_cheques_2, pla_cuentas, pla_bancos
where pla_cheques_1.id = pla_cheques_2.id_pla_cheques_1
and pla_bancos.id = pla_cheques_1.id_pla_bancos
and pla_cuentas.id = pla_cheques_2.id_pla_cuentas
and pla_cheques_1.tipo_transaccion = 'C'
and pla_cuentas.cuenta not like '10%';


create view v_pla_cheques_peachtree as
select pla_bancos.compania, Trim(pla_cheques_1.paguese_a) as vendor_name,
pla_cheques_1.no_cheque as check_number, 
Trim(to_char(pla_cheques_1.fecha_cheque, 'mm/dd/yyyy')) as fecha,
pla_cheques_1.fecha_cheque,
Trim(pla_cheques_1.en_concepto_de) as en_concepto_de,
Trim(pla_cuentas.cuenta) as gl_account, Trim(pla_cheques_2.descripcion) as description, 
Trim((select pla_cuentas.cuenta from pla_cuentas
where pla_cuentas.id = pla_bancos.id_pla_cuentas)) as cash_account,
'Yes' as detailed_payments,
(select count(*)-1 from pla_cheques_2
where pla_cheques_2.id_pla_cheques_1 = pla_cheques_1.id) as number_of_distributions,
1 as quantity,
1 as unit_price,
pla_cheques_2.id as id_pla_cheques_2, 
case when pla_cheques_1.status <> 'A' then pla_cheques_2.monto else 0 end as amount
from pla_cheques_1, pla_cheques_2, pla_cuentas, pla_bancos
where pla_cheques_1.id = pla_cheques_2.id_pla_cheques_1
and pla_bancos.id = pla_cheques_1.id_pla_bancos
and pla_cuentas.id = pla_cheques_2.id_pla_cuentas
and pla_cheques_1.tipo_transaccion = 'C'
and pla_cuentas.cuenta not like '10%';

-- and 

create view v_pla_cheques_1_pla_cheques_2 as
select pla_bancos.compania, pla_cheques_1.id, pla_cheques_1.id_pla_bancos,
pla_cheques_1.no_cheque, pla_cheques_1.paguese_a,
pla_cheques_1.fecha_cheque, pla_cheques_1.en_concepto_de,
pla_cuentas.cuenta, pla_cheques_2.descripcion, pla_cheques_2.monto
from pla_cheques_1, pla_cheques_2, pla_cuentas, pla_bancos
where pla_cheques_1.id = pla_cheques_2.id_pla_cheques_1
and pla_bancos.id = pla_cheques_1.id_pla_bancos
and pla_cuentas.id = pla_cheques_2.id_pla_cuentas
and pla_cheques_1.status <> 'A'
and pla_cheques_1.tipo_transaccion = 'C';

create view v_pla_acreedores_pendiente_de_pago as
select pla_dinero.id as id_pla_dinero, pla_companias.nombre as nombre_compania, pla_companias.compania,
pla_acreedores.nombre as nombre_acreedor, pla_acreedores.acreedor,
pla_empleados.apellido, pla_empleados.nombre, pla_empleados.codigo_empleado,
pla_periodos.tipo_de_planilla, pla_periodos.year, pla_periodos.numero_planilla,
Mes(pla_periodos.dia_d_pago) as mes, 
pla_periodos.dia_d_pago as fecha,
pla_acreedores.prioridad,
pla_dinero.monto
from pla_retenciones, pla_acreedores, pla_deducciones, pla_dinero, pla_periodos,
pla_companias, pla_empleados
where pla_retenciones.compania = pla_acreedores.compania
and pla_retenciones.acreedor = pla_acreedores.acreedor
and pla_retenciones.id = pla_deducciones.id_pla_retenciones
and pla_deducciones.id_pla_dinero = pla_dinero.id
and pla_dinero.id_periodos = pla_periodos.id
and pla_companias.compania = pla_dinero.compania
and pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
and pla_retenciones.hacer_cheque = 'S'
and pla_retenciones.status = 'A'
and pla_deducciones.id_pla_cheques_1 is null;

create view v_pla_costos_x_proyecto as
select pla_dinero.id, pla_dinero.compania, 
pla_empleados.departamento,
pla_dinero.id_periodos, 
pla_periodos.year,
pla_periodos.numero_planilla as numero_planilla,
pla_proyectos.descripcion as desc_proyecto,
pla_dinero.id_pla_proyectos,
pla_dinero.codigo_empleado,
pla_dinero.tipo_de_calculo, 
pla_periodos.tipo_de_planilla,
pla_conceptos.prioridad_impresion, 
pla_conceptos.descripcion, pla_dinero.concepto,
pla_periodos.year as anio, pla_dinero.mes, 
(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_conceptos, pla_periodos, pla_proyectos, pla_empleados
where pla_empleados.compania = pla_dinero.compania
and pla_empleados.codigo_empleado = pla_dinero.codigo_empleado
and pla_dinero.id_pla_proyectos = pla_proyectos.id
and pla_dinero.concepto = pla_conceptos.concepto
and pla_dinero.id_periodos = pla_periodos.id
and pla_conceptos.tipo_de_concepto <> '2'
union
select pla_dinero.id, pla_dinero.compania, 
pla_empleados.departamento,
pla_dinero.id_periodos, 
pla_periodos.year,
pla_periodos.numero_planilla,
pla_proyectos.descripcion as desc_proyecto,
pla_dinero.id_pla_proyectos,
pla_dinero.codigo_empleado,
pla_dinero.tipo_de_calculo, 
pla_periodos.tipo_de_planilla,
pla_conceptos.prioridad_impresion, 
pla_conceptos.descripcion, 
pla_reservas_pp.concepto,
pla_periodos.year, pla_dinero.mes, 
(pla_reservas_pp.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_conceptos, pla_reservas_pp, pla_periodos, pla_proyectos, pla_empleados
where pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
and pla_dinero.id = pla_reservas_pp.id_pla_dinero
and pla_dinero.id_pla_proyectos = pla_proyectos.id
and pla_reservas_pp.concepto = pla_conceptos.concepto
and pla_dinero.id_periodos = pla_periodos.id
and pla_conceptos.tipo_de_concepto <> '2';

create view v_pla_dinero_resumido as
select pla_dinero.compania, Trim(pla_empleados.apellido) as apellido, Trim(pla_empleados.nombre) as nombre, 
pla_empleados.codigo_empleado, 
pla_tipos_de_planilla.descripcion as desc_tipo_de_planilla, pla_periodos.tipo_de_planilla,
pla_tipos_de_calculo.descripcion as desc_tipo_de_calculo,
pla_dinero.tipo_de_calculo,
pla_periodos.year,
pla_periodos.numero_planilla,
pla_periodos.dia_d_pago as fecha,
pla_periodos.id as id_pla_periodos,
pla_departamentos.descripcion as desc_departamento,
pla_empleados.departamento as id_pla_departamento,
sum(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_conceptos, pla_empleados, pla_periodos, 
pla_tipos_de_planilla, pla_tipos_de_calculo, pla_departamentos
where pla_dinero.concepto = pla_conceptos.concepto
and pla_empleados.departamento = pla_departamentos.id
and pla_tipos_de_calculo.tipo_de_calculo = pla_dinero.tipo_de_calculo
and pla_periodos.tipo_de_planilla = pla_tipos_de_planilla.tipo_de_planilla
and pla_periodos.compania = pla_tipos_de_planilla.compania
and pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
and pla_periodos.year >= 2013
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
having sum(pla_dinero.monto*pla_conceptos.signo) <> 0;


create view v_pla_dinero_detallado as
select pla_dinero.compania, 
pla_periodos.year,
pla_periodos.numero_planilla,
pla_periodos.dia_d_pago as fecha,
trim(pla_empleados.apellido) as apellido, 
trim(pla_empleados.nombre) as nombre, 
trim(pla_empleados.codigo_empleado) as codigo_empleado, 
trim(pla_conceptos.descripcion) as desc_concepto,
pla_conceptos.concepto,
trim(pla_departamentos.descripcion) as desc_departamento,
pla_empleados.departamento as departamento,
trim(pla_proyectos.descripcion) as desc_proyecto,
pla_empleados.id_pla_proyectos,
pla_empleados.forma_de_pago,
pla_empleados.status,
pla_tipos_de_planilla.descripcion as desc_tipo_de_planilla,
pla_periodos.tipo_de_planilla,
pla_tipos_de_calculo.descripcion as desc_tipo_de_calculo,
pla_dinero.tipo_de_calculo,
pla_empleados.tipo_de_salario,
pla_periodos.id as id_pla_periodos,
pla_conceptos.tipo_de_concepto,
pla_tipos_de_conceptos.descripcion as desc_tipo_de_concepto, 
pla_conceptos.prioridad_impresion,
pla_dinero.id_pla_cheques_1 as id_pla_cheques_1,
(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_conceptos, pla_empleados, pla_periodos, 
pla_tipos_de_conceptos, pla_tipos_de_calculo, pla_tipos_de_planilla, 
pla_departamentos, pla_proyectos
where pla_dinero.concepto = pla_conceptos.concepto
and pla_dinero.id_pla_proyectos = pla_proyectos.id
and pla_empleados.departamento = pla_departamentos.id
and pla_periodos.tipo_de_planilla = pla_tipos_de_planilla.tipo_de_planilla
and pla_periodos.compania = pla_tipos_de_planilla.compania
and pla_dinero.tipo_de_calculo = pla_tipos_de_calculo.tipo_de_calculo
and pla_tipos_de_conceptos.tipo_de_concepto = pla_conceptos.tipo_de_concepto
and pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado;

create view v_pla_dinero_pla_reservas_pp as
select pla_dinero.id, pla_dinero.compania, pla_dinero.id_periodos, 
pla_periodos.tipo_de_planilla,
pla_periodos.year,
pla_periodos.numero_planilla as numero_planilla,
pla_dinero.id_pla_proyectos,
pla_dinero.id_pla_departamentos, pla_dinero.codigo_empleado,
pla_empleados.apellido,
pla_empleados.nombre,
pla_dinero.tipo_de_calculo, pla_conceptos.prioridad_impresion, 
pla_conceptos.descripcion, pla_dinero.concepto,
pla_periodos.year as anio, pla_dinero.mes, 
(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_conceptos, pla_periodos, pla_empleados
where pla_dinero.concepto = pla_conceptos.concepto
and pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
and pla_conceptos.tipo_de_concepto = '1'
and pla_dinero.concepto not in ('107','108','109','220','125')
union
select pla_dinero.id, pla_dinero.compania, pla_dinero.id_periodos, 
pla_periodos.tipo_de_planilla,
pla_periodos.year,
pla_periodos.numero_planilla,
pla_dinero.id_pla_proyectos,
pla_dinero.id_pla_departamentos, pla_dinero.codigo_empleado,
pla_empleados.apellido,
pla_empleados.nombre,
pla_dinero.tipo_de_calculo, pla_conceptos.prioridad_impresion, pla_conceptos.descripcion, 
pla_reservas_pp.concepto,
pla_periodos.year, pla_dinero.mes, 
pla_reservas_pp.monto as monto
from pla_dinero, pla_conceptos, pla_reservas_pp, pla_periodos, pla_empleados
where pla_dinero.id = pla_reservas_pp.id_pla_dinero
and pla_reservas_pp.concepto = pla_conceptos.concepto
and pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
and pla_dinero.id_periodos = pla_periodos.id;

create view v_pla_acumulados_pla_dinero as
select pla_dinero.compania, pla_dinero.codigo_empleado, pla_dinero.id, pla_conceptos.descripcion, 
pla_conceptos.concepto,
pla_acumulados.fecha, (pla_acumulados.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_acumulados, pla_conceptos
where pla_dinero.id = pla_acumulados.id_pla_dinero
and pla_acumulados.concepto = pla_conceptos.concepto;

create view v_pla_acumulados as
select pla_dinero.id, pla_dinero.compania, pla_dinero.codigo_empleado,
pla_empleados.apellido, pla_empleados.nombre,
(select pla_conceptos.descripcion from pla_conceptos
where pla_conceptos.concepto = pla_conceptos_acumulan.concepto) as descripcion_calcula,
pla_conceptos_acumulan.concepto as concepto_calcula,
pla_conceptos.descripcion as descripcion_acumula,
pla_conceptos.concepto as concepto_acumula, 
pla_periodos.dia_d_pago as fecha, 
Anio(pla_periodos.dia_d_pago) as anio,
Mes(pla_periodos.dia_d_pago) as mes,
(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_conceptos_acumulan, pla_dinero, pla_conceptos, pla_periodos, pla_empleados
where pla_conceptos_acumulan.concepto_aplica = pla_dinero.concepto
and pla_empleados.compania = pla_dinero.compania
and pla_empleados.codigo_empleado = pla_dinero.codigo_empleado
and pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.concepto = pla_conceptos.concepto
and pla_empleados.status in ('A', 'V', 'L','I','E')
and pla_periodos.dia_d_pago >= pla_empleados.fecha_inicio
union
select null, pla_preelaboradas.compania, pla_preelaboradas.codigo_empleado,
pla_empleados.apellido, pla_empleados.nombre,
(select pla_conceptos.descripcion from pla_conceptos
where pla_conceptos.concepto = pla_conceptos_acumulan.concepto) as descripcion_calcula,
pla_conceptos_acumulan.concepto as concepto_calcula,
pla_conceptos.descripcion as descripcion_acumula,
pla_conceptos.concepto as concepto_acumula, 
pla_preelaboradas.fecha, 
Anio(pla_preelaboradas.fecha),
Mes(pla_preelaboradas.fecha),
(pla_preelaboradas.monto*pla_conceptos.signo) as monto
from pla_conceptos_acumulan, pla_preelaboradas, pla_conceptos, pla_empleados
where pla_conceptos_acumulan.concepto_aplica = pla_preelaboradas.concepto
and pla_empleados.compania = pla_preelaboradas.compania
and pla_empleados.codigo_empleado = pla_preelaboradas.codigo_empleado
and pla_preelaboradas.concepto = pla_conceptos.concepto
and pla_preelaboradas.fecha >= pla_empleados.fecha_inicio
union
select null, pla_riesgos_profesionales.compania, pla_riesgos_profesionales.codigo_empleado,
pla_empleados.apellido, pla_empleados.nombre,
(select pla_conceptos.descripcion from pla_conceptos
where pla_conceptos.concepto = pla_conceptos_acumulan.concepto) as descripcion_calcula,
pla_conceptos_acumulan.concepto as concepto_calcula,
pla_conceptos.descripcion as descripcion_acumula,
pla_conceptos.concepto as concepto_acumula, 
pla_riesgos_profesionales.dia_d_pago, 
Anio(pla_riesgos_profesionales.dia_d_pago) as anio,
Mes(pla_riesgos_profesionales.dia_d_pago) as mes,
(pla_riesgos_profesionales.monto*pla_conceptos.signo) as monto
from pla_conceptos_acumulan, pla_riesgos_profesionales, pla_conceptos, pla_empleados
where pla_conceptos_acumulan.concepto_aplica = pla_riesgos_profesionales.concepto
and pla_empleados.compania = pla_riesgos_profesionales.compania
and pla_empleados.codigo_empleado = pla_riesgos_profesionales.codigo_empleado
and pla_riesgos_profesionales.concepto = pla_conceptos.concepto
and pla_riesgos_profesionales.dia_d_pago >= pla_empleados.fecha_inicio;


create view v_pla_retenciones_hechas as
select pla_companias.nombre as nombre_cia, pla_dinero.compania, 
trim(pla_empleados.nombre) || '  ' || trim(pla_empleados.apellido) as nombre_empleado,
pla_dinero.codigo_empleado, pla_departamentos.descripcion as desc_departamento, 
pla_departamentos.departamento, pla_acreedores.nombre, 
pla_acreedores.acreedor, pla_tipos_de_planilla.descripcion, pla_retenciones.numero_documento,
pla_retenciones.descripcion_descuento, pla_periodos.dia_d_pago, pla_dinero.id_periodos, 
pla_deducciones.id_pla_cheques_1, pla_dinero.monto
from pla_dinero, pla_deducciones, pla_retenciones, pla_acreedores, pla_periodos, 
pla_tipos_de_planilla, pla_empleados, pla_departamentos, pla_companias
where pla_dinero.compania = pla_companias.compania
and pla_dinero.compania = pla_empleados.compania
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
and pla_empleados.departamento = pla_departamentos.id
and pla_dinero.id = pla_deducciones.id_pla_dinero
and pla_deducciones.id_pla_retenciones = pla_retenciones.id
and pla_retenciones.acreedor = pla_acreedores.acreedor
and pla_retenciones.compania = pla_acreedores.compania
and pla_dinero.id_periodos = pla_periodos.id
and pla_tipos_de_planilla.compania = pla_periodos.compania
and pla_tipos_de_planilla.tipo_de_planilla = pla_periodos.tipo_de_planilla;

create view v_pla_cheques_empleados_pendientes as
select pla_dinero.compania, pla_dinero.tipo_de_calculo, pla_tipos_de_calculo.descripcion,
pla_dinero.id_periodos, pla_tipos_de_planilla.tipo_de_planilla, 
pla_empleados.tipo_de_salario,
pla_departamentos.descripcion as departamento,
pla_proyectos.descripcion as proyecto,
pla_periodos.dia_d_pago as fecha, 
pla_periodos.year as anio,
Mes(pla_periodos.dia_d_pago) as mes,
pla_periodos.numero_planilla,
trim(pla_empleados.nombre) || '  ' || trim(pla_empleados.apellido) as nombre_empleado,
pla_dinero.codigo_empleado, sum(pla_dinero.monto*pla_conceptos.signo) as monto
from pla_dinero, pla_tipos_de_calculo, pla_conceptos, pla_periodos, pla_empleados, 
pla_tipos_de_planilla, pla_departamentos, pla_proyectos
where pla_dinero.compania = pla_empleados.compania
and pla_dinero.id_pla_proyectos = pla_proyectos.id
and pla_empleados.departamento = pla_departamentos.id
and pla_empleados.compania = pla_tipos_de_planilla.compania
and pla_periodos.tipo_de_planilla = pla_tipos_de_planilla.tipo_de_planilla
and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
and pla_dinero.tipo_de_calculo = pla_tipos_de_calculo.tipo_de_calculo
and pla_dinero.concepto = pla_conceptos.concepto
and pla_dinero.id_periodos = pla_periodos.id
and pla_dinero.id_pla_cheques_1 is null
and pla_empleados.forma_de_pago = 'C'
and pla_empleados.status in ('A','V')
group by pla_dinero.compania, pla_dinero.tipo_de_calculo, pla_tipos_de_calculo.descripcion,
pla_dinero.id_periodos, pla_tipos_de_planilla.tipo_de_planilla, pla_departamentos.descripcion,
pla_periodos.dia_d_pago, pla_dinero.codigo_empleado, pla_empleados.nombre, pla_proyectos.descripcion,
pla_empleados.apellido, pla_periodos.year, pla_periodos.numero_planilla, pla_empleados.tipo_de_salario;





create view v_pla_implementos_valorizados as
select '1' as tipo_de_calculo, pla_marcaciones.id as id_pla_marcaciones, pla_marcaciones.compania, pla_tarjeta_tiempo.codigo_empleado,
date(pla_marcaciones.entrada) as fecha,
pla_empleados.departamento as id_pla_departamentos,
pla_marcaciones.id_pla_proyectos,
pla_periodos.tipo_de_planilla, pla_periodos.year, pla_periodos.numero_planilla,
pla_horas.tipo_de_hora, pla_implementos.concepto, pla_conceptos.descripcion,
pla_periodos.dia_d_pago, pla_tipos_de_horas.recargo, pla_implementos.recargo as recargo_implemento, 
pla_tipos_de_horas.tiempo_regular, 
pla_tipos_de_horas.signo, 
pla_periodos.id as id_periodos,
Round((pla_horas.minutos_implemento*pla_tipos_de_horas.signo), 2) as minutos,
Round((pla_horas.minutos_implemento*pla_tipos_de_horas.signo*pla_tipos_de_horas.recargo*pla_horas.tasa_por_minuto*pla_implementos.recargo/100) ,2) as monto
from pla_horas, pla_marcaciones, pla_tarjeta_tiempo, pla_periodos, 
pla_tipos_de_horas, pla_conceptos, pla_empleados, pla_implementos
where pla_horas.compania = pla_implementos.compania
and pla_horas.implemento = pla_implementos.implemento
and pla_empleados.compania = pla_tarjeta_tiempo.compania
and pla_empleados.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado
and pla_implementos.concepto = pla_conceptos.concepto
and pla_horas.id_marcaciones = pla_marcaciones.id
and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
and pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora;


/*
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11, 12, 13, 14, 15,16, 17, 18, 19;
*/
