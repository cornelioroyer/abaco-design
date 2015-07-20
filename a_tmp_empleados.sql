

rollback work;

begin work;
alter table tmp_empleados
add column compania integer;

update tmp_empleados
set compania = 1299;


alter table tmp_descuentos
add column compania integer;

update tmp_descuentos
set compania = 1299;

alter table tmp_acumulados
drop column compania;

alter table tmp_acumulados
add column compania integer;

update tmp_acumulados
set compania = 1299;

commit work;

