
drop function f_factura2_eys2(char(2), char(3), int4, char(3), int4) cascade;

create function f_factura2_eys2(char(2), char(3), int4, char(3), int4) returns integer as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    as_caja alias for $4;
    ai_linea alias for $5;
    r_factmotivos record;
    r_factura1 record;
    r_factura2 record;
    r_eys1 record;
    r_eys2 record;
    r_eys3 record;
    r_work1 record;
    r_articulos record;
    ldc_costo decimal(12,4);
    ldc_cantidad decimal(12,4);
    ldc_cu decimal(12,4);
    li_linea integer;
    ls_cuenta_costo char(24);
    ldc_sum_eys2 decimal(12,4);
    ldc_sum_eys3 decimal(12,4);
    ldc_work decimal(12,4);
begin
    ldc_cu = 0;    

    
    delete from factura2_eys2
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and factura2_linea = ai_linea
    and caja = as_caja;
    
    
    select into r_factura2 * from factura2
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and linea = ai_linea
    and caja = as_caja;
    if not found then
        return 0;
    end if;

        
    select into r_articulos * from articulos
    where articulo =  r_factura2.articulo
    and servicio = ''S'';
    if found then
        return 0;
    end if;
   
    
    select into r_factura1 factura1.* from factura1, factmotivos
    where factura1.tipo = factmotivos.tipo
    and factura1.almacen = as_almacen
    and factura1.tipo = as_tipo
    and factura1.num_documento = ai_num_documento
    and factura1.caja = as_caja
    and (factmotivos.nota_credito = ''S'' 
    or factmotivos.cotizacion = ''S'' or factura1.status = ''A'');
    if found then
       return 0;
    end if;
    
    select into r_factura1 * from factura1
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and caja = as_caja;
    
    if r_factura1.status = ''A'' or r_factura1.despachar = ''N'' or r_factura1.fecha_despacho is null then
       return 0;
    end if;
    
    if r_factura1.aplicacion = ''TAL'' then
        return 0;
    end if;
    
    select into r_factmotivos * from factmotivos
    where tipo = as_tipo;

    
    select into r_eys1 eys1.* from eys1
    where eys1.almacen = as_almacen
    and eys1.motivo = r_factmotivos.motivo
    and eys1.aplicacion_origen = ''FAC''
    and eys1.fecha = r_factura1.fecha_despacho;
    if not found then
       r_eys1.no_transaccion      =  f_sec_inventario(as_almacen); 
       insert into eys1 (almacen, no_transaccion, motivo, aplicacion_origen, 
        fecha, usuario, fecha_captura, status) 
       values (as_almacen, r_eys1.no_transaccion, r_factmotivos.motivo,
        ''FAC'', r_factura1.fecha_despacho, current_user, current_timestamp, ''R'');
    end if;
    
    if r_factmotivos.devolucion = ''S'' then
        select into ldc_cu eys2.costo/eys2.cantidad
        from factura2, factura2_eys2, eys2
        where factura2.almacen = factura2_eys2.almacen
        and factura2.tipo = factura2_eys2.tipo
        and factura2.num_documento = factura2_eys2.num_documento
        and factura2.linea = factura2_eys2.factura2_linea
        and factura2_eys2.articulo = eys2.articulo
        and factura2_eys2.almacen = eys2.almacen
        and factura2_eys2.no_transaccion = eys2.no_transaccion
        and factura2_eys2.eys2_linea = eys2.linea
        and factura2.almacen = r_factura2.almacen
        and factura2.articulo = r_factura2.articulo
        and factura2.caja = r_factura1.caja
        and factura2.num_documento = r_factura1.num_factura;
        if not found then
            ldc_cu  =  f_stock(r_factura2.almacen, r_factura2.articulo, r_factura1.fecha_despacho, 0, 0, ''CU'');
        end if;
    else
          ldc_cu  =   f_stock(r_factura2.almacen, r_factura2.articulo,r_factura1.fecha_despacho, 0, 0, ''CU'');
    end if;
    
    
    select into li_linea max(eys2.linea) from eys2
    where almacen = as_almacen
    and no_transaccion = r_eys1.no_transaccion;
    if li_linea is null then
        li_linea = 1;
    else
        li_linea = li_linea + 1;
    end if;
    
    if ldc_cu is null then
        raise exception ''costo unitario no puede ser nulo...documento %'', ai_num_documento;
    end if;
    
    
    select into ls_cuenta_costo facparamcgl.cuenta_costo
    from articulos_por_almacen, articulos_agrupados, facparamcgl
    where articulos_por_almacen.articulo = articulos_agrupados.articulo
    and articulos_agrupados.codigo_valor_grupo = facparamcgl.codigo_valor_grupo
    and articulos_por_almacen.almacen = facparamcgl.almacen
    and articulos_por_almacen.almacen = r_factura2.almacen
    and articulos_por_almacen.articulo = r_factura2.articulo;
    if ls_cuenta_costo is null or not found then
        select into ls_cuenta_costo fac_parametros_contables.cta_de_costo
        from articulos_agrupados, fac_parametros_contables
        where articulos_agrupados.codigo_valor_grupo = fac_parametros_contables.codigo_valor_grupo
        and articulos_agrupados.articulo = r_factura2.articulo
        and fac_parametros_contables.almacen = r_factura2.almacen
        and fac_parametros_contables.referencia = r_factura1.referencia;
        if Not Found or ls_cuenta_costo is null then
            raise exception ''No existe cuenta de costo para el articulo % en la factura %'', r_factura2.articulo, r_factura2.num_documento;
        end if;                
    end if;

/*
if trim(ls_cuenta_costo) = ''6150100'' then
    raise exception ''entre'';
end if;
*/
    
    INSERT INTO eys2 ( articulo, almacen, no_transaccion, linea, cantidad, costo, cuenta ) 
    VALUES (r_factura2.articulo, r_factura2.almacen, r_eys1.no_transaccion,
    li_linea, r_factura2.cantidad, (ldc_cu * r_factura2.cantidad), ls_cuenta_costo);

    
    insert into factura2_eys2 (articulo, almacen, no_transaccion, eys2_linea,
    tipo, num_documento, factura2_linea, caja)
    values (r_factura2.articulo, r_factura2.almacen, r_eys1.no_transaccion,
    li_linea, r_factura2.tipo, r_factura2.num_documento, r_factura2.linea, as_caja);
    
    
    delete from eys3
    where trim(almacen) = trim(as_almacen)
    and no_transaccion = r_eys1.no_transaccion
    and trim(cuenta) = trim(ls_cuenta_costo);
    
    
    select into ldc_sum_eys2 sum(costo) from eys2
    where trim(almacen) = trim(r_factura2.almacen)
    and no_transaccion = r_eys1.no_transaccion;
    if ldc_sum_eys2 is null then
        ldc_sum_eys2 = 0;
    end if;
    
    
    select into ldc_sum_eys3 sum(monto) from eys3
    where trim(almacen) = trim(r_eys1.almacen)
    and no_transaccion = r_eys1.no_transaccion;
    if ldc_sum_eys3 is null then
        ldc_sum_eys3 = 0;
    end if;
    
    
    ldc_work = ldc_sum_eys2 - ldc_sum_eys3;
/*
        select into r_eys3 *
        from eys3
        where almacen = as_almacen
        and no_transaccion = r_eys1.no_transaccion
        and cuenta = ls_cuenta_costo;
        if not found then
        else
        
            update eys3
            set monto = ldc_work - ldc_work
            where almacen = as_almacen
            and no_transaccion = r_eys1.no_transaccion
            and cuenta = ls_cuenta_costo;

*/  


    if ldc_work <> 0 then
        INSERT INTO eys3 ( almacen, no_transaccion, cuenta, auxiliar1, auxiliar2, monto ) 
        VALUES ( as_almacen, r_eys1.no_transaccion, ls_cuenta_costo, null, null,
            ldc_work);
    end if;    
    
    return 1;
end;
' language plpgsql;
