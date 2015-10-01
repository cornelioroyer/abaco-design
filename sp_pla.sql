set search_path to dba;

drop function f_nomctrac_cglposteo(char(2), char(7), char(2), char(2), int4, int4) cascade;
drop function f_pla_reservas_cglposteo(char(7), char(2), char(2), char(3), char(2), int4, int4, char(30), char(3));
drop function f_pla_reservas_cglposteo_resumido(char(2), date) cascade;
drop function f_timestamp(date, time) cascade;
drop function f_vacaciones_x_pagar(char(2), char(7), date) cascade;
drop function f_vacaciones_x_pagar_gto_repre(char(2), char(7), date) cascade;
drop function f_nomhrtrab_sin_turno(char(2), char(7), char(2), integer, date, date) cascade;
drop function f_deducciones_basicas(char(2), char(7), char(2), char(2), int4, int4) cascade;
drop function f_calculo_de(char(2), char(7), char(2), char(2), int4, int4, char(3)) cascade;
drop function f_pla_horas_regulares_excedentes(char(2), char(7), char(2), int4, int4) cascade;
drop function f_pla_valoriza_horas(char(2), char(7), char(2), int4, int4) cascade;
drop function f_nomctrac(char(2), char(7), char(2), char(2), int4, int4, char(3), decimal) cascade;
drop function f_pla_desglose_de_horas(char(2), char(7), char(2), int4, date, date) cascade;
drop function f_tipo_de_jornada(timestamp, timestamp) cascade;
drop function f_nomhoras(char(2), char(7), char(2), int4, int4, date, date, char(2), decimal, decimal) cascade;
--drop function f_nomhrtrab(char(2), char(7), char(2), integer, date, date) cascade;
drop function f_poner_ausencias(char(2), char(7), date) cascade;
drop function f_nomctrac_pla_reservas(char(2), char(7), char(2), char(2), int4, int4, char(30), char(3));
--drop function f_nomctrac_pla_reservas(char(2), char(7), char(2), char(2), int4, int4, char(30), char(3)) cascade;



create function f_nomctrac_pla_reservas(char(2), char(7), char(2), char(2), int4, int4, char(30), char(3)) returns integer as '
declare
    as_compania alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_calculo alias for $3;
    as_tipo_planilla alias for $4;
    ai_year alias for $5;
    ai_numero_planilla alias for $6;
    as_numero_documento alias for $7;
    as_cod_concepto_planilla alias for $8;
    r_pla_reloj record;
    r_nomctrac record;
    r_nom_conceptos_para_calculo record;
    r_nomconce record;
    r_nomtpla2 record;
    ldc_reserva decimal;
    ldc_porcentaje decimal;
    lvc_metodo_calculo varchar(50);
begin

    lvc_metodo_calculo = Trim(f_gralparaxcia(as_compania, ''PLA'', ''metodo_calculo''));

    delete from pla_reservas
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado
    and tipo_calculo = as_tipo_calculo
    and tipo_planilla = as_tipo_planilla
    and year = ai_year
    and numero_planilla = ai_numero_planilla
    and numero_documento = as_numero_documento
    and cod_concepto_planilla = as_cod_concepto_planilla;

    select into r_nomctrac * 
    from nomctrac
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado
    and tipo_calculo = as_tipo_calculo
    and tipo_planilla = as_tipo_planilla
    and year = ai_year
    and numero_planilla = ai_numero_planilla
    and numero_documento = as_numero_documento
    and cod_concepto_planilla = as_cod_concepto_planilla;

    select into r_nomtpla2 *
    from nomtpla2
    where tipo_planilla = as_tipo_planilla
    and year = ai_year
    and numero_planilla = ai_numero_planilla;
    if not found then
        return 0;
    end if;
    
    select into r_nomconce *
    from nomconce
    where cod_concepto_planilla = as_cod_concepto_planilla;
    if not found then
        return 0;
    end if;

    r_nomctrac.monto = r_nomctrac.monto * r_nomconce.signo;

-- 108 vacaciones    
-- 402 s.s. patronal
-- 403 s.s. patronal del xiii mes
-- 404 s.e. patronal
-- 408 vacaciones reserva
-- 409 xiii reserva
-- 410 riesgos
-- 420 prima de antiguedad
-- 430 indemnizacion

    for r_nom_conceptos_para_calculo in select nom_conceptos_para_calculo.* 
                                            from nom_conceptos_para_calculo, nomconce
                                            where nom_conceptos_para_calculo.cod_concepto_planilla = nomconce.cod_concepto_planilla
                                            and nomconce.solo_patrono = ''S''
                                            and concepto_aplica = as_cod_concepto_planilla
                                            order by cod_concepto_planilla
    loop
        if trim(lvc_metodo_calculo) = ''coolhouse'' 
            and (r_nom_conceptos_para_calculo.cod_concepto_planilla = ''420'' 
            or r_nom_conceptos_para_calculo.cod_concepto_planilla = ''430''
            or r_nom_conceptos_para_calculo.cod_concepto_planilla = ''408''
            or r_nom_conceptos_para_calculo.cod_concepto_planilla = ''409'')  then
            continue;
        end if;
                    
        ldc_reserva = 0;
        if r_nom_conceptos_para_calculo.cod_concepto_planilla = ''402'' then
            if r_nomtpla2.dia_d_pago >= ''2013-01-01'' then
                ldc_reserva = r_nomctrac.monto * .1225;
            else
                ldc_reserva = r_nomctrac.monto * .12;
            end if;                
        elseif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''403'' then
            ldc_reserva = r_nomctrac.monto * .1075;
        elseif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''404'' then
            ldc_reserva = r_nomctrac.monto * 1.5/100;
        elseif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''408'' then
            ldc_reserva = r_nomctrac.monto / 11;
        elseif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''409'' then
-- reserva xiii mes
            if r_nomctrac.cod_concepto_planilla = ''108'' then
--                ldc_reserva = (r_nomctrac.monto / 12);
                  ldc_reserva = 0;
            else        
                ldc_reserva = (r_nomctrac.monto / 12) + (r_nomctrac.monto/11/12);
            end if;
            
        elseif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''410'' then
            ldc_porcentaje = f_gralparaxcia(r_nomctrac.compania, ''PLA'', ''porcentaje_rp'');        
            ldc_reserva = r_nomctrac.monto * (ldc_porcentaje/100);

        elseif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''420'' then
            if r_nomctrac.cod_concepto_planilla = ''108'' then
--                ldc_reserva = r_nomctrac.monto/52;
                ldc_reserva = 0;
            else
                ldc_reserva = r_nomctrac.monto/52 + (r_nomctrac.monto/11/52);
            end if;
            
        elseif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''430'' then
            if r_nomctrac.cod_concepto_planilla = ''108'' then
--                ldc_reserva = (r_nomctrac.monto/52*3.4) *.05;
                  ldc_reserva = 0;
            else
--                ldc_reserva = (r_nomctrac.monto/52*3.4 + (r_nomctrac.monto/11/52*3.4))*.05;
                ldc_reserva = (r_nomctrac.monto/52*3.4 + (r_nomctrac.monto/11/52*3.4));
            end if;
        end if;
        
        if ldc_reserva <> 0 then
            insert into pla_reservas(compania, codigo_empleado, tipo_calculo, cod_concepto_planilla,
                tipo_planilla, numero_planilla, year, numero_documento, concepto_reserva, monto)
            values(r_nomctrac.compania, r_nomctrac.codigo_empleado, r_nomctrac.tipo_calculo, 
                r_nomctrac.cod_concepto_planilla,
                r_nomctrac.tipo_planilla, r_nomctrac.numero_planilla, r_nomctrac.year, 
                r_nomctrac.numero_documento, 
                r_nom_conceptos_para_calculo.cod_concepto_planilla, ldc_reserva);
        end if;
        
        
    end loop; 

    
    return 1;
end;
' language plpgsql;



create function f_poner_ausencias(char(2), char(7), date) returns integer as '
declare
    as_compania alias for $1;
    as_codigo_empleado alias for $2;
    ad_fecha alias for $3;
    r_pla_reloj record;
begin
    select into r_pla_reloj *
    from pla_reloj
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado
    and fecha = ad_fecha;
    if not found then
        update nomhrtrab
        set status = ''I''
        where compania = as_compania
        and codigo_empleado = as_codigo_empleado
        and fecha_laborable = ad_fecha;
    end if;
    return 1;
end;
' language plpgsql;





/*
create function f_nomhrtrab(char(2), char(7), char(2), integer, date, date) returns integer as '
declare
    as_compania alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_planilla alias for $3;
    ai_numero_planilla alias for $4;
    ad_fecha_laborable alias for $5;
    ad_fecha_salida alias for $6;
    r_rhuempl record;
    r_nomhrtrab record;
    li_minutos_trabajado int4;
begin
    select into r_nomhrtrab * 
    from nomhrtrab
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado
    and tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and fecha_laborable = ad_fecha_laborable
    and fecha_salida = ad_fecha_salida;
    if not found then
        return 0;
    end if;
    
    if r_nomhrtrab.cod_id_turnos is null then
        return 0;
    end if;
    
    lts_inicio_descanso     =   f_timestamp(r_nomhrtrab.fecha_laborable,r_nomhrtrab.hora_de_descanso_inicio);
    lts_final_descanso      =   f_timestamp(r_nomhrtrab.fecha_laborable, r_nomhrtrab.hora_de_descanso_final);
    lts_entrada             =   f_timestamp(r_nomhrtrab.fecha_laborable, r_nomhrtrab.hora_de_inicio_trabajo);
    lts_salida              =   f_timestamp(r_nomhrtrab.fecha_salida, r_nomhrtrab.hora_de_salida_trabajo);
    
    li_minutos_descanso     =   f_intervalo(lts_inicio_descanso, lts_final_descanso);
    li_minutos_trabajados   =   f_intervalo(lts_entrada, lts_salida) - li_minutos_descanso;
    
    
    
    return 1;
end;
' language plpgsql;
*/


create function f_pla_horas_regulares_excedentes(char(2), char(7), char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_planilla alias for $3;
    ai_year alias for $4;
    ai_numero_planilla alias for $5;
    r_nomhrtrab record;
    r_nomhoras record;
    r_rhuturno record;
    r_rhuempl record;
    ldc_horas_excedentes decimal;
    ldc_work_acum decimal;
    ldc_work decimal;
    ldc_horas_minutos decimal;
    ldc_horas decimal;
    ldc_minutos decimal;
    ldc_sum_horas_regulares decimal;
    lts_inicio_trabajo timestamp;
    lts_salida_trabajo timestamp;
    lts_inicio_descanso timestamp;
    lts_finalizar_descanso timestamp;
    li_minutos_regulares int4;
begin
    select into r_rhuempl * from rhuempl
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado;
    
    for r_nomhrtrab in select * from nomhrtrab
                        where compania = as_compania
                        and codigo_empleado = as_codigo_empleado
                        and tipo_planilla = as_tipo_planilla
                        and year = ai_year
                        and numero_planilla = ai_numero_planilla
                        order by fecha_laborable
    loop
        if r_nomhrtrab.cod_id_turnos is null then
            if Extract(dow from r_nomhrtrab.fecha_laborable) = 7 then
                select into r_rhuturno * from rhuturno
                where cod_id_turnos = r_rhuempl.turnosabado;
            else
                select into r_rhuturno * from rhuturno
                where cod_id_turnos = r_rhuempl.cod_id_turnos;
            end if;
        else
            select into r_rhuturno * from rhuturno
            where cod_id_turnos = r_nomhrtrab.cod_id_turnos;
        end if;


--        raise exception ''antes'';
                        
        lts_inicio_trabajo      =   f_timestamp(r_nomhrtrab.fecha_laborable,r_rhuturno.hora_inicio_trabajo);
        
--        raise exception ''%'',lts_inicio_trabajo;
        
        lts_salida_trabajo      =   f_timestamp(r_nomhrtrab.fecha_salida,r_rhuturno.hora_salida_trabajo);
        lts_inicio_descanso     =   f_timestamp(r_nomhrtrab.fecha_laborable,r_rhuturno.inicio_descanso);
        lts_finalizar_descanso  =   f_timestamp(r_nomhrtrab.fecha_laborable,r_rhuturno.finalizar_descanso);


        li_minutos_regulares    =   f_intervalo(lts_inicio_trabajo, lts_salida_trabajo) -
                                    f_intervalo(lts_inicio_descanso, lts_finalizar_descanso);
        
        if r_rhuturno.tipo_de_jornada = ''N'' then
            li_minutos_regulares = li_minutos_regulares + 60;
        end if;
        
        select into ldc_sum_horas_regulares sum((nomhoras.horas+(nomhoras.minutos/60))*nomtipodehoras.signo)
        from nomtipodehoras, nomhoras
        where nomtipodehoras.tipodhora = nomhoras.tipodhora
        and (nomtipodehoras.recargo = 1 or nomtipodehoras.tipodhora in (''91'',''22''))
        and compania = r_nomhrtrab.compania
        and codigo_empleado = r_nomhrtrab.codigo_empleado
        and tipo_planilla = r_nomhrtrab.tipo_planilla
        and year = r_nomhrtrab.year
        and numero_planilla = r_nomhrtrab.numero_planilla
        and fecha_laborable = r_nomhrtrab.fecha_laborable
        and fecha_salida = r_nomhrtrab.fecha_salida;
        if ldc_sum_horas_regulares is null then
            ldc_sum_horas_regulares = 0;
        end if;
        
        ldc_work    =   li_minutos_regulares;
        ldc_work    =   ldc_work / 60;
        ldc_horas_excedentes = ldc_sum_horas_regulares - ldc_work;
/*        
        if r_nomhrtrab.fecha_laborable = ''2008-10-25'' then
            return ldc_horas_excedentes;
        end if;
*/        
        if ldc_horas_excedentes > 0 then
            delete from nomhoras
            where nomhoras.tipodhora in 
            (select tipodhora from nomtipodehoras
                where signo = -1)
            and codigo_empleado = r_nomhrtrab.codigo_empleado
            and tipo_planilla = r_nomhrtrab.tipo_planilla
            and year = r_nomhrtrab.year
            and numero_planilla = r_nomhrtrab.numero_planilla
            and fecha_laborable = r_nomhrtrab.fecha_laborable
            and fecha_salida = r_nomhrtrab.fecha_salida
            and forma_de_registro = ''A'';

            ldc_work_acum = 0;
            ldc_horas_minutos = 0;
            for r_nomhoras in select ((nomhoras.horas+(nomhoras.minutos/60))*nomtipodehoras.signo) as hora_minuto,
                                nomhoras.* from nomtipodehoras, nomhoras
                                where nomtipodehoras.tipodhora = nomhoras.tipodhora
                                and (nomtipodehoras.recargo = 1 or nomtipodehoras.tipodhora in (''91'',''22''))
                                and compania = r_nomhrtrab.compania
                                and codigo_empleado = r_nomhrtrab.codigo_empleado
                                and tipo_planilla = r_nomhrtrab.tipo_planilla
                                and year = r_nomhrtrab.year
                                and numero_planilla = r_nomhrtrab.numero_planilla
                                and fecha_laborable = r_nomhrtrab.fecha_laborable
                                and fecha_salida = r_nomhrtrab.fecha_salida
                                order by nomtipodehoras.signo, nomhoras.tipodhora
            loop
                ldc_horas_minutos   =   r_nomhoras.hora_minuto;
                if ldc_work_acum + ldc_horas_minutos <= ldc_horas_excedentes then
                    ldc_horas       =   0;
                    ldc_minutos     =   0;
                    ldc_work_acum   =   ldc_work_acum + ldc_horas_minutos;
                else
                    ldc_horas       =   ldc_horas_minutos - (ldc_horas_excedentes - ldc_work_acum);
                    ldc_minutos     =   ldc_horas - Trunc(ldc_horas);
                    ldc_minutos     =   ldc_minutos * 60;
                    ldc_horas       =   Trunc(ldc_horas);
                    ldc_work_acum   =   ldc_work_acum + ldc_horas;
                end if;
                update nomhoras
                set horas = ldc_horas, minutos = ldc_minutos
                where compania = r_nomhoras.compania
                and codigo_empleado = r_nomhoras.codigo_empleado
                and tipo_planilla = r_nomhoras.tipo_planilla
                and year = r_nomhoras.year
                and numero_planilla = r_nomhoras.numero_planilla
                and fecha_laborable = r_nomhoras.fecha_laborable
                and fecha_salida = r_nomhoras.fecha_salida
                and tipodhora = r_nomhoras.tipodhora
                and acumula = r_nomhoras.acumula;
                
                if ldc_work_acum >= ldc_horas_excedentes then
                    exit;
                end if;
            end loop;
        end if;
    end loop;
    
    delete from nomhoras
    where horas = 0 and minutos = 0 and forma_de_registro = ''A'';
    
    return 1;
end;
' language plpgsql;


create function f_nomhoras(char(2), char(7), char(2), int4, int4, date, date, char(2), decimal, decimal) returns integer as '
declare
    as_compania alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_planilla alias for $3;
    ai_year alias for $4;
    ai_numero_planilla alias for $5;
    ad_fecha_laborable alias for $6;
    ad_fecha_salida alias for $7;
    as_tipodhora alias for $8;
    adc_horas alias for $9;
    adc_minutos alias for $10;
    r_nomhoras record;
    r_rhuempl record;
begin
/*
    select into r_rhuempl * from rhuempl
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    
    select into r_nomhoras * from nomhoras
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado
    and tipo_planilla = as_tipo_planilla
    and year = ai_year
    and numero_planilla = ai_numero_planilla
    and fecha_laborable = ad_fecha_laborable
    and fecha_salida = ad_fecha_salida
    and tipodhora = as_tipodhora
    and acumula = ''N'';
    if not found then
        insert into nomhoras(compania, codigo_empleado, tipo_planilla, year, numero_planilla,
            fecha_laborable, fecha_salida, tipodhora, acumula, forma_de_registro, 
            status, aplicar, tasaporhora, horas, minutos)
        values(as_compania, as_codigo_empleado, as_tipo_planilla
    else
    end if;
*/    
    return 1;
end;
' language plpgsql;


create function f_pla_desglose_de_horas(char(2), char(7), char(2), int4, date, date) returns integer as '
declare
    as_compania alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_planilla alias for $3;
    ai_numero_planilla alias for $4;
    ad_fecha_laborable alias for $5;
    ad_fecha_salida alias for $6;
    r_nomhrtrab record;
    r_rhuempl record;
    r_rhuturno record;
    r_nomdfer record;
    lt_comienza_dia time;
    lts_entrada timestamp;
    lts_salida timestamp;
    lts_inicio_descanso timestamp;
    lts_fin_descanso timestamp;
    lts_comienza_dia timestamp;
    lts_salida_turno timestamp;
    ld_salida_turno date;
    li_minutos_regulares int4;
    li_minutos_adicionales int4;
    li_minutos_cargados int4;
    li_minutos_descanso int4;
    li_work int4;
    li_retorno int4;
    ldc_horas decimal;
    ldc_minutos decimal;
    ls_tipo_de_hora char(2);
    ls_tipo_de_jornada char(1);
begin
    select into r_nomhrtrab * from nomhrtrab
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado
    and tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and fecha_laborable = ad_fecha_laborable
    and fecha_salida = ad_fecha_salida;
    if not found then
        return 0;
    end if;
    
    
    
    select into r_rhuempl * from rhuempl
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado;
                                
    if r_nomhrtrab.cod_id_turnos is null then
        lts_entrada         =   to_timestamp(f_concat_fecha_hora(r_nomhrtrab.fecha_laborable, r_nomhrtrab.hora_de_inicio_trabajo), ''YYYY/MM/DD HH:MI'');
        lts_salida          =   to_timestamp(f_concat_fecha_hora(r_nomhrtrab.fecha_salida, r_nomhrtrab.hora_de_salida_trabajo), ''YYYY/MM/DD HH:MI'');
        lts_inicio_descanso =   to_timestamp(f_concat_fecha_hora(r_nomhrtrab.fecha_laborable, r_nomhrtrab.hora_de_descanso_inicio), ''YYYY/MM/DD HH:MI'');
        lts_fin_descanso    =   to_timestamp(f_concat_fecha_hora(r_nomhrtrab.fecha_laborable, r_nomhrtrab.hora_de_descanso_final), ''YYYY/MM/DD HH:MI'');
        
        ls_tipo_de_jornada  =   f_tipo_de_jornada(lts_entrada, lts_salida);
        if ls_tipo_de_jornada = ''N'' and li_minutos_regulares >= 420 then
            li_minutos_adicionales = 60;
        end if;
        
        if ls_tipo_de_jornada = ''M'' and li_minutos_regulares >= 450 then
            li_minutos_adicionales = 30;
        end if;
    else
        select into r_rhuturno * from rhuturno
        where cod_id_turnos = r_nomhrtrab.cod_id_turnos;
    
        ls_tipo_de_jornada = r_rhuturno.tipo_de_jornada;
        
        if r_rhuturno.hora_salida_trabajo < r_rhuturno.hora_inicio_trabajo then
            lts_entrada         =   to_timestamp(f_concat_fecha_hora(r_nomhrtrab.fecha_laborable, r_rhuturno.hora_inicio_trabajo), ''YYYY/MM/DD HH:MI'');
            lts_salida          =   to_timestamp(f_concat_fecha_hora(r_nomhrtrab.fecha_salida, r_rhuturno.hora_salida_trabajo), ''YYYY/MM/DD HH:MI'');
        else
            lts_entrada         =   to_timestamp(f_concat_fecha_hora(r_nomhrtrab.fecha_laborable, r_rhuturno.hora_inicio_trabajo), ''YYYY/MM/DD HH:MI'');
            lts_salida          =   to_timestamp(f_concat_fecha_hora(r_nomhrtrab.fecha_laborable, r_rhuturno.hora_salida_trabajo), ''YYYY/MM/DD HH:MI'');
        end if;
    
        li_minutos_regulares = f_intervalo(lts_entrada, lts_salida) - f_intervalo(lts_inicio_descanso, lts_fin_descanso);
    
        if r_rhuturno.finalizar_descanso < r_rhuturno.inicio_descanso then
            lts_inicio_descanso=   to_timestamp(f_concat_fecha_hora(r_nomhrtrab.fecha_laborable, r_rhuturno.inicio_descanso), ''YYYY/MM/DD HH:MI'');
            lts_fin_descanso =   to_timestamp(f_concat_fecha_hora(r_nomhrtrab.fecha_salida, r_rhuturno.finalizar_descanso), ''YYYY/MM/DD HH:MI'');
        else
            lts_inicio_descanso=   to_timestamp(f_concat_fecha_hora(r_nomhrtrab.fecha_laborable, r_rhuturno.inicio_descanso), ''YYYY/MM/DD HH:MI'');
            lts_fin_descanso =   to_timestamp(f_concat_fecha_hora(r_nomhrtrab.fecha_laborable, r_rhuturno.finalizar_descanso), ''YYYY/MM/DD HH:MI'');
        end if;
        
    end if;
    
    li_minutos_adicionales  =   0;
    li_minutos_descanso     =   f_intervalo(lts_inicio_descanso, lts_fin_descanso);
    li_minutos_cargados     =   f_intervalo(lts_entrada, lts_salida) - f_intervalo(lts_inicio_descanso, lts_fin_descanso);
    li_minutos_regulares    =   li_minutos_cargados;
    
    if ls_tipo_de_jornada = ''N'' and li_minutos_cargados >= 420 then
        li_minutos_adicionales  =   60;
        li_minutos_regulares    =   420;
    end if;
    
    if ls_tipo_de_jornada = ''M'' and li_minutos_cargados >= 450 then
        li_minutos_adicionales  =   30;
        li_minutos_regulares    =   450;
    end if;
    
    if ls_tipo_de_jornada = ''D'' and li_minutos_cargados >= 480 then
        li_minutos_adicionales  =   0;
        li_minutos_regulares    =   480;
    end if; 
    
    
    ls_tipo_de_hora = ''00'';
    if extract(dow from lts_entrada) = 0 then
        ls_tipo_de_hora = ''91'';
    end if;

    select into r_nomdfer * from nomdfer
    where fecha = r_nomhrtrab.fecha_laborable;
    if found then
        ls_tipo_de_hora = r_nomdfer.tipodhora;
    end if;

    if li_minutos_regulares + li_minutos_cargados > 480 then
        lts_salida_turno    =   lts_salida - cast((li_minutos_regulares || ''minutes'') as interval);
    else
        lts_salida_turno    =   lts_salida;
    end if;
    
    
    lt_comienza_dia     =   ''00:00'';
    if r_nomhrtrab.fecha_salida > r_nomhrtrab.fecha_laborable then
        ld_salida_turno     =   lts_salida_turno;
        lts_comienza_dia    =   to_timestamp(f_concat_fecha_hora(ld_salida_turno, lt_comienza_dia), ''YYYY/MM/DD HH:MI'');
        li_work             =   f_intervalo(lts_entrada, lts_comienza_dia);
        ldc_horas           =   Trunc(li_work / 60);
        ldc_minutos         =   Mod(li_work/60);
        li_retorno          =   f_nomhoras(r_nomhrtrab.compania, r_nomhrtrab.codigo_empleado,
                                    r_nomhtrab.tipo_planilla, r_nomhrtrab.year,
                                    r_nomhrtrab.numero_planilla, r_nomhrtrab.fecha_laborable,
                                    r_nomhrtrab.fecha_salida, ls_tipo_de_hora, 
                                    ldc_horas, ldc_minutos);
                                    
        select into r_nomdfer * from nomdfer
        where fecha = ld_salida_turno;
        if not found then
            if extract(dow from ld_salida_turno) = 0 then
                li_work     =   li_minutos_regulares + li_minutos_adicionales - li_work;
                if li_work > 0 then
                    ldc_horas   =   Trunc(li_work/60);
                    ldc_minutos =   Mod(li_work/60);
                    li_retorno  =   f_nomhoras(r_nomhrtrab.compania, r_nomhrtrab.codigo_empleado,
                                        r_nomhtrab.tipo_planilla, r_nomhrtrab.year,
                                        r_nomhrtrab.numero_planilla, r_nomhrtrab.fecha_laborable,
                                        r_nomhrtrab.fecha_salida, ''91'',
                                        ldc_horas, ldc_minutos);
                end if;
            else
                li_work     =   li_minutos_regulares + li_minutos_adicionales - li_work;
                if li_work > 0 then
                    ldc_horas   =   Trunc(li_work/60);
                    ldc_minutos =   Mod(li_work/60);
                    li_retorno  =   f_nomhoras(r_nomhrtrab.compania, r_nomhrtrab.codigo_empleado,
                                        r_nomhtrab.tipo_planilla, r_nomhrtrab.year,
                                        r_nomhrtrab.numero_planilla, r_nomhrtrab.fecha_laborable,
                                        r_nomhrtrab.fecha_salida, ''00'',
                                        ldc_horas, ldc_minutos);
                end if;
            end if;
        else
            li_work     =   li_minutos_regulares + li_minutos_adicionales - li_work;
            if li_work > 0 then
                ldc_horas   =   Trunc(li_work/60);
                ldc_minutos =   Mod(li_work/60);
                li_retorno  =   f_nomhoras(r_nomhrtrab.compania, r_nomhrtrab.codigo_empleado,
                                    r_nomhtrab.tipo_planilla, r_nomhrtrab.year,
                                    r_nomhrtrab.numero_planilla, r_nomhrtrab.fecha_laborable,
                                    r_nomhrtrab.fecha_salida, r_nomdfer.tipodhora,
                                    ldc_horas, ldc_minutos);
            end if;
        end if;        
    else
        li_work     =   li_minutos_regulares + li_minutos_adicionales;
        if li_work > 0 then
            ldc_horas   =   Trunc(li_work/60);
            ldc_minutos =   Mod(li_work/60);
            li_retorno  =   f_nomhoras(r_nomhrtrab.compania, r_nomhrtrab.codigo_empleado,
                                r_nomhtrab.tipo_planilla, r_nomhrtrab.year,
                                r_nomhrtrab.numero_planilla, r_nomhrtrab.fecha_laborable,
                                r_nomhrtrab.fecha_salida, ls_tipo_de_hora,
                                ldc_horas, ldc_minutos);
        end if;
    end if;
    
    return 1;
end;
' language plpgsql;



create function f_pla_valoriza_horas(char(2), char(7), char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_planilla alias for $3;
    ai_year alias for $4;
    ai_numero_planilla alias for $5;
    r_nomhrtrab record;
    r_nomhoras record;
    r_rhuempl record;
    r_nomtpla2 record;
    r_pla_vacacion record;
    r_v_pla_horas_valorizadas_x_dia record;
    r_nomtipodehoras record;
    ldc_horas_excedentes decimal;
    ldc_work decimal;
    ldc_work_acum decimal;
    ldc_horas_minutos decimal;
    ldc_horas decimal;
    ldc_minutos decimal;
    ldc_sum_horas_regulares decimal;
    ldc_salario decimal;
    ldc_monto decimal;
    li_retorno integer;
begin
    delete from nomctrac
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado
    and tipo_calculo = ''1''
    and tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and year = ai_year
    and forma_de_registro = ''A'';
    
    select into r_rhuempl * from rhuempl
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    select into r_nomtpla2 * from nomtpla2
    where tipo_planilla = as_tipo_planilla
    and year = ai_year
    and numero_planilla = ai_numero_planilla;
    if not found then
        return 0;
    end if;

    if r_rhuempl.tipo_de_salario = ''H'' or r_rhuempl.fecha_inicio >= r_nomtpla2.desde then
        select into r_pla_vacacion * from pla_vacacion
        where compania = as_compania
        and codigo_empleado = as_codigo_empleado
        and ((r_nomtpla2.desde between pagar_desde and pagar_hasta)
        or (r_nomtpla2.hasta between pagar_desde and pagar_hasta));
        if found then
            for r_v_pla_horas_valorizadas_x_dia in
                select v_pla_horas_valorizadas_x_dia.cod_concepto_planilla,
                    sum(v_pla_horas_valorizadas_x_dia.monto*nomtipodehoras.signo) as monto
                    from v_pla_horas_valorizadas_x_dia, nomtipodehoras
                    where v_pla_horas_valorizadas_x_dia.tipodhora = nomtipodehoras.tipodhora
                    and compania = as_compania
                    and codigo_empleado = as_codigo_empleado
                    and tipo_planilla = as_tipo_planilla
                    and year = ai_year
                    and numero_planilla = ai_numero_planilla
                    and fecha_laborable > r_pla_vacacion.pagar_hasta
                    group by 1
                    order by 1
            loop
                li_retorno  =   f_nomctrac(as_compania, as_codigo_empleado,
                                    ''1'', as_tipo_planilla, ai_numero_planilla,
                                    ai_year, r_v_pla_horas_valorizadas_x_dia.cod_concepto_planilla,
                                    r_v_pla_horas_valorizadas_x_dia.monto);
            end loop;
        else
            for r_v_pla_horas_valorizadas_x_dia in
                select v_pla_horas_valorizadas_x_dia.cod_concepto_planilla,
                    sum(v_pla_horas_valorizadas_x_dia.monto*nomtipodehoras.signo) as monto
                    from v_pla_horas_valorizadas_x_dia, nomtipodehoras
                    where v_pla_horas_valorizadas_x_dia.tipodhora = nomtipodehoras.tipodhora
                    and compania = as_compania
                    and codigo_empleado = as_codigo_empleado
                    and tipo_planilla = as_tipo_planilla
                    and year = ai_year
                    and numero_planilla = ai_numero_planilla
                    and fecha_laborable >= r_rhuempl.fecha_inicio
                    group by 1
                    order by 1
            loop
                ldc_monto = r_v_pla_horas_valorizadas_x_dia.monto;
                
                if r_v_pla_horas_valorizadas_x_dia.cod_concepto_planilla = ''100''
                    and ldc_monto > r_rhuempl.salario_bruto then
                    ldc_monto = r_rhuempl.salario_bruto;
                end if;

                li_retorno  =   f_nomctrac(as_compania, as_codigo_empleado,
                                    ''1'', as_tipo_planilla, ai_numero_planilla,
                                    ai_year, r_v_pla_horas_valorizadas_x_dia.cod_concepto_planilla,
                                    ldc_monto);
            end loop;
        end if;
    else
        select into ldc_salario sum(monto)
        from v_pla_horas_valorizadas_x_dia
        where compania = as_compania
        and codigo_empleado = as_codigo_empleado
        and tipo_planilla = as_tipo_planilla
        and year = ai_year
        and numero_planilla = ai_numero_planilla
        and tipodhora not in (''00'', ''50'')
        and recargo = 1 and signo = 1;
        if ldc_salario is null then
            ldc_salario = 0;
        end if;
        ldc_salario     =   r_rhuempl.salario_bruto - ldc_salario;
        
        li_retorno      =   f_nomctrac(as_compania, as_codigo_empleado,
                                ''1'', as_tipo_planilla, ai_numero_planilla,
                                ai_year, ''100'', ldc_salario);
        for r_v_pla_horas_valorizadas_x_dia in
            select v_pla_horas_valorizadas_x_dia.cod_concepto_planilla,
                sum(v_pla_horas_valorizadas_x_dia.monto*nomtipodehoras.signo) as monto
                from v_pla_horas_valorizadas_x_dia, nomtipodehoras
                where v_pla_horas_valorizadas_x_dia.tipodhora = nomtipodehoras.tipodhora
                and compania = as_compania
                and codigo_empleado = as_codigo_empleado
                and tipo_planilla = as_tipo_planilla
                and year = ai_year
                and numero_planilla = ai_numero_planilla
                and nomtipodehoras.tipodhora not in (''00'', ''50'')
                and (nomtipodehoras.recargo = 1 or (nomtipodehoras.recargo > 1 and nomtipodehoras.signo = 1))
                group by 1
                order by 1
        loop
            li_retorno  =   f_nomctrac(as_compania, as_codigo_empleado,
                                ''1'', as_tipo_planilla, ai_numero_planilla,
                                ai_year, r_v_pla_horas_valorizadas_x_dia.cod_concepto_planilla,
                                r_v_pla_horas_valorizadas_x_dia.monto);
        end loop;
    end if;
    
    return 1;
end;
' language plpgsql;



create function f_nomctrac(char(2), char(7), char(2), char(2), int4, int4, char(3), decimal) returns integer as '
declare
    as_compania alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_calculo alias for $3;
    as_tipo_planilla alias for $4;
    ai_numero_planilla alias for $5;
    ai_year alias for $6;
    as_cod_concepto_planilla alias for $7;
    adc_monto alias for $8;
    r_nomctrac record;
    r_nomconce record;
    r_nomtpla2 record;
begin
    select into r_nomconce * from nomconce
    where cod_concepto_planilla = as_cod_concepto_planilla;
    if not found then
        return 0;
    end if;
    
    select into r_nomtpla2 * from nomtpla2
    where tipo_planilla = as_tipo_planilla
    and year = ai_year
    and numero_planilla = ai_numero_planilla;
    if not found then
        return 0;
    end if;
    
    select into r_nomctrac * from nomctrac
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado
    and tipo_calculo = ''1''
    and tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and year = ai_year
    and numero_documento = ''0''
    and cod_concepto_planilla = as_cod_concepto_planilla;
    if found then
        update nomctrac
        set monto = monto + adc_monto
        where compania = as_compania
        and codigo_empleado = as_codigo_empleado
        and tipo_planilla = as_tipo_planilla
        and year = ai_year
        and numero_planilla = ai_numero_planilla
        and tipo_calculo = ''1''
        and numero_documento = ''0''
        and forma_de_registro = ''A'';
    else
        insert into nomctrac(compania, codigo_empleado, tipo_calculo,
            tipo_planilla, numero_planilla, year, numero_documento, cod_concepto_planilla,
            mes, usuario, fecha_actualiza, status, forma_de_registro, descripcion,
            monto) 
        values(as_compania, as_codigo_empleado, as_tipo_calculo, as_tipo_planilla,
            ai_numero_planilla, ai_year, ''0'', as_cod_concepto_planilla,
            Mes(r_nomtpla2.dia_d_pago), current_user, current_timestamp, ''R'',
            ''A'', r_nomconce.nombre_concepto, adc_monto);
    end if;
    return 1;
end;
' language plpgsql;

/*
create function f_pla_horas_regulares_excedentes(char(2), char(7), char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_planilla alias for $3;
    ai_year alias for $4;
    ai_numero_planilla alias for $5;
    r_nomhrtrab record;
    r_nomhoras record;
    ldc_horas_excedentes decimal;
    ldc_work_acum decimal;
    ldc_horas_minutos decimal;
    ldc_horas decimal;
    ldc_minutos decimal;
    ldc_sum_horas_regulares decimal;
begin
    for r_nomhrtrab in select * from nomhrtrab
                        where compania = as_compania
                        and codigo_empleado = as_codigo_empleado
                        and tipo_planilla = as_tipo_planilla
                        and year = ai_year
                        and numero_planilla = ai_numero_planilla
                        order by fecha_laborable
    loop
        select into ldc_sum_horas_regulares sum((nomhoras.horas+(nomhoras.minutos/60))*nomtipodehoras.signo)
        from nomtipodehoras, nomhoras
        where nomtipodehoras.tipodhora = nomhoras.tipodhora
        and (nomtipodehoras.recargo = 1 or nomtipodehoras.tipodhora in (''91'',''22''))
        and compania = r_nomhrtrab.compania
        and codigo_empleado = r_nomhrtrab.codigo_empleado
        and tipo_planilla = r_nomhrtrab.tipo_planilla
        and year = r_nomhrtrab.year
        and numero_planilla = r_nomhrtrab.numero_planilla
        and fecha_laborable = r_nomhrtrab.fecha_laborable
        and fecha_salida = r_nomhrtrab.fecha_salida;
        if ldc_sum_horas_regulares is null then
            ldc_sum_horas_regulares = 0;
        end if;
        
        ldc_horas_excedentes = ldc_sum_horas_regulares - 8;
        if ldc_horas_excedentes > 0 then
            ldc_work_acum = 0;
            ldc_horas_minutos = 0;
            for r_nomhoras in select ((nomhoras.horas+(nomhoras.minutos/60))*nomtipodehoras.signo) as hora_minuto,
                                nomhoras.* from nomtipodehoras, nomhoras
                                where nomtipodehoras.tipodhora = nomhoras.tipodhora
                                and (nomtipodehoras.recargo = 1 or nomtipodehoras.tipodhora in (''91'',''22''))
                                and compania = r_nomhrtrab.compania
                                and codigo_empleado = r_nomhrtrab.codigo_empleado
                                and tipo_planilla = r_nomhrtrab.tipo_planilla
                                and year = r_nomhrtrab.year
                                and numero_planilla = r_nomhrtrab.numero_planilla
                                and fecha_laborable = r_nomhrtrab.fecha_laborable
                                and fecha_salida = r_nomhrtrab.fecha_salida
                                order by nomtipodehoras.signo, nomhoras.tipodhora
            loop
                ldc_horas_minutos   =   r_nomhoras.hora_minuto;
                if ldc_work_acum + ldc_horas_minutos < ldc_horas_excedentes then
                    ldc_horas       =   0;
                    ldc_minutos     =   0;
                    ldc_work_acum   =   ldc_work_acum + ldc_horas_minutos;
                else
                    ldc_horas       =   ldc_horas_minutos - (ldc_horas_excedentes - ldc_work_acum);
                    ldc_minutos     =   ldc_horas - Trunc(ldc_horas);
                    ldc_minutos     =   ldc_minutos * 60;
                    ldc_horas       =   Trunc(ldc_horas);
                    ldc_work_acum   =   ldc_work_acum + ldc_horas;
                end if;
                update nomhoras
                set horas = ldc_horas, minutos = ldc_minutos
                where compania = r_nomhoras.compania
                and codigo_empleado = r_nomhoras.codigo_empleado
                and tipo_planilla = r_nomhoras.tipo_planilla
                and year = r_nomhoras.year
                and numero_planilla = r_nomhoras.numero_planilla
                and fecha_laborable = r_nomhoras.fecha_laborable
                and fecha_salida = r_nomhoras.fecha_salida
                and tipodhora = r_nomhoras.tipodhora
                and acumula = r_nomhoras.acumula;
                
                if ldc_work_acum >= ldc_horas_excedentes then
                    exit;
                end if;
            end loop;
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;
*/



create function f_calculo_de(char(2), char(7), char(2), char(2), int4, int4, char(3)) returns integer as '
declare
    as_compania alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_calculo alias for $3;
    as_tipo_planilla alias for $4;
    ai_numero_planilla alias for $5;
    ai_year alias for $6;
    as_cod_concepto_planilla alias for $7;
    ldc_acum decimal;
    ldc_monto decimal;
    ldc_work decimal;
    ldc_work2 decimal;
    ldc_ss decimal;
    r_nomctrac record;
    r_nomtpla2 record;
    r_nomconce record;
    r_rhuempl record;
begin
    select into r_nomtpla2 * from nomtpla2
    where tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and year = ai_year;
    if not found then
        return 0;
    end if;
    
    select into r_rhuempl * from rhuempl
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    select into r_nomconce * from nomconce
    where cod_concepto_planilla = as_cod_concepto_planilla;

        
    select into ldc_acum sum(nomconce.signo*nomctrac.monto)
    from nomconce, nomctrac
    where nomconce.cod_concepto_planilla = nomctrac.cod_concepto_planilla
    and nomctrac.compania = as_compania
    and nomctrac.codigo_empleado = as_codigo_empleado
    and nomctrac.tipo_calculo = as_tipo_calculo
    and nomctrac.tipo_planilla = as_tipo_planilla
    and nomctrac.numero_planilla = ai_numero_planilla
    and nomctrac.year = ai_year
    and nomctrac.cod_concepto_planilla in
        (select concepto_aplica from nom_conceptos_para_calculo
        where nom_conceptos_para_calculo.cod_concepto_planilla = as_cod_concepto_planilla);
        
    if ldc_acum is null then
        ldc_acum = 0;
    end if;

    if r_nomconce.cod_concepto_planilla = ''102'' then
        if r_nomtpla2.dia_d_pago >= ''2013-01-01'' then
            r_nomconce.porcentaje = 9.75;
        else
            r_nomconce.porcentaje = 9;
        end if;            
    end if;

    
    if (r_nomconce.cod_concepto_planilla = ''102''
        or r_nomconce.cod_concepto_planilla = ''104'')
        and as_tipo_planilla = ''2'' then
        if r_nomtpla2.periodo = 1 then
            ldc_work = 0;
            select into ldc_work sum(nomconce.signo*nomctrac.monto)
            from nomconce, nomctrac
            where nomconce.cod_concepto_planilla = nomctrac.cod_concepto_planilla
            and nomctrac.compania = as_compania
            and nomctrac.codigo_empleado = as_codigo_empleado
            and nomctrac.tipo_calculo = as_tipo_calculo
            and nomctrac.tipo_planilla = as_tipo_planilla
            and nomctrac.numero_planilla = ai_numero_planilla
            and nomctrac.year = ai_year
            and trim(nomctrac.cod_concepto_planilla) = ''81'';
            if ldc_work is null then
                ldc_work = 0;
            end if;
            
            if ldc_work > ldc_acum then
                ldc_acum = ldc_acum + (ldc_work - ldc_acum);
            end if;
        else
            select into ldc_work sum(nomconce.signo*nomctrac.monto)
            from nomconce, nomctrac, nomtpla2
            where nomconce.cod_concepto_planilla = nomctrac.cod_concepto_planilla
            and nomctrac.tipo_planilla = nomtpla2.tipo_planilla
            and nomctrac.year = nomtpla2.year
            and nomctrac.numero_planilla = nomtpla2.numero_planilla
            and nomctrac.compania = as_compania
            and nomctrac.codigo_empleado = as_codigo_empleado
            and nomctrac.year = ai_year
            and Mes(nomtpla2.dia_d_pago) = r_nomtpla2.mes
            and trim(nomctrac.cod_concepto_planilla) = ''81'';
            if ldc_work is null then
                ldc_work = 0;
            end if;
        
--            raise exception '' entre %'', ldc_work;
                
            if ldc_work <> 0 then
                select into ldc_acum sum(nomconce.signo*nomctrac.monto)
                from nomconce, nomctrac, nomtpla2
                where nomconce.cod_concepto_planilla = nomctrac.cod_concepto_planilla
                and nomctrac.tipo_planilla = nomtpla2.tipo_planilla
                and nomctrac.year = nomtpla2.year
                and nomctrac.numero_planilla = nomtpla2.numero_planilla
                and nomctrac.compania = as_compania
                and nomctrac.codigo_empleado = as_codigo_empleado
                and nomctrac.year = ai_year
                and Mes(nomtpla2.dia_d_pago) = r_nomtpla2.mes
                and nomctrac.cod_concepto_planilla in
                    (select concepto_aplica from nom_conceptos_para_calculo
                    where nom_conceptos_para_calculo.cod_concepto_planilla = as_cod_concepto_planilla);

                ldc_ss = 0;
                select into ldc_ss sum(nomconce.signo*nomctrac.monto)
                from nomconce, nomctrac, nomtpla2
                where nomconce.cod_concepto_planilla = nomctrac.cod_concepto_planilla
                and nomctrac.tipo_planilla = nomtpla2.tipo_planilla
                and nomctrac.year = nomtpla2.year
                and nomctrac.numero_planilla = nomtpla2.numero_planilla
                and nomctrac.compania = as_compania
                and nomctrac.codigo_empleado = as_codigo_empleado
                and nomctrac.year = ai_year
                and Mes(nomtpla2.dia_d_pago) = r_nomtpla2.mes
                and trim(nomctrac.cod_concepto_planilla) = trim(as_cod_concepto_planilla);
                if ldc_ss is null then
                    ldc_ss = 0;
                end if;

                if ldc_work > (ldc_acum/2) then
                    ldc_acum    =   ldc_acum  + (ldc_work - (ldc_acum/2));
                end if;
                
                ldc_work2       =   ldc_acum * (r_nomconce.porcentaje/100);
                ldc_ss          =   ldc_work2 + ldc_ss;
                ldc_acum        =   ldc_ss / (r_nomconce.porcentaje/100);                     
            end if;
        end if;
    end if;
    
    
    ldc_monto = ldc_acum * (r_nomconce.porcentaje/100);
    
    select into r_nomctrac * from nomctrac
    where nomctrac.compania = as_compania
    and nomctrac.codigo_empleado = as_codigo_empleado
    and nomctrac.tipo_calculo = as_tipo_calculo
    and nomctrac.tipo_planilla = as_tipo_planilla
    and nomctrac.numero_planilla = ai_numero_planilla
    and nomctrac.year = ai_year
    and nomctrac.numero_documento = ''0''
    and nomctrac.cod_concepto_planilla = as_cod_concepto_planilla;
    if not found then
        if ldc_monto > 0 then
            insert into nomctrac(compania, codigo_empleado, tipo_calculo, tipo_planilla,
                numero_planilla, year, numero_documento, cod_concepto_planilla,
                mes, usuario, fecha_actualiza, status, forma_de_registro,
                descripcion, monto)
            values (as_compania, as_codigo_empleado, as_tipo_calculo, as_tipo_planilla,
                ai_numero_planilla, ai_year, ''0'', as_cod_concepto_planilla, Mes(r_nomtpla2.dia_d_pago),
                current_user, current_date, ''R'', ''A'', r_nomconce.nombre_concepto,
                ldc_monto);
        end if;
    else
        if r_nomctrac.forma_de_registro = ''A'' and r_nomctrac.no_cheque is null then
            update nomctrac
            set monto = monto + ldc_monto
            where nomctrac.compania = as_compania
            and nomctrac.codigo_empleado = as_codigo_empleado
            and nomctrac.tipo_calculo = as_tipo_calculo
            and nomctrac.tipo_planilla = as_tipo_planilla
            and nomctrac.numero_planilla = ai_numero_planilla
            and nomctrac.year = ai_year
            and nomctrac.numero_documento = ''0''
            and nomctrac.cod_concepto_planilla = as_cod_concepto_planilla;
        end if;        
    end if;

    return 1;
end;
' language plpgsql;


create function f_deducciones_basicas(char(2), char(7), char(2), char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_calculo alias for $3;
    as_tipo_planilla alias for $4;
    ai_numero_planilla alias for $5;
    ai_year alias for $6;
    ldc_acum_ss decimal;
    ldc_monto decimal;
    i integer;
    r_nomctrac record;
    r_nomtpla2 record;
    r_nomconce record;
begin
    delete from nomctrac
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado
    and tipo_calculo = as_tipo_calculo
    and tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and year = ai_year
    and no_cheque is null
    and cod_concepto_planilla in (''102'',''103'',''104'',''310'');
    
    if as_tipo_calculo = ''3'' then
        i = f_calculo_de(as_compania, as_codigo_empleado, as_tipo_calculo, as_tipo_planilla, 
                ai_numero_planilla, ai_year, ''102'');

        i = f_calculo_de(as_compania, as_codigo_empleado, as_tipo_calculo, as_tipo_planilla, 
                ai_numero_planilla, ai_year, ''103'');
                
                
        i = f_calculo_de(as_compania, as_codigo_empleado, as_tipo_calculo, as_tipo_planilla, 
                ai_numero_planilla, ai_year, ''310'');
    
    else
        i = f_calculo_de(as_compania, as_codigo_empleado, as_tipo_calculo, as_tipo_planilla, 
                ai_numero_planilla, ai_year, ''102'');
                
        i = f_calculo_de(as_compania, as_codigo_empleado, as_tipo_calculo, as_tipo_planilla, 
                ai_numero_planilla, ai_year, ''104'');
                
        i = f_calculo_de(as_compania, as_codigo_empleado, as_tipo_calculo, as_tipo_planilla, 
                ai_numero_planilla, ai_year, ''310'');
    
        i = f_calculo_de(as_compania, as_codigo_empleado, as_tipo_calculo, as_tipo_planilla, 
                ai_numero_planilla, ai_year, ''103'');
    end if;
    
    return 1;
end;
' language plpgsql;



create function f_timestamp(date, time) returns timestamp as '
declare
    ad_fecha alias for $1;
    at_hora alias for $2;
    ls_fecha char(10);
    ls_hora char(8);
    ls_fecha_hora char(20);
    ldt_fechahora timestamp;
begin
    ls_fecha = ad_fecha;
    ls_hora = at_hora;
    ls_fecha_hora = trim(ls_fecha) || ''  '' || trim(ls_hora);
    ldt_fechahora = to_timestamp(ls_fecha_hora,''YYYY/MM/DD HH:MI'');
    return ldt_fechahora;
end;
' language plpgsql;




create function f_nomhrtrab_sin_turno(char(2), char(7), char(2), integer, date, date) returns integer as '
declare
    as_compania alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_planilla alias for $3;
    ai_numero_planilla alias for $4;
    ad_fecha_laborable alias for $5;
    ad_fecha_salida alias for $6;
    r_rhuempl record;
    r_nomhrtrab record;
    li_minutos_trabajado int4;
begin
/*
    select into r_rhuempl * from rhuempl
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;        
    
    if r_rhuempl.status <> ''A'' then
        return 0;
    end if;
    
    select into r_nomhrtrab * from nomhrtrab
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado
    and tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and fecha_laborable = ad_fecha_laborable
    and fecha_salida = ad_fecha_salida;
    if not found then
        return 0;
    end if;

    lts_inicio_descanso     =   f_timestamp(r_nomhrtrab.fecha_laborable,r_nomhrtrab.hora_de_descanso_inicio);
    lts_final_descanso      =   f_timestamp(r_nomhrtrab.fecha_laborable, r_nomhrtrab.hora_de_descanso_final);
    lts_entrada             =   f_timestamp(r_nomhrtrab.fecha_laborable, r_nomhrtrab.hora_de_inicio_trabajo);
    lts_salida              =   f_timestamp(r_nomhrtrab.fecha_salida, r_nomhrtrab.hora_de_salida_trabajo);
    
    li_minutos_descanso     =   f_intervalo(lts_inicio_descanso, lts_final_descanso);
    li_minutos_trabajados   =   f_intervalo(lts_entrada, lts_salida) - li_minutos_descanso;
*/    

    
    return 1;
end;
' language plpgsql;



create function f_vacaciones_x_pagar_gto_repre(char(2), char(7), date) returns decimal as '
declare
    as_compania alias for $1;
    as_codigo_empleado alias for $2;
    ad_hasta alias for $3;
    ldc_vacacion_x_pagar decimal;
    ldc_acumulado decimal;
    ldc_salario_actual decimal;
    ld_ultima_vacacion date;
    r_rhuempl record;
begin
    ldc_vacacion_x_pagar = 0;
    
    select into r_rhuempl * from rhuempl
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado;
    
    if r_rhuempl.status <> ''A'' and r_rhuempl.status <> ''V'' then
        return 0;
    end if;
    
    select into ld_ultima_vacacion Max(f_corte)
    from pla_vacacion
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado
    and pagar_desde <= ad_hasta;
    
    if ld_ultima_vacacion is null then
        ld_ultima_vacacion = r_rhuempl.fecha_inicio;
    end if;
    
    select into ldc_acumulado sum(nomconce.signo*nomctrac.monto)
    from nomconce, nomctrac, nomtpla2
    where nomconce.cod_concepto_planilla = nomctrac.cod_concepto_planilla
    and nomctrac.codigo_empleado = as_codigo_empleado
    and nomctrac.tipo_planilla = nomtpla2.tipo_planilla
    and nomctrac.numero_planilla = nomtpla2.numero_planilla
    and nomctrac.year = nomtpla2.year
    and nomctrac.cod_concepto_planilla = ''200''
    and nomconce.solo_patrono = ''N''
    and nomctrac.compania = as_compania
    and nomtpla2.dia_d_pago > ld_ultima_vacacion
    and nomtpla2.dia_d_pago <= ad_hasta;
    if ldc_acumulado is null then
        ldc_acumulado = 0;
    end if;
    
    ldc_vacacion_x_pagar = ldc_acumulado / 11;
    
/*    
    if r_rhuempl.tipo_planilla = ''1'' then
        ldc_salario_actual = r_rhuempl.salario_bruto * 52 / 12;
    elsif r_rhuempl.tipo_planilla = ''2'' then
        ldc_salario_actual = r_rhuempl.salario_bruto * 2;
    else
        ldc_salario_actual = 0;
    end if;

    if (ad_hasta - r_rhuempl.fecha_inicio) >= 30 and ldc_salario_actual > ldc_vacacion_x_pagar then
        ldc_vacacion_x_pagar = ldc_salario_actual;
    end if;
*/    
        
    return ldc_vacacion_x_pagar;
end;
' language plpgsql;






create function f_vacaciones_x_pagar(char(2), char(7), date) returns decimal as '
declare
    as_compania alias for $1;
    as_codigo_empleado alias for $2;
    ad_hasta alias for $3;
    ldc_vacacion_x_pagar decimal;
    ldc_acumulado decimal;
    ldc_salario_actual decimal;
    ld_ultima_vacacion date;
    r_rhuempl record;
begin
    ldc_vacacion_x_pagar = 0;
    
    select into r_rhuempl * from rhuempl
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado;
    
    if r_rhuempl.status <> ''A'' and r_rhuempl.status <> ''V'' then
        return 0;
    end if;
    
    select into ld_ultima_vacacion Max(f_corte)
    from pla_vacacion
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado
    and pagar_desde <= ad_hasta;
    
    if ld_ultima_vacacion is null then
        ld_ultima_vacacion = r_rhuempl.fecha_inicio;
    end if;
    
    select into ldc_acumulado sum(nomconce.signo*nomctrac.monto)
    from nomconce, nomctrac, nomtpla2
    where nomconce.cod_concepto_planilla = nomctrac.cod_concepto_planilla
    and nomctrac.codigo_empleado = as_codigo_empleado
    and nomctrac.tipo_planilla = nomtpla2.tipo_planilla
    and nomctrac.numero_planilla = nomtpla2.numero_planilla
    and nomctrac.year = nomtpla2.year
    and nomctrac.cod_concepto_planilla in
        (select concepto_aplica from nom_conceptos_para_calculo
            where cod_concepto_planilla = ''108'')
    and nomconce.solo_patrono = ''N''
    and nomctrac.compania = as_compania
    and nomtpla2.dia_d_pago > ld_ultima_vacacion
    and nomtpla2.dia_d_pago <= ad_hasta;
    if ldc_acumulado is null then
        ldc_acumulado = 0;
    end if;
    
    ldc_vacacion_x_pagar = ldc_acumulado / 11;
    
    if r_rhuempl.tipo_planilla = ''1'' then
        ldc_salario_actual = r_rhuempl.salario_bruto * 52 / 12;
    elsif r_rhuempl.tipo_planilla = ''2'' then
        ldc_salario_actual = r_rhuempl.salario_bruto * 2;
    else
        ldc_salario_actual = 0;
    end if;

/*    
    if (ad_hasta - r_rhuempl.fecha_inicio) >= 30 and ldc_salario_actual > ldc_vacacion_x_pagar then
        ldc_vacacion_x_pagar = ldc_salario_actual;
    end if;
*/    
        
    return ldc_vacacion_x_pagar;
end;
' language plpgsql;





create function f_pla_reservas_cglposteo_resumido(char(2), date) returns integer as '
declare
    as_compania alias for $1;
    ad_fecha alias for $2;
    li_consecutivo int4;
    ls_tipo_de_comprobante char(3);
    ls_cta_pte_planilla char(24);
    ls_descripcion text;
    r_rhuempl record;
    r_pla_afectacion_contable record;
    r_nomtpla2 record;
    r_nomconce record;
    r_nomacrem record;
    r_cglcuentas record;
    r_pla_reservas record;
    r_cglauxiliares record;
    r_pla_reservas_resumidas record;
    ldc_monto decimal(10,2);
    ls_auxiliar char(10);
    i integer;
    li_signo integer;
    lvc_auxiliar1 varchar(10);
begin
    delete from rela_pla_reservas_cglposteo
    where rela_pla_reservas_cglposteo.compania = as_compania
    and exists
        (select * from nomtpla2
        where nomtpla2.dia_d_pago = ad_fecha
        and rela_pla_reservas_cglposteo.tipo_planilla = nomtpla2.tipo_planilla
        and rela_pla_reservas_cglposteo.numero_planilla = nomtpla2.numero_planilla
        and rela_pla_reservas_cglposteo.year = nomtpla2.year);
    

    ls_tipo_de_comprobante := f_gralparaxcia(as_compania, ''PLA'', ''tipo_d_comprobante'');

    for r_pla_reservas_resumidas in select pla_reservas.compania, nomtpla2.dia_d_pago, rhuempl.departamento, pla_reservas.tipo_planilla,
            pla_reservas.numero_planilla, pla_reservas.year, pla_reservas.concepto_reserva, 
            sum(pla_reservas.monto) as reserva
            from nomtpla2, rhuempl, pla_reservas
            where nomtpla2.tipo_planilla = pla_reservas.tipo_planilla
            and nomtpla2.numero_planilla = pla_reservas.numero_planilla
            and nomtpla2.year = pla_reservas.year
            and rhuempl.compania = pla_reservas.compania
            and rhuempl.codigo_empleado = pla_reservas.codigo_empleado
            and rhuempl.compania = as_compania
            and nomtpla2.dia_d_pago = ad_fecha
            group by pla_reservas.compania, nomtpla2.dia_d_pago, rhuempl.departamento, 
                        pla_reservas.tipo_planilla, pla_reservas.numero_planilla,
                        pla_reservas.year, pla_reservas.concepto_reserva
            order by pla_reservas.compania, nomtpla2.dia_d_pago, rhuempl.departamento, 
                        pla_reservas.tipo_planilla, pla_reservas.numero_planilla,
                        pla_reservas.year, pla_reservas.concepto_reserva
    loop
        ls_descripcion := ''RESERVA DEL DEPARTAMENTO '' || trim(r_pla_reservas_resumidas.departamento);
        ldc_monto := 0;
    
        select into i count(*) from pla_afectacion_contable
        where departamento = r_pla_reservas_resumidas.departamento
        and cod_concepto_planilla = r_pla_reservas_resumidas.concepto_reserva;
        if not found or i <= 1 then
            Raise Exception ''Departamento % no tiene afectacion contable en el concepto de reserva %'',r_pla_reservas_resumidas.departamento,
                r_pla_reservas_resumidas.concepto_reserva;
        end if;
    
        li_signo := -1;
        for r_pla_afectacion_contable in select * from pla_afectacion_contable
                            where departamento = r_pla_reservas_resumidas.departamento
                            and cod_concepto_planilla = r_pla_reservas_resumidas.concepto_reserva
                            order by cuenta
        loop
            select into r_nomconce * from nomconce
            where cod_concepto_planilla = r_pla_reservas_resumidas.concepto_reserva;
        
            select into r_cglcuentas *
            from cglcuentas
            where trim(cuenta) = trim(r_pla_afectacion_contable.cuenta);
            if found then
                if r_cglcuentas.auxiliar_1 = ''S'' then
                    lvc_auxiliar1 = ''0000'';
                    
                    select into r_cglauxiliares *
                    from cglauxiliares
                    where trim(auxiliar) = trim(lvc_auxiliar1);
                    if not found then
                        insert into cglauxiliares(auxiliar, nombre, status, concepto, tipo_de_compra)
                        values(trim(lvc_auxiliar1), ''RECLASIFICAR'', ''A'', ''1'', ''1'');
                    end if;
                end if;
            end if;
        
            li_consecutivo := f_cglposteo(as_compania, ''PLA'', r_pla_reservas_resumidas.dia_d_pago,
                                r_pla_afectacion_contable.cuenta, trim(lvc_auxiliar1), null,
                                ls_tipo_de_comprobante, ls_descripcion,
                                (r_pla_reservas_resumidas.reserva*li_signo));
            if li_consecutivo > 0 then
               insert into rela_pla_reservas_cglposteo(codigo_empleado, compania, tipo_calculo,
                cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento,
                concepto_reserva, consecutivo)
               select pla_reservas.codigo_empleado, pla_reservas.compania, pla_reservas.tipo_calculo,
               pla_reservas.cod_concepto_planilla, pla_reservas.tipo_planilla, pla_reservas.numero_planilla,
               pla_reservas.year, pla_reservas.numero_documento, pla_reservas.concepto_reserva, li_consecutivo
               from pla_reservas, rhuempl, nomtpla2
               where pla_reservas.compania = rhuempl.compania
               and pla_reservas.codigo_empleado = rhuempl.codigo_empleado
               and pla_reservas.tipo_planilla = nomtpla2.tipo_planilla
               and pla_reservas.numero_planilla = nomtpla2.numero_planilla
               and pla_reservas.year = nomtpla2.year
               and rhuempl.departamento = r_pla_reservas_resumidas.departamento
               and pla_reservas.concepto_reserva = r_pla_reservas_resumidas.concepto_reserva
               and rhuempl.compania = as_compania
               and nomtpla2.dia_d_pago = ad_fecha;
            end if;
            li_signo := li_signo * -1;
        end loop;

    end loop;
    
    return 1;
end;
' language plpgsql;


/*
create function f_nomctrac_pla_reservas(char(2), char(7), char(2), char(2), int4, int4, char(30), char(3)) returns integer as '
declare
    as_compania alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_calculo alias for $3;
    as_tipo_planilla alias for $4;
    ai_year alias for $5;
    ai_numero_planilla alias for $6;
    as_numero_documento alias for $7;
    as_cod_concepto_planilla alias for $8;
    r_nomconce record;
    r_nomctrac record;
    r_pla_reservas record;
    r_nomtpla2 record;
    r_nom_conceptos_para_calculo record;
    ldc_reserva decimal(10,2);
    li_signo integer;
    ls_rp char(20);
    ldc_porcentaje decimal(15,5);
    ldc_combustible_mensual decimal(10,2);
    ldc_monto_gravado decimal(10,2);
    ldc_porcen_ss decimal(15,6);
    ls_concepto_reserva char(3);
begin
    
    select into r_nomtpla2 * from nomtpla2
    where tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and year = ai_year;
    if not found then
        return 0;
    end if;

    delete from pla_reservas
    where codigo_empleado = as_codigo_empleado
    and compania = as_compania
    and tipo_calculo = as_tipo_calculo
    and cod_concepto_planilla = as_cod_concepto_planilla
    and tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and year = ai_year
    and numero_documento = as_numero_documento;
    
    select into r_nomctrac * from nomctrac
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado
    and tipo_calculo = as_tipo_calculo
    and cod_concepto_planilla = as_cod_concepto_planilla
    and tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and year = ai_year
    and numero_documento = as_numero_documento;
    if not found then
        return 0;
    end if;    
    
    select into r_nomconce *
    from nomconce
    where cod_concepto_planilla = as_cod_concepto_planilla;
    if not found then
        return 0;
    end if;

    r_nomctrac.monto = r_nomctrac.monto * r_nomconce.signo;
    
    for r_nom_conceptos_para_calculo in select nom_conceptos_para_calculo.* 
                                            from nom_conceptos_para_calculo, nomconce
                                            where nom_conceptos_para_calculo.cod_concepto_planilla = nomconce.cod_concepto_planilla
                                            and nomconce.solo_patrono = ''S''
                                            and concepto_aplica = as_cod_concepto_planilla
                                            order by cod_concepto_planilla
    loop
        ldc_reserva = 0;
        if r_nom_conceptos_para_calculo.cod_concepto_planilla = ''402'' then
            ldc_reserva = r_nomctrac.monto * .12;
        elsif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''403'' then
            ldc_reserva = r_nomctrac.monto * .1075;
        elsif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''404'' then
            ldc_reserva = r_nomctrac.monto * 0.015;
        elsif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''408'' then
            ldc_reserva = r_nomctrac.monto / 11;
        elsif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''409'' then
            ldc_reserva = (r_nomctrac.monto / 12) + (r_nomctrac.monto/11/12);
            ldc_reserva = (r_nomctrac.monto / 12);
        elsif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''410'' then
            ldc_porcentaje := f_gralparaxcia(r_nomctrac.compania, ''PLA'', ''porcentaje_rp'');        
            ldc_reserva = r_nomctrac.monto * (ldc_porcentaje/100);
        elsif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''420'' then
            ldc_reserva = r_nomctrac.monto/52 + (r_nomctrac.monto/11/52);
            ldc_reserva = r_nomctrac.monto/52;
        elsif r_nom_conceptos_para_calculo.cod_concepto_planilla = ''430'' then
            ldc_reserva = (r_nomctrac.monto/52*3.4 + (r_nomctrac.monto/11/52*3.4))*.05;
            ldc_reserva = (r_nomctrac.monto/52*3.4) *.05;
        end if;
        if ldc_reserva <> 0 then
            insert into pla_reservas(compania, codigo_empleado, tipo_calculo, cod_concepto_planilla,
                tipo_planilla, numero_planilla, year, numero_documento, concepto_reserva, monto)
            values(r_nomctrac.compania, r_nomctrac.codigo_empleado, r_nomctrac.tipo_calculo, 
                r_nomctrac.cod_concepto_planilla, r_nomctrac.tipo_planilla, r_nomctrac.numero_planilla, 
                r_nomctrac.year, r_nomctrac.numero_documento, 
                r_nom_conceptos_para_calculo.cod_concepto_planilla, ldc_reserva);
        end if;
    end loop; 
    return 1;
end;
' language plpgsql;
*/    

create function f_pla_reservas_cglposteo(char(7), char(2), char(2), char(3), char(2), int4, int4, char(30), char(3)) returns integer as '
declare
    as_codigo_empleado alias for $1;
    as_compania alias for $2;
    as_tipo_calculo alias for $3;
    as_cod_concepto_planilla alias for $4;
    as_tipo_planilla alias for $5;
    ai_numero_planilla alias for $6;
    ai_year alias for $7;
    as_numero_documento alias for $8;
    as_concepto_reserva alias for $9;
    li_consecutivo int4;
    ls_tipo_de_comprobante char(3);
    ls_cta_pte_planilla char(24);
    ls_descripcion text;
    r_rhuempl record;
    r_pla_afectacion_contable record;
    r_nomtpla2 record;
    ldc_monto decimal(10,2);
    r_nomconce record;
    ls_auxiliar char(10);
    r_nomacrem record;
    r_cglcuentas record;
    r_pla_reservas record;
    i integer;
    li_signo integer;
begin
    delete from rela_pla_reservas_cglposteo
    where codigo_empleado = as_codigo_empleado
    and compania = as_compania
    and tipo_calculo = as_tipo_calculo
    and cod_concepto_planilla = as_cod_concepto_planilla
    and tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and year = ai_year
    and numero_documento = as_numero_documento
    and concepto_reserva = as_concepto_reserva;
    

    select into r_pla_reservas * from pla_reservas
    where codigo_empleado = as_codigo_empleado
    and compania = as_compania
    and tipo_calculo = as_tipo_calculo
    and cod_concepto_planilla = as_cod_concepto_planilla
    and tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and year = ai_year
    and numero_documento = as_numero_documento
    and concepto_reserva = as_concepto_reserva;
    if not found then
       return 0;
    end if;

    ls_tipo_de_comprobante := f_gralparaxcia(as_compania, ''PLA'', ''tipo_d_comprobante'');
    
    
    select into r_nomtpla2 * from nomtpla2
    where tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and year = ai_year;
    
    select into r_rhuempl * from rhuempl
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado;
    
    ls_descripcion := r_rhuempl.nombre_del_empleado;
    ldc_monto := 0;
    
    select into i count(*) from pla_afectacion_contable
    where departamento = r_rhuempl.departamento
    and cod_concepto_planilla = as_concepto_reserva;
    if not found or i <= 1 then
        Raise Exception ''Empleado % no tiene afectacion contable en el departamento % y el concepto de reserva %'',as_codigo_empleado,
            r_rhuempl.departamento, as_concepto_reserva;
    end if;

    
    li_signo := -1;
    for r_pla_afectacion_contable in select * from pla_afectacion_contable
                        where departamento = r_rhuempl.departamento
                        and cod_concepto_planilla = as_concepto_reserva
                        order by cuenta
    loop
        select into r_nomconce * from nomconce
        where cod_concepto_planilla = as_concepto_reserva;
        
        li_consecutivo := f_cglposteo(as_compania, ''PLA'', r_nomtpla2.dia_d_pago,
                            r_pla_afectacion_contable.cuenta, null, null,
                            ls_tipo_de_comprobante, ls_descripcion,
                            (r_pla_reservas.monto*li_signo));
        if li_consecutivo > 0 then
           insert into rela_pla_reservas_cglposteo(codigo_empleado, compania, tipo_calculo,
            cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento,
            concepto_reserva, consecutivo)
           values (as_codigo_empleado, as_compania, as_tipo_calculo, 
            as_cod_concepto_planilla, as_tipo_planilla, ai_numero_planilla, 
            ai_year, as_numero_documento, as_concepto_reserva, li_consecutivo);
        end if;
        li_signo := li_signo * -1;
    end loop;

    
    return 1;
end;
' language plpgsql;



create function f_nomctrac_cglposteo(char(2), char(7), char(2), char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_calculo alias for $3;
    as_tipo_planilla alias for $4;
    ai_numero_planilla alias for $5;
    ai_year alias for $6;
    li_consecutivo int4;
    r_nomctrac record;
    ls_tipo_de_comprobante char(3);
    ls_cta_pte_planilla char(24);
    ls_descripcion text;
    r_rhuempl record;
    r_pla_afectacion_contable record;
    r_nomtpla2 record;
    ldc_monto decimal(10,2);
    r_nomconce record;
    ls_auxiliar char(10);
    r_nomacrem record;
    r_cglcuentas record;
begin
    ls_tipo_de_comprobante := f_gralparaxcia(as_compania, ''PLA'', ''tipo_d_comprobante'');
    ls_cta_pte_planilla := f_gralparaxcia(as_compania, ''PLA'', ''cta_pte_planilla'');
    
    
    delete from rela_nomctrac_cglposteo
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado
    and tipo_calculo = as_tipo_calculo
    and tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and year = ai_year;
    
    select into r_nomtpla2 * from nomtpla2
    where tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and year = ai_year;
    
    select into r_rhuempl * from rhuempl
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado;
    
    ls_descripcion := r_rhuempl.nombre_del_empleado;
    ldc_monto = 0;

        
    for r_nomctrac in select * from nomctrac
                        where compania = as_compania
                        and codigo_empleado = as_codigo_empleado
                        and tipo_calculo = as_tipo_calculo
                        and tipo_planilla = as_tipo_planilla
                        and numero_planilla = ai_numero_planilla
                        and year = ai_year
                        and monto <> 0
                        and no_cheque is null
    loop
        
        select into r_pla_afectacion_contable * from pla_afectacion_contable
        where departamento = r_rhuempl.departamento
        and cod_concepto_planilla = r_nomctrac.cod_concepto_planilla;
        if not found then
            Raise Exception ''Empleado % no tiene afectacion contable en el departamento % y el concepto %'',as_codigo_empleado,
                r_rhuempl.departamento, r_nomctrac.cod_concepto_planilla;
        end if;

        select into r_nomconce * from nomconce
        where cod_concepto_planilla = r_nomctrac.cod_concepto_planilla;
        if not found or r_nomctrac.cod_concepto_planilla is null then
            Raise Exception ''Empleado %, Tipo calculo %, Tipo de Planilla %, Numero de Planilla % no existe concepto %'',as_codigo_empleado,
                as_tipo_calculo, as_tipo_planilla, ai_numero_planilla, r_nomctrac.cod_concepto_planilla;
        end if;        
        ls_auxiliar := null;
        select into r_cglcuentas * from cglcuentas
        where cuenta = r_pla_afectacion_contable.cuenta and auxiliar_1 = ''S'';
        if found then
           select into r_nomacrem nomacrem.* from nomdescuentos, nomacrem
           where nomacrem.numero_documento = nomdescuentos.numero_documento
           and nomacrem.codigo_empleado = nomdescuentos.codigo_empleado
           and nomacrem.cod_concepto_planilla = nomdescuentos.cod_concepto_planilla
           and nomacrem.compania = nomdescuentos.compania
           and nomdescuentos.compania = as_compania
           and nomdescuentos.codigo_empleado = as_codigo_empleado
           and nomdescuentos.tipo_calculo = as_tipo_calculo
           and nomdescuentos.tipo_planilla = as_tipo_planilla
           and nomdescuentos.numero_planilla = ai_numero_planilla
           and nomdescuentos.year = ai_year
           and nomdescuentos.numero_documento = r_nomctrac.numero_documento;
           if found then
            if r_nomacrem.hacer_cheque = ''S'' then
                ls_auxiliar := r_nomacrem.cod_acreedores;
              else
                ls_auxiliar := as_codigo_empleado;
              end if;
           else
               ls_auxiliar := as_codigo_empleado;
           end if;
        end if;
        ldc_monto := ldc_monto + (r_nomctrac.monto * r_nomconce.signo);
        
        
        
        li_consecutivo := f_cglposteo(as_compania, ''PLA'', r_nomtpla2.dia_d_pago,
                            r_pla_afectacion_contable.cuenta, ls_auxiliar, null,
                            ls_tipo_de_comprobante, ls_descripcion,
                            (r_nomctrac.monto*r_nomconce.signo));

        if li_consecutivo > 0 then
           insert into rela_nomctrac_cglposteo (codigo_empleado, compania, tipo_calculo,
            cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento,
            consecutivo)
           values (as_codigo_empleado, as_compania, as_tipo_calculo, 
            r_nomctrac.cod_concepto_planilla, as_tipo_planilla, ai_numero_planilla, 
            ai_year, r_nomctrac.numero_documento, li_consecutivo);
        end if;
        
    end loop;

    if ldc_monto <> 0 then    
        li_consecutivo := f_cglposteo(as_compania, ''PLA'', r_nomtpla2.dia_d_pago,
                            ls_cta_pte_planilla, null, null,
                            ls_tipo_de_comprobante, ls_descripcion, -ldc_monto);
        if li_consecutivo > 0 then
           insert into rela_nomctrac_cglposteo (codigo_empleado, compania, tipo_calculo,
            cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento,
            consecutivo)
           values (as_codigo_empleado, as_compania, as_tipo_calculo, 
           r_nomctrac.cod_concepto_planilla, as_tipo_planilla, ai_numero_planilla, 
           ai_year, r_nomctrac.numero_documento, li_consecutivo);
        end if;
    end if;
    return 1;
end;
' language plpgsql;



create function f_tipo_de_jornada(timestamp, timestamp) returns char(1) as '
declare
    ats_desde alias for $1;
    ats_hasta alias for $2;
    li_minutos int4;
    li_minutos_diurnos int4;
    li_minutos_nocturnos int4;
    lts_inicio_nocturno timestamp;
    lts_fin_diurno timestamp;
    lt_inicio_nocturno time;
    lt_fin_nocturno time;
    lt_work time;
    ld_work date;
    ld_desde date;
    ld_hasta date;
begin
    if ats_hasta < ats_desde then
        raise exception ''Fecha Hasta % No puede ser menor a la fecha Desde %'',ats_hasta, ats_desde;
    end if;
    
    lt_inicio_nocturno = ''18:00'';
    lt_fin_nocturno = ''06:00'';
    
    li_minutos  =   f_intervalo(ats_desde, ats_hasta);
    ld_desde    =   ats_desde;
    ld_hasta    =   ats_hasta;
    if ld_hasta > ld_desde then
        lt_work = ats_desde;
        if lt_work >= lt_inicio_nocturno then
            return ''N'';
        end if;
    else
        lt_work = ats_desde;
        if lt_work >= lt_inicio_nocturno and li_minutos >= 420 then
            return ''N'';
        else
            lt_work = ats_hasta;
            if lt_work  >= lt_inicio_nocturno then
                ld_work = ats_hasta;
                lts_inicio_nocturno = f_timestamp(ld_work, lt_inicio_nocturno);
                li_minutos_nocturnos = f_intervalo(lts_inicio_nocturno, ats_hasta);
                if li_minutos_nocturnos >= 420 then
                    return ''N'';
                else
                    return ''M'';
                end if;
            end if;
        end if;
    end if;
    return ''D'';
end;
' language plpgsql;
