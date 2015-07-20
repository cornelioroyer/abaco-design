
drop function f_pla_horas(int4, char(2), int4, decimal, char(1), char(1), timestamp, timestamp) cascade;

drop function f_pla_horas_implementos(int4) cascade;

create function f_pla_horas_implementos(int4) returns integer as '
declare
    ai_id_pla_marcaciones alias for $1;
    r_pla_marcaciones_work record;
    r_pla_marcaciones record;
    r_pla_tarjeta_tiempo record;
    r_pla_horas record;
    r_pla_horas_detalle record;
    r_pla_eventos record;
    r_pla_empleados record;
    r_pla_horas_2 record;
    r_pla_horas_work record;
    r_pla_turnos record;
    li_retorno int;
    li_minutos int4;
    li_minutos_adicionales int4;
    li_eventos int4;
    lb_loop boolean;
begin
--    raise exception ''%'', ai_id_pla_marcaciones;
    
    delete from pla_horas
    where id_marcaciones = ai_id_pla_marcaciones
    and minutos = 0 and minutos_implemento <> 0;
    
    select into r_pla_marcaciones *
    from pla_marcaciones
    where id = ai_id_pla_marcaciones;
    if not found then
        return 0;
    end if;
    
    select into r_pla_turnos *
    from pla_turnos
    where compania = r_pla_marcaciones.compania
    and turno = r_pla_marcaciones.turno;
    if not found then
        return 0;
    end if;

    li_minutos_adicionales = 0;
    if r_pla_turnos.tipo_de_jornada = ''N'' then
        li_minutos_adicionales = 60;
    end if;
    
    select into r_pla_tarjeta_tiempo *
    from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    if not found then
        return 0;
    end if;
    
    
    select into r_pla_empleados *
    from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;
    if not found then
        return 0;
    end if;


    for r_pla_horas in select * from pla_horas
                        where id_marcaciones = ai_id_pla_marcaciones
                        order by id
    loop
    
        for r_pla_horas_detalle in select * from pla_horas_detalle
                                    where id_pla_horas = r_pla_horas.id
                                    order by desde
        loop
            li_eventos = 0;
            lb_loop = false;

/*
if r_pla_empleados.codigo_empleado = ''0188'' then
    raise exception ''entre'';
end if;    
*/
            
            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and desde between r_pla_horas_detalle.desde and r_pla_horas_detalle.hasta
                                    and hasta between r_pla_horas_detalle.desde and r_pla_horas_detalle.hasta
                                    and implemento not in (''25'',''75'')
                                    order by desde, implemento
                                    
            loop
                lb_loop = true;
                li_eventos = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_eventos.desde, r_pla_eventos.hasta);

                if li_minutos >= 420 then
                    li_minutos  =   li_minutos + li_minutos_adicionales;
                end if;                    
                
                if li_minutos_adicionales = 60 then
                    li_minutos_adicionales = 0;
                end if;

                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;

                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else
/*                
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
*/                        
                end if;
            end loop;
            
            if lb_loop then
                continue;
            end if;


            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and desde >= r_pla_horas_detalle.desde 
                                    and desde < r_pla_horas_detalle.hasta
                                    and hasta >= r_pla_horas_detalle.hasta
                                    and implemento not in (''25'',''75'')
                                    order by desde
            loop


                lb_loop     = true;
                li_eventos  = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_eventos.desde, r_pla_horas_detalle.hasta);

                li_minutos  =   li_minutos + li_minutos_adicionales;
                
                if li_minutos_adicionales = 60 then
                    li_minutos_adicionales = 0;
                end if;

                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;

                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
/*                
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
*/                        
                end if;

            end loop;

            if lb_loop is true then
                continue;
            end if;

            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and desde >= r_pla_horas_detalle.desde 
                                    and desde < r_pla_horas_detalle.hasta
                                    and hasta <= r_pla_horas_detalle.hasta
                                    and implemento not in (''25'',''75'')
                                    order by desde
            loop
                lb_loop     = true;
                li_eventos  = li_eventos + 1;
                li_minutos  =   f_intervalo(r_pla_horas_detalle.desde, r_pla_eventos.hasta);
                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;

                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
/*                
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
*/                        
                end if;
            end loop;
            if lb_loop then
                continue;
            end if;


            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and hasta >= r_pla_horas_detalle.desde 
                                    and hasta < r_pla_horas_detalle.hasta
                                    and desde <= r_pla_horas_detalle.desde
                                    and implemento not in (''25'',''75'')
                                    order by desde
            loop
                lb_loop     = true;
                li_eventos  = li_eventos + 1;

            
                li_minutos  =   f_intervalo(r_pla_horas_detalle.desde, r_pla_eventos.hasta);

                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;

                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
/*                
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
*/                        
                end if;
            end loop;
            if lb_loop then
                continue;
            end if;


            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and hasta >= r_pla_horas_detalle.desde 
                                    and hasta < r_pla_horas_detalle.hasta
                                    and desde >= r_pla_horas_detalle.desde
                                    and implemento not in (''25'',''75'')
                                    order by desde
            loop
                lb_loop     = true;
                li_eventos  = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_eventos.desde, r_pla_horas_detalle.hasta);
                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;

                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
/*                
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
*/                        
                end if;
            end loop;
            if lb_loop then
                continue;
            end if;


            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and desde <= r_pla_horas_detalle.desde
                                    and hasta >= r_pla_horas_detalle.hasta
                                    and implemento not in (''25'',''75'')
                                    order by desde
            loop
                lb_loop     = true;
                li_eventos  = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_horas_detalle.desde, r_pla_horas_detalle.hasta);
                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;

                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
/*                
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
*/                        
                end if;
            end loop;
            if lb_loop then
                continue;
            end if;

/*
            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and r_pla_horas_detalle.desde < desde
                                    and r_pla_horas_detalle.hasta between desde and hasta
                                    order by desde
            loop
                lb_loop = true;
                li_eventos = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_eventos.desde, r_pla_horas_detalle.hasta);
            
                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;
                
                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
--                    raise exception ''update %'', li_minutos;
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
--                    raise exception ''insert'';
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
                end if;
            end loop;

            if lb_loop then
                continue;
            end if;

        
            li_eventos = 0;
            lb_loop = false;
            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and r_pla_horas_detalle.desde >= desde
                                    and r_pla_horas_detalle.hasta between desde and hasta
                                    order by desde
            loop
                lb_loop = true;
                li_eventos = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_horas_detalle.desde, r_pla_horas_detalle.hasta);
            
                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;
                
                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
--                    raise exception ''update %'', li_minutos;
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
                    raise exception ''insert'';
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
                end if;
            end loop;

            if lb_loop then
                continue;
            end if;

        
        
            lb_loop = false;
            li_eventos = 0;
--    raise exception ''entre % %'', r_pla_horas_detalle.desde, r_pla_horas_detalle.hasta;


            li_eventos = 0;
            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and desde between r_pla_horas_detalle.desde and r_pla_horas_detalle.hasta
                                    and hasta >= r_pla_horas_detalle.hasta
                                    order by desde
            loop
                lb_loop = true;
                li_eventos = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_horas_detalle.desde, r_pla_horas_detalle.hasta);
            
                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;
                
                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
--                    raise exception ''update %'', li_minutos;
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
                    raise exception ''insert'';
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
                end if;
            end loop;

            if lb_loop then
                continue;
            end if;

            li_eventos = 0;
            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and r_pla_horas_detalle.desde >= desde
                                    and r_pla_horas_detalle.hasta <=  hasta
                                    order by desde
            loop
                lb_loop = true;
                li_eventos = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_horas_detalle.desde, r_pla_horas_detalle.hasta);
            
                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;
                
                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
--                    raise exception ''update %'', li_minutos;
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
                    raise exception ''insert'';
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
                end if;
            end loop;

            if lb_loop then
                continue;
            end if;

            li_eventos = 0;
            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and r_pla_horas_detalle.desde between desde and hasta
                                    and hasta <= r_pla_horas_detalle.hasta
                                    order by desde
            loop
--                    raise exception ''entre'';

                lb_loop = true;
                li_eventos = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_horas_detalle.desde, r_pla_eventos.hasta);
            
                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;
                
                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
--                    raise exception ''update %'', li_minutos;
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
                    raise exception ''insert'';
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
                end if;
            end loop;

            if lb_loop then
                continue;
            end if;


            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and r_pla_horas_detalle.desde not between desde and hasta
                                    and r_pla_horas_detalle.hasta between desde and hasta
                                    order by desde
            loop
                lb_loop = true;

                li_eventos = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_horas_detalle.desde, r_pla_horas_detalle.hasta);
            
                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;
                
                if li_eventos = 1 and r_pla_horas_work.implemento = r_pla_eventos.implemento then    
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
                end if;
            end loop;

            if lb_loop then
                continue;
            end if;
*/

/*
            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and desde between r_pla_horas_detalle.desde and r_pla_horas_detalle.hasta
                                    and hasta between r_pla_horas_detalle.desde and r_pla_horas_detalle.hasta
                                    order by desde
            loop
                li_minutos  =   f_intervalo(r_pla_eventos.desde, r_pla_eventos.hasta);
                
                update pla_horas
                set minutos_implemento = minutos_implemento + li_minutos,
                implemento = r_pla_eventos.implemento
                where id = r_pla_horas.id;
                lb_loop = true;
            end loop;
*/

            if lb_loop then
                continue;
            end if;

/*            
            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and r_pla_horas_detalle.desde not between desde and hasta
                                    and r_pla_horas_detalle.hasta between desde and hasta
                                    order by desde
            loop
                li_minutos  =   f_intervalo(r_pla_eventos.desde, r_pla_horas_detalle.hasta);
                
--                raise exception ''% % %'', li_minutos, r_pla_eventos.hasta, r_pla_horas_detalle.hasta;
                update pla_horas
                set minutos_implemento = minutos_implemento + li_minutos,
                implemento = r_pla_eventos.implemento
                where id = r_pla_horas.id;
            end loop;                                    
*/
/*            
            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and f_to_date(desde) = f_to_date(r_pla_marcaciones.entrada)
                                    and implemento in (''75'',''25'')
            loop
                li_minutos  =   f_intervalo(r_pla_eventos.desde, r_pla_eventos.hasta);

                
                insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                    tasa_por_minuto, aplicar, acumula, forma_de_registro, implemento, 
                    minutos_implemento, compania)
                values (ai_id_pla_marcaciones, ''00'', 0, r_pla_empleados.tasa_por_hora, ''N'', 
                        ''N'', ''A'', r_pla_eventos.implemento, li_minutos, 
                        r_pla_tarjeta_tiempo.compania);

                        
            end loop;
*/
           
        end loop;
    end loop;
    
    return 1;
end;
' language plpgsql;




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
    

    if r_pla_tarjeta_tiempo.compania = 1260 and as_tipo_de_hora = ''00'' then
    
        select into r_pla_horas * from pla_horas
        where id_marcaciones = ai_id_marcaciones
        and tipo_de_hora = ''31'';
        if not found then
            insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                tasa_por_minuto, aplicar, acumula, forma_de_registro, compania)
            values (ai_id_marcaciones, ''31'', 30, adc_tasa_por_minuto, as_aplicar, 
                    as_acumula, ''A'', r_pla_marcaciones.compania);
        end if;    
    end if;
    return 1;
end;
' language plpgsql;

/*
drop function f_pla_calculo_viaticos(int4) cascade;

create function f_pla_calculo_viaticos(int4) returns integer as '
declare
    ai_id_pla_marcaciones alias for $1;
    r_pla_marcaciones_work record;
    r_pla_marcaciones record;
    r_pla_tarjeta_tiempo record;
    r_pla_horas record;
    r_pla_horas_detalle record;
    r_pla_eventos record;
    r_pla_empleados record;
    r_pla_horas_2 record;
    r_pla_horas_work record;
    r_pla_turnos record;
    li_retorno int;
    li_minutos int4;
    li_minutos_nocturnos int4;
    li_eventos int4;
    lb_loop boolean;
begin
    
    select into r_pla_marcaciones *
    from pla_marcaciones
    where id = ai_id_pla_marcaciones;
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

  
    select into r_pla_tarjeta_tiempo *
    from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    if not found then
        return 0;
    end if;
    
    select into r_pla_empleados *
    from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;
    if not found then
        return 0;
    end if;

    for r_pla_horas in select * from pla_horas
                        where id_marcaciones = ai_id_pla_marcaciones
                        order by id
    loop
    
        for r_pla_horas_detalle in select * from pla_horas_detalle
                                    where id_pla_horas = r_pla_horas.id
                                    order by desde
        loop
            li_eventos = 0;
            lb_loop = false;
            li_minutos_nocturnos = 0;    

            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and desde between r_pla_horas_detalle.desde and r_pla_horas_detalle.hasta
                                    and hasta between r_pla_horas_detalle.desde and r_pla_horas_detalle.hasta
                                    order by desde
                                    
            loop
                lb_loop = true;
                li_eventos = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_eventos.desde, r_pla_eventos.hasta);

/*
                if r_pla_turnos.tipo_de_jornada = ''N'' and li_minutos >= 420 
                    and li_minutos_nocturnos = 0 then
                    li_minutos_nocturnos = 60;
                end if;    
*/
                

                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;

                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else
/*                
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
*/                        
                end if;
            end loop;

            if lb_loop then
                continue;
            end if;



            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and desde >= r_pla_horas_detalle.desde 
                                    and desde < r_pla_horas_detalle.hasta
                                    and hasta >= r_pla_horas_detalle.hasta
                                    order by desde
                                    
            loop
                lb_loop     = true;
                li_eventos  = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_eventos.desde, r_pla_horas_detalle.hasta);

                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;

                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
/*                
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
*/                        
                end if;
            end loop;
            if lb_loop then
                continue;
            end if;


            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and desde >= r_pla_horas_detalle.desde 
                                    and desde < r_pla_horas_detalle.hasta
                                    and hasta <= r_pla_horas_detalle.hasta
                                    order by desde
            loop
                lb_loop     = true;
                li_eventos  = li_eventos + 1;
                li_minutos  =   f_intervalo(r_pla_horas_detalle.desde, r_pla_eventos.hasta);
                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;

                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
/*                
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
*/                        
                end if;
            end loop;
            if lb_loop then
                continue;
            end if;


            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and hasta >= r_pla_horas_detalle.desde 
                                    and hasta < r_pla_horas_detalle.hasta
                                    and desde <= r_pla_horas_detalle.desde
                                    order by desde
            loop
                lb_loop     = true;
                li_eventos  = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_horas_detalle.desde, r_pla_eventos.hasta);
                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;

                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
/*                
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
*/                        
                end if;
            end loop;
            if lb_loop then
                continue;
            end if;


            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and hasta >= r_pla_horas_detalle.desde 
                                    and hasta < r_pla_horas_detalle.hasta
                                    and desde >= r_pla_horas_detalle.desde
                                    order by desde
            loop
                lb_loop     = true;
                li_eventos  = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_eventos.desde, r_pla_horas_detalle.hasta);
                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;

                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
/*                
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
*/                        
                end if;
            end loop;
            if lb_loop then
                continue;
            end if;



            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and desde <= r_pla_horas_detalle.desde
                                    and hasta >= r_pla_horas_detalle.hasta
                                    order by desde
            loop
                lb_loop     = true;
                li_eventos  = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_horas_detalle.desde, r_pla_horas_detalle.hasta);
                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;

                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
/*                
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
*/                        
                end if;
            end loop;
            if lb_loop then
                continue;
            end if;

/*
            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and r_pla_horas_detalle.desde < desde
                                    and r_pla_horas_detalle.hasta between desde and hasta
                                    order by desde
            loop
                lb_loop = true;
                li_eventos = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_eventos.desde, r_pla_horas_detalle.hasta);
            
                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;
                
                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
--                    raise exception ''update %'', li_minutos;
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
--                    raise exception ''insert'';
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
                end if;
            end loop;

            if lb_loop then
                continue;
            end if;

        
            li_eventos = 0;
            lb_loop = false;
            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and r_pla_horas_detalle.desde >= desde
                                    and r_pla_horas_detalle.hasta between desde and hasta
                                    order by desde
            loop
                lb_loop = true;
                li_eventos = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_horas_detalle.desde, r_pla_horas_detalle.hasta);
            
                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;
                
                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
--                    raise exception ''update %'', li_minutos;
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
                    raise exception ''insert'';
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
                end if;
            end loop;

            if lb_loop then
                continue;
            end if;

        
        
            lb_loop = false;
            li_eventos = 0;
--    raise exception ''entre % %'', r_pla_horas_detalle.desde, r_pla_horas_detalle.hasta;


            li_eventos = 0;
            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and desde between r_pla_horas_detalle.desde and r_pla_horas_detalle.hasta
                                    and hasta >= r_pla_horas_detalle.hasta
                                    order by desde
            loop
                lb_loop = true;
                li_eventos = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_horas_detalle.desde, r_pla_horas_detalle.hasta);
            
                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;
                
                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
--                    raise exception ''update %'', li_minutos;
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
                    raise exception ''insert'';
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
                end if;
            end loop;

            if lb_loop then
                continue;
            end if;

            li_eventos = 0;
            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and r_pla_horas_detalle.desde >= desde
                                    and r_pla_horas_detalle.hasta <=  hasta
                                    order by desde
            loop
                lb_loop = true;
                li_eventos = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_horas_detalle.desde, r_pla_horas_detalle.hasta);
            
                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;
                
                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
--                    raise exception ''update %'', li_minutos;
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
                    raise exception ''insert'';
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
                end if;
            end loop;

            if lb_loop then
                continue;
            end if;

            li_eventos = 0;
            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and r_pla_horas_detalle.desde between desde and hasta
                                    and hasta <= r_pla_horas_detalle.hasta
                                    order by desde
            loop
--                    raise exception ''entre'';

                lb_loop = true;
                li_eventos = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_horas_detalle.desde, r_pla_eventos.hasta);
            
                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;
                
                if li_eventos = 1 or r_pla_horas_work.implemento is null then    
--                    raise exception ''update %'', li_minutos;
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
                    raise exception ''insert'';
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
                end if;
            end loop;

            if lb_loop then
                continue;
            end if;


            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and r_pla_horas_detalle.desde not between desde and hasta
                                    and r_pla_horas_detalle.hasta between desde and hasta
                                    order by desde
            loop
                lb_loop = true;

                li_eventos = li_eventos + 1;
            
                li_minutos  =   f_intervalo(r_pla_horas_detalle.desde, r_pla_horas_detalle.hasta);
            
                select into r_pla_horas_work *
                from pla_horas                
                where id = r_pla_horas.id;
                
                if li_eventos = 1 and r_pla_horas_work.implemento = r_pla_eventos.implemento then    
                    update pla_horas
                    set minutos_implemento = minutos_implemento + li_minutos,
                    implemento = r_pla_eventos.implemento,
                    id_pla_eventos = r_pla_eventos.id
                    where id = r_pla_horas.id;
                else                
                    insert into pla_horas(id_marcaciones, tipo_de_hora, compania, implemento,
                        minutos, tasa_por_minuto, aplicar, 
                        acumula, forma_de_registro, minutos_implemento,
                        id_pla_eventos)
                    values(r_pla_horas.id_marcaciones, r_pla_horas_work.tipo_de_hora, r_pla_horas.compania,
                        r_pla_eventos.implemento, 0, r_pla_horas.tasa_por_minuto, ''N'',
                        ''N'', ''A'', li_minutos, r_pla_eventos.id);
                end if;
            end loop;

            if lb_loop then
                continue;
            end if;
*/

/*
            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and desde between r_pla_horas_detalle.desde and r_pla_horas_detalle.hasta
                                    and hasta between r_pla_horas_detalle.desde and r_pla_horas_detalle.hasta
                                    order by desde
            loop
                li_minutos  =   f_intervalo(r_pla_eventos.desde, r_pla_eventos.hasta);
                
                update pla_horas
                set minutos_implemento = minutos_implemento + li_minutos,
                implemento = r_pla_eventos.implemento
                where id = r_pla_horas.id;
                lb_loop = true;
            end loop;
*/

            if lb_loop then
                continue;
            end if;

/*            
            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and r_pla_horas_detalle.desde not between desde and hasta
                                    and r_pla_horas_detalle.hasta between desde and hasta
                                    order by desde
            loop
                li_minutos  =   f_intervalo(r_pla_eventos.desde, r_pla_horas_detalle.hasta);
                
--                raise exception ''% % %'', li_minutos, r_pla_eventos.hasta, r_pla_horas_detalle.hasta;
                update pla_horas
                set minutos_implemento = minutos_implemento + li_minutos,
                implemento = r_pla_eventos.implemento
                where id = r_pla_horas.id;
            end loop;                                    
*/
/*            
            for r_pla_eventos in select * from pla_eventos
                                    where compania = r_pla_tarjeta_tiempo.compania
                                    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                    and f_to_date(desde) = f_to_date(r_pla_marcaciones.entrada)
                                    and implemento in (''75'',''25'')
            loop
                li_minutos  =   f_intervalo(r_pla_eventos.desde, r_pla_eventos.hasta);

                
                insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                    tasa_por_minuto, aplicar, acumula, forma_de_registro, implemento, 
                    minutos_implemento, compania)
                values (ai_id_pla_marcaciones, ''00'', 0, r_pla_empleados.tasa_por_hora, ''N'', 
                        ''N'', ''A'', r_pla_eventos.implemento, li_minutos, 
                        r_pla_tarjeta_tiempo.compania);

                        
            end loop;
*/
           
        end loop;
    end loop;
    
    return 1;
end;
' language plpgsql;

*/
