drop function f_cerrar_cgl(char(2),int4, int4) cascade;


create function f_cerrar_cgl(char(2),int4, int4) returns integer as '
declare
    as_cia alias for $1;
    ai_anio alias for $2;
    ai_mes alias for $3;
    r_work record;
    r_gralperiodos record;
    r_bcobalance record;
    r_cglsldocuenta record;
    r_cglsldoaux1 record;
    r_cglsldoaux2 record;
    ldc_balance_inicial decimal;
    ldc_debito decimal;
    ldc_credito decimal;
    ldc_balance_inicio decimal;
    li_next_anio integer;
    li_next_mes integer;
begin
    li_next_anio    = ai_anio;
    li_next_mes     = ai_mes + 1;
    
    if ai_mes > 13 then
        li_next_anio    =   li_next_anio + 1;
        li_next_mes     =   1;
    end if;

    select into r_gralperiodos *
    from gralperiodos
    where compania = as_cia
    and aplicacion = ''CGL''
    and year = ai_anio
    and periodo = ai_mes;
    if not found then
        Raise Exception ''No existe Anio % y Mes % en Mayor General'',ai_anio, ai_mes;
    end if;
    
    if r_gralperiodos.estado <> ''A'' then
        return 0;
    end if;
    
    update cglsldocuenta
    set balance_inicio = 0
    where compania = as_cia
    and year = li_next_anio
    and periodo = li_next_mes;
    
    update cglsldoaux1
    set balance_inicio = 0
    where compania = as_cia
    and year = li_next_anio
    and periodo = li_next_mes;

    update cglsldoaux2
    set balance_inicio = 0
    where compania = as_cia
    and year = li_next_anio
    and periodo = li_next_mes;
    


    for r_cglsldocuenta in select * from cglsldocuenta
                            where compania = as_cia
                            and year = ai_anio
                            and periodo = ai_mes
                            order by cuenta
    loop
        ldc_balance_inicio  =   r_cglsldocuenta.balance_inicio + r_cglsldocuenta.debito - r_cglsldocuenta.credito;

        select into r_work *
        from cglsldocuenta
        where as_cia = as_cia
        and year = li_next_anio
        and periodo = li_next_mes
        and trim(cuenta) = trim(r_cglsldocuenta.cuenta);
        if found then
            update cglsldocuenta
            set balance_inicio = ldc_balance_inicio
            where as_cia = as_cia
            and year = li_next_anio
            and periodo = li_next_mes
            and trim(cuenta) = trim(r_cglsldocuenta.cuenta);
        else
            insert into cglsldocuenta(compania, year, periodo, cuenta, balance_inicio, debito, credito)
            values(as_cia, li_next_anio, li_next_mes, r_cglsldocuenta.cuenta, ldc_balance_inicio, 0, 0);
        end if;

        for r_cglsldoaux1 in select * from cglsldoaux1
                                where compania = as_cia
                                and year = ai_anio
                                and periodo = ai_mes
                                and cuenta = r_cglsldocuenta.cuenta
                                order by auxiliar
        loop
            ldc_balance_inicio  =   r_cglsldoaux1.balance_inicio + r_cglsldoaux1.debito - r_cglsldoaux1.credito;
    
            select into r_work *
            from cglsldoaux1
            where as_cia = as_cia
            and year = li_next_anio
            and periodo = li_next_mes
            and trim(cuenta) = trim(r_cglsldocuenta.cuenta)
            and trim(auxiliar) = trim(r_cglsldoaux1.auxiliar);
            if found then
                update cglsldoaux1
                set balance_inicio = ldc_balance_inicio
                where as_cia = as_cia
                and year = li_next_anio
                and periodo = li_next_mes
                and trim(cuenta) = trim(r_cglsldocuenta.cuenta)
                and trim(auxiliar) = trim(r_cglsldoaux1.auxiliar);
            else
                insert into cglsldoaux1(compania, year, periodo, cuenta, auxiliar, balance_inicio, debito, credito)
                values(as_cia, li_next_anio, li_next_mes, r_cglsldocuenta.cuenta, r_cglsldoaux1.auxiliar, 
                    ldc_balance_inicio, 0, 0);
            end if;
        end loop;
        
        for r_cglsldoaux2 in select * from cglsldoaux2
                                where compania = as_cia
                                and year = ai_anio
                                and periodo = ai_mes
                                and cuenta = r_cglsldocuenta.cuenta
                                order by auxiliar
        loop
            ldc_balance_inicio  =   r_cglsldoaux2.balance_inicio + r_cglsldoaux2.debito - r_cglsldoaux2.credito;
    
            select into r_work *
            from cglsldoaux2
            where as_cia = as_cia
            and year = li_next_anio
            and periodo = li_next_mes
            and trim(cuenta) = trim(r_cglsldocuenta.cuenta)
            and trim(auxiliar) = trim(r_cglsldoaux2.auxiliar);
            if found then
                update cglsldoaux2
                set balance_inicio = ldc_balance_inicio
                where as_cia = as_cia
                and year = li_next_anio
                and periodo = li_next_mes
                and trim(cuenta) = trim(r_cglsldocuenta.cuenta)
                and trim(auxiliar) = trim(r_cglsldoaux2.auxiliar);
            else
                insert into cglsldoaux2(compania, year, periodo, cuenta, auxiliar, balance_inicio, debito, credito)
                values(as_cia, li_next_anio, li_next_mes, r_cglsldocuenta.cuenta, r_cglsldoaux2.auxiliar, 
                    ldc_balance_inicio, 0, 0);
            end if;
        end loop;
        
    end loop;
    
    return f_cerrar_aplicacion(as_cia, ''CGL'', ai_anio, ai_mes);
end;
' language plpgsql;    


