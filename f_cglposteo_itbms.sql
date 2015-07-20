drop view v_cxp_declaracion_impuestos;

drop function f_cglposteo_itbms(int4, char(20)) cascade;
drop function f_cglposteo(int4, char(20)) cascade;


create function f_cglposteo(int4, char(20)) returns char(100) as '
declare
    ai_consecutivo alias for $1;
    as_retornar alias for $2;
    r_cglposteo record;
    r_rela_cxpfact1_cglposteo record;
    r_rela_cxpajuste1_cglposteo record;
    r_cxpmotivos record;
    r_rela_bcocheck1_cglposteo record;
    r_rela_bcotransac1_cglposteo record;
    r_cxpfact1 record;
    r_cxpajuste1 record;
    r_proveedores record;
    r_rela_caja_trx1_cglposteo record;
    r_caja_trx1 record;
    lc_retornar char(100);
begin
    lc_retornar = null;
    select into r_cglposteo * from cglposteo
    where consecutivo = ai_consecutivo;
    if not found then
        return null;
    end if;
    
    if trim(as_retornar) = ''NOMBRE'' then
        select into r_rela_cxpfact1_cglposteo * 
        from rela_cxpfact1_cglposteo
        where consecutivo = r_cglposteo.consecutivo;
        if found then
            select into r_cxpfact1 * from cxpfact1    
            where compania = r_rela_cxpfact1_cglposteo.compania
            and proveedor = r_rela_cxpfact1_cglposteo.proveedor
            and fact_proveedor = r_rela_cxpfact1_cglposteo.fact_proveedor;
            if found then
                select into r_proveedores *
                from proveedores
                where proveedor = r_rela_cxpfact1_cglposteo.proveedor;
                if found then
                    return trim(r_proveedores.nomb_proveedor);
                end if;
            end if;
        else
            select into r_rela_cxpajuste1_cglposteo *
            from rela_cxpajuste1_cglposteo
            where consecutivo = r_cglposteo.consecutivo;
            if found then
                select into r_cxpajuste1 *
                from cxpajuste1
                where compania = r_rela_cxpajuste1_cglposteo.compania
                and sec_sjuste_cxp = r_rela_cxpajuste1_cglposteo.sec_ajuste_cxp;
                if found then
                    select into r_proveedores *
                    from proveedores
                    where proveedor = r_cxpajuste1.proveedor;
                    if found then
                        return trim(r_proveedores.nomb_proveedor);
                    end if;
                end if;
            end if;
        end if;
             
    elsif trim(as_retornar) = ''PROVEEDOR'' then
        select into r_rela_cxpfact1_cglposteo * 
        from rela_cxpfact1_cglposteo
        where consecutivo = r_cglposteo.consecutivo;
        if found then
            select into r_cxpfact1 * from cxpfact1    
            where compania = r_rela_cxpfact1_cglposteo.compania
            and proveedor = r_rela_cxpfact1_cglposteo.proveedor
            and fact_proveedor = r_rela_cxpfact1_cglposteo.fact_proveedor;
            if found then
                return trim(r_cxpfact1.proveedor);
            end if;
        else
            select into r_rela_cxpajuste1_cglposteo *
            from rela_cxpajuste1_cglposteo
            where consecutivo = r_cglposteo.consecutivo;
            if found then
                select into r_cxpajuste1 *
                from cxpajuste1
                where compania = r_rela_cxpajuste1_cglposteo.compania
                and sec_sjuste_cxp = r_rela_cxpajuste1_cglposteo.sec_ajuste_cxp;
                if found then
                    return trim(r_cxpajuste1.proveedor);
                end if;
            end if;
        end if;
    
    elsif trim(as_retornar) = ''TIPO'' then
        select into r_rela_cxpfact1_cglposteo * 
        from rela_cxpfact1_cglposteo
        where consecutivo = r_cglposteo.consecutivo;
        if found then
            select into r_cxpfact1 * from cxpfact1    
            where compania = r_rela_cxpfact1_cglposteo.compania
            and proveedor = r_rela_cxpfact1_cglposteo.proveedor
            and fact_proveedor = r_rela_cxpfact1_cglposteo.fact_proveedor;
            if found then
                return ''FACTURA'';
            end if;
        else
            select into r_rela_cxpajuste1_cglposteo *
            from rela_cxpajuste1_cglposteo
            where consecutivo = r_cglposteo.consecutivo;
            if found then
                select into r_cxpajuste1 *
                from cxpajuste1
                where compania = r_rela_cxpajuste1_cglposteo.compania
                and sec_sjuste_cxp = r_rela_cxpajuste1_cglposteo.sec_ajuste_cxp;
                if found then
                    select into r_cxpmotivos *
                    from cxpmotivos
                    where motivo_cxp = r_cxpajuste1.motivo_cxp;
                    if found then
                        return trim(r_cxpmotivos.desc_motivos_cxp);
                    end if;
                end if;
            end if;
        end if;
    
    elsif trim(as_retornar) = ''DOCUMENTO'' then
        select into r_rela_cxpfact1_cglposteo * 
        from rela_cxpfact1_cglposteo
        where consecutivo = r_cglposteo.consecutivo;
        if found then
            select into r_cxpfact1 * from cxpfact1    
            where compania = r_rela_cxpfact1_cglposteo.compania
            and proveedor = r_rela_cxpfact1_cglposteo.proveedor
            and fact_proveedor = r_rela_cxpfact1_cglposteo.fact_proveedor;
            if found then
                return trim(r_cxpfact1.fact_proveedor);
            end if;
        else
            select into r_rela_cxpajuste1_cglposteo *
            from rela_cxpajuste1_cglposteo
            where consecutivo = r_cglposteo.consecutivo;
            if found then
                select into r_cxpajuste1 *
                from cxpajuste1
                where compania = r_rela_cxpajuste1_cglposteo.compania
                and sec_sjuste_cxp = r_rela_cxpajuste1_cglposteo.sec_ajuste_cxp;
                if found then
                    return trim(r_cxpajuste1.docm_ajuste_cxp);
                end if;
            end if;
        end if;
    
    elsif trim(as_retornar) = ''OBSERVACION'' then
        select into r_rela_cxpfact1_cglposteo * 
        from rela_cxpfact1_cglposteo
        where consecutivo = r_cglposteo.consecutivo;
        if found then
            select into r_cxpfact1 * from cxpfact1    
            where compania = r_rela_cxpfact1_cglposteo.compania
            and proveedor = r_rela_cxpfact1_cglposteo.proveedor
            and fact_proveedor = r_rela_cxpfact1_cglposteo.fact_proveedor;
            if found then
                return trim(r_cxpfact1.obs_fact_cxp);
            end if;
        else
            select into r_rela_cxpajuste1_cglposteo *
            from rela_cxpajuste1_cglposteo
            where consecutivo = r_cglposteo.consecutivo;
            if found then
                select into r_cxpajuste1 *
                from cxpajuste1
                where compania = r_rela_cxpajuste1_cglposteo.compania
                and sec_sjuste_cxp = r_rela_cxpajuste1_cglposteo.sec_ajuste_cxp;
                if found then
                    return trim(r_cxpajuste1.obs_ajuste_cxp);
                end if;
            else
                select into r_rela_caja_trx1_cglposteo *
                from rela_caja_trx1_cglposteo
                where consecutivo = r_cglposteo.consecutivo;
                if found then
                    select into r_caja_trx1 * 
                    from caja_trx1
                    where caja = r_rela_caja_trx1_cglposteo.caja
                    and numero_trx = r_rela_caja_trx1_cglposteo.numero_trx;
                    if found then
                        return trim(r_caja_trx1.concepto);
                    end if;
                end if;
            end if;
        end if;
    
    end if;
    
    
    
    return lc_retornar;
end;
' language plpgsql;




create function f_cglposteo_itbms(int4, char(20)) returns decimal as '
declare
    ai_consecutivo alias for $1;
    as_retornar alias for $2;
    r_cglposteo record;
    r_rela_cxpfact1_cglposteo record;
    r_rela_cxpajuste1_cglposteo record;
    r_cxpajuste1 record;
    r_cxpmotivos record;
    r_rela_bcocheck1_cglposteo record;
    r_rela_bcotransac1_cglposteo record;
    r_rela_caja_trx1_cglposteo record;
    ldc_retornar decimal;
    ldc_work decimal;
    ldc_compra decimal;
    ldc_compra_gravada decimal;
    ldc_compra_excenta decimal;
    ldc_itbms decimal;
begin
    ldc_retornar = 0;
    select into r_cglposteo * from cglposteo
    where consecutivo = ai_consecutivo;
    if not found then
        return 0;
    end if;
    
    if trim(as_retornar) = ''ITBMS'' then
        return r_cglposteo.debito - r_cglposteo.credito;
    else
        if r_cglposteo.aplicacion_origen = ''CXP'' or 
            r_cglposteo.aplicacion_origen = ''TAL'' or 
            r_cglposteo.aplicacion_origen = ''COM'' then
            select into r_rela_cxpfact1_cglposteo *
            from rela_cxpfact1_cglposteo
            where consecutivo = ai_consecutivo;
            if found then
                ldc_retornar = 0;
                ldc_work = 0;
                select sum(cxpfact2.monto) into ldc_retornar
                from cxpfact2
                where compania = r_rela_cxpfact1_cglposteo.compania
                and proveedor = r_rela_cxpfact1_cglposteo.proveedor
                and fact_proveedor = r_rela_cxpfact1_cglposteo.fact_proveedor
                and cuenta <> r_cglposteo.cuenta;
                
                select sum(eys2.costo) into ldc_work
                from eys2
                where compania = r_rela_cxpfact1_cglposteo.compania
                and proveedor = r_rela_cxpfact1_cglposteo.proveedor
                and fact_proveedor = r_rela_cxpfact1_cglposteo.fact_proveedor;
                
                if ldc_retornar is null then
                    ldc_retornar = 0;
                end if;
                
                if ldc_work is null then
                    ldc_work = 0;
                end if;

                ldc_compra = ldc_retornar + ldc_work;
                ldc_itbms = r_cglposteo.debito - r_cglposteo.credito;
                ldc_compra_gravada = 100 * ldc_itbms / 7;

                
                if trim(as_retornar) = ''COMPRA_GRAVADA'' then
                    if ldc_compra_gravada <= ldc_compra then
                        return ldc_compra_gravada;
                    else
                        return ldc_compra;
                    end if;     
                else
                    if ldc_compra > ldc_compra_gravada then
                        return ldc_compra - ldc_compra_gravada;
                    else
                        return 0;
                    end if;
                end if;
            else
                select into r_rela_cxpajuste1_cglposteo *
                from rela_cxpajuste1_cglposteo
                where consecutivo = r_cglposteo.consecutivo;
                if found then
                    select into r_cxpajuste1 *
                    from cxpajuste1
                    where compania = r_rela_cxpajuste1_cglposteo.compania
                    and sec_ajuste_cxp = r_rela_cxpajuste1_cglposteo.sec_ajuste_cxp;
                    
                    select into r_cxpmotivos *
                    from cxpmotivos
                    where motivo_cxp = r_cxajuste1.motivo_cxp;
                    
                    select into ldc_retornar sum(monto)*r_cxpmotivos.signo
                    from cxpajuste3
                    where compania = r_rela_cxpajuste1_cglposteo.compania
                    and sec_ajuste_cxp = r_rela_cxajuste1_cglposteo.sec_ajuste_cxp
                    and cuenta <> r_cglposteo.cuenta;
                    return ldc_retornar;
                end if;
            end if;
            
        elsif r_cglposteo.aplicacion_origen = ''BCO'' then
            select into r_rela_bcocheck1_cglposteo *
            from rela_bcocheck1_cglposteo
            where consecutivo = ai_consecutivo;
            if found then
                select into ldc_retornar sum(monto)
                from bcocheck2
                where cod_ctabco = r_rela_bcocheck1_cglposteo.cod_ctabco
                and motivo_bco = r_rela_bcocheck1_cglposteo.motivo_bco
                and no_cheque = r_rela_bcocheck1_cglposteo.no_cheque
                and cuenta <> r_cglposteo.cuenta;
                
                ldc_compra = ldc_retornar;
                ldc_itbms = r_cglposteo.debito - r_cglposteo.credito;
                ldc_compra_gravada = 100 * ldc_itbms / 7;

                
                if trim(as_retornar) = ''COMPRA_GRAVADA'' then
                    if ldc_compra_gravada <= ldc_compra then
                        return ldc_compra_gravada;
                    else
                        return ldc_compra;
                    end if;     
                else
                    if ldc_compra > ldc_compra_gravada then
                        return ldc_compra - ldc_compra_gravada;
                    else
                        return 0;
                    end if;
                end if;
            else
                select into r_rela_bcotransac1_cglposteo *
                from rela_bcotransac1_cglposteo
                where consecutivo = r_cglposteo.consecutivo;
                
                select into ldc_retornar sum(bcotransac2.monto*bcomotivos.signo)
                from bcomotivos, bcotransac2, bcotransac1
                where bcomotivos.motivo_bco = bcotransac1.motivo_bco
                and bcotransac1.cod_ctabco = bcotransac2.cod_ctabco
                and bcotransac1.sec_transacc = bcotransac2.sec_transacc
                and bcotransac1.cod_ctabco = r_rela_bcotransac1_cglposteo.cod_ctabco
                and bcotransac1.sec_transacc = r_rela_bcotransac1_cglposteo.sec_transacc;

                ldc_compra = ldc_retornar;
                ldc_itbms = r_cglposteo.debito - r_cglposteo.credito;
                ldc_compra_gravada = 100 * ldc_itbms / 7;

                
                if trim(as_retornar) = ''COMPRA_GRAVADA'' then
                    if ldc_compra_gravada <= ldc_compra then
                        return ldc_compra_gravada;
                    else
                        return ldc_compra;
                    end if;     
                else
                    if ldc_compra > ldc_compra_gravada then
                        return ldc_compra - ldc_compra_gravada;
                    else
                        return 0;
                    end if;
                end if;
                
            end if;
        
        
        elsif r_cglposteo.aplicacion_origen = ''CAJ'' then
            select into r_rela_caja_trx1_cglposteo *
            from rela_caja_trx1_cglposteo
            where consecutivo = r_cglposteo.consecutivo;
            
            select into ldc_retornar sum(caja_trx2.monto) 
            from caja_trx2
            where caja = r_rela_caja_trx1_cglposteo.caja
            and numero_trx = r_rela_caja_trx1_cglposteo.numero_trx
            and cuenta <> r_cglposteo.cuenta;

            ldc_compra = ldc_retornar;
            ldc_itbms = r_cglposteo.debito - r_cglposteo.credito;
            ldc_compra_gravada = (100 * ldc_itbms) / 7;
            
            
            if trim(as_retornar) = ''COMPRA_GRAVADA'' then
                if ldc_compra_gravada <= ldc_compra then
                    return ldc_compra_gravada;
                else
                    return ldc_compra;
                end if;     
            else
                if ldc_compra > ldc_compra_gravada then
                    return ldc_compra - ldc_compra_gravada;
                else 
                    return 0;
                end if;
            end if;
        
        end if;
    end if;
    return ldc_retornar;
end;
' language plpgsql;




create view v_cxp_declaracion_impuestos as
select gralcompanias.nombre, cglposteo.compania, 
f_cglposteo(cglposteo.consecutivo, 'NOMBRE') as nombre_proveedor,
f_cglposteo(cglposteo.consecutivo, 'PROVEEDOR') as proveedor,
f_cglposteo(cglposteo.consecutivo, 'TIPO') as tipo,
f_cglposteo(cglposteo.consecutivo, 'DOCUMENTO') as documento,
cglposteo.fecha_comprobante as fecha,
f_cglposteo(cglposteo.consecutivo, 'OBSERVACION') as observacion,
f_cglposteo_itbms(cglposteo.consecutivo, 'COMPRA_GRAVADA') as compra_gravada,
f_cglposteo_itbms(cglposteo.consecutivo, 'COMPRA_EXCENTA') as compra_excenta,
f_cglposteo_itbms(cglposteo.consecutivo, 'ITBMS') as impuesto
from cglposteo, gral_impuestos, gralcompanias
where cglposteo.cuenta = gral_impuestos.cuenta
and cglposteo.compania = gralcompanias.compania
and aplicacion_origen <> 'FAC'
and fecha_comprobante >= '2010-01-01' 
union
select gralcompanias.nombre, cxpfact1.compania, proveedores.nomb_proveedor,
cxpfact1.proveedor, 'FACTURA', cxpfact1.fact_proveedor, cxpfact1.fecha_posteo_fact_cxp,
cxpfact1.obs_fact_cxp, 0,
(select sum(cxpfact2.monto) from cxpfact2
where cxpfact2.compania = cxpfact1.compania
and cxpfact2.proveedor = cxpfact1.proveedor
and cxpfact2.fact_proveedor = cxpfact1.fact_proveedor), 0
from cxpfact1, gralcompanias, proveedores
where cxpfact1.compania = gralcompanias.compania
and cxpfact1.proveedor = proveedores.proveedor
and fecha_posteo_fact_cxp >= '2010-01-01' 
and not exists
(select * from cxpfact2, gral_impuestos
where cxpfact2.cuenta = gral_impuestos.cuenta
and cxpfact2.compania = cxpfact1.compania
and cxpfact2.proveedor = cxpfact1.proveedor
and cxpfact2.fact_proveedor = cxpfact1.fact_proveedor);
