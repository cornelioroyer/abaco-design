drop function f_pla_horas_extras(int4) cascade;
drop function f_tolerancia_de_salida(int4, char(7), int4, date) cascade;

create function f_tolerancia_de_salida(int4, char(7), int4, date) returns timestamp as '
declare
    ai_compania alias for $1;
    as_codigo_empleado alias for $2;
    ai_turno alias for $3;
    ad_entrada alias for $4;
    r_pla_empleados record;
    r_pla_dias_feriados record;
    r_pla_marcaciones record;
    r_pla_turnos record;
    lts_tolerancia_salida timestamp;
    ld_fecha date;
begin
    lts_tolerancia_salida   =   null;
    ld_fecha                =   ad_entrada;
    select into r_pla_empleados * 
    from pla_empleados
    where compania = ai_compania
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return lts_tolerancia_salida;
    end if;
    
    select into r_pla_turnos *
    from pla_turnos
    where compania = ai_compania
    and turno = ai_turno;
    if not found then
        return lts_tolerancia_salida;
    else
        if r_pla_turnos.inicio_extras is not null then
            r_pla_turnos.tolerancia_de_salida = r_pla_turnos.inicio_extras;
        end if;        
    end if;
    
    if r_pla_turnos.tolerancia_de_salida < r_pla_turnos.hora_inicio then
        ld_fecha    =   ld_fecha + 1;
    end if;
    
    lts_tolerancia_salida   =   f_timestamp(ld_fecha, r_pla_turnos.tolerancia_de_salida);
    
    return lts_tolerancia_salida;
end;
' language plpgsql;



create function f_pla_horas_extras(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_turnos record;
    r_pla_permisos record;
    r_pla_horas record;
    r_pla_tipos_de_horas record;
    r_pla_tipos_de_horas_work record;
    r_pla_tarjeta_tiempo record;
    r_pla_dias_feriados record;
    r_pla_certificados_medico record;
    r_pla_desglose_regulares record;
    ldt_entrada_turno timestamp;
    ldt_salida_turno timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    lts_work1 timestamp;
    lts_work2 timestamp;
    lts_noche timestamp;
    lts_comienza_nocturno timestamp;
    lts_comienza_dia timestamp;
    lts_salida_turno timestamp;
    lts_hora_actual timestamp;
    lts_hora_actual_anterior timestamp;
    lts_work timestamp;
    lts_tolerancia_de_salida timestamp;
    ls_tipo_de_hora char(2);
    ld_fecha date;
    ld_work date;
    ld_work1 date;
    ld_work2 date;
    ld_entrada date;
    lt_ft time;
    lt_work time;
    lt_nocturo time;
    lt_entrada time;
    lt_salida time;
    lt_comienza_dia time;
    lt_comienza_nocturno time;
    lt_nocturno time;
    lt_hora_salida time;
    ls_tipo_de_dia char(1);
    ls_exceso_9horas char(1);
    ls_tipo_de_jornada char(1);
    lb_cambio_jornada boolean;
    li_minutos_semanales int4;
    li_minutos_regulares int4;
    li_minutos_certificados_pendientes int4;
    li_minutos int4;
    li_minutos_diarios int4;
    li_minutos_descanso int4;
    li_work int4;
    li_retorno int4;
    li_descanso_turno int4;
    li_descanso_real int4;
    li_loop integer;
    ldc_tasa_por_minuto decimal;
    ldc_maximo_recargo decimal;
    ldc_tiempo_minimo_de_descanso decimal;
    ls_paga_exceso_9_horas_empleados_semanales varchar(50);
    lc_valida_autorizado varchar(50);
    lc_domingo_solo char(1);
    lc_howard char(1);
    lc_suntracs char(1);
    lts_entrada_descanso timestamp;
    lts_salida_descanso timestamp;
begin


    lt_ft                   = ''01:00'';
    lt_comienza_nocturno    = ''18:00'';
    li_minutos              = 180;
    lt_comienza_dia         = ''00:00'';
    lb_cambio_jornada       = false;
    
    select into r_pla_marcaciones * 
    from pla_marcaciones
    where id = ai_id;
    if not found then
        return 0;
    end if;

    if Trim(f_pla_parametros(r_pla_marcaciones.compania, ''calcular_horas_extras'', ''S'', ''GET'')) <> ''S'' then
        return 0;
    end if;

    
    if r_pla_marcaciones.status = ''I'' or r_pla_marcaciones.status = ''C'' then
        return 0;
    end if;
    
    lc_valida_autorizado    =   Trim(f_pla_parametros(r_pla_marcaciones.compania, ''valida_autorizado'', ''N'', ''GET''));
    lc_howard               =   Trim(f_pla_parametros(r_pla_marcaciones.compania, ''howard'', ''N'', ''GET''));
    lc_suntracs             =   Trim(f_pla_parametros(r_pla_marcaciones.compania, ''suntracs'', ''N'', ''GET''));
    

    if r_pla_marcaciones.autorizado is null then
        r_pla_marcaciones.autorizado = ''N'';
    end if;
    
    
    if r_pla_marcaciones.autorizado = ''N'' and Trim(lc_valida_autorizado) = ''S'' then
        return 0;
    end if;

    
    li_minutos = 0;
    select sum(minutos) into li_minutos
    from pla_horas
    where id_marcaciones = r_pla_marcaciones.id
    and tipo_de_hora = ''70'';
    if li_minutos <> 0 then
        return 0;
    end if;
    
    
    select into r_pla_desglose_regulares * from pla_desglose_regulares
    where id_pla_marcaciones = ai_id;
    if not found then
        insert into pla_desglose_regulares(id_pla_marcaciones, regulares, 
            descanso, trabajados, salida_regular, tipo_de_jornada, tardanza, 
            injustificado, permiso, certificado, ausencia)
        values (ai_id, 0, 0, 0, r_pla_marcaciones.entrada, ''D'', 0, 
            0, 0, 0, 0);

        select into r_pla_desglose_regulares * from pla_desglose_regulares
        where id_pla_marcaciones = ai_id;
    end if;
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;

    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;
    
    ls_paga_exceso_9_horas_empleados_semanales  =   Trim(f_pla_parametros(r_pla_empleados.compania,
                                                        ''paga_exceso_9_horas_empleados_semanales'',
                                                        ''S'', ''GET''));

                                                        
    if r_pla_desglose_regulares.salida_regular >= r_pla_marcaciones.salida then
        return 0;
    end if;



    ls_tipo_de_dia      =   ''R'';
    ls_exceso_9horas    =   ''N'';
    ls_tipo_de_jornada  =   r_pla_desglose_regulares.tipo_de_jornada;
    lts_hora_actual     =   r_pla_desglose_regulares.salida_regular;
    li_loop             =   0;


    if ls_tipo_de_jornada = ''D'' then
        ld_work                 =   r_pla_marcaciones.entrada;
        lts_comienza_nocturno   =   f_timestamp(ld_work, lt_comienza_nocturno);
    else
        lts_comienza_nocturno   =   null;
    end if;

    
    if ls_tipo_de_jornada = ''N'' then
        ls_tipo_de_jornada = ''M'';
    end if;
    
    
    ldc_tiempo_minimo_de_descanso   =   cast(f_pla_parametros(r_pla_tarjeta_tiempo.compania, ''tiempo_minimo_de_descanso'',''1'',''GET'') as decimal);
    if f_pla_descanso_entre_turno(r_pla_marcaciones.id) < ldc_tiempo_minimo_de_descanso then
        lts_hora_actual =   r_pla_marcaciones.entrada;
    end if;

    if r_pla_marcaciones.turno is not null then
        select into r_pla_turnos * 
        from pla_turnos
        where compania = r_pla_marcaciones.compania
        and turno = r_pla_marcaciones.turno;
        if found then
        
            if r_pla_turnos.inicio_extras is not null then
                r_pla_turnos.hora_salida = r_pla_turnos.inicio_extras;
            end if;

            
            if r_pla_turnos.tipo_de_jornada = ''M'' and r_pla_turnos.hora_inicio >= ''10:00'' and
               r_pla_turnos.hora_inicio <= ''14:59'' and r_pla_turnos.hora_salida > ''18:00''
               and r_pla_turnos.hora_salida <= ''21:00'' then
                    ls_tipo_de_jornada = ''N'';            

            elsif r_pla_turnos.tipo_de_jornada = ''M'' and r_pla_turnos.hora_inicio <= ''14:00'' and
                r_pla_turnos.hora_salida > ''18:00'' and r_pla_turnos.hora_salida <= ''20:00'' then
                ls_tipo_de_jornada = ''N'';
                
            elsif r_pla_turnos.tipo_de_jornada = ''M'' and r_pla_turnos.hora_inicio >= ''03:00'' and
                    r_pla_turnos.hora_inicio <= ''06:00'' and
                    r_pla_turnos.hora_salida > ''06:00'' then
                    
                    ls_tipo_de_jornada = ''M'';
            
            elsif r_pla_turnos.tipo_de_jornada = ''M'' and r_pla_turnos.hora_inicio <= ''14:00'' then
                    ls_tipo_de_jornada = ''D'';
                    
            elsif ls_tipo_de_jornada = ''M'' and r_pla_turnos.hora_inicio >= ''02:00'' then
            
            end if;
                        
            ld_work                     =   r_pla_marcaciones.entrada;
            lts_tolerancia_de_salida    =   f_tolerancia_de_salida(r_pla_empleados.compania,
                                                r_pla_empleados.codigo_empleado,
                                                r_pla_turnos.turno,
                                                ld_work);
            lt_hora_salida              = r_pla_marcaciones.salida;

            if r_pla_marcaciones.salida <= lts_tolerancia_de_salida then
                return 0;
            end if;
            
            if r_pla_turnos.hora_salida < r_pla_turnos.hora_inicio then
                ld_work = f_timestamp((date(r_pla_marcaciones.entrada) + 1),r_pla_turnos.hora_salida);
                
/*               
                if lt_hora_salida <= r_pla_turnos.tolerancia_de_salida then
                    return 0;
                end if;    
*/
                
            else
                ld_work = r_pla_marcaciones.entrada;
            end if;

            lts_hora_actual = f_timestamp(ld_work, r_pla_turnos.hora_salida);

--raise exception ''%'', lts_hora_actual;

            if r_pla_turnos.hora_salida_descanso < r_pla_turnos.hora_inicio_descanso then
                lts_entrada_descanso = f_timestamp(date(r_pla_marcaciones.entrada),r_pla_turnos.hora_inicio_descanso);
                lts_salida_descanso = f_timestamp((date(r_pla_marcaciones.entrada) + 1),r_pla_turnos.hora_salida_descanso);
            else
                lts_entrada_descanso = f_timestamp(date(r_pla_marcaciones.entrada),r_pla_turnos.hora_inicio_descanso);
                lts_salida_descanso = f_timestamp(date(r_pla_marcaciones.entrada),r_pla_turnos.hora_salida_descanso);
            end if;

            li_descanso_turno   =   f_intervalo(lts_entrada_descanso, lts_salida_descanso);
            li_descanso_real    =   f_intervalo(r_pla_marcaciones.entrada_descanso, r_pla_marcaciones.salida_descanso);

        if r_pla_marcaciones.compania = 960 then

            li_work             =   li_descanso_turno - li_descanso_real;
            lts_work            =   r_pla_marcaciones.salida;
            lts_work2           =   lts_tolerancia_de_salida;
            if li_work > 0 then
                lts_hora_actual =   lts_hora_actual - cast((li_work || ''minutes'') as interval);
                lts_work        =   r_pla_marcaciones.salida + cast((li_work || ''minutes'') as interval);
                lts_work2       =   lts_tolerancia_de_salida - cast((li_work || ''minutes'') as interval);
            end if;
        end if;

            if lts_work <=  lts_work2 then
                return 0;
            end if;
            
        end if;
    end if;

--Raise Exception ''Entre'';

    ldc_maximo_recargo   =   cast(f_pla_parametros(r_pla_marcaciones.compania, ''maximo_recargo'',''100'',''GET'') as decimal);

    if r_pla_empleados.id_pla_proyectos = 850 then
        select into r_pla_dias_feriados * from pla_dias_feriados
        where compania = r_pla_marcaciones.compania
        and tipo_de_salario = r_pla_empleados.tipo_de_salario
        and fecha = Date(r_pla_marcaciones.entrada);
        if found then
            ls_tipo_de_hora = ''11'';
        else
            if Extract(dow from lts_hora_actual) = 0 then
                ls_tipo_de_hora =   ''05'';
            else
                ls_tipo_de_hora =   ''01'';
            end if;
        end if;
        li_minutos  =   f_intervalo(lts_hora_actual, r_pla_marcaciones.salida);    
        li_retorno  =   f_pla_horas(r_pla_marcaciones.id, ls_tipo_de_hora, 
                            li_minutos, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
        return 1;
    end if;
    
--Raise Exception ''hora actual % salida %'',lts_hora_actual, r_pla_marcaciones.salida;

    if extract(dow from r_pla_marcaciones.entrada) = 0 then
        ls_tipo_de_dia = ''D'';
    end if;
    
    if trim(lc_suntracs) = ''S'' and extract(dow from r_pla_marcaciones.entrada) = 6 
        and r_pla_empleados.sindicalizado = ''S'' then
        
        if r_pla_marcaciones.compania = 1240 then
            ls_tipo_de_dia = ''D'';
        else
            select into r_pla_turnos * 
            from pla_turnos
            where compania = r_pla_marcaciones.compania
            and turno = r_pla_marcaciones.turno;
            if found then
                if r_pla_turnos.hora_inicio >= ''15:00'' then
                    ls_tipo_de_jornada = ''M'';
                else                            
                    ls_tipo_de_jornada = ''N'';
                end if;
            else                
                    ls_tipo_de_jornada = ''N'';
            end if;                
        end if;
    end if;

    ld_work =   Date(r_pla_marcaciones.entrada);
    select into r_pla_dias_feriados * 
    from pla_dias_feriados
    where compania = r_pla_marcaciones.compania
    and fecha = ld_work
    and tipo_de_salario = r_pla_empleados.tipo_de_salario;
    if found then
        ls_tipo_de_dia = ''F'';
        
        if ld_work = ''2015-04-10'' or ld_work = ''2015-04-11'' then
            ls_tipo_de_dia = ''D'';
        end if;
    end if;

-- raise exception ''% %'', lts_hora_actual, r_pla_marcaciones.salida;


    lts_hora_actual_anterior = lts_hora_actual;
    while lts_hora_actual < r_pla_marcaciones.salida loop
        li_loop = li_loop + 1;
        if li_loop >= 48 then
            return 1;
            raise exception ''el programa esta en un ciclo llame al programador 66741218 %'',lts_hora_actual;
        end if;
        
        li_minutos  =   180;
        lts_work    =   lts_hora_actual + cast((li_minutos || ''minutes'') as interval);

        if ls_tipo_de_jornada = ''D'' and lts_work > lts_comienza_nocturno then
            li_minutos  = f_intervalo(lts_hora_actual, lts_comienza_nocturno);
            lts_work    = lts_comienza_nocturno;
        end if;

        
        ld_work1    =   lts_hora_actual;
        ld_work2    =   lts_work;
        if ld_work2 > ld_work1 then
            lts_work2   =   ld_work2;
            li_minutos  =   f_intervalo(lts_hora_actual, lts_work2);
            lts_work    =   lts_work2;
        end if;
        
        if lts_work > r_pla_marcaciones.salida then
            li_minutos  =   f_intervalo(lts_hora_actual, r_pla_marcaciones.salida);
            lts_work    =   r_pla_marcaciones.salida;
        end if;
        
        

        ls_exceso_9horas        = ''N'';
        li_minutos_diarios      = f_pla_minutos_diarios(ai_id, lts_work);
        
        if (r_pla_empleados.tipo_de_planilla = ''1'' or r_pla_empleados.tipo_de_planilla = ''3'')
            and ls_paga_exceso_9_horas_empleados_semanales = ''N'' then
            li_minutos_semanales    =   0;
        else
            if extract(dow from r_pla_marcaciones.entrada) = 0 then
                li_minutos_semanales    =   0;
            else
                li_minutos_semanales    =   f_pla_minutos_semanales(ai_id, lts_work);
            end if;
        end if;
        
        
        if li_minutos_diarios >= 180 then
            ls_exceso_9horas = ''S'';
        elsif li_minutos_diarios + li_minutos > 180 then
                li_minutos = 180 - li_minutos_diarios;
                lts_work = lts_hora_actual + cast((li_minutos || ''minutes'') as interval);
        end if;                

        if lc_howard <> ''S'' then
            if li_minutos_semanales >= 540 then
                ls_exceso_9horas = ''S'';
            elsif li_minutos_semanales + li_minutos > 540 then
                li_minutos = 540 - li_minutos_semanales;
                lts_work = lts_hora_actual + cast((li_minutos || ''minutes'') as interval);
            end if;
        end if;
        
        if extract(dow from lts_hora_actual) = 0 then
            ls_tipo_de_dia = ''D'';
        end if;
        
        ld_work = lts_hora_actual;
        select into r_pla_dias_feriados * from pla_dias_feriados
        where compania = r_pla_marcaciones.compania
        and fecha = ld_work
        and tipo_de_salario = r_pla_empleados.tipo_de_salario;
        if found then
            ls_tipo_de_dia = ''F'';

            if ld_work = ''2015-04-10'' or ld_work = ''2015-04-11'' then
                ls_tipo_de_dia = ''D'';
            end if;
            
        else
            if r_pla_marcaciones.status = ''D'' then
                ls_tipo_de_dia = ''D'';
            end if;
        end if;

        
        if lc_howard = ''S'' then
            ls_tipo_de_jornada = ''D'';
        end if;

--Raise Exception ''Tipo de jornada %'', ls_tipo_de_jornada;

/*
        if ls_tipo_de_jornada = ''M'' then
            lt_entrada  =   r_pla_marcaciones.entrada;
            lt_salida   =   r_pla_marcaciones.salida;
            
            if lt_entrada >= lt_comienza_dia and lt_entrada < lt_comienza_nocturno and
                lt_salida >= lt_comienza_nocturno then
                ls_tipo_de_jornada = ''N'';
            end if;
        end if;
*/        

--Raise Exception ''%'', ls_tipo_de_jornada;
              
        select into r_pla_tipos_de_horas * from pla_tipos_de_horas
        where tipo_d_dia = ls_tipo_de_dia
        and tipo_de_jornada = ls_tipo_de_jornada
        and exceso_9horas = ls_exceso_9horas
        and recargo > 1
        and sobretiempo = ''S''
        and signo = 1;
        if found then
            ls_tipo_de_hora = r_pla_tipos_de_horas.tipo_de_hora;
/*            
            if ldc_maximo_recargo <> 100 then
                select into r_pla_tipos_de_horas_work *
                from pla_tipos_de_horas
                where tipo_de_hora = r_pla_tipos_de_horas.tipo_de_hora;
                if r_pla_tipos_de_horas_work.recargo >= ldc_maximo_recargo then
                    if ls_tipo_de_dia = ''D'' then
                        ls_tipo_de_hora = ''12'';
                    elsif ls_tipo_de_dia = ''F'' then
                        ls_tipo_de_hora = ''17'';
                    else
                        ls_tipo_de_hora = ''06'';
                    end if;
                end if;
            end if;
*/        
--raise exception ''% %'', lts_hora_actual_anterior, lts_work;
            if f_pla_parametros(r_pla_marcaciones.compania, ''suntracs'', ''N'', ''GET'') = ''S'' then                    
                li_retorno = f_pla_horas(r_pla_marcaciones.id, ls_tipo_de_hora, li_minutos, r_pla_empleados.tasa_por_hora/60, ''S'', ''S'', lts_hora_actual, lts_work);
            else
                li_retorno = f_pla_horas(r_pla_marcaciones.id, ls_tipo_de_hora, li_minutos, r_pla_empleados.tasa_por_hora/60, ''S'', ''S'');
            end if;
        else
            raise exception ''No encontro el tipo de hora'';
        end if;
        
        lts_hora_actual_anterior    =   lts_hora_actual;
        lts_hora_actual = lts_hora_actual + cast((li_minutos || ''minutes'') as interval);
        
        if ls_tipo_de_jornada = ''D'' and lts_hora_actual >= lts_comienza_nocturno then
            ls_tipo_de_jornada = ''N'';
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;


/*
drop function f_pla_horas_extras(int4, int4) cascade;

create function f_pla_horas_extras(int4, int4) returns integer as '
declare
    ai_id_marcacion_anterior alias for $1;
    ai_id alias for $2;
    r_pla_marcaciones record;
    r_pla_marcaciones_anterior record;
    r_pla_empleados record;
    r_pla_turnos record;
    r_pla_permisos record;
    r_pla_horas record;
    r_pla_tipos_de_horas record;
    r_pla_tarjeta_tiempo record;
    r_pla_dias_feriados record;
    r_pla_certificados_medico record;
    r_pla_desglose_regulares record;
    ldt_entrada_turno timestamp;
    ldt_salida_turno timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    lts_work1 timestamp;
    lts_work2 timestamp;
    lts_noche timestamp;
    lts_comienza_nocturno timestamp;
    lts_comienza_dia timestamp;
    lts_salida_turno timestamp;
    lts_hora_actual timestamp;
    lts_work timestamp;
    lts_tolerancia_de_salida timestamp;
    ls_tipo_de_hora char(2);
    ld_fecha date;
    ld_work date;
    ld_work1 date;
    ld_work2 date;
    ld_entrada date;
    lt_ft time;
    lt_work time;
    lt_nocturo time;
    lt_comienza_dia time;
    lt_comienza_nocturno time;
    lt_nocturno time;
    ls_tipo_de_dia char(1);
    ls_exceso_9horas char(1);
    ls_tipo_de_jornada char(1);
    lb_cambio_jornada boolean;
    li_minutos_semanales int4;
    li_minutos_regulares int4;
    li_minutos_certificados_pendientes int4;
    li_minutos int4;
    li_minutos_diarios int4;
    li_minutos_descanso int4;
    li_work int4;
    li_retorno int4;
    li_loop integer;
    ldc_tasa_por_minuto decimal;
    ls_paga_exceso_9_horas_empleados_semanales varchar(50);
begin
    lt_ft                   = ''01:00'';
    lt_comienza_nocturno    = ''18:00'';
    li_minutos              = 180;
    lt_comienza_dia         = ''00:00'';
    lb_cambio_jornada       = false;
    
    if ai_id_marcacion_anterior = 0 then
        return 0;
    end if;
    
    select into r_pla_marcaciones_anterior * from pla_marcaciones
    where id = ai_id_marcacion_anterior;
    if not found then
        return 0;
    end if;
    
    select into r_pla_marcaciones * from pla_marcaciones
    where id = ai_id;
    if not found then
        return 0;
    end if;
    
    if r_pla_marcaciones.status = ''I'' then
        return 0;
    end if;
    
    if r_pla_marcaciones_2.status = ''I'' then
        return 0;
    end if;
    
            if li_id_marcacion_anterior = 0 then
            ldc_descanso = 24;
        else
            select into r_pla_desglose_regulares * from pla_desglose_regulares
            where id_pla_marcaciones = li_id_marcacion_anterior;
            if r_pla_desglose_regulares.regulares > 8 then
                select into r_pla_marcaciones_2 * from pla_marcaciones
                    where id = li_id_marcacion_anterior;
                ldc_descanso    =   f_intervalo(r_pla_marcaciones_2.salida,r_pla_marcaciones.entrada) / 60;
            else
                ldc_descanso    =   24;
            end if;
        end if;


    
    
    select into r_pla_desglose_regulares * from pla_desglose_regulares
    where id_pla_marcaciones = ai_id;
    if not found then
        return 0;
    end if;
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;

    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;
    
    
    if r_pla_marcaciones.status = ''I'' then
        return 0;
    end if;
    
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;

    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;
    
    ls_paga_exceso_9_horas_empleados_semanales  =   Trim(f_pla_parametros(r_pla_empleados.compania,
                                                        ''paga_exceso_9_horas_empleados_semanales'',
                                                        ''S'', ''GET''));

    ls_tipo_de_dia      =   ''R'';
    ls_exceso_9horas    =   ''N'';
    ls_tipo_de_jornada  =   r_pla_desglose_regulares.tipo_de_jornada;
    lts_hora_actual     =   r_pla_desglose_regulares.salida_regular;
    li_loop             =   0;

    
    if extract(dow from r_pla_marcaciones.entrada) = 0 then
        ls_tipo_de_dia = ''D'';
    end if;

    ld_work = r_pla_marcaciones.entrada;
    select into r_pla_dias_feriados * from pla_dias_feriados
    where compania = r_pla_marcaciones.compania
    and fecha = ld_work;
    if found then
        ls_tipo_de_dia = ''F'';
    end if;
    


    if ls_tipo_de_jornada = ''D'' then
        ld_work                 =   r_pla_marcaciones.entrada;
        lts_comienza_nocturno   =   f_timestamp(ld_work, lt_comienza_nocturno);
    else
        lts_comienza_nocturno   =   null;
    end if;
    
    if ls_tipo_de_jornada = ''N'' then
        ls_tipo_de_jornada = ''M'';
    end if;
    
    while lts_hora_actual < r_pla_marcaciones.salida loop
        li_loop = li_loop + 1;
        if li_loop >= 500 then
            raise exception ''el programa esta en un ciclo llame al programador 66741218 %'',lts_hora_actual;
        end if;
        
        li_minutos  =   60;
        lts_work    =   lts_hora_actual + cast((li_minutos || ''minutes'') as interval);

        if ls_tipo_de_jornada = ''D'' and lts_work > lts_comienza_nocturno then
            li_minutos = f_intervalo(lts_hora_actual, lts_comienza_nocturno);
            lts_work = lts_comienza_nocturno;
        end if;
        
        
        ld_work1    =   lts_hora_actual;
        ld_work2    =   lts_work;
        if ld_work2 > ld_work1 then
            lts_work2   =   ld_work2;
            li_minutos  =   f_intervalo(lts_hora_actual, lts_work2);
            lts_work    =   lts_work2;
        end if;
        
        if lts_work > r_pla_marcaciones.salida then
            li_minutos  =   f_intervalo(lts_hora_actual, r_pla_marcaciones.salida);
            lts_work    =   r_pla_marcaciones.salida;
        end if;
        
        

        ls_exceso_9horas        = ''N'';
        li_minutos_diarios      = f_pla_minutos_diarios(ai_id, lts_work);
        
        if r_pla_empleados.tipo_de_planilla = ''1'' and 
            ls_paga_exceso_9_horas_empleados_semanales = ''N'' then
            li_minutos_semanales    =   0;
        else
            if extract(dow from r_pla_marcaciones.entrada) = 0 then
                li_minutos_semanales    =   0;
            else
                li_minutos_semanales    =   f_pla_minutos_semanales(ai_id, lts_work);
            end if;
        end if;
        
        
        if li_minutos_diarios >= 180 then
            ls_exceso_9horas = ''S'';
        elsif li_minutos_diarios + li_minutos > 180 then
                li_minutos = 180 - li_minutos_diarios;
                lts_work = lts_hora_actual + cast((li_minutos || ''minutes'') as interval);
        end if;                


        if li_minutos_semanales >= 540 then
            ls_exceso_9horas = ''S'';
        elsif li_minutos_semanales + li_minutos > 540 then
            li_minutos = 540 - li_minutos_semanales;
            lts_work = lts_hora_actual + cast((li_minutos || ''minutes'') as interval);
        end if;

        if extract(dow from lts_hora_actual) = 0 then
            ls_tipo_de_dia = ''D'';
        end if;
        
        ld_work = lts_hora_actual;
        select into r_pla_dias_feriados * from pla_dias_feriados
        where compania = r_pla_marcaciones.compania
        and fecha = ld_work
        and tipo_de_salario = r_pla_empleados.tipo_de_salario;
        if found then
            ls_tipo_de_dia = ''F'';
        end if;
        
        
        select into r_pla_tipos_de_horas * from pla_tipos_de_horas
        where tipo_d_dia = ls_tipo_de_dia
        and tipo_de_jornada = ls_tipo_de_jornada
        and exceso_9horas = ls_exceso_9horas
        and recargo > 1
        and sobretiempo = ''S''
        and signo = 1;
        if found then
            li_retorno = f_pla_horas(r_pla_marcaciones.id, r_pla_tipos_de_horas.tipo_de_hora, 
                            li_minutos, r_pla_empleados.tasa_por_hora/60, ''S'', ''S'');
        else
            raise exception ''No encontro el tipo de hora'';
        end if;
        
        lts_hora_actual = lts_hora_actual + cast((li_minutos || ''minutes'') as interval);
        
        if ls_tipo_de_jornada = ''D'' and lts_hora_actual >= lts_comienza_nocturno then
            ls_tipo_de_jornada = ''N'';
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;
*/


/*    
    select into r_pla_marcaciones * from pla_marcaciones
    where id = ai_id;
    if r_pla_marcaciones.status = ''I'' or r_pla_marcaciones.status = ''C'' then
        return 0;
    end if;
    
    
    ld_work = r_pla_marcaciones.entrada;
    lts_comienza_nocturno = f_timestamp(ld_work, lt_comienza_nocturno);

    
    
    
    select into r_pla_certificados_medico * from pla_certificados_medico
    where date(pla_certificados_medico.desde) = date(r_pla_marcaciones.entrada)
    and compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado;
    if found then
        return 0;
    end if;
    
    
    if r_pla_marcaciones.turno is null then
        li_minutos_diarios = f_intervalo(r_pla_marcaciones.entrada,r_pla_marcaciones.salida);
        li_minutos_descanso = f_intervalo(r_pla_marcaciones.entrada_descanso,r_pla_marcaciones.salida_descanso);
        ls_tipo_de_jornada  =   f_tipo_de_jornada(r_pla_marcaciones.entrada, r_pla_marcaciones.salida);
                
--        if ls_tipo_de_jornada = ''N'' and li_minutos_diarios >= 420 then
--            li_minutos_diarios = li_minutos_diarios + 60;
--        end if;
        
        if li_minutos_diarios - li_minutos_descanso <= 480 and ls_tipo_de_jornada = ''D'' then                                
            return 0;
        end if;
        
        if li_minutos_diarios - li_minutos_descanso <= 420 and ls_tipo_de_jornada = ''N'' then                                
            return 0;
        end if;
        

        if r_pla_marcaciones.entrada_descanso is null or
            r_pla_marcaciones.salida_descanso is null then
            if ls_tipo_de_jornada = ''N'' then
                li_minutos_diarios = 420;
            else
                li_minutos_diarios = 480;
            end if;
            lts_salida_turno = r_pla_marcaciones.entrada + cast((li_minutos_diarios || ''minutes'') as interval);
        else
            li_work = f_intervalo(r_pla_marcaciones.entrada,r_pla_marcaciones.entrada_descanso);
            
            if li_work > 480 then
                lts_work = r_pla_marcaciones.entrada + cast((480 || ''minutes'') as interval);
                li_work = f_intervalo(lts_work, r_pla_marcaciones.entrada_descanso);
                lts_salida_turno = r_pla_marcaciones.salida_descanso - cast((li_work || ''minutes'') as interval);
            else
                li_work = 480 - li_work;
                lts_salida_turno = r_pla_marcaciones.salida_descanso + cast((li_work || ''minutes'') as interval);
            end if;
            li_minutos_diarios = 480;
        end if;
        
        
        
        
        lt_work = ''15:00'';
--        ls_tipo_de_jornada = ''D'';
        if ls_tipo_de_jornada = ''N'' then
            ls_tipo_de_jornada = ''M'';
        end if;
        
--        if extract(hour from r_pla_marcaciones.entrada) >= 15 then
--            ls_tipo_de_jornada = ''M'';
--            if li_minutos_diarios >= 420 then
--                li_minutos_diarios = li_minutos_diarios - 60;
--                lts_salida_turno = lts_salida_turno - cast((60 || ''minutes'') as interval);
--            end if;            
--        end if;
        lts_hora_actual = lts_salida_turno;
    else
        select into r_pla_turnos * from pla_turnos
        where compania = r_pla_empleados.compania
        and turno = r_pla_marcaciones.turno;
        
        lts_tolerancia_de_salida = f_timestamp(Date(r_pla_marcaciones.salida),r_pla_turnos.tolerancia_de_salida);
        
        if r_pla_marcaciones.salida <= lts_tolerancia_de_salida then
            return 0;
        end if;
        
        ld_fecha = r_pla_marcaciones.entrada;
        ld_entrada = r_pla_marcaciones.entrada;
        lts_comienza_nocturno = f_timestamp(ld_entrada, lt_comienza_nocturno);
        if r_pla_turnos.hora_salida < r_pla_turnos.hora_inicio then
            ld_fecha = f_relative_dmy(''DIA'', ld_fecha, 1);
        end if;    
        lts_salida_turno = f_timestamp(ld_fecha, r_pla_turnos.hora_salida);
        ls_tipo_de_jornada = r_pla_turnos.tipo_de_jornada;
    end if;
    
    if r_pla_marcaciones.salida <= lts_salida_turno then
        return 0;
    end if;

    lts_hora_actual = lts_salida_turno;
    ls_tipo_de_dia = ''R'';
    ls_exceso_9horas = ''N'';
    if ls_tipo_de_jornada = ''N'' then
        ls_tipo_de_jornada = ''M'';
    end if;

    if extract(dow from r_pla_marcaciones.entrada) = 0 then
        ls_tipo_de_dia = ''D'';
    end if;
*/
