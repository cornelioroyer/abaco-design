drop function f_validar_balance(char(2)) cascade;

create function f_validar_balance(char(2)) returns integer as '
declare
    as_compania alias for $1;
    ld_desde date;
    ldc_work decimal(14,2);
    r_work_1 record;
    r_cglposteo record;
    r_rela_cgl_comprobante1_cglposteo record;
    r_adc_master record;
    r_rela_activos_cglposteo record;
    r_rela_bcocheck1_cglposteo record;
    r_factura1 record;
    r_factura2 record;
    r_cxc_recibo1 record;
    r_cxc_recibo2 record;
    r_cxcdocm record;
    li_retorno integer;
begin
    li_retorno = 0;
    
    select Min(inicio) into ld_desde
    from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and estado = ''A'';
    if not found then
        Raise Exception ''No existen periodos abiertos'';
    end if;
    

    delete from cglposteo
    using rela_bcotransac1_cglposteo, bcotransac1, bcoctas
    where rela_bcotransac1_cglposteo.consecutivo = cglposteo.consecutivo
    and rela_bcotransac1_cglposteo.cod_ctabco = bcotransac1.cod_ctabco
    and rela_bcotransac1_cglposteo.sec_transacc = bcotransac1.sec_transacc
    and rela_bcotransac1_cglposteo.cod_ctabco = bcoctas.cod_ctabco
    and bcoctas.compania = as_compania
    and (bcotransac1.fecha_posteo >= ld_desde
    or cglposteo.fecha_comprobante >= ld_desde)
    and bcotransac1.fecha_posteo <> cglposteo.fecha_comprobante;


    delete from eys1
    using almacen
    where eys1.almacen = almacen.almacen
    and f_sum_eys(eys1.almacen, no_transaccion, ''eys2'') <> f_sum_eys(eys1.almacen, no_transaccion, ''eys3'')
    and fecha >= ld_desde
    and almacen.compania = as_compania
    and aplicacion_origen = ''FAC'';

    
    ldc_work = 0;
    li_retorno = 1;
    for r_work_1 in select aplicacion_origen, fecha_comprobante, sum(cglposteo.debito-cglposteo.credito) as monto
                        from cglposteo
                        where compania = as_compania
                        and fecha_comprobante >= ld_desde
                        group by 1, 2
                        having sum(cglposteo.debito-cglposteo.credito) <> 0
                        order by 1, 2
    loop
        delete from cglposteo
        where compania = as_compania
        and aplicacion_origen = r_work_1.aplicacion_origen
        and fecha_comprobante = r_work_1.fecha_comprobante;
        li_retorno = 0;
    end loop;    


    ldc_work = 0;
    li_retorno = 1;
    for r_cglposteo in select * from cglposteo
                        where compania = as_compania
                        and fecha_comprobante >= ld_desde
                        and aplicacion_origen = ''CGL''
                        order by fecha_comprobante, consecutivo
    loop
        select into r_rela_cgl_comprobante1_cglposteo *
        from rela_cgl_comprobante1_cglposteo
        where consecutivo = r_cglposteo.consecutivo;
        if not found then
            delete from cglposteo
            where consecutivo = r_cglposteo.consecutivo;
        end if;
    end loop;    

    
    for r_adc_master in select adc_master.* 
                        from adc_manifiesto, adc_master, rela_adc_master_cglposteo, cglposteo
                        where adc_manifiesto.compania = adc_master.compania
                        and adc_manifiesto.consecutivo = adc_master.consecutivo
                        and adc_master.compania = rela_adc_master_cglposteo.compania
                        and adc_master.consecutivo = rela_adc_master_cglposteo.consecutivo
                        and adc_master.linea_master = rela_adc_master_cglposteo.linea_master
                        and rela_adc_master_cglposteo.cgl_consecutivo = cglposteo.consecutivo
                        and adc_manifiesto.compania = as_compania
                        and adc_manifiesto.fecha >= ld_desde
                        and cglposteo.aplicacion_origen <> ''CXP''
    loop
        delete from rela_adc_master_cglposteo
        where compania = r_adc_master.compania
        and consecutivo = r_adc_master.consecutivo
        and linea_master = r_adc_master.linea_master;
    end loop;


    
    for r_rela_activos_cglposteo in 
                        select rela_activos_cglposteo.compania, rela_activos_cglposteo.codigo, count(*)
                        from activos, rela_activos_cglposteo
                        where activos.compania = rela_activos_cglposteo.compania
                        and activos.codigo = rela_activos_cglposteo.codigo
                        and activos.fecha_compra >= ld_desde
                        and activos.compania = as_compania
                        group by 1, 2
                        having count(*) <= 1
    loop
        delete from rela_activos_cglposteo
        where compania = r_rela_activos_cglposteo.compania
        and codigo = r_rela_activos_cglposteo.codigo;    
    end loop;       



    for r_rela_bcocheck1_cglposteo in 
                        select rela_bcocheck1_cglposteo.cod_ctabco, no_cheque, motivo_bco, sum(cglposteo.debito-cglposteo.credito)
                        from rela_bcocheck1_cglposteo, cglposteo, bcoctas
                        where cglposteo.consecutivo = rela_bcocheck1_cglposteo.consecutivo
                        and cglposteo.fecha_comprobante >= ld_desde
                        and bcoctas.cod_ctabco = rela_bcocheck1_cglposteo.cod_ctabco
                        and bcoctas.compania = as_compania
                        group by 1, 2, 3
                        having sum(cglposteo.debito-cglposteo.credito) <> 0
                        order by 1, 3, 2
    loop
        delete from rela_bcocheck1_cglposteo
        where cod_ctabco = r_rela_bcocheck1_cglposteo.cod_ctabco
        and no_cheque = r_rela_bcocheck1_cglposteo.no_cheque
        and motivo_bco = r_rela_bcocheck1_cglposteo.motivo_bco;
    end loop;       


    for r_factura1 in select factura1.*
        from almacen, factura1, factmotivos
        where almacen.almacen = factura1.almacen
        and factura1.tipo = factmotivos.tipo
        and almacen.compania = as_compania
        and factura1.fecha_factura >= ld_desde
        and factmotivos.cotizacion <> ''S'' and factmotivos.donacion <> ''S''
        and factura1.status <> ''A''
        order by factura1.fecha_factura, factura1.num_documento
    loop
        select into r_factura2 *
        from factura2
        where almacen = r_factura1.almacen
        and caja = r_factura1.caja
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;
        if not found then
            Raise Exception ''Almacen % Caja % Tipo % Numero % no tiene detalle Verifique'',r_factura1.almacen, r_factura1.caja, r_factura1.tipo, r_factura1.num_documento;
        end if;
        
        ldc_work = 0;
        select sum(monto) into ldc_work
        from factura4
        where almacen = r_factura1.almacen
        and caja = r_factura1.caja
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;
        if ldc_work is null or ldc_work = 0 then
            Raise Exception ''Almacen % Caja % Tipo % Numero % no tiene totales (factura4) Verifique'',r_factura1.almacen, r_factura1.caja, r_factura1.tipo, r_factura1.num_documento;
        end if;
    end loop;


    for r_cxc_recibo1 in select cxc_recibo1.*
        from almacen, cxc_recibo1
        where almacen.almacen = cxc_recibo1.almacen
        and almacen.compania = as_compania
        and cxc_recibo1.fecha >= ld_desde
        order by cxc_recibo1.fecha, cxc_recibo1.caja, cxc_recibo1.consecutivo
    loop
        for r_cxc_recibo2 in select * from cxc_recibo2
                                where almacen = r_cxc_recibo1.almacen
                                and caja = r_cxc_recibo1.caja
                                and consecutivo = r_cxc_recibo1.consecutivo
                                order by documento_aplicar
        loop
            select into r_cxcdocm *
            from cxcdocm
            where almacen = r_cxc_recibo2.almacen_aplicar
            and caja = r_cxc_recibo2.caja_aplicar
            and cliente = r_cxc_recibo1.cliente
            and documento = r_cxc_recibo2.documento_aplicar
            and docmto_aplicar = r_cxc_recibo2.documento_aplicar
            and motivo_cxc = r_cxc_recibo2.motivo_aplicar;
            if not found then
--                Raise Exception ''Almacen % Caja % Consecutivo % Recibo con Inconsistencia'',r_cxc_recibo2.almacen, r_cxc_recibo2.caja, r_cxc_recibo2.consecutivo;
            end if;
        end loop;                                
    end loop;
   
    
    return li_retorno;
end;
' language plpgsql;
