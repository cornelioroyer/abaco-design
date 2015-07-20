
drop function f_bitacora(text, text, integer, text, text, text) cascade;

create function f_bitacora(text, text, integer, text, text, text) returns integer as '
declare
    ac_operacion alias for $1;
    at_tabla alias for $2;
    ai_id_tabla alias for $3;
    at_old_dato alias for $4;
    at_new_dato alias for $5;
    at_sentencia_sql alias for $6;
begin
    
    insert into bitacora(operacion, tabla, id_tabla, fecha_hora,
        usuario, old_dato, new_dato, sentencia_sql) 
    values (trim(ac_operacion), trim(at_tabla), ai_id_tabla, current_timestamp,
        current_user, at_old_dato, at_new_dato, at_sentencia_sql);

    return 1;
end;
' language plpgsql;
