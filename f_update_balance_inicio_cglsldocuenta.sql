drop function f_update_balance_inicio_cglsldocuenta(char(2), int4, int4) cascade;


create function f_update_balance_inicio_cglsldocuenta(char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_anio alias for $2;
    ai_mes alias for $3;
    r_gralperiodos record;
    r_cglsldocuenta record;
    r_cglsldocuenta_work record;
    r_cglsldoaux1 record;
    r_cglsldoaux1_work record;
    ld_ultimo_cierre date;
    li_anio integer;
    li_mes integer;
    ldc_balance_inicio decimal;
begin

    update cglsldocuenta
    set balance_inicio = 0
    where compania = as_compania 
    and year = ai_anio
    and periodo = ai_mes;
    
    li_anio =   ai_anio;
    li_mes  =   ai_mes;
    
    li_mes  =   li_mes - 1;
    if li_mes = 0 then
        li_mes  =   13;
        li_anio =   li_anio - 1;
    end if;
    
    
    for r_cglsldocuenta in select * from cglsldocuenta
                                where compania = as_compania
                                and year = li_anio
                                and periodo = li_mes
                                order by cuenta
    loop
        ldc_balance_inicio  =   r_cglsldocuenta.balance_inicio + r_cglsldocuenta.debito - r_cglsldocuenta.credito;
        select into r_cglsldocuenta_work *
        from cglsldocuenta
        where compania  = as_compania
        and year = ai_anio
        and periodo = ai_mes
        and cuenta = r_cglsldocuenta.cuenta;
        if found then
            update cglsldocuenta
            set balance_inicio = ldc_balance_inicio
            where cglsldocuenta.compania = as_compania
            and cglsldocuenta.year = ai_anio
            and cglsldocuenta.periodo = ai_mes
            and cglsldocuenta.cuenta = r_cglsldocuenta.cuenta;
        else        
            insert into cglsldocuenta(compania, year, periodo, cuenta, balance_inicio, debito, credito)
            values(as_compania, ai_anio, ai_mes, r_cglsldocuenta.cuenta, ldc_balance_inicio, 0, 0);
        end if;
        

        for r_cglsldoaux1 in select * from cglsldoaux1
                                    where compania = as_compania
                                    and year = li_anio
                                    and periodo = li_mes
                                    and cuenta = r_cglsldocuenta.cuenta
                                    order by auxiliar
        loop
            ldc_balance_inicio  =   r_cglsldoaux1.balance_inicio + r_cglsldoaux1.debito - r_cglsldoaux1.credito;
            select into r_cglsldoaux1_work *
            from cglsldoaux1
            where compania  = as_compania
            and year = ai_anio
            and periodo = ai_mes
            and auxiliar = r_cglsldoaux1.auxiliar
            and cuenta = r_cglsldocuenta.cuenta;
            if found then
                update cglsldoaux1
                set balance_inicio = ldc_balance_inicio
                where compania = as_compania
                and year = ai_anio
                and periodo = ai_mes
                and auxiliar = r_cglsldoaux1.auxiliar
                and cuenta = r_cglsldocuenta.cuenta;
            else        
                insert into cglsldoaux1(compania, cuenta, auxiliar, year, periodo, balance_inicio, debito, credito)
                values(as_compania, r_cglsldocuenta.cuenta, r_cglsldoaux1.auxiliar, ai_anio, ai_mes,  ldc_balance_inicio, 0, 0);
            end if;
        end loop;
    end loop;    
        
    return 1;
end;
' language plpgsql;
