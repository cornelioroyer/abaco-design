drop function f_i_articulos_from_tmp_articulos();
drop function f_i_gral_valor_grupos() cascade;

create function f_i_gral_valor_grupos() returns integer as '
declare
    r_tmp_clases record;
    r_tmp_lineas record;
    r_gral_valor_grupos record;
begin
    delete from gral_valor_grupos where grupo in (''CLA'');
    
    for r_tmp_clases in select * from tmp_clases
    loop
        select into r_gral_valor_grupos *
        from gral_valor_grupos
        where codigo_valor_grupo = r_tmp_clases.clase;
        if not found then
            insert into gral_valor_grupos(grupo, aplicacion,
                codigo_valor_grupo, gra_codigo_valor_grupo,
                desc_valor_grupo, status)
            values(''CLA'', ''INV'', r_tmp_clases.clase,
                r_tmp_clases.categoria, r_tmp_clases.descripcion, ''A'');
        end if;
    end loop;
    
    for r_tmp_lineas in select * from tmp_lineas
    loop
        select into r_gral_valor_grupos *
        from gral_valor_grupos
        where codigo_valor_grupo = r_tmp_lineas.linea;
        if not found then
            insert into gral_valor_grupos(grupo, aplicacion,
                codigo_valor_grupo, gra_codigo_valor_grupo,
                desc_valor_grupo, status)
            values(''LIN'', ''INV'', r_tmp_lineas.linea,
                r_tmp_lineas.categoria, r_tmp_lineas.descripcion1, ''A'');
        end if;
    end loop;
    return 1;
end;
' language plpgsql;


create function f_i_articulos_from_tmp_articulos() returns integer as '
declare
    r_tmp_articulos record;
    r_tmp_unidades_medida record;
    r_articulos record;
    r_gral_valor_grupos record;
    r_articulos_agrupados record;
    ls_unidad_medida char(10);
    ls_desc_articulo char(90);
begin
    delete from articulos_por_almacen;
    delete from articulos;
    for r_tmp_articulos in select * from tmp_articulos order by codigo
    loop
        if r_tmp_articulos.descripcion is null then
            ls_desc_articulo = ''PONER NOMBRE'';
        else
            ls_desc_articulo = trim(r_tmp_articulos.descripcion);
        end if;
        select into r_tmp_unidades_medida *
        from tmp_unidades_medida
        where codigo = r_tmp_articulos.unidad_medida;
        if not found then
            ls_unidad_medida = ''UNIDAD'';
        else
            ls_unidad_medida = r_tmp_unidades_medida.unidad_medida;
        end if;
        
        select into r_articulos *
        from articulos
        where trim(articulo) = trim(r_tmp_articulos.codigo);
        if not found then
            insert into articulos (articulo, unidad_medida, desc_articulo,
            status_articulo, servicio, valorizacion, orden_impresion)
            values( trim(r_tmp_articulos.codigo), ls_unidad_medida,
            ls_desc_articulo, ''A'', ''N'', ''P'', 100);

                      
            insert into articulos_agrupados (articulo, codigo_valor_grupo)
            values(trim(r_tmp_articulos.codigo), ''SI'');

            insert into articulos_agrupados (articulo, codigo_valor_grupo)
            values(trim(r_tmp_articulos.codigo), ''99'');

            select into r_gral_valor_grupos *
            from gral_valor_grupos
            where codigo_valor_grupo = r_tmp_articulos.categoria;
            if found then
                select into r_articulos_agrupados *
                from articulos_agrupados
                where trim(articulo) = trim(r_tmp_articulos.codigo)
                and trim(codigo_valor_grupo) = trim(r_tmp_articulos.categoria);
                if not found then
                    insert into articulos_agrupados (articulo, codigo_valor_grupo)
                    values(trim(r_tmp_articulos.codigo), trim(r_tmp_articulos.categoria));
                end if;
            end if;

            select into r_gral_valor_grupos *
            from gral_valor_grupos
            where codigo_valor_grupo = r_tmp_articulos.clase;
            if found then
                select into r_articulos_agrupados *
                from articulos_agrupados
                where trim(articulo) = trim(r_tmp_articulos.codigo)
                and trim(codigo_valor_grupo) = trim(r_tmp_articulos.clase);
                if not found then
                    insert into articulos_agrupados (articulo, codigo_valor_grupo)
                    values(trim(r_tmp_articulos.codigo), trim(r_tmp_articulos.clase));
                end if;                    
            end if;
            
            select into r_gral_valor_grupos *
            from gral_valor_grupos
            where codigo_valor_grupo = r_tmp_articulos.linea;
            if found then
                select into r_articulos_agrupados *
                from articulos_agrupados
                where trim(articulo) = trim(r_tmp_articulos.codigo)
                and codigo_valor_grupo = r_tmp_articulos.linea;
                if not found then
                    insert into articulos_agrupados (articulo, codigo_valor_grupo)
                    values(trim(r_tmp_articulos.codigo), r_tmp_articulos.linea);
                end if;
            end if;
            
            insert into articulos_por_almacen (almacen, articulo, cuenta, 
            precio_venta,
            minimo, maximo, usuario, fecha_captura, dias_piso, existencia, 
            costo, precio_fijo) 
            values (''01'',trim(r_tmp_articulos.codigo),''1101000'',
            r_tmp_articulos.precio1,0,0,current_user,current_timestamp,1,0,0,''N'');
            
        end if;
    end loop;        
    
    return 1;
end;
' language plpgsql;
