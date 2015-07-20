rollback work;

begin work;
drop function f_zktime_hr_department(int4) cascade;
drop function f_att_punches_pla_marcaciones(int4) cascade;
drop function f_zktime_hr_company(int4) cascade;
drop function f_zktime_hr_employee(int4, char(7)) cascade;


create function f_att_punches_pla_marcaciones(int4) returns int4 as '
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
    ld_fecha date;
    lt_punch_time time;
    lt_work time;
    lt_work_min time;
    i int4;
    li_turno int4;
begin

    delete from att_punches_pla_marcaciones
    where att_punches_id = ai_id;
    

    select into r_att_punches *
    from att_punches
    where id = ai_id;
    if not found then
        return 0;
    end if;
    
    ld_fecha = f_to_date(r_att_punches.punch_time);
    
    select into r_hr_employee *
    from hr_employee
    where id = r_att_punches.employee_id;
    if not found then
        return 0;
    end if;
    
    select into r_hr_department *
    from hr_department
    where id = r_hr_employee.department_id;
    if not found then
        return 0;
    end if;
    
    select into r_pla_empleados *             
    from pla_empleados
    where compania = r_hr_department.company_id
    and trim(codigo_empleado) = Trim(r_hr_employee.emp_pin);
    if not found then
        return 0;
    end if;        

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
    
-- 0 = entrada
-- 1 = salida
-- 2 = inicio descanso
-- 3 = salida descanso
    
    if r_att_punches.workstate = 0 then
        select into r_pla_marcaciones *
        from pla_marcaciones
        where id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
        and compania = r_pla_empleados.compania
        and f_to_date(entrada) = ld_fecha;
        if not found then
            select into r_pla_turnos *
            from pla_turnos
            where compania = r_pla_empleados.compania
            order by hora_inicio
            limit 1;
            
            i = f_insertar_pla_marcaciones(r_pla_empleados.compania, r_pla_empleados.codigo_empleado, 
                    r_pla_tarjeta_tiempo.id_periodos, null,
                    r_pla_turnos.turno, f_timestamp(ld_fecha, r_pla_turnos.hora_inicio),
                    f_timestamp(ld_fecha, r_pla_turnos.hora_salida),
                    f_timestamp(ld_fecha, r_pla_turnos.hora_inicio_descanso),
                    f_timestamp(ld_fecha, r_pla_turnos.hora_salida_descanso), ''R'');
                    

/*        
            i = f_crear_tarjeta(r_pla_empleados.compania, r_pla_empleados.codigo_empleado, ld_fecha,
                r_pla_tarjeta_tiempo.id_periodos);                    
*/                

            select into r_pla_marcaciones *
            from pla_marcaciones
            where id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
            and compania = r_pla_empleados.compania
            and f_to_date(entrada) = ld_fecha;
            if not found then
                return 0;
            end if;
                
        end if;


        select into r_att_punches_pla_marcaciones *
        from att_punches, att_punches_pla_marcaciones
        where att_punches.id = att_punches_pla_marcaciones.att_punches_id
        and att_punches_pla_marcaciones.pla_marcaciones_id = r_pla_marcaciones.id
        and att_punches.workstate = 0;
        if found then
            return 0;
        end if;            

        
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
        
    elsif r_att_punches.workstate = 2 then
    
        select into r_pla_marcaciones *
        from pla_marcaciones
        where id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
        and compania = r_pla_empleados.compania
        and f_to_date(entrada_descanso) = ld_fecha;
        if not found then
            return 0;
        end if;            

        update pla_marcaciones
        set entrada_descanso = r_att_punches.punch_time
        where id = r_pla_marcaciones.id;

    elsif r_att_punches.workstate = 3 then
        select into r_pla_marcaciones *
        from pla_marcaciones
        where id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
        and compania = r_pla_empleados.compania
        and f_to_date(salida_descanso) = ld_fecha;
        if not found then
            return 0;
        end if;            

        update pla_marcaciones
        set salida_descanso = r_att_punches.punch_time
        where id = r_pla_marcaciones.id;

    else
        select into r_pla_marcaciones *
        from pla_marcaciones
        where id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
        and compania = r_pla_empleados.compania
        and f_to_date(salida) = ld_fecha;
        if not found then
            select into r_pla_turnos *
            from pla_turnos
            where compania = r_pla_empleados.compania
            order by hora_inicio
            limit 1;
            
            i = f_insertar_pla_marcaciones(r_pla_empleados.compania, r_pla_empleados.codigo_empleado, 
                    r_pla_tarjeta_tiempo.id_periodos, null,
                    r_pla_turnos.turno, f_timestamp(ld_fecha, r_pla_turnos.hora_inicio),
                    f_timestamp(ld_fecha, r_pla_turnos.hora_salida),
                    f_timestamp(ld_fecha, r_pla_turnos.hora_inicio_descanso),
                    f_timestamp(ld_fecha, r_pla_turnos.hora_salida_descanso), ''R'');

            select into r_pla_marcaciones *
            from pla_marcaciones
            where id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
            and compania = r_pla_empleados.compania
            and f_to_date(entrada) = ld_fecha;
            if not found then
                return 0;
            end if;
        end if;

        update pla_marcaciones
        set salida = r_att_punches.punch_time
        where id = r_pla_marcaciones.id;


    end if;    
    
    insert into att_punches_pla_marcaciones(att_punches_id, pla_marcaciones_id)
    values (ai_id, r_pla_marcaciones.id);

    return 1;
end;
' language plpgsql;



create function f_zktime_hr_company(int4) returns integer as '
declare
    ai_cia alias for $1;
    r_pla_companias record;
    r_hr_company record;
    r_pla_departamentos record;
    r_pla_empleados record;
    i integer;
begin
-- raise exception ''entre'';

    select into r_pla_companias *
    from pla_companias
    where compania = ai_cia;
    if not found then
        return 0;
    end if;

    if r_pla_companias.att_zone_id is null then
        return 0;
    end if;        

    if Trim(f_pla_parametros(ai_cia, ''utilizan_reloj'',''N'',''GET'')) <> ''S'' then
        return 0;
    end if;

    select into r_hr_company *
    from hr_company
    where id = ai_cia;
    if not found then
        insert into hr_company(id, cmp_code, cmp_dateformat, cmp_timeformat, cmp_name, 
            cmp_operationmode,
            cmp_address1, cmp_address2, cmp_phone, cmp_fax, cmp_email, 
            cmp_showlogoinreport, cmp_website)
        values(r_pla_companias.compania, trim(to_char(r_pla_companias.compania, ''999999'')),
            null, null, r_pla_companias.nombre, 0,
            r_pla_companias.direccion1, r_pla_companias.direccion2, r_pla_companias.telefono1,
            null, 
            Trim(r_pla_companias.e_mail), false, ''www.planillapanama.com'');
    else
        update hr_company
        set cmp_name = Trim(r_pla_companias.nombre),
            cmp_city = ''Panama'',
            cmp_state = ''Panama'',
            cmp_country = ''Panama'',
            cmp_postal = '' '',
            cmp_fax = '' ''
        where id = ai_cia;
            
    end if;



    for r_pla_departamentos in
        select * from pla_departamentos
        where compania = ai_cia
        order by departamento
    loop 
        i   =   f_zktime_hr_department(r_pla_departamentos.id);
    end loop;



    for r_pla_empleados in
        select * from pla_empleados
        where compania = ai_cia
        and status in (''A'', ''V'')
        order by codigo_empleado
    loop 
        i   =   f_zktime_hr_employee(r_pla_empleados.compania, r_pla_empleados.codigo_empleado);
    end loop;
    
    
    return 1;
end;
' language plpgsql;



create function f_zktime_hr_department(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_companias record;
    r_hr_company record;
    r_hr_department record;
    r_pla_departamentos record;
    li_att_shift_id int4;
begin
    select into r_pla_departamentos *
    from pla_departamentos
    where id = ai_id;
    if not found then
        return 0;
    end if;

    li_att_shift_id = 0;
    select into li_att_shift_id Max(id) from att_shift;
    
    select into r_hr_department *
    from hr_department
    where id = ai_id;
    if not found then
        insert into hr_department(id, dept_code, dept_name, dept_parentcode,
            dept_operationmode, middleware_id, defaultdepartment,
            company_id, shift_id)
        values(r_pla_departamentos.id, r_pla_departamentos.id,
            Trim(r_pla_departamentos.descripcion), 0,
            0, 0, 0, r_pla_departamentos.compania, li_att_shift_id);
    else
        update hr_department
        set dept_name = trim(r_pla_departamentos.descripcion),
            dept_parentcode = 0
        where id = ai_id;
    end if;
    
    return 1;
end;
' language plpgsql;





create function f_zktime_hr_employee(int4, char(7)) returns integer as '
declare
    ai_cia alias for $1;
    ac_codigo_empleado alias for $2;
    r_pla_companias record;
    r_pla_empleados record;
    r_hr_company record;
    r_hr_department record;
    r_hr_employee record;
    r_pla_departamentos record;
    r_att_employee_zone record;
    li_id int4;
    li_emp_active integer;
    li_id2 int4;
    li_att_zone_id int4;
    i integer;
begin
    select into r_pla_companias *
    from pla_companias
    where compania = ai_cia;
    if not found then
        return 0;
    end if;
    
    if r_pla_companias.att_zone_id is null then
        return 0;
    end if;

    if Trim(f_pla_parametros(ai_cia, ''utilizan_reloj'',''N'',''GET'')) <> ''S'' then
        return 0;
    end if;
    
    select into r_pla_empleados *
    from pla_empleados
    where compania = ai_cia
    and codigo_empleado = ac_codigo_empleado;
    if not found then
        return 0;
    end if;


    if r_pla_empleados.reloj is not true then
        return 0;
    end if;
    
    if r_pla_empleados.fecha_terminacion_real is not null or
        (r_pla_empleados.status <> ''A'' and r_pla_empleados.status <> ''V'') then
        return 0;        
    end if;        

    i = f_zktime_hr_department(r_pla_empleados.departamento);


    select into r_hr_employee *
    from hr_employee, hr_department
    where hr_employee.department_id = hr_department.id
    and hr_department.company_id = ai_cia
    and trim(hr_employee.emp_pin) = trim(r_pla_empleados.codigo_empleado);
    if not found then
        li_id = 0;
        select Max(id) into li_id
        from hr_employee;
        if li_id is null then
            li_id = 1;
        else
            li_id = li_id + 1;            
        end if;
        
        insert into hr_employee(id, emp_pin, emp_ssn, emp_role, emp_firstname, emp_lastname,
            emp_username, emp_pwd, emp_timezone, emp_phone, emp_payroll_id,
            emp_payroll_type, emp_pin2, emp_privilege, emp_group, emp_hiredate,
            emp_address, emp_active, emp_firedate, emp_firereason, 
            emp_emergencyphone1, emp_emergencyphone2, emp_emergencyname, emp_emergencyaddress, 
            emp_cardnumber, emp_country, emp_city, emp_state, emp_postal, emp_fax,
            emp_email,
            emp_title, 
            emp_hourlyrate1, emp_hourlyrate2, emp_hourlyrate3, emp_hourlyrate4, emp_hourlyrate5,
            emp_gender, emp_birthday, emp_operationmode, isselect, middleware_id, nationalid, 
            department_id)
        values(li_id, trim(r_pla_empleados.codigo_empleado), '' '', '' '', 
            trim(r_pla_empleados.nombre), trim(r_pla_empleados.apellido), '' '', null, '' '', 
            r_pla_empleados.telefono_1,
            '' '', '' '', '' '', '' '', '' '', r_pla_empleados.fecha_inicio, r_pla_empleados.direccion1,
            1, null, '' '', 
            '' '', '' '', '' '', '' '', '' '', ''Panama'', ''Panama'', ''Panama'', ''Panama'', '' '',
            trim(r_pla_empleados.email), '' '', 0, 0, 0, 0, 0, 1, r_pla_empleados.fecha_nacimiento, 0,
            0, 0, '' '', r_pla_empleados.departamento);
                    
    else
        if r_pla_empleados.status = ''A'' then
            li_emp_active = 1;
        else
            li_emp_active = 0;
        end if;
        
        update hr_employee
        set emp_firstname = trim(r_pla_empleados.nombre),
            emp_lastname = Trim(r_pla_empleados.apellido),
            emp_hiredate = r_pla_empleados.fecha_inicio,
            emp_active = li_emp_active,
            emp_ssn = '' '',
            emp_pwd = null,
            emp_payroll_id = '' '',
            emp_privilege = 0,
            emp_address = '' '',
            emp_emergencyphone1 = '' '',
            emp_emergencyphone2 = '' '',
            emp_emergencyname = '' '',
            emp_emergencyaddress = '' '',
            emp_cardnumber = '' '',
            emp_country = ''Panama'',
            emp_city = ''Panama'',
            emp_state = ''Panama'',
            emp_postal = '' '',
            emp_fax = '' '',
            emp_title = '' '',
            emp_operationmode = 0,
            isselect = 0,
            middleware_id = 0,
            nationalid = '' '',
            emp_email = ''cornelioroyer@hotmail.com''
        from hr_department
        where hr_employee.department_id = hr_department.id
        and hr_department.company_id = ai_cia
        and trim(hr_employee.emp_pin) = trim(r_pla_empleados.codigo_empleado);

        li_id = r_hr_employee.id;
        
    end if;


    select into r_att_employee_zone *
    from att_employee_zone
    where employee_id = li_id
    and zone_id = r_pla_companias.att_zone_id;
    if not found then
/*
        li_id2 = 0;
        select into li_id2 Max(id) 
        from att_employee_zone;
        if li_id2 is null then
            li_id2 = 0;
        end if;
        li_id2 = li_id2 + 1;
*/

        insert into att_employee_zone(employee_id, zone_id)
            values(li_id, r_pla_companias.att_zone_id);
    end if;

    
    return 1;
end;
' language plpgsql;




commit work;
