drop function f_eys1_poner_cuentas(char(2), int4) cascade;

create function f_eys1_poner_cuentas(char(2), int4) returns integer as '
declare
    as_almacen alias for $1;
    ai_no_transaccion alias for $2;
    r_work record;
    r_facparamcgl record;
    r_eys3 record;
    li_work integer;
begin
    delete from eys3
    where almacen = as_almacen
    and no_transaccion = ai_no_transaccion;
    for r_work in select articulo, sum(eys2.costo) as monto from eys2
                    where eys2.almacen = as_almacen
                    and eys2.no_transaccion = ai_no_transaccion
                    group by 1
                    order by 1
    loop
    
        select into r_facparamcgl * from articulos_agrupados, facparamcgl
        where articulos_agrupados.codigo_valor_grupo = facparamcgl.codigo_valor_grupo
        and articulos_agrupados.articulo = r_work.articulo
        and facparamcgl.almacen = as_almacen;
        if not found then
           raise exception ''Articulo % no tiene definido parametros contables'',r_work.articulo;
        end if;
        
        select into r_eys3 * from eys3
        where almacen = as_almacen
        and no_transaccion = ai_no_transaccion
        and cuenta = r_facparamcgl.cuenta_costo;
        if not found then
           insert into eys3 (almacen, no_transaccion, cuenta, monto)
           values (as_almacen, ai_no_transaccion, r_facparamcgl.cuenta_costo, r_work.monto);
        else
           update eys3
           set monto = monto + r_work.monto
           where almacen = as_almacen
           and no_transaccion = ai_no_transaccion
           and cuenta = r_facparamcgl.cuenta_costo;
        end if;
    end loop;
    li_work := f_eys1_cglposteo(as_almacen, ai_no_transaccion);
    return 1;
end;
' language plpgsql;

