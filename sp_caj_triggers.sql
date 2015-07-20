

drop function f_caja_trx1_before_insert() cascade;
drop function f_caja_trx1_before_update() cascade;
drop function f_caja_trx1_before_delete() cascade;
drop function f_caja_trx1_update() cascade;

drop function f_caja_trx2_before_insert() cascade;
drop function f_caja_trx2_before_update() cascade;
drop function f_caja_trx2_before_delete() cascade;
drop function f_caja_trx2_update() cascade;
drop function f_caja_trx2_delete() cascade;

drop function f_rela_caja_trx1_cglposteo_delete() cascade;



create function f_caja_trx1_before_insert() returns trigger as '
declare
    i integer;
    r_cajas record;
begin
    
    select into r_cajas *
    from cajas
    where caja = new.caja;
    
    i = f_valida_fecha(r_cajas.compania, ''CAJ'', new.fecha_posteo);

    return new;
end;
' language plpgsql;


create function f_caja_trx1_before_update() returns trigger as '
declare
    i integer;
    r_cajas record;
begin
    
    select into r_cajas *
    from cajas
    where caja = old.caja;
    
    i = f_valida_fecha(r_cajas.compania, ''CAJ'', old.fecha_posteo);


    select into r_cajas *
    from cajas
    where caja = new.caja;
    
    i = f_valida_fecha(r_cajas.compania, ''CAJ'', new.fecha_posteo);

    
    delete from rela_caja_trx1_cglposteo
    where caja = old.caja
    and numero_trx = old.numero_trx;

    return new;
end;
' language plpgsql;


create function f_caja_trx1_before_delete() returns trigger as '
declare
    i integer;
    r_cajas record;
begin
    
    select into r_cajas *
    from cajas
    where caja = old.caja;
    
    i = f_valida_fecha(r_cajas.compania, ''CAJ'', old.fecha_trx);
    
    delete from rela_caja_trx1_cglposteo
    where caja = old.caja
    and numero_trx = old.numero_trx;

    return old;
end;
' language plpgsql;


create function f_caja_trx2_before_insert() returns trigger as '
declare
    i integer;
    r_cajas record;
    r_caja_trx1 record;
    r_cglcuentas record;
begin
    
    select into r_caja_trx1 *
    from caja_trx1
    where caja = new.caja
    and numero_trx = new.numero_trx;
    
    select into r_cajas *
    from cajas
    where caja = new.caja;
    
    i = f_valida_fecha(r_cajas.compania, ''CAJ'', r_caja_trx1.fecha_trx);
    
    select into r_cglcuentas *
    from cglcuentas
    where cuenta = new.cuenta;
    if not found then
        Raise Exception ''Cuenta % no Existe...Verifique'',new.cuenta;
    end if; 
    
    if r_cglcuentas.auxiliar_1 = ''S'' and new.auxiliar_1 is null then
        Raise Exception ''Auxiliar 1 En Cuenta % es Obligatorio'',new.cuenta;
    end if;
    
    if r_cglcuentas.auxiliar_2 = ''S'' and new.auxiliar_2 is null then
        Raise Exception ''Auxiliar 2 En Cuenta % es Obligatorio'',new.cuenta;
    end if;
    
    
    
    
   
    
    return new;
end;
' language plpgsql;



create function f_caja_trx2_before_update() returns trigger as '
declare
    i integer;
    r_cajas record;
    r_caja_trx1 record;
begin
    
    select into r_caja_trx1 *
    from caja_trx1
    where caja = old.caja
    and numero_trx = old.numero_trx;
    
    select into r_cajas *
    from cajas
    where caja = old.caja;
    
    i = f_valida_fecha(r_cajas.compania, ''CAJ'', r_caja_trx1.fecha_trx);


    select into r_caja_trx1 *
    from caja_trx1
    where caja = new.caja
    and numero_trx = new.numero_trx;
    
    select into r_cajas *
    from cajas
    where caja = new.caja;
    
    i = f_valida_fecha(r_cajas.compania, ''CAJ'', r_caja_trx1.fecha_trx);
    
    return new;
end;
' language plpgsql;


create function f_caja_trx2_before_delete() returns trigger as '
declare
    i integer;
    r_cajas record;
    r_caja_trx1 record;
begin
    
    select into r_caja_trx1 *
    from caja_trx1
    where caja = old.caja
    and numero_trx = old.numero_trx;
    if not found then
        return old;
    end if;
    
    select into r_cajas *
    from cajas
    where caja = old.caja;
    
    i = f_valida_fecha(r_cajas.compania, ''CAJ'', r_caja_trx1.fecha_posteo);

    return old;
end;
' language plpgsql;




create function f_rela_caja_trx1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;


create function f_caja_trx1_update() returns trigger as '
declare
    r_cajas record;
    i integer;

begin
    delete from rela_caja_trx1_cglposteo
    where caja = old.caja
    and numero_trx = old.numero_trx;
    
    return new;
end;
' language plpgsql;


create function f_caja_trx2_update() returns trigger as '
begin
    delete from rela_caja_trx1_cglposteo
    where caja = old.caja
    and numero_trx = old.numero_trx;
    return new;
end;
' language plpgsql;


create function f_caja_trx2_delete() returns trigger as '
begin
    
    delete from rela_caja_trx1_cglposteo
    where caja = old.caja
    and numero_trx = old.numero_trx;

    return old;
end;
' language plpgsql;


create trigger t_caja_trx1_before_insert before insert on caja_trx1
for each row execute procedure f_caja_trx1_before_insert();

create trigger t_caja_trx1_before_update before update on caja_trx1
for each row execute procedure f_caja_trx1_before_update();

create trigger t_caja_trx1_before_delete before delete on caja_trx1
for each row execute procedure f_caja_trx1_before_delete();

create trigger t_caja_trx1_update after update on caja_trx1
for each row execute procedure f_caja_trx1_update();


create trigger t_caja_trx2_before_insert before insert on caja_trx2
for each row execute procedure f_caja_trx2_before_insert();

create trigger t_caja_trx2_before_update before update on caja_trx2
for each row execute procedure f_caja_trx2_before_update();

create trigger t_caja_trx2_before_delete before delete on caja_trx2
for each row execute procedure f_caja_trx2_before_delete();


create trigger t_caja_trx2_update after update on caja_trx2
for each row execute procedure f_caja_trx2_update();

create trigger t_caja_trx2_delete after delete on caja_trx2
for each row execute procedure f_caja_trx2_delete();

create trigger t_rela_caja_trx1_cglposteo_delete after delete on rela_caja_trx1_cglposteo
for each row execute procedure f_rela_caja_trx1_cglposteo_delete();

