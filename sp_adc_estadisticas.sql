drop function f_adc_house(char(2), int4, int4, int4, char(20)) cascade;
drop function f_adc_manejo(char(2), int4, int4, int4, char(20)) cascade;
drop function f_adc_master_house(char(2), int4, int4, char(20)) cascade;
drop function f_adc_ajustes(char(2), int4, char(20)) cascade;
drop function f_adc_master(char(2), int4, int4, char(20)) cascade;
drop function f_adc_manifiesto_master(char(2), int4, char(20)) cascade;
drop function f_adc_manifiesto(char(2), int4, char(20)) cascade;
drop function f_adc_house_datos(char(2), int4, int4, int4, char(40)) cascade;


create function f_adc_house_datos(char(2), int4, int4, int4, char(40)) returns char(50) as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ai_linea_house alias for $4;
    as_retornar alias for $5;
    r_adc_house record;
    r_factura1 record;
    r_cxcdocm record;
    lc_retorno char(50);
    ld_work date;
    li_work int4;
    ldc_work decimal;
begin
    select into r_adc_house * from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and linea_house = ai_linea_house;
    if not found then
        return 0;
    end if;
    
    if trim(as_retornar) = ''FECHA_FACTURA_FLETE'' then
        select into ld_work Max(factura1.fecha_factura)
        from adc_house_factura1, factura1, factmotivos
        where adc_house_factura1.almacen = factura1.almacen
        and adc_house_factura1.caja = factura1.caja
        and adc_house_factura1.tipo = factura1.tipo
        and adc_house_factura1.num_documento = factura1.num_documento
        and factura1.tipo = factmotivos.tipo
        and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
        and factura1.status <> ''A''
        and adc_house_factura1.compania = as_compania
        and adc_house_factura1.consecutivo = ai_consecutivo
        and adc_house_factura1.linea_master = ai_linea_master
        and adc_house_factura1.linea_house = ai_linea_house;
        return to_char(ld_work, ''yyyy-mm-dd'');
        
    elsif trim(as_retornar) = ''NUMERO_FACTURA_FLETE'' then
        select into li_work Max(factura1.num_documento)
        from adc_house_factura1, factura1, factmotivos
        where adc_house_factura1.almacen = factura1.almacen
        and adc_house_factura1.caja = factura1.caja
        and adc_house_factura1.tipo = factura1.tipo
        and adc_house_factura1.num_documento = factura1.num_documento
        and factura1.tipo = factmotivos.tipo
        and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
        and factura1.status <> ''A''
        and adc_house_factura1.compania = as_compania
        and adc_house_factura1.consecutivo = ai_consecutivo
        and adc_house_factura1.linea_master = ai_linea_master
        and adc_house_factura1.linea_house = ai_linea_house;
        return Trim(to_char(li_work, ''99999999999999''));
        
    elsif trim(as_retornar) = ''FECHA_FACTURA_MANEJO'' then
        select into ld_work Max(factura1.fecha_factura)
        from adc_manejo_factura1, factura1, factmotivos
        where adc_manejo_factura1.almacen = factura1.almacen
        and adc_manejo_factura1.caja = factura1.caja
        and adc_manejo_factura1.tipo = factura1.tipo
        and adc_manejo_factura1.num_documento = factura1.num_documento
        and factura1.tipo = factmotivos.tipo
        and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
        and factura1.status <> ''A''
        and adc_manejo_factura1.compania = as_compania
        and adc_manejo_factura1.consecutivo = ai_consecutivo
        and adc_manejo_factura1.linea_master = ai_linea_master
        and adc_manejo_factura1.linea_house = ai_linea_house;
        return to_char(ld_work, ''yyyy-mm-dd'');

    elsif trim(as_retornar) = ''NUMERO_FACTURA_MANEJO'' then
        select into li_work Max(factura1.num_documento)
        from adc_manejo_factura1, factura1, factmotivos
        where adc_manejo_factura1.almacen = factura1.almacen
        and adc_manejo_factura1.caja = factura1.caja
        and adc_manejo_factura1.tipo = factura1.tipo
        and adc_manejo_factura1.num_documento = factura1.num_documento
        and factura1.tipo = factmotivos.tipo
        and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
        and factura1.status <> ''A''
        and adc_manejo_factura1.compania = as_compania
        and adc_manejo_factura1.consecutivo = ai_consecutivo
        and adc_manejo_factura1.linea_master = ai_linea_master
        and adc_manejo_factura1.linea_house = ai_linea_house;
        return Trim(to_char(li_work, ''99999999999999''));
        
    elsif trim(as_retornar) = ''SALDO_FACTURA_FLETE'' then
        select into r_factura1 factura1.*
        from adc_house_factura1, factura1, factmotivos
        where adc_house_factura1.almacen = factura1.almacen
        and adc_house_factura1.caja = factura1.caja
        and adc_house_factura1.tipo = factura1.tipo
        and adc_house_factura1.num_documento = factura1.num_documento
        and factura1.tipo = factmotivos.tipo
        and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
        and factura1.status <> ''A''
        and adc_house_factura1.compania = as_compania
        and adc_house_factura1.consecutivo = ai_consecutivo
        and adc_house_factura1.linea_master = ai_linea_master
        and adc_house_factura1.linea_house = ai_linea_house;
        if found then
            ldc_work    =   f_saldo_documento_cxc(r_factura1.almacen,
                                r_factura1.caja, 
                                r_factura1.cliente,
                                r_factura1.tipo,
                                Trim(to_char(r_factura1.num_documento,''999999999999999'')),
                                current_date);
            return Trim(to_char(ldc_work, ''999999999999.99''));
        end if;
        
    elsif trim(as_retornar) = ''MONTO_FACTURA_FLETE'' then
        select into r_factura1 factura1.*
        from adc_house_factura1, factura1, factmotivos
        where adc_house_factura1.almacen = factura1.almacen
        and adc_house_factura1.caja = factura1.caja
        and adc_house_factura1.tipo = factura1.tipo
        and adc_house_factura1.num_documento = factura1.num_documento
        and factura1.tipo = factmotivos.tipo
        and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
        and factura1.status <> ''A''
        and adc_house_factura1.compania = as_compania
        and adc_house_factura1.consecutivo = ai_consecutivo
        and adc_house_factura1.linea_master = ai_linea_master
        and adc_house_factura1.linea_house = ai_linea_house;
        if found then
            ldc_work = 0;
            select count(*) into ldc_work
            from adc_house_factura1
            where almacen = r_factura1.almacen
            and caja = r_factura1.caja
            and tipo = r_factura1.tipo
            and num_documento = r_factura1.num_documento
            and linea_manejo is null;
            if ldc_work = 0 or ldc_work is null or not found then
                ldc_work = 1;
            end if;
            ldc_work = f_monto_factura(r_factura1.almacen, r_factura1.caja, 
                        r_factura1.tipo, r_factura1.num_documento)/ldc_work;
            return Trim(to_char(ldc_work, ''999999999999.99''));
        end if;
        
        
    elsif trim(as_retornar) = ''SALDO_FACTURA_MANEJO'' then
        select into r_factura1 factura1.*
        from adc_manejo_factura1, factura1, factmotivos
        where adc_manejo_factura1.almacen = factura1.almacen
        and adc_manejo_factura1.caja = factura1.caja
        and adc_manejo_factura1.tipo = factura1.tipo
        and adc_manejo_factura1.num_documento = factura1.num_documento
        and factura1.tipo = factmotivos.tipo
        and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
        and factura1.status <> ''A''
        and adc_manejo_factura1.compania = as_compania
        and adc_manejo_factura1.consecutivo = ai_consecutivo
        and adc_manejo_factura1.linea_master = ai_linea_master
        and adc_manejo_factura1.linea_house = ai_linea_house;
        if found then
            ldc_work    =   f_saldo_documento_cxc(r_factura1.almacen,
                                r_factura1.caja, 
                                r_factura1.cliente,
                                r_factura1.tipo,
                                Trim(to_char(r_factura1.num_documento,''999999999999999'')),
                                current_date);
            return Trim(to_char(ldc_work, ''999999999999.99''));
        end if;
        
    elsif trim(as_retornar) = ''MONTO_FACTURA_MANEJO'' then
        select into r_factura1 factura1.*
        from adc_manejo_factura1, factura1, factmotivos
        where adc_manejo_factura1.almacen = factura1.almacen
        and adc_manejo_factura1.caja = factura1.caja
        and adc_manejo_factura1.tipo = factura1.tipo
        and adc_manejo_factura1.num_documento = factura1.num_documento
        and factura1.tipo = factmotivos.tipo
        and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
        and factura1.status <> ''A''
        and adc_manejo_factura1.compania = as_compania
        and adc_manejo_factura1.consecutivo = ai_consecutivo
        and adc_manejo_factura1.linea_master = ai_linea_master
        and adc_manejo_factura1.linea_house = ai_linea_house;
        if found then
            ldc_work = f_monto_factura(r_factura1.almacen, r_factura1.caja, 
                        r_factura1.tipo, r_factura1.num_documento);
            return Trim(to_char(ldc_work, ''999999999999.99''));
        end if;
        
        
    elsif trim(as_retornar) = ''RECIBO_FACTURA_MANEJO'' then
        select into r_factura1 factura1.*
        from adc_manejo_factura1, factura1, factmotivos
        where adc_manejo_factura1.almacen = factura1.almacen
        and adc_manejo_factura1.caja = factura1.caja
        and adc_manejo_factura1.tipo = factura1.tipo
        and adc_manejo_factura1.num_documento = factura1.num_documento
        and factura1.tipo = factmotivos.tipo
        and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
        and factura1.status <> ''A''
        and adc_manejo_factura1.compania = as_compania
        and adc_manejo_factura1.consecutivo = ai_consecutivo
        and adc_manejo_factura1.linea_master = ai_linea_master
        and adc_manejo_factura1.linea_house = ai_linea_house;
        if found then
            for r_cxcdocm in
                select * from cxcdocm
                where almacen = r_factura1.almacen
                and caja = r_factura1.caja
                and cliente = r_factura1.cliente
                and docmto_aplicar = Trim(to_char(r_factura1.num_documento,''999999999999999''))
                and docmto_ref = Trim(to_char(r_factura1.num_documento,''999999999999999''))
                and motivo_ref = r_factura1.tipo
                and (documento <> docmto_aplicar or motivo_cxc <> motivo_ref)
                order by fecha_posteo desc
            loop
                return trim(r_cxcdocm.documento);            
            end loop;
        end if;
        
    elsif trim(as_retornar) = ''FECHA_RECIBO_FACTURA_MANEJO'' then
        select into r_factura1 factura1.*
        from adc_manejo_factura1, factura1, factmotivos
        where adc_manejo_factura1.almacen = factura1.almacen
        and adc_manejo_factura1.caja = factura1.caja
        and adc_manejo_factura1.tipo = factura1.tipo
        and adc_manejo_factura1.num_documento = factura1.num_documento
        and factura1.tipo = factmotivos.tipo
        and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
        and factura1.status <> ''A''
        and adc_manejo_factura1.compania = as_compania
        and adc_manejo_factura1.consecutivo = ai_consecutivo
        and adc_manejo_factura1.linea_master = ai_linea_master
        and adc_manejo_factura1.linea_house = ai_linea_house;
        if found then
            for r_cxcdocm in
                select * from cxcdocm
                where almacen = r_factura1.almacen
                and caja = r_factura1.caja
                and cliente = r_factura1.cliente
                and docmto_aplicar = Trim(to_char(r_factura1.num_documento,''999999999999999''))
                and docmto_ref = Trim(to_char(r_factura1.num_documento,''999999999999999''))
                and motivo_ref = r_factura1.tipo
                and (documento <> docmto_aplicar or motivo_cxc <> motivo_ref)
                order by fecha_posteo desc
            loop
                return to_char(r_cxcdocm.fecha_posteo, ''yyyy-mm-dd'');
            end loop;
        end if;

    elsif trim(as_retornar) = ''RECIBO_FACTURA_FLETE'' then
        select into r_factura1 factura1.*
        from adc_house_factura1, factura1, factmotivos
        where adc_house_factura1.almacen = factura1.almacen
        and adc_house_factura1.caja = factura1.caja
        and adc_house_factura1.tipo = factura1.tipo
        and adc_house_factura1.num_documento = factura1.num_documento
        and factura1.tipo = factmotivos.tipo
        and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
        and factura1.status <> ''A''
        and adc_house_factura1.compania = as_compania
        and adc_house_factura1.consecutivo = ai_consecutivo
        and adc_house_factura1.linea_master = ai_linea_master
        and adc_house_factura1.linea_house = ai_linea_house;
        if found then
            for r_cxcdocm in
                select * from cxcdocm
                where almacen = r_factura1.almacen
                and caja = r_factura1.caja
                and cliente = r_factura1.cliente
                and docmto_aplicar = Trim(to_char(r_factura1.num_documento,''999999999999999''))
                and docmto_ref = Trim(to_char(r_factura1.num_documento,''999999999999999''))
                and motivo_ref = r_factura1.tipo
                and (documento <> docmto_aplicar or motivo_cxc <> motivo_ref)
                order by fecha_posteo desc
            loop
                return trim(r_cxcdocm.documento);            
            end loop;
        end if;
        
    elsif trim(as_retornar) = ''FECHA_RECIBO_FACTURA_FLETE'' then
        select into r_factura1 factura1.*
        from adc_house_factura1, factura1, factmotivos
        where adc_house_factura1.almacen = factura1.almacen
        and adc_house_factura1.tipo = factura1.tipo
        and adc_house_factura1.caja = factura1.caja
        and adc_house_factura1.num_documento = factura1.num_documento
        and factura1.tipo = factmotivos.tipo
        and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
        and factura1.status <> ''A''
        and adc_house_factura1.compania = as_compania
        and adc_house_factura1.consecutivo = ai_consecutivo
        and adc_house_factura1.linea_master = ai_linea_master
        and adc_house_factura1.linea_house = ai_linea_house;
        if found then
            for r_cxcdocm in
                select * from cxcdocm
                where almacen = r_factura1.almacen
                and caja = r_factura1.caja
                and cliente = r_factura1.cliente
                and docmto_aplicar = Trim(to_char(r_factura1.num_documento,''999999999999999''))
                and docmto_ref = Trim(to_char(r_factura1.num_documento,''999999999999999''))
                and motivo_ref = r_factura1.tipo
                and (documento <> docmto_aplicar or motivo_cxc <> motivo_ref)
                order by fecha_posteo desc
            loop
                return to_char(r_cxcdocm.fecha_posteo, ''yyyy-mm-dd'');            
            end loop;
        end if;
    end if;
    
    return trim(lc_retorno);
end;
' language plpgsql;


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
    ldc_flete_nota_debito decimal;
    ldc_manejo_nota_debito decimal;
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
    
    ldc_flete           =   0;    
    ldc_manejo          =   0;
    ldc_costos_flete    = 0;
    
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
    
    ldc_flete_nota_debito   = 0;
    ldc_manejo_nota_debito  = 0;
    for r_work in select adc_notas_debito_1.almacen, adc_notas_debito_1.tipo,
                    adc_notas_debito_1.num_documento
                  from adc_notas_debito_1
                  where adc_notas_debito_1.compania = as_compania
                    and adc_notas_debito_1.consecutivo = ai_consecutivo
                    and adc_notas_debito_1.cliente = r_adc_house.cliente
                  group by 1, 2, 3
                  order by 1, 2, 3                                      
    loop
        li_lineas = 0;
        select into li_lineas count(*)
        from adc_notas_debito_1
        where almacen = r_work.almacen
        and tipo = r_work.tipo
        and num_documento = r_work.num_documento;
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
        
            
        ldc_flete_nota_debito   =   ldc_flete_nota_debito + (ldc_work/ldc_lineas);
        

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
        
        ldc_manejo_nota_debito  =   ldc_manejo_nota_debito + (ldc_work/ldc_lineas);
        ldc_flete_nota_debito   =   ldc_flete_nota_debito - (ldc_work/ldc_lineas);
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

        ldc_flete       =   ldc_flete + (ldc_master * ldc_porcentaje) + (ldc_flete_nota_debito * ldc_porcentaje);
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
        
        ldc_manejo       =   ldc_manejo + (ldc_master/ldc_count) + (ldc_manejo_nota_debito/ldc_count);
        
        if trim(as_retornar) = ''COSTOS_FLETE'' then
            return (ldc_master/ldc_count);
        else
            return ldc_manejo;
        end if;

    end if;    
end;
' language plpgsql;


create function f_adc_manejo(char(2), int4, int4, int4, char(20)) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ai_linea_house alias for $4;
    as_retornar alias for $5;
    r_work record;
    r_adc_manejo_factura1 record;
    li_count int4;
    li_linea_master int4;
    li_linea_house int4;
    ldc_flete decimal;
    ldc_manejo decimal;
    ldc_work decimal;
    ldc_count decimal;
    ldc_costos_flete decimal;
begin
    ldc_flete   =   0;
    ldc_manejo  =   0;
    ldc_costos_flete    =   0;
    for r_work in select adc_manejo_factura1.almacen, adc_manejo_factura1.tipo,
                    adc_manejo_factura1.num_documento
                  from adc_manejo_factura1
                  where adc_manejo_factura1.compania = as_compania
                    and adc_manejo_factura1.consecutivo = ai_consecutivo
                    and adc_manejo_factura1.linea_master = ai_linea_master
                    and adc_manejo_factura1.linea_house = ai_linea_house
                  group by 1, 2, 3
                  order by 1, 2, 3
    loop
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

        ldc_count    =   0;        
        for r_adc_manejo_factura1 in select * from adc_manejo_factura1
                                        where almacen = r_work.almacen
                                        and tipo = r_work.tipo
                                        and num_documento = r_work.num_documento
                                        order by linea_master, linea_house
        loop
            if ldc_count = 0 then
                ldc_count = 1;
                li_linea_master =   r_adc_manejo_factura1.linea_master;
                li_linea_house  =   r_adc_manejo_factura1.linea_house;
            else
                if li_linea_master = r_adc_manejo_factura1.linea_master
                    and li_linea_house = r_adc_manejo_factura1.linea_house then
                else
                    ldc_count       =   ldc_count + 1;
                    li_linea_master =   r_adc_manejo_factura1.linea_master;
                    li_linea_house  =   r_adc_manejo_factura1.linea_house;
                end if;
            end if;
        end loop;
        
        if ldc_count > 1 then
            ldc_work    =   ldc_work * (1/ldc_count);
        end if;
        
        
        ldc_flete   =   ldc_flete + ldc_work;    
        
        
        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo, cglcuentas
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento
        and (cglposteo.cuenta like ''9%'' or cglposteo.cuenta like ''8%'');
        if ldc_work is null then
            ldc_work = 0;
        end if;


        if ldc_count > 1 then
            ldc_work    =   ldc_work * (1/ldc_count);
        end if;
        
        ldc_costos_flete = ldc_costos_flete + ldc_work;
    
        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo, cglcuentas
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento
        and ((cglposteo.cuenta between ''4600'' and ''4610'') or cglposteo.cuenta like ''8%'');
        if ldc_work is null then
            ldc_work = 0;
        end if;


        if ldc_count > 1 then
            ldc_work    =   ldc_work * (1/ldc_count);
        end if;
        
        
        ldc_manejo  =   ldc_manejo + ldc_work;
        ldc_flete   =   ldc_flete - ldc_work;
    end loop;    

    if trim(as_retornar) = ''MANEJO'' then
        return ldc_manejo;
    elsif trim(as_retornar) = ''COSTOS_FLETE'' then
            return ldc_costos_flete;
    else
        return ldc_flete;
    end if;
end;
' language plpgsql;



create function f_adc_master_house(char(2), int4, int4, char(20)) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    as_retornar alias for $4;
    r_work record;
    ldc_flete decimal;
    ldc_manejo decimal;
    ldc_work decimal;
begin
    ldc_flete   =   0;
    ldc_manejo  =   0;
    for r_work in 
        select adc_house_factura1.almacen, adc_house_factura1.tipo, 
                adc_house_factura1.num_documento
        from adc_house_factura1
        where compania = as_compania
        and consecutivo = ai_consecutivo
        and linea_master = ai_linea_master
        group by 1, 2, 3
    loop
        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo, cglcuentas
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento
        and cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R'';
        if ldc_work is null then
            ldc_work = 0;
        end if;
        ldc_flete   =   ldc_flete + ldc_work;
        
        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento
        and ((cglposteo.cuenta between ''4600'' and ''4610'') or cglposteo.cuenta like ''8%'');
        if ldc_work is null then
            ldc_work = 0;
        end if;
        ldc_manejo  =   ldc_manejo + ldc_work;
        ldc_flete   =   ldc_flete - ldc_work;
    end loop;

    
    for r_work in select adc_manejo_factura1.almacen, adc_manejo_factura1.tipo,
                    adc_manejo_factura1.num_documento
                  from adc_manejo_factura1
                  where adc_manejo_factura1.compania = as_compania
                    and adc_manejo_factura1.consecutivo = ai_consecutivo
                    and adc_manejo_factura1.linea_master = ai_linea_master
                  group by 1, 2, 3
                  order by 1, 2, 3
    loop
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
        ldc_flete   =   ldc_flete + ldc_work;    
    
        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo, cglcuentas
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento
        and ((cglposteo.cuenta between ''4600'' and ''4610'') or cglposteo.cuenta like ''8%'');
        if ldc_work is null then
            ldc_work = 0;
        end if;
        
        ldc_manejo  =   ldc_manejo + ldc_work;
        ldc_flete   =   ldc_flete - ldc_work;
    end loop;    
    

    if trim(as_retornar) = ''MANEJO'' then
        return ldc_manejo;
    else
        return ldc_flete;
    end if;
end;
' language plpgsql;



create function f_adc_master(char(2), int4, int4, char(20)) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    as_retornar alias for $4;
    r_adc_house record;
    ldc_work decimal;
    ldc_flete decimal;
    ldc_manejo decimal;
    ldc_manifiesto_master decimal;
    ldc_master decimal;
    ldc_porcentaje decimal;
    ldc_count decimal;
    ldc_ajustes decimal;
    ldc_costos_flete decimal;
    li_count int4;
begin
    ldc_costos_flete = 0;
    select into r_adc_house * from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        return 0;
    end if;
    
    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglcuentas, cglposteo, rela_adc_master_cglposteo
    where cglcuentas.cuenta = cglposteo.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_master_cglposteo.cgl_consecutivo
    and rela_adc_master_cglposteo.compania = as_compania
    and rela_adc_master_cglposteo.consecutivo = ai_consecutivo
    and rela_adc_master_cglposteo.linea_master = ai_linea_master;
    if ldc_work is null then
        ldc_work = 0;
    end if;
    
    ldc_flete   =   ldc_work;
    
    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglcuentas, cglposteo, rela_adc_master_cglposteo
    where cglcuentas.cuenta = cglposteo.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_master_cglposteo.cgl_consecutivo
    and rela_adc_master_cglposteo.compania = as_compania
    and rela_adc_master_cglposteo.consecutivo = ai_consecutivo
    and rela_adc_master_cglposteo.linea_master = ai_linea_master
    and ((cglposteo.cuenta between ''4600'' and ''4610'') or cglposteo.cuenta like ''8%'');
    if ldc_work is null then
        ldc_work = 0;
    end if;
    ldc_manejo              =   ldc_work;
    ldc_flete               =   ldc_flete - ldc_work;
    
    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglcuentas, cglposteo, rela_adc_master_cglposteo
    where cglcuentas.cuenta = cglposteo.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_master_cglposteo.cgl_consecutivo
    and rela_adc_master_cglposteo.compania = as_compania
    and rela_adc_master_cglposteo.consecutivo = ai_consecutivo
    and rela_adc_master_cglposteo.linea_master = ai_linea_master
    and (cglposteo.cuenta like ''9%'' or cglposteo.cuenta like ''8%'');
    if ldc_work is null then
        ldc_work = 0;
    end if;
    ldc_costos_flete = ldc_costos_flete + ldc_work;    
    
    ldc_ajustes   =   f_adc_ajustes(as_compania, ai_consecutivo, trim(as_retornar));

    
    select into li_count count(*) from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and exists
        (select * from adc_house
        where adc_house.compania = adc_master.compania
        and adc_house.consecutivo = adc_master.consecutivo
        and adc_house.linea_master = adc_master.linea_master);
    if li_count is null or li_count = 0 then
        ldc_count = 1;
    else
        ldc_count = li_count;
    end if;


    if trim(as_retornar) = ''MANEJO'' then
        return ldc_manejo + (ldc_ajustes/ldc_count);
    elsif trim(as_retornar) = ''COSTOS_FLETE'' then
        return ldc_costos_flete + (ldc_ajustes/ldc_count);
    else
        return ldc_flete + (ldc_ajustes/ldc_count);
    end if;

/*    
    if trim(as_retornar) = ''MANEJO'' then
        if ldc_manifiesto_master = 0 or ldc_manejo = 0 then
            select into li_count count(*) from adc_master
            where compania = as_compania
            and consecutivo = ai_consecutivo
            and exists
                (select * from adc_house
                where adc_house.compania = adc_master.compania
                and adc_house.consecutivo = adc_master.consecutivo
                and adc_house.linea_master = adc_master.linea_master);
            if li_count is null or li_count = 0 then
                ldc_porcentaje = 0;
            else
                ldc_count       =   li_count;
                ldc_porcentaje  =   1 / ldc_count;
            end if;
        else
            ldc_porcentaje          =   ldc_manejo / ldc_manifiesto_master;
        end if;
        ldc_work                =   f_adc_ajustes(as_compania, ai_consecutivo, trim(as_retornar))*ldc_porcentaje;
        return ldc_manejo + ldc_work;
    else

        if ldc_manifiesto_master = 0 or ldc_flete = 0 then
            select into li_count count(*) from adc_master
            where compania = as_compania
            and consecutivo = ai_consecutivo;
            if li_count is null or li_count = 0 then
                ldc_porcentaje = 0;
            else
                ldc_count       =   li_count;
                ldc_porcentaje  =   1 / ldc_count;
            end if;
        else
            ldc_porcentaje          =   ldc_flete / ldc_manifiesto_master;
        end if;
        
        select into li_count count(*) from adc_master
        where compania = as_compania
        and consecutivo = ai_consecutivo
        and exists
            (select * from adc_house
            where adc_house.compania = adc_master.compania
            and adc_house.consecutivo = adc_master.consecutivo
            and adc_house.linea_master = adc_master.linea_master);
        if li_count is null or li_count = 0 then
            ldc_porcentaje = 0;
        else
            ldc_count       =   li_count;
            ldc_porcentaje  =   1 / ldc_count;
        end if;
    
        ldc_work                =   f_adc_ajustes(as_compania, ai_consecutivo, trim(as_retornar))*ldc_porcentaje;
        return ldc_flete + ldc_work;
    end if;
*/    
end;
' language plpgsql;


create function f_adc_manifiesto_master(char(2), int4, char(20)) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    as_retornar alias for $3;
    ldc_work decimal;
    ldc_flete decimal;
    ldc_manejo decimal;
begin
    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglcuentas, cglposteo, rela_adc_master_cglposteo
    where cglcuentas.cuenta = cglposteo.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_master_cglposteo.cgl_consecutivo
    and rela_adc_master_cglposteo.compania = as_compania
    and rela_adc_master_cglposteo.consecutivo = ai_consecutivo;
    if ldc_work is null then
        ldc_work = 0;
    end if;
    
    ldc_flete   =   ldc_work;
    
    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglcuentas, cglposteo, rela_adc_master_cglposteo
    where cglcuentas.cuenta = cglposteo.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_master_cglposteo.cgl_consecutivo
    and rela_adc_master_cglposteo.compania = as_compania
    and rela_adc_master_cglposteo.consecutivo = ai_consecutivo
    and ((cglposteo.cuenta between ''4600'' and ''4610'') or cglposteo.cuenta like ''8%'');
    if ldc_work is null then
        ldc_work = 0;
    end if;
    ldc_manejo  =   ldc_work;
    ldc_flete   =   ldc_flete - ldc_work;
    
    if trim(as_retornar) = ''MANEJO'' then
        return ldc_manejo;
    else
        return ldc_flete;
    end if;
end;
' language plpgsql;


create function f_adc_ajustes(char(2), int4, char(20)) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    as_retornar alias for $3;
    ldc_work decimal;
    ldc_flete decimal;
    ldc_manejo decimal;
    ldc_costos_flete decimal;
begin
    ldc_costos_flete = 0;
    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglposteo, rela_adc_cxc_1_cglposteo, cglcuentas
    where cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_cxc_1_cglposteo.cgl_consecutivo
    and rela_adc_cxc_1_cglposteo.compania = as_compania
    and rela_adc_cxc_1_cglposteo.consecutivo = ai_consecutivo;
    if ldc_work is null then
        ldc_work = 0;
    end if;
    ldc_flete   =   ldc_work;

    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglposteo, rela_adc_cxc_1_cglposteo, cglcuentas
    where cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_cxc_1_cglposteo.cgl_consecutivo
    and rela_adc_cxc_1_cglposteo.compania = as_compania
    and rela_adc_cxc_1_cglposteo.consecutivo = ai_consecutivo
    and ((cglposteo.cuenta between ''4600'' and ''4610'') or cglposteo.cuenta like ''8%'');
    if ldc_work is null then
        ldc_work = 0;
    end if;
    ldc_manejo  =   ldc_work;
    ldc_flete   =   ldc_flete - ldc_work;
    

    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglposteo, rela_adc_cxc_1_cglposteo, cglcuentas
    where cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_cxc_1_cglposteo.cgl_consecutivo
    and rela_adc_cxc_1_cglposteo.compania = as_compania
    and rela_adc_cxc_1_cglposteo.consecutivo = ai_consecutivo
    and (cglposteo.cuenta like ''9%'' or cglposteo.cuenta like ''8%'');
    if ldc_work is null then
        ldc_work = 0;
    end if;
    ldc_costos_flete = ldc_costos_flete + ldc_work;
    
    
    
    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglposteo, rela_adc_cxp_1_cglposteo, cglcuentas
    where cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_cxp_1_cglposteo.cgl_consecutivo
    and rela_adc_cxp_1_cglposteo.compania = as_compania
    and rela_adc_cxp_1_cglposteo.consecutivo = ai_consecutivo;
    if ldc_work is null then
        ldc_work = 0;
    end if;
    ldc_flete   =   ldc_flete + ldc_work;

    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglposteo, rela_adc_cxp_1_cglposteo, cglcuentas
    where cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_cxp_1_cglposteo.cgl_consecutivo
    and rela_adc_cxp_1_cglposteo.compania = as_compania
    and rela_adc_cxp_1_cglposteo.consecutivo = ai_consecutivo
    and ((cglposteo.cuenta between ''4600'' and ''4610'') or cglposteo.cuenta like ''8%'');
    if ldc_work is null then
        ldc_work = 0;
    end if;
    ldc_manejo  =   ldc_manejo + ldc_work;
    ldc_flete   =   ldc_flete - ldc_work;
    
    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglposteo, rela_adc_cxp_1_cglposteo, cglcuentas
    where cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_cxp_1_cglposteo.cgl_consecutivo
    and rela_adc_cxp_1_cglposteo.compania = as_compania
    and rela_adc_cxp_1_cglposteo.consecutivo = ai_consecutivo
    and (cglposteo.cuenta like ''9%'' or cglposteo.cuenta like ''8%'');
    if ldc_work is null then
        ldc_work = 0;
    end if;
    ldc_costos_flete = ldc_costos_flete + ldc_work;    
    

    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglcuentas, cglposteo, rela_adc_master_cglposteo
    where cglcuentas.cuenta = cglposteo.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_master_cglposteo.cgl_consecutivo
    and rela_adc_master_cglposteo.compania = as_compania
    and rela_adc_master_cglposteo.consecutivo = ai_consecutivo
    and not exists
        (select * from adc_house
            where adc_house.compania = rela_adc_master_cglposteo.compania
            and adc_house.consecutivo = rela_adc_master_cglposteo.consecutivo
            and adc_house.linea_master = rela_adc_master_cglposteo.linea_master);
    if ldc_work is null then
        ldc_work = 0;
    end if;
    
    ldc_flete   =   ldc_flete + ldc_work;
    
    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglcuentas, cglposteo, rela_adc_master_cglposteo
    where cglcuentas.cuenta = cglposteo.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_master_cglposteo.cgl_consecutivo
    and rela_adc_master_cglposteo.compania = as_compania
    and rela_adc_master_cglposteo.consecutivo = ai_consecutivo
    and ((cglposteo.cuenta between ''4600'' and ''4610'') or cglposteo.cuenta like ''8%'')
    and not exists
        (select * from adc_house
            where adc_house.compania = rela_adc_master_cglposteo.compania
            and adc_house.consecutivo = rela_adc_master_cglposteo.consecutivo
            and adc_house.linea_master = rela_adc_master_cglposteo.linea_master);
    if ldc_work is null then
        ldc_work = 0;
    end if;
    ldc_manejo              =   ldc_manejo + ldc_work;
    ldc_flete               =   ldc_flete - ldc_work;
    
    
    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglcuentas, cglposteo, rela_adc_master_cglposteo
    where cglcuentas.cuenta = cglposteo.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_master_cglposteo.cgl_consecutivo
    and rela_adc_master_cglposteo.compania = as_compania
    and rela_adc_master_cglposteo.consecutivo = ai_consecutivo
    and (cglposteo.cuenta like ''9%'' or cglposteo.cuenta like ''8%'')
    and not exists
        (select * from adc_house
            where adc_house.compania = rela_adc_master_cglposteo.compania
            and adc_house.consecutivo = rela_adc_master_cglposteo.consecutivo
            and adc_house.linea_master = rela_adc_master_cglposteo.linea_master);
    if ldc_work is null then
        ldc_work = 0;
    end if;
    ldc_costos_flete = ldc_costos_flete + ldc_work;    
    
    if trim(as_retornar) = ''MANEJO'' then
        return ldc_manejo;
    elsif trim(as_retornar) = ''COSTOS_FLETE'' then
        return ldc_costos_flete;
    else
        return ldc_flete;
    end if;
end;
' language plpgsql;


create function f_adc_manifiesto(char(2), int4, char(20)) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    as_retornar alias for $3;
    r_work record;
    ldc_retorno decimal;
    ldc_work decimal;
    ldc_manejo decimal;
    ldc_flete decimal;
    ldc_costos decimal;
begin
    ldc_flete   =   0;
    ldc_manejo  =   0;
    ldc_costos  =   0;    
    if trim(as_retornar) = ''COSTOS'' then
        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from cglcuentas, cglposteo, rela_adc_master_cglposteo
        where cglcuentas.cuenta = cglposteo.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and cglposteo.consecutivo = rela_adc_master_cglposteo.cgl_consecutivo
        and rela_adc_master_cglposteo.compania = as_compania
        and rela_adc_master_cglposteo.consecutivo = ai_consecutivo
        and cglcuentas.naturaleza = 1;
        if ldc_work is null then
            ldc_work = 0;
        end if;
        ldc_costos  =   ldc_work;
    
        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from cglposteo, rela_adc_cxc_1_cglposteo, cglcuentas
        where cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and cglposteo.consecutivo = rela_adc_cxc_1_cglposteo.cgl_consecutivo
        and rela_adc_cxc_1_cglposteo.compania = as_compania
        and rela_adc_cxc_1_cglposteo.consecutivo = ai_consecutivo
        and cglcuentas.naturaleza = 1;
        if ldc_work is null then
            ldc_work = 0;
        end if;
        ldc_costos  =   ldc_costos + ldc_work;
    

        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from cglposteo, rela_adc_cxp_1_cglposteo, cglcuentas
        where cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and cglposteo.consecutivo = rela_adc_cxp_1_cglposteo.cgl_consecutivo
        and rela_adc_cxp_1_cglposteo.compania = as_compania
        and rela_adc_cxp_1_cglposteo.consecutivo = ai_consecutivo
        and cglcuentas.naturaleza = 1;
        if ldc_work is null then
            ldc_work = 0;
        end if;
        ldc_costos  =   ldc_costos + ldc_work;
    
        for r_work in select adc_manejo_factura1.almacen, adc_manejo_factura1.tipo,
                        adc_manejo_factura1.num_documento
                      from adc_manejo_factura1
                      where adc_manejo_factura1.compania = as_compania
                        and adc_manejo_factura1.consecutivo = ai_consecutivo
                      group by 1, 2, 3
                      order by 1, 2, 3
        loop
            
            select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
            from rela_factura1_cglposteo, cglposteo, cglcuentas
            where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
            and cglposteo.cuenta = cglcuentas.cuenta
            and cglcuentas.tipo_cuenta = ''R''
            and rela_factura1_cglposteo.almacen = r_work.almacen
            and rela_factura1_cglposteo.tipo = r_work.tipo
            and rela_factura1_cglposteo.num_documento = r_work.num_documento
            and cglcuentas.naturaleza = 1;
            if ldc_work is null then
                ldc_work = 0;
            end if;
            ldc_costos  =   ldc_costos + ldc_work;
        end loop;
    

        for r_work in 
            select adc_house_factura1.almacen, adc_house_factura1.tipo, 
                    adc_house_factura1.num_documento
            from adc_house_factura1
            where compania = as_compania
            and consecutivo = ai_consecutivo
            group by 1, 2, 3
        loop
            select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
            from rela_factura1_cglposteo, cglposteo
            where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
            and rela_factura1_cglposteo.almacen = r_work.almacen
            and rela_factura1_cglposteo.tipo = r_work.tipo
            and rela_factura1_cglposteo.num_documento = r_work.num_documento
            and cglcuentas.naturaleza = 1;
            if ldc_work is null then
                ldc_work = 0;
            end if;
            ldc_costos  =   ldc_costos + ldc_work;
        end loop;
        
        return ldc_costos;
    else
        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from cglcuentas, cglposteo, rela_adc_master_cglposteo
        where cglcuentas.cuenta = cglposteo.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and cglposteo.consecutivo = rela_adc_master_cglposteo.cgl_consecutivo
        and rela_adc_master_cglposteo.compania = as_compania
        and rela_adc_master_cglposteo.consecutivo = ai_consecutivo;
        if ldc_work is null then
            ldc_work = 0;
        end if;
        ldc_flete   =   ldc_work;
    
        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from cglcuentas, cglposteo, rela_adc_master_cglposteo
        where cglcuentas.cuenta = cglposteo.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and cglposteo.consecutivo = rela_adc_master_cglposteo.cgl_consecutivo
        and rela_adc_master_cglposteo.compania = as_compania
        and rela_adc_master_cglposteo.consecutivo = ai_consecutivo
        and ((cglposteo.cuenta between ''4600'' and ''4610'') or cglposteo.cuenta like ''8%'');
        if ldc_work is null then
            ldc_work = 0;
        end if;
        ldc_flete   =   ldc_flete - ldc_work;
        ldc_manejo  =   ldc_manejo + ldc_work;
    
        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from cglposteo, rela_adc_cxc_1_cglposteo, cglcuentas
        where cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and cglposteo.consecutivo = rela_adc_cxc_1_cglposteo.cgl_consecutivo
        and rela_adc_cxc_1_cglposteo.compania = as_compania
        and rela_adc_cxc_1_cglposteo.consecutivo = ai_consecutivo;
        if ldc_work is null then
            ldc_work = 0;
        end if;
        ldc_flete   =   ldc_flete + ldc_work;

        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from cglposteo, rela_adc_cxc_1_cglposteo, cglcuentas
        where cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and cglposteo.consecutivo = rela_adc_cxc_1_cglposteo.cgl_consecutivo
        and rela_adc_cxc_1_cglposteo.compania = as_compania
        and rela_adc_cxc_1_cglposteo.consecutivo = ai_consecutivo
        and ((cglposteo.cuenta between ''4600'' and ''4610'') or cglposteo.cuenta like ''8%'');
        if ldc_work is null then
            ldc_work = 0;
        end if;
        ldc_manejo  =   ldc_manejo + ldc_work;
        ldc_flete   =   ldc_flete - ldc_work;
    
    
        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from cglposteo, rela_adc_cxp_1_cglposteo, cglcuentas
        where cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and cglposteo.consecutivo = rela_adc_cxp_1_cglposteo.cgl_consecutivo
        and rela_adc_cxp_1_cglposteo.compania = as_compania
        and rela_adc_cxp_1_cglposteo.consecutivo = ai_consecutivo;
        if ldc_work is null then
            ldc_work = 0;
        end if;
        ldc_flete   =   ldc_flete + ldc_work;

        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from cglposteo, rela_adc_cxp_1_cglposteo, cglcuentas
        where cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and cglposteo.consecutivo = rela_adc_cxp_1_cglposteo.cgl_consecutivo
        and rela_adc_cxp_1_cglposteo.compania = as_compania
        and rela_adc_cxp_1_cglposteo.consecutivo = ai_consecutivo
        and ((cglposteo.cuenta between ''4600'' and ''4610'') or cglposteo.cuenta like ''8%'');
        if ldc_work is null then
            ldc_work = 0;
        end if;
        ldc_manejo  =   ldc_manejo + ldc_work;
        ldc_flete   =   ldc_flete - ldc_work;
    
    
        for r_work in select adc_manejo_factura1.almacen, adc_manejo_factura1.tipo,
                        adc_manejo_factura1.num_documento
                      from adc_manejo_factura1
                      where adc_manejo_factura1.compania = as_compania
                        and adc_manejo_factura1.consecutivo = ai_consecutivo
                      group by 1, 2, 3
                      order by 1, 2, 3
        loop
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
            ldc_flete   =   ldc_flete + ldc_work;
            
            select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
            from rela_factura1_cglposteo, cglposteo, cglcuentas
            where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
            and cglposteo.cuenta = cglcuentas.cuenta
            and cglcuentas.tipo_cuenta = ''R''
            and rela_factura1_cglposteo.almacen = r_work.almacen
            and rela_factura1_cglposteo.tipo = r_work.tipo
            and rela_factura1_cglposteo.num_documento = r_work.num_documento
            and ((cglposteo.cuenta between ''4600'' and ''4610'') or cglposteo.cuenta like ''8%'');
            if ldc_work is null then
                ldc_work = 0;
            end if;
            ldc_flete   =   ldc_flete - ldc_work;
            ldc_manejo  =   ldc_manejo + ldc_work;        
        end loop;
    

        for r_work in 
            select adc_house_factura1.almacen, adc_house_factura1.tipo, 
                    adc_house_factura1.num_documento
            from adc_house_factura1
            where compania = as_compania
            and consecutivo = ai_consecutivo
            group by 1, 2, 3
        loop
            select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
            from rela_factura1_cglposteo, cglposteo, cglcuentas
            where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
            and rela_factura1_cglposteo.almacen = r_work.almacen
            and rela_factura1_cglposteo.tipo = r_work.tipo
            and rela_factura1_cglposteo.num_documento = r_work.num_documento
            and cglposteo.cuenta = cglcuentas.cuenta
            and cglcuentas.tipo_cuenta = ''R'';
            if ldc_work is null then
                ldc_work = 0;
            end if;
            ldc_flete       =   ldc_flete + ldc_work;
       
            select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
            from rela_factura1_cglposteo, cglposteo
            where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
            and rela_factura1_cglposteo.almacen = r_work.almacen
            and rela_factura1_cglposteo.tipo = r_work.tipo
            and rela_factura1_cglposteo.num_documento = r_work.num_documento
            and ((cglposteo.cuenta between ''4600'' and ''4610'') or cglposteo.cuenta like ''8%'');
            if ldc_work is null then
                ldc_work = 0;
            end if;
            ldc_flete   =   ldc_flete - ldc_work;
            ldc_manejo  =   ldc_manejo + ldc_work;
        end loop;


        for r_work in 
            select adc_notas_debito_1.almacen, adc_notas_debito_1.tipo, 
                    adc_notas_debito_1.num_documento
            from adc_notas_debito_1
            where compania = as_compania
            and consecutivo = ai_consecutivo
            group by 1, 2, 3
        loop
            select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
            from rela_factura1_cglposteo, cglposteo, cglcuentas
            where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
            and rela_factura1_cglposteo.almacen = r_work.almacen
            and rela_factura1_cglposteo.tipo = r_work.tipo
            and rela_factura1_cglposteo.num_documento = r_work.num_documento
            and cglposteo.cuenta = cglcuentas.cuenta
            and cglcuentas.tipo_cuenta = ''R'';
            if ldc_work is null then
                ldc_work = 0;
            end if;
            ldc_flete       =   ldc_flete + ldc_work;
       
            select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
            from rela_factura1_cglposteo, cglposteo
            where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
            and rela_factura1_cglposteo.almacen = r_work.almacen
            and rela_factura1_cglposteo.tipo = r_work.tipo
            and rela_factura1_cglposteo.num_documento = r_work.num_documento
            and ((cglposteo.cuenta between ''4600'' and ''4610'') or cglposteo.cuenta like ''8%'');
            if ldc_work is null then
                ldc_work = 0;
            end if;
            ldc_flete   =   ldc_flete - ldc_work;
            ldc_manejo  =   ldc_manejo + ldc_work;
        end loop;
    
    

        if trim(as_retornar) = ''FLETE'' then
            return ldc_flete;
        else
            return ldc_manejo;
        end if;
    end if;
end;
' language plpgsql;



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

