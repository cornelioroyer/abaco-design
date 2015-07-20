

alter table tmp_acumulados
drop column compania;

alter table tmp_acumulados
add column compania integer;

update tmp_acumulados
set compania = 1286;

begin work;
    select f_cargar_tmp_acumulados(1286);
commit work;
