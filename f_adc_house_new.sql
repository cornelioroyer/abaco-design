drop function f_adc_house(char(2), int4, int4, int4, char(20)) cascade;


create function f_adc_house(char(2), int4, int4, int4, char(20)) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ai_linea_house alias for $4;
    as_retornar alias for $5;
    r_adc_house record;
    r_work record;
    ldc_work decimal;
    ldc_flete decimal;
    ldc_flete_house decimal;
    ldc_manejo decimal;
    ldc_manejo_house decimal;
    ldc_manifiesto_master decimal;
    ldc_master decimal;
    ldc_porcentaje decimal;
    ldc_master_house decimal;
    ldc_house decimal;
    ldc_count decimal;
    ldc_lineas decimal;
    ldc_costos_flete decimal;
    li_lineas int4;
    li_count int4;
begin
    select into r_adc_house * from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and linea_house = ai_linea_house;
    if not found then
        return 0;
    end if;
    ldc_flete   =   0;    
    ldc_manejo  =   0;
    ldc_costos_flete = 0;
    for r_work in select adc_house_factura1.almacen, adc_house_factura1.tipo,
                    adc_house_factura1.num_documento
                  from adc_house_factura1
                  where adc_house_factura1.compania = as_compania
                    and adc_house_factura1.consecutivo = ai_consecutivo
                    and adc_house_factura1.linea_master = ai_linea_master
                    and adc_house_factura1.linea_house = ai_linea_house
                  group by 1, 2, 3
                  order by 1, 2, 3
    loop
        li_lineas = 0;
        select into li_lineas count(*)
        from adc_house_factura1
        where almacen = r_work.almacen
        and tipo = r_work.tipo
        and num_documento = r_work.num_documento
        and linea_manejo is null;
        if li_lineas is null or li_lineas = 0 then
            li_lineas = 1;
        end if;
        
        ldc_lineas = li_lineas;
        
        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo, cglcuentas
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento;
        if ldc_work is null then
            ldc_work = 0;
        end if;
        
            
        ldc_flete   =   ldc_flete + (ldc_work/ldc_lineas);
        

        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo, cglcuentas
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta = cglcuentas.cuenta
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento
        and (cglposteo.cuenta like ''9%'' or cglposteo.cuenta like ''8%'');
        if ldc_work is null then
            ldc_work = 0;
        end if;
        
        ldc_costos_flete = ldc_costos_flete + (ldc_work/ldc_lineas);
        
        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo, cglcuentas
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta = cglcuentas.cuenta
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento
        and ((cglposteo.cuenta between ''4600'' and ''4610'') or cglposteo.cuenta like ''8%'');
        if ldc_work is null then
            ldc_work = 0;
        end if;
        
        
        
        ldc_manejo  =   ldc_manejo + (ldc_work/ldc_lineas);
        ldc_flete   =   ldc_flete - (ldc_work/ldc_lineas);
    end loop;
    
    
/*    
    select into li_count count(*) from adc_house_factura1
    where almacen = r_work.almacen
    and tipo = r_work.tipo
    and num_documento = r_work.num_documento;
    if li_count is null or li_count = 0 then
        ldc_porcentaje  = 0;
    else
        ldc_count       =   li_count;
        ldc_porcentaje  =   1 / ldc_count;
    end if;
    
    ldc_flete           =   ldc_flete * ldc_porcentaje;
*/   
    
    ldc_flete           =   ldc_flete + f_adc_manejo(as_compania, ai_consecutivo, ai_linea_master, ai_linea_house, ''FLETE'');
    ldc_costos_flete    =   ldc_costos_flete + f_adc_manejo(as_compania, ai_consecutivo, ai_linea_master, ai_linea_house, ''COSTOS_FLETE'');
    ldc_manejo          =   ldc_manejo + f_adc_manejo(as_compania, ai_consecutivo, ai_linea_master, ai_linea_house, ''MANEJO'');    
    ldc_manejo_house    =   ldc_manejo;
    ldc_flete_house     =   ldc_flete;
    
    if trim(as_retornar) = ''FLETE'' then    
        ldc_master              =   f_adc_master(as_compania, ai_consecutivo, ai_linea_master, trim(as_retornar));
        
        ldc_master_house        =   f_adc_master_house(as_compania, ai_consecutivo, ai_linea_master, trim(as_retornar));
        ldc_house               =   ldc_flete_house;
        
        
/*        
        if ldc_master_house = 0 or ldc_house = 0 then
            select into li_count count(*)
            from adc_house
            where compania = as_compania
            and consecutivo = ai_consecutivo
            and linea_master = ai_linea_master;
            if li_count is null or li_count = 0 then
                ldc_porcentaje = 0;
            else
                ldc_count       =   li_count;
                ldc_porcentaje  =    1 / ldc_count;
            end if;
        else
            ldc_porcentaje  =   ldc_house / ldc_master_house;
        end if;
*/

/*
        ldc_count = 0;
        for r_work in select almacen, tipo, num_documento
                        from adc_house_factura1
                        where compania = as_compania
                        and consecutivo = ai_consecutivo
                        and linea_master = ai_linea_master
                        group by 1, 2, 3
        loop
            ldc_count = ldc_count + f_monto_factura(r_work.almacen, r_work.tipo, r_work.num_documento);
        end loop;
        if ldc_count = 0 then
            ldc_porcentaje = 0;
        else
            
        end if;        
*/    
        select into li_count count(*)
        from adc_house
        where compania = as_compania
        and consecutivo = ai_consecutivo
        and linea_master = ai_linea_master;
        if li_count is null or li_count = 0 then
            ldc_porcentaje = 0;
        else
            ldc_count       =   li_count;
            ldc_porcentaje  =    1 / ldc_count;
        end if;

--        raise exception ''% master % %'',ldc_flete, ldc_master, ldc_porcentaje;
        
        ldc_flete       =   ldc_flete + (ldc_master * ldc_porcentaje);
        return ldc_flete;
    else
        ldc_master              =   f_adc_master(as_compania, ai_consecutivo, ai_linea_master, trim(as_retornar));
        
        
        ldc_master_house        =   f_adc_master_house(as_compania, ai_consecutivo, ai_linea_master, trim(as_retornar));
        ldc_house               =   ldc_flete_house;
        
        select into li_count count(*)
        from adc_house
        where compania = as_compania
        and consecutivo = ai_consecutivo
        and linea_master = ai_linea_master;
        if li_count is null or li_count = 0 then
            ldc_count = 1;
        else
            ldc_count       =   li_count;
        end if;
        
        ldc_manejo       =   ldc_manejo + (ldc_master/ldc_count);
        
        if trim(as_retornar) = ''COSTOS_FLETE'' then
            return (ldc_master/ldc_count);
        else
            return ldc_manejo;
        end if;

/*        
        if ldc_master_house = 0 or ldc_house = 0 then
            select into li_count count(*)
            from adc_house
            where compania = as_compania
            and consecutivo = ai_consecutivo
            and linea_master = ai_linea_master;
            if li_count is null or li_count = 0 then
                ldc_porcentaje = 0;
            else
                ldc_count       =   li_count;
                ldc_porcentaje  =    1 / ldc_count;
            end if;
            
        else
            ldc_porcentaje  =   ldc_house / ldc_master_house;
        end if;
*/        
    end if;    
end;
' language plpgsql;
