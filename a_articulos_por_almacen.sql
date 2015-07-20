alter table articulos_por_almacen
add column existencia decimal(12,4);

alter table articulos_por_almacen
add column costo decimal(12,4);

update articulos_por_almacen
set existencia = 0, costo = 0;

alter table articulos_por_almacen
alter column existencia set not null;

alter table articulos_por_almacen
alter column costo set not null;