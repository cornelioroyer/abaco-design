drop function f_adc_house_delete(char(2), int4, int4, int4) cascade;
drop function f_adc_house_to_facturacion(char(2), int4, int4, int4) cascade;
drop function f_adc_manejo_delete(char(2), int4, int4, int4, int4) cascade;
drop function f_adc_notas_debito_to_facturacion(char(2), int4) cascade;
drop function f_adc_libera_facturas() cascade;


create function f_adc_libera_facturas() returns integer as '
declare
    r_factura1 record;
    ld_desde date;
    ldc_monto_devolucion decimal(12,2);
    ldc_monto_factura decimal(12,2);
    lc_tipo_factura char(2);
begin
    select tipo into lc_tipo_factura
    from factmotivos
    where factura_fiscal = ''S'';
    if not found then
        return 0;
    end if;
    
    ld_desde    =   current_date - 10;
    
    
    for r_factura1 in select factura1.* 
                        from factura1, factmotivos
                        where factura1.tipo = factmotivos.tipo
                        and factmotivos.devolucion = ''S''
                        and factura1.fecha_factura >= ld_desde
                        order by factura1.num_documento
    loop
    
        ldc_monto_devolucion    =   f_monto_factura_new(r_factura1.almacen, r_factura1.tipo,
                                        r_factura1.num_documento, r_factura1.caja);
        ldc_monto_factura       =   f_monto_factura_new(r_factura1.almacen, trim(lc_tipo_factura),
                                        r_factura1.num_factura, r_factura1.caja);
                                        

        if -ldc_monto_devolucion = ldc_monto_factura then
            
            
            delete from adc_house_factura1
            where almacen = r_factura1.almacen
            and tipo = lc_tipo_factura
            and caja = r_factura1.caja
            and num_documento = r_factura1.num_factura;
            
            update adc_notas_debito_1
            set almacen = null, tipo = null, num_documento = null
            where almacen = r_factura1.almacen
            and tipo = lc_tipo_factura
            and caja = r_factura1.caja
            and num_documento = r_factura1.num_factura;
        end if;
    end loop;

    
    return 1;
end;
' language plpgsql;


create function f_adc_notas_debito_to_facturacion(char(2), int4) returns integer as '
declare
    as_compania alias for $1;
    ai_secuencia alias for $2;
    r_adc_master record;
    r_adc_manifiesto record;
    r_navieras record;
    r_adc_parametros_contables record;
    r_fact_referencias record;
    r_factmotivos record;
    r_cglcuentas record;
    r_clientes record;
    r_adc_house record;
    r_factura1 record;
    r_gralperiodos record;
    r_articulos_por_almacen record;
    r_adc_notas_debito_1 record;
    r_adc_notas_debito_2 record;
    r_fac_cajas record;
    r_work record;
    r_factura4 record;
    r_factura2 record;
    ls_ciudad char(10);
    ls_agente char(10);
    ls_aux1 char(10);
    ls_observacion text;
    li_consecutivo int4;
    li_num_documento int4;
    li_linea integer;
    i integer;
    ldc_total decimal;
begin
    select into r_adc_notas_debito_1 * 
    from adc_notas_debito_1
    where compania = as_compania
    and secuencia = ai_secuencia
    and num_documento is not null;
    if found then
        return 0;
    end if;

    select into r_adc_notas_debito_1 * 
    from adc_notas_debito_1
    where compania = as_compania
    and secuencia = ai_secuencia;
    if not found then
        raise exception ''no encontre la nota debito'';
    end if;

    select into r_factmotivos *
    from factmotivos
    where tipo = r_adc_notas_debito_1.tipo
    and factura_fiscal = ''S'';
    if found then
        return 0;
    end if;
    

    select into r_adc_notas_debito_1 * 
    from adc_notas_debito_1
    where compania = as_compania
    and secuencia = ai_secuencia;
    if not found then
        raise exception ''no encontre la nota debito'';
    end if;
    
    select into r_adc_manifiesto * from adc_manifiesto
    where compania = as_compania
    and consecutivo = r_adc_notas_debito_1.consecutivo;
    if not found then
        return 0;
    end if;

    select into r_adc_notas_debito_2 *
    from adc_notas_debito_2
    where compania = as_compania
    and secuencia = ai_secuencia
    order by almacen;
    if not found then
        return 0;
    end if;
    

    select into r_adc_notas_debito_1 adc_notas_debito_1.* 
    from factura1, adc_notas_debito_1, factmotivos
    where factura1.almacen = adc_notas_debito_1.almacen
    and factura1.tipo = adc_notas_debito_1.tipo
    and factura1.caja = adc_notas_debito_1.caja
    and factura1.num_documento = adc_notas_debito_1.num_documento
    and factura1.tipo = factmotivos.tipo
    and (factmotivos.cotizacion = ''S'' or factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
    and factura1.status <> ''A''
    and adc_notas_debito_1.compania = as_compania
    and adc_notas_debito_1.secuencia = ai_secuencia;
    if found then
        return 0;
    end if;

    
    select into r_factmotivos * from factmotivos where cotizacion = ''S'';
    
    select into r_clientes * from clientes
    where cliente = r_adc_notas_debito_1.cliente;
    
   
    select into r_navieras * from navieras
    where cod_naviera = r_adc_manifiesto.cod_naviera;
    
    select into r_fact_referencias * from fact_referencias
    where referencia = r_adc_manifiesto.referencia;
    
    if r_fact_referencias.tipo = ''E'' then
        ls_ciudad := r_adc_manifiesto.ciudad_destino;
        ls_agente := r_adc_manifiesto.to_agent;
    else
        ls_ciudad := r_adc_manifiesto.ciudad_origen;
        ls_agente := r_adc_manifiesto.from_agent;
    end if;        
    
    ls_observacion = ''LOTE: '' || trim(r_adc_manifiesto.no_referencia);
    
    li_num_documento = 0;

    select into r_adc_notas_debito_1 * 
    from adc_notas_debito_1
    where compania = as_compania
    and secuencia = ai_secuencia;
    if not found then
        raise exception ''no encontre la nota debito'';
    end if;
    
    if r_adc_notas_debito_1.observacion_1 is not null then
        ls_observacion  =   trim(ls_observacion) || '' '' || Trim(r_adc_notas_debito_1.observacion_1);
    end if;

    if r_adc_notas_debito_1.observacion_2 is not null then
        ls_observacion  =   trim(ls_observacion) || '' '' || Trim(r_adc_notas_debito_1.observacion_2);
    end if;

    if r_adc_notas_debito_1.observacion_3 is not null then
        ls_observacion  =   trim(ls_observacion) || '' '' || Trim(r_adc_notas_debito_1.observacion_3);
    end if;
    
    select into r_clientes *
    from clientes
    where cliente = r_adc_notas_debito_1.cliente;
    
    select into r_fac_cajas *
    from fac_cajas
    where almacen = r_adc_notas_debito_2.almacen
    and status = ''A'';
    if not found then
        Raise Exception ''Caja No existe %'', r_adc_notas_debito_2.almacen;
    end if;


    select into r_factura1 factura1.* 
    from factura1, factmotivos
    where factura1.tipo = factmotivos.tipo
    and almacen = r_adc_notas_debito_2.almacen
    and cliente = r_adc_notas_debito_1.cliente
    and fecha_factura = current_date
    and trim(no_referencia) = trim(r_adc_manifiesto.no_referencia)
    and trim(vapor) = Trim(r_adc_manifiesto.vapor)
    and factmotivos.cotizacion = ''S'';
    if found then
        li_num_documento = r_factura1.num_documento;
    else
        loop
            li_num_documento := li_num_documento + 1;    
        
            select into r_factura1 * from factura1
            where almacen = r_adc_notas_debito_2.almacen
            and tipo = r_factmotivos.tipo
            and caja = r_fac_cajas.caja
            and num_documento = li_num_documento;
            if not found then
                exit;
            end if;
        end loop;

        insert into factura1(almacen, tipo, num_documento, cliente, forma_pago, codigo_vendedor,
            nombre_cliente, descto_porcentaje, descto_monto, usuario_captura, usuario_postea,
            fecha_vencimiento, fecha_captura, fecha_postea, fecha_factura, status,
            num_cotizacion, num_factura, observacion, despachar, documento, aplicacion,
            referencia, no_referencia, mbl, hbl, vapor, embarcador, direccion1, direccion2,
            cod_destino, cod_naviera, ciudad_origen, ciudad_destino, agente, bultos, peso, facturar, caja)
        values (r_adc_notas_debito_2.almacen, r_factmotivos.tipo, li_num_documento,
            r_adc_notas_debito_1.cliente, r_clientes.forma_pago, ''00'', r_clientes.nomb_cliente, 
            0, 0, current_user, current_user, current_date, current_timestamp, current_date, 
            current_date,
            ''R'', 0, 0, trim(ls_observacion), ''N'', 0, ''FAC'', r_adc_manifiesto.referencia, 
            r_adc_manifiesto.no_referencia, null, null, 
            r_adc_manifiesto.vapor, null, trim(r_clientes.direccion1), 
            trim(r_clientes.direccion2), 
            null, r_adc_manifiesto.cod_naviera, r_adc_manifiesto.ciudad_origen,
            r_adc_manifiesto.ciudad_destino, null, 0, 0, ''N'', r_fac_cajas.caja);
    end if;


    ldc_total = 0;
    for r_adc_notas_debito_2 in select * from adc_notas_debito_2
                                    where compania = r_adc_notas_debito_1.compania
                                    and secuencia = r_adc_notas_debito_1.secuencia
                                    order by linea
    loop
        if r_adc_notas_debito_2.articulo is null then
            Raise Exception ''Nota Debito % Los articulos no pueden ser nulos'', r_adc_notas_debito_1.secuencia;
        end if;
    
        li_linea := 0;
        select into li_linea Max(linea) from factura2
        where almacen = r_adc_notas_debito_2.almacen
        and tipo = r_factmotivos.tipo
        and caja = r_fac_cajas.caja
        and num_documento = li_num_documento;
        if li_linea is null then
            li_linea := 1;
        else
            li_linea := li_linea + 1;
        end if;

        loop
            select into r_factura2 *
            from factura2
            where almacen = r_adc_notas_debito_2.almacen
            and tipo = r_factmotivos.tipo
            and num_documento = li_num_documento
            and caja = r_fac_cajas.caja
            and linea = li_linea;
            if not found then
                select into r_work *
                from fac_cajas
                where almacen = r_adc_notas_debito_2.almacen
                and caja = r_fac_cajas.caja;
                if not found then
                    Raise Exception ''Almacen % Caja % Nota Debito % No Existe'', r_adc_notas_debito_2.almacen, r_fac_cajas.caja, ai_secuencia;
                end if;
                
                insert into factura2 (almacen, tipo, num_documento, linea,
                    articulo, cantidad, precio, descuento_linea, descuento_global,
                    observacion, cif, caja)
                values (r_adc_notas_debito_2.almacen, r_factmotivos.tipo, li_num_documento, li_linea,
                    r_adc_notas_debito_2.articulo, 1, r_adc_notas_debito_2.monto, 0, 0, 
                    trim(r_adc_notas_debito_2.observacion), 0, r_fac_cajas.caja);
                    
                ldc_total = ldc_total + r_adc_notas_debito_2.monto;
                exit;
            end if;
            li_linea = li_linea + 1;
        end loop;
    end loop;
        
        
    select into r_factura4 * from factura4
    where almacen = r_adc_notas_debito_2.almacen
    and tipo = r_factmotivos.tipo
    and num_documento = li_num_documento
    and caja = r_fac_cajas.caja
    and rubro_fact_cxc = ''SUB-TOTAL'';
    if not found then
        select into r_factura1 * from factura1
        where almacen = r_adc_notas_debito_2.almacen
        and tipo = r_factmotivos.tipo
        and caja = r_fac_cajas.caja
        and num_documento = li_num_documento;
        if found then
            insert into factura4 (almacen, tipo, num_documento, rubro_fact_cxc, monto, caja)
            values (r_adc_notas_debito_2.almacen, r_factmotivos.tipo, li_num_documento, ''SUB-TOTAL'',
                ldc_total, r_fac_cajas.caja);
        end if;
    else
        update factura4
        set monto = monto + ldc_total
        where almacen = r_adc_notas_debito_2.almacen
        and tipo = r_factmotivos.tipo
        and num_documento = li_num_documento
        and caja = r_fac_cajas.caja
        and rubro_fact_cxc = ''SUB-TOTAL'';
    end if;


    update adc_notas_debito_1
    set almacen = r_adc_notas_debito_2.almacen, tipo = r_factmotivos.tipo,
        num_documento = li_num_documento, caja = r_fac_cajas.caja
    where compania = as_compania
    and secuencia = ai_secuencia;

    
    return 1;
end;
' language plpgsql;


create function f_adc_manejo_delete(char(2), int4, int4, int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ai_linea_house alias for $4;
    ai_linea_manejo alias for $5;
    r_factura1 record;
begin
/*
    select into r_factura1 factura1.* from adc_house_factura1, factura1, factmotivos
    where adc_house_factura1.almacen = factura1.almacen
    and adc_house_factura1.tipo = factura1.tipo
    and adc_house_factura1.num_documento = factura1.num_documento
    and factura1.tipo = factmotivos.tipo
    and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
    and adc_house_factura1.compania = as_compania
    and adc_house_factura1.consecutivo = ai_consecutivo
    and adc_house_factura1.linea_master = ai_linea_master
    and adc_house_factura1.linea_house = ai_linea_house
    and adc_house_factura1.linea_manejo = ai_linea_manejo;
    if found then
        return 0;
    end if;

    delete from factura1
    using adc_house_factura1
    where adc_house_factura1.almacen = factura1.almacen
    and adc_house_factura1.tipo = factura1.tipo
    and adc_house_factura1.num_documento = factura1.num_documento
    and adc_house_factura1.compania = as_compania
    and adc_house_factura1.consecutivo = ai_consecutivo
    and adc_house_factura1.linea_master = ai_linea_master
    and adc_house_factura1.linea_house = ai_linea_house
    and adc_house_factura1.linea_manejo = ai_linea_manejo;
*/

    delete from adc_house_factura1
    where adc_house_factura1.compania = as_compania
    and adc_house_factura1.consecutivo = ai_consecutivo
    and adc_house_factura1.linea_master = ai_linea_master
    and adc_house_factura1.linea_house = ai_linea_house
    and tipo in (select tipo from factmotivos where cotizacion = ''S'');
    
    return 1;
end;
' language plpgsql;



create function f_adc_house_delete(char(2), int4, int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ai_linea_house alias for $4;
    r_factura1 record;
begin
/*
    select into r_factura1 factura1.* from adc_house_factura1, factura1, factmotivos
    where adc_house_factura1.almacen = factura1.almacen
    and adc_house_factura1.tipo = factura1.tipo
    and adc_house_factura1.num_documento = factura1.num_documento
    and factura1.tipo = factmotivos.tipo
    and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
    and adc_house_factura1.compania = as_compania
    and adc_house_factura1.consecutivo = ai_consecutivo
    and adc_house_factura1.linea_master = ai_linea_master
    and adc_house_factura1.linea_house = ai_linea_house;
    if found then
        return 0;
    end if;
*/

    delete from adc_house_factura1
    where adc_house_factura1.compania = as_compania
    and adc_house_factura1.consecutivo = ai_consecutivo
    and adc_house_factura1.linea_master = ai_linea_master
    and adc_house_factura1.linea_house = ai_linea_house
    and tipo in (select tipo from factmotivos where cotizacion = ''S'');

    return 1;
end;
' language plpgsql;



create function f_adc_house_to_facturacion(char(2), int4, int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ai_linea_house alias for $4;
    r_adc_master record;
    r_adc_manifiesto record;
    r_navieras record;
    r_adc_parametros_contables record;
    r_fact_referencias record;
    r_factmotivos record;
    r_cglcuentas record;
    r_clientes record;
    ls_ciudad char(10);
    ls_agente char(10);
    ls_aux1 char(10);
    ls_observacion text;
    li_consecutivo int4;
    li_num_documento int4;
    r_adc_house record;
    r_factura1 record;
    r_gralperiodos record;
    r_articulos_por_almacen record;
    r_adc_house_factura1 record;
    r_fac_cajas record;
    r_factura2 record;
    r_factura4 record;
    r_work record;
    li_linea integer;
    i integer;
    ldc_total decimal;
begin


    select into r_adc_house_factura1 * 
    from adc_house_factura1
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and linea_house = ai_linea_house
    and linea_manejo is null;
    if found then
        return 0;
    end if;

    select into r_adc_manifiesto * from adc_manifiesto
    where compania = as_compania
    and consecutivo = ai_consecutivo;
    if not found then
        return 0;
    end if;


/*    
    if r_adc_manifiesto.fecha <= ''2008-12-31'' then
        return 0;
    end if;
*/    

    select into r_adc_house * from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and linea_house = ai_linea_house;
    if not found then
        raise exception ''no encontre el house'';
    end if;

    
    select into r_fac_cajas * from fac_cajas
    where almacen = r_adc_house.almacen
    and status = ''A'';
    if not found then
        Raise Exception ''No encontre la caja'';
    end if;

    ldc_total := 0;

    
    if (r_adc_house.cargo = 0 and r_adc_house.gtos_d_origen = 0 and r_adc_house.dthc = 0) or
        (r_adc_house.cargo_prepago = ''S'' and r_adc_house.gtos_prepago = ''S'' and r_adc_house.dthc_prepago = ''S'') then
        return 0;
    end if;


    
    if (r_adc_house.cargo_prepago = ''S'' and r_adc_house.gtos_d_origen = 0)
        or (r_adc_house.dthc_prepago = ''S'' and r_adc_house.dthc = 0) then
        return 0;
    end if;

    
    if not (r_adc_house.cargo <> 0 and r_adc_house.cargo_prepago = ''N'') and 
        not (r_adc_house.dthc <> 0 and r_adc_house.dthc_prepago = ''N'') and 
        not (r_adc_house.gtos_d_origen <> 0 and r_adc_house.gtos_prepago = ''N'') then
        return 0;
    end if;            



    select into r_adc_house_factura1 * 
    from factura1, adc_house_factura1, factmotivos
    where factura1.almacen = adc_house_factura1.almacen
    and factura1.tipo = adc_house_factura1.tipo
    and factura1.caja = adc_house_factura1.caja
    and factura1.num_documento = adc_house_factura1.num_documento
    and factura1.tipo = factmotivos.tipo
    and (factmotivos.cotizacion = ''S'' or factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
    and factura1.status <> ''A''
    and adc_house_factura1.compania = as_compania
    and adc_house_factura1.consecutivo = ai_consecutivo
    and adc_house_factura1.linea_master = ai_linea_master
    and adc_house_factura1.linea_house = ai_linea_house
    and adc_house_factura1.linea_manejo is null;
    if found then
        return 0;
    end if;


      
    select into r_factmotivos * from factmotivos where cotizacion = ''S'';

    
    select into r_adc_master * from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        return 0;
    end if;

    
    select into r_clientes * from clientes
    where cliente = r_adc_house.cliente;
    
    
    select into r_adc_manifiesto * from adc_manifiesto
    where compania = as_compania
    and consecutivo = ai_consecutivo;
    if not found then
        Raise Exception ''No se encontro manifiesto %'', ai_consecutivo;
    end if;


    select into r_gralperiodos * from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and r_adc_manifiesto.fecha between inicio and final
    and estado = ''I'';
    if found then
        return 0;
    end if;


   
    select into r_navieras * from navieras
    where cod_naviera = r_adc_manifiesto.cod_naviera;
    
    select into r_fact_referencias * from fact_referencias
    where referencia = r_adc_manifiesto.referencia;
    
    if r_fact_referencias.tipo = ''E'' then
        ls_ciudad := r_adc_manifiesto.ciudad_destino;
        ls_agente := r_adc_manifiesto.to_agent;
    else
        ls_ciudad := r_adc_manifiesto.ciudad_origen;
        ls_agente := r_adc_manifiesto.from_agent;
    end if;        
    
    
    select into r_adc_parametros_contables * from adc_parametros_contables
    where referencia = r_adc_manifiesto.referencia
    and trim(ciudad) = trim(ls_ciudad);
    if not found then
        Raise Exception ''Manifiesto % no tiene afectacion contable definida...Verifique'', ai_consecutivo;
    end if;
    
    select into r_articulos_por_almacen * from articulos_por_almacen
    where trim(cuenta) = trim(r_adc_parametros_contables.cta_ingreso)
    and almacen = r_adc_house.almacen;
    if not found then
        Raise Exception ''No existe articulo para la cuenta % en el almacen %...Verifique'', r_adc_parametros_contables.cta_ingreso, r_adc_house.almacen;
    end if;
    
    select into r_articulos_por_almacen * from articulos_por_almacen
    where trim(cuenta) = trim(r_adc_parametros_contables.cta_ingreso)
    and trim(articulo) = trim(r_adc_parametros_contables.cta_ingreso)
    and almacen = r_adc_house.almacen;
    if not found then
        for r_articulos_por_almacen in select * from articulos_por_almacen
                                        where trim(cuenta) = trim(r_adc_parametros_contables.cta_ingreso)
                                        and almacen = r_adc_house.almacen
                                        order by articulo
        loop
            exit;
        end loop;
    end if;    
    
    
    select into r_cglcuentas * from cglcuentas
    where cuenta = r_adc_parametros_contables.cta_costo
    and auxiliar_1 = ''S'';
    if found then
        ls_aux1 := ls_agente;
    else
        ls_aux1 := null;
    end if;        
        
    ls_observacion := ''LOTE: '' || trim(r_adc_manifiesto.no_referencia) || ''  MASTER: '' || trim(r_adc_master.no_bill);
    
    li_num_documento := 0;

    select into r_clientes *
    from clientes
    where cliente = r_adc_house.cliente
    and status = ''I'';
    if found then
        return 0;
    end if;

    select into r_clientes *
    from clientes
    where cliente = r_adc_house.cliente;

    
    select into r_factura1 * from factura1, factmotivos
    where almacen = r_adc_house.almacen
    and caja = r_fac_cajas.caja
    and factura1.tipo = factmotivos.tipo
    and cliente = r_adc_house.cliente
    and fecha_factura = current_date
    and trim(no_referencia) = trim(r_adc_manifiesto.no_referencia)
    and trim(mbl) = Trim(r_adc_master.no_bill)
    and trim(hbl) = trim(r_adc_house.no_house)
    and trim(vapor) = Trim(r_adc_manifiesto.vapor)
    and trim(cod_destino) = Trim(r_adc_house.cod_destino)
    and factmotivos.cotizacion = ''S'';
    if found then
        li_num_documento = r_factura1.num_documento;
    else
        loop
            li_num_documento := li_num_documento + 1;    
        
            select into r_factura1 * from factura1
            where almacen = r_adc_house.almacen
            and tipo = r_factmotivos.tipo
            and caja = r_fac_cajas.caja
            and num_documento = li_num_documento;
            if not found then
                exit;
            end if;
        end loop;

        if r_adc_house.vendedor is null then
            r_adc_house.vendedor = ''00'';
        end if;    

        if r_adc_house.observacion is null then
            r_adc_house.observacion = '' '';
        end if;
        
        ls_observacion = ''FECHA DE LLEGADA: '' || Trim(to_char(r_adc_manifiesto.fecha_arrive, ''DD-MON-YYYY''));

        if r_clientes.nomb_cliente is null then
            r_clientes.nomb_cliente = ''PONER NOMBRE'';
        end if;

        insert into factura1(almacen, tipo, num_documento, cliente, forma_pago, codigo_vendedor,
            nombre_cliente, descto_porcentaje, descto_monto, usuario_captura, usuario_postea,
            fecha_vencimiento, fecha_captura, fecha_postea, fecha_factura, status,
            num_cotizacion, num_factura, observacion, despachar, documento, aplicacion,
            referencia, no_referencia, mbl, hbl, vapor, embarcador, direccion1, direccion2,
            cod_destino, cod_naviera, ciudad_origen, ciudad_destino, agente, bultos, peso, facturar, caja)
        values (r_adc_house.almacen, r_factmotivos.tipo, li_num_documento,
            r_adc_house.cliente, r_clientes.forma_pago, r_adc_house.vendedor, substring(trim(r_clientes.nomb_cliente) from 1 for 50), 
            0, 0, current_user, current_user, current_date, current_timestamp, current_date, 
            current_date,
            ''R'', 0, 0, trim(ls_observacion), ''N'', 0, ''FAC'', r_adc_manifiesto.referencia, 
            r_adc_manifiesto.no_referencia, r_adc_master.no_bill, r_adc_house.no_house, 
            r_adc_manifiesto.vapor, r_adc_house.embarcador, r_adc_house.direccion1, r_adc_house.direccion2, 
            r_adc_house.cod_destino, r_adc_manifiesto.cod_naviera, r_adc_manifiesto.ciudad_origen,
            r_adc_manifiesto.ciudad_destino, ls_agente, 0, 0, ''N'', r_fac_cajas.caja);
    end if;



    select into r_factura1 *
    from factura1
    where almacen = r_adc_house.almacen
    and tipo = r_factmotivos.tipo
    and caja = r_fac_cajas.caja
    and num_documento = li_num_documento;
    if not found then
        raise exception ''no la encontre %'', li_num_documento;
    end if;
    
    if r_fact_referencias.medio = ''M'' then
        ls_observacion := ''CONTENEDOR: '' || trim(r_adc_master.container) || ''  '' || 
                            ''SELLO: '' || trim(r_adc_master.sello) || '' / '' || trim(r_adc_master.tamanio) ||
                            '' PIES.  '' || ''SON '' || 
                            r_adc_house.pkgs || '' CTNS, '' || r_adc_house.kgs || ''KGS, '' || 
                            r_adc_house.cbm || ''CBM'';
    else
        ls_observacion := ''COMPUESTO POR '' || r_adc_house.pkgs || '' PIEZAS: '' || 
                            r_adc_house.kgs || '' KGS, '' || r_adc_house.cbm || ''CBM'';
    end if;
    
    li_linea := 0;
    select into li_linea Max(linea) from factura2
    where almacen = r_adc_house.almacen
    and tipo = r_factura1.tipo
    and caja = r_fac_cajas.caja
    and num_documento = r_factura1.num_documento;
    if li_linea is null then
        li_linea := 1;
    else
        li_linea := li_linea + 1;
    end if;


    if r_adc_house.cargo <> 0 and r_adc_house.cargo_prepago = ''N'' then        
        loop
            select into r_factura2 *
            from factura2
            where almacen = r_adc_house.almacen
            and tipo = r_factmotivos.tipo
            and num_documento = li_num_documento
            and caja = r_fac_cajas.caja
            and linea = li_linea;
            if not found then
                select into r_work *
                from factura1
                where almacen = r_adc_house.almacen
                and caja = r_fac_cajas.caja
                and tipo = r_factmotivos.tipo
                and num_documento = li_num_documento;
                if found then
                    insert into factura2 (almacen, tipo, num_documento, linea,
                        articulo, cantidad, precio, descuento_linea, descuento_global,
                        observacion, cif, caja)
                    values (r_adc_house.almacen, r_factmotivos.tipo, li_num_documento, li_linea,
                        r_articulos_por_almacen.articulo, 1, r_adc_house.cargo, 0, 0, ls_observacion,
                        0, r_fac_cajas.caja);
                    ldc_total := ldc_total + r_adc_house.cargo;
                end if;                    
                exit;
            end if;
            li_linea = li_linea + 1;
        end loop;
    end if;            


    if r_adc_house.dthc > 0 and (r_adc_house.dthc_prepago = ''N'' or r_adc_house.dthc_prepago is null) then
        li_linea := li_linea + 1;
        
        ls_observacion := ''DTHC'';
            select into r_work *
            from factura1
            where almacen = r_adc_house.almacen
            and caja = r_fac_cajas.caja
            and tipo = r_factmotivos.tipo
            and num_documento = li_num_documento;
            if found then
                insert into factura2 (almacen, tipo, num_documento, linea,
                    articulo, cantidad, precio, descuento_linea, descuento_global,
                    observacion, cif, caja)
                values (r_adc_house.almacen, r_factmotivos.tipo, li_num_documento, li_linea,
                    r_articulos_por_almacen.articulo, 1, r_adc_house.dthc, 0, 0, ls_observacion,
                    0, r_fac_cajas.caja);
                    
                ldc_total := ldc_total + r_adc_house.dthc;
            end if;
    
    end if;

    
    if r_adc_house.gtos_d_origen <> 0 and r_adc_house.gtos_prepago = ''N'' then
        li_linea := li_linea + 1;
        
        select into r_work *
        from factura1
        where almacen = r_adc_house.almacen
        and caja = r_fac_cajas.caja
        and tipo = r_factmotivos.tipo
        and num_documento = li_num_documento;
        if found then

            ls_observacion = r_adc_house.observacion;
            insert into factura2 (almacen, tipo, num_documento, linea,
                articulo, cantidad, precio, descuento_linea, descuento_global,
                observacion, cif, caja)
            values (r_adc_house.almacen, r_factmotivos.tipo, li_num_documento, li_linea,
                r_articulos_por_almacen.articulo, 1, r_adc_house.gtos_d_origen, 0, 0, ls_observacion,
                0, r_fac_cajas.caja);
            
            ldc_total := ldc_total + r_adc_house.gtos_d_origen;
        end if;
    end if;

    i   =   f_update_factura4(r_adc_house.almacen, r_factmotivos.tipo, li_num_documento, r_fac_cajas.caja);    
        
    insert into adc_house_factura1 (compania, consecutivo, linea_master, linea_house,
        almacen, tipo, num_documento, caja)
    values (r_adc_house.compania, r_adc_house.consecutivo, r_adc_house.linea_master,
        r_adc_house.linea_house, r_adc_house.almacen, r_factmotivos.tipo, li_num_documento, r_fac_cajas.caja);

    
    return 1;
end;
' language plpgsql;
