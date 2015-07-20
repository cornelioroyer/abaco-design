

drop function f_precios_panificable() cascade;


create function f_precios_panificable() returns integer as '
declare
    r_precios_por_cliente_1 record;
    r_precios_por_cliente_1_work record;
    r_precios_por_cliente_2 record;
    r_work record;
    r_factura1 record;
    r_clientes record;
    li_secuencia int4;
    li_secuencia_old int4;
begin
    for r_clientes in select * from clientes order by cliente
    loop
        for r_precios_por_cliente_2 in 
                select precios_por_cliente_2.* from precios_por_cliente_1, precios_por_cliente_2
                where precios_por_cliente_1.secuencia = precios_por_cliente_2.secuencia
                and precios_por_cliente_1.cliente = r_clientes.cliente
                and current_date between fecha_desde and fecha_hasta
                and status = ''A''
                order by almacen, articulo
        loop
            if r_precios_por_cliente_2.secuencia is null then
                raise exception ''nulo'';
            end if;
            if trim(r_precios_por_cliente_2.articulo) = ''26'' then
                select into r_work *
                from precios_por_cliente_2
                where secuencia = r_precios_por_cliente_2.secuencia
                and almacen = r_precios_por_cliente_2.almacen
                and trim(articulo) = ''55'';
                if not found then
                    insert into precios_por_cliente_2(secuencia, articulo,
                        almacen, precio)
                    values(r_precios_por_cliente_2.secuencia, ''55'',
                        r_precios_por_cliente_2.almacen, r_precios_por_cliente_2.precio);
                end if;
                                    
            elsif trim(r_precios_por_cliente_2.articulo) = ''27'' then
                select into r_work *
                from precios_por_cliente_2
                where secuencia = r_precios_por_cliente_2.secuencia
                and almacen = r_precios_por_cliente_2.almacen
                and trim(articulo) = ''56'';
                if not found then
                    insert into precios_por_cliente_2(secuencia, articulo,
                        almacen, precio)
                    values(r_precios_por_cliente_2.secuencia, ''56'',
                        r_precios_por_cliente_2.almacen, r_precios_por_cliente_2.precio);
                end if;
            
            elsif trim(r_precios_por_cliente_2.articulo) = ''29'' then
                select into r_work *
                from precios_por_cliente_2
                where secuencia = r_precios_por_cliente_2.secuencia
                and almacen = r_precios_por_cliente_2.almacen
                and trim(articulo) = ''57'';
                if not found then
                    insert into precios_por_cliente_2(secuencia, articulo,
                        almacen, precio)
                    values(r_precios_por_cliente_2.secuencia, ''57'',
                        r_precios_por_cliente_2.almacen, r_precios_por_cliente_2.precio);
                end if;            
            end if;
        end loop;                
    end loop;
    
    return 1; 
end;
' language plpgsql;    
