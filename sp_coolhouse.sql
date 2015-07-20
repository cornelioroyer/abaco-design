/*
drop function f_eys2_after_insert_cooldragon() cascade;
*/

drop function f_update_precios(char(2));
drop function f_poner_categoria();
drop function f_crear_auxiliares() cascade;
drop function f_crear_y_borrar_agrupaciones() cascade;
drop function f_crear_pla_afectacion_contable() cascade;
drop function f_ajustar_codigo_proveedor() cascade;
drop function f_articulos_after_insert_coolhouse() cascade;
drop function f_cambio_de_codigo_de_cliente() cascade;


create function f_cambio_de_codigo_de_cliente() returns integer as '
declare
    r_clientes record;
    r_work record;
    lc_cliente char(10);
begin
    for r_clientes in select * from clientes
                        where id is not null
                        and tipo_de_persona = ''1''
                       order by cliente
    loop
        lc_cliente = SubString(Trim(r_clientes.id) from 1 for 10);
        
        select into r_work * from clientes
        where cliente = lc_cliente;
        if not found then
            update clientes
            set cliente = lc_cliente, cli_cliente = lc_cliente
            where cliente = r_clientes.cliente;
        end if;        
    end loop;
    return 1;
end;
' language plpgsql;



create function f_ajustar_codigo_proveedor() returns integer as '
declare
    r_proveedores record;
    r_work record;
    lb_work boolean;
    li_work integer;
    lc_proveedor char(6);
begin
    li_work = 0;
    for r_proveedores in select * from proveedores 
                            where length(trim(proveedor)) > 4
                            order by proveedor
    loop
        lb_work = true;
        while lb_work loop
            li_work = li_work + 1;
            lc_proveedor = trim(to_char(li_work,''0000''));
            select into r_work * from proveedores
            where trim(proveedor) = trim(lc_proveedor);
            if not found then
                lb_work = false;
            end if;
        end loop;
        
        update proveedores
        set proveedor = lc_proveedor
        where proveedor = r_proveedores.proveedor;
    end loop;
    return 1;
end;
' language plpgsql;





create function f_crear_pla_afectacion_contable() returns integer as '
declare
    r_departamentos record;
    r_nomconce record;
    r_pla_afectacion_contable record;
    li_count integer;
begin
    for r_departamentos in select * from departamentos order by codigo
    loop
        for r_nomconce in select * from nomconce order by cod_concepto_planilla
        loop
            if r_nomconce.tipodeconcepto = ''R'' then
                li_count = 0;
                select into li_count count(*)
                from pla_afectacion_contable
                where departamento = r_departamentos.codigo
                and cod_concepto_planilla = r_nomconce.cod_concepto_planilla;
                if li_count is null then
                    li_count = 0;
                end if;
                if li_count = 0 then
                    insert into pla_afectacion_contable(departamento, cuenta,
                        cod_concepto_planilla, porcentaje)
                    values(r_departamentos.codigo, ''8041040'',
                        r_nomconce.cod_concepto_planilla, 100);
                
                    insert into pla_afectacion_contable(departamento, cuenta,
                        cod_concepto_planilla, porcentaje)
                    values(r_departamentos.codigo, ''2300111'',
                        r_nomconce.cod_concepto_planilla, 100);
                else
                    select into r_pla_afectacion_contable * from pla_afectacion_contable
                    where departamento = r_departamentos.codigo
                    and cuenta = ''2300111''
                    and cod_concepto_planilla = r_nomconce.cod_concepto_planilla;
                    if not found then
                        insert into pla_afectacion_contable(departamento, cuenta,
                            cod_concepto_planilla, porcentaje)
                        values (r_departamentos.codigo, ''2300111'',
                            r_nomconce.cod_concepto_planilla, 100);
                    else
                        select into r_pla_afectacion_contable *
                        from pla_afectacion_contable
                        where departamento = r_departamentos.codigo
                        and cuenta = ''8041040''
                        and cod_concepto_planilla = r_nomconce.cod_concepto_planilla;
                        if not found then
                            insert into pla_afectacion_contable(departamento, cuenta,
                                cod_concepto_planilla, porcentaje)
                            values(r_departamentos.codigo, ''8041040'',
                                r_nomconce.cod_concepto_planilla, 100);
                        end if;                    
                    end if;
                end if;
            else
                select into r_pla_afectacion_contable *
                from pla_afectacion_contable
                where departamento = r_departamentos.codigo
                and cod_concepto_planilla = r_nomconce.cod_concepto_planilla;
                if not found then
                    insert into pla_afectacion_contable(departamento, cuenta,
                        cod_concepto_planilla, porcentaje)
                    values(r_departamentos.codigo, ''8041010'',
                        r_nomconce.cod_concepto_planilla, 100);
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
                if r_gral_grupos_aplicacion.grupo = ''CAT'' then
                    r_gral_valor_grupos.codigo_valor_grupo = ''RE'';
                end if;
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



create function f_crear_auxiliares() returns integer as '
declare
    r_clientes record;
    r_proveedores record;
    r_rhuempl record;
    r_cglauxiliares record;
begin
    for r_clientes in select * from clientes order by cliente
    loop
        select into r_cglauxiliares * from cglauxiliares
        where Trim(auxiliar) = trim(r_clientes.cliente);
        if not found then
            insert into cglauxiliares(auxiliar, nombre, status, tipo_persona, id, dv)
            values (Trim(r_clientes.cliente), Trim(r_clientes.nomb_cliente), ''A'', r_clientes.tipo_de_persona, r_clientes.id, r_clientes.dv);
        else
            update cglauxiliares
            set nombre = Trim(r_clientes.nomb_cliente), id = r_clientes.id, dv = r_clientes.dv, tipo_persona = r_clientes.tipo_de_persona
            where Trim(auxiliar) = trim(r_clientes.cliente);
        end if;
    end loop;
    
    for r_proveedores in select * from proveedores order by proveedor
    loop
        select into r_cglauxiliares * from cglauxiliares
        where Trim(auxiliar) = trim(r_proveedores.proveedor);
        if not found then
            insert into cglauxiliares(auxiliar, nombre, status, tipo_persona, id, dv)
            values (Trim(r_proveedores.proveedor), Trim(r_proveedores.nomb_proveedor), ''A'', r_proveedores.tipo_de_persona, r_proveedores.id_proveedor, r_proveedores.dv_proveedor);
        else
            update cglauxiliares
            set nombre = Trim(r_proveedores.nomb_proveedor),
            id = r_proveedores.id_proveedor, dv = r_proveedores.dv_proveedor, tipo_persona = r_proveedores.tipo_de_persona
            where Trim(auxiliar) = trim(r_proveedores.proveedor);
        end if;
        
    end loop;


    for r_rhuempl in select * from rhuempl order by codigo_empleado
    loop
        select into r_cglauxiliares * from cglauxiliares
        where Trim(auxiliar) = trim(r_rhuempl.codigo_empleado);
        if not found then
            insert into cglauxiliares(auxiliar, nombre, status, tipo_persona, id, dv)
            values (Trim(r_rhuempl.codigo_empleado), Trim(r_rhuempl.nombre_de_empleado), ''A'', ''1'', r_rhuempl.numero_cedula, r_rhuempl.dv);
        else
            update cglauxiliares
            set nombre = Trim(r_rhuempl.nombre_del_empleado),
            id = r_rhuempl.numero_cedula, dv = r_rhuempl.dv, tipo_persona = ''1''
            where Trim(auxiliar) = trim(r_rhuempl.codigo_empleado);
        end if;
    end loop;

    
    return 1;
end;
' language plpgsql;


create function f_poner_categoria() returns integer as '
declare
    r_articulos record;
    r_gral_valor_grupos record;
    r_articulos_agrupados record;
    r_tmp_articulos record;
begin
    for r_articulos in select * from articulos order by articulo
    loop
        select into r_tmp_articulos *
        from tmp_articulos
        where trim(tmp_articulos.codigo) = trim(r_articulos.articulo);
        if found then
            if r_tmp_articulos.categoria is not null then
                select into r_gral_valor_grupos * from gral_valor_grupos
                where codigo_valor_grupo = trim(r_tmp_articulos.categoria)
                and grupo = ''CAT'';
                if found then
                    insert into articulos_agrupados(articulo, codigo_valor_grupo)
                    values(r_articulos.articulo, trim(r_tmp_articulos.categoria));
                end if;
            end if;
        end if;
    end loop;
    return 1;
end;
' language plpgsql;


create function f_update_precios(char(2)) returns integer as '
declare
    as_cia alias for $1;
    r_inv_margenes_x_grupo record;
    r_articulos_por_almacen record;
    ldc_precio_minimo decimal(10,2);
    ldc_cu decimal(10,2);
    ldc_precio decimal(10,2);
begin
    for r_inv_margenes_x_grupo in select inv_margenes_x_grupo.* from almacen, inv_margenes_x_grupo 
                                    where almacen.almacen = inv_margenes_x_grupo.almacen
                                    and almacen.compania = as_cia
                                    order by codigo_valor_grupo
    loop
        for r_articulos_por_almacen in select articulos_por_almacen.*
                                        from articulos_agrupados, articulos_por_almacen
                                        where articulos_agrupados.articulo = articulos_por_almacen.articulo
                                        and articulos_por_almacen.almacen = r_inv_margenes_x_grupo.almacen
                                        and articulos_agrupados.codigo_valor_grupo = r_inv_margenes_x_grupo.codigo_valor_grupo
        loop
             ldc_cu = f_stock(r_articulos_por_almacen.almacen, r_articulos_por_almacen.articulo, 
                        current_date, 0, 0, ''CU'');
             ldc_precio_minimo = ldc_cu / ((100 - r_inv_margenes_x_grupo.margen) / 100);

             update articulos_por_almacen
             set precio_minimo = ldc_precio_minimo
             where almacen = r_articulos_por_almacen.almacen
             and articulo = r_articulos_por_almacen.articulo;
             
             if r_articulos_por_almacen.precio_venta >= 50000 and ldc_cu > 0 then
                ldc_precio = ldc_cu / ((100.00-60.00)/100.00);
                
                 
                 update articulos_por_almacen
                 set precio_venta = ldc_precio
                 where almacen = r_articulos_por_almacen.almacen
                 and articulo = r_articulos_por_almacen.articulo;
                
             end if;
             
        end loop;
    end loop;
    return 1;
end;
' language plpgsql;


create function f_articulos_after_insert_coolhouse() returns trigger as '
declare
r_gral_grupos_aplicacion record;
r_gral_valor_grupos record;
r_articulos_agrupados record;
r_articulos_por_almacen record;
li_sw integer;
begin
    if new.servicio = ''N'' then
        select into r_articulos_por_almacen *
        from articulos_por_almacen
        where almacen = ''01''
        and Trim(articulo) = Trim(new.articulo);
        if not found then
            insert into articulos_por_almacen (almacen, articulo, cuenta, precio_venta,
            minimo, maximo, usuario, fecha_captura, dias_piso, existencia, costo, precio_fijo, precio_minimo) 
            values (''01'',Trim(new.articulo),''1101000'',99999,0,0,current_user,current_timestamp,1,0,0,''N'', 0);
        end if;
    end if;
    return new;
end;
' language plpgsql;


create trigger t_articulos_after_insert_coolhouse after insert or update on articulos
for each row execute procedure f_articulos_after_insert_coolhouse();


/*
create function f_eys2_after_insert_cooldragon() returns trigger as '
declare
    r_eys1 record;
    r_articulos_por_almacen record;
    ldc_cu decimal;
    ldc_precio decimal;
begin
    select into r_eys1 * from eys1
    where almacen = new.almacen
    and no_transaccion = new.no_transaccion;
    if r_eys1.aplicacion_origen = ''COM'' then
        if new.cantidad > 0 and new.costo > 0 then
            ldc_cu  =   new.costo / new.cantidad;
            
            select into r_articulos_por_almacen *
            from articulos_por_almacen
            where almacen = new.almacen
            and articulo = new.articulo;
            
            ldc_precio  =   ldc_cu * 2.2;
            
--            if ldc_precio > r_articulos_por_almacen.precio_venta then
                update articulos_por_almacen
                set precio_venta = ldc_precio
                where almacen = new.almacen
                and articulo = new.articulo;
--            end if;            
           
        end if;   
    end if;
    return new;
end;
' language plpgsql;

create trigger t_eys2_after_insert_cooldragon after insert on eys2
for each row execute procedure f_eys2_after_insert_cooldragon();
*/
