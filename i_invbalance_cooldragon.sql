
begin work;
delete from invbalance
where compania = '02'
and year = 2008
and periodo >= 10;
commit work;

begin work;
    insert into invbalance (compania, aplicacion, year, periodo, articulo, almacen, existencia, costo)
    select almacen.compania,'INV',2008,10,articulo,almacen.almacen,
    f_stock(almacen.almacen, articulo,'2008-10-31',0,0,'EXISTENCIA'),
    f_stock(almacen.almacen, articulo,'2008-10-31',0,0,'COSTO')
    from articulos_por_almacen, almacen
    where almacen.almacen = articulos_por_almacen.almacen;
commit work;

begin work;
    insert into invbalance (compania, aplicacion, year, periodo, articulo, almacen, existencia, costo)
    select almacen.compania,'INV',2008,11,articulo,almacen.almacen,
    f_stock(almacen.almacen, articulo,'2008-11-30',0,0,'EXISTENCIA'),
    f_stock(almacen.almacen, articulo,'2008-11-30',0,0,'COSTO')
    from articulos_por_almacen, almacen
    where almacen.almacen = articulos_por_almacen.almacen;
commit work;

begin work;
    insert into invbalance (compania, aplicacion, year, periodo, articulo, almacen, existencia, costo)
    select almacen.compania,'INV',2008,12,articulo,almacen.almacen,
    f_stock(almacen.almacen, articulo,'2008-12-31',0,0,'EXISTENCIA'),
    f_stock(almacen.almacen, articulo,'2008-12-31',0,0,'COSTO')
    from articulos_por_almacen, almacen
    where almacen.almacen = articulos_por_almacen.almacen;
commit work;


