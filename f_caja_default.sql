drop function f_caja_default(char(2)) cascade;

create function f_caja_default(char(2)) returns char(3) as '
declare
    as_almacen alias for $1;
    r_fac_cajas record;
begin
    for r_fac_cajas in select * from fac_cajas where almacen = as_almacen
                        order by caja
    loop
        return r_fac_cajas.caja;
    end loop;
    
    return '''';
end;
' language plpgsql;

