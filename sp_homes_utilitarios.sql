
drop function f_load_articulos_homes() cascade;
drop function f_load_nva_compra() cascade;


create function f_load_articulos_homes() returns integer as '
declare
    r_tmp_articulos6 record;
    r_articulos record;
    ls_codigo char(15);
begin
    delete from eys2 where almacen = ''02'' and no_transaccion = 18;
    
    for r_tmp_articulos6 in select tmp_articulos6.* from tmp_articulos6
                                where codigo is not null
                                order by codigo
    loop

        ls_codigo = substring(trim(r_tmp_articulos6.codigo) from 1 for 15);

        select into r_articulos * from articulos
        where trim(articulo) = trim(ls_codigo);
        if not found then
            insert into articulos (articulo, unidad_medida, desc_articulo,
            categoria_abc, status_articulo, servicio, valorizacion, orden_impresion)
            values (ls_codigo, ''UNIDAD'', r_tmp_articulos6.descripcion,
                ''A'', ''A'', ''N'', ''P'', 100);
        end if;
        
        insert into eys2(almacen, no_transaccion, linea, articulo, cantidad, costo)
        values(''02'', 18, 1, trim(ls_codigo), r_tmp_articulos6.cantidad, (r_tmp_articulos6.cantidad*r_tmp_articulos6.cu));    
        
        update articulos_por_almacen
        set precio_venta = r_tmp_articulos6.precio
        where almacen = ''02''
        and trim(articulo) = trim(ls_codigo);
    end loop;
    
    
    return 1;
end;
' language plpgsql;


create function f_load_nva_compra() returns integer as '
declare
    r_tmp_nva_compra record;
    r_articulos record;
    r_oc1 record;
    ls_proveedor char(6);
    ls_codigo char(15);
begin
    delete from oc2 where compania = ''02'' 
    and exists
        (select * from oc1
        where oc1.compania = oc2.compania
        and oc1.numero_oc = oc2.numero_oc
        and oc1.fecha = ''2009-10-15'');
        
    delete from oc3 where compania = ''02'' 
    and exists
        (select * from oc1
        where oc1.compania = oc3.compania
        and oc1.numero_oc = oc3.numero_oc
        and oc1.fecha = ''2009-10-15'');
        
    delete from oc4 where compania = ''02'' 
    and exists
        (select * from oc1
        where oc1.compania = oc4.compania
        and oc1.numero_oc = oc4.numero_oc
        and oc1.fecha = ''2009-10-15'');
    
    for r_tmp_nva_compra in select tmp_nva_compra.* from tmp_nva_compra
                                where codigo is not null
                                order by codigo
    loop

        ls_codigo = substring(trim(r_tmp_nva_compra.codigo) from 1 for 15);

        select into r_articulos * from articulos
        where trim(articulo) = trim(ls_codigo);
        if not found then
            insert into articulos (articulo, unidad_medida, desc_articulo,
            categoria_abc, status_articulo, servicio, valorizacion, orden_impresion)
            values (ls_codigo, ''UNIDAD'', r_tmp_nva_compra.descripcion,
                ''A'', ''A'', ''N'', ''P'', 100);
        end if;
        
        
        update articulos_por_almacen
        set precio_venta = r_tmp_nva_compra.precio
        where almacen = ''02''
        and articulo = ls_codigo;
        
        ls_proveedor = substring(trim(r_tmp_nva_compra.codigo) from 1 for 2);
        
        select into r_oc1 *
        from oc1
        where compania = ''02''
        and proveedor = ls_proveedor
        and fecha = ''2009-10-15'';
        if found then
            insert into oc2 (compania, numero_oc, linea_oc, articulo,
                d_articulo, cantidad, costo, porcen_descto, descuento)
            values(''02'', r_oc1.numero_oc, 1, ls_codigo, r_tmp_nva_compra.descripcion, 
                r_tmp_nva_compra.cantidad, (r_tmp_nva_compra.cantidad*r_tmp_nva_compra.cu), 0, 0);
        else
            raise exception ''no existe'';
        end if;                
    end loop;
    
    
    return 1;
end;
' language plpgsql;