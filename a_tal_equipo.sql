alter table tal_equipo
add column inventario char(1);

update tal_equipo
set inventario = 'N';

alter table tal_equipo
alter column inventario set not null;
