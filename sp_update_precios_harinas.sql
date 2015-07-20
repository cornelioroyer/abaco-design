drop function f_update_precios_harinas() cascade;
drop function f_update_precios_afrecho() cascade;


create function f_update_precios_afrecho()returns integer as '
declare
    r_precios_por_cliente_1 record;
    r_precios_por_cliente_2 record;
    r_pxc_1 record;
    r_pxc_2 record;
    ldc_precio decimal;
    li_secuencia int4;
begin
    for r_precios_por_cliente_1 in select precios_por_cliente_1.* from precios_por_cliente_1
                    where ''2008-03-31'' between fecha_desde and fecha_hasta
                    order by secuencia
    loop
        for r_precios_por_cliente_2 in select * from precios_por_cliente_2
                                        where secuencia = r_precios_por_cliente_1.secuencia
                                        and precios_por_cliente_2.articulo in (''06'',''07'')
                                        order by almacen, articulo
        loop                                        
            select into r_pxc_1 * from precios_por_cliente_1
            where cliente = r_precios_por_cliente_1.cliente
            and fecha_desde = ''2008-04-01'';
            if found then
                li_secuencia = r_pxc_1.secuencia;
            else
                li_secuencia = 0;
                while 1=1 loop
                    li_secuencia = li_secuencia + 1;
                    select into r_pxc_1 * from precios_por_cliente_1
                    where secuencia = li_secuencia;
                    if not found then
                        exit;
                    end if;
                end loop;
                insert into precios_por_cliente_1(secuencia, cliente, cantidad_desde,
                                cantidad_hasta, fecha_desde, fecha_hasta, status,
                                usuario_captura, fecha_captura)
                values (li_secuencia, r_precios_por_cliente_1.cliente, 1, 9999999,
                        ''2008-04-01'',''2010-01-01'', ''A'', current_user, current_timestamp);
            end if;
            
            ldc_precio = 0;
            
            if r_precios_por_cliente_2.articulo = ''06'' 
                or r_precios_por_cliente_2.articulo = ''07'' then
                ldc_precio = r_precios_por_cliente_2.precio + .75;
            else
                ldc_precio = 0;
            end if;
            
            if ldc_precio > 0 then
                select into r_pxc_2 * from precios_por_cliente_2
                where secuencia = li_secuencia
                and almacen = r_precios_por_cliente_2.almacen
                and articulo = r_precios_por_cliente_2.articulo;
                if not found then
                    insert into precios_por_cliente_2(secuencia, articulo, almacen, precio)
                    values(li_secuencia, r_precios_por_cliente_2.articulo, 
                            r_precios_por_cliente_2.almacen, ldc_precio);
                else
                    if ldc_precio > r_pxc_2.precio then
                        update precios_por_cliente_2
                        set precio = ldc_precio
                        where secuencia = li_secuencia
                        and almacen = r_precios_por_cliente_2.almacen
                        and articulo = r_precios_por_cliente_2.articulo;
                    end if;
                end if;
            end if;
        end loop;
    end loop;        
    
    
    return 1;
    
end;
' language plpgsql;    


/*
create function f_update_precios_afrecho()returns integer as '
declare
    r_precios_por_cliente_1 record;
    r_precios_por_cliente_2 record;
    r_pxc_1 record;
    r_pxc_2 record;
    r_work record;
    ldc_precio decimal;
    li_secuencia int4;
begin
    li_secuencia = 0;
    for r_work in select factura1.almacen, factura1.cliente from factura1, factura2
                    where factura1.almacen = factura2.almacen
                    and factura1.tipo = factura2.tipo
                    and factura1.num_documento = factura2.num_documento
                    and factura2.articulo in (''06'',''07'')
                    and factura1.fecha_factura >= ''2007-01-01''
                    group by 1, 2
                    order by 1, 2
    loop
        while 1=1 loop
            li_secuencia = li_secuencia + 1;
            select into r_pxc_1 * from precios_por_cliente_1
            where secuencia = li_secuencia;
            if not found then
                exit;
            end if;
        end loop;
        
        insert into precios_por_cliente_1(secuencia, cliente, cantidad_desde,
                                cantidad_hasta, fecha_desde, fecha_hasta, status,
                                usuario_captura, fecha_captura)
        values (li_secuencia, r_work.cliente, 1, 9999999,
                ''2007-11-01'',''2008-12-31'', ''A'', current_user, current_timestamp);
   
        insert into precios_por_cliente_2(secuencia, articulo, almacen, precio)
        values(li_secuencia, ''06'', r_work.almacen, 8.5);
        
        insert into precios_por_cliente_2(secuencia, articulo, almacen, precio)
        values(li_secuencia, ''07'', r_work.almacen, 8.5);
    end loop;        
    
    
return 1;
    
end;
' language plpgsql;    
*/


create function f_update_precios_harinas()returns integer as '
declare
    r_precios_por_cliente_1 record;
    r_precios_por_cliente_2 record;
    r_pxc_1 record;
    r_pxc_2 record;
    ldc_precio decimal;
    li_secuencia int4;
begin
    for r_precios_por_cliente_1 in select precios_por_cliente_1.* from precios_por_cliente_1
                    where ''2008-03-31'' between fecha_desde and fecha_hasta
                    order by secuencia
    loop
        for r_precios_por_cliente_2 in select * from precios_por_cliente_2
                                        where secuencia = r_precios_por_cliente_1.secuencia
                                        order by almacen, articulo
        loop                                        
            select into r_pxc_1 * from precios_por_cliente_1
            where cliente = r_precios_por_cliente_1.cliente
            and fecha_desde = ''2008-04-01'';
            if found then
                li_secuencia = r_pxc_1.secuencia;
            else
                li_secuencia = 0;
                while 1=1 loop
                    li_secuencia = li_secuencia + 1;
                    select into r_pxc_1 * from precios_por_cliente_1
                    where secuencia = li_secuencia;
                    if not found then
                        exit;
                    end if;
                end loop;
                insert into precios_por_cliente_1(secuencia, cliente, cantidad_desde,
                                cantidad_hasta, fecha_desde, fecha_hasta, status,
                                usuario_captura, fecha_captura)
                values (li_secuencia, r_precios_por_cliente_1.cliente, 1, 9999999,
                        ''2008-04-01'',''2010-01-01'', ''A'', current_user, current_timestamp);
            end if;
            
            ldc_precio = 0;
            
            if r_precios_por_cliente_2.articulo = ''02'' 
                or r_precios_por_cliente_2.articulo = ''04''
                or r_precios_por_cliente_2.articulo = ''05'' then
                ldc_precio = r_precios_por_cliente_2.precio + 6;
            elsif r_precios_por_cliente_2.articulo = ''22'' then
                ldc_precio = r_precios_por_cliente_2.precio + 1.5;
            elsif r_precios_por_cliente_2.articulo = ''12'' then
                ldc_precio = r_precios_por_cliente_2.precio + 3;
            elsif r_precios_por_cliente_2.articulo = ''01'' 
                or r_precios_por_cliente_2.articulo = ''03'' then
                ldc_precio = r_precios_por_cliente_2.precio + 12;
            elsif r_precios_por_cliente_2.articulo = ''11'' 
                or r_precios_por_cliente_2.articulo = ''13'' then
                ldc_precio = r_precios_por_cliente_2.precio + 6;
            elsif r_precios_por_cliente_2.articulo = ''21'' then
                ldc_precio = r_precios_por_cliente_2.precio + 3;
            else
                ldc_precio = 0;
            end if;
            
            if ldc_precio > 0 then
                select into r_pxc_2 * from precios_por_cliente_2
                where secuencia = li_secuencia
                and almacen = r_precios_por_cliente_2.almacen
                and articulo = r_precios_por_cliente_2.articulo;
                if not found then
                    insert into precios_por_cliente_2(secuencia, articulo, almacen, precio)
                    values(li_secuencia, r_precios_por_cliente_2.articulo, 
                            r_precios_por_cliente_2.almacen, ldc_precio);
                else
                    if ldc_precio > r_pxc_2.precio then
                        update precios_por_cliente_2
                        set precio = ldc_precio
                        where secuencia = li_secuencia
                        and almacen = r_precios_por_cliente_2.almacen
                        and articulo = r_precios_por_cliente_2.articulo;
                    end if;
                end if;
            end if;
        end loop;
    end loop;        
    
    
    return 1;
    
end;
' language plpgsql;    