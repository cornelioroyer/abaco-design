set search_path to 'planilla';


rollback work;

begin work;
    update pla_periodos
    set status = 'A'
    where compania in (select compania from tmp_cias_expiradas);
commit work;

begin work;
    delete from pla_cheques_2
    using pla_cheques_1, pla_bancos
    where pla_cheques_1.id_pla_bancos = pla_bancos.id
    and pla_cheques_1.id = pla_cheques_2.id_pla_cheques_1
    and pla_bancos.compania in (select compania from tmp_cias_expiradas);
commit work;

begin work;
    delete from pla_cheques_2
    using pla_auxiliares
    where pla_cheques_2.id_pla_auxiliares = pla_auxiliares.id
    and pla_auxiliares.compania in (select compania from tmp_cias_expiradas);
commit work;

begin work;
    delete from pla_cheques_setup
    where compania in (select compania from tmp_cias_expiradas);
commit work;

begin work;
    delete from pla_xiii where compania in (select compania from tmp_cias_expiradas);
commit work;


begin work;
    delete from pla_dinero where compania in (select compania from tmp_cias_expiradas);
commit work;

begin work;
    delete from pla_cuentas_x_proyecto where compania in (select compania from tmp_cias_expiradas);
    delete from pla_cuentas_x_concepto where compania in (select compania from tmp_cias_expiradas);
    delete from pla_cuentas_x_departamento where compania in (select compania from tmp_cias_expiradas);

    delete from pla_cheques_1
    using pla_bancos
    where pla_bancos.id = pla_cheques_1.id_pla_bancos
    and pla_bancos.compania in (select compania from tmp_cias_expiradas);
commit work;

begin work;
    delete from pla_acreedores where compania in (select compania from tmp_cias_expiradas);
    delete from pla_planilla_03 where compania in (select compania from tmp_cias_expiradas);
    delete from pla_dinero where compania in (select compania from tmp_cias_expiradas);
    delete from pla_ajuste_de_renta where compania in (select compania from tmp_cias_expiradas);
commit work;

delete from pla_eventos where compania in (select compania from tmp_cias_expiradas);
delete from pla_implementos where compania in (select compania from tmp_cias_expiradas);

begin work;
    delete from pla_auxiliares where compania in (select compania from tmp_cias_expiradas);
    delete from pla_reclamos where compania in (select compania from tmp_cias_expiradas);
commit work;

delete from pla_cuentas_conceptos
where id_pla_cuentas in (select id from pla_cuentas where compania in (select compania from tmp_cias_expiradas));

delete from pla_parametros
where compania in (select compania from tmp_cias_expiradas);


delete from pla_auxiliares
where id_pla_departamentos in 
(select id from pla_departamentos
where compania in (select compania from tmp_cias_expiradas));

delete from pla_marcaciones
where compania in (select compania from tmp_cias_expiradas);

delete from pla_marcaciones
where id_pla_proyectos in (select id from pla_proyectos where compania in (select compania from tmp_cias_expiradas));

delete from pla_tarjeta_tiempo
where compania in (select compania from tmp_cias_expiradas);

delete from pla_certificados_medico where compania in (select compania from tmp_cias_expiradas);
delete from pla_permisos where compania in (select compania from tmp_cias_expiradas);
delete from pla_liquidacion where compania in (select compania from tmp_cias_expiradas);
delete from pla_otros_ingresos_fijos where compania in (select compania from tmp_cias_expiradas);
delete from pla_turnos_rotativos where compania in (select compania from tmp_cias_expiradas);
delete from pla_vacaciones where compania in (select compania from tmp_cias_expiradas);
delete from pla_riesgos_profesionales where compania in (select compania from tmp_cias_expiradas);
delete from pla_preelaboradas where compania in (select compania from tmp_cias_expiradas);
delete from pla_auxiliares where compania in (select compania from tmp_cias_expiradas);
delete from pla_retenciones where compania in (select compania from tmp_cias_expiradas);
delete from pla_acreedores where compania in (select compania from tmp_cias_expiradas);

begin work;
    delete from pla_dinero where compania in (select compania from tmp_cias_expiradas);
commit work;    


begin work;
    delete from pla_tarjeta_tiempo where compania in (select compania from tmp_cias_expiradas);
    delete from pla_liquidacion where compania in (select compania from tmp_cias_expiradas);
    delete from pla_periodos where compania in (select compania from tmp_cias_expiradas);
commit work;

begin work;
    delete from pla_empleados where compania in (select compania from tmp_cias_expiradas);
commit work;    

begin work;
    delete from pla_bancos
    where compania in (select compania from tmp_cias_expiradas);
commit work;

delete from pla_parametros_contables where compania in (select compania from tmp_cias_expiradas);

delete from pla_cuentas where compania in (select compania from tmp_cias_expiradas);

delete from pla_proyectos where compania in (select compania from tmp_cias_expiradas);

begin work;
    delete from pla_bancos where compania in (select compania from tmp_cias_expiradas);
    delete from pla_comprobante_contable where compania in (select compania from tmp_cias_expiradas);
    delete from pla_departamentos where compania in (select compania from tmp_cias_expiradas);
commit work;

delete from pla_turnos where compania in (select compania from tmp_cias_expiradas);

delete from pla_cargos where compania in (select compania from tmp_cias_expiradas);

delete from pla_tipos_de_planilla where compania in (select compania from tmp_cias_expiradas);
    
delete from pla_dias_feriados where compania in (select compania from tmp_cias_expiradas);

delete from pla_companias where compania in (select compania from tmp_cias_expiradas);


/*






*/

