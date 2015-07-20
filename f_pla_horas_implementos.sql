
drop function f_pla_horas(int4, char(2), int4, decimal, char(1), char(1), timestamp, timestamp) cascade;

create function f_pla_horas(int4, char(2), int4, decimal, char(1), char(1), timestamp, timestamp) returns integer as '
declare
    ai_id_marcaciones alias for $1;
    as_tipo_de_hora alias for $2;
    ai_minutos alias for $3;
    adc_tasa_por_minuto alias for $4;
    as_aplicar alias for $5;
    as_acumula alias for $6;
    ats_desde alias for $7;
    ats_hasta alias for $8;
    r_pla_horas record;
    r_pla_horas_2 record;
    r_pla_marcaciones record;
    r_pla_tipos_de_horas record;
    r_pla_tarjeta_tiempo record;
    r_pla_eventos record;
    ls_tipo_de_hora char(2);
    ls_implemento char(3);
    li_minutos_implemento int4;
    li_minutos int4;
    li_minutos_trabajo int4;
    li_work_1 int4;
    ldc_maximo_recargo decimal;
    lts_desde timestamp;
    lb_implementos boolean;
begin
    li_work_1       =   0;
    li_minutos      =   ai_minutos;
    ls_tipo_de_hora =   as_tipo_de_hora;
    
    select into r_pla_marcaciones *
    from pla_marcaciones
    where id = ai_id_marcaciones;
    if not found then
        return 0;
    end if;
    
    select into r_pla_tarjeta_tiempo *
    from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    if not found then
        return 0;
    end if;

    ldc_maximo_recargo   =   cast(f_pla_parametros(r_pla_marcaciones.compania, ''maximo_recargo'',''100'',''GET'') as decimal);

    
    select into r_pla_horas * 
    from pla_horas
    where id_marcaciones = ai_id_marcaciones
    and tipo_de_hora = ls_tipo_de_hora
    and forma_de_registro = ''M'';
    if found then
        return 0;
    end if;


    li_minutos_implemento   =   0;
    ls_implemento           =   null;
    lb_implementos          =   0;
/*   
   

    for r_pla_eventos in 
        select * from pla_eventos
        where compania = r_pla_marcaciones.compania
        and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
        and ((desde between ats_desde and ats_hasta 
        and hasta between ats_desde and ats_hasta)
        order by desde
    loop
        li_minutos_implemento   =   f_intervalo(r_pla_eventos.desde, r_pla_eventos.hasta);
        ls_implemento           =   r_pla_eventos.implemento;
        li_work_1               =   li_work_1 + 1;

    
        select into r_pla_horas * from pla_horas
        where id_marcaciones = ai_id_marcaciones
        and tipo_de_hora = ls_tipo_de_hora
        and trim(implemento) = trim(ls_implemento);
        if not found then
            select into r_pla_horas_2 * from pla_horas
            where id_marcaciones = ai_id_marcaciones
            and tipo_de_hora = ls_tipo_de_hora;
            if found then
                li_minutos = 0;
            end if;
            
            insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                tasa_por_minuto, aplicar, acumula, forma_de_registro, implemento, minutos_implemento, compania)
            values (ai_id_marcaciones, ls_tipo_de_hora, li_minutos, adc_tasa_por_minuto, as_aplicar, 
                    as_acumula, ''A'', ls_implemento, li_minutos_implemento, r_pla_marcaciones.compania);
--raise exception ''minutos %'', li_minutos;

        else
        
--            if trim(ls_tipo_de_hora) <> ''00'' then
                update pla_horas
                set minutos = minutos + li_minutos
                where id = r_pla_horas.id;
--            end if;
--                minutos_implemento = minutos_implemento + li_minutos_implemento                    

--            lb_implementos = 0;            
        end if;
        lb_implementos          =   1;
    end loop;

    

    ls_implemento = null;
    if lb_implementos then
--    raise exception ''%'',li_work_1;
        return 1;
    end if;
*/    
  
  ls_implemento = null;  
/*    
    select into r_pla_eventos *
    from pla_eventos
    if found then
        li_minutos_implemento   =   f_intervalo(r_pla_eventos.desde, r_pla_eventos.hasta);
        ls_implemento           =   r_pla_eventos.implemento;
    else
        select into r_pla_eventos *
        from pla_eventos
        where compania = r_pla_marcaciones.compania
        and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
        and desde between ats_desde and ats_hasta
        and hasta > ats_hasta;
        if found then
            if r_pla_eventos.desde > ats_desde then
                lts_desde = r_pla_eventos.desde;
            else
                lts_desde = ats_desde;
            end if;
            li_minutos_implemento   =   f_intervalo(lts_desde, ats_hasta);
            ls_implemento           =   r_pla_eventos.implemento;
        else
            select into r_pla_eventos *
            from pla_eventos
            where compania = r_pla_marcaciones.compania
            and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
            and ((hasta between ats_desde and ats_hasta)
            or (ats_hasta between desde and hasta)) ;
            if found then
                li_minutos_implemento   =   f_intervalo(ats_desde, ats_hasta);
                ls_implemento           =   r_pla_eventos.implemento;
            end if;            
        end if;
    end if;
*/
  
    select into r_pla_horas * from pla_horas
    where id_marcaciones = ai_id_marcaciones
    and tipo_de_hora = ls_tipo_de_hora;
    if not found then
        insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
            tasa_por_minuto, aplicar, acumula, forma_de_registro, implemento, minutos_implemento, compania)
        values (ai_id_marcaciones, ls_tipo_de_hora, ai_minutos, adc_tasa_por_minuto, as_aplicar, 
                as_acumula, ''A'', ls_implemento, li_minutos_implemento, r_pla_marcaciones.compania);

        select into r_pla_horas * from pla_horas
        where id_marcaciones = ai_id_marcaciones
        and tipo_de_hora = ls_tipo_de_hora;
        if found then
            insert into pla_horas_detalle(id_pla_horas,
                desde, hasta, minutos)
            values(r_pla_horas.id, ats_desde, ats_hasta, li_minutos);
        end if;                        
        
    else
        if ls_implemento is not null then
            select into r_pla_horas * from pla_horas
            where id_marcaciones = ai_id_marcaciones
            and tipo_de_hora = ls_tipo_de_hora
            and trim(implemento) = trim(ls_implemento);
            if not found then
                insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                    tasa_por_minuto, aplicar, acumula, forma_de_registro, implemento, minutos_implemento, compania)
                values (ai_id_marcaciones, ls_tipo_de_hora, ai_minutos, adc_tasa_por_minuto, as_aplicar, 
                        as_acumula, ''A'', ls_implemento, li_minutos_implemento, r_pla_marcaciones.compania);
                select into r_pla_horas * from pla_horas
                where id_marcaciones = ai_id_marcaciones
                and tipo_de_hora = ls_tipo_de_hora
                and trim(implemento) = trim(ls_implemento);
                if found then
                    insert into pla_horas_detalle(id_pla_horas,
                        desde, hasta, minutos)
                    values(r_pla_horas.id, ats_desde, ats_hasta, li_minutos);
                end if;                        
            else
--raise exception ''entre %'', li_minutos_implemento;            
                update pla_horas
                set minutos = minutos + ai_minutos
                where id = r_pla_horas.id;

                insert into pla_horas_detalle(id_pla_horas,
                    desde, hasta, minutos)
                values(r_pla_horas.id, ats_desde, ats_hasta, li_minutos);
            
--                if trim(r_pla_horas.tipo_de_hora) <> ''00'' then
--                    update pla_horas
--                    set minutos_implemento = minutos_implemento + li_minutos_implemento
--                    where id = r_pla_horas.id;
--                end if;
                
            end if;
        else
            update pla_horas
            set minutos = minutos + ai_minutos
            where id = r_pla_horas.id;
            
            insert into pla_horas_detalle(id_pla_horas,
                desde, hasta, minutos)
            values(r_pla_horas.id, ats_desde, ats_hasta, ai_minutos);
        
        end if;                
    end if;
    
    return 1;
end;
' language plpgsql;
