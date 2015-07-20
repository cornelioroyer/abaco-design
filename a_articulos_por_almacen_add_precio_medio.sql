
rollback work;

begin work;
alter table articulos_por_almacen add column precio_medio decimal(12,4);

update articulos_por_almacen
set precio_medio = 0;

alter table articulos_por_almacen alter column precio_medio set not null;
commit work;
