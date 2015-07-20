
rollback work;
drop function f_factura_cxcdocm(char(2), char(3), integer);
drop function f_saldo_docmto_cxc(char(2), char(10), char(25),  char(3), date);
-- drop function f_saldo_documento_cxc(char(2), char(10), char(2), char(25), date) cascade;

--drop function f_saldo_documento_cxc(char(2), char(3), char(10), char(3), char(25), date) cascade;

drop function f_saldo_documento_cxc(char(2), char(3), char(10), char(3), char(25), date) cascade;

drop function f_saldo_cliente(char(2), char(10), date);
drop function f_cxctrx1_cxcdocm(char(2), int4);

drop function f_cxctrx1_cglposteo(char(2), char(3), int4);

-- drop function f_cxctrx1_cglposteo(char(2), int4);


drop function f_update_cxcdocm_fac(char(2)) cascade;
drop function f_update_cxcdocm_cxc(char(2)) cascade;
drop function f_postea_cxc(char(2)) cascade;
drop function f_cxc_edc_calculo_morosidad(char(2),char(10),date,date) cascade;
drop function f_informacion_cliente(char(2),char(10)) cascade;
drop function f_delete_cxcdocm(char(2)) cascade;
drop function f_vendedor(char(2), char(10), char(2), char(25), char(25), char(20)) cascade;
drop function f_insert_agrupaciones_clientes(char(10)) cascade;
drop function f_facturas_pendientes(char(10), date) cascade;
drop function f_cxc_promedio_dias_cobros(char(10), date, date, varchar(20)) cascade;
drop function f_cxc_promedio_dias_morosidad(char(2), char(10), date, varchar(20)) cascade;
drop function f_cxc_recibo1_before_delete(char(2), char(3), integer) cascade;
drop function f_cerrar_cxc(char(2),int4, int4) cascade;


create function f_cerrar_cxc(char(2),int4, int4) returns integer as '
declare
    as_cia alias for $1;
    ai_anio alias for $2;
    ai_mes alias for $3;
    r_work record;
    r_gralperiodos record;
begin

    select into r_gralperiodos *
    from gralperiodos
    where compania = as_cia
    and aplicacion = ''CXC''
    and year = ai_anio
    and periodo = ai_mes;
    if not found then
        Raise Exception ''No existe Anio % y Mes % en Inventario'',ai_anio, ai_mes;
    end if;
    
    if r_gralperiodos.estado <> ''A'' then
        return 0;
    end if;

	delete from cxcbalance
	where compania = as_cia
	and year = ai_anio
	and periodo = ai_mes;

    insert into cxcbalance (aplicacion, compania, cliente, year, periodo, saldo)
    select ''CXC'', almacen.compania, cxcdocm.cliente, ai_anio, ai_mes, 
    sum(cxcmotivos.signo*cxcdocm.monto)
    from cxcdocm, almacen, cxcmotivos
    where cxcdocm.almacen = almacen.almacen
    and cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
    and cxcdocm.fecha_posteo <= r_gralperiodos.final
    and almacen.compania = as_cia
    group by almacen.compania, cxcdocm.cliente;
    
    return f_cerrar_aplicacion(as_cia, ''CXC'', ai_anio, ai_mes);
end;
' language plpgsql;    




create function f_cxc_recibo1_before_delete(char(2), char(3), integer)returns integer as '
declare
    ac_almacen alias for $1;
    ac_caja alias for $2;
    ai_consecutivo alias for $3;
    r_cxc_recibo1 record;
begin

    select into r_cxc_recibo1 *
    from cxc_recibo1
    where almacen = ac_almacen
    and caja = ac_caja
    and consecutivo = ai_consecutivo;
    if not found then
        return 0;
    end if;
    
    delete from cxcdocm
    where almacen = ac_almacen
    and caja = ac_caja
    and cliente = r_cxc_recibo1.cliente
    and trim(documento) = trim(r_cxc_recibo1.documento)
    and fecha_posteo = r_cxc_recibo1.fecha;
    
    delete from rela_cxc_recibo1_cglposteo
    where almacen = ac_almacen
    and caja = ac_caja
    and cxc_consecutivo = ai_consecutivo;
    
    
    return 1;
end;
' language plpgsql;    


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

  


create function f_cxc_promedio_dias_cobros(char(10), date, date, varchar(20))returns decimal as '
declare
    as_cliente alias for $1;
    ad_desde alias for $2;
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
begin
    ldc_work = 0;
    
    if trim(avc_retorno) = ''VENTA'' then
        select into ldc_work sum(cxcdocm.monto*cxcmotivos.signo)
        from cxcdocm, cxcmotivos
        where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
        and cxcmotivos.factura = ''S''
        and trim(cxcdocm.cliente) = trim(as_cliente)
        and cxcdocm.fecha_posteo between ad_desde and ad_hasta;
        
    elsif trim(avc_retorno) = ''SALDO'' then
        select into ldc_work sum(cxcdocm.monto*cxcmotivos.signo)
        from cxcdocm, cxcmotivos
        where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
        and trim(cxcdocm.cliente) = trim(as_cliente)
        and cxcdocm.fecha_posteo <= ad_hasta;


    elsif trim(avc_retorno) = ''PROMEDIO'' then
        select into ldc_saldo sum(cxcdocm.monto*cxcmotivos.signo)
        from cxcdocm, cxcmotivos
        where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
        and trim(cxcdocm.cliente) = trim(as_cliente)
        and cxcdocm.fecha_posteo <= ad_hasta;

        select into ldc_venta sum(cxcdocm.monto*cxcmotivos.signo)
        from cxcdocm, cxcmotivos
        where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
        and cxcmotivos.factura = ''S''
        and trim(cxcdocm.cliente) = trim(as_cliente)
        and cxcdocm.fecha_posteo between ad_desde and ad_hasta;

        select into ld_dia1 Min(fecha_posteo)
        from cxcdocm, cxcmotivos
        where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
        and cxcmotivos.factura = ''S''
        and trim(cxcdocm.cliente) = trim(as_cliente)
        and cxcdocm.fecha_posteo between ad_desde and ad_hasta;

        select into ld_dia2 Max(fecha_posteo)
        from cxcdocm, cxcmotivos
        where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
        and cxcmotivos.factura = ''S''
        and trim(cxcdocm.cliente) = trim(as_cliente)
        and cxcdocm.fecha_posteo between ad_desde and ad_hasta;

        ldc_dias    =   ld_dia2 - ld_dia1;

        ldc_work    =   (ldc_saldo * ldc_dias) /  ldc_venta;

/*        
        ldc_rotacion    =   ldc_venta / ldc_saldo;
        
        ldc_work        =   ldc_dias / ldc_rotacion;
*/        
        
             
    end if;

    if ldc_work is null then
        ldc_work = 0;
    end if;
    
    return ldc_work;
end;
' language plpgsql;    



create function f_facturas_pendientes(char(10), date)returns integer as '
declare
    as_cliente alias for $1;
    ad_fecha alias for $2;
    li_count integer;
begin
    li_count = 0;
    select into li_count count(*)
    from cxcdocm
    where cliente = as_cliente
    and fecha_posteo <= ad_fecha
    and documento = docmto_aplicar
    and motivo_cxc = motivo_ref
    and f_saldo_documento_cxc(almacen, caja, cliente, motivo_cxc, documento, ad_fecha) > 0;
    
    
    if not found then
        li_count = 0;
    end if;
        
    if li_count is null then
        li_count = 0;
    end if;
    
    return li_count;    
end;
' language plpgsql;    


create function f_insert_agrupaciones_clientes(char(10))returns integer as '
declare
    as_cliente alias for $1;
    r_clientes_agrupados record;
    r_gral_grupos_aplicacion record;
    r_gral_valor_grupos record;
    li_count integer;
    lb_sw1 integer;
begin
    lb_sw1 = 0;
    for r_gral_grupos_aplicacion in select * from gral_grupos_aplicacion
                                where aplicacion = ''CXC''
                                order by secuencia, grupo
    loop
        select into r_clientes_agrupados *
        from clientes_agrupados, gral_valor_grupos
        where clientes_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
        and gral_valor_grupos.grupo = r_gral_grupos_aplicacion.grupo
        and clientes_agrupados.cliente = as_cliente;
        if not found then
            for r_gral_valor_grupos in select * from gral_valor_grupos
                                        where grupo = r_gral_grupos_aplicacion.grupo
                                        and aplicacion = r_gral_grupos_aplicacion.aplicacion
                                        order by codigo_valor_grupo
            loop
                insert into clientes_agrupados(cliente, codigo_valor_grupo)
                values(as_cliente, r_gral_valor_grupos.codigo_valor_grupo);
                lb_sw1 = 1;
                exit;
            end loop;
            

            if lb_sw1 = 0 then            
            end if;
            
        end if;
    end loop;                      
    
    return 1;
    
end;
' language plpgsql;    



create function f_vendedor(char(2), char(10), char(2), char(25), char(25), char(20)) returns varchar(50) as '
declare
    as_almacen alias for $1;
    as_cliente alias for $2;
    as_tipo alias for $3;
    as_documento alias for $4;
    as_docmto_aplicar alias for $5;
    as_retorno alias for $6;
    r_factura1 record;
    r_vendedores record;
    r_cxcdocm record;
begin
    select into r_cxcdocm *
    from cxcdocm
    where almacen = as_almacen
    and motivo_cxc = as_tipo
    and cliente = as_cliente
    and documento = as_documento
    and docmto_aplicar = as_docmto_aplicar;
    if not found then
        return null;
    end if;
    
    
    select into r_factura1 *
    from factura1
    where almacen = as_almacen
    and tipo = r_cxcdocm.motivo_ref
    and trim(to_char(num_documento, ''99999999999999'')) = trim(as_docmto_aplicar);
    if found then
        if trim(as_retorno) = ''CODIGO'' then
            return trim(r_factura1.codigo_vendedor);
        else
            select into r_vendedores *
            from vendedores
            where codigo = r_factura1.codigo_vendedor;
            if found then
                return trim(r_vendedores.nombre);
            end if;
        end if;
    end if;
    
    return null;
end;
' language plpgsql;    



create function f_delete_cxcdocm(char(2))returns integer as '
declare
    as_cia alias for $1;
    ld_fecha date;
    i integer;
    r_cxc_recibo1 record;
    r_cxctrx1 record;
    r_adc_cxc_1 record;
begin
    select into ld_fecha Min(inicio) from gralperiodos
    where compania = as_cia
    and aplicacion = ''CXC''
    and estado = ''A''
    and inicio >= ''2009-01-01'';
    if not found then
        return 0;
    end if;
    
    delete from cxcdocm 
    where almacen in (select almacen from almacen where compania = as_cia)
    and (documento <> docmto_aplicar or motivo_cxc <> motivo_ref)
    and fecha_posteo >= ld_fecha;
    
    delete from cxcdocm 
    where almacen in (select almacen from almacen where compania = as_cia)
    and fecha_posteo >= ld_fecha;
    
    return 1;
end;
' language plpgsql;    



create function f_informacion_cliente(char(2),char(10))returns integer as '
declare
    as_cia alias for $1;
    as_cliente alias for $2;
    ldc_morosidad1 decimal;
    ldc_morosidad2 decimal;
    ldc_morosidad3 decimal;
    ldc_morosidad4 decimal;
    ldc_morosidad5 decimal;
    ldc_morosidad_total decimal;
    ldc_work decimal;
    li_mes1 integer;
    li_mes2 integer;
    li_mes3 integer;
    li_mes4 integer;
    li_mes5 integer;
    li_anio1 integer;
    li_anio2 integer;
    li_anio3 integer;
    li_anio4 integer;
    li_anio5 integer;
    ls_mes1 char(40);
    ls_mes2 char(40);
    ls_mes3 char(40);
    ls_mes4 char(40);
    ls_mes5 char(40);
    r_work record;
    r_work2 record;
    r_cxcdocm record;
    r_clientes record;
    ls_mensaje char(80);
begin
    delete from gral_informe;
    
    
    select into r_clientes * from clientes
    where trim(cliente) = trim(as_cliente);
    if not found then
        Raise Exception ''Codigo de Cliente % No Existe'',as_cliente;
    end if;
    
    ls_mensaje      =   ''Cliente: '' || trim(r_clientes.nomb_cliente) || ''   ''  || trim(as_cliente);
    
    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mensaje);
    
    ldc_morosidad1 = 0;
    ldc_morosidad2 = 0;
    ldc_morosidad3 = 0;
    ldc_morosidad4 = 0;
    ldc_morosidad5 = 0;

    li_anio1 = Anio(current_date);
    li_mes1 = Mes(current_date);
    
    li_anio2 = li_anio1;
    li_mes2 = li_mes1 - 1;
    if li_mes2 = 0 then
        li_anio2 = li_anio2 - 1;
        li_mes2 = 12;
    end if;
    
    li_anio3 = li_anio2;
    li_mes3 = li_mes2 - 1;
    if li_mes3 = 0 then
        li_anio3 = li_anio3 - 1;
        li_mes3 = 12;
    end if;
    
    li_anio4 = li_anio3;
    li_mes4 = li_mes3 - 1;
    if li_mes4 = 0 then
        li_anio4 = li_anio4 - 1;
        li_mes4 = 12;
    end if;
    
    li_anio5 = li_anio4;
    li_mes5 = li_mes4 - 1;
    if li_mes5 = 0 then
        li_anio5 = li_anio5 - 1;
        li_mes5 = 12;
    end if;
    
    ldc_morosidad1 = 0;
    ldc_morosidad2 = 0;
    ldc_morosidad3 = 0;
    ldc_morosidad4 = 0;
    ldc_morosidad5 = 0;
    
    for r_work in select cxcdocm.almacen, cliente, 
                    docmto_aplicar, docmto_ref, motivo_ref, 
                    sum(cxcdocm.monto*cxcmotivos.signo) as saldo
                    from cxcdocm, cxcmotivos, almacen
                    where cxcdocm.almacen = almacen.almacen
                    and cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
                    and almacen.compania = as_cia
                    and cxcdocm.cliente = as_cliente
                    and cxcdocm.fecha_posteo <= current_date
                    group by 1, 2, 3, 4, 5
                    having sum(cxcdocm.monto*cxcmotivos.signo) <> 0
    loop
        select into r_cxcdocm * from cxcdocm
        where almacen = r_work.almacen
        and cliente = r_work.cliente
        and documento = r_work.docmto_aplicar
        and docmto_aplicar = r_work.docmto_aplicar
        and motivo_cxc = r_work.motivo_ref;
        if found then
            if Anio(r_cxcdocm.fecha_posteo) = li_anio1
                and Mes(r_cxcdocm.fecha_posteo) = li_mes1 then
               ldc_morosidad1 = ldc_morosidad1 + r_work.saldo;
            elsif Anio(r_cxcdocm.fecha_posteo) = li_anio2
                    and Mes(r_cxcdocm.fecha_posteo)= li_mes2 then
               ldc_morosidad2 = ldc_morosidad2 + r_work.saldo;
            elsif Anio(r_cxcdocm.fecha_posteo) = li_anio3
                    and Mes(r_cxcdocm.fecha_posteo)= li_mes3 then
               ldc_morosidad3 = ldc_morosidad3 + r_work.saldo;
            elsif Anio(r_cxcdocm.fecha_posteo) = li_anio4
                    and Mes(r_cxcdocm.fecha_posteo)= li_mes4 then
               ldc_morosidad4 = ldc_morosidad4 + r_work.saldo;
            else
               ldc_morosidad5 = ldc_morosidad5 + r_work.saldo;
            end if;            
        end if;
    end loop;
    
    ls_mes1 = f_mes(li_mes1) || ''-'' || li_anio1 || ''      '' || Trim(to_char(ldc_morosidad1,''9,999,999D99''));
    ls_mes2 = f_mes(li_mes2) || ''-'' || li_anio2 || ''      '' || Trim(to_char(ldc_morosidad2,''9,999,999D99''));
    ls_mes3 = f_mes(li_mes3) || ''-'' || li_anio3 || ''      '' || Trim(to_char(ldc_morosidad3,''9,999,999D99''));
    ls_mes4 = f_mes(li_mes4) || ''-'' || li_anio4 || ''      '' || Trim(to_char(ldc_morosidad4,''9,999,999D99''));
    ls_mes5 = f_mes(li_mes5) || ''-'' || li_anio5 || ''      '' || Trim(to_char(ldc_morosidad5,''9,999,999D99''));
    

    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mes1);
    
    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mes2);

    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mes3);
    
    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mes4);
    
    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mes5);
    
    ldc_morosidad_total =   ldc_morosidad1 + ldc_morosidad2 + ldc_morosidad3 + ldc_morosidad4 + ldc_morosidad5;
    
    ls_mensaje          =   ''Morosidad Total:    '' || Trim(to_char(ldc_morosidad_total, ''9,999,999D99''));
    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mensaje);

    ls_mensaje      =   ''Facturas Vencidas'';
    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mensaje);

    ls_mensaje      =   ''F.Factura        F.Vmto                Factura              Saldo'';
    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mensaje);

    ldc_work = 0;
    for r_work in select cxcdocm.almacen, cliente, 
                    docmto_aplicar, docmto_ref, motivo_ref,
                    sum(cxcdocm.monto*cxcmotivos.signo) as saldo
                    from cxcdocm, cxcmotivos, almacen
                    where cxcdocm.almacen = almacen.almacen
                    and cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
                    and almacen.compania = as_cia
                    and cxcdocm.cliente = as_cliente
                    and cxcdocm.fecha_posteo <= current_date
                    group by 1, 2, 3, 4, 5
                    having sum(cxcdocm.monto*cxcmotivos.signo) <> 0
                    order by 3
    loop
        select into r_work2 fecha_posteo, fecha_vmto
        from cxcdocm
        where almacen = r_work.almacen
        and cliente = r_work.cliente
        and documento = r_work.docmto_aplicar
        and docmto_aplicar = r_work.docmto_aplicar
        and motivo_cxc = r_work.motivo_ref;
        
        if r_work2.fecha_vmto <= current_date then
            ls_mensaje  =   to_char(r_work2.fecha_posteo,''DD Mon YYYY'') || ''   '' ||
                            to_char(r_work2.fecha_vmto, ''DD Mon YYYY'') || ''       '' ||
                            r_work.docmto_aplicar || ''       '' ||
                            to_char(r_work.saldo,''9,999,999D99'');
            insert into gral_informe(usuario, mensaje)
            values(current_user,ls_mensaje);
            ldc_work = ldc_work + r_work.saldo;
        end if;            
    end loop;
    
    ls_mensaje  =   ''Total de Facturas Vencidas: '' || to_char(ldc_work,''9,999,999D99'');
    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mensaje);
    
    
    ls_mensaje  =   ''Limite de Credito: '' || to_char(r_clientes.limite_credito,''9,9999,999D99'');
    insert into gral_informe(usuario, mensaje)
    values(current_user,ls_mensaje);
    
    return 1;
end;
' language plpgsql;    




create function f_cxc_edc_calculo_morosidad(char(2),char(10),date,date)returns integer as '
declare
    as_cia alias for $1;
    as_cliente alias for $2;
    ad_desde alias for $3;
    ad_hasta alias for $4;
    ldc_morosidad1 decimal;
    ldc_morosidad2 decimal;
    ldc_morosidad3 decimal;
    ldc_morosidad4 decimal;
    ldc_morosidad5 decimal;
    li_mes1 integer;
    li_mes2 integer;
    li_mes3 integer;
    li_mes4 integer;
    li_mes5 integer;
    li_anio1 integer;
    li_anio2 integer;
    li_anio3 integer;
    li_anio4 integer;
    li_anio5 integer;
    ls_mes1 char(30);
    ls_mes2 char(30);
    ls_mes3 char(30);
    ls_mes4 char(30);
    ls_mes5 char(30);
    r_work record;
    r_cxcdocm record;
begin
    ldc_morosidad1 = 0;
    ldc_morosidad2 = 0;
    ldc_morosidad3 = 0;
    ldc_morosidad4 = 0;
    ldc_morosidad5 = 0;

    li_anio1 = Anio(ad_hasta);
    li_mes1 = Mes(ad_hasta);
    
    li_anio2 = li_anio1;
    li_mes2 = li_mes1 - 1;
    if li_mes2 = 0 then
        li_anio2 = li_anio2 - 1;
        li_mes2 = 12;
    end if;
    
    li_anio3 = li_anio2;
    li_mes3 = li_mes2 - 1;
    if li_mes3 = 0 then
        li_anio3 = li_anio3 - 1;
        li_mes3 = 12;
    end if;
    
    li_anio4 = li_anio3;
    li_mes4 = li_mes3 - 1;
    if li_mes4 = 0 then
        li_anio4 = li_anio4 - 1;
        li_mes4 = 12;
    end if;
    
    li_anio5 = li_anio4;
    li_mes5 = li_mes4 - 1;
    if li_mes5 = 0 then
        li_anio5 = li_anio5 - 1;
        li_mes5 = 12;
    end if;
    
    ldc_morosidad1 = 0;
    ldc_morosidad2 = 0;
    ldc_morosidad3 = 0;
    ldc_morosidad4 = 0;
    ldc_morosidad5 = 0;
    
    for r_work in select cxcdocm.almacen, cxcdocm.caja, cliente, 
                    docmto_aplicar, docmto_ref, motivo_ref, 
                    sum(cxcdocm.monto*cxcmotivos.signo) as saldo
                    from cxcdocm, cxcmotivos, almacen
                    where cxcdocm.almacen = almacen.almacen
                    and cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
                    and almacen.compania = as_cia
                    and cxcdocm.cliente = as_cliente
                    and cxcdocm.fecha_posteo <= ad_hasta
                    group by 1, 2, 3, 4, 5, 6
                    having sum(cxcdocm.monto*cxcmotivos.signo) <> 0
    loop
        select into r_cxcdocm * from cxcdocm
        where almacen = r_work.almacen
        and caja = r_work.caja
        and cliente = r_work.cliente
        and documento = r_work.docmto_aplicar
        and docmto_aplicar = r_work.docmto_aplicar
        and motivo_cxc = r_work.motivo_ref;
        if found then
            if Anio(r_cxcdocm.fecha_posteo) = li_anio1
                and Mes(r_cxcdocm.fecha_posteo) = li_mes1 then
               ldc_morosidad1 = ldc_morosidad1 + r_work.saldo;
            elsif Anio(r_cxcdocm.fecha_posteo) = li_anio2
                    and Mes(r_cxcdocm.fecha_posteo)= li_mes2 then
               ldc_morosidad2 = ldc_morosidad2 + r_work.saldo;
            elsif Anio(r_cxcdocm.fecha_posteo) = li_anio3
                    and Mes(r_cxcdocm.fecha_posteo)= li_mes3 then
               ldc_morosidad3 = ldc_morosidad3 + r_work.saldo;
            elsif Anio(r_cxcdocm.fecha_posteo) = li_anio4
                    and Mes(r_cxcdocm.fecha_posteo)= li_mes4 then
               ldc_morosidad4 = ldc_morosidad4 + r_work.saldo;
            else
               ldc_morosidad5 = ldc_morosidad5 + r_work.saldo;
            end if;            
        end if;
    end loop;
    
    ls_mes1 = f_mes(li_mes1) || ''-'' || li_anio1;
    ls_mes2 = f_mes(li_mes2) || ''-'' || li_anio2;
    ls_mes3 = f_mes(li_mes3) || ''-'' || li_anio3;
    ls_mes4 = f_mes(li_mes4) || ''-'' || li_anio4;
    ls_mes5 = f_mes(li_mes5) || ''-'' || li_anio5;
    
    
    update cxc_edc
    set morosidad1 = ldc_morosidad1, morosidad2 = ldc_morosidad2,
        morosidad3 = ldc_morosidad3, morosidad4 = ldc_morosidad4,
        morosidad5 = ldc_morosidad5,
        mes1 = ls_mes1, mes2 = ls_mes2, mes3 = ls_mes3, mes4 = ls_mes4, mes5 = ls_mes5
    where cliente = as_cliente;
    
    return 1;
end;
' language plpgsql;    




create function f_postea_cxc(char(2))returns integer as '
declare
    as_cia alias for $1;
    ld_fecha date;
    i integer;
    r_cxc_recibo1 record;
    r_cxctrx1 record;
    r_adc_cxc_1 record;
begin
    select into ld_fecha Min(inicio) from gralperiodos
    where compania = as_cia
    and aplicacion = ''CXC''
    and estado = ''A''
    and inicio >= ''2005-01-01'';
    if not found then
        return 0;
    end if;

    for r_cxc_recibo1 in select cxc_recibo1.* from almacen, cxc_recibo1
                    where almacen.almacen = cxc_recibo1.almacen
                    and fecha >= ld_fecha
                    and status <> ''A''
                    and (efectivo <> 0 or cheque <> 0 or otro <> 0)
                    and almacen.compania = as_cia
                    and not exists
                        (select * from rela_cxc_recibo1_cglposteo
                            where rela_cxc_recibo1_cglposteo.caja = cxc_recibo1.caja
                            and rela_cxc_recibo1_cglposteo.almacen = cxc_recibo1.almacen
                            and rela_cxc_recibo1_cglposteo.cxc_consecutivo = cxc_recibo1.consecutivo)
                    order by cxc_recibo1.fecha
    loop
        i = f_cxc_recibo1_cglposteo(r_cxc_recibo1.almacen, r_cxc_recibo1.caja, r_cxc_recibo1.consecutivo);
    end loop;        

    
    for r_cxctrx1 in select cxctrx1.* from almacen, cxctrx1
                    where cxctrx1.almacen = almacen.almacen
                    and almacen.compania = as_cia
                    and cxctrx1.fecha_posteo_ajuste_cxc >= ld_fecha
                    and not exists
                        (select * from rela_cxctrx1_cglposteo
                        where rela_cxctrx1_cglposteo.caja = cxctrx1.caja
                        and rela_cxctrx1_cglposteo.almacen = cxctrx1.almacen
                        and rela_cxctrx1_cglposteo.sec_ajuste_cxc = cxctrx1.sec_ajuste_cxc)
                    order by cxctrx1.fecha_posteo_ajuste_cxc
    loop
        i := f_cxctrx1_cglposteo(r_cxctrx1.almacen, r_cxctrx1.caja, r_cxctrx1.sec_ajuste_cxc);
    end loop;
    
    
    
    for r_adc_cxc_1 in select * from adc_cxc_1
                        where compania = as_cia
                        and fecha >= ld_fecha
                        and not exists
                            (select * from rela_adc_cxc_1_cglposteo
                            where rela_adc_cxc_1_cglposteo.compania = adc_cxc_1.compania
                            and rela_adc_cxc_1_cglposteo.consecutivo = adc_cxc_1.consecutivo
                            and rela_adc_cxc_1_cglposteo.secuencia = adc_cxc_1.secuencia)
                        order by fecha
    loop
        i = f_adc_cxc_1_cglposteo(r_adc_cxc_1.compania, r_adc_cxc_1.consecutivo, r_adc_cxc_1.secuencia);
    end loop;                        
    
    return 1;
    
end;
' language plpgsql;    



create function f_update_cxcdocm_cxc(char(2)) returns integer as '
declare
    as_cia alias for $1;
    ld_fecha date;
begin
    select into ld_fecha Min(inicio) from gralperiodos
    where compania = as_cia
    and aplicacion = ''CXC''
    and estado = ''A'';
    if not found then
        return 0;
    end if;

--    ld_fecha    =   ''2013-04-01'';
           
	insert into cxcdocm (caja, documento, docmto_aplicar, cliente, motivo_cxc, almacen, docmto_ref,
	motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
	status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
	select caja, documento, docmto_aplicar, cliente, motivo_cxc, v_cxcdocm_cxc.almacen, docmto_ref,
	motivo_ref, aplicacion_origen, ''N'', fecha_docmto, fecha_vmto, monto, 
    fecha_posteo,
	''R'', current_user, current_timestamp, obs_docmto, current_date, referencia
	from v_cxcdocm_cxc, almacen
	where trim(documento)= trim(docmto_aplicar)
    and trim(motivo_cxc) = trim(motivo_ref)
	and fecha_posteo >= ld_fecha
	and v_cxcdocm_cxc.almacen = almacen.almacen
    and almacen.compania = as_cia
	and not exists
	(select * from cxcdocm
	where cxcdocm.almacen = v_cxcdocm_cxc.almacen
	and cxcdocm.cliente = v_cxcdocm_cxc.cliente
	and trim(cxcdocm.documento) = trim(v_cxcdocm_cxc.documento)
	and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_cxc.docmto_aplicar)
	and cxcdocm.motivo_cxc = v_cxcdocm_cxc.motivo_cxc
    and cxcdocm.fecha_posteo >= ld_fecha);

    
	insert into cxcdocm (caja, documento, docmto_aplicar, cliente, motivo_cxc, almacen, docmto_ref,
	motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
	status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
	select caja, documento, docmto_aplicar, cliente, motivo_cxc, v_cxcdocm_cxc.almacen, docmto_ref,
	motivo_ref, aplicacion_origen, ''N'', fecha_docmto, fecha_vmto, monto, fecha_posteo,
	''R'', current_user, current_timestamp, obs_docmto, current_date, referencia
	from v_cxcdocm_cxc, almacen
	where (trim(documento) <> trim(docmto_aplicar)
    or trim(motivo_cxc) <> trim(motivo_ref))
	and fecha_posteo >= ld_fecha
	and v_cxcdocm_cxc.almacen = almacen.almacen
    and almacen.compania = as_cia
	and not exists
	(select * from cxcdocm
	where cxcdocm.almacen = v_cxcdocm_cxc.almacen
	and cxcdocm.cliente = v_cxcdocm_cxc.cliente
	and trim(cxcdocm.documento) = trim(v_cxcdocm_cxc.documento)
	and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_cxc.docmto_aplicar)
	and cxcdocm.motivo_cxc = v_cxcdocm_cxc.motivo_cxc
    and cxcdocm.fecha_posteo >= ld_fecha);
    
    return 1;
end;
' language plpgsql;    


create function f_update_cxcdocm_fac(char(2)) returns integer as '
declare
    as_cia alias for $1;
    ld_fecha date;
begin
    select into ld_fecha Min(inicio) from gralperiodos
    where compania = as_cia
    and aplicacion = ''CXC''
    and estado = ''A'';
    if not found then
        return 0;
    end if;

--    ld_fecha    =   ''2013-04-01'';
    
	insert into cxcdocm (caja, documento, docmto_aplicar, cliente, motivo_cxc, almacen, docmto_ref,
	motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
	status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
	select trim(caja), trim(documento), trim(docmto_aplicar), trim(cliente), trim(motivo_cxc), 
    trim(v_cxcdocm_fac.almacen), trim(docmto_ref),
	trim(motivo_ref), aplicacion_origen, ''N'', fecha_docmto, fecha_vmto, sum(monto), fecha_posteo,
	''R'', current_user, current_timestamp, obs_docmto, current_date, trim(referencia)
	from v_cxcdocm_fac, almacen
	where v_cxcdocm_fac.almacen = almacen.almacen
    and almacen.compania = as_cia
    and trim(motivo_cxc) = trim(motivo_ref)
    and trim(documento) = trim(docmto_aplicar)
	and fecha_posteo >= ld_fecha
	and not exists
	(select * from cxcdocm
	where cxcdocm.almacen = v_cxcdocm_fac.almacen
	and cxcdocm.cliente = v_cxcdocm_fac.cliente
    and cxcdocm.caja = v_cxcdocm_fac.caja
	and trim(cxcdocm.documento) = trim(v_cxcdocm_fac.documento)
	and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_fac.docmto_aplicar)
	and cxcdocm.motivo_cxc = v_cxcdocm_fac.motivo_cxc
    and cxcdocm.fecha_posteo >= ld_fecha)
    group by caja, documento, docmto_aplicar, cliente, motivo_cxc, v_cxcdocm_fac.almacen, docmto_ref,
	motivo_ref, aplicacion_origen, fecha_docmto, fecha_vmto, fecha_posteo,
	obs_docmto, referencia;

	insert into cxcdocm (caja, documento, docmto_aplicar, cliente, motivo_cxc, almacen, docmto_ref,
	motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
	status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
	select trim(caja), trim(documento), trim(docmto_aplicar), trim(cliente), trim(motivo_cxc), 
    trim(v_cxcdocm_fac.almacen), trim(docmto_ref),
	trim(motivo_ref), aplicacion_origen, ''N'', fecha_docmto, fecha_vmto, monto, fecha_posteo,
	''R'', current_user, current_timestamp, trim(obs_docmto), current_date, trim(referencia)
	from v_cxcdocm_fac, almacen
    where v_cxcdocm_fac.almacen = almacen.almacen
    and almacen.compania = as_cia
	and (trim(documento) <> trim(docmto_aplicar)
    or trim(motivo_cxc) <> trim(motivo_ref))
	and fecha_posteo >= ld_fecha
	and not exists
	(select * from cxcdocm
	where cxcdocm.almacen = v_cxcdocm_fac.almacen
	and cxcdocm.cliente = v_cxcdocm_fac.cliente
    and cxcdocm.caja = v_cxcdocm_fac.caja
	and trim(cxcdocm.documento) = trim(v_cxcdocm_fac.documento)
	and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_fac.docmto_aplicar)
	and cxcdocm.motivo_cxc = v_cxcdocm_fac.motivo_cxc
    and cxcdocm.fecha_posteo >= ld_fecha)
    and exists
    (select * from cxcdocm
    where cxcdocm.almacen = v_cxcdocm_fac.almacen
    and cxcdocm.cliente = v_cxcdocm_fac.cliente
    and cxcdocm.caja = v_cxcdocm_fac.caja
    and trim(cxcdocm.documento) = trim(v_cxcdocm_fac.docmto_aplicar)
    and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_fac.docmto_aplicar)
    and trim(cxcdocm.motivo_cxc) = trim(v_cxcdocm_fac.motivo_ref));

	insert into cxcdocm (almacen_ref, caja_ref, caja, documento, docmto_aplicar, cliente, motivo_cxc, almacen, docmto_ref,
	motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
	status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
	select trim(v_cxcdocm_fac_fiscal.almacen), trim(caja), trim(caja), trim(documento), trim(documento), trim(cliente), trim(motivo_cxc), 
    trim(v_cxcdocm_fac_fiscal.almacen), trim(documento),
	trim(motivo_cxc), aplicacion_origen, ''N'', fecha_docmto, fecha_vmto, sum(monto), fecha_posteo,
	''R'', current_user, current_timestamp, obs_docmto, current_date, trim(referencia)
	from v_cxcdocm_fac_fiscal, almacen
	where v_cxcdocm_fac_fiscal.almacen = almacen.almacen
    and almacen.compania = as_cia
    and trim(motivo_cxc) = trim(motivo_ref)
    and trim(documento) = trim(docmto_aplicar)
	and fecha_posteo >= ld_fecha
	and not exists
	(select * from cxcdocm
	where cxcdocm.almacen = v_cxcdocm_fac_fiscal.almacen
	and cxcdocm.cliente = v_cxcdocm_fac_fiscal.cliente
    and cxcdocm.caja = v_cxcdocm_fac_fiscal.caja
	and trim(cxcdocm.documento) = trim(v_cxcdocm_fac_fiscal.documento)
	and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_fac_fiscal.docmto_aplicar)
	and cxcdocm.motivo_cxc = v_cxcdocm_fac_fiscal.motivo_cxc
    and cxcdocm.fecha_posteo >= ld_fecha)
    group by almacen_ref, caja_ref, caja, documento, docmto_aplicar, cliente, motivo_cxc, v_cxcdocm_fac_fiscal.almacen, 
    docmto_ref,
	motivo_ref, aplicacion_origen, fecha_docmto, fecha_vmto, fecha_posteo,
	obs_docmto, referencia;


	insert into cxcdocm (almacen_ref, caja_ref, caja, documento, docmto_aplicar, cliente, motivo_cxc, almacen, docmto_ref,
	motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
	status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
	select trim(almacen_ref), trim(caja_ref), trim(caja), trim(documento), trim(docmto_aplicar), trim(cliente), trim(motivo_cxc), 
    trim(v_cxcdocm_fac_fiscal.almacen), trim(docmto_ref),
	trim(motivo_ref), aplicacion_origen, ''N'', fecha_docmto, fecha_vmto, monto, fecha_posteo,
	''R'', current_user, current_timestamp, trim(obs_docmto), current_date, trim(referencia)
	from v_cxcdocm_fac_fiscal, almacen
    where v_cxcdocm_fac_fiscal.almacen = almacen.almacen
    and almacen.compania = as_cia
	and (trim(documento) <> trim(docmto_aplicar)
    or trim(motivo_cxc) <> trim(motivo_ref))
	and fecha_posteo >= ld_fecha
	and not exists
	(select * from cxcdocm
	where cxcdocm.almacen = v_cxcdocm_fac_fiscal.almacen
    and cxcdocm.caja = v_cxcdocm_fac_fiscal.caja
	and cxcdocm.cliente = v_cxcdocm_fac_fiscal.cliente
	and trim(cxcdocm.documento) = trim(v_cxcdocm_fac_fiscal.documento)
	and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_fac_fiscal.docmto_aplicar)
	and cxcdocm.motivo_cxc = v_cxcdocm_fac_fiscal.motivo_cxc
    and cxcdocm.fecha_posteo >= ld_fecha)
    and exists
    (select * from cxcdocm
    where cxcdocm.almacen = v_cxcdocm_fac_fiscal.almacen_ref
    and cxcdocm.caja = v_cxcdocm_fac_fiscal.caja_ref
    and cxcdocm.cliente = v_cxcdocm_fac_fiscal.cliente
    and trim(cxcdocm.documento) = trim(v_cxcdocm_fac_fiscal.docmto_aplicar)
    and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_fac_fiscal.docmto_aplicar)
    and trim(cxcdocm.motivo_cxc) = trim(v_cxcdocm_fac_fiscal.motivo_ref));

    
    return 1;
end;
' language plpgsql;    


create function f_saldo_cliente(char(2), char(10), date) returns decimal as '
declare
    as_compania alias for $1;
    as_cliente alias for $2;
    ad_fecha alias for $3;
    ldc_saldo decimal(12,2);
begin
    select into ldc_saldo sum(cxcdocm.monto*cxcmotivos.signo)
    from almacen, cxcdocm, cxcmotivos
    where almacen.almacen = cxcdocm.almacen
    and cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
    and almacen.compania = as_compania
    and cxcdocm.cliente = as_cliente
    and cxcdocm.fecha_posteo <= ad_fecha;
    
    if ldc_saldo is null then
        ldc_saldo = 0;
    end if;
   
    return ldc_saldo;
end;
' language plpgsql;    



create function f_cxctrx1_cglposteo(char(2), char(3), int4) returns integer as '
declare
    as_almacen alias for $1;
    as_caja alias for $2;
    ai_sec_ajuste_cxc alias for $3;
    li_consecutivo int4;
    r_almacen record;
    r_cxctrx1 record;
    r_cxctrx2 record;
    r_work record;
    r_clientes record;
    r_cxcmotivos record;
    r_cglauxiliares record;
    r_cglcuentas record;
    ldc_sum_cxctrx1 decimal(10,2);
    ldc_sum_cxctrx2 decimal(10,2);
    ldc_sum_cxctrx3 decimal(10,2);
    ls_cuenta char(24);
    ls_aux1 char(10);
begin
    select into r_cxctrx1 * from cxctrx1
    where almacen = as_almacen
    and caja = as_caja
    and sec_ajuste_cxc = ai_sec_ajuste_cxc;
    if not found then
       return 0;
    end if;
    
    
    select into ldc_sum_cxctrx1 (efectivo + cheque) from cxctrx1
    where almacen = as_almacen
    and caja = as_caja
    and sec_ajuste_cxc = ai_sec_ajuste_cxc;
    
    select into ldc_sum_cxctrx2 sum(monto) from cxctrx2
    where almacen = as_almacen
    and caja = as_caja
    and sec_ajuste_cxc = ai_sec_ajuste_cxc;
    if ldc_sum_cxctrx2 is null then
       ldc_sum_cxctrx2 := 0;
    end if;
    
    select into ldc_sum_cxctrx3 sum(monto) from cxctrx3
    where almacen = as_almacen
    and caja = as_caja
    and sec_ajuste_cxc = ai_sec_ajuste_cxc;
    if ldc_sum_cxctrx3 is null then
       ldc_sum_cxctrx3 := 0;
    end if;
    
    if ldc_sum_cxctrx2 = 0 and ldc_sum_cxctrx1 <> ldc_sum_cxctrx3 then
       raise exception ''Transaccion % esta desbalanceada...Verifique'',r_cxctrx1.sec_ajuste_cxc;
    end if;
    
    if (ldc_sum_cxctrx1 <> ldc_sum_cxctrx3 or ldc_sum_cxctrx1 <> ldc_sum_cxctrx2)
        and ldc_sum_cxctrx2 <> 0 then
       raise exception ''Transaccion % esta desbalanceada...Verifique'',r_cxctrx1.sec_ajuste_cxc;
    end if;
    
    delete from rela_cxctrx1_cglposteo
    where almacen = r_cxctrx1.almacen
    and caja = as_caja
    and sec_ajuste_cxc = r_cxctrx1.sec_ajuste_cxc;
    
    select into r_cxcmotivos * from cxcmotivos
    where motivo_cxc = r_cxctrx1.motivo_cxc;
    
    select into r_almacen * from almacen
    where almacen = r_cxctrx1.almacen;
    
    select into r_clientes * from clientes
    where cliente = r_cxctrx1.cliente;
    
    if r_cxctrx1.obs_ajuste_cxc is null then
       r_cxctrx1.obs_ajuste_cxc := ''TRANSACCION #  '' || r_cxctrx1.sec_ajuste_cxc || '' DOCUMENTO # '' || r_cxctrx1.docm_ajuste_cxc;
    else
       r_cxctrx1.obs_ajuste_cxc := ''TRANSACCION #  '' || r_cxctrx1.sec_ajuste_cxc || '' DOCUMENTO # '' || r_cxctrx1.docm_ajuste_cxc || ''  '' || trim(r_cxctrx1.obs_ajuste_cxc);
    end if;

/*    
    select into ls_cuenta trim(valor) from invparal
    where almacen = r_cxctrx1.almacen
    and parametro = ''cta_cxc''
    and aplicacion =  ''INV'';
    if not found then
       ls_cuenta := r_clientes.cuenta;
    end if;
*/    
    
    ls_cuenta := r_clientes.cuenta;

    select into r_cglcuentas * from cglcuentas
    where trim(cuenta) = trim(ls_cuenta) and auxiliar_1 = ''S'';
    if not found then
        ls_aux1 := null;
    else
        ls_aux1 := r_cxctrx1.cliente;
        select into r_cglauxiliares * from cglauxiliares
        where trim(auxiliar) = trim(ls_aux1);
        if not found then
            insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
            values (r_clientes.cliente, r_clientes.nomb_cliente, ''1'', ''A'');
        end if;
        
    end if;        
    

    li_consecutivo := f_cglposteo(r_almacen.compania, ''CXC'', r_cxctrx1.fecha_posteo_ajuste_cxc, 
                            ls_cuenta, ls_aux1, null,
                            r_cxcmotivos.tipo_comp, r_cxctrx1.obs_ajuste_cxc, 
                            (ldc_sum_cxctrx1*r_cxcmotivos.signo));
    if li_consecutivo > 0 then
        insert into rela_cxctrx1_cglposteo (almacen, sec_ajuste_cxc, consecutivo, caja)
        values (r_cxctrx1.almacen, r_cxctrx1.sec_ajuste_cxc, li_consecutivo, as_caja);
    end if;

    for r_work in select cxctrx3.cuenta, cxctrx3.auxiliar1, cxctrx3.auxiliar2, cxctrx3.monto
                    from cxctrx3
                    where cxctrx3.almacen = r_cxctrx1.almacen
                    and caja = as_caja
                    and cxctrx3.sec_ajuste_cxc = r_cxctrx1.sec_ajuste_cxc
                    order by 1
    loop
        li_consecutivo = f_cglposteo(r_almacen.compania, ''CXC'', 
                                r_cxctrx1.fecha_posteo_ajuste_cxc, 
                                r_work.cuenta, r_work.auxiliar1, r_work.auxiliar2,
                                r_cxcmotivos.tipo_comp, r_cxctrx1.obs_ajuste_cxc, 
                                -(r_work.monto*r_cxcmotivos.signo));
        if li_consecutivo > 0 then
            insert into rela_cxctrx1_cglposteo (almacen, caja, sec_ajuste_cxc, consecutivo)
            values (r_cxctrx1.almacen, as_caja, r_cxctrx1.sec_ajuste_cxc, li_consecutivo);
        end if;
    end loop;
    return 1;
end;
' language plpgsql;


create function f_saldo_docmto_cxc(char(2), char(10), char(2), char(25), date) returns decimal(10,2) as '
declare
    as_almacen alias for $1;
    as_cliente alias for $2;
    as_tipo alias for $3;
    as_documento alias for $4;
    ad_fecha alias for $5;
    ldc_saldo decimal(10,2);
begin
    ldc_saldo = 0;
    select into ldc_saldo sum(cxcdocm.monto*cxcmotivos.signo) 
    from cxcdocm, cxcmotivos
    where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
    and cxcdocm.almacen = as_almacen
    and cxcdocm.cliente = as_cliente
    and cxcdocm.motivo_ref = as_tipo
    and cxcdocm.docmto_ref = as_documento
    and cxcdocm.docmto_aplicar = as_documento
    and cxcdocm.fecha_posteo <= ad_fecha;
    
    if ldc_saldo is null then
        ldc_saldo = 0;
    end if;
    
    return ldc_saldo;
end;
' language plpgsql;    


create function f_saldo_documento_cxc(char(2), char(3), char(10), char(3), char(25), date) returns decimal(10,2) as '
declare
    as_almacen alias for $1;
    as_caja alias for $2;
    as_cliente alias for $3;
    as_tipo alias for $4;
    as_documento alias for $5;
    ad_fecha alias for $6;
    ldc_saldo decimal(10,2);
begin
    ldc_saldo = 0;
    select into ldc_saldo sum(cxcdocm.monto*cxcmotivos.signo) 
    from cxcdocm, cxcmotivos
    where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
    and cxcdocm.almacen = as_almacen
    and cxcdocm.caja_ref = as_caja
    and cxcdocm.cliente = as_cliente
    and cxcdocm.motivo_ref = as_tipo
    and cxcdocm.docmto_ref = as_documento
    and cxcdocm.docmto_aplicar = as_documento
    and cxcdocm.fecha_posteo <= ad_fecha;
    
    if ldc_saldo is null then
        ldc_saldo = 0;
    end if;
    
    return ldc_saldo;
end;
' language plpgsql;    


create function f_factura_cxcdocm(char(2), char(3), integer) returns integer as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    r_factura1 record;
    r_cxcdocm record;
    ldc_monto_factura decimal(10,2);
    lc_documento char(25);
    lc_docmto_aplicar char(25);
    lc_motivo_ref char(3);
begin
    ldc_monto_factura := f_monto_factura(as_almacen, as_tipo, ai_num_documento);
    if ldc_monto_factura = 0 or ldc_monto_factura is null then
        return 0;
    end if;
    
    select into r_factura1 factura1.* from factura1, factmotivos, gral_forma_de_pago
    where factura1.tipo = factmotivos.tipo
    and factura1.almacen = as_almacen
    and factura1.tipo = as_tipo
    and factura1.num_documento = ai_num_documento
    and factura1.tipo = factmotivos.tipo
    and factura1.forma_pago = gral_forma_de_pago.forma_pago
    and (factmotivos.factura = ''S'' or factmotivos.nota_credito = ''S'' 
    or factmotivos.devolucion = ''S'')
    and gral_forma_de_pago.dias > 0;
    if not found then
       return 0;
    end if;
    
    if r_factura1.status = ''A'' then
        return 0;
    end if;
    
    if r_factura1.num_factura = 0 then
        lc_documento    := trim(to_char(r_factura1.num_documento, ''9999999999999999''));
        lc_docmto_aplicar := trim(to_char(r_factura1.num_documento, ''9999999999999999''));
        lc_motivo_ref := trim(r_factura1.tipo);
    else
        lc_documento    := trim(to_char(r_factura1.num_documento, ''9999999999999999''));
        lc_docmto_aplicar := trim(to_char(r_factura1.num_factura, ''9999999999999999''));
        select into lc_motivo_ref motivo_cxc from cxcdocm
        where almacen = r_factura1.almacen
        and cliente = r_factura1.cliente
        and documento = lc_docmto_aplicar
        and docmto_aplicar = lc_docmto_aplicar;
        if not found then
            raise exception ''Factura aplicar no existe en devolucion # %'',lc_docmto_aplicar;
        end if;
    end if;
    
    
/*    delete from cxcdocm
    where almacen = r_factura1.almacen
    and cliente = r_factura1.cliente
    and motivo_cxc = r_factura1.tipo
    and documento = lc_documento
    and docmto_aplicar = lc_docmto_aplicar;
*/    
    
    select into r_cxcdocm * from cxcdocm
    where almacen = r_factura1.almacen
    and cliente = r_factura1.cliente
    and motivo_cxc = r_factura1.tipo
    and documento = lc_documento
    and docmto_aplicar = lc_docmto_aplicar;
    if not found then
        insert into cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen, 
        docmto_ref, motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, 
        fecha_vmto, monto, fecha_posteo, status, usuario, fecha_captura, obs_docmto,
        fecha_cancelo, referencia) values (trim(lc_documento), trim(lc_docmto_aplicar), 
        r_factura1.cliente, r_factura1.tipo, r_factura1.almacen, trim(lc_docmto_aplicar), 
        trim(lc_motivo_ref), ''FAC'', ''N'', r_factura1.fecha_factura, 
        r_factura1.fecha_vencimiento, Abs(ldc_monto_factura), r_factura1.fecha_factura, 
        ''R'', current_user, current_timestamp, null, current_date, null);
    else
        update cxcdocm
        set     fecha_docmto = r_factura1.fecha_factura,
                fecha_vmto = r_factura1.fecha_vencimiento,
                monto = Abs(ldc_monto_factura),
                fecha_posteo = r_factura1.fecha_factura,
                usuario = current_user,
                fecha_captura = current_timestamp,
                obs_docmto = r_factura1.observacion,
                referencia = r_factura1.no_referencia
        where   almacen = r_factura1.almacen
        and     cliente = r_factura1.cliente
        and     motivo_cxc = r_factura1.tipo
        and     documento = lc_documento
        and     docmto_aplicar = lc_docmto_aplicar;
    end if;        
  
    return 1;
end;
' language plpgsql;    


create function f_cxctrx1_cxcdocm(char(2), int4) returns integer as '
declare
    as_almacen alias for $1;
    ai_sec_ajuste_cxc alias for $2;
    r_cxctrx1 record;
    r_cxctrx2 record;
    r_cxctrx3 record;
    r_cxcdocm record;
    r_cxcdocm2 record;
    li_work int4;
    ldc_sum_cxctrx2 decimal(10,2);
begin
    select into r_cxctrx1 * from cxctrx1
    where almacen = as_almacen
    and sec_ajuste_cxc = ai_sec_ajuste_cxc;
    if not found then
        return 0;
    end if;
   
    ldc_sum_cxctrx2 := 0;
    select into ldc_sum_cxctrx2 sum(monto) from cxctrx2
    where almacen = as_almacen
    and sec_ajuste_cxc = ai_sec_ajuste_cxc;
    if ldc_sum_cxctrx2 is null or ldc_sum_cxctrx2 = 0 then
        select into r_cxcdocm * from cxcdocm
        where almacen = r_cxctrx1.almacen
        and cliente = r_cxctrx1.cliente
        and documento = r_cxctrx1.docm_ajuste_cxc
        and docmto_aplicar = r_cxctrx1.docm_ajuste_cxc
        and motivo_cxc = r_cxctrx1.motivo_cxc;
        if not found then
            insert into cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen, 
                docmto_ref, motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, 
                fecha_vmto, monto, fecha_posteo, status, usuario, fecha_captura, obs_docmto,
                fecha_cancelo, referencia) 
            values (r_cxctrx1.docm_ajuste_cxc, r_cxctrx1.docm_ajuste_cxc, r_cxctrx1.cliente,
                r_cxctrx1.motivo_cxc, r_cxctrx1.almacen, r_cxctrx1.docm_ajuste_cxc,
                r_cxctrx1.motivo_cxc, ''CXC'', ''N'', r_cxctrx1.fecha_posteo_ajuste_cxc,
                r_cxctrx1.fecha_posteo_ajuste_cxc, (r_cxctrx1.efectivo+r_cxctrx1.cheque),
                r_cxctrx1.fecha_posteo_ajuste_cxc, ''R'', current_user,
                current_timestamp, r_cxctrx1.obs_ajuste_cxc, current_date,
                r_cxctrx1.referencia);
        end if;                
    end if;


    select into li_work count(*) from cxctrx2
    where almacen = as_almacen
    and sec_ajuste_cxc = ai_sec_ajuste_cxc
    and monto <> 0;
    if li_work is null or li_work = 0 then
        select into r_cxcdocm * from cxcdocm
        where almacen = r_cxctrx1.almacen
        and cliente = r_cxctrx1.cliente
        and documento = r_cxctrx1.docm_ajuste_cxc
        and docmto_aplicar = r_cxctrx1.docm_ajuste_cxc
        and motivo_cxc = r_cxctrx1.motivo_cxc;
        if not found then
            insert into cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen, 
                docmto_ref, motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, 
                fecha_vmto, monto, fecha_posteo, status, usuario, fecha_captura, obs_docmto,
                fecha_cancelo, referencia) 
            values (trim(r_cxctrx1.docm_ajuste_cxc), trim(r_cxctrx1.docm_ajuste_cxc), 
                r_cxctrx1.cliente, r_cxctrx1.motivo_cxc, r_cxctrx1.almacen, trim(r_cxctrx1.docm_ajuste_cxc), 
                r_cxctrx1.motivo_cxc, ''CXC'', ''N'', r_cxctrx1.fecha_posteo_ajuste_cxc, 
                r_cxctrx1.fecha_posteo_ajuste_cxc, (r_cxctrx1.efectivo + r_cxctrx1.cheque), r_cxctrx1.fecha_posteo_ajuste_cxc, 
                ''R'', current_user, current_timestamp, r_cxctrx1.obs_ajuste_cxc, current_date, r_cxctrx1.referencia);
        end if;                
    else
        for r_cxctrx2 in select cxctrx2.* from cxctrx2
                            where almacen = as_almacen
                            and sec_ajuste_cxc = ai_sec_ajuste_cxc
                            and monto <> 0
        loop
            select into r_cxcdocm2 * from cxcdocm
            where almacen = r_cxctrx1.almacen
            and cliente = r_cxctrx1.cliente
            and motivo_cxc = r_cxctrx2.motivo_cxc
            and documento = r_cxctrx2.aplicar_a
            and docmto_aplicar = r_cxctrx2.aplicar_a;
            if found then
                delete from cxcdocm
                where almacen = r_cxctrx1.almacen
                and cliente = r_cxctrx1.cliente
                and motivo_cxc = r_cxctrx1.motivo_cxc
                and trim(documento) = trim(r_cxctrx1.docm_ajuste_cxc)
                and trim(docmto_aplicar) = trim(r_cxctrx2.aplicar_a);
            
                insert into cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen, 
                    docmto_ref, motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, 
                    fecha_vmto, monto, fecha_posteo, status, usuario, fecha_captura, obs_docmto,
                    fecha_cancelo, referencia) 
                values (r_cxctrx1.docm_ajuste_cxc, r_cxctrx2.aplicar_a, 
                    r_cxctrx1.cliente, r_cxctrx1.motivo_cxc, r_cxctrx1.almacen, 
                    r_cxctrx2.aplicar_a, r_cxctrx2.motivo_cxc, ''CXC'', ''N'', 
                    r_cxctrx1.fecha_posteo_ajuste_cxc, r_cxctrx1.fecha_posteo_ajuste_cxc, 
                    r_cxctrx2.monto, r_cxctrx1.fecha_posteo_ajuste_cxc, ''R'', 
                    current_user, current_timestamp, r_cxctrx1.obs_ajuste_cxc, 
                    current_date, r_cxctrx1.referencia);
            end if;                
        end loop;
        
    end if;    

   
    return 1;
end;
' language plpgsql;    
