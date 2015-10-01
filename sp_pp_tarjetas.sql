set search_path to planilla;

drop function f_pla_reasignacion_de_turno(int4, char(7), date, date, int4, int4) cascade;
drop function f_pla_reasignacion_de_turno(int4, char(7), date, date, int4, time, time, time, time) cascade;
drop function f_pla_asignacion_de_dia_libre(int4, char(7), date, date) cascade;
drop function f_pla_crear_tarjetas_de_tiempo(int4, char(2)) cascade;
drop function f_crear_tarjeta(int4, char(7), date, int4) cascade;
drop function f_insertar_pla_marcaciones(int4, char(7), int4, int4, int4, timestamp, timestamp, timestamp, timestamp) cascade;
drop function f_insertar_pla_marcaciones(int4, char(7), int4, int4, int4, timestamp, timestamp, timestamp, timestamp, char(1)) cascade;
drop function f_procesar_reloj(int4, date, date) cascade;
drop function f_poner_ausencias(int4, char(2)) cascade;


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
    li_id int4;
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
            select into li_id Max(id) from pla_eventos;
            li_id = li_id + 1;
            insert into pla_eventos(id, compania, codigo_empleado, implemento, desde, hasta)
            values(li_id, r_pla_empleados.compania, r_pla_empleados.codigo_empleado, ''04'',
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
            select into li_id Max(id) from pla_eventos;
            li_id = li_id + 1;
            insert into pla_eventos(id, compania, codigo_empleado, implemento,
                desde, hasta)
            values(li_id, r_pla_empleados.compania, r_pla_empleados.codigo_empleado, ''25'',
                lts_desde, lts_hasta);
        end if;            
    end if;
    

    return r_pla_marcaciones.id;
end;
' language plpgsql;



create function f_poner_ausencias(int4, char(2)) returns integer as '
declare
    ai_cia alias for $1;
    as_tipo_de_planilla alias for $2;
    r_pla_tipos_de_planilla record;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_marcaciones record;
    r_pla_reloj_01 record;
    r_pla_dias_feriados record;
    r_bitacora record;
    i integer;
    lb_procesar boolean;
    ld_work date;
begin
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

--                            and status in (''A'', ''V'')
--                            and fecha_terminacion_real is null

    for r_pla_empleados in select * from pla_empleados
                            where compania = ai_cia
                            and tipo_de_planilla = as_tipo_de_planilla
                            and reloj is true
                            and codigo_empleado in (''0924'')
                            order by codigo_empleado
    loop
        for r_pla_marcaciones in select pla_marcaciones.* 
                                    from pla_marcaciones, pla_tarjeta_tiempo
                                    where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
                                    and pla_tarjeta_tiempo.compania = r_pla_empleados.compania
                                    and pla_tarjeta_tiempo.codigo_empleado = r_pla_empleados.codigo_empleado
                                    and pla_tarjeta_tiempo.id_periodos = r_pla_periodos.id
                                    and f_to_date(pla_marcaciones.entrada) <= r_pla_periodos.hasta
                                    order by pla_marcaciones.id
        loop
            ld_work =   f_to_date(r_pla_marcaciones.entrada);
            
            select into r_bitacora *
            from bitacora
            where trim(tabla) = ''pla_marcaciones''
            and id_tabla = r_pla_marcaciones.id
            and trim(operacion) = ''UPDATE'';
            if found then
                continue;
            end if;
            
            select into r_pla_dias_feriados *
            from pla_dias_feriados
            where compania = r_pla_empleados.compania
            and fecha = ld_work;
            if found then
                continue;
            end if;
            if r_pla_empleados.compania = 1261 
                and extract(dow from r_pla_marcaciones.entrada) = 0 then
                update pla_marcaciones
                set status = ''L''
                where id = r_pla_marcaciones.id;
            else        
                select into r_pla_reloj_01 *
                from pla_reloj_01
                where compania = r_pla_empleados.compania
                and trim(codigo_reloj) = trim(r_pla_empleados.codigo_empleado)
                and trim(to_char(r_pla_marcaciones.entrada, ''yyyy-mm-dd'')) = trim(to_char(pla_reloj_01.fecha,''yyyy-mm-dd''));
                if not found then
                    update pla_marcaciones
                    set status = ''I''
                    where id = r_pla_marcaciones.id;
                end if;
            end if;
        end loop;
    end loop;
    
    
    
    return 1;
end;
' language plpgsql;


create function f_procesar_reloj(int4, date, date) returns integer as '
declare
    ai_cia alias for $1;
    ad_desde alias for $2;
    ad_hasta alias for $3;
    r_pla_reloj_01 record;
    r_pla_marcaciones record;
begin

    for r_pla_reloj_01 in select * from pla_reloj_01
                            where compania = ai_cia
                            and fecha between ad_desde and ad_hasta
                            order by id 
    loop
        select into r_pla_marcaciones pla_marcaciones.*
        from pla_marcaciones, pla_tarjeta_tiempo, pla_periodos
        where pla_periodos.id = pla_tarjeta_tiempo.id_periodos
        and pla_periodos.status = ''A''
        and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
        and pla_tarjeta_tiempo.compania = r_pla_reloj_01.compania
        and trim(pla_tarjeta_tiempo.codigo_empleado) = trim(r_pla_reloj_01.codigo_reloj)
        and pla_marcaciones.status = ''I''
        and trim(to_char(pla_marcaciones.entrada, ''yyyy-mm-dd'')) = trim(to_char(r_pla_reloj_01.fecha,''yyyy-mm-dd''));
        if found then
            update pla_marcaciones
            set status = ''R''
            where id = r_pla_marcaciones.id;
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;



create function f_insertar_pla_marcaciones(int4, char(7), int4, int4, int4, timestamp, timestamp, timestamp, timestamp, char(1)) returns int4 as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    ai_id_pla_proyectos alias for $4;
    ai_turno alias for $5;
    ats_entrada alias for $6;
    ats_salida alias for $7;
    ats_entrada_descanso alias for $8;
    ats_salida_descanso alias for $9;
    as_status alias for $10;
    r_pla_tarjeta_tiempo record;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_tipos_de_planilla record;
    r_pla_periodos record;
    r_pla_proyectos record;
    r_pla_turnos record;
    r_pla_vacaciones record;
    r_pla_reloj_01 record;
    r_pla_horarios record;
    ld_fecha date;
    ld_work date;
    ld_work2 date;
    li_turno int4;
    li_work int4;
    lc_autorizado char(1);
    lc_utilizan_reloj char(1);
    lc_respetar_horarios char(1);
    lc_status char(1);
    lts_entrada_descanso timestamp;
    lts_salida_descanso timestamp;
    lts_salida timestamp;
    lts_entrada_turno timestamp;
    lt_hora_inicio time;
    lt_hora_salida time;
    li_dow integer;
begin

--    raise exception ''entre'';
    
    
    if ats_entrada is null or ats_salida is null then
        return 0;
    end if;
    
    if ats_entrada = ats_salida then
        return 0;
    end if;

    
    lt_hora_inicio          =   ats_entrada;
    lt_hora_salida          =   ats_salida;
    
    lc_autorizado           =   Trim(f_pla_parametros(ai_cia, ''autorizado_default'',''N'',''GET''));
    lc_utilizan_reloj       =   Trim(f_pla_parametros(ai_cia, ''utilizan_reloj'',''N'',''GET''));
    lc_respetar_horarios    =   Trim(f_pla_parametros(ai_cia, ''respetar_horarios'', ''S'', ''GET''));
    lc_status               =   ''R'';


--    raise exception ''entre 2 % %'',as_codigo_empleado, ats_salida;
    
    select into r_pla_empleados *
    from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;

    
    if r_pla_empleados.status = ''E'' or r_pla_empleados.status = ''I'' then
        return 0;
    end if;
    

/*    
    if r_pla_empleados.reloj is false then
        return 0;
    end if;
*/
    
    select into r_pla_tipos_de_planilla *
    from pla_tipos_de_planilla
    where compania = r_pla_empleados.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla;
    if not found then
        return 0;
    end if;
    
    ld_work     = ats_entrada;
    ld_work2    = ats_entrada;

    
/*    
    if trim(as_codigo_empleado) = ''0021'' and ld_work = ''2013-10-09'' then
        raise exception ''% %'', ats_entrada, ats_salida;
    end if;
*/    

    
    select into r_pla_periodos *
    from pla_periodos
    where compania = ai_cia
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and ld_work between desde and hasta
    and status = ''C'';
    if found then
        return 0;
    end if;


  /*                      
  if r_pla_empleados.compania = 754 and r_pla_empleados.codigo_empleado = ''0020''
        and ld_work = ''2012-06-26''  then
        raise exception ''entre 2'';
  end if;
*/
    
    
    select into r_pla_vacaciones *
    from pla_vacaciones
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and status = ''A''
    and ld_work between pagar_desde and pagar_hasta;
    if found then
        return 0;
    end if;
    
    
    select into r_pla_periodos *
    from pla_periodos
    where id = ai_id_periodos;
    if not found or ai_id_periodos is null then    
        select into r_pla_periodos *
        from pla_periodos
        where compania = r_pla_tipos_de_planilla.compania
        and tipo_de_planilla = r_pla_tipos_de_planilla.tipo_de_planilla
        and numero_planilla = r_pla_tipos_de_planilla.planilla_actual
        and status = ''A'';
        if not found then
            raise exception ''No existe periodo % abierto'',r_pla_tipos_de_planilla.planilla_actual;
        end if;
    else
        select into r_pla_periodos *
        from pla_periodos
        where id = ai_id_periodos;
        if not found then
            raise exception ''Periodo % no Existe...Verifique'',ai_id_periodos;
        end if;
    end if;


    if r_pla_empleados.tipo_de_salario = ''H'' and ld_work > r_pla_periodos.hasta then
        return 0;
    end if;        

    
    if ai_id_pla_proyectos is null then
        select into r_pla_proyectos *
        from pla_proyectos
        where id = r_pla_empleados.id_pla_proyectos;
    else
        select into r_pla_proyectos *
        from pla_proyectos
        where id = ai_id_pla_proyectos;
        if not found then
            select into r_pla_proyectos *
            from pla_proyectos
            where id = r_pla_empleados.id_pla_proyectos;
        end if;
    end if;
  
    
    select into r_pla_tarjeta_tiempo *
    from pla_tarjeta_tiempo
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and id_periodos = r_pla_periodos.id;
    if not found then
        insert into pla_tarjeta_tiempo (compania, codigo_empleado, id_periodos)
        values (ai_cia, r_pla_empleados.codigo_empleado, r_pla_periodos.id);

        select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
        where compania = ai_cia
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and id_periodos = r_pla_periodos.id;
        
    end if;
    lts_entrada_descanso    = ats_entrada_descanso;
    lts_salida_descanso     = ats_salida_descanso;
    lts_salida              = ats_salida;

/*
    if lts_entrada_descanso < ats_entrada then
        lts_entrada_descanso = lts_entrada_descanso + interval ''1 day'';
    end if;

    if ats_entrada > lts_entrada_descanso 
        or ats_entrada > lts_salida_descanso 
        or lts_entrada_descanso > lts_salida_descanso 
        or lts_salida_descanso > ats_salida then
        lts_entrada_descanso = null;
        lts_salida_descanso = null;
    end if;
    
    if ats_entrada > lts_salida then
        lts_salida = lts_salida + interval ''1 day'';
    end if;
*/

    ld_fecha = date(ats_entrada);
    select into r_pla_marcaciones * from pla_marcaciones
    where compania = ai_cia
    and id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
    and date(entrada) = ld_fecha;
    if not found then
        if trim(lc_respetar_horarios) = ''S'' then
            li_turno                =   f_turno_asignado(ai_cia, as_codigo_empleado, ld_fecha);
--            lts_entrada_descanso    =   null;
--            lts_salida_descanso     =   null;
        else
            if ai_cia = 992 then
                li_turno = null;
                
            elsif ai_cia = 1075 then
                select into r_pla_turnos * from pla_turnos
                    where compania = ai_cia
                    and hora_inicio =   lt_hora_inicio
                    order by turno;
                if found then
                    li_turno    =   r_pla_turnos.turno;
                else
--                    li_turno = f_turno_asignado(ai_cia, as_codigo_empleado, ld_fecha);
                    li_turno    =   null;
                end if;
            
            else
                li_turno = f_turno_asignado(ai_cia, as_codigo_empleado, ld_fecha);
--                li_turno                =   r_pla_marcaciones.turno;
            end if;
        end if;
        

        select into r_pla_turnos * from pla_turnos
        where compania = ai_cia
        and turno = li_turno;
        if not found then
            li_turno = null;
        end if;

        if li_turno is null and ai_turno is not null then
            li_turno = ai_turno;
        end if;            
    
    
        if lts_salida > ats_entrada then
            if Trim(lc_utilizan_reloj) = ''S'' and r_pla_empleados.reloj is true then
                select into r_pla_vacaciones *
                from pla_vacaciones
                where compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and ld_work2 between pagar_desde and pagar_hasta;
                if found then
                    lc_status   =   ''L'';
                else
                    lc_status   =   ''I'';
                end if;
            else
                lc_status   =   ''R'';
            end if;
            
            if as_status = ''L'' or as_status = ''D'' or as_status = ''F'' then
                lc_status = as_status;
            end if;
            
            
            li_dow = extract(dow from ats_entrada);
            select into r_pla_horarios * 
            from pla_horarios
            where compania = ai_cia
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and dia = li_dow;
            if not found then
                lc_status = ''L'';
                if Trim(lc_utilizan_reloj) = ''S'' and r_pla_empleados.reloj is true
                    and as_status = ''R'' then
                    lc_status = ''R'';
                end if;
            end if;

--            raise exception ''status %'', lc_status;
            
            insert into pla_marcaciones (id_tarjeta_de_tiempo, compania,
                turno, entrada, salida, entrada_descanso, salida_descanso, status, autorizado, id_pla_proyectos)
            values (r_pla_tarjeta_tiempo.id, ai_cia, li_turno, ats_entrada,
                lts_salida, lts_entrada_descanso, lts_salida_descanso, lc_status, lc_autorizado, r_pla_proyectos.id);
        else
            return 0;
        end if;
        
        select into r_pla_marcaciones * from pla_marcaciones
        where compania = ai_cia
        and id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
        and date(entrada) = ld_fecha;
    else
        if trim(lc_respetar_horarios) = ''S'' then
            li_turno                =   r_pla_marcaciones.turno;
            select into r_pla_turnos * from pla_turnos
            where compania = ai_cia
            and turno = li_turno;
            if not found then
                li_turno = null;
            end if;

            lts_entrada_turno   =   f_timestamp(Date(r_pla_marcaciones.entrada), r_pla_turnos.hora_inicio);
            li_work             =   f_intervalo(ats_entrada, lts_entrada_turno);
            
            if lts_salida > ats_entrada then
                if li_work > 180 then
                    update pla_marcaciones
                    set salida = lts_salida, 
                        turno = li_turno,
                        entrada_descanso = null,
                        salida_descanso = null,
                        status = as_status,
                        id_pla_proyectos = r_pla_proyectos.id
                    where id = r_pla_marcaciones.id;
                else
                    update pla_marcaciones
                    set entrada = ats_entrada, salida = lts_salida, 
                        turno = li_turno,
                        status = as_status,
                        entrada_descanso = null,
                        salida_descanso = null,
                        id_pla_proyectos = r_pla_proyectos.id
                    where id = r_pla_marcaciones.id;
                end if;                    
            end if;

            if ats_entrada_descanso is not null and ats_salida_descanso is not null then
                if lts_entrada_descanso > ats_entrada then
                    update pla_marcaciones
                    set entrada_descanso = lts_entrada_descanso,
                        salida_descanso = lts_salida_descanso,
                        status = as_status
                    where id = r_pla_marcaciones.id;
                end if;
            end if;
        else
            if ai_cia = 1075 then
                
                select into r_pla_turnos * from pla_turnos
                    where compania = ai_cia
                    and hora_inicio =   lt_hora_inicio
                    and hora_salida = lt_hora_salida
                    order by turno;
                if not found then
                    select into r_pla_turnos * from pla_turnos
                        where compania = ai_cia
                        and hora_inicio =   lt_hora_inicio
                        order by turno;
                    if found then
                        li_turno    =   r_pla_turnos.turno;
                    else
    --                    li_turno = f_turno_asignado(ai_cia, as_codigo_empleado, ld_fecha);
                        li_turno    =   null;
                    end if;
                else
                    li_turno    =   r_pla_turnos.turno;
                end if;
                
                update pla_marcaciones
                set entrada = ats_entrada, salida = lts_salida, 
                    entrada_descanso = lts_entrada_descanso,
                    salida_descanso = lts_salida_descanso, turno = li_turno,
                    status = as_status,
                    id_pla_proyectos = r_pla_proyectos.id
                where id = r_pla_marcaciones.id;

            else
                update pla_marcaciones
                set entrada = ats_entrada, salida = lts_salida, 
                    entrada_descanso = lts_entrada_descanso,
                    salida_descanso = lts_salida_descanso, turno = li_turno,
                    status = as_status,
                    id_pla_proyectos = r_pla_proyectos.id
                where id = r_pla_marcaciones.id;
            end if;                
        end if;

        if Trim(lc_utilizan_reloj) = ''S'' and r_pla_empleados.reloj is true 
            and r_pla_marcaciones.status = ''I'' then

            update pla_marcaciones
            set status = as_status
            where id = r_pla_marcaciones.id;

        end if;
    
    end if;
    
    return r_pla_marcaciones.id;
end;
' language plpgsql;



create function f_insertar_pla_marcaciones(int4, char(7), int4, int4, int4, timestamp, timestamp, timestamp, timestamp) returns int4 as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    ai_id_pla_proyectos alias for $4;
    ai_turno alias for $5;
    ats_entrada alias for $6;
    ats_salida alias for $7;
    ats_entrada_descanso alias for $8;
    ats_salida_descanso alias for $9;
    r_pla_tarjeta_tiempo record;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_tipos_de_planilla record;
    r_pla_periodos record;
    r_pla_proyectos record;
    r_pla_certificados_medico record;
    r_pla_turnos record;
    r_pla_vacaciones record;
    r_pla_reloj_01 record;
    r_pla_horarios record;
    ld_fecha date;
    ld_work date;
    ld_work2 date;
    li_turno int4;
    li_work int4;
    lc_autorizado char(1);
    lc_utilizan_reloj char(1);
    lc_respetar_horarios char(1);
    lc_status char(1);
    lts_entrada_descanso timestamp;
    lts_salida_descanso timestamp;
    lts_salida timestamp;
    lts_entrada_turno timestamp;
    li_dow integer;
begin
    
    if f_intervalo(ats_entrada, ats_salida) <= 7 then
        return 0;
    end if;
    
    if ats_entrada is null or ats_salida is null then
        return 0;
    end if;
    
    if ats_entrada = ats_salida then
        return 0;
    end if;

    
    lc_autorizado           =   Trim(f_pla_parametros(ai_cia, ''autorizado_default'',''N'',''GET''));
    lc_utilizan_reloj       =   Trim(f_pla_parametros(ai_cia, ''utilizan_reloj'',''N'',''GET''));
    lc_respetar_horarios    =   Trim(f_pla_parametros(ai_cia, ''respetar_horarios'', ''S'', ''GET''));
    lc_status               =   ''R'';


--    raise exception ''status %'', ats_entrada;
    
    select into r_pla_empleados *
    from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;

    
    if r_pla_empleados.status = ''E'' or r_pla_empleados.status = ''I'' then
        return 0;
    end if;

/*    
    if r_pla_empleados.reloj is false then
        return 0;
    end if;
*/
    
    select into r_pla_tipos_de_planilla *
    from pla_tipos_de_planilla
    where compania = r_pla_empleados.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla;
    if not found then
        return 0;
    end if;

    
    ld_work     = ats_entrada;
    ld_work2    = ats_entrada;



    select into r_pla_certificados_medico *
    from pla_certificados_medico
    where compania = ai_cia
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and fecha = ld_work;
    if not found then
        select into r_pla_periodos *
        from pla_periodos
        where compania = ai_cia
        and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
        and ld_work between desde and hasta
        and status = ''C'';
        if found then
            Raise Exception ''Periodo para esta fecha % esta cerrado Empleado %'',ld_work, r_pla_empleados.codigo_empleado;
            return 0;
        end if;
    end if;

/*
    if Trim(as_codigo_empleado) = ''0012'' and ld_work >= ''2015-04-26'' then
        Raise Exception ''entre insertar %'', ld_work;
    end if;
*/

  /*                      
  if r_pla_empleados.compania = 754 and r_pla_empleados.codigo_empleado = ''0020''
        and ld_work = ''2012-06-26''  then
        raise exception ''entre 2'';
  end if;
*/
    
    
    select into r_pla_vacaciones *
    from pla_vacaciones
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and status = ''A''
    and ld_work between pagar_desde and pagar_hasta;
    if found then
        return 0;
    end if;

    
    select into r_pla_periodos *
    from pla_periodos
    where id = ai_id_periodos;
    if not found or ai_id_periodos is null then    
        select into r_pla_periodos *
        from pla_periodos
        where compania = r_pla_tipos_de_planilla.compania
        and tipo_de_planilla = r_pla_tipos_de_planilla.tipo_de_planilla
        and numero_planilla = r_pla_tipos_de_planilla.planilla_actual
        and status = ''A'';
        if not found then
            raise exception ''No existe periodo % abierto'',r_pla_tipos_de_planilla.planilla_actual;
        end if;
    else
        select into r_pla_periodos *
        from pla_periodos
        where id = ai_id_periodos;
        if not found then
            raise exception ''Periodo % no Existe...Verifique'',ai_id_periodos;
        end if;
    end if;
    
    if r_pla_empleados.tipo_de_salario = ''H'' and ld_work > r_pla_periodos.hasta then
        return 0;
    end if;        
    
    if ai_id_pla_proyectos is null then
        select into r_pla_proyectos *
        from pla_proyectos
        where id = r_pla_empleados.id_pla_proyectos;
    else
        select into r_pla_proyectos *
        from pla_proyectos
        where id = ai_id_pla_proyectos;
        if not found then
            select into r_pla_proyectos *
            from pla_proyectos
            where id = r_pla_empleados.id_pla_proyectos;
        end if;
    end if;
  
    
    select into r_pla_tarjeta_tiempo *
    from pla_tarjeta_tiempo
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and id_periodos = r_pla_periodos.id;
    if not found then
        insert into pla_tarjeta_tiempo (compania, codigo_empleado, id_periodos)
        values (ai_cia, r_pla_empleados.codigo_empleado, r_pla_periodos.id);

        select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
        where compania = ai_cia
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and id_periodos = r_pla_periodos.id;
        
    end if;
    lts_entrada_descanso    = ats_entrada_descanso;
    lts_salida_descanso     = ats_salida_descanso;
    lts_salida              = ats_salida;

/*
    if lts_entrada_descanso < ats_entrada then
        lts_entrada_descanso = lts_entrada_descanso + interval ''1 day'';
    end if;

    if ats_entrada > lts_entrada_descanso 
        or ats_entrada > lts_salida_descanso 
        or lts_entrada_descanso > lts_salida_descanso 
        or lts_salida_descanso > ats_salida then
        lts_entrada_descanso = null;
        lts_salida_descanso = null;
    end if;
    
    if ats_entrada > lts_salida then
        lts_salida = lts_salida + interval ''1 day'';
    end if;
*/

    ld_fecha = date(ats_entrada);
    select into r_pla_marcaciones * from pla_marcaciones
    where compania = ai_cia
    and id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
    and date(entrada) = ld_fecha;
    if not found then
        if trim(lc_respetar_horarios) = ''S'' then
            li_turno                =   f_turno_asignado(ai_cia, as_codigo_empleado, ld_fecha);
--            lts_entrada_descanso    =   null;
--            lts_salida_descanso     =   null;
        else
            if ai_cia = 992 then
                li_turno = null;
            else
                li_turno = f_turno_asignado(ai_cia, as_codigo_empleado, ld_fecha);
--                li_turno                =   r_pla_marcaciones.turno;
            end if;
        end if;
        

        select into r_pla_turnos * from pla_turnos
        where compania = ai_cia
        and turno = li_turno;
        if not found then
            li_turno = null;
        end if;
    
    
        if lts_salida > ats_entrada then
            if Trim(lc_utilizan_reloj) = ''S'' and r_pla_empleados.reloj is true then
                select into r_pla_vacaciones *
                from pla_vacaciones
                where compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and ld_work2 between pagar_desde and pagar_hasta;
                if found then
                    lc_status   =   ''L'';
                else
                    lc_status   =   ''I'';
                    if ld_work2 > r_pla_periodos.hasta then
                        lc_status = ''R'';
                    end if;
                end if;
            else
                lc_status   =   ''R'';
            end if;
            
            li_dow = extract(dow from ats_entrada);
            select into r_pla_horarios * 
            from pla_horarios
            where compania = ai_cia
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and dia = li_dow;
            if not found then
                lc_status = ''L'';
            end if;
            
            insert into pla_marcaciones (id_tarjeta_de_tiempo, compania,
                turno, entrada, salida, entrada_descanso, salida_descanso, status, autorizado, id_pla_proyectos)
            values (r_pla_tarjeta_tiempo.id, ai_cia, li_turno, ats_entrada,
                lts_salida, lts_entrada_descanso, lts_salida_descanso, lc_status, lc_autorizado, r_pla_proyectos.id);
        else
            return 0;
        end if;
        
        select into r_pla_marcaciones * from pla_marcaciones
        where compania = ai_cia
        and id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
        and date(entrada) = ld_fecha;
    else
        if trim(lc_respetar_horarios) = ''S'' then
            li_turno                =   r_pla_marcaciones.turno;
            select into r_pla_turnos * from pla_turnos
            where compania = ai_cia
            and turno = li_turno;
            if not found then
                li_turno = null;
            end if;

            lts_entrada_turno   =   f_timestamp(Date(r_pla_marcaciones.entrada), r_pla_turnos.hora_inicio);
            li_work             =   f_intervalo(ats_entrada, lts_entrada_turno);
            
            if lts_salida > ats_entrada then
                if li_work > 180 then
                    update pla_marcaciones
                    set salida = lts_salida, 
                        turno = li_turno,
                        entrada_descanso = null,
                        salida_descanso = null,
                        id_pla_proyectos = r_pla_proyectos.id
                    where id = r_pla_marcaciones.id;
                else
                    update pla_marcaciones
                    set entrada = ats_entrada, salida = lts_salida, 
                        turno = li_turno,
                        entrada_descanso = null,
                        salida_descanso = null,
                        id_pla_proyectos = r_pla_proyectos.id
                    where id = r_pla_marcaciones.id;
                end if;                    
            end if;

            if ats_entrada_descanso is not null and ats_salida_descanso is not null then
                if lts_entrada_descanso > ats_entrada then
                    update pla_marcaciones
                    set entrada_descanso = lts_entrada_descanso,
                        salida_descanso = lts_salida_descanso
                    where id = r_pla_marcaciones.id;
                end if;
            end if;
        else
            update pla_marcaciones
            set entrada = ats_entrada, salida = lts_salida, 
                entrada_descanso = lts_entrada_descanso,
                salida_descanso = lts_salida_descanso, turno = li_turno,
                id_pla_proyectos = r_pla_proyectos.id
            where id = r_pla_marcaciones.id;
        end if;

        if Trim(lc_utilizan_reloj) = ''S'' and r_pla_empleados.reloj is true 
            and r_pla_marcaciones.status = ''I'' then

            update pla_marcaciones
            set status = ''R''
            where id = r_pla_marcaciones.id;

        end if;
    
    end if;
    
    return r_pla_marcaciones.id;
end;
' language plpgsql;



create function f_pla_crear_tarjetas_de_tiempo(int4, char(2)) returns integer as '
declare
    ai_cia alias for $1;
    as_tipo_de_planilla alias for $2;
    r_pla_tipos_de_planilla record;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_horarios record;
    r_pla_tarjeta_tiempo record;
    r_pla_marcaciones record;
    r_pla_turnos record;
    r_pla_dias_feriados record;
    r_pla_turnos_rotativos record;
    r_pla_dinero record;
    r_pla_certificados_medico record;
    r_att_punches record;
    ld_work date;
    ld_hasta date;
    ldt_entrada timestamp without time zone;
    ldt_salida timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    li_dow integer;
    i integer;
    lvc_crear_tarjetas_hasta_el_corte_en_salario_fijo varchar(50);
    lvc_utiliza_reloj_zk varchar(1);
begin

    lvc_crear_tarjetas_hasta_el_corte_en_salario_fijo = f_pla_parametros(ai_cia, ''crear_tarjetas_hasta_el_corte_en_salario_fijo'', ''N'',''GET'');
    lvc_utiliza_reloj_zk = Trim(f_pla_parametros(ai_cia, ''utiliza_reloj_zk'', ''N'',''GET''));

    select into r_pla_tipos_de_planilla * 
    from pla_tipos_de_planilla
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
    
    if trim(as_tipo_de_planilla) = ''1'' and
        Trim(f_pla_parametros(ai_cia, ''proyecto_obligatorio_semanales'',''N'',''GET'')) = ''S'' then
        
        delete from pla_marcaciones using pla_periodos, pla_tarjeta_tiempo
        where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
        and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
        and pla_marcaciones.id_pla_proyectos is null
        and pla_tarjeta_tiempo.compania = ai_cia
        and pla_periodos.tipo_de_planilla = ''1''
        and pla_periodos.id = r_pla_periodos.id;
        
        return 0;
    end if;

/*
    delete from pla_marcaciones using pla_periodos, pla_empleados, pla_tarjeta_tiempo
    where pla_periodos.id = pla_tarjeta_tiempo.id_periodos
    and pla_tarjeta_tiempo.compania = pla_empleados.compania
    and pla_tarjeta_tiempo.codigo_empleado = pla_empleados.codigo_empleado
    and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
    and pla_empleados.status = ''E''
    and pla_periodos.id = r_pla_periodos.id;


    delete from pla_tarjeta_tiempo using pla_periodos, pla_empleados
    where pla_periodos.id = pla_tarjeta_tiempo.id_periodos
    and pla_tarjeta_tiempo.compania = pla_empleados.compania
    and pla_tarjeta_tiempo.codigo_empleado = pla_empleados.codigo_empleado
    and pla_empleados.status = ''E''
    and pla_periodos.id = r_pla_periodos.id;
*/    
    
  
    if trim(as_tipo_de_planilla) = ''3''
        and Trim(f_pla_parametros(ai_cia, ''crear_tarjeta_bisemanales'',''N'',''GET'')) = ''N'' then
        return 0;
    end if;

    
    for r_pla_empleados in select * from pla_empleados
                            where compania = ai_cia
                            and tipo_de_planilla = as_tipo_de_planilla
                            and status in (''A'',''V'')
                            order by codigo_empleado
    loop
        select into r_pla_dinero *
        from pla_dinero
        where compania = ai_cia
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and tipo_de_calculo = ''1''
        and id_periodos = r_pla_periodos.id
        and id_pla_cheques_1 is not null;
        if not found then
--                r_pla_empleados.fecha_inicio between r_pla_periodos.desde and r_pla_periodos.dia_d_pago then
--            if r_pla_empleados.tipo_de_salario = ''F'' or r_pla_empleados.compania = 1353 then


            if r_pla_empleados.tipo_de_salario = ''F'' and lvc_crear_tarjetas_hasta_el_corte_en_salario_fijo = ''N'' then
                ld_hasta = r_pla_periodos.dia_d_pago;
            else
                ld_hasta = r_pla_periodos.hasta;
            end if;

/*
            if r_pla_empleados.compania <> 1046 then
                if r_pla_empleados.tipo_de_planilla = ''2''
                    and r_pla_empleados.tipo_de_salario = ''F'' then
                    ld_hasta = r_pla_periodos.dia_d_pago;
                end if;
            end if;
*/            

            ld_work = r_pla_periodos.desde;
            
            if r_pla_empleados.fecha_terminacion_real is not null then
                ld_hasta = r_pla_empleados.fecha_terminacion_real;
            end if;

            while ld_work <= ld_hasta loop
                if r_pla_empleados.tipo_de_planilla = ''2''
                    and r_pla_empleados.tipo_de_salario = ''F''
                    and ld_work > r_pla_periodos.hasta
                    and extract(dow from ld_work) = 0 then
                    ld_work = ld_work + 1;
                    continue;
                end if;




                if r_pla_empleados.fecha_inicio <= ld_work then
                    i = f_crear_tarjeta(ai_cia, r_pla_empleados.codigo_empleado, ld_work, r_pla_periodos.id);
                end if;
                ld_work = ld_work + 1;

/*                
if Trim(r_pla_empleados.codigo_empleado) = ''0012'' and ld_work >= ''2015-04-26'' then
    return 0;
--    Raise Exception ''%'', ld_work;
end if;
*/

                

            end loop;

            if r_pla_empleados.tipo_de_planilla = ''2''
                and r_pla_empleados.tipo_de_salario = ''F'' then
                update pla_marcaciones
                set status = ''R''
                from pla_tarjeta_tiempo
                where pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
                and pla_tarjeta_tiempo.compania = ai_cia
                and pla_tarjeta_tiempo.codigo_empleado = r_pla_empleados.codigo_empleado
                and pla_tarjeta_tiempo.id_periodos = r_pla_periodos.id
                and pla_marcaciones.status = ''I''
                and date(pla_marcaciones.entrada) > r_pla_periodos.hasta;
           end if;

            
            for r_pla_certificados_medico in select pla_certificados_medico.* 
                                    from pla_certificados_medico, pla_periodos
                                    where pla_certificados_medico.compania = pla_periodos.compania
                                    and pla_certificados_medico.year = pla_periodos.year
                                    and pla_certificados_medico.numero_planilla = pla_periodos.numero_planilla
                                    and pla_certificados_medico.compania = r_pla_empleados.compania
                                    and pla_certificados_medico.codigo_empleado = r_pla_empleados.codigo_empleado
                                    and pla_certificados_medico.year = r_pla_periodos.year
                                    and pla_certificados_medico.numero_planilla = r_pla_periodos.numero_planilla
                                    order by pla_certificados_medico.codigo_empleado desc
            loop
                if r_pla_empleados.fecha_inicio <= r_pla_certificados_medico.fecha then
                    i = f_crear_tarjeta(ai_cia, r_pla_empleados.codigo_empleado, r_pla_certificados_medico.fecha, r_pla_periodos.id);
                end if;
            end loop;
        end if;

        
        if r_pla_empleados.reloj is true and Trim(lvc_utiliza_reloj_zk) = ''S'' then
            for r_att_punches in select att_punches.* from hr_employee, hr_department, att_punches
                                    where hr_employee.department_id = hr_department.id
                                    and hr_employee.id = att_punches.employee_id
                                    and hr_department.company_id = ai_cia
                                    and trim(hr_employee.emp_pin) = trim(r_pla_empleados.codigo_empleado)
                                    and f_to_date(att_punches.punch_time) >= r_pla_periodos.desde
                                    and not exists
                                        (select * from att_punches_pla_marcaciones
                                            where att_punches_pla_marcaciones.att_punches_id = att_punches.id)
            loop
                i = f_att_punches_pla_marcaciones(r_att_punches.id);
            end loop;                            
        end if;        
        
    end loop;
    
    
    return 1;
end;
' language plpgsql;


create function f_crear_tarjeta(int4, char(7), date, int4) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ad_fecha alias for $3;
    ai_id_periodos alias for $4;
    r_pla_tipos_de_planilla record;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_horarios record;
    r_pla_tarjeta_tiempo record;
    r_pla_marcaciones record;
    r_pla_turnos record;
    r_pla_turnos_rotativos record;
    r_pla_dias_feriados record;
    r_pla_vacaciones record;
    r_pla_riesgos_profesionales record;
    ld_work date;
    ld_fecha date;
    ldt_entrada timestamp without time zone;
    ldt_salida timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    li_dow integer;
    i integer;
    curs1 refcursor;
    lc_status char(1);
    lc_pagar_salario_en_vacaciones char(1);
begin

    lc_pagar_salario_en_vacaciones = Trim(f_pla_parametros(ai_cia, ''pagar_salario_en_vacaciones'',''N'',''GET''));

    ld_fecha    =   ad_fecha;

    select into r_pla_riesgos_profesionales * 
    from pla_riesgos_profesionales
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and monto <> 0
    and ad_fecha between desde and hasta;
    if found then
        return 0;
    end if;
    
    

    if lc_pagar_salario_en_vacaciones <> ''S'' then
        select into r_pla_vacaciones * from pla_vacaciones
        where compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and ad_fecha between pagar_desde and pagar_hasta;
        if found then
            return 0;
        end if;
    end if;
    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    
/*    
    select into r_pla_dias_feriados * from pla_dias_feriados
    where compania = ai_cia
    and fecha = ad_fecha
    and tipo_de_salario = r_pla_empleados.tipo_de_salario;
    if found then
        return 0;
    end if;
*/    
    
    if r_pla_empleados.fecha_inicio > ad_fecha and r_pla_empleados.tipo_de_salario = ''H'' then
        return 0;
    end if;


    
    if r_pla_empleados.fecha_terminacion_real is not null then
        if ad_fecha > r_pla_empleados.fecha_terminacion_real then
            return 0;
        end if;
    end if;
    
    open curs1 for 
        select * from pla_turnos_rotativos
        where compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and ad_fecha between desde and hasta
        and turno is not null
        order by desde;
    fetch curs1 into r_pla_turnos_rotativos;
    if found then
        if extract(dow from ad_fecha) = r_pla_turnos_rotativos.dia_libre then
            return 0;
        end if;
    
        select into r_pla_turnos * from pla_turnos
        where compania = ai_cia
        and turno = r_pla_turnos_rotativos.turno;


        select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
        where compania = ai_cia
        and trim(codigo_empleado) = trim(as_codigo_empleado)
        and id_periodos = ai_id_periodos;
        if not found then
            insert into pla_tarjeta_tiempo (compania, codigo_empleado, id_periodos)
            values (ai_cia, r_pla_empleados.codigo_empleado, ai_id_periodos);

            select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
            where compania = ai_cia
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and id_periodos = ai_id_periodos;
        end if;

        select into r_pla_marcaciones * 
        from pla_marcaciones, pla_tarjeta_tiempo
        where pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
        and pla_tarjeta_tiempo.id_periodos = ai_id_periodos
        and pla_tarjeta_tiempo.compania = ai_cia
        and id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
        and date(entrada) = ad_fecha;
        if not found then
            ldt_entrada = to_timestamp(f_concat_fecha_hora(ad_fecha, r_pla_turnos.hora_inicio),''YYYY/MM/DD HH24:MI'');
            if r_pla_turnos.hora_salida < r_pla_turnos.hora_inicio then
                ldt_salida = to_timestamp(f_concat_fecha_hora(ad_fecha+1, r_pla_turnos.hora_salida),''YYYY/MM/DD HH24:MI'');
            else
                ldt_salida = to_timestamp(f_concat_fecha_hora(ad_fecha, r_pla_turnos.hora_salida),''YYYY/MM/DD HH24:MI'');
            end if;
        
            if r_pla_turnos.hora_inicio_descanso is null then
                ldt_entrada_descanso = null;
            else
                if r_pla_turnos.hora_inicio_descanso < r_pla_turnos.hora_inicio then
                    ldt_entrada_descanso = to_timestamp(f_concat_fecha_hora(ad_fecha+1, r_pla_turnos.hora_inicio_descanso),''YYYY/MM/DD HH24:MI'');
                else
                    ldt_entrada_descanso = to_timestamp(f_concat_fecha_hora(ad_fecha, r_pla_turnos.hora_inicio_descanso),''YYYY/MM/DD HH24:MI'');
                end if;
            end if;

            if r_pla_turnos.hora_salida_descanso is null then
                ldt_salida_descanso = null;
            else
                if r_pla_turnos.hora_salida_descanso < r_pla_turnos.hora_inicio then
                    ldt_salida_descanso = to_timestamp(f_concat_fecha_hora(ad_fecha+1, r_pla_turnos.hora_salida_descanso),''YYYY/MM/DD HH24:MI'');
                else
                    ldt_salida_descanso = to_timestamp(f_concat_fecha_hora(ad_fecha, r_pla_turnos.hora_salida_descanso),''YYYY/MM/DD HH24:MI'');
                end if;
            end if;

            if r_pla_empleados.reloj is true then
                lc_status = ''R'';
            else
                lc_status = ''R'';
            end if;
            
            insert into pla_marcaciones (id_tarjeta_de_tiempo, compania,
                turno, entrada, salida, entrada_descanso, salida_descanso, status, autorizado)
            values (r_pla_tarjeta_tiempo.id, ai_cia, r_pla_turnos_rotativos.turno, ldt_entrada,
                ldt_salida, ldt_entrada_descanso, ldt_salida_descanso, lc_status, ''S'');

            
        end if;
    else
    
        li_dow = extract(dow from ad_fecha);
        select into r_pla_horarios * 
        from pla_horarios
        where compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and dia = li_dow;
        if found then
        
            select into r_pla_turnos * from pla_turnos
            where compania = ai_cia
            and turno = r_pla_horarios.turno;
            if not found then
                raise exception ''Turno % No existe'',r_pla_horarios.turno;
            end if;

    
            select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
            where compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and id_periodos = ai_id_periodos;
            if not found then
                insert into pla_tarjeta_tiempo (compania, codigo_empleado, id_periodos)
                values (ai_cia, as_codigo_empleado, ai_id_periodos);

        
                select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
                where compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and id_periodos = ai_id_periodos;
            end if;
    

            select into r_pla_marcaciones * 
            from pla_marcaciones, pla_tarjeta_tiempo
            where pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
            and pla_tarjeta_tiempo.id_periodos = ai_id_periodos
            and pla_tarjeta_tiempo.compania = ai_cia
            and id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
            and date(entrada) = ad_fecha;
            if not found then
            
                ldt_entrada = to_timestamp(f_concat_fecha_hora(ad_fecha, r_pla_turnos.hora_inicio),''YYYY/MM/DD HH24:MI'');
                if r_pla_turnos.hora_salida < r_pla_turnos.hora_inicio then
                    ldt_salida = to_timestamp(f_concat_fecha_hora(ad_fecha+1, r_pla_turnos.hora_salida),''YYYY/MM/DD HH24:MI'');
                else
                    ldt_salida = to_timestamp(f_concat_fecha_hora(ad_fecha, r_pla_turnos.hora_salida),''YYYY/MM/DD HH24:MI'');
                end if;
    
                if r_pla_turnos.hora_inicio_descanso is null then
                    ldt_entrada_descanso = null;
                else
                    if r_pla_turnos.hora_inicio_descanso < r_pla_turnos.hora_inicio then
                        ldt_entrada_descanso = to_timestamp(f_concat_fecha_hora(ad_fecha+1, r_pla_turnos.hora_inicio_descanso),''YYYY/MM/DD HH24:MI'');
                    else
                        ldt_entrada_descanso = to_timestamp(f_concat_fecha_hora(ad_fecha, r_pla_turnos.hora_inicio_descanso),''YYYY/MM/DD HH24:MI'');
                    end if;
                end if;

                if r_pla_turnos.hora_salida_descanso is null then
                    ldt_salida_descanso = null;
                else
                    if r_pla_turnos.hora_salida_descanso < r_pla_turnos.hora_inicio then
                        ldt_salida_descanso = to_timestamp(f_concat_fecha_hora(ad_fecha+1, r_pla_turnos.hora_salida_descanso),''YYYY/MM/DD HH24:MI'');
                    else
                        ldt_salida_descanso = to_timestamp(f_concat_fecha_hora(ad_fecha, r_pla_turnos.hora_salida_descanso),''YYYY/MM/DD HH24:MI'');
                    end if;
                end if;

/*        
                insert into pla_marcaciones (id_tarjeta_de_tiempo, compania,
                    turno, entrada, salida, entrada_descanso, salida_descanso, status)
                values (r_pla_tarjeta_tiempo.id, ai_cia, r_pla_horarios.turno, ldt_entrada,
                    ldt_salida, ldt_entrada_descanso, ldt_salida_descanso, ''R'');
*/

/*
    if Trim(as_codigo_empleado) = ''0012'' and ad_fecha >= ''2015-04-26'' then
        Raise Exception ''entre  %'', ad_fecha;
    end if;
*/
                i = f_insertar_pla_marcaciones(ai_cia, as_codigo_empleado, ai_id_periodos, null,
                        r_pla_horarios.turno, ldt_entrada, ldt_salida, ldt_entrada_descanso,
                        ldt_salida_descanso);
                        

            end  if;
        else
            if li_dow = 0 and ai_cia = 1341 then
                select into r_pla_horarios * from pla_horarios
                where compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and dia = 1;
                if found then
                    select into r_pla_turnos * from pla_turnos
                    where compania = ai_cia
                    and turno = r_pla_horarios.turno;
                    if not found then
                        raise exception ''Turno % No existe'',r_pla_horarios.turno;
                    end if;

                    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
                    where compania = ai_cia
                    and codigo_empleado = as_codigo_empleado
                    and id_periodos = ai_id_periodos;
                    if not found then
                        insert into pla_tarjeta_tiempo (compania, codigo_empleado, id_periodos)
                        values (ai_cia, as_codigo_empleado, ai_id_periodos);

        
                        select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
                        where compania = ai_cia
                        and codigo_empleado = as_codigo_empleado
                        and id_periodos = ai_id_periodos;
                    end if;
    
    
                    select into r_pla_marcaciones * from pla_marcaciones
                    where compania = ai_cia
                    and id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
                    and date(entrada) = ad_fecha;
                    if not found then
            
                        ldt_entrada = to_timestamp(f_concat_fecha_hora(ad_fecha, r_pla_turnos.hora_inicio),''YYYY/MM/DD HH24:MI'');
                        if r_pla_turnos.hora_salida < r_pla_turnos.hora_inicio then
                            ldt_salida = to_timestamp(f_concat_fecha_hora(ad_fecha+1, r_pla_turnos.hora_salida),''YYYY/MM/DD HH24:MI'');
                        else
                            ldt_salida = to_timestamp(f_concat_fecha_hora(ad_fecha, r_pla_turnos.hora_salida),''YYYY/MM/DD HH24:MI'');
                        end if;
    
                        if r_pla_turnos.hora_inicio_descanso is null then
                            ldt_entrada_descanso = null;
                        else
                            if r_pla_turnos.hora_inicio_descanso < r_pla_turnos.hora_inicio then
                                ldt_entrada_descanso = to_timestamp(f_concat_fecha_hora(ad_fecha+1, r_pla_turnos.hora_inicio_descanso),''YYYY/MM/DD HH24:MI'');
                            else
                                ldt_entrada_descanso = to_timestamp(f_concat_fecha_hora(ad_fecha, r_pla_turnos.hora_inicio_descanso),''YYYY/MM/DD HH24:MI'');
                            end if;
                        end if;

                        if r_pla_turnos.hora_salida_descanso is null then
                            ldt_salida_descanso = null;
                        else
                            if r_pla_turnos.hora_salida_descanso < r_pla_turnos.hora_inicio then
                                ldt_salida_descanso = to_timestamp(f_concat_fecha_hora(ad_fecha+1, r_pla_turnos.hora_salida_descanso),''YYYY/MM/DD HH24:MI'');
                            else
                                ldt_salida_descanso = to_timestamp(f_concat_fecha_hora(ad_fecha, r_pla_turnos.hora_salida_descanso),''YYYY/MM/DD HH24:MI'');
                            end if;
                        end if;

                        insert into pla_marcaciones (id_tarjeta_de_tiempo, compania,
                            turno, entrada, salida, entrada_descanso, salida_descanso, status)
                        values (r_pla_tarjeta_tiempo.id, ai_cia, r_pla_horarios.turno, ldt_entrada,
                            ldt_salida, ldt_entrada_descanso, ldt_salida_descanso, ''L'');
                    end if;
                end if;                    
            end if;            
        end if;
    end if;
    close curs1;

    return 1;
end;
' language plpgsql;




create function f_pla_asignacion_de_dia_libre(int4, char(7), date, date) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ad_desde alias for $3;
    ad_hasta alias for $4;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_turnos record;
    r_pla_tarjeta_tiempo record;
    r_pla_marcaciones record;
    r_pla_proyectos record;
    lb_sw boolean;
    ld_work date;
    ld_fecha_salida date;
    ld_fecha_salida_descanso date;
    lt_ini_descanso time;
    lt_fin_descanso time;
begin
    lb_sw   =   false;

    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and status = ''A'';
    if not found then
        return 0;
    end if;

    for r_pla_proyectos in select * from pla_proyectos
                            where compania = ai_cia
                            order by id desc
    loop
        lb_sw = true;
        exit;
    end loop;
    
    if not lb_sw then
        raise exception ''En esta compania % no existen proyectos'',ai_cia;
    end if;
    

    ld_work =   ad_desde;
    while ld_work <= ad_hasta loop
        if r_pla_empleados.fecha_inicio > ld_work then
            continue;
        end if;
        
        for r_pla_periodos in select * from pla_periodos
                                where compania = ai_cia
                                and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
                                and ld_work between desde and hasta
                                and status = ''A''
                                order by dia_d_pago desc
        loop
            select into r_pla_tarjeta_tiempo *
                from pla_tarjeta_tiempo
                where compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and id_periodos = r_pla_periodos.id;
            if found then
                select into r_pla_marcaciones *
                from pla_marcaciones
                where id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
                and cast(entrada as date) = ld_work;
                if found then
                    if r_pla_marcaciones.status = ''L'' then
                        exit;
                    end if;
                    delete from pla_marcaciones
                    where id = r_pla_marcaciones.id
                    and compania = ai_cia;
                end if;
                ld_fecha_salida             =   ld_work;
                ld_fecha_salida_descanso    =   ld_work;
                
                
                insert into pla_marcaciones (id_tarjeta_de_tiempo, compania, 
                    id_pla_proyectos, entrada, salida, entrada_descanso, salida_descanso, status)
                values(r_pla_tarjeta_tiempo.id, ai_cia, r_pla_proyectos.id,
                    cast(ld_work as timestamp), cast(ld_work as timestamp),
                    null, null, ''L'');
            end if;
            exit;
        end loop;
        ld_work =   ld_work + 1;
    end loop;

    return 1;
end;
' language plpgsql;



create function f_pla_reasignacion_de_turno(int4, char(7), date, date, int4, time, time, time, time) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ad_desde alias for $3;
    ad_hasta alias for $4;
    ai_id_pla_proyectos alias for $5;
    at_entrada alias for $6;
    at_ini_descanso alias for $7;
    at_fin_descanso alias for $8;
    at_salida alias for $9;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_turnos record;
    r_pla_tarjeta_tiempo record;
    r_pla_marcaciones record;
    r_pla_proyectos record;
    r_pla_tipos_de_planilla record;
    r_pla_horarios record;
    ld_work date;
    ld_fecha_salida date;
    ld_fecha_salida_descanso date;
    lt_ini_descanso time;
    lt_fin_descanso time;
    li_dow integer;
    lc_status char(1);
begin
    if ad_desde > ad_hasta then
        return 0;
    end if;
  
    if ad_hasta - ad_desde > 31 then
        return 0;
    end if;  
  
    if at_ini_descanso = cast(''00:00:00'' as time) then
        lt_ini_descanso = null;
    else
        lt_ini_descanso = at_ini_descanso;
    end if;

    if at_fin_descanso = cast(''00:00:00'' as time) then
        lt_fin_descanso = null;
    else
        lt_fin_descanso = at_fin_descanso;
    end if;
    
        
    select into r_pla_proyectos * from pla_proyectos
    where id = ai_id_pla_proyectos;
    if not found then
        return 0;
    end if;
    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and status = ''A'';
    if not found then
        return 0;
    end if;
    
    select into r_pla_tipos_de_planilla * 
    from pla_tipos_de_planilla
    where compania = ai_cia
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla;
    
    select into r_pla_periodos * 
    from pla_periodos
    where compania = ai_cia
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and numero_planilla = r_pla_tipos_de_planilla.planilla_actual
    and status = ''A'';
    if not found then
        return 0;
    end if;
    
    ld_work =   ad_desde;
    
    while ld_work <= ad_hasta loop
        if ld_work > r_pla_periodos.hasta then
            ld_work = ld_work + 1;
            continue;
        end if;
        
        if r_pla_empleados.fecha_inicio > ld_work then
            ld_work = ld_work + 1;
            continue;
        end if;
        
        select into r_pla_tarjeta_tiempo *
            from pla_tarjeta_tiempo
            where compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and id_periodos = r_pla_periodos.id;
        if not found then
            insert into pla_tarjeta_tiempo(compania, codigo_empleado, id_periodos)
            values (ai_cia, as_codigo_empleado, r_pla_periodos.id);
        end if;
        
        select into r_pla_tarjeta_tiempo *
            from pla_tarjeta_tiempo
            where compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and id_periodos = r_pla_periodos.id;
        if found then
            select into r_pla_marcaciones *
            from pla_marcaciones
            where id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
            and cast(entrada as date) = ld_work;
            if found then
                if r_pla_marcaciones.status = ''L'' then
                    exit;
                end if;
                delete from pla_marcaciones
                where id = r_pla_marcaciones.id
                and compania = ai_cia;
            end if;
            ld_fecha_salida             =   ld_work;
            ld_fecha_salida_descanso    =   ld_work;
            
            
            if at_salida < at_entrada then
                ld_fecha_salida =   ld_fecha_salida + 1;
            end if;
            
            if lt_fin_descanso < lt_ini_descanso then
                ld_fecha_salida_descanso    =   ld_fecha_salida_descanso + 1;
            end if;

            lc_status   =   ''R'';
            li_dow      =   extract(dow from ld_work);
            select into r_pla_horarios * 
            from pla_horarios
            where compania = r_pla_empleados.compania
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and dia = li_dow;
            if not found then
                lc_status = ''L'';
            end if;

            
            insert into pla_marcaciones (id_tarjeta_de_tiempo, compania, 
                id_pla_proyectos, entrada, salida, entrada_descanso, salida_descanso, status)
            values(r_pla_tarjeta_tiempo.id, ai_cia, ai_id_pla_proyectos,
                f_timestamp(ld_work, at_entrada),
                f_timestamp(ld_fecha_salida, at_salida),
                f_timestamp(ld_work, lt_ini_descanso),
                f_timestamp(ld_fecha_salida_descanso, lt_fin_descanso), lc_status);
        end if;
        ld_work =   ld_work + 1;
    end loop;
        

    return 1;
end;
' language plpgsql;


create function f_pla_reasignacion_de_turno(int4, char(7), date, date, int4, int4) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ad_desde alias for $3;
    ad_hasta alias for $4;
    ai_turno alias for $5;
    ai_id_pla_proyectos alias for $6;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_turnos record;
    r_pla_tarjeta_tiempo record;
    r_pla_marcaciones record;
    r_pla_proyectos record;
    r_pla_tipos_de_planilla record;
    r_pla_horarios record;
    ld_work date;
    ld_fecha_salida date;
    ld_fecha_salida_descanso date;
    ld_fecha_inicio_descanso date;
    li_dow integer;
    lc_status char(1);
begin
    if ad_desde > ad_hasta then
        return 0;
    end if;
    
    
    if ad_hasta - ad_desde > 31 then
        return 0;
    end if;  
    
    select into r_pla_proyectos * from pla_proyectos
    where id = ai_id_pla_proyectos;
    if not found then
        return 0;
    end if;
    
    select into r_pla_turnos * from pla_turnos
    where compania = ai_cia
    and turno = ai_turno;
    if not found then
        return 0;
    end if;
    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and status = ''A'';
    if not found then
        return 0;
    end if;
    
    select into r_pla_tipos_de_planilla *
    from pla_tipos_de_planilla
    where compania = ai_cia
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla;
    
    
    ld_work =   ad_desde;

    while ld_work <= ad_hasta loop
        if r_pla_empleados.fecha_inicio > ld_work then
            ld_work = ld_work + 1;
            continue;
        end if;
        
        for r_pla_periodos in select * from pla_periodos
                                where compania = ai_cia
                                and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
                                and numero_planilla = r_pla_tipos_de_planilla.planilla_actual
                                and status = ''A''
                                order by dia_d_pago desc
        loop
            if ld_work > r_pla_periodos.hasta then
                continue;
            end if;
        
            select into r_pla_tarjeta_tiempo *
                from pla_tarjeta_tiempo
                where compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and id_periodos = r_pla_periodos.id;
            if not found then
                insert into pla_tarjeta_tiempo(compania, codigo_empleado, id_periodos)
                values (ai_cia, as_codigo_empleado, r_pla_periodos.id);
            end if;
            
            select into r_pla_tarjeta_tiempo *
                from pla_tarjeta_tiempo
                where compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and id_periodos = r_pla_periodos.id;
            if found then
                select into r_pla_marcaciones *
                from pla_marcaciones
                where id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
                and cast(entrada as date) = ld_work;
                if found then
                    if r_pla_marcaciones.status = ''L'' then
                        exit;
                    end if;
                    delete from pla_marcaciones
                    where id = r_pla_marcaciones.id
                    and compania = ai_cia;
                end if;

                ld_fecha_salida             =   ld_work;
                ld_fecha_salida_descanso    =   ld_work;
                ld_fecha_inicio_descanso    =   ld_work;
                if r_pla_turnos.hora_salida < r_pla_turnos.hora_inicio then
                    ld_fecha_salida =   ld_fecha_salida + 1;
                end if;
                
                if r_pla_turnos.hora_inicio_descanso is not null then
                    if r_pla_turnos.hora_inicio_descanso < r_pla_turnos.hora_inicio then
                        ld_fecha_inicio_descanso = ld_work + 1;
                        ld_fecha_salida_descanso = ld_work + 1;
                    end if;
                end if;
                
                if r_pla_turnos.hora_salida_descanso < r_pla_turnos.hora_inicio_descanso then
                    ld_fecha_salida_descanso    =   ld_fecha_salida_descanso + 1;
                end if;

                lc_status   =   ''R'';
                li_dow      =   extract(dow from ld_work);
                select into r_pla_horarios * 
                from pla_horarios
                where compania = r_pla_empleados.compania
                and codigo_empleado = r_pla_empleados.codigo_empleado
                and dia = li_dow;
                if not found then
                    lc_status = ''L'';
                end if;

                
                insert into pla_marcaciones (id_tarjeta_de_tiempo, compania, turno,
                    id_pla_proyectos, entrada, salida, entrada_descanso, salida_descanso, status)
                values(r_pla_tarjeta_tiempo.id, ai_cia, ai_turno, ai_id_pla_proyectos,
                    f_timestamp(ld_work, r_pla_turnos.hora_inicio),
                    f_timestamp(ld_fecha_salida, r_pla_turnos.hora_salida),
                    f_timestamp(ld_fecha_inicio_descanso, r_pla_turnos.hora_inicio_descanso),
                    f_timestamp(ld_fecha_salida_descanso, r_pla_turnos.hora_salida_descanso), lc_status);

            end if;
            exit;
        end loop;
        ld_work =   ld_work + 1;
    end loop;

    return 1;
end;
' language plpgsql;
