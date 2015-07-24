
set search_path to 'planilla';


drop function f_pp_usuario_after_insert() cascade;
drop function f_pp_horarios_before_update() cascade;
drop function f_att_punches_after_insert() cascade;
drop function f_pp_horarios_before_insert() cascade;
drop function f_pp_horarios_after_update() cascade;

create function f_pp_horarios_after_update() returns trigger as '
declare
    r_pla_periodos record;
    r_pla_marcaciones record;
begin

    return new;
    
    select into r_pla_periodos *
    from pla_periodos
    where id = new.pla_periodos_id;
    if not found then
        return new;
    else
        if r_pla_periodos.status = ''C'' then
            return new;
        end if;            
    end if;        


    select into r_pla_marcaciones pla_marcaciones.*
    from pla_tarjeta_tiempo, pla_marcaciones
    where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
    and pla_tarjeta_tiempo.compania = new.compania
    and pla_tarjeta_tiempo.codigo_empleado = new.codigo_empleado
    and pla_tarjeta_tiempo.id_periodos = r_pla_periodos.id
    and f_to_date(pla_marcaciones.entrada) = new.fecha;
    if found then
        update pla_marcaciones
        set entrada = f_timestamp(new.fecha, new.entrada1),salida = f_timestamp(new.fecha, new.salida1),
            entrada_descanso = f_timestamp(new.fecha, new.descanso_inicio), salida_descanso = f_timestamp(new.fecha, new.descanso_fin)
        where id = r_pla_marcaciones.id;
    end if;
    
    

    return new;
end;
' language plpgsql;


create function f_pp_horarios_before_insert() returns trigger as '
declare
    r_pla_turnos record;
begin
    if new.pp_usuario_id is null then
        new.pp_usuario_id = 1;
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
