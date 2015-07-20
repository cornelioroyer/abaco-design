drop function f_to_date(timestamp with time zone) cascade;


CREATE FUNCTION f_to_date(timestamp with time zone) RETURNS date
    AS '
declare
    ats_fecha_hora alias for $1;
    li_y integer;
    li_m integer;
    li_d integer;
    ls_fecha char(10);
begin
    li_y    =   Extract(year from ats_fecha_hora);
    li_m    =   Extract(month from ats_fecha_hora);
    li_d    =   Extract(day from ats_fecha_hora);
    ls_fecha = trim(to_char(li_y,''9999'')) || ''/'' || trim(to_char(li_m,''09'')) || ''/'' || trim(to_char(li_d,''09''));
    return to_date(ls_fecha, ''YYYY/MM/DD'');
end;
' LANGUAGE plpgsql;

