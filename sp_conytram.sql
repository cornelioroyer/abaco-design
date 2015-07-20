

drop function f_clientes_cglauxiliares() cascade;
drop function f_f_conytram_to_facturacion(char(2), char(3), int4) cascade;
drop function f_f_conytram_before_update() cascade;
drop function f_f_conytram_before_insert() cascade;
drop function f_f_conytram_before_delete() cascade;
drop function f_f_conytram_after_delete() cascade;
drop function f_f_conytram_after_update() cascade;
drop function f_pedidos_1_before_insert_update() cascade;


create function f_pedidos_1_before_insert_update() returns trigger as '
declare
    ls_documento char(25);
begin
    
    if new.status is null then
        new.status = ''P'';
    end if;
    
    
    return new;
end;
' language plpgsql;



create function f_f_conytram_after_delete() returns trigger as '
declare
    ls_documento char(25);
begin
    
    ls_documento := old.no_documento;
    
    delete from cxcdocm
    where almacen = old.almacen
    and cliente = old.cliente
    and documento = ls_documento
    and docmto_aplicar = ls_documento
    and motivo_cxc = old.tipo;
    
    return old;
end;
' language plpgsql;



create function f_f_conytram_after_update() returns trigger as '
declare
    ls_documento char(25);
begin
    if old.no_documento <> new.no_documento then
        return new;
    end if;
    
    delete from factura4
    where almacen = old.almacen
    and tipo = old.tipo
    and num_documento = old.no_documento;

    delete from factura2
    where almacen = old.almacen
    and tipo = old.tipo
    and num_documento = old.no_documento;


    delete from factura1
    where almacen = old.almacen
    and tipo = old.tipo
    and num_documento = old.no_documento;
    
    ls_documento := old.no_documento;
    
    delete from cxcdocm
    where almacen = old.almacen
    and cliente = old.cliente
    and documento = ls_documento
    and docmto_aplicar = ls_documento
    and motivo_cxc = old.tipo;
    
    return new;
end;
' language plpgsql;


create function f_f_conytram_before_insert() returns trigger as '
declare
    ldc_saldo_cod decimal;
    ldc_saldo_aduana decimal;
    r_factmotivos record;
    r_tal_equipo record;
    r_almacen record;
    i integer;
begin
    if new.otros_servicios is null then
        new.otros_servicios = 0;
    end if;
    
    
    select into r_almacen *
    from almacen
    where almacen = new.almacen;
    if found then
        i = f_valida_fecha(r_almacen.compania, ''CGL'', new.fecha_factura);
    end if;
    

    if new.placa is not null then
        select into r_tal_equipo *
        from tal_equipo
        where compania = r_almacen.compania
        and trim(codigo) = trim(new.placa);
        if not found then
            Raise Exception ''Placa % no Existe'', new.placa;
        end if;
    end if;
    
    select into r_factmotivos * from factmotivos
    where tipo = new.tipo
    and factura = ''S'';
    if found then
        ldc_saldo_cod = 0;
        ldc_saldo_aduana = 0;
    
        select into ldc_saldo_cod sum(cglposteo.debito-cglposteo.credito)
        from cglposteoaux1, cglposteo
        where cglposteoaux1.consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta = ''2106003''
        and trim(cglposteoaux1.auxiliar) = trim(new.cliente)
        and cglposteo.fecha_comprobante >= ''2009-01-01'';
    
        if ldc_saldo_cod > 0 and ldc_saldo_cod > (new.monto_cod1 + new.monto_cod2 + new.monto_cod3) and not f_supervisor(trim(current_user)) then
            raise exception ''Debe cancelar el total del COD %'',ldc_saldo_cod;
        end if;
    
        select into ldc_saldo_aduana sum(cglposteo.debito-cglposteo.credito)
        from cglposteoaux1, cglposteo
        where cglposteoaux1.consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta = ''2106004''
        and trim(cglposteoaux1.auxiliar) = trim(new.cliente)
        and cglposteo.fecha_comprobante >= ''2009-01-01'';
    
        if ldc_saldo_aduana > 0 and ldc_saldo_aduana > new.monto_aduana and not f_supervisor(trim(current_user)) then
            raise exception ''Debe cancelar el impuesto de aduana %'',ldc_saldo_aduana;
        end if;
    end if;    
    
    return new;
end;
' language plpgsql;


create function f_f_conytram_before_update() returns trigger as '
declare
    r_gralperiodos record;
    ls_documento char(25);
    r_cxcdocm record;
    r_almacen record;
    r_tal_equipo record;
    i integer;
    ldc_saldo_aduana decimal;
    ldc_saldo_cod decimal;
begin

    delete from factura4
    where almacen = old.almacen
    and tipo = old.tipo
    and num_documento = old.no_documento;

    delete from factura2
    where almacen = old.almacen
    and tipo = old.tipo
    and num_documento = old.no_documento;

    delete from factura1
    where almacen = old.almacen
    and tipo = old.tipo
    and num_documento = old.no_documento;

    select into r_almacen * from almacen
    where almacen = old.almacen;
    
    if new.placa is not null then
        select into r_tal_equipo *
        from tal_equipo
        where compania = r_almacen.compania
        and trim(codigo) = trim(new.placa);
        if not found then
            Raise Exception ''Placa % no Existe'', new.placa;
        end if;
    end if;
    
    
    if new.otros_servicios is null then
        new.otros_servicios = 0;
    end if;
    
    i = f_valida_fecha(r_almacen.compania, ''CXC'', old.fecha_factura);
    i = f_valida_fecha(r_almacen.compania, ''CGL'', old.fecha_factura);

    i = f_valida_fecha(r_almacen.compania, ''CGL'', new.fecha_factura);
    
    ls_documento := old.no_documento;
    
    select into r_cxcdocm * from cxcdocm
    where almacen = old.almacen
    and cliente = old.cliente
    and docmto_aplicar = ls_documento
    and docmto_ref = ls_documento
    and motivo_ref = old.tipo
    and documento <> docmto_aplicar;
    if found then
       raise exception ''No se puede modificar factura numero % con transacciones aplicadas...Verifique'', ls_documento;
    end if;
    
    ldc_saldo_cod = 0;
    ldc_saldo_aduana = 0;
    
    select into ldc_saldo_cod sum(cglposteo.debito-cglposteo.credito)
    from cglposteoaux1, cglposteo
    where cglposteoaux1.consecutivo = cglposteo.consecutivo
    and cglposteo.cuenta = ''2106003''
    and trim(cglposteoaux1.auxiliar) = trim(new.cliente)
    and cglposteo.fecha_comprobante >= ''2009-01-01'';
    
    if ldc_saldo_cod > 0 and ldc_saldo_cod > (new.monto_cod1 + new.monto_cod2 + new.monto_cod3) and not f_supervisor(trim(current_user)) then
        raise exception ''Debe cancelar el total del COD %'',ldc_saldo_cod;
    end if;
    
    select into ldc_saldo_aduana sum(cglposteo.debito-cglposteo.credito)
    from cglposteoaux1, cglposteo
    where cglposteoaux1.consecutivo = cglposteo.consecutivo
    and cglposteo.cuenta = ''2106004''
    and trim(cglposteoaux1.auxiliar) = trim(new.cliente)
    and cglposteo.fecha_comprobante >= ''2009-01-01'';
    
    if ldc_saldo_aduana > 0 and ldc_saldo_aduana > new.monto_aduana and not f_supervisor(trim(current_user)) then
        raise exception ''Debe cancelar el impuesto de aduana %'',ldc_saldo_aduana;
    end if;
    
    return new;
end;
' language plpgsql;
    
/*    
create function f_f_conytram_before_insert() returns trigger as '
declare
    ldc_saldo_cod decimal;
    ldc_saldo_aduana decimal;
begin
    if new.otros_servicios is null then
        new.otros_servicios = 0;
    end if;
    
    ldc_saldo_cod = 0;
    ldc_saldo_aduana = 0;
    
    select into ldc_saldo_cod sum(cglposteo.debito-cglposteo.credito)
    from cglposteoaux1, cglposteo
    where cglposteoaux1.consecutivo = cglposteo.consecutivo
    and cglposteo.cuenta = ''2106003''
    and trim(cglposteoaux1.auxiliar) = trim(new.cliente)
    and cglposteo.fecha_comprobante >= ''2008-01-01'';
    
    if ldc_saldo_cod > (new.monto_cod1 + new.monto_cod2 + new.monto_cod3) then
        raise exception ''Debe cancelar el total del COD %'',ldc_saldo_cod;
    end if;
    
    select into ldc_saldo_aduana sum(cglposteo.debito-cglposteo.credito)
    from cglposteoaux1, cglposteo
    where cglposteoaux1.consecutivo = cglposteo.consecutivo
    and cglposteo.cuenta = ''2106004''
    and trim(cglposteoaux1.auxiliar) = trim(new.cliente)
    and cglposteo.fecha_comprobante >= ''2008-01-01'';
    
    if ldc_saldo_aduana > new.monto_aduana then
        raise exception ''Debe cancelar el impuesto de aduana %'',ldc_saldo_aduana;
    end if;
    
    
    return new;
end;
' language plpgsql;
*/


create function f_f_conytram_before_delete() returns trigger as '
declare
    r_gralperiodos record;
    r_cxcdocm record;
    ls_documento char(25);
    r_almacen record;
    i integer;
begin
    delete from factura4
    where almacen = old.almacen
    and tipo = old.tipo
    and num_documento = old.no_documento;

    delete from factura2
    where almacen = old.almacen
    and tipo = old.tipo
    and num_documento = old.no_documento;

    delete from factura1
    where almacen = old.almacen
    and tipo = old.tipo
    and num_documento = old.no_documento;


    select into r_almacen * from almacen
    where almacen = old.almacen;
    
    i = f_valida_fecha(r_almacen.compania, ''CXC'', old.fecha_factura);
    i = f_valida_fecha(r_almacen.compania, ''CGL'', old.fecha_factura);
    
    ls_documento := old.no_documento;
    
    select into r_cxcdocm * from cxcdocm
    where almacen = old.almacen
    and cliente = old.cliente
    and docmto_aplicar = ls_documento
    and docmto_ref = ls_documento
    and motivo_ref = old.tipo
    and documento <> docmto_aplicar;
    if found then
       raise exception ''No se puede eliminar facturas con transacciones aplicadas...Verifique'';
    end if;

    return old;
end;
' language plpgsql;


create function f_f_conytram_to_facturacion(char(2), char(3), int4) returns integer as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    r_almacen record;
    r_gralperiodos record;
    r_v_f_conytram record;
    r_cxcdocm record;
    ldc_total decimal;
    ldc_work decimal;
    i integer;
    ls_documento char(25);
    r_factmotivos record;
    r_factura1 record;
    r_factura2 record;
    r_factura4 record;
    r_fac_cajas record;
    r_f_conytram record;
    lc_observacion varchar(100);
begin
    if ai_num_documento is null then
        return 0;
    end if;
            
    select into r_factmotivos * from factmotivos
    where tipo = as_tipo
    and cotizacion = ''S'' or donacion = ''S'';
    if found then
        return 0;
    end if;
    
    select into r_almacen * from almacen
    where almacen = as_almacen;
    if not found then
        return 0;
    end if;
    
    select into r_fac_cajas * from fac_cajas
    where almacen = as_almacen;
    if not found then
        raise exception ''No existe caja para este almacen %'',as_almacen;
        return 0;
    end if;
    
    select into r_v_f_conytram * from v_f_conytram
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    if not found then
        return 0;
    end if;
    
    select into r_f_conytram *
    from f_conytram
    where almacen = as_almacen
    and tipo = as_tipo
    and no_documento = ai_num_documento;
    
    
    if r_v_f_conytram.total = 0 then
        return 0;
    end if;

/*    
    select into r_gralperiodos * from gralperiodos
    where compania = r_almacen.compania
    and aplicacion in (''CGL'', ''CXC'')
    and r_v_f_conytram.fecha_factura between inicio and final
    and estado = ''I'';
    if found then
        raise exception ''Fecha % de Factura % corresponde a un periodo cerrado...Verifique'', r_v_f_conytram.fecha_factura, ai_num_documento;
    end if;
*/
    

    ls_documento    :=  ai_num_documento;
    
    select into r_factura1 * from factura1
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = r_fac_cajas.caja
    and num_documento = ai_num_documento;
    if not found then
        lc_observacion  =   ''LIQUIDACION NUMERO: '' || trim(r_f_conytram.no_liquidacion);
        insert into factura1 (almacen, tipo, num_documento, cliente, forma_pago, codigo_vendedor,
        nombre_cliente,descto_porcentaje, descto_monto, usuario_captura, usuario_postea,
        fecha_vencimiento, fecha_captura, fecha_postea, fecha_factura, status, num_cotizacion,
        num_factura, despachar, documento, ciudad_origen, ciudad_destino,
        agente, bultos, peso, facturar, cajero, caja, sec_z, observacion)
        values (as_almacen, as_tipo, ai_num_documento,
        r_v_f_conytram.cliente, ''30'', ''00'',
        r_v_f_conytram.nombre_cliente, 0, 0, current_user, current_user,
        r_v_f_conytram.fecha_factura, current_timestamp, r_v_f_conytram.fecha_factura, 
        r_v_f_conytram.fecha_factura, ''R'', 0,
        0, ''N'', trim(ls_documento), ''00'', ''00'', r_v_f_conytram.cliente, 0, 0, ''S'', 
        r_fac_cajas.cajero, r_fac_cajas.caja, r_fac_cajas.sec_z, lc_observacion);
    end if;        


    select into r_factura2 * from factura2
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = r_fac_cajas.caja
    and num_documento = ai_num_documento
    and linea = 1;
    if not found and r_v_f_conytram.manejo <> 0 then
        ldc_work        =   r_f_conytram.porcentaje1*100;
        lc_observacion  = to_char(ldc_work, ''99,999.99'') || ''% AL VALOR DE ''  ||  
                            to_char(r_f_conytram.valor_cif, ''99,999.99'');
                            
        insert into factura2 (almacen, tipo, caja, num_documento, linea, articulo,
        cantidad, precio, descuento_linea, descuento_global, cif, observacion)
        values (as_almacen, as_tipo, r_fac_cajas.caja, ai_num_documento, 1, ''MANEJO'',
        1, Abs(r_v_f_conytram.manejo), 0, 0, 0, trim(lc_observacion));           
    end if;
    
    select into r_factura2 * from factura2
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = r_fac_cajas.caja
    and num_documento = ai_num_documento
    and linea = 2;
    if not found and r_v_f_conytram.confeccion <> 0 then
        lc_observacion  =   ''VALOR CIF '' || to_char(r_f_conytram.valor_cif, ''999,999.99'') || '' * 0.15% (DOCUMENTACION) '';

        insert into factura2 (almacen, tipo, caja, num_documento, linea, articulo,
        cantidad, precio, descuento_linea, descuento_global, cif, observacion)
        values (as_almacen, as_tipo, r_fac_cajas.caja, ai_num_documento, 2, ''CONFECCION'',
        1, Abs(r_v_f_conytram.confeccion), 0, 0, 0, lc_observacion);           
    end if;
        
    select into r_factura2 * from factura2
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = r_fac_cajas.caja
    and num_documento = ai_num_documento
    and linea = 3;
    if not found and r_v_f_conytram.valor_x_linea <> 0 then
        lc_observacion  =   ''LINEAS: '' || to_char(r_f_conytram.lineas, ''999,999'') || '' * 2 '';

        insert into factura2 (almacen, tipo, caja, num_documento, linea, articulo,
        cantidad, precio, descuento_linea, descuento_global, cif, observacion)
        values (as_almacen, as_tipo, r_fac_cajas.caja, ai_num_documento, 3, ''OTROS INGRESOS'',
        1, Abs(r_v_f_conytram.valor_x_linea), 0, 0, 0, lc_observacion);           
    end if;

    select into r_factura2 * from factura2
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = r_fac_cajas.caja
    and num_documento = ai_num_documento
    and linea = 4;
    if not found and r_v_f_conytram.sellos <> 0 then
--        lc_observacion  =   ''LINEAS: '' || to_char(r_f_conytram.lineas, ''999,999'') || '' * 2 '';
        lc_observacion = ''SELLOS'';
        insert into factura2 (almacen, tipo, caja, num_documento, linea, articulo,
        cantidad, precio, descuento_linea, descuento_global, cif, observacion)
        values (as_almacen, as_tipo, r_fac_cajas.caja, ai_num_documento, 4, ''OTROS INGRESOS'',
        1, Abs(r_v_f_conytram.sellos), 0, 0, 0, lc_observacion);           
    end if;

    select into r_factura2 * from factura2
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = r_fac_cajas.caja
    and num_documento = ai_num_documento
    and linea = 5;
    if not found and r_v_f_conytram.manejo_documentacion <> 0 then
--        lc_observacion  =   ''LINEAS: '' || to_char(r_f_conytram.lineas, ''999,999'') || '' * 2 '';
        lc_observacion = ''MANEJO DOCUMENTACION'';
        insert into factura2 (almacen, tipo, caja, num_documento, linea, articulo,
        cantidad, precio, descuento_linea, descuento_global, cif, observacion)
        values (as_almacen, as_tipo, r_fac_cajas.caja, ai_num_documento, 5, ''OTROS INGRESOS'',
        1, Abs(r_v_f_conytram.manejo_documentacion), 0, 0, 0, lc_observacion);           
    end if;
    
    select into r_factura2 * from factura2
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = r_fac_cajas.caja
    and num_documento = ai_num_documento
    and linea = 6;
    if not found and r_v_f_conytram.tramites <> 0 then
--        lc_observacion  =   ''LINEAS: '' || to_char(r_f_conytram.lineas, ''999,999'') || '' * 2 '';
        lc_observacion = ''TRAMITES'';
        insert into factura2 (almacen, tipo, caja, num_documento, linea, articulo,
        cantidad, precio, descuento_linea, descuento_global, cif, observacion)
        values (as_almacen, as_tipo, r_fac_cajas.caja, ai_num_documento, 6, ''OTROS INGRESOS'',
        1, Abs(r_v_f_conytram.tramites), 0, 0, 0, lc_observacion);           
    end if;

    
    select into r_factura2 * from factura2
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = r_fac_cajas.caja
    and num_documento = ai_num_documento
    and linea = 7;
    if not found and r_v_f_conytram.otros_ingresos <> 0 then
--        lc_observacion  =   ''LINEAS: '' || to_char(r_f_conytram.lineas, ''999,999'') || '' * 2 '';
        lc_observacion = ''CARGOS POR CHEQUES CERTIFICADOS'';
        insert into factura2 (almacen, tipo, caja, num_documento, linea, articulo,
        cantidad, precio, descuento_linea, descuento_global, cif, observacion)
        values (as_almacen, as_tipo, r_fac_cajas.caja, ai_num_documento, 7, ''OTROS INGRESOS'',
        1, Abs(r_v_f_conytram.otros_ingresos), 0, 0, 0, lc_observacion);           
    end if;

    select into r_factura2 * from factura2
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = r_fac_cajas.caja
    and num_documento = ai_num_documento
    and linea = 8;
    if not found and r_v_f_conytram.cod <> 0 then
        insert into factura2 (almacen, tipo, caja, num_documento, linea, articulo,
        cantidad, precio, descuento_linea, descuento_global, cif)
        values (as_almacen, as_tipo, r_fac_cajas.caja, ai_num_documento, 8, ''COD'',
        1, Abs(r_v_f_conytram.cod), 0, 0, 0);           
    end if;        


    select into r_factura2 * from factura2
    where almacen = as_almacen
    and caja = r_fac_cajas.caja
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and linea = 9;
    if not found and r_v_f_conytram.aduana <> 0 then
        lc_observacion = ''CHEQUE DE ADUANA NUMERO: '' || to_char(r_f_conytram.ck_aduana, ''99999'');
        
        if lc_observacion is null then
            lc_observacion = ''IMPUESTO DE ADUANA'';
        end if;
        insert into factura2 (almacen, tipo, caja, num_documento, linea, articulo,
        cantidad, precio, descuento_linea, descuento_global, cif, observacion)
        values (as_almacen, as_tipo, r_fac_cajas.caja, ai_num_documento, 9, ''ADUANA'',
        1, Abs(r_v_f_conytram.aduana), 0, 0, 0, lc_observacion);           
    end if;        

    
    select into r_factura2 * from factura2
    where almacen = as_almacen
    and caja = r_fac_cajas.caja
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and linea = 10;
    if not found and r_v_f_conytram.acarreo <> 0 then
        insert into factura2 (almacen, tipo, caja, num_documento, linea, articulo,
        cantidad, precio, descuento_linea, descuento_global, cif, observacion)
        values (as_almacen, as_tipo, r_fac_cajas.caja, ai_num_documento, 10, ''FLETE'',
        1, Abs(r_v_f_conytram.acarreo), 0, 0, 0, ''ACARREO'');           
    end if;        
    
    select into r_factura4 * from factura4
    where almacen = as_almacen
    and tipo = as_tipo
    and caja = r_fac_cajas.caja
    and num_documento = ai_num_documento
    and rubro_fact_cxc = ''SUBTOTAL'';
    if not found then
        insert into factura4 (almacen, tipo, caja, num_documento, rubro_fact_cxc, monto)
        values (as_almacen, as_tipo, r_fac_cajas.caja, ai_num_documento, ''SUBTOTAL'', Abs(r_v_f_conytram.total));
    end if;

    i   =   f_update_factura4(as_almacen, as_tipo, ai_num_documento, r_fac_cajas.caja);
        
    return 1;
end;
' language plpgsql;

create function f_clientes_cglauxiliares() returns trigger as '
declare
    r_cglauxiliares record;
begin
    select into r_cglauxiliares * from cglauxiliares
    where trim(auxiliar) = trim(new.cliente);
    if not found then
        insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
        values (trim(new.cliente), substring(new.nomb_cliente from 1 for 30), ''1'', ''A'');
    else    
        update cglauxiliares
        set nombre = substring(new.nomb_cliente from 1 for 30)
        where trim(auxiliar) = trim(new.cliente);
    end if;
        
    return new;
end;
' language plpgsql;

create trigger t_pedidos_1_before_insert_update before insert or update on pedidos_1
for each row execute procedure f_pedidos_1_before_insert_update();


create trigger t_f_conytram_before_insert before insert on f_conytram
for each row execute procedure f_f_conytram_before_insert();

create trigger t_f_conytram_before_update before update on f_conytram
for each row execute procedure f_f_conytram_before_update();

create trigger t_f_conytram_before_delete before delete on f_conytram
for each row execute procedure f_f_conytram_before_delete();

create trigger t_f_conytram_after_delete after delete on f_conytram
for each row execute procedure f_f_conytram_after_delete();

create trigger t_f_conytram_after_update after update on f_conytram
for each row execute procedure f_f_conytram_after_update();

create trigger t_clientes_cglauxiliares after insert or update on clientes
for each row execute procedure f_clientes_cglauxiliares();




/*
drop function f_f_conytram_delete() cascade;
drop function f_f_conytram_update() cascade;
drop trigger t_f_conytram_delete on f_conytram;
drop trigger t_f_conytram_update on f_conytram;



create function f_f_conytram_update() returns trigger as '
declare
    r_almacen record;
    r_gralperiodos record;
    r_cxcdocm record;
    ldc_total decimal;
    ls_documento char(25);
begin

    ls_documento    :=  trim(to_char(new.no_documento, ''999999999999''));
    
    
    delete from factura2
    where almacen = new.almacen
    and tipo = new.tipo
    and num_documento = new.no_documento;
    
    delete from factura4
    where almacen = new.almacen
    and tipo = new.tipo
    and num_documento = new.no_documento;

    delete from factura1
    where almacen = new.almacen
    and tipo = new.tipo
    and num_documento = new.no_documento;
    

    delete from cxcdocm
    where almacen = new.almacen
    and cliente = new.cliente
    and trim(documento) = trim(ls_documento)
    and trim(docmto_aplicar) = trim(ls_documento)
    and motivo_cxc = new.tipo;
        
    if new.status = ''A'' then
        return new;
    end if;
    
    select into r_almacen * from almacen
    where almacen = new.almacen;
    
    select into r_gralperiodos * from gralperiodos
    where compania = r_almacen.compania
    and aplicacion in (''CGL'', ''CXC'')
    and new.fecha_factura between inicio and final
    and estado = ''I'';
    if found then
        raise exception ''Fecha de Factura corresponde a un periodo cerrado...Verifique'';
    end if;
    
  
    ldc_total :=    new.monto_manejo + new.monto_documentacion + new.otros_ingresos1 +
                    new.otros_ingresos2 + new.otros_ingresos3 + new.otros_ingresos4 +
                    new.monto_cod1 + new.monto_cod2 + new.monto_cod3 + 
                    new.monto_aduana + new.monto_acarreo + new.valor_x_linea + new.itbms;

                    
    insert into cxcdocm (almacen, cliente, documento, docmto_aplicar, motivo_cxc,
    docmto_ref, motivo_ref, fecha_posteo, fecha_docmto, fecha_vmto,
    fecha_cancelo, fecha_captura, usuario, obs_docmto, referencia, uso_interno,
    status, aplicacion_origen, monto)
    values (new.almacen, new.cliente, trim(ls_documento), trim(ls_documento), new.tipo, 
    trim(ls_documento), new.tipo, new.fecha_factura, new.fecha_factura, new.fecha_factura,
    new.fecha_factura, current_timestamp, current_user, null, null, ''N'',
           ''R'', ''FAC'', ldc_total);

           
           

    insert into factura1 (almacen, tipo, num_documento, cliente, forma_pago, codigo_vendedor,
    nombre_cliente,descto_porcentaje, descto_monto, usuario_captura, usuario_postea,
    fecha_vencimiento, fecha_captura, fecha_postea, fecha_factura, status, num_cotizacion,
    num_factura, despachar, documento, ciudad_origen, ciudad_destino,
    agente, bultos, peso, facturar)
    values (new.almacen, new.tipo, new.no_documento, new.cliente, ''30'', ''00'',
    new.nombre_cliente, 0, 0, current_user, current_user,
    new.fecha_factura, current_timestamp, new.fecha_factura, new.fecha_factura, ''I'', 0,
    0, ''N'', trim(ls_documento), ''00'', ''00'', new.cliente, 0, 0, ''S'');
    
    insert into factura2 (almacen, tipo, num_documento, linea, articulo,
    cantidad, precio, descuento_linea, descuento_global, cif)
    values (new.almacen, new.tipo, new.no_documento, 1, ''FLETE'',
    1, new.monto_acarreo, 0, 0, 0);           
    
    insert into factura2 (almacen, tipo, num_documento, linea, articulo,
    cantidad, precio, descuento_linea, descuento_global, cif)
    values (new.almacen, new.tipo, new.no_documento, 2, ''OTROS INGRESOS'',
    1, (new.otros_ingresos1+new.otros_ingresos2+new.otros_ingresos3+new.otros_ingresos4+new.valor_x_linea), 0, 0, 0);
    
    
    
    insert into factura2 (almacen, tipo, num_documento, linea, articulo,
    cantidad, precio, descuento_linea, descuento_global, cif)
    values (new.almacen, new.tipo, new.no_documento, 3, ''CONFECCION'',
    1, new.monto_documentacion, 0, 0, 0);           
    
--    raise exception ''documentacion %'', new.monto_documentacion;
    
    insert into factura2 (almacen, tipo, num_documento, linea, articulo,
    cantidad, precio, descuento_linea, descuento_global, cif)
    values (new.almacen, new.tipo, new.no_documento, 4, ''MANEJO'',
    1, new.monto_manejo, 0, 0, 0);           

    insert into factura2 (almacen, tipo, num_documento, linea, articulo,
    cantidad, precio, descuento_linea, descuento_global, cif)
    values (new.almacen, new.tipo, new.no_documento, 5, ''COD'',
    1, (new.monto_cod1+new.monto_cod2+new.monto_cod3), 0, 0, 0);           

    insert into factura2 (almacen, tipo, num_documento, linea, articulo,
    cantidad, precio, descuento_linea, descuento_global, cif)
    values (new.almacen, new.tipo, new.no_documento, 6, ''ADUANA'',
    1, new.monto_aduana, 0, 0, 0);           

    insert into factura2 (almacen, tipo, num_documento, linea, articulo,
    cantidad, precio, descuento_linea, descuento_global, cif)
    values (new.almacen, new.tipo, new.no_documento, 7, ''ITBMS'',
    1, new.itbms, 0, 0, 0);           
    
    insert into factura4 (almacen, tipo, num_documento, rubro_fact_cxc, monto)
    values (new.almacen, new.tipo, new.no_documento, ''SUBTOTAL'', ldc_total);    
    
    return new;
end;
' language plpgsql;





create function f_f_conytram_delete() returns trigger as '
declare
    r_almacen record;
    r_gralperiodos record;
    ls_documento char(25);
begin
    select into r_almacen * from almacen
    where almacen = old.almacen;
    
    select into r_gralperiodos * from gralperiodos
    where compania = r_almacen.compania
    and aplicacion in (''CGL'', ''CXC'')
    and old.fecha_factura between inicio and final
    and estado = ''I'';
    if found then
        raise exception ''Fecha de Factura corresponde a un periodo cerrado...Verifique'';
    end if;
    
    delete from factura1
    where almacen = old.almacen
    and tipo = old.tipo
    and num_documento = old.no_documento;
    
    ls_documento := trim(to_char(old.no_documento, ''999999999999''));
    
    delete from cxcdocm
    where almacen = old.almacen
    and cliente = old.cliente
    and documento = trim(ls_documento)
    and documento = trim(ls_documento)
    and motivo_cxc = old.tipo;
    
    return old;
end;
' language plpgsql;




create trigger t_f_conytram_delete after delete on f_conytram
for each row execute procedure f_f_conytram_delete();

create trigger t_f_conytram_update after update on f_conytram
for each row execute procedure f_f_conytram_update();

*/
