drop function f_articulos_after_insert_fa() cascade;



create function f_articulos_after_insert_fa() returns trigger as '
declare
r_gral_grupos_aplicacion record;
r_gral_valor_grupos record;
r_articulos_agrupados record;
li_sw integer;
begin
/*
    select into r_articulos_agrupados * from articulos_agrupados
    where articulo = new.articulo
    and codigo_valor_grupo = ''SI'';
    if not found then
        insert into articulos_agrupados (articulo, codigo_valor_grupo)
        values (new.articulo, ''SI'');
    end if;
    
        
    select into r_articulos_agrupados * from articulos_agrupados
    where articulo = new.articulo
    and codigo_valor_grupo = ''00'';
    if not found then
        insert into articulos_agrupados (articulo, codigo_valor_grupo)
        values (new.articulo, ''00'');
    end if;    
*/
    
    insert into articulos_por_almacen (almacen, articulo, cuenta, precio_venta,
    minimo, maximo, usuario, fecha_captura, dias_piso, existencia, costo, precio_fijo) 
    values (''01'',new.articulo,''11301'',0.01,0,0,current_user,current_timestamp,1,0,0,''N'');
    
    for r_gral_grupos_aplicacion in 
            select * from gral_grupos_aplicacion
                where aplicacion = ''INV''
                order by secuencia, grupo
    loop
        select into r_articulos_agrupados *
        from articulos_agrupados
        where articulo = new.articulo
        and codigo_valor_grupo in
        (select codigo_valor_grupo from gral_valor_grupos
        where grupo = r_gral_grupos_aplicacion.grupo
        and aplicacion = r_gral_grupos_aplicacion.aplicacion);
        if not found then
            li_sw = 0;
            for r_gral_valor_grupos in
                        select * from gral_valor_grupos
                            where aplicacion = r_gral_grupos_aplicacion.aplicacion
                            and grupo = r_gral_grupos_aplicacion.grupo
                            order by codigo_valor_grupo
            loop
                if li_sw = 0 then
                    insert into articulos_agrupados (articulo, codigo_valor_grupo)
                    values (new.articulo, trim(r_gral_valor_grupos.codigo_valor_grupo));
                    li_sw = 1;
                end if;
            end loop;
        end if;
    end loop;
                
    return new;
end;
' language plpgsql;


create trigger t_articulos_after_insert_fa after insert on articulos
for each row execute procedure f_articulos_after_insert_fa();