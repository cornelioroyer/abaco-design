
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
drop function f_salario_liquidacion(int4) cascade;
drop function f_pla_dinero_liquidacion(int4, char(7), int4) cascade;
drop function f_fecha_desde_xiii(int4, char(7), date) cascade;
drop function f_fecha_desde_vacaciones(int4, char(7), date) cascade;
drop function f_indemnizacion_1(int4) cascade;
drop function f_indemnizacion_2(int4) cascade;
drop function f_indemnizacion_suntracs(int4) cascade;


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
    r_work record;
    i integer;
    li_id int4;
    ldc_acum decimal;
    ldc_bonificacion decimal;
    ld_desde date;
    ld_hasta date;
    ld_hasta_work date;
    ld_work date;
begin

    ldc_acum = 0;
    select into r_pla_liquidacion * from pla_liquidacion
    where id = ai_id;
    if not found then
        raise exception ''Liquidacion no Existe % No Existe'',ai_id;
    end if;
    
    ld_hasta    =   r_pla_liquidacion.fecha_d_pago;
        
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_liquidacion.compania
    and codigo_empleado = r_pla_liquidacion.codigo_empleado;

    select into r_pla_periodos * from pla_periodos
    where compania = r_pla_liquidacion.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and r_pla_liquidacion.fecha_d_pago between hasta and dia_d_pago
    and status = ''A''
    order by dia_d_pago;
    if not found then
        raise exception ''No existe planilla abierta para esta fecha % Verifique'',r_pla_liquidacion.fecha_d_pago;
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
    

    ld_work = null;
    select into ld_work Max(dia_d_pago)
    from pla_dinero, pla_periodos
    where pla_dinero.id_periodos = pla_periodos.id
    and pla_dinero.compania = r_pla_empleados.compania
    and monto <> 0
    and pla_dinero.concepto in (''108'')
    and pla_dinero.codigo_empleado = r_pla_empleados.codigo_empleado
    and pla_periodos.dia_d_pago <= current_date
    and pla_dinero.tipo_de_calculo = ''7'';
    if ld_work is null then
        ld_work = ''1968-01-01'';
    end if;    


    if ld_desde is null then
       ld_desde = ''1968-01-01'';
    end if;


    if ld_work > ld_desde then
        ld_desde = ld_work + 1;
    end if;


    if r_pla_periodos.dia_d_pago > r_pla_empleados.fecha_terminacion_real then
        r_pla_empleados.fecha_terminacion_real = r_pla_periodos.dia_d_pago;
    end if;

    ld_desde    =   f_fecha_desde_vacaciones(r_pla_empleados.compania,
                        r_pla_empleados.codigo_empleado,
                        r_pla_liquidacion.fecha);
                       
                       
    ldc_bonificacion    =   0;
    
    if r_pla_empleados.compania <> 1142 then
        ld_hasta_work       =   ld_hasta + 60;
    else
        ld_hasta_work       =   ld_hasta;        
    end if;

    select into ldc_acum sum(monto) 
    from v_pla_acumulados
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto_calcula in (''108'')
    and fecha >= ld_desde;
    if ldc_acum is null then
        return 0;
    end if;

    ldc_bonificacion = 0;
    select into r_work *
    from pla_dinero
    where compania = r_pla_empleados.compania
    and id_periodos = r_pla_periodos.id
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and tipo_de_calculo = ''7''
    and trim(concepto) = ''75'';
    if not found then    
        select into ldc_bonificacion monto
        from pla_liquidacion_calculo
        where id_pla_liquidacion = ai_id
        and concepto = ''75'';
        if found then
            ldc_acum = ldc_acum + ldc_bonificacion;
        end if;
    end if;
    
--raise exception ''%'', ldc_bonificacion;
    
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
        if r_pla_work.fecha > r_pla_liquidacion.fecha then
            r_pla_work.fecha = r_pla_liquidacion.fecha;
        end if;
        select into r_pla_conceptos *
        from pla_conceptos
        where concepto = r_pla_work.concepto_acumula;
        insert into pla_liquidacion_acumulados (id_pla_liquidacion_calculo, concepto, fecha, monto)
        values (li_id, r_pla_work.concepto_acumula, r_pla_work.fecha, (r_pla_work.monto*r_pla_conceptos.signo));
    end loop;

    if ldc_bonificacion > 0 then
        insert into pla_liquidacion_acumulados (id_pla_liquidacion_calculo, concepto, fecha, monto)
        values (li_id, ''75'', r_pla_liquidacion.fecha, ldc_bonificacion);
    end if;

    select into ldc_acum sum(monto) 
    from v_pla_acumulados
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto_calcula in (''107'')
    and fecha between ld_desde and ld_hasta_work;
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
    ldc_bonificacion decimal;
    ldc_salario decimal;
    ld_desde date;
    ld_desde_2 date;
    ld_work date;
    ld_hasta date;
    ld_hasta_work date;
    ld_ultimo_xiii date;
    li_id int4;
begin
    ldc_vacacion = 0;
    select into r_pla_liquidacion * 
    from pla_liquidacion
    where id = ai_id;
    if not found then
        raise exception ''Liquidacion no Existe % No Existe'',ai_id;
    end if;

    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_liquidacion.compania
    and codigo_empleado = r_pla_liquidacion.codigo_empleado;

    ld_desde    =   f_fecha_desde_xiii(r_pla_empleados.compania, r_pla_empleados.codigo_empleado,
                        r_pla_liquidacion.fecha);
    ld_hasta    =   r_pla_liquidacion.fecha_indemnizacion;


--    raise exception ''%'', ld_desde;

/*    
    ld_ultimo_xiii = null;
    select into ld_ultimo_xiii Max(acum_hasta) 
    from pla_xiii
    where compania = r_pla_empleados.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla;
    if ld_ultimo_xiii is null then
        ld_ultimo_xiii = ''2500-01-01'';
    end if;        

    if ld_ultimo_xiii < ld_desde then
        ld_desde = ld_ultimo_xiii+1;
    end if;        
*/

    select into r_pla_periodos *
    from pla_periodos
    where compania = r_pla_empleados.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and r_pla_liquidacion.fecha_d_pago between hasta and dia_d_pago
    and status = ''A''
    order by dia_d_pago;
    if not found then
        raise exception ''No existe planilla abierta para esta fecha %'',r_pla_liquidacion.fecha_d_pago;
    else        
        if r_pla_periodos.dia_d_pago > r_pla_empleados.fecha_terminacion_real then
            r_pla_empleados.fecha_terminacion_real = r_pla_periodos.dia_d_pago;
        end if;
    end if;

    if r_pla_empleados.fecha_inicio > ld_desde then
        ld_desde = r_pla_empleados.fecha_inicio;
    end if;

    ld_hasta            =   r_pla_liquidacion.fecha_indemnizacion;
    ld_hasta_work       =   r_pla_liquidacion.fecha_indemnizacion + 30;
    ldc_acum            =   0;
    ldc_vacacion        =   0;
    ldc_bonificacion    =   0;
    ldc_salario         =   0;

    select into ldc_acum sum(monto) 
    from v_pla_acumulados
    where compania = r_pla_empleados.compania
    and trim(codigo_empleado) = trim(r_pla_empleados.codigo_empleado)
    and trim(concepto_calcula) = ''109''
    and fecha >= ld_desde;
    if ldc_acum is null then
        ldc_acum = 0;
    end if;

    ldc_bonificacion = 0;
    
    select into r_work *
    from pla_dinero
    where compania = r_pla_empleados.compania
    and id_periodos = r_pla_periodos.id
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and tipo_de_calculo = ''7''
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
        if r_pla_work.fecha > r_pla_liquidacion.fecha then
            r_pla_work.fecha = r_pla_liquidacion.fecha;
        end if;
                    
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

    ldc_salario         = 0;
    ldc_acum            = 0;
    ldc_vacacion        = 0;
    ldc_bonificacion    = 0;

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
                        and v_pla_acumulados.fecha between ld_desde and ld_hasta_work
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
    ldc_pa decimal;
    ldc_dias decimal;
    ldc_anios decimal;
    ldc_bonificacion decimal;
    ld_desde date;
    ld_desde_work date;
    ld_work date;
    ld_hasta date;
    li_id int4;
begin
    ldc_vacacion = 0;
    select into r_pla_liquidacion * from pla_liquidacion
    where id = ai_id;
    if not found then
        raise exception ''Liquidacion no Existe % No Existe'',ai_id;
    end if;
    
    ld_hasta = r_pla_liquidacion.fecha_d_pago;
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_liquidacion.compania
    and codigo_empleado = r_pla_liquidacion.codigo_empleado;
    
    if r_pla_empleados.tipo_contrato = ''T'' then
        return 0;
    end if;


    ld_desde = r_pla_empleados.fecha_inicio;


    select into r_pla_periodos *
    from pla_periodos
    where compania = r_pla_empleados.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and r_pla_liquidacion.fecha_d_pago between hasta and dia_d_pago
    and status = ''A''
    order by dia_d_pago;
    if not found then
        raise exception ''No existe planilla abierta para esta fecha %'',r_pla_liquidacion.fecha_d_pago;
    end if;

    if r_pla_periodos.dia_d_pago > r_pla_empleados.fecha_terminacion_real then
        r_pla_empleados.fecha_terminacion_real = r_pla_periodos.dia_d_pago;
    end if;
    
    if ld_desde > r_pla_empleados.fecha_terminacion_real  or ld_desde is null then
        ld_desde = r_pla_empleados.fecha_terminacion_real;
    end if;
    
    ld_work = null;
    select into ld_work Max(dia_d_pago)
    from pla_dinero, pla_periodos
    where pla_dinero.id_periodos = pla_periodos.id
    and pla_dinero.compania = r_pla_empleados.compania
    and monto <> 0
    and pla_periodos.dia_d_pago <= (current_date - 15)
    and pla_dinero.codigo_empleado = r_pla_empleados.codigo_empleado
    and pla_dinero.tipo_de_calculo = ''7'';
    if ld_work is null then
        ld_work = ''1968-01-01'';
    end if;    

    if ld_work > ld_desde then
        ld_desde = ld_work + 1;
    end if;
    
    if ld_desde >= ld_hasta then
        ld_desde    =   r_pla_empleados.fecha_inicio;
    end if;
    
    ldc_dias        =   ld_hasta - ld_desde;
    ldc_anios       =   ldc_dias / 365;
    ldc_acum        =   0;
    ldc_vacacion    =   0;
    ld_desde_work   =   ld_desde;
    
    if ldc_anios >= 5 then
        ld_desde_work    =   f_relative_dmy(''ANIO'', ld_hasta, -5);

        select into ldc_acum sum(monto) 
        from v_pla_acumulados
        where compania = r_pla_empleados.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and concepto_calcula = ''220''
        and fecha between ld_desde_work and ld_hasta;
        if ldc_acum is null then
            return 1;
        end if;
    else

        select into ldc_acum sum(monto) 
        from v_pla_acumulados
        where compania = r_pla_empleados.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and concepto_calcula = ''220''
        and fecha >= ld_desde_work;
        if ldc_acum is null then
            return 1;
        end if;
    end if;    

    ldc_bonificacion = 0;
    select into r_work *
    from pla_dinero
    where compania = r_pla_empleados.compania
    and id_periodos = r_pla_periodos.id
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and tipo_de_calculo = ''7''
    and concepto = ''75'';
    if not found then
        select into ldc_bonificacion monto
        from pla_liquidacion_calculo
        where id_pla_liquidacion = ai_id
        and concepto = ''75'';
        if found then
            ldc_acum = ldc_acum + ldc_bonificacion;
        end if;
    end if;

    ldc_vacacion = 0;    
    select into r_work *
    from pla_dinero
    where compania = r_pla_empleados.compania
    and id_periodos = r_pla_periodos.id
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and tipo_de_calculo = ''7''
    and trim(concepto) = ''108'';
    if not found then
        select into ldc_vacacion monto
        from pla_liquidacion_calculo
        where id_pla_liquidacion = ai_id
        and concepto = ''108'';
        if found then
            ldc_acum = ldc_acum + ldc_vacacion;
        end if;
    end if;    
    
    if ldc_anios >= 5 then
        ldc_pa  =   ldc_acum/260*ldc_anios;
    else    
        ldc_pa  =   ldc_acum / 52;
    end if;

    insert into pla_liquidacion_calculo (id_pla_liquidacion, concepto, forma_de_registro, monto)
    values (ai_id, ''220'',''A'',ldc_pa);

    li_id   =   lastval();    
--                        and v_pla_acumulados.fecha between ld_desde_work and ld_hasta
    
    for r_pla_work in select v_pla_acumulados.id, v_pla_acumulados.concepto_acumula, 
                        v_pla_acumulados.fecha, v_pla_acumulados.monto
                        from v_pla_acumulados
                        where v_pla_acumulados.compania = r_pla_empleados.compania
                        and v_pla_acumulados.codigo_empleado = r_pla_empleados.codigo_empleado
                        and v_pla_acumulados.fecha >= ld_desde_work
                        and v_pla_acumulados.concepto_calcula = ''220''
                        order by v_pla_acumulados.fecha, v_pla_acumulados.concepto_acumula
    loop
        if r_pla_work.fecha > r_pla_liquidacion.fecha then
            r_pla_work.fecha = r_pla_liquidacion.fecha;
        end if;
        
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

    if ldc_bonificacion > 0 then
        insert into pla_liquidacion_acumulados (id_pla_liquidacion_calculo, concepto, fecha, monto)
        values (li_id, ''75'', r_pla_liquidacion.fecha, ldc_bonificacion);
    end if;

    
    return 1;
end;
' language plpgsql;


create function f_indemnizacion_suntracs(int4) returns integer as '
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
    ldc_bonificacion decimal;
    ld_work date;
    ld_hasta date;
    ld_hasta_work date;
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

    
    select into r_pla_periodos *
    from pla_periodos
    where compania = r_pla_empleados.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and r_pla_liquidacion.fecha_d_pago between hasta and dia_d_pago
    and status = ''A''
    order by dia_d_pago;
    if not found then
        raise exception ''No existe planilla abierta para esta fecha %'',r_pla_liquidacion.fecha_d_pago;
    end if;
    
    ld_hasta    =   r_pla_liquidacion.fecha;
    
    
    
--    lc_suntracs =   Trim(f_pla_parametros(r_pla_liquidacion.compania, ''suntracs'', ''N'', ''GET''));
    
    ld_desde    = r_pla_empleados.fecha_inicio;
    
    ld_work = null;
    select into ld_work Max(dia_d_pago)
    from pla_dinero, pla_periodos
    where pla_dinero.id_periodos = pla_periodos.id
    and pla_dinero.compania = r_pla_empleados.compania
    and monto <> 0
    and pla_dinero.codigo_empleado = r_pla_empleados.codigo_empleado
    and pla_periodos.dia_d_pago <= ld_hasta
    and pla_dinero.tipo_de_calculo = ''7'';
    if ld_work is null then
        ld_work = ''1968-01-01'';
    end if;    

    if ld_work > ld_desde then
        ld_desde = ld_work + 1;
    end if;

    if r_pla_empleados.fecha_inicio < ld_desde then
        ld_desde    =   r_pla_empleados.fecha_inicio;
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

    if r_pla_empleados.compania <> 1142 then
        ld_hasta_work       =   ld_hasta + 32;
    else
        ld_hasta_work       =   ld_hasta + 32;        
    end if;        
    
--    raise exception ''% %'', ld_desde, ld_hasta_work;
    
    ldc_acum            =   0; 
    ldc_bonificacion    =   0;   
    select into ldc_acum sum(monto) from v_pla_acumulados
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto_calcula = ''130''
    and fecha between ld_desde and ld_hasta_work;
    if ldc_acum is null then
        return 1;
    end if;



    ldc_bonificacion = 0;

    if r_pla_empleados.compania = 1341 then    
        select into ldc_bonificacion monto
        from pla_dinero
        where compania = r_pla_empleados.compania
        and id_periodos = r_pla_periodos.id
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and tipo_de_calculo = ''7''
        and concepto = ''75'';
        if found then
            ldc_acum = ldc_acum + ldc_bonificacion;
        else        
            select into ldc_bonificacion monto
            from pla_liquidacion_calculo
            where id_pla_liquidacion = ai_id
            and concepto = ''75'';
            if found then
                ldc_acum = ldc_acum + ldc_bonificacion;
            end if;
        end if;
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

/*
    select into r_work *
    from pla_dinero
    where id_pla_liquidacion = ai_id
    and concepto = ''75'';
    if not found then
        select into ldc_bonificacion monto
        from pla_liquidacion_calculo
        where id_pla_liquidacion = ai_id
        and concepto = ''75'';
        if found then
            ldc_acum = ldc_acum + ldc_bonificacion;
        end if;
    end if;
*/

    ldc_indemnizacion   =   ldc_acum * 0.06;
    
    insert into pla_liquidacion_calculo (id_pla_liquidacion, concepto, forma_de_registro, monto)
    values (ai_id, ''130'',''A'',ldc_indemnizacion);

    li_id   =   lastval();
    
    for r_pla_work in select v_pla_acumulados.id, v_pla_acumulados.concepto_acumula, 
                        v_pla_acumulados.fecha, v_pla_acumulados.monto
                        from v_pla_acumulados
                        where v_pla_acumulados.compania = r_pla_empleados.compania
                        and v_pla_acumulados.codigo_empleado = r_pla_empleados.codigo_empleado
                        and v_pla_acumulados.concepto_calcula = ''130''
                        and v_pla_acumulados.fecha between ld_desde and ld_hasta_work
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

/*
    if ldc_bonificacion > 0 then
        insert into pla_liquidacion_acumulados (id_pla_liquidacion_calculo, concepto, fecha, monto)
        values (li_id, ''75'', r_pla_liquidacion.fecha, ldc_bonificacion);
    end if;
*/
    
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
    
    if r_pla_liquidacion.justificado is true  then
        return 0;
    end if;
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_liquidacion.compania
    and codigo_empleado = r_pla_liquidacion.codigo_empleado;

    
    if r_pla_empleados.fecha_inicio >= r_pla_liquidacion.fecha then
        return 0;
    end if;


    lc_suntracs =   Trim(f_pla_parametros(r_pla_liquidacion.compania, ''suntracs'', ''N'', ''GET''));

    if r_pla_empleados.sindicalizado = ''S'' and trim(lc_suntracs) = ''S'' and r_pla_empleados.tipo_contrato = ''T'' then
        return f_indemnizacion_suntracs(ai_id);
    else
        if r_pla_liquidacion.fecha - r_pla_empleados.fecha_inicio <= 180 then
            return f_indemnizacion_1(ai_id);
        else
            return f_indemnizacion_2(ai_id);
        end if;
    end if;        
    return 1;
end;
' language plpgsql;


create function f_indemnizacion_2(int4) returns integer as '
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
    ldc_vacacion_proporcional decimal;
    ldc_indemnizacion decimal;
    ld_desde date;
    ld_desde_6_meses date;
    ld_desde_30_dias date;
    ld_semana_6_meses decimal;
    ldc_semana_30_dias decimal;
    ldc_acum_30_dias decimal;
    ldc_acum_6_meses decimal;
    ldc_promedio_30_dias decimal(12,2);
    ldc_promedio_6_meses decimal(12,2);
    ldc_anios_laborados decimal(12,4);
    ld_work date;
    ld_hasta date;
    ld_hasta_work date;
    li_id int4;
    lc_suntracs char(1);
begin


    ldc_vacacion                    = 0;
    select into r_pla_liquidacion * from pla_liquidacion
    where id = ai_id;
    if not found then
        raise exception ''Liquidacion no Existe % No Existe'',ai_id;
    end if;
    
    if r_pla_liquidacion.fecha_indemnizacion is null then
        r_pla_liquidacion.fecha_indemnizacion = r_pla_liquidacion.fecha;
    end if;
    
    ld_hasta        =   r_pla_liquidacion.fecha;
    ld_hasta_work   =   ld_hasta + 32;
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_liquidacion.compania
    and codigo_empleado = r_pla_liquidacion.codigo_empleado;
    
    lc_suntracs =   Trim(f_pla_parametros(r_pla_liquidacion.compania, ''suntracs'', ''N'', ''GET''));
    
    ld_desde    =   r_pla_empleados.fecha_inicio;
    
    ld_work = null;
    select into ld_work Max(dia_d_pago)
    from pla_dinero, pla_periodos
    where pla_dinero.id_periodos = pla_periodos.id
    and pla_dinero.compania = r_pla_empleados.compania
    and monto <> 0
    and pla_dinero.codigo_empleado = r_pla_empleados.codigo_empleado
    and pla_periodos.dia_d_pago <= ld_hasta
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
    ld_desde_30_dias        =   f_relative_dmy(''DAY'',r_pla_liquidacion.fecha_indemnizacion, -25);
    ld_desde_6_meses        =   f_relative_mes(r_pla_liquidacion.fecha_indemnizacion, -6)+1;
    ldc_acum_30_dias        =   0;
    ldc_acum_6_meses        =   0;
    ldc_promedio_30_dias    =   0;
    ldc_promedio_6_meses    =   0;

    ldc_vacacion_proporcional   =   0;
    select into ldc_vacacion_proporcional sum(monto)
    from v_pla_dinero_detallado
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto = ''108''
    and tipo_de_calculo = ''7''
    and fecha >= ld_desde_30_dias;
    if ldc_vacacion_proporcional is null then
        ldc_vacacion_proporcional = 0;
    end if;
    
    if r_pla_empleados.compania = 1288 then
--        ld_desde_30_dias        =   f_relative_dmy(''DAY'',r_pla_liquidacion.fecha_indemnizacion, -25);

        select into ldc_acum_30_dias sum(monto) 
        from v_pla_acumulados
        where compania = r_pla_empleados.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and concepto_calcula = ''130''
        and fecha between ld_desde_30_dias and r_pla_liquidacion.fecha_indemnizacion;
        if ldc_acum_30_dias is null then
            ldc_acum_30_dias = 0;
        end if;
    else
        select into ldc_acum_30_dias sum(monto) 
        from v_pla_acumulados
        where compania = r_pla_empleados.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and concepto_calcula = ''130''
        and fecha between ld_desde_30_dias and ld_hasta_work;
        if ldc_acum_30_dias is null then
            ldc_acum_30_dias = 0;
        end if;
    end if;
        
    ldc_acum_30_dias    =   ldc_acum_30_dias - ldc_vacacion_proporcional;

    select into ldc_acum_6_meses sum(monto) from v_pla_acumulados
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto_calcula = ''130''
    and fecha between ld_desde_6_meses and ld_hasta_work;
    if ldc_acum_6_meses is null then
        ldc_acum_6_meses = 0;
    end if;

    ldc_acum_6_meses    =   ldc_acum_6_meses - ldc_vacacion_proporcional;

    
    ldc_promedio_30_dias    =   Round((ldc_acum_30_dias * 12 / 52), 2);
    ldc_promedio_6_meses    =   Round((ldc_acum_6_meses / 26), 2);
    

--    raise exception ''anio laborados % % % %'',ldc_acum_6_meses, ldc_promedio_30_dias, ldc_promedio_6_meses, ld_desde_6_meses;
    
    if ldc_promedio_30_dias > ldc_promedio_6_meses then
        if ldc_anios_laborados > 10 then
            ldc_indemnizacion       =   (ldc_promedio_30_dias * 3.4 * 10) + ((ldc_anios_laborados - 10) * ldc_promedio_30_dias);
        else
            ldc_indemnizacion       =   ldc_promedio_30_dias * 3.4 * ldc_anios_laborados;
        end if;
    else
        if ldc_anios_laborados > 10 then
            ldc_indemnizacion       =   (ldc_promedio_6_meses * 3.4 * 10) + ((ldc_anios_laborados - 10) * ldc_promedio_6_meses);
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
                        and v_pla_acumulados.fecha between ld_desde_6_meses and ld_hasta_work
                        order by v_pla_acumulados.fecha, v_pla_acumulados.concepto_acumula
    loop
        select into r_pla_conceptos *
        from pla_conceptos
        where concepto = r_pla_work.concepto_acumula;
        
        if r_pla_work.fecha >= ld_desde_30_dias and r_pla_work.concepto_acumula = ''108''
            and ldc_vacacion_proporcional > 0 then
            
            r_pla_work.monto = r_pla_work.monto - ldc_vacacion_proporcional;
        end if;

        if r_pla_work.fecha > r_pla_liquidacion.fecha then
            r_pla_work.fecha = r_pla_liquidacion.fecha;
        end if;

        insert into pla_liquidacion_acumulados (id_pla_liquidacion_calculo, concepto, fecha, monto)
        values (li_id, r_pla_work.concepto_acumula, r_pla_work.fecha, (r_pla_work.monto*r_pla_conceptos.signo));
    end loop;

    return 1;
end;
' language plpgsql;


create function f_indemnizacion_1(int4) returns integer as '
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
    ldc_anios_laborados decimal;
    ld_work date;
    ld_hasta date;
    li_id int4;
    lc_suntracs char(1);
begin

    ldc_vacacion = 0;
    select into r_pla_liquidacion * from pla_liquidacion
    where id = ai_id;
    if not found then
        raise exception ''Liquidacion no Existe % No Existe'',ai_id;
    end if;
    
    ld_hasta    =   r_pla_liquidacion.fecha_indemnizacion;
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_liquidacion.compania
    and codigo_empleado = r_pla_liquidacion.codigo_empleado;
    
    
    lc_suntracs =   Trim(f_pla_parametros(r_pla_liquidacion.compania, ''suntracs'', ''N'', ''GET''));

    ld_desde    = r_pla_empleados.fecha_inicio;
    
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

    select into ldc_acum sum(monto) from v_pla_acumulados
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto_calcula = ''130''
    and fecha between ld_desde and ld_hasta;
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

    if r_pla_empleados.sindicalizado = ''S'' and lc_suntracs = ''S'' then
        ldc_indemnizacion   =   ldc_acum * 0.06;
    else
        ldc_indemnizacion   =   (ldc_acum/52*3.4);
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
                        and v_pla_acumulados.fecha between ld_desde and ld_hasta
                        order by v_pla_acumulados.fecha, v_pla_acumulados.concepto_acumula
    loop
        if r_pla_work.fecha > r_pla_liquidacion.fecha then
            r_pla_work.fecha = r_pla_liquidacion.fecha;
        end if;

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



create function f_fecha_desde_vacaciones(int4, char(7), date) returns date as '
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
    ld_desde_preelaboradas date;
    ld_desde_pla_xiii date;
    ld_desde_liquidacion date;
    ld_desde_pla_liquidacion date;
    ld_desde_pla_vacaciones date;
    li_id int4;
begin
    ld_desde = ''1968-01-01'';

    select into r_pla_empleados *
    from pla_empleados
    where compania = ai_compania
    and codigo_empleado = ac_codigo_empleado;
    if not found then
        Raise Exception ''Codigo de Empleado % no Existe...Verifique'',ac_codigo_empleado;
    end if;

    ld_desde_preelaboradas = null;
    select Max(fecha) into ld_desde_preelaboradas
    from pla_preelaboradas
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto = ''108''
    and fecha < ad_fecha
    and monto <> 0;
    if ld_desde_preelaboradas is null then
        ld_desde_preelaboradas = ld_desde;
    end if;
    
    
    
    ld_desde_pla_liquidacion = null;
    select into ld_desde_pla_liquidacion Max(fecha)
    from pla_liquidacion
    where compania = r_pla_empleados.compania
    and fecha < ad_fecha
    and codigo_empleado = r_pla_empleados.codigo_empleado;
    if ld_desde_pla_liquidacion is null then
        ld_desde_pla_liquidacion = ld_desde;
    end if;
    
    ld_desde_liquidacion = null;
    select into ld_desde_liquidacion Max(dia_d_pago)
    from pla_dinero, pla_periodos
    where pla_dinero.id_periodos = pla_periodos.id
    and pla_dinero.compania = r_pla_empleados.compania
    and monto <> 0
    and pla_dinero.concepto in (''108'')
    and pla_periodos.dia_d_pago < ad_fecha
    and pla_dinero.codigo_empleado = r_pla_empleados.codigo_empleado
    and pla_dinero.tipo_de_calculo = ''7'';
    if ld_desde_liquidacion is null then
        ld_desde_liquidacion = ld_desde;
    end if;
    
    ld_desde_pla_vacaciones = null;
    select into ld_desde_pla_vacaciones Max(acum_hasta)
    from pla_vacaciones
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and acum_hasta < ad_fecha;
    if ld_desde_pla_vacaciones is null then
        ld_desde_pla_vacaciones = ld_desde;
    end if;
    
    if ld_desde_pla_vacaciones > ld_desde then
        ld_desde = ld_desde_pla_vacaciones;
    end if;
    
    if r_pla_empleados.fecha_inicio > ld_desde then
        ld_desde = r_pla_empleados.fecha_inicio;
    end if;
    
    if ld_desde_liquidacion > ld_desde then
        ld_desde    =   ld_desde_liquidacion;
    end if;

    if ld_desde_preelaboradas > ld_desde then
        ld_desde    =   ld_desde_preelaboradas;
    end if;
    
    if ld_desde_pla_liquidacion > ld_desde then
        ld_desde    =   ld_desde_pla_liquidacion;
    end if;

    return ld_desde+1;
end;
' language plpgsql;




create function f_fecha_desde_xiii(int4, char(7), date) returns date as '
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
    ld_desde_preelaboradas date;
    ld_desde_pla_xiii date;
    ld_desde_liquidacion date;
    ld_desde_pla_liquidacion date;
    ld_ultimo_xiii_mes_cobrado date;
    ld_ultimo_xiii date;
    ld_fecha_work date;
    li_id int4;
begin
    ld_desde = ''1968-01-01'';

    select into r_pla_empleados *
    from pla_empleados
    where compania = ai_compania
    and trim(codigo_empleado) = trim(ac_codigo_empleado);
    if not found then
        Raise Exception ''Codigo de Empleado % no Existe...Verifique'',ac_codigo_empleado;
    end if;

    ld_ultimo_xiii = null;
    select into ld_ultimo_xiii Max(dia_d_pago) 
    from pla_xiii
    where compania = r_pla_empleados.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and dia_d_pago < ad_fecha;
    if ld_ultimo_xiii is null then
        return ld_desde;
        ld_ultimo_xiii = ld_desde;
    else
        select into r_pla_xiii *
        from pla_xiii
        where compania = r_pla_empleados.compania
        and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
        and dia_d_pago = ld_ultimo_xiii;
        if found then
            if r_pla_empleados.fecha_inicio > r_pla_xiii.acum_hasta then
                ld_ultimo_xiii_mes_cobrado = null;
                select into ld_ultimo_xiii_mes_cobrado Max(dia_d_pago)
                from pla_dinero, pla_periodos
                where pla_dinero.id_periodos = pla_periodos.id
                and pla_dinero.compania = r_pla_empleados.compania
                and monto <> 0
                and pla_dinero.concepto in (''109'')
                and pla_dinero.tipo_de_calculo = ''7''
                and pla_dinero.codigo_empleado = r_pla_empleados.codigo_empleado;
                if ld_ultimo_xiii_mes_cobrado is null then
                    return r_pla_empleados.fecha_inicio;
                else
                    return ld_ultimo_xiii_mes_cobrado + 1;
                end if;                    
            else                
                return r_pla_xiii.acum_hasta + 1;
            end if;
        end if;           
    end if;

            
    ld_desde_pla_xiii = null;
    select into ld_desde_pla_xiii Max(acum_hasta) 
    from pla_xiii
    where compania = r_pla_empleados.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and dia_d_pago < ad_fecha;
    if ld_desde_pla_xiii is null then
        ld_desde_pla_xiii = ld_desde;
    end if;

    ld_desde_preelaboradas = null;
    select Max(fecha) into ld_desde_preelaboradas
    from pla_preelaboradas
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto = ''109''
    and fecha <= ad_fecha
    and monto <> 0;
    if ld_desde_preelaboradas is null then
        ld_desde_preelaboradas = ld_desde;
    end if;

    ld_desde_pla_liquidacion = null;
    select into ld_desde_pla_liquidacion Max(fecha)
    from pla_liquidacion
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and fecha < ad_fecha;
    if ld_desde_pla_liquidacion is null then
        ld_desde_pla_liquidacion = ld_desde;
    end if;
    
    ld_desde_liquidacion = null;
    select into ld_desde_liquidacion Max(dia_d_pago)
    from pla_dinero, pla_periodos
    where pla_dinero.id_periodos = pla_periodos.id
    and pla_dinero.compania = r_pla_empleados.compania
    and monto <> 0
    and pla_dinero.concepto in (''109'')
    and pla_periodos.dia_d_pago < ad_fecha
    and pla_dinero.codigo_empleado = r_pla_empleados.codigo_empleado
    and pla_dinero.tipo_de_calculo = ''7'';
    if ld_desde_liquidacion is null then
        ld_desde_liquidacion = ld_desde;
    end if;    
    
    ld_fecha_work = ad_fecha + 30;
    ld_ultimo_xiii_mes_cobrado = null;
    select into ld_ultimo_xiii_mes_cobrado Max(dia_d_pago)
    from pla_dinero, pla_periodos
    where pla_dinero.id_periodos = pla_periodos.id
    and pla_dinero.compania = r_pla_empleados.compania
    and monto <> 0
    and pla_dinero.concepto in (''109'')
    and pla_dinero.codigo_empleado = r_pla_empleados.codigo_empleado
    and pla_periodos.dia_d_pago <= ld_fecha_work
    and pla_dinero.tipo_de_calculo = ''3'';
    
    if ld_ultimo_xiii_mes_cobrado is null then
        ld_ultimo_xiii_mes_cobrado = ld_desde;
    end if;    
    
    if r_pla_empleados.fecha_inicio > ld_desde then
        ld_desde = r_pla_empleados.fecha_inicio;
    end if;
    
    if ld_desde_liquidacion > ld_desde then
        ld_desde    =   ld_desde_liquidacion;
    end if;

    if ld_desde_preelaboradas > ld_desde then
        ld_desde    =   ld_desde_preelaboradas;
    end if;
    
    if ld_desde_pla_xiii > ld_desde then
        ld_desde    =   ld_desde_pla_xiii;
    end if;
    
    if ld_desde_pla_liquidacion > ld_desde then
        ld_desde    =   ld_desde_pla_liquidacion;
    end if;
    
    if ld_ultimo_xiii_mes_cobrado > ld_desde then
        ld_desde = ld_ultimo_xiii_mes_cobrado;
    end if;        

    return ld_desde+1;
end;
' language plpgsql;




create function f_salario_liquidacion(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_liquidacion record;
    r_pla_liquidacion_calculo record;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_vacaciones record;
    r_pla_work record;
    r_pla_conceptos record;
    r_pla_dinero record;
    i integer;
    li_id int4;
    li_dia int4;
    li_anio int4;
    li_mes int4;
    ldc_acum decimal;
    ld_desde date;
    ld_work date;
    lts_desde timestamp;
begin


    select into r_pla_liquidacion * from pla_liquidacion
    where id = ai_id;
    if not found then
        raise exception ''Liquidacion no Existe % No Existe'',ai_id;
    end if;

    select into r_pla_empleados *
    from pla_empleados
    where compania = r_pla_liquidacion.compania
    and codigo_empleado = r_pla_liquidacion.codigo_empleado;
    
    select into r_pla_periodos * from pla_periodos
    where compania = r_pla_liquidacion.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and r_pla_liquidacion.fecha_d_pago between hasta and dia_d_pago
    and status = ''A''
    order by hasta;
    if not found then
        raise exception ''No existe planilla abierta para esta fecha %'',r_pla_liquidacion.fecha_d_pago;
    end if;
    
    li_id = 0;
    select into li_id Max(id)
    from pla_dinero
    where compania = r_pla_liquidacion.compania
    and codigo_empleado = r_pla_liquidacion.codigo_empleado
    and id_periodos = r_pla_periodos.id
    and tipo_de_calculo = ''1''
    and monto <> 0
    and trim(concepto) = ''03'';
    if li_id is not null then
        return 0;
    end if;

    select into lts_desde Max(entrada)
    from pla_tarjeta_tiempo, pla_marcaciones
    where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
    and pla_tarjeta_tiempo.compania = r_pla_liquidacion.compania
    and pla_tarjeta_tiempo.id_periodos <> r_pla_periodos.id
    and pla_tarjeta_tiempo.codigo_empleado = r_pla_liquidacion.codigo_empleado;
    if not found then
        return 0;
    end if;

    ld_desde    =   lts_desde;

    
    select into ld_work Max(pagar_hasta)
    from pla_vacaciones
    where compania = r_pla_liquidacion.compania
    and codigo_empleado = r_pla_liquidacion.codigo_empleado;
    if found then
        if ld_work > ld_desde then
            ld_desde = ld_work;
        end if;        
    end if;
    
    ld_desde    =   ld_desde + 1;

/*
    if r_pla_empleados.tipo_de_salario = ''F'' and r_pla_empleados.tipo_de_planilla = ''2'' then
        li_dia  =   Extract(Day from ld_desde);
        if li_dia >= 1 and li_dia <= 15 then
            li_anio     =   Extract(Year from ld_desde);
            li_mes      =   Extract(Month from ld_desde);
            ld_desde    =   f_to_date(li_anio, li_mes, 16);
        end if;
    end if;
*/    

    if r_pla_empleados.tipo_de_planilla = ''3''
        and Trim(f_pla_parametros(r_pla_liquidacion.compania, ''crear_tarjeta_bisemanales'',''N'',''GET'')) = ''N'' then

    else
        while ld_desde <= r_pla_liquidacion.fecha loop
            i = f_crear_tarjeta(r_pla_liquidacion.compania, r_pla_liquidacion.codigo_empleado, 
                    ld_desde, r_pla_periodos.id);
            ld_desde = ld_desde + 1;
        end loop;
    end if;

-- raise exception ''% %'', ld_desde, r_pla_liquidacion.fecha;
    

    i = f_pla_horas(r_pla_liquidacion.compania, r_pla_empleados.codigo_empleado, r_pla_periodos.id);
    
    i = f_pla_dinero_liquidacion(r_pla_liquidacion.compania, r_pla_empleados.codigo_empleado, r_pla_periodos.id);
    
--    i = f_pla_dinero(r_pla_liquidacion.compania, r_pla_empleados.codigo_empleado, r_pla_periodos.id);
    
    

    
    return 1;
end;
' language plpgsql;



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
    ldc_anios_laborados decimal;
    ld_desde date;
    ld_desde_30_dias date;
    ld_desde_6_meses date;
    ldc_acum_30_dias decimal;
    ldc_acum_6_meses decimal;
    ldc_promedio_30_dias decimal;
    ldc_promedio_6_meses decimal;
    ldc_indemnizacion decimal;
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
    
    select into ldc_acum sum(monto) 
    from v_pla_acumulados
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and concepto_calcula = ''130''
    and fecha >= ld_desde;
    if ldc_acum is null then
        return 0;
    end if;
    
    ldc_vacacion    =   f_vacacion_proporcional(ai_compania, ac_codigo_empleado, ad_fecha);
    
    select into r_pla_empleados *
    from pla_empleados
    where compania = ai_compania
    and trim(codigo_empleado) = trim(ac_codigo_empleado);
    if not found then
        return 0;
    end if;
            
    if ad_fecha - r_pla_empleados.fecha_inicio <= 180 then
        return ((ldc_acum+ldc_vacacion)/52)*3.4;
    else

        ldc_anios_laborados     =   (ad_fecha - r_pla_empleados.fecha_inicio) / 365.00;
        ld_desde_30_dias        =   f_relative_dmy(''DAY'',ad_fecha, -25);
        ld_desde_6_meses        =   f_relative_mes(ad_fecha, -6)+1;
        ldc_acum_30_dias        =   0;
        ldc_acum_6_meses        =   0;
        ldc_promedio_30_dias    =   0;
        ldc_promedio_6_meses    =   0;

    
        select into ldc_acum_30_dias sum(monto) 
        from v_pla_acumulados
        where compania = r_pla_empleados.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and concepto_calcula = ''130''
        and fecha between ld_desde_30_dias and ad_fecha;
        if ldc_acum_30_dias is null then
            ldc_acum_30_dias = 0;
        end if;
    

        select into ldc_acum_6_meses sum(monto) 
        from v_pla_acumulados
        where compania = r_pla_empleados.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and concepto_calcula = ''130''
        and fecha between ld_desde_6_meses and ad_fecha;
        if ldc_acum_6_meses is null then
            ldc_acum_6_meses = 0;
        end if;

        ldc_promedio_30_dias    =   Round((ldc_acum_30_dias * 12 / 52), 2);
        ldc_promedio_6_meses    =   Round((ldc_acum_6_meses / 26), 2);
    
        if ldc_promedio_30_dias > ldc_promedio_6_meses then
            if ldc_anios_laborados > 10 then
                ldc_indemnizacion       =   (ldc_promedio_30_dias * 3.4 * 10) + ((ldc_anios_laborados - 10) * ldc_promedio_30_dias);
            else
                ldc_indemnizacion       =   ldc_promedio_30_dias * 3.4 * ldc_anios_laborados;
            end if;
        else
            if ldc_anios_laborados > 10 then
                ldc_indemnizacion       =   (ldc_promedio_6_meses * 3.4 * 10) + ((ldc_anios_laborados - 10) * ldc_promedio_6_meses);
            else
                ldc_indemnizacion       =   ldc_promedio_6_meses * 3.4 * ldc_anios_laborados;
            end if;
        end if;

        return ldc_indemnizacion;
    end if;
return 0;            
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

        ld_desde_2 = ''1968-01-01'';
        select into ld_desde_2 Max(dia_d_pago)
        from pla_dinero, pla_periodos
        where pla_dinero.id_periodos = pla_periodos.id
        and pla_dinero.compania = r_pla_empleados.compania
        and pla_dinero.codigo_empleado = r_pla_empleados.codigo_empleado
        and pla_dinero.tipo_de_calculo = ''3'';
        if ld_desde_2 is null then
            ld_desde_2 = ''1968-01-01'';
        end if;
                
        if ld_desde_2 > ld_desde then
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
    li_minutos_ausencia int4;
    ldc_work1 decimal;
    ldc_work2 decimal;
begin
    ldc_vacacion        = 0;
    
    select into r_pla_liquidacion * from pla_liquidacion
    where id = ai_id;
    if not found then
        raise exception ''Liquidacion no Existe % No Existe'',ai_id;
    end if;
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_liquidacion.compania
    and codigo_empleado = r_pla_liquidacion.codigo_empleado;


    li_minutos_ausencia = 0;
    select into li_minutos_ausencia sum(pla_horas.minutos)
    from pla_horas, pla_marcaciones, pla_tarjeta_tiempo
    where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
    and pla_marcaciones.id = pla_horas.id_marcaciones
    and pla_tarjeta_tiempo.compania = r_pla_liquidacion.compania
    and pla_tarjeta_tiempo.codigo_empleado = r_pla_liquidacion.codigo_empleado
    and pla_marcaciones.entrada between r_pla_empleados.fecha_inicio and r_pla_liquidacion.fecha
    and pla_horas.tipo_de_hora = ''20'';
    if li_minutos_ausencia is null then
        li_minutos_ausencia = 0;
    end if;    
    
--    raise exception ''ausencias %'', li_minutos_ausencia;
    
    li_minutos_certificados_pendientes  =   f_minutos_certificados_pendientes(r_pla_empleados.compania, r_pla_empleados.codigo_empleado, r_pla_liquidacion.fecha);

    if r_pla_empleados.compania = 1142 then
        ldc_monto                           =   (li_minutos_certificados_pendientes / 60) * r_pla_empleados.tasa_por_hora;
    else
        ldc_work1                           =   li_minutos_certificados_pendientes;
        ldc_work2                           =   li_minutos_ausencia;
--        ldc_monto                           =   ((li_minutos_certificados_pendientes - li_minutos_ausencia) / 60) * r_pla_empleados.tasa_por_hora;
        ldc_monto                           =   ((ldc_work1 - ldc_work2) / 60) * r_pla_empleados.tasa_por_hora;
    
    end if;        

--    raise exception ''pendiente % ausencia % monto % tasa por hora %'', li_minutos_certificados_pendientes, li_minutos_ausencia, ldc_monto, r_pla_empleados.tasa_por_hora;
    
    if ldc_monto > 0 then
        insert into pla_liquidacion_calculo (id_pla_liquidacion, concepto, 
                forma_de_registro, monto)
        values (ai_id, ''75'',''A'',ldc_monto);
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
    r_pla_cheques_1 record;
    i int4;
    li_minutos_certificados_pendientes int4;
    ldc_monto decimal;
    li_mes integer;
    lb_work boolean;
    ld_desde date;
    lc_suntracs char(1);
    lc_pagar_salario_en_liquidacion char(1);
begin

-- raise exception ''OPCION EN MANTENIMIENTO...ESPERE UN MOMENTO'';

    

    select into r_pla_dinero *
    from pla_dinero
    where id_pla_liquidacion = ai_id
    and id_pla_cheques_1 is not null;
    if found then
        select into r_pla_cheques_1 *
        from pla_cheques_1
        where id = r_pla_dinero.id_pla_cheques_1;
        
        Raise Exception ''Liquidacion % ya fue pagada con cheque %'', ai_id, r_pla_cheques_1.no_cheque;
    end if; 
   


    select into r_pla_liquidacion * from pla_liquidacion
    where id = ai_id;
    if not found then
        raise exception ''Liquidacion no Existe % No Existe'',ai_id;
    end if;

    delete from pla_dinero
    where id_pla_liquidacion = ai_id
    and id_pla_cheques_1 is not null
    and compania = r_pla_liquidacion.compania
    and forma_de_registro = ''A'';
    

    lc_suntracs                     =   Trim(f_pla_parametros(r_pla_liquidacion.compania, ''suntracs'', ''N'', ''GET''));
    lc_pagar_salario_en_liquidacion =   Trim(f_pla_parametros(r_pla_liquidacion.compania, ''pagar_salario_en_liquidacion'', ''N'', ''GET''));
    

--    lb_work = f_valida_fecha(r_pla_liquidacion.compania, r_pla_liquidacion.fecha);
    
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_liquidacion.compania
    and codigo_empleado = r_pla_liquidacion.codigo_empleado;
    if not found then
        Raise Exception ''Codigo de empleado % no Existe'', r_pla_liquidacion.codigo_empleado;
    else
        if r_pla_empleados.fecha_inicio >= r_pla_liquidacion.fecha then
            Raise Exception ''No se puede recalcular la liquidacion a un empleado ya liquidado.  Fecha Inicio %'', r_pla_empleados.fecha_inicio;
        end if;        
        
        if r_pla_empleados.status = ''I'' then
            Raise Exception ''No se puede liquidar un empleado inactivo'';
        end if;
    end if;
    
    if r_pla_empleados.status = ''V'' then
        Raise Exception ''Empleado % esta de Vacaciones...Inactive las vacaciones antes de liquidar'', r_pla_empleados.codigo_empleado;
    end if;
    

    if r_pla_empleados.status <> ''A'' then
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
    and r_pla_liquidacion.fecha_d_pago between hasta and dia_d_pago
    and status = ''A''
    order by hasta
    limit 1;
    if not found then
        raise exception ''No existe planilla abierta para esta fecha %'',r_pla_liquidacion.fecha_d_pago;
    end if;
    
--    raise exception ''% %'', r_pla_liquidacion.fecha_d_pago, r_pla_periodos.dia_d_pago;

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
    
    if trim(lc_pagar_salario_en_liquidacion) = ''S'' then
        i   =   f_salario_liquidacion(ai_id);
    end if;        

    if trim(r_pla_empleados.sindicalizado) = ''S'' and trim(lc_suntracs) = ''S'' then
        i   =   f_certificados_medicos_pendientes(ai_id);
    end if;

    
    i   =   f_vacacion_proporcional(ai_id);
    i   =   f_xiii_proporcional(ai_id);
    i   =   f_prima_de_antiguedad(ai_id);

    
    if not r_pla_liquidacion.justificado then
        i = f_preaviso(ai_id);
        i = f_indemnizacion(ai_id);
    end if;

    
    select into r_pla_periodos * from pla_periodos
    where compania = r_pla_liquidacion.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and r_pla_liquidacion.fecha_d_pago between hasta and dia_d_pago
    and status = ''A''
    order by hasta;
    if not found then
        raise exception ''No existe planilla abierta para esta fecha %'',r_pla_liquidacion.fecha_d_pago;
    end if;


--raise exception ''% %'', r_pla_periodos.dia_d_pago, r_pla_liquidacion.fecha_d_pago;
    
    li_mes = Mes(r_pla_liquidacion.fecha);

    if r_pla_empleados.retiene_ss = ''S'' then
        i = f_pla_retenciones_liquidacion(''102'',ai_id);
        i = f_pla_retenciones_liquidacion(''103'',ai_id);
        i = f_pla_retenciones_liquidacion(''104'',ai_id);
    end if;    

    if r_pla_liquidacion.preliminar then
        return 1;
    end if;


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
            if trim(r_pla_liquidacion_calculo.concepto) = ''75'' then
                if (r_pla_empleados.compania = 1289 or r_pla_empleados.compania = 1294) then
                    r_pla_conceptos.descripcion = ''BONIFICACION POR ASISTENCIA'';
                else
                    r_pla_conceptos.descripcion = ''FONDO DE ENFERMEDAD'';
                end if;                    
            end if;
            
            insert into pla_dinero(id_periodos, compania, codigo_empleado,
                tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                monto, id_pla_liquidacion)
            values(r_pla_periodos.id, r_pla_empleados.compania, r_pla_empleados.codigo_empleado, 
                ''7'', r_pla_liquidacion_calculo.concepto, ''A'', 
                r_pla_conceptos.descripcion, li_mes,
                r_pla_liquidacion_calculo.monto, ai_id);
              
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

    
/*
    if trim(r_pla_empleados.sindicalizado) = ''S'' and trim(lc_suntracs) = ''S'' then

    
        li_minutos_certificados_pendientes  =   f_minutos_certificados_pendientes(r_pla_empleados.compania, r_pla_empleados.codigo_empleado, r_pla_liquidacion.fecha);
        ldc_monto                           =   li_minutos_certificados_pendientes / 60 * r_pla_empleados.tasa_por_hora;

        if ldc_monto > 0 then
            insert into pla_dinero(id_periodos, compania, codigo_empleado,
                tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                monto, id_pla_liquidacion)
            values(r_pla_periodos.id, r_pla_empleados.compania, r_pla_empleados.codigo_empleado, 
                ''7'', ''75'', ''A'', ''CERTIFICADOS MEDICOS'', li_mes, ldc_monto, ai_id);
        end if;
    end if;
*/    

    
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
        ldc_work = ldc_acumulado * .0975;
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
    ldc_gastos_de_representacion decimal;
    ld_desde date;
    li_id int4;
    li_dias int4;
    lc_suntracs char(1);
begin
    select into r_pla_liquidacion * from pla_liquidacion
    where id = ai_id;
    if not found then
        raise exception ''Liquidacion no Existe % No Existe'',ai_id;
    end if;

    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_liquidacion.compania
    and codigo_empleado = r_pla_liquidacion.codigo_empleado;

    lc_suntracs =   Trim(f_pla_parametros(r_pla_liquidacion.compania, ''suntracs'', ''N'', ''GET''));
    
    if lc_suntracs = ''S'' and r_pla_empleados.sindicalizado = ''S'' 
        and r_pla_empleados.tipo_contrato = ''T'' then
        return 0;
    end if;

        
    li_dias =   r_pla_liquidacion.fecha - r_pla_empleados.fecha_inicio;
    if li_dias >= 730 then
        return 0;
    end if;
    
    ldc_gastos_de_representacion = 0;
    select sum(monto) into ldc_gastos_de_representacion
    from pla_otros_ingresos_fijos
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and trim(concepto) = ''73'';
    
    if ldc_gastos_de_representacion is null then
        ldc_gastos_de_representacion = 0;
    end if;
    
    if r_pla_empleados.tipo_de_planilla = ''1'' then
        ldc_preaviso = r_pla_empleados.salario_bruto * 52 / 12;
    elsif r_pla_empleados.tipo_de_planilla = ''2'' then
            ldc_preaviso = r_pla_empleados.salario_bruto * 2;
    elsif r_pla_empleados.tipo_de_planilla = ''3'' then
            ldc_preaviso = r_pla_empleados.salario_bruto * 26 / 12;
    elsif r_pla_empleados.tipo_de_planilla = ''4'' then
            ldc_preaviso = r_pla_empleados.salario_bruto;
    else
        return 0;            
    end if;    
    
    ldc_preaviso = ldc_preaviso + ldc_gastos_de_representacion;
    
    insert into pla_liquidacion_calculo (id_pla_liquidacion, concepto, forma_de_registro, monto)
    values (ai_id, ''135'',''A'',ldc_preaviso);
    
    return 1;
end;
' language plpgsql;



create function f_pla_dinero_liquidacion(int4, char(7), int4) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_turnos record;
    r_pla_vacaciones record;
    r_pla_periodos record;
    r_pla_conceptos record;
    r_v_pla_horas_valorizadas record;
    r_v_pla_implementos_valorizados record;
    r_pla_dinero record;
    r_pla_work record;
    r_work record;
    ldt_entrada_turno timestamp;
    ldt_salida_turno timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    li_minutos_regulares int4;
    ldc_work decimal;
    ldc_suma decimal;
    ldc_salario_regular decimal;
    ldc_salario_neto decimal;
    ldc_gto_representacion decimal;
    ldc_monto decimal;
    i int4;
    lb_vacaciones boolean;
    ld_work date;
    ld_desde date;
    lc_pagar_salario_en_vacaciones varchar(10);
    lc_primer_salario_completo varchar(10);
begin


    lc_pagar_salario_en_vacaciones      =   Trim(f_pla_parametros(ai_cia, ''pagar_salario_en_vacaciones'', ''N'', ''GET''));
    lc_primer_salario_completo          =   Trim(f_pla_parametros(ai_cia, ''primer_salario_completo'', ''N'', ''GET''));

    
    delete from pla_dinero
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and forma_de_registro = ''A''
    and tipo_de_calculo = ''7''
    and id_periodos = ai_id_periodos
    and id_pla_cheques_1 is null;

    ld_work = current_date - 5;

    for r_pla_dinero in 
        select * from pla_dinero
        where compania = ai_cia
        and id_periodos = ai_id_periodos
        and codigo_empleado = as_codigo_empleado
        and tipo_de_calculo = ''7''
        and id_pla_cheques_1 is not null
    loop
        return 0;
    end loop;
    

    i = 0;
    select count(*) into i
    from pla_tarjeta_tiempo, pla_marcaciones
    where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
    and pla_tarjeta_tiempo.compania = ai_cia
    and pla_tarjeta_tiempo.codigo_empleado = as_codigo_empleado
    and pla_tarjeta_tiempo.id_periodos = ai_id_periodos;
    if not found or i = 0 or i is null then
        return 0;
    end if;

    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    
    
    if r_pla_empleados.status = ''L'' 
        or r_pla_empleados.status = ''I'' 
        or r_pla_empleados.status = ''E'' then
        return 0;
    end if;

    if r_pla_empleados.status = ''V'' 
        and trim(lc_pagar_salario_en_vacaciones) = ''N'' then
        return 0;
    end if;


    select into r_pla_periodos * from pla_periodos
    where id = ai_id_periodos;
    
    ld_work = ''2100-01-01'';
    select into ld_work Min(fecha)
    from v_pla_horas_valorizadas
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and id_periodos = ai_id_periodos;
    if ld_work is null or not found then
        ld_work = ''2100-01-01'';
    else
        if ld_work < ld_desde then
            ld_desde = ld_work;
        end if;
    end if;
    
/*            
00 regular
20 ausencia
30 certificado medico
80 permiso pagado
*/

    if r_pla_empleados.tipo_de_planilla = ''2'' 
        and r_pla_empleados.tipo_de_salario = ''F''
        and Extract(Day from r_pla_periodos.dia_d_pago) = Extract(Day from r_pla_empleados.fecha_terminacion_real) then

        select into r_pla_dinero * from pla_dinero
        where id_periodos = ai_id_periodos
        and compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and tipo_de_calculo = ''7''
        and trim(concepto) = ''03''
        and forma_de_registro = ''M'';
        if not found then
            insert into pla_dinero(id_periodos, compania, codigo_empleado,
                tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                monto)
            values(ai_id_periodos, ai_cia, as_codigo_empleado, ''7'',''03'',
                ''A'', ''SALARIO REGULAR'', Mes(r_pla_periodos.dia_d_pago),
                r_pla_empleados.salario_bruto);
        end if;
    else
        for r_v_pla_horas_valorizadas in
            select * from v_pla_horas_valorizadas
            where compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and id_periodos = ai_id_periodos
            and tipo_de_calculo = ''1''
            order by fecha
        loop
            select into r_pla_conceptos * from pla_conceptos
                where concepto = r_v_pla_horas_valorizadas.concepto;

            select into r_pla_dinero * from pla_dinero
            where id_periodos = ai_id_periodos
            and compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''7''
            and concepto = r_v_pla_horas_valorizadas.concepto
            and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos
            and forma_de_registro = ''M'';
            if found then
                continue;
            end if;
        
        
            select into r_pla_dinero * from pla_dinero
            where id_periodos = ai_id_periodos
            and compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''7''
            and concepto = r_v_pla_horas_valorizadas.concepto
            and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos;
            if found then
                ldc_monto   =   r_pla_dinero.monto + (r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo);
            
                update pla_dinero
                set monto = ldc_monto 
                where id_periodos = ai_id_periodos
                and compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and tipo_de_calculo = ''7''
                and forma_de_registro = ''A''
                and id_pla_cheques_1 is null
                and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos
                and concepto = r_v_pla_horas_valorizadas.concepto;
            else
                insert into pla_dinero(id_periodos, compania, codigo_empleado,
                    tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                    monto, id_pla_proyectos, id_pla_departamentos)
                values(ai_id_periodos, ai_cia, as_codigo_empleado, ''7'',r_v_pla_horas_valorizadas.concepto,
                    ''A'', r_v_pla_horas_valorizadas.descripcion, Mes(r_pla_periodos.dia_d_pago),
                    r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo,
                    r_v_pla_horas_valorizadas.id_pla_proyectos,
                    r_v_pla_horas_valorizadas.id_pla_departamentos);
            end if;
        end loop;
    end if;
    i = f_pla_sindicato(ai_cia, as_codigo_empleado,ai_id_periodos, ''7'');
    
    delete from pla_dinero
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and forma_de_registro = ''A''
    and tipo_de_calculo = ''7''
    and id_periodos = ai_id_periodos
    and monto = 0;

    return 1;
end;
' language plpgsql;
