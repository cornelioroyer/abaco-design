alter table tmp_empleados 
add column compania int4;

alter table tmp_descuentos
add column compania int4;

update tmp_empleados
set compania = 1265;

update tmp_descuentos
set compania = 1265;

