drop function f_articulos_after_insert() cascade;



create function f_articulos_after_insert() returns trigger as '
begin
    insert into articulos_agrupados (articulo, codigo_valor_grupo)
    values (new.articulo, ''SI'');
    
    insert into articulos_agrupados (articulo, codigo_valor_grupo)
    values (new.articulo, ''00'');
    
    insert into articulos_por_almacen (almacen, articulo, cuenta, precio_venta,
    minimo, maximo, usuario, fecha_captura, dias_piso, existencia, costo, precio_fijo) 
    values (''01'',new.articulo,''11301'',0.01,0,0,current_user,current_timestamp,1,0,0,''N'');
    
    return new;
end;
' language plpgsql;


create trigger t_articulos_after_insert after insert on articulos
for each row execute procedure f_articulos_after_insert();