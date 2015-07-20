rollback work;
begin work;
    delete from invbalance
    using almacen
    where almacen.almacen = invbalance.almacen
    and almacen.compania in ('03')
    and year = 2013
    and periodo = 12;
commit work;

 
/*
begin work;
    insert into invbalance (compania, aplicacion, year, periodo, articulo, almacen, existencia, costo)
    select '03','INV',2008,5,articulo,almacen, 
    f_stock(almacen,articulo,'2008-05-31',0,0,'STOCK'),
    f_stock(almacen,articulo,'2008-05-31',0,0,'COSTO')
    from articulos_por_almacen
    where almacen in ('03');
commit work;
*/


