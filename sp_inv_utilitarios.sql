drop function f_inconsistencias_eys1(char(2), int4) cascade;
create function f_inconsistencias_eys1(char(2), int4) returns decimal(12,4) as '
declare
    as_almacen alias for $1;
    ai_no_transaccion alias for $2;
    ldc_eys2 decimal(12,4);
    ldc_eys3 decimal(12,4);
begin
    ldc_eys2 = 0;
    ldc_eys3 = 0;
    select into ldc_eys2 sum(costo)
    from eys2
    where almacen = as_almacen
    and no_transaccion = ai_no_transaccion;
    
    select into ldc_eys3 sum(monto)
    from eys3
    where almacen = as_almacen
    and no_transaccion = ai_no_transaccion;
    
    if ldc_eys2 is null then
        ldc_eys2 = 0;
    end if;
    
    if ldc_eys3 is null then
        ldc_eys3 = 0;
    end if;
    
    return ldc_eys3 - ldc_eys2;
end;
' language plpgsql;
