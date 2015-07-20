create function f_inv_cierre(char(2)) returns integer as '
declare
    as_cia alias for $1;
    i integer;
    ld_fecha date;
    r_factura1 record;
    r_cos_trx record;
    r_tal_ot2 record;
    r_cos_consumo record;
    r_cos_produccion record;
    curs1 refcursor;
    ls_sql text;
begin
    select into ld_fecha Min(inicio) from gralperiodos
    where compania = as_cia
    and aplicacion = ''INV''
    and estado = ''A'';
    if not found then
        return 0;
    end if;
    
    for r_tal_ot2 in select tal_ot2.*
                        from tal_ot2, tal_ot1, almacen
                        where tal_ot1.almacen = tal_ot2.almacen
                        and tal_ot1.tipo = tal_ot2.tipo
                        and tal_ot1.no_orden = tal_ot2.no_orden
                        and tal_ot2.despachar = ''S''
                        and tal_ot2.fecha_despacho >= ld_fecha
                        and tal_ot2.almacen = almacen.almacen
                        and almacen.compania = as_cia
                        and not exists
                            (select * from tal_ot2_eys2
                                where tal_ot2_eys2.almacen = tal_ot2.almacen
                                and tal_ot2_eys2.tipo = tal_ot2.tipo
                                and tal_ot2_eys2.no_orden = tal_ot2.no_orden
                                and tal_ot2_eys2.linea_tal_ot2 = tal_ot2.linea
                                and tal_ot2_eys2.articulo = tal_ot2.articulo)
    loop                                
        i := f_tal_ot2_inventario(r_tal_ot2.almacen, r_tal_ot2.no_orden, r_tal_ot2.tipo, r_tal_ot2.linea, r_tal_ot2.articulo);
    end loop;

/*    
    for r_factura1 in select factura1.almacen, factura1.tipo, factura1.num_documento 
                        from factura1, factura2, articulos, factmotivos, almacen
                        where factura1.almacen = almacen.almacen
                        and almacen.compania = as_cia
                        and factura1.tipo = factmotivos.tipo
                        and factura1.almacen = factura2.almacen
                        and factura1.tipo = factura2.tipo
                        and factura1.num_documento = factura2.num_documento
                        and factura2.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and factmotivos.devolucion = ''S''
                        and factura1.fecha_despacho >= ld_fecha
                        and factura1.status <> ''A''
                        and factura1.fecha_despacho is not null
                        and factura1.despachar = ''S''
                        and not exists
                        (select * from factura2_eys2
                        where factura2_eys2.almacen = factura2.almacen
                        and factura2_eys2.tipo = factura2.tipo
                        and factura2_eys2.num_documento = factura2.num_documento
                        and factura2_eys2.factura2_linea = factura2.linea)
                        group by factura1.almacen, factura1.tipo, factura1.num_documento
                        order by factura1.almacen, factura1.tipo, factura1.num_documento
    loop
        i := f_factura_inventario(r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento);
    end loop;
*/    
    
    for r_factura1 in select factura1.almacen, factura1.tipo, factura1.caja, factura1.num_documento 
                        from factura1, factura2, articulos, factmotivos, almacen
                        where factura1.almacen = almacen.almacen
                        and almacen.compania = as_cia
                        and factura1.tipo = factmotivos.tipo
                        and factura1.almacen = factura2.almacen
                        and factura1.caja = factura2.caja
                        and factura1.tipo = factura2.tipo
                        and factura1.num_documento = factura2.num_documento
                        and factura2.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and (factmotivos.factura = ''S'' 
                        or factmotivos.factura_fiscal = ''S'' 
                        or factmotivos.donacion = ''S'' or factmotivos.devolucion = ''S''
                        or factmotivos.promocion = ''S'')
                        and factura1.fecha_despacho >= ld_fecha
                        and factura1.status <> ''A''
                        and factura1.fecha_despacho is not null
                        and factura1.despachar = ''S''
                        and not exists
                        (select * from factura2_eys2
                        where factura2_eys2.almacen = factura2.almacen
                        and factura2_eys2.tipo = factura2.tipo
                        and factura2_eys2.num_documento = factura2.num_documento
                        and factura2_eys2.caja = factura2.caja
                        and factura2_eys2.factura2_linea = factura2.linea)
                        group by factura1.almacen, factura1.num_documento, factura1.caja, factura1.tipo
                        order by factura1.almacen, factura1.num_documento, factura1.caja, factura1.tipo
    loop
        i := f_factura_inventario(r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento, r_factura1.caja);
    end loop;

    for r_cos_consumo in select cos_consumo.* from cos_trx, cos_consumo
                        where cos_trx.compania = cos_consumo.compania
                        and cos_trx.secuencia = cos_consumo.secuencia
                        and cos_trx.compania = as_cia
                        and cos_trx.fecha >= ld_fecha
                        and not exists
                            (select * from cos_consumo_eys2
                            where cos_consumo_eys2.compania = cos_consumo.compania
                            and cos_consumo_eys2.secuencia = cos_consumo.secuencia
                            and cos_consumo_eys2.linea = cos_consumo.linea)
                        order by cos_consumo.secuencia, cos_consumo.linea
    loop
        i = f_cos_consumo_eys2(r_cos_consumo.compania, r_cos_consumo.secuencia, r_cos_consumo.linea);
    end loop;

    
    for r_cos_produccion in select cos_produccion.* from cos_trx, cos_produccion
                        where cos_trx.compania = cos_produccion.compania
                        and cos_trx.secuencia = cos_produccion.secuencia
                        and cos_trx.compania = as_cia
                        and cos_trx.fecha >= ld_fecha
                        and not exists
                            (select * from cos_produccion_eys2
                            where cos_produccion_eys2.compania = cos_produccion.compania
                            and cos_produccion_eys2.secuencia = cos_produccion.secuencia
                            and cos_produccion_eys2.linea = cos_produccion.linea)
                        order by cos_produccion.secuencia, cos_produccion.linea
    loop
        i = f_cos_produccion_eys2(r_cos_produccion.compania, r_cos_produccion.secuencia, r_cos_produccion.linea);
    end loop;

    
/*
    for r_cos_trx in select cos_trx.* from cos_trx
                        where compania = as_cia
                        and fecha >= ld_fecha
                        order by fecha
    loop
        select into i f_costos_inventario_fifo(r_cos_trx.compania, r_cos_trx.secuencia);
    end loop;
*/
    
    return 1;
end;
' language plpgsql;


