drop function f_update_costos_fifo(char(2), char(15), int4, int4) cascade;

create function f_update_costos_fifo(char(2), char(15), int4, int4) returns integer as '
declare
    as_almacen alias for $1;
    as_articulo alias for $2;
    ai_no_transaccion alias for $3;
    ai_linea alias for $4;
    r_articulos record;
    r_eys1 record;
    r_eys6 record;
    r_eys2 record;
    r_invmotivos record;
    ldc_costo decimal;
begin
    select into r_articulos *
    from articulos
    where trim(articulo) = trim(as_articulo);
    if not found then
        return 0;
    end if;
    
    if r_articulos.servicio = ''S'' then
        return 0;
    end if;
    
    if r_articulos.valorizacion = ''P'' or r_articulos.valorizacion = ''U'' then
        return 0;
    end if;
    
    select into r_eys1 * from eys1
    where almacen = as_almacen
    and no_transaccion = ai_no_transaccion;
    if not found then
        return 0;
    end if;
    
    select into r_invmotivos * from invmotivos
    where motivo = r_eys1.motivo;
    if not found then
        return 0;
    end if;
    
    if r_invmotivos.signo > 0 then
        return 0;
    end if;
    
    if r_invmotivos.costo = ''N'' then
        return 0;
    end if;
    
--    raise exception ''entre'';
    ldc_costo := 0;
    for r_eys6 in select * from eys6
                    where articulo = as_articulo
                    and almacen = as_almacen
                    and no_transaccion = ai_no_transaccion
                    and linea = ai_linea
    loop
        select into r_eys2 * from eys2
        where articulo = r_eys6.articulo
        and almacen = r_eys6.almacen
        and no_transaccion = r_eys6.compra_no_transaccion
        and linea = r_eys6.compra_linea;
        if found then
            ldc_costo := ldc_costo + ((r_eys2.costo / r_eys2.cantidad) * -r_eys6.cantidad);
        end if;
    end loop;
    
    
    update eys2
    set costo = ldc_costo
    where articulo = as_articulo
    and almacen = as_almacen
    and no_transaccion = ai_no_transaccion
    and linea = ai_linea;
          
    return 1;
end;
' language plpgsql;



