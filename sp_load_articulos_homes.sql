drop function f_load_articulos_homes();
drop function f_poner_precios_homes();
drop function f_load_inventario();

create function f_poner_precios_homes() returns integer as '
declare
    r_tmp_articulos2 record;
    r_articulos record;
    ls_codigo char(50);
    ldc_precio decimal;
begin
    
    for r_tmp_articulos2 in select * from tmp_articulos2
                                order by codigo
    
    loop
        ls_codigo   =   trim(r_tmp_articulos2.casa) || ''-'' || trim(r_tmp_articulos2.codigo);
        
        if ls_codigo is null then
            ls_codigo   =   trim(r_tmp_articulos2.codigo);
        end if;
        
        if ls_codigo is null then
            ls_codigo   =   r_tmp_articulos2.oid;
        end if;
    
    
        if r_tmp_articulos2.cantidad <> 0 then
            ldc_precio  =   (r_tmp_articulos2.costo / r_tmp_articulos2.cantidad) * 4;
        else
            ldc_precio  =   0;
        end if;
        
        if ldc_precio > 0 then
            update articulos_por_almacen
            set precio_venta = ldc_precio
            where almacen = ''02''
            and trim(articulo) = trim(ls_codigo);
        end if;        
      
    end loop;
    return 1;
end;
' language plpgsql;    



create function f_load_articulos_homes() returns integer as '
declare
    r_tmp_articulos2 record;
    r_articulos record;
    ls_codigo char(50);
begin
    
    for r_tmp_articulos2 in select * from tmp_articulos2
                                order by codigo
    
    loop
        ls_codigo   =   trim(r_tmp_articulos2.casa) || ''-'' || trim(r_tmp_articulos2.codigo);
        
        if ls_codigo is null then
            ls_codigo   =   trim(r_tmp_articulos2.codigo);
        end if;
        
        if ls_codigo is null then
            ls_codigo   =   r_tmp_articulos2.oid;
        end if;
        
        select into r_articulos * from articulos
        where trim(articulo) = substring(trim(ls_codigo) from 1 for 15);
        if not found then
            
            if r_tmp_articulos2.descripcion is null then
                r_tmp_articulos2.descripcion = ''PONER NOMBRE'';
            end if;
            
            insert into articulos (articulo, unidad_medida, desc_articulo,
            categoria_abc, status_articulo, servicio, valorizacion, orden_impresion)
            values (substring(trim(ls_codigo) from 1 for 15), ''UNIDAD'', 
            trim(r_tmp_articulos2.descripcion), ''A'', ''A'', ''N'', ''P'', 100);
        end if;
      
    end loop;
    return 1;
end;
' language plpgsql;    




create function f_load_inventario() returns integer as '
declare
    r_tmp_articulos2 record;
    r_articulos record;
    r_eys2 record;
    r_articulos_por_almacen record;
    ls_codigo char(50);
begin
    
    for r_tmp_articulos2 in select * from tmp_articulos2
                                order by codigo
    
    loop
        ls_codigo   =   trim(r_tmp_articulos2.casa) || ''-'' || trim(r_tmp_articulos2.codigo);
        
        if ls_codigo is null then
            ls_codigo   =   trim(r_tmp_articulos2.codigo);
        end if;
        
        if ls_codigo is null then
            ls_codigo   =   r_tmp_articulos2.oid;
        end if;
        
        select into r_eys2 * from eys2
        where almacen = ''02''
        and no_transaccion = 6
        and trim(articulo) = substring(trim(ls_codigo) from 1 for 15);
        if not found then
            select into r_articulos_por_almacen * from articulos_por_almacen
            where almacen = ''02''
            and trim(articulo) = substring(trim(ls_codigo) from 1 for 15);
            if found then
                if r_tmp_articulos2.costo is null then
                    r_tmp_articulos2.costo = 0;
                end if;
                
                if r_tmp_articulos2.cantidad is null then
                    r_tmp_articulos2.cantidad = 0;
                end if;
                
                    insert into eys2 (almacen, no_transaccion, linea, articulo,
                    cantidad, costo)
                    values (''02'', 6, 1, substring(trim(ls_codigo) from 1 for 15), r_tmp_articulos2.cantidad,
                    r_tmp_articulos2.costo);
            end if;        
        end if;
      
    end loop;
    return 1;
end;
' language plpgsql;    

