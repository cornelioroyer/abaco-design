
rollback work;

begin work;
    delete from pla_dinero where compania in (41, 48, 49);
commit work;

begin work;
    delete from pla_cuentas_x_proyecto where compania in (41, 48, 49);
    delete from pla_cuentas_x_concepto where compania in (41, 48, 49);
    delete from pla_cuentas_x_departamento where compania in (41, 48, 49);

    delete from pla_cheques_1
    using pla_bancos
    where pla_bancos.id = pla_cheques_1.id_pla_bancos
    and pla_bancos.compania in (41, 48, 49);
commit work;

begin work;
    delete from pla_acreedores where compania in (41, 48, 49);
    delete from pla_planilla_03 where compania in (41, 48, 49);
    delete from pla_dinero where compania in (41, 48, 49);
    delete from pla_ajuste_de_renta where compania in (41, 48, 49);
commit work;

delete from pla_eventos where compania in (41, 48, 49);
delete from pla_implementos where compania in (41, 48, 49);

begin work;
    delete from pla_auxiliares where compania in (41, 48, 49);
    delete from pla_reclamos where compania in (41, 48, 49);
commit work;

delete from pla_cuentas_conceptos
where id_pla_cuentas in (select id from pla_cuentas where compania in (41, 48, 49));

delete from pla_parametros
where compania in (41, 48, 49);

delete from pla_auxiliares
where id_pla_departamentos in 
(select id from pla_departamentos
where compania in (41, 48, 49));

delete from pla_marcaciones
where compania in (41, 48, 49);

delete from pla_marcaciones
where id_pla_proyectos in (select id from pla_proyectos where compania in (41, 48, 49));

delete from pla_tarjeta_tiempo
where compania in (41, 48, 49);

delete from pla_certificados_medico where compania in (41, 48, 49);
delete from pla_permisos where compania in (41, 48, 49);
delete from pla_liquidacion where compania in (41, 48, 49);
delete from pla_otros_ingresos_fijos where compania in (41, 48, 49);
delete from pla_turnos_rotativos where compania in (41, 48, 49);
delete from pla_vacaciones where compania in (41, 48, 49);
delete from pla_riesgos_profesionales where compania in (41, 48, 49);
delete from pla_preelaboradas where compania in (41, 48, 49);
delete from pla_cuentas where compania in (41, 48, 49);
delete from pla_auxiliares where compania in (41, 48, 49);
delete from pla_retenciones where compania in (41, 48, 49);
delete from pla_acreedores where compania in (41, 48, 49);

begin work;
    delete from pla_dinero where compania in (41, 48, 49);
commit work;    


begin work;
    delete from pla_tarjeta_tiempo where compania in (41, 48, 49);
    delete from pla_liquidacion where compania in (41, 48, 49);
    delete from pla_periodos where compania in (41, 48, 49);
commit work;

begin work;
    delete from pla_empleados where compania in (41, 48, 49);
commit work;    

begin work;
    delete from pla_proyectos where compania in (41, 48, 49);
    delete from pla_bancos where compania in (41, 48, 49);
    delete from pla_comprobante_contable where compania in (41, 48, 49);
    delete from pla_departamentos where compania in (41, 48, 49);
commit work;

delete from pla_turnos where compania in (41, 48, 49);

delete from pla_cargos where compania in (41, 48, 49);

delete from pla_tipos_de_planilla where compania in (41, 48, 49);
    

delete from pla_companias where compania in (41, 48, 49);

/*






*/
