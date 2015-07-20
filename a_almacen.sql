rollback work;
begin work;
alter table almacen
rename column desc_almacen to desc_almacen_old;

alter table almacen
rename column direccion1_almacen to direccion1_almacen_old;

alter table almacen
rename column direccion2_almacen to direccion2_almacen_old;


alter table almacen 
add column desc_almacen text;

alter table almacen
add column direccion1_almacen text;

alter table almacen
add column direccion2_almacen text;

update almacen
set desc_almacen = desc_almacen_old, direccion1_almacen = direccion1_almacen_old,
direccion2_almacen = direccion2_almacen_old;

alter table almacen
drop column desc_almacen_old cascade;

alter table almacen
drop column direccion1_almacen_old;

alter table almacen
drop column direccion2_almacen_old;

commit work;