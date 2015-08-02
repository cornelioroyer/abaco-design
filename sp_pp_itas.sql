
set search_path to 'planilla';


drop function f_it_tbl_data_user_after_insert() cascade;
drop function f_it_tbl_data_user(int4) cascade;


create function f_it_tbl_data_user_after_insert() returns trigger as '
declare
    i integer;
begin

    i   =   f_it_tbl_data_user(new.it_dat_use_nid);

    return new;
end;
' language plpgsql;


create function f_it_tbl_data_user(int4) returns int4 as '
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
    r_it_tbl_data_user record;
    r_pla_turnos record;
    r_it_tbl_data_user_pla_marcacione record;
    ld_fecha date;
    lt_punch_time time;
    lt_work time;
    lt_work_min time;
    i int4;
    li_turno int4;
begin

    select into r_it_tbl_data_user_pla_marcacione *
    from it_tbl_data_user_pla_marcacione
    where it_tbl_data_user_id = ai_id;
    if found then
        return 0;
/*
        delete from it_tbl_data_user_pla_marcacione
        where id = r_it_tbl_data_user_pla_marcacione.id;
*/        
    end if;
            
            
    select into r_it_tbl_data_user *
    from it_tbl_data_user
    where it_dat_use_nid = ai_id;
    
    
    select into r_pla_empleados *
    from pla_empleados
    where trim(cedula) = trim(r_it_tbl_data_user.it_dat_use_id);
    if not found then
        return 0;
    end if;        
    
    ld_fecha = f_to_date(r_it_tbl_data_user.it_dat_use_dialing_start);
    
    select into r_pla_periodos *
    from pla_periodos
    where compania = r_pla_empleados.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and year = Anio(ld_fecha)
    and ld_fecha between desde and hasta
    and status = ''A''
    order by dia_d_pago;
    if not found then
        return 0;
    end if;
    
    select into r_pla_tarjeta_tiempo *
    from pla_tarjeta_tiempo
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and id_periodos = r_pla_periodos.id;
    if not found then
        return 0;
    end if;

    select into r_pla_turnos *
    from pla_turnos
    where compania = r_pla_empleados.compania
    order by hora_inicio
    limit 1;


    i = f_insertar_pla_marcaciones(r_pla_empleados.compania, r_pla_empleados.codigo_empleado, 
            r_pla_tarjeta_tiempo.id_periodos, null,
            r_pla_turnos.turno, 
            r_it_tbl_data_user.it_dat_use_dialing_start,
            r_it_tbl_data_user.it_dat_use_dialing_end,
            null,
            null, ''R'');

            
    select into r_pla_marcaciones *
    from pla_marcaciones
    where id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
    and compania = r_pla_empleados.compania
    and f_to_date(entrada) = ld_fecha;
    if not found then
        return 0;
    else

        if r_it_tbl_data_user.it_dat_use_dialing_start is null or
            r_it_tbl_data_user.it_dat_use_dialing_end is null then

            update pla_marcaciones
            set status = ''I''
            where id = r_pla_marcaciones.id;
        end if;

            
    end if;
    
    
    insert into it_tbl_data_user_pla_marcacione(it_tbl_data_user_id, pla_marcaciones_id)
    values (ai_id, r_pla_marcaciones.id);
    
/*        
        li_turno        = r_pla_marcaciones.turno;
        lt_punch_time   = f_extract_time(r_att_punches.punch_time);
        lt_work_min     = ''24:00'';
        for r_pla_turnos_reloj in
            select * from pla_turnos_reloj, pla_turnos
            where pla_turnos.compania = pla_turnos_reloj.compania
            and pla_turnos.turno = pla_turnos_reloj.turno
            and pla_turnos.compania = r_pla_empleados.compania
            and lt_punch_time between checkin_begin and checkin_end
            order by checkin_begin
        loop
            
            lt_work = lt_punch_time - r_pla_turnos_reloj.checkin_begin;
--            lt_work = lt_punch_time - r_pla_turnos.hora_inicio;
            
            if lt_work < lt_work_min then
                lt_work_min = lt_work;
                li_turno = r_pla_turnos_reloj.turno;
            end if;                
        end loop;            

        
        if r_pla_marcaciones.status = ''I'' then        
            update pla_marcaciones
            set entrada = r_att_punches.punch_time, status = ''R'',
                turno = li_turno
            where id = r_pla_marcaciones.id;
        else
            update pla_marcaciones
            set entrada = r_att_punches.punch_time, turno = li_turno
            where id = r_pla_marcaciones.id;
        end if;                    


*/

        

    return 1;
end;
' language plpgsql;




create trigger t_it_tbl_data_user after insert on it_tbl_data_user
for each row execute procedure f_it_tbl_data_user_after_insert();

