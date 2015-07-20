drop function f_rela_afi_cglposteo_delete() cascade;
drop function f_rela_activos_cglposteo_delete() cascade;
drop function f_activos_after_update() cascade;
drop function f_rela_afi_trx1_cglposteo_after_delete() cascade;
drop function f_afi_trx2_after_update() cascade;
drop function f_afi_trx2_after_delete() cascade;
drop function f_afi_trx1_after_update() cascade;
drop function f_afi_trx2_before_update() cascade;
drop function f_afi_trx2_before_insert() cascade;
drop function f_activos_before_update() cascade;

create function f_activos_before_update() returns trigger as '
begin
    if old.codigo <> new.codigo
        or old.fecha_compra <> new.fecha_compra
        or old.costo_inicial <> new.costo_inicial then
    end if;
    
        delete from rela_activos_cglposteo
        where compania = old.compania
        and codigo = old.codigo;
    
    return new;
end;
' language plpgsql;




create function f_rela_afi_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    
    return old;
end;
' language plpgsql;

create function f_rela_activos_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;

create function f_activos_after_update() returns trigger as '
begin
    if old.codigo <> new.codigo
        or old.fecha_compra <> new.fecha_compra
        or old.costo_inicial <> new.costo_inicial then
        delete from rela_activos_cglposteo
        where compania = old.compania
        and codigo = old.codigo;
    end if;
    return new;
end;
' language plpgsql;


create function f_afi_trx2_before_update() returns trigger as '
declare
    r_afi_trx2 record;
    li_secuencia integer;
begin
    li_secuencia = 0;
    loop
        li_secuencia = li_secuencia + 1;
        select into r_afi_trx2 * from afi_trx2
        where compania = new.compania
        and no_trx = new.no_trx
        and linea = li_secuencia;
        if not found then
            new.linea = li_secuencia;
            exit;
        end if; 
    end loop;


    delete from rela_afi_trx1_cglposteo
    where compania = old.compania
    and no_trx = old.no_trx;
    return new;
end;
' language plpgsql;


create function f_afi_trx2_before_insert() returns trigger as '
declare
    r_afi_trx2 record;
    li_secuencia integer;
begin
    li_secuencia = 0;
    loop
        li_secuencia = li_secuencia + 1;
        select into r_afi_trx2 * from afi_trx2
        where compania = new.compania
        and no_trx = new.no_trx
        and linea = li_secuencia;
        if not found then
            new.linea = li_secuencia;
            exit;
        end if; 
    end loop;


    return new;
end;
' language plpgsql;



create function f_afi_trx1_after_update() returns trigger as '
begin
    delete from rela_afi_trx1_cglposteo
    where compania = old.compania
    and no_trx = old.no_trx;
    return new;
end;
' language plpgsql;


create function f_afi_trx2_after_update() returns trigger as '
begin
    delete from rela_afi_trx1_cglposteo
    where compania = old.compania
    and no_trx = old.no_trx;
    return new;
end;
' language plpgsql;

create function f_afi_trx2_after_delete() returns trigger as '
begin
    delete from rela_afi_trx1_cglposteo
    where compania = old.compania
    and no_trx = old.no_trx;
    return old;
end;
' language plpgsql;

create function f_rela_afi_trx1_cglposteo_after_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;


create trigger t_rela_afi_cglposteo_delete after delete on rela_afi_cglposteo
for each row execute procedure f_rela_afi_cglposteo_delete();

create trigger t_rela_activos_cglposteo_delete after delete on rela_activos_cglposteo
for each row execute procedure f_rela_activos_cglposteo_delete();

create trigger t_activos_after_update after update on activos
for each row execute procedure f_activos_after_update();

create trigger t_activos_before_update before update on activos
for each row execute procedure f_activos_before_update();


create trigger t_afi_trx1_after_update after update on afi_trx1
for each row execute procedure f_afi_trx1_after_update();

create trigger t_afi_trx2_after_update after update on afi_trx2
for each row execute procedure f_afi_trx2_after_update();

create trigger t_afi_trx2_after_delete after delete on afi_trx2
for each row execute procedure f_afi_trx2_after_delete();

create trigger t_rela_afi_trx1_cglposteo_after_delete after delete on rela_afi_trx1_cglposteo
for each row execute procedure f_rela_afi_trx1_cglposteo_after_delete();

create trigger t_afi_trx2_before_update before update on afi_trx2
for each row execute procedure f_afi_trx2_before_update();

create trigger t_afi_trx2_before_insert before insert on afi_trx2
for each row execute procedure f_afi_trx2_before_insert();
