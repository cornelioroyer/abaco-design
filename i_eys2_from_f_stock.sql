delete from eys2 where no_transaccion = 3944 and almacen = '01';
delete from eys3 where no_transaccion = 3944 and almacen = '01';

insert into eys2 (almacen, no_transaccion, linea, articulo,
cantidad, costo)
select almacen, 3944, 1, articulo, 0, -f_stock(almacen, articulo, '2010-01-06',0,0,'COSTO')
from articulos_por_almacen
where almacen in (select almacen from almacen where compania = '01')
and f_stock(almacen, articulo, '2010-01-06',0,0,'COSTO') < 0;

insert into eys2 (almacen, no_transaccion, linea, articulo,
cantidad, costo)
select almacen, 3944, 2, articulo, -f_stock(almacen, articulo, '2010-01-06',0,0,'EXISTENCIA'), 0
from articulos_por_almacen
where almacen in (select almacen from almacen where compania = '01')
and f_stock(almacen, articulo, '2010-01-06',0,0,'EXISTENCIA') < 0;


/*
select almacen, articulo, f_stock(almacen, articulo, '2009-08-31',0,0,'COSTO'),
f_stock(almacen, articulo, '2009-08-31',0,0,'EXISTENCIA')
from articulos_por_almacen
where almacen in (select almacen from almacen where compania = '02')
and (f_stock(almacen, articulo, '2009-08-31',0,0,'COSTO') < 0
or f_stock(almacen, articulo, '2009-08-31',0,0,'EXISTENCIA') < 0)
*/