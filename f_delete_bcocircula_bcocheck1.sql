//drop trigger t_delete_bcocircula_bcocheck1 on bcocheck1;
drop trigger t_delete_bcocircula_bcotransac1 on bcotransac1;
drop function f_delete_bcocircula(char(2), char(2), int4, date );
create function f_delete_bcocircula(char(2), char(2), int4, date) returns trigger as '
begin
    delete from bcocircula
    where cod_ctabco = $1
    and motivo_bco = $2
    and no_docmto_sys = $3
    and fecha_posteo = $4;
    return old;
end;
' language plpgsql;

create trigger t_delete_bcocircula_bcotransac1 after delete on bcotransac1
for each row execute procedure f_delete_bcocircula(old.cod_ctabco, old.motivo_bco, 
old.sec_transacc, old.fecha_posteo);