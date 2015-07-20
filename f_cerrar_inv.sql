

drop function f_cerrar_inv(char(2),int4, int4) cascade;


create function f_cerrar_inv(char(2),int4, int4) returns integer as '
declare
    as_cia alias for $1;
    ai_anio alias for $2;
    ai_mes alias for $3;
    r_work record;
    r_gralperiodos record;
begin

    select into r_gralperiodos *
    from gralperiodos
    where compania = as_cia
    and aplicacion = ''INV''
    and year = ai_anio
    and periodo = ai_mes;
    if not found then
        Raise Exception ''No existe Anio % y Mes % en Inventario'',ai_anio, ai_mes;
    end if;
    
    if r_gralperiodos.estado <> ''A'' then
        return 0;
    end if;
    
    delete from invbalance
    where compania = as_cia
    and year = ai_anio
    and periodo = ai_mes;
    
    insert into invbalance (compania, aplicacion, almacen,  articulo, year, periodo, existencia, costo)
    select compania,''INV'',almacen,articulo,ai_anio,ai_mes,sum(cantidad), sum(costo)
    from v_eys1_eys2
    where compania = as_cia
    and fecha <= r_gralperiodos.final
    group by articulo, almacen, compania;

    return 1;
end;


' language plpgsql;


/*    
    for r_work in select articulos_por_almacen.* 
                    from almacen, articulos_por_almacen
                    where almacen.almacen = articulos_por_almacen.almacen
                    and almacen.compania = as_cia
                    order by articulos_por_almacen.almacen, articulos_por_almacen.articulo
    loop
    
    end loop;                    
*/    


