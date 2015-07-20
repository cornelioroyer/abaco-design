
drop function f_matame(timestamp) cascade;

create function f_matame(timestamp) returns integer as '
declare
    ats_fecha alias for $1;
    ld_fecha date;
    lt_hora time;
begin

    ld_fecha    =   ats_fecha;
    lt_hora     =   ats_fecha;
    
    raise exception ''% %'', ld_fecha, lt_hora;
    
    return 1;
end;
' language plpgsql;
