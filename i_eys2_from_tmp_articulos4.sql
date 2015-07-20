
begin work;
    delete from eys2 where no_transaccion = 3;
    delete from eys3 where no_transaccion = 3;
commit work;

begin work;
    insert into eys2 (almacen, no_transaccion, linea, articulo,
    cantidad, costo)
    select '02', 3, 1, substring(trim(codigo) from 1 for 15), cantidad, (cantidad*cu)
    from tmp_articulos4
    where codigo is not null;
commit work;

