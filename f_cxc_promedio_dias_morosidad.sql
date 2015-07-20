

--drop function f_cxc_promedio_dias_morosidad(char(10), date, date, varchar(20)) cascade;
-- drop function f_cxc_promedio_dias_morosidad(char(10), date, varchar(20))cascade;
drop function f_cxc_promedio_dias_morosidad(char(2), char(10), date, varchar(20)) cascade;

create function f_cxc_promedio_dias_morosidad(char(2), char(10), date, varchar(20))returns decimal as '
declare
    as_cia alias for $1;
    as_cliente alias for $2;
    ad_hasta alias for $3;
    avc_retorno alias for $4;
    li_count integer;
    ldc_work decimal;
    ld_dia1 date;
    ld_dia2 date;
    ldc_dias decimal;
    ldc_venta decimal;
    ldc_saldo decimal;
    ldc_rotacion decimal;
    ldc_acumulado decimal;
    r_work record;
    r_cxcdocm record;
begin
    ldc_work = 0;
    ldc_acumulado = 0;
    ldc_saldo = 0;
    for r_work in SELECT cxcdocm.almacen,
                     cxcdocm.caja,
                     cxcdocm.cliente,   
                     cxcdocm.documento,
                     cxcdocm.docmto_aplicar,
                     cxcdocm.motivo_cxc,
                     cxcdocm.fecha_posteo,
                     f_saldo_documento_cxc(cxcdocm.almacen, cxcdocm.caja,
                        cxcdocm.cliente, cxcdocm.motivo_cxc, cxcdocm.documento, ad_hasta) as saldo  
                FROM almacen, cxcdocm
                WHERE cxcdocm.almacen = almacen.almacen
                    and cxcdocm.cliente = as_cliente
                    and almacen.compania = as_cia
                    and cxcdocm.fecha_posteo <= ad_hasta
                    and trim(cxcdocm.documento) = trim(cxcdocm.docmto_aplicar)
                    and trim(cxcdocm.motivo_cxc) = trim(cxcdocm.motivo_ref)
             order by documento
    loop
        if r_work.saldo = 0 then
            continue;
        end if;
        
        ldc_dias        =   ad_hasta - r_work.fecha_posteo;
        ldc_acumulado   =   ldc_acumulado + (ldc_dias * r_work.saldo);
        ldc_saldo       =   ldc_saldo + r_work.saldo;
            
       
    end loop;

    ldc_work    =   ldc_acumulado / ldc_saldo;
    return ldc_work;
end;
' language plpgsql;    

  
