drop function f_cos_trx_before_update() cascade;
drop function f_cos_trx_before_delete() cascade;

drop function f_cos_consumo_before_update() cascade;
drop function f_cos_consumo_before_delete() cascade;
drop function f_cos_consumo_eys2_after_delete() cascade;
drop function f_cos_consumo_after_insert() cascade;

drop function f_cos_produccion_before_update() cascade;
drop function f_cos_produccion_before_delete() cascade;
drop function f_cos_produccion_eys2_after_delete() cascade;
drop function f_cos_produccion_after_insert() cascade;
drop function f_cos_consumo_eys2_before_delete() cascade;
drop function f_cos_produccion_eys2_before_delete() cascade;
drop function f_hp_pesa_before_insert_update() cascade;


create function f_hp_pesa_before_insert_update() returns trigger as '
begin
    if new.fecha_entrada > new.fecha_salida then
        raise exception ''Fecha de Entrada % debe ser anterior a fecha de salida %'',new.fecha_entrada, new.fecha_salida;
    end if;
    
    if new.peso_salida > new.peso_entrada then
        raise exception ''Peso de salida % debe ser menor a peso de entrada %'',new.peso_salida, new.peso_salida;
    end if;
    return new;
end;
' language plpgsql;



create function f_cos_consumo_eys2_before_delete() returns trigger as '
begin
    delete from eys2
    where almacen = old.almacen
    and no_transaccion = old.no_transaccion
    and linea = old.eys2_linea
    and articulo = old.articulo;
    
    return old;
end;
' language plpgsql;


create function f_cos_produccion_eys2_before_delete() returns trigger as '
begin
    delete from eys2
    where almacen = old.almacen
    and no_transaccion = old.no_transaccion
    and linea = old.eys2_linea
    and articulo = old.articulo;
    
    return old;
end;
' language plpgsql;



create function f_cos_trx_before_delete() returns trigger as '
begin
    delete from cos_consumo_eys2
    where compania = old.compania
    and secuencia = old.secuencia;
    
    delete from cos_produccion_eys2
    where compania = old.compania
    and secuencia = old.secuencia;
    return old;
end;
' language plpgsql;


create function f_cos_trx_before_update() returns trigger as '
begin
    delete from cos_consumo_eys2
    where compania = old.compania
    and secuencia = old.secuencia;
    
    delete from cos_produccion_eys2
    where compania = old.compania
    and secuencia = old.secuencia;
    
    return new;
end;
' language plpgsql;


create function f_cos_consumo_before_delete() returns trigger as '
begin
    delete from cos_consumo_eys2
    where compania = old.compania
    and secuencia = old.secuencia
    and linea = old.linea;
    return old;
end;
' language plpgsql;

create function f_cos_consumo_before_update() returns trigger as '
begin
    delete from cos_consumo_eys2
    where compania = old.compania
    and secuencia = old.secuencia
    and linea = old.linea;
    return new;
end;
' language plpgsql;


create function f_cos_produccion_before_update() returns trigger as '
begin
    delete from cos_consumo_eys2
    where compania = old.compania
    and secuencia = old.secuencia
    and linea = old.linea;
    return new;
end;
' language plpgsql;

create function f_cos_produccion_before_delete() returns trigger as '
begin
    delete from cos_consumo_eys2
    where compania = old.compania
    and secuencia = old.secuencia
    and linea = old.linea;
    return old;
end;
' language plpgsql;





create function f_cos_produccion_after_insert() returns trigger as '
declare
    i integer;
begin
    i = f_cos_produccion_eys2(new.compania, new.secuencia, new.linea);
    return new;
end;
' language plpgsql;


create function f_cos_consumo_after_insert() returns trigger as '
declare
    i integer;
begin
    i = f_cos_consumo_eys2(new.compania, new.secuencia, new.linea);
    return new;
end;
' language plpgsql;


create function f_cos_produccion_eys2_after_delete() returns trigger as '
begin
    delete from eys2
    where articulo = old.articulo
    and almacen = old.almacen
    and no_transaccion = old.no_transaccion
    and linea = old.eys2_linea;
    return old;
end;
' language plpgsql;


create function f_cos_consumo_eys2_after_delete() returns trigger as '
begin
    delete from eys2
    where articulo = old.articulo
    and almacen = old.almacen
    and no_transaccion = old.no_transaccion
    and linea = old.eys2_linea;
    return old;
end;
' language plpgsql;



create trigger t_cos_trx_before_update before update on cos_trx
for each row execute procedure f_cos_trx_before_update();
create trigger t_cos_trx_before_delete before delete on cos_trx
for each row execute procedure f_cos_trx_before_delete();
create trigger t_cos_consumo_before_update before update on cos_consumo
for each row execute procedure f_cos_consumo_before_update();
create trigger t_cos_consumo_before_delete before delete on cos_consumo
for each row execute procedure f_cos_consumo_before_delete();
create trigger t_cos_produccion_before_delete before delete on cos_produccion
for each row execute procedure f_cos_produccion_before_delete();
create trigger t_cos_produccion_before_update before update on cos_produccion
for each row execute procedure f_cos_produccion_before_update();

create trigger t_cos_consumo_eys2_after_delete after delete on cos_consumo_eys2
for each row execute procedure f_cos_consumo_eys2_after_delete();
create trigger t_cos_produccion_eys2_after_delete after delete on cos_produccion_eys2
for each row execute procedure f_cos_produccion_eys2_after_delete();


create trigger t_cos_produccion_after_insert after insert or update on cos_produccion
for each row execute procedure f_cos_produccion_after_insert();
create trigger t_cos_consumo_after_insert after insert or update on cos_consumo
for each row execute procedure f_cos_consumo_after_insert();


create trigger t_cos_produccion_eys2_before_delete before delete on cos_produccion_eys2
for each row execute procedure f_cos_produccion_eys2_before_delete();

create trigger t_cos_consumo_eys2_before_delete before delete on cos_consumo_eys2
for each row execute procedure f_cos_consumo_eys2_before_delete();


create trigger t_hp_pesa_before_insert_update before insert or update on hp_pesa
for each row execute procedure f_hp_pesa_before_insert_update();
