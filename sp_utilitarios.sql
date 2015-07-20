
drop function f_fix_cglsldoaux1(char(2), char(24)) cascade;
drop function f_update_balance_inicio(char(2)) cascade;
drop function f_incosistencia_en_cxp(char(2)) cascade;
-- drop function f_update_invbalance(char(2)) cascade;
drop function f_crear_y_borrar_agrupaciones() cascade;
drop function f_crear_y_borrar_agrupaciones_clientes() cascade;
drop function f_fix_factura3(char(2), char(3), char(3), integer) cascade;
drop function f_cambio_codigo_destinos() cascade;
drop function f_cargar_nuevas_cuentas() cascade;


create function f_cargar_nuevas_cuentas() returns integer as '
declare
    r_tmp_cglcuentas record;
    r_cglcuentas record;
    i integer;
begin

    for r_tmp_cglcuentas in select * from tmp_cglcuentas
                            where cuenta is not null and nombre is not null
                            order by cuenta
    loop
    
        select into r_cglcuentas *
        from cglcuentas
        where trim(cuenta) = trim(r_tmp_cglcuentas.cuenta);
        if not found then
            insert into cglcuentas (cuenta, nombre, nivel, naturaleza, auxiliar_1, auxiliar_2, 
            efectivo, tipo_cuenta, status)
            values(trim(r_tmp_cglcuentas.cuenta), trim(r_tmp_cglcuentas.nombre),
                ''3'', 1, ''N'', ''N'', ''N'', ''B'', ''A'');
        else
            update cglcuentas
            set nombre = trim(r_tmp_cglcuentas.nombre)
            where trim(cuenta) = trim(r_tmp_cglcuentas.cuenta);
        end if;
        
    end loop;
    
    return 1;    
end;
' language plpgsql;




create function f_cambio_codigo_destinos() returns integer as '
declare
    r_tmp_destinos record;
    r_destinos record;
    i integer;
begin

    for r_tmp_destinos in select * from tmp_destinos 
                            where cod_destino is not null and cod_destino_new is not null
                            order by cod_destino
    loop
        select into r_destinos *
        from destinos
        where trim(cod_destino) = trim(r_tmp_destinos.cod_destino_new);
        if found then
            continue;
        end if;
        update destinos
        set cod_destino = trim(r_tmp_destinos.cod_destino_new)
        where trim(cod_destino) = trim(r_tmp_destinos.cod_destino);
    end loop;
    
    return 1;    
end;
' language plpgsql;



create function f_fix_factura3(char(2), char(3), char(3), integer) returns integer as '
declare
    ac_almacen alias for $1;
    ac_caja alias for $2;
    ac_tipo alias for $3;
    ai_num_documento alias for $4;
    r_factura2 record;
    i integer;
begin

    delete from factura3
    where almacen = ac_almacen
    and caja = ac_caja
    and tipo = ac_tipo
    and num_documento = ai_num_documento;
    
    for r_factura2 in select * from factura2
                        where almacen = ac_almacen
                        and caja = ac_caja
                        and tipo = ac_tipo
                        and num_documento = ai_num_documento
    loop
        
        
        i = f_factura2_factura3(r_factura2.almacen, r_factura2.tipo,
                r_factura2.num_documento, r_factura2.caja, r_factura2.linea);        
        
    end loop;
    
    return 1;    
end;
' language plpgsql;



create function f_crear_y_borrar_agrupaciones_clientes() returns integer as '
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
            end if;
        end loop;
    end loop;
    return 1;
end;
' language plpgsql;



create function f_crear_y_borrar_agrupaciones() returns integer as '
declare
    r_articulos record;
    r_gral_valor_grupos record;
    r_articulos_agrupados record;
    r_gral_grupos_aplicacion record;
    li_count integer;
begin
    for r_articulos in select * from articulos order by articulo
    loop
        for r_gral_grupos_aplicacion in select * from gral_grupos_aplicacion
                                    where aplicacion = ''INV''
                                    order by secuencia, grupo
        loop
            select into r_articulos_agrupados *
            from articulos_agrupados, gral_valor_grupos
            where articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
            and gral_valor_grupos.grupo = r_gral_grupos_aplicacion.grupo
            and articulos_agrupados.articulo = r_articulos.articulo;
            if not found then
                for r_gral_valor_grupos in select * from gral_valor_grupos
                                            where grupo = r_gral_grupos_aplicacion.grupo
                                            order by codigo_valor_grupo
                loop
                    exit;
                end loop;
                insert into articulos_agrupados(articulo, codigo_valor_grupo)
                values(r_articulos.articulo, r_gral_valor_grupos.codigo_valor_grupo);
            else
                li_count = 0;
                select into li_count Count(*)
                from articulos_agrupados, gral_valor_grupos
                where articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
                and gral_valor_grupos.grupo = r_gral_grupos_aplicacion.grupo
                and articulos_agrupados.articulo = r_articulos.articulo;
                if li_count > 1 then
                    delete from articulos_agrupados
                    using gral_valor_grupos
                    where articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
                    and gral_valor_grupos.grupo = r_gral_grupos_aplicacion.grupo;
                end if;
            end if;
        end loop;
    end loop;
    return 1;
end;
' language plpgsql;

/*
create function f_update_invbalance(char(2)) returns integer as '
declare
    as_compania alias for $1;
    r_cxpdocm record;
    ld_fecha date;
    r_work record;
    r_invbalance record;
begin
    for r_work in select anio, mes from v_eys1_eys2
        group by 1, 2
        order by 1, 2
    loop;
        delete from invbalance
        where compania = as_compania
        and year = r_work.anio
        and periodo = r_work.mes;
        
        
    end loop;
    delete from tmp_matame;
    for r_cxpdocm in select * from cxpdocm
                        where documento = docmto_aplicar and motivo_cxp = motivo_cxp_ref
                        and compania = as_compania
                        order by fecha_posteo
    loop
        select into ld_fecha Min(fecha_posteo)
        from cxpdocm
        where compania = r_cxpdocm.compania
        and proveedor = r_cxpdocm.proveedor
        and docmto_aplicar = r_cxpdocm.documento
        and docmto_aplicar_ref = r_cxpdocm.documento
        and motivo_cxp_ref = r_cxpdocm.motivo_cxp;
        if not found then
            continue;
        else
            if ld_fecha < r_cxpdocm.fecha_posteo then
                insert into tmp_matame (documento) values (r_cxpdocm.documento);
            end if;
        end if;
        
    end loop;
    return 1;
end;
' language plpgsql;
*/



create function f_incosistencia_en_cxp(char(2)) returns integer as '
declare
    as_compania alias for $1;
    r_cxpdocm record;
    ld_fecha date;
begin
    delete from tmp_matame;
    for r_cxpdocm in select * from cxpdocm
                        where documento = docmto_aplicar and motivo_cxp = motivo_cxp_ref
                        and compania = as_compania
                        order by fecha_posteo
    loop
        select into ld_fecha Min(fecha_posteo)
        from cxpdocm
        where compania = r_cxpdocm.compania
        and proveedor = r_cxpdocm.proveedor
        and docmto_aplicar = r_cxpdocm.documento
        and docmto_aplicar_ref = r_cxpdocm.documento
        and motivo_cxp_ref = r_cxpdocm.motivo_cxp;
        if not found then
            continue;
        else
            if ld_fecha < r_cxpdocm.fecha_posteo then
                insert into tmp_matame (documento) values (r_cxpdocm.documento);
            end if;
        end if;
        
    end loop;
    return 1;
end;
' language plpgsql;



create function f_update_balance_inicio(char(2)) returns integer as '
declare
    as_compania alias for $1;
    ldc_balance_inicio decimal(10,2);
    r_gralperiodos record;
    r_cglsldocuenta record;
    r_cglsldoaux1 record;
    r_cglcuentas record;
    r_work record;
    ld_work date;
    li_next_year integer;
    li_next_periodo integer;
begin
    select into ld_work Min(inicio) from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and estado = ''A'';
    if not found then
        return 0;
    end if;
    
    for r_gralperiodos in select * from gralperiodos
                        where compania = as_compania
                        and aplicacion = ''CGL''
                        and inicio between ''2000-12-01'' and ''2010-12-31''
                        order by inicio
    loop
        li_next_year = r_gralperiodos.year;
        li_next_periodo = r_gralperiodos.periodo + 1;
        if li_next_periodo > 13 then
            li_next_periodo = 1;
            li_next_year = r_gralperiodos.year + 1;
        end if;
        
        update cglsldocuenta
        set balance_inicio = 0
        where compania = as_compania
        and year = li_next_year
        and periodo = li_next_periodo;
        
        update cglsldoaux1
        set balance_inicio = 0
        where compania = as_compania
        and year = li_next_year
        and periodo = li_next_periodo;
        
        for r_cglsldocuenta in select cglsldocuenta.* from cglsldocuenta
                                where cglsldocuenta.compania = as_compania
                                and cglsldocuenta.year = r_gralperiodos.year
                                and cglsldocuenta.periodo = r_gralperiodos.periodo
                                order by cglsldocuenta.cuenta
        loop
            ldc_balance_inicio = r_cglsldocuenta.balance_inicio + r_cglsldocuenta.debito - r_cglsldocuenta.credito;
            
            select into r_work * from cglsldocuenta
            where compania = as_compania
            and cuenta = r_cglsldocuenta.cuenta
            and year = li_next_year
            and periodo = li_next_periodo;
            if not found then
                insert into cglsldocuenta (compania, cuenta, year, periodo, balance_inicio,
                    debito, credito)
                values (as_compania, r_cglsldocuenta.cuenta,
                        li_next_year, li_next_periodo, ldc_balance_inicio, 0, 0);
            else
                update cglsldocuenta
                set balance_inicio = ldc_balance_inicio
                where compania = as_compania
                and cuenta = r_cglsldocuenta.cuenta
                and year = li_next_year
                and periodo = li_next_periodo;
            end if;
            
            for r_cglsldoaux1 in select cglsldoaux1.* from cglsldoaux1
                                    where cglsldoaux1.compania = as_compania
                                    and cglsldoaux1.year = r_gralperiodos.year
                                    and cglsldoaux1.periodo = r_gralperiodos.periodo
                                    and cglsldoaux1.cuenta = r_cglsldocuenta.cuenta
                                    order by cglsldoaux1.auxiliar
            loop
                ldc_balance_inicio = r_cglsldoaux1.balance_inicio + r_cglsldoaux1.debito - r_cglsldoaux1.credito;
                select into r_work * from cglsldoaux1
                where compania = as_compania
                and cuenta = r_cglsldoaux1.cuenta
                and auxiliar = r_cglsldoaux1.auxiliar
                and year = li_next_year
                and periodo = li_next_periodo;
                if not found then
                    insert into cglsldoaux1 (compania, cuenta, auxiliar, year, periodo, balance_inicio,
                        debito, credito)
                    values (as_compania, r_cglsldoaux1.cuenta, r_cglsldoaux1.auxiliar,
                            li_next_year, li_next_periodo, ldc_balance_inicio, 0, 0);
                else
                    update cglsldoaux1
                    set balance_inicio = ldc_balance_inicio
                    where compania = as_compania
                    and cuenta = r_cglsldoaux1.cuenta
                    and auxiliar = r_cglsldoaux1.auxiliar
                    and year = li_next_year
                    and periodo = li_next_periodo;
                end if;
            end loop;
        end loop;
        
        
    end loop;
    return 1;
end;
' language plpgsql;


create function f_fix_cglsldoaux1(char(2), char(24)) returns integer as '
declare
    ac_compania alias for $1;
    ac_cuenta alias for $2;
    r_work record;
    r_cglsldoaux1 record;
    r_cglsldocuenta record;
    ldc_balance_inicio decimal;
    li_year integer;
    li_periodo integer;
    lc_auxiliar char(10);
    li_year_work integer;
    li_periodo_work integer;
begin
/*
    delete from cglsldoaux1
    where compania = ac_compania
    and cuenta = ac_cuenta;
    
    insert into cglsldoaux1(compania, cuenta, auxiliar, year, periodo,
                                    balance_inicio, debito, credito)    
    select cglposteo.compania, cglposteo.cuenta, 
    cglposteoaux1.auxiliar, 
    cglposteo.year, 
    cglposteo.periodo,  0, 
    sum(cglposteoaux1.debito), sum(cglposteoaux1.credito)
    where cglposteo.consecutivo = cglposteoaux1.consecutivo
    and cglposteo.compania = ac_compania
    and cglposteo.cuenta = ac_cuenta
    group by 1, 2, 3, 4, 5;    
*/

    update cglsldoaux1
    set balance_inicio = 0  
    where compania = ac_compania
    and cuenta = ac_cuenta;
    
    li_year = 0;
    li_periodo = 0; 
    lc_auxiliar = null;
    for r_cglsldoaux1 in select * from cglsldoaux1
                            where compania = ac_compania
                            and cuenta = ac_cuenta
                            order by auxiliar, year, periodo
    
    loop
        if lc_auxiliar is null or lc_auxiliar <> r_cglsldoaux1.auxiliar then
            lc_auxiliar = r_cglsldoaux1.auxiliar;
            ldc_balance_inicio = r_cglsldoaux1.debito - r_cglsldoaux1.credito;
        else
            ldc_balance_inicio = r_cglsldoaux1.debito - r_cglsldoaux1.credito + ldc_balance_inicio;
        end if;
        
        li_year = r_cglsldoaux1.year;
        li_periodo = r_cglsldoaux1.periodo + 1;
        if li_periodo > 13 then
            li_periodo = 1;
            li_year = li_year + 1;
        end if;
        
        
        select into r_work *
        from cglsldoaux1
        where compania = r_cglsldoaux1.compania
        and cuenta = r_cglsldoaux1.cuenta
        and auxiliar = r_cglsldoaux1.auxiliar
        and year = li_year
        and periodo = li_periodo;
        if not found then
            if li_year <= 2011 then
                insert into cglsldoaux1(compania, cuenta, auxiliar, year, periodo,
                                balance_inicio, debito, credito)
                values(r_cglsldoaux1.compania, r_cglsldoaux1.cuenta, r_cglsldoaux1.auxiliar,
                        li_year, li_periodo, ldc_balance_inicio, 0, 0);

                li_year_work = li_year;
                li_periodo_work = li_periodo;
            
                loop
                    li_periodo_work = li_periodo_work + 1;
                    if li_periodo_work > 13 then
                        li_periodo_work = 1;
                        li_year_work = li_year_work + 1;
                    end if;
                    
                    if li_year_work >= 2012 then
                        exit;
                    end if;
                    
                    select into r_work *
                    from cglsldoaux1
                    where compania = r_cglsldoaux1.compania
                    and cuenta = r_cglsldoaux1.cuenta
                    and auxiliar = r_cglsldoaux1.auxiliar
                    and year = li_year_work
                    and periodo = li_periodo_work;
                    if not found then
                        insert into cglsldoaux1(compania, cuenta, auxiliar, year, periodo,
                                        balance_inicio, debito, credito)
                        values(r_cglsldoaux1.compania, r_cglsldoaux1.cuenta, r_cglsldoaux1.auxiliar,
                                li_year_work, li_periodo_work, 1, 0, 0);
                    end if;                    
                    
                end loop;
            end if;
        else
            update cglsldoaux1
            set balance_inicio = ldc_balance_inicio
            where compania = r_cglsldoaux1.compania
            and cuenta = r_cglsldoaux1.cuenta
            and auxiliar = r_cglsldoaux1.auxiliar
            and year = li_year
            and periodo = li_periodo;
        end if;
        
    end loop;
    
    return 1;    
end;
' language plpgsql;
