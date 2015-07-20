

set search_path to planilla;


-- drop function f_insertar_pla_marcaciones_apra(int4, char(7), int4, int4, char(20), date, time, time, time, time, time, time, char(1)) cascade;

-- drop function f_insertar_pla_marcaciones_apra(int4, char(7), int4, int4, char(20), date, time, time, char(5), char(5), char(5), char(5), char(1)) cascade;
-- drop function f_insertar_pla_marcaciones_apra(int4, char(7), int4, int4, char(20), date, time, time, time, time, time, time, char(1)) cascade;
-- drop function f_insertar_pla_marcaciones_apra(int4, char(7), int4, int4, char(20), date, time without time zone, time without time zone, char(3), time without time zone, time without time zone, time without time zone, time without time zone, char(1)) cascade;
drop function f_insertar_pla_marcaciones_apra(int4, char(7), int4, int4, int4, date, time with time zone, time with time zone, varchar(30), time with time zone, time with time zone, time with time zone, time with time zone, char(1)) cascade;


create function f_insertar_pla_marcaciones_apra(int4, char(7), int4, int4, int4, date, time with time zone, time with time zone, varchar(30), time with time zone, time with time zone, time with time zone, time with time zone, char(1)) returns int4 as '
declare
    ai_cia alias for $1;
    ac_codigo_empleado alias for $2;
    ai_numero_planilla alias for $3;
    ai_turno alias for $4;
    ai_id_pla_proyectos alias for $5;
    ad_fecha alias for $6;
    at_entrada1 alias for $7;
    at_salida1 alias for $8;
    ac_implemento alias for $9;
    at_entrada2 alias for $10;
    at_salida2 alias for $11;
    at_entrada3 alias for $12;
    at_salida3 alias for $13;
    ac_status alias for $14;    
    lt_entrada1 time;
    lt_salida1 time;
    lt_entrada2 time;
    lt_salida2 time;
    lt_entrada3 time;
    lt_salida3 time;
    lt_inicio_descanso time;
    lt_fin_descanso time;
    lt_desde time;
    lt_hasta time;
    r_pla_tarjeta_tiempo record;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_tipos_de_planilla record;
    r_pla_periodos record;
    r_pla_proyectos record;
    r_pla_certificados_medico record;
    r_pla_eventos record;
    r_pla_turnos record;
    r_pla_vacaciones record;
    r_pla_implementos record;
    r_pla_reloj_01 record;
    ld_fecha date;
    ld_work date;
    ld_work2 date;
    li_turno int4;
    li_work int4;
    li_id_pla_proyectos int4;
    lc_autorizado char(1);
    lc_utilizan_reloj char(1);
    lc_respetar_horarios char(1);
    lc_status char(1);
    lc_implemento char(3);
    lts_inicio_descanso timestamp;
    lts_fin_descanso timestamp;
    lts_salida timestamp;
    lts_entrada timestamp;
    lts_desde timestamp;
    lts_hasta timestamp;
begin
    select into r_pla_empleados *
    from pla_empleados
    where compania = ai_cia
    and trim(codigo_empleado) = trim(ac_codigo_empleado);
    if not found then
        return 0;
    end if;

    
    if r_pla_empleados.status = ''E'' or r_pla_empleados.status = ''I'' then
        return 0;
    end if;
    
    li_turno = ai_turno;
    select into r_pla_turnos *
    from pla_turnos
    where compania = ai_cia
    and turno = li_turno;
    if not found then
        Raise Exception ''Turno % no Existe...Verifique'', ai_turno;
    end if;

    select into r_pla_vacaciones *
    from pla_vacaciones
    where compania = ai_cia
    and codigo_empleado = ac_codigo_empleado
    and status = ''A''
    and ad_fecha between pagar_desde and pagar_hasta;
    if found then
        Raise Exception ''Empleado % esta de vacaciones...Verifique'', ac_codigo_empleado;
        return 0;
    end if;

/*    
    select into r_pla_proyectos *
    from pla_proyectos
    where compania = r_pla_empleados.compania
    and trim(proyecto) = trim(ac_proyecto);
    if not found  then
        select into r_pla_proyectos *
        from pla_proyectos
        where compania = r_pla_empleados.compania
        order by id limit 1;
    end if;
*/    

    li_id_pla_proyectos =   ai_id_pla_proyectos;
    select into r_pla_proyectos * from pla_proyectos
    where id = li_id_pla_proyectos
    and compania = ai_cia;
    if not found then
        li_id_pla_proyectos =   r_pla_empleados.id_pla_proyectos;
--        Raise Exception ''Proyecto no Existe...Verifique...'';

        select into r_pla_proyectos * from pla_proyectos
        where id = li_id_pla_proyectos;
    end if;
    
    select into r_pla_tipos_de_planilla *
    from pla_tipos_de_planilla
    where compania = r_pla_empleados.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla;
    if not found then
        return 0;
    end if;

    select into r_pla_periodos *
    from pla_periodos
    where compania = r_pla_empleados.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and year = 2015
    and numero_planilla = ai_numero_planilla;
    if not found then
        Raise Exception ''Numero de Planilla % no Existe'', ai_numero_planilla;
        return 0;
    end if;

    if r_pla_periodos.status = ''C'' then
        Raise Exception ''% Numero de Planilla % esta cerrado...Verifique'', r_pla_empleados.codigo_empleado, ai_numero_planilla;
        return 0;
    end if;        
    
    lc_autorizado           =   Trim(f_pla_parametros(ai_cia, ''autorizado_default'',''N'',''GET''));
    lc_utilizan_reloj       =   Trim(f_pla_parametros(ai_cia, ''utilizan_reloj'',''N'',''GET''));
    lc_respetar_horarios    =   Trim(f_pla_parametros(ai_cia, ''respetar_horarios'', ''S'', ''GET''));
    lc_status               =   ac_status;

    select into r_pla_tarjeta_tiempo *
    from pla_tarjeta_tiempo
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and id_periodos = r_pla_periodos.id;
    if not found then
        insert into pla_tarjeta_tiempo (compania, codigo_empleado, id_periodos)
        values (ai_cia, r_pla_empleados.codigo_empleado, r_pla_periodos.id);

        select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
        where compania = ai_cia
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and id_periodos = r_pla_periodos.id;
        
    end if;

    ld_fecha            =   ad_fecha;
    lt_inicio_descanso  =   r_pla_turnos.hora_inicio_descanso;
    lt_fin_descanso     =   r_pla_turnos.hora_salida_descanso;
    lt_entrada1         =   at_entrada1;
    lt_salida1          =   at_salida1;

    
    if lt_entrada1 is null then
        lt_entrada1 = r_pla_turnos.hora_inicio;
    end if;
    
    if lt_salida1 is null then
        lt_salida1 = r_pla_turnos.hora_salida;
    end if;                
    

    lts_entrada =   f_timestamp(ld_fecha, lt_entrada1);
    if lt_salida1 < lt_entrada1 then
        lts_salida  =   f_timestamp((ld_fecha+1),lt_salida1);
    else
        lts_salida  =   f_timestamp(ld_fecha,lt_salida1);
    end if;
    
    lts_inicio_descanso  =   f_timestamp(ld_fecha, lt_inicio_descanso);
    lts_fin_descanso    =   f_timestamp(ld_fecha, lt_fin_descanso);

    
    select into r_pla_marcaciones * from pla_marcaciones
    where compania = ai_cia
    and id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
    and date(entrada) = ld_fecha;
    if not found then
        insert into pla_marcaciones (id_tarjeta_de_tiempo, compania,
            turno, entrada, salida, entrada_descanso, salida_descanso, status, autorizado, id_pla_proyectos)
        values (r_pla_tarjeta_tiempo.id, ai_cia, li_turno, lts_entrada,
            lts_salida, lts_inicio_descanso, lts_fin_descanso, lc_status, lc_autorizado, r_pla_proyectos.id);
    else
        update pla_marcaciones
        set entrada = lts_entrada,
            salida = lts_salida, 
            turno = li_turno,
            entrada_descanso = lts_inicio_descanso,
            salida_descanso = lts_fin_descanso,
            id_pla_proyectos = r_pla_proyectos.id,
            status = lc_status,
            autorizado = lc_autorizado
        where id = r_pla_marcaciones.id;
    end if;


    

    if at_entrada2 is not null and at_salida2 is not null then

/*
        lt_desde    =   Cast(at_entrada2 as time);
        lt_hasta    =   Cast(at_salida2 as time);
*/        


        lt_desde    =   at_entrada2;
        lt_hasta    =   at_salida2;

        lts_desde =   f_timestamp(ld_fecha, lt_desde);
        
        if lt_hasta < lt_desde then
            lts_hasta  =   f_timestamp((ld_fecha+1), lt_hasta);
        else
            lts_hasta  =   f_timestamp(ld_fecha, lt_hasta);
        end if;

        select into r_pla_eventos *
        from pla_eventos
        where compania = r_pla_empleados.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and trim(implemento) = ''04''
        and Date(desde) = ld_fecha;
        if found then
            update pla_eventos
            set desde = lts_desde, hasta = lts_hasta
            where id = r_pla_eventos.id;
        else
            insert into pla_eventos(compania, codigo_empleado, implemento,
                desde, hasta)
            values(r_pla_empleados.compania, r_pla_empleados.codigo_empleado, ''04'',
                lts_desde, lts_hasta);
        end if;            
    end if;
    
    if at_entrada3 is not null and at_salida3 is not null then

        lt_desde    =   Cast(at_entrada3 as time);
        lt_hasta    =   Cast(at_salida3 as time);

        lts_desde =   f_timestamp(ld_fecha, lt_desde);
        
        if lt_hasta < lt_desde then
            lts_hasta  =   f_timestamp((ld_fecha+1), lt_hasta);
        else
            lts_hasta  =   f_timestamp(ld_fecha, lt_hasta);
        end if;

        select into r_pla_eventos *
        from pla_eventos
        where compania = r_pla_empleados.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and trim(implemento) = ''25''
        and Date(desde) = ld_fecha;
        if found then
            update pla_eventos
            set desde = lts_desde, hasta = lts_hasta
            where id = r_pla_eventos.id;
        else
            insert into pla_eventos(compania, codigo_empleado, implemento,
                desde, hasta)
            values(r_pla_empleados.compania, r_pla_empleados.codigo_empleado, ''25'',
                lts_desde, lts_hasta);
        end if;            
    end if;
    

    return r_pla_marcaciones.id;
end;
' language plpgsql;
