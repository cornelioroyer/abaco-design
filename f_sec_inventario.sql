drop function f_sec_inventario(char(2));
create function f_sec_inventario(char(2)) returns integer as '
declare
    as_almacen alias for $1;
    r_invparal record;
    r_work record;
    secuencia integer;
begin
    select into r_invparal invparal.* from invparal
    where invparal.almacen = as_almacen
    and parametro = ''sec_eys''
    and aplicacion = ''INV'';
    if not found then
        secuencia := 0;
    else
        secuencia := to_number(r_invparal.valor, ''99G999D9S'');
    end if;
    
    loop
        secuencia := secuencia + 1;
        
        select into r_work * from eys1
        where eys1.almacen = as_almacen
        and eys1.no_transaccion = secuencia;
        if not found then
            exit;
        end if;
    end loop;
    
    update invparal
    set valor = trim(to_char(secuencia, ''99999999''))
    where almacen = as_almacen
    and parametro = ''sec_eys''
    and aplicacion = ''INV'';
     
    return secuencia;
end;
' language plpgsql;