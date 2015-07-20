//drop function f_stock(char(2), char(15), date, text);
drop function f_timestamp();
create function f_timestamp() returns timestamp as '
declare
    ls_retornar text;
    lt_retornar
begin
    ls_retornar :=  current_timestamp;
    
    ls_retornar :=  substring(ls_retornar from 1 for 19);
    
    lt_retornar :=  to_timestamp(ls_retornar, ''YYYY-MM-DD HH:MI:SS'')
    
    return lt_retornar;
end;
' language plpgsql;