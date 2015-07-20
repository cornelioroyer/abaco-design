set search_path to planilla;

-- drop function f_pla_turnos_x_dia(int4, char(7), int4, date, char(1), char(1), int4, time, time) cascade;
drop function f_pla_turnos_x_dia(int4, char(7), int4, date, char(1), char(1), varchar(20), time, time) cascade;
drop function f_pla_marcaciones_movicell(int4, char(7), date, time, time) cascade;



create function f_pla_marcaciones_movicell(int4, char(7), date, time, time) returns integer as '
declare
    ai_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ad_fecha alias for $3;
    at_entrada alias for $4;
    at_salida alias for $5;
    r_pla_empleados record;
    r_pla_marcaciones_movicell record;
    li_compania int4;
begin

    li_compania = ai_compania;
   
    if li_compania is null then
        li_compania = 1316;
    end if;

    

    select into r_pla_empleados *
    from pla_empleados
    where compania = li_compania
    and trim(codigo_empleado) = trim(ac_codigo_empleado);
    if not found then
        return 0;
    end if;
    
    select into r_pla_marcaciones_movicell *
    from pla_marcaciones_movicell
    where compania = li_compania
    and trim(codigo_empleado) = trim(ac_codigo_empleado)
    and fecha = ad_fecha
    and entrada = at_entrada
    and salida = at_salida;
    if not found then
        insert into pla_marcaciones_movicell(compania, codigo_empleado, fecha, entrada, salida)
        values(li_compania, trim(ac_codigo_empleado), ad_fecha, at_entrada, at_salida);
    else
        return 0;        
    end if;    
    
    return 1;
end;
' language plpgsql;




create function f_pla_turnos_x_dia(int4, char(7), int4, date, char(1), char(1), varchar(20), time, time) returns int4 as '
declare
    ai_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ai_turno alias for $3;
    ad_fecha alias for $4;
    ac_status alias for $5;
    ac_autorizado alias for $6;
    avc_proyecto alias for $7;
    at_entrada alias for $8;
    at_salida alias for $9;
    r_pla_turnos_x_dia record;
    r_pla_empleados record;
    r_pla_turnos record;
    r_pla_proyectos record;
    r_pla_horarios record;
    li_retorno int4;
    li_turno int4;
    li_dow integer;
    lt_entrada time;
    lt_salida time;
    lc_status char(1);
begin
    li_turno    =   ai_turno;
    lt_entrada  =   at_entrada;
    lt_salida   =   at_salida;
    li_dow      =   Extract(dow from ad_fecha);
    lc_status   =   ac_status;
    
    if lc_status is null then
        lc_status = ''R'';
    end if;
    
    if lt_entrada > lt_salida then
        lt_salida   =   lt_salida + interval ''12 hours'';
    end if;
    
    select into r_pla_empleados *
    from pla_empleados
    where compania = ai_compania
    and codigo_empleado = ac_codigo_empleado;
    if not found then
        Raise Exception ''Codigo de Empleado % no existe'',ac_codigo_empleado;
    end if;


    if li_turno is null or li_turno = 0 then
        select into r_pla_horarios *
        from pla_horarios
        where compania = ai_compania
        and codigo_empleado = ac_codigo_empleado
        and dia = li_dow;
        if not found then
            select Min(turno) into li_turno
            from pla_turnos
            where compania = ai_compania;
        else
            li_turno    =   r_pla_horarios.turno;            
        end if;
    end if;        


    select into r_pla_turnos *
    from pla_turnos
    where compania = ai_compania
    and turno = li_turno;
    if not found then
        Raise Exception ''Codigo de Turno % no existe'', ai_turno;
    end if;


    select into r_pla_proyectos *
    from pla_proyectos
    where compania = ai_compania
    and trim(proyecto) = trim(avc_proyecto);
    if not found then
        select into r_pla_proyectos *
        from pla_proyectos
        where compania = ai_compania
        and id = r_pla_empleados.id_pla_proyectos;
    end if;


    
    select into r_pla_turnos_x_dia *
    from pla_turnos_x_dia
    where compania = ai_compania
    and codigo_empleado = ac_codigo_empleado
    and fecha = ad_fecha;
    if not found then
        insert into pla_turnos_x_dia(compania, codigo_empleado, turno, fecha, status, autorizado, id_pla_proyectos, entrada, salida)
        values (ai_compania, ac_codigo_empleado, li_turno, ad_fecha, lc_status, ac_autorizado, r_pla_proyectos.id, lt_entrada, lt_salida);
    else
--        insert into pla_turnos_x_dia(compania, codigo_empleado, turno, fecha, status, autorizado, id_pla_proyectos, entrada, salida)
--        values (ai_compania, ac_codigo_empleado, li_turno, ad_fecha, ac_status, ac_autorizado, r_pla_proyectos.id, lt_entrada, lt_salida);
        return 0;
    end if; 
    
    return 1;
end;
' language plpgsql;


