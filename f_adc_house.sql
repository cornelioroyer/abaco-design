create function f_adc_house(char(2), int4, int4, int4, char(20)) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ai_linea_house alias for $4;
    as_retornar alias for $5;
    r_adc_house record;
    r_adc_master record;
    r_adc_manifiesto record;
    r_work record;
    ldc_ingresos_house decimal;
    ldc_retorno decimal;
    ldc_total_ingresos decimal;
    ldc_porcentaje_costos decimal;
    ldc_costos decimal;
    ldc_cxc decimal;
    ldc_cxc_manejo decimal;
    ldc_cxp decimal;
    ldc_cxp_manejo decimal;
    ldc_manejo_flete decimal;
    ldc_manejo decimal;
    ldc_work_manejo decimal;
    ldc_work_flete decimal;
    ldc_work decimal;
    ldc_cargo_total decimal;
    ldc_cargo decimal;
    ldc_dthc_total decimal;
    ldc_dthc decimal;
    ldc_gtos_d_origen decimal;
    ldc_gtos_d_origen_total decimal;
    ldc_ingresos_lote decimal;
    ldc_porcentaje_lote decimal;
    ldc_dthc_lote decimal;
    ldc_gtos_d_origen_lote decimal;
    ldc_cargo_lote decimal;
begin
    select into r_adc_manifiesto * from adc_manifiesto
    where compania = as_compania
    and consecutivo = ai_consecutivo;
    if not found then
        return 0;
    end if;
  
    select into r_adc_master * from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        return 0;
    end if;

    select into r_adc_house * from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and linea_house = ai_linea_house;
    if not found then
        return 0;
    end if;
    
    select into ldc_cargo_lote sum(cargo) from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and cargo_prepago = ''N'';
    if ldc_cargo_lote is null then
        ldc_cargo_lote = 0;
    end if;

    select into ldc_gtos_d_origen_lote sum(gtos_d_origen) from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and gtos_prepago = ''N'';
    if ldc_gtos_d_origen_lote is null then
        ldc_gtos_d_origen_lote = 0;
    end if;

    select into ldc_dthc_lote sum(dthc) from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and dthc_prepago = ''N'';
    if ldc_dthc_lote is null then
        ldc_dthc_lote = 0;
    end if;
    
    ldc_ingresos_lote   =   ldc_dthc_lote + ldc_gtos_d_origen_lote + ldc_cargo_lote;
    
    select into ldc_cargo_total sum(cargo) from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and cargo_prepago = ''N'';
    if ldc_cargo_total is null then
        ldc_cargo_total = 0;
    end if;

    select into ldc_gtos_d_origen_total sum(gtos_d_origen) from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and gtos_prepago = ''N'';
    if ldc_gtos_d_origen_total is null then
        ldc_gtos_d_origen_total = 0;
    end if;

    select into ldc_dthc_total sum(dthc) from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and dthc_prepago = ''N'';
    if ldc_dthc_total is null then
        ldc_dthc_total = 0;
    end if;

    ldc_total_ingresos = ldc_dthc_total + ldc_gtos_d_origen_total + ldc_cargo_total;
    
    if r_adc_house.cargo_prepago = ''N'' then
        ldc_cargo = r_adc_house.cargo;
    else
        ldc_cargo = 0;
    end if;
    
    if r_adc_house.gtos_prepago = ''N'' then
        ldc_gtos_d_origen = r_adc_house.gtos_d_origen;
    else
        ldc_gtos_d_origen = 0;
    end if;
    
    if r_adc_house.dthc_prepago = ''N'' then
        ldc_dthc = r_adc_house.dthc;
    else
        ldc_dthc = 0;
    end if;
    
    ldc_ingresos_house  =   ldc_cargo + ldc_gtos_d_origen + ldc_dthc;

    if ldc_total_ingresos <> 0 then
        ldc_porcentaje_costos = ldc_ingresos_house / ldc_total_ingresos;
    else
        ldc_porcentaje_costos = 0;
    end if;
    
    if ldc_ingresos_lote <> 0 then
        ldc_porcentaje_lote = ldc_ingresos_house / -ldc_ingresos_lote;
    else
        ldc_porcentaje_lote = 0;
    end if;
    
    select into ldc_costos -sum(cglposteo.debito-cglposteo.credito)
    from rela_adc_master_cglposteo, cglposteo, cglcuentas
    where rela_adc_master_cglposteo.cgl_consecutivo = cglposteo.consecutivo
    and cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and rela_adc_master_cglposteo.compania = as_compania
    and rela_adc_master_cglposteo.consecutivo = ai_consecutivo
    and rela_adc_master_cglposteo.linea_master = ai_linea_master;
    if ldc_costos is null then
        ldc_costos = 0;
    end if;
    ldc_costos = ldc_costos * ldc_porcentaje_costos;
    
    select into ldc_cxc_manejo -sum(cglposteo.debito-cglposteo.credito)
    from rela_adc_cxc_1_cglposteo, cglposteo, cglcuentas
    where rela_adc_cxc_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
    and cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and rela_adc_cxc_1_cglposteo.compania = as_compania
    and rela_adc_cxc_1_cglposteo.consecutivo = ai_consecutivo
    and cglposteo.cuenta between ''4600'' and ''4610'';
    if ldc_cxc_manejo is null then
        ldc_cxc_manejo = 0;
    end if;
    
    select into ldc_cxp_manejo -sum(cglposteo.debito-cglposteo.credito)
    from rela_adc_cxp_1_cglposteo, cglposteo, cglcuentas
    where rela_adc_cxp_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
    and cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and rela_adc_cxp_1_cglposteo.compania = as_compania
    and rela_adc_cxp_1_cglposteo.consecutivo = ai_consecutivo
    and cglposteo.cuenta between ''4600'' and ''4610'';
    if ldc_cxp_manejo is null then
        ldc_cxp_manejo = 0;
    end if;
    
    select into ldc_cxc -sum(cglposteo.debito-cglposteo.credito)
    from rela_adc_cxc_1_cglposteo, cglposteo, cglcuentas
    where rela_adc_cxc_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
    and cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and rela_adc_cxc_1_cglposteo.compania = as_compania
    and rela_adc_cxc_1_cglposteo.consecutivo = ai_consecutivo;
    if ldc_cxc is null then
        ldc_cxc = 0;
    end if;
    ldc_cxc =   ldc_cxc - ldc_cxc_manejo;
    ldc_cxc =   ldc_cxc * ldc_porcentaje_lote;

    
    select into ldc_cxp -sum(cglposteo.debito-cglposteo.credito)
    from rela_adc_cxp_1_cglposteo, cglposteo, cglcuentas
    where rela_adc_cxp_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
    and cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and rela_adc_cxp_1_cglposteo.compania = as_compania
    and rela_adc_cxp_1_cglposteo.consecutivo = ai_consecutivo;
    if ldc_cxp is null then
        ldc_cxp = 0;
    end if;
    ldc_cxp =   ldc_cxp - ldc_cxp_manejo;
    ldc_cxp =   ldc_cxp * ldc_porcentaje_lote;
    
    
    ldc_manejo_flete    =   0;
    ldc_manejo          =   0;

    for r_work in select adc_manejo_factura1.almacen, adc_manejo_factura1.tipo,
                    adc_manejo_factura1.num_documento
                  from adc_manejo_factura1
                  where adc_manejo_factura1.compania = as_compania
                    and adc_manejo_factura1.consecutivo = ai_consecutivo
                  group by 1, 2, 3
                  order by 1, 2, 3
    loop
        select into ldc_work_manejo -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo, cglcuentas
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento
        and cglposteo.cuenta between ''4600'' and ''4610'';
        if ldc_work_manejo is null then
            ldc_work_manejo = 0;
        end if;
        
        select into ldc_work_flete -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo, cglcuentas
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento;
        if ldc_work_flete is null then
            ldc_work_flete = 0;
        end if;
        
        ldc_work_flete      =   ldc_work_flete - ldc_work_manejo;
        
        ldc_manejo_flete    =   ldc_manejo_flete + ldc_work_flete;
        ldc_manejo          =   ldc_manejo + ldc_work_manejo;
    end loop;    

    
    ldc_manejo_flete    =   ldc_manejo_flete * ldc_porcentaje_lote;
    ldc_manejo          =   ldc_manejo * ldc_porcentaje_lote;
    
    if trim(as_retornar) = ''MANEJO'' then
        return -ldc_manejo - ldc_cxc_manejo - ldc_cxp_manejo;
    else
        return ldc_ingresos_house + ldc_costos - ldc_cxc - ldc_cxp - ldc_manejo_flete;
    end if;
end;
' language plpgsql;

