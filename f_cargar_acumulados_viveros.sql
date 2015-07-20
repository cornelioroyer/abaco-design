
drop function f_cargar_acumulados_viveros();
drop function f_cargar_acumulados_viveros_constructora() cascade;


create function f_cargar_acumulados_viveros_constructora() returns integer as '
declare
    ai_compania integer;
    r_pla_preelaboradas record;
    r_pla_empleados record;
    r_tmp_acumulados record;
    r_tmp_tipos_de_ingreso record;
    r_tmp_empleados_viveros record;
    ld_fecha date;
    lc_codigo_empleado char(7);
    lc_concepto_pp char(3);
begin
    ai_compania = 1240;

/*
    delete from pla_preelaboradas
    where compania = ai_compania;
*/    

    for r_tmp_acumulados in select * from tmp_acumulados
                                where cia = 5
                                and tipo = ''T''
                                and empleado <> 209
                                order by anio, mes
    loop

        ld_fecha            = f_to_date(r_tmp_acumulados.anio, r_tmp_acumulados.mes, 1);

        
        select into r_tmp_empleados_viveros *
        from tmp_empleados_viveros
        where cia = r_tmp_acumulados.cia
        and numero = r_tmp_acumulados.empleado;
        if not found then
            continue;
        end if;


  
        select into r_pla_empleados *
        from pla_empleados
        where compania = ai_compania
        and trim(cedula) = trim(r_tmp_empleados_viveros.cedula);
        if not found then
            continue;
        end if;


        
        select into r_tmp_tipos_de_ingreso * from tmp_tipos_de_ingreso
        where concepto = r_tmp_acumulados.concepto;
        if not found then
            continue;
        end if;

        lc_concepto_pp      =   r_tmp_tipos_de_ingreso.concepto_pp;
        lc_codigo_empleado  = r_pla_empleados.codigo_empleado;

        
        select into r_pla_preelaboradas *
        from pla_preelaboradas
        where compania = ai_compania
        and codigo_empleado = lc_codigo_empleado
        and fecha = ld_fecha
        and concepto = lc_concepto_pp;
        if not found then
            insert into pla_preelaboradas(compania, codigo_empleado,
                concepto, fecha, monto)
            values(ai_compania, lc_codigo_empleado, lc_concepto_pp, ld_fecha, r_tmp_acumulados.monto);
        else
            update pla_preelaboradas
            set monto = monto + r_tmp_acumulados.monto
            where compania = ai_compania
            and codigo_empleado = lc_codigo_empleado
            and fecha = ld_fecha
            and concepto = lc_concepto_pp;
        end if;
        
    end loop;
    

    for r_tmp_acumulados in select * from tmp_acumulados
                                where cia = 5
                                and tipo = ''P''
                                and concepto = 3
                                order by anio, mes
    loop

        ld_fecha            = f_to_date(r_tmp_acumulados.anio, r_tmp_acumulados.mes, 1);

        select into r_tmp_empleados_viveros *
        from tmp_empleados_viveros
        where cia = r_tmp_acumulados.cia
        and numero = r_tmp_acumulados.empleado;
        if not found then
            continue;
        end if;
  
        select into r_pla_empleados *
        from pla_empleados
        where compania = ai_compania
        and trim(cedula) = trim(r_tmp_empleados_viveros.cedula);
        if not found then
            continue;
        end if;

        lc_codigo_empleado  = r_pla_empleados.codigo_empleado;

        lc_concepto_pp      =   ''106'';

        
        select into r_pla_preelaboradas *
        from pla_preelaboradas
        where compania = ai_compania
        and codigo_empleado = lc_codigo_empleado
        and fecha = ld_fecha
        and concepto = lc_concepto_pp;
        if not found then
            insert into pla_preelaboradas(compania, codigo_empleado,
                concepto, fecha, monto)
            values(ai_compania, lc_codigo_empleado, lc_concepto_pp, ld_fecha, r_tmp_acumulados.monto);
        else
            update pla_preelaboradas
            set monto = monto + r_tmp_acumulados.monto
            where compania = ai_compania
            and codigo_empleado = lc_codigo_empleado
            and fecha = ld_fecha
            and concepto = lc_concepto_pp;
        end if;
        
    end loop;
    
    return 1;
end;
' language plpgsql;


create function f_cargar_acumulados_viveros() returns integer as '
declare
    ai_compania integer;
    r_pla_preelaboradas record;
    r_pla_empleados record;
    r_tmp_acumulados record;
    r_tmp_tipos_de_ingreso record;
    ld_fecha date;
    lc_codigo_empleado char(7);
    lc_concepto_pp char(3);
begin
    ai_compania = 1240;

    delete from pla_preelaboradas
    where compania = ai_compania;

    for r_tmp_acumulados in select * from tmp_acumulados
                                where cia = ai_compania
                                and tipo = ''T''
                                order by anio, mes
    loop

        ld_fecha            = f_to_date(r_tmp_acumulados.anio, r_tmp_acumulados.mes, 1);
        lc_codigo_empleado  = trim(to_char(r_tmp_acumulados.empleado, ''99999999''));

        
        select into r_tmp_tipos_de_ingreso * from tmp_tipos_de_ingreso
        where concepto = r_tmp_acumulados.concepto;
        if not found then
            continue;
        end if;

        lc_concepto_pp      =   r_tmp_tipos_de_ingreso.concepto_pp;

        select into r_pla_empleados *
        from pla_empleados
        where compania = ai_compania
        and trim(codigo_empleado) = trim(lc_codigo_empleado);
        if not found then
            continue;
        end if;

        
        select into r_pla_preelaboradas *
        from pla_preelaboradas
        where compania = ai_compania
        and codigo_empleado = lc_codigo_empleado
        and fecha = ld_fecha
        and concepto = lc_concepto_pp;
        if not found then
            insert into pla_preelaboradas(compania, codigo_empleado,
                concepto, fecha, monto)
            values(ai_compania, lc_codigo_empleado, lc_concepto_pp, ld_fecha, r_tmp_acumulados.monto);
        else
            update pla_preelaboradas
            set monto = monto + r_tmp_acumulados.monto
            where compania = ai_compania
            and codigo_empleado = lc_codigo_empleado
            and fecha = ld_fecha
            and concepto = lc_concepto_pp;
        end if;
        
    end loop;
    

    for r_tmp_acumulados in select * from tmp_acumulados
                                where cia = ai_compania
                                and tipo = ''P''
                                and concepto = 3
                                order by anio, mes
    loop

        ld_fecha            = f_to_date(r_tmp_acumulados.anio, r_tmp_acumulados.mes, 1);
        lc_codigo_empleado  = trim(to_char(r_tmp_acumulados.empleado, ''99999999''));

        lc_concepto_pp      =   ''106'';

        select into r_pla_empleados *
        from pla_empleados
        where compania = ai_compania
        and trim(codigo_empleado) = trim(lc_codigo_empleado);
        if not found then
            continue;
        end if;

        
        select into r_pla_preelaboradas *
        from pla_preelaboradas
        where compania = ai_compania
        and codigo_empleado = lc_codigo_empleado
        and fecha = ld_fecha
        and concepto = lc_concepto_pp;
        if not found then
            insert into pla_preelaboradas(compania, codigo_empleado,
                concepto, fecha, monto)
            values(ai_compania, lc_codigo_empleado, lc_concepto_pp, ld_fecha, r_tmp_acumulados.monto);
        else
            update pla_preelaboradas
            set monto = monto + r_tmp_acumulados.monto
            where compania = ai_compania
            and codigo_empleado = lc_codigo_empleado
            and fecha = ld_fecha
            and concepto = lc_concepto_pp;
        end if;
        
    end loop;
    
    return 1;
end;
' language plpgsql;



