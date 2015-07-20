//drop trigger t_delete_bcocircula_bcocheck1 on bcocheck1;
drop trigger t_delete_bcocircula_bcotransac1 on bcotransac1;
drop function f_delete_bcocircula_bcotransac1();
create function f_delete_bcocircula_bcotransac1() returns trigger as '
begin
    delete from bcocircula
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_docmto_sys = old.sec_transacc
    and fecha_posteo = old.fecha_posteo;
    return old;
end;
' language plpgsql;

create trigger t_delete_bcocircula_bcotransac1 after delete on bcotransac1
for each row execute procedure f_delete_bcocircula_bcotransac1();
