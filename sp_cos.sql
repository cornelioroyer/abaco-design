drop function f_costos_inventario(char(2), int4) cascade;
drop function f_costos_inventario_fifo(char(2), int4) cascade;

drop function f_cos_produccion_eys2(char(2), int4, int4) cascade;
drop function f_cos_consumo_eys2(char(2), int4, int4) cascade;
drop function f_taller_inventario_fifo(char(2), char(1), int4) cascade;


create function f_taller_inventario_fifo(char(2), char(1), int4) returns integer as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_no_orden alias for $3;
    r_tal_ot2_eys2 record;
    r_eys6 record;
    r_eys2 record;
    r_articulos record;
    i integer;
    ldc_costo decimal(12,2);
begin
    for r_tal_ot2_eys2 in select tal_ot2_eys2.* from tal_ot2_eys2, articulos 
                        where tal_ot2_eys2.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and articulos.valorizacion in (''F'',''L'')
                        and tal_ot2_eys2.almacen = as_almacen
                        and tal_ot2_eys2.tipo = as_tipo
                        and tal_ot2_eys2.no_orden = ai_no_orden
    loop
        ldc_costo := 0;
        for r_eys6 in select * from eys6
                        where articulo = r_tal_ot2_eys2.articulo
                        and almacen = r_tal_ot2_eys2.almacen
                        and no_transaccion = r_tal_ot2_eys2.no_transaccion
                        and linea = r_tal_ot2_eys2.linea_eys2
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
        where articulo = r_tal_ot2_eys2.articulo
        and almacen = r_tal_ot2_eys2.almacen
        and no_transaccion = r_tal_ot2_eys2.no_transaccion
        and linea = r_tal_ot2_eys2.linea_eys2;
              
    end loop;
    
    return 1;
end;
' language plpgsql;


create function f_costos_inventario(char(2), int4) returns integer as '
declare
    as_compania alias for $1;
    ai_secuencia alias for $2;
    r_cos_produccion record;
    r_cos_consumo record;
    r_invmotivos record;
    r_cos_trx record;
    r_eys1 record;
    r_eys2 record;
    r_eys6 record;
    ls_tdt_consumo char(2);
    ls_tdt_produccion char(2);
    li_work integer;
    li_linea integer;
    ls_work text;
    ldc_cu decimal(12,4);
    r_cos_consumo_eys2 record;
    i integer;
begin
    select into r_cos_trx * from cos_trx
    where compania = as_compania 
    and secuencia = ai_secuencia;
    if not found then
        return 0;
    end if;
    
    if r_cos_trx.fecha is null then
        return 0;
    end if;
    
    li_work = f_valida_fecha(as_compania, ''CGL'', r_cos_trx.fecha);
    
    select into ls_work trim(valor) from gralparaxapli
    where aplicacion = ''INV'' and parametro = ''tdt_consumo'';
    if not found then
       raise exception ''no existe valor para parametro tdt_consumo a nivel de aplicacion'';
    end if;
    ls_tdt_consumo = trim(ls_work);
    
    
    select into ls_work trim(valor) from gralparaxapli
    where aplicacion = ''INV'' and parametro = ''tdt_produccion'';
    if not found then
       raise exception ''no existe valor para parametro tdt_produccion a nivel de aplicacion'';
    end if;
    ls_tdt_produccion = trim(ls_work);
    
    select into r_invmotivos * 
    from invmotivos
    where motivo = ls_tdt_consumo;
    if not found then
       raise exception ''tipo de transaccion para consumo no existe en invmotivos %'', ls_tdt_consumo;
    end if;
    
    select into r_invmotivos * 
    from invmotivos
    where motivo = ls_tdt_produccion;
    if not found then
       raise exception ''tipo de transaccion para produccion no existe en invmotivos %'', ls_tdt_consumo;
    end if;

    
    delete from cos_consumo_eys2
    where compania = as_compania
    and secuencia = ai_secuencia;
    
    delete from cos_produccion_eys2
    where compania = as_compania
    and secuencia = ai_secuencia;
    

    for r_cos_consumo in select cos_consumo.* from cos_consumo, articulos 
                        where cos_consumo.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and cos_consumo.compania = as_compania
                        and cos_consumo.secuencia = ai_secuencia
    loop
        i = f_cos_consumo_eys2(r_cos_consumo.almacen, r_cos_consumo.secuencia, r_cos_consumo.linea);
    end loop;

    for r_cos_produccion in select cos_produccion.* from cos_produccion, articulos 
                        where cos_produccion.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and cos_produccion.compania = as_compania
                        and cos_produccion.secuencia = ai_secuencia
    loop
        i = f_cos_produccion_eys2(r_cos_produccion.almacen, r_cos_produccion.secuencia, r_cos_produccion.linea);
    end  loop;
    
    return 1;
end;
' language plpgsql;


create function f_costos_inventario_fifo(char(2), int4) returns integer as '
declare
    as_compania alias for $1;
    ai_secuencia alias for $2;
    r_cos_consumo_eys2 record;
    r_eys6 record;
    r_eys2 record;
    r_articulos record;
    i integer;
    ldc_costo decimal(12,2);
begin
    for r_cos_consumo_eys2 in select cos_consumo_eys2.* from cos_consumo_eys2, articulos 
                        where cos_consumo_eys2.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and cos_consumo_eys2.compania = as_compania
                        and cos_consumo_eys2.secuencia = ai_secuencia
    loop
        select into r_articulos * from articulos
        where articulo = r_cos_consumo_eys2.articulo;
        if r_articulos.valorizacion = ''L'' or r_articulos.valorizacion = ''F'' then
            ldc_costo := 0;
            for r_eys6 in select * from eys6
                            where articulo = r_cos_consumo_eys2.articulo
                            and almacen = r_cos_consumo_eys2.almacen
                            and no_transaccion = r_cos_consumo_eys2.no_transaccion
                            and linea = r_cos_consumo_eys2.eys2_linea
            loop
                select into r_eys2 * from eys2
                where articulo = r_eys6.articulo
                and almacen = r_eys6.almacen
                and no_transaccion = r_eys6.compra_no_transaccion
                and linea = r_eys6.compra_linea
                and eys2.cantidad <> 0;
                if found then
                    ldc_costo := ldc_costo + ((r_eys2.costo / r_eys2.cantidad) * -r_eys6.cantidad);
                end if;
            end loop;
            
            
            update eys2
            set costo = ldc_costo
            where articulo = r_cos_consumo_eys2.articulo
            and almacen = r_cos_consumo_eys2.almacen
            and no_transaccion = r_cos_consumo_eys2.no_transaccion
            and linea = r_cos_consumo_eys2.eys2_linea;
                  
            select into r_eys2 * from eys2
            where articulo = r_cos_consumo_eys2.articulo
            and almacen = r_cos_consumo_eys2.almacen
            and no_transaccion = r_cos_consumo_eys2.no_transaccion
            and linea = r_cos_consumo_eys2.eys2_linea;
/*          
            update cos_consumo
            set costo = r_eys2.costo
            where secuencia = r_cos_consumo_eys2.secuencia
            and compania = r_cos_consumo_eys2.compania
            and linea = r_cos_consumo_eys2.linea;
*/            
        else
            select into r_eys2 * from eys2
            where articulo = r_cos_consumo_eys2.articulo
            and almacen = r_cos_consumo_eys2.almacen
            and no_transaccion = r_cos_consumo_eys2.no_transaccion
            and linea = r_cos_consumo_eys2.eys2_linea;
/*          
            update cos_consumo
            set costo = r_eys2.costo
            where secuencia = r_cos_consumo_eys2.secuencia
            and compania = r_cos_consumo_eys2.compania
            and linea = r_cos_consumo_eys2.linea;
*/            
        end if;

/*        
        i = f_eys1_poner_cuentas(r_cos_consumo_eys2.almacen, r_cos_consumo_eys2.no_transaccion);
        
        if i = 0 then
           raise exception ''transaccion % no tiene definido cuenta de costo...verifique '', r_cos_consumo_eys2.no_transaccion;
        end if;
*/
        
    end loop;
    
    return 1;
end;
' language plpgsql;


create function f_cos_consumo_eys2(char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_secuencia alias for $2;
    ai_linea alias for $3;
    r_cos_trx record;
    r_cos_consumo record;
    r_invmotivos record;
    r_articulos record;
    r_facparamcgl record;
    r_eys1 record;
    r_eys2 record;
    i integer;
    li_linea integer;
    li_work integer;
    ls_tdt_consumo char(2);
    ldc_cu decimal(12,4);
    ldc_sum_eys2 decimal;
    ldc_sum_eys3 decimal;
    ldc_work decimal;
begin
    delete from cos_consumo_eys2
    where compania = as_compania
    and secuencia = ai_secuencia
    and linea = ai_linea;

    select into r_cos_trx * from cos_trx
    where compania = as_compania 
    and secuencia = ai_secuencia;
    
    select into r_cos_consumo * from cos_consumo
    where compania = as_compania
    and secuencia = ai_secuencia
    and linea = ai_linea;
    
    
    i = f_valida_fecha(r_cos_trx.compania, ''CGL'', r_cos_trx.fecha);
    
    ls_tdt_consumo = Trim(f_gralparaxapli(''INV'', ''tdt_consumo''));
        
    select into r_invmotivos * from invmotivos
    where motivo = ls_tdt_consumo;
    if not found then
       raise exception ''tipo de transaccion para consumo no existe en invmotivos %'', ls_tdt_consumo;
    end if;
    
    select into r_articulos * from articulos
    where articulo = r_cos_consumo.articulo
    and servicio = ''S'';
    if found then
        return 0;
    end if;
    
    
    select into r_eys1 eys1.* from eys1
    where almacen = r_cos_consumo.almacen
    and motivo = ls_tdt_consumo
    and aplicacion_origen = ''COS''
    and fecha = r_cos_trx.fecha;
    if not found then
        r_eys1.no_transaccion      =  f_sec_inventario(r_cos_consumo.almacen); 
        INSERT INTO eys1 ( almacen, no_transaccion, motivo, aplicacion_origen, 
            fecha, usuario, fecha_captura, status, observacion ) 
        VALUES ( r_cos_consumo.almacen, r_eys1.no_transaccion, ls_tdt_consumo, ''COS'', 
            r_cos_trx.fecha, current_user, current_timestamp, ''R'', trim(r_cos_trx.observacion));
    else            
        update eys1
        set    usuario = current_user,
               fecha_captura = current_timestamp
        where  almacen = r_cos_consumo.almacen
        and    no_transaccion = r_eys1.no_transaccion;
    end if;
    
    li_linea := 0;
    li_work := 0;
    while li_work = 0 loop
        li_linea = li_linea + 1;
        select into r_eys2 * from eys2
        where almacen = r_cos_consumo.almacen
        and no_transaccion = r_eys1.no_transaccion
        and linea = li_linea;
        if not found then
           li_work := 1;
        end if;
    end loop;
    
    ldc_cu  =   f_stock(r_cos_consumo.almacen, r_cos_consumo.articulo, r_cos_trx.fecha, 0, 0, ''CU'');
    INSERT INTO eys2 ( articulo, almacen, no_transaccion, linea, cantidad, costo ) 
    VALUES (r_cos_consumo.articulo, r_cos_consumo.almacen, r_eys1.no_transaccion,
    li_linea, r_cos_consumo.cantidad, (ldc_cu * r_cos_consumo.cantidad));
    
    insert into cos_consumo_eys2 (secuencia, compania, linea, articulo, almacen,
        no_transaccion, eys2_linea)
    values (r_cos_trx.secuencia, r_cos_trx.compania, r_cos_consumo.linea,
        r_cos_consumo.articulo, r_cos_consumo.almacen, r_eys1.no_transaccion,
        li_linea);


    select into r_facparamcgl * 
    from articulos_agrupados, facparamcgl
    where articulos_agrupados.codigo_valor_grupo = facparamcgl.codigo_valor_grupo
    and articulos_agrupados.articulo = r_cos_consumo.articulo
    and facparamcgl.almacen = r_cos_consumo.almacen;
    if not found then
       raise exception ''Articulo % no tiene definido parametros contables'',r_cos_consumo.articulo;
    end if;

    delete from eys3
    where almacen = r_cos_consumo.almacen
    and no_transaccion = r_eys1.no_transaccion
    and cuenta = r_facparamcgl.cuenta_costo;
        
    ldc_sum_eys2 = 0;
    ldc_sum_eys3 = 0;
        
    select sum(costo) into ldc_sum_eys2
    from eys2
    where almacen = r_cos_consumo.almacen
    and no_transaccion = r_eys1.no_transaccion;
    if ldc_sum_eys2 is null then
        ldc_sum_eys2 = 0;
    end if;

    select sum(monto) into ldc_sum_eys3
    from eys3
    where almacen = r_cos_consumo.almacen
    and no_transaccion = r_eys1.no_transaccion;
    if ldc_sum_eys3 is null then
        ldc_sum_eys3 = 0;
    end if;
    
    ldc_work    =   ldc_sum_eys2 - ldc_sum_eys3;
    
    insert into eys3 (almacen, no_transaccion, cuenta, monto)
    values (r_cos_consumo.almacen, r_eys1.no_transaccion, 
        r_facparamcgl.cuenta_costo, ldc_work);
    
    return 1;
end;
' language plpgsql;


create function f_cos_produccion_eys2(char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_secuencia alias for $2;
    ai_linea alias for $3;
    r_cos_trx record;
    r_cos_produccion record;
    r_invmotivos record;
    r_articulos record;
    r_eys1 record;
    r_eys2 record;
    i integer;
    li_linea integer;
    li_work integer;
    ls_tdt_produccion char(2);
    ldc_cu decimal(12,4);
begin
    delete from cos_produccion_eys2
    where compania = as_compania
    and secuencia = ai_secuencia
    and linea = ai_linea;

    select into r_cos_trx * from cos_trx
    where compania = as_compania 
    and secuencia = ai_secuencia;
    if not found then
        return 0;
    end if;
    
    select into r_cos_produccion * from cos_produccion
    where compania = as_compania
    and secuencia = ai_secuencia
    and linea = ai_linea;
    
    i = f_valida_fecha(r_cos_trx.compania, ''CGL'', r_cos_trx.fecha);
    
    ls_tdt_produccion = Trim(f_gralparaxapli(''INV'', ''tdt_produccion''));
        
    select into r_invmotivos * from invmotivos
    where motivo = ls_tdt_produccion;
    if not found then
       raise exception ''tipo de transaccion para consumo no existe en invmotivos %'', ls_tdt_produccion;
    end if;
    
    select into r_articulos * from articulos
    where articulo = r_cos_produccion.articulo
    and servicio = ''S'';
    if found then
        return 0;
    end if;
    
    select into r_eys1 eys1.* from eys1
    where almacen = r_cos_produccion.almacen
    and motivo = ls_tdt_produccion
    and aplicacion_origen = ''COS''
    and fecha = r_cos_trx.fecha;
    if not found then
        r_eys1.no_transaccion      =  f_sec_inventario(r_cos_produccion.almacen); 
        INSERT INTO eys1 ( almacen, no_transaccion, motivo, aplicacion_origen, 
            fecha, usuario, fecha_captura, status, observacion ) 
        VALUES ( r_cos_produccion.almacen, r_eys1.no_transaccion, ls_tdt_produccion, ''COS'', 
            r_cos_trx.fecha, current_user, current_timestamp, ''R'', trim(r_cos_trx.observacion));
    else            
        update eys1
        set    usuario = current_user,
               fecha_captura = current_timestamp
        where  almacen = r_cos_produccion.almacen
        and    no_transaccion = r_eys1.no_transaccion;
    end if;
    
    li_linea := 0;
    li_work := 0;
    while li_work = 0 loop
        li_linea := li_linea + 1;
        select into r_eys2 * from eys2
        where almacen = r_cos_produccion.almacen
        and no_transaccion = r_eys1.no_transaccion
        and linea = li_linea;
        if not found then
           li_work := 1;
        end if;
    end loop;
    
    INSERT INTO eys2 ( articulo, almacen, no_transaccion, linea, cantidad, costo ) 
    VALUES (r_cos_produccion.articulo, r_cos_produccion.almacen, r_eys1.no_transaccion,
    li_linea, r_cos_produccion.cantidad, 0);
    
    insert into cos_produccion_eys2 (secuencia, compania, linea, articulo, almacen,
        no_transaccion, eys2_linea)
    values (r_cos_trx.secuencia, r_cos_trx.compania, r_cos_produccion.linea,
        r_cos_produccion.articulo, r_cos_produccion.almacen, r_eys1.no_transaccion,
        li_linea);

    return 1;
end;
' language plpgsql;
