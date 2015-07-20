drop function f_update_costos() cascade;


create function f_update_costos()returns integer as '
declare
    r_eys1 record;
    r_eys2 record;
    r_eys3 record;
    ldc_cu decimal;
    ldc_work decimal;
begin
    for r_eys1 in select * from eys1
    where motivo = ''11''
    and fecha >= ''2009-04-06''
    order by fecha
    loop
        for r_eys2 in select * from eys2
        where almacen = r_eys1.almacen
        and no_transaccion = r_eys1.no_transaccion
        and costo = 0
        loop
            ldc_cu = f_stock(r_eys2.almacen, r_eys2.articulo,
                r_eys1.fecha, 0, 0, ''CU'');
            
            update eys2
            set costo = cantidad * ldc_cu
            where almacen = r_eys2.almacen
            and no_transaccion = r_eys2.no_transaccion
            and linea = r_eys2.linea
            and articulo = r_eys2.articulo;
            
        end loop;
        
        delete from eys3
        where almacen = r_eys1.almacen
        and no_transaccion = r_eys1.no_transaccion;
        
        select into ldc_work sum(costo)
        from eys2
        where almacen = r_eys1.almacen
        and no_transaccion = r_eys1.no_transaccion;
        
        insert into eys3(almacen, no_transaccion, cuenta, monto)
        values(r_eys1.almacen, r_eys1.no_transaccion, ''6191110'', ldc_work);
        
    end loop;
    
    return 1;
    
end;
' language plpgsql;    
