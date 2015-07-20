drop function f_update_cglsldoaux1(char(2), int4, int4) cascade;
drop function f_insert_aranceles_from_tmp_aranceles() cascade;

create function f_insert_aranceles_from_tmp_aranceles() returns integer as '
declare
    r_tmp_aranceles record;
    r_aranceles record;
begin
    for r_tmp_aranceles in select * from tmp_aranceles order by partida
    loop
        
        select into r_aranceles * from aranceles
        where Trim(partida) = Trim(r_tmp_aranceles.partida);
        if not found then
            insert into aranceles (partida, descripcion, arancel, itbms)
            values (r_tmp_aranceles.partida, r_tmp_aranceles.descripcion, r_tmp_aranceles.arancel,
                    r_tmp_aranceles.itbms);
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;



create function f_update_cglsldoaux1(char(2), int4, int4) returns integer as '
declare
    as_cia alias for $1;
    ai_anio alias for $2;
    ai_mes alias for $3;
    r_cglsldocuenta record;
    ldc_work decimal;    
    ldc_debito decimal;
    ldc_credito decimal;
begin
    for r_cglsldocuenta in select cglsldocuenta.*
                            from cglsldocuenta, cglcuentas
                            where cglsldocuenta.cuenta = cglcuentas.cuenta
                            and cglcuentas.auxiliar_1 = ''S''
                            and compania = as_cia
                            and year = ai_anio
                            and periodo = ai_mes
                            order by cglsldocuenta.cuenta
    loop
        delete from cglsldoaux1
        where compania = as_cia
        and year = ai_anio
        and periodo = ai_mes
        and trim(cuenta) = trim(r_cglsldocuenta.cuenta)
        and auxiliar = ''0000'';
    
        select into ldc_work sum(balance_inicio+debito-credito)
        from cglsldoaux1
        where compania = as_cia
        and year = ai_anio
        and periodo = ai_mes
        and trim(cuenta) = trim(r_cglsldocuenta.cuenta);
        
        ldc_work    =   r_cglsldocuenta.balance_inicio + r_cglsldocuenta.debito - r_cglsldocuenta.credito - ldc_work;
        if ldc_work = 0 then
            continue;
        end if;
        
        
        if ldc_work > 0 then
            ldc_debito = ldc_work;
            ldc_credito = 0;
        else
            ldc_debito = 0;
            ldc_credito = -ldc_work;
        end if;

        insert into cglsldoaux1 (compania, cuenta, auxiliar, year, periodo,
            balance_inicio, debito, credito)
        values(as_cia, r_cglsldocuenta.cuenta, ''0000'', ai_anio, ai_mes, 0, ldc_debito, ldc_credito);
    end loop;
    
    return 1;
end;
' language plpgsql;

