--drop function f_factura_inventario(char(2), char(3), integer) cascade;
drop function f_factura_inventario(char(2), char(3), integer, char(3)) cascade;
drop function f_update_existencias(char(2), char(15)) cascade;
drop function f_compras_inventario(char(2), char(6), char(25)) cascade;
drop function f_sec_inventario(char(2)) cascade;
drop function f_eys1_cglposteo(char(2), int4) cascade;
--drop function f_eys1_poner_cuentas(char(2), int4) cascade;
drop function f_update_inventario(char(2)) cascade;
drop function f_postea_inventario(char(2)) cascade;
drop function f_stock(char(2), char(15), date, int4, int4, text) cascade;
drop function f_asiento_fisico(char(2),int4) cascade;
drop function f_insert_inv_fisico2(char(2),int4) cascade;
drop function f_eys2_costo(char(2),int4, int4, char(15)) cascade;
drop function f_invparal(char(2), char(20)) cascade;
drop function f_ultimo_costo_unitario(char(2), char(15), date) cascade;
drop function f_sum_eys(char(2), int4, char(20)) cascade;
drop function f_cerrar_inv(char(2),int4, int4) cascade;


create function f_cerrar_inv(char(2),int4, int4) returns integer as '
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
    and aplicacion = ''INV''
    and year = ai_anio
    and periodo = ai_mes;
    if not found then
        Raise Exception ''No existe Anio % y Mes % en Inventario'',ai_anio, ai_mes;
    end if;
    
    if r_gralperiodos.estado <> ''A'' then
        return 0;
    end if;
    
    delete from invbalance
    where compania = as_cia
    and year = ai_anio
    and periodo = ai_mes;

    if trim(f_gralparaxcia(as_cia,''PLA'',''metodo_calculo'')) = ''harinas'' then
        insert into invbalance (compania, aplicacion, almacen,  articulo, year, periodo, existencia, costo)
        select almacen.compania,''INV'',almacen.almacen,articulos_por_almacen.articulo,
        ai_anio,ai_mes, 
        f_stock(almacen.almacen, articulos_por_almacen.articulo, r_gralperiodos.final, 0, 0, ''STOCK''),
        f_stock(almacen.almacen, articulos_por_almacen.articulo, r_gralperiodos.final, 0, 0, ''COSTO'')
        from almacen, articulos_por_almacen
        where almacen.almacen = articulos_por_almacen.almacen
        and almacen.compania = as_cia
        order by almacen.compania, almacen.almacen, articulos_por_almacen.articulo;
    else
        insert into invbalance (compania, aplicacion, almacen,  articulo, year, periodo, existencia, costo)
        select compania,''INV'',almacen,articulo,ai_anio,ai_mes,sum(cantidad), sum(costo)
        from v_eys1_eys2
        where compania = as_cia
        and fecha <= r_gralperiodos.final
        group by articulo, almacen, compania;
    end if;
    return f_cerrar_aplicacion(as_cia, ''INV'', ai_anio, ai_mes);
end;


' language plpgsql;



create function f_sum_eys(char(2), int4, char(20)) returns decimal(12,4) as '
declare
    as_almacen alias for $1;
    ai_no_transaccion alias for $2;
    as_tabla alias for $3;
    ldc_work decimal(12,4);
begin
    ldc_work = 0;
    
    if trim(as_tabla) = ''eys2'' then
        select sum(costo) into ldc_work
        from eys2
        where almacen = as_almacen
        and no_transaccion = ai_no_transaccion;
    else
        select sum(monto) into ldc_work
        from eys3
        where almacen = as_almacen
        and no_transaccion = ai_no_transaccion;
    end if;
    
    if ldc_work is null then
        ldc_work = 0;
    end if;
    
    return ldc_work;
end;
' language plpgsql;



create function f_ultimo_costo_unitario(char(2), char(15), date) returns decimal(12,4) as '
declare
    as_almacen alias for $1;
    as_articulo alias for $2;
    ad_fecha alias for $3;
    stock decimal(12,4);
    ld_ultimo_cierre date;
    r_articulos record;
    r_articulos_por_almacen record;
    r_work record;
    r_eys2 record;
    li_year integer;
    li_periodo integer;
    ldc_existencia1 decimal(12,4);
    ldc_existencia2 decimal(12,4);
    ldc_costo1 decimal(12,4);
    ldc_costo2 decimal(12,4);
    ldc_retornar decimal;
    ldc_costo decimal;
    ldc_cantidad decimal;
    ldc_cu decimal;
begin
    stock           =   0;
    ldc_retornar    =   0;
    ldc_cu          =   0;
    select into r_articulos * from articulos
    where articulos.articulo = as_articulo;
    if r_articulos.servicio = ''S'' then
       return 0;
    end if;
    
    select into r_articulos_por_almacen * from articulos_por_almacen
    where almacen = as_almacen
    and articulo = as_articulo;
    if not found then
        return 0;
    end if;

    select Max(fecha) into ld_ultimo_cierre from eys1, eys2
    where eys1.almacen = eys2.almacen
    and eys1.no_transaccion = eys2.no_transaccion
    and eys2.almacen = as_almacen
    and eys2.articulo = as_articulo
    and eys1.aplicacion_origen = ''COM''
    and eys2.cantidad > 0
    and eys1.fecha <= ad_fecha;
    if ld_ultimo_cierre is not null then
        select (sum(eys2.costo)/sum(eys2.cantidad)) into ldc_cu
        from eys1, eys2
        where eys1.almacen = eys2.almacen
        and eys1.no_transaccion = eys2.no_transaccion
        and eys2.almacen = as_almacen
        and eys2.articulo = as_articulo
        and eys1.aplicacion_origen = ''COM''
        and eys2.cantidad > 0
        and eys2.costo is not null
        and eys2.cantidad is not null
        and eys1.fecha = ld_ultimo_cierre;
        if found then
            return ldc_cu;
        end if;
    else
        select into ldc_cu (eys2.costo/eys2.cantidad)
        from eys1, eys2
        where eys1.almacen = eys2.almacen
        and eys1.no_transaccion = eys2.no_transaccion
        and eys2.almacen = as_almacen
        and eys2.articulo = as_articulo
        and eys1.aplicacion_origen = ''INV''
        and eys2.cantidad > 0
        and eys2.costo is not null
        and eys2.cantidad is not null
        and eys1.fecha = ''2008-12-31'';
        if found then
            return ldc_cu;
        end if;
    end if;
    
    if ldc_cu is null then
        ldc_cu = 0;
    end if;

    return ldc_cu;
end;
' language plpgsql;



create function f_invparal(char(2), char(20)) returns char(60) as '
declare
    as_almacen alias for $1;
    as_parametro alias for $2;
    r_invparal record;
begin
    select into r_invparal * from invparal
    where almacen = as_almacen
    and trim(parametro) = trim(as_parametro)
    and aplicacion = ''INV'';
    if not found then
        raise exception ''Parametro % No Existe en el Almacen %'', as_parametro, as_almacen;
    else
        return trim(r_invparal.valor);
    end if;
end;
' language plpgsql;


create function f_eys2_costo(char(2),int4, int4, char(15)) returns decimal as '
declare
    as_almacen alias for $1;
    ai_no_transaccion alias for $2;
    ai_linea alias for $3;
    as_articulo alias for $4;
    ldc_cu decimal;
    r_eys2 record;
    r_eys6 record;
begin
    select into r_eys2 * from eys2
    where eys2.almacen = as_almacen
    and eys2.no_transaccion = ai_no_transaccion
    and eys2.linea = ai_linea
    and eys2.articulo = as_articulo;
    if not found then
        return 0;
    end if;
    
    
    select into r_eys6 * from eys6
    where eys6.almacen = as_almacen
    and eys6.no_transaccion = ai_no_transaccion
    and eys6.linea = ai_linea
    and eys6.articulo = as_articulo;
    if not found then
        return r_eys2.costo;
    else
        select into ldc_cu (eys2.costo/eys2.cantidad)
        from eys2
        where eys2.almacen = r_eys6.almacen
        and eys2.no_transaccion = r_eys6.compra_no_transaccion
        and eys2.linea = r_eys6.compra_linea
        and eys2.articulo = r_eys6.articulo;
        if not found then
            return r_eys2.costo;
        else
            return r_eys2.cantidad * ldc_cu;
        end if;
    end if;
    
    return 0;
end;
' language plpgsql;


create function f_insert_inv_fisico2(char(2),int4) returns integer as '
declare
    as_almacen alias for $1;
    ai_secuencia alias for $2;
    i integer;
begin
    insert into inv_fisico2(almacen, secuencia, articulo, linea, cantidad)
    select almacen, ai_secuencia, articulo, 0, 0
    from articulos_por_almacen
    where almacen = as_almacen
    and not exists
    (select * from inv_fisico2 fis
    where fis.almacen = articulos_por_almacen.almacen
    and fis.secuencia = ai_secuencia
    and fis.articulo = articulos_por_almacen.articulo);
    return 1;
end;
' language plpgsql;


create function f_asiento_fisico(char(2),int4) returns integer as '
declare
    as_almacen alias for $1;
    ai_no_transaccion alias for $2;
    r_almacen record;
    r_work record;
    lvc_grupo varchar(10);
    i integer;
begin
    select into r_almacen *
    from almacen
    where almacen = as_almacen;
    if not found then
        return 0;
    end if;
    
    delete from eys3
    where almacen = as_almacen
    and no_transaccion = ai_no_transaccion;
    
    lvc_grupo = Trim(f_gralparaxcia(r_almacen.compania, ''FAC'', ''agrupar_por''));
    
    for r_work in select facparamcgl.cuenta_costo as cuenta, sum(eys2.costo) as monto
                    from eys2, articulos_agrupados, facparamcgl, gral_valor_grupos
                    where eys2.articulo = articulos_agrupados.articulo
                    and articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
                    and articulos_agrupados.codigo_valor_grupo = facparamcgl.codigo_valor_grupo
                    and trim(gral_valor_grupos.grupo) = trim(lvc_grupo)
                    and eys2.almacen = as_almacen
                    and eys2.no_transaccion = ai_no_transaccion
                    group by 1
                    order by 1
    loop
        insert into eys3 (almacen, no_transaccion, cuenta, monto)
        values(as_almacen, ai_no_transaccion, r_work.cuenta, r_work.monto);
    end loop;
        
    
    return 1;
end;
' language plpgsql;


create function f_postea_inventario(char(2)) returns integer as '
declare
    as_cia alias for $1;
    i integer;
    ld_fecha date;
    r_eys1 record;
begin
    select into ld_fecha Min(inicio) from gralperiodos
    where compania = as_cia
    and aplicacion = ''INV''
    and estado = ''A'';
    if not found then
        return 0;
    end if;
    
    for r_eys1 in select eys1.* from eys1
                        where eys1.almacen in (select almacen from almacen where compania = as_cia)
                        and eys1.fecha >= ld_fecha
                        and not exists
						(select * from rela_eys1_cglposteo
						where rela_eys1_cglposteo.almacen = eys1.almacen
						and rela_eys1_cglposteo.no_transaccion = eys1.no_transaccion)
                        order by fecha
    loop
        select into i f_eys1_cglposteo(r_eys1.almacen, r_eys1.no_transaccion);
    end loop;        
    
    return 1;
end;
' language plpgsql;


create function f_update_inventario(char(2)) returns integer as '
declare
    as_cia alias for $1;
    i integer;
    ld_fecha date;
    r_factura1 record;
    r_cos_trx record;
    r_tal_ot2 record;
    r_cos_consumo record;
    r_cos_produccion record;
    curs1 refcursor;
    ls_sql text;
begin
    select into ld_fecha Min(inicio) from gralperiodos
    where compania = as_cia
    and aplicacion = ''INV''
    and estado = ''A'';
    if not found then
        return 0;
    end if;
    
    for r_tal_ot2 in select tal_ot2.*
                        from tal_ot2, tal_ot1, almacen
                        where tal_ot1.almacen = tal_ot2.almacen
                        and tal_ot1.tipo = tal_ot2.tipo
                        and tal_ot1.no_orden = tal_ot2.no_orden
                        and tal_ot2.despachar = ''S''
                        and tal_ot2.fecha_despacho >= ld_fecha
                        and tal_ot2.almacen = almacen.almacen
                        and almacen.compania = as_cia
                        and not exists
                            (select * from tal_ot2_eys2
                                where tal_ot2_eys2.almacen = tal_ot2.almacen
                                and tal_ot2_eys2.tipo = tal_ot2.tipo
                                and tal_ot2_eys2.no_orden = tal_ot2.no_orden
                                and tal_ot2_eys2.linea_tal_ot2 = tal_ot2.linea
                                and tal_ot2_eys2.articulo = tal_ot2.articulo)
    loop                                
        i = f_tal_ot2_inventario(r_tal_ot2.almacen, r_tal_ot2.no_orden, r_tal_ot2.tipo, r_tal_ot2.linea, r_tal_ot2.articulo);
    end loop;

/*    
    for r_factura1 in select factura1.almacen, factura1.tipo, factura1.num_documento 
                        from factura1, factura2, articulos, factmotivos, almacen
                        where factura1.almacen = almacen.almacen
                        and almacen.compania = as_cia
                        and factura1.tipo = factmotivos.tipo
                        and factura1.almacen = factura2.almacen
                        and factura1.tipo = factura2.tipo
                        and factura1.num_documento = factura2.num_documento
                        and factura2.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and factmotivos.devolucion = ''S''
                        and factura1.fecha_despacho >= ld_fecha
                        and factura1.status <> ''A''
                        and factura1.fecha_despacho is not null
                        and factura1.despachar = ''S''
                        and not exists
                        (select * from factura2_eys2
                        where factura2_eys2.almacen = factura2.almacen
                        and factura2_eys2.tipo = factura2.tipo
                        and factura2_eys2.num_documento = factura2.num_documento
                        and factura2_eys2.factura2_linea = factura2.linea)
                        group by factura1.almacen, factura1.tipo, factura1.num_documento
                        order by factura1.almacen, factura1.tipo, factura1.num_documento
    loop
        i := f_factura_inventario(r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento);
    end loop;
*/    

    for r_factura1 in select factura1.almacen, factura1.tipo, factura1.caja, factura1.num_documento 
                        from factura1, factura2, articulos, factmotivos, almacen
                        where factura1.almacen = almacen.almacen
                        and almacen.compania = as_cia
                        and factura1.tipo = factmotivos.tipo
                        and factura1.almacen = factura2.almacen
                        and factura1.caja = factura2.caja
                        and factura1.tipo = factura2.tipo
                        and factura1.num_documento = factura2.num_documento
                        and factura2.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and (factmotivos.factura = ''S'' 
                        or factmotivos.factura_fiscal = ''S'' 
                        or factmotivos.donacion = ''S'' or factmotivos.devolucion = ''S''
                        or factmotivos.promocion = ''S'')
                        and factura1.fecha_despacho >= ld_fecha
                        and factura1.status <> ''A''
                        and factura1.fecha_despacho is not null
                        and factura1.despachar = ''S''
                        and not exists
                        (select * from factura2_eys2
                        where factura2_eys2.almacen = factura2.almacen
                        and factura2_eys2.tipo = factura2.tipo
                        and factura2_eys2.num_documento = factura2.num_documento
                        and factura2_eys2.caja = factura2.caja
                        and factura2_eys2.factura2_linea = factura2.linea)
                        group by factura1.almacen, factura1.num_documento, factura1.caja, factura1.tipo
                        order by factura1.almacen, factura1.num_documento, factura1.caja, factura1.tipo
    loop
        i = f_factura_inventario(r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento, r_factura1.caja);
    end loop;


    for r_cos_consumo in select cos_consumo.* from cos_trx, cos_consumo
                        where cos_trx.compania = cos_consumo.compania
                        and cos_trx.secuencia = cos_consumo.secuencia
                        and cos_trx.compania = as_cia
                        and cos_trx.fecha >= ld_fecha
                        and not exists
                            (select * from cos_consumo_eys2
                            where cos_consumo_eys2.compania = cos_consumo.compania
                            and cos_consumo_eys2.secuencia = cos_consumo.secuencia
                            and cos_consumo_eys2.linea = cos_consumo.linea)
                        order by cos_consumo.secuencia, cos_consumo.linea
    loop
        i = f_cos_consumo_eys2(r_cos_consumo.compania, r_cos_consumo.secuencia, r_cos_consumo.linea);
    end loop;

    
    for r_cos_produccion in select cos_produccion.* from cos_trx, cos_produccion
                        where cos_trx.compania = cos_produccion.compania
                        and cos_trx.secuencia = cos_produccion.secuencia
                        and cos_trx.compania = as_cia
                        and cos_trx.fecha >= ld_fecha
                        and not exists
                            (select * from cos_produccion_eys2
                            where cos_produccion_eys2.compania = cos_produccion.compania
                            and cos_produccion_eys2.secuencia = cos_produccion.secuencia
                            and cos_produccion_eys2.linea = cos_produccion.linea)
                        order by cos_produccion.secuencia, cos_produccion.linea
    loop
        i = f_cos_produccion_eys2(r_cos_produccion.compania, r_cos_produccion.secuencia, r_cos_produccion.linea);
    end loop;

    
/*
    for r_cos_trx in select cos_trx.* from cos_trx
                        where compania = as_cia
                        and fecha >= ld_fecha
                        order by fecha
    loop
        select into i f_costos_inventario_fifo(r_cos_trx.compania, r_cos_trx.secuencia);
    end loop;
*/
    
    return 1;
end;
' language plpgsql;





create function f_sec_inventario(char(2)) returns integer as '
declare
    as_almacen alias for $1;
    r_invparal record;
    r_work record;
    secuencia integer;
    ls_valor char(60);
begin
    select into r_invparal invparal.* from invparal
    where invparal.almacen = as_almacen
    and parametro = ''sec_eys''
    and aplicacion = ''INV'';
    if not found then
        secuencia := 0;
    else
        secuencia := to_number(r_invparal.valor, ''99G999D9S'');
    end if;
    
    loop
        secuencia := secuencia + 1;
        
        select into r_work * from eys1
        where eys1.almacen = as_almacen
        and eys1.no_transaccion = secuencia;
        if not found then
            exit;
        end if;
    end loop;
    
    ls_valor := trim(to_char(secuencia, ''99999999''));
    
    update invparal
    set valor = trim(ls_valor)
    where almacen = as_almacen
    and parametro = ''sec_eys''
    and aplicacion = ''INV'';
     
    return secuencia;
end;
' language plpgsql;



create function f_eys1_cglposteo(char(2), int4) returns integer as '
declare
    as_almacen alias for $1;
    ai_no_transaccion alias for $2;
    li_consecutivo int4;
    r_invmotivos record;
    r_eys1 record;
    r_articulos_por_almacen record;
    r_eys3 record;
    r_work record;
    r_cglcuentas record;
    ldc_monto decimal(20,2);
    ldc_work2 decimal(20,2);
    ldc_work3 decimal(20,2);
    ldc_sum_eys2 decimal(20,4);
    ldc_sum_eys3 decimal(20,4);
begin
    select into r_eys1 * from eys1
    where almacen = as_almacen
    and no_transaccion = ai_no_transaccion;
    if not found then
       return 0;
    end if;
    
    if r_eys1.aplicacion_origen = ''COM'' then
       return 0;
    end if;
    
    ldc_sum_eys2 = 0;
    ldc_sum_eys3 = 0;
    
    select into ldc_sum_eys2 sum(costo)
    from eys2
    where almacen = as_almacen
    and no_transaccion = ai_no_transaccion;
    
    select into ldc_sum_eys3 sum(monto)
    from eys3
    where almacen = as_almacen
    and no_transaccion = ai_no_transaccion;
    
    if ldc_sum_eys2 is null then
        ldc_sum_eys2 = 0;
    end if;
    
    if ldc_sum_eys3 is null then
        ldc_sum_eys3 = 0;
    end if;
    
    if ldc_sum_eys2 <> ldc_sum_eys3 then
        if trim(r_eys1.aplicacion_origen) = ''FAC'' then
            delete from eys1
            where almacen = as_almacen
            and no_transaccion = ai_no_transaccion;
            return 0;
        else
            Raise Exception ''Almacen % Transaccion % esta en desbalance'', as_almacen, ai_no_transaccion;
        end if;            
    end if;
  
    delete from rela_eys1_cglposteo
    where almacen = as_almacen
    and no_transaccion = ai_no_transaccion;
    
    
    select into r_invmotivos * from invmotivos
    where motivo = r_eys1.motivo;
/*
    if r_invmotivos.costo = ''N'' then
        return 0;
    end if;
*/    
    
    if r_eys1.aplicacion_origen = ''TAL'' and r_invmotivos.signo = 1 then
        return 0;
    end if;
    
    ldc_work2 = 0;
    for r_work in select almacen.compania, articulos_por_almacen.cuenta, sum(eys2.costo) as monto
                    from eys2, articulos_por_almacen, almacen
                    where eys2.almacen = almacen.almacen
                    and eys2.almacen = articulos_por_almacen.almacen
                    and eys2.articulo = articulos_por_almacen.articulo
                    and eys2.almacen = as_almacen
                    and eys2.no_transaccion = ai_no_transaccion
                    and eys2.costo <> 0
                    group by 1, 2
                    order by 1, 2
    loop
        if r_eys1.observacion is null then
           r_eys1.observacion := ''ALMACEN  '' || trim(r_eys1.almacen) || ''   TRANSACCION #  '' || ai_no_transaccion;
        else
           r_eys1.observacion := ''ALMACEN  '' || trim(r_eys1.almacen) || ''   TRANSACCION #  '' || ai_no_transaccion || ''  ''  || r_eys1.observacion;
        end if;
        ldc_monto = r_work.monto;
        ldc_work2 = ldc_work2 + ldc_monto;
        li_consecutivo := f_cglposteo(r_work.compania, r_eys1.aplicacion_origen, r_eys1.fecha, r_work.cuenta,
                            null, null, r_invmotivos.tipo_comp, trim(r_eys1.observacion), 
                            (ldc_monto*r_invmotivos.signo));
        if li_consecutivo > 0 then
           insert into rela_eys1_cglposteo (consecutivo, almacen, no_transaccion)
           values (li_consecutivo, as_almacen, ai_no_transaccion);
        end if;
    end loop;
    
    ldc_work3 = 0;
    for r_work in select almacen.compania, eys3.cuenta, eys3.auxiliar1, sum(eys3.monto) as monto
                    from eys3, almacen
                    where eys3.almacen = almacen.almacen
                    and eys3.almacen = as_almacen
                    and eys3.no_transaccion = ai_no_transaccion
                    and eys3.monto <> 0
                    group by 1, 2, 3
                    order by 1, 2, 3
    loop
        if r_eys1.observacion is null then
            r_eys1.observacion := ''   '';
        end if;
        ldc_work3 = ldc_work3 + r_work.monto;
        
        select into r_cglcuentas *
        from cglcuentas
        where trim(cuenta) = trim(r_work.cuenta);
        if not found then
            Raise Exception ''Almacen % Transaccion % Cuenta % No Existe...Verifique'', as_almacen, ai_no_transaccion, r_work.cuenta;
        else
            if r_cglcuentas.auxiliar_1 = ''S'' and r_work.auxiliar1 is null then 
                Raise Exception ''Almacen % Transaccion % Cuenta % Auxiliar no puede estar nulo...Verifique'', as_almacen, ai_no_transaccion, r_work.cuenta;
            end if;            
        end if;
        
        li_consecutivo := f_cglposteo(r_work.compania, r_eys1.aplicacion_origen, r_eys1.fecha, 
                            r_work.cuenta, r_work.auxiliar1, null, r_invmotivos.tipo_comp, 
                            trim(r_eys1.observacion), -(r_work.monto*r_invmotivos.signo));
        if li_consecutivo > 0 then
           insert into rela_eys1_cglposteo (consecutivo, almacen, no_transaccion)
           values (li_consecutivo, as_almacen, ai_no_transaccion);
        end if;
    end loop;

    
    if ldc_work2 <> ldc_work3 and ldc_work3 <> 0 then
        li_consecutivo := f_cglposteo(r_work.compania, r_eys1.aplicacion_origen, r_eys1.fecha, 
                            r_work.cuenta, r_work.auxiliar1, null, r_invmotivos.tipo_comp, 
                            trim(r_eys1.observacion), -(ldc_work2-ldc_work3)*r_invmotivos.signo);
        if li_consecutivo > 0 then
           insert into rela_eys1_cglposteo (consecutivo, almacen, no_transaccion)
           values (li_consecutivo, as_almacen, ai_no_transaccion);
        end if;
    end if;    
    
    return 1;
end;
' language plpgsql;



create function f_compras_inventario(char(2), char(6), char(25)) returns integer as '
declare
    as_compania alias for $1;
    as_proveedor alias for $2;
    as_fact_proveedor alias for $3;
    r_cxpfact1 record;
    r_eys1 record;
    r_eys2 record;
    r_eys6 record;
    r_work record;
    r_compra record;
    ldc_cu decimal(12,4);
begin
    select into r_cxpfact1 cxpfact1.* from cxpfact1
    where compania = as_compania
    and proveedor = as_proveedor
    and fact_proveedor = as_fact_proveedor
    and aplicacion_origen = ''COM'';
    if not found then
       return 0;
    end if;
    
    for r_eys2 in select eys2.* from eys2, articulos
                        where eys2.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and articulos.valorizacion in (''F'', ''L'')
                        and eys2.compania = as_compania
                        and eys2.proveedor = as_proveedor
                        and eys2.fact_proveedor = as_fact_proveedor
    loop
        delete from eys6
        where almacen = r_eys2.almacen
        and articulo = r_eys2.articulo
        and compra_no_transaccion = r_eys2.no_transaccion
        and compra_linea = r_eys2.linea;
        
        if r_eys2.cantidad >= 0 then
            insert into eys6 (articulo, almacen, no_transaccion, linea, compra_no_transaccion,
                compra_linea, cantidad)
            values (r_eys2.articulo, r_eys2.almacen, r_eys2.no_transaccion, r_eys2.linea,
                r_eys2.no_transaccion, r_eys2.linea, r_eys2.cantidad);
        else
            for r_work in select articulo, almacen, compra_no_transaccion, 
                            compra_linea, sum(cantidad) as cantidad from eys6
                          where articulo = r_eys2.articulo
                          and almacen = r_eys2.almacen
                          group by 1, 2, 3, 4
                          having sum(cantidad) > 0
            loop
                select into r_compra * from eys2
                where articulo = r_work.articulo
                and almacen = r_work.almacen
                and no_transaccion = r_work.compra_no_transaccion
                and linea = r_work.compra_linea;
                if found then
                    ldc_cu := r_compra.costo / r_compra.cantidad;
                    if ldc_cu = (r_eys2.costo / r_eys2.cantidad) then
                        insert into eys6 (articulo, almacen, no_transaccion, linea, 
                            compra_no_transaccion, compra_linea, cantidad)
                        values (r_eys2.articulo, r_eys2.almacen, r_eys2.no_transaccion, r_eys2.linea,
                            r_work.compra_no_transaccion, r_work.compra_linea, r_eys2.cantidad);
                    end if;
                end if;
            end loop;
        end if;                
    end loop;
        
    return 1;
end;
' language plpgsql;





create function f_update_existencias(char(2), char(15)) returns integer as '
declare
    as_almacen alias for $1;
    as_articulo alias for $2;
    ldc_existencia decimal(12,4);
    ldc_costo decimal(12,4);
begin

    ldc_existencia  = f_stock($1, $2, ''2300-01-01'', 0, 0, ''STOCK'');
    ldc_costo       = f_stock($1, $2, ''2300-01-01'', 0, 0, ''COSTO'');
    
    update articulos_por_almacen
    set existencia = ldc_existencia, costo = ldc_costo
    where articulos_por_almacen.almacen = $1
    and articulos_por_almacen.articulo = $2;
    
    return 1;
end;
' language plpgsql;


create function f_factura_inventario(char(2), char(3), integer, char(3)) returns integer as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    as_caja alias for $4;
    r_factmotivos record;
    r_factura1 record;
    r_factura2 record;
    r_factura2_eys2 record;
    r_eys1 record;
    r_eys2 record;
    r_work1 record;
    ldc_costo decimal(12,4);
    ldc_cantidad decimal(12,4);
    ldc_cu decimal(12,4);
    li_linea integer;
    ls_cuenta_costo char(24);
    ldc_sum_eys2 decimal(12,4);
    ldc_sum_eys3 decimal(12,4);
    i integer;
begin
--return 1;
/*
    update factura1
    set documento = trim(to_char(num_documento, ''9999999999999999'')), aplicacion = ''FAC''
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento;
*/


    
/*    
    
    delete from factura2_eys2
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = as_caja
    and num_documento = ai_num_documento;

    select into r_factura1 factura1.* from factura1, factmotivos
    where factura1.tipo = factmotivos.tipo
    and factura1.almacen = as_almacen
    and factura1.tipo = as_tipo
    and factura1.num_documento = ai_num_documento
    and (factmotivos.nota_credito = ''S''
    or factmotivos.cotizacion = ''S'' or factura1.status = ''A'');
    if found then
       return 0;
    end if;
*/
    
    select into r_factura1 *
    from factura1
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = as_caja
    and num_documento = ai_num_documento
    and status = ''A'';
    if found then
        return 0;
    end if;
    
    
    select into r_factmotivos factmotivos.* from factura1, factmotivos
    where factura1.tipo = factmotivos.tipo
    and factura1.almacen = as_almacen
    and factura1.tipo = as_tipo
    and factura1.caja = as_caja
    and factura1.num_documento = ai_num_documento;
    if not found then
        return 0;
    end if;


    if r_factmotivos.cotizacion = ''S'' then
        return 0;
    end if;
    
    if r_factmotivos.nota_credito = ''S'' and
        r_factmotivos.devolucion = ''N'' then
        return 0;
    end if;
        
    select into r_factura2 factura2.* from factura2, articulos 
    where factura2.articulo = articulos.articulo
    and articulos.servicio = ''N''
    and factura2.almacen = as_almacen 
    and factura2.tipo = as_tipo 
    and factura2.caja = as_caja
    and factura2.num_documento = ai_num_documento;
    if not found then
        return 0;
    end if;

/*    
    select into r_factura2_eys2 factura2_eys2.* from factura2_eys2, eys1
    where factura2_eys2.almacen = eys1.almacen
    and factura2_eys2.no_transaccion = eys1.no_transaccion
    and factura2_eys2.almacen = as_almacen
    and factura2_eys2.tipo = as_tipo
    and factura2_eys2.num_documento = ai_num_documento
    and eys1.status = ''P'';
    if found then
       return 0;
    end if;
*/
    
    select into r_factura1 * from factura1
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = as_caja
    and num_documento = ai_num_documento;
    
    if r_factura1.status = ''A'' or r_factura1.despachar = ''N'' or r_factura1.fecha_despacho is null then
       return 0;
    end if;
    
    if r_factura1.aplicacion = ''TAL'' then
        return 0;
    end if;
    
    select into r_factmotivos * from factmotivos
    where tipo = as_tipo;

    for r_factura2 in select factura2.* from factura2, articulos 
                        where factura2.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and factura2.almacen = as_almacen 
                        and factura2.tipo = as_tipo 
                        and factura2.caja = as_caja
                        and factura2.num_documento = ai_num_documento
    loop
        i = f_factura2_eys2(r_factura2.almacen, r_factura2.tipo, r_factura2.num_documento, r_factura2.caja, r_factura2.linea);
    end  loop;
        
    return 1;
end;
' language plpgsql;



create function f_stock(char(2), char(15), date, int4, int4, text) returns decimal(12,4) as '
declare
    as_almacen alias for $1;
    as_articulo alias for $2;
    ad_fecha alias for $3;
    ai_no_transaccion alias for $4;
    ai_linea alias for $5;
    as_retornar alias for $6;
    stock decimal(12,4);
    ld_ultimo_cierre date;
    ld_work date;
    r_articulos record;
    r_articulos_por_almacen record;
    r_work record;
    r_eys2 record;
    r_almacen record;
    li_year integer;
    li_periodo integer;
    ldc_existencia1 decimal(12,4);
    ldc_existencia2 decimal(12,4);
    ldc_costo1 decimal(12,4);
    ldc_costo2 decimal(12,4);
    ldc_retornar decimal;
    ldc_costo decimal;
    ldc_cantidad decimal;
    ldc_cu decimal;
begin
    select into r_almacen *
    from almacen
    where trim(almacen) = trim(as_almacen);
    if not found then
        Raise Exception ''Almacen % no Existe...Verifique'', as_almacen;
    end if;
    
    if trim(f_gralparaxcia(r_almacen.compania,''PLA'',''metodo_calculo'')) <> ''harinas'' then
        if trim(as_retornar) = ''COSTO'' then
            ldc_costo   =   0;
            select sum(costo) into ldc_costo
            from v_eys1_eys2
            where almacen = as_almacen
            and articulo = as_articulo
            and fecha <= ad_fecha;
            if ldc_costo is null then
                ldc_costo = 0;
            end if;
            return ldc_costo;
        
        elsif trim(as_retornar) = ''CU'' then
            ldc_cantidad    =   0;
            ldc_costo       =   0;
            select sum(cantidad) into ldc_cantidad
            from v_eys1_eys2
            where almacen = as_almacen
            and articulo = as_articulo
            and fecha <= ad_fecha;
            if ldc_cantidad is null then
                ldc_cantidad = 0;
            end if;

            if ldc_cantidad <= 0 then
                return f_ultimo_costo_unitario(as_almacen, as_articulo, ad_fecha);
            end if;
        
            select sum(costo) into ldc_costo
            from v_eys1_eys2
            where almacen = as_almacen
            and articulo = as_articulo
            and fecha <= ad_fecha;
            if ldc_costo is null then
                ldc_costo = 0;
            end if;

            ldc_cu  =   ldc_costo / ldc_cantidad;
            
            if ldc_cu < 0 then
                ldc_cu  = f_ultimo_costo_unitario(as_almacen, as_articulo, ad_fecha);
            end if;
            
            return ldc_cu;
    
        else
            ldc_cantidad    =   0;
            select sum(cantidad) into ldc_cantidad
            from v_eys1_eys2
            where almacen = as_almacen
            and articulo = as_articulo
            and fecha <= ad_fecha;
            if ldc_cantidad is null then
                ldc_cantidad = 0;
            end if;

            return ldc_cantidad;
    
        end if;
    end if;
    
    
    stock           = 0;
    ldc_retornar    = 0;
    select into r_articulos * from articulos
    where articulos.articulo = as_articulo;
    if r_articulos.servicio = ''S'' then
       return 0;
    end if;
    
    select into r_articulos_por_almacen * from articulos_por_almacen
    where trim(almacen) = trim(as_almacen)
    and trim(articulo) = trim(as_articulo);
    if not found then
        return 0;
    end if;
    ldc_cu = 0;    
    
    if trim(as_retornar) = ''CU'' and r_articulos.valorizacion = ''U'' then
        return f_ultimo_costo_unitario(as_almacen, as_articulo, ad_fecha);
/*        
        select Max(fecha) into ld_ultimo_cierre from eys1, eys2
        where eys1.almacen = eys2.almacen
        and eys1.no_transaccion = eys2.no_transaccion
        and eys2.almacen = as_almacen
        and eys2.articulo = as_articulo
        and eys1.aplicacion_origen = ''COM''
        and eys2.cantidad > 0
        and eys1.fecha <= ad_fecha;
        if ld_ultimo_cierre is not null then
            select (sum(eys2.costo)/sum(eys2.cantidad)) into ldc_cu
            from eys1, eys2
            where eys1.almacen = eys2.almacen
            and eys1.no_transaccion = eys2.no_transaccion
            and eys2.almacen = as_almacen
            and eys2.articulo = as_articulo
            and eys1.aplicacion_origen = ''COM''
            and eys2.cantidad > 0
            and eys2.costo is not null
            and eys2.cantidad is not null
            and eys1.fecha = ld_ultimo_cierre;
            if found then
                return ldc_cu;
            end if;
        end if;
*/        
    end if;

        
    select Max(final) into ld_ultimo_cierre from gralperiodos, almacen
    where almacen.compania = gralperiodos.compania
    and almacen.almacen = as_almacen
    and aplicacion = ''INV'' 
    and estado = ''I''
    and final < ad_fecha;
    if not found or ld_ultimo_cierre is null then
        select Min(inicio) into ld_ultimo_cierre from gralperiodos,almacen
        where almacen.compania = gralperiodos.compania
        and gralperiodos.aplicacion = ''INV''
        and almacen.almacen = as_almacen;
        if not found then
            raise exception ''Inventario no tiene periodos definidos...Verifique'';
        end if;            
    else
        select year into li_year from gralperiodos, almacen
        where gralperiodos.compania = almacen.compania
        and almacen.almacen = as_almacen
        and aplicacion = ''INV''
        and estado = ''I''
        and final = ld_ultimo_cierre;

        select periodo into li_periodo from gralperiodos, almacen
        where gralperiodos.compania = almacen.compania
        and almacen.almacen = as_almacen
        and aplicacion = ''INV''
        and estado = ''I''
        and final = ld_ultimo_cierre;
    end if;
    
    
    select existencia, costo into ldc_existencia1, ldc_costo1 
    from invbalance
    where almacen = as_almacen
    and Trim(articulo) = Trim(as_articulo)
    and year = li_year
    and periodo = li_periodo;
    if ldc_existencia1 is null then
        ldc_existencia1 := 0;
    end if;

/*
    ldc_cu = ldc_costo1 / ldc_existencia1;
    raise exception ''existencia % costo % year % periodo %'',ldc_existencia1, ldc_cu,li_year, li_periodo;
*/
    
    if ldc_costo1 is null then
        ldc_costo1 := 0;
    end if;
    
    if ai_no_transaccion > 0 then
        select sum(eys2.cantidad * invmotivos.signo), sum(eys2.costo * invmotivos.signo) 
        into ldc_existencia2, ldc_costo2 from eys1, eys2, invmotivos
        where eys1.almacen = eys2.almacen
        and eys1.no_transaccion = eys2.no_transaccion
		and eys1.motivo = invmotivos.motivo
		and eys2.almacen = as_almacen
		and eys2.articulo = as_articulo
		and ((eys1.fecha > ld_ultimo_cierre
		and eys1.fecha < ad_fecha)
		or (eys1.fecha = ad_fecha
		and eys1.no_transaccion < ai_no_transaccion));
    else
    /*
        select sum(eys2.cantidad * invmotivos.signo), sum(eys2.costo * invmotivos.signo) 
        into ldc_existencia2, ldc_costo2 from eys1, eys2, invmotivos
        where eys1.almacen = eys2.almacen
        and eys1.no_transaccion = eys2.no_transaccion
        and eys1.motivo = invmotivos.motivo
        and eys1.almacen = as_almacen
        and eys2.articulo = as_articulo
        and eys1.fecha > ld_ultimo_cierre
        and eys1.fecha <= ad_fecha;
*/
        select sum(cantidad), sum(costo) into ldc_existencia2, ldc_costo2
        from v_eys1_eys2
        where almacen = as_almacen
        and articulo = as_articulo
        and fecha > ld_ultimo_cierre
        and fecha <= ad_fecha;        
    end if;

    
    if ldc_existencia2 is null then
        ldc_existencia2 := 0;
    end if;
    
    if ldc_costo2 is null then
        ldc_costo2 := 0;
    end if;
    ldc_retornar := 0;
    
    if r_articulos.valorizacion = ''F'' or r_articulos.valorizacion = ''L'' then
        return 0;
        ldc_cantidad = 0;
        ldc_costo = 0;
        for r_work in select eys6.almacen, eys6.compra_no_transaccion, eys6.compra_linea,
                                eys6.articulo, sum(eys6.cantidad) as cantidad
                        from eys6
                        where eys6.almacen = as_almacen
                        and eys6.articulo = as_articulo
                        and exists
                        (select * from eys1 
                            where almacen = eys6.almacen 
                            and no_transaccion = eys6.no_transaccion 
                            and fecha <= ad_fecha) 
                    GROUP BY 1, 2, 3, 4
                    having sum(eys6.cantidad) <> 0
                    ORDER BY 1, 2        
        loop
            select into r_eys2 *
            from eys2
            where almacen = r_work.almacen
            and no_transaccion = r_work.compra_no_transaccion
            and linea = r_work.compra_linea
            and articulo = r_work.articulo
            and cantidad <> 0;
            if found then
                ldc_cantidad = ldc_cantidad + r_work.cantidad;
                ldc_costo = ldc_costo + (r_work.cantidad * (r_eys2.costo/r_eys2.cantidad));
            end if;
        end loop;
        
        if as_retornar = ''COSTO'' then
            return ldc_costo;
            
        elsif as_retornar = ''CU'' then
                if ldc_cantidad <> 0 then
                    ldc_cu  =   ldc_costo / ldc_cantidad;
                    if ldc_cu > 0 then
                        return ldc_cu;
                    else
                        return f_ultimo_costo_unitario(as_almacen, as_articulo, ad_fecha);
                    end if;
                else
                    return f_ultimo_costo_unitario(as_almacen, as_articulo, ad_fecha);
                end if;
        else
            return ldc_cantidad;
        end if;
    end if;

    
    if as_retornar = ''CU'' then
       if r_articulos.valorizacion = ''F'' or r_articulos.valorizacion = ''L'' then
          ldc_retornar := 0;
       elsif r_articulos.valorizacion = ''U'' then
            ldc_retornar = 0;
       else
        ldc_retornar := ldc_existencia1 + ldc_existencia2;
        if ldc_retornar <= 0 or (ldc_costo1 + ldc_costo2) <= 0 then
            ldc_cu  = f_ultimo_costo_unitario(as_almacen, as_articulo, ad_fecha);
            if ldc_cu <= 0 then
                ld_work = ''2300-01-01'';
                ldc_cu  = f_ultimo_costo_unitario(as_almacen, as_articulo, ld_work);
            end if;
            return ldc_cu;
        end if;

        ldc_retornar := (ldc_costo1 + ldc_costo2) / ldc_retornar;
        if ldc_retornar < 0 or (ldc_costo1 + ldc_costo2) < 0 then
            ldc_cu  = f_ultimo_costo_unitario(as_almacen, as_articulo, ad_fecha);
            if ldc_cu <= 0 then
                ld_work = ''2300-01-01'';
                ldc_cu  = f_ultimo_costo_unitario(as_almacen, as_articulo, ld_work);
            end if;
            ldc_retornar = ldc_cu;
         end if;
         return ldc_retornar;
      end if;
    else
        if as_retornar = ''COSTO'' then
            ldc_retornar := ldc_costo1 + ldc_costo2;
        else
            ldc_retornar := ldc_existencia1 + ldc_existencia2;
        end if;
    end if;
    
    if ldc_retornar is null then
        ldc_retornar = 0;
    end if;
    return ldc_retornar;
end;
' language plpgsql;




/*
create function f_eys1_poner_cuentas(char(2), int4) returns integer as '
declare
    as_almacen alias for $1;
    ai_no_transaccion alias for $2;
    r_work record;
    r_facparamcgl record;
    r_eys3 record;
    li_work integer;
    ldc_sum_eys2 decimal;
    ldc_sum_eys3 decimal;
    ldc_work decimal;
begin
    delete from eys3
    where almacen = as_almacen
    and no_transaccion = ai_no_transaccion;
    
    for r_work in select articulo, sum(eys2.costo) as monto from eys2
                    where eys2.almacen = as_almacen
                    and eys2.no_transaccion = ai_no_transaccion
                    group by 1
                    order by 1
    loop
    
        select into r_facparamcgl * from articulos_agrupados, facparamcgl
        where articulos_agrupados.codigo_valor_grupo = facparamcgl.codigo_valor_grupo
        and articulos_agrupados.articulo = r_work.articulo
        and facparamcgl.almacen = as_almacen;
        if not found then
           raise exception ''Articulo % no tiene definido parametros contables'',r_work.articulo;
        end if;
        
        select into r_eys3 * from eys3
        where almacen = as_almacen
        and no_transaccion = ai_no_transaccion
        and cuenta = r_facparamcgl.cuenta_costo;
        if not found then
           insert into eys3 (almacen, no_transaccion, cuenta, monto)
           values (as_almacen, ai_no_transaccion, r_facparamcgl.cuenta_costo, r_work.monto);
        else
           update eys3
           set monto = monto + r_work.monto
           where almacen = as_almacen
           and no_transaccion = ai_no_transaccion
           and cuenta = r_facparamcgl.cuenta_costo;
        end if;
    end loop;

    ldc_sum_eys2 = 0;
    ldc_sum_eys3 = 0;
        
    select sum(costo) into ldc_sum_eys2
    from eys2
    where almacen = as_almacen
    and no_transaccion = ai_no_transaccion;

    select sum(monto) into ldc_sum_eys3
    from eys3
    where almacen = as_almacen
    and no_transaccion = ai_no_transaccion;
    
    if ldc_sum_eys2 is null then
        ldc_sum_eys2 = 0;
    end if;
    
    if ldc_sum_eys3 is null then
        ldc_sum_eys3 = 0;
    end if;
    
    ldc_work    =   ldc_sum_eys2 - ldc_sum_eys3;
    
    if ldc_work <> 0 then
       update eys3
       set monto = monto + ldc_work
       where almacen = as_almacen
       and no_transaccion = ai_no_transaccion
       and cuenta = r_facparamcgl.cuenta_costo;
    end if;
    
    return 1;
end;
' language plpgsql;
*/
