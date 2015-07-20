set search_path to planilla;


--rollback work;

--begin work;
drop function f_pla_marcaciones_movicell_after_insert() cascade;
drop function f_pla_turnos_x_dia_after_insert() cascade;

--commit work;

begin work;
create function f_pla_turnos_x_dia_after_insert() returns trigger as '
declare
    r_pla_marcaciones record;
    r_pla_turnos record;
    lts_entrada timestamp;
    lts_salida timestamp;
    lts_entrada_descanso timestamp;
    lts_salida_descanso timestamp;
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), new.id, trim(lt_old_dato), trim(lt_new_dato), null);

    select into r_pla_turnos *
    from pla_turnos
    where compania = new.compania
    and turno = new.turno;
    if not found then
        Raise Exception ''Turno % no existe'', new.turno;
    end if;

    if new.entrada is not null then
        r_pla_turnos.hora_inicio = new.entrada;
    end if;
    
    if new.salida is not null then
        r_pla_turnos.hora_salida = new.salida;
    end if;

    select into r_pla_marcaciones *
    from pla_marcaciones, pla_tarjeta_tiempo, pla_periodos
    where pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
    and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
    and pla_periodos.status = ''A''
    and pla_tarjeta_tiempo.codigo_empleado = new.codigo_empleado
    and pla_tarjeta_tiempo.compania = new.compania
    and f_to_date(pla_marcaciones.entrada) = new.fecha;
    if found then
        lts_entrada             =   f_timestamp(f_to_date(r_pla_marcaciones.entrada), r_pla_turnos.hora_inicio);
        lts_salida              =   f_timestamp(f_to_date(r_pla_marcaciones.salida), r_pla_turnos.hora_salida);
        lts_entrada_descanso    =   f_timestamp(f_to_date(r_pla_marcaciones.entrada_descanso), r_pla_turnos.hora_inicio_descanso);
        lts_salida_descanso     =   f_timestamp(f_to_date(r_pla_marcaciones.salida_descanso), r_pla_turnos.hora_salida_descanso);
        
        if r_pla_turnos.hora_salida < r_pla_turnos.hora_inicio then
            lts_salida          =   f_timestamp((f_to_date(r_pla_marcaciones.salida)+1), r_pla_turnos.hora_salida);
        end if;
        
        if new.compania = 1075 and new.turno = 3 then
            lts_salida = lts_salida + Interval ''90 minute'';
        end if;
        
        if r_pla_marcaciones.status = ''I'' and new.status = ''R'' then
            new.status = ''I'';
        end if;
        
        update pla_marcaciones
        set turno = new.turno, status = new.status, autorizado = new.autorizado,
            entrada = lts_entrada, salida = lts_salida, entrada_descanso = lts_entrada_descanso, salida_descanso = lts_salida_descanso,
            id_pla_proyectos = new.id_pla_proyectos
        where id = r_pla_marcaciones.id;
    end if;

    return new;
end;
' language plpgsql;




create function f_pla_marcaciones_movicell_after_insert() returns trigger as '
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
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), new.id, trim(lt_old_dato), trim(lt_new_dato), null);

/*
        lts_entrada             =   f_timestamp(f_to_date(r_pla_marcaciones.entrada), r_pla_turnos.hora_inicio);
        lts_salida              =   f_timestamp(f_to_date(r_pla_marcaciones.salida), r_pla_turnos.hora_salida);
        lts_entrada_descanso    =   f_timestamp(f_to_date(r_pla_marcaciones.entrada_descanso), r_pla_turnos.hora_inicio_descanso);
        lts_salida_descanso     =   f_timestamp(f_to_date(r_pla_marcaciones.salida_descanso), r_pla_turnos.hora_salida_descanso);
*/

        
    if new.entrada is null or new.salida is null then
        return new;
    end if;
       

    select into r_pla_marcaciones *
    from pla_marcaciones, pla_tarjeta_tiempo, pla_periodos
    where pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
    and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
    and pla_periodos.status = ''A''
    and pla_tarjeta_tiempo.codigo_empleado = new.codigo_empleado
    and pla_tarjeta_tiempo.compania = new.compania
    and f_to_date(pla_marcaciones.entrada) = new.fecha;
    if found then
        lc_status = r_pla_marcaciones.status;
        select into r_pla_marcaciones_movicell *
        from pla_marcaciones_movicell
        where compania = new.compania
        and codigo_empleado = new.codigo_empleado
        and fecha = new.fecha
        and id <> new.id;
        if found then
            lts_entrada_descanso            =   f_timestamp(f_to_date(r_pla_marcaciones.entrada), r_pla_marcaciones_movicell.salida);
            lts_salida_descanso             =   f_timestamp(f_to_date(r_pla_marcaciones.entrada), new.entrada);
            lts_salida                      =   f_timestamp(f_to_date(r_pla_marcaciones.salida), new.salida);

            if lc_status = ''I'' then
                lc_status = ''R'';
            end if;
            
            update pla_marcaciones
            set entrada_descanso = lts_entrada_descanso, salida_descanso = lts_salida_descanso, salida = lts_salida, status = lc_status
            where id = r_pla_marcaciones.id;
        else
            lts_entrada             =   f_timestamp(f_to_date(r_pla_marcaciones.entrada), new.entrada);
            lts_salida              =   f_timestamp(f_to_date(r_pla_marcaciones.entrada), new.salida);
        
            if lc_status = ''I'' then
                lc_status = ''R'';
            end if;
        
            update pla_marcaciones
            set entrada = lts_entrada, salida = lts_salida, status = lc_status
            where id = r_pla_marcaciones.id;
    
/*        
            if new.salida - new.entrada >= interval ''09:00'' then
                lts_entrada             =   f_timestamp(f_to_date(r_pla_marcaciones.entrada), new.entrada);
                lts_salida              =   f_timestamp(f_to_date(r_pla_marcaciones.entrada), new.salida);
            
                if lc_status = ''I'' then
                    lc_status = ''R'';
                end if;
            
                update pla_marcaciones
                set entrada = lts_entrada, salida = lts_salida, status = lc_status
                where id = r_pla_marcaciones.id;
            else
        
                lts_entrada             =   f_timestamp(f_to_date(r_pla_marcaciones.entrada), new.entrada);
            
                if r_pla_marcaciones.entrada_descanso is null then
                    lts_entrada_descanso    =   f_timestamp(new.fecha, new.salida);
                else
                    lts_entrada_descanso    =   f_timestamp(f_to_date(r_pla_marcaciones.entrada), new.salida);
                end if;
            
                if lc_status = ''I'' then
                    lc_status = ''R'';
                end if;
            
                update pla_marcaciones
                set entrada = lts_entrada, entrada_descanso = lts_entrada_descanso, status = lc_status
                where id = r_pla_marcaciones.id;
            end if;            
*/            
        end if;
        
/*                    
                   else
            lts_entrada             =   f_timestamp(f_to_date(r_pla_marcaciones.entrada), r_pla_turnos.hora_inicio);
            lts_salida              =   f_timestamp(f_to_date(r_pla_marcaciones.salida), r_pla_turnos.hora_salida);
            lts_entrada_descanso    =   f_timestamp(f_to_date(r_pla_marcaciones.entrada_descanso), r_pla_turnos.hora_inicio_descanso);
            lts_salida_descanso     =   f_timestamp(f_to_date(r_pla_marcaciones.salida_descanso), r_pla_turnos.hora_salida_descanso);
        
        update pla_marcaciones
        set turno = new.turno, status = new.status, autorizado = new.autorizado,
            entrada = lts_entrada, salida = lts_salida, entrada_descanso = lts_entrada_descanso, salida_descanso = lts_salida_descanso,
            id_pla_proyectos = new.id_pla_proyectos
        where id = r_pla_marcaciones.id;
*/        
    end if;

    return new;
end;
' language plpgsql;
commit work;


--begin work;
create trigger t_pla_marcaciones_movicell_after_insert after insert on pla_marcaciones_movicell
for each row execute procedure f_pla_marcaciones_movicell_after_insert();

create trigger t_pla_turnos_x_dia_after_insert after insert on pla_turnos_x_dia
for each row execute procedure f_pla_turnos_x_dia_after_insert();
--commit work;





