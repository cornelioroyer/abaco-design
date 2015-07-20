
/*
drop function f_update_cxc_empleados(char(2), char(7)) cascade;
drop function f_ventas_promedio_al(character, character, character, date, character) cascade;
drop function f_add_cacefp() cascade;
drop function f_cambio_precios_pan_rico() cascade;
drop function f_cambio_precios_afrecho() cascade;
drop function f_precios_por_cliente(char(2), date, date) cascade;
drop function f_precio(char(2), char(6), char(15), date) cascade;
drop function f_cambio_de_precios_2010_11_16() cascade;
drop function f_precio_x_tipo_de_harina(char(2), char(6), char(30), date) cascade;
drop function f_cambio_de_precios_2011_02_07() cascade;
drop function f_cltes_bajaron_vtas() cascade;
*/


drop function f_cliente_venta(char(6), date, date) cascade;
drop function f_poner_caja() cascade;

drop function f_cambio_de_codigo_de_cliente() cascade;
drop function f_update_div_socios_05() cascade;

drop function f_get_data_pla(char(2), char(7), varchar(100)) cascade;

drop function f_ultima_vacaciones(char(2), char(7)) cascade;

drop function f_balance_nomacrem(char(2), char(7), char(3), char(30)) cascade;

drop function f_deduccion_mensual(char(2), char(7), char(3), char(30)) cascade;

drop function f_monto_por_concepto(char(2), char(7), char(2), char(2), int4, int4, char(30), char(3), varchar(100)) cascade;

drop function f_precios_panificable() cascade;


create function f_precios_panificable() returns integer as '
declare
    r_precios_por_cliente_1 record;
    r_precios_por_cliente_1_work record;
    r_precios_por_cliente_2 record;
    r_factura1 record;
    li_secuencia int4;
    li_secuencia_old int4;
begin
    delete from precios_por_cliente_1 where fecha_desde = ''2011-02-07'';
    
    li_secuencia = 0;
    for r_precios_por_cliente_1 in select * from precios_por_cliente_1
                    where status = ''A''
                    and fecha_hasta <= ''2011-02-06''
                    and fecha_desde >= ''2010-11-16''
                    order by secuencia
    loop
        select into r_factura1 * from factura1
        where cliente = r_precios_por_cliente_1.cliente
        and fecha_factura >= ''2010-01-01'';
        if not found then 
            continue;
        end if;
        
        li_secuencia_old = r_precios_por_cliente_1.secuencia;
        
        while 1=1 loop
            li_secuencia = li_secuencia + 1;
            select into r_precios_por_cliente_1_work *
            from precios_por_cliente_1
            where secuencia = li_secuencia;
            if not found then
                exit;
            end if;        
        end loop;
        
        
        r_precios_por_cliente_1.secuencia       =   li_secuencia;
        r_precios_por_cliente_1.fecha_desde     =   ''2011-02-07'';
        r_precios_por_cliente_1.fecha_hasta     =   ''2300-01-01'';
        
        select into r_precios_por_cliente_1_work * from precios_por_cliente_1
        where fecha_desde = ''2011-02-07''
        and cliente = r_precios_por_cliente_1.cliente;
        if not found then
            insert into precios_por_cliente_1 (secuencia, cliente,
                cantidad_desde, cantidad_hasta, fecha_desde, fecha_hasta, status, usuario_captura,
                fecha_captura)
            values (r_precios_por_cliente_1.secuencia, r_precios_por_cliente_1.cliente,
                r_precios_por_cliente_1.cantidad_desde, r_precios_por_cliente_1.cantidad_hasta,
                r_precios_por_cliente_1.fecha_desde, r_precios_por_cliente_1.fecha_hasta,
                r_precios_por_cliente_1.status, current_user, current_timestamp);
        else
            continue;
        end if;   
             
        for r_precios_por_cliente_2 in select * from precios_por_cliente_2
                                        where secuencia = li_secuencia_old
        loop
            r_precios_por_cliente_2.secuencia = li_secuencia;
        
            if r_precios_por_cliente_2.articulo = ''11'' or
                r_precios_por_cliente_2.articulo = ''21'' then
                continue;
                
            elsif r_precios_por_cliente_2.articulo = ''26'' then
                r_precios_por_cliente_2.precio = 35;
                
            elsif r_precios_por_cliente_2.articulo = ''27'' then
                    r_precios_por_cliente_2.precio = 17.5;
                    
            elsif r_precios_por_cliente_2.articulo = ''29'' then
                    r_precios_por_cliente_2.precio = 8.75;
                    
            elsif r_precios_por_cliente_2.articulo = ''02'' then
                    r_precios_por_cliente_2.precio = 43;
                    
            elsif r_precios_por_cliente_2.articulo = ''12'' then
                    r_precios_por_cliente_2.precio = 21.5;
                    
            elsif r_precios_por_cliente_2.articulo = ''22'' then
                    r_precios_por_cliente_2.precio = 10.75;
                    
            elsif r_precios_por_cliente_2.articulo = ''22'' then
                    r_precios_por_cliente_2.precio = 10.75;
                    
            elsif r_precios_por_cliente_2.articulo = ''01'' then
                    if r_precios_por_cliente_2.precio <= 42 then
                        insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
                        values (li_secuencia, r_precios_por_cliente_2.articulo,
                            r_precios_por_cliente_2.almacen, 42);

                        insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
                        values (li_secuencia, ''11'',
                            r_precios_por_cliente_2.almacen, 21);
                            
                        insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
                        values (li_secuencia, ''21'',
                            r_precios_por_cliente_2.almacen, 10.50);
                        continue;
                    elsif r_precios_por_cliente_2.precio > 42 and r_precios_por_cliente_2.precio <= 43 then
                        insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
                        values (li_secuencia, r_precios_por_cliente_2.articulo,
                            r_precios_por_cliente_2.almacen, 43);

                        insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
                        values (li_secuencia, ''11'',
                            r_precios_por_cliente_2.almacen, 21.5);
                            
                        insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
                        values (li_secuencia, ''21'',
                            r_precios_por_cliente_2.almacen, 10.75);
                        continue;
                    elsif r_precios_por_cliente_2.precio > 43 then
                        insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
                        values (li_secuencia, r_precios_por_cliente_2.articulo,
                            r_precios_por_cliente_2.almacen, 45);

                        insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
                        values (li_secuencia, ''11'',
                            r_precios_por_cliente_2.almacen, 22.5);
                            
                        insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
                        values (li_secuencia, ''21'',
                            r_precios_por_cliente_2.almacen, 11.25);
                        continue;
                    end if;
                    
            elsif r_precios_por_cliente_2.articulo = ''13'' then
                if r_precios_por_cliente_2.precio <= 21 then
                    r_precios_por_cliente_2.precio = 21;
                elsif r_precios_por_cliente_2.precio > 21 and r_precios_por_cliente_2.precio <= 21.50 then
                    r_precios_por_cliente_2.precio = 21.50;
                elsif r_precios_por_cliente_2.precio > 21.50 and r_precios_por_cliente_2.precio <= 22.50 then
                    r_precios_por_cliente_2.precio = 22.50;
                end if;
            end if;
            r_precios_por_cliente_2.secuencia = li_secuencia;
        
            insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
            values (li_secuencia, r_precios_por_cliente_2.articulo,
                r_precios_por_cliente_2.almacen, r_precios_por_cliente_2.precio);
        
        end loop;
        
    end loop;
    
    delete from precios_por_cliente_1
    where not exists
        (select * from precios_por_cliente_2
            where precios_por_cliente_2.secuencia = precios_por_cliente_1.secuencia);
    return 1; 
end;
' language plpgsql;    


create function f_monto_por_concepto(char(2), char(7), char(2), char(2), int4, int4, char(30), char(3), varchar(100)) returns decimal(10,2) as '
declare
    ac_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ac_tipo_calculo alias for $3;
    ac_tipo_planilla alias for $4;
    ai_year alias for $5;
    ai_numero_planilla alias for $6;
    ac_numero_documento alias for $7;
    ac_cod_concepto_planilla alias for $8;
    avc_retornar alias for $9;
    ldc_retorno decimal(10,2);
    r_nomctrac record;
    r_nomconce record;
begin

    ldc_retorno = 0;

    select into r_nomctrac *
    from nomctrac
    where compania = ac_compania
    and codigo_empleado = ac_codigo_empleado
    and tipo_calculo = ac_tipo_calculo
    and tipo_planilla = ac_tipo_planilla
    and year = ai_year
    and numero_planilla = ai_numero_planilla
    and numero_documento = ac_numero_documento
    and cod_concepto_planilla = ac_cod_concepto_planilla;

    select into r_nomconce *
    from nomconce
    where cod_concepto_planilla = ac_cod_concepto_planilla;
    
    if trim(avc_retornar) = ''NBONIF'' then
        if trim(ac_cod_concepto_planilla) = ''112'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;
        
    elsif trim(avc_retornar) = ''NSALSOB'' then
        if trim(ac_cod_concepto_planilla) = ''101'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;


    elsif trim(avc_retornar) = ''NBONO'' then
        if trim(ac_cod_concepto_planilla) = ''81'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;

    elsif trim(avc_retornar) = ''NOTROING'' then
        if trim(ac_cod_concepto_planilla) = ''140'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;


    elsif trim(avc_retornar) = ''NOTROING2'' then
        if trim(ac_cod_concepto_planilla) = ''142'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;

    elsif trim(avc_retornar) = ''NOTROING3'' then
        if trim(ac_cod_concepto_planilla) = ''250'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;

    elsif trim(avc_retornar) = ''NVAC' then
        if trim(ac_cod_concepto_planilla) = ''108'' 
            or trim(ac_cod_concepto_planilla) = ''121''
            or trim(ac_cod_concepto_planilla) = ''300'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;
        
    elsif trim(avc_retornar) = ''NGRVAC'' then
        if trim(ac_cod_concepto_planilla) = ''107'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;
        
    elsif trim(avc_retornar) = ''NXIII'' then
        if trim(ac_cod_concepto_planilla) = ''240'' or
            trim(ac_cod_concepto_planilla) = ''109'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;
        
    elsif trim(avc_retornar) = ''NGRXIII'' then
        if trim(ac_cod_concepto_planilla) = ''125'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;
        
    elsif trim(avc_retornar) = ''NPRIMA'' then
        if trim(ac_cod_concepto_planilla) = ''220'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;
        
    elsif trim(avc_retornar) = ''NINDEM'' then
        if trim(ac_cod_concepto_planilla) = ''130'' or
            trim(ac_cod_concepto_planilla) = ''135'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;
        
    elsif trim(avc_retornar) = ''NGASTOREP'' then
        if trim(ac_cod_concepto_planilla) = ''200'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;

    elsif trim(avc_retornar) = ''NSS'' then
        if trim(ac_cod_concepto_planilla) = ''103''
            or trim(ac_cod_concepto_planilla) = ''102'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;
        
    elsif trim(avc_retornar) = ''NSE'' then
        if trim(ac_cod_concepto_planilla) = ''104'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;
        
    elsif trim(avc_retornar) = ''NISR'' then
        if trim(ac_cod_concepto_planilla) = ''106'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;
        
    elsif trim(avc_retornar) = ''NISRGTORE'' then
        if trim(ac_cod_concepto_planilla) = ''110'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;

    elsif trim(avc_retornar) = ''NGRATIF'' then
        if trim(ac_cod_concepto_planilla) = ''260'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;

    elsif trim(avc_retornar) = ''NBONIF'' then
        if trim(ac_cod_concepto_planilla) = ''112'' then
            return r_nomctrac.monto * r_nomconce.signo;
        end IF;

    elsif r_nomconce.tipodeconcepto = ''1'' then
            return r_nomctrac.monto * r_nomconce.signo;

    end if;    
    
    return ldc_retorno;
end;
' language plpgsql;    



create function f_deduccion_mensual(char(2), char(7), char(3), char(30)) returns decimal(10,2) as '
declare
    ac_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ac_cod_concepto_planilla alias for $3;
    ac_numero_documento alias for $4;
    ldc_retorno decimal(10,2);
    r_nomacrem record;
    r_pla_afectacion_contable record;
    r_nomdedu record;
begin

    ldc_retorno = 0;

    select into r_nomacrem *
    from nomacrem
    where compania = ac_compania
    and codigo_empleado = ac_codigo_empleado
    and cod_concepto_planilla = ac_cod_concepto_planilla
    and numero_documento = ac_numero_documento;
    if not found then
        return 0;
    end if;

    if r_nomacrem.tipo_descuento = ''P'' then
        select into r_nomdedu *
        from nomdedu
        where compania = ac_compania
        and codigo_empleado = ac_codigo_empleado
        and cod_concepto_planilla = ac_cod_concepto_planilla
        and numero_documento = ac_numero_documento;
        if not found then
            return 0;
        else
            return r_nomdedu.monto;
        end if;
    else
        select into ldc_retorno sum(monto)
        from nomdedu
        where compania = ac_compania
        and codigo_empleado = ac_codigo_empleado
        and cod_concepto_planilla = ac_cod_concepto_planilla
        and numero_documento = ac_numero_documento;
        if ldc_retorno is null then
            ldc_retorno = 0;
        end if;
    end if;    
    return ldc_retorno;
end;
' language plpgsql;    



create function f_balance_nomacrem(char(2), char(7), char(3), char(30)) returns decimal(10,2) as '
declare
    ac_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ac_cod_concepto_planilla alias for $3;
    ac_numero_documento alias for $4;
    ldc_retorno decimal(10,2);
    r_nomacrem record;
    r_pla_afectacion_contable record;
begin

    ldc_retorno = 0;

    select into r_nomacrem *
    from nomacrem
    where compania = ac_compania
    and codigo_empleado = ac_codigo_empleado
    and cod_concepto_planilla = ac_cod_concepto_planilla
    and numero_documento = ac_numero_documento;
    if not found then
        return 0;
    end if;

        
    if r_nomacrem.hacer_cheque = ''S'' then
        select into ldc_retorno sum(nomctrac.monto)
        from nomctrac, nomdescuentos, nomtpla2
        where nomctrac.codigo_empleado = nomdescuentos.codigo_empleado
        and nomctrac.compania = nomdescuentos.compania
        and nomctrac.tipo_calculo = nomdescuentos.tipo_calculo
        and nomctrac.cod_concepto_planilla = nomdescuentos.cod_concepto_planilla
        and nomctrac.tipo_planilla = nomdescuentos.tipo_planilla
        and nomctrac.numero_planilla = nomdescuentos.numero_planilla
        and nomctrac.year = nomdescuentos.year
        and nomctrac.numero_documento = nomdescuentos.numero_documento
        and nomctrac.tipo_planilla = nomtpla2.tipo_planilla
        and nomctrac.numero_planilla = nomtpla2.numero_planilla
        and nomctrac.year = nomtpla2.year
        and nomdescuentos.numero_documento = r_nomacrem.numero_documento
        and nomdescuentos.codigo_empleado = r_nomacrem.codigo_empleado
        and nomdescuentos.cod_concepto_planilla = r_nomacrem.cod_concepto_planilla
        and nomdescuentos.compania = r_nomacrem.compania;
        if ldc_retorno is null then
            ldc_retorno = 0;
        end if;
        
        if r_nomacrem.monto_original_deuda <= 0 then
            return 0;
        else
            return r_nomacrem.monto_original_deuda - ldc_retorno;
        end if;
    
    else
        select into r_pla_afectacion_contable *
        from pla_afectacion_contable
        where cod_concepto_planilla = r_nomacrem.cod_concepto_planilla;

        select into ldc_retorno sum(saldo) 
        from cgl_saldo_aux1
        where compania = ac_compania
        and cuenta = r_pla_afectacion_contable.cuenta
        and auxiliar = ac_codigo_empleado;
        
        if ldc_retorno is null then
            ldc_retorno = 0;
        end if;
        
        return ldc_retorno;
        

        
    end if;
    
    return ldc_retorno;
end;
' language plpgsql;    





create function f_ultima_vacaciones(char(2), char(7)) returns date as '
declare
    ac_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ld_retorno date;
begin

    ld_retorno  =   null;
    
    select into ld_retorno Max(f_corte)
    from pla_vacacion
    where compania = ac_compania
    and trim(codigo_empleado) = trim(ac_codigo_empleado);

    return ld_retorno;
end;
' language plpgsql;    




create function f_get_data_pla(char(2), char(7), varchar(100)) returns decimal(10,2) as '
declare
    ac_compania alias for $1;
    ac_codigo_empleado alias for $2;
    avc_get alias for $3;
    ldc_retorno decimal(10,2);
begin

    ldc_retorno = 0;

    if trim(avc_get) = ''GTOS_REPRE'' then
        select into ldc_retorno sum(monto)
        from pla_otros_ingresos_fijos
        where trim(compania) = trim(ac_compania)
        and trim(codigo_empleado) = trim(ac_codigo_empleado)
        and trim(cod_concepto_planilla) = ''200'';
        if ldc_retorno is null then
            ldc_retorno = 0;
        end if;
    
    end if;


    return ldc_retorno;
end;
' language plpgsql;    




create function f_update_div_socios_05() returns integer as '
declare
    r_div_socios record;
begin
    
    for r_div_socios in select * from div_socios
        where compania = ''03''
        order by socio
    loop
        update div_socios
        set grupo = r_div_socios.grupo,
        nombre1 = r_div_socios.nombre1,
        nombre2 = r_div_socios.nombre2,
        nombre3 = r_div_socios.nombre3,
        nombre4 = r_div_socios.nombre4,
        no_acciones = r_div_socios.no_acciones,
        giro = r_div_socios.giro,
        a_nombre_de = r_div_socios.a_nombre_de,
        apartado = r_div_socios.apartado,
        telefono1 = r_div_socios.telefono1,
        telefono2 = r_div_socios.telefono2,
        usuario = r_div_socios.usuario,
        fecha_captura = current_timestamp,
        tipo_d_persona = r_div_socios.tipo_d_persona,
        ruc = r_div_socios.ruc,
        dv = r_div_socios.dv,
        forma_de_pago = r_div_socios.forma_de_pago,
        ruta = r_div_socios.ruta,
        tipo_de_cuenta = r_div_socios.tipo_de_cuenta,
        cuenta = r_div_socios.cuenta,
        email = r_div_socios.email
        where compania = ''05''
        and socio = r_div_socios.socio;
    end loop;
    
    return 1;   
end;
' language plpgsql;    


create function f_cambio_de_codigo_de_cliente() returns integer as '
declare
    r_tmp_clientes record;
begin
    
    for r_tmp_clientes in select * from tmp_clientes
        where cliente_new like ''8%''
        and trim(cliente_old) <> ''HP-5252''
        and not exists
        (select * from clientes
        where trim(cliente) = trim(tmp_clientes.cliente_new))
        order by cliente_old
    loop
        update clientes
        set cliente = trim(r_tmp_clientes.cliente_new)
        where trim(cliente) = trim(r_tmp_clientes.cliente_old);
    end loop;
    
    return 1;   
end;
' language plpgsql;    



create function f_poner_caja() returns integer as '
declare
    r_factura1 record;
begin
    
    for r_factura1 in select * from factura1
        order by fecha_factura, num_documento
    loop
    
        update factura2
        set caja = r_factura1.caja
        where almacen = r_factura1.almacen
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;

        update factura2_eys2
        set caja = r_factura1.caja
        where almacen = r_factura1.almacen
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;


        update factura3
        set caja = r_factura1.caja
        where almacen = r_factura1.almacen
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;
        
        update adc_facturas_recibos
        set caja = r_factura1.caja
        where fac_almacen = r_factura1.almacen
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;


        update adc_house_factura1
        set caja = r_factura1.caja
        where almacen = r_factura1.almacen
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;

        
        update adc_informe1
        set caja = r_factura1.caja
        where almacen = r_factura1.almacen
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;
        
        update adc_manejo_factura1
        set caja = r_factura1.caja
        where almacen = r_factura1.almacen
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;
        

        update adc_notas_debito_1
        set caja = r_factura1.caja
        where almacen = r_factura1.almacen
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;


        update fac_pagos
        set caja = r_factura1.caja
        where almacen = r_factura1.almacen
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;

        update fact_informe_ventas
        set caja = r_factura1.caja
        where almacen = r_factura1.almacen
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;


        update fact_list_despachos
        set caja = r_factura1.caja
        where almacen = r_factura1.almacen
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;


        update factura4
        set caja = r_factura1.caja
        where almacen = r_factura1.almacen
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;
        
        update factura5
        set caja = r_factura1.caja
        where almacen = r_factura1.almacen
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;
        
        update factura6
        set caja = r_factura1.caja
        where almacen = r_factura1.almacen
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;
        
        update factura7
        set caja = r_factura1.caja
        where almacen = r_factura1.almacen
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;
        
        update factura8
        set caja = r_factura1.caja
        where almacen = r_factura1.almacen
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;
        
        update inv_despachos
        set caja = r_factura1.caja
        where almacen = r_factura1.almacen
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;


        update rela_factura1_cglposteo
        set caja = r_factura1.caja
        where almacen = r_factura1.almacen
        and tipo = r_factura1.tipo
        and num_documento = r_factura1.num_documento;


        update tal_ot1
        set caja = r_factura1.caja
        where almacen = r_factura1.almacen
        and tipo = r_factura1.tipo
        and numero_factura = r_factura1.num_documento;

-- raise exception ''entre'';
        
    end loop;
    
    return 1;   
end;
' language plpgsql;    



create function f_cliente_venta(char(6), date, date) returns char(1) as '
declare
    ac_cliente alias for $1;
    ad_desde alias for $2;
    ad_hasta alias for $3;
    r_factura1 record;
    lc_retorno char(1);
begin
    lc_retorno  =   ''N'';
    
    for r_factura1 in select * from factura1, factmotivos 
        where factura1.tipo = factmotivos.tipo
        and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
        and factura1.cliente = ac_cliente
        and factura1.fecha_factura between ad_desde and ad_hasta
    loop
        return ''S'';    
    end loop;
   
    return ''N''; 
end;
' language plpgsql;    


/*
create function f_cltes_bajaron_vtas() returns integer as '
declare
    r_clientes record;
    ldc_quintales decimal;
    ldc_dolares decimal;
    ldc_quintales_2011 decimal;
    ldc_dolares_2011 decimal;
    ldc_quintales_dif decimal;
    ldc_dolares_dif decimal;
begin

    drop table tmp_cltes_bajaron_ventas;
    
    create table tmp_cltes_bajaron_ventas as
            select nomb_cliente, cliente, limite_credito as quintales, limite_credito as dolares,
                limite_credito as quintales_2011, limite_credito as dolares_2011,
                limite_credito as quintales_dif, limite_credito as dolares_dif
            from clientes
            where 1=0; 
    
    for r_clientes in select * from clientes order by nomb_cliente
    loop
    
    
        ldc_quintales       =   0;
        ldc_dolares         =   0;
        ldc_quintales_2011  =   0;
        ldc_dolares_2011    =   0;
        
        select into ldc_quintales sum(quintales)
        from v_ventas_x_cliente_harinas
        where anio <= 2010
        and cliente = r_clientes.cliente;

        select into ldc_dolares sum(dolares)
        from v_ventas_x_cliente_harinas
        where anio <= 2010
        and cliente = r_clientes.cliente;

        select into ldc_quintales_2011 sum(quintales)
        from v_ventas_x_cliente_harinas
        where anio between 2011 and 2012
        and cliente = r_clientes.cliente;

        select into ldc_dolares_2011 sum(dolares)
        from v_ventas_x_cliente_harinas
        where anio between 2011 and 2012
        and cliente = r_clientes.cliente;
        
        ldc_quintales_dif   =   ldc_quintales_2011 - ldc_quintales;
        ldc_dolares_dif     =   ldc_dolares_2011 - ldc_dolares;
        
        insert into cltes_bajaron_ventas values(r_clientes.nomb_cliente,
            r_clientes.cliente, ldc_quintales, ldc_dolares, 
            ldc_quintales_2011, ldc_dolares_2011, ldc_quintales_dif, ldc_dolares_dif);
            
        
        
    end loop;
   
    return 1; 
end;
' language plpgsql;    


create function f_defuncion(char(1)) returns integer as '
declare
    as_status alias for $1;
    r_rhuempl record;
begin
    update nomacrem
    set status = as_status
    where cod_acreedores = ''DEFUNCION''
    
    if as_status <> ''A'' then
        return 1;
    end if;
    
    for r_rhuempl in select * from rhuempl
                        where not exists
                            (select * nomacrem
                                where compania = rhuempl.compania
                                and codigo_empleado = rhuempl.codigo_empleado
                                and cod_acreedores = ''DEFUNCION'')
                    order by codigo_empleado
    loop
        insert into nomacrem(compania, codigo_empleado, cod_concepto_planilla, numero_documento,
            cod_acreedores, descripcion_descuento, monto_original_deuda, letras_a_pagar,
            fecha_ini_descto, fecha_final_descto, status, observacion, hacer_cheque, incluir_deduc_
    end loop;
   
    return 1; 
end;
' language plpgsql;    


create function f_cambio_de_precios_2011_02_07() returns integer as '
declare
    r_precios_por_cliente_1 record;
    r_precios_por_cliente_1_work record;
    r_precios_por_cliente_2 record;
    r_factura1 record;
    li_secuencia int4;
    li_secuencia_old int4;
begin
    delete from precios_por_cliente_1 where fecha_desde = ''2011-02-07'';
    
    li_secuencia = 0;
    for r_precios_por_cliente_1 in select * from precios_por_cliente_1
                    where status = ''A''
                    and fecha_hasta <= ''2011-02-06''
                    and fecha_desde >= ''2010-11-16''
                    order by secuencia
    loop
        select into r_factura1 * from factura1
        where cliente = r_precios_por_cliente_1.cliente
        and fecha_factura >= ''2010-01-01'';
        if not found then 
            continue;
        end if;
        
        li_secuencia_old = r_precios_por_cliente_1.secuencia;
        
        while 1=1 loop
            li_secuencia = li_secuencia + 1;
            select into r_precios_por_cliente_1_work *
            from precios_por_cliente_1
            where secuencia = li_secuencia;
            if not found then
                exit;
            end if;        
        end loop;
        
        
        r_precios_por_cliente_1.secuencia       =   li_secuencia;
        r_precios_por_cliente_1.fecha_desde     =   ''2011-02-07'';
        r_precios_por_cliente_1.fecha_hasta     =   ''2300-01-01'';
        
        select into r_precios_por_cliente_1_work * from precios_por_cliente_1
        where fecha_desde = ''2011-02-07''
        and cliente = r_precios_por_cliente_1.cliente;
        if not found then
            insert into precios_por_cliente_1 (secuencia, cliente,
                cantidad_desde, cantidad_hasta, fecha_desde, fecha_hasta, status, usuario_captura,
                fecha_captura)
            values (r_precios_por_cliente_1.secuencia, r_precios_por_cliente_1.cliente,
                r_precios_por_cliente_1.cantidad_desde, r_precios_por_cliente_1.cantidad_hasta,
                r_precios_por_cliente_1.fecha_desde, r_precios_por_cliente_1.fecha_hasta,
                r_precios_por_cliente_1.status, current_user, current_timestamp);
        else
            continue;
        end if;   
             
        for r_precios_por_cliente_2 in select * from precios_por_cliente_2
                                        where secuencia = li_secuencia_old
        loop
            r_precios_por_cliente_2.secuencia = li_secuencia;
        
            if r_precios_por_cliente_2.articulo = ''11'' or
                r_precios_por_cliente_2.articulo = ''21'' then
                continue;
                
            elsif r_precios_por_cliente_2.articulo = ''26'' then
                r_precios_por_cliente_2.precio = 35;
                
            elsif r_precios_por_cliente_2.articulo = ''27'' then
                    r_precios_por_cliente_2.precio = 17.5;
                    
            elsif r_precios_por_cliente_2.articulo = ''29'' then
                    r_precios_por_cliente_2.precio = 8.75;
                    
            elsif r_precios_por_cliente_2.articulo = ''02'' then
                    r_precios_por_cliente_2.precio = 43;
                    
            elsif r_precios_por_cliente_2.articulo = ''12'' then
                    r_precios_por_cliente_2.precio = 21.5;
                    
            elsif r_precios_por_cliente_2.articulo = ''22'' then
                    r_precios_por_cliente_2.precio = 10.75;
                    
            elsif r_precios_por_cliente_2.articulo = ''22'' then
                    r_precios_por_cliente_2.precio = 10.75;
                    
            elsif r_precios_por_cliente_2.articulo = ''01'' then
                    if r_precios_por_cliente_2.precio <= 42 then
                        insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
                        values (li_secuencia, r_precios_por_cliente_2.articulo,
                            r_precios_por_cliente_2.almacen, 42);

                        insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
                        values (li_secuencia, ''11'',
                            r_precios_por_cliente_2.almacen, 21);
                            
                        insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
                        values (li_secuencia, ''21'',
                            r_precios_por_cliente_2.almacen, 10.50);
                        continue;
                    elsif r_precios_por_cliente_2.precio > 42 and r_precios_por_cliente_2.precio <= 43 then
                        insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
                        values (li_secuencia, r_precios_por_cliente_2.articulo,
                            r_precios_por_cliente_2.almacen, 43);

                        insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
                        values (li_secuencia, ''11'',
                            r_precios_por_cliente_2.almacen, 21.5);
                            
                        insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
                        values (li_secuencia, ''21'',
                            r_precios_por_cliente_2.almacen, 10.75);
                        continue;
                    elsif r_precios_por_cliente_2.precio > 43 then
                        insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
                        values (li_secuencia, r_precios_por_cliente_2.articulo,
                            r_precios_por_cliente_2.almacen, 45);

                        insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
                        values (li_secuencia, ''11'',
                            r_precios_por_cliente_2.almacen, 22.5);
                            
                        insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
                        values (li_secuencia, ''21'',
                            r_precios_por_cliente_2.almacen, 11.25);
                        continue;
                    end if;
                    
            elsif r_precios_por_cliente_2.articulo = ''13'' then
                if r_precios_por_cliente_2.precio <= 21 then
                    r_precios_por_cliente_2.precio = 21;
                elsif r_precios_por_cliente_2.precio > 21 and r_precios_por_cliente_2.precio <= 21.50 then
                    r_precios_por_cliente_2.precio = 21.50;
                elsif r_precios_por_cliente_2.precio > 21.50 and r_precios_por_cliente_2.precio <= 22.50 then
                    r_precios_por_cliente_2.precio = 22.50;
                end if;
            end if;
            r_precios_por_cliente_2.secuencia = li_secuencia;
        
            insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
            values (li_secuencia, r_precios_por_cliente_2.articulo,
                r_precios_por_cliente_2.almacen, r_precios_por_cliente_2.precio);
        
        end loop;
        
    end loop;
    
    delete from precios_por_cliente_1
    where not exists
        (select * from precios_por_cliente_2
            where precios_por_cliente_2.secuencia = precios_por_cliente_1.secuencia);
    return 1; 
end;
' language plpgsql;    




create function f_precio_x_tipo_de_harina(char(2), char(6), char(30), date) returns decimal as '
declare
    as_cia alias for $1;
    as_cliente alias for $2;
    as_tipo_de_harina alias for $3;
    ad_fecha alias for $4;
    r_work record;
    r_precios_por_cliente_2 record;
    r_articulos_por_almacen record;
    lb_sw boolean;
    ldc_precio decimal;
    as_articulo char(15);
begin
    if Trim(as_tipo_de_harina) = ''HRW'' then
        as_articulo = ''26'';
    elsif Trim(as_tipo_de_harina) = ''HARINA SUAVE'' then
        as_articulo = ''02'';
    else
        as_articulo = ''01'';
    end if;
    
    lb_sw = false;
    ldc_precio = 0;
    for r_precios_por_cliente_2 in select precios_por_cliente_2.* from precios_por_cliente_1, precios_por_cliente_2, almacen
        where precios_por_cliente_1.secuencia = precios_por_cliente_2.secuencia
        and precios_por_cliente_2.almacen = almacen.almacen
        and almacen.compania = as_cia
        and precios_por_cliente_2.articulo = trim(as_articulo)
        and precios_por_cliente_1.status = ''A''
        and ad_fecha between precios_por_cliente_1.fecha_desde and precios_por_cliente_1.fecha_hasta
        and precios_por_cliente_2.precio > 0
        and precios_por_cliente_1.cliente = trim(as_cliente)
        order by precios_por_cliente_2.almacen
    loop
        if ldc_precio < r_precios_por_cliente_2.precio then
            ldc_precio = r_precios_por_cliente_2.precio;
        end if;
    end loop;
    
    if ldc_precio > 0 then
        return ldc_precio;
    end if;
    for r_articulos_por_almacen in select articulos_por_almacen.* from articulos_por_almacen, almacen
                                        where articulos_por_almacen.almacen = almacen.almacen
                                        and articulos_por_almacen.articulo = trim(as_articulo)
                                        and almacen.compania = as_cia
                                        order by articulos_por_almacen.almacen
    loop
        return r_articulos_por_almacen.precio_venta;
    end loop;    
    return 0;
end;
' language plpgsql;    




create function f_cambio_de_precios_2010_11_16() returns integer as '
declare
    r_precios_por_cliente_1 record;
    r_precios_por_cliente_1_work record;
    r_precios_por_cliente_2 record;
    li_secuencia int4;
    li_secuencia_old int4;
begin
    li_secuencia = 0;
    for r_precios_por_cliente_1 in select * from precios_por_cliente_1
                    where status = ''A''
                    and fecha_hasta >= ''2010-11-16''
                    order by secuencia
    loop
        li_secuencia_old = r_precios_por_cliente_1.secuencia;
        
        while 1=1 loop
            li_secuencia = li_secuencia + 1;
            select into r_precios_por_cliente_1_work *
            from precios_por_cliente_1
            where secuencia = li_secuencia;
            if not found then
                exit;
            end if;        
        end loop;
        
        r_precios_por_cliente_1.secuencia       =   li_secuencia;
        r_precios_por_cliente_1.fecha_desde     =   ''2010-11-16'';
        r_precios_por_cliente_1.fecha_hasta     =   ''2300-01-01'';
        
        insert into precios_por_cliente_1 (secuencia, cliente,
            cantidad_desde, cantidad_hasta, fecha_desde, fecha_hasta, status, usuario_captura,
            fecha_captura)
        values (r_precios_por_cliente_1.secuencia, r_precios_por_cliente_1.cliente,
            r_precios_por_cliente_1.cantidad_desde, r_precios_por_cliente_1.cantidad_hasta,
            r_precios_por_cliente_1.fecha_desde, r_precios_por_cliente_1.fecha_hasta,
            r_precios_por_cliente_1.status, current_user, current_timestamp);
        
        for r_precios_por_cliente_2 in select * from precios_por_cliente_2
                                        where secuencia = li_secuencia_old
        loop
            if r_precios_por_cliente_2.articulo <> ''26''
                and r_precios_por_cliente_2.articulo <> ''27'' then
                if r_precios_por_cliente_2.articulo = ''02''
                    and r_precios_por_cliente_2.precio < 38 then
                    r_precios_por_cliente_2.precio = 38;
                end if;
            
                if r_precios_por_cliente_2.articulo = ''12''
                    and r_precios_por_cliente_2.precio < 19 then
                    r_precios_por_cliente_2.precio = 19;
                end if;
            
                if r_precios_por_cliente_2.articulo = ''22''
                    and r_precios_por_cliente_2.precio < 9.5 then
                    r_precios_por_cliente_2.precio = 9.5;
                end if;
                        
                r_precios_por_cliente_2.secuencia = li_secuencia;
            
                insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
                values (r_precios_por_cliente_2.secuencia, r_precios_por_cliente_2.articulo,
                    r_precios_por_cliente_2.almacen, r_precios_por_cliente_2.precio);
                

            end if;
            
        end loop;
        
        update precios_por_cliente_1
        set fecha_hasta = ''2010-11-15''
        where secuencia = li_secuencia_old;
    
    end loop;
    return 1; 
end;
' language plpgsql;    




create function f_precio(char(2), char(6), char(15), date) returns decimal as '
declare
    as_cia alias for $1;
    as_cliente alias for $2;
    as_articulo alias for $3;
    ad_fecha alias for $4;
    r_work record;
    r_precios_por_cliente_2 record;
    r_articulos_por_almacen record;
    lb_sw boolean;
    ldc_precio decimal;
begin
    lb_sw = false;
    ldc_precio = 0;
    for r_precios_por_cliente_2 in select precios_por_cliente_2.* from precios_por_cliente_1, precios_por_cliente_2, almacen
        where precios_por_cliente_1.secuencia = precios_por_cliente_2.secuencia
        and precios_por_cliente_2.almacen = almacen.almacen
        and almacen.compania = as_cia
        and precios_por_cliente_2.articulo = trim(as_articulo)
        and precios_por_cliente_1.status = ''A''
        and ad_fecha between precios_por_cliente_1.fecha_desde and precios_por_cliente_1.fecha_hasta
        and precios_por_cliente_2.precio > 0
        and precios_por_cliente_1.cliente = trim(as_cliente)
        order by precios_por_cliente_2.almacen
    loop
        if ldc_precio < r_precios_por_cliente_2.precio then
            ldc_precio = r_precios_por_cliente_2.precio;
        end if;
    end loop;
    
    if ldc_precio > 0 then
        return ldc_precio;
    end if;
    for r_articulos_por_almacen in select articulos_por_almacen.* from articulos_por_almacen, almacen
                                        where articulos_por_almacen.almacen = almacen.almacen
                                        and articulos_por_almacen.articulo = trim(as_articulo)
                                        and almacen.compania = as_cia
                                        order by articulos_por_almacen.almacen
    loop
        return r_articulos_por_almacen.precio_venta;
    end loop;    
    return 0;
end;
' language plpgsql;    


create function f_precios_por_cliente(char(2), date, date) returns integer as '
declare
    as_cia alias for $1;
    ad_desde alias for $2;
    ad_hasta alias for $3;
    r_work record;
    r_articulos record;
begin
    for r_work in select factura1.cliente from factura1
        where almacen in (select almacen from almacen where compania = as_cia)
        and factura1.fecha_factura between ad_desde and ad_hasta
        group by 1
        order by 1
    loop
        for r_articulos in select * from articulos 
                            where articulo in (''01'', ''02'', ''03'', ''04'', ''05'', ''06'', ''07'', ''08'', ''09'', ''10'',
                                ''11'', ''12'', ''13'', ''16'', ''17'', ''18'', ''21'', ''22'', ''23'', ''26'', ''27'', ''29'')
                                order by articulo
        loop
            insert into fac_precios_por_cliente(usuario, compania, cliente, articulo, precio)
            values (current_user, as_cia, r_work.cliente, r_articulos.articulo, 
            f_precio(as_cia, r_work.cliente, r_articulos.articulo, ad_hasta)); 
        end loop;
    end loop;
    return 1;
end;
' language plpgsql;    


create function f_cambio_precios_afrecho() returns integer as '
declare
    r_precios_por_cliente_1 record;
    r_precios_por_cliente_1_work record;
    r_precios_por_cliente_2 record;
    li_secuencia int4;
    li_secuencia_old int4;
begin
    li_secuencia = 0;
    for r_precios_por_cliente_1 in select * from precios_por_cliente_1
                    where status = ''A''
                    and current_date between fecha_desde and fecha_hasta
                    and exists
                        (select * from precios_por_cliente_2
                        where precios_por_cliente_2.secuencia = precios_por_cliente_1.secuencia
                        and precios_por_cliente_2.articulo in (''06'',''07''))
                    order by secuencia
    loop
        li_secuencia_old = r_precios_por_cliente_1.secuencia;
        
        while 1=1 loop
            li_secuencia = li_secuencia + 1;
            select into r_precios_por_cliente_1_work *
            from precios_por_cliente_1
            where secuencia = li_secuencia;
            if not found then
                exit;
            end if;        
        end loop;
        
        r_precios_por_cliente_1.secuencia       =   li_secuencia;
        r_precios_por_cliente_1.fecha_desde     =   ''2010-02-15'';
        r_precios_por_cliente_1.fecha_hasta     =   ''2300-01-01'';
        
        insert into precios_por_cliente_1 (secuencia, cliente,
            cantidad_desde, cantidad_hasta, fecha_desde, fecha_hasta, status, usuario_captura,
            fecha_captura)
        values (r_precios_por_cliente_1.secuencia, r_precios_por_cliente_1.cliente,
            r_precios_por_cliente_1.cantidad_desde, r_precios_por_cliente_1.cantidad_hasta,
            r_precios_por_cliente_1.fecha_desde, r_precios_por_cliente_1.fecha_hasta,
            r_precios_por_cliente_1.status, current_user, current_timestamp);
        
        for r_precios_por_cliente_2 in select * from precios_por_cliente_2
                                        where secuencia = li_secuencia_old
        loop
            if r_precios_por_cliente_2.articulo = ''06'' then
                r_precios_por_cliente_2.precio = 7;
            end if;
            
            if r_precios_por_cliente_2.articulo = ''07'' then
                r_precios_por_cliente_2.precio = 7;
            end if;
            
            r_precios_por_cliente_2.secuencia = li_secuencia;
            
            insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
            values (r_precios_por_cliente_2.secuencia, r_precios_por_cliente_2.articulo,
                r_precios_por_cliente_2.almacen, r_precios_por_cliente_2.precio);
        end loop;

        update precios_por_cliente_1
        set fecha_hasta = ''2010-02-14'', status = ''I''
        where secuencia = li_secuencia_old;
        
    end loop;       
    return 1; 
end;
' language plpgsql;    



create function f_cambio_precios_pan_rico() returns integer as '
declare
    r_precios_por_cliente_1 record;
    r_precios_por_cliente_1_work record;
    r_precios_por_cliente_2 record;
    li_secuencia int4;
    li_secuencia_old int4;
begin
    li_secuencia = 0;
    for r_precios_por_cliente_1 in select * from precios_por_cliente_1
                    where status = ''A''
                    and current_date between fecha_desde and fecha_hasta
                    and exists
                        (select * from precios_por_cliente_2
                        where precios_por_cliente_2.secuencia = precios_por_cliente_1.secuencia
                        and precios_por_cliente_2.articulo in (''26'',''27''))
                    order by secuencia
    loop
        li_secuencia_old = r_precios_por_cliente_1.secuencia;
        
        while 1=1 loop
            li_secuencia = li_secuencia + 1;
            select into r_precios_por_cliente_1_work *
            from precios_por_cliente_1
            where secuencia = li_secuencia;
            if not found then
                exit;
            end if;        
        end loop;
        
        r_precios_por_cliente_1.secuencia       =   li_secuencia;
        r_precios_por_cliente_1.fecha_desde     =   ''2010-02-01'';
        r_precios_por_cliente_1.fecha_hasta     =   ''2300-01-01'';
        
        insert into precios_por_cliente_1 (secuencia, cliente,
            cantidad_desde, cantidad_hasta, fecha_desde, fecha_hasta, status, usuario_captura,
            fecha_captura)
        values (r_precios_por_cliente_1.secuencia, r_precios_por_cliente_1.cliente,
            r_precios_por_cliente_1.cantidad_desde, r_precios_por_cliente_1.cantidad_hasta,
            r_precios_por_cliente_1.fecha_desde, r_precios_por_cliente_1.fecha_hasta,
            r_precios_por_cliente_1.status, current_user, current_timestamp);
        
        for r_precios_por_cliente_2 in select * from precios_por_cliente_2
                                        where secuencia = li_secuencia_old
        loop
            if r_precios_por_cliente_2.articulo = ''26'' then
                r_precios_por_cliente_2.precio = 28;
            end if;
            
            if r_precios_por_cliente_2.articulo = ''27'' then
                r_precios_por_cliente_2.precio = 14;
            end if;
            
            r_precios_por_cliente_2.secuencia = li_secuencia;
            
            insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
            values (r_precios_por_cliente_2.secuencia, r_precios_por_cliente_2.articulo,
                r_precios_por_cliente_2.almacen, r_precios_por_cliente_2.precio);
        end loop;

        update precios_por_cliente_1
        set fecha_hasta = ''2010-01-31'', status = ''I''
        where secuencia = li_secuencia_old;
        
    end loop;       
    return 1; 
end;
' language plpgsql;    



create function f_add_cacefp() returns integer as '
declare
    r_nomacrem record;
    r_nomacrem_work record;
    r_nomdedu record;
    r_nomdedu_work record;
begin
    for r_nomacrem in select * from nomacrem
                    where cod_acreedores = ''CACEFP''
                    and status = ''A''
                    order by codigo_empleado
    loop
        select into r_nomacrem_work * from nomacrem
        where compania = r_nomacrem.compania
        and codigo_empleado = r_nomacrem.codigo_empleado
        and cod_concepto_planilla = r_nomacrem.cod_concepto_planilla
        and trim(numero_documento) = ''2010'';
        if not found then
            insert into nomacrem (compania, codigo_empleado, cod_concepto_planilla,
                numero_documento, cod_acreedores, descripcion_descuento,
                monto_original_deuda, letras_a_pagar, fecha_inidescto,
                fecha_finaldescto, status, observacion, hacer_cheque,
                incluir_deduc_carta_trabajo, deduccion_aplica_diciembre,
                usuario, fecha_captura, tipo_descuento)
            values (r_nomacrem.compania, r_nomacrem.codigo_empleado, r_nomacrem.cod_concepto_planilla,
                ''2010'', r_nomacrem.cod_acreedores, r_nomacrem.descripcion_descuento,
                r_nomacrem.monto_original_deuda, r_nomacrem.letras_a_pagar,
                r_nomacrem.fecha_inidescto, r_nomacrem.fecha_finaldescto, r_nomacrem.status,
                r_nomacrem.observacion, r_nomacrem.hacer_cheque, r_nomacrem.incluir_deduc_carta_trabajo,
                r_nomacrem.deduccion_aplica_diciembre, r_nomacrem.usuario, r_nomacrem.fecha_captura,
                r_nomacrem.tipo_descuento);
        end if;
        
        
        for r_nomdedu in select * from nomdedu
                        where compania = r_nomacrem.compania
                        and codigo_empleado = r_nomacrem.codigo_empleado
                        and cod_concepto_planilla = r_nomacrem.cod_concepto_planilla
                        and trim(numero_documento) = trim(r_nomacrem.numero_documento)
        loop
            select into r_nomdedu_work * from nomdedu
            where compania = r_nomacrem.compania
            and codigo_empleado = r_nomacrem.codigo_empleado
            and cod_concepto_planilla = r_nomacrem.cod_concepto_planilla
            and trim(numero_documento) = ''2010''
            and periodo = r_nomdedu.periodo;
            if not found then
                insert into nomdedu (compania, codigo_empleado, numero_documento,
                    cod_concepto_planilla, periodo, monto)
                values(r_nomacrem.compania, r_nomacrem.codigo_empleado,
                    ''2010'', r_nomacrem.cod_concepto_planilla,
                    r_nomdedu.periodo, r_nomdedu.monto);
            end if;
        end loop;
    end loop;
    return 1; 
end;
' language plpgsql;    


create function f_ventas_promedio_al(character, character, character, date, character) returns decimal as '
declare
    as_nombre alias for $1;
    as_descripcion alias for $2;
    as_cliente alias for $3;
    ad_fecha alias for $4;
    as_retornar alias for $5;
    li_meses integer;
    ldc_retornar decimal;
begin
    li_meses = Mes(ad_fecha) - 1;
    if li_meses = 0 then
        li_meses = 12;
    end if;
    
    
    ldc_retornar = 0;
    
    if as_retornar = ''QUINTALES'' then
        select sum(quintales) into ldc_retornar
        from v_ventas_x_cliente_harinas
        where anio = Anio(ad_fecha)
        and cliente = as_cliente
        and trim(descripcion) = trim(as_descripcion)
        and fecha_factura < ad_fecha;
    else
        select sum(venta) into ldc_retornar
        from v_ventas_x_cliente_harinas
        where anio = Anio(ad_fecha)
        and cliente = as_cliente
        and trim(descripcion) = trim(as_descripcion)
        and fecha_factura < ad_fecha;
    end if;
    
    if ldc_retornar is null then
        return 0;
    end if;

    return ldc_retornar / li_meses;
        
end;
' language plpgsql;    

create function f_update_cxc_empleados(char(2), char(7)) returns integer as '
declare
    as_cia alias for $1;
    as_codigo_empleado alias for $2;
    r_rhuempl record;
    r_cglauxiliares record;
    r_nomacrem record;
    li_periodos integer;
    i integer;
begin
    select into r_rhuempl * from rhuempl
    where compania = as_cia
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    if r_rhuempl.status = ''A'' or r_rhuempl.status = ''V'' then
        select into r_cglauxiliares * from cglauxiliares
        where trim(auxiliar) = trim(as_codigo_empleado);
        if not found then
            insert into cglauxiliares(auxiliar, nombre, tipo_persona, status, id, dv)
            values(r_rhuempl.codigo_empleado, r_rhuempl.nombre_empleado, ''N'', ''A'',
                        r_rhuempl.numero_cedula, r_rhumempl.dv);
        end if;
        
        select into r_nomacrem * from nomacrem
        where compania = r_rhuempl.compania
        and codigo_empleado = r_rhuempl.codigo_empleado
        and cod_acreedores = ''HP-127'';
        if not found then
            insert into nomacrem(compania, codigo_empleado, cod_concepto_planilla, numero_documento,
                                    cod_acreedores,monto_original_deuda,letras_a_pagar, fecha_inidescto,
                                    status,hacer_cheque,incluir_deduc_carta_trabajo,
                                    deduccion_aplica_diciembre,usuario,fecha_captura,tipo_descuento)
            values (r_rhuempl.compania, r_rhuempl.codigo_empleado, ''170'', Anio(current_date),
                        ''HP-127'', 1, 0, r_rhuempl.fecha_inicio, ''A'',''N'',''S'',''S'',
                        current_user, current_timestamp, ''P'');
                        

            if r_rhuempl.tipo_planilla = ''1'' then
                li_periodos = 5;
            else
                li_periodos = 2;
            end if;
            
            for i in 1..li_periodos loop
                insert into nomdedu(compania, codigo_empleado, numero_documento, cod_concepto_planilla,
                                    periodo, monto)
                values(r_rhuempl.compania, r_rhuempl.codigo_empleado, Anio(current_date),''170'',
                            i, 7);                    
            end loop;
        else
            return 0;
        end if;
    else
        return 0;
    end if;    
    
    return 1;
    
end;
' language plpgsql;    

*/
