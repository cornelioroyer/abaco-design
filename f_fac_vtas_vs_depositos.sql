drop function f_fac_vtas_vs_depositos(char(2), date, date) cascade;

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

--    raise exception ''% %'', ldc_deposito_1, ld_work;
        
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


