drop function f_precio_harinas(char(2),char(15), char(10),date) cascade;
drop function f_precio_hd(char(2),char(15), date) cascade;
drop function f_precio_hs(char(2),char(15), date) cascade;


create function f_precio_hs(char(2),char(15), date)returns decimal as '
declare
    as_almacen alias for $1;
    as_cliente alias for $2;
    ad_fecha alias for $3;
    ldc_precio decimal;
begin
    ldc_precio = f_precio_harinas(as_almacen, ''02'', as_cliente, ad_fecha);
    if ldc_precio > 0 then
        return ldc_precio;
    end if;
    
    ldc_precio = f_precio_harinas(as_almacen, ''12'', as_cliente, ad_fecha);
    if ldc_precio > 0 then
        return ldc_precio*2;
    end if;
    
    ldc_precio = f_precio_harinas(as_almacen, ''22'', as_cliente, ad_fecha);
    if ldc_precio > 0 then
        return ldc_precio*4;
    end if;
    
    ldc_precio = f_precio_harinas(as_almacen, ''04'', as_cliente, ad_fecha);
    if ldc_precio > 0 then
        return ldc_precio;
    end if;
    
    ldc_precio = f_precio_harinas(as_almacen, ''05'', as_cliente, ad_fecha);
    if ldc_precio > 0 then
        return ldc_precio;
    end if;
    
    
    return 0;
end;
' language plpgsql;    



create function f_precio_hd(char(2),char(15), date)returns decimal as '
declare
    as_almacen alias for $1;
    as_cliente alias for $2;
    ad_fecha alias for $3;
    ldc_precio decimal;
begin
    ldc_precio = f_precio_harinas(as_almacen, ''01'', as_cliente, ad_fecha);
    if ldc_precio > 0 then
        return ldc_precio;
    end if;
    
    ldc_precio = f_precio_harinas(as_almacen, ''11'', as_cliente, ad_fecha);
    if ldc_precio > 0 then
        return ldc_precio*2;
    end if;
    
    ldc_precio = f_precio_harinas(as_almacen, ''21'', as_cliente, ad_fecha);
    if ldc_precio > 0 then
        return ldc_precio*4;
    end if;
    
    ldc_precio = f_precio_harinas(as_almacen, ''03'', as_cliente, ad_fecha);
    if ldc_precio > 0 then
        return ldc_precio;
    end if;
    
    return 0;
end;
' language plpgsql;    



create function f_precio_harinas(char(2),char(15), char(10),date)returns decimal as '
declare
    as_almacen alias for $1;
    as_articulo alias for $2;
    as_cliente alias for $3;
    ad_fecha alias for $4;
    r_precios_por_cliente_2 record;
    r_articulos_por_almacen record;
    ldc_precio decimal;
begin
    ldc_precio = 0;
    
    select into ldc_precio Max(precios_por_cliente_2.precio)
    from precios_por_cliente_1, precios_por_cliente_2
    where precios_por_cliente_1.secuencia = precios_por_cliente_2.secuencia
    and precios_por_cliente_1.cliente = as_cliente
    and precios_por_cliente_2.almacen = as_almacen
    and precios_por_cliente_2.articulo = as_articulo
    and ad_fecha between precios_por_cliente_1.fecha_desde and precios_por_cliente_1.fecha_hasta
    and status = ''A'';
    if ldc_precio is null then
        ldc_precio = 0;
    end if;
    
    if ldc_precio = 0 then
        select into ldc_precio precio_venta from articulos_por_almacen
        where almacen = as_almacen
        and articulo = as_articulo;
        if not found then
            ldc_precio = 0;
        else
            if ad_fecha <= ''2007-08-15'' then
                if as_articulo = ''02'' or as_articulo = ''04'' or as_articulo = ''05'' then
                    ldc_precio = ldc_precio - 3;
                elsif as_articulo = ''22'' then
                    ldc_precio = ldc_precio - .75;
                elsif as_articulo = ''12'' then
                    ldc_precio = ldc_precio - 1.50;
                elsif as_articulo = ''01'' or as_articulo = ''03'' then
                    ldc_precio = ldc_precio - 2.5;
                elsif as_articulo = ''11'' or as_articulo = ''13'' then
                    ldc_precio = ldc_precio - 1.25;
                elsif as_articulo = ''21'' then
                    ldc_precio = ldc_precio - .65;
                end if;
            end if;
        end if;
    end if;
    
    return ldc_precio;
end;
' language plpgsql;    