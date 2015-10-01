
--set search_path to dba;

drop function f_rela_factura1_cglposteo_delete() cascade;
drop function f_rela_factura1_cglposteo_before_delete() cascade;
drop function f_factura1_before_insert() cascade;
drop function f_factura1_before_delete() cascade;
drop function f_factura1_before_update() cascade;
drop function f_factura1_after_delete() cascade;
drop function f_factura1_after_update() cascade;
drop function f_factura1_after_insert() cascade;

drop function f_factura2_before_update() cascade;
drop function f_factura2_before_delete() cascade;
drop function f_factura2_after_update() cascade;
drop function f_factura2_after_delete() cascade;
drop function f_factura2_after_insert() cascade;
drop function f_factura2_eys2_before_update() cascade;
drop function f_factura2_eys2_before_delete() cascade;

drop function f_factura4_before_update() cascade;
drop function f_factura4_before_delete() cascade;


drop function f_fac_cajas_after_insert() cascade;
drop function f_fac_cajas_after_update() cascade;
drop function f_fac_z_after_update() cascade;
drop function f_factura2_before_insert() cascade;
drop function f_precios_por_cliente_1_before_insert() cascade;
drop function f_factsobregiro_before_insert() cascade;
drop function f_factura3_before_insert() cascade;
drop function f_factura4_before_insert() cascade;
drop function f_factura3_before_delete() cascade;


create function f_factura3_before_delete() returns trigger as '
declare
    r_factura3 record;
    r_fac_cajas record;
begin
    
    delete from rela_factura1_cglposteo
    where almacen = old.almacen
    and caja = old.caja
    and tipo = old.tipo
    and num_documento = old.num_documento;
    
    return old;
end;
' language plpgsql;


create function f_factura4_before_insert() returns trigger as '
declare
    r_factura1 record;
    r_fac_cajas record;
    ls_documento char(25);
    i integer;
begin
    return new;
end;
' language plpgsql;



create function f_factura3_before_insert() returns trigger as '
declare
    r_factura3 record;
    r_fac_cajas record;
begin
/*
    select into r_fac_cajas *
    from fac_cajas
    where almacen = new.almacen
    and status = ''A'';
    if not found then
        Raise Exception ''Caja no Existe para almacen %'', new.almacen;
    else
        new.caja = r_fac_cajas.caja;
    end if;
*/

    select into r_factura3 *
    from factura3
    where almacen = new.almacen
    and tipo = new.tipo
    and caja = new.caja
    and num_documento = new.num_documento
    and linea = new.linea
    and impuesto = new.impuesto;
    if found then
        Raise Exception ''Registro Duplicado en factura3'';
    end if;

    
    
    return new;
end;
' language plpgsql;


create function f_factsobregiro_before_insert() returns trigger as '
declare
    r_clientes record;
    r_gral_forma_de_pago record;
    li_dias_credito_cliente integer;
    li_dias_credito_sobregiro integer;
begin
    
    select into r_clientes * from clientes
    where cliente = new.cliente;
    if not found then
        Raise Exception ''Cliente % No Existe'',new.cliente;
    end if;
    
    
    select into li_dias_credito_cliente gral_forma_de_pago.dias
    from gral_forma_de_pago, clientes
    where gral_forma_de_pago.forma_pago = clientes.forma_pago
    and clientes.cliente = new.cliente;
    
    
    select into r_gral_forma_de_pago * from gral_forma_de_pago
    where forma_pago = new.forma_pago;
    if not found then
        Raise Exception ''Forma de Pago % No Existe...Verifique'',new.forma_pago;
    end if;
    
    
    select into li_dias_credito_sobregiro gral_forma_de_pago.dias
    from gral_forma_de_pago
    where forma_pago = new.forma_pago;

    if li_dias_credito_sobregiro > li_dias_credito_cliente then
        Raise Exception ''Dias Credito del Sobregiro % no pueden ser mayor a los dias credito del cliente %'',li_dias_credito_sobregiro,li_dias_credito_cliente;
    end if;    
    
    return new;
end;
' language plpgsql;


create function f_factura1_before_update() returns trigger as '
declare
    r_almacen record;
    i integer;
    ls_documento char(25);
    r_factmotivos record;
    r_fac_z record;
    r_factura1 record;
    r_factura2 record;
    r_clientes record;
    r_choferes record;
    r_gralperiodos record;
    r_gral_forma_de_pago record;
    r_work record;
    lt_new_dato text;
    lt_old_dato text;
begin

/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/    


    update invparal
    set valor = ''N''
    where parametro = ''valida_existencias'';

    select into r_factmotivos * from factmotivos
    where tipo = old.tipo
    and cotizacion = ''S'';
    if found then
        return new;
    end if;        
    
    delete from eys2
    using factura2_eys2
    where factura2_eys2.almacen = eys2.almacen
    and factura2_eys2.articulo = eys2.articulo
    and factura2_eys2.no_transaccion = eys2.no_transaccion
    and factura2_eys2.eys2_linea = eys2.linea
    and factura2_eys2.almacen = old.almacen
    and factura2_eys2.tipo = old.tipo
    and factura2_eys2.caja = old.caja
    and factura2_eys2.num_documento = old.num_documento;
    

    delete from factura2_eys2
    where almacen = old.almacen
    and tipo = old.tipo
    and caja = old.caja
    and num_documento = old.num_documento;


    delete from cglposteo
    using rela_factura1_cglposteo
    where cglposteo.consecutivo = rela_factura1_cglposteo.consecutivo
    and rela_factura1_cglposteo.almacen = old.almacen
    and rela_factura1_cglposteo.tipo = old.tipo
    and rela_factura1_cglposteo.caja = old.caja
    and rela_factura1_cglposteo.num_documento = old.num_documento;
    
    delete from rela_factura1_cglposteo
    where almacen = old.almacen
    and tipo = old.tipo
    and caja = old.caja
    and num_documento = old.num_documento;

    i               =   f_delete_rela_factura1_cglposteo(old.almacen, old.caja, old.tipo, old.num_documento);

    new.documento   =   trim(to_char(new.num_documento, ''99999999999999''));


    select into r_factmotivos * from factmotivos
    where tipo = new.tipo
    and cotizacion = ''S'';
    if found then
        return new;
    end if;

    select into r_factmotivos * from factmotivos
    where tipo = old.tipo
    and cotizacion = ''S'';
    if found then
        return new;
    end if;


    select into r_factmotivos * from factmotivos
    where tipo = new.tipo;


/*
    if new.fecha_factura >= ''2012-03-01'' then
        select into r_factmotivos * from factmotivos
        where tipo = new.tipo
        and factura = ''S'';
        if found then
            Raise Exception ''Este tipo de transaccion % no es valido'',new.tipo;
        end if;
    end if;
*/
    

    if new.chofer is null then
        for r_choferes in select * from choferes order by chofer
        loop
            new.chofer = r_choferes.chofer;
            exit;
        end loop;
    end if;



    select into r_factmotivos * from factmotivos
    where tipo = new.tipo;

    if r_factmotivos.factura_fiscal = ''S'' then
        select into r_factura1 *
        from factura1, factmotivos
        where factura1.tipo = factmotivos.tipo
        and factmotivos.devolucion = ''S''
        and almacen_aplica = new.almacen
        and caja_aplica = new.caja
        and tipo_aplica = new.tipo
        and num_factura = old.num_documento
        and status <> ''A''
        and fecha_factura >= ''2014-01-01'';
        if found then
--            Raise Exception ''Factura % no puede ser modificada...Tiene Devolucion aplicandole'', old.num_documento;
        end if;
    end if;
    
        
    select into r_clientes * from clientes
    where cliente = new.cliente and status = ''I'';
    if found then
        raise exception ''Cliente % Esta Inactivo...Verifique'',new.cliente;
    end if;
    
    if new.tipo = ''DA'' and new.despachar = ''S'' then
        raise exception ''Las comisiones no se despachan'';
    end if;
    
    if new.tipo = ''DA'' and new.descto_porcentaje = 0 and new.descto_monto = 0 then
        raise Exception ''En los DA el monto a pagar o porcentaje es obligatorio'';
    end if;
    
    select into r_almacen * from almacen
    where almacen = old.almacen;

    if new.chofer is null then
        select into r_choferes * from choferes
            where chofer = ''00'';
        if found then
            new.chofer = ''00'';
        end if;        
    end if;
    
    if old.despachar <> new.despachar then
        if new.despachar = ''S'' and new.chofer is null then
           raise exception ''Chofer es Obligatorio en Factura % del Almacen %'',new.num_documento,new.almacen;
        end if;
        return new;
    end if;

    i := f_valida_fecha(r_almacen.compania, ''CGL'', old.fecha_factura);
    i := f_valida_fecha(r_almacen.compania, ''INV'', old.fecha_factura);
    i := f_valida_fecha(r_almacen.compania, ''CXC'', old.fecha_factura);
    
    i := f_valida_fecha(r_almacen.compania, ''CGL'', new.fecha_factura);
    i := f_valida_fecha(r_almacen.compania, ''INV'', new.fecha_factura);
    i := f_valida_fecha(r_almacen.compania, ''CXC'', new.fecha_factura);


    if new.num_factura is null then
        new.num_factura = 0;
    end if;        

    select into r_factmotivos * from factmotivos
    where tipo = old.tipo
    and cotizacion = ''S'';
    if found then
        new.num_factura = 0;
    end if;


    if new.num_factura <> 0 then

        if new.tipo_aplica is null then    
            select into r_factmotivos * from factmotivos
            where factura_fiscal = ''S'';
            if found then
                new.tipo_aplica =   r_factmotivos.tipo;
            else
                select into r_factmotivos * from factmotivos
                where factura = ''S'';

                new.tipo_aplica = r_factmotivos.tipo;
            end if;            
        end if;
            
        if new.tipo = ''DA'' then
            select into r_factura1 * from factura1
            where almacen = new.almacen_aplica
            and caja = new.caja_aplica
            and tipo = new.tipo_aplica
            and num_documento = new.num_factura;
            if not found then
                raise exception ''Factura % No Existe Para aplica DA...Verifique'',new.num_factura;
            end if;
        else
        
            select into r_factura1 * from factura1
            where almacen = new.almacen_aplica
            and caja = new.caja_aplica
            and tipo = new.tipo_aplica
            and num_documento = new.num_factura;
            if not found then
                raise exception ''Almacen % Caja % Tipo % Factura % No Existe...Verifique'',new.almacen_aplica, new.caja_aplica, new.tipo_aplica, new.num_factura;
            else
                new.forma_pago  =   r_factura1.forma_pago;

                select into r_gralperiodos *
                from gralperiodos
                where compania = r_almacen.compania
                and aplicacion = ''CGL''
                and estado = ''A''
                and r_factura1.fecha_factura between inicio and final;
                if found then
                    select into r_work *
                    from factura1, factmotivos
                    where factura1.tipo = factmotivos.tipo
                    and factmotivos.devolucion = ''S''
                    and almacen = new.almacen
                    and caja = new.caja
                    and num_factura = old.num_documento;
                    if not found then
/*                    
                        update factura1
                        set despachar = ''S'',
                        fecha_despacho = new.fecha_factura
                        where almacen = r_factura1.almacen
                        and caja = r_factura1.caja
                        and tipo = r_factura1.tipo
                        and num_documento = r_factura1.num_documento;
*/                        
                    end if;
/*                
                    new.despachar = ''S'';
                    new.fecha_despacho = new.fecha_factura;
*/                    
                end if;
            end if;
        end if;
    end if;
    
  
    if r_factmotivos.devolucion = ''S'' and new.num_factura = 0 then
        raise exception ''En las devoluciones % el numero de factura aplicar es obligatorio'',new.num_documento;
    end if;
    


    ls_documento    =   old.num_documento;

    
    if old.almacen <> new.almacen
        or old.tipo <> new.tipo
        or old.num_documento <> new.num_documento 
        or old.cliente <> new.cliente 
        or new.status = ''A'' then

        delete from cxcdocm
        where almacen = old.almacen
        and cliente = old.cliente
        and motivo_cxc = old.tipo
        and caja = old.caja
        and trim(documento) = trim(ls_documento)
        and trim(docmto_aplicar) = trim(ls_documento);
    end if;       

/*
    if new.status = ''A'' then
        delete from adc_house_factura1
        where almacen = old.almacen
        and tipo = old.tipo
        and num_documento = old.num_documento;
        
        delete from adc_manejo_factura1
        where almacen = old.almacen
        and tipo = old.tipo
        and num_documento = old.num_documento;
    end if;
*/

/*
    if f_gralparaxcia(r_almacen.compania, ''PLA'', ''metodo_calculo'') <> ''harinas'' then
        select into r_factura2 * from factura2
        where almacen = old.almacen
        and tipo = old.tipo
        and num_documento = old.num_documento;
        if found then
            select into r_gral_forma_de_pago * from gral_forma_de_pago
            where forma_pago = new.forma_pago;
        
            select into r_fac_z * from fac_z
            where caja = old.caja
            and almacen = old.almacen
            and sec_z = old.sec_z
            and status = ''C'';
            if found then
                raise exception ''Factura % no puede ser modificada pertenece a un turno % cerrado...Verifique'',old.num_documento, old.sec_z;
            end if;
        end if;    
    end if;
*/
    

    if f_gralparaxcia(r_almacen.compania, ''PLA'', ''metodo_calculo'') = ''coolhouse'' then
        if r_factmotivos.factura = ''S'' or r_factmotivos.factura_fiscal = ''S'' 
            or r_factmotivos.devolucion = ''S'' then
            new.fecha_despacho = new.fecha_factura;
        end if;
    end if;

    if new.fecha_despacho is not null then
        i := f_valida_fecha(r_almacen.compania, ''CGL'', new.fecha_despacho);
        i := f_valida_fecha(r_almacen.compania, ''INV'', new.fecha_despacho);
    end if;

    if old.fecha_despacho is not null then
        i := f_valida_fecha(r_almacen.compania, ''CGL'', old.fecha_despacho);
        i := f_valida_fecha(r_almacen.compania, ''INV'', old.fecha_despacho);
    end if;

    return new;
end;
' language plpgsql;


create function f_factura1_after_update() returns trigger as '
declare
    r_almacen record;
    r_fac_pagos record;
    r_gral_forma_de_pago record;
    r_adc_house_factura1 record;
    r_factura1 record;
    ls_documento char(25);
    r_factmotivos record;
    ls_docmto_aplicar char(25);
    lt_sentencia_sql text;
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/    

    select into r_factmotivos * from factmotivos
    where tipo = new.tipo;
    if not found then
        raise exception ''Tipo de Documento % no Existe...Verificar'',new.tipo;
    end if;
    
    if r_factmotivos.cotizacion = ''S'' then
        return new;
    end if;

    ls_documento    :=   old.num_documento;
    
    if old.num_factura = 0 then
        ls_docmto_aplicar = old.num_documento;
    else
        ls_docmto_aplicar = old.num_factura;
    end if;

    select into r_almacen * from almacen
    where almacen = old.almacen;

/*    
    i := f_valida_fecha(r_almacen.compania, ''CGL'', old.fecha_factura);
    i := f_valida_fecha(r_almacen.compania, ''INV'', old.fecha_factura);
    i := f_valida_fecha(r_almacen.compania, ''CXC'', old.fecha_factura);
*/    


    if new.status = ''A'' then
        delete from adc_house_factura1
        where almacen = old.almacen
        and tipo = old.tipo
        and caja = old.caja
        and num_documento = old.num_documento;
        
        delete from adc_manejo_factura1
        where almacen = old.almacen
        and tipo = old.tipo
        and caja = old.caja
        and num_documento = old.num_documento;
        
        update tal_ot1
        set status = ''R'', tipo_factura = null, numero_factura = null
        where tal_ot1.almacen = old.almacen
        and tal_ot1.tipo_factura = old.tipo
        and caja = old.caja
        and tal_ot1.numero_factura = old.num_documento;
    end if;
    
    if old.fecha_factura <> new.fecha_factura
        or old.almacen <> new.almacen
        or old.cliente <> new.cliente
        or old.num_documento <> new.num_documento
        or old.tipo <> new.tipo 
        or old.caja <> new.caja
        or old.num_factura <> new.num_factura then
        


        delete from cxcdocm
        where almacen = old.almacen
        and cliente = old.cliente
        and trim(documento) = trim(ls_documento)
        and caja = old.caja
        and docmto_aplicar = ls_docmto_aplicar
        and motivo_cxc = old.tipo;

        
    end if;
    
/*    
    delete from factura2_eys2
    where almacen = old.almacen
    and tipo = old.tipo
    and caja = old.caja
    and num_documento = old.num_documento;    
*/

    select into r_gral_forma_de_pago *
    from gral_forma_de_pago
    where forma_pago = new.forma_pago;

    select into r_fac_pagos * from fac_pagos
    where almacen = new.almacen
    and tipo = new.tipo
    and caja = new.caja
    and num_documento = new.num_documento;
    if not found then
        if r_gral_forma_de_pago.dias > 0 then
            insert into fac_pagos(almacen, tipo, num_documento, forma, monto, caja)
            values(new.almacen, new.tipo, new.num_documento, 6, 0, new.caja);
        else
            insert into fac_pagos(almacen, tipo, num_documento, forma, monto, caja)
            values(new.almacen, new.tipo, new.num_documento, 1, 0, new.caja);
        end if;
    end if;    
    
        
    if r_factmotivos.devolucion = ''S'' and new.num_factura <> 0 then
        update tal_ot1
        set tipo_factura = null, numero_factura = null, status = ''R''
        where almacen = new.almacen
        and caja = new.caja
        and tipo_factura in (select tipo from factmotivos where factura = ''S'')
        and numero_factura = new.num_factura;
        
        delete from adc_house_factura1
        where almacen = new.almacen
        and caja = new.caja
        and tipo in (select tipo from factmotivos where factura_fiscal = ''S'')
        and num_documento = new.num_factura;
        
        delete from adc_manejo_factura1
        where almacen = new.almacen
        and caja = new.caja
        and tipo in (select tipo from factmotivos where factura_fiscal = ''S'')
        and num_documento = new.num_factura;
        
        if new.despachar = ''S'' and new.tipo <> ''DA'' and new.num_factura <> 0 then
            select into r_factura1 * from factura1
            where almacen = new.almacen
            and cliente = new.cliente
            and caja = new.caja
            and tipo in (select tipo from factmotivos where factura_fiscal = ''S'')
            and (fecha_despacho is null or despachar = ''N'')
            and num_documento = new.num_factura;
            if found then
                    update factura1
                    set despachar = ''S'',
                    fecha_despacho = new.fecha_factura
                    where almacen = r_factura1.almacen
                    and caja = r_factura1.caja
                    and tipo = r_factura1.tipo
                    and num_documento = r_factura1.num_documento;
            end if;
        end if;
    end if;

--raise exception ''after update'';

    
    if r_factmotivos.factura_fiscal = ''S'' then
        for r_adc_house_factura1 in select * from adc_house_factura1
                            where adc_house_factura1.almacen = new.almacen
                            and adc_house_factura1.tipo = new.tipo
                            and adc_house_factura1.num_documento = new.num_documento
                            and adc_house_factura1.caja = new.caja
                            and linea_manejo is not null
                            order by consecutivo
        loop
            update adc_manejo
            set fecha = new.fecha_factura
            where compania = r_adc_house_factura1.compania
            and consecutivo = r_adc_house_factura1.consecutivo
            and linea_master = r_adc_house_factura1.linea_master
            and linea_house = r_adc_house_factura1.linea_house
            and linea_manejo = r_adc_house_factura1.linea_manejo;
        end loop;    
    end if;

    
    if old.num_documento <> new.num_documento then
--raise exception ''after update final % % % %'', old.almacen_aplica, old.caja_aplica, old.tipo_aplica, old.num_documento;

        update factura1
        set num_factura = new.num_documento
        where almacen_aplica = old.almacen_aplica
        and caja_aplica = old.caja_aplica
        and tipo_aplica = old.tipo_aplica
        and num_factura = old.num_documento;
    end if;
  
/*  
    update invparal
    set valor = ''S''
    where parametro = ''valida_existencias'';
*/
        
    return new;
end;
' language plpgsql;



create function f_precios_por_cliente_1_before_insert() returns trigger as '
declare
    r_work record;
    li_secuencia int4;
begin
    if new.secuencia > 0 then
        return new;
    end if;
    
    li_secuencia = 1;
    loop
        select into r_work * from precios_por_cliente_1
        where secuencia = li_secuencia;
        if found then
            li_secuencia = li_secuencia + 1;
        else
            exit;            
        end if;
    end loop;
    
    new.secuencia = li_secuencia;
    return new;
end;
' language plpgsql;



create function f_factura2_before_insert() returns trigger as '
declare
    r_factura1 record;
    r1_factura1 record;
    r2_factura1 record;
    r_factura2 record;
    r_factmotivos record;
    r_work record;
    r_almacen record;
    r_fac_cajas record;
    r_articulos record;
    r_articulos_por_almacen record;
    lc_metodo_calculo char(20);
    ldc_valor_factura decimal(10,2);
    ldc_valor_da decimal(10,2);
    ldc_existencia decimal;
    ldc_cantidad decimal;
    ldc_cu decimal(12,2);
    ldc_margen decimal(12,2);
begin
/*
    select into r_fac_cajas *
    from fac_cajas
    where almacen = new.almacen
    and status = ''A'';
    if not found then
        Raise Exception ''Caja no Existe para almacen %'', new.almacen;
    else
        new.caja = r_fac_cajas.caja;
    end if;
*/

    select into r_fac_cajas *
    from fac_cajas
    where almacen = new.almacen
    and caja = new.caja;
    if not found then
        Raise Exception ''Almacen % Caja % no Existe'', new.almacen, new.caja;
    end if;

    if r_fac_cajas.status <> ''A'' then
        Raise Exception ''Almacen % Caja % esta Inactivo...Verifique'', new.almacen, new.caja;
    end if;
    
    select into r_articulos *
    from articulos
    where trim(articulo) = trim(new.articulo);
    if found then
        if r_articulos.status_articulo = ''I'' then
            Raise Exception ''Articulo % esta inactivo'', new.articulo;
        end if;
    end if;
    
    if new.precio is null then
        new.precio = 0;
    end if;
    
    if new.cantidad is null then
        new.cantidad = 0;
    end if;
    
    if new.descuento_linea is null then
        new.descuento_linea = 0;
    end if;
    
    if new.descuento_global is null then
        new.descuento_global = 0;
    end if;
    
    select into r_almacen *
    from almacen
    where almacen = new.almacen;
    
    lc_metodo_calculo = Trim(f_gralparaxcia(r_almacen.compania, ''PLA'', ''metodo_calculo''));

    select into r_factura1 *
    from factura1
    where almacen = new.almacen
    and caja = new.caja
    and tipo = new.tipo
    and num_documento = new.num_documento;
    if not found then
        raise exception ''Factura % no existe en el almacen % Caja % tipo %'', new.num_documento, new.almacen, new.caja, new.tipo;
    end if;


    select into r_factura2 *
    from factura2
    where almacen = new.almacen
    and tipo = new.tipo
    and caja = new.caja
    and num_documento = new.num_documento
    and linea = new.linea;
    if found then
--        raise exception ''cliente % almacen % tipo % documento % linea % ya existe en factura2'',r_factura1.cliente, new.almacen, new.tipo, new.num_documento, new.linea;
        loop
            new.linea = new.linea + 1;
            select into r_factura2 *
            from factura2
            where almacen = new.almacen
            and tipo = new.tipo
            and caja = new.caja
            and num_documento = new.num_documento
            and linea = new.linea;
            if not found then
                exit;
            end if;
        end loop;
    end if;
    
    select into r_factmotivos *
    from factmotivos
    where tipo = new.tipo;
    
    
    if (r_factmotivos.devolucion = ''S'' and r_factmotivos.nota_credito = ''N'')
        or new.tipo = ''DA'' then
        if r_factura1.num_factura = 0 then
            raise exception ''En las devoluciones o DA el numero de factura es obligario...Devolucion No. %'',new.num_documento;
        end if;
        
        select into r_work factura2.*
        from factura1, factura2, factmotivos
        where factura1.almacen = factura2.almacen
        and factura1.tipo = factura2.tipo
        and factura1.num_documento = factura2.num_documento
        and factura1.tipo = factmotivos.tipo
        and factura1.num_documento = r_factura1.num_factura
        and factura2.articulo = new.articulo
        and (factmotivos.factura_fiscal = ''S'' or factmotivos.factura = ''S'');
        if not found then
            raise exception ''Articulo % no pertenece a factura %  ...Verifique'',new.articulo, r_factura1.num_factura;
        end if;

        if trim(new.tipo) = ''DA'' then
            ldc_valor_factura   = (r_work.cantidad * r_work.precio) - 
                                    r_work.descuento_linea - r_work.descuento_global;
            ldc_valor_da        =   (new.cantidad * new.precio) -
                                    new.descuento_linea - new.descuento_global;
            if ldc_valor_da > ldc_valor_factura then
                Raise Exception ''Monto de DA % no puede ser mayor factura en articulo % Valor Factura%'',ldc_valor_da, new.articulo, ldc_valor_factura;
            end if;    
        end if;        

    end if;
    
    if trim(lc_metodo_calculo) = ''harinas'' and trim(new.tipo) = ''9'' then
        select into r_work factura2.*
        from factura1, factura2, factmotivos
        where factura1.almacen = factura2.almacen
        and factura1.tipo = factura2.tipo
        and factura1.num_documento = factura2.num_documento
        and factura1.tipo = factmotivos.tipo
        and factura1.num_documento = r_factura1.num_factura
        and factura2.articulo = new.articulo
        and (factmotivos.factura_fiscal = ''S'' or factmotivos.factura = ''S'');
        if not found then
            raise exception ''Articulo % no pertenece a factura %  ...Verifique'',new.articulo, r_factura1.num_factura;
        end if;
    end if;

    select into r_articulos *
    from articulos
    where trim(articulo) = trim(new.articulo);
    if found then
        if r_articulos.status_articulo = ''I'' then
            Raise Exception ''Articulo % esta inactivo'', new.articulo;
        end if;
        
        if (r_factmotivos.factura = ''S'' or r_factmotivos.factura_fiscal = ''S'' 
            or r_factmotivos.donacion = ''S''
            or r_factmotivos.promocion = ''S'')
            and f_invparal(new.almacen, ''valida_existencias'') = ''S'' 
            and r_articulos.servicio = ''N'' then
            ldc_existencia = f_stock(new.almacen, new.articulo, current_date, 0, 0, ''STOCK'');
        
            if new.cantidad > ldc_existencia then
                Raise Exception ''Almacen % Articulo % Existencia % no tiene existencia para este pedido...Verifique'', new.almacen, new.articulo, ldc_existencia;
            end if;        
        end if;

/*        
        if (r_factmotivos.factura = ''S'' or r_factmotivos.factura_fiscal = ''S'')
             and r_articulos.servicio = ''N'' then
            
            select into r_articulos_por_almacen *            
            from articulos_por_almacen
            where almacen = new.almacen
            and articulo = new.articulo;
            if not found then
                Raise Exception ''Almacen % Articulo % no Existe'', new.almacen, new.articulo;
            end if;

            if r_articulos_por_almacen.margen_minimo > 0 then
                if r_articulos_por_almacen.existencia <= 0 or r_articulos_por_almacen.costo <= 0 then
                    ldc_cu = 0;
                else
                    ldc_cu = r_articulos_por_almacen.costo / r_articulos_por_almacen.existencia;
                end if;
            
                if ldc_cu > new.precio then
                    Raise Exception ''Articulo % Costo Unitario % no puede mayor que el precio %'',new.articulo, ldc_cu, new.precio;
                end if;    
            
                ldc_margen  =   ((new.precio - ldc_cu) / new.precio) * 100;
                
                if ldc_margen < r_articulos_por_almacen.margen_minimo then
                    Raise Exception ''Almacen % Articulo % Costo % Precio % Margen % Venta no cubre margen minimo %'', new.almacen, new.articulo, ldc_cu, new.precio, ldc_margen, r_articulos_por_almacen.margen_minimo;
                end if;
            end if;            
        end if;            
*/
        
    end if;

    if r_factmotivos.devolucion = ''S'' then
        select into r1_factura1 *
        from factura1
        where almacen = new.almacen
        and tipo = new.tipo
        and caja = new.caja
        and num_documento = new.num_documento;
        if not found then
            Raise Exception ''Almacen % Caja % Tipo % Documento % no Existe'',new.almacen, new.caja, new.tipo, new.num_documento;
        end if;
        
        select into r2_factura1 *
        from factura1
        where almacen = r1_factura1.almacen_aplica
        and tipo = r1_factura1.tipo_aplica
        and caja = r1_factura1.caja_aplica
        and num_documento = r1_factura1.num_factura;
        if not found then
            Raise Exception ''Almacen % Caja % Tipo % Documento % Para Anular no Existe'',r1_factura1.almacen_aplica, r1_factura1.caja_aplica, r1_factura1.tipo_aplica, r1_factura1.num_factura;
        end if;

        select into r_factura2 *
        from factura2
        where almacen = r1_factura1.almacen_aplica
        and tipo = r1_factura1.tipo_aplica
        and caja = r1_factura1.caja_aplica
        and num_documento = r1_factura1.num_factura
        and articulo = new.articulo;
        if not found then
            Raise Exception ''Almacen % Caja % Tipo % Documento % Articulo % No existe en este documento '',r_factura1.almacen_aplica, r_factura1.caja_aplica, r_factura1.tipo_aplica, r_factura1.num_factura, new.articulo;
        end if;

        ldc_cantidad = 0;
        select sum(cantidad) into ldc_cantidad
        from factura1, factura2
        where factura1.almacen = factura2.almacen
        and factura1.caja = factura2.caja
        and factura1.tipo = factura2.tipo
        and factura1.num_documento = factura2.num_documento
        and factura1.status <> ''A''
        and factura1.almacen_aplica = r1_factura1.almacen_aplica
        and factura1.num_documento <> r1_factura1.num_documento
        and factura1.tipo_aplica = r1_factura1.tipo_aplica
        and factura1.caja_aplica = r1_factura1.caja_aplica
        and factura1.num_factura = r1_factura1.num_factura
        and factura2.articulo = new.articulo;
        if ldc_cantidad is null then
            ldc_cantidad = 0;
        end if;

--        raise exception ''% '', ldc_cantidad;

        ldc_cantidad = ldc_cantidad + new.cantidad;
                        
        if ldc_cantidad > r_factura2.cantidad then
--            Raise Exception ''Almacen % Caja % Tipo % Documento % Articulo % Ya fue devuelta % %'',r1_factura1.almacen_aplica, r1_factura1.caja_aplica, r1_factura1.tipo_aplica, r1_factura1.num_factura, new.articulo, ldc_cantidad, r_factura2.cantidad;
        end if;
        
    end if;

        
    return new;
end;
' language plpgsql;



create function f_fac_z_after_update() returns trigger as '
declare
    r_fac_cajas record;
    r_fac_z record;
    r_factura1 record;
    secuencia int4;
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    
    if new.status = ''C'' then
        select into r_factura1 *
        from factura1
        where almacen = old.almacen
        and caja = old.caja
        and sec_z = old.sec_z;
        if not found then
/*        
            if f_gralparaxcia(r_almacen.compania, ''PLA'', ''metodo_calculo'') <> ''homes'' then
                raise exception ''Esta Z % no puede ser cerrada no tiene movimientos'',old.sec_z;
            end if;
*/            
        end if;
        
        
        new.fecha   =   current_date;
        new.hora    =   current_time;
    
        select into r_fac_cajas * from fac_cajas
        where caja = new.caja
        and almacen = new.almacen;
        
        secuencia = r_fac_cajas.sec_z;
        loop
            select into r_fac_z * from fac_z
            where caja = new.caja
            and almacen = new.almacen
            and sec_z = secuencia;
            if not found then
               exit;
            else
                if r_fac_z.status = ''A'' then
                    exit;
                end if;
            end if;
            secuencia = secuencia + 1;            
        end loop;
        
        update fac_cajas
        set sec_z = secuencia
        where almacen = new.almacen
        and caja = new.caja;
        
    end if;
    return new;
end;
' language plpgsql;


create function f_fac_cajas_after_insert() returns trigger as '
declare
    r_fac_z record;
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    
    select into r_fac_z * from fac_z
    where caja = new.caja
    and almacen = new.almacen
    and sec_z = new.sec_z;
    if not found then
        insert into fac_z (caja, almacen, sec_z, status, fecha, hora, usuario)
        values (new.caja, new.almacen, new.sec_z, ''A'', current_date, current_time, current_user);
    end if;

    return new;
end;
' language plpgsql;


create function f_fac_cajas_after_update() returns trigger as '
declare
    r_fac_z record;
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/    
    select into r_fac_z * from fac_z
    where caja = new.caja
    and almacen = new.almacen
    and sec_z = new.sec_z;
    if not found then
        insert into fac_z (caja, almacen, sec_z, status, fecha, hora, usuario)
        values (new.caja, new.almacen, new.sec_z, ''A'', current_date, current_time, current_user);
    end if;

    return new;
end;
' language plpgsql;


create function f_factura2_before_update() returns trigger as '
declare
    r_factura1 record;
    r_factmotivos record;
    r_articulos record;
    ls_documento char(25);
    ldc_existencia decimal;
    i integer;
begin


    delete from rela_factura1_cglposteo
    where almacen = old.almacen
    and tipo = old.tipo
    and caja = old.caja
    and num_documento = old.num_documento;
    
    delete from factura2_eys2
    where almacen = old.almacen
    and tipo = old.tipo
    and caja = old.caja
    and num_documento = old.num_documento
    and factura2_linea = old.linea;

    
    
    select into r_factura1 *
    from factura1
    where almacen = old.almacen
    and caja = old.caja
    and tipo = old.tipo
    and num_documento = old.num_documento;
    if found then
        ls_documento    =   old.num_documento;
    
        select into i count(*) from cxcdocm
        where almacen = old.almacen
        and cliente = r_factura1.cliente
        and trim(docmto_ref) = trim(ls_documento)
        and trim(docmto_aplicar) = trim(ls_documento)
        and motivo_ref = old.tipo
        and monto <> 0;
        if i is null then
            i := 0;
        end if;
    
        if i > 1 then
            raise exception ''Factura % tiene documentos aplicando a ella...No se puede modificar...Verifique'', old.num_documento;
        end if;
    
        delete from cxcdocm
        where almacen = old.almacen
        and cliente = r_factura1.cliente
        and caja = old.caja
        and motivo_cxc = old.tipo
        and trim(documento) = trim(ls_documento)
        and trim(docmto_aplicar) = trim(ls_documento);
    end if;


    select into r_articulos *
    from articulos
    where trim(articulo) = trim(new.articulo);
    if found then
        if r_articulos.status_articulo = ''I'' then
            Raise Exception ''Articulo % esta inactivo'', new.articulo;
        end if;


        select into r_factmotivos *
        from factmotivos
        where tipo = new.tipo;
    
        if (r_factmotivos.factura = ''S'' or r_factmotivos.factura_fiscal = ''S'' 
            or r_factmotivos.cotizacion = ''S'' or r_factmotivos.donacion = ''S''
            or r_factmotivos.promocion = ''S'')
            and f_invparal(new.almacen, ''valida_existencias'') = ''S'' 
            and r_articulos.servicio = ''N'' then
            ldc_existencia = f_stock(new.almacen, new.articulo, current_date, 0, 0, ''STOCK'');
        
            if new.cantidad - old.cantidad > ldc_existencia then
                Raise Exception ''Almacen % Articulo % Existencia % no tiene existencia para este pedido...Verifique'', new.almacen, new.articulo, ldc_existencia;
            end if;        
        
        end if;
    end if;    
    
    return new;
end;
' language plpgsql;

create function f_factura4_before_update() returns trigger as '
declare
    r_factura1 record;
    ls_documento char(25);
    i integer;
begin

/*
    delete from rela_factura1_cglposteo
    where almacen = old.almacen
    and tipo = old.tipo
    and caja = old.caja
    and num_documento = old.num_documento;
    
    delete from factura2_eys2
    where almacen = old.almacen
    and tipo = old.tipo
    and caja = old.caja
    and num_documento = old.num_documento;
*/
    
    select into r_factura1 *
    from factura1
    where almacen = old.almacen
    and tipo = old.tipo
    and caja = old.caja
    and num_documento = old.num_documento;
    if found then
        ls_documento    :=   old.num_documento;
    
        select into i count(*) from cxcdocm
        where almacen = old.almacen
        and cliente = r_factura1.cliente
        and caja = old.caja
        and trim(docmto_ref) = trim(ls_documento)
        and trim(docmto_aplicar) = trim(ls_documento)
        and motivo_ref = old.tipo
        and monto <> 0;
        if i is null then
            i := 0;
        end if;
    
        if i > 1 then
            raise exception ''Factura % tiene documentos aplicando a ella...No se puede modificar...Verifique'', old.num_documento;
        end if;
    
        delete from cxcdocm
        where almacen = old.almacen
        and cliente = r_factura1.cliente
        and motivo_cxc = old.tipo
        and caja = old.caja
        and trim(documento) = trim(ls_documento)
        and trim(docmto_aplicar) = trim(ls_documento);
    end if;

    
    return new;
end;
' language plpgsql;


create function f_factura2_before_delete() returns trigger as '
declare
    r_factura1 record;
    ls_documento char(25);
    ls_docmto_aplicar char(25);
    i integer;
begin

/*
    delete from factura2_eys2
    where almacen = old.almacen
    and tipo = old.tipo
    and caja = old.caja
    and num_documento = old.num_documento
    and factura2_linea = old.linea;

    delete from rela_factura1_cglposteo
    where almacen = old.almacen
    and caja = old.caja
    and tipo = old.tipo
    and num_documento = old.num_documento;
*/

    select into r_factura1 *
    from factura1
    where almacen = old.almacen
    and caja = old.caja
    and tipo = old.tipo
    and num_documento = old.num_documento;
    if found then
        ls_documento    :=   old.num_documento;
        
        if r_factura1.num_factura = 0 then
            ls_docmto_aplicar = r_factura1.num_documento;
        else
            ls_docmto_aplicar = r_factura1.num_factura;
        end if;
    
        select into i count(*) from cxcdocm
        where almacen = old.almacen
        and cliente = r_factura1.cliente
        and trim(docmto_ref) = trim(ls_documento)
        and trim(docmto_aplicar) = trim(ls_documento)
        and motivo_ref = old.tipo
        and monto <> 0;
        if i is null then
            i := 0;
        end if;
    
        if i > 1 then
--            raise exception ''Factura % tiene documentos aplicando a ella...No se puede eliminar...Verifique'', old.num_documento;
        end if;
    
        delete from cxcdocm
        where almacen = old.almacen
        and cliente = r_factura1.cliente
        and motivo_cxc = old.tipo
        and caja = old.caja
        and trim(documento) = trim(ls_documento)
        and trim(docmto_aplicar) = trim(ls_docmto_aplicar);
    end if;
    
    return old;
end;
' language plpgsql;


create function f_factura4_before_delete() returns trigger as '
declare
    r_factura1 record;
    ls_documento char(25);
    i integer;
begin
    if old.monto = 0 then
        return old;
    end if;
/*    
    delete from rela_factura1_cglposteo
    where almacen = old.almacen
    and tipo = old.tipo
    and caja = old.caja
    and num_documento = old.num_documento;

    delete from factura2_eys2
    where almacen = old.almacen
    and tipo = old.tipo
    and caja = old.caja
    and num_documento = old.num_documento;
*/

    select into r_factura1 *
    from factura1
    where almacen = old.almacen
    and tipo = old.tipo
    and caja = old.caja
    and num_documento = old.num_documento;
    if found then
        ls_documento    :=   old.num_documento;
    
        select into i count(*) from cxcdocm
        where almacen = old.almacen
        and cliente = r_factura1.cliente
        and caja = old.caja
        and trim(docmto_ref) = trim(ls_documento)
        and trim(docmto_aplicar) = trim(ls_documento)
        and motivo_ref = old.tipo
        and monto <> 0;
        if i is null then
            i := 0;
        end if;
    
        if i > 1 then
            raise exception ''Factura % tiene documentos aplicando a ella...No se puede eliminar...Verifique'', old.num_documento;
        end if;
    
        delete from cxcdocm
        where almacen = old.almacen
        and cliente = r_factura1.cliente
        and motivo_cxc = old.tipo
        and caja = old.caja
        and trim(documento) = trim(ls_documento)
        and trim(docmto_aplicar) = trim(ls_documento);
    end if;
    
    return old;
end;
' language plpgsql;


create function f_factura2_eys2_before_delete() returns trigger as '
begin
    
    delete from eys2
    where almacen = old.almacen
    and no_transaccion = old.no_transaccion
    and articulo = old.articulo
    and linea = old.eys2_linea;
    
    return old;
end;
' language plpgsql;


create function f_factura2_eys2_before_update() returns trigger as '
begin
    delete from eys2
    where almacen = old.almacen
    and no_transaccion = old.no_transaccion
    and articulo = old.articulo
    and linea = old.eys2_linea;

    return new;
end;
' language plpgsql;


create function f_rela_factura1_cglposteo_before_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;




create function f_rela_factura1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;



create function f_factura1_after_delete() returns trigger as '
declare
    ls_documento char(25);
    r_almacen record;
    r_factmotivos record;
    ls_docmto_aplicar char(25);
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
/*
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/    
    
    select into r_factmotivos * from factmotivos
    where tipo = old.tipo
    and cotizacion = ''S'';
    if found then
        return old;
    end if;
    
    select into r_almacen * from almacen
    where almacen = old.almacen;
    
    i := f_valida_fecha(r_almacen.compania, ''CGL'', old.fecha_factura);
    i := f_valida_fecha(r_almacen.compania, ''INV'', old.fecha_factura);
    i := f_valida_fecha(r_almacen.compania, ''CXC'', old.fecha_factura);
    
    ls_documento    =   old.num_documento;
    
    if old.num_factura = 0 then
        ls_docmto_aplicar = old.num_documento;
    else
        ls_docmto_aplicar = old.num_factura;
    end if;

/*    
    select into i count(*) from cxcdocm
    where almacen = old.almacen
    and cliente = old.cliente
    and docmto_ref = ls_documento
    and docmto_aplicar = ls_documento
    and motivo_ref = old.tipo
    and monto <> 0;
    if i is null then
        i := 0;
    end if;

    
    if i > 1 then
        raise exception ''Factura % tiene documentos aplicando a ella...No se puede modificar/eliminar...Verifique'', old.num_documento;
    end if;
*/

    
    delete from cxcdocm
    where almacen = old.almacen
    and cliente = old.cliente
    and motivo_cxc = old.tipo
    and caja = old.caja
    and trim(documento) = trim(ls_documento)
    and trim(docmto_aplicar) = trim(ls_docmto_aplicar);
    
    return old;
end;
' language plpgsql;



create function f_factura1_after_insert() returns trigger as '
declare
    r_almacen record;
    r_fac_pagos record;
    r_gral_forma_de_pago record;
    ls_documento char(25);
    r_factmotivos record;
    r_factura1 record;
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/    

    select into r_factmotivos * from factmotivos
    where tipo = new.tipo;
    if not found then
        raise exception ''Tipo de Documento % no Existe...Verifique'',new.tipo;
    end if;
    
    if r_factmotivos.cotizacion = ''S'' then
        return new;
    end if;
    

    select into r_gral_forma_de_pago *
    from gral_forma_de_pago
    where forma_pago = new.forma_pago;

    select into r_fac_pagos * from fac_pagos
    where almacen = new.almacen
    and tipo = new.tipo
    and caja = new.caja
    and num_documento = new.num_documento;
    if not found then
        if r_gral_forma_de_pago.dias > 0 then
            insert into fac_pagos(almacen, tipo, num_documento, forma, monto, caja)
            values(new.almacen, new.tipo, new.num_documento, 6, 0, new.caja);
        else
            insert into fac_pagos(almacen, tipo, num_documento, forma, monto, caja)
            values(new.almacen, new.tipo, new.num_documento, 1, 0, new.caja);
        end if;
    end if;    
    
    
    if r_factmotivos.devolucion = ''S'' and new.num_factura <> 0 then
        update tal_ot1
        set tipo_factura = null, numero_factura = null, status = ''R''
        where almacen = new.almacen
        and caja = new.caja
        and tipo_factura in (select tipo from factmotivos where factura = ''S'')
        and numero_factura = new.num_factura;

/*        
        delete from adc_house_factura1
        where almacen = new.almacen
        and tipo in (select tipo from factmotivos where factura_fiscal = ''S'')
        and num_documento = new.num_factura;
*/
        
        delete from adc_manejo_factura1
        where almacen = new.almacen
        and caja = new.caja
        and tipo in (select tipo from factmotivos where factura_fiscal = ''S'')
        and num_documento = new.num_factura;
        
/*        
        update adc_notas_debito_1
        set almacen = null, tipo = null, num_documento = null
        where almacen = new.almacen
        and tipo in (select tipo from factmotivos where factura_fiscal = ''S'')
        and num_documento = new.num_factura;
*/        

        if new.despachar = ''S'' and new.tipo <> ''DA'' and new.num_factura <> 0 then
            select into r_factura1 * from factura1
            where almacen = new.almacen
            and cliente = new.cliente
            and caja = new.caja
            and tipo in (select tipo from factmotivos where factura_fiscal = ''S'')
            and (fecha_despacho is null or despachar = ''N'')
            and num_documento = new.num_factura;
            if found then
                    update factura1
                    set despachar = ''S'',
                    fecha_despacho = new.fecha_despacho
                    where almacen = r_factura1.almacen
                    and caja = r_factura1.caja
                    and tipo = r_factura1.tipo
                    and num_documento = r_factura1.num_documento;
            end if;
        end if;

    end if;
    
    return new;
end;
' language plpgsql;



create function f_factura2_after_insert() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/    

    if Trim(f_invparal(new.almacen, ''update_inventario'')) = ''S'' then
        i = f_factura2_eys2(new.almacen, new.tipo, new.num_documento, new.caja, new.linea);
    end if;
    i = f_factura2_factura3(new.almacen, new.tipo, new.num_documento, new.caja, new.linea);
    return new;
end;
' language plpgsql;




create function f_factura2_after_update() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/    

/*
    delete from factura2_eys2
    where almacen = old.almacen
    and tipo = old.tipo
    and caja = old.caja
    and num_documento = old.num_documento;


    delete from rela_factura1_cglposteo
    where almacen = old.almacen
    and tipo = old.tipo
    and caja = old.caja
    and num_documento = old.num_documento;
*/

    
    if Trim(f_invparal(new.almacen, ''update_inventario'')) = ''S'' then
        i = f_factura2_eys2(new.almacen, new.tipo, new.num_documento, new.caja, new.linea);
    end if;
    i = f_factura2_factura3(new.almacen, new.tipo, new.num_documento, new.caja, new.linea);
    
    return new;
end;
' language plpgsql;


create function f_factura2_after_delete() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
/*
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/

/*
    delete from factura2_eys2
    where almacen = old.almacen
    and tipo = old.tipo
    and caja = old.caja
    and num_documento = old.num_documento;

    delete from rela_factura1_cglposteo
    where almacen = old.almacen
    and tipo = old.tipo
    and caja = old.caja
    and num_documento = old.num_documento;
*/
    
    return old;
end;
' language plpgsql;



create function f_factura1_before_insert() returns trigger as '
declare
    r_fac_cajas record;
    r_factura1 record;
    r_fac_z record;
    r_factmotivos record;
    r_almacen record;
    r_clientes record;
    r_vendedores record;
    r_choferes record;
    r_gralperiodos record;
    r_fact_referencias record;
    r_gral_forma_de_pago record;
    r_fac_ciudades record;
    r_cxcdocm record;
    i integer;
    lb_while boolean; 
    lc_metodo_calculo char(20);
    lc_documento char(25);
    lc_utiliza_fiscal char(1);
    lt_new_dato text;
    lt_old_dato text;
begin

/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/

    if new.facturar is null then
        new.facturar = ''N'';
    end if;
    
    if new.ciudad_origen is null then
        select into r_fac_ciudades *
        from fac_ciudades
        order by ciudad;
        if found then
            new.ciudad_origen = r_fac_ciudades.ciudad;
        end if;            
    end if;

    if new.ciudad_destino is null then
        select into r_fac_ciudades *
        from fac_ciudades
        order by ciudad;
        if found then
            new.ciudad_destino = r_fac_ciudades.ciudad;
        end if;            
    end if;


    if new.almacen_aplica is null then
        new.almacen_aplica = new.almacen;
    end if;
    
    if new.tipo_aplica is null then
        new.tipo_aplica = new.tipo;
    end if;
    
    if new.caja_aplica is null then
        new.caja_aplica = new.caja;
    end if;
                    
    
    new.documento   =   trim(to_char(new.num_documento, ''99999999999999''));

    select into r_almacen * from almacen
    where almacen = new.almacen;
    if not found then
        raise exception ''Almacen no Existe...Verifique'';
    end if;

    select into r_fac_cajas * from fac_cajas
    where almacen = new.almacen
    and caja = new.caja;
    if not found then
        select into r_fac_cajas * from fac_cajas
        where almacen = new.almacen
        and status = ''A'';
        if not found then
            Raise Exception ''No existe caja para este almacen'';
        else
            new.caja = r_fac_cajas.caja;            
        end if;
    end if;

    select into r_factura1 *
    from factura1
    where almacen = new.almacen
    and tipo = new.tipo
    and caja = new.caja
    and num_documento = new.num_documento;
    if found then
        raise exception ''Numero de documento % ya existe en el almacen % caja % tipo de documento  %'',new.num_documento, new.almacen, new.caja, new.tipo;
    end if;


    lb_while = false;
    if new.referencia is null then
        for r_fact_referencias in select * from fact_referencias
                            order by referencia
        loop
            lb_while = true;
            new.referencia = r_fact_referencias.referencia;
            exit;
        end loop;
        if lb_while = false then
            Raise Exception ''No existe ninguna referencia...Verifique'';
        end if;
    end if;

    if new.agente is null then
        new.agente = new.cliente;
    end if;    
    
    select into r_almacen * from almacen
    where almacen = new.almacen;
    if not found then
        raise exception ''Almacen no Existe...Verifique'';
    end if;

    lc_metodo_calculo = Trim(f_gralparaxcia(r_almacen.compania, ''PLA'', ''metodo_calculo''));
    lc_utiliza_fiscal = Trim(f_gralparaxcia(r_almacen.compania, ''FAC'', ''utiliza_fiscal''));
        
    select into r_clientes * from clientes
    where cliente = new.cliente and status = ''I'';
    if found then
        raise exception ''Cliente % Esta Inactivo...Verifique'',new.cliente;
    end if;
    
    if new.codigo_vendedor is null then
        for r_vendedores in select * 
                            from vendedores 
                            where codigo is not null 
                            and status = ''A'' order by codigo
        loop
            new.codigo_vendedor = r_vendedores.codigo;
        end loop;
    else
        select into r_vendedores *
        from vendedores
        where Trim(codigo) = Trim(new.codigo_vendedor);
        if not found then
            Raise Exception ''Vendedor % no Existe'', new.codigo_vendedor;
        else
            if r_vendedores.status <> ''A'' then
                Raise Exception ''Vendedor % esta Inactivo'',new.codigo_vendedor;
            end if;
        end if;
    end if;
    
    if trim(lc_metodo_calculo) = ''harinas'' then
        select into r_clientes * 
        from clientes
        where cliente = new.cliente;
        new.codigo_vendedor = r_clientes.vendedor;
    end if;
    

    if new.chofer is null then
        for r_choferes in select * from choferes order by chofer
        loop
            new.chofer = r_choferes.chofer;
            exit;
        end loop;
    end if;
    
    if lc_metodo_calculo = ''airsea'' then
        select into r_gral_forma_de_pago * from gral_forma_de_pago
        where forma_pago = new.forma_pago
        and dias >= 1;
        if not found then
            select into r_gral_forma_de_pago * from gral_forma_de_pago
            where dias >= 1
            order by dias;
            if not found then
                raise exception ''Debe existir la forma de pago credito'';
            else
                new.forma_pago = r_gral_forma_de_pago.forma_pago;
            end if;
        end if;
    end if;
    
    
    select into r_factmotivos * from factmotivos
    where tipo = new.tipo
    and cotizacion = ''S'';
    if found then
        return new;
    end if;

    
    if new.fecha_factura >= ''2012-03-01'' and trim(lc_utiliza_fiscal) = ''S'' then
        select into r_factmotivos * from factmotivos
        where tipo = new.tipo
        and factura = ''S'';
        if found then
            Raise Exception ''Este tipo de transaccion % no es valido'',new.tipo;
        end if;
    end if;

    
    if new.codigo_vendedor is null then
        raise exception ''El codigo de vendedor es obligatorio...Verifique'';
    end if;
    
    if new.tipo = ''DA'' and new.despachar = ''S'' then
        new.despachar = ''N'';
        new.fecha_despacho = null;
--        raise exception ''Las comisiones no se despachan'';
    end if;
    
    if new.tipo = ''DA'' and new.descto_porcentaje = 0 and new.descto_monto = 0 then
        raise Exception ''En los DA el monto a pagar o porcentaje es obligatorio'';
    end if;
    
    
    i := f_valida_fecha(r_almacen.compania, ''CGL'', new.fecha_factura);
    i := f_valida_fecha(r_almacen.compania, ''INV'', new.fecha_factura);
    i := f_valida_fecha(r_almacen.compania, ''CXC'', new.fecha_factura);
    i := f_valida_fecha(r_almacen.compania, ''CGL'', new.fecha_postea);

    
    if new.sec_z is null then
        new.sec_z = 0;
    end if;


    select into r_fac_z * from fac_z
    where caja = new.caja
    and almacen = new.almacen
    and status = ''A'';
    if not found then
        i = 0;
        lb_while = true;
        while lb_while loop
            i = i + 1;
            select into r_fac_z * from fac_z
            where caja = new.caja
            and almacen = new.almacen
            and sec_z = i;
            if not found then
                lb_while = false;
            end if;
        end loop;
        
        insert into fac_z(caja, almacen, sec_z, status, fecha, hora, usuario)
        values(new.caja, new.almacen, i, ''A'', current_date, current_time, current_user);
        
        update fac_cajas
        set sec_z = i
        where almacen = new.almacen
        and caja = new.caja;
        
        new.sec_z = i;
        
    end if;      
    
    select into r_fac_z * from fac_z
    where caja = new.caja
    and almacen = new.almacen
    and sec_z = new.sec_z;
    if not found then
        insert into fac_z (caja, almacen, sec_z, status, fecha, hora, usuario)
        values (new.caja, new.almacen, new.sec_z, ''A'', current_date, current_time, current_user);
    else
        if r_fac_z.status = ''C'' then
/*        
            select into r_factmotivos * from factmotivos
            where tipo = new.tipo
            and (factura = ''S'' or devolucion = ''S'');
            if found then
                raise exception ''Factura % no puede ser creada pertenece a un turno % cerrado...Verifique'',new.num_documento, new.sec_z;
            end if;
*/            
        else
            update fac_z
            set fecha = current_date, hora = current_time, usuario = current_user
            where caja = new.caja
            and almacen = new.almacen
            and sec_z = new.sec_z;
        end if;
    end if;
    
    select into r_factmotivos * 
    from factmotivos
    where tipo = new.tipo;

    if r_factmotivos.devolucion = ''S'' and new.num_factura = 0 then
        raise exception ''En las devoluciones % el numero de factura aplicar es obligatorio'',new.num_documento;
    end if;
    
    if r_factmotivos.devolucion <> ''S'' and new.num_factura <> 0 and new.tipo <> ''DA'' then
        raise exception ''Solo se puede aplicar a otro documento con devoluciones...Verifique'';
    end if;
    

    if r_factmotivos.devolucion = ''S'' and new.num_factura <> 0 and new.tipo <> ''DA'' then
        select into r_factura1 *
        from factura1
        where almacen = new.almacen_aplica
        and caja = new.caja_aplica
        and tipo = new.tipo_aplica
        and num_documento = new.num_factura;
        if not found then
            Raise Exception ''Almacen % Caja % Tipo % Factura % no Existe'', new.almacen_aplica, new.caja_aplica, new.tipo_aplica, new.num_factura;
        end if;

        lc_documento    =   Trim(To_Char(new.num_factura,''999999999999999''));
        
        
        select into r_cxcdocm *
        from cxcdocm
        where almacen = new.almacen_aplica
        and caja = new.caja_aplica
        and motivo_cxc = new.tipo_aplica
        and cliente = new.cliente
        and trim(documento) = trim(lc_documento)
        and trim(docmto_aplicar) = trim(lc_documento);
        if found then
            if f_saldo_documento_cxc(r_cxcdocm.almacen, r_cxcdocm.caja, r_cxcdocm.cliente,
                r_cxcdocm.motivo_cxc, r_cxcdocm.documento, current_date) <= 0 then
                    Raise Exception ''Almacen % Caja % Tipo % Factura % Ya Fue Cancelada'', new.almacen_aplica, new.caja_aplica, new.tipo_aplica, lc_documento;
            end if;                                        
        end if;
    end if;

    if new.num_factura <> 0 then 
        if new.tipo_aplica is null then
            select into new.tipo_aplica tipo
            from factmotivos
            where factura_fiscal = ''S'';
            if not found then
                select into new.tipo_aplica tipo
                from factmotivos
                where factura = ''S'';
            end if;
        else
            select into r_factmotivos * from factmotivos
            where tipo = new.tipo_aplica
            and (factura = ''S'' or factura_fiscal = ''S'');
            if not found then
                select into new.tipo_aplica tipo
                from factmotivos
                where factura_fiscal = ''S'';
                if not found then
                    select into new.tipo_aplica tipo
                    from factmotivos
                    where factura = ''S'';
                end if;
            end if;            
        end if;            

        select into r_factura1 *
        from factura1
        where almacen_aplica = new.almacen_aplica
        and cliente = new.cliente
        and caja_aplica = new.caja_aplica
        and tipo_aplica = new.tipo_aplica
        and status <> ''A''
        and tipo <> ''DA''
        and num_factura = new.num_factura;
        if found then
            if trim(lc_metodo_calculo) <> ''coolhouse'' then
--                Raise Exception ''Almacen % Caja % Tipo % Factura % ya fue anulada...Verifique'', new.almacen_aplica, new.caja_aplica, new.tipo_aplica, new.num_factura;
            end if;                
        end if;


        select into r_factmotivos * from factmotivos
        where factura_fiscal = ''S''
        and tipo = new.tipo;
        if found then
            raise exception ''Solo se puede aplicar a otro documento con devoluciones...Verifique'';
        end if;

        select into r_factura1 * from factura1
        where almacen = new.almacen_aplica
        and tipo = new.tipo_aplica
        and caja = new.caja_aplica
        and num_documento = new.num_factura;
        if not found then
            raise exception ''Almacen % Caja % Tipo % Factura %  No Existe...Verifique'',new.almacen_aplica, new.caja_aplica, new.tipo_aplica, new.num_factura;
        else
            if new.tipo = ''DA'' then
                select into r_gral_forma_de_pago * 
                from gral_forma_de_pago
                where forma_pago = r_factura1.forma_pago
                and dias >= 1;
                if found then
                    select into r_gral_forma_de_pago * 
                    from gral_forma_de_pago
                    where forma_pago = new.forma_pago
                    and dias = 0;
                    if found then
                        Raise Exception ''En una factura credito el DA no puede ser contado'';
                    end if;
                end if;
            else
                if trim(new.cliente) <> trim(r_factura1.cliente) then
                    Raise Exception ''Factura Referenciada no tiene el mismo cliente %  Cliente Factura % Cliente NC %'',new.num_factura, r_factura1.cliente, new.cliente;
                end if;
            
                new.forma_pago = r_factura1.forma_pago;
                
            end if;                
                                
        end if;
    end if;
    
    
    select into r_fac_cajas * from fac_cajas
    where almacen = new.almacen
    and caja = new.caja;
    if found then
        new.sec_z = r_fac_cajas.sec_z;
    end if;
    
    if lc_metodo_calculo = ''airsea'' then
        new.forma_pago = ''1'';
    end if;

    if new.referencia is null then
        new.referencia = ''NO'';
    end if;
    
    if trim(lc_metodo_calculo) = ''harinas'' then
        if trim(new.tipo) = ''9'' then
            new.despachar = ''S'';
            new.fecha_despacho = new.fecha_factura;
        end if;
    end if;
    
    if new.num_documento <= 0 then
        Raise Exception ''Numero de Factura no puede ser Cero...Verifique'';
    end if;
    
    return new;
end;
' language plpgsql;




create function f_factura1_before_delete() returns trigger as '
declare
    i integer;
    ls_documento char(25);
    r_factmotivos record;
    r_fac_z record;
    r_factura2 record;
    r_factura1 record;
    r_almacen record;
    lc_utiliza_fiscal char(1);
begin
    select into r_factmotivos * from factmotivos
    where tipo = old.tipo
    and cotizacion = ''S'';
    if found then
        update adc_notas_debito_1
        set almacen = null, tipo = null, num_documento = null
        where almacen = old.almacen
        and tipo = old.tipo
        and caja = old.caja
        and num_documento = old.num_documento;
        return old;
    end if;        

    i               =   0;
    ls_documento    =   old.num_documento;
    select count(*) into i
    from cxcdocm
    where almacen = old.almacen
    and cliente = old.cliente
    and trim(docmto_aplicar) = trim(ls_documento)
    and trim(docmto_ref) = trim(ls_documento)
    and trim(motivo_ref) = trim(old.tipo)
    and trim(caja) = trim(old.caja);
    if i > 1 then
        Raise Exception ''Factura Tiene documentos aplicandole...Verifique'';
    end if;
    
    i   =   f_delete_rela_factura1_cglposteo(old.almacen, old.caja, old.tipo, old.num_documento);
    

    select into r_factmotivos * from factmotivos
    where tipo = old.tipo
    and cotizacion = ''S'';
    if found then
        return old;
    end if;        

    select into r_almacen *
    from almacen
    where almacen = old.almacen;

    lc_utiliza_fiscal = Trim(f_gralparaxcia(r_almacen.compania, ''FAC'', ''utiliza_fiscal''));
    
    if lc_utiliza_fiscal = ''S'' then
        if f_gralparaxcia(r_almacen.compania, ''PLA'', ''metodo_calculo'') = ''conytram'' then
            select into r_factmotivos * from factmotivos
            where tipo = old.tipo;
            if found then
                if r_factmotivos.factura_fiscal = ''S'' and old.status = ''I'' then
    --                Raise Exception ''Factura Fiscal Impresa % no puede ser eliminada'', old.num_documento;
                end if;
            end if;        
        else
            select into r_factmotivos * from factmotivos
            where tipo = old.tipo;
            if found then
                if r_factmotivos.factura_fiscal = ''S'' then
--                    Raise Exception ''Factura Fiscal % no puede ser eliminada'', old.num_documento;
                end if;
            end if;        
        end if;
    end if;
    
    select into r_factura1 factura1.*
    from factura1, factmotivos
    where factura1.tipo = factmotivos.tipo
    and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
    and almacen = old.almacen
    and caja = old.caja
    and num_factura = old.num_documento;
    if found then
        Raise Exception ''Factura % no puede ser Eliminada...Tiene Devolucion aplicandole'', old.num_documento;
    end if;


    
    select into r_almacen * from almacen
    where almacen = old.almacen;
    
    i := f_valida_fecha(r_almacen.compania, ''CGL'', old.fecha_factura);
    i := f_valida_fecha(r_almacen.compania, ''INV'', old.fecha_factura);
    i := f_valida_fecha(r_almacen.compania, ''CXC'', old.fecha_factura);
    
    
    
    select into r_factura2 * from factura2, factmotivos
    where factura2.almacen = old.almacen
    and factura2.tipo = old.tipo
    and factura2.caja = old.caja
    and factura2.num_documento = old.num_documento
    and factura2.tipo = factmotivos.tipo
    and (factmotivos.factura = ''S'' or factmotivos.devolucion = ''S'');
    if found then
        select into r_fac_z * from fac_z
        where caja = old.caja
        and almacen = old.almacen
        and sec_z = old.sec_z
        and status = ''C'';
        if found then
            raise exception ''Factura % no puede ser modificada pertenece a un turno % cerrado...Verifique'',old.num_documento, old.sec_z;
        end if;
    end if;    
    
    ls_documento    :=   old.num_documento;
/*
    delete from rela_factura1_cglposteo
    where almacen = old.almacen
    and tipo = old.tipo
    and caja = old.caja
    and num_documento = old.num_documento;

    delete from factura2_eys2
    where almacen = old.almacen
    and tipo = old.tipo
    and caja = old.caja
    and num_documento = old.num_documento;
*/

    delete from cxcdocm
    where almacen = old.almacen
    and cliente = old.cliente
    and motivo_cxc = old.tipo
    and caja = old.caja
    and trim(documento) = trim(ls_documento);


    if old.status = ''A'' then
        delete from adc_house_factura1
        where almacen = old.almacen
        and tipo = old.tipo
        and caja = old.caja
        and num_documento = old.num_documento;
        
        delete from adc_manejo_factura1
        where almacen = old.almacen
        and tipo = old.tipo
        and caja = old.caja
        and num_documento = old.num_documento;
    end if;

        
    return old;
end;
' language plpgsql;


create trigger t_factura1_after_update after update on factura1
for each row execute procedure f_factura1_after_update();
create trigger t_factura1_before_update before update on factura1
for each row execute procedure f_factura1_before_update();
create trigger t_factura1_before_insert before insert on factura1
for each row execute procedure f_factura1_before_insert();
create trigger t_factura1_before_delete before delete on factura1
for each row execute procedure f_factura1_before_delete();
create trigger t_factura1_after_delete after delete on factura1
for each row execute procedure f_factura1_after_delete();
create trigger t_factura1_after_insert after insert on factura1
for each row execute procedure f_factura1_after_insert();


create trigger t_factura2_before_insert before insert on factura2
for each row execute procedure f_factura2_before_insert();
create trigger t_factura2_before_delete before delete on factura2
for each row execute procedure f_factura2_before_delete();
create trigger t_factura2_before_update before update on factura2
for each row execute procedure f_factura2_before_update();
create trigger t_factura2_after_delete after delete on factura2
for each row execute procedure f_factura2_after_delete();
create trigger t_factura2_after_update after update on factura2
for each row execute procedure f_factura2_after_update();
create trigger t_factura2_after_insert after insert on factura2
for each row execute procedure f_factura2_after_insert();



create trigger t_factura2_eys2_before_update before update on factura2_eys2
for each row execute procedure f_factura2_eys2_before_update();
create trigger t_factura2_eys2_before_delete before delete on factura2_eys2
for each row execute procedure f_factura2_eys2_before_delete();

create trigger t_factura4_before_update before update on factura4
for each row execute procedure f_factura4_before_update();
create trigger t_factura4_before_delete before delete on factura4
for each row execute procedure f_factura4_before_delete();
create trigger t_factura4_before_insert before insert on factura4
for each row execute procedure f_factura4_before_insert();

create trigger t_fac_cajas_after_insert after insert on fac_cajas
for each row execute procedure f_fac_cajas_after_insert();
create trigger t_fac_cajas_after_update after update on fac_cajas
for each row execute procedure f_fac_cajas_after_update();

create trigger t_fac_z_after_update after update on fac_z
for each row execute procedure f_fac_z_after_update();

create trigger t_precios_por_cliente_1_before_insert before insert on precios_por_cliente_1
for each row execute procedure f_precios_por_cliente_1_before_insert();

create trigger t_factsobregiro_before_insert before insert or update on factsobregiro
for each row execute procedure f_factsobregiro_before_insert();

create trigger t_factura3_before_insert before insert on factura3
for each row execute procedure f_factura3_before_insert();

create trigger t_rela_factura1_cglposteo_before_delete before delete on rela_factura1_cglposteo
for each row execute procedure f_rela_factura1_cglposteo_before_delete();


create trigger t_rela_factura1_cglposteo_delete after delete on rela_factura1_cglposteo
for each row execute procedure f_rela_factura1_cglposteo_delete();

create trigger t_factura3_before_delete before delete on factura3
for each row execute procedure f_factura3_before_delete();
