drop function f_to_char(integer);
create function f_to_char(integer) returns char(25) as '
declare
    ai_numero alias for $1;
    as_numero char(25);
begin
    as_numero := trim(to_char(ai_numero, ''99999999999999999999''));
    return as_numero;
end;
' language plpgsql;

