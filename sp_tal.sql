drop function f_taller_inventario_fifo(character, character, integer);
drop function f_ot_itbm(character, character, int4) cascade;
drop function f_tal_ot2_inventario(char(2), int, char(1), int, char(15));


create function f_ot_itbm(char(2), char(1), int4) returns decimal as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_no_orden alias for $3;
    r_tal_ot1 record;
    r_work record;
    r_clientes_exentos record;
    ldc_impuesto decimal(10,2);
begin

    ldc_impuesto = 0;
    
    select into r_tal_ot1 * from tal_ot1
    where tal_ot1.almacen = as_almacen
    and tal_ot1.tipo = as_tipo
    and tal_ot1.no_orden = ai_no_orden;
    
    
    select into r_clientes_exentos * from clientes_exentos
    where cliente = r_tal_ot1.cliente;
    if found then
        return 0;
    end if;
    
    
    for r_work in select tal_ot2.articulo, extension from tal_ot2, articulos_agrupados
                    where tal_ot2.articulo = articulos_agrupados.articulo 
                    and articulos_agrupados.codigo_valor_grupo = ''SI''
                    and tal_ot2.almacen = as_almacen
                    and tal_ot2.tipo = as_tipo
                    and tal_ot2.no_orden = ai_no_orden
                    order by articulo
    loop
        ldc_impuesto = ldc_impuesto + (r_work.extension*.05);
    end loop;
    
    for r_work in select tal_servicios.articulo, sum(extension) as extension from tal_ot3, tal_servicios
                    where tal_ot3.almacen = as_almacen
                    and tal_ot3.tipo = as_tipo
                    and tal_ot3.no_orden = ai_no_orden
                    and tal_ot3.servicio = tal_servicios.servicio
                    group by tal_servicios.articulo
                    order by tal_servicios.articulo
    loop
        ldc_impuesto = ldc_impuesto + (r_work.extension*.05);
    end loop;
    
    return ldc_impuesto;
end;
' LANGUAGE plpgsql;



CREATE FUNCTION f_taller_inventario_fifo(character, character, integer) returns integer as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_no_orden alias for $3;
    r_tal_ot2_eys2 record;
    r_eys6 record;
    r_eys2 record;
    r_articulos record;
    i integer;
    ldc_costo decimal(12,2);
begin
    for r_tal_ot2_eys2 in select tal_ot2_eys2.* from tal_ot2_eys2, articulos 
                        where tal_ot2_eys2.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and articulos.valorizacion in (''F'',''L'')
                        and tal_ot2_eys2.almacen = as_almacen
                        and tal_ot2_eys2.tipo = as_tipo
                        and tal_ot2_eys2.no_orden = ai_no_orden
    loop
        ldc_costo := 0;
        for r_eys6 in select * from eys6
                        where articulo = r_tal_ot2_eys2.articulo
                        and almacen = r_tal_ot2_eys2.almacen
                        and no_transaccion = r_tal_ot2_eys2.no_transaccion
                        and linea = r_tal_ot2_eys2.linea_eys2
        loop
            select into r_eys2 * from eys2
            where articulo = r_eys6.articulo
            and almacen = r_eys6.almacen
            and no_transaccion = r_eys6.compra_no_transaccion
            and linea = r_eys6.compra_linea;
            if found then
                ldc_costo := ldc_costo + ((r_eys2.costo / r_eys2.cantidad) * -r_eys6.cantidad);
            end if;
        end loop;
        
        update eys2
        set costo = ldc_costo
        where articulo = r_tal_ot2_eys2.articulo
        and almacen = r_tal_ot2_eys2.almacen
        and no_transaccion = r_tal_ot2_eys2.no_transaccion
        and linea = r_tal_ot2_eys2.linea_eys2;
              
    end loop;
    
    return 1;
end;
' LANGUAGE plpgsql;



create function f_tal_ot2_inventario(char(2), int, char(1), int, char(15)) returns integer as '
declare
    as_almacen alias for $1;
    ai_no_orden alias for $2;
    as_tipo alias for $3;
    ai_linea alias for $4;
    as_articulo alias for $5;
    r_factmotivos record;
    r_tal_ot2 record;
    r_tal_ot1 record;
    r_clientes record;
    r_almacen record;
    r_oc2 record;
    r_eys1 record;
    r_cglcuentas record;
    ldc_cu decimal;
    ldc_stock decimal;
    ldc_sum_eys2 decimal;
    ldc_sum_eys3 decimal;
    li_linea integer;
    ls_cuenta_costo char(24);
begin
    select into r_tal_ot1 * from tal_ot1
    where almacen = as_almacen
    and tipo = as_tipo
    and no_orden = ai_no_orden;
    if r_tal_ot1.fecha <= ''2005-06-30'' then
        return 0;
    end if;
    
    select into r_almacen * from almacen
    where almacen = as_almacen;
        
    delete from tal_ot2_eys2
    where no_orden = ai_no_orden
    and tipo = as_tipo
    and almacen = as_almacen
    and linea_tal_ot2 = ai_linea
    and articulo = as_articulo;

/*    
    delete from eys1
    where aplicacion_origen = ''TAL''
    and not exists
        (select * from eys2
            where eys2.almacen = eys1.almacen
            and eys2.no_transaccion = eys1.no_transaccion);
*/            
    
    select into r_tal_ot2 * from tal_ot2
    where no_orden = ai_no_orden
    and tipo = as_tipo
    and almacen = as_almacen
    and linea = ai_linea
    and trim(articulo) = trim(as_articulo);
    
    if r_tal_ot2.despachar = ''N'' then
        return 0;
    end if;

    if r_tal_ot2.fecha_despacho is null then
        return 0;
    end if;
    
    select into r_factmotivos * from factmotivos
    where factura = ''S'';
    
    select into r_eys1 eys1.* from eys1
    where eys1.almacen = as_almacen
    and eys1.motivo = r_factmotivos.motivo
    and eys1.aplicacion_origen = ''TAL''
    and eys1.fecha = r_tal_ot2.fecha_despacho;
    if not found then
       r_eys1.almacen             :=  as_almacen;
       r_eys1.no_transaccion      :=  f_sec_inventario(as_almacen); 
       r_eys1.motivo              :=  r_factmotivos.motivo;
       r_eys1.aplicacion_origen   :=  ''TAL'';
       r_eys1.usuario             :=  current_user;
       r_eys1.fecha_captura       :=  current_timestamp;
       r_eys1.status              :=  ''R'';
       r_eys1.fecha               :=  r_tal_ot2.fecha_despacho;
       
        INSERT INTO eys1 ( almacen, no_transaccion, motivo, aplicacion_origen, 
        fecha, usuario, fecha_captura, status ) 
        VALUES ( r_eys1.almacen, r_eys1.no_transaccion, r_eys1.motivo, ''TAL'', 
        r_eys1.fecha, current_user, current_timestamp, ''R'');

    end if;
    

    select into r_oc2 * from oc2
    where almacen = r_tal_ot2.almacen
    and no_orden = r_tal_ot2.no_orden
    and tipo = r_tal_ot2.tipo
    and linea = r_tal_ot2.linea
    and articulo = r_tal_ot2.articulo;
    if not found then
        ldc_cu  :=  f_stock(r_tal_ot2.almacen, r_tal_ot2.articulo, r_tal_ot2.fecha_despacho, 0, 0, ''CU'');
    else
        ldc_cu  :=  (r_oc2.costo-r_oc2.descuento) / r_oc2.cantidad;
    end if;
        
    select into li_linea max(eys2.linea) from eys2
    where almacen = r_eys1.almacen
    and no_transaccion = r_eys1.no_transaccion;
    if li_linea is null then
        li_linea := 1;
    else
        li_linea := li_linea + 1;
    end if;
    
    if ldc_cu is null then
        raise exception ''Costo de Articulo % en la Orden % no puede ser nulo'', r_tal_ot2.articulo, r_tal_ot2.no_orden;
    end if;
    
    INSERT INTO eys2 ( articulo, almacen, no_transaccion, linea, cantidad, costo ) 
    VALUES (r_tal_ot2.articulo, r_tal_ot2.almacen, r_eys1.no_transaccion,
    li_linea, r_tal_ot2.cantidad, (ldc_cu * r_tal_ot2.cantidad));
    
    insert into tal_ot2_eys2 (no_orden, tipo, almacen, linea_tal_ot2, articulo,
        no_transaccion, linea_eys2)
    values (r_tal_ot2.no_orden, r_tal_ot2.tipo, r_tal_ot2.almacen, r_tal_ot2.linea,
        r_tal_ot2.articulo, r_eys1.no_transaccion, li_linea);
        
        
    if trim(f_gralparaxcia(r_almacen.compania, ''FAC'', ''clte_interno'')) = trim(r_tal_ot1.cliente) then
        select into ls_cuenta_costo fac_parametros_contables.cta_de_gasto
        from articulos_agrupados, fac_parametros_contables
        where articulos_agrupados.codigo_valor_grupo = fac_parametros_contables.codigo_valor_grupo
        and articulos_agrupados.articulo = r_tal_ot2.articulo
        and fac_parametros_contables.almacen = r_tal_ot2.almacen
        and fac_parametros_contables.referencia = ''1'';
        if Not Found or ls_cuenta_costo is null then
            raise exception ''No existe cuenta de gasto para el articulo % en la orden %'', r_tal_ot2.articulo, r_tal_ot2.no_orden;
        end if;                
    else
        if Trim(f_gralparaxcia(r_almacen.compania, ''INV'', ''inv_en_proceso'')) = ''S'' then
            ls_cuenta_costo = f_gralparaxcia(r_almacen.compania, ''INV'', ''cta_inv_en_proceso'');
        else        
            select into ls_cuenta_costo fac_parametros_contables.cta_de_costo
            from articulos_agrupados, fac_parametros_contables
            where articulos_agrupados.codigo_valor_grupo = fac_parametros_contables.codigo_valor_grupo
            and articulos_agrupados.articulo = r_tal_ot2.articulo
            and fac_parametros_contables.almacen = r_tal_ot2.almacen
            and fac_parametros_contables.referencia = r_tal_ot1.referencia;
            if Not Found or ls_cuenta_costo is null then
                raise exception ''No existe cuenta de costo para el articulo % en la orden %'', r_tal_ot2.articulo, r_tal_ot2.no_orden;
            end if;                
        end if;
        
        select into r_cglcuentas * from cglcuentas
        where trim(cuenta) = trim(ls_cuenta_costo);
        if not found then
            raise exception ''El valor de parametro cta_inv_en_proceso % no existe en el mayor'', ls_cuenta_costo;
        end if;
    end if;


    
    delete from eys3
    where almacen = r_eys1.almacen
    and no_transaccion = r_eys1.no_transaccion
    and cuenta = ls_cuenta_costo;
    
    select into ldc_sum_eys2 sum(costo) from eys2
    where almacen = r_eys1.almacen
    and no_transaccion = r_eys1.no_transaccion;
    if ldc_sum_eys2 is null then
        ldc_sum_eys2 := 0;
    end if;
    
    select into ldc_sum_eys3 sum(monto) from eys3
    where almacen = r_eys1.almacen
    and no_transaccion = r_eys1.no_transaccion;
    if ldc_sum_eys3 is null then
        ldc_sum_eys3 := 0;
    end if;

    INSERT INTO eys3 ( almacen, no_transaccion, cuenta, auxiliar1, auxiliar2, monto ) 
    VALUES ( r_eys1.almacen, r_eys1.no_transaccion, ls_cuenta_costo, null, null,
        (ldc_sum_eys2-ldc_sum_eys3));
    
        
    return 1;
end;
' language plpgsql;



/*
create function f_stock(char(2), char(15), date, int4, int4, text) returns decimal(12,4) as '
declare
    as_almacen alias for $1;
    as_articulo alias for $2;
    ad_fecha alias for $3;
    ai_no_transaccion alias for $4;
    ai_linea alias for $5;
    as_retornar alias for $6;
    ld_ultimo_cierre date;
    r_articulos record;
    r_eys2 record;
    ldc_existencia decimal(12,4);
    ldc_retornar decimal(12,4);
    ldc_costo decimal(12,4);
begin
    select into r_articulos * from articulos
    where articulos.articulo = as_articulo;
    if r_articulos.servicio = ''S'' then
       return 0;
    end if;

    ldc_existencia := 0;
    ldc_costo := 0;
    ldc_retornar := 0;

    
    if ai_no_transaccion > 0 then
        select sum(eys2.cantidad * invmotivos.signo), sum(eys2.costo * invmotivos.signo) 
        into ldc_existencia, ldc_costo from eys1, eys2, invmotivos
        where eys1.almacen = eys2.almacen
        and eys1.no_transaccion = eys2.no_transaccion
		and eys1.motivo = invmotivos.motivo
		and eys2.almacen = as_almacen
		and eys2.articulo = as_articulo
		and (eys1.fecha < ad_fecha
		or (eys1.fecha = ad_fecha
		and eys1.no_transaccion < ai_no_transaccion));
    else
        select sum(eys2.cantidad * invmotivos.signo), sum(eys2.costo * invmotivos.signo) 
        into ldc_existencia, ldc_costo from eys1, eys2, invmotivos
        where eys1.almacen = eys2.almacen
        and eys1.no_transaccion = eys2.no_transaccion
        and eys1.motivo = invmotivos.motivo
        and eys1.almacen = as_almacen
        and eys2.articulo = as_articulo
        and eys1.fecha <= ad_fecha;
    end if;
    
    if ldc_existencia is null then
        ldc_existencia := 0;
    end if;
    
    if ldc_costo is null then
        ldc_costo := 0;
    end if;
    
        
    ldc_retornar := 0;
    if as_retornar = ''CU'' then
        if ldc_existencia <> 0 then
            ldc_retornar := ldc_costo / ldc_existencia;
        end if;
    else
        if as_retornar = ''COSTO'' then
            ldc_retornar := ldc_costo;
        else
            ldc_retornar := ldc_existencia;
        end if;
    end if;
    
    return ldc_retornar;
end;
' language plpgsql;
*/
