drop function f_adc_master_flete(char(2), int4, int4) cascade;
drop function f_adc_master(char(2), int4, int4, char(20)) cascade;

create function f_adc_master(char(2), int4, int4, char(20)) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    as_retornar alias for $4;
    r_adc_master record;
    li_masters integer;
    ldc_costos decimal;
    ldc_ingresos decimal;
    ldc_manejos decimal;
    ldc_work decimal;
    ldc_adc_cxc_flete decimal;
    ldc_adc_cxc_manejo decimal;
    ldc_adc_cxp_flete decimal;
    ldc_adc_cxp_manejo decimal;
    ldc_cargo decimal;
    ldc_dthc decimal;
begin
    select into r_adc_master * from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        return 0;
    end if;
    
    ldc_adc_cxc_flete = 0;
    ldc_adc_cxp_flete = 0;
    ldc_adc_cxc_manejo = 0;
    ldc_adc_cxp_manejo = 0;
    select count(*) into li_masters 
    from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo;
    
    if trim(as_retornar) = ''FLETE'' then
        select into ldc_costos sum(cglposteo.debito-cglposteo.credito)
        from rela_adc_master_cglposteo, cglposteo, cglcuentas
        where rela_adc_master_cglposteo.cgl_consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and rela_adc_master_cglposteo.compania = as_compania
        and rela_adc_master_cglposteo.consecutivo = ai_consecutivo
        and rela_adc_master_cglposteo.linea_master = ai_linea_master;
    
        select into ldc_cargo sum(cargo) from adc_house
        where compania = as_compania
        and consecutivo = ai_consecutivo
        and linea_master = ai_linea_master
        and cargo_prepago = ''N'';
                
        select into ldc_dthc sum(dthc) from adc_house
        where compania = as_compania
        and consecutivo = ai_consecutivo
        and linea_master = ai_linea_master
        and dthc_prepago = ''N'';
        
        
        select into ldc_adc_cxc_flete -sum(cglposteo.debito-cglposteo.credito)
        from rela_adc_cxc_1_cglposteo, cglposteo
        where rela_adc_cxc_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
        and (cglposteo.cuenta like ''4%'' or cglposteo.cuenta like ''9%'')
        and cglposteo.cuenta not between ''4600'' and ''4610''
        and rela_adc_cxc_1_cglposteo.compania = as_compania
        and rela_adc_cxc_1_cglposteo.consecutivo = ai_consecutivo;

        select into ldc_adc_cxc_manejo -sum(cglposteo.debito-cglposteo.credito)
        from rela_adc_cxc_1_cglposteo, cglposteo
        where rela_adc_cxc_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta not between ''4600'' and ''4610''
        and rela_adc_cxc_1_cglposteo.compania = as_compania
        and rela_adc_cxc_1_cglposteo.consecutivo = ai_consecutivo;


        select into ldc_adc_cxp_flete -sum(cglposteo.debito-cglposteo.credito)
        from rela_adc_cxp_1_cglposteo, cglposteo
        where rela_adc_cxp_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
        and (cglposteo.cuenta like ''4%'' or cglposteo.cuenta like ''9%'')
        and cglposteo.cuenta not between ''4600'' and ''4610''
        and rela_adc_cxp_1_cglposteo.compania = as_compania
        and rela_adc_cxp_1_cglposteo.consecutivo = ai_consecutivo;

        select into ldc_adc_cxp_manejo -sum(cglposteo.debito-cglposteo.credito)
        from rela_adc_cxp_1_cglposteo, cglposteo
        where rela_adc_cxp_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta not between ''4600'' and ''4610''
        and rela_adc_cxp_1_cglposteo.compania = as_compania
        and rela_adc_cxp_1_cglposteo.consecutivo = ai_consecutivo;


        if ldc_adc_cxc_flete is null then
            ldc_adc_cxc_flete = 0;
        end if;
        
        if ldc_adc_cxc_manejo is null then
            ldc_adc_cxc_manejo = 0;
        end if;
        
        if ldc_adc_cxp_flete is null then
            ldc_adc_cxp_flete = 0;
        end if;
        
        if ldc_adc_cxp_manejo is null then
            ldc_adc_cxp_manejo = 0;
        end if;
        ldc_work    =   (ldc_adc_cxc_flete -ldc_adc_cxc_manejo + ldc_adc_cxp_flete - ldc_adc_cxp_manejo)/li_masters;
        ldc_work    =   ldc_cargo + ldc_dthc - ldc_costos + ldc_work;
        return ldc_work;
    else
        select into ldc_manejos sum(cglposteo.debito-cglposteo.credito)
        from adc_manejo_factura1, rela_factura1_cglposteo, cglposteo, cglcuentas
        where adc_manejo_factura1.almacen = rela_factura1_cglposteo.almacen
        and adc_manejo_factura1.tipo = rela_factura1_cglposteo.tipo
        and adc_manejo_factura1.num_documento = rela_factura1_cglposteo.num_documento
        and rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and adc_manejo_factura1.compania = as_compania
        and adc_manejo_factura1.consecutivo = ai_consecutivo
        and adc_manejo_factura1.linea_master = ai_linea_master;
        
        select into ldc_adc_cxc_manejo sum(cglposteo.debito-cglposteo.credito)
        from rela_adc_cxc_1_cglposteo, cglposteo
        where rela_adc_cxc_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta between ''4600'' and ''4610''
        and rela_adc_cxc_1_cglposteo.compania = as_compania
        and rela_adc_cxc_1_cglposteo.consecutivo = ai_consecutivo;
    
        select into ldc_adc_cxp_manejo sum(cglposteo.debito-cglposteo.credito)
        from rela_adc_cxp_1_cglposteo, cglposteo
        where rela_adc_cxp_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta between ''4600'' and ''4610''
        and rela_adc_cxp_1_cglposteo.compania = as_compania
        and rela_adc_cxp_1_cglposteo.consecutivo = ai_consecutivo;
        
        if ldc_adc_cxc_manejo is null then
            ldc_adc_cxc_manejo = 0;
        end if;
        
        if ldc_adc_cxp_manejo is null then
            ldc_adc_cxp_manejo = 0;
        end if;
        
        if ldc_manejos is null then
            ldc_manejos = 0;
        end if;
        
        ldc_work    =   (ldc_adc_cxc_manejo + ldc_adc_cxp_manejo) / li_masters;
        return ldc_manejos + ldc_work;
    end if;
end;
' language plpgsql;

create function f_adc_master_flete(char(2), int4, int4) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ldc_ingreso decimal(10,2);
    ldc_cargos decimal(10,2);
    ldc_cargos_totales decimal(10,2);
    ldc_ajustes_cxc decimal;
    ldc_ajustes_cxp decimal;
    ldc_retorno decimal;
    r_adc_master record;
    r_adc_house record;
begin
    select into r_adc_master * from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        return 0;
    end if;
    
    if r_adc_master.dthc_prepago is null then
        r_adc_master.dthc_prepago = ''N'';
    end if;
    
    if r_adc_master.dthc is null then
        r_adc_master.dthc = 0;
    end if;


    ldc_ingreso = 0;    
    for r_adc_house in select adc_house.* from adc_house
                        where compania = as_compania
                        and consecutivo = ai_consecutivo
                        and linea_master = ai_linea_master
    loop
        if r_adc_house.cargo is null then
            r_adc_house.cargo = 0;
        end if;
        
        if r_adc_house.gtos_d_origen is null then
            r_adc_house.gtos_d_origen = 0;
        end if;
        
        if r_adc_house.dthc is null then
            r_adc_house.dthc = 0;
        end if;
        
        ldc_ingreso = ldc_ingreso + r_adc_house.cargo + r_adc_house.gtos_d_origen + r_adc_house.dthc;
    end loop;        
    
    select into ldc_ajustes_cxc sum(cxcmotivos.signo*adc_cxc_1.monto)
    from adc_cxc_1, cxcmotivos
    where adc_cxc_1.motivo_cxc = cxcmotivos.motivo_cxc
    and adc_cxc_1.compania = as_compania
    and adc_cxc_1.consecutivo = ai_consecutivo;
    
    
    if ldc_ajustes_cxc is null then
        ldc_ajustes_cxc = 0;
    end if;
    
    select into ldc_ajustes_cxp sum(cxpmotivos.signo*adc_cxp_1.monto)
    from adc_cxp_1, cxpmotivos
    where adc_cxp_1.motivo_cxp = cxpmotivos.motivo_cxp
    and adc_cxp_1.compania = as_compania
    and adc_cxp_1.consecutivo = ai_consecutivo;
    
    if ldc_ajustes_cxp is null then
        ldc_ajustes_cxp = 0;
    end if;
    
    
    select into ldc_cargos_totales sum(cargo+gtos_d_origen+gtos_destino+dthc)
    from adc_master
    where adc_master.compania = as_compania
    and adc_master.consecutivo = ai_consecutivo;

    ldc_cargos  =   r_adc_master.cargo - r_adc_master.gtos_d_origen - r_adc_master.gtos_destino + r_adc_master.dthc;
    
    if ldc_cargos_totales <> 0 then
        ldc_ajustes_cxc =   (ldc_cargos/ldc_cargos_totales)*ldc_ajustes_cxc;
        ldc_ajustes_cxp =   (ldc_cargos/ldc_cargos_totales)*ldc_ajustes_cxp;
    end if;
    
    ldc_retorno =   ldc_ingreso - ldc_cargos + ldc_ajustes_cxc - ldc_ajustes_cxp;
    if ldc_retorno is null then
        ldc_retorno = 0;
    end if;
    
    return ldc_retorno;
end;
' language plpgsql;