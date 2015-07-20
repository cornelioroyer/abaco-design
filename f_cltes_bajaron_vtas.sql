drop function f_cltes_bajaron_vtas() cascade;

create function f_cltes_bajaron_vtas() returns integer as '
declare
    r_clientes record;
    ldc_quintales decimal;
    ldc_dolares decimal;
    ldc_quintales_2011 decimal;
    ldc_dolares_2011 decimal;
    ldc_quintales_dif decimal;
    ldc_dolares_dif decimal;
begin

    drop table tmp_cltes_bajaron_vtas;
    
    create table tmp_cltes_bajaron_vtas as
            select nomb_cliente, cliente, limite_credito as quintales, limite_credito as dolares,
                limite_credito as quintales_2011, limite_credito as dolares_2011,
                limite_credito as quintales_dif, limite_credito as dolares_dif
            from clientes
            where 1=0; 
    
    for r_clientes in select * from clientes order by nomb_cliente
    loop
    
    
        ldc_quintales       =   0;
        ldc_dolares         =   0;
        ldc_quintales_2011  =   0;
        ldc_dolares_2011    =   0;
        
        select into ldc_quintales sum(quintales)
        from v_ventas_x_cliente_harinas
        where anio between 2009 and 2010
        and cliente = r_clientes.cliente;

        select into ldc_dolares sum(venta)
        from v_ventas_x_cliente_harinas
        where anio between 2009 and 2010
        and cliente = r_clientes.cliente;

        select into ldc_quintales_2011 sum(quintales)
        from v_ventas_x_cliente_harinas
        where anio between 2011 and 2012
        and cliente = r_clientes.cliente;

        select into ldc_dolares_2011 sum(venta)
        from v_ventas_x_cliente_harinas
        where anio between 2011 and 2012
        and cliente = r_clientes.cliente;
        
        
        if ldc_quintales is null then
            ldc_quintales = 0;
        end if;
        
        if ldc_dolares is null then
            ldc_dolares = 0;
        end if;
        
        if ldc_quintales_2011 is null then
            ldc_quintales_2011 = 0;
        end if;
        
        if ldc_dolares_2011 is null then
            ldc_dolares_2011 = 0;
        end if;

        ldc_quintales_dif   =   ldc_quintales_2011 - ldc_quintales;
        ldc_dolares_dif     =   ldc_dolares_2011 - ldc_dolares;
        
        insert into tmp_cltes_bajaron_vtas values(r_clientes.nomb_cliente,
            r_clientes.cliente, ldc_quintales, ldc_dolares, 
            ldc_quintales_2011, ldc_dolares_2011, ldc_quintales_dif, ldc_dolares_dif);
            
        
        
    end loop;
   
    return 1; 
end;
' language plpgsql;    
