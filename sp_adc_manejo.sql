drop function f_adc_manejo_delete() cascade;
drop function f_adc_manejo_update() cascade;
drop function f_adc_manejo_delete(char(2), int4, int4, int4, int4);
drop function f_adc_manejo_factura1_delete() cascade;
drop function f_adc_manejo_to_facturacion(char(2), int4, int4, int4, int4) cascade;
drop function f_adc_manejo_factura1_before_delete() cascade;
drop function f_adc_manejo_factura1_before_insert() cascade;


create function f_adc_manejo_factura1_before_insert() returns trigger as '
declare
    r_adc_manejo_factura1 record;
begin
/*
    select into r_adc_manejo_factura1 * from adc_manejo_factura1
    where almacen = new.almacen
    and tipo = new.tipo
    and num_documento = new.num_documento;
    if found then
        Raise Exception ''Almacen % Documento % Ya existe en adc_manejo_factura1...Verifique'', new.almacen, new.num_documento;
    end if;
*/    
    return new;
end;
' language plpgsql;


create function f_adc_manejo_to_facturacion(char(2), int4, int4, int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ai_linea_house alias for $4;
    ai_linea_manejo alias for $5;
    r_adc_master record;
    r_adc_manifiesto record;
    r_navieras record;
    r_adc_parametros_contables record;
    r_fact_referencias record;
    r_factmotivos record;
    r_fac_cajas record;
    r_cglcuentas record;
    r_clientes record;
    ls_ciudad char(10);
    ls_agente char(10);
    ls_aux1 char(10);
    ls_observacion text;
    li_consecutivo int4;
    li_num_documento int4;
    li_linea int4;
    r_adc_house record;
    r_factura1 record;
    r_gralperiodos record;
    r_articulos_por_almacen record;
    r_adc_manejo record;
    r_work1 record;
    ldc_cargo decimal;
    r_adc_manejo_factura1 record;
    r_adc_house_factura1 record;
    ls_desc_larga text;
    ls_work text;
    i integer;
begin
    select into r_adc_house_factura1 *
    from adc_house_factura1
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and linea_house = ai_linea_house
    and linea_manejo = ai_linea_manejo;
    if found then
        return 0;
    end if;
    
    
    select into r_adc_manejo * from adc_manejo
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and linea_house = ai_linea_house;
    if not found then
        return 0;
    end if;


    
    select into r_adc_house * from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and linea_house = ai_linea_house;
    if not found then
        return 0;
    end if;
    
    select into r_adc_master * from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        raise exception ''no encontre el master'';
    end if;
    
    select into r_adc_manifiesto * from adc_manifiesto
    where compania = as_compania
    and consecutivo = ai_consecutivo;
    
    select into r_gralperiodos * from gralperiodos
    where compania = as_compania 
    and aplicacion = ''CGL''
    and r_adc_manejo.fecha between inicio and final
    and estado = ''I'';
    if found then
        return 0;
    end if;
    
    select into r_factmotivos * from factmotivos where cotizacion = ''S'';
    
    select into r_clientes * from clientes
    where cliente = r_adc_house.cliente;
    
    select into r_navieras * from navieras
    where cod_naviera = r_adc_manifiesto.cod_naviera;
    
    select into r_fact_referencias * from fact_referencias
    where referencia = r_adc_manifiesto.referencia;
    
    if r_fact_referencias.tipo = ''E'' then
        ls_ciudad := r_adc_manifiesto.ciudad_destino;
        ls_agente := r_adc_manifiesto.to_agent;
    else
        ls_ciudad := r_adc_manifiesto.ciudad_origen;
        ls_agente := r_adc_manifiesto.from_agent;
    end if;        
    
    ldc_cargo := 0;
    select into r_adc_manejo * from adc_manejo
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and linea_house = ai_linea_house
    and linea_manejo = ai_linea_manejo;
    if not found then
        return 0;
    end if;

    select into r_fac_cajas *
    from fac_cajas
    where almacen = r_adc_manejo.almacen
    and status = ''A'';
    if not found then
        Raise Exception ''Caja no Existe'';
    end if;

    
    select into r_factura1 factura1.*
    from adc_manejo_factura1, factura1, factmotivos
    where adc_manejo_factura1.almacen = factura1.almacen
    and adc_manejo_factura1.tipo = factura1.tipo
    and adc_manejo_factura1.num_documento = factura1.num_documento
    and adc_manejo_factura1.caja = factura1.caja
    and factura1.tipo = factmotivos.tipo
    and (factmotivos.cotizacion = ''S'' or factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
    and factura1.status <> ''A''
    and factura1.fecha_factura = r_adc_manejo.fecha
    and factura1.almacen = r_adc_manejo.almacen
    and adc_manejo_factura1.compania = r_adc_manejo.compania
    and adc_manejo_factura1.consecutivo = r_adc_manejo.consecutivo
    and adc_manejo_factura1.linea_master = r_adc_manejo.linea_master
    and adc_manejo_factura1.linea_house = r_adc_manejo.linea_house
    and adc_manejo_factura1.linea_manejo = r_adc_manejo.linea_manejo;
    if found then
        return 0;
    end if;
    
    
    select into r_factura1 factura1.*
    from adc_house_factura1, factura1, factmotivos
    where adc_house_factura1.almacen = factura1.almacen
    and adc_house_factura1.tipo = factura1.tipo
    and adc_house_factura1.num_documento = factura1.num_documento
    and adc_house_factura1.caja = factura1.caja
    and factura1.tipo = factmotivos.tipo
    and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
    and factura1.status <> ''A''
    and factura1.almacen = r_adc_manejo.almacen
    and adc_house_factura1.compania = r_adc_manejo.compania
    and adc_house_factura1.consecutivo = r_adc_manejo.consecutivo
    and adc_house_factura1.linea_master = r_adc_manejo.linea_master
    and adc_house_factura1.linea_house = r_adc_manejo.linea_house
    and adc_house_factura1.linea_manejo = r_adc_manejo.linea_manejo;
    if found then
        return 0;
    end if;
    
    select into r_adc_house_factura1 * 
    from factura1, adc_house_factura1, factmotivos
    where factura1.almacen = adc_house_factura1.almacen
    and factura1.tipo = adc_house_factura1.tipo
    and factura1.num_documento = adc_house_factura1.num_documento
    and adc_house_factura1.caja = factura1.caja
    and factura1.tipo = factmotivos.tipo
    and factmotivos.cotizacion = ''S''
    and factura1.almacen = r_adc_manejo.almacen
    and factura1.cliente = r_adc_house.cliente
    and Trim(factura1.no_referencia) = Trim(r_adc_manifiesto.no_referencia)
    and adc_house_factura1.compania = as_compania
    and adc_house_factura1.consecutivo = ai_consecutivo
    and adc_house_factura1.linea_master = ai_linea_master
    and adc_house_factura1.linea_house = ai_linea_house;
    if found then  
        li_num_documento = r_adc_house_factura1.num_documento;            
    else
    
        li_num_documento = 0;
        loop
            li_num_documento = li_num_documento + 1;    

            select into r_factura1 * from factura1
            where almacen = r_adc_manejo.almacen
            and tipo = r_factmotivos.tipo
            and trim(caja) = trim(r_fac_cajas.caja)
            and num_documento = li_num_documento;
            if not found then
                exit;
            end if;
        end loop;

    
        ls_observacion = ''FECHA DE LLEGADA: '' || Trim(to_char(r_adc_manifiesto.fecha_arrive, ''DD-MON-YYYY''));
        
        if r_adc_house.vendedor is null then
            r_adc_house.vendedor = ''00'';
        end if;


        
        insert into factura1(almacen, caja, tipo, num_documento, cliente, forma_pago, codigo_vendedor,
            nombre_cliente, descto_porcentaje, descto_monto, usuario_captura, usuario_postea,
            fecha_vencimiento, fecha_captura, fecha_postea, fecha_factura, status,
            num_cotizacion, num_factura, observacion, despachar, documento, aplicacion,
            referencia, no_referencia, mbl, hbl, vapor, embarcador, direccion1, direccion2,
            cod_destino, cod_naviera, ciudad_origen, ciudad_destino, agente, bultos, peso, facturar)
        values (r_adc_manejo.almacen, r_fac_cajas.caja, r_factmotivos.tipo, li_num_documento,
            r_adc_house.cliente, r_clientes.forma_pago, r_adc_house.vendedor, r_clientes.nomb_cliente, 
            0, 0, current_user, current_user, current_date, current_timestamp, current_date, 
            current_date,
            ''R'', 0, 0, trim(ls_observacion), ''N'', 0, ''FAC'', r_adc_manifiesto.referencia, 
            r_adc_manifiesto.no_referencia, r_adc_master.no_bill, r_adc_house.no_house, 
            r_adc_manifiesto.vapor, r_adc_house.embarcador, r_adc_house.direccion1, r_adc_house.direccion2, 
            r_adc_house.cod_destino, r_adc_manifiesto.cod_naviera, r_adc_manifiesto.ciudad_origen,
            r_adc_manifiesto.ciudad_destino, ls_agente, 0, 0, ''N'');
    end if;
    
    if r_fact_referencias.medio = ''M'' then
        ls_observacion := ''CONTENEDOR: '' || trim(r_adc_master.container) ||
                            '' SELLO: '' || trim(r_adc_master.sello) || '' / '' || trim(r_adc_master.tamanio) ||
                            '' PIES.  '' || ''SON '' || 
                            Round(r_adc_house.pkgs) || '' CTNS, '' || r_adc_house.kgs || ''KGS, '' || 
                            r_adc_house.cbm || ''CBM'';
    else
        ls_observacion := ''COMPUESTO POR '' || Round(r_adc_house.pkgs) || '' PIEZAS: '' || 
                            r_adc_house.kgs || '' KGS, '' || r_adc_house.cbm || ''CBM'';
    end if;

    if r_adc_manejo.articulo = ''02'' then
        if r_adc_manejo.observacion is null then
            ls_work :=  ls_observacion;
        else
            ls_work := trim(ls_observacion) || ''  '' || trim(r_adc_manejo.observacion);
        end if;
    else
        ls_work := trim(r_adc_manejo.observacion);
    end if;

    select into li_linea Max(linea)
    from factura2
    where almacen = r_adc_manejo.almacen
    and tipo = r_factmotivos.tipo
    and caja = r_fac_cajas.caja
    and num_documento = li_num_documento;
    if li_linea is null then
        li_linea := 1;
    else
        li_linea := li_linea + 1;
    end if;        


    select into r_work1 * from factura1
    where almacen = r_adc_manejo.almacen
    and tipo = r_factmotivos.tipo
    and caja = r_fac_cajas.caja
    and num_documento = li_num_documento;
    if found then
        insert into factura2 (almacen, tipo, num_documento, linea,
            articulo, cantidad, precio, descuento_linea, descuento_global,
            observacion, cif, caja)
        values (r_adc_manejo.almacen, r_factmotivos.tipo, li_num_documento, li_linea,
            r_adc_manejo.articulo, 1, r_adc_manejo.cargo, 0, 0, ls_work, 0, r_fac_cajas.caja);


        select into r_adc_house_factura1 * from adc_house_factura1
        where compania = r_adc_manejo.compania
        and consecutivo = r_adc_manejo.consecutivo
        and linea_master = r_adc_manejo.linea_master
        and linea_house = r_adc_manejo.linea_house
        and linea_manejo= r_adc_manejo.linea_manejo;
        if not found then
            insert into adc_house_factura1 (compania, consecutivo, linea_master, linea_house,
                linea_manejo,
                almacen, tipo, num_documento, caja)
            values (r_adc_manejo.compania, r_adc_manejo.consecutivo, r_adc_manejo.linea_master,
                r_adc_manejo.linea_house, r_adc_manejo.linea_manejo, 
                r_adc_manejo.almacen, r_factmotivos.tipo, li_num_documento, r_fac_cajas.caja);
        end if;

        ldc_cargo := ldc_cargo + r_adc_manejo.cargo;            

        select into ldc_cargo sum(precio) from factura2
        where almacen = r_adc_manejo.almacen
        and tipo = r_factmotivos.tipo
        and caja = r_fac_cajas.caja
        and num_documento = li_num_documento;

        if ldc_cargo is null then
            ldc_cargo := 0;
        end if;

        i   =   f_update_factura4(r_adc_manejo.almacen, r_factmotivos.tipo, li_num_documento, r_fac_cajas.caja);
        
    end if;
    return 1;
end;
' language plpgsql;


create function f_adc_manejo_delete(char(2), int4, int4, int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ai_linea_house alias for $4;
    ai_linea_manejo alias for $5;
    r_factura1 record;
    r_adc_manejo_factura1 record;
begin
    select into r_factura1 factura1.* from adc_manejo_factura1, factura1, factmotivos
    where adc_manejo_factura1.almacen = factura1.almacen
    and adc_manejo_factura1.tipo = factura1.tipo
    and adc_manejo_factura1.num_documento = factura1.num_documento
    and factura1.tipo = factmotivos.tipo
    and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
    and adc_manejo_factura1.compania = as_compania
    and adc_manejo_factura1.consecutivo = ai_consecutivo
    and adc_manejo_factura1.linea_master = ai_linea_master
    and adc_manejo_factura1.linea_house = ai_linea_house
    and adc_manejo_factura1.linea_manejo = ai_linea_manejo;
    if found then
--        Raise Exception ''House no se puede modificar o eliminar...Tiene facturas asociadas...Verifique'';
        return 0;
    end if;
    
    select into r_adc_manejo_factura1 * from adc_manejo_factura1
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and linea_house = ai_linea_house
    and linea_manejo = ai_linea_manejo;
    if found then
        delete from factura1
        where almacen = r_adc_manejo_factura1.almacen
        and tipo = r_adc_manejo_factura1.tipo
        and num_documento = r_adc_manejo_factura1.num_documento;
    end if;                
    
/*
    delete from adc_manejo_factura1
    where adc_manejo_factura1.compania = as_compania
    and adc_manejo_factura1.consecutivo = ai_consecutivo
    and adc_manejo_factura1.linea_master = ai_linea_master
    and adc_manejo_factura1.linea_house = ai_linea_house
    and adc_manejo_factura1.linea_manejo = ai_linea_manejo;
*/    

    return 1;
end;
' language plpgsql;


create function f_adc_manejo_factura1_delete() returns trigger as '
declare
    r_factura1 record;
begin

/*
    select into r_factura1 factura1.* from factura1, factmotivos
    where factura1.tipo = factmotivos.tipo
    and factmotivos.factura = ''S''
    and factura1.status <> ''A''
    and factura1.almacen = old.almacen
    and factura1.tipo = old.tipo
    and factura1.num_documento = old.num_documento;
    if found then
        Raise Exception ''adc_manejo_factura1 no se puede modificar o eliminar...Tiene facturas asociadas...Verifique'';
    end if;
*/

    delete from factura1
    where almacen = old.almacen
    and tipo = old.tipo
    and num_documento = old.num_documento
    and tipo in (select tipo from factmotivos where factura = ''N'')
    and status <> ''A'';
    
    
    return old;
end;
' language plpgsql;


create function f_adc_manejo_factura1_before_delete() returns trigger as '
declare
    r_factura1 record;
begin
    select into r_factura1 factura1.* from factura1, factmotivos
    where factura1.tipo = factmotivos.tipo
    and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
    and factura1.status <> ''A''
    and factura1.almacen = old.almacen
    and factura1.tipo = old.tipo
    and factura1.num_documento = old.num_documento;
    if found then
        Raise Exception ''adc_manejo_factura1 no se puede modificar o eliminar...Tiene facturas asociadas...Verifique'';
    end if;

/*
    select into r_factura1 factura1.* from factura1, factmotivos
    where factura1.tipo = factmotivos.tipo
    and factmotivos.factura = ''S''
    and factura1.status <> ''A''
    and factura1.almacen = old.almacen
    and factura1.tipo = old.tipo
    and factura1.num_documento = old.num_documento;
    if found then
        Raise Exception ''adc_manejo_factura1 no se puede modificar o eliminar...Tiene facturas asociadas...Verifique'';
    end if;
*/
    
    return old;
end;
' language plpgsql;



create function f_adc_manejo_delete() returns trigger as '
declare
    i integer;
begin
    i := f_adc_manejo_delete(old.compania, old.consecutivo, old.linea_master, old.linea_house, old.linea_manejo);
    return old;
end;
' language plpgsql;


create function f_adc_manejo_update() returns trigger as '
declare
    i integer;
begin
    i := f_adc_manejo_delete(old.compania, old.consecutivo, old.linea_master, old.linea_house, old.linea_manejo);
    return new;
end;
' language plpgsql;



create trigger t_adc_manejo_delete before delete on adc_manejo
for each row execute procedure f_adc_manejo_delete();

create trigger t_adc_manejo_update before update on adc_manejo
for each row execute procedure f_adc_manejo_update();

create trigger t_adc_manejo_factura1_delete after delete on adc_manejo_factura1
for each row execute procedure f_adc_manejo_factura1_delete();

create trigger t_adc_manejo_factura1_before_delete before delete on adc_manejo_factura1
for each row execute procedure f_adc_manejo_factura1_before_delete();

create trigger t_adc_manejo_factura1_before_insert before insert on adc_manejo_factura1
for each row execute procedure f_adc_manejo_factura1_before_insert();
