

drop function f_pla_horas_tardanzas(int4) cascade;

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

--    raise exception ''Computa descanso %  % %'', r_pla_marcaciones.entrada, ldt_entrada_turno, li_minutos_regulares;

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

