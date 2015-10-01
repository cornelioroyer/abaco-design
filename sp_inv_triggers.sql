
-- set search_path to dba;

drop function f_articulos_after_insert() cascade;
drop function f_articulos_before_insert() cascade;

drop function f_eys1_before_update() cascade;
drop function f_eys1_before_delete() cascade;
drop function f_eys1_before_insert() cascade;

drop function f_eys2_before_insert() cascade;
drop function f_eys2_before_update() cascade;
drop function f_eys2_before_delete() cascade;
drop function f_eys2_after_insert() cascade;
drop function f_eys2_after_delete() cascade;
drop function f_eys2_after_update() cascade;
drop function f_eys2_eys6() cascade;

drop function f_factura2_eys2_delete() cascade;
drop function f_inv_fisico2_after_update() cascade;

drop function f_eys3_before_update() cascade;
drop function f_eys3_before_delete() cascade;

drop function f_eys4_after_delete() cascade;
drop function f_oc2_before_insert() cascade;
drop function f_rela_eys1_cglposteo_before_delete() cascade;
drop function f_articulos_agrupados_before_insert() cascade;


drop function f_articulos_por_almacen_before_insert() cascade;
drop function f_articulos_por_almacen_after_insert() cascade;
drop function f_articulos_por_almacen_after_update() cascade;
drop function f_invparal_before_update() cascade;
drop function f_eys3_before_insert() cascade;


create function f_eys3_before_insert() returns trigger as '
declare
    r_eys1 record;
    r_almacen record;
    ld_uif date;
    i integer;
begin

    i   =   f_valida_cuenta(new.cuenta, ''INV'');
    
    return new;
end;
' language plpgsql;



create function f_invparal_before_update() returns trigger as '
declare
    r_articulos record;
begin

    if trim(new.parametro) = ''valida_secuencia_fac'' then
        new.valor = ''S'';
    end if;

    return new;
end;
' language plpgsql;



create function f_articulos_before_insert() returns trigger as '
declare
    r_articulos record;
begin
    select into r_articulos * from articulos
    where trim(articulo) = trim(new.articulo);
    if found then
        raise exception ''Codigo de Articulo % ya existe '',new.articulo;
    end if;                
    return new;
end;
' language plpgsql;


create function f_articulos_agrupados_before_insert() returns trigger as '
declare
    r_articulos_agrupados record;
    r_gral_valor_grupos record;
begin
    select into r_gral_valor_grupos * from gral_valor_grupos
    where codigo_valor_grupo = new.codigo_valor_grupo;
    if not found then
        raise exception ''Codigo de Agrupacion % no Existe'',new.codigo_valor_grupo;
    end if;
    
    select into r_articulos_agrupados * from articulos_agrupados, gral_valor_grupos
    where articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
    and gral_valor_grupos.grupo = r_gral_valor_grupos.grupo
    and articulos_agrupados.articulo = new.articulo;
    if found then
        raise exception ''Ya Existe un Valor para esta Agrupacion %'',r_gral_valor_grupos.grupo;
    end if;
    
    return new;
end;
' language plpgsql;

create function f_articulos_after_insert() returns trigger as '
declare
r_gral_grupos_aplicacion record;
r_gral_valor_grupos record;
r_articulos_agrupados record;
li_sw integer;
begin
    for r_gral_grupos_aplicacion in 
            select * from gral_grupos_aplicacion
                where aplicacion = ''INV''
                order by secuencia, grupo
    loop
        select into r_articulos_agrupados *
        from articulos_agrupados
        where articulo = new.articulo
        and codigo_valor_grupo in
        (select codigo_valor_grupo from gral_valor_grupos
        where grupo = r_gral_grupos_aplicacion.grupo
        and aplicacion = r_gral_grupos_aplicacion.aplicacion);
        if not found then
            li_sw = 0;
            for r_gral_valor_grupos in
                        select * from gral_valor_grupos
                            where aplicacion = r_gral_grupos_aplicacion.aplicacion
                            and grupo = r_gral_grupos_aplicacion.grupo
                            order by codigo_valor_grupo
            loop
                if r_gral_valor_grupos.grupo = ''IVA'' then
                    r_gral_valor_grupos.codigo_valor_grupo = ''SI'';
                end if;
                if li_sw = 0 then
                    insert into articulos_agrupados (articulo, codigo_valor_grupo)
                    values (new.articulo, trim(r_gral_valor_grupos.codigo_valor_grupo));
                    li_sw = 1;
                end if;
            end loop;
        end if;
    end loop;
                
    return new;
end;
' language plpgsql;


create function f_eys1_before_delete() returns trigger as '
declare
    r_almacen record;
    i integer;
    ld_uif date;
begin
--    ld_uif = ''2014-11-28'';
    ld_uif = ''2014-11-28'';

    select into r_almacen * from almacen
    where almacen = old.almacen;

    if Trim(f_gralparaxcia(r_almacen.compania, ''PLA'', ''metodo_calculo'')) = ''coolhouse'' 
        and old.fecha < ld_uif then
        Raise Exception ''No se puede eliminar registros con fecha % el ultimo inventario fisico fue %'',old.fecha, ld_uif;
    end if;


    i = f_valida_fecha(r_almacen.compania, ''INV'', old.fecha);
    i = f_valida_fecha(r_almacen.compania, ''CGL'', old.fecha);

/*    
    delete from cglposteo
    where consecutivo in 
    (select consecutivo from rela_eys1_cglposteo
    where almacen = old.almacen
    and no_transaccion = old.no_transaccion);
    
    delete from rela_eys1_cglposteo
    where almacen = old.almacen
    and no_transaccion = old.no_transaccion;
*/    
    
    return old;
end;
' language plpgsql;


create function f_eys1_before_update() returns trigger as '
declare
    ls_tdt_consumo char(2);
    ls_tdt_produccion char(2);
    ls_metodo_calculo char(30);
    r_almacen record;
    ld_uif date;
begin
--    ld_uif = ''2014-11-28'';
    ld_uif = ''2014-11-28'';

    new.usuario         =   current_user;
    new.fecha_captura   =   current_timestamp;
    ls_tdt_consumo      = Trim(f_gralparaxapli(''INV'', ''tdt_consumo''));
    ls_tdt_produccion   = Trim(f_gralparaxapli(''INV'', ''tdt_produccion''));    

    select into r_almacen * from almacen
    where almacen = new.almacen;
    if not found then
        Raise Exception ''Almacen % no existe'',new.almacen;
    end if;

    if Trim(f_gralparaxcia(r_almacen.compania, ''PLA'', ''metodo_calculo'')) = ''coolhouse'' 
        and old.fecha < ld_uif then
        Raise Exception ''No se puede modificar registros con fecha % el ultimo inventario fisico fue %'',old.fecha, ld_uif;
    end if;

    
    ls_tdt_consumo      =   Trim(f_gralparaxapli(''INV'', ''tdt_consumo''));
    ls_tdt_produccion   =   Trim(f_gralparaxapli(''INV'', ''tdt_produccion''));    
    ls_metodo_calculo   =   Trim(f_gralparaxcia(r_almacen.compania, ''PLA'', ''metodo_calculo''));

    if (Trim(new.motivo) = Trim(ls_tdt_consumo)
        or Trim(new.motivo) = Trim(ls_tdt_produccion))
        and Trim(new.aplicacion_origen) <> ''COS'' 
        and Trim(ls_metodo_calculo) = ''harinas'' then
        Raise Exception ''Este tipo de transaccion % solo se utiliza en produccion'',new.motivo;
    end if;
    

    delete from rela_eys1_cglposteo
    where almacen = old.almacen
    and no_transaccion = old.no_transaccion;

    return new;
end;
' language plpgsql;


create function f_eys1_before_insert() returns trigger as '
declare
    r_eys1 record;
    ls_tdt_produccion char(2);
    ls_tdt_consumo char(2);
    ls_metodo_calculo char(30);
    r_almacen record;
    ld_uif date;
begin
--    ld_uif              =   ''2014-11-28'';
    ld_uif              =   ''2014-11-28'';
    new.usuario         =   current_user;
    new.fecha_captura   =   current_timestamp;

    select into r_almacen * from almacen
    where almacen = new.almacen;
    if not found then
        Raise Exception ''Almacen % no existe'',new.almacen;
    end if;
    
    ls_tdt_consumo      =   Trim(f_gralparaxapli(''INV'', ''tdt_consumo''));
    ls_tdt_produccion   =   Trim(f_gralparaxapli(''INV'', ''tdt_produccion''));    
    ls_metodo_calculo   =   Trim(f_gralparaxcia(r_almacen.compania, ''PLA'', ''metodo_calculo''));

    if trim(ls_metodo_calculo) = ''coolhouse'' and new.fecha < ld_uif then
        Raise Exception ''No se puede agregar registros a inventario con fecha % el ultimo inventario fisico fue %'',new.fecha, ld_uif;
    end if;

    if (Trim(new.motivo) = Trim(ls_tdt_consumo)
        or Trim(new.motivo) = Trim(ls_tdt_produccion))
        and Trim(new.aplicacion_origen) <> ''COS'' 
        and Trim(ls_metodo_calculo) = ''harinas'' then
        Raise Exception ''Este tipo de transaccion % solo se utiliza en produccion'',new.motivo;
    end if;
        


    while 1=1 loop
        select into r_eys1 * from eys1
        where almacen = new.almacen
        and no_transaccion = new.no_transaccion;
        if not found then
            return new;
        else
            new.no_transaccion = new.no_transaccion + 1;
        end if;
    end loop;

    return new;
end;
' language plpgsql;


create function f_eys2_before_delete() returns trigger as '
declare
    r_eys1 record;
    r_almacen record;
    r_work record;
    i integer;
    ld_uif date;
begin
--    ld_uif = ''2014-11-28'';
    ld_uif = ''2014-11-28'';
    
    select into r_almacen * from almacen
    where almacen = old.almacen;
    
    select into r_eys1 * from eys1
    where almacen = old.almacen
    and no_transaccion = old.no_transaccion;
    if found then
        i = f_valida_fecha(r_almacen.compania, ''INV'', r_eys1.fecha);
        i = f_valida_fecha(r_almacen.compania, ''CGL'', r_eys1.fecha);
        
        if Trim(f_gralparaxcia(r_almacen.compania, ''PLA'', ''metodo_calculo'')) = ''coolhouse'' 
            and r_eys1.fecha < ld_uif then
            Raise Exception ''No se puede eliminar registros con fecha % el ultimo inventario fisico fue %'',r_eys1.fecha, ld_uif;
        end if;
        
    end if;
    

    delete from rela_eys1_cglposteo
    where almacen = old.almacen
    and no_transaccion = old.no_transaccion;

    
    if old.proveedor is not null and f_invparal(old.almacen, ''valida_existencias'') = ''S'' then    
        select into r_work * from eys1, eys2, invmotivos
        where eys1.motivo = invmotivos.motivo
        and eys1.almacen = eys2.almacen
        and eys1.no_transaccion = eys2.no_transaccion
        and eys1.fecha > r_eys1.fecha
        and invmotivos.signo = -1
        and eys2.articulo = old.articulo;
        if found then
            raise exception ''Articulo % no puede ser eliminado...Tiene Egresos Posteriores'',old.articulo;
        end if;
    end if;
    
    
    return old;
end;
' language plpgsql;


create function f_eys2_before_update() returns trigger as '
begin

    delete from rela_eys1_cglposteo
    where almacen = old.almacen
    and no_transaccion = old.no_transaccion;
    
    return new;
end;
' language plpgsql;


create function f_eys2_before_insert() returns trigger as '
declare
    r_eys1 record;
    r_invmotivos record;
    r_eys2 record;
    r_cxpfact1 record;
    r_almacen record;
    r_articulos record;
    ldc_cantidad decimal;
    ldc_stock decimal;
    li_linea integer;
    i integer;
    ld_uif date;
begin
--    ld_uif = ''2014-11-28'';
    ld_uif = ''2014-11-28'';


    select into r_articulos *
    from articulos
    where trim(articulo) = trim(new.articulo);
    if not found then
        Raise Exception ''Articulo % no Existe'', new.articulo;
    else        
        if r_articulos.status_articulo = ''I'' then
            Raise Exception ''Articulo % esta inactivo'', new.articulo;
        end if;
    end if;
    
    select into r_eys1 * 
    from eys1
    where almacen = new.almacen
    and no_transaccion = new.no_transaccion;
    if not found then
        raise exception ''No existe transaccion % en el almacen % en la table eys1'',new.no_transaccion, new.almacen;
    else
        select into r_invmotivos * from invmotivos
        where motivo = r_eys1.motivo;
    end if;

    select into r_almacen * from almacen
    where almacen = r_eys1.almacen;

    
    if Trim(f_gralparaxcia(r_almacen.compania, ''PLA'', ''metodo_calculo'')) = ''coolhouse'' 
        and r_eys1.fecha < ld_uif then
        Raise Exception ''No se puede eliminar registros con fecha % el ultimo inventario fisico fue %'',r_eys1.fecha, ld_uif;
    end if;

    
    
    i = f_valida_fecha(r_almacen.compania, ''INV'', r_eys1.fecha);
    i = f_valida_fecha(r_almacen.compania, ''CGL'', r_eys1.fecha);
    
    
/*    
    if new.costo = 0 and r_invmotivos.costo = ''S'' then
        raise exception ''Costo es obligario'';
    end if;
*/    
    
    ldc_cantidad = r_invmotivos.signo * new.cantidad;
    if ldc_cantidad < 0 and f_invparal(new.almacen, ''valida_existencias'') = ''S'' then
        ldc_stock = f_stock(new.almacen, new.articulo, r_eys1.fecha, 0, 0, ''STOCK'') + ldc_cantidad;
        if ldc_stock < 0 then
            raise exception ''A esta fecha % No hay existencia % para este articulo % en el almacen %'',r_eys1.fecha, ldc_stock, new.articulo,new.almacen;
        end if;
        
        if current_date <> r_eys1.fecha then
            if f_stock(new.almacen, new.articulo, current_date, 0, 0, ''STOCK'') + ldc_cantidad < 0 then
                raise exception ''No hay existencia para este articulo % en el almacen %'',new.articulo,new.almacen;
            end if;
        end if;
    end if;
    
    if r_eys1.aplicacion_origen = ''COM'' or r_eys1.aplicacion_origen = ''TAL'' then
        li_linea = new.linea;
        while true loop
            select into r_eys2 * from eys2
            where almacen = new.almacen
            and articulo = new.articulo
            and no_transaccion = new.no_transaccion
            and linea = li_linea;
            if found then
                li_linea = li_linea + 1;
            else
                new.linea = li_linea;
                exit;
            end if;
        end loop;
    end if;
    
    if r_eys1.aplicacion_origen = ''COM'' then
        if new.fact_proveedor is null then
            raise exception ''Factura de proveedor es obligatoria'';
        end if;
        
        select into r_cxpfact1 * from cxpfact1
        where compania = new.compania
        and proveedor = new.proveedor
        and fact_proveedor = new.fact_proveedor;
        if not found then
            raise exception ''Factura % de proveedor no existe'',new.fact_proveedor;
        end if;
        
        if r_cxpfact1.fecha_posteo_fact_cxp <> r_eys1.fecha then
            raise exception ''Fecha debe ser igual a fecha de factura'';
        end if;
    end if;
    
    return new;
end;
' language plpgsql;



create function f_eys3_before_delete() returns trigger as '
declare
    r_eys1 record;
    r_almacen record;
    ld_uif date;
begin
--    ld_uif = ''2014-11-28'';
    ld_uif = ''2014-11-28'';

    
    select into r_eys1 * from eys1
    where almacen = old.almacen
    and no_transaccion = old.no_transaccion;
    if found then

        select into r_almacen * from almacen
        where almacen = r_eys1.almacen;

        if Trim(f_gralparaxcia(r_almacen.compania, ''PLA'', ''metodo_calculo'')) = ''coolhouse'' 
            and r_eys1.fecha < ld_uif then
            Raise Exception ''No se puede eliminar registros con fecha % el ultimo inventario fisico fue %'',r_eys1.fecha, ld_uif;
        end if;

/*
        delete from rela_eys1_cglposteo
        where almacen = old.almacen
        and no_transaccion = old.no_transaccion;
*/
        
    end if;        
    return old;
end;
' language plpgsql;


create function f_eys3_before_update() returns trigger as '
declare
    r_eys1 record;
    r_almacen record;
    ld_uif date;
begin
--    ld_uif = ''2014-11-28'';
    ld_uif = ''2014-11-28'';

    
    select into r_eys1 * from eys1
    where almacen = old.almacen
    and no_transaccion = old.no_transaccion;
    if not found then
        raise exception ''No existe transaccion % en el almacen % en la table eys1'',old.no_transaccion, old.almacen;
    end if;

    select into r_almacen * from almacen
    where almacen = r_eys1.almacen;

    if Trim(f_gralparaxcia(r_almacen.compania, ''PLA'', ''metodo_calculo'')) = ''coolhouse'' 
        and r_eys1.fecha < ld_uif then
        Raise Exception ''No se puede eliminar registros con fecha % el ultimo inventario fisico fue %'',r_eys1.fecha, ld_uif;
    end if;

/*
    delete from rela_eys1_cglposteo
    where almacen = old.almacen
    and no_transaccion = old.no_transaccion;
*/
    
    return new;
end;
' language plpgsql;



create function f_eys4_after_delete() returns trigger as '
begin
    delete from eys2
    where articulo = old.articulo
    and almacen = old.almacen
    and no_transaccion = old.no_transaccion
    and linea = old.inv_linea;
    return old;
end;
' language plpgsql;


create function f_inv_fisico2_after_update() returns trigger as '
begin
    if new.ubicacion is not null then
        update articulos_por_almacen
        set ubicacion = new.ubicacion
        where almacen = new.almacen
        and articulo = new.articulo;
    end if;
    return new;
end;
' language plpgsql;


create function f_rela_eys1_cglposteo_before_delete() returns trigger as '
begin
/*
    delete from cglposteo
    where consecutivo = old.consecutivo;
*/    
    return old;
end;
' language plpgsql;



create function f_eys2_after_insert() returns trigger as '
declare
    i integer;
    r_cxpfact1 record;
    r_inv_margenes_x_grupo record;
    r_articulos_por_almacen record;
    ldc_precio decimal;
    ldc_cu decimal;
    ldc_ganancia decimal;
begin
    i = f_update_existencias(new.almacen, new.articulo);
    
    select into r_articulos_por_almacen * 
    from articulos_por_almacen
    where almacen = new.almacen
    and articulo = new.articulo;
    if r_articulos_por_almacen.precio_fijo = ''S'' then
        return new;
    end if;
    
    select into r_cxpfact1 * from cxpfact1
    where compania = new.compania
    and proveedor = new.proveedor
    and fact_proveedor = new.fact_proveedor;
    if found then
        if r_cxpfact1.actualiza_precios = ''S'' then
            if new.cantidad <> 0 then
                ldc_cu  =   new.costo / new.cantidad;
            else
                return new;
            end if;
            
            ldc_precio  =   0;
            for r_inv_margenes_x_grupo in select inv_margenes_x_grupo.*
                    from inv_margenes_x_grupo, articulos_agrupados
                    where inv_margenes_x_grupo.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
                    and inv_margenes_x_grupo.almacen = new.almacen
                    and articulos_agrupados.articulo = new.articulo
                    order by articulos_agrupados.codigo_valor_grupo
            loop
                if r_inv_margenes_x_grupo.margen > 0 then
                    ldc_ganancia    =   (ldc_cu * r_inv_margenes_x_grupo.margen) / (100 - r_inv_margenes_x_grupo.margen);
                    ldc_precio      =   ldc_cu + ldc_ganancia;
                    ldc_precio      =   ldc_cu / ((100 - r_inv_margenes_x_grupo.margen) / 100);
                    exit;
                end if;
            end loop;
            
            if ldc_precio > r_articulos_por_almacen.precio_venta then
                update articulos_por_almacen
                set precio_venta = ldc_precio
                where almacen = new.almacen
                and articulo = new.articulo;
            end if;
        end if;
    end if;
    return new;
end;
' language plpgsql;


create function f_eys2_after_delete() returns trigger as '
declare
    i integer;
begin
    i = f_update_existencias(old.almacen, old.articulo);
    return old;
end;
' language plpgsql;

create function f_eys2_after_update() returns trigger as '
declare
    i integer;
begin
    if old.articulo = new.articulo then
       i := f_update_existencias(new.almacen, new.articulo);
    else
       i := f_update_existencias(old.almacen, old.articulo);
       i := f_update_existencias(new.almacen, new.articulo);
    end if;
       
    return new;
end;
' language plpgsql;



create function f_eys2_eys6() returns trigger as '
declare
    r_eys1 record;
    r_eys2 record;
    r_articulos record;
    r_compras record;
    r_invmotivos record;
    ldc_cantidad decimal(12,4);
    ldc_cantidad_eys6 decimal(12,4);
    ldc_work decimal(12,4);
    i integer;
begin
    
    select into r_articulos * from articulos
    where articulo = new.articulo
    and valorizacion in (''F'', ''L'');
    if not found then
       return new;
    end if;
    
    if new.cantidad = 0 then
       return new;
    end if;
    
    select into r_eys1 * from eys1
    where almacen = new.almacen
    and no_transaccion = new.no_transaccion;    
    if not found then
        return new;
    end if;
    
    select into r_invmotivos * from invmotivos
    where motivo = r_eys1.motivo;
    
    
    delete from eys6
    where articulo = new.articulo
    and almacen = new.almacen
    and no_transaccion = new.no_transaccion
    and linea = new.linea;
    
    ldc_cantidad := new.cantidad;
    
    ldc_work := r_invmotivos.signo * new.cantidad;
    
    if r_invmotivos.signo = -1 then
        for r_compras in select eys1.almacen, eys6.articulo,   
                                 eys1.fecha,   
                                 eys6.compra_no_transaccion,   
                                 eys6.compra_linea,   
                                 sum(eys6.cantidad) as saldo FROM eys1, eys6  
                           WHERE eys1.almacen = eys6.almacen
                           and  eys1.no_transaccion = eys6.compra_no_transaccion
                           and eys1.almacen = new.almacen
                           and eys6.articulo = new.articulo
                           and exists 
                           (select * from eys1 where almacen = eys6.almacen 
                           and no_transaccion = eys6.no_transaccion and fecha <= r_eys1.fecha)
                    GROUP BY eys1.almacen,   
                             eys1.fecha,   
                             eys6.articulo,   
                             eys6.compra_no_transaccion,   
                             eys6.compra_linea  
                    ORDER BY eys1.fecha ASC
        loop
            if r_compras.saldo > 0 then
                if r_compras.saldo >= ldc_cantidad then
                   ldc_cantidad_eys6 := ldc_cantidad;
                   ldc_cantidad := 0;
                else
                   ldc_cantidad_eys6 := r_compras.saldo;
                   ldc_cantidad := ldc_cantidad - r_compras.saldo;
                end if;
    
                if ldc_cantidad_eys6 <> 0 then
                    insert into eys6 (articulo, almacen, no_transaccion, linea, compra_no_transaccion,
                        compra_linea, cantidad)
                    values (new.articulo, new.almacen, new.no_transaccion, new.linea, 
                        r_compras.compra_no_transaccion, r_compras.compra_linea, -ldc_cantidad_eys6);
                end if;
                if ldc_cantidad <= 0 then
                   exit;
                end if;
            end if;
        end loop;
    else
        insert into eys6 (articulo, almacen, no_transaccion, linea, compra_no_transaccion,
            compra_linea, cantidad)
        values (new.articulo, new.almacen, new.no_transaccion, new.linea, 
            new.no_transaccion, new.linea, new.cantidad);
    end if;
    
    return new;
end;
' language plpgsql;

create function f_articulos_por_almacen_after_update() returns trigger as '
declare
    ldc_cu decimal(10,2);
begin
    if new.existencia <= 0 then
        return new;
    end if;
    
    if old.precio_venta = new.precio_venta then
        return new;
    end if;

/*    
    ldc_cu  =   new.costo / new.existencia;
    
    if ldc_cu > new.precio_venta then
        raise exception ''Precio de Venta % no Puede estar por Debajo del Costo % en Articulo %...Verifique'',new.precio_venta, ldc_cu, new.articulo;
    end if;
*/    
    
    return new;
end;
' language plpgsql;

create function f_articulos_por_almacen_after_insert() returns trigger as '
declare
    ldc_cu decimal(10,2);
begin
    if new.existencia <= 0 then
        return new;
    end if;
    
    ldc_cu  =   new.costo / new.existencia;
    
    if ldc_cu > new.precio_venta then
        raise exception ''Precio de Venta % no Puede estar por Debajo del Costo % en Articulo %...Verifique'',new.precio_venta, ldc_cu, new.articulo;
    end if;
    
    return new;
end;
' language plpgsql;


create function f_articulos_por_almacen_before_insert() returns trigger as '
declare
    r_cglcuentas record;
    r_articulos record;
    r_almacen record;
begin
    if new.articulo is null then
        raise exception ''Codigo de Articulo es Obligatorio...Verifique'';
    end if;


    if new.margen_minimo is null then
        new.margen_minimo = 0;
    end if;    
    
    select into r_articulos * from articulos
    where articulo = new.articulo;
    if not found then
        raise exception ''Codigo de Articulo % No Existe'',new.articulo;
    end if;
    
    if new.cuenta is null then
        raise exception ''Codigo de Cuenta es Obligatorio...Verifique'';
    end if;
    
    select into r_cglcuentas * from cglcuentas
    where cuenta = new.cuenta;
    if not found then
        raise exception ''Codigo de Cuenta % No Existe'',new.cuenta;
    end if;
    
    select into r_almacen *
    from almacen
    where almacen = new.almacen;
    if not found then
        Raise Exception ''Almacen no Existe...'';
    end if;
    
    if Trim(f_gralparaxcia(r_almacen.compania, ''PLA'', ''metodo_calculo'')) <> ''conytram'' and
       Trim(f_gralparaxcia(r_almacen.compania, ''PLA'', ''metodo_calculo'')) <> ''airsea'' then
        if r_articulos.servicio = ''S'' and r_cglcuentas.tipo_cuenta = ''B'' then
            raise exception ''Esta Cuenta % No se Puede Colocar a Articulos % que son Servicios'',new.cuenta, new.articulo;
        end if;
    end if;
        
    if r_articulos.servicio = ''N'' and r_cglcuentas.tipo_cuenta = ''R'' then
        raise exception ''Esta Cuenta % No se Puede Colocar a Articulos % de Inventario'',new.cuenta, new.articulo;
    end if;
    
    if new.precio_minimo is null then
        new.precio_minimo = 0;
    end if;
    return new;
end;
' language plpgsql;




create function f_factura2_eys2_delete() returns trigger as '
begin
    delete from eys2
    where articulo = old.articulo
    and almacen = old.almacen
    and no_transaccion = old.no_transaccion
    and linea = old.eys2_linea;
    return old;
end;
' language plpgsql;

create function f_oc2_before_insert() returns trigger as '
declare
    r_articulos record;
begin
    if new.d_articulo is null then
        new.d_articulo = '''';
    else
        select into r_articulos *
        from articulos
        where trim(articulo) = trim(new.articulo);
        if not found then
            Raise Exception ''Articulo % no Existe'', new.articulo;
        else
            if r_articulos.status_articulo = ''I'' then
                Raise Exception ''Articulo % esta Inactivo'', new.articulo;
            end if;
        end if;           
    end if;
    return new;
end;
' language plpgsql;



create trigger t_oc2_before_insert before insert on oc2
for each row execute procedure f_oc2_before_insert();


create trigger t_eys1_before_delete before delete on eys1
for each row execute procedure f_eys1_before_delete();
create trigger t_eys1_before_update before update on eys1
for each row execute procedure f_eys1_before_update();
create trigger t_eys1_before_insert before insert on eys1
for each row execute procedure f_eys1_before_insert();


create trigger t_eys2_before_insert before insert on eys2
for each row execute procedure f_eys2_before_insert();
create trigger t_eys2_before_delete before delete on eys2
for each row execute procedure f_eys2_before_delete();
create trigger t_eys2_before_update before update on eys2
for each row execute procedure f_eys2_before_update();
create trigger t_eys2_after_insert after insert on eys2
for each row execute procedure f_eys2_after_insert();
create trigger t_eys2_after_update after update on eys2
for each row execute procedure f_eys2_after_update();
create trigger t_eys2_after_delete after delete on eys2
for each row execute procedure f_eys2_after_delete();
create trigger t_eys2_eys6 after insert or update on eys2
for each row execute procedure f_eys2_eys6();


create trigger t_eys3_before_insert before insert on eys3
for each row execute procedure f_eys3_before_insert();
create trigger t_eys3_before_delete before delete on eys3
for each row execute procedure f_eys3_before_delete();
create trigger t_eys3_before_update before update on eys3
for each row execute procedure f_eys3_before_update();


create trigger t_eys4_after_delete after delete on eys4
for each row execute procedure f_eys4_after_delete();

create trigger t_factura2_eys2_delete after delete on factura2_eys2 
for each row execute procedure f_factura2_eys2_delete();


create trigger t_rela_eys1_cglposteo_before_delete before delete on rela_eys1_cglposteo
for each row execute procedure f_rela_eys1_cglposteo_before_delete();


create trigger t_inv_fisico2_after_update after insert or update on inv_fisico2
for each row execute procedure f_inv_fisico2_after_update();

create trigger t_articulos_por_almacen_after_update after update on articulos_por_almacen
for each row execute procedure f_articulos_por_almacen_after_update();

create trigger t_articulos_por_almacen_after_insert after insert on articulos_por_almacen
for each row execute procedure f_articulos_por_almacen_after_insert();

create trigger t_articulos_por_almacen_before_insert before insert or update on articulos_por_almacen
for each row execute procedure f_articulos_por_almacen_before_insert();

create trigger t_articulos_after_insert after insert on articulos
for each row execute procedure f_articulos_after_insert();

create trigger t_articulos_before_insert before insert on articulos
for each row execute procedure f_articulos_before_insert();

create trigger t_articulos_agrupados_before_insert before insert on articulos_agrupados
for each row execute procedure f_articulos_agrupados_before_insert();

create trigger t_invparal_before_update before update on invparal
for each row execute procedure f_invparal_before_update();
