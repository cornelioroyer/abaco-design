
begin work;
alter table articulos_por_almacen add column precio_minimo decimal(12,4);
update articulos_por_almacen
set precio_minimo = 0;
alter table articulos_por_almacen alter column precio_minimo set not null;
commit work;
