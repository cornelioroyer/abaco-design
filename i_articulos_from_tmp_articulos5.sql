
rollback work;

begin work;
    insert into articulos (articulo, unidad_medida, desc_articulo,
    categoria_abc, status_articulo, servicio, valorizacion, orden_impresion)
    select substring(trim(codigo) from 1 for 15), 'UNIDAD', descripcion,
    'A', 'A', 'N', 'P', 100
    from tmp_articulos5
    where codigo is not null 
    and not exists
    (select * from articulos
    where trim(articulos.articulo) = substring(trim(tmp_articulos5.codigo) from 1 for 15));
commit work;



/*
begin work;
    delete from articulos_por_almacen;
    delete from articulos;
commit work;

begin work;
    insert into articulos (articulo, unidad_medida, desc_articulo,
    categoria_abc, status_articulo, servicio, valorizacion, orden_impresion)
    select substring(trim(articulo) from 1 for 15), 'UNIDAD', descripcion,
    'A', 'A', 'N', 'P', 100
    from tmp_articulos
    where articulo is not null 
    and not exists
    (select * from articulos
    where articulos.articulo = tmp_articulos.articulo);
commit work;
*/

/*
begin work;
    delete from articulos_por_almacen;
commit work;
*/

begin work;
    insert into articulos_por_almacen (almacen, articulo, 
    cuenta, precio_venta,
    minimo, maximo, usuario, fecha_captura, dias_piso, existencia, 
    costo, precio_fijo)
    select '04', substring(trim(articulo) from 1 for 15), '1', 
    999999, 0, 0, 'dba', current_timestamp, 0, 0, 0, 'N'
    from tmp_articulos
    where articulo is not null 
    and not exists
    (select * from articulos_por_almacen
    where articulos_por_almacen.articulo = tmp_articulos.articulo);
commit work;