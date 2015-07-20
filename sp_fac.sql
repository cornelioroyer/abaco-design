
set search_path to dba;


drop function f_factura1_cglposteo(char(2), char(3), int4, char(3)) cascade;
--drop function f_factura1_cglposteo(char(2), char(3), int4) cascade;

-- drop function f_factura_x_rubro(char(2), char(3), int4, char(15)) cascade;
drop function f_factura_x_rubro(char(2), char(3), int4, char(3), char(15)) cascade;


drop function f_monto_factura(char(2), char(3), int4) cascade;
-- drop function f_monto_factura(char(2), char(3), int4, char(3)) cascade;

drop function f_postea_fac(char(2)) cascade;
drop function f_factura2_eys2(char(2), char(3), int4, char(3), int4) cascade;
drop function f_actualiza_precios(char(2), char(10), char(25));
-- drop function f_desglose_factura(char(2), char(3), int4, char(30)) cascade;
drop function f_desglose_factura(char(2), char(3), int4, char(3), char(30)) cascade;
drop function f_factura2_costo(char(2), char(3), int4, int4, char(30)) cascade;
-- drop function f_update_factura4(char(2), char(3), int4) cascade;
drop function f_update_factura4(char(2), char(3), int4, char(3)) cascade;

-- drop function f_desglose_factura_x_linea(char(2), char(3), int4, int4, char(30)) cascade;
drop function f_desglose_factura_x_linea(char(2), char(3), int4, char(3), int4, char(30)) cascade;
--drop function f_fac_vtas_vs_depositos(char(2), date, date) cascade;
-- drop function f_update_factura8(char(2), char(3), int4) cascade;
drop function f_update_factura8(char(2), char(3), int4, char(3)) cascade;
-- drop function f_factura1_ciudad(char(2), char(3), int4) cascade;
drop function f_factura1_ciudad(char(2), char(3), int4, char(3)) cascade;
drop function f_factura2_factura3(char(2), char(3), int4, char(3), int4) cascade;
drop function f_facturas_en_desbalance(char(2)) cascade;
drop function f_monto_factura_new(char(2), char(3), int4, char(3)) cascade;
drop function f_factura1(char(2), char(3), int4, char(3), char(50)) cascade;
drop function f_delete_rela_factura1_cglposteo(char(2), char(3), char(3), int4) cascade;
--drop function f_fac_vtas_vs_depositos(char(2), char(3), date, date) cascade;

drop function f_fac_vtas_vs_depositos(char(2), date, date) cascade;
drop function f_monto_factura(char(2), char(3), char(3), int4) cascade;
drop function f_factura2_costo(char(2), char(2), char(3), int4, int4, char(30)) cascade;

--drop function f_factura2_eys2(char(2), char(3), int4, char(3), int4) cascade;


create function f_factura2_costo(char(2), char(2), char(3), int4, int4, char(30)) returns decimal as '
declare
    as_almacen alias for $1;
    as_caja alias for $2;
    as_tipo alias for $3;
    ai_num_documento alias for $4;
    ai_linea alias for $5;
    as_rubro alias for $6;
    ldc_retorno decimal(15,4);
    ldc_work decimal;
    r_factura2 record;
    r_articulos record;
begin
    ldc_retorno = 0;
    
    select into r_factura2 * from factura2
    where factura2.almacen = as_almacen
    and factura2.caja = as_caja
    and factura2.tipo = as_tipo
    and factura2.num_documento = ai_num_documento
    and factura2.linea = ai_linea;
    if not found then
        return 0;
    end if;
    
    select into r_articulos * from articulos
    where articulo = r_factura2.articulo
    and servicio = ''S'';
    if found then
        return 0;
    end if;
    
    if trim(as_rubro) = ''COSTO'' then
        select into ldc_retorno -sum(eys2.costo*invmotivos.signo)
        from factura2_eys2, eys2, invmotivos, eys1
        where eys1.almacen = eys2.almacen
        and eys1.no_transaccion = eys2.no_transaccion
        and eys1.motivo = invmotivos.motivo
        and factura2_eys2.articulo = eys2.articulo
        and factura2_eys2.almacen = eys2.almacen
        and factura2_eys2.no_transaccion = eys2.no_transaccion
        and factura2_eys2.eys2_linea = eys2.linea
        and factura2_eys2.articulo = r_factura2.articulo
        and eys2.articulo = r_factura2.articulo
        and factura2_eys2.almacen = as_almacen
        and factura2_eys2.caja = as_caja
        and factura2_eys2.tipo = as_tipo
        and factura2_eys2.num_documento = ai_num_documento
        and factura2_eys2.factura2_linea = ai_linea;
        if not found or ldc_retorno = 0 or ldc_retorno is null then
            select into ldc_retorno -sum(eys2.costo*invmotivos.signo)
            from invmotivos, eys1, eys2, tal_ot1, tal_ot2_eys2
            where eys1.almacen = eys2.almacen
            and eys1.no_transaccion = eys2.no_transaccion
            and eys1.motivo = invmotivos.motivo
            and tal_ot1.almacen = tal_ot2_eys2.almacen
            and tal_ot1.no_orden = tal_ot2_eys2.no_orden
            and tal_ot1.tipo = tal_ot2_eys2.tipo
            and eys2.almacen = tal_ot2_eys2.almacen
            and eys2.no_transaccion = tal_ot2_eys2.no_transaccion
            and eys2.linea = tal_ot2_eys2.linea_eys2
            and tal_ot1.almacen = as_almacen
            and tal_ot1.tipo_factura = as_tipo
            and tal_ot1.numero_factura = ai_num_documento
            and eys2.articulo = r_factura2.articulo;
        end if;
    else
        select into ldc_retorno sum(factura3.monto*factmotivos.signo)
        from factmotivos, factura3
        where factura3.tipo = factmotivos.tipo
        and factura3.almacen = as_almacen
        and factura3.caja = as_caja
        and factura3.tipo = as_tipo
        and factura3.num_documento = ai_num_documento
        and factura3.linea = ai_linea;
    end if;

    if ldc_retorno is null then
        ldc_retorno = 0;
    end if;
    return ldc_retorno;
end;
' language plpgsql;



create function f_factura2_eys2(char(2), char(3), int4, char(3), int4) returns integer as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    as_caja alias for $4;
    ai_linea alias for $5;
    r_factmotivos record;
    r_factura1 record;
    r_factura2 record;
    r_eys1 record;
    r_eys2 record;
    r_eys3 record;
    r_work1 record;
    r_articulos record;
    ldc_costo decimal(12,4);
    ldc_cantidad decimal(12,4);
    ldc_cu decimal(12,4);
    li_linea integer;
    ls_cuenta_costo char(24);
    ldc_sum_eys2 decimal(12,4);
    ldc_sum_eys3 decimal(12,4);
    ldc_work decimal(12,4);
begin
    ldc_cu = 0;    

    
    delete from factura2_eys2
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and factura2_linea = ai_linea
    and caja = as_caja;
    
    
    select into r_factura2 * from factura2
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and linea = ai_linea
    and caja = as_caja;
    if not found then
        return 0;
    end if;

        
    select into r_articulos * from articulos
    where articulo =  r_factura2.articulo
    and servicio = ''S'';
    if found then
        return 0;
    end if;
   
    
    select into r_factura1 factura1.* from factura1, factmotivos
    where factura1.tipo = factmotivos.tipo
    and factura1.almacen = as_almacen
    and factura1.tipo = as_tipo
    and factura1.num_documento = ai_num_documento
    and factura1.caja = as_caja
    and (factmotivos.nota_credito = ''S'' 
    or factmotivos.cotizacion = ''S'' or factura1.status = ''A'');
    if found then
       return 0;
    end if;
    
    select into r_factura1 * from factura1
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and caja = as_caja;
    
    if r_factura1.status = ''A'' or r_factura1.despachar = ''N'' or r_factura1.fecha_despacho is null then
       return 0;
    end if;
    
    if r_factura1.aplicacion = ''TAL'' then
        return 0;
    end if;
    
    select into r_factmotivos * from factmotivos
    where tipo = as_tipo;

    
    select into r_eys1 eys1.* from eys1
    where eys1.almacen = as_almacen
    and eys1.motivo = r_factmotivos.motivo
    and eys1.aplicacion_origen = ''FAC''
    and eys1.fecha = r_factura1.fecha_despacho;
    if not found then
       r_eys1.no_transaccion      =  f_sec_inventario(as_almacen); 
       insert into eys1 (almacen, no_transaccion, motivo, aplicacion_origen, 
        fecha, usuario, fecha_captura, status) 
       values (as_almacen, r_eys1.no_transaccion, r_factmotivos.motivo,
        ''FAC'', r_factura1.fecha_despacho, current_user, current_timestamp, ''R'');
    end if;
    
    if r_factmotivos.devolucion = ''S'' then
        select into ldc_cu eys2.costo/eys2.cantidad
        from factura2, factura2_eys2, eys2
        where factura2.almacen = factura2_eys2.almacen
        and factura2.tipo = factura2_eys2.tipo
        and factura2.num_documento = factura2_eys2.num_documento
        and factura2.linea = factura2_eys2.factura2_linea
        and factura2.articulo = factura2_eys2.articulo
        and factura2_eys2.articulo = eys2.articulo
        and factura2_eys2.almacen = eys2.almacen
        and factura2_eys2.no_transaccion = eys2.no_transaccion
        and factura2_eys2.eys2_linea = eys2.linea
        and factura2.almacen = r_factura1.almacen_aplica
        and factura2.articulo = r_factura2.articulo
        and eys2.articulo = r_factura2.articulo
        and factura2.caja = r_factura1.caja_aplica
        and factura2.num_documento = r_factura1.num_factura;
--raise exception ''%'', ldc_cu;        
        if not found then
            ldc_cu  =  f_stock(r_factura2.almacen, r_factura2.articulo, r_factura1.fecha_despacho, 0, 0, ''CU'');
        end if;
    else
          ldc_cu  =   f_stock(r_factura2.almacen, r_factura2.articulo,r_factura1.fecha_despacho, 0, 0, ''CU'');
    end if;
    
    
    select into li_linea max(eys2.linea) from eys2
    where almacen = as_almacen
    and no_transaccion = r_eys1.no_transaccion;
    if li_linea is null then
        li_linea = 1;
    else
        li_linea = li_linea + 1;
    end if;
    
    if ldc_cu is null then
        raise exception ''costo unitario no puede ser nulo...documento %'', ai_num_documento;
    end if;
    
    
    select into ls_cuenta_costo facparamcgl.cuenta_costo
    from articulos_por_almacen, articulos_agrupados, facparamcgl
    where articulos_por_almacen.articulo = articulos_agrupados.articulo
    and articulos_agrupados.codigo_valor_grupo = facparamcgl.codigo_valor_grupo
    and articulos_por_almacen.almacen = facparamcgl.almacen
    and articulos_por_almacen.almacen = r_factura2.almacen
    and articulos_por_almacen.articulo = r_factura2.articulo;
    if ls_cuenta_costo is null or not found then
        select into ls_cuenta_costo fac_parametros_contables.cta_de_costo
        from articulos_agrupados, fac_parametros_contables
        where articulos_agrupados.codigo_valor_grupo = fac_parametros_contables.codigo_valor_grupo
        and articulos_agrupados.articulo = r_factura2.articulo
        and fac_parametros_contables.almacen = r_factura2.almacen
        and fac_parametros_contables.referencia = r_factura1.referencia;
        if Not Found or ls_cuenta_costo is null then
            raise exception ''No existe cuenta de costo para el articulo % en la factura %'', r_factura2.articulo, r_factura2.num_documento;
        end if;                
    end if;

/*
if trim(ls_cuenta_costo) = ''6150100'' then
    raise exception ''entre'';
end if;
*/
    
    INSERT INTO eys2 ( articulo, almacen, no_transaccion, linea, cantidad, costo, cuenta ) 
    VALUES (r_factura2.articulo, r_factura2.almacen, r_eys1.no_transaccion,
    li_linea, r_factura2.cantidad, (ldc_cu * r_factura2.cantidad), ls_cuenta_costo);

    
    insert into factura2_eys2 (articulo, almacen, no_transaccion, eys2_linea,
    tipo, num_documento, factura2_linea, caja)
    values (r_factura2.articulo, r_factura2.almacen, r_eys1.no_transaccion,
    li_linea, r_factura2.tipo, r_factura2.num_documento, r_factura2.linea, as_caja);
    
    
    delete from eys3
    where trim(almacen) = trim(as_almacen)
    and no_transaccion = r_eys1.no_transaccion
    and trim(cuenta) = trim(ls_cuenta_costo);
    
    
    select into ldc_sum_eys2 sum(costo) from eys2
    where trim(almacen) = trim(r_factura2.almacen)
    and no_transaccion = r_eys1.no_transaccion;
    if ldc_sum_eys2 is null then
        ldc_sum_eys2 = 0;
    end if;
    
    
    select into ldc_sum_eys3 sum(monto) from eys3
    where trim(almacen) = trim(r_eys1.almacen)
    and no_transaccion = r_eys1.no_transaccion;
    if ldc_sum_eys3 is null then
        ldc_sum_eys3 = 0;
    end if;
    
    
    ldc_work = ldc_sum_eys2 - ldc_sum_eys3;
/*
        select into r_eys3 *
        from eys3
        where almacen = as_almacen
        and no_transaccion = r_eys1.no_transaccion
        and cuenta = ls_cuenta_costo;
        if not found then
        else
        
            update eys3
            set monto = ldc_work - ldc_work
            where almacen = as_almacen
            and no_transaccion = r_eys1.no_transaccion
            and cuenta = ls_cuenta_costo;

*/  


    if ldc_work <> 0 then
        INSERT INTO eys3 ( almacen, no_transaccion, cuenta, auxiliar1, auxiliar2, monto ) 
        VALUES ( as_almacen, r_eys1.no_transaccion, ls_cuenta_costo, null, null,
            ldc_work);
    end if;    
    
    return 1;
end;
' language plpgsql;

create function f_monto_factura(char(2), char(3), char(3), int4) returns decimal(10,2) as '
declare
    as_almacen alias for $1;
    as_caja alias for $2;
    as_tipo alias for $3;
    ai_num_documento alias for $4;
    ldc_sum_factura2 decimal(10,2);
    ldc_sum_factura3 decimal(10,2);
    r_factmotivos record;
    r_factura1 record;
    i integer;
begin

    select into r_factura1 * from factura1
    where almacen = as_almacen
    and caja = as_caja
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    if not found then
        return 0;
    end if;
    
    if r_factura1.status = ''A'' then
        return 0;
    end if;
    
    select into ldc_sum_factura2 sum((cantidad*precio)-descuento_linea-descuento_global) 
    from factura2
    where almacen = as_almacen
    and caja = as_caja
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    
    if ldc_sum_factura2 is null then
       ldc_sum_factura2 := 0;
    end if;
    
    select into ldc_sum_factura3 sum(monto) 
    from factura3
    where almacen = as_almacen
    and caja = as_caja
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    
    if ldc_sum_factura3 is null then
       ldc_sum_factura3 = 0;
    end if;
    
    select into r_factmotivos * from factmotivos
    where tipo = as_tipo;
    
    return ((ldc_sum_factura2 + ldc_sum_factura3) * r_factmotivos.signo);
end;
' language plpgsql;


create function f_fac_vtas_vs_depositos(char(2), date, date) returns integer as '
declare
    as_compania alias for $1;
    ad_desde alias for $2;
    ad_hasta alias for $3;
    ld_work date;
    ldc_work decimal;
    ldc_venta_neta_credito decimal;
    ldc_venta_neta_contado decimal;
    ldc_itbm_credito decimal;
    ldc_itbm_contado decimal;
    ldc_deposito_1 decimal;
    ldc_deposito_2 decimal;
    ldc_deposito_3 decimal;
    ldc_deposito_4 decimal;
    ldc_recibos decimal;
    li_ini_factura int4;
    li_fin_factura int4;
    li_ini_recibo char(25);
    li_fin_recibo char(25);
    as_almacen char(2);
    as_caja char(3);
    r_fac_cajas record;
begin
    delete from fac_vtas_vs_depositos 
    where usuario = current_user;
    
    ld_work = ad_desde;
    while ld_work <= ad_hasta loop
        for r_fac_cajas in select fac_cajas.* 
                            from fac_cajas, almacen
                            where fac_cajas.almacen = almacen.almacen
                            and almacen.compania = as_compania
                            order by fac_cajas.almacen, fac_cajas.caja
        loop
            as_almacen  =   r_fac_cajas.almacen;
            as_caja     =   r_fac_cajas.caja;
            select into ldc_venta_neta_contado 
            Sum(f_desglose_factura(factura1.almacen, tipo, num_documento, caja,
            ''VENTA_NETA_CONTADO''))
            from factura1, almacen
            where factura1.almacen = almacen.almacen
            and factura1.fecha_factura = ld_work
            and factura1.status <> ''A''
            and factura1.almacen = as_almacen
            and factura1.caja = as_caja;
            if ldc_venta_neta_contado is null then
                ldc_venta_neta_contado = 0;
            end if;
        
        
            select into ldc_venta_neta_credito 
            Sum(f_desglose_factura(factura1.almacen, tipo, 
            num_documento, caja, ''VENTA_NETA_CREDITO''))
            from factura1, almacen
            where factura1.almacen = almacen.almacen
            and factura1.fecha_factura = ld_work
            and factura1.status <> ''A''
            and factura1.almacen = as_almacen
            and factura1.caja = as_caja;
            if ldc_venta_neta_credito is null then
                ldc_venta_neta_credito = 0;
            end if;
        
            select into ldc_itbm_contado Sum(f_desglose_factura(factura1.almacen, 
            tipo, num_documento, caja, ''ITBM_CONTADO''))
            from factura1, almacen
            where factura1.almacen = almacen.almacen
            and factura1.fecha_factura = ld_work
            and factura1.status <> ''A''
            and factura1.almacen = as_almacen
            and factura1.caja = as_caja;
            if ldc_itbm_contado is null then
                ldc_itbm_contado = 0;
            end if;
        
            select into ldc_itbm_credito Sum(f_desglose_factura(factura1.almacen, tipo, num_documento, caja, ''ITBM_CREDITO''))
            from factura1, almacen
            where factura1.almacen = almacen.almacen
            and factura1.fecha_factura = ld_work
            and factura1.status <> ''A''
            and factura1.almacen = as_almacen
            and factura1.caja = as_caja;
            if ldc_itbm_credito is null then
                ldc_itbm_credito = 0;
            end if;
        
        
            select into li_ini_factura Min(num_documento)
            from factura1, almacen, factmotivos
            where factura1.tipo = factmotivos.tipo
            and factura1.almacen = almacen.almacen
            and factura1.fecha_factura = ld_work
            and factmotivos.factura_fiscal = ''S''
            and factura1.almacen = as_almacen
            and factura1.caja = as_caja;
            if li_ini_factura is null then
                li_ini_factura = 0;
            end if;
        
            select into li_fin_factura Max(num_documento)
            from factura1, almacen, factmotivos
            where factura1.tipo = factmotivos.tipo
            and factura1.almacen = almacen.almacen
            and factura1.fecha_factura = ld_work
            and factmotivos.factura_fiscal = ''S''
            and factura1.almacen = as_almacen
            and factura1.caja = as_caja;
            if li_fin_factura is null then
                li_fin_factura = 0;
            end if;
        
            select into li_ini_recibo Min(documento)
            from cxc_recibo1, almacen
            where cxc_recibo1.almacen = almacen.almacen
            and cxc_recibo1.almacen = as_almacen
            and cxc_recibo1.caja = as_caja
            and cxc_recibo1.fecha = ld_work;
            if li_ini_recibo is null then
                li_ini_recibo = 0;
            end if;
        
            select into li_fin_recibo Max(documento)
            from cxc_recibo1, almacen
            where cxc_recibo1.almacen = almacen.almacen
            and cxc_recibo1.almacen = as_almacen
            and cxc_recibo1.caja = as_caja
            and cxc_recibo1.fecha = ld_work;
            if li_fin_recibo is null then
                li_fin_recibo = 0;
            end if;
        
        
            select into ldc_deposito_1 sum(bcotransac1.monto)
            from bcotransac1, bcoctas, bcomotivos
            where bcotransac1.cod_ctabco = bcoctas.cod_ctabco
            and bcotransac1.motivo_bco = bcomotivos.motivo_bco
            and bcomotivos.signo = 1
            and (bcomotivos.motivo_bco in (''D1'')
            or bcomotivos.desc_motivo_bco = ''DEPOSITO''
            or trim(bcomotivos.desc_motivo_bco) = ''DEPOSITOS''
            or bcomotivos.desc_motivo_bco = ''DEPOSITO COBROS''
            or bcomotivos.desc_motivo_bco = ''DEPOSITO VENTAS''
            or bcomotivos.tipo_deposito = 1)
            and bcomotivos.almacen = as_almacen
            and bcomotivos.caja = as_caja
            and bcotransac1.fecha_posteo = ld_work;
            if ldc_deposito_1 is null then
                ldc_deposito_1 = 0;
            end if;

    
        
            select into ldc_deposito_2 sum(bcotransac1.monto)
            from bcotransac1, bcoctas, bcomotivos
            where bcotransac1.cod_ctabco = bcoctas.cod_ctabco
            and bcotransac1.motivo_bco = bcomotivos.motivo_bco
            and bcomotivos.signo = 1
            and (bcomotivos.motivo_bco = ''D2'' 
                    or bcomotivos.tipo_deposito = 2)
            and bcomotivos.almacen = as_almacen
            and bcomotivos.caja = as_caja
            and bcotransac1.fecha_posteo = ld_work;
            if ldc_deposito_2 is null then
                ldc_deposito_2 = 0;
            end if;
            
        
            select into ldc_deposito_3 sum(bcotransac1.monto)
            from bcotransac1, bcoctas, bcomotivos
            where bcotransac1.cod_ctabco = bcoctas.cod_ctabco
            and bcotransac1.motivo_bco = bcomotivos.motivo_bco
            and bcomotivos.signo = 1
            and (bcomotivos.motivo_bco = ''D3''
                    or bcomotivos.tipo_deposito = 3)
            and bcomotivos.almacen = as_almacen
            and bcomotivos.caja = as_caja
            and bcotransac1.fecha_posteo = ld_work;
            if ldc_deposito_3 is null then
                ldc_deposito_3 = 0;
            end if;
        
            select into ldc_deposito_4 sum(bcotransac1.monto)
            from bcotransac1, bcoctas, bcomotivos
            where bcotransac1.cod_ctabco = bcoctas.cod_ctabco
            and bcotransac1.motivo_bco = bcomotivos.motivo_bco
            and bcomotivos.signo = 1
            and (bcomotivos.motivo_bco = ''D4''
                    or bcomotivos.tipo_deposito = 4)
            and bcomotivos.almacen = as_almacen
            and bcomotivos.caja = as_caja
            and bcotransac1.fecha_posteo = ld_work;
            if ldc_deposito_4 is null then
                ldc_deposito_4 = 0;
            end if;
        
            select into ldc_recibos sum(cxc_recibo1.cheque + cxc_recibo1.efectivo + cxc_recibo1.otro)
            from cxc_recibo1, almacen
            where cxc_recibo1.almacen = almacen.almacen
            and cxc_recibo1.almacen = as_almacen
            and cxc_recibo1.caja = as_caja
            and cxc_recibo1.status <> ''A''
            and cxc_recibo1.fecha = ld_work;
            if ldc_recibos is null then
                ldc_recibos = 0;
            end if;
        
            insert into fac_vtas_vs_depositos (almacen, caja, usuario, fecha, ini_factura, fin_factura,
                ini_recibo, fin_recibo, vta_contado, itbm_contado, vta_credito, itbm_credito, recibos, depositos_1,
                depositos_2, depositos_3, depositos_4)
            values(as_almacen, as_caja, current_user, ld_work, li_ini_factura, li_fin_factura, li_ini_recibo, li_fin_recibo, 
                ldc_venta_neta_contado, ldc_itbm_contado, ldc_venta_neta_credito, ldc_itbm_credito,
                ldc_recibos, ldc_deposito_1, ldc_deposito_2, ldc_deposito_3, ldc_deposito_4);
        end loop;                            
        ld_work =   ld_work + 1;
    end loop;

    delete from fac_vtas_vs_depositos
    where vta_contado = 0 and vta_credito = 0 and recibos = 0
    and depositos_1 = 0 and depositos_2 = 0 and depositos_3 = 0 and depositos_4 = 0;

    return 1;
end;
' language plpgsql;



create function f_delete_rela_factura1_cglposteo(char(2), char(3), char(3), int4) returns integer as '
declare
    as_almacen alias for $1;
    as_caja alias for $2;
    as_tipo alias for $3;
    ai_num_documento alias for $4;
    li_consecutivo int4;
    r_almacen record;
    r_factura1 record;
    r_gral_forma_de_pago record;
    r_factmotivos record;
    i integer;
    lc_documento varchar(10);
begin
    select into r_almacen *
    from almacen
    where almacen = as_almacen;
    if not found then
        Raise Exception ''Almacen % no existe'', as_almacen;
    end if;
    
    select into r_factura1 *
    from factura1
    where almacen = as_almacen
    and caja = as_caja
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    if not found then
        return 0;
--        Raise Exception ''Factura % no Existe'', ai_num_documento;
    end if;
    
    i := f_valida_fecha(r_almacen.compania, ''CGL'', r_factura1.fecha_factura);

    delete from cglposteo
    where consecutivo in 
    (select consecutivo from rela_factura1_cglposteo
    where rela_factura1_cglposteo.almacen = as_almacen
    and rela_factura1_cglposteo.caja = as_caja
    and rela_factura1_cglposteo.tipo = as_tipo
    and rela_factura1_cglposteo.num_documento = ai_num_documento);
    
    delete from rela_factura1_cglposteo
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and caja = as_caja;
    
    select into r_factmotivos * from factmotivos
    where tipo = as_tipo;
    
    delete from cxcdocm
    where almacen = r_factura1.almacen
    and caja = r_factura1.caja
    and motivo_cxc = r_factura1.tipo
    and cliente = r_factura1.cliente
    and trim(documento) = trim(lc_documento)
    and fecha_posteo = r_factura1.fecha_factura;
    
    return 1;
end;
' language plpgsql;



create function f_factura1(char(2), char(3), int4, char(3), char(50)) returns char(60) as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    as_caja alias for $4;
    as_retorno alias for $5;
    r_factura1 record;
    r_fac_ciudades record;
    r_fact_referencias record;
    r_adc_house_factura1 record;
    ls_retorno char(50);
begin
    ls_retorno = null;
    select into r_factura1 *
    from factura1
    where almacen = as_almacen
    and caja = as_caja
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    if not found then
        return ls_retorno;
    end if;

    if trim(as_retorno) = ''CIUDAD'' then    
        select into r_fact_referencias *
        from fact_referencias
        where referencia = r_factura1.referencia;
    
    
        if r_fact_referencias.tipo = ''E'' then
            select into ls_retorno fac_ciudades.nombre
            from fac_ciudades
            where ciudad = r_factura1.ciudad_destino;
        else
            select into ls_retorno fac_ciudades.nombre
            from fac_ciudades
            where ciudad = r_factura1.ciudad_origen;
        end if;
    elsif trim(as_retorno) = ''CONSECUTIVO'' then
        for r_adc_house_factura1 in select *
                        from adc_house_factura1
                        where adc_house_factura1.almacen = as_almacen
                        and adc_house_factura1.tipo = as_tipo
                        and adc_house_factura1.caja = as_caja
                        and adc_house_factura1.num_documento = ai_num_documento
                        order by consecutivo
        loop
            return Trim(to_char(r_adc_house_factura1.consecutivo, ''9999999''));
        end loop;    
    elsif trim(as_retorno) = ''REFERENCIA'' then
        select into r_fact_referencias *
        from fact_referencias
        where referencia = r_factura1.referencia;
        if not found then
            return null;
        else 
            return trim(r_fact_referencias.descripcion);
        end if;
    
    end if;    
    return ls_retorno;
end;
' language plpgsql;



create function f_monto_factura_new(char(2), char(3), int4, char(3)) returns decimal(10,2) as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    as_caja alias for $4;
    ldc_sum_factura2 decimal(10,2);
    ldc_sum_factura3 decimal(10,2);
    r_factmotivos record;
    r_factura1 record;
    i integer;
begin
    select into r_factura1 * from factura1
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = as_caja
    and num_documento = ai_num_documento;
    if not found then
        return 0;
    end if;
    
    if r_factura1.status = ''A'' then
        return 0;
    end if;
    
    select into ldc_sum_factura2 sum((cantidad*precio)-descuento_linea-descuento_global) 
    from factura2
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = as_caja
    and num_documento = ai_num_documento;

    
    if ldc_sum_factura2 is null then
       ldc_sum_factura2 := 0;
    end if;
    
    select into ldc_sum_factura3 sum(monto) 
    from factura3
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = as_caja
    and num_documento = ai_num_documento;
    if ldc_sum_factura3 is null then
       ldc_sum_factura3 := 0;
    end if;


    
    select into r_factmotivos * from factmotivos
    where tipo = as_tipo;
    
    return ((ldc_sum_factura2 + ldc_sum_factura3) * r_factmotivos.signo);
end;
' language plpgsql;


create function f_facturas_en_desbalance(char(2)) returns integer as '
declare
    as_compania alias for $1;
    ld_desde date;
    r_work record;
begin
    select Min(inicio) into ld_desde
    from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and estado = ''A'';
    if not found then
        return 0;
    end if;
    
    for r_work in select factura1.almacen, factura1.tipo, factura1.num_documento, factura1.caja, count(*)
                    from rela_factura1_cglposteo, factura1, almacen, factmotivos
                    where factura1.tipo = factmotivos.tipo
                    and factmotivos.cotizacion = ''N'' and factmotivos.donacion = ''N''
                    and factura1.almacen = almacen.almacen
                    and factura1.almacen = rela_factura1_cglposteo.almacen                    
                    and factura1.tipo = rela_factura1_cglposteo.tipo
                    and factura1.num_documento = rela_factura1_cglposteo.num_documento
                    and factura1.caja = rela_factura1_cglposteo.caja
                    and factura1.fecha_factura >= ld_desde
                    and almacen.compania = as_compania
                    group by 1, 2, 3, 4
                    having count(*) <= 1
                    order by 1, 2, 3
    loop
        delete from rela_factura1_cglposteo
        where almacen = r_work.almacen
        and tipo = r_work.tipo
        and caja = r_work.caja
        and num_documento = r_work.num_documento;
    end loop;
    

    for r_work in select factura1.almacen, factura1.tipo, factura1.num_documento, factura1.caja,
                    sum(cglposteo.debito-cglposteo.credito)
                    from factura1, rela_factura1_cglposteo, cglposteo, almacen, factmotivos
                    where factura1.almacen = almacen.almacen
                    and factura1.tipo = factmotivos.tipo
                    and factmotivos.cotizacion = ''N'' and factmotivos.donacion = ''N''
                    and factura1.tipo = rela_factura1_cglposteo.tipo
                    and factura1.almacen = rela_factura1_cglposteo.almacen                    
                    and factura1.tipo = rela_factura1_cglposteo.tipo
                    and factura1.num_documento = rela_factura1_cglposteo.num_documento
                    and factura1.caja = rela_factura1_cglposteo.caja
                    and rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
                    and factura1.fecha_factura >= ld_desde
                    and almacen.compania = as_compania
                    group by 1, 2, 3, 4
                    having sum(cglposteo.debito-cglposteo.credito) <> 0    
    loop
        delete from rela_factura1_cglposteo
        where almacen = r_work.almacen
        and tipo = r_work.tipo
        and caja = r_work.caja
        and num_documento = r_work.num_documento;
    end loop;

    for r_work in select * from factura1, factmotivos, almacen
        where factura1.tipo = factmotivos.tipo
        and factura1.almacen = almacen.almacen
        and factmotivos.devolucion = ''S''
        and factura1.status <> ''A''
        and factura1.fecha_factura >= ld_desde
        and almacen.compania = as_compania
        and not exists
        (select * from factura1 a, factmotivos b
        where a.tipo = b.tipo
        and b.factura_fiscal = ''S''
        and a.almacen = factura1.almacen
        and a.caja = factura1.caja
        and a.num_documento = factura1.num_factura
        and a.forma_pago = factura1.forma_pago)
    loop
--        Raise Exception ''Devolucion % Factura % deben tener la misma forma de pago'', r_work.num_documento, r_work.num_factura;
    end loop;

    return 1;
end;
' language plpgsql;


create function f_factura2_factura3(char(2), char(3), int4, char(3), int4) returns integer as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    as_caja alias for $4;
    ai_linea alias for $5;
    r_factura2 record;
    r_factura1 record;
    r_clientes_exentos record;
    r_gral_impuestos record;
    r_factura3 record;
    r_almacen record;
    ldc_impuesto decimal(12,4);
begin
    delete from factura3
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and linea = ai_linea
    and caja = as_caja;
    
    if trim(as_tipo) = ''DA'' then
        return 0;
    end if;
        
   
    select into r_factura1 * from factura1
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and caja = as_caja;
    if not found then
        return 0;
    end if;
   
    select into r_almacen *
    from almacen
    where almacen = as_almacen;
    
    select into r_factura2 * from factura2
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and caja = as_caja
    and linea = ai_linea;
    if not found then
        return 0;
    end if;

    for r_gral_impuestos in select gral_impuestos.* 
                                from gral_impuestos, articulos_agrupados, impuestos_por_grupo  
                                where impuestos_por_grupo.impuesto = gral_impuestos.impuesto
                                and articulos_agrupados.codigo_valor_grupo = impuestos_por_grupo.codigo_valor_grupo
                                and articulos_agrupados.articulo = r_factura2.articulo
    loop
        select into r_clientes_exentos * from clientes_exentos
        where impuesto = r_gral_impuestos.impuesto
        and cliente = r_factura1.cliente;
        if not found then
            ldc_impuesto = (r_factura2.precio * r_factura2.cantidad) - r_factura2.descuento_linea - r_factura2.descuento_global;

            if f_gralparaxcia(r_almacen.compania, ''PLA'', ''metodo_calculo'') = ''11conytram'' then
                ldc_impuesto = Round((Round(ldc_impuesto,2) * (r_gral_impuestos.porcentaje/100)),2);
            else
                ldc_impuesto = ldc_impuesto * (r_gral_impuestos.porcentaje/100);
            end if;

            if ldc_impuesto <> 0 then
                select into r_factura3 *
                from factura3
                where almacen = as_almacen
                and tipo = as_tipo
                and caja = as_caja
                and num_documento = ai_num_documento
                and linea = ai_linea
                and impuesto = r_gral_impuestos.impuesto;
                if not found then
                    insert into factura3(almacen, tipo, num_documento, linea, impuesto, monto, caja)
                    values(as_almacen, as_tipo, ai_num_documento, ai_linea, r_gral_impuestos.impuesto,
                            ldc_impuesto, as_caja);
                end if;
            end if;                
        end if;
    end loop;    
    
    return 1;
end;
' language plpgsql;

/*
drop function f_pendiente_de_despachar(char(2), char(3), int4) cascade;

create function f_pendiente_de_despachar(char(2), char(3), int4) returns boolean as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    r_factura1 record;
    r_fac_ciudades record;
    r_fact_referencias record;
    r_factmotivos record;
    r_factura2 record;
    lb_retorno boolean;
begin
    
    select into r_factura1 *
    from factura1
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    if not found then
        return false;
    end if;
    
    select into r_factmotivos *
    from factmotivos
    where tipo = as_tipo;
    if not found then
        return false;
    end if;
    
    if r_factura1.status = ''A'' then
        return false;
    end if;
    
    
    if r_factmotivos.cotizacion = ''S'' then
        return false;
    end if;
    
    if r_factura1.despachar = ''S'' and r_factura1.fecha_despacho is not null then
        return false;
    end if;
    
    select into r_factura2 factura2.*
    from factura2, articulos
    where factura2.articulo = articulos.articulo
    and articulos.servicio = ''N''
    and factura2.almacen = as_almacen
    and factura2.tipo  = as_tipo
    and factura2.num_documento = ai_num_documento;
    if not found then
        return false;
    end if;
    
    if r_factmotivos.factura = ''S'' or r_factmotivos.factura_fiscal = ''S'' then
    
        select into li_count count(*)
        from factura1
        where almacen = as_almacen
        and tipo in (select tipo from factmotivos 
                        where factura_fiscal = ''S'' or factura = ''S''
                        or devolucion = ''S'')
        and (num_documento = ai_num_documento or num_factura = ai_num_documento);
        
        if li_count is null then
            li_count = 0;
        end if;
        
        if li_count >= 2 then
            return false;
        end if;
    end if;
    
   return true;
end;
' language plpgsql;
*/


create function f_factura1_ciudad(char(2), char(3), int4, char(3)) returns char(50) as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    as_caja alias for $4;
    r_factura1 record;
    r_fac_ciudades record;
    r_fact_referencias record;
    ls_retorno char(50);
begin
    ls_retorno = null;
    select into r_factura1 *
    from factura1
    where almacen = as_almacen
    and caja = as_caja
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    if not found then
        return ls_retorno;
    end if;
    
    select into r_fact_referencias *
    from fact_referencias
    where referencia = r_factura1.referencia;
    
    
    if r_fact_referencias.tipo = ''E'' then
        select into ls_retorno fac_ciudades.nombre
        from fac_ciudades
        where ciudad = r_factura1.ciudad_destino;
    else
        select into ls_retorno fac_ciudades.nombre
        from fac_ciudades
        where ciudad = r_factura1.ciudad_origen;
    end if;
    
    return ls_retorno;
end;
' language plpgsql;



create function f_update_factura8(char(2), char(3), int4, char(3)) returns integer as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    as_caja alias for $4;
    ldc_work decimal;
    ls_work text;
begin
    delete from factura8
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = as_caja
    and num_documento = ai_num_documento;

    
    select into ls_work tal_ot1.memo_piezas
    from tal_ot1
    where almacen = as_almacen
    and caja = as_caja
    and tipo_factura = as_tipo
    and numero_factura = ai_num_documento;

    
    
    select into ldc_work sum(factura2.precio*factura2.cantidad)
    from factura2, articulos
    where factura2.articulo = articulos.articulo
    and articulos.servicio = ''N''
    and factura2.almacen = as_almacen
    and factura2.tipo = as_tipo
    and factura2.caja = as_caja
    and factura2.num_documento = ai_num_documento;
    if ldc_work is not null then
        insert into factura8(almacen, tipo, num_documento, memo, monto, caja)
        values(as_almacen, as_tipo, ai_num_documento, ls_work, ldc_work, as_caja);
    end if;
    
    select into ls_work tal_ot1.memo_mo
    from tal_ot1
    where almacen = as_almacen
    and tipo_factura = as_tipo
    and caja = as_caja
    and numero_factura = ai_num_documento;

    
    
    select into ldc_work sum(factura2.precio*factura2.cantidad)
    from factura2, articulos
    where factura2.articulo = articulos.articulo
    and articulos.servicio = ''S''
    and factura2.almacen = as_almacen
    and factura2.tipo = as_tipo
    and factura2.caja = as_caja
    and factura2.num_documento = ai_num_documento;
    if ldc_work is not null then
        insert into factura8(almacen, tipo, num_documento, memo, monto, caja)
        values(as_almacen, as_tipo, ai_num_documento, ls_work, ldc_work, as_caja);
    end if;
    
    return 1;
end;
' language plpgsql;





create function f_desglose_factura_x_linea(char(2), char(3), int4, char(3), int4, char(30)) returns decimal as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    as_caja alias for $4;
    ai_linea alias for $5;
    as_rubro alias for $6;
    ldc_retorno decimal(15,2);
    r_factura1 record;
    r_factmotivos record;
begin
    select into r_factura1 * from factura1
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = as_caja
    and num_documento = ai_num_documento;
    if not found then
        return 0;
    end if;
    
    if r_factura1.status = ''A'' then
        return 0;
    end if;
    
    select into r_factmotivos * from factmotivos
    where tipo = as_tipo;
    if not found then
        return 0;
    end if;
    
    if r_factmotivos.cotizacion = ''S'' then
        return 0;
    end if;
    
    if r_factmotivos.promocion = ''S'' and (as_rubro = ''VENTA'' or as_rubro = ''VENTA_NETA'') then
        return 0;
    end if;
    
    ldc_retorno = 0;
    if trim(as_rubro) = ''VENTA_NETA'' then
        select into ldc_retorno ((factura2.precio*factura2.cantidad)-factura2.descuento_linea-
                    factura2.descuento_global)*factmotivos.signo
        from factura2, factmotivos
        where factura2.tipo = factmotivos.tipo
        and factura2.almacen = as_almacen
        and factura2.tipo = as_tipo
        and factura2.caja = as_caja
        and factura2.num_documento = ai_num_documento
        and factura2.linea = ai_linea;
    elsif trim(as_rubro) = ''100LBS'' then
            select into ldc_retorno (factura2.cantidad*convmedi.factor*factmotivos.signo)
            from factura2, convmedi, factmotivos, articulos
            where factura2.articulo = articulos.articulo
            and factura2.caja = as_caja
            and factura2.tipo = factmotivos.tipo
            and articulos.unidad_medida = convmedi.old_unidad
            and trim(convmedi.new_unidad) = trim(as_rubro)
            and factura2.almacen = as_almacen
            and factura2.tipo = as_tipo
            and factura2.num_documento = ai_num_documento
            and factura2.linea = ai_linea;
    end if;

    if ldc_retorno is null then
        ldc_retorno = 0;
    end if;
    return ldc_retorno;
end;
' language plpgsql;


create function f_update_factura4(char(2), char(3), int4, char(3)) returns integer as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    as_caja alias for $4;
    ldc_descuento decimal;
    ldc_subtotal decimal;
    ldc_itbms decimal;
    ls_rubro_subtotal char(30);
    ls_rubro_descuento char(30);
    r_almacen record;
begin
    delete from factura4
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and caja = as_caja;
    
    select into r_almacen * from almacen
    where almacen = as_almacen;
    
    ls_rubro_subtotal = f_gralparaxcia(r_almacen.compania, ''FAC'', ''rubro_subtotal'');
    ls_rubro_descuento = f_gralparaxcia(r_almacen.compania, ''FAC'', ''rubro_descuento'');
    
    
    select into ldc_itbms sum(monto)
    from factura3
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and caja = as_caja;


    select into ldc_subtotal sum(precio*cantidad)
    from factura2
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and caja = as_caja;
    
    select into ldc_descuento sum(descuento_linea+descuento_global)
    from factura2
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and caja = as_caja;

    
    if ldc_itbms is null then
        ldc_itbms = 0;
    end if;
    
    if ldc_subtotal is null then
        ldc_subtotal = 0;
    end if;
    
    if ldc_descuento is null then
        ldc_descuento = 0;
    end if;
    
    insert into factura4(almacen, tipo, num_documento, rubro_fact_cxc, monto, caja)
    values(as_almacen, as_tipo, ai_num_documento, ''ITBMS'', ldc_itbms, as_caja);
    
    
    insert into factura4(almacen, tipo, num_documento, rubro_fact_cxc, monto, caja)
    values(as_almacen, as_tipo, ai_num_documento, ls_rubro_descuento, ldc_descuento, as_caja);
    
    insert into factura4(almacen, tipo, num_documento, rubro_fact_cxc, monto, caja)
    values(as_almacen, as_tipo, ai_num_documento, ls_rubro_subtotal, ldc_subtotal, as_caja);
    
    return 1;
end;
' language plpgsql;



create function f_factura2_costo(char(2), char(3), int4, int4, char(30)) returns decimal as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    ai_linea alias for $4;
    as_rubro alias for $5;
    ldc_retorno decimal(15,4);
    ldc_work decimal;
    r_factura2 record;
    r_articulos record;
begin
    ldc_retorno = 0;
    
    select into r_factura2 * from factura2
    where factura2.almacen = as_almacen
    and factura2.tipo = as_tipo
    and factura2.num_documento = ai_num_documento
    and factura2.linea = ai_linea;
    if not found then
        return 0;
    end if;
    
    select into r_articulos * from articulos
    where articulo = r_factura2.articulo
    and servicio = ''S'';
    if found then
        return 0;
    end if;
    
    if trim(as_rubro) = ''COSTO'' then
        select into ldc_retorno -sum(eys2.costo*invmotivos.signo)
        from factura2_eys2, eys2, invmotivos, eys1
        where eys1.almacen = eys2.almacen
        and eys1.no_transaccion = eys2.no_transaccion
        and eys1.motivo = invmotivos.motivo
        and factura2_eys2.articulo = eys2.articulo
        and factura2_eys2.almacen = eys2.almacen
        and factura2_eys2.no_transaccion = eys2.no_transaccion
        and factura2_eys2.eys2_linea = eys2.linea
        and factura2_eys2.articulo = r_factura2.articulo
        and eys2.articulo = r_factura2.articulo
        and factura2_eys2.almacen = as_almacen
        and factura2_eys2.tipo = as_tipo
        and factura2_eys2.num_documento = ai_num_documento
        and factura2_eys2.factura2_linea = ai_linea;
        if not found or ldc_retorno = 0 or ldc_retorno is null then
            select into ldc_retorno -sum(eys2.costo*invmotivos.signo)
            from invmotivos, eys1, eys2, tal_ot1, tal_ot2_eys2
            where eys1.almacen = eys2.almacen
            and eys1.no_transaccion = eys2.no_transaccion
            and eys1.motivo = invmotivos.motivo
            and tal_ot1.almacen = tal_ot2_eys2.almacen
            and tal_ot1.no_orden = tal_ot2_eys2.no_orden
            and tal_ot1.tipo = tal_ot2_eys2.tipo
            and eys2.almacen = tal_ot2_eys2.almacen
            and eys2.no_transaccion = tal_ot2_eys2.no_transaccion
            and eys2.linea = tal_ot2_eys2.linea_eys2
            and tal_ot1.almacen = as_almacen
            and tal_ot1.tipo_factura = as_tipo
            and tal_ot1.numero_factura = ai_num_documento
            and eys2.articulo = r_factura2.articulo;
        end if;
    else
        select into ldc_retorno sum(factura3.monto*factmotivos.signo)
        from factmotivos, factura3
        where factura3.tipo = factmotivos.tipo
        and factura3.almacen = as_almacen
        and factura3.tipo = as_tipo
        and factura3.num_documento = ai_num_documento
        and factura3.linea = ai_linea;
    end if;

    if ldc_retorno is null then
        ldc_retorno = 0;
    end if;
    return ldc_retorno;
end;
' language plpgsql;



create function f_desglose_factura(char(2), char(3), int4, char(3), char(30)) returns decimal as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    as_caja alias for $4;
    as_rubro alias for $5;
    r_factura1 record;
    r_gral_forma_de_pago record;
    r_factmotivos record;
    ldc_retorno decimal(15,2);
    ldc_venta decimal(15,2);
    ldc_impuesto decimal(15,2);
begin
    select into r_factura1 * from factura1
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = as_caja
    and num_documento = ai_num_documento;
    if not found then
        return 0;
    end if;
    
    if r_factura1.status = ''A'' then
        return 0;
    end if;
    
    select into r_factmotivos *
    from factmotivos
    where tipo = as_tipo;
    if found then
        if r_factmotivos.cotizacion = ''S'' then
            return 0;
        end if;
    else
        return 0;
    end if;
    
    ldc_retorno = 0;
    if trim(as_rubro) = ''VENTA'' then
        select into ldc_retorno sum(factura2.precio*factura2.cantidad*factmotivos.signo)
        from factura2, factmotivos
        where factura2.tipo = factmotivos.tipo
        and factura2.almacen = as_almacen
        and factura2.tipo = as_tipo
        and factura2.caja = as_caja
        and factmotivos.cotizacion = ''N''
        and factura2.num_documento = ai_num_documento;
        
    elsif trim(as_rubro) = ''VENTA_NETA_CONTADO'' then
        select into ldc_retorno sum(((factura2.precio*factura2.cantidad)-
            (factura2.descuento_linea+factura2.descuento_global))*factmotivos.signo)
        from factura2, factmotivos, factura1, gral_forma_de_pago
        where factura2.tipo = factmotivos.tipo
        and factura1.almacen = factura2.almacen
        and factura1.caja = factura2.caja
        and factura1.tipo = factura2.tipo
        and factura1.num_documento = factura2.num_documento
        and factura1.caja = as_caja
        and factura1.forma_pago = gral_forma_de_pago.forma_pago
        and gral_forma_de_pago.dias = 0
        and factura2.almacen = as_almacen
        and factura2.tipo = as_tipo
        and factmotivos.cotizacion = ''N''
        and factura2.num_documento = ai_num_documento;
        if ldc_retorno is null then
            ldc_retorno = 0;
        end if;
        
    elsif trim(as_rubro) = ''VENTA_NETA_CREDITO'' then
        select into ldc_retorno sum(((factura2.precio*factura2.cantidad)-
            (factura2.descuento_linea+factura2.descuento_global))*factmotivos.signo)
        from factura2, factmotivos, factura1, gral_forma_de_pago
        where factura2.tipo = factmotivos.tipo
        and factura1.almacen = factura2.almacen
        and factura1.tipo = factura2.tipo
        and factura1.num_documento = factura2.num_documento
        and factura1.caja = as_caja
        and factura1.caja = factura2.caja
        and factura1.forma_pago = gral_forma_de_pago.forma_pago
        and gral_forma_de_pago.dias <> 0
        and factura2.almacen = as_almacen
        and factura2.tipo = as_tipo
        and factmotivos.cotizacion = ''N''
        and factura2.num_documento = ai_num_documento;
        if ldc_retorno is null then
            ldc_retorno = 0;
        end if;

    elsif trim(as_rubro) = ''DA'' then
        select into ldc_retorno sum(((factura2.precio*factura2.cantidad)-
            (factura2.descuento_linea+factura2.descuento_global))*factmotivos.signo)
        from factura2, factmotivos, factura1
        where factura2.tipo = factmotivos.tipo
        and factura1.almacen = factura2.almacen
        and factura1.caja = factura2.caja
        and factura1.tipo = factura2.tipo
        and factura1.num_documento = factura2.num_documento
        and factura2.almacen = as_almacen
        and factura2.tipo = as_tipo
        and factura1.caja = as_caja
        and factura1.tipo = ''DA''
        and factura2.num_documento = ai_num_documento;
        if ldc_retorno is null then
            ldc_retorno = 0;
        end if;

        
    elsif trim(as_rubro) = ''DA_CONTADO'' then
        select into ldc_retorno sum(((factura2.precio*factura2.cantidad)-
            (factura2.descuento_linea+factura2.descuento_global))*factmotivos.signo)
        from factura2, factmotivos, factura1, gral_forma_de_pago
        where factura2.tipo = factmotivos.tipo
        and factura1.almacen = factura2.almacen
        and factura1.caja = factura2.caja
        and factura1.tipo = factura2.tipo
        and factura1.caja = as_caja
        and factura1.num_documento = factura2.num_documento
        and factura1.forma_pago = gral_forma_de_pago.forma_pago
        and gral_forma_de_pago.dias = 0
        and factura2.almacen = as_almacen
        and factura2.tipo = as_tipo
        and factura1.tipo = ''DA''
        and factura2.num_documento = ai_num_documento;
        if ldc_retorno is null then
            ldc_retorno = 0;
        end if;
        
    elsif trim(as_rubro) = ''DA_CREDITO'' then
        select into ldc_retorno sum(((factura2.precio*factura2.cantidad)-
            (factura2.descuento_linea+factura2.descuento_global))*factmotivos.signo)
        from factura2, factmotivos, factura1, gral_forma_de_pago
        where factura2.tipo = factmotivos.tipo
        and factura1.almacen = factura2.almacen
        and factura1.caja = factura2.caja
        and factura1.tipo = factura2.tipo
        and factura1.caja = as_caja
        and factura1.num_documento = factura2.num_documento
        and factura1.forma_pago = gral_forma_de_pago.forma_pago
        and gral_forma_de_pago.dias > 0
        and factura2.almacen = as_almacen
        and factura2.tipo = as_tipo
        and factura1.tipo = ''DA''
        and factura2.num_documento = ai_num_documento;
        if ldc_retorno is null then
            ldc_retorno = 0;
        end if;
        
    elsif trim(as_rubro) = ''ITBMS'' then
        select into ldc_retorno sum(factura3.monto*factmotivos.signo)
        from factmotivos, factura3, factura1, gral_forma_de_pago
        where factura1.almacen = factura3.almacen
        and factura1.tipo = factura3.tipo
        and factura1.caja = factura3.caja
        and factura1.num_documento = factura3.num_documento
        and factura1.forma_pago = gral_forma_de_pago.forma_pago
        and factura3.tipo = factmotivos.tipo
        and factura1.caja = as_caja
        and factura3.almacen = as_almacen
        and factura3.tipo = as_tipo
        and factmotivos.cotizacion = ''N''
        and factura3.num_documento = ai_num_documento;
        if ldc_retorno is null then
            ldc_retorno = 0;
        end if;
        
        
    elsif trim(as_rubro) = ''ITBM_CREDITO'' then
        select into ldc_retorno sum(factura3.monto*factmotivos.signo)
        from factmotivos, factura3, factura1, gral_forma_de_pago
        where factura1.almacen = factura3.almacen
        and factura1.caja = factura3.caja
        and factura1.tipo = factura3.tipo
        and factura1.num_documento = factura3.num_documento
        and factura1.forma_pago = gral_forma_de_pago.forma_pago
        and gral_forma_de_pago.dias <> 0
        and factura3.tipo = factmotivos.tipo
        and factura3.almacen = as_almacen
        and factura1.caja = as_caja
        and factura3.tipo = as_tipo
        and factmotivos.cotizacion = ''N''
        and factura3.num_documento = ai_num_documento;
        if ldc_retorno is null then
            ldc_retorno = 0;
        end if;
        
        
    elsif trim(as_rubro) = ''ITBM_CONTADO'' then
        select into ldc_retorno sum(factura3.monto*factmotivos.signo)
        from factmotivos, factura3, factura1, gral_forma_de_pago
        where factura1.almacen = factura3.almacen
        and factura1.tipo = factura3.tipo
        and factura1.caja = factura3.caja
        and factura1.num_documento = factura3.num_documento
        and factura1.forma_pago = gral_forma_de_pago.forma_pago
        and gral_forma_de_pago.dias = 0
        and factura3.tipo = factmotivos.tipo
        and factura3.almacen = as_almacen
        and factura3.tipo = as_tipo
        and factura1.caja = as_caja
        and factmotivos.cotizacion = ''N''
        and factura3.num_documento = ai_num_documento;
        if ldc_retorno is null then
            ldc_retorno = 0;
        end if;
        
    elsif trim(as_rubro) = ''VENTA_CONTADO'' then
        select into ldc_retorno sum(((factura2.precio*factura2.cantidad)-
            (factura2.descuento_linea+factura2.descuento_global))*factmotivos.signo)
        from factura2, factmotivos, factura1, gral_forma_de_pago
        where factura2.tipo = factmotivos.tipo
        and factura1.almacen = factura2.almacen
        and factura1.caja = factura2.caja
        and factura1.tipo = factura2.tipo
        and factura1.num_documento = factura2.num_documento
        and factura1.caja = as_caja
        and factura1.forma_pago = gral_forma_de_pago.forma_pago
        and gral_forma_de_pago.dias = 0
        and factura2.almacen = as_almacen
        and factura2.tipo = as_tipo
        and factura1.tipo <> ''DA''
        and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
        and factura2.num_documento = ai_num_documento;
        if ldc_retorno is null then
            ldc_retorno = 0;
        end if;
        
    elsif trim(as_rubro) = ''VENTA_CREDITO'' then
        select into ldc_retorno sum(((factura2.precio*factura2.cantidad)-
            (factura2.descuento_linea+factura2.descuento_global))*factmotivos.signo)
        from factura2, factmotivos, factura1, gral_forma_de_pago
        where factura2.tipo = factmotivos.tipo
        and factura1.almacen = factura2.almacen
        and factura1.caja = factura2.caja
        and factura1.tipo = factura2.tipo
        and factura1.num_documento = factura2.num_documento
        and factura1.forma_pago = gral_forma_de_pago.forma_pago
        and gral_forma_de_pago.dias > 0
        and factura2.almacen = as_almacen
        and factura1.caja = as_caja
        and factura2.tipo = as_tipo
        and factura1.tipo <> ''DA''
        and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
        and factura2.num_documento = ai_num_documento;
        if ldc_retorno is null then
            ldc_retorno = 0;
        end if;
        
    elsif trim(as_rubro) = ''DESCUENTO'' then
        select into ldc_retorno -sum((factura2.descuento_linea+factura2.descuento_global) * factmotivos.signo)
        from factura2, factmotivos
        where factura2.tipo = factmotivos.tipo
        and factura2.almacen = as_almacen
        and factura2.caja = as_caja
        and factura2.tipo = as_tipo
        and factura2.num_documento = ai_num_documento;
            
    elsif trim(as_rubro) = ''DEVOLUCION'' then
        select into ldc_retorno sum(((factura2.precio*factura2.cantidad)-
            (factura2.descuento_linea+factura2.descuento_global))*factmotivos.signo)
        from factura2, factmotivos
        where factura2.tipo = factmotivos.tipo
        and factura2.almacen = as_almacen
        and factura2.caja = as_caja
        and factura2.tipo = as_tipo
        and factura2.num_documento = ai_num_documento
        and factmotivos.signo = -1
        and factura2.tipo <> ''DA'';
        
    elsif trim(as_rubro) = ''VTA_GRAVADA'' then
        select into ldc_retorno sum(((factura2.precio*factura2.cantidad)-
            (factura2.descuento_linea+factura2.descuento_global))*factmotivos.signo)
        from factura2, factmotivos, factura3
        where factura2.tipo = factmotivos.tipo
        and factura2.caja = factura3.caja
        and factura2.almacen = as_almacen
        and factura2.tipo = as_tipo
        and factura2.num_documento = ai_num_documento
        and factura2.almacen = factura3.almacen
        and factura2.caja = as_caja
        and factura2.tipo = factura3.tipo
        and factura2.num_documento = factura3.num_documento
        and factmotivos.cotizacion = ''N''
        and factura2.linea = factura3.linea;
        
    elsif trim(as_rubro) = ''VTA_EXCENTA'' then
        select into ldc_venta sum(((factura2.precio*factura2.cantidad)-factura2.descuento_linea-
                    factura2.descuento_global)*factmotivos.signo)
        from factura2, factmotivos
        where factura2.tipo = factmotivos.tipo
        and factura2.almacen = as_almacen
        and factura2.caja = as_caja
        and factura2.tipo = as_tipo
        and factmotivos.cotizacion = ''N''
        and factura2.num_documento = ai_num_documento;
        if ldc_venta is null then
            ldc_venta = 0;
        end if;
        
    
        select into ldc_retorno sum(((factura2.precio*factura2.cantidad)-
            (factura2.descuento_linea+factura2.descuento_global))*factmotivos.signo)
        from factura2, factmotivos, factura3
        where factura2.tipo = factmotivos.tipo
        and factura2.almacen = as_almacen
        and factura2.caja = as_caja
        and factura2.tipo = as_tipo
        and factura2.num_documento = ai_num_documento
        and factura2.almacen = factura3.almacen
        and factura2.tipo = factura3.tipo
        and factura2.caja = factura3.caja
        and factmotivos.cotizacion = ''N''
        and factura2.num_documento = factura3.num_documento
        and factura2.linea = factura3.linea;
        if ldc_retorno is null then
            ldc_retorno = 0;
        end if;
        
        ldc_retorno =   ldc_venta - ldc_retorno;
        
    elsif trim(as_rubro) = ''IMPUESTO'' then
        select into ldc_retorno sum(factura3.monto*factmotivos.signo)
        from factmotivos, factura3
        where factura3.tipo = factmotivos.tipo
        and factura3.almacen = as_almacen
        and factmotivos.cotizacion = ''N''
        and factura3.tipo = as_tipo
        and factura3.caja = as_caja
        and factura3.num_documento = ai_num_documento;
        
    elsif trim(as_rubro) = ''EFECTIVO'' then
        select into ldc_retorno sum(fac_pagos.monto)
        from fac_pagos
        where fac_pagos.almacen = as_almacen
        and fac_pagos.tipo = as_tipo
        and fac_pagos.caja = as_caja
        and fac_pagos.num_documento = ai_num_documento
        and fac_pagos.forma = 1;
        
    elsif trim(as_rubro) = ''CHEQUE'' then
        select into ldc_retorno sum(fac_pagos.monto)
        from fac_pagos
        where fac_pagos.almacen = as_almacen
        and fac_pagos.tipo = as_tipo
        and fac_pagos.caja = as_caja
        and fac_pagos.num_documento = ai_num_documento
        and fac_pagos.forma = 2;
        
    elsif trim(as_rubro) = ''RECIBIDO'' then
        select into ldc_retorno sum(fac_pagos.monto)
        from fac_pagos
        where fac_pagos.almacen = as_almacen
        and fac_pagos.tipo = as_tipo
        and fac_pagos.caja = as_caja
        and fac_pagos.num_documento = ai_num_documento;
        
    elsif trim(as_rubro) = ''TARJETA_CREDITO'' then
        select into ldc_retorno sum(fac_pagos.monto)
        from fac_pagos
        where fac_pagos.almacen = as_almacen
        and fac_pagos.tipo = as_tipo
        and fac_pagos.caja = as_caja
        and fac_pagos.num_documento = ai_num_documento
        and fac_pagos.forma = 3;
        
    elsif trim(as_rubro) = ''TARJETA_DEBITO'' then
        select into ldc_retorno sum(fac_pagos.monto)
        from fac_pagos
        where fac_pagos.almacen = as_almacen
        and fac_pagos.tipo = as_tipo
        and fac_pagos.caja = as_caja
        and fac_pagos.num_documento = ai_num_documento
        and fac_pagos.forma = 4;
        
    elsif trim(as_rubro) = ''OTRO'' then
        select into ldc_retorno sum(fac_pagos.monto)
        from fac_pagos
        where fac_pagos.almacen = as_almacen
        and fac_pagos.tipo = as_tipo
        and fac_pagos.caja = as_caja
        and fac_pagos.num_documento = ai_num_documento
        and fac_pagos.forma = 5;
        
    elsif trim(as_rubro) = ''COSTO'' then
        select into ldc_retorno -sum(eys2.costo*invmotivos.signo)
        from factura2_eys2, eys2, invmotivos, eys1
        where eys1.almacen = eys2.almacen
        and eys1.no_transaccion = eys2.no_transaccion
        and eys1.motivo = invmotivos.motivo
        and factura2_eys2.articulo = eys2.articulo
        and factura2_eys2.almacen = eys2.almacen
        and factura2_eys2.no_transaccion = eys2.no_transaccion
        and factura2_eys2.eys2_linea = eys2.linea
        and factura2_eys2.almacen = as_almacen
        and factura2_eys2.caja = as_caja
        and factura2_eys2.tipo = as_tipo
        and factura2_eys2.num_documento = ai_num_documento;
        
    elsif trim(as_rubro) = ''VENTA_NETA'' then
        select into ldc_retorno sum(((factura2.precio*factura2.cantidad)-factura2.descuento_linea-
                    factura2.descuento_global)*factmotivos.signo)
        from factura2, factmotivos
        where factura2.tipo = factmotivos.tipo
        and factura2.almacen = as_almacen
        and factura2.caja = as_caja
        and factura2.tipo = as_tipo
        and factmotivos.cotizacion = ''N''
        and factura2.num_documento = ai_num_documento;
        
    elsif trim(as_rubro) = ''TOTAL'' then
        select into ldc_venta sum(((factura2.precio*factura2.cantidad)-factura2.descuento_linea-
                    factura2.descuento_global)*factmotivos.signo)
        from factura2, factmotivos
        where factura2.tipo = factmotivos.tipo
        and factura2.almacen = as_almacen
        and factura2.caja = as_caja
        and factura2.tipo = as_tipo
        and factmotivos.cotizacion = ''N''
        and factura2.num_documento = ai_num_documento;
        
        select into ldc_impuesto sum(factura3.monto*factmotivos.signo)
        from factmotivos, factura3
        where factura3.tipo = factmotivos.tipo
        and factura3.almacen = as_almacen
        and factmotivos.cotizacion = ''N''
        and factura3.caja = as_caja
        and factura3.tipo = as_tipo
        and factura3.num_documento = ai_num_documento;
        
        if ldc_venta is null then
            ldc_venta = 0;
        end if;
        
        if ldc_impuesto is null then
            ldc_impuesto = 0;
        end if;
        
        ldc_retorno = ldc_venta + ldc_impuesto;
        
    elsif  trim(as_rubro) = ''SALDO'' then
        select into r_gral_forma_de_pago * from gral_forma_de_pago
        where forma_pago = r_factura1.forma_pago;
        if not found then
            return 0;
        end if;
        
        if r_gral_forma_de_pago.dias > 0 then
            ldc_retorno =   f_saldo_documento_cxc(r_factura1.almacen, r_factura1.caja, r_factura1.cliente,
                                r_factura1.tipo, trim(to_char(r_factura1.num_documento, ''99999999999'')),
                                current_date);
        else
            ldc_retorno =   0;
        end if;
    end if;


    if ldc_retorno is null then
        ldc_retorno = 0;
    end if;
    return ldc_retorno;
end;
' language plpgsql;


create function f_actualiza_precios(char(2), char(10), char(25)) returns integer as '
declare
    as_cia alias for $1;
    as_proveedor alias for $2;
    as_fact_proveedor alias for $3;
    ld_fecha date;
    i integer;
    ldc_descuento decimal(10,2);
    ldc_cu decimal(10,2);
    ldc_pv decimal(10,2);
    r_cxpfact1 record;
    r_eys2 record;
    r_inv_margenes_x_grupo record;
    r_articulos_por_almacen record;
begin
    select into r_cxpfact1 * from cxpfact1
    where compania = as_cia
    and proveedor = as_proveedor
    and fact_proveedor = as_fact_proveedor;
    if not found then
        return 0;
    end if;
    
    if r_cxpfact1.actualiza_precios = ''N'' then
        return 0;
    end if;

    for r_eys2 in select eys2.* from eys2
                    where compania = r_cxpfact1.compania
                    and proveedor = r_cxpfact1.proveedor
                    and fact_proveedor = r_cxpfact1.fact_proveedor
                    order by eys2.articulo
    loop
        ldc_descuento = 0;
        select into ldc_descuento (oc2.descuento) from oc2
        where oc2.compania = r_cxpfact1.compania
        and oc2.numero_oc = r_cxpfact1.numero_oc
        and oc2.articulo = r_eys2.articulo;
        if not found then
            ldc_descuento = 0;
        end if;
        
        
        for r_inv_margenes_x_grupo in 
            select inv_margenes_x_grupo.* 
            from inv_margenes_x_grupo, articulos_agrupados
            where inv_margenes_x_grupo.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo
            and articulos_agrupados.articulo = r_eys2.articulo
            order by margen
        loop
            if r_eys2.cantidad = 0 then
                continue;
            end if;
            
            
            if ldc_descuento > r_eys2.costo then
                continue;
            end if;
            
            ldc_cu = (r_eys2.costo + ldc_descuento) / r_eys2.cantidad;
            
            ldc_pv = ldc_cu * (1+(r_inv_margenes_x_grupo.margen/100));

--            raise exception ''costo % precio % articulo % margen %'',ldc_cu,ldc_pv,r_eys2.articulo,r_inv_margenes_x_grupo.margen;

            select into r_articulos_por_almacen * from articulos_por_almacen
            where almacen = r_eys2.almacen
            and articulo = r_eys2.articulo;
            
            if r_articulos_por_almacen.existencia > 0 then            
                update articulos_por_almacen
                set precio_venta = ldc_pv
                where almacen = r_eys2.almacen
                and articulo = r_eys2.articulo
                and precio_fijo = ''N''
                and ldc_pv > (costo/existencia)
                and ldc_pv > precio_venta;
            end if;
            
        end loop;
    end loop;        
    return 1;
end;
' language plpgsql;    



create function f_factura1_cglposteo(char(2), char(3), int4, char(3)) returns integer as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    as_caja alias for $4;
    li_consecutivo int4;
    r_almacen record;
    r_factura1 record;
    r_factura2 record;
    r_factura4 record;
    r_gral_forma_de_pago record;
    r_clientes record;
    r_work record;
    r_factmotivos record;
    r_cglcuentas record;
    r_articulos_por_almacen record;
    r_articulos record;
    r_articulos_agrupados record;
    r_cglauxiliares record;
    r_clientes_exentos record;
    ldc_sum_factura1 decimal(10,2);
    ldc_sum_factura2 decimal(10,2);
    ldc_sum_factura3 decimal(12,4);
    ldc_sum_factura4 decimal(10,2);
    ldc_sum_inv_en_proceso decimal(10,2);
    ldc_monto_factura decimal(10,2);
    ldc_monto_factura2 decimal(10,2);
    ldc_work decimal(10,2);
    ldc_desbalance decimal(10,2);
    ldc_impuesto decimal(10,2);
    ls_cuenta char(24);
    ls_cuenta_costo char(24);
    ls_aux1 char(10);
    ls_rubro_subtotal char(60);
    ls_observacion text;
    ls_cta_cxp_da char(24);
begin

    delete from cglposteo
    using rela_factura1_cglposteo
    where cglposteo.consecutivo = rela_factura1_cglposteo.consecutivo
    and rela_factura1_cglposteo.almacen = as_almacen
    and rela_factura1_cglposteo.tipo = as_tipo
    and rela_factura1_cglposteo.num_documento = ai_num_documento
    and rela_factura1_cglposteo.caja = as_caja;


    delete from rela_factura1_cglposteo
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and caja = as_caja;

    select into r_factura1 * from factura1
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = as_caja
    and num_documento = ai_num_documento;
    if not found then
       return 0;
    end if;

    
    select into r_clientes * from clientes
    where cliente = r_factura1.cliente;
        
    if r_factura1.status = ''A'' then
       return 0;
    end if;
    
    select into r_factmotivos * from factmotivos
    where tipo = r_factura1.tipo;
    if r_factmotivos.cotizacion = ''S'' or r_factmotivos.donacion = ''S'' or r_factmotivos.promocion = ''S'' then
       return 0;
    end if;
    
    ldc_monto_factura = f_monto_factura_new(as_almacen, as_tipo, ai_num_documento, as_caja);
    if ldc_monto_factura = 0 or ldc_monto_factura is null then
        return 0;
/*    
       Raise Exception ''Monto de Factura % no puede ser cero...Verifique'',ai_num_documento;
*/       
    end if;
    
    select into ldc_sum_factura2 sum((cantidad*precio)-descuento_linea-descuento_global) 
    from factura2
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = as_caja
    and num_documento = ai_num_documento;
    if ldc_sum_factura2 is null then
       ldc_sum_factura2 := 0;
    end if;
    ldc_sum_factura2 = ldc_sum_factura2 * r_factmotivos.signo;
    
    select into ldc_sum_factura3 Round(sum(monto),2)
    from factura3
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = as_caja
    and num_documento = ai_num_documento;
    if ldc_sum_factura3 is null then
       ldc_sum_factura3 := 0;
    end if;
    ldc_sum_factura3 = ldc_sum_factura3 * r_factmotivos.signo;


    ldc_monto_factura = (ldc_sum_factura2 + ldc_sum_factura3) * r_factmotivos.signo;
/*    
    if ldc_monto_factura < 0 then
        ldc_monto_factura2 := -ldc_monto_factura;
    else
        ldc_monto_factura2 := ldc_monto_factura;
    end if;    
*/    

    ldc_desbalance := ldc_monto_factura2 - ldc_sum_factura2 - ldc_sum_factura3;
    if ldc_desbalance <> 0 then
       raise exception ''Almacen % Caja % Tipo % Documento % esta en desbalanceada...Verifique'', 
           r_factura1.almacen, r_factura1.caja, r_factura1.tipo, r_factura1.num_documento;
    end if;
    
    
    select into r_almacen * from almacen
    where almacen = r_factura1.almacen;
    
    r_factura1.observacion = ''CLIENTE: '' || trim(r_factura1.cliente) || ''  FACTURA # '' || ai_num_documento;

    r_factura1.observacion = ''CLIENTE: '' || trim(r_factura1.nombre_cliente) || ''  '' || trim(r_factura1.cliente) || ''   '' || trim(r_factmotivos.descripcion) ||  '' # ''  || ai_num_documento;
    
    if r_factura1.mbl is not null then
       r_factura1.observacion := trim(r_factura1.observacion) || ''  '' || trim(r_factura1.mbl);
    end if;
    
    if r_factura1.hbl is not null then
       r_factura1.observacion := trim(r_factura1.observacion) || ''  '' || trim(r_factura1.hbl);
    end if;
    
    
    ls_cta_cxp_da   = Trim(f_gralparaxcia(r_almacen.compania, ''FAC'', ''cta_cxp_da''));
    
    ldc_sum_factura2 := 0;
    for r_work in select factura2.almacen, factura2.articulo, -sum(((cantidad*precio)-descuento_linea-descuento_global)*factmotivos.signo) as monto
                        from factura2, factmotivos
                        where factura2.tipo = factmotivos.tipo
                        and factura2.almacen = r_factura1.almacen
                        and factura2.tipo = r_factura1.tipo
                        and factura2.caja = as_caja
                        and factura2.num_documento = r_factura1.num_documento
                        group by 1, 2
                        order by 1, 2
    loop
        ls_aux1 = null;
        select into r_articulos * from articulos
        where articulo = r_work.articulo and servicio = ''S'';
        if found then
            select into r_articulos_por_almacen * from articulos_por_almacen
            where almacen = r_work.almacen
            and articulo = r_work.articulo;
            ls_cuenta = r_articulos_por_almacen.cuenta;
            if Trim(r_factura1.tipo) = ''DA'' then
                ls_cuenta   = f_gralparaxcia(r_almacen.compania, ''FAC'', ''cta_gto_da'');
                ls_aux1     = r_factura1.cliente;
            end if;
            
            select into r_cglcuentas * from cglcuentas
            where cuenta = ls_cuenta and auxiliar_1 = ''S'';
            if found then
                if r_factura1.referencia = ''1'' or r_factura1.referencia = ''2'' or r_factura1.referencia = ''7'' then
                    ls_aux1 := r_factura1.ciudad_origen;
                else
                    ls_aux1 := r_factura1.ciudad_destino;
                end if;
                
                ls_aux1 := r_factura1.agente;
                
                if ls_aux1 is null then
                    select into r_cglauxiliares * from cglauxiliares
                    where trim(auxiliar) = trim(r_factura1.cliente);
                    if not found then
                        insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
                        values (r_factura1.cliente, r_clientes.nomb_cliente, ''1'', ''A'');
                    end if;
                    ls_aux1 = r_factura1.cliente;
                end if;
            end if;
        else
            if Trim(r_factura1.tipo) = ''DA'' then
                ls_cuenta   = f_gralparaxcia(r_almacen.compania, ''FAC'', ''cta_gto_da'');
                ls_aux1     = r_factura1.cliente;
                
                select into r_cglauxiliares * from cglauxiliares
                where trim(auxiliar) = trim(ls_aux1);
                if not found then
                    insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
                    values (trim(r_factura1.cliente), trim(r_clientes.nomb_cliente), ''1'', ''A'');
                end if;
            else
                if r_factmotivos.devolucion = ''S'' then
                    select into ls_cuenta facparamcgl.cuenta_devolucion
                    from articulos_agrupados, facparamcgl
                    where r_work.articulo = articulos_agrupados.articulo
                    and facparamcgl.almacen = r_work.almacen
                    and facparamcgl.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo;
                    if ls_cuenta is null or not found then
                        select into r_articulos_agrupados * from articulos_agrupados
                        where codigo_valor_grupo = ''NO''
                        and articulo = r_work.articulo;
                        if found then
                            select into ls_cuenta fac_parametros_contables.vtas_exentas
                            from fac_parametros_contables, articulos_agrupados
                            where articulos_agrupados.codigo_valor_grupo = fac_parametros_contables.codigo_valor_grupo
                            and articulos_agrupados.articulo = r_work.articulo
                            and fac_parametros_contables.almacen = r_work.almacen
                            and fac_parametros_contables.referencia = r_factura1.referencia;
                            if ls_cuenta is null or not found then
                                Raise Exception ''En la Factura # % El articulo % no tiene definido cuenta de ventas excentas...Verifique'',r_factura1.num_documento, r_work.articulo;
                            end if;
                        else
                            select into ls_cuenta fac_parametros_contables.cta_de_ingreso
                            from fac_parametros_contables, articulos_agrupados
                            where articulos_agrupados.codigo_valor_grupo = fac_parametros_contables.codigo_valor_grupo
                            and articulos_agrupados.articulo = r_work.articulo
                            and fac_parametros_contables.almacen = r_work.almacen
                            and fac_parametros_contables.referencia = r_factura1.referencia;
                            if ls_cuenta is null or not found then
                                Raise Exception ''En la Factura # % El articulo % no tiene definido cuenta de ingreso...Verifique'',r_factura1.num_documento, r_work.articulo;
                            end if;
                        end if;
                    end if;                
                else
                    select into ls_cuenta facparamcgl.cuenta_ingreso
                    from articulos_agrupados, facparamcgl
                    where r_work.articulo = articulos_agrupados.articulo
                    and facparamcgl.almacen = r_work.almacen
                    and facparamcgl.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo;
                    if ls_cuenta is null or not found then
                        select into r_articulos_agrupados * from articulos_agrupados
                        where codigo_valor_grupo = ''NO''
                        and articulo = r_work.articulo;
                        if found then
                            select into ls_cuenta fac_parametros_contables.vtas_exentas
                            from fac_parametros_contables, articulos_agrupados
                            where articulos_agrupados.codigo_valor_grupo = fac_parametros_contables.codigo_valor_grupo
                            and articulos_agrupados.articulo = r_work.articulo
                            and fac_parametros_contables.almacen = r_work.almacen
                            and fac_parametros_contables.referencia = r_factura1.referencia;
                            if ls_cuenta is null or not found then
                                Raise Exception ''En la Factura # % El articulo % no tiene definido cuenta de ventas excentas...Verifique'',r_factura1.num_documento, r_work.articulo;
                            end if;
                        else
                            select into ls_cuenta fac_parametros_contables.cta_de_ingreso
                            from fac_parametros_contables, articulos_agrupados
                            where articulos_agrupados.codigo_valor_grupo = fac_parametros_contables.codigo_valor_grupo
                            and articulos_agrupados.articulo = r_work.articulo
                            and fac_parametros_contables.almacen = r_work.almacen
                            and fac_parametros_contables.referencia = r_factura1.referencia;
                            if ls_cuenta is null or not found then
                                Raise Exception ''En la Factura # % El articulo % no tiene definido cuenta de ingreso...Verifique'',r_factura1.num_documento, r_work.articulo;
                            end if;
                        end if;
                    end if;
                end if;

/*
                select into r_clientes_exentos * from clientes_exentos
                where cliente = r_factura1.cliente;
                if found and Trim(r_factura1.tipo) <> ''DA''then
                    select into ls_cuenta fac_parametros_contables.vtas_exentas
                    from fac_parametros_contables, articulos_agrupados
                    where articulos_agrupados.codigo_valor_grupo = fac_parametros_contables.codigo_valor_grupo
                    and articulos_agrupados.articulo = r_work.articulo
                    and fac_parametros_contables.almacen = r_work.almacen
                    and fac_parametros_contables.referencia = r_factura1.referencia;
                    if ls_cuenta is null or not found then
                        select into ls_cuenta facparamcgl.cta_vta_exenta
                        from facparamcgl, articulos_agrupados
                        where articulos_agrupados.codigo_valor_grupo = facparamcgl.codigo_valor_grupo
                        and articulos_agrupados.articulo = r_work.articulo
                        and facparamcgl.almacen = r_work.almacen
                        and facparamcgl.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo;
                        if ls_cuenta is null or not found then
                            ls_cuenta := r_clientes_exentos.cuenta;
                        end if;
                    end if;
                end if;
*/                
            end if;
        end if;

        if ls_cuenta is null then
            Raise Exception ''En la Factura # % El articulo % no tiene definido cuenta de ingreso...Verifique'',r_factura1.num_documento, r_work.articulo;
        end if;

        
        li_consecutivo = f_cglposteo(r_almacen.compania, ''FAC'', r_factura1.fecha_factura, 
                                Trim(ls_cuenta), ls_aux1, null, r_factmotivos.tipo_comp, 
                                trim(r_factura1.observacion), Round(r_work.monto,2));
        if li_consecutivo > 0 then
            insert into rela_factura1_cglposteo (almacen, tipo, num_documento, consecutivo, caja)
            values (r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento, li_consecutivo, as_caja);
        end if;
        ldc_sum_factura2 := ldc_sum_factura2 + Round(r_work.monto,2);
    end loop;
    
    if Trim(f_gralparaxcia(r_almacen.compania, ''INV'', ''inv_en_proceso'')) = ''S'' then
        ldc_sum_inv_en_proceso = 0;
        for r_work in select tal_ot1.cliente, eys2.almacen, eys2.articulo, sum(factmotivos.signo*eys2.costo) as costo
                            from tal_ot1, tal_ot2, articulos, tal_ot2_eys2, eys2, factmotivos
                            where factmotivos.tipo = tal_ot1.tipo_factura
                            and tal_ot1.almacen = as_almacen
                            and tal_ot1.tipo_factura = as_tipo
                            and tal_ot1.numero_factura = ai_num_documento
                            and tal_ot1.caja = as_caja
                            and tal_ot1.almacen = tal_ot2.almacen
                            and tal_ot1.tipo = tal_ot2.tipo
                            and tal_ot1.no_orden = tal_ot2.no_orden
                            and tal_ot2.articulo = articulos.articulo
                            and articulos.servicio = ''N''
                            and tal_ot2.no_orden = tal_ot2_eys2.no_orden
                            and tal_ot2.tipo = tal_ot2_eys2.tipo
                            and tal_ot2.almacen = tal_ot2_eys2.almacen
                            and tal_ot2.linea = tal_ot2_eys2.linea_tal_ot2
                            and tal_ot2.articulo = tal_ot2_eys2.articulo
                            and eys2.articulo = tal_ot2_eys2.articulo
                            and eys2.almacen = tal_ot2_eys2.almacen
                            and eys2.no_transaccion = tal_ot2_eys2.no_transaccion
                            and eys2.linea = tal_ot2_eys2.linea_eys2
                            and tal_ot2.fecha_despacho >= ''2006-01-01''
                            group by 1, 2, 3
                            order by 1, 2, 3
        loop
            select into ls_cuenta_costo fac_parametros_contables.cta_de_costo
            from articulos_agrupados, fac_parametros_contables
            where articulos_agrupados.codigo_valor_grupo = fac_parametros_contables.codigo_valor_grupo
            and articulos_agrupados.articulo = r_work.articulo
            and fac_parametros_contables.almacen = r_work.almacen
            and fac_parametros_contables.referencia = r_factura1.referencia;
            if Not Found or ls_cuenta_costo is null then
                raise exception ''No existe cuenta de costo para el articulo % en la factura %'', r_work.articulo, ai_num_documento;
            end if;                
    
            li_consecutivo := f_cglposteo(r_almacen.compania, ''FAC'', r_factura1.fecha_factura, 
                                    Trim(ls_cuenta_costo), null, null, r_factmotivos.tipo_comp, 
                                    trim(r_factura1.observacion), Round(r_work.costo,2));
            if li_consecutivo > 0 then
                insert into rela_factura1_cglposteo (almacen, tipo, num_documento, consecutivo, caja)
                values (as_almacen, as_tipo, ai_num_documento, li_consecutivo, as_caja);
            end if;
            ldc_sum_inv_en_proceso = ldc_sum_inv_en_proceso + Round(r_work.costo,2);
        end loop;
    
        if ldc_sum_inv_en_proceso <> 0 then
            ls_cuenta_costo = f_gralparaxcia(r_almacen.compania, ''INV'', ''cta_inv_en_proceso'');
            li_consecutivo := f_cglposteo(r_almacen.compania, ''FAC'', r_factura1.fecha_factura, 
                                    Trim(ls_cuenta_costo), null, null, r_factmotivos.tipo_comp, 
                                    trim(r_factura1.observacion), -ldc_sum_inv_en_proceso);
            if li_consecutivo > 0 then
                insert into rela_factura1_cglposteo (almacen, tipo, num_documento, consecutivo, caja)
                values (as_almacen, as_tipo, ai_num_documento, li_consecutivo, as_caja);
            end if;
        end if;        
    end if;
  
  
    ls_rubro_subtotal = f_gralparaxcia(r_almacen.compania, ''FAC'', ''rubro_subtotal'');
    select into ldc_sum_factura4 sum(monto*rubros_fact_cxc.signo_rubro_fact_cxc) 
    from factura4, rubros_fact_cxc
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = as_caja
    and num_documento = ai_num_documento
    and trim(factura4.rubro_fact_cxc) = trim(rubros_fact_cxc.rubro_fact_cxc)
    and trim(factura4.rubro_fact_cxc) <> ''ITBMS'';
    if found then
        ldc_work := (r_factmotivos.signo*ldc_sum_factura4) - ldc_sum_factura2;
        if ldc_work <> 0 then
            ls_observacion := ''FACTURA # '' || ai_num_documento || '' AJUSTE POR REDONDEO '';
    
            if ls_cuenta is null then
                Raise Exception ''En la Factura # % no tiene cuenta de ajuste...Verifique'',r_factura1.num_documento;
            end if;
--            li_consecutivo := f_cglposteo(r_almacen.compania, ''FAC'', r_factura1.fecha_factura, 
--                                    Trim(ls_cuenta), ls_aux1, null, r_factmotivos.tipo_comp, 
--                                    trim(ls_observacion), (ldc_work*r_factmotivos.signo));
--            if li_consecutivo > 0 then
--                insert into rela_factura1_cglposteo (almacen, tipo, num_documento, consecutivo)
--                values (r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento, li_consecutivo);
--            end if;
        end if;
    end if;
    
    ldc_sum_factura3 = 0;    
    for r_work in select gral_impuestos.cuenta, -sum(monto*factmotivos.signo) as monto
                    from factura3, gral_impuestos, factmotivos
                    where factura3.impuesto = gral_impuestos.impuesto
                    and factura3.almacen = r_factura1.almacen
                    and factura3.caja = as_caja
                    and factura3.tipo = r_factura1.tipo
                    and factura3.num_documento = r_factura1.num_documento
                    and factura3.tipo = factmotivos.tipo
                    group by 1
                    having sum(monto*factmotivos.signo) <> 0
                    order by 1
    loop
        if r_work.cuenta is null then
            Raise Exception ''En la Factura # % no tiene cuenta de impuestos...Verifique'',r_factura1.num_documento;
        end if;

        
        ldc_impuesto    =   Round(r_work.monto,2);
        
        li_consecutivo = f_cglposteo(r_almacen.compania, ''FAC'', r_factura1.fecha_factura, 
                                Trim(r_work.cuenta), null, null, r_factmotivos.tipo_comp, 
                                trim(r_factura1.observacion), ldc_impuesto);
        if li_consecutivo > 0 then
            insert into rela_factura1_cglposteo (almacen, tipo, num_documento, consecutivo, caja)
            values (r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento, li_consecutivo, as_caja);
        end if;
        ldc_sum_factura3 = ldc_sum_factura3 + ldc_impuesto;
    end loop;

    
    select into r_factura4 * from factura4
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = as_caja
    and num_documento = ai_num_documento
    and monto <> 0
    and trim(rubro_fact_cxc) = ''ITBMS'';
    if found then
        ldc_work = (r_factura4.monto*r_factmotivos.signo) + ldc_sum_factura3;
        if ldc_work <> 0 then
            if r_work.cuenta is null then
                Raise Exception ''En la Factura # % no tiene cuenta de impuestos...Verifique'',r_factura1.num_documento;
            end if;
        
            ls_observacion = ''FACTURA # '' || ai_num_documento || '' AJUSTE POR REDONDEO '';
    
            li_consecutivo = f_cglposteo(r_almacen.compania, ''FAC'', r_factura1.fecha_factura, 
                                    Trim(r_work.cuenta), ls_aux1, null, r_factmotivos.tipo_comp, 
                                    trim(ls_observacion), (ldc_work));
            if li_consecutivo > 0 then
                insert into rela_factura1_cglposteo (almacen, tipo, num_documento, consecutivo, caja)
                values (r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento, li_consecutivo, as_caja);
            end if;
        end if;
    end if;        
    
    ldc_monto_factura := -(ldc_sum_factura2 + ldc_sum_factura3);
    
    select into r_clientes * from clientes
    where cliente = r_factura1.cliente;
    
    select into r_gral_forma_de_pago * from gral_forma_de_pago
    where forma_pago = r_factura1.forma_pago;
    
    if r_gral_forma_de_pago.dias > 0 then
/*
       select into ls_cuenta trim(valor) from invparal
       where almacen = r_factura1.almacen
       and parametro = ''cta_cxc''
       and aplicacion =  ''INV'';
       if not found then
          ls_cuenta := r_clientes.cuenta;
       end if;
*/

       ls_cuenta := r_clientes.cuenta;

        if Trim(r_factura1.tipo) = ''DA''then
/*        
           select into ls_cuenta trim(valor) from invparal
           where almacen = r_factura1.almacen
           and trim(parametro) = ''cta_cxp_comisiones''
           and aplicacion =  ''INV'';
           if not found then
                ls_cuenta = trim(ls_cta_cxp_da);
           else
              ls_cuenta = Trim(r_clientes.cuenta);
           end if;
*/           
           ls_cuenta    =   Trim(f_invparal(r_factura1.almacen, ''cta_cxp_comisiones''));
        end if;
    else
       select into ls_cuenta trim(valor) from invparal
       where almacen = r_factura1.almacen
       and parametro = ''cta_caja''
       and aplicacion =  ''INV'';
       if not found then
          Raise Exception ''Parametro cta_caja no existe en el almacen % ...Verifique'',r_factura1.almacen;
       end if;
    end if;
    
    
    ls_aux1 :=  null;
    select into r_cglcuentas * from cglcuentas
    where trim(cuenta) = trim(ls_cuenta)
    and auxiliar_1 = ''S'';
    if found then
        ls_aux1 :=   r_factura1.cliente;
        select into r_cglauxiliares * from cglauxiliares
        where trim(auxiliar) = trim(ls_aux1);
        if not found then
            insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
            values (r_factura1.cliente, r_clientes.nomb_cliente, ''1'', ''A'');
        end if;
    end if;

    li_consecutivo = f_cglposteo(r_almacen.compania, ''FAC'', r_factura1.fecha_factura, 
                            ls_cuenta, ls_aux1, null, r_factmotivos.tipo_comp, 
                            trim(r_factura1.observacion), ldc_monto_factura);
    if li_consecutivo > 0 then
        insert into rela_factura1_cglposteo (almacen, tipo, num_documento, consecutivo, caja)
        values (r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento, li_consecutivo, as_caja);
    end if;

    return 1;
end;
' language plpgsql;




create function f_postea_fac(char(2))returns integer as '
declare
    as_cia alias for $1;
    ld_fecha date;
    i integer;
    r_factura1 record;
begin
    select into ld_fecha Min(inicio) from gralperiodos
    where compania = as_cia
    and aplicacion = ''CXC''
    and estado = ''A'';
    if not found then
        return 0;
    end if;
    
    for r_factura1 in select factura1.* from almacen, factura1, factmotivos
                    where almacen.almacen = factura1.almacen
                    and factura1.tipo = factmotivos.tipo
                    and factmotivos.cotizacion = ''N'' and factmotivos.donacion = ''N''
                    and almacen.compania = as_cia
                    and factura1.status <> ''A''
                    and factura1.fecha_factura >= ld_fecha
                    and not exists
                        (select * from rela_factura1_cglposteo
                            where rela_factura1_cglposteo.almacen = factura1.almacen
                            and rela_factura1_cglposteo.tipo = factura1.tipo
                            and rela_factura1_cglposteo.caja = factura1.caja
                            and rela_factura1_cglposteo.num_documento = factura1.num_documento)
                    order by factura1.fecha_factura
    loop
        i = f_factura1_cglposteo(r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento, r_factura1.caja);
    end loop;        
    
    
    return 1;
    
end;
' language plpgsql;    


create function f_factura_x_rubro(char(2), char(3), int4, char(3), char(15)) returns decimal(10,2)
as 'select -sum(d.monto*a.signo*b.signo_rubro_fact_cxc) from factmotivos a, rubros_fact_cxc b, factura1 c, factura4 d
where c.almacen = d.almacen
and c.tipo = d.tipo
and c.num_documento = d.num_documento
and c.tipo = a.tipo
and d.rubro_fact_cxc = b.rubro_fact_cxc
and c.almacen = $1
and c.tipo = $2
and c.num_documento = $3
and c.caja = $4
and b.rubro_fact_cxc = $5;' language 'sql';


create function f_monto_factura(char(2), char(3), int4) returns decimal(10,2) as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    ldc_sum_factura2 decimal(10,2);
    ldc_sum_factura3 decimal(10,2);
    r_factmotivos record;
    r_factura1 record;
    i integer;
begin

    return 0;
    
    select into r_factura1 * from factura1
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    if not found then
        return 0;
    end if;
    
    if r_factura1.status = ''A'' then
        return 0;
    end if;
    
    select into ldc_sum_factura2 sum((cantidad*precio)-descuento_linea-descuento_global) 
    from factura2
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    
    if ldc_sum_factura2 is null then
       ldc_sum_factura2 := 0;
    end if;
    
    select into ldc_sum_factura3 sum(monto) 
    from factura3
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    if ldc_sum_factura3 is null then
       ldc_sum_factura3 := 0;
    end if;
    
    select into r_factmotivos * from factmotivos
    where tipo = as_tipo;
    
    return ((ldc_sum_factura2 + ldc_sum_factura3) * r_factmotivos.signo);
end;
' language plpgsql;
