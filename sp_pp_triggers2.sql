
set search_path to planilla;


drop function f_pp_usuario_after_insert() cascade;
drop function f_pp_horarios_before_update() cascade;
drop function f_att_punches_after_insert() cascade;
drop function f_pp_horarios_before_insert() cascade;
drop function f_pp_horarios_after_update() cascade;
drop function f_pp_horarios_pla_marcaciones(int4) cascade;
drop function f_pla_companias_after_update() cascade;


create function f_pla_companias_after_update() returns trigger as '
declare
    r_pla_periodos record;
    r_pla_marcaciones record;
    i integer;
begin
    if f_pla_parametros(new.compania, ''utilizan_reloj'', ''N'', ''GET'') = ''S'' then
        i = f_zktime_hr_company(new.compania);
    end if;        

    return new;
end;
' language plpgsql;


create function f_pp_horarios_pla_marcaciones(int4) returns int4 as '
declare
    ai_id alias for $1;
    r_pla_companias record;
    r_hr_company record;
    r_att_punches record;
    r_att_punches_pla_marcaciones record;
    r_hr_employee record;
    r_pla_empleados record;
    r_hr_department record;
    r_pla_periodos record;
    r_pla_tarjeta_tiempo record;
    r_pla_turnos_reloj record;
    r_pla_marcaciones record;
    r_pla_turnos record;
    r_pp_horarios record;
    r_pla_eventos record;
    ld_fecha date;
    lt_punch_time time;
    lt_work time;
    lt_work_min time;
    i int4;
    li_turno int4;
begin

    select into r_pp_horarios *
    from pp_horarios
    where id = ai_id;
    if not found then
        return 0;
    end if;
    
    select into r_pla_periodos *
    from pla_periodos
    where id = r_pp_horarios.pla_periodos_id;
    if not found then
        return 0;
    else
        if r_pla_periodos.status = ''C'' then
            return 0;
        end if;            
    end if;        


    select into r_pla_marcaciones pla_marcaciones.*
    from pla_tarjeta_tiempo, pla_marcaciones
    where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
    and pla_tarjeta_tiempo.compania = r_pp_horarios.compania
    and pla_tarjeta_tiempo.codigo_empleado = r_pp_horarios.codigo_empleado
    and pla_tarjeta_tiempo.id_periodos = r_pla_periodos.id
    and f_to_date(pla_marcaciones.entrada) = r_pp_horarios.fecha;
    if found then
        update pla_marcaciones
        set entrada = f_timestamp(r_pp_horarios.fecha, r_pp_horarios.entrada1),
            salida = f_timestamp(r_pp_horarios.fecha, r_pp_horarios.salida1),
            entrada_descanso = f_timestamp(r_pp_horarios.fecha, r_pp_horarios.descanso_inicio), 
            salida_descanso = f_timestamp(r_pp_horarios.fecha, r_pp_horarios.descanso_fin),
            status = r_pp_horarios.status, 
            turno = r_pp_horarios.turno,
            autorizado = r_pp_horarios.autorizado
        where id = r_pla_marcaciones.id;

   
        if r_pp_horarios.entrada2 is not null and r_pp_horarios.salida2 is not null 
            and r_pp_horarios.implemento is not null then
            select into r_pla_eventos *
            from pla_eventos
            where compania = r_pp_horarios.compania
            and codigo_empleado = r_pp_horarios.codigo_empleado
            and f_to_date(desde) = r_pp_horarios.fecha
            and trim(implemento) = r_pp_horarios.implemento;
            if not found then
                select Max(id) into i from pla_eventos;
            
                insert into pla_eventos(id, compania, codigo_empleado, implemento, desde, hasta)
                values(i+1, r_pp_horarios.compania, r_pp_horarios.codigo_empleado, r_pp_horarios.implemento,
                    f_timestamp(r_pp_horarios.fecha, r_pp_horarios.entrada2),
                    f_timestamp(r_pp_horarios.fecha, r_pp_horarios.salida2));
            else
                update pla_eventos
                set desde =  f_timestamp(r_pp_horarios.fecha, r_pp_horarios.entrada2),
                    hasta =  f_timestamp(r_pp_horarios.fecha, r_pp_horarios.salida2)
                where id = r_pla_eventos.id;
            end if;
        end if;

        if r_pp_horarios.entrada3 is not null and r_pp_horarios.salida3 is not null then
            select into r_pla_eventos *
            from pla_eventos
            where compania = r_pp_horarios.compania
            and codigo_empleado = r_pp_horarios.codigo_empleado
            and f_to_date(desde) = r_pp_horarios.fecha
            and trim(implemento) = ''25'';
            if not found then
                select Max(id) into i from pla_eventos;

                insert into pla_eventos(id, compania, codigo_empleado, implemento, desde, hasta)
                values(i+1, r_pp_horarios.compania, r_pp_horarios.codigo_empleado, ''25'',
                    f_timestamp(r_pp_horarios.fecha, r_pp_horarios.entrada3),
                    f_timestamp(r_pp_horarios.fecha, r_pp_horarios.salida3));
            else
                update pla_eventos
                set desde =  f_timestamp(r_pp_horarios.fecha, r_pp_horarios.entrada3),
                    hasta =  f_timestamp(r_pp_horarios.fecha, r_pp_horarios.salida3)
                where id = r_pla_eventos.id;
            end if;                    

        end if;

    else

-- raise exception ''% %'', r_pp_horarios.compania, r_pp_horarios.codigo_empleado;

        i = f_insertar_pla_marcaciones(
                r_pp_horarios.compania, 
                r_pp_horarios.codigo_empleado,
                r_pp_horarios.pla_periodos_id, 
                r_pp_horarios.pla_proyectos_id,
                r_pp_horarios.turno, 
                f_timestamp(r_pp_horarios.fecha, r_pp_horarios.entrada1),
                f_timestamp(r_pp_horarios.fecha, r_pp_horarios.salida1),
                f_timestamp(r_pp_horarios.fecha, r_pp_horarios.descanso_inicio),
                f_timestamp(r_pp_horarios.fecha, r_pp_horarios.descanso_fin), 
                r_pp_horarios.status);

        select into r_pla_marcaciones pla_marcaciones.*
        from pla_tarjeta_tiempo, pla_marcaciones
        where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
        and pla_tarjeta_tiempo.compania = r_pp_horarios.compania
        and pla_tarjeta_tiempo.codigo_empleado = r_pp_horarios.codigo_empleado
        and pla_tarjeta_tiempo.id_periodos = r_pla_periodos.id
        and f_to_date(pla_marcaciones.entrada) = r_pp_horarios.fecha;
        if found then
            update pla_marcaciones
            set status = r_pp_horarios.status,
                autorizado = r_pp_horarios.autorizado
            where id = r_pla_marcaciones.id;
        end if;

                
    end if;
   
    
    return 1;
end;
' language plpgsql;


create function f_pp_horarios_after_update() returns trigger as '
declare
    r_pla_periodos record;
    r_pla_marcaciones record;
    i integer;
begin

    i = f_pp_horarios_pla_marcaciones(new.id);      

    return new;
end;
' language plpgsql;


create function f_pp_horarios_before_insert() returns trigger as '
declare
    r_pla_turnos record;
    r_pla_empleados record;
begin
    if new.pp_usuario_id is null then
        new.pp_usuario_id = 1;
    end if;
    
    select into r_pla_empleados *
    from pla_empleados
    where compania = new.compania
    and codigo_empleado = new.codigo_empleado;
    if not found then
        Raise Exception ''Codigo de Empleado % no Existe'', new.codigo_empleado;
    else
        new.pla_periodos_id = f_pla_periodo_actual(new.compania, r_pla_empleados.tipo_de_planilla);
    end if;        
    
    return new;
end;
' language plpgsql;



create function f_att_punches_after_insert() returns trigger as '
declare
    r_pla_marcaciones record;
    r_pla_marcaciones_movicell record;
    lts_entrada timestamp;
    lts_salida timestamp;
    lts_entrada_descanso timestamp;
    lts_salida_descanso timestamp;
    lt_new_dato text;
    lt_old_dato text;
    i int4;
    lc_status char(1);
begin

    i  = f_att_punches_pla_marcaciones(new.id);
    
    
    return new;
end;
' language plpgsql;



create function f_pp_horarios_before_update() returns trigger as '
declare
    r_pla_turnos record;
begin
-- tipo usuario
-- 1 = usuario comun
-- 2 = administrador
-- 3 = super admin

    if new.entrada2 is not null and new.salida2 is null then
        Raise Exception ''Salida es Obligatorio Empleado % Fecha %...Verifique'', new.codigo_empleado, new.fecha;
    end if;        


    if new.turno <> old.turno then
        select into r_pla_turnos *
        from pla_turnos
        where compania = new.compania
        and turno = new.turno;
        if not found then
            Raise Exception ''Turno % no Existe'', new.turno;
        else
            new.entrada1 = r_pla_turnos.hora_inicio;
            new.descanso_inicio = r_pla_turnos.hora_inicio_descanso;
            new.descanso_fin = r_pla_turnos.hora_salida_descanso;
            new.salida1 = r_pla_turnos.hora_salida;
        end if;            
    end if;
  
/*    
    if (new.entrada2 is not null or new.salida2 is not null) and new.implemento is null then
        new.implemento = ''04'';
--        Raise Exception ''El Codigo de Implemento es Obligatorio en la fecha % '', new.fecha;
    end if;
*/    
    
    return new;
end;
' language plpgsql;


create function f_pp_usuario_after_insert() returns trigger as '
declare
    r_pp_usuario record;
    r_pp_usuario_compania record;
begin
-- tipo usuario
-- 1 = usuario comun
-- 2 = administrador
-- 3 = super admin

    if new.pp_usuario_id is not null then
        select into r_pp_usuario *
        from pp_usuario
        where id = new.pp_usuario_id;
        if not found then
            Raise Exception ''Usuario no Existe...Verifique'';
        else            
            if r_pp_usuario.tipo_usuario = ''2'' then
                select into r_pp_usuario_compania *
                from pp_usuario_compania
                where pp_usuario_id = new.pp_usuario_id
                order by id
                limit 1;
                if found then
                    insert into pp_usuario_compania(pp_usuario_id, compania)
                    values(new.id, r_pp_usuario_compania.compania);
                end if;                    
            end if;
        end if;
    end if;        
    return new;
end;
' language plpgsql;

/*
create trigger t_pp_horarios_before_update before update on pp_horarios
for each row execute procedure f_pp_horarios_before_update();
*/

create trigger t_pp_usuario_after_insert after insert on pp_usuario
for each row execute procedure f_pp_usuario_after_insert();

create trigger t_pp_horarios_before_update before update on pp_horarios
for each row execute procedure f_pp_horarios_before_update();

create trigger t_att_punches_after_insert after insert on att_punches
for each row execute procedure f_att_punches_after_insert();

create trigger t_pp_horarios_before_insert before insert on pp_horarios
for each row execute procedure f_pp_horarios_before_insert();

create trigger t_pp_horarios_after_update after update on pp_horarios
for each row execute procedure f_pp_horarios_after_update();

create trigger t_pla_companias_after_update after update on pla_companias
for each row execute procedure f_pla_companias_after_update();
