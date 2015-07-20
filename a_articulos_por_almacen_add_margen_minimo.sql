

rollback work;

begin work;

alter table articulos_por_almacen
add column margen_minimo decimal(12,4);

update articulos_por_almacen
set margen_minimo = 0;

alter table articulos_por_almacen
alter column margen_minimo set not null;

commit work;

