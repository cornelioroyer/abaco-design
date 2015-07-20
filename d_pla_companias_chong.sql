
update pla_periodos
set status = 'A';


delete from pla_parametros where compania <> 987;
delete from pla_dias_feriados;
delete from pla_xiii;
delete from pla_vacaciones;
delete from pla_tipos_de_planilla where compania <> 987;
delete from pla_proyectos where compania <> 987;
delete from pla_cuentas_conceptos;
delete from pla_cuentas_x_proyecto;
delete from pla_cuentas_x_departamento;
delete from pla_cuentas_x_concepto where compania <> 987;
delete from pla_cheques_setup;
delete from pla_bancos;
delete from pla_cuentas where compania <> 987;
delete from pla_parametros_contables where compania <> 987;
delete from pla_riesgos_profesionales;
delete from pla_turnos_rotativos;
delete from pla_horarios where compania <> 987;
delete from pla_turnos where compania <> 987;
delete from pla_fondo_d_cesantia;
delete from pla_preelaboradas;
delete from pla_certificados_medico;
delete from pla_liquidacion;
delete from pla_acreedores where compania <> 987;
delete from pla_retenciones where compania <> 987;
delete from pla_permisos;
delete from pla_otros_ingresos_fijos;
delete from pla_periodos where compania <> 987;
delete from pla_reclamos;
delete from pla_empleados where compania <> 987;
delete from pla_auxiliares;
delete from pla_departamentos where compania <> 987;

begin work;
delete from pla_otros_ingresos_variables;
commit work;

delete from pla_comprobante_contable;
delete from pla_periodos where compania <> 987;
delete from pla_reclamos;
delete from pla_tarjeta_tiempo;
delete from pla_planilla_03;
delete from pla_dinero;
delete from pla_cheques_2;
delete from pla_cheques_1;
delete from pla_auxiliares where compania <> 987;
delete from pla_empleados where compania <> 987;
delete from pla_cargos where compania <> 987;
delete from pla_companias where compania <> 987;

