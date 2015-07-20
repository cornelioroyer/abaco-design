
begin work;
    delete from eys2 where no_transaccion = 2;
    delete from eys3 where no_transaccion = 2;
commit work;

begin work;
    insert into eys2 (almacen, no_transaccion, linea, articulo,
    cantidad, costo)
    select '02', 2, 1, substring(trim(articulo) from 1 for 15), existencia, costo
    from tmp_articulos
    where existencia > 0;
commit work;

