drop function f_articulos_after_insert_cooldragon() cascade;
drop function f_eys2_after_insert_cooldragon() cascade;


create function f_articulos_after_insert_cooldragon() returns trigger as '
declare
r_gral_grupos_aplicacion record;
r_gral_valor_grupos record;
r_articulos_agrupados record;
li_sw integer;
begin
    if new.servicio = ''N'' then
        insert into articulos_por_almacen (almacen, articulo, cuenta, precio_venta,
        minimo, maximo, usuario, fecha_captura, dias_piso, existencia, costo, precio_fijo, precio_minimo) 
        values (''02'',new.articulo,''1101001'',99999,0,0,current_user,current_timestamp,1,0,0,''N'', 0);
    end if;
    return new;
end;
' language plpgsql;


create function f_eys2_after_insert_cooldragon() returns trigger as '
declare
    r_eys1 record;
    r_articulos_por_almacen record;
    ldc_cu decimal;
    ldc_precio decimal;
begin
    select into r_eys1 * from eys1
    where almacen = new.almacen
    and no_transaccion = new.no_transaccion;
    if r_eys1.aplicacion_origen = ''COM'' then
        if new.cantidad > 0 and new.costo > 0 then
            ldc_cu  =   new.costo / new.cantidad;
            
            select into r_articulos_por_almacen *
            from articulos_por_almacen
            where almacen = new.almacen
            and articulo = new.articulo;
            
            ldc_precio  =   ldc_cu * 2.2;
            
--            if ldc_precio > r_articulos_por_almacen.precio_venta then
                update articulos_por_almacen
                set precio_venta = ldc_precio
                where almacen = new.almacen
                and articulo = new.articulo;
--            end if;            
           
        end if;   
    end if;
    return new;
end;
' language plpgsql;

create trigger t_eys2_after_insert_cooldragon after insert on eys2
for each row execute procedure f_eys2_after_insert_cooldragon();

create trigger t_articulos_after_insert_cooldragon after insert on articulos
for each row execute procedure f_articulos_after_insert_cooldragon();
