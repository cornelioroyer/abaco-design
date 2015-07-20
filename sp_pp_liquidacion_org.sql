
set search_path to planilla;



drop function f_pla_liquidacion(int4) cascade;
drop function f_vacacion_proporcional(int4) cascade;
drop function f_xiii_proporcional(int4) cascade;
drop function f_prima_de_antiguedad(int4) cascade;
drop function f_preaviso(int4) cascade;
drop function f_indemnizacion(int4) cascade;
drop function f_pla_retenciones_liquidacion(char(3), int4) cascade;
drop function f_certificados_medicos_pendientes(int4) cascade;
drop function f_vacacion_proporcional(int4, char(7), date) cascade;
drop function f_xiii_proporcional(int4, char(7), date) cascade;
drop function f_prima_de_antiguedad(int4, char(7), date) cascade;
drop function f_indemnizacion(int4, char(7), date) cascade;

create function f_indemnizacion(int4, char(7), date) returns decimal as '
declare
    ai_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ad_fecha alias for $3;
    r_pla_empleados record;
    r_pla_xiii record;
    r_pla_conceptos record;
    r_pla_work record;
    r_work record;
    i integer;
    ldc_acum decimal;
    ldc_vacacion decimal;
    ld_desde date;
    li_id int4;
begin
    ldc_vacacion = 0;
    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_compania
    and codigo_empleado = ac_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    ld_desde = r_pla_empleados.fecha_inicio;

    ldc_acum = 0;
    ldc_vacacion = 0;
    
    select into ldc_acum sum(monto) from v_pla_acumulados
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto_calcula = ''130''
    and fecha >= ld_desde;
    if ldc_acum is null then
        return 0;
    end if;
    

    ldc_vacacion    =   f_vacacion_proporcional(ai_compania, ac_codigo_empleado, ad_fecha);
    ldc_acum        =   ldc_acum + ldc_vacacion;
    return ldc_acum/52*3.4;
end;
' language plpgsql;



create function f_prima_de_antiguedad(int4, char(7), date) returns decimal as '
declare
    ai_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ad_fecha alias for $3;
    r_pla_empleados record;
    r_pla_xiii record;
    r_pla_work record;
    r_pla_conceptos record;
    r_work record;
    i integer;
    ldc_acum decimal;
    ldc_vacacion decimal;
    ld_desde date;
    li_id int4;
begin
    ldc_vacacion = 0;
    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_compania
    and codigo_empleado = ac_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    ld_desde = r_pla_empleados.fecha_inicio;
    
    ldc_acum = 0;
    ldc_vacacion = 0;
    select into ldc_acum sum(monto) from v_pla_acumulados
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto_calcula = ''220''
    and fecha >= ld_desde;
    if ldc_acum is null then
        return 0;
    end if;

    ldc_vacacion    =   f_vacacion_proporcional(ai_compania, ac_codigo_empleado, ad_fecha);
    ldc_acum        =   ldc_acum + ldc_vacacion;

    return ldc_acum/52;
end;
' language plpgsql;




create function f_xiii_proporcional(int4, char(7), date) returns decimal as '
declare
    ai_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ad_fecha alias for $3;

    r_pla_empleados record;
    r_pla_xiii record;
    r_pla_work record;
    r_pla_conceptos record;
    r_work record;
    i integer;
    ldc_acum decimal;
    ldc_vacacion decimal;
    ld_desde date;
    ld_desde_2 date;
    li_id int4;
begin
    ldc_vacacion = 0;

    select into r_pla_empleados * from pla_empleados
    where compania = ai_compania
    and codigo_empleado = ac_codigo_empleado;
    if not found then
        return 0;
    end if;

    ld_desde = ''1968-01-01'';

    select into r_pla_xiii * from pla_xiii
    where compania = r_pla_empleados.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and dia_d_pago < ad_fecha;
    if found then
        select into ld_desde Max(acum_hasta) from pla_xiii
        where compania = r_pla_empleados.compania
        and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
        and dia_d_pago < ad_fecha;
    else
        select into ld_desde Max(dia_d_pago) from pla_xiii
        where compania = r_pla_empleados.compania
        and tipo_de_planilla = r_pla_empleados.tipo_de_planilla;
        if not found then
            select Max(fecha) into ld_desde
            from pla_preelaboradas
            where compania = r_pla_empleados.compania
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and concepto = ''109''
            and monto <> 0;
            if found then
                ld_desde = ld_desde + 1;
            else
                ld_desde = ''1968-01-01'';
            end if;
        end if;

        select into ld_desde_2 Max(dia_d_pago)
        from pla_dinero, pla_periodos
        where pla_dinero.id_periodos = pla_periodos.id
        and pla_dinero.compania = r_pla_empleados.compania
        and pla_dinero.codigo_empleado = r_pla_empleados.codigo_empleado
        and pla_dinero.tipo_de_calculo = ''3'';
        if found and ld_desde_2 > ld_desde then
            ld_desde = ld_desde_2;
        end if;
        
    end if;
    

    

    ld_desde = ld_desde + 1;
    
    
    if r_pla_empleados.fecha_inicio > ld_desde or ld_desde is null then
        ld_desde = r_pla_empleados.fecha_inicio;
    end if;

    ldc_acum = 0;
    ldc_vacacion = 0;
    select into ldc_acum sum(monto) from v_pla_acumulados
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto_calcula = ''109''
    and fecha >= ld_desde;
    if ldc_acum is null then
        ldc_acum = 0;
    end if;


    ldc_vacacion    =   f_vacacion_proporcional(ai_compania, ac_codigo_empleado, ad_fecha);
    ldc_acum        =   ldc_acum + ldc_vacacion;
    
    if ldc_acum <= 0 then
        return 0;
    end if;

    return ldc_acum/12;
end;
' language plpgsql;



create function f_vacacion_proporcional(int4, char(7), date) returns decimal as '
declare
    ai_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ad_fecha alias for $3;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_vacaciones record;
    r_pla_work record;
    r_pla_conceptos record;
    i integer;
    li_id int4;
    ldc_acum decimal;
    ld_desde date;
begin
    ldc_acum = 0;
    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_compania
    and codigo_empleado = ac_codigo_empleado;
    if not found then
        Raise Exception ''Codigo de Empleado no Existe %'',ac_codigo_empleado;
    else
        if r_pla_empleados.status = ''I'' or r_pla_empleados.fecha_terminacion_real is not null then
            return 0;
        end if;
    end if;

    select into r_pla_vacaciones * from pla_vacaciones
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado;
    if found then
        select into ld_desde Max(acum_hasta) from pla_vacaciones
        where compania = r_pla_empleados.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado;
        
        ld_desde = ld_desde + 1;
    else
        select Max(fecha) into ld_desde
        from pla_preelaboradas
        where compania = r_pla_empleados.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and concepto = ''108''
        and monto <> 0;
        if not found or ld_desde is null then
            ld_desde = ''1968-01-01'';
        else
            ld_desde    =   ld_desde + 1;
        end if;
    end if;
    
    if r_pla_empleados.fecha_inicio > ld_desde then
        ld_desde = r_pla_empleados.fecha_inicio;
    end if;
    

    select into ldc_acum sum(monto) from v_pla_acumulados
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto_calcula = ''108''
    and fecha >= ld_desde;
    if ldc_acum is null then
        return 0;
    end if;
    
    return ldc_acum/11;
        
end;
' language plpgsql;



create function f_certificados_medicos_pendientes(int4) returns integer as '
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
    ldc_monto decimal;
    ld_desde date;
    li_id int4;
    li_minutos_certificados_pendientes int4;
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


    li_minutos_certificados_pendientes  =   f_minutos_certificados_pendientes(r_pla_empleados.compania, r_pla_empleados.codigo_empleado, r_pla_liquidacion.fecha);
    ldc_monto   =   li_minutos_certificados_pendientes / 60 * r_pla_empleados.tasa_por_hora;

    
    if ldc_monto > 0 then
        insert into pla_liquidacion_calculo (id_pla_liquidacion, concepto, 
                forma_de_registro, monto)
        values (ai_id, ''190'',''A'',ldc_monto);
    end if;

    return 1;
end;
' language plpgsql;



create function f_pla_liquidacion(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_liquidacion record;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_liquidacion_calculo record;
    r_pla_liquidacion_acumulados record;
    r_pla_conceptos record;
    r_pla_dinero record;
    i int4;
    li_minutos_certificados_pendientes int4;
    ldc_monto decimal;
    li_mes integer;
    lb_work boolean;
    ld_desde date;
begin
    select into r_pla_dinero *
    from pla_dinero
    where id_pla_liquidacion = ai_id
    and id_pla_cheques_1 is not null;
    if found then
        Raise Exception ''Liquidacion % ya fue pagada'', ai_id;
    end if; 
   

    select into r_pla_liquidacion * from pla_liquidacion
    where id = ai_id;
    if not found then
        raise exception ''Liquidacion no Existe % No Existe'',ai_id;
    end if;


    
    
--    lb_work = f_valida_fecha(r_pla_liquidacion.compania, r_pla_liquidacion.fecha);
    
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_liquidacion.compania
    and codigo_empleado = r_pla_liquidacion.codigo_empleado;
    if not found then
        Raise Exception ''Codigo de empleado % no Existe'', r_pla_liquidacion.codigo_empleado;
    end if;
    
    if r_pla_emplados.status <> ''A'' then
        return 0;
    end if;
    
    if not r_pla_liquidacion.preliminar and r_pla_empleados.fecha_terminacion_real is null then
        update pla_empleados
        set fecha_terminacion_real = r_pla_liquidacion.fecha
        where compania = r_pla_empleados.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado;
    end if;


    select into r_pla_periodos * from pla_periodos
    where compania = r_pla_liquidacion.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and r_pla_liquidacion.fecha_d_pago between desde and dia_d_pago
    and status = ''A''
    order by dia_d_pago;
    if not found then
        raise exception ''No existe planilla abierta para esta fecha %'',r_pla_liquidacion.fecha_d_pago;
    end if;
    
--    raise exception ''% %'', r_pla_liquidacion.fecha_d_pago, r_pla_periodos.id;

    ld_desde = r_pla_periodos.desde - 30;    

    delete from pla_liquidacion_calculo
    where id_pla_liquidacion = ai_id;

    
    delete from pla_dinero
    using pla_periodos
    where pla_dinero.id_periodos = pla_periodos.id
    and pla_periodos.status = ''A''
    and pla_periodos.desde >= ld_desde
    and pla_dinero.compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and forma_de_registro = ''A''
    and tipo_de_calculo = ''7'';
    
    i = f_vacacion_proporcional(ai_id);
    i = f_xiii_proporcional(ai_id);
    i = f_prima_de_antiguedad(ai_id);

    
    if not r_pla_liquidacion.justificado then
        i = f_preaviso(ai_id);
        i = f_indemnizacion(ai_id);
    end if;

    if r_pla_empleados.sindicalizado = ''S'' then
        i   =   f_certificados_medicos_pendientes(ai_id);
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where compania = r_pla_empleados.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and r_pla_liquidacion.fecha_d_pago between desde and dia_d_pago;
    if not found then
        return 0;
    end if;

    li_mes = Mes(r_pla_liquidacion.fecha);

    i = f_pla_retenciones_liquidacion(''102'',ai_id);
    i = f_pla_retenciones_liquidacion(''103'',ai_id);
    i = f_pla_retenciones_liquidacion(''104'',ai_id);
    

    if r_pla_liquidacion.preliminar then
        return 1;
    end if;


    
    delete from pla_dinero
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and tipo_de_calculo = ''7''
    and id_periodos = r_pla_periodos.id
    and forma_de_registro = ''A'';
    
    for r_pla_liquidacion_calculo in select * from pla_liquidacion_calculo
                        where id_pla_liquidacion = ai_id
                        order by concepto
    loop
    
        select into r_pla_conceptos * from pla_conceptos
        where concepto = r_pla_liquidacion_calculo.concepto;
        
        select into i id
        from pla_dinero
        where compania = r_pla_empleados.compania
        and id_periodos = r_pla_periodos.id
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and tipo_de_calculo = ''7''
        and concepto = r_pla_liquidacion_calculo.concepto;
        if not found then        
            insert into pla_dinero(id_periodos, compania, codigo_empleado,
                tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                monto, id_pla_liquidacion)
            values(r_pla_periodos.id, r_pla_empleados.compania, r_pla_empleados.codigo_empleado, 
                ''7'', r_pla_liquidacion_calculo.concepto, ''A'', 
                r_pla_conceptos.descripcion, li_mes,
                r_pla_liquidacion_calculo.monto, ai_id);
              
--            i = lastval();
            select into i id
            from pla_dinero
            where compania = r_pla_empleados.compania
            and id_periodos = r_pla_periodos.id
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and tipo_de_calculo = ''7''
            and concepto = r_pla_liquidacion_calculo.concepto;
            
        end if;    
        

        for r_pla_liquidacion_acumulados in select * from pla_liquidacion_acumulados
                                                where id_pla_liquidacion_calculo = r_pla_liquidacion_calculo.id
        loop
            insert into pla_acumulados(id_pla_dinero, concepto, fecha, monto)
            values(i, r_pla_liquidacion_acumulados.concepto, 
                r_pla_liquidacion_acumulados.fecha, r_pla_liquidacion_acumulados.monto);
        end loop;
    end loop;

    if r_pla_empleados.sindicalizado = ''S'' then
        li_minutos_certificados_pendientes  =   f_minutos_certificados_pendientes(r_pla_empleados.compania, r_pla_empleados.codigo_empleado, r_pla_liquidacion.fecha);
        ldc_monto   =   li_minutos_certificados_pendientes / 60 * r_pla_empleados.tasa_por_hora;
        
        if ldc_monto > 0 then
            i   =   f_pla_dinero_insert(r_pla_empleados.compania, 
                        r_pla_empleados.codigo_empleado, ''7'', r_pla_empleados.departamento,
                        null, ''190'', ''CERTIFICADOS MEDICOS'', li_mes, ldc_monto);
        end if;
    end if;

    
    i = f_pla_seguro_social(r_pla_empleados.compania, r_pla_empleados.codigo_empleado, 
            r_pla_periodos.id, ''7'');
            
    i = f_pla_seguro_educativo(r_pla_empleados.compania, r_pla_empleados.codigo_empleado, 
            r_pla_periodos.id, ''7'');
    
    return 1;
end;
' language plpgsql;



create function f_pla_retenciones_liquidacion(char(3), int4) returns integer as '
declare
    ac_concepto alias for $1;
    ai_id_pla_liquidacion alias for $2;
    r_pla_conceptos record;
    ldc_work decimal;
    ldc_work2 decimal;
    ldc_acumulado decimal;
    i integer;
begin
    select into r_pla_conceptos * from pla_conceptos
    where concepto = ac_concepto;

    ldc_acumulado = 0;
    select into ldc_acumulado sum(pla_liquidacion_calculo.monto*pla_conceptos.signo)
    from pla_liquidacion_calculo, pla_conceptos, pla_conceptos_acumulan
    where pla_liquidacion_calculo.concepto = pla_conceptos.concepto
    and pla_liquidacion_calculo.concepto = pla_conceptos_acumulan.concepto_aplica
    and pla_liquidacion_calculo.id_pla_liquidacion = ai_id_pla_liquidacion
    and pla_conceptos_acumulan.concepto = ac_concepto;
    if ldc_acumulado is null then
        ldc_acumulado = 0;
    end if;


    if trim(ac_concepto) = ''102'' then
        ldc_work = ldc_acumulado * .09;
    elsif trim(ac_concepto) = ''103'' then
            ldc_work    =   ldc_acumulado * .0725;
    elsif trim(ac_concepto) = ''104'' then
            ldc_work    =   ldc_acumulado * .0125;
    end if;
    
    if ldc_work is not null and ldc_work <> 0 then    
        insert into pla_liquidacion_calculo(id_pla_liquidacion, concepto, forma_de_registro, monto)
        values(ai_id_pla_liquidacion, ac_concepto, ''A'', ldc_work);
    end if;
    return 1;
end;
' language plpgsql;


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
    ld_desde date;
    li_id int4;
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
    

    ld_desde = r_pla_empleados.fecha_inicio;

    ldc_acum = 0;
    ldc_vacacion = 0;
    
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

    insert into pla_liquidacion_calculo (id_pla_liquidacion, concepto, forma_de_registro, monto)
    values (ai_id, ''130'',''A'',(ldc_acum/52*3.4));

    li_id   =   lastval();
    
    for r_pla_work in select v_pla_acumulados.id, v_pla_acumulados.concepto_acumula, 
                        v_pla_acumulados.fecha, v_pla_acumulados.monto
                        from v_pla_acumulados
                        where v_pla_acumulados.compania = r_pla_empleados.compania
                        and v_pla_acumulados.codigo_empleado = r_pla_empleados.codigo_empleado
                        and v_pla_acumulados.concepto_calcula = ''130''
                        and v_pla_acumulados.fecha >= ld_desde
                        order by v_pla_acumulados.fecha, v_pla_acumulados.concepto_acumula
    loop
        select into r_pla_conceptos *
        from pla_conceptos
        where concepto = r_pla_work.concepto_acumula;
        insert into pla_liquidacion_acumulados (id_pla_liquidacion_calculo, concepto, fecha, monto)
        values (li_id, r_pla_work.concepto_acumula, r_pla_work.fecha, (r_pla_work.monto*r_pla_conceptos.signo));
    end loop;
    
    if ldc_vacacion > 0 then
        insert into pla_liquidacion_acumulados (id_pla_liquidacion_calculo, concepto, fecha, monto)
        values (li_id, ''108'', r_pla_liquidacion.fecha, ldc_vacacion);
    end if;
    
    return 1;
end;
' language plpgsql;


create function f_vacacion_proporcional(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_liquidacion record;
    r_pla_liquidacion_calculo record;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_vacaciones record;
    r_pla_work record;
    r_pla_conceptos record;
    i integer;
    li_id int4;
    ldc_acum decimal;
    ld_desde date;
begin
    ldc_acum = 0;
    select into r_pla_liquidacion * from pla_liquidacion
    where id = ai_id;
    if not found then
        raise exception ''Liquidacion no Existe % No Existe'',ai_id;
    end if;
    
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_liquidacion.compania
    and codigo_empleado = r_pla_liquidacion.codigo_empleado;

    select into r_pla_periodos *
    from pla_periodos
    where compania = r_pla_liquidacion.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and r_pla_liquidacion.fecha_d_pago between desde and hasta;
    

    select into r_pla_vacaciones * from pla_vacaciones
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado;
    if found then
        select into ld_desde Max(acum_hasta) from pla_vacaciones
        where compania = r_pla_empleados.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado;
        
        ld_desde = ld_desde + 1;
    else
        select Max(fecha) into ld_desde
        from pla_preelaboradas
        where compania = r_pla_empleados.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and concepto = ''108''
        and monto <> 0;
        if not found or ld_desde is null then
            ld_desde = ''1968-01-01'';
        else
            ld_desde    =   ld_desde + 1;
        end if;
    end if;
    
    if r_pla_empleados.fecha_inicio > ld_desde then
        ld_desde = r_pla_empleados.fecha_inicio;
    end if;
    


/*    
    select into ldc_acum sum(pla_dinero.monto*pla_conceptos.signo) 
    from pla_dinero, pla_conceptos, pla_conceptos_acumulan, pla_periodos
    where pla_periodos.id = pla_dinero.id_periodos
    and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
    and pla_conceptos_acumulan.concepto = pla_conceptos.concepto
    and pla_dinero.compania = r_pla_empleados.compania
    and pla_dinero.codigo_empleado = r_pla_empleados.codigo_empleado
    and pla_conceptos_acumulan.concepto = ''108''
    and pla_periodos.dia_d_pago >= ld_desde;
    if ldc_acum is null then
        return 1;
    end if;
*/

    if r_pla_periodos.dia_d_pago > r_pla_empleados.fecha_terminacion_real then
        r_pla_empleados.fecha_terminacion_real = r_pla_periodos.dia_d_pago;
    end if;



    
    select into ldc_acum sum(monto) from v_pla_acumulados
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto_calcula in (''108'')
    and fecha >= ld_desde;
    if ldc_acum is null then
        return 0;
    end if;
    
    
    insert into pla_liquidacion_calculo (id_pla_liquidacion, concepto, forma_de_registro, monto)
    values (ai_id, ''108'',''A'',(ldc_acum/11));
    
    li_id   =   lastval();


    
    for r_pla_work in select v_pla_acumulados.id, v_pla_acumulados.concepto_acumula, 
                        v_pla_acumulados.fecha, v_pla_acumulados.monto
                        from v_pla_acumulados
                        where v_pla_acumulados.compania = r_pla_empleados.compania
                        and v_pla_acumulados.codigo_empleado = r_pla_empleados.codigo_empleado
                        and v_pla_acumulados.concepto_calcula = ''108''
                        and v_pla_acumulados.fecha >= ld_desde
                        order by v_pla_acumulados.fecha, v_pla_acumulados.concepto_acumula
    loop
        select into r_pla_conceptos *
        from pla_conceptos
        where concepto = r_pla_work.concepto_acumula;
        insert into pla_liquidacion_acumulados (id_pla_liquidacion_calculo, concepto, fecha, monto)
        values (li_id, r_pla_work.concepto_acumula, r_pla_work.fecha, (r_pla_work.monto*r_pla_conceptos.signo));
    end loop;



    select into ldc_acum sum(monto) from v_pla_acumulados
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto_calcula in (''107'')
    and fecha >= ld_desde;
    if ldc_acum is null then
        return 0;
    end if;
    
    
    insert into pla_liquidacion_calculo (id_pla_liquidacion, concepto, forma_de_registro, monto)
    values (ai_id, ''107'',''A'',(ldc_acum/11));

    li_id   =   lastval();

    
    for r_pla_work in select v_pla_acumulados.id, v_pla_acumulados.concepto_acumula, 
                        v_pla_acumulados.fecha, v_pla_acumulados.monto
                        from v_pla_acumulados
                        where v_pla_acumulados.compania = r_pla_empleados.compania
                        and v_pla_acumulados.codigo_empleado = r_pla_empleados.codigo_empleado
                        and v_pla_acumulados.concepto_calcula = ''107''
                        and v_pla_acumulados.fecha >= ld_desde
                        order by v_pla_acumulados.fecha, v_pla_acumulados.concepto_acumula
    loop
    
        select into r_pla_conceptos *
        from pla_conceptos
        where concepto = r_pla_work.concepto_acumula;
        insert into pla_liquidacion_acumulados (id_pla_liquidacion_calculo, concepto, fecha, monto)
        values (li_id, r_pla_work.concepto_acumula, r_pla_work.fecha, (r_pla_work.monto*r_pla_conceptos.signo));
    end loop;
    
    
    return 1;
end;
' language plpgsql;



create function f_xiii_proporcional(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_liquidacion record;
    r_pla_liquidacion_calculo record;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_xiii record;
    r_pla_work record;
    r_pla_conceptos record;
    r_work record;
    i integer;
    ldc_acum decimal;
    ldc_vacacion decimal;
    ld_desde date;
    ld_desde_2 date;
    li_id int4;
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

    ld_desde = ''1968-01-01'';

    select into r_pla_xiii * from pla_xiii
    where compania = r_pla_empleados.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and dia_d_pago < r_pla_liquidacion.fecha;
    if found then
        select into ld_desde Max(acum_hasta) from pla_xiii
        where compania = r_pla_empleados.compania
        and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
        and dia_d_pago < r_pla_liquidacion.fecha;
    else
        select into ld_desde Max(dia_d_pago) from pla_xiii
        where compania = r_pla_empleados.compania
        and tipo_de_planilla = r_pla_empleados.tipo_de_planilla;
        if not found then
            select Max(fecha) into ld_desde
            from pla_preelaboradas
            where compania = r_pla_empleados.compania
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and concepto = ''109''
            and monto <> 0;
            if found then
                ld_desde = ld_desde + 1;
            else
                ld_desde = ''1968-01-01'';
            end if;
        end if;

        select into ld_desde_2 Max(dia_d_pago)
        from pla_dinero, pla_periodos
        where pla_dinero.id_periodos = pla_periodos.id
        and pla_dinero.compania = r_pla_empleados.compania
        and pla_dinero.codigo_empleado = r_pla_empleados.codigo_empleado
        and pla_dinero.tipo_de_calculo = ''3'';
        if found and ld_desde_2 > ld_desde then
            ld_desde = ld_desde_2;
        end if;
        
    end if;
    

    

    ld_desde = ld_desde + 1;
    
    
    if r_pla_empleados.fecha_inicio > ld_desde or ld_desde is null then
        ld_desde = r_pla_empleados.fecha_inicio;
    end if;

    select into r_pla_periodos * from pla_periodos
    where compania = r_pla_empleados.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and r_pla_liquidacion.fecha_d_pago between desde and dia_d_pago;
    if not found then
        return 0;
    end if;
    
    if r_pla_periodos.dia_d_pago > r_pla_empleados.fecha_terminacion_real then
        r_pla_empleados.fecha_terminacion_real = r_pla_periodos.dia_d_pago;
    end if;

    select into r_pla_periodos *
    from pla_periodos
    where compania = r_pla_empleados.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and r_pla_liquidacion.fecha_d_pago between desde and dia_d_pago;
    if found then
        if r_pla_periodos.dia_d_pago > r_pla_empleados.fecha_terminacion_real then
            r_pla_empleados.fecha_terminacion_real = r_pla_periodos.dia_d_pago;
        end if;
    end if;
    
/*
    if ld_desde > r_pla_empleados.fecha_terminacion_real then
        ld_desde = r_pla_empleados.fecha_terminacion_real;
    end if;
*/    

    ldc_acum = 0;
    ldc_vacacion = 0;
    select into ldc_acum sum(monto) from v_pla_acumulados
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto_calcula = ''109''
    and fecha >= ld_desde;
    if ldc_acum is null then
        ldc_acum = 0;
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
    
    if ldc_acum <= 0 then
        return 1;
    end if;

    
    insert into pla_liquidacion_calculo (id_pla_liquidacion, concepto, forma_de_registro, monto)
    values (ai_id, ''109'',''A'',(ldc_acum/12));
    
    li_id   =   lastval();
    
    for r_pla_work in select v_pla_acumulados.id, v_pla_acumulados.concepto_acumula, 
                        v_pla_acumulados.fecha, v_pla_acumulados.monto
                        from v_pla_acumulados
                        where v_pla_acumulados.compania = r_pla_empleados.compania
                        and v_pla_acumulados.codigo_empleado = r_pla_empleados.codigo_empleado
                        and v_pla_acumulados.concepto_calcula = ''109''
                        and v_pla_acumulados.fecha >= ld_desde 
                        order by v_pla_acumulados.fecha, v_pla_acumulados.concepto_acumula
    loop
        select into r_pla_conceptos *
        from pla_conceptos
        where concepto = r_pla_work.concepto_acumula;
        insert into pla_liquidacion_acumulados (id_pla_liquidacion_calculo, concepto, fecha, monto)
        values (li_id, r_pla_work.concepto_acumula, r_pla_work.fecha, (r_pla_work.monto*r_pla_conceptos.signo));
    end loop;
    

    if ldc_vacacion > 0 then
        insert into pla_liquidacion_acumulados (id_pla_liquidacion_calculo, concepto, fecha, monto)
        values (li_id, ''108'', r_pla_liquidacion.fecha, ldc_vacacion);
    end if;


    ldc_acum = 0;
    ldc_vacacion = 0;
    select into ldc_acum sum(monto) from v_pla_acumulados
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto_calcula = ''125''
    and fecha >= ld_desde;
    if ldc_acum is null then
        ldc_acum = 0;
    end if;


    select into r_work *
    from pla_dinero
    where id_pla_liquidacion = ai_id
    and concepto = ''107'';
    if not found then    
        select into ldc_vacacion monto
        from pla_liquidacion_calculo
        where id_pla_liquidacion = ai_id
        and concepto = ''107'';
        if found then
            ldc_acum = ldc_acum + ldc_vacacion;
        end if;
    end if;
    
    if ldc_acum <= 0 then
        return 1;
    end if;

    
    insert into pla_liquidacion_calculo (id_pla_liquidacion, concepto, forma_de_registro, monto)
    values (ai_id, ''125'',''A'',(ldc_acum/12));
    
    li_id   =   lastval();
    
    for r_pla_work in select v_pla_acumulados.id, v_pla_acumulados.concepto_acumula, 
                        v_pla_acumulados.fecha, v_pla_acumulados.monto
                        from v_pla_acumulados
                        where v_pla_acumulados.compania = r_pla_empleados.compania
                        and v_pla_acumulados.codigo_empleado = r_pla_empleados.codigo_empleado
                        and v_pla_acumulados.concepto_calcula = ''125''
                        and v_pla_acumulados.fecha >= ld_desde 
                        order by v_pla_acumulados.fecha, v_pla_acumulados.concepto_acumula
    loop
        select into r_pla_conceptos *
        from pla_conceptos
        where concepto = r_pla_work.concepto_acumula;
        insert into pla_liquidacion_acumulados (id_pla_liquidacion_calculo, concepto, fecha, monto)
        values (li_id, r_pla_work.concepto_acumula, r_pla_work.fecha, (r_pla_work.monto*r_pla_conceptos.signo));
    end loop;
    

    if ldc_vacacion > 0 then
        insert into pla_liquidacion_acumulados (id_pla_liquidacion_calculo, concepto, fecha, monto)
        values (li_id, ''107'', r_pla_liquidacion.fecha, ldc_vacacion);
    end if;


    
    return 1;
end;
' language plpgsql;


create function f_prima_de_antiguedad(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_liquidacion record;
    r_pla_liquidacion_calculo record;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_xiii record;
    r_pla_work record;
    r_pla_conceptos record;
    r_work record;
    i integer;
    ldc_acum decimal;
    ldc_vacacion decimal;
    ld_desde date;
    li_id int4;
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
    
    if r_pla_empleados.tipo_contrato = ''T'' then
        return 0;
    end if;

    ld_desde = r_pla_empleados.fecha_inicio;
    
    select into r_pla_periodos * from pla_periodos
    where compania = r_pla_empleados.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and r_pla_liquidacion.fecha between desde and dia_d_pago;
    if not found then
        return 0;
    end if;
    
    if r_pla_periodos.dia_d_pago > r_pla_empleados.fecha_terminacion_real then
        r_pla_empleados.fecha_terminacion_real = r_pla_periodos.dia_d_pago;
    end if;
    
    if ld_desde > r_pla_empleados.fecha_terminacion_real  or ld_desde is null then
        ld_desde = r_pla_empleados.fecha_terminacion_real;
    end if;
    
/*
    select into r_work * from pla_periodos
    where compania = r_pla_empleados.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and r_pla_empleados.fecha_terminacion_real between desde and dia_d_pago;
    if found then
        r_pla_empleados.fecha_terminacion_real = r_work.dia_d_pago;
    end if;
*/
    


    ldc_acum = 0;
    ldc_vacacion = 0;
    select into ldc_acum sum(monto) from v_pla_acumulados
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto_calcula = ''220''
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
    
    insert into pla_liquidacion_calculo (id_pla_liquidacion, concepto, forma_de_registro, monto)
    values (ai_id, ''220'',''A'',(ldc_acum/52));

    li_id   =   lastval();    
    
    for r_pla_work in select v_pla_acumulados.id, v_pla_acumulados.concepto_acumula, 
                        v_pla_acumulados.fecha, v_pla_acumulados.monto
                        from v_pla_acumulados
                        where v_pla_acumulados.compania = r_pla_empleados.compania
                        and v_pla_acumulados.codigo_empleado = r_pla_empleados.codigo_empleado
                        and v_pla_acumulados.concepto_calcula = ''220''
                        and v_pla_acumulados.fecha between ld_desde and r_pla_empleados.fecha_terminacion_real
                        order by v_pla_acumulados.fecha, v_pla_acumulados.concepto_acumula
    loop
        select into r_pla_conceptos *
        from pla_conceptos
        where concepto = r_pla_work.concepto_acumula;
        insert into pla_liquidacion_acumulados (id_pla_liquidacion_calculo, concepto, fecha, monto)
        values (li_id, r_pla_work.concepto_acumula, r_pla_work.fecha, (r_pla_work.monto*r_pla_conceptos.signo));
    end loop;

    if ldc_vacacion > 0 then
        insert into pla_liquidacion_acumulados (id_pla_liquidacion_calculo, concepto, fecha, monto)
        values (li_id, ''108'', r_pla_liquidacion.fecha, ldc_vacacion);
    end if;
    
    return 1;
end;
' language plpgsql;



create function f_preaviso(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_liquidacion record;
    r_pla_liquidacion_calculo record;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_xiii record;
    r_pla_work record;
    i integer;
    ldc_preaviso decimal;
    ld_desde date;
    li_id int4;
    li_dias int4;
begin
    select into r_pla_liquidacion * from pla_liquidacion
    where id = ai_id;
    if not found then
        raise exception ''Liquidacion no Existe % No Existe'',ai_id;
    end if;
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_liquidacion.compania
    and codigo_empleado = r_pla_liquidacion.codigo_empleado;
        
    li_dias =   r_pla_liquidacion.fecha - r_pla_empleados.fecha_inicio;
    if li_dias >= 730 then
        return 0;
    end if;
    
    
    if r_pla_empleados.tipo_de_planilla = ''1'' then
        ldc_preaviso = r_pla_empleados.salario_bruto * 52 / 12;
    elsif r_pla_empleados.tipo_de_planilla = ''2'' then
            ldc_preaviso = r_pla_empleados.salario_bruto * 2;
    elsif r_pla_empleados.tipo_de_planilla = ''3'' then
            ldc_preaviso = r_pla_empleados.salario_bruto * 26 / 12;
    else
        return 0;
    end if;    
    
    insert into pla_liquidacion_calculo (id_pla_liquidacion, concepto, forma_de_registro, monto)
    values (ai_id, ''135'',''A'',ldc_preaviso);
    
    return 1;
end;
' language plpgsql;


