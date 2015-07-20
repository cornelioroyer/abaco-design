
drop function f_indemnizacion(int4) cascade;

create function f_indemnizacion(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_liquidacion record;
    r_pla_liquidacion_calculo record;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_xiii record;
    r_pla_conceptos record;
    r_pla_work record;
    r_work record;
    i integer;
    ldc_acum decimal;
    ldc_vacacion decimal;
    ldc_indemnizacion decimal;
    ld_desde date;
    ld_desde_6_meses date;
    ld_desde_30_dias date;
    ld_semana_6_meses decimal;
    ldc_semana_30_dias decimal;
    ldc_acum_30_dias decimal;
    ldc_acum_6_meses decimal;
    ldc_promedio_30_dias decimal;
    ldc_promedio_6_meses decimal;
    ldc_anios_laborados decimal;
    ld_work date;
    li_id int4;
    lc_suntracs char(1);
begin
    ldc_vacacion = 0;
    select into r_pla_liquidacion * from pla_liquidacion
    where id = ai_id;
    if not found then
        raise exception ''Liquidacion no Existe % No Existe'',ai_id;
    end if;
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_liquidacion.compania
    and codigo_empleado = r_pla_liquidacion.codigo_empleado;
    

    lc_suntracs =   Trim(f_pla_parametros(r_pla_liquidacion.compania, ''suntracs'', ''N'', ''GET''));


    ld_desde = r_pla_empleados.fecha_inicio;
    
    ld_work = null;
    select into ld_work Max(dia_d_pago)
    from pla_dinero, pla_periodos
    where pla_dinero.id_periodos = pla_periodos.id
    and pla_dinero.compania = r_pla_empleados.compania
    and monto <> 0
    and pla_dinero.codigo_empleado = r_pla_empleados.codigo_empleado
    and pla_periodos.dia_d_pago <= current_date
    and pla_dinero.tipo_de_calculo = ''7'';
    if ld_work is null then
        ld_work = ''1968-01-01'';
    end if;    

    if ld_work > ld_desde then
        ld_desde = ld_work + 1;
    end if;


    ldc_anios_laborados     =   (r_pla_liquidacion.fecha - r_pla_empleados.fecha_inicio) / 365.00;
    ldc_acum                =   0;
    ldc_vacacion            =   0;
    ld_desde_30_dias        =   f_relative_dmy(''DAY'',r_pla_liquidacion.fecha, -29);
    ld_desde_6_meses        =   f_relative_mes(r_pla_liquidacion.fecha, -6)+1;
    ldc_acum_30_dias        =   0;
    ldc_acum_6_meses        =   0;
    ldc_promedio_30_dias    =   0;
    ldc_promedio_6_meses    =   0;

    select into ldc_acum_30_dias sum(monto) from v_pla_acumulados
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto_calcula = ''130''
    and fecha >= ld_desde_30_dias;
    if ldc_acum_30_dias is null then
        ldc_acum_30_dias = 0;
    end if;
    

    select into ldc_acum_6_meses sum(monto) from v_pla_acumulados
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto_calcula = ''130''
    and concepto_acumula not in (''108'')
    and fecha >= ld_desde_6_meses;
    if ldc_acum_6_meses is null then
        ldc_acum_6_meses = 0;
    end if;


    ldc_promedio_30_dias    =   ldc_acum_30_dias * 12 / 52;
    ldc_promedio_6_meses    =   ldc_acum_6_meses / 26;
    
--    raise exception ''%  %'',ldc_promedio_30_dias, ldc_promedio_6_meses;

/*
    select into ldc_acum sum(monto) from v_pla_acumulados
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto_calcula = ''130''
    and fecha >= ld_desde;
    if ldc_acum is null then
        return 1;
    end if;

    
    select into r_work *
    from pla_dinero
    where id_pla_liquidacion = ai_id
    and concepto = ''108'';
    if not found then
        select into ldc_vacacion monto
        from pla_liquidacion_calculo
        where id_pla_liquidacion = ai_id
        and concepto = ''108'';
        if found then
            ldc_acum = ldc_acum + ldc_vacacion;
        end if;
    end if;
*/

    if r_pla_empleados.sindicalizado = ''S'' and lc_suntracs = ''S'' then
        ldc_indemnizacion   =   ldc_acum * 0.06;
    else
--        ldc_indemnizacion   =   (ldc_acum/52*3.4);
        if ldc_promedio_30_dias > ldc_promedio_6_meses then
            ldc_indemnizacion       =   ldc_promedio_30_dias * 3.4 * ldc_anios_laborados;
        else
            ldc_indemnizacion       =   ldc_promedio_6_meses * 3.4 * ldc_anios_laborados;
        end if;
    end if;
    
    insert into pla_liquidacion_calculo (id_pla_liquidacion, concepto, forma_de_registro, monto)
    values (ai_id, ''130'',''A'',ldc_indemnizacion);

    li_id   =   lastval();
    
    for r_pla_work in select v_pla_acumulados.id, v_pla_acumulados.concepto_acumula, 
                        v_pla_acumulados.fecha, v_pla_acumulados.monto
                        from v_pla_acumulados
                        where v_pla_acumulados.compania = r_pla_empleados.compania
                        and v_pla_acumulados.codigo_empleado = r_pla_empleados.codigo_empleado
                        and v_pla_acumulados.concepto_calcula = ''130''
                        and v_pla_acumulados.fecha >= ld_desde_6_meses
                        order by v_pla_acumulados.fecha, v_pla_acumulados.concepto_acumula
    loop
        select into r_pla_conceptos *
        from pla_conceptos
        where concepto = r_pla_work.concepto_acumula;
        insert into pla_liquidacion_acumulados (id_pla_liquidacion_calculo, concepto, fecha, monto)
        values (li_id, r_pla_work.concepto_acumula, r_pla_work.fecha, (r_pla_work.monto*r_pla_conceptos.signo));
    end loop;

/*    
    if ldc_vacacion > 0 then
        insert into pla_liquidacion_acumulados (id_pla_liquidacion_calculo, concepto, fecha, monto)
        values (li_id, ''108'', r_pla_liquidacion.fecha, ldc_vacacion);
    end if;
*/    
    
    return 1;
end;
' language plpgsql;

