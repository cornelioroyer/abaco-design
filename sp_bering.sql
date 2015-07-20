drop trigger t_departamentos_update on departamentos;
drop function f_departamentos_update() cascade;
drop trigger t_articulos on articulos;
drop function f_articulos();
drop function f_tal_equipo_update() cascade;



create function f_tal_equipo_update() returns trigger as '
declare
    r_articulos record;
    ls_desc_larga char(200);
    r_articulos_por_almacen record;
begin
    if new.inventario = ''N'' then
        return new;
    end if;
    
    ls_desc_larga := trim(new.modelo) || ''  AÑO:'' || trim(new.anio);
    select into r_articulos * from articulos
    where trim(articulo) = trim(new.codigo);
    if not found then
        insert into articulos(articulo, unidad_medida, desc_articulo, status_articulo,
            desc_larga, servicio, numero_parte, numero_serie, valorizacion, orden_impresion)
        values (new.codigo, ''UNIDAD'', substring(trim(new.descripcion) from 1 for 90), ''A'',
            ls_desc_larga, ''N'', new.motor, new.serial, ''P'', 100);
    else
        update articulos
        set desc_articulo = substring(trim(new.descripcion) from 1 for 90),
            desc_larga = ls_desc_larga,
            numero_parte = new.motor,
            numero_serie = new.serial
        where trim(articulo) = trim(new.codigo);
    end if;
    
    select into r_articulos_por_almacen * from articulos_por_almacen
    where almacen = ''03''
    and trim(articulo) = trim(new.codigo);
    if not found then
        insert into articulos_por_almacen (almacen, articulo, cuenta,
            precio_venta, usuario, fecha_captura, minimo, maximo, dias_piso, existencia,
            costo)
        values (''03'', trim(new.codigo), ''121000'', 999999, current_user, current_timestamp,
            1, 1, 20, 0, 0);
    end if;
    
    select into r_articulos_por_almacen * from articulos_por_almacen
    where almacen = ''05''
    and trim(articulo) = trim(new.codigo);
    if not found then
        insert into articulos_por_almacen (almacen, articulo, cuenta,
            precio_venta, usuario, fecha_captura, minimo, maximo, dias_piso, existencia,
            costo)
        values (''05'', trim(new.codigo), ''121000'', 999999, current_user, current_timestamp,
            1, 1, 20, 0, 0);
    end if;
    
      
    return new;
end;
' language plpgsql;



create function f_departamentos_update() returns trigger as '
declare
    r_cglauxiliares record;
begin
    select into r_cglauxiliares * from cglauxiliares
    where auxiliar = new.codigo;
    if not found then
        insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
        values (new.codigo, substring(trim(new.descripcion) from 1 for 30), ''1'', ''A'');
    else
        update cglauxiliares
        set nombre = substring(trim(new.descripcion) from 1 for 30)
        where auxiliar = new.codigo;
    end if;
            
    return new;
end;
' language plpgsql;



create function f_articulos() returns trigger as '
begin
    delete from articulos_agrupados
    where articulo = new.articulo
    and codigo_valor_grupo in (''SI'',''01'');
    
    insert into articulos_agrupados (articulo, codigo_valor_grupo)
    values (new.articulo, ''SI'');
    
    insert into articulos_agrupados (articulo, codigo_valor_grupo)
    values (new.articulo, ''03'');
    
    return new;
end;
' language plpgsql;


create trigger t_tal_equipo_update after insert or update on tal_equipo
for each row execute procedure f_tal_equipo_update();

create trigger t_articulos after insert on articulos
for each row execute procedure f_articulos();


create trigger t_departamentos_update after insert or update on departamentos
for each row execute procedure f_departamentos_update();