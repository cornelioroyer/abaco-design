set search_path to planilla;

rollback work;

begin work;
drop function f_pla_dinero(int4, char(7), int4) cascade;
drop function f_planilla_regular(int4, char(2)) cascade;
drop function f_pla_horas(int4, char(7), int4) cascade;
drop function f_procesar_tarjeta(int4, char(7), date) cascade;
drop function f_pla_horas_regulares(int4) cascade;
drop function f_pla_horas_tardanzas(int4) cascade;
--drop function f_primer_pago(int4, char(7)) cascade;
--drop function f_pla_seguro_social(int4, char(7), int4, char(2)) cascade;
--drop function f_pla_seguro_educativo(int4, char(7), int4, char(2)) cascade;
drop function f_pla_retenciones(int4, char(7), int4, char(2)) cascade;
drop function f_pla_salario_neto(int4, char(7), char(2), int4) cascade;
drop function f_pla_horas_ausencia(int4) cascade;
--drop function f_minutos_certificados_pendientes(int4, char(2), timestamp) cascade;
drop function f_pla_otros_ingresos(int4, char(7), int4, char(2)) cascade;
drop function f_pla_minutos_semanales(int4, timestamp) cascade;
drop function f_pla_minutos_diarios(int4, timestamp) cascade;
drop function f_pla_horas(int4, char(2), int4, decimal, char(1), char(1)) cascade;
--drop function f_pla_horas(int4, char(2), int4, decimal, char(1), char(1), timestamp, timestamp) cascade;
drop function f_pla_crear_periodos(int4, int4) cascade;
--drop function f_pla_crear_tarjetas_de_tiempo(int4, char(2)) cascade;
--drop function f_crear_tarjeta(int4, char(7), date, int4) cascade;
drop function f_pla_horas_permisos(int4) cascade;
drop function f_pla_salida_en_horas_laborables(int4) cascade;
drop function f_pla_horas_regulares_excedentes(int4) cascade;
drop function f_pla_horas_certificadas(int4) cascade;
drop function f_pla_liquida_semana(int4, char(7), int4) cascade;
drop function f_pla_primer_salario(int4, char(7), int4) cascade;
drop function f_planilla_regular_empleado(int4, char(7)) cascade;
drop function f_minutos_certificados_pendientes(int4, char(7), date) cascade;
drop function f_tipo_de_hora(int4, char(7), date, int4) cascade;
commit work;

drop function f_pla_bonos_de_produccion(int4, char(7), int4) cascade;
drop function f_primer_pago(int4, char(7), int4) cascade;
drop function f_pla_horas_anteriores(int4) cascade;

drop function f_pla_horas_elimina_horas_regulares_vacaciones(int4) cascade;
drop function f_activa_empleados_en_vacaciones(int4) cascade;
drop function f_pla_horas_seceyco(int4, char(7), int4) cascade;
drop function f_pla_ajustar_salida_seceyco(int4, char(7), int4) cascade;
drop function f_pla_calculo_viaticos(int4) cascade;
drop function f_pla_drive_true(int4, char(7), int4, char(2)) cascade;
drop function f_pla_reasignacion_turno(int4, char(7), int4) cascade;

create function f_pla_horas_certificadas(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_tarjeta_tiempo record;
    r_pla_certificados_medico record;
    r_pla_horas record;
    r_pla_turnos record;
    r_pla_periodos record;
    ldt_entrada_turno timestamp;
    ldt_salida_turno timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    ld_work date;
    li_minutos_regulares int4;
    li_minutos_certificados_pendientes int4;
    li_minutos_certificados_a_pagar int4;
    li_minutos_adicionales int4;
    li_work int4;
    li_min_acum int4;
    li_minutos_diarios int4;
    li_minutos_pagados int4;
    li_minutos_no_pagados int4;
    li_minutos_tardanza int4;
    li_minutos_trabajados int4;
    li_retorno integer;
    ls_tipo_de_hora char(2);
    ls_tipo_de_jornada char(1);
    ldc_tasa_por_hora decimal;
    
    ldc_work decimal;
begin
    li_minutos_adicionales  =   0;
    
    select into r_pla_marcaciones * 
    from pla_marcaciones
    where id = ai_id;
    if not found then
        return 0;
    end if;



    ld_work = r_pla_marcaciones.entrada;
    
    update pla_marcaciones
    set status = ''R''
    where id = ai_id
    and status not in (''I'',''D'',''F'');

    delete from pla_horas
    where id_marcaciones = ai_id
    and forma_de_registro = ''A''
    and tipo_de_hora in (''30'',''93'');
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    
    select into r_pla_periodos * from pla_periodos
    where id = r_pla_tarjeta_tiempo.id_periodos;
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;


/*
    if r_pla_marcaciones.status <> ''C'' then
        delete from pla_certificados_medico
        where compania = r_pla_empleados.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and fecha = date(r_pla_marcaciones.entrada)
        and year = r_pla_periodos.year
        and numero_planilla = r_pla_periodos.numero_planilla
        and minutos >= 480;
    
        return 0;
    end if;        
*/
    
    select into r_pla_certificados_medico * 
    from pla_certificados_medico
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and fecha = date(r_pla_marcaciones.entrada)
    and year = r_pla_periodos.year
    and numero_planilla = r_pla_periodos.numero_planilla;
    if not found then
        return 0;
    else
        if r_pla_marcaciones.status = ''C'' then
            li_minutos_trabajados   =   f_intervalo(r_pla_marcaciones.entrada, r_pla_marcaciones.salida) 
                                        -   f_intervalo(r_pla_marcaciones.entrada_descanso, r_pla_marcaciones.salida_descanso);
            if li_minutos_trabajados <> r_pla_certificados_medico.minutos then
--                raise exception ''Minutos laborados % debe ser igual a los certificados %'', li_minutos_trabajados, r_pla_certificados_medico.minutos;
            end if;
        end if;
    
        update pla_marcaciones
        set status = ''C''
        where id = ai_id
        and status <> ''I'';
    end if;

    li_minutos_certificados_pendientes = f_minutos_certificados_pendientes(r_pla_empleados.compania, r_pla_empleados.codigo_empleado, r_pla_certificados_medico.fecha);
    
    li_minutos_tardanza = 0;
    select sum(minutos) into li_minutos_tardanza 
    from pla_horas
    where id_marcaciones = ai_id
    and tipo_de_hora = ''21'';
    if li_minutos_tardanza is null then
        li_minutos_tardanza = 0;
    end if;
    
--
--    30 = certificados medicos pagados
--    93 = certificados medicos no pagados
--    21 = tardanza
--

    if li_minutos_certificados_pendientes <= 0 then
        update pla_certificados_medico
        set pagado = ''N''
        where compania = r_pla_certificados_medico.compania
        and codigo_empleado = r_pla_certificados_medico.codigo_empleado
        and fecha = r_pla_certificados_medico.fecha;
        
        
        if r_pla_certificados_medico.minutos <> 0 then
            li_retorno  =   f_pla_horas(r_pla_marcaciones.id, ''93'', r_pla_certificados_medico.minutos,
                                r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');

            if r_pla_empleados.tipo_de_salario = ''H'' then
                li_retorno  =   f_pla_horas(r_pla_marcaciones.id, ''00'', r_pla_certificados_medico.minutos,
                                    r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
            end if;                                    
        end if;


        
        return 0;
    end if;

    
--
--    30 = certificados medicos pagados
--    93 = certificados medicos no pagados
--    21 = tardanza
--

    if r_pla_certificados_medico.minutos > li_minutos_certificados_pendientes then
        li_minutos_pagados      =   li_minutos_certificados_pendientes;
        li_minutos_no_pagados   =   r_pla_certificados_medico.minutos - li_minutos_pagados;
    else
        li_minutos_pagados      =   r_pla_certificados_medico.minutos;
        li_minutos_no_pagados   =   0;
    end if;
    

    delete from pla_horas
    where id_marcaciones = ai_id
    and forma_de_registro = ''A'';

    
    li_minutos_pagados  =   li_minutos_pagados + li_minutos_adicionales;
    
--    li_minutos_pagados  =   li_minutos_pagados - li_minutos_tardanza;
    
    if (r_pla_marcaciones.status = ''R'' or r_pla_marcaciones.status = ''C'') 
        and li_minutos_no_pagados <> 0 then
        li_retorno          =   f_pla_horas(r_pla_marcaciones.id, ''93'', li_minutos_no_pagados, 
                                    r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');

        if r_pla_empleados.tipo_de_salario = ''H'' then
            li_retorno          =   f_pla_horas(r_pla_marcaciones.id, ''00'', li_minutos_no_pagados, 
                                    r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
        
        end if;                                    
    end if;
    
    if r_pla_marcaciones.turno is not null then
        select into r_pla_turnos *
        from pla_turnos
        where compania = r_pla_marcaciones.compania
        and turno = r_pla_marcaciones.turno;
        if found then
            if r_pla_turnos.tipo_de_jornada = ''N'' and li_minutos_pagados >= 420 and li_minutos_pagados <= 480 then
                li_minutos_pagados  =   li_minutos_pagados + 60;
                if li_minutos_pagados > 480 then
                    li_minutos_pagados = 480;
                end if;
            end if;
        end if;
    end if;


    li_retorno          =   f_pla_horas(r_pla_marcaciones.id, ''30'', li_minutos_pagados, 
                                r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');


/*
    li_retorno          =   f_pla_horas(r_pla_marcaciones.id, ''30'', li_minutos_pagados, 
                                r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');


    ls_tipo_de_hora     =   f_tipo_de_hora(r_pla_empleados.compania, r_pla_empleados.codigo_empleado, ld_work, r_pla_marcaciones.id);
    
    li_retorno          =   f_pla_horas(r_pla_marcaciones.id, ls_tipo_de_hora, -li_minutos_pagados, 
                                r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');

    if li_minutos_pagados >= li_minutos_tardanza then
        li_retorno  =   f_pla_horas(r_pla_marcaciones.id, ''00'', li_minutos_tardanza, 
                                r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
    end if;
*/    
    
    
    if r_pla_marcaciones.status = ''I'' then
        delete from pla_horas
        where id_marcaciones = ai_id
        and forma_de_registro = ''A''
        and tipo_de_hora in (''00'',''20'');
    end if;
                                
    update pla_certificados_medico
    set pagado = ''S''
    where compania = r_pla_certificados_medico.compania
    and codigo_empleado = r_pla_certificados_medico.codigo_empleado
    and fecha = r_pla_certificados_medico.fecha;
    
    update pla_desglose_regulares
    set certificado = certificado + li_minutos_pagados - li_minutos_no_pagados
    where id_pla_marcaciones = ai_id;
    
    return 1;
end;
' language plpgsql;


create function f_pla_drive_true(int4, char(7), int4, char(2)) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    as_tipo_de_calculo alias for $4;
    r_pla_periodos record;
    r_pla_dinero record;
    r_pla_conceptos record;
    r_pla_marcaciones record;
    r_pla_retenciones record;
    r_pla_eventos record;
    r_pla_empleados record;
    r_pla_tarjeta_tiempo record;
    r_pla_otros_ingresos_fijos record;
    r_pla_implementos record;
    i int4;
    ldc_work decimal;
    ldc_retener decimal;
    li_minutos int4;
    ldc_minutos decimal;
    ldc_horas decimal;
    ldc_incremento decimal;
    ldc_monto decimal;
begin
    select into r_pla_periodos * from pla_periodos
    where id = ai_id_periodos;
    if not found then
        raise exception ''Periodo % no Existe otros ingresos'',ai_id_periodos;
    end if;
    
    select into r_pla_empleados *
    from pla_empleados
    where compania = ai_cia
    and trim(codigo_empleado) = trim(as_codigo_empleado);
    if not found then
        return 0;
    end if;        

    select into r_pla_tarjeta_tiempo *
    from pla_tarjeta_tiempo
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and id_periodos = ai_id_periodos;
    if not found then
        return 0;
    end if;            

    for r_pla_marcaciones in select * from pla_marcaciones    
                                where id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
                                order by entrada
    loop                                
        for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_marcaciones.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and implemento in (''25'',''75'')
                                    and Date(desde) = Date(r_pla_marcaciones.entrada)
        loop
            select into r_pla_implementos *
            from pla_implementos
            where compania = r_pla_marcaciones.compania
            and implemento = r_pla_eventos.implemento;
            
            li_minutos      =   f_intervalo(r_pla_eventos.desde, r_pla_eventos.hasta);
            ldc_minutos     =   li_minutos;
            ldc_horas       =   ldc_minutos/60;
            ldc_incremento  =   (r_pla_implementos.recargo/100) + 1;
--            ldc_incremento  =   (r_pla_implementos.recargo/100) + 1;
--            ldc_monto       =   ldc_horas * (r_pla_empleados.tasa_por_hora*ldc_incremento);
            ldc_monto       =   ldc_horas * r_pla_empleados.tasa_por_hora;

            select into r_pla_dinero * 
            from pla_dinero
            where id_periodos = r_pla_tarjeta_tiempo.id_periodos
            and compania = r_pla_empleados.compania
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and tipo_de_calculo = ''1''
            and id_pla_cheques_1 is null
            and concepto = ''137'';
            if found then
                if r_pla_dinero.forma_de_registro = ''A'' then
                    update pla_dinero
                    set monto = monto + ldc_monto
                    where id = r_pla_dinero.id;
                end if;                    
            else
                insert into pla_dinero(id_periodos, compania, codigo_empleado,
                    tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                    monto, id_pla_proyectos, id_pla_departamentos)
                values(r_pla_tarjeta_tiempo.id_periodos, r_pla_empleados.compania, r_pla_empleados.codigo_empleado, 
                    ''1'',''137'', ''A'', null, 
                    Mes(r_pla_periodos.dia_d_pago), ldc_monto, r_pla_marcaciones.id_pla_proyectos,
                    r_pla_empleados.departamento);
            end if;
        end loop;
    end loop;
    
    return 1;
end;
' language plpgsql;



create function f_pla_calculo_viaticos(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_turnos record;
    r_pla_tarjeta_tiempo record;
    r_pla_horas record;
    r_pla_vacaciones record;
    r_pla_periodos record;
    r_pla_dinero record;
    ldt_entrada_turno timestamp;
    ldt_salida_turno timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    li_minutos_regulares int4;
    lt_hora_salida time;
    ld_fecha date;
begin
    select into r_pla_marcaciones * 
    from pla_marcaciones
    where id = ai_id;
    if not found then
        return 0;
    end if;
    
    if r_pla_marcaciones.turno is null then
        return 0;
    end if;
    
    select into r_pla_turnos *
    from pla_turnos
    where compania = r_pla_marcaciones.compania
    and turno = r_pla_marcaciones.turno;
    if not found then
        return 0;
    end if;

    if r_pla_turnos.tipo_de_jornada <> ''D'' then
        return 0;
    end if;        

    select into r_pla_tarjeta_tiempo * 
    from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    
    select into r_pla_empleados *
    from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;
    if not found then
        return 0;
    end if;        
    
    if trim(r_pla_empleados.sindicalizado) <> ''S'' then
        return 0;
    end if;        
    
    select into r_pla_periodos *
    from pla_periodos
    where id = r_pla_tarjeta_tiempo.id_periodos;


    lt_hora_salida  =   r_pla_marcaciones.salida;
    
    if lt_hora_salida > ''18:00''  then

            select into r_pla_dinero * 
            from pla_dinero
            where id_periodos = r_pla_tarjeta_tiempo.id_periodos
            and compania = r_pla_empleados.compania
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and tipo_de_calculo = ''1''
            and id_pla_cheques_1 is null
            and concepto = ''119'';
            if found then
                if r_pla_dinero.forma_de_registro = ''A'' then
                    update pla_dinero
                    set monto = monto + 6.5
                    where id = r_pla_dinero.id;
                end if;                    
            else
                insert into pla_dinero(id_periodos, compania, codigo_empleado,
                    tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                    monto, id_pla_proyectos, id_pla_departamentos)
                values(r_pla_tarjeta_tiempo.id_periodos, r_pla_empleados.compania, r_pla_empleados.codigo_empleado, 
                    ''1'',''119'', ''A'', ''VIATICOS POR ALIMENTACION Y TRANSPORTE'', 
                    Mes(r_pla_periodos.dia_d_pago), 6.50, r_pla_marcaciones.id_pla_proyectos,
                    r_pla_empleados.departamento);
            end if;
    end if;
    
    return 1;
end;
' language plpgsql;



create function f_pla_ajustar_salida_seceyco(int4, char(7), int4) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_turnos record;
    r_pla_certificados_medico record;
    r_pla_permisos record;
    r_pla_marcaciones_2 record;
    r_pla_desglose_regulares record;
    r_pla_periodos record;
    r_work record;
    ldt_entrada_turno timestamp;
    ldt_salida_turno timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    li_minutos_regulares int4;
    ldc_tiempo_minimo_de_descanso decimal;
    ldc_descanso decimal;
    i integer;
    li_id_marcacion_anterior int4;
    li_minutos_trabajados int4;
    li_minutos_faltantes int4;
    li_hora int4;
    ld_fecha date;
    lt_hora time;
begin
    return 0;
    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    
    
    select into r_pla_periodos * from pla_periodos
    where id = ai_id_periodos;
    if not found then
        return 0;
    end if;
    
    if r_pla_periodos.status = ''C'' then
        return 0;
    end if;


    
    li_id_marcacion_anterior    =   0;
    for r_pla_marcaciones in select pla_marcaciones.* 
                                from pla_tarjeta_tiempo, pla_marcaciones
                                where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
                                and pla_tarjeta_tiempo.compania = ai_cia
                                and pla_marcaciones.id_pla_proyectos in (2882, 1838, 2012)
                                and pla_tarjeta_tiempo.codigo_empleado = as_codigo_empleado
                                and pla_marcaciones.turno is not null
                                and pla_tarjeta_tiempo.id_periodos = ai_id_periodos
                                and pla_marcaciones.status in (''R'')
                                order by pla_marcaciones.entrada
    loop
    
        li_hora = extract(hour from r_pla_marcaciones.entrada);
        if li_hora < 7 then
            update pla_marcaciones
            set turno = ''3''
            where id = r_pla_marcaciones.id;
            
            select into r_pla_turnos *
            from pla_turnos
            where compania = ai_cia
            and turno = ''3'';
        else
            select into r_pla_turnos *
            from pla_turnos
            where compania = ai_cia
            and turno = r_pla_marcaciones.turno;
        end if;

        ld_fecha    =   r_pla_marcaciones.entrada;
        lt_hora     =   r_pla_turnos.hora_inicio;
        r_pla_marcaciones.entrada = f_timestamp(ld_fecha, lt_hora);

        li_minutos_trabajados   =   f_intervalo(r_pla_marcaciones.entrada, r_pla_marcaciones.salida) 
                                    -   f_intervalo(r_pla_marcaciones.entrada_descanso, r_pla_marcaciones.salida_descanso);

    
        if r_pla_marcaciones.id_pla_proyectos = 2882 or
            r_pla_marcaciones.id_pla_proyectos = 2012 then
            if li_minutos_trabajados <= 900 then
                li_minutos_faltantes = 900 - li_minutos_trabajados;
                r_pla_marcaciones.salida = r_pla_marcaciones.salida + cast((li_minutos_faltantes || ''minutes'') as interval);
                update pla_marcaciones
                set salida = r_pla_marcaciones.salida
                where id = r_pla_marcaciones.id;                                
            end if;                
        else
            if li_minutos_trabajados <= 840 then
                li_minutos_faltantes = 840 - li_minutos_trabajados;
                r_pla_marcaciones.salida = r_pla_marcaciones.salida + cast((li_minutos_faltantes || ''minutes'') as interval);
                update pla_marcaciones
                set salida = r_pla_marcaciones.salida
                where id = r_pla_marcaciones.id;                                
            end if;                
        end if;
        
        
    end loop;


    return 1;
end;
' language plpgsql;


create function f_pla_horas_seceyco(int4, char(7), int4) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_turnos record;
    r_pla_certificados_medico record;
    r_pla_permisos record;
    r_pla_marcaciones_2 record;
    r_pla_desglose_regulares record;
    r_pla_periodos record;
    r_work record;
    r_pla_incremento record;
    r_pla_horas record;
    ldt_entrada_turno timestamp;
    ldt_salida_turno timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    li_minutos_regulares int4;
    ldc_tiempo_minimo_de_descanso decimal;
    ldc_descanso decimal;
    i integer;
    li_count integer;
    li_id_marcacion_anterior int4;
    li_minutos_ampliacion int4;
    li_minutos_transporte int4;
    li_minutos_trabajados int4;
    li_work int4;
    lc_tipo_de_hora_incremento char(2);
begin
    for r_pla_marcaciones in select pla_marcaciones.*, pla_proyectos.proyecto, pla_empleados.tasa_por_hora,
                                pla_empleados.cargo
                                from pla_tarjeta_tiempo, pla_marcaciones, pla_proyectos, pla_empleados
                                where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
                                and pla_marcaciones.id_pla_proyectos = pla_proyectos.id
                                and pla_tarjeta_tiempo.compania = pla_empleados.compania
                                and pla_tarjeta_tiempo.codigo_empleado = pla_empleados.codigo_empleado
                                and pla_tarjeta_tiempo.compania = ai_cia
                                and pla_tarjeta_tiempo.codigo_empleado = as_codigo_empleado
                                and pla_tarjeta_tiempo.id_periodos = ai_id_periodos
                                and pla_proyectos.proyecto in (''GUPCA'',''GUPCP'',''PA'',''PLAZA-ESTE'')
                                order by pla_marcaciones.entrada
    loop

        if Date(r_pla_marcaciones.entrada) >= ''2015-01-01'' then
            lc_tipo_de_hora_incremento = ''51'';
        else
            lc_tipo_de_hora_incremento = ''51'';
        end if;
        
        li_count = 0;
        li_minutos_trabajados = 0;
        
        select into r_pla_incremento *
        from pla_incremento
        where id_pla_proyectos = r_pla_marcaciones.id_pla_proyectos
        and id_pla_cargos = r_pla_marcaciones.cargo;
        if not found then
            continue;
        end if;

        select into li_count count(*)
        from pla_horas
        where id_marcaciones = r_pla_marcaciones.id;
        if li_count is null then
            li_count = 0;
        end if;


        select into li_minutos_trabajados sum(minutos)
        from pla_horas
        where id_marcaciones = r_pla_marcaciones.id;
        if li_minutos_trabajados is null then
            li_minutos_trabajados = 0;
        end if;

        if li_count = 1 then
            select into r_pla_horas *
            from pla_horas
            where id_marcaciones = r_pla_marcaciones.id;
            
            delete from pla_horas
            where id_marcaciones = r_pla_marcaciones.id;
            
            if r_pla_marcaciones.proyecto = ''GUPCP'' then
                li_minutos_ampliacion   =   r_pla_horas.minutos - 120;
            else
                li_minutos_ampliacion   =   r_pla_horas.minutos - 180;
            end if;

            insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                tasa_por_minuto, aplicar, acumula, forma_de_registro, minutos_ampliacion)
            values (r_pla_marcaciones.id, lc_tipo_de_hora_incremento, li_minutos_ampliacion, 
                r_pla_marcaciones.tasa_por_hora/60*r_pla_incremento.recargo, ''N'', ''N'', ''A'', li_minutos_ampliacion);


            insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                tasa_por_minuto, aplicar, acumula, forma_de_registro)
            values (r_pla_marcaciones.id, r_pla_horas.tipo_de_hora, r_pla_horas.minutos - li_minutos_ampliacion, 
                r_pla_marcaciones.tasa_por_hora/60, ''N'', ''N'', ''A'');
                
        else

            if r_pla_marcaciones.proyecto = ''GUPCP'' then
                li_minutos_transporte   =   60;
            else
                li_minutos_transporte   =   90;
            end if;

            select into r_pla_horas *
            from pla_horas
            where id_marcaciones = r_pla_marcaciones.id
            and tipo_de_hora in (''00'');
            if found then

                li_minutos_ampliacion   =   r_pla_horas.minutos - li_minutos_transporte;

            
                delete from pla_horas
                where id_marcaciones = r_pla_marcaciones.id
                and tipo_de_hora in (''00'',lc_tipo_de_hora_incremento);
            
/*
                if r_pla_marcaciones.proyecto = ''GUPCP'' then
                    li_minutos_ampliacion   =   r_pla_horas.minutos - 60;
                else
                    li_minutos_ampliacion   =   r_pla_horas.minutos - 90;
                end if;
*/                

                insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                    tasa_por_minuto, aplicar, acumula, forma_de_registro)
                values (r_pla_marcaciones.id, r_pla_horas.tipo_de_hora, r_pla_horas.minutos - li_minutos_ampliacion, 
                    r_pla_marcaciones.tasa_por_hora/60, ''N'', ''N'', ''A'');

                insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                    tasa_por_minuto, aplicar, acumula, forma_de_registro, minutos_ampliacion)
                values (r_pla_marcaciones.id, lc_tipo_de_hora_incremento, li_minutos_ampliacion, 
                    r_pla_marcaciones.tasa_por_hora/60*r_pla_incremento.recargo, ''N'', ''N'', ''A'', li_minutos_ampliacion);
            end if;                

            
            for r_pla_horas in select * from pla_horas, pla_tipos_de_horas
                                where pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
                                and pla_horas.id_marcaciones = r_pla_marcaciones.id
                                and pla_tipos_de_horas.recargo > 1
                                order by pla_tipos_de_horas.recargo

            loop
                update pla_horas
                set tasa_por_minuto = tasa_por_minuto * r_pla_incremento.recargo
                where id = r_pla_horas.id;
            end loop;
            
/*            
-- para el tema del sobre tiempo.
            li_work = 0;
            select sum(minutos) into li_work
            from pla_horas, pla_tipos_de_horas
            where pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
            and pla_horas.id_marcaciones = r_pla_marcaciones.id
            and pla_horas.minutos_ampliacion is null
            and pla_tipos_de_horas.recargo > 1;
            if li_work is null then
                li_work =   0;
            end if;
            
            if li_work > 0 then
                li_minutos_ampliacion = li_work - li_minutos_transporte;
            end if;
            
            if li_minutos_ampliacion > 0 then
                li_work =   0;
                for r_pla_horas in select * from pla_horas, pla_tipos_de_horas
                                    where pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
                                    and pla_horas.id_marcaciones = r_pla_marcaciones.id
                                    and pla_horas.minutos_ampliacion is null
                                    and pla_tipos_de_horas.recargo > 1
                                    order by pla_tipos_de_horas.recargo
                loop
                    if li_minutos_ampliacion <= 0 then
                        exit;
                    end if;
                    
                    if li_minutos_ampliacion > r_pla_horas.minutos then
                        delete from pla_horas
                        where id_marcaciones = r_pla_marcaciones.id
                        and tipo_de_hora not in (''00'',''51'')
                        and tipo_de_hora = r_pla_horas.tipo_de_hora;
            
                        insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                            tasa_por_minuto, aplicar, acumula, forma_de_registro, minutos_ampliacion)
                        values (r_pla_marcaciones.id, r_pla_horas.tipo_de_hora, r_pla_horas.minutos, 
                            r_pla_marcaciones.tasa_por_hora/60*r_pla_incremento.recargo, ''N'', ''N'', ''A'', li_minutos_ampliacion);
                        
                        li_minutos_ampliacion = li_minutos_ampliacion - r_pla_horas.minutos;
                    else
                        delete from pla_horas
                        where id_marcaciones = r_pla_marcaciones.id
                        and tipo_de_hora not in (''00'',''51'')
                        and tipo_de_hora = r_pla_horas.tipo_de_hora;

/*            
                        insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                            tasa_por_minuto, aplicar, acumula, forma_de_registro, minutos_ampliacion)
                        values (r_pla_horas.id_marcaciones, ''00'', li_minutos_ampliacion, 
                            r_pla_marcaciones.tasa_por_hora/60*r_pla_incremento.recargo, ''N'', ''N'', ''A'', li_minutos_ampliacion);
*/

                        if r_pla_horas.minutos > li_minutos_ampliacion then
                            insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                                tasa_por_minuto, aplicar, acumula, forma_de_registro)
                            values (r_pla_marcaciones.id, r_pla_horas.tipo_de_hora, r_pla_horas.minutos - li_minutos_ampliacion, 
                                r_pla_marcaciones.tasa_por_hora/60, ''N'', ''N'', ''A'');
                        end if;                
                        exit;                        
                    end if;
                end loop;            
            end if;
*/            
        end if;    
    end loop;

    return 1;
end;
' language plpgsql;


create function f_activa_empleados_en_vacaciones(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_periodos record;
    lc_inactiva_pla_vacaciones char(1);
begin


    select into r_pla_periodos *
    from pla_periodos
    where id = ai_id;
    if not found then
        return 0;
    end if;
    
    if trim(f_pla_parametros(r_pla_periodos.compania, ''inactiva_pla_vacaciones'', ''S'', ''GET'')) <> ''S'' then
        return 0;
    end if;
    
    
    update pla_vacaciones
    set status = ''I''
    where compania = r_pla_periodos.compania
    and status = ''A''
    and pagar_hasta <= r_pla_periodos.desde;
    
    
    return 1;
end;
' language plpgsql;


create function f_pla_horas_anteriores(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_marcaciones_work record;
    r_pla_marcaciones record;
    r_pla_horas record;
    r_pla_periodos record;
    li_retorno int;
begin
    select into r_pla_marcaciones_work * 
    from pla_marcaciones, pla_tarjeta_tiempo
    where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
    and pla_marcaciones.id = ai_id;
    if not found then
        return 0;
    end if;
    
    select into r_pla_periodos *
    from pla_periodos, pla_tarjeta_tiempo
    where pla_periodos.id = pla_tarjeta_tiempo.id_periodos
    and pla_tarjeta_tiempo.id = r_pla_marcaciones_work.id_tarjeta_de_tiempo;
    if not found then
        return 0;
    end if;
    
                
-- aqui poner una condicion para que solo aplique a empleados de salario fijo.

    if r_pla_marcaciones_work.status = ''F'' 
        or Extract(dow from r_pla_marcaciones_work.entrada) = 0 
        or Extract(dow from r_pla_marcaciones_work.salida) = 0 then
        return 0;
    end if;


    select into r_pla_marcaciones pla_marcaciones.* 
    from pla_tarjeta_tiempo, pla_marcaciones, pla_periodos
    where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
    and pla_periodos.id = pla_tarjeta_tiempo.id_periodos
    and pla_periodos.dia_d_pago < r_pla_periodos.dia_d_pago
    and pla_marcaciones.id <> ai_id
    and f_to_date(pla_marcaciones.entrada) = f_to_date(r_pla_marcaciones_work.entrada)
    and pla_tarjeta_tiempo.compania = r_pla_marcaciones_work.compania
    and pla_tarjeta_tiempo.codigo_empleado = r_pla_marcaciones_work.codigo_empleado;
    if not found then
        return 0;
    end if;
    
    for r_pla_horas in
        select * from pla_horas
        where id_marcaciones = r_pla_marcaciones.id
        order by id
    loop
        li_retorno  =   f_pla_horas(r_pla_marcaciones_work.id, r_pla_horas.tipo_de_hora, 
                            -r_pla_horas.minutos, r_pla_horas.tasa_por_minuto,
                            r_pla_horas.aplicar, r_pla_horas.acumula);
  
        
    end loop;
    return 1;
end;
' language plpgsql;




create function f_primer_pago(int4, char(7), int4) returns decimal as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    ldc_primer_pago decimal;
    r_pla_empleados record;
    r_pla_turnos record;
    r_pla_horarios record;
    r_pla_periodos record;
    ld_hasta date;
    ld_work date;
    ld_desde date;
    li_dow integer;
    ldt_entrada timestamp;
    ldt_salida timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    li_minutos_regulares int4;
    li_dias_trabajados int4;
    ldc_salario decimal;
    ldc_suma decimal;
begin
    ldc_primer_pago = 0;
    
    select into r_pla_periodos * from pla_periodos
    where id = ai_id_periodos;
    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    
    if extract(day from r_pla_empleados.fecha_inicio) = 16 or
        extract(day from r_pla_empleados.fecha_inicio) = 1 then
        return r_pla_empleados.salario_bruto;
    end if;

    if extract(day from r_pla_empleados.fecha_inicio) > 15 then
        ld_hasta = f_ultimo_dia_del_mes(r_pla_empleados.fecha_inicio);
    else
        ld_hasta = to_char(Anio(r_pla_empleados.fecha_inicio),''9999'')||''-''||trim(to_char(Mes(r_pla_empleados.fecha_inicio),''99''))||''-15'';
        if r_pla_periodos.hasta > ld_hasta then
            ld_hasta = r_pla_periodos.hasta;
        end if;
    end if;

        ldc_suma = 0;
        select into ldc_suma sum(monto) from v_pla_horas_valorizadas
        where compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and id_periodos = ai_id_periodos
        and tipo_de_hora = ''00''
        and fecha between r_pla_empleados.fecha_inicio and r_pla_periodos.hasta;
        if not found or ldc_suma is null then
           ldc_suma = 0;
        end if;
        if ldc_suma > r_pla_empleados.salario_bruto then
            ldc_suma =   r_pla_empleados.salario_bruto;
        end if;
        return ldc_suma;

    
    li_dias_trabajados  =   ld_hasta - r_pla_empleados.fecha_inicio;
    
    if li_dias_trabajados >= 10 and r_pla_empleados.tipo_de_planilla = ''2'' then
        if extract(day from r_pla_empleados.fecha_inicio) > 15 then
            ld_desde = to_char(Anio(r_pla_empleados.fecha_inicio),''9999'')||''-''||trim(to_char(Mes(r_pla_empleados.fecha_inicio),''99''))||''-15'';
        else
            ld_desde = to_char(Anio(r_pla_empleados.fecha_inicio),''9999'')||''-''||trim(to_char(Mes(r_pla_empleados.fecha_inicio),''99''))||''-01'';
        end if;

        ld_hasta = r_pla_empleados.fecha_inicio;
        
        while ld_desde < ld_hasta loop
        
            li_dow = extract(dow from ld_desde);
            select into r_pla_horarios * from pla_horarios
            where compania = ai_cia
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and dia = li_dow;
            if found then
                select into r_pla_turnos * from pla_turnos
                where compania = ai_cia
                and turno = r_pla_horarios.turno;
                ldt_entrada = to_timestamp(f_concat_fecha_hora(ld_desde, r_pla_turnos.hora_inicio),''YYYY/MM/DD HH24:MI'');
                if r_pla_turnos.hora_salida < r_pla_turnos.hora_inicio then
                    ldt_salida = to_timestamp(f_concat_fecha_hora(ld_desde+1, r_pla_turnos.hora_salida),''YYYY/MM/DD HH24:MI'');
                else
                    ldt_salida = to_timestamp(f_concat_fecha_hora(ld_desde, r_pla_turnos.hora_salida),''YYYY/MM/DD HH24:MI'');
                end if;
                if r_pla_turnos.hora_inicio_descanso is null then
                    ldt_entrada_descanso = null;
                else
                    ldt_entrada_descanso = to_timestamp(f_concat_fecha_hora(ld_desde, r_pla_turnos.hora_inicio_descanso),''YYYY/MM/DD HH24:MI'');
                end if;

                if r_pla_turnos.hora_salida_descanso is null then
                    ldt_salida_descanso = null;
                else
                    ldt_salida_descanso = to_timestamp(f_concat_fecha_hora(ld_desde, r_pla_turnos.hora_salida_descanso),''YYYY/MM/DD HH24:MI'');
                end if;

                li_minutos_regulares = f_intervalo(ldt_entrada,ldt_salida)
                                        - f_intervalo(ldt_entrada_descanso, ldt_salida_descanso);

                ldc_primer_pago = ldc_primer_pago + (li_minutos_regulares/60*r_pla_empleados.tasa_por_hora);
                
            end if;
            ld_desde = ld_desde + 1;
        end loop;

        ldc_salario   =   r_pla_empleados.salario_bruto - ldc_primer_pago;
        return ldc_salario;
    end if;
    
    if extract(day from r_pla_empleados.fecha_inicio) > 15 then
        ld_hasta = f_ultimo_dia_del_mes(r_pla_empleados.fecha_inicio);
    else
        ld_hasta = to_char(Anio(r_pla_empleados.fecha_inicio),''9999'')||''-''||trim(to_char(Mes(r_pla_empleados.fecha_inicio),''99''))||''-15'';
    end if;

    ld_work = r_pla_empleados.fecha_inicio;
    while ld_work <= ld_hasta loop
        li_dow = extract(dow from ld_work);
        select into r_pla_horarios * from pla_horarios
        where compania = ai_cia
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and dia = li_dow;
        if found then
            select into r_pla_turnos * from pla_turnos
            where compania = ai_cia
            and turno = r_pla_horarios.turno;
        
            ldt_entrada = to_timestamp(f_concat_fecha_hora(ld_work, r_pla_turnos.hora_inicio),''YYYY/MM/DD HH24:MI'');
            if r_pla_turnos.hora_salida < r_pla_turnos.hora_inicio then
                ldt_salida = to_timestamp(f_concat_fecha_hora(ld_work+1, r_pla_turnos.hora_salida),''YYYY/MM/DD HH24:MI'');
            else
                ldt_salida = to_timestamp(f_concat_fecha_hora(ld_work, r_pla_turnos.hora_salida),''YYYY/MM/DD HH24:MI'');
            end if;
            if r_pla_turnos.hora_inicio_descanso is null then
                ldt_entrada_descanso = null;
            else
                ldt_entrada_descanso = to_timestamp(f_concat_fecha_hora(ld_work, r_pla_turnos.hora_inicio_descanso),''YYYY/MM/DD HH24:MI'');
            end if;

            if r_pla_turnos.hora_salida_descanso is null then
                ldt_salida_descanso = null;
            else
                ldt_salida_descanso = to_timestamp(f_concat_fecha_hora(ld_work, r_pla_turnos.hora_salida_descanso),''YYYY/MM/DD HH24:MI'');
            end if;

            li_minutos_regulares = f_intervalo(ldt_entrada,ldt_salida)
                                    - f_intervalo(ldt_entrada_descanso, ldt_salida_descanso);

            ldc_primer_pago = ldc_primer_pago + (li_minutos_regulares/60*r_pla_empleados.tasa_por_hora);
        end if;
        ld_work = ld_work + 1;
    end loop;
    
    if ldc_primer_pago >= r_pla_empleados.salario_bruto then
        return r_pla_empleados.salario_bruto;
    else
        return ldc_primer_pago;
    end if;
end;
' language plpgsql;



create function f_pla_bonos_de_produccion(int4, char(7), int4) returns int4 as '
declare
    ai_compania alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    r_pla_reclamos record;
    r_pla_periodos record;
    r_pla_empleados record;
    r_pla_cargos record;
    r_work record;
    r_pla_dinero record;
    ldc_cantidad decimal;
begin
    select into r_pla_periodos * from pla_periodos
    where id = ai_id_periodos;
    if not found then
        return 0;
    end if;
    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_compania
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    select into r_pla_cargos * from pla_cargos
    where id = r_pla_empleados.cargo
    and compania = ai_compania;
    if not found then
        return 0;
    end if;
    
    ldc_cantidad = 0;
    select sum(cantidad) into ldc_cantidad
    from pla_bonos_de_produccion
    where compania = ai_compania
    and codigo_empleado = as_codigo_empleado
    and year = r_pla_periodos.year
    and numero_planilla = r_pla_periodos.numero_planilla;
    if ldc_cantidad is null then
        ldc_cantidad = 0;
    end if;
    
    if ldc_cantidad <> 0 then
        for r_pla_dinero in
            select * from pla_dinero
            where compania = ai_compania
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''1''
            and concepto = ''140''
            and id_periodos = r_pla_periodos.id
        loop
            return 0;
        end loop;

        insert into pla_dinero(id_periodos, compania, codigo_empleado, tipo_de_calculo,
            concepto, forma_de_registro, descripcion, mes, monto)
        values (r_pla_periodos.id, ai_compania, as_codigo_empleado, ''1'',
            ''140'', ''A'', ''BONO POR METRAJE'', Mes(r_pla_periodos.dia_d_pago),
            (ldc_cantidad*r_pla_cargos.monto));
    
    end if;


    return 1;
end;
' language plpgsql;




create function f_tipo_de_hora(int4, char(7), date, int4) returns char(2) as '
declare
    ai_compania alias for $1;
    as_codigo_empleado alias for $2;
    ad_fecha alias for $3;
    ai_id_pla_marcaciones alias for $4;
    lc_tipo_de_hora_domingo_fijo char(2);
    lc_tipo_de_hora_domingo_hora char(2);
    r_pla_empleados record;
    r_pla_dias_feriados record;
    r_pla_marcaciones record;
begin

    select into r_pla_empleados * from pla_empleados
    where compania = ai_compania
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;

    lc_tipo_de_hora_domingo_fijo    =   f_pla_parametros(ai_compania, ''tipo_de_hora_domingo_fijo'', ''26'', ''GET'');
    lc_tipo_de_hora_domingo_hora    =   f_pla_parametros(ai_compania, ''tipo_de_hora_domingo_hora'', ''91'', ''GET'');
    
    if ai_compania = 745 then
        lc_tipo_de_hora_domingo_hora    =   ''28'';
    end if;

    select into r_pla_marcaciones * from pla_marcaciones
    where id = ai_id_pla_marcaciones;
    if found then
        if r_pla_marcaciones.status = ''C'' then
            if extract(dow from ad_fecha) = 0 then
                if r_pla_empleados.tipo_de_salario = ''F'' then
                    return lc_tipo_de_hora_domingo_fijo;
                else
                    return lc_tipo_de_hora_domingo_hora;
                end if;
            else
                return ''00'';
            end if;
        end if;
    else
        Raise Exception ''No existe registro en pla_marcaciones'';
    end if;

    select into r_pla_dias_feriados * from pla_dias_feriados
    where compania = ai_compania
    and fecha = ad_fecha
    and tipo_de_salario = r_pla_empleados.tipo_de_salario;
    if found then
        if r_pla_marcaciones.status = ''I'' then
            return ''00'';
        else
            return r_pla_dias_feriados.tipo_de_hora;
        end if;
    end if;

    if extract(dow from ad_fecha) = 0 then
        if r_pla_empleados.tipo_de_salario = ''F'' then
            return lc_tipo_de_hora_domingo_fijo;
        else
            return lc_tipo_de_hora_domingo_hora;
        end if;
    end if;
    

    return ''00'';
end;
' language plpgsql;




create function f_minutos_certificados_pendientes(int4, char(7), date) returns int4 as '
declare
    ai_compania alias for $1;
    as_codigo_empleado alias for $2;
    ad_fecha alias for $3;
    r_pla_empleados record;
    li_dias int4;
    li_minutos_a_tomar int4;
    li_minutos_pendientes int4;
    li_work int4;
    ld_desde date;
    ld_fecha date;
    lt_time time;
    lts_desde timestamp;
    lts_hasta timestamp;
    lts_fecha_hora timestamp;
    li_minutos_laborados int4;
    li_minutos_pagados int4;
    ldc_anios_laborados decimal;
    ldc_minutos_laborados decimal;
    ldc_minutos_a_tomar decimal;
begin
    li_minutos_a_tomar  =   0;
    li_minutos_pagados  =   0;
    

    select into r_pla_empleados * from pla_empleados
    where compania = ai_compania
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;

    ld_fecha        =   ad_fecha;
    ld_desde        =   f_relative_dmy(''ANIO'',ld_fecha,-2);
    lt_time         =   ''00:00'';
    lts_desde       =   f_timestamp(ld_desde, lt_time);
    lts_hasta       =   f_timestamp(ad_fecha, lt_time);
    lts_fecha_hora  =   f_timestamp(ld_fecha, lt_time);
    
    if ld_desde >= r_pla_empleados.fecha_inicio then
        li_minutos_a_tomar  =   17280;
    else
        ld_desde                = r_pla_empleados.fecha_inicio;
        lt_time                 = ''00:00'';
        lts_desde               = f_timestamp(ld_desde, lt_time);
        li_minutos_laborados    = f_intervalo(lts_desde, f_timestamp(ad_fecha, lt_time));
        ldc_minutos_laborados   = li_minutos_laborados;
        ldc_anios_laborados     = ldc_minutos_laborados / (365*24*60);
        ldc_minutos_a_tomar     = ldc_anios_laborados * 17280 / 2;
        li_minutos_a_tomar      = Round(ldc_minutos_a_tomar,0);
    end if;

    li_minutos_pagados  =   0;
    
    li_work = 0;
    select into li_work sum(minutos)
    from pla_certificados_medico
    where year = 0
    and numero_planilla = 0
    and compania = ai_compania
    and codigo_empleado = as_codigo_empleado
    and fecha between ld_desde and ad_fecha
    and pagado = ''S'';
    if li_work is null then
        li_work = 0;
    end if;
    
    select into li_minutos_pagados sum(pla_horas.minutos)
    from pla_horas, pla_marcaciones, pla_tarjeta_tiempo
    where pla_marcaciones.id = pla_horas.id_marcaciones 
    and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
    and pla_horas.tipo_de_hora = ''30'' 
    and pla_tarjeta_tiempo.codigo_empleado = as_codigo_empleado
    and pla_tarjeta_tiempo.compania = ai_compania
    and cast(pla_marcaciones.entrada as date) between ld_desde and ad_fecha;
    
    if li_minutos_pagados is null then
        li_minutos_pagados = 0;
    end if;
    
    li_minutos_pagados = li_minutos_pagados + li_work;

    return li_minutos_a_tomar - li_minutos_pagados;    
end;
' language plpgsql;


create function f_planilla_regular_empleado(int4, char(7)) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    r_pla_tipos_de_planilla record;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_dinero record;
    i integer;
    ld_work date;
    ld_ultima_liquidacion date;
    lc_error_si_hay_empleado_liquidado char(1);
begin

    lc_error_si_hay_empleado_liquidado =   Trim(f_pla_parametros(ai_cia, ''error_si_hay_empleado_liquidado'', ''S'', ''GET''));

    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;

    ld_ultima_liquidacion = null;            
    select into ld_ultima_liquidacion Max(fecha)
    from pla_liquidacion
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    if ld_ultima_liquidacion is not null then
        if r_pla_empleados.fecha_inicio <= ld_ultima_liquidacion then
                Raise Exception ''Empleado % Fecha de Inicio % Debe ser posterior a ultima liquidacion %'',as_codigo_empleado, r_pla_empleados.fecha_inicio, ld_ultima_liquidacion;
        end if;
    end if;

    if trim(lc_error_si_hay_empleado_liquidado) = ''S'' and r_pla_empleados.fecha_terminacion_real is not null then
        Raise Exception ''Empleado % esta liquidado...Ponerlo Inactivo'', r_pla_empleados.codigo_empleado;
    end if;
    
    select into r_pla_tipos_de_planilla * from pla_tipos_de_planilla
    where compania = ai_cia
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla;
    
    select into r_pla_periodos * from pla_periodos
    where compania = ai_cia
    and tipo_de_planilla = r_pla_tipos_de_planilla.tipo_de_planilla
    and numero_planilla = r_pla_tipos_de_planilla.planilla_actual
    and status = ''A'';
    if not found then
        return 0;
    else
        if r_pla_periodos.status = ''C'' then
            return 0;
        end if;
    end if;

    for r_pla_dinero in 
        select * from pla_dinero
        where id_periodos = r_pla_periodos.id
        and compania = r_pla_periodos.compania
        and codigo_empleado = as_codigo_empleado
        and tipo_de_calculo = ''1''
        and id_pla_cheques_1 is not null
    loop
        return 0;
    end loop;

/*
    delete from pla_horas using pla_marcaciones, pla_tarjeta_tiempo, pla_empleados
    where pla_tarjeta_tiempo.compania = pla_empleados.compania
    and pla_tarjeta_tiempo.codigo_empleado = pla_empleados.codigo_empleado
    and pla_empleados.fecha_terminacion_real is not null
    and pla_horas.id_marcaciones = pla_marcaciones.id
    and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
    and pla_tarjeta_tiempo.codigo_empleado = as_codigo_empleado
    and pla_tarjeta_tiempo.compania = ai_cia
    and pla_tarjeta_tiempo.id_periodos = r_pla_periodos.id
    and pla_horas.forma_de_registro = ''A''
    and not exists
        (select * from pla_dinero
            where pla_dinero.compania = pla_tarjeta_tiempo.compania
            and pla_dinero.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado
            and pla_dinero.tipo_de_calculo = ''1''
            and pla_dinero.id_periodos = r_pla_periodos.id
            and pla_dinero.id_pla_cheques_1 is not null);
    
    delete from pla_dinero 
    using pla_empleados
    where pla_dinero.compania = pla_empleados.compania
    and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
    and pla_empleados.fecha_terminacion_real is not null
    and pla_dinero.id_periodos = r_pla_periodos.id
    and pla_dinero.forma_de_registro = ''A''
    and pla_dinero.compania = ai_cia
    and pla_dinero.tipo_de_calculo = ''1''
    and pla_dinero.id_pla_cheques_1 is null
    and pla_dinero.codigo_empleado = as_codigo_empleado;
*/    


    delete from pla_marcaciones
    using pla_tarjeta_tiempo, pla_periodos, pla_vacaciones
    where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
    and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
    and pla_vacaciones.compania = pla_tarjeta_tiempo.compania
    and pla_vacaciones.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado
    and pla_vacaciones.codigo_empleado = trim(as_codigo_empleado)
    and pla_vacaciones.status = ''A''
    and pla_periodos.id = r_pla_periodos.id
    and pla_periodos.compania = ai_cia
    and f_to_date(pla_marcaciones.entrada) between pla_vacaciones.pagar_desde and  pla_vacaciones.pagar_hasta;

    delete from pla_marcaciones 
    using pla_tarjeta_tiempo, pla_empleados
    where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
    and pla_tarjeta_tiempo.compania = pla_empleados.compania
    and pla_tarjeta_tiempo.codigo_empleado = pla_empleados.codigo_empleado
    and pla_tarjeta_tiempo.compania = ai_cia
    and pla_empleados.fecha_terminacion_real is not null
    and pla_empleados.codigo_empleado = r_pla_empleados.codigo_empleado
    and pla_tarjeta_tiempo.id_periodos = r_pla_periodos.id
    and f_to_date(pla_marcaciones.entrada) > pla_empleados.fecha_terminacion_real;

    if ai_cia = 1341 or ai_cia = 1353 then
        delete from pla_dinero
        where compania = ai_cia
        and trim(codigo_empleado) = Trim(r_pla_empleados.codigo_empleado)
        and id_periodos = r_pla_periodos.id
        and tipo_de_calculo = ''1'' 
        and concepto = ''119''
        and forma_de_registro = ''A'';
    end if;

    if ai_cia = 1046 then
        i = f_pla_ajustar_salida_seceyco(ai_cia, r_pla_empleados.codigo_empleado, r_pla_periodos.id);
    end if;

    if ai_cia = 1360 then
        i = f_pla_reasignacion_turno(ai_cia, r_pla_empleados.codigo_empleado, r_pla_periodos.id);
    end if;
    
    i = f_pla_horas(ai_cia, r_pla_empleados.codigo_empleado, r_pla_periodos.id);
    i = f_pla_dinero(ai_cia, r_pla_empleados.codigo_empleado, r_pla_periodos.id);


    return 1;
end;
' language plpgsql;


create function f_pla_primer_salario(int4, char(7), int4) returns decimal as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    r_pla_empleados record;
    r_pla_periodos record;
    ldc_salario decimal;
    ldc_suma decimal;
    li_dias_trabajados integer;
    li_dias_no_trabajados integer;
    ld_work date;
begin
    ldc_salario             =   0;
    ldc_suma                =   0;
    li_dias_trabajados      =   0;
    li_dias_no_trabajados   =   0;
    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    
    select into r_pla_periodos * from pla_periodos
    where id = ai_id_periodos;
    
    li_dias_trabajados  =   r_pla_periodos.hasta - r_pla_empleados.fecha_inicio;
    
    if li_dias_trabajados >= 10 and r_pla_empleados.tipo_de_planilla = ''2'' then
        ld_work                 =   r_pla_periodos.desde;
        li_dias_no_trabajados   =   0;
        while ld_work < r_pla_empleados.fecha_inicio loop
            if extract(dow from ld_work) <> 0 then
                li_dias_no_trabajados   =   li_dias_no_trabajados + 1;
            end if;
            ld_work =   ld_work + 1;
        end loop;
        ldc_salario   =   r_pla_empleados.salario_bruto - (r_pla_empleados.tasa_por_hora*8*li_dias_no_trabajados);
        if r_pla_empleados.compania = 893 and
            (Extract(Day from r_pla_empleados.fecha_inicio) = 1 or
             Extract(Day from r_pla_empleados.fecha_inicio) = 16) then
            ldc_salario   =   r_pla_empleados.salario_bruto;
        end if;
    else
        select into ldc_suma sum(monto) from v_pla_horas_valorizadas
        where compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and id_periodos = ai_id_periodos
        and tipo_de_hora = ''00''
        and fecha >= r_pla_empleados.fecha_inicio;
        if not found or ldc_suma is null then
            ldc_suma = 0;
        else
            if ldc_suma > r_pla_empleados.salario_bruto then
                ldc_salario =   r_pla_empleados.salario_bruto;
            else
                ldc_salario =   ldc_suma;
            end if;
        end if;
    end if;
    
    return ldc_salario;
end;
' language plpgsql;



create function f_pla_liquida_semana(int4, char(7), int4) returns integer as '
declare
    ai_compania alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    r_pla_periodos record;
    r_pla_work record;
    r_pla_conceptos record;
    r_pla_empleados record;
    r_pla_dinero record;
    r_work record;
    ldc_acum decimal;
    ldc_vacacion decimal;
    ldc_xiii decimal;
    i int4;
    li_id_pla_proyectos int4;
    li_mes integer;
begin

    select into r_pla_periodos *
    from pla_periodos
    where id = ai_id_periodos;
    if not found then
        return 0;
    end if;
    
    li_mes      =   Mes(r_pla_periodos.dia_d_pago);
    
    ldc_acum    =   0;
    for r_work in
        select pla_dinero.id_pla_proyectos, sum(v_pla_acumulados.monto) as monto
        from v_pla_acumulados, pla_dinero
        where v_pla_acumulados.id = pla_dinero.id
        and v_pla_acumulados.compania = ai_compania
        and v_pla_acumulados.codigo_empleado = as_codigo_empleado
        and pla_dinero.id_periodos = ai_id_periodos
        and concepto_calcula = ''108''
        group by 1
        order by 1
    loop
        ldc_vacacion    =   r_work.monto / 11;
    
        select into r_pla_empleados *
        from pla_empleados
        where compania = ai_compania
        and codigo_empleado = as_codigo_empleado;
    
        i = f_pla_dinero_insert(ai_id_periodos,ai_compania,
                as_codigo_empleado, ''1'', r_pla_empleados.departamento, r_work.id_pla_proyectos, ''108'',
                ''VACACIONES PROPORCIONALES'', li_mes, ldc_vacacion);
            
        for r_pla_work in select v_pla_acumulados.id, v_pla_acumulados.concepto_acumula, 
                            v_pla_acumulados.fecha, v_pla_acumulados.monto
                            from v_pla_acumulados, pla_dinero
                            where v_pla_acumulados.id = pla_dinero.id
                            and v_pla_acumulados.compania = ai_compania
                            and v_pla_acumulados.codigo_empleado = as_codigo_empleado
                            and v_pla_acumulados.concepto_calcula = ''108''
                            and pla_dinero.id_periodos = ai_id_periodos
                            and pla_dinero.id_pla_proyectos = r_work.id_pla_proyectos
                            order by v_pla_acumulados.fecha, v_pla_acumulados.concepto_acumula
        loop
            select into r_pla_conceptos *
            from pla_conceptos
            where concepto = r_pla_work.concepto_acumula;
            
            select into r_pla_dinero *
            from pla_dinero
            where id = i;
            if found then
                insert into pla_acumulados(id_pla_dinero, concepto, fecha, monto)
                values(i, r_pla_work.concepto_acumula, 
                    r_pla_work.fecha, (r_pla_work.monto*r_pla_conceptos.signo));
            end if;
        end loop;
    end loop;
        
    
    for r_work in
        select pla_dinero.id_pla_proyectos, sum(v_pla_acumulados.monto) as monto
        from v_pla_acumulados, pla_dinero
        where v_pla_acumulados.id = pla_dinero.id
        and v_pla_acumulados.compania = ai_compania
        and v_pla_acumulados.codigo_empleado = as_codigo_empleado
        and pla_dinero.id_periodos = ai_id_periodos
        and concepto_calcula = ''109''
        group by 1
        order by 1
    loop
        ldc_vacacion    =   r_work.monto / 12;
    
        i = f_pla_dinero_insert(ai_id_periodos,ai_compania,
                as_codigo_empleado, ''1'', r_pla_empleados.departamento, r_work.id_pla_proyectos, ''109'',
                ''XIII PROPORCIONAL'', li_mes, ldc_vacacion);
    
        for r_pla_work in select v_pla_acumulados.id, v_pla_acumulados.concepto_acumula, 
                            v_pla_acumulados.fecha, v_pla_acumulados.monto
                            from v_pla_acumulados, pla_dinero
                            where v_pla_acumulados.id = pla_dinero.id
                            and v_pla_acumulados.compania = ai_compania
                            and v_pla_acumulados.codigo_empleado = as_codigo_empleado
                            and v_pla_acumulados.concepto_calcula = ''109''
                            and pla_dinero.id_periodos = ai_id_periodos
                            and pla_dinero.id_pla_proyectos = r_work.id_pla_proyectos
                            order by v_pla_acumulados.fecha, v_pla_acumulados.concepto_acumula
        loop
            select into r_pla_conceptos *
            from pla_conceptos
            where concepto = r_pla_work.concepto_acumula;
        
            select into r_pla_dinero *
            from pla_dinero
            where id = i;
            if found then
                insert into pla_acumulados(id_pla_dinero, concepto, fecha, monto)
                values(i, r_pla_work.concepto_acumula, 
                    r_pla_work.fecha, (r_pla_work.monto*r_pla_conceptos.signo));
            end if;
        end loop;
    end loop;
    
    
    for r_work in
        select pla_dinero.id_pla_proyectos, sum(v_pla_acumulados.monto) as monto
        from v_pla_acumulados, pla_dinero
        where v_pla_acumulados.id = pla_dinero.id
        and v_pla_acumulados.compania = ai_compania
        and v_pla_acumulados.codigo_empleado = as_codigo_empleado
        and pla_dinero.id_periodos = ai_id_periodos
        and concepto_calcula = ''220''
        group by 1
        order by 1
    loop
        ldc_vacacion    =   r_work.monto / 52;
    
        i = f_pla_dinero_insert(ai_id_periodos,ai_compania,
                as_codigo_empleado, ''1'', r_pla_empleados.departamento, r_work.id_pla_proyectos, ''220'',
                ''PRIMA DE ANTIGUEDAD'', li_mes, ldc_vacacion);
    
        for r_pla_work in select v_pla_acumulados.id, v_pla_acumulados.concepto_acumula, 
                            v_pla_acumulados.fecha, v_pla_acumulados.monto
                            from v_pla_acumulados, pla_dinero
                            where v_pla_acumulados.id = pla_dinero.id
                            and v_pla_acumulados.compania = ai_compania
                            and v_pla_acumulados.codigo_empleado = as_codigo_empleado
                            and v_pla_acumulados.concepto_calcula = ''220''
                            and pla_dinero.id_periodos = ai_id_periodos
                            and pla_dinero.id_pla_proyectos = r_work.id_pla_proyectos
                            order by v_pla_acumulados.fecha, v_pla_acumulados.concepto_acumula
        loop
            select into r_pla_conceptos *
            from pla_conceptos
            where concepto = r_pla_work.concepto_acumula;

            select into r_pla_dinero *
            from pla_dinero
            where id = i;
            if found then
                insert into pla_acumulados(id_pla_dinero, concepto, fecha, monto)
                values(i, r_pla_work.concepto_acumula, 
                    r_pla_work.fecha, (r_pla_work.monto*r_pla_conceptos.signo));
            end if;
        end loop;
    end loop;    
    
    return 1;
end;
' language plpgsql;


create function f_pla_horas_regulares(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_turnos record;
    r_pla_tarjeta_tiempo record;
    r_pla_dias_feriados record;
    r_pla_horarios record;
    r_pla_certificados_medico record;
    r_pla_periodos record;
    lts_work timestamp;
    lts_comienza_dia timestamp;
    lts_entrada_turno timestamp;
    lts_salida_turno timestamp;
    lts_entrada_descanso timestamp;
    lts_salida_descanso timestamp;
    lts_tolerancia_entrada timestamp;
    lt_comienza_dia time;
    ld_fecha date;
    ld_work date;
    ld_entrada date;
    ld_salida_turno date;
    li_minutos_regulares int4;
    li_minutos_trabajados int4;
    li_minutos_descanso int4;
    li_minutos_adicionales int4;
    li_min_tardanza int4;
    li_min_injustificado int4;
    li_descanso_programado int4;
    ls_tipo_de_hora char(2);
    li_retorno integer;
    li_dow integer;
    li_work integer;
    i integer;
    ldc_tiempo_minimo_de_descanso decimal;
    ldc_work decimal;
    ls_tipo_de_jornada char(1);
    lc_tipo_de_hora_domingo_fijo char(2);
    lc_tipo_de_hora_domingo_hora char(2);
    lc_tipo_de_hora_domingo_sehl char(2);
    lc_calcular_salida_en_horas_laborables char(1);
    lb_salida_antes_de_tiempo boolean;
begin
    lb_salida_antes_de_tiempo       =   false;
    li_minutos_adicionales          =   0;
    lt_comienza_dia                 =   ''00:00'';
    li_minutos_descanso             =   0;
    li_min_tardanza                 =   0;
    li_min_injustificado            =   0;
    li_descanso_programado          =   0;

    
    select into r_pla_marcaciones * from pla_marcaciones
    where id = ai_id;
    

/*    
    delete from pla_horas
    where id_marcaciones = r_pla_marcaciones.id 
    and forma_de_registro = ''A'' and minutos > 0;
*/    
    
    select into r_pla_tarjeta_tiempo * 
    from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    
    select into r_pla_periodos *
    from pla_periodos
    where id = r_pla_tarjeta_tiempo.id_periodos;


    lc_tipo_de_hora_domingo_hora                =   Trim(f_pla_parametros(r_pla_tarjeta_tiempo.compania, ''tipo_de_hora_domingo_hora'', ''91'', ''GET''));
    lc_tipo_de_hora_domingo_fijo                =   Trim(f_pla_parametros(r_pla_tarjeta_tiempo.compania, ''tipo_de_hora_domingo_fijo'', ''26'', ''GET''));
    lc_calcular_salida_en_horas_laborables      =   Trim(f_pla_parametros(r_pla_tarjeta_tiempo.compania, ''calcular_salida_en_horas_laborables'', ''S'', ''GET''));
    
    if r_pla_marcaciones.compania = 745 then
        lc_tipo_de_hora_domingo_hora = ''28'';
    end if;

    
    ldc_tiempo_minimo_de_descanso   =   cast(f_pla_parametros(r_pla_tarjeta_tiempo.compania, ''tiempo_minimo_de_descanso'',''1'',''GET'') as decimal);
    if f_pla_descanso_entre_turno(r_pla_marcaciones.id) < ldc_tiempo_minimo_de_descanso then
        delete from pla_desglose_regulares
        where id_pla_marcaciones = r_pla_marcaciones.id;

        if r_pla_marcaciones.turno is null then
            ls_tipo_de_jornada      =   f_tipo_de_jornada(r_pla_marcaciones.entrada, r_pla_marcaciones.salida);
        else
            select into r_pla_turnos * from pla_turnos
            where compania = r_pla_marcaciones.compania
            and turno = r_pla_marcaciones.turno;
            ls_tipo_de_jornada      =   r_pla_turnos.tipo_de_jornada;
        end if;            

        insert into pla_desglose_regulares(id_pla_marcaciones, regulares, 
            descanso, trabajados, salida_regular, tipo_de_jornada, tardanza, 
            injustificado, permiso, certificado, ausencia)
        values (r_pla_marcaciones.id, 0, 0, 0, r_pla_marcaciones.entrada, ls_tipo_de_jornada, 0, 
            0, 0, 0, 0);

        return 0;
    end if;
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;

    if r_pla_marcaciones.turno is not null and r_pla_marcaciones.status = ''F'' then
        select into r_pla_turnos * from pla_turnos
        where compania = r_pla_marcaciones.compania
        and turno = r_pla_marcaciones.turno;

        li_minutos_trabajados   =   f_intervalo(r_pla_marcaciones.entrada, r_pla_marcaciones.salida) 
                                    -   f_intervalo(r_pla_marcaciones.entrada_descanso, r_pla_marcaciones.salida_descanso);

        if r_pla_turnos.tipo_de_jornada = ''N'' and li_minutos_trabajados < 420 then
            r_pla_marcaciones.turno = null;
/*
            li_retorno  =   f_pla_horas(r_pla_marcaciones.id, ''00'', 120,
                                r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
*/                                
    
        end if;
        
    end if;
    
    li_dow  =   Extract(dow from r_pla_marcaciones.entrada);
    if r_pla_marcaciones.turno is null then
        li_minutos_regulares = 480;
        select into r_pla_horarios * from pla_horarios
        where compania = r_pla_tarjeta_tiempo.compania
        and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
        and dia = li_dow;
        if found then
            select into r_pla_turnos * from pla_turnos
            where compania = r_pla_horarios.compania
            and turno = r_pla_horarios.turno;
            if found then
                if r_pla_turnos.hora_salida < r_pla_turnos.hora_inicio then
                    lts_entrada_turno   = f_timestamp(date(r_pla_marcaciones.entrada),r_pla_turnos.hora_inicio);
                    lts_salida_turno    = f_timestamp((date(r_pla_marcaciones.entrada) + 1),r_pla_turnos.hora_salida);
                else
                    lts_entrada_turno = f_timestamp(date(r_pla_marcaciones.entrada), r_pla_turnos.hora_inicio);
                    lts_salida_turno = f_timestamp(date(r_pla_marcaciones.entrada), r_pla_turnos.hora_salida);
                end if;
                
                if r_pla_turnos.hora_salida_descanso < r_pla_turnos.hora_inicio_descanso then
                    lts_entrada_descanso = f_timestamp(date(r_pla_marcaciones.entrada),r_pla_turnos.hora_inicio_descanso);
                    lts_salida_descanso = f_timestamp((date(r_pla_marcaciones.entrada) + 1),r_pla_turnos.hora_salida_descanso);
                else
                    lts_entrada_descanso = f_timestamp(date(r_pla_marcaciones.entrada),r_pla_turnos.hora_inicio_descanso);
                    lts_salida_descanso = f_timestamp(date(r_pla_marcaciones.entrada),r_pla_turnos.hora_salida_descanso);
                end if;

                li_minutos_regulares    =   f_intervalo(lts_entrada_turno,lts_salida_turno)
                                            - f_intervalo(lts_entrada_descanso, lts_salida_descanso);

                li_minutos_trabajados   =   f_intervalo(r_pla_marcaciones.entrada, r_pla_marcaciones.salida) 
                                            -   f_intervalo(r_pla_marcaciones.entrada_descanso, r_pla_marcaciones.salida_descanso);
                if li_minutos_trabajados < li_minutos_regulares then
                    li_minutos_regulares = li_minutos_trabajados;
                end if;
            end if;
        else
            li_minutos_trabajados   =   f_intervalo(r_pla_marcaciones.entrada, r_pla_marcaciones.salida) 
                                        -   f_intervalo(r_pla_marcaciones.entrada_descanso, r_pla_marcaciones.salida_descanso);
            if li_minutos_trabajados < li_minutos_regulares then
                li_minutos_regulares = li_minutos_trabajados;
            end if;

            if r_pla_empleados.tipo_de_salario = ''F'' and r_pla_empleados.compania = 749 then
                return 0;
            end if;
        end if;
    
        li_minutos_trabajados   =   f_intervalo(r_pla_marcaciones.entrada, r_pla_marcaciones.salida) 
                                    -   f_intervalo(r_pla_marcaciones.entrada_descanso, r_pla_marcaciones.salida_descanso);
        li_minutos_descanso     =   f_intervalo(r_pla_marcaciones.entrada_descanso, r_pla_marcaciones.salida_descanso);
        
        ls_tipo_de_jornada      =   f_tipo_de_jornada(r_pla_marcaciones.entrada, r_pla_marcaciones.salida);

            
        if ls_tipo_de_jornada = ''M'' and li_minutos_regulares < 450 then
            ldc_work                =   480 * li_minutos_regulares / 450;
            li_minutos_adicionales  =   ldc_work - li_minutos_regulares;
        elsif ls_tipo_de_jornada = ''N'' and li_minutos_trabajados >= 420 then
            li_minutos_adicionales  =   60;
            li_minutos_regulares    =   420;
        elsif ls_tipo_de_jornada = ''M'' and li_minutos_trabajados >= 450 then
            li_minutos_adicionales  =   30;
            li_minutos_regulares    =   450;
        end if;
    else
        select into r_pla_turnos * from pla_turnos
        where compania = r_pla_marcaciones.compania
        and turno = r_pla_marcaciones.turno;
        
        if r_pla_turnos.inicio_extras is not null then
            r_pla_turnos.hora_salida = r_pla_turnos.inicio_extras;
        end if;
        
        ls_tipo_de_jornada = r_pla_turnos.tipo_de_jornada;
        
    
        if r_pla_turnos.hora_salida < r_pla_turnos.hora_inicio then
            lts_entrada_turno       =   f_timestamp(date(r_pla_marcaciones.entrada),r_pla_turnos.hora_inicio);
            lts_salida_turno        =   f_timestamp((date(r_pla_marcaciones.entrada) + 1),r_pla_turnos.hora_salida);
        else
            lts_entrada_turno       =   f_timestamp(date(r_pla_marcaciones.entrada), r_pla_turnos.hora_inicio);
            lts_salida_turno        =   f_timestamp(date(r_pla_marcaciones.entrada), r_pla_turnos.hora_salida);
        end if;
        
        if r_pla_turnos.hora_salida_descanso < r_pla_turnos.hora_inicio_descanso then
            lts_entrada_descanso = f_timestamp(date(r_pla_marcaciones.entrada),r_pla_turnos.hora_inicio_descanso);
            lts_salida_descanso = f_timestamp((date(r_pla_marcaciones.entrada) + 1),r_pla_turnos.hora_salida_descanso);
        else
            lts_entrada_descanso = f_timestamp(date(r_pla_marcaciones.entrada),r_pla_turnos.hora_inicio_descanso);
            lts_salida_descanso = f_timestamp(date(r_pla_marcaciones.entrada),r_pla_turnos.hora_salida_descanso);
        end if;
        
        lts_tolerancia_entrada  =   f_timestamp(date(r_pla_marcaciones.entrada),r_pla_turnos.tolerancia_de_entrada);
        
        
        li_min_tardanza         =   f_pla_horas_tardanzas(r_pla_marcaciones.id);

        
        if r_pla_marcaciones.salida < lts_salida_turno 
            and (r_pla_marcaciones.status = ''R'' or r_pla_marcaciones.status = ''F'')
            and lc_calcular_salida_en_horas_laborables = ''S'' then
            li_min_injustificado    =   f_intervalo(r_pla_marcaciones.salida, lts_salida_turno);
            if extract(dow from r_pla_marcaciones.entrada) = 0 then
                lc_tipo_de_hora_domingo_sehl    =   Trim(f_pla_parametros(r_pla_tarjeta_tiempo.compania, ''tipo_de_hora_domingo_sehl'', ''75'', ''GET''));
            else                
                lc_tipo_de_hora_domingo_sehl    =   ''75'';
            end if;
            
            li_retorno              =   f_pla_horas(r_pla_marcaciones.id, lc_tipo_de_hora_domingo_sehl, li_min_injustificado,
                                            r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
            lb_salida_antes_de_tiempo = true;
            ld_fecha    =   f_to_date(r_pla_marcaciones.salida);
            if Trim(f_pla_parametros(r_pla_tarjeta_tiempo.compania, ''tardanza_dia_nacional'', ''N'', ''GET'')) = ''S'' then
                select into r_pla_dias_feriados *
                from pla_dias_feriados
                where compania = r_pla_tarjeta_tiempo.compania
                and tipo_de_salario = r_pla_empleados.tipo_de_salario
                and fecha = ld_fecha;
                if found then
                    li_retorno  =   f_pla_horas(r_pla_marcaciones.id, r_pla_dias_feriados.tipo_de_hora, 
                                        -li_min_injustificado,
                                        r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
                end if;
            end if;
                                            
        end if;
        
        
        li_minutos_trabajados   =   f_intervalo(r_pla_marcaciones.entrada, r_pla_marcaciones.salida) 
                                    -   f_intervalo(r_pla_marcaciones.entrada_descanso, r_pla_marcaciones.salida_descanso);
                                    
        li_minutos_descanso     =   f_intervalo(r_pla_marcaciones.entrada_descanso, r_pla_marcaciones.salida_descanso);
        li_descanso_programado  =   f_intervalo(lts_entrada_descanso, lts_salida_descanso);


        li_minutos_regulares    =   f_intervalo(lts_entrada_turno,lts_salida_turno)
                                    - f_intervalo(lts_entrada_descanso, lts_salida_descanso);

        li_minutos_adicionales = 0;            
        if ls_tipo_de_jornada = ''N'' and li_minutos_trabajados >= 270 then
            li_minutos_adicionales  =   60;
            li_minutos_regulares    =   420;
        elsif ls_tipo_de_jornada = ''M'' and li_minutos_trabajados >= 300 then
            li_minutos_adicionales  =   30;
            li_minutos_regulares    =   450;
        end if;
        
        li_work =   li_descanso_programado - li_minutos_descanso;
        if li_work > 0 then
            lts_salida_turno    =   lts_salida_turno - cast((li_work || ''minutes'') as interval);
        end if;
    end if;

    
    ls_tipo_de_hora = ''00'';
    if extract(dow from r_pla_marcaciones.entrada) = 0 and r_pla_marcaciones.status <> ''I'' then
        if r_pla_empleados.tipo_de_salario = ''F'' then
            ls_tipo_de_hora = lc_tipo_de_hora_domingo_fijo;
        else
            ls_tipo_de_hora = lc_tipo_de_hora_domingo_hora;
        end if;
    end if;
    

    ld_fecha = r_pla_marcaciones.entrada;

    select into r_pla_dias_feriados * from pla_dias_feriados
    where compania = r_pla_marcaciones.compania
    and fecha = ld_fecha
    and tipo_de_salario = r_pla_empleados.tipo_de_salario;
    if found and r_pla_marcaciones.status = ''F'' then
        ls_tipo_de_hora = r_pla_dias_feriados.tipo_de_hora;
    end if;
    
    if r_pla_marcaciones.status = ''I'' then
        ls_tipo_de_hora =   ''00'';
    end if;
    
    select into r_pla_certificados_medico *
    from pla_certificados_medico
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and cast(desde as date) = ld_fecha;
    if found then
        ls_tipo_de_hora =   ''00'';
    end if;

    
    li_work             =   li_minutos_regulares + li_minutos_descanso;
    if r_pla_marcaciones.turno is null then
        lts_salida_turno    =   r_pla_marcaciones.entrada + cast((li_work || ''minutes'') as interval);
    end if;

    if r_pla_marcaciones.compania = 745
        and r_pla_marcaciones.status = ''D'' then
        ls_tipo_de_hora = ''98'';
    end if;


    ld_entrada          =   r_pla_marcaciones.entrada;
    ld_salida_turno     =   lts_salida_turno;
    if ld_salida_turno > ld_entrada then
        lts_comienza_dia    =   to_timestamp(f_concat_fecha_hora(ld_salida_turno, lt_comienza_dia), ''YYYY/MM/DD HH24:MI'');
        li_work             =   f_intervalo(r_pla_marcaciones.entrada, lts_comienza_dia);
  
        li_minutos_descanso =   f_intervalo(r_pla_marcaciones.entrada_descanso, r_pla_marcaciones.salida_descanso);

        if r_pla_marcaciones.entrada_descanso > lts_comienza_dia then
            li_work = li_work;
        else
            li_work = li_work - li_minutos_descanso;
        end if;
        
        
--        li_retorno          =   f_pla_horas(r_pla_marcaciones.id, ls_tipo_de_hora, li_work, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
        li_retorno          =   f_pla_horas(r_pla_marcaciones.id, ls_tipo_de_hora, li_work, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'', r_pla_marcaciones.entrada, lts_comienza_dia);


        
        select into r_pla_dias_feriados * from pla_dias_feriados
        where compania = r_pla_tarjeta_tiempo.compania
        and fecha in (ld_salida_turno)
        and tipo_de_salario = r_pla_empleados.tipo_de_salario;
        if not found then
            if extract(dow from ld_salida_turno) = 0 and r_pla_marcaciones.status <> ''I'' then
                li_work     =   li_minutos_regulares - li_work + li_minutos_adicionales;
                if li_work > 0 then
                    if r_pla_marcaciones.compania = 1193 
                        and Extract(minute from r_pla_marcaciones.salida) = 0 then
--                raise exception ''entre'';

                    else
                        if r_pla_empleados.tipo_de_salario = ''F'' then
                            ls_tipo_de_hora = lc_tipo_de_hora_domingo_fijo;
                        else
                            ls_tipo_de_hora = lc_tipo_de_hora_domingo_hora;
                        end if;
                    end if;                    
                    
                    if r_pla_empleados.compania = 745 or r_pla_empleados.compania = 746 or r_pla_empleados.compania = 747 then
                        ls_tipo_de_hora = ''91'';
                    end if;

                    if r_pla_marcaciones.status = ''I'' or lb_salida_antes_de_tiempo is true then
                        ls_tipo_de_hora = ''00'';
                    end if;                    

                    if r_pla_empleados.tipo_de_salario = ''F'' and r_pla_marcaciones.entrada > r_pla_periodos.hasta then
                        li_retorno  =   f_pla_horas(r_pla_marcaciones.id, ''00'', li_work, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
                    else
                        if f_pla_parametros(r_pla_tarjeta_tiempo.compania, ''suntracs'', ''N'', ''GET'') = ''S'' then                    
                            li_retorno  =   f_pla_horas(r_pla_marcaciones.id, ls_tipo_de_hora, li_work, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'', lts_comienza_dia, lts_salida_turno);
                        else
                            li_retorno  =   f_pla_horas(r_pla_marcaciones.id, ls_tipo_de_hora, li_work, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
                        end if;
                    end if;
/*
            if r_pla_marcaciones.compania = 1288 then
                raise exception ''% % %'', ld_salida_turno, li_work, ls_tipo_de_hora;
            end if;
*/                    
                end if;
            else
            
-- raise exception ''regulares % adicionales %'',li_minutos_regulares, li_minutos_adicionales;
            
                li_work     =   li_minutos_regulares  - li_work + li_minutos_adicionales;
                if li_work > 0 then
                    if f_pla_parametros(r_pla_tarjeta_tiempo.compania, ''suntracs'', ''N'', ''GET'') = ''S'' then                    
                        li_retorno  =   f_pla_horas(r_pla_marcaciones.id, ''00'', li_work, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'', lts_comienza_dia, lts_salida_turno);
                    else
                        li_retorno  =   f_pla_horas(r_pla_marcaciones.id, ''00'', li_work, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
                    end if;
                end if;
            end if;
        else
            if r_pla_marcaciones.status = ''I'' then
                r_pla_dias_feriados.tipo_de_hora = ''00'';
            end if;
            
            li_work     =   li_minutos_regulares  - li_work + li_minutos_adicionales;
            if li_work > 0 then
                if f_pla_parametros(r_pla_tarjeta_tiempo.compania, ''suntracs'', ''N'', ''GET'') = ''S'' then                    
                    li_retorno  =   f_pla_horas(r_pla_marcaciones.id, r_pla_dias_feriados.tipo_de_hora, li_work, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'', lts_comienza_dia, lts_salida_turno);
                else
                    li_retorno  =   f_pla_horas(r_pla_marcaciones.id, r_pla_dias_feriados.tipo_de_hora, li_work, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
                end if;
                
            end if;
        end if;        
    else
        li_work         =   li_minutos_regulares + li_minutos_adicionales;
        if f_pla_parametros(r_pla_tarjeta_tiempo.compania, ''suntracs'', ''N'', ''GET'') = ''S'' then                    
            li_retorno  =   f_pla_horas(r_pla_marcaciones.id, ls_tipo_de_hora, li_work, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'', r_pla_marcaciones.entrada, lts_salida_turno);
        else
            li_retorno  =   f_pla_horas(r_pla_marcaciones.id, ls_tipo_de_hora, li_work, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
        end if;
    end if;

    delete from pla_desglose_regulares
    where id_pla_marcaciones = r_pla_marcaciones.id;
    
    li_minutos_regulares    =   li_minutos_regulares;

       
    if r_pla_marcaciones.status = ''D'' and r_pla_marcaciones.compania <> 745 then
        li_retorno  =   f_pla_horas(r_pla_marcaciones.id, ''96'', li_minutos_regulares+li_minutos_adicionales, 
                            r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');    
    end if;

    insert into pla_desglose_regulares(id_pla_marcaciones, regulares, descanso, 
        trabajados, salida_regular, tipo_de_jornada, tardanza, 
        injustificado, permiso, certificado, ausencia)
    values (r_pla_marcaciones.id, li_minutos_regulares+li_minutos_adicionales, li_minutos_descanso, 
        li_minutos_trabajados, lts_salida_turno, ls_tipo_de_jornada, li_min_tardanza, 
        li_min_injustificado, 0, 0, 0);
        

    if r_pla_marcaciones.compania = 1341 and r_pla_marcaciones.turno is not null then
        if r_pla_marcaciones.turno in (4, 5, 2) then
            li_retorno  =   f_pla_horas(r_pla_marcaciones.id, ''31'', 30, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
        end if;
    end if;
    
    return 1;
end;
' language plpgsql;


create function f_pla_horas_regulares_excedentes(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_tarjeta_tiempo record;
    r_pla_certificados_medico record;
    r_pla_horas record;
    r_pla_desglose_regulares record;
    r_pla_periodos record;
    r_pla_turnos record;
    ldt_entrada_turno timestamp;
    ldt_salida_turno timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    li_minutos_regulares int4;
    li_minutos_certificados_pendientes int4;
    li_minutos_certificados_a_pagar int4;
    li_minutos_adicionales int4;
    li_sum_minutos_regulares int4;
    li_work int4;
    li_min_acum int4;
    li_minutos_diarios int4;
    li_work_acum int4;
    li_suman int4;
    li_minutos_excedentes int4;
    li_retorno integer;
    ls_tipo_de_hora char(2);
    ls_tipo_de_jornada char(1);
begin

    li_minutos_excedentes   =   0;
    li_minutos_regulares    =   0;
    li_minutos_adicionales  =   0;
    
    select into r_pla_marcaciones * from pla_marcaciones
    where id = ai_id;
    if r_pla_marcaciones.status = ''I'' then
        return 0;
    end if;
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    
    select into r_pla_periodos * from pla_periodos
    where id = r_pla_tarjeta_tiempo.id_periodos;
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;
    
    select into r_pla_desglose_regulares * from pla_desglose_regulares
    where id_pla_marcaciones = ai_id;
    
    select into li_minutos_regulares sum(pla_horas.minutos*pla_tipos_de_horas.signo)
    from pla_horas, pla_tipos_de_horas
    where pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
    and pla_tipos_de_horas.tiempo_regular = ''S''
    and pla_horas.id_marcaciones = ai_id;
    if li_minutos_regulares is null then
        li_minutos_regulares = 0;
    end if;
    
    
    li_minutos_excedentes   =   li_minutos_regulares - r_pla_desglose_regulares.regulares;
    if li_minutos_excedentes <= 0 then
        return 0;
    end if;
    
    delete from pla_horas using pla_tipos_de_horas
    where pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
    and pla_tipos_de_horas.tiempo_regular = ''S''
    and pla_horas.id_marcaciones = ai_id
    and pla_horas.forma_de_registro = ''A''
    and pla_tipos_de_horas.signo = -1;
    
    
    li_work_acum            =   0;
    for r_pla_horas in select pla_horas.id, pla_horas.tasa_por_minuto, 
                        pla_horas.tipo_de_hora, 
                        (pla_horas.minutos*pla_tipos_de_horas.signo) as minutos 
                        from pla_horas, pla_tipos_de_horas
                        where pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
                        and pla_tipos_de_horas.tiempo_regular = ''S''
                        and pla_horas.id_marcaciones = ai_id
                        order by pla_tipos_de_horas.signo, pla_tipos_de_horas.tipo_de_hora
    loop
        if li_work_acum + r_pla_horas.minutos < li_minutos_excedentes then
            delete from pla_horas
            where id = r_pla_horas.id
            and forma_de_registro = ''A'';
            li_work = 0;
            li_work_acum = li_work_acum + r_pla_horas.minutos;
        else
            li_work = li_minutos_excedentes - li_work_acum;
            li_work_acum = li_work_acum + li_work;
        end if;
        li_retorno  =   f_pla_horas(ai_id, r_pla_horas.tipo_de_hora, -li_work,
                            r_pla_horas.tasa_por_minuto, ''N'', ''N'');
                            
        if li_work_acum >= li_minutos_excedentes then
            exit;
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;


create function f_pla_salida_en_horas_laborables(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_turnos record;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_tarjeta_tiempo record;
    r_pla_permisos record;
    r_pla_horas record;
    r_pla_tipos_de_permisos record;
    r_pla_periodos record;
    r_pla_tipos_de_horas record;
    ldt_entrada_turno timestamp;
    ldt_salida_turno timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    lts_salida_turno timestamp;
    li_minutos_regulares int4;
    li_minutos_certificados_pendientes int4;
    lc_calcular_salida_en_horas_laborables char(1);
    ls_tipo_de_hora char(2);
    li_minutos_permiso int4;
    li_min_acum int4;
    li_minutos int4;
    li_work int4;
    li_retorno integer;
begin
    select into r_pla_marcaciones * from pla_marcaciones
    where id = ai_id;
    if r_pla_marcaciones.status = ''I'' or r_pla_marcaciones.status = ''C'' or
        r_pla_marcaciones.turno is null then
        return 0;
    end if;
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;

    lc_calcular_salida_en_horas_laborables      =   Trim(f_pla_parametros(r_pla_tarjeta_tiempo.compania, ''calcular_salida_en_horas_laborables'', ''S'', ''GET''));

    ls_tipo_de_hora                             =   Trim(f_pla_parametros(r_pla_tarjeta_tiempo.compania, ''tipo_de_hora_domingo_sehl'', ''75'', ''GET''));

    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;
    
    select into r_pla_periodos * from pla_periodos
    where id = r_pla_tarjeta_tiempo.id_periodos;
    
    if r_pla_marcaciones.turno is null then
        return 0;
    end if;
    
    select into r_pla_turnos * from pla_turnos
    where compania = r_pla_marcaciones.compania
    and turno = r_pla_marcaciones.turno;
    if not found then
        return 0;
    end if;
    
    lts_salida_turno    =   f_timestamp(Date(r_pla_marcaciones.salida),r_pla_turnos.hora_salida);
    
    if r_pla_marcaciones.salida < lts_salida_turno and lc_calcular_salida_en_horas_laborables = ''S'' then
        li_minutos_permiso  =   f_intervalo(r_pla_marcaciones.salida, lts_salida_turno);
        li_retorno          =   f_pla_horas(r_pla_marcaciones.id, ls_tipo_de_hora, 
                                                li_minutos_permiso, 
                                                r_pla_empleados.tasa_por_hora/60, 
                                                ''N'', ''N'');
    end if;
    
    return 1;
end;
' language plpgsql;


create function f_pla_horas_permisos(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_turnos record;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_tarjeta_tiempo record;
    r_pla_permisos record;
    r_pla_horas record;
    r_pla_tipos_de_permisos record;
    r_pla_periodos record;
    r_pla_tipos_de_horas record;
    ldt_entrada_turno timestamp;
    ldt_salida_turno timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    lts_salida_turno timestamp;
    li_minutos_regulares int4;
    li_minutos_certificados_pendientes int4;
    ls_tipo_de_hora char(2);
    li_minutos_permiso int4;
    li_min_acum int4;
    li_minutos int4;
    li_work int4;
    li_retorno integer;
begin
    select into r_pla_marcaciones * from pla_marcaciones
    where id = ai_id;
    if not found then
        return 0;
    end if;
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;
    
    select into r_pla_periodos * from pla_periodos
    where id = r_pla_tarjeta_tiempo.id_periodos;
    
    for r_pla_permisos in select pla_permisos.* from pla_permisos
                            where pla_permisos.compania = r_pla_empleados.compania
                            and pla_permisos.codigo_empleado = r_pla_empleados.codigo_empleado
                            and date(fecha) = date(r_pla_marcaciones.entrada)
                            and year = r_pla_periodos.year
                            and numero_planilla = r_pla_periodos.numero_planilla
    loop
        select into r_pla_tipos_de_permisos * 
        from pla_tipos_de_permisos
        where tipo_de_permiso = r_pla_permisos.tipo_de_permiso;
        li_retorno  =   f_pla_horas(r_pla_marcaciones.id, r_pla_tipos_de_permisos.tipo_de_hora, 
                            r_pla_permisos.minutos,
                            r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
                            
        update pla_desglose_regulares
        set permiso = permiso + r_pla_permisos.minutos
        where id_pla_marcaciones = ai_id;
    end loop;    
    
    return 1;
end;
' language plpgsql;


create function f_pla_crear_periodos(int4, int4) returns integer as '
declare
    ai_compania alias for $1;
    ai_year alias for $2;
    r_pla_periodos record;
    r_pla_tipos_de_planilla record;
    ld_desde date;
    ld_hasta date;
    li_periodo integer;
    li_year integer;
begin
    ld_desde = to_char(ai_year,''9999'')||''-01-01'';
    ld_hasta = ld_desde + 14;
    li_periodo = 1;

    
    for i in 1..24 loop
        select into r_pla_periodos * from pla_periodos
        where compania = ai_compania
        and tipo_de_planilla = ''2''
        and year = ai_year
        and numero_planilla = i;
        if not found then
            insert into pla_periodos (compania, tipo_de_planilla, year, numero_planilla,
                periodo, desde, hasta, dia_d_pago, status)
            values (ai_compania, ''2'', ai_year, i, li_periodo, ld_desde, ld_hasta, 
                ld_hasta, ''C'');
        end if;
        
        if li_periodo = 1 then
            ld_desde = ld_hasta + 1;
            ld_hasta = f_ultimo_dia_del_mes(ld_desde);
            li_periodo = 2;
        else            
            ld_desde = ld_hasta + 1;
            ld_hasta = ld_desde + 14;
            li_periodo = 1;
        end if;
    end loop;
    
    ld_desde = to_char(ai_year,''9999'')||''-01-01'';
    ld_hasta = ld_desde + 6;
    li_periodo = 1;
    
    li_year = ai_year - 1;
    select into r_pla_periodos * from pla_periodos
    where compania = ai_compania
    and tipo_de_planilla = ''1''
    and year = li_year
    and numero_planilla = 52;
    if found then
        ld_desde = r_pla_periodos.hasta + 1;
    end if;
    
    for i in 1..52 loop
        select into r_pla_periodos * from pla_periodos
        where compania = ai_compania
        and tipo_de_planilla = ''1''
        and year = ai_year
        and numero_planilla = i;
        if not found then
            insert into pla_periodos (compania, tipo_de_planilla, year, numero_planilla,
                periodo, desde, hasta, dia_d_pago, status)
            values (ai_compania, ''1'', ai_year, i, li_periodo, ld_desde, ld_hasta, 
                ld_hasta, ''C'');
        end if;
        
        ld_desde = ld_hasta + 1;
        ld_hasta = ld_desde + 6;
    end loop;
    
    select into r_pla_tipos_de_planilla * from pla_tipos_de_planilla
    where compania = ai_compania
    and tipo_de_planilla = ''3'';
    if not found then
        insert into pla_tipos_de_planilla (compania, tipo_de_planilla, descripcion, planilla_actual)
        values (ai_compania, ''3'', ''BISEMANAL'',1);
    end if;
    
    ld_desde = to_char(ai_year,''9999'')||''-01-01'';
    ld_hasta = ld_desde + 13;
    li_periodo = 1;
    li_year = ai_year - 1;
    
    select into r_pla_periodos * from pla_periodos
    where compania = ai_compania
    and tipo_de_planilla = ''3''
    and year = li_year
    and numero_planilla = 26;
    if found then
        ld_desde = r_pla_periodos.hasta + 1;
    end if;
    
    for i in 1..26 loop
        select into r_pla_periodos * from pla_periodos
        where compania = ai_compania
        and tipo_de_planilla = ''3''
        and year = ai_year
        and numero_planilla = i;
        if not found then
            insert into pla_periodos (compania, tipo_de_planilla, year, numero_planilla,
                periodo, desde, hasta, dia_d_pago, status)
            values (ai_compania, ''3'', ai_year, i, li_periodo, ld_desde, ld_hasta, 
                ld_hasta, ''C'');
        end if;
        
        ld_desde = ld_hasta + 1;
        ld_hasta = ld_desde + 13;
    end loop;
    
    
    select into r_pla_tipos_de_planilla * from pla_tipos_de_planilla
    where compania = ai_compania
    and tipo_de_planilla = ''4'';
    if not found then
        insert into pla_tipos_de_planilla (compania, tipo_de_planilla,
            descripcion, planilla_actual)
        values (ai_compania, ''4'', ''MENSUAL'', 1);
    end if;
    
    ld_desde = to_char(ai_year,''9999'')||''-01-01'';
    ld_hasta = f_ultimo_dia_del_mes(ld_desde);
    li_periodo = 1;
    li_year = ai_year - 1;
    
    select into r_pla_periodos * from pla_periodos
    where compania = ai_compania
    and tipo_de_planilla = ''4''
    and year = li_year
    and numero_planilla = 12;
    if found then
        ld_desde = r_pla_periodos.hasta + 1;
        ld_hasta = f_ultimo_dia_del_mes(ld_desde);
    end if;
    
    for i in 1..12 loop
        select into r_pla_periodos * from pla_periodos
        where compania = ai_compania
        and tipo_de_planilla = ''4''
        and year = ai_year
        and numero_planilla = i;
        if not found then
            insert into pla_periodos (compania, tipo_de_planilla, year, numero_planilla,
                periodo, desde, hasta, dia_d_pago, status)
            values (ai_compania, ''4'', ai_year, i, li_periodo, ld_desde, ld_hasta, 
                ld_hasta, ''C'');
        end if;
        
        ld_desde = ld_hasta + 1;
        ld_hasta = f_ultimo_dia_del_mes(ld_desde);
    end loop;
    
    return 1;
end;
' language plpgsql;




create function f_planilla_regular(int4, char(2)) returns integer as '
declare
    ai_cia alias for $1;
    as_tipo_de_planilla alias for $2;
    r_pla_tipos_de_planilla record;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_dinero record;
    i integer;
    lb_procesar boolean;
begin
--    i   =   f_poner_ausencias(ai_cia, as_tipo_de_planilla);
    
    lb_procesar   =   f_valida_fecha(ai_cia, current_date);
    
    select into r_pla_tipos_de_planilla * from pla_tipos_de_planilla
    where compania = ai_cia
    and tipo_de_planilla = as_tipo_de_planilla;
    if not found then
        raise exception ''Tipo de Planilla % No Existe...Verifique'',as_tipo_de_planilla;
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where compania = ai_cia
    and tipo_de_planilla = as_tipo_de_planilla
    and numero_planilla = r_pla_tipos_de_planilla.planilla_actual
    and status = ''A'';
    if not found then
        raise exception ''Numero de Planilla % no Existe'',r_pla_tipos_de_planilla.planilla_actual;
    else
        if r_pla_periodos.status = ''C'' then
            raise exception ''Numero de Planilla % esta Cerrada'',r_pla_tipos_de_planilla.planilla_actual;
        end if;
    end if;

    i   =   f_activa_empleados_en_vacaciones(r_pla_periodos.id);
    
    delete from pla_horas using pla_marcaciones, pla_tarjeta_tiempo
    where pla_horas.id_marcaciones = pla_marcaciones.id
    and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
    and pla_tarjeta_tiempo.id_periodos = r_pla_periodos.id
    and pla_horas.forma_de_registro = ''A''
    and not exists
        (select * from pla_dinero
            where pla_dinero.compania = pla_tarjeta_tiempo.compania
            and pla_dinero.codigo_empleado = pla_tarjeta_tiempo.codigo_empleado
            and pla_dinero.tipo_de_calculo = ''1''
            and pla_dinero.id_periodos = r_pla_periodos.id
            and pla_dinero.id_pla_cheques_1 is not null);
    
    
    
/*    
    delete from pla_dinero using pla_empleados
    where pla_dinero.compania = pla_empleados.compania
    and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
    and pla_empleados.fecha_terminacion_real is not null
    and pla_dinero.id_periodos = r_pla_periodos.id
    and pla_dinero.tipo_de_calculo = ''1''
    and pla_dinero.forma_de_registro = ''A''
    and id_pla_cheques_1 is null;
*/    
        
    for r_pla_empleados in select * from pla_empleados
                            where compania = ai_cia
                            and tipo_de_planilla = as_tipo_de_planilla
                            and fecha_terminacion_real is null
                            and status in (''A'', ''V'')
                            order by codigo_empleado
    loop
        i   =   f_planilla_regular_empleado(r_pla_empleados.compania, r_pla_empleados.codigo_empleado);
    end loop;
    
    
    delete from pla_dinero using pla_periodos, pla_empleados
    where pla_dinero.compania = pla_empleados.compania
    and pla_dinero.codigo_empleado = pla_empleados.codigo_empleado
    and pla_empleados.fecha_terminacion_real is not null
    and pla_dinero.id_periodos = pla_periodos.id
    and pla_dinero.compania = ai_cia
    and pla_dinero.id_pla_cheques_1 is null
    and pla_periodos.status = ''A''
    and pla_dinero.forma_de_registro = ''A''
    and pla_periodos.tipo_de_planilla = as_tipo_de_planilla
    and pla_dinero.id_periodos = r_pla_periodos.id
    and pla_dinero.monto = 0;

    
    delete from pla_horas using pla_marcaciones, pla_tarjeta_tiempo, pla_periodos
    where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
    and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
    and pla_periodos.status = ''A''
    and pla_horas.forma_de_registro = ''A''
    and pla_marcaciones.id = pla_horas.id_marcaciones
    and pla_horas.minutos = 0
    and pla_horas.minutos_implemento = 0
    and pla_periodos.tipo_de_planilla = as_tipo_de_planilla
    and pla_periodos.id = r_pla_periodos.id
    and pla_marcaciones.compania = ai_cia
    and pla_marcaciones.compania not in (1341, 1353);
    
    return 1;
end;
' language plpgsql;


/*
create function f_minutos_certificados_pendientes(int4, char(2), timestamp) returns int4 as '
declare
    ai_compania alias for $1;
    as_codigo_empleado alias for $2;
    ats_fechahora alias for $3;
    r_pla_empleados record;
    li_dias int4;
    li_minutos_a_tomar int4;
    li_minutos_pendientes int4;
    ld_desde date;
    ld_fecha date;
    lt_time time;
    lts_desde timestamp;
    li_minutos_laborados int4;
    li_minutos_pagados int4;
    ldc_anios_laborados decimal;
    ldc_minutos_laborados decimal;
    ldc_minutos_a_tomar decimal;
begin
    return 8640;
    select into r_pla_empleados * from pla_empleados
    where compania = ai_compania
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;
        
    ld_fecha = ats_fechahora;
    ld_desde = f_relative_dmy(''ANIO'',ld_fecha,-2);
    lt_time = ''00:00'';
    lts_desde = f_timestamp(ld_desde, lt_time);

    if ld_desde >= r_pla_empleados.fecha_inicio then
        li_minutos_a_tomar = 17280;
    else
        ld_desde                = r_pla_empleados.fecha_inicio;
        lt_time                 = ''00:00'';
        lts_desde               = f_timestamp(ld_desde, lt_time);
        li_minutos_laborados    = f_intervalo(lts_desde, ats_fechahora);
        ldc_minutos_laborados   = li_minutos_laborados;
        ldc_anios_laborados     = ldc_minutos_laborados / (365*24*60);
        ldc_minutos_a_tomar     = ldc_anios_laborados * 17280 / 2;
        li_minutos_a_tomar      = Round(ldc_minutos_a_tomar,0);
    end if;

    
    li_minutos_pagados = 0;
    
    select into li_minutos_pagados sum(pla_horas.minutos)
    from pla_horas, pla_marcaciones
    where pla_marcaciones.id = pla_horas.id_marcaciones
    and pla_marcaciones.entrada >= lts_desde
    and pla_horas.tipo_de_hora = ''30'';
    
    if li_minutos_pagados is null then
        li_minutos_pagados = 0;
    end if;
    
    
    
    return li_minutos_a_tomar - li_minutos_pagados;    
end;
' language plpgsql;
*/




create function f_pla_dinero(int4, char(7), int4) returns integer as '
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
    ldc_vacacion_pagada decimal;
    i int4;
    li_count int4;
    lb_vacaciones boolean;
    ld_work date;
    ld_desde date;
    lc_pagar_salario_en_vacaciones varchar(10);
    lc_primer_salario_completo varchar(10);
    lvc_descripcion varchar(100);
begin
    lc_pagar_salario_en_vacaciones      =   Trim(f_pla_parametros(ai_cia, ''pagar_salario_en_vacaciones'', ''N'', ''GET''));
    lc_primer_salario_completo          =   Trim(f_pla_parametros(ai_cia, ''primer_salario_completo'', ''N'', ''GET''));

    
    li_count = 0;
    select into li_count count(*)
    from pla_dinero
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and tipo_de_calculo = ''7''
    and id_periodos = ai_id_periodos;
    if li_count is null then
        li_count = 0;
    end if;
    
    if li_count > 0 then
        return 0;
    end if;


    if ai_cia = 1185 then
        delete from pla_dinero
        where compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and forma_de_registro = ''A''
        and concepto not in (''108'')
        and tipo_de_calculo = ''1''
        and id_periodos = ai_id_periodos
        and id_pla_cheques_1 is null;
    else
        if ai_cia = 1341 or ai_cia = 1353 then
            delete from pla_dinero
            where compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and forma_de_registro = ''A''
            and concepto not in (''119'')
            and tipo_de_calculo = ''1''
            and id_periodos = ai_id_periodos
            and id_pla_cheques_1 is null;
        else        
            delete from pla_dinero
            where compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and forma_de_registro = ''A''
            and tipo_de_calculo = ''1''
            and id_periodos = ai_id_periodos
            and id_pla_cheques_1 is null;
        end if;            
    end if;
    
    ld_work = current_date - 5;


    select into r_pla_periodos *
    from pla_periodos
    where id = ai_id_periodos;
    
/*
    select into r_pla_dinero *
    from pla_dinero, pla_periodos
    where pla_dinero.compania = ai_cia
    and pla_dinero.id_periodos = pla_periodos.id
    and codigo_empleado = as_codigo_empleado
    and pla_periodos.dia_d_pago >= r_pla_periodos.desde
    and tipo_de_calculo = ''7''
    and pla_dinero.monto <> 0;
    if found then
        return 0;
    end if;    
*/
    
    for r_pla_dinero in 
        select * from pla_dinero
        where compania = ai_cia
        and id_periodos = ai_id_periodos
        and codigo_empleado = as_codigo_empleado
        and tipo_de_calculo = ''1''
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
    
    i   =   f_pla_bonos_de_produccion(ai_cia, as_codigo_empleado, ai_id_periodos);

    select into r_pla_vacaciones * 
    from pla_vacaciones
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and (r_pla_periodos.desde between pagar_desde and pagar_hasta
    or r_pla_periodos.hasta between pagar_desde and pagar_hasta);
    if found then
        lb_vacaciones = true;
--        ld_desde = r_pla_vacaciones.pagar_hasta+1;
        ld_desde    =   r_pla_periodos.desde;
    else
        lb_vacaciones = false;
        ld_desde = r_pla_empleados.fecha_inicio;
    end if;

    if r_pla_vacaciones.status = ''A'' or r_pla_empleados.status = ''V'' then
        lb_vacaciones = true;
    else
        lb_vacaciones = false;
    end if;

    
    
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

    li_count = 0;
    select into li_count Count(*)
    from v_pla_horas_valorizadas
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and id_periodos = ai_id_periodos
    and id_pla_proyectos in (1838, 2012, 2887, 2882);
    if li_count is null then
        li_count = 0;
    end if;

--    and id_pla_proyectos in (1838, 2012, 2887, 2882);

    if li_count > 0 then
        r_pla_empleados.tipo_de_salario = ''H'';
    end if;

-- raise exception ''entre %'', lb_vacaciones;


    if (r_pla_empleados.tipo_de_salario = ''F'' 
        and extract(day from r_pla_empleados.fecha_inicio) <> 1
        and extract(day from r_pla_empleados.fecha_inicio) <> 16
        and r_pla_empleados.fecha_inicio between r_pla_periodos.desde and r_pla_periodos.dia_d_pago)
        or r_pla_empleados.tipo_de_salario = ''H'' 
        or r_pla_empleados.fecha_terminacion_real is not null 
        or lb_vacaciones then


        if r_pla_empleados.tipo_de_salario = ''F'' and not lb_vacaciones then
--            ld_desde    =   f_primer_dia_del_mes(r_pla_periodos.hasta);
        end if;
        
        for r_v_pla_horas_valorizadas in
            select * from v_pla_horas_valorizadas
            where compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and id_periodos = ai_id_periodos
            and tipo_de_calculo = ''1''
            and fecha >= ld_desde
            order by fecha
        loop

        
            select into r_pla_conceptos * from pla_conceptos
            where concepto = r_v_pla_horas_valorizadas.concepto;

            select into r_pla_dinero * 
            from pla_dinero
            where id_periodos = ai_id_periodos
            and compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''1''
            and concepto = r_v_pla_horas_valorizadas.concepto
            and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos
            and pla_dinero.monto <> 0
            and forma_de_registro = ''M'';
            if found then
                continue;
            end if;

            select into r_pla_dinero * from pla_dinero
            where id_periodos = ai_id_periodos
            and compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''1''
            and forma_de_registro = ''A''
            and id_pla_cheques_1 is null
            and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos
            and concepto = r_v_pla_horas_valorizadas.concepto;
            if found then
                update pla_dinero
                set monto = monto + (r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo)
                where id_periodos = ai_id_periodos
                and compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and tipo_de_calculo = ''1''
                and forma_de_registro = ''A''
                and id_pla_cheques_1 is null
                and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos
                and concepto = r_v_pla_horas_valorizadas.concepto;
            else
                insert into pla_dinero(id_periodos, compania, codigo_empleado,
                    tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                    monto, id_pla_proyectos, id_pla_departamentos)
                values(ai_id_periodos, ai_cia, as_codigo_empleado, ''1'',r_v_pla_horas_valorizadas.concepto,
                    ''A'', r_v_pla_horas_valorizadas.descripcion, Mes(r_pla_periodos.dia_d_pago),
                    r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo,
                    r_v_pla_horas_valorizadas.id_pla_proyectos,
                    r_v_pla_horas_valorizadas.id_pla_departamentos);


/*
            i   =   f_pla_dinero_insert(ai_id_periodos, ai_cia, as_codigo_empleado,
                        ''1'', r_v_pla_horas_valorizadas.concepto,r_v_pla_horas_valorizadas.descripcion, Mes(r_pla_periodos.dia_d_pago),
                        (r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo));
*/
            end if;
        end loop;

        if r_pla_empleados.fecha_inicio between r_pla_periodos.desde and r_pla_periodos.dia_d_pago then
            select into r_pla_dinero * 
            from pla_dinero
            where id_periodos = ai_id_periodos
            and compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''1''
            and forma_de_registro = ''A''
            and id_pla_cheques_1 is null
            and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos
            and concepto = ''03''
            and concepto = r_v_pla_horas_valorizadas.concepto;
            if found then
                if r_pla_dinero.monto > r_pla_empleados.salario_bruto then
                    update pla_dinero
                    set monto = r_pla_empleados.salario_bruto
                    where id = r_pla_dinero.id;
                end if;
            end if;
        end if;
        
        for r_v_pla_implementos_valorizados in
            select * from v_pla_implementos_valorizados
            where compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and id_periodos = ai_id_periodos
            and fecha >= ld_desde
            order by fecha
        loop
            lvc_descripcion = Trim(r_v_pla_implementos_valorizados.descripcion);

            select into r_pla_conceptos * from pla_conceptos
            where concepto = r_v_pla_implementos_valorizados.concepto;


            select into r_pla_dinero * from pla_dinero
            where id_periodos = ai_id_periodos
            and compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''1''
            and concepto = r_v_pla_implementos_valorizados.concepto
            and id_pla_proyectos = r_v_pla_implementos_valorizados.id_pla_proyectos
            and forma_de_registro = ''M'';
            if found then
                continue;
            end if;

            select into r_pla_dinero * from pla_dinero
            where id_periodos = ai_id_periodos
            and compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''1''
            and concepto = r_v_pla_implementos_valorizados.concepto
            and id_pla_proyectos = r_v_pla_implementos_valorizados.id_pla_proyectos;
            if found then

                update pla_dinero
                set monto = monto + (r_v_pla_implementos_valorizados.monto*r_pla_conceptos.signo)
                where id_periodos = ai_id_periodos
                and compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and tipo_de_calculo = ''1''
                and forma_de_registro = ''A''
                and id_pla_cheques_1 is null
                and id_pla_proyectos = r_v_pla_implementos_valorizados.id_pla_proyectos
                and concepto = r_v_pla_implementos_valorizados.concepto;
            else

                if Trim(r_v_pla_implementos_valorizados.concepto) = ''136'' then
                    ldc_work = 0;
                    select sum(minutos) into ldc_work
                    from v_pla_implementos_valorizados
                    where compania = ai_cia
                    and codigo_empleado = as_codigo_empleado
                    and concepto = ''136''
                    and id_periodos = ai_id_periodos;
                    if ldc_work is null then
                        ldc_work = 0;
                    end if;

                    if ldc_work > 0 then
                        ldc_work = ldc_work / 60;
                        
                        lvc_descripcion =  ''HORAS DE ALTURA = '' || to_char(ldc_work, ''9999.99'');
                    end if;
                end if;
            
                insert into pla_dinero(id_periodos, compania, codigo_empleado,
                    tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                    monto, id_pla_proyectos, id_pla_departamentos)
                values(ai_id_periodos, ai_cia, as_codigo_empleado, ''1'',
                    r_v_pla_implementos_valorizados.concepto,
                    ''A'', trim(lvc_descripcion), Mes(r_pla_periodos.dia_d_pago),
                    r_v_pla_implementos_valorizados.monto*r_pla_conceptos.signo,
                    r_v_pla_implementos_valorizados.id_pla_proyectos,
                    r_v_pla_implementos_valorizados.id_pla_departamentos);

/*
            i   =   f_pla_dinero_insert(ai_id_periodos, ai_cia, as_codigo_empleado,
                        ''1'', r_v_pla_horas_valorizadas.concepto,r_v_pla_horas_valorizadas.descripcion, Mes(r_pla_periodos.dia_d_pago),
                        (r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo));
*/
            end if;
        end loop;
        
    elsif (r_pla_empleados.fecha_inicio 
        between r_pla_periodos.desde and r_pla_periodos.dia_d_pago
        and r_pla_empleados.tipo_de_salario = ''F'' 
        and extract(day from r_pla_empleados.fecha_inicio) <> 1)
        or 
        (r_pla_empleados.fecha_inicio 
        between r_pla_periodos.desde and r_pla_periodos.dia_d_pago
        and r_pla_empleados.tipo_de_salario = ''F'' 
        and trim(lc_primer_salario_completo) = ''N'') 
        or 
        (r_pla_empleados.fecha_terminacion_real
        between r_pla_periodos.desde and r_pla_periodos.dia_d_pago) then
        for r_v_pla_horas_valorizadas in
            select * from v_pla_horas_valorizadas
            where compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''1''
            and id_periodos = ai_id_periodos
            and fecha >= ld_desde
            order by fecha
        loop
            select into r_pla_conceptos * from pla_conceptos
            where concepto = r_v_pla_horas_valorizadas.concepto;


/*            
            if ai_cia = 1142 and r_pla_empleados.tipo = ''2''
                and (r_v_pla_horas_valorizadas.tipo_de_hora = ''30'' or r_v_pla_horas_valorizadas.tipo_de_hora = ''93'') then
                r_v_pla_horas_valorizadas.monto = 22;
                raise exception ''entre'';
            end if;
*/


            select into r_pla_dinero * from pla_dinero
            where id_periodos = ai_id_periodos
            and compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''1''
            and concepto = r_v_pla_horas_valorizadas.concepto
            and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos
            and pla_dinero.monto <> 0
            and forma_de_registro = ''M'';
            if found then
                continue;
            end if;
            
            select into r_pla_dinero * from pla_dinero
            where id_periodos = ai_id_periodos
            and compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''1''
            and forma_de_registro = ''A''
            and id_pla_cheques_1 is null
            and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos
            and concepto = r_v_pla_horas_valorizadas.concepto;
            if found then
                ldc_monto   =   r_pla_dinero.monto + (r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo);
                
                if trim(r_v_pla_horas_valorizadas.concepto) = ''03'' then
                    if ldc_monto > r_pla_empleados.salario_bruto then
                        ldc_monto = r_pla_empleados.salario_bruto;

                    elsif r_pla_empleados.fecha_inicio 
                            between r_pla_periodos.desde and r_pla_periodos.dia_d_pago
                            and r_pla_empleados.tipo_de_salario = ''F'' 
                            and (extract(day from r_pla_empleados.fecha_inicio) = 1
                            or extract(day from r_pla_empleados.fecha_inicio) = 16) then
                             ldc_monto = r_pla_empleados.salario_bruto;
                    end if;                             
                end if;
                
                update pla_dinero
                set monto = ldc_monto 
                where id_periodos = ai_id_periodos
                and compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and tipo_de_calculo = ''1''
                and forma_de_registro = ''A''
                and id_pla_cheques_1 is null
                and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos
                and concepto = r_v_pla_horas_valorizadas.concepto;
            else

                insert into pla_dinero(id_periodos, compania, codigo_empleado,
                    tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                    monto, id_pla_proyectos, id_pla_departamentos)
                values(ai_id_periodos, ai_cia, as_codigo_empleado, ''1'',r_v_pla_horas_valorizadas.concepto,
                    ''A'', r_v_pla_horas_valorizadas.descripcion, Mes(r_pla_periodos.dia_d_pago),
                    r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo,
                    r_v_pla_horas_valorizadas.id_pla_proyectos,
                    r_v_pla_horas_valorizadas.id_pla_departamentos);
            end if;
        end loop;
        

    else

        select into r_pla_vacaciones * from pla_vacaciones
        where compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and (r_pla_periodos.desde between pagar_desde and pagar_hasta
        or r_pla_periodos.hasta between pagar_desde and pagar_hasta)
        and status = ''A'';
        if found then
            for r_v_pla_horas_valorizadas in
                select * from v_pla_horas_valorizadas
                where compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and fecha > r_pla_vacaciones.pagar_hasta
                and id_periodos = ai_id_periodos
                order by fecha
            loop
                select into r_pla_dinero * from pla_dinero
                where id_periodos = ai_id_periodos
                and compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and tipo_de_calculo = ''1''
                and concepto = r_v_pla_horas_valorizadas.concepto;
                if found then
                    if r_pla_dinero.forma_de_registro = ''A'' then
                        update pla_dinero
                        set monto = monto + r_v_pla_horas_valorizadas.monto
                        where id_periodos = ai_id_periodos
                        and compania = ai_cia
                        and codigo_empleado = as_codigo_empleado
                        and tipo_de_calculo = ''1''
                        and id_pla_cheques_1 is null
                        and concepto = r_v_pla_horas_valorizadas.concepto;
                    end if;
                else
                    insert into pla_dinero(id_periodos, compania, codigo_empleado, tipo_de_calculo,
                        concepto, forma_de_registro, descripcion, mes, monto, id_pla_departamentos, id_pla_proyectos)
                    values (ai_id_periodos, ai_cia, as_codigo_empleado, ''1'', r_v_pla_horas_valorizadas.concepto,
                        ''A'', r_v_pla_horas_valorizadas.descripcion, Mes(r_pla_periodos.dia_d_pago),
                        r_v_pla_horas_valorizadas.monto,
                        r_v_pla_horas_valorizadas.id_pla_departamentos,
                        r_v_pla_horas_valorizadas.id_pla_proyectos);
/*                        
                    i   =   f_pla_dinero_insert(ai_id_periodos, ai_cia, as_codigo_empleado,
                                ''1'', r_v_pla_horas_valorizadas.concepto,r_v_pla_horas_valorizadas.descripcion, Mes(r_pla_periodos.dia_d_pago),
                                r_v_pla_horas_valorizadas.monto);
*/                                
                        
                end if;
            end loop; 
        else
--            and fecha >= r_pla_periodos.desde;

            select into ldc_suma sum(monto) from v_pla_horas_valorizadas
            where compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and id_periodos = ai_id_periodos
            and tipo_de_calculo = ''1''
            and recargo = 1
            and signo = 1
            and tipo_de_hora not in (''00'',''91'',''26'');
            if not found or ldc_suma is null then
                ldc_suma = 0;
            end if;
        
            select into r_pla_work * from pla_empleados
            where compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and fecha_inicio > r_pla_periodos.desde;
            if found then
                if r_pla_work.tipo_de_planilla = ''2'' then
                    r_pla_empleados.salario_bruto = f_primer_pago(ai_cia, as_codigo_empleado, ai_id_periodos);
                else
                    r_pla_empleados.salario_bruto = f_pla_primer_salario(ai_cia, as_codigo_empleado, ai_id_periodos);
                end if;
            end if;
            
            ldc_vacacion_pagada = 0;
            
            if ai_cia = 1185 then
                select sum(monto) into ldc_vacacion_pagada 
                from pla_dinero
                where compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and id_periodos = r_pla_periodos.id
                and concepto = ''108'';
                if ldc_vacacion_pagada is null then
                    ldc_vacacion_pagada = 0;
                end if;
                
                update pla_dinero
                set tipo_de_calculo = ''1''
                where compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and id_periodos = r_pla_periodos.id
                and tipo_de_calculo = ''2'';
            end if;
            
            ldc_salario_regular = r_pla_empleados.salario_bruto - ldc_suma - ldc_vacacion_pagada;
            select into r_pla_dinero * from pla_dinero
            where id_periodos = ai_id_periodos
            and compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''1''
            and concepto = ''03'';
            if not found then
                for r_work in
                    select id_pla_proyectos, pla_conceptos.concepto, sum(monto*pla_conceptos.signo) as monto
                    from v_pla_horas_valorizadas, pla_conceptos
                    where compania = ai_cia
                    and codigo_empleado = as_codigo_empleado
                    and id_periodos = ai_id_periodos
                    and pla_conceptos.concepto = ''03''
                    and id_pla_proyectos <> r_pla_empleados.id_pla_proyectos
                    and v_pla_horas_valorizadas.concepto = pla_conceptos.concepto
                    group by 1, 2
                    order by 1, 2
                loop
                    insert into pla_dinero(id_periodos, compania, codigo_empleado,
                        tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                        monto, id_pla_departamentos, id_pla_proyectos)
                    values(ai_id_periodos, ai_cia, as_codigo_empleado, ''1'',''03'',
                        ''A'', ''SALARIO REGULAR'', Mes(r_pla_periodos.dia_d_pago),
                        r_work.monto, r_pla_empleados.departamento, r_work.id_pla_proyectos);
                    ldc_salario_regular = ldc_salario_regular - r_work.monto;
                end loop;

                
                insert into pla_dinero(id_periodos, compania, codigo_empleado,
                    tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                    monto, id_pla_departamentos, id_pla_proyectos)
                values(ai_id_periodos, ai_cia, as_codigo_empleado, ''1'',''03'',
                    ''A'', ''SALARIO REGULAR'', Mes(r_pla_periodos.dia_d_pago),
                    ldc_salario_regular, r_pla_empleados.departamento, r_pla_empleados.id_pla_proyectos);
                    
            end if;
            
            for r_v_pla_horas_valorizadas in
                select * from v_pla_horas_valorizadas
                where compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and tipo_de_calculo = ''1''
                and id_periodos = ai_id_periodos
                and tipo_de_hora not in (''00'', ''50'')
                order by fecha
            loop
                select into r_pla_conceptos * from pla_conceptos
                where concepto = r_v_pla_horas_valorizadas.concepto;
                
                select into r_pla_dinero * from pla_dinero
                where id_periodos = ai_id_periodos
                and compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and tipo_de_calculo = ''1''
                and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos
                and concepto = r_v_pla_horas_valorizadas.concepto;
                if found then
                    update pla_dinero
                    set monto = monto + (r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo)
                    where id_periodos = ai_id_periodos
                    and compania = ai_cia
                    and codigo_empleado = as_codigo_empleado
                    and tipo_de_calculo = ''1''
                    and forma_de_registro = ''A''
                    and id_pla_cheques_1 is null
                    and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos
                    and concepto = r_v_pla_horas_valorizadas.concepto;
                else
                    insert into pla_dinero(id_periodos, compania, codigo_empleado,
                        tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                        monto, id_pla_departamentos, id_pla_proyectos)
                    values(ai_id_periodos, ai_cia, as_codigo_empleado, ''1'',r_v_pla_horas_valorizadas.concepto,
                        ''A'', r_v_pla_horas_valorizadas.descripcion, Mes(r_pla_periodos.dia_d_pago),
                        r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo, 
                        r_v_pla_horas_valorizadas.id_pla_departamentos,
                        r_v_pla_horas_valorizadas.id_pla_proyectos);
                        
/*                        
                    i   =   f_pla_dinero_insert(ai_id_periodos, ai_cia, as_codigo_empleado,
                                ''1'', r_v_pla_horas_valorizadas.concepto,r_v_pla_horas_valorizadas.descripcion, Mes(r_pla_periodos.dia_d_pago),
                                (r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo));
*/                                
                end if;
            end loop;
        end if;
    end if;
    
    if f_pla_parametros(ai_cia, ''paga_exceso_9_horas_empleados_semanales'', ''S'', ''GET'') = ''N'' 
        and (r_pla_empleados.tipo_de_planilla = ''1'' or r_pla_empleados.tipo_de_planilla = ''3'') then
            if ai_cia <> 745 then
                i   =   f_pla_liquida_semana(ai_cia, as_codigo_empleado, ai_id_periodos);    
            end if;
    end if;


    i = f_pla_otros_ingresos(ai_cia, as_codigo_empleado, ai_id_periodos, ''1'');

    i = f_pla_drive_true(ai_cia, as_codigo_empleado, ai_id_periodos, ''1'');

    i = f_pla_seguro_social(ai_cia, as_codigo_empleado,ai_id_periodos, ''1'');
    
    i = f_pla_seguro_educativo(ai_cia, as_codigo_empleado,ai_id_periodos, ''1'');

    i = f_pla_sindicato(ai_cia, as_codigo_empleado,ai_id_periodos, ''1'');

    i = f_pla_sindicato_chong(ai_cia, as_codigo_empleado,ai_id_periodos, ''1'');
    
    i = f_pla_retenciones(ai_cia, as_codigo_empleado, ai_id_periodos,''1'');

    
    if f_pla_salario_neto(ai_cia, as_codigo_empleado, ''1'', ai_id_periodos) < 0 then
        delete from pla_dinero
        where compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and forma_de_registro = ''A''
        and tipo_de_calculo = ''1''
        and id_periodos = ai_id_periodos
        and (id_pla_cheques_1 is null or monto = 0);
    end if;
    
    delete from pla_dinero
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and forma_de_registro = ''A''
    and tipo_de_calculo = ''1''
    and id_periodos = ai_id_periodos
    and monto = 0;

    return 1;
end;
' language plpgsql;



create function f_pla_otros_ingresos(int4, char(7), int4, char(2)) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    as_tipo_de_calculo alias for $4;
    r_pla_periodos record;
    r_pla_dinero record;
    r_pla_conceptos record;
    r_pla_retenciones record;
    r_pla_otros_ingresos_fijos record;
    i int4;
    ldc_work decimal;
    ldc_retener decimal;
begin
    select into r_pla_periodos * from pla_periodos
    where id = ai_id_periodos;
    if not found then
        raise exception ''Periodo % no Existe otros ingresos'',ai_id_periodos;
    end if;
    
    for r_pla_otros_ingresos_fijos in select * from pla_otros_ingresos_fijos
                                        where compania = ai_cia
                                        and codigo_empleado = as_codigo_empleado
                                        and periodo = r_pla_periodos.periodo
                                        order by concepto
    loop
        select into r_pla_conceptos * from pla_conceptos
        where concepto = r_pla_otros_ingresos_fijos.concepto;
/*        
        i   =   f_pla_dinero_insert(ai_id_periodos, ai_cia, as_codigo_empleado,
                            as_tipo_de_calculo, r_pla_otros_ingresos_fijos.concepto,r_pla_conceptos.descripcion, Mes(r_pla_periodos.dia_d_pago),
                            r_pla_otros_ingresos_fijos.monto);
*/            
        
        select into r_pla_dinero * from pla_dinero
        where id_periodos = ai_id_periodos
        and compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and tipo_de_calculo = as_tipo_de_calculo
        and concepto = r_pla_otros_ingresos_fijos.concepto;
        if not found then        
        
            if trim(as_tipo_de_calculo) = ''2'' and trim(r_pla_otros_ingresos_fijos.concepto) = ''73'' then
                r_pla_otros_ingresos_fijos.concepto = ''107'';
            end if;
            
            insert into pla_dinero(id_periodos, compania, codigo_empleado, tipo_de_calculo,
                concepto, forma_de_registro, descripcion, mes, monto)
            values (ai_id_periodos, ai_cia, as_codigo_empleado, as_tipo_de_calculo, r_pla_otros_ingresos_fijos.concepto,
                ''A'', r_pla_conceptos.descripcion, Mes(r_pla_periodos.dia_d_pago), r_pla_otros_ingresos_fijos.monto);
                
                
        end if;
        
    end loop;
    

    return 1;
end;
' language plpgsql;




create function f_pla_retenciones(int4, char(7), int4, char(2)) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    as_tipo_de_calculo alias for $4;
    r_pla_periodos record;
    r_pla_dinero record;
    r_pla_conceptos record;
    r_pla_retenciones record;
    r_pla_deducciones record;
    r_pla_acreedores record;
    r_pla_vacaciones record;
    i int4;
    li_id_pla_dinero int4;
    ldc_dias_vacaciones decimal;
    li_id_pla_vacaciones int4;
    ldc_work decimal;
    ldc_retener decimal;
    ldc_retenido decimal;
    ldc_saldo decimal;
    lc_descripcion varchar(100);
begin
    select into r_pla_periodos * from pla_periodos
    where id = ai_id_periodos;
    
    for r_pla_retenciones in select * from pla_retenciones, pla_retener, pla_acreedores
                                where pla_retenciones.id = pla_retener.id_pla_retenciones
                                and pla_retenciones.acreedor = pla_acreedores.acreedor
                                and pla_retenciones.compania = pla_acreedores.compania
                                and r_pla_periodos.dia_d_pago >= pla_retenciones.fecha_inidescto
                                and pla_retenciones.status = ''A''
                                and pla_retenciones.compania = ai_cia
                                and pla_retenciones.codigo_empleado = as_codigo_empleado
                                and pla_retener.periodo = r_pla_periodos.periodo
                                order by pla_acreedores.prioridad, pla_retenciones.fecha_inidescto
    loop
        select into r_pla_acreedores *
        from pla_acreedores
        where compania = ai_cia
        and acreedor = r_pla_retenciones.acreedor;
        
        if r_pla_retenciones.fecha_finaldescto  is not null and 
           r_pla_periodos.dia_d_pago > r_pla_retenciones.fecha_finaldescto then
            continue;
        end if;
        
        if Mes(r_pla_periodos.dia_d_pago) = 12 and
            r_pla_retenciones.aplica_diciembre = ''N'' then
            continue;
        end if;        
        
        if r_pla_retenciones.tipo_descuento = ''P'' then
            select into ldc_work sum(pla_dinero.monto*pla_conceptos.signo)
            from pla_dinero, pla_conceptos, pla_conceptos_acumulan
            where pla_dinero.concepto = pla_conceptos.concepto
            and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
            and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
            and pla_dinero.codigo_empleado = as_codigo_empleado
            and pla_dinero.id_periodos = ai_id_periodos
            and pla_dinero.compania = ai_cia
            and pla_conceptos_acumulan.concepto = r_pla_acreedores.concepto;
            ldc_retener = (r_pla_retenciones.monto/100) * ldc_work;
        else
            ldc_retener = r_pla_retenciones.monto;
        end if;
        
        ldc_retenido = 0;
        select sum(pla_dinero.monto) into ldc_retenido
        from pla_deducciones, pla_dinero
        where pla_deducciones.id_pla_dinero = pla_dinero.id
        and pla_deducciones.id_pla_retenciones = r_pla_retenciones.id;
        if not found or ldc_retenido is null then
            ldc_retenido = 0;
        end if;
        
        ldc_saldo = r_pla_retenciones.monto_original_deuda - ldc_retenido;
        
        if ldc_saldo <= 0 and r_pla_retenciones.monto_original_deuda <> 0 then
            continue;
        end if;
        
        if ldc_retener > ldc_saldo then
            ldc_retener = ldc_saldo;
        end if;        
        
        if r_pla_retenciones.monto_original_deuda = 0 then
            ldc_retener = r_pla_retenciones.monto;        
        end if;
        
        lc_descripcion = trim(r_pla_retenciones.nombre);
        
        lc_descripcion = Trim(r_pla_retenciones.nombre) || ''  '' || Trim(r_pla_retenciones.descripcion_descuento);
        
        if Trim(as_tipo_de_calculo) = ''2'' then
            select into li_id_pla_vacaciones Max(id_pla_vacaciones)
            from pla_dinero
            where compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = as_tipo_de_calculo
            and id_periodos = ai_id_periodos;
            
            select into r_pla_vacaciones *
            from pla_vacaciones
            where id = li_id_pla_vacaciones;
            if found then
                ldc_dias_vacaciones = (r_pla_vacaciones.pagar_hasta - r_pla_vacaciones.pagar_desde) + 1;
                if ldc_dias_vacaciones >= 25 then
                    if r_pla_periodos.tipo_de_planilla = ''1'' then
                        ldc_retener = ldc_retener * 4;
                    elsif r_pla_periodos.tipo_de_planilla = ''2'' 
                        or r_pla_periodos.tipo_de_planilla = ''3'' then
                        ldc_retener = ldc_retener * 2;
                    end if;
                end if;
            end if;
        end if;

        if f_pla_salario_neto(ai_cia, as_codigo_empleado, as_tipo_de_calculo, ai_id_periodos) >= ldc_retener then
            li_id_pla_dinero   =   f_pla_dinero_insert(ai_id_periodos, ai_cia, as_codigo_empleado,
                                    as_tipo_de_calculo, r_pla_acreedores.concepto,
                                    trim(lc_descripcion), Cast(Mes(r_pla_periodos.dia_d_pago) as integer),
                                    ldc_retener);                        
                                    
                                    
            select into r_pla_deducciones * from pla_deducciones
            where id_pla_retenciones = r_pla_retenciones.id
            and id_pla_dinero = li_id_pla_dinero;
            if not found then
                insert into pla_deducciones(id_pla_retenciones, id_pla_dinero)
                values(r_pla_retenciones.id, li_id_pla_dinero); 
            end if;
        end if;
                
    end loop;
    
    return 1;
end;
' language plpgsql;


create function f_pla_salario_neto(int4, char(7), char(2), int4) returns decimal as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_de_calculo alias for $3;
    ai_id_periodos alias for $4;
    ldc_work decimal;
begin
    ldc_work = 0;
    
    select into ldc_work sum(pla_dinero.monto*pla_conceptos.signo) 
    from pla_dinero, pla_conceptos
    where pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.compania = ai_cia
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
    and pla_dinero.id_periodos = ai_id_periodos;
    
    if ldc_work is null then
        ldc_work = 0;
    end if;
    
    return ldc_work;
end;
' language plpgsql;




create function f_pla_horas(int4, char(7), int4) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_turnos record;
    r_pla_certificados_medico record;
    r_pla_permisos record;
    r_pla_marcaciones_2 record;
    r_pla_desglose_regulares record;
    r_pla_periodos record;
    r_work record;
    ldt_entrada_turno timestamp;
    ldt_salida_turno timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    li_minutos_regulares int4;
    ldc_tiempo_minimo_de_descanso decimal;
    ldc_descanso decimal;
    i integer;
    li_id_marcacion_anterior int4;
    lc_computa_descanso_en_base_al_turno char(1);
begin
    
    delete from pla_horas using pla_marcaciones, pla_tarjeta_tiempo
    where pla_horas.id_marcaciones = pla_marcaciones.id
    and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
    and pla_tarjeta_tiempo.compania = ai_cia
    and pla_tarjeta_tiempo.codigo_empleado = as_codigo_empleado
    and pla_tarjeta_tiempo.id_periodos = ai_id_periodos
    and pla_horas.forma_de_registro = ''A'';


    if ai_cia = 1341 or ai_cia = 1353 then
        delete from pla_dinero
        where compania = ai_cia
        and trim(codigo_empleado) = Trim(as_codigo_empleado)
        and id_periodos = ai_id_periodos
        and tipo_de_calculo = ''1'' 
        and concepto = ''119''
        and forma_de_registro = ''A'';
    end if;


    select into r_pla_empleados * 
    from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    
    lc_computa_descanso_en_base_al_turno    =   trim(f_pla_parametros(r_pla_empleados.compania, ''computa_descanso_en_base_al_turno'', ''N'', ''GET''));
    
    select into r_pla_periodos * from pla_periodos
    where id = ai_id_periodos;
    if not found then
        return 0;
    end if;
    
    if r_pla_periodos.status = ''C'' then
        return 0;
    end if;



    for r_pla_certificados_medico in select pla_certificados_medico.*
                                     from pla_certificados_medico, pla_periodos, pla_empleados
                                     where pla_certificados_medico.compania = pla_empleados.compania
                                     and pla_certificados_medico.codigo_empleado = pla_empleados.codigo_empleado
                                     and pla_certificados_medico.compania = pla_periodos.compania
                                     and pla_certificados_medico.year = pla_periodos.year
                                     and pla_certificados_medico.numero_planilla = pla_periodos.numero_planilla
                                     and pla_empleados.tipo_de_planilla = pla_periodos.tipo_de_planilla
                                     and pla_certificados_medico.compania = ai_cia
                                     and pla_certificados_medico.codigo_empleado = as_codigo_empleado
                                     and pla_periodos.id = ai_id_periodos
                                     order by pla_certificados_medico.fecha
    loop
        i = f_crear_tarjeta(ai_cia, as_codigo_empleado, r_pla_certificados_medico.fecha, ai_id_periodos);
    end loop;    
    
    for r_pla_permisos in select pla_permisos.* 
                            from pla_permisos, pla_periodos, pla_empleados
                             where pla_permisos.compania = pla_empleados.compania
                             and pla_permisos.codigo_empleado = pla_empleados.codigo_empleado
                             and pla_permisos.compania = pla_periodos.compania
                             and pla_permisos.year = pla_periodos.year
                             and pla_permisos.numero_planilla = pla_periodos.numero_planilla
                             and pla_empleados.tipo_de_planilla = pla_periodos.tipo_de_planilla
                             and pla_permisos.compania = ai_cia
                             and pla_permisos.codigo_empleado = as_codigo_empleado
                             and pla_periodos.id = ai_id_periodos
                             order by pla_permisos.fecha
    loop
        i = f_crear_tarjeta(ai_cia, as_codigo_empleado, r_pla_permisos.fecha, ai_id_periodos);
    end loop;    
    
    li_id_marcacion_anterior    =   0;
    for r_pla_marcaciones in select pla_marcaciones.* 
                                from pla_tarjeta_tiempo, pla_marcaciones
                                where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
                                and pla_tarjeta_tiempo.compania = ai_cia
                                and pla_tarjeta_tiempo.codigo_empleado = as_codigo_empleado
                                and pla_tarjeta_tiempo.id_periodos = ai_id_periodos
                                order by pla_marcaciones.entrada
    loop

        if ai_cia = 1360 and r_pla_marcaciones.status <> ''I'' then
            if trim(lc_computa_descanso_en_base_al_turno) = ''S'' then
                if r_pla_marcaciones.entrada > r_pla_marcaciones.salida 
                    or r_pla_marcaciones.entrada > r_pla_marcaciones.entrada_descanso
                    or r_pla_marcaciones.entrada > r_pla_marcaciones.salida_descanso then
                    raise exception ''Inconsistencia en la Hora de Entrada de Jornada % Empleado %'',r_pla_marcaciones.entrada, as_codigo_empleado;
                end if;
    
                if r_pla_marcaciones.entrada_descanso > r_pla_marcaciones.salida_descanso 
                    or r_pla_marcaciones.entrada_descanso > r_pla_marcaciones.salida 
                    or r_pla_marcaciones.entrada_descanso < r_pla_marcaciones.entrada then
                    raise exception ''Inconsistencia en la Hora de Inicio de Descanso % Empleado %'',r_pla_marcaciones.entrada_descanso, as_codigo_empleado;
                end if;
        
                if r_pla_marcaciones.salida_descanso > r_pla_marcaciones.salida 
                    or r_pla_marcaciones.salida_descanso < r_pla_marcaciones.entrada
                    or r_pla_marcaciones.salida_descanso < r_pla_marcaciones.entrada_descanso then
                    raise exception ''Inconsistencia en la Hora de Final de Descanso % Empleado %'',r_pla_marcaciones.salida_descanso, as_codigo_empleado;
                end if;

                if r_pla_marcaciones.salida < r_pla_marcaciones.entrada
                    or r_pla_marcaciones.salida < r_pla_marcaciones.entrada_descanso
                    or r_pla_marcaciones.salida < r_pla_marcaciones.salida_descanso then
                    raise exception ''Inconsistencia en la Hora de Fin de Jornada % Empleado %'',r_pla_marcaciones.salida, as_codigo_empleado;
                end if;
            else
                if r_pla_marcaciones.entrada > r_pla_marcaciones.salida then
                    raise exception ''Inconsistencia en la Hora de Entrada de Jornada % Empleado %'',r_pla_marcaciones.entrada, as_codigo_empleado;
                end if;
    
                if r_pla_marcaciones.salida < r_pla_marcaciones.entrada then
                    raise exception ''Inconsistencia en la Hora de Fin de Jornada % Empleado %'',r_pla_marcaciones.salida, as_codigo_empleado;
                end if;
            end if;
        end if;
        
        if r_pla_marcaciones.status = ''L'' then
            i   =   f_pla_horas(r_pla_marcaciones.id, ''00'', 0,
                       0, ''N'', ''N'');
            continue;
        end if;

        
        if f_procesar_tarjeta(ai_cia, as_codigo_empleado, date(r_pla_marcaciones.entrada)) then
            
            i = f_pla_horas_regulares(r_pla_marcaciones.id);

            i = f_pla_horas_ausencia(r_pla_marcaciones.id);

            i = f_pla_horas_permisos(r_pla_marcaciones.id);

            if ai_cia = 1142 and r_pla_empleados.tipo = ''2'' then
                i = f_pla_horas_certificadas_tecozam(r_pla_marcaciones.id);
            else
                i = f_pla_horas_certificadas(r_pla_marcaciones.id);
            end if;

--            i = f_pla_horas_elimina_horas_regulares_vacaciones(r_pla_marcaciones.id);

--        if ai_cia <> 1075 then            
            i = f_pla_horas_regulares_excedentes(r_pla_marcaciones.id);
--        end if;            
            i = f_pla_horas_extras(r_pla_marcaciones.id);

            if ai_cia <> 1046 then        
                i = f_pla_horas_anteriores(r_pla_marcaciones.id);
            end if;

            i = f_pla_horas_implementos(r_pla_marcaciones.id);
            
            if ai_cia = 1341 or ai_cia = 1353 then
                i = f_pla_calculo_viaticos(r_pla_marcaciones.id);
            end if;
        end if;
    end loop;

    if ai_cia = 1046 then
        i = f_pla_horas_seceyco(ai_cia, as_codigo_empleado, ai_id_periodos);
    end if;

    delete from pla_horas
    using pla_tarjeta_tiempo, pla_periodos, pla_empleados, pla_departamentos, pla_marcaciones
    where pla_horas.id_marcaciones = pla_marcaciones.id
    and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
    and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
    and pla_tarjeta_tiempo.compania = pla_empleados.compania
    and pla_tarjeta_tiempo.codigo_empleado = pla_empleados.codigo_empleado
    and pla_empleados.departamento = pla_departamentos.id
    and pla_periodos.compania = ai_cia
    and pla_empleados.codigo_empleado = as_codigo_empleado
    and pla_periodos.id = ai_id_periodos
    and pla_horas.forma_de_registro = ''A''
    and pla_horas.minutos = 0
    and pla_periodos.compania not in (1341, 1353);

    return 1;
end;
' language plpgsql;


create function f_pla_reasignacion_turno(int4, char(7), int4) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_turnos record;
    r_pla_turnos_rotativos record;
    r_pla_certificados_medico record;
    r_pla_permisos record;
    r_pla_marcaciones_2 record;
    r_pla_desglose_regulares record;
    r_pla_periodos record;
    r_work record;
    ldt_entrada_turno timestamp;
    ldt_salida_turno timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    li_minutos_regulares int4;
    ldc_tiempo_minimo_de_descanso decimal;
    ldc_descanso decimal;
    i integer;
    li_id_marcacion_anterior int4;
    lc_computa_descanso_en_base_al_turno char(1);
begin
    
    delete from pla_horas using pla_marcaciones, pla_tarjeta_tiempo
    where pla_horas.id_marcaciones = pla_marcaciones.id
    and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
    and pla_tarjeta_tiempo.compania = ai_cia
    and pla_tarjeta_tiempo.codigo_empleado = as_codigo_empleado
    and pla_tarjeta_tiempo.id_periodos = ai_id_periodos
    and pla_horas.forma_de_registro = ''A'';


    if ai_cia = 1341 or ai_cia = 1353 then
        delete from pla_dinero
        where compania = ai_cia
        and trim(codigo_empleado) = Trim(as_codigo_empleado)
        and id_periodos = ai_id_periodos
        and tipo_de_calculo = ''1'' 
        and concepto = ''119''
        and forma_de_registro = ''A'';
    end if;


    select into r_pla_empleados * 
    from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    
    lc_computa_descanso_en_base_al_turno    =   trim(f_pla_parametros(r_pla_empleados.compania, ''computa_descanso_en_base_al_turno'', ''N'', ''GET''));
    
    select into r_pla_periodos * from pla_periodos
    where id = ai_id_periodos;
    if not found then
        return 0;
    end if;
    
    if r_pla_periodos.status = ''C'' then
        return 0;
    end if;



    
    li_id_marcacion_anterior    =   0;
    for r_pla_marcaciones in select pla_marcaciones.*
                                from pla_tarjeta_tiempo, pla_marcaciones
                                where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
                                and pla_tarjeta_tiempo.compania = ai_cia
                                and pla_tarjeta_tiempo.codigo_empleado = as_codigo_empleado
                                and pla_tarjeta_tiempo.id_periodos = ai_id_periodos
                                order by pla_marcaciones.entrada
    loop

        select into r_pla_turnos_rotativos *
        from pla_turnos_rotativos
        where compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and f_to_date(r_pla_marcaciones.entrada) between desde and hasta
        and turno is not null;
        if found then
            update pla_marcaciones
            set turno = r_pla_turnos_rotativos.turno
            where id = r_pla_marcaciones.id;
        end if;
        
    end loop;

    return 1;
end;
' language plpgsql;


create function f_pla_horas_elimina_horas_regulares_vacaciones(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_turnos record;
    r_pla_tarjeta_tiempo record;
    r_pla_horas record;
    r_pla_vacaciones record;
    ldt_entrada_turno timestamp;
    ldt_salida_turno timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    li_minutos_regulares int4;
    ld_fecha date;
begin
    select into r_pla_marcaciones * from pla_marcaciones
    where id = ai_id;
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;

    if r_pla_empleados.tipo_de_salario = ''H'' then
        return 0;
    end if;
    
    if r_pla_empleados.status <> ''V'' then
        return 0;
    end if;
    
    delete from pla_horas
    where id_marcaciones = ai_id
    and tipo_de_hora = ''00''
    and forma_de_registro = ''A'';

    
    return 1;
end;
' language plpgsql;



create function f_pla_horas_ausencia(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_turnos record;
    r_pla_tarjeta_tiempo record;
    r_pla_horas record;
    r_pla_dias_feriados record;
    ldt_entrada_turno timestamp;
    ldt_salida_turno timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    li_minutos_regulares int4;
    ld_fecha date;
begin
    select into r_pla_marcaciones * from pla_marcaciones
    where id = ai_id;
    if r_pla_marcaciones.status <> ''I'' then
        return 1;
    end if;
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;

    ld_fecha    =   f_to_date(r_pla_marcaciones.entrada);

    select into r_pla_dias_feriados *
    from pla_dias_feriados
    where compania = r_pla_empleados.compania
    and tipo_de_salario = r_pla_empleados.tipo_de_salario
    and fecha = ld_fecha;
    if found then
        update pla_marcaciones
        set status = ''R''
        where id = ai_id;
        return 1;
    end if;        

    
    if r_pla_marcaciones.turno is null then
        li_minutos_regulares = f_intervalo(r_pla_marcaciones.entrada, r_pla_marcaciones.salida)
                                    - f_intervalo(r_pla_marcaciones.entrada_descanso, r_pla_marcaciones.salida_descanso);
        if li_minutos_regulares > (60*8) then
            li_minutos_regulares    =   60*8;
        end if;
    else    
        select into r_pla_turnos * from pla_turnos
        where compania = r_pla_empleados.compania
        and turno = r_pla_marcaciones.turno;

        ldt_entrada_turno = f_timestamp(date(r_pla_marcaciones.entrada),r_pla_turnos.hora_inicio);
        ldt_salida_turno = f_timestamp(date(r_pla_marcaciones.salida), r_pla_turnos.hora_salida);
    
        li_minutos_regulares = 0;    
        li_minutos_regulares = f_intervalo(ldt_entrada_turno, ldt_salida_turno);
    
        if r_pla_turnos.tipo_de_jornada = ''N'' then
            li_minutos_regulares = li_minutos_regulares + 60;
        elsif r_pla_turnos.tipo_de_jornada = ''M'' then
                li_minutos_regulares = li_minutos_regulares + 30;
        end if;
        
        if r_pla_turnos.hora_inicio_descanso is not null
            and r_pla_turnos.hora_salida_descanso is not null then
            ldt_entrada_turno = f_timestamp(date(r_pla_marcaciones.entrada), r_pla_turnos.hora_inicio_descanso);
            ldt_salida_turno = f_timestamp(date(r_pla_marcaciones.entrada), r_pla_turnos.hora_salida_descanso);
            li_minutos_regulares = li_minutos_regulares - f_intervalo(ldt_entrada_turno, ldt_salida_turno);
        end if;
        
    end if;
            
    select into r_pla_horas * from pla_horas
    where id_marcaciones = r_pla_marcaciones.id
    and tipo_de_hora = ''20'';
    if not found and li_minutos_regulares > 0 then
        insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
            tasa_por_minuto, aplicar, acumula, forma_de_registro)
        values (r_pla_marcaciones.id, ''20'',li_minutos_regulares, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'', ''A'');
    end if;    
    
    
    update pla_desglose_regulares
    set ausencia = ausencia + li_minutos_regulares
    where id_pla_marcaciones = r_pla_marcaciones.id;
    
    return 1;
end;
' language plpgsql;


create function f_pla_horas_tardanzas(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_turnos record;
    r_pla_tarjeta_tiempo record;
    r_pla_horas record;
    r_pla_dias_feriados record;
    ldt_entrada_turno timestamp;
    ldt_salida_turno timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    lts_inicio_descanso timestamp;
    lts_salida_descanso timestamp;
    lts_tolerancia_descanso timestamp;
    lts_hora_salida_descanso timestamp;
    li_minutos_regulares int4;
    li_minutos_descanso int4;
    li_retorno int4;
    lc_computa_descanso_en_base_al_turno char(1);
    lc_tipo_de_hora varchar(2);
    ld_fecha date;
begin

    select into r_pla_marcaciones * 
    from pla_marcaciones
    where id = ai_id;
    
    if r_pla_marcaciones.status = ''I'' then
        return 0;
    end if;
    
    if r_pla_marcaciones.turno is null then
        return 0;
    end if;
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;
    
    select into r_pla_turnos * from pla_turnos
    where compania = r_pla_empleados.compania
    and turno = r_pla_marcaciones.turno;
    if not found then
        return 0;
    end if;

    lc_computa_descanso_en_base_al_turno    =   trim(f_pla_parametros(r_pla_empleados.compania, ''computa_descanso_en_base_al_turno'', ''N'', ''GET''));
        
    li_minutos_regulares    = 0;    
    ldt_entrada_turno       = f_timestamp(date(r_pla_marcaciones.entrada),r_pla_turnos.tolerancia_de_entrada);

    if r_pla_marcaciones.entrada > ldt_entrada_turno then
        ldt_entrada_turno       = f_timestamp(date(r_pla_marcaciones.entrada),r_pla_turnos.hora_inicio);
        li_minutos_regulares    = f_intervalo(ldt_entrada_turno,r_pla_marcaciones.entrada);
    end if;


    if trim(lc_computa_descanso_en_base_al_turno) = ''S'' then
        if r_pla_turnos.tolerancia_descanso is not null and r_pla_marcaciones.entrada_descanso is not null then
            ldt_entrada_descanso = f_timestamp(date(r_pla_marcaciones.entrada_descanso),r_pla_turnos.tolerancia_descanso);
            if r_pla_marcaciones.entrada_descanso > ldt_entrada_descanso then
                li_minutos_regulares = li_minutos_regulares + f_intervalo(ldt_entrada_descanso,r_pla_marcaciones.entrada_descanso);
            end if;
        end if;
    
        lts_inicio_descanso =   f_timestamp(date(r_pla_marcaciones.entrada),r_pla_turnos.hora_inicio_descanso);
        if r_pla_turnos.hora_inicio_descanso is not null and r_pla_marcaciones.entrada_descanso is null and
            r_pla_marcaciones.entrada >= lts_inicio_descanso then
        
        
            li_minutos_descanso =   f_intervalo(lts_inicio_descanso, r_pla_marcaciones.entrada);
        
            li_minutos_regulares=   li_minutos_regulares - li_minutos_descanso;
        end if;
        
        lts_salida_descanso =   f_timestamp(date(r_pla_marcaciones.entrada),r_pla_turnos.hora_salida_descanso);
        if r_pla_turnos.hora_salida_descanso is not null and r_pla_marcaciones.entrada_descanso is null and
            r_pla_marcaciones.entrada >= lts_salida_descanso then
            li_minutos_regulares=   li_minutos_regulares +
                                        f_intervalo(lts_salida_descanso, r_pla_marcaciones.entrada);
        end if;

        if r_pla_turnos.tolerancia_descanso is not null then
            lts_tolerancia_descanso  =  f_timestamp(date(r_pla_marcaciones.salida_descanso), r_pla_turnos.tolerancia_descanso);
            lts_hora_salida_descanso =  f_timestamp(date(r_pla_marcaciones.salida_descanso), r_pla_turnos.hora_salida_descanso);
            if r_pla_marcaciones.salida_descanso > lts_tolerancia_descanso then
                li_minutos_regulares    =   li_minutos_regulares + f_intervalo(lts_hora_salida_descanso, r_pla_marcaciones.salida_descanso);
            end if;
        end if;
    end if;


    if extract(dow from r_pla_marcaciones.entrada) = 0 then
        lc_tipo_de_hora =   f_pla_parametros(r_pla_marcaciones.compania, ''tipo_de_hora_domingo_tardanza'', ''37'', ''GET'');
    else
        lc_tipo_de_hora =   ''21'';
    end if;
            
    select into r_pla_horas * from pla_horas
    where id_marcaciones = r_pla_marcaciones.id
    and trim(tipo_de_hora) = trim(lc_tipo_de_hora);
    if not found and li_minutos_regulares > 0 then
        insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
            tasa_por_minuto, aplicar, acumula, forma_de_registro)
        values (r_pla_marcaciones.id, lc_tipo_de_hora,li_minutos_regulares, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'', ''A'');
    end if;    

    if r_pla_marcaciones.entrada_descanso is not null
        and r_pla_marcaciones.salida_descanso is not null
        and r_pla_empleados.compania = 1316 then
        
        li_minutos_regulares    =   f_intervalo(r_pla_marcaciones.entrada_descanso, r_pla_marcaciones.salida_descanso);
        
        if li_minutos_regulares > 60 then
            li_minutos_regulares    =   li_minutos_regulares - 60;

            insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                tasa_por_minuto, aplicar, acumula, forma_de_registro)
            values (r_pla_marcaciones.id, lc_tipo_de_hora,li_minutos_regulares, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'', ''A'');


        end if;
        
    end if;        

    ld_fecha    =   f_to_date(r_pla_marcaciones.entrada);
    if Trim(f_pla_parametros(r_pla_tarjeta_tiempo.compania, ''tardanza_dia_nacional'', ''N'', ''GET'')) = ''S'' then
        select into r_pla_dias_feriados *
        from pla_dias_feriados
        where compania = r_pla_tarjeta_tiempo.compania
        and tipo_de_salario = r_pla_empleados.tipo_de_salario
        and fecha = ld_fecha;
        if found then
            li_retorno  =   f_pla_horas(r_pla_marcaciones.id, r_pla_dias_feriados.tipo_de_hora, 
                                -li_minutos_regulares,
                                r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
        end if;
    end if;


    return li_minutos_regulares;
end;
' language plpgsql;



create function f_procesar_tarjeta(int4, char(7), date) returns boolean as '
declare
    a_cia alias for $1;
    a_codigo_empleado alias for $2;
    a_fecha alias for $3;
    r_pla_empleados record;
    r_pla_dias_feriados record;
    r_pla_vacaciones record;
    r_pla_riesgos_profesionales record;
begin
    select into r_pla_riesgos_profesionales * from pla_riesgos_profesionales
    where compania = a_cia
    and codigo_empleado = a_codigo_empleado
    and a_fecha between desde and hasta;
    if found then
        return false;
    end if;
    
    select into r_pla_vacaciones * from pla_vacaciones
    where compania = a_cia
    and codigo_empleado = a_codigo_empleado
    and status = ''A''
    and a_fecha between pagar_desde and pagar_hasta;
    if found then
        return false;
    end if;
    
    select into r_pla_empleados * from pla_empleados
    where compania = a_cia
    and codigo_empleado = a_codigo_empleado;
    
    if r_pla_empleados.fecha_inicio > a_fecha then
        return false;
    end if;

    if r_pla_empleados.fecha_terminacion_real is not null then
        if a_fecha > r_pla_empleados.fecha_terminacion_real then
            return false;
        end if;
    end if;
    
    if r_pla_empleados.status = ''I'' then
        return false;
    end if;
    
    return true;
end;
' language plpgsql;


create function f_pla_minutos_semanales(int4, timestamp) returns int4 as '
declare
    ai_id alias for $1;
    ats_hasta alias for $2;
    r_pla_marcaciones record;
    r_pla_tarjeta_tiempo record;
    r_pla_periodos record;
    r_pla_empleados record;
    lt_inicio_dia time;
    lt_fin_dia time;
    lts_desde timestamp;
    ld_work date;
    li_dow int4;
    li_dias int4;
    li_minutos int4;
begin

    lt_inicio_dia = ''00:00'';
    lt_fin_dia = ''23:59'';
    select into r_pla_marcaciones * from pla_marcaciones
    where id = ai_id;
    if r_pla_marcaciones.status = ''I'' then
        return 0;
    end if;
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    
    select into r_pla_periodos * from pla_periodos
    where id = r_pla_tarjeta_tiempo.id_periodos;
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;
    
    if r_pla_periodos.tipo_de_planilla = ''1'' then
        lts_desde = f_timestamp(r_pla_periodos.desde, lt_inicio_dia);
--    elsif r_pla_periodos.tipo_de_planilla = ''3'' then
--        lts_desde = f_timestamp(r_pla_periodos.desde, lt_inicio_dia);
    else 
        li_dow = extract(dow from ats_hasta);
        if li_dow > 1 then
            li_dias = -li_dow + 1;
        elsif li_dow = 0 then
            li_dias = -6;
        else
            li_dias = 0;
        end if;
        
        ld_work = ats_hasta;
        ld_work = f_relative_dmy(''DIA'', ld_work, li_dias);
        lts_desde = f_timestamp(ld_work, lt_inicio_dia);
    end if;
    
    li_minutos = 0;
    select sum(pla_horas.minutos) into li_minutos from pla_horas, pla_marcaciones, pla_tipos_de_horas, pla_tarjeta_tiempo
    where pla_horas.id_marcaciones = pla_marcaciones.id
    and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
    and pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
    and pla_marcaciones.entrada between lts_desde and ats_hasta
    and acumula = ''S''
    and pla_tipos_de_horas.recargo > 1
    and pla_tipos_de_horas.signo > 0
    and pla_tarjeta_tiempo.compania = r_pla_empleados.compania
    and pla_tarjeta_tiempo.codigo_empleado = r_pla_empleados.codigo_empleado;

    if li_minutos is null then
        li_minutos = 0;
    end if;
    
    return li_minutos;
end;
' language plpgsql;



create function f_pla_minutos_diarios(int4, timestamp) returns int4 as '
declare
    ai_id alias for $1;
    ats_hasta alias for $2;
    r_pla_marcaciones record;
    r_pla_tarjeta_tiempo record;
    r_pla_periodos record;
    r_pla_empleados record;
    lt_inicio_dia time;
    lt_fin_dia time;
    lts_desde timestamp;
    ld_work date;
    li_dow int4;
    li_dias int4;
    li_minutos int4;
begin

    lt_inicio_dia = ''00:00'';
    lt_fin_dia = ''23:59'';
    select into r_pla_marcaciones * from pla_marcaciones
    where id = ai_id;
    if r_pla_marcaciones.status = ''I'' then
        return 0;
    end if;
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    
    select into r_pla_periodos * from pla_periodos
    where id = r_pla_tarjeta_tiempo.id_periodos;
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;
    
    li_minutos = 0;
    select sum(pla_horas.minutos) into li_minutos from pla_horas, pla_marcaciones, pla_tipos_de_horas, pla_tarjeta_tiempo
    where pla_horas.id_marcaciones = pla_marcaciones.id
    and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
    and pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
    and pla_marcaciones.id = ai_id
    and acumula = ''S''
    and pla_tipos_de_horas.recargo > 1
    and pla_tipos_de_horas.signo > 0
    and pla_tarjeta_tiempo.compania = r_pla_empleados.compania
    and pla_tarjeta_tiempo.codigo_empleado = r_pla_empleados.codigo_empleado;
    
    if li_minutos is null then
        li_minutos = 0;
    end if;
    
    return li_minutos;
end;
' language plpgsql;



create function f_pla_horas(int4, char(2), int4, decimal, char(1), char(1)) returns integer as '
declare
    ai_id_marcaciones alias for $1;
    as_tipo_de_hora alias for $2;
    ai_minutos alias for $3;
    adc_tasa_por_minuto alias for $4;
    as_aplicar alias for $5;
    as_acumula alias for $6;
    r_pla_horas record;
    r_pla_marcaciones record;
    r_pla_tipos_de_horas record;
    ls_tipo_de_hora char(2);
    ldc_maximo_recargo decimal;
begin
/*
    if ai_minutos is null then
        return 0;
    end if;
*/    
    
    ls_tipo_de_hora = as_tipo_de_hora;
    select into r_pla_marcaciones *
    from pla_marcaciones
    where id = ai_id_marcaciones;
    if not found then
        return 0;
    end if;

    ldc_maximo_recargo   =   cast(f_pla_parametros(r_pla_marcaciones.compania, ''maximo_recargo'',''100'',''GET'') as decimal);

/*    
    if r_pla_marcaciones.status = ''C'' and as_tipo_de_hora = ''91'' then
        return 0;
    end if;
*/
    
    select into r_pla_horas * from pla_horas
    where id_marcaciones = ai_id_marcaciones
    and tipo_de_hora = ls_tipo_de_hora
    and forma_de_registro = ''M'';
    if found then
        return 0;
    end if;
  
    select into r_pla_horas * from pla_horas
    where id_marcaciones = ai_id_marcaciones
    and tipo_de_hora = ls_tipo_de_hora;
    if not found then
        insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
            tasa_por_minuto, aplicar, acumula, forma_de_registro)
        values (ai_id_marcaciones, ls_tipo_de_hora, ai_minutos, adc_tasa_por_minuto, as_aplicar, as_acumula, ''A'');
    else
        update pla_horas
        set minutos = minutos + ai_minutos
        where id_marcaciones = ai_id_marcaciones
        and tipo_de_hora = ls_tipo_de_hora;
    end if;
    
    return 1;
end;
' language plpgsql;
