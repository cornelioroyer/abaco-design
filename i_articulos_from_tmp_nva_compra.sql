rollback work;


begin work;
    insert into oc2 (compania, numero_oc, linea_oc, articulo,
    d_articulo, cantidad, costo, porcen_descto, descuento)
    select '02', 8, 1, codigo, descripcion, cantidad, (cantidad*cu), 0, 0
    from tmp_nva_compra;
commit work;


/*
begin work;
    insert into articulos (articulo, unidad_medida, desc_articulo,
    categoria_abc, status_articulo, servicio, valorizacion, orden_impresion, codigo_barra,
    desc_larga)
    select codigo, 'UNIDAD', descripcion,
    'A', 'A', 'N', 'P', 100, codigo, null
    from tmp_nva_compra;
commit work;
*/


/*
begin work;
    insert into articulos_por_almacen (almacen, articulo, cuenta, precio_venta,
    minimo, maximo, usuario, fecha_captura, dias_piso, existencia, costo, precio_fijo)
    select '02', codigo, '11105101', 99999, 0, 0, current_user, current_timestamp, 0, 0, 0, 'N'
    from tmp_nva_compra
    where codigo not in (select articulo from articulos_por_almacen);
commit work;
*/


