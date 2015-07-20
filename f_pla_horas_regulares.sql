
drop function f_pla_horas_regulares(int4) cascade;

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
    lc_calcular_salida_en_horas_laborables char(1);
begin
    li_minutos_adicionales          =   0;
    lt_comienza_dia                 =   ''00:00'';
    li_minutos_descanso             =   0;
    li_min_tardanza                 =   0;
    li_min_injustificado            =   0;
    li_descanso_programado          =   0;

    
    select into r_pla_marcaciones * from pla_marcaciones
    where id = ai_id;

    
    delete from pla_horas
    where id_marcaciones = r_pla_marcaciones.id 
    and forma_de_registro = ''A'' and minutos > 0;
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;


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
    
        ls_tipo_de_jornada      =   f_tipo_de_jornada(r_pla_marcaciones.entrada, r_pla_marcaciones.salida);

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
        
        ls_tipo_de_jornada = r_pla_turnos.tipo_de_jornada;
        
    
        if r_pla_turnos.hora_salida < r_pla_turnos.hora_inicio then
            lts_entrada_turno       =   f_timestamp(date(r_pla_marcaciones.entrada),r_pla_turnos.hora_inicio);
            lts_salida_turno        =   f_timestamp((date(r_pla_marcaciones.entrada) + 1),r_pla_turnos.hora_salida);
        else
            lts_entrada_turno       = f_timestamp(date(r_pla_marcaciones.entrada), r_pla_turnos.hora_inicio);
            lts_salida_turno        = f_timestamp(date(r_pla_marcaciones.entrada), r_pla_turnos.hora_salida);
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

        if r_pla_marcaciones.salida < lts_salida_turno and r_pla_marcaciones.status = ''R'' 
            and lc_calcular_salida_en_horas_laborables = ''S'' then
            li_min_injustificado    =   f_intervalo(r_pla_marcaciones.salida, lts_salida_turno);
            li_retorno              =   f_pla_horas(r_pla_marcaciones.id, ''75'', li_min_injustificado,
                                            r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
        end if;
        
        
        li_minutos_trabajados   =   f_intervalo(r_pla_marcaciones.entrada, r_pla_marcaciones.salida) 
                                    -   f_intervalo(r_pla_marcaciones.entrada_descanso, r_pla_marcaciones.salida_descanso);
                                    
        li_minutos_descanso     =   f_intervalo(r_pla_marcaciones.entrada_descanso, r_pla_marcaciones.salida_descanso);
        li_descanso_programado  =   f_intervalo(lts_entrada_descanso, lts_salida_descanso);


        li_minutos_regulares    =   f_intervalo(lts_entrada_turno,lts_salida_turno)
                                    - f_intervalo(lts_entrada_descanso, lts_salida_descanso);

        li_minutos_adicionales = 0;            
        if ls_tipo_de_jornada = ''N'' and li_minutos_trabajados >= 360 then
            li_minutos_adicionales  =   60;
            li_minutos_regulares    =   420;
        elsif ls_tipo_de_jornada = ''M'' and li_minutos_trabajados >= 420 then
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

--    raise exception ''% %'', r_pla_marcaciones.entrada, lts_comienza_dia;

        
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

                    if r_pla_marcaciones.status = ''I'' then
                        ls_tipo_de_hora = ''00'';
                    end if;                    
                    if f_pla_parametros(r_pla_tarjeta_tiempo.compania, ''suntracs'', ''N'', ''GET'') = ''S'' then                    
                        li_retorno  =   f_pla_horas(r_pla_marcaciones.id, ls_tipo_de_hora, li_work, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'', lts_comienza_dia, lts_salida_turno);
                    else
                        li_retorno  =   f_pla_horas(r_pla_marcaciones.id, ls_tipo_de_hora, li_work, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
                    end if;

            if r_pla_marcaciones.compania = 1193 then
--                raise exception ''% % %'', ld_salida_turno, li_work, ls_tipo_de_hora;
            end if;
                    
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
        li_work     =   li_minutos_regulares + li_minutos_adicionales;
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
    return 1;
end;
' language plpgsql;

