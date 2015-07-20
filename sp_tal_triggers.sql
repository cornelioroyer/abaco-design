drop function f_tal_ot2_eys2_after_delete() cascade;
drop function f_tal_ot2_after_update() cascade;
drop function f_tal_ot2_after_insert() cascade;
drop function f_tal_ot2_before_update() cascade;
drop function f_tal_ot2_before_delete() cascade;
drop function f_tal_ot2_before_insert() cascade;
drop function f_tal_ot1_before_insert() cascade;
drop function f_tal_ot1_before_update() cascade;
drop function f_tal_equipo_after_insert() cascade;


create function f_tal_equipo_after_insert() returns trigger as '
declare
    r_cglauxiliares record;
begin
    select into r_cglauxiliares *
    from cglauxiliares
    where trim(auxiliar) = trim(new.codigo);
    if not found then
        insert into cglauxiliares(auxiliar, nombre, tipo_persona, status, concepto, tipo_de_compra)
        values(trim(new.codigo), trim(new.descripcion), ''1'', ''A'', ''1'', ''1'');
    else
        update cglauxiliares
        set nombre = trim(new.descripcion)
        where trim(auxiliar) = trim(new.codigo);
    end if;
    return new;
end;
' language plpgsql;

create function f_tal_ot1_before_insert() returns trigger as '
begin
    if new.referencia is null then
        raise exception ''Campo de Origen es Obligatorio'';
    end if;
    return new;
end;
' language plpgsql;


create function f_tal_ot1_before_update() returns trigger as '
begin
    if old.status = ''R'' and new.facturar = ''N'' then
        return new;
    end if;

    if new.referencia is null then
        raise exception ''Campo de Origen es Obligatorio'';
    end if;
    
    return new;
end;
' language plpgsql;


create function f_tal_ot2_eys2_after_delete() returns trigger as '
begin
    delete from eys2
    where articulo = old.articulo
    and almacen = old.almacen
    and no_transaccion = old.no_transaccion
    and linea = old.linea_eys2;
    return old;
end;
' language plpgsql;


create function f_tal_ot2_after_update() returns trigger as '
declare
    i integer;
begin
    delete from tal_ot2_eys2
    where no_orden = old.no_orden
    and tipo = old.tipo
    and almacen = old.almacen
    and linea_tal_ot2 = old.linea
    and articulo =old.articulo;
    
    if new.despachar = ''S'' then
        i := f_tal_ot2_inventario(new.almacen, new.no_orden, new.tipo, new.linea, new.articulo);
    end if;
    
    return new;
end;
' language plpgsql;


create function f_tal_ot2_before_delete() returns trigger as '
begin
    delete from tal_ot2_eys2
    where no_orden = old.no_orden
    and tipo = old.tipo
    and almacen = old.almacen
    and linea_tal_ot2 = old.linea
    and articulo = old.articulo;
    
    return old;
end;
' language plpgsql;

create function f_tal_ot2_before_update() returns trigger as '
begin
    if new.despachar = ''S'' and trim(new.articulo) = ''SOLICITUD'' then
        raise exception ''Articulo % no se puede despachar'',new.articulo;
    end if;
    delete from tal_ot2_eys2
    where no_orden = old.no_orden
    and tipo = old.tipo
    and almacen = old.almacen
    and linea_tal_ot2 = old.linea
    and articulo =old.articulo;
    
    delete from eys2 using tal_ot2_eys2
    where eys2.articulo = tal_ot2_eys2.articulo
    and eys2.almacen = tal_ot2_eys2.almacen
    and eys2.no_transaccion = tal_ot2_eys2.no_transaccion
    and eys2.linea = tal_ot2_eys2.linea_eys2
    and tal_ot2_eys2.tipo = old.tipo
    and tal_ot2_eys2.almacen = old.almacen
    and tal_ot2_eys2.linea_tal_ot2 = old.linea
    and tal_ot2_eys2.articulo =old.articulo;
    
    return new;
end;
' language plpgsql;

create function f_tal_ot2_before_insert() returns trigger as '
begin
    if new.despachar = ''S'' and trim(new.articulo) = ''SOLICITUD'' then
        raise exception ''Articulo % no se puede despachar'',new.articulo;
    end if;
    
    return new;
end;
' language plpgsql;




create function f_tal_ot2_after_insert() returns trigger as '
declare
    i integer;
begin
    if new.despachar = ''S'' then
        i := f_tal_ot2_inventario(new.almacen, new.no_orden, new.tipo, new.linea, new.articulo);
    end if;
    
    return new;
end;
' language plpgsql;



create trigger t_tal_ot2_before_delete before delete on tal_ot2
for each row execute procedure f_tal_ot2_before_delete();

create trigger t_tal_ot2_before_update before update on tal_ot2
for each row execute procedure f_tal_ot2_before_update();

create trigger t_tal_ot2_eys2_after_delete after delete on tal_ot2_eys2
for each row execute procedure f_tal_ot2_eys2_after_delete();

create trigger t_tal_ot2_after_update after update on tal_ot2
for each row execute procedure f_tal_ot2_after_update();

create trigger t_tal_ot2_after_insert after insert on tal_ot2
for each row execute procedure f_tal_ot2_after_insert();

create trigger t_tal_ot2_before_insert before insert on tal_ot2
for each row execute procedure f_tal_ot2_before_insert();

create trigger t_tal_ot1_before_insert before insert on tal_ot1
for each row execute procedure f_tal_ot1_before_insert();

create trigger t_tal_ot1_before_update before update on tal_ot1
for each row execute procedure f_tal_ot1_before_update();

create trigger t_tal_equipo_after_insert after insert or update on tal_equipo
for each row execute procedure f_tal_equipo_after_insert();

