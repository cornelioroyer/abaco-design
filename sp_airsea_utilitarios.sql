
drop function f_cargar_agentes() cascade;

drop function f_update_agentes() cascade;

drop function f_update_paises() cascade;


drop function f_update_agrupaciones_clientes_airsea() cascade;


create function f_update_agrupaciones_clientes_airsea() returns integer as '
declare
    r_clientes record;
    r_clientes_agrupados record;
    r_gral_grupos_aplicacion record;
    r_gral_valor_grupos record;
    li_count integer;
begin

/*
    delete from clientes_agrupados
    using gral_valor_grupos
    where clientes_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
    and gral_valor_grupos.aplicacion <> ''CXC'';
*/    
    
    for r_clientes in select * from clientes order by cliente
    loop
        for r_gral_grupos_aplicacion in select * from gral_grupos_aplicacion
                                    where aplicacion = ''CXC''
                                    order by secuencia, grupo
        loop
            select into r_clientes_agrupados *
            from clientes_agrupados, gral_valor_grupos
            where clientes_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
            and gral_valor_grupos.grupo = r_gral_grupos_aplicacion.grupo
            and clientes_agrupados.cliente = r_clientes.cliente;
            if not found then
                for r_gral_valor_grupos in select * from gral_valor_grupos
                                            where grupo = r_gral_grupos_aplicacion.grupo
                                            and aplicacion = r_gral_grupos_aplicacion.aplicacion
                                            order by codigo_valor_grupo
                loop
                    exit;
                end loop;
                
                if r_clientes.cuenta = ''1103''
                    and r_gral_grupos_aplicacion.grupo = ''CLA'' then
                    
                    r_gral_valor_grupos.codigo_valor_grupo = ''03'';
                    
                end if;
                
                insert into clientes_agrupados(cliente, codigo_valor_grupo)
                values(r_clientes.cliente, r_gral_valor_grupos.codigo_valor_grupo);
            else
                li_count = 0;
                select into li_count Count(*)
                from clientes_agrupados, gral_valor_grupos
                where clientes_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
                and gral_valor_grupos.grupo = r_gral_grupos_aplicacion.grupo
                and clientes_agrupados.cliente = r_clientes.cliente;
                if li_count > 1 then
                    delete from clientes_agrupados
                    using gral_valor_grupos
                    where clientes_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
                    and gral_valor_grupos.grupo = r_gral_grupos_aplicacion.grupo;
                end if;

                if r_clientes.cuenta = ''1103''
                    and r_gral_grupos_aplicacion.grupo = ''CLA'' 
                    and r_clientes_agrupados.codigo_valor_grupo = ''01'' then
                    
                    update clientes_agrupados
                    set codigo_valor_grupo = ''03''
                    from gral_valor_grupos, gral_grupos_aplicacion, clientes
                    where gral_valor_grupos.grupo = gral_grupos_aplicacion.grupo
                    and clientes_agrupados.cliente = clientes.cliente
                    and clientes_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
                    and clientes.cuenta = ''1103''
                    and gral_grupos_aplicacion.aplicacion = ''CXC''
                    and gral_grupos_aplicacion.grupo = ''CLA''
                    and clientes_agrupados.cliente = r_clientes.cliente;
                    
                end if;
                
                
            end if;
        end loop;
    end loop;
    return 1;
end;
' language plpgsql;



create function f_update_paises() returns integer as '
declare
    r_tmp_agentes record;
    r_tmp_ciudades record;
    r_clientes record;
    r_work record;
    r_fac_paises record;
    r_fac_ciudades record;
    lvc_codigo varchar(100);
    lvc_pais varchar(10);
    lvc_ciudad varchar(10);
begin

    for r_tmp_ciudades in 
        select * from tmp_ciudades
        order by pais
    loop
        lvc_ciudad  =   substring(trim(r_tmp_ciudades.codigo_ciudad) from 1 for 5);
        lvc_pais    =   substring(trim(lvc_ciudad) from 1 for 2);
        
--        raise exception ''%'', lvc_pais;
        
        select into r_fac_paises *
        from fac_paises
        where trim(pais) = trim(lvc_pais);
        if not found then
            update fac_paises
            set pais = trim(lvc_pais)
            where trim(pais) = trim(r_tmp_ciudades.pais);
        end if;

        select into r_fac_ciudades *
        from fac_ciudades
        where trim(ciudad) = trim(lvc_ciudad);
        if not found then
            update fac_ciudades
            set ciudad = trim(lvc_ciudad)
            where trim(ciudad) = trim(r_tmp_ciudades.ciudad);
        end if;

                
    end loop;
    
    return 1;
end;
' language plpgsql;



create function f_update_agentes() returns integer as '
declare
    r_tmp_agentes record;
    r_clientes record;
    r_work record;
    lvc_codigo varchar(100);
begin

    for r_tmp_agentes in 
        select * from tmp_agentes 
        order by codigo
    loop
        select into r_clientes *
        from clientes
        where trim(cliente) = trim(r_tmp_agentes.codigo);
        if found then
            if trim(r_clientes.nomb_cliente) <> trim(r_tmp_agentes.nombre) then
                update clientes
                set nomb_cliente = trim(r_tmp_agentes.nombre)
                where trim(cliente) = trim(r_tmp_agentes.codigo);
            end if;
        else
                    insert into clientes(cliente, forma_pago, cuenta, cli_cliente, 
                    vendedor, nomb_cliente, fecha_apertura, status,
                    usuario, fecha_captura, tel1_cliente, direccion1, limite_credito,
                    promedio_dias_cobro, estado_cuenta, categoria_abc, dv, 
                    tipo_de_persona, concepto, tipo_de_compra) 
                    values
                    (trim(r_tmp_agentes.codigo), ''30'', ''1103'', 
                    trim(r_tmp_agentes.codigo),
                    ''00'', trim(r_tmp_agentes.nombre), current_date,
                    ''A'', current_user, current_timestamp, ''123'',
                    ''PONER DIRECCION'', 999999, 0, ''S'', ''A'',''00'', ''1'',''1'',''1'');
                    
        end if;        
    end loop;
    
    return 1;
end;
' language plpgsql;




create function f_cargar_agentes() returns integer as '
declare
    r_tmp_agentes record;
    r_clientes record;
    r_work record;
    lvc_codigo varchar(100);
begin

    for r_tmp_agentes in 
        select * from tmp_agentes 
        order by codigo
    loop
        if substring(trim(r_tmp_agentes.codigo_abaco) from 1 for 5) = ''Activ'' then
/*        
            select into r_clientes *
            from clientes
            where trim(cliente) = trim(r_tmp_agentes.codigo);
            if not found then
                insert into clientes(cliente, forma_pago, cuenta, cli_cliente, 
                vendedor, nomb_cliente, fecha_apertura, status,
                usuario, fecha_captura, tel1_cliente, direccion1, limite_credito,
                promedio_dias_cobro, estado_cuenta, categoria_abc, dv, 
                tipo_de_persona, concepto, tipo_de_compra) 
                values
                (trim(r_tmp_agentes.codigo), ''30'', ''1103'', 
                trim(r_tmp_agentes.codigo),
                ''00'', trim(r_tmp_agentes.nombre), current_date,
                ''A'', current_user, current_timestamp, ''123'',
                ''PONER DIRECCION'', 999999, 0, ''S'', ''A'',''00'', ''1'',''1'',''1'');
            else
                if trim(r_tmp_agentes.nombre) <> trim(r_clientes.nomb_cliente) then
                    update clientes
                    set cliente = trim(cliente) || ''OLD''
                    where trim(cliente) = trim(r_tmp_agentes.codigo);
                    
                    insert into clientes(cliente, forma_pago, cuenta, cli_cliente, 
                    vendedor, nomb_cliente, fecha_apertura, status,
                    usuario, fecha_captura, tel1_cliente, direccion1, limite_credito,
                    promedio_dias_cobro, estado_cuenta, categoria_abc, dv, 
                    tipo_de_persona, concepto, tipo_de_compra) 
                    values
                    (trim(r_tmp_agentes.codigo), ''30'', ''1103'', 
                    trim(r_tmp_agentes.codigo),
                    ''00'', trim(r_tmp_agentes.nombre), current_date,
                    ''A'', current_user, current_timestamp, ''123'',
                    ''PONER DIRECCION'', 999999, 0, ''S'', ''A'',''00'', ''1'',''1'',''1'');
                    
                end if;
            end if;
*/
            
        else
            lvc_codigo  =   trim(substring(trim(r_tmp_agentes.codigo_abaco) from 2 for 20));
            select into r_clientes *
            from clientes
            where trim(cliente) = trim(lvc_codigo);
            if found then
                select into r_work * from clientes
                where trim(cliente) = trim(r_tmp_agentes.codigo);
                if found then
            
                    update clientes
                    set cliente = trim(cliente) || ''OLD'',
                        cli_cliente = trim(cliente) || ''OLD''
                    where trim(cliente) = trim(r_tmp_agentes.codigo);
                    
                    
                    update clientes
                    set cliente = trim(r_tmp_agentes.codigo),
                    cli_cliente = trim(r_tmp_agentes.codigo)
                    where trim(cliente) = trim(lvc_codigo);
                    
                end if;
            end if;            
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;
