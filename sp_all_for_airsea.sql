drop function f_adc_master_delete() cascade;
drop function f_adc_master_update() cascade;
drop function f_rela_adc_master_cglposteo_delete() cascade;
drop function f_adc_master_cxpdocm(char(2), int4, int4) cascade;
drop function f_adc_master_delete(char(2), int4, int4) cascade;
drop function f_adc_master_cglposteo(char(2), int4, int4) cascade;
drop function f_adc_manifiesto_before_delete() cascade;

create function f_adc_manifiesto_before_delete() returns trigger as '
declare
    i integer;
    r_factura1 record;
begin
    select into r_factura1 factura1.* from factura1, factmotivos, adc_house_factura1
    where factura1.tipo = factmotivos.tipo
    and factura1.almacen = adc_house_factura1.almacen
    and factura1.tipo = adc_house_factura1.tipo
    and factura1.num_documento = adc_house_factura1.num_documento
    and factmotivos.factura = ''S''
    and factura1.status <> ''A''
    and adc_house_factura1.compania = old.compania
    and adc_house_factura1.consecutivo = old.consecutivo;
    if found then
        raise exception ''No se puede eliminar este manifiesto % por que tiene facturas de flete relacionadas...Verifique'', old.consecutivo;
    end if;
    
    select into r_factura1 factura1.* from factura1, factmotivos, adc_manejo_factura1
    where factura1.tipo = factmotivos.tipo
    and factura1.almacen = adc_manejo_factura1.almacen
    and factura1.tipo = adc_manejo_factura1.tipo
    and factura1.num_documento = adc_manejo_factura1.num_documento
    and factmotivos.factura = ''S''
    and factura1.status <> ''A''
    and adc_manejo_factura1.compania = old.compania
    and adc_manejo_factura1.consecutivo = old.consecutivo;
    if found then
        raise exception ''No se puede eliminar este manifiesto % por que tiene facturas de manejo relacionadas...Verifique'', old.consecutivo;
    end if;
    
    
    return old;
end;
' language plpgsql;


create function f_adc_master_cglposteo(char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    r_adc_master record;
    r_adc_manifiesto record;
    r_navieras record;
    r_adc_parametros_contables record;
    r_fact_referencias record;
    r_cxpmotivos record;
    r_cxpdocm record;
    r_cglcuentas record;
    r_proveedores record;
    ls_ciudad char(10);
    ls_agente char(10);
    ls_aux1 char(10);
    ls_observacion text;
    li_consecutivo int4;
    ldc_cargo decimal;
begin
    select into r_adc_master * from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        return 0;
    end if;
    
    select into r_adc_manifiesto * from adc_manifiesto
    where compania = as_compania
    and consecutivo = ai_consecutivo;

    
    select into r_navieras * from navieras
    where cod_naviera = r_adc_manifiesto.cod_naviera;
    
    select into r_proveedores * from proveedores
    where proveedor = r_navieras.proveedor;
    
    select into r_fact_referencias * from fact_referencias
    where referencia = r_adc_manifiesto.referencia;
    
    if r_fact_referencias.tipo = ''E'' then
        ls_ciudad := r_adc_manifiesto.ciudad_destino;
        ls_agente := r_adc_manifiesto.to_agent;
    else
        ls_ciudad := r_adc_manifiesto.ciudad_origen;
        ls_agente := r_adc_manifiesto.from_agent;
    end if;        
    
    select into r_adc_parametros_contables * from adc_parametros_contables
    where referencia = r_adc_manifiesto.referencia
    and trim(ciudad) = trim(ls_ciudad);
    if not found then
        Raise Exception ''Manifiesto % no tiene afectacion contable definida...Verifique'', ai_consecutivo;
    end if;
    
    select into r_cxpmotivos * from cxpmotivos
    where factura = ''S'';
    if not found then
        Raise Exception ''Motivo de Factura no existe en cxpmotivos...Verifique'';
    end if;
    
    select into r_cglcuentas * from cglcuentas
    where cuenta = r_adc_parametros_contables.cta_costo
    and auxiliar_1 = ''S'';
    if found then
        ls_aux1 := ls_agente;
    else
        ls_aux1 := null;
    end if;        
        
    ls_observacion := ''LOTE: '' || trim(r_adc_manifiesto.no_referencia) || ''  MASTER: '' || trim(r_adc_master.no_bill);
    

    delete from rela_adc_master_cglposteo
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    
    if r_adc_master.cargo_prepago = ''N'' then
        li_consecutivo := f_cglposteo(as_compania, ''CXP'', r_adc_manifiesto.fecha,
                                r_adc_parametros_contables.cta_costo, ls_aux1, null,
                                r_cxpmotivos.tipo_comp, trim(ls_observacion),
                                r_adc_master.cargo);
        if li_consecutivo > 0 then
            insert into rela_adc_master_cglposteo (compania, consecutivo, linea_master, cgl_consecutivo)
            values (as_compania, ai_consecutivo, ai_linea_master, li_consecutivo);
        end if;
    end if;        
    
    if r_adc_master.gtos_destino <> 0 then
        select into r_cglcuentas * from cglcuentas
        where cuenta = r_adc_parametros_contables.cta_costo
        and auxiliar_1 = ''S'';
        if found then
            ls_aux1 := ls_agente;
        else
            ls_aux1 := null;
        end if;        
    
        li_consecutivo := f_cglposteo(as_compania, ''CXP'', r_adc_manifiesto.fecha,
                                r_adc_parametros_contables.cta_costo, ls_aux1, null,
                                r_cxpmotivos.tipo_comp, trim(ls_observacion),
                                r_adc_master.gtos_destino);
        if li_consecutivo > 0 then
            insert into rela_adc_master_cglposteo (compania, consecutivo, linea_master, cgl_consecutivo)
            values (as_compania, ai_consecutivo, ai_linea_master, li_consecutivo);
        end if;
    end if;
    
    if r_adc_master.cargo_prepago = ''S'' then
        ldc_cargo := 0;
    else
        ldc_cargo := r_adc_master.cargo;
    end if;
    li_consecutivo := f_cglposteo(as_compania, ''CXP'', r_adc_manifiesto.fecha,
                            r_proveedores.cuenta, null, null,
                            r_cxpmotivos.tipo_comp, trim(ls_observacion),
                            -(ldc_cargo+r_adc_master.gtos_destino));
    if li_consecutivo > 0 then
        insert into rela_adc_master_cglposteo (compania, consecutivo, linea_master, cgl_consecutivo)
        values (as_compania, ai_consecutivo, ai_linea_master, li_consecutivo);
    end if;
    
    return 1;
end;
' language plpgsql;


create function f_adc_master_delete(char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    r_adc_master record;
    r_adc_manifiesto record;
    r_navieras record;
    r_adc_parametros_contables record;
    r_cxpmotivos record;
    r_cxpdocm record;
    r_cglcuentas record;
    r_proveedores record;
begin
    select into r_adc_master * from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        return 0;
    end if;
    
    select into r_adc_manifiesto * from adc_manifiesto
    where compania = as_compania
    and consecutivo = ai_consecutivo;

    select into r_navieras * from navieras
    where cod_naviera = r_adc_manifiesto.cod_naviera;
    
    select into r_proveedores * from proveedores
    where proveedor = r_navieras.proveedor;
    
    select into r_cxpmotivos * from cxpmotivos
    where factura = ''S'';
    if not found then
        Raise Exception ''Motivo de Factura no existe en cxpmotivos...Verifique'';
    end if;
    
    select into r_cxpdocm * from cxpdocm
    where compania = as_compania
    and proveedor = r_navieras.proveedor
    and trim(docmto_aplicar) = trim(r_adc_master.container)
    and trim(docmto_aplicar_ref) = trim(r_adc_master.container)
    and motivo_cxp_ref = r_cxpmotivos.motivo_cxp
    and trim(documento) <> trim(docmto_aplicar);
    if found then
--        Raise Exception ''Container % tiene movimientos aplicando a ella no se puede modificar'', r_adc_master.container;
        return 0;
    end if;


    delete from cxpdocm
    where trim(compania) = trim(as_compania)
    and trim(proveedor) = trim(r_navieras.proveedor)
    and trim(docmto_aplicar) = trim(r_adc_master.container)
    and trim(docmto_aplicar_ref) = trim(r_adc_master.container)
    and trim(motivo_cxp_ref) = trim(r_cxpmotivos.motivo_cxp);
    
    delete from rela_adc_master_cglposteo
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    
    return 1;
end;
' language plpgsql;



create function f_adc_master_cxpdocm(char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    r_adc_master record;
    r_adc_manifiesto record;
    r_navieras record;
    r_adc_parametros_contables record;
    r_fact_referencias record;
    r_cxpmotivos record;
    r_cxpdocm record;
    r_cglcuentas record;
    r_proveedores record;
    ls_ciudad char(10);
    ls_agente char(10);
    ls_aux1 char(10);
    ls_observacion text;
    li_consecutivo int4;
    ldc_cargo decimal;
    ldc_monto decimal;
begin
    select into r_adc_master * from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        return 0;
    end if;
    
    select into r_adc_manifiesto * from adc_manifiesto
    where compania = as_compania
    and consecutivo = ai_consecutivo;

    
    select into r_navieras * from navieras
    where cod_naviera = r_adc_manifiesto.cod_naviera;
    
    select into r_proveedores * from proveedores
    where proveedor = r_navieras.proveedor;
    
    select into r_fact_referencias * from fact_referencias
    where referencia = r_adc_manifiesto.referencia;
    
    select into r_cxpmotivos * from cxpmotivos
    where factura = ''S'';
    if not found then
        Raise Exception ''Motivo de Factura no existe en cxpmotivos...Verifique'';
    end if;
    
    ls_observacion := trim(r_adc_master.no_bill) || '' / '' || trim(r_adc_manifiesto.no_referencia);
    
    select into r_cxpdocm * from cxpdocm
    where compania = as_compania
    and proveedor = r_navieras.proveedor
    and trim(docmto_aplicar) = trim(r_adc_master.container)
    and trim(docmto_aplicar_ref) = trim(r_adc_master.container)
    and motivo_cxp_ref = r_cxpmotivos.motivo_cxp
    and trim(documento) <> trim(docmto_aplicar);
    if found then
        Raise Exception ''Container % tiene movimientos aplicando a ella no se puede modificar'', r_adc_master.container;
    end if;
    
    if r_adc_master.cargo_prepago = ''S'' then
        ldc_monto := r_adc_master.gtos_destino;
    else
        ldc_monto := r_adc_master.cargo + r_adc_master.gtos_destino;
    end if;
    
    if ldc_monto = 0 then
        return 0;
    end if;
    
    
    select into r_cxpdocm * from cxpdocm
    where trim(compania) = trim(as_compania)
    and trim(proveedor) = trim(r_navieras.proveedor)
    and trim(docmto_aplicar) = trim(r_adc_master.container)
    and trim(docmto_aplicar_ref) = trim(r_adc_master.container)
    and trim(motivo_cxp_ref) = trim(r_cxpmotivos.motivo_cxp);
    if not found then
        insert into cxpdocm (compania, proveedor, documento, docmto_aplicar, motivo_cxp,
            docmto_aplicar_ref, motivo_cxp_ref, fecha_docmto, fecha_vmto, fecha_posteo,
            fecha_cancelo, fecha_captura, usuario, status, obs_docmto, referencia,
            uso_interno, aplicacion_origen, monto)
        values (as_compania, r_navieras.proveedor, trim(r_adc_master.container), trim(r_adc_master.container),
            r_cxpmotivos.motivo_cxp, trim(r_adc_master.container), r_cxpmotivos.motivo_cxp,
            r_adc_manifiesto.fecha, r_adc_manifiesto.fecha, r_adc_manifiesto.fecha, r_adc_manifiesto.fecha,
            current_timestamp, current_user, ''P'', trim(ls_observacion), trim(r_adc_manifiesto.no_referencia),
            ''N'', ''CXP'', ldc_monto);
    else
        update cxpdocm
        set proveedor = r_navieras.proveedor,
            documento = trim(r_adc_master.container),
            docmto_aplicar = trim(r_adc_master.container),
            docmto_aplicar_ref = trim(r_adc_master.container),
            fecha_posteo = r_adc_manifiesto.fecha,
            obs_docmto = trim(ls_observacion),
            referencia = trim(r_adc_manifiesto.no_referencia),
            monto = ldc_monto
        where trim(compania) = trim(as_compania)
        and trim(proveedor) = trim(r_navieras.proveedor)
        and trim(docmto_aplicar) = trim(r_adc_master.container)
        and trim(docmto_aplicar_ref) = trim(r_adc_master.container)
        and trim(motivo_cxp_ref) = trim(r_cxpmotivos.motivo_cxp);
    end if;
    
    return 1;
end;
' language plpgsql;

    
create function f_rela_adc_master_cglposteo_delete() returns trigger as '
begin

    delete from cglposteo
    where consecutivo = old.cgl_consecutivo;
    
    return old;
    
end;
' language plpgsql;


create function f_adc_master_delete() returns trigger as '
declare
    i integer;
begin
    i := f_adc_master_delete(old.compania, old.consecutivo, old.linea_master);
    return old;
end;
' language plpgsql;


create function f_adc_master_update() returns trigger as '
declare
    i integer;
begin
    i := f_adc_master_delete(old.compania, old.consecutivo, old.linea_master);
    return new;
end;
' language plpgsql;


create trigger t_rela_adc_master_cglposteo_delete after delete or update on rela_adc_master_cglposteo
for each row execute procedure f_rela_adc_master_cglposteo_delete();

create trigger t_adc_master_delete before delete on adc_master
for each row execute procedure f_adc_master_delete();

create trigger t_adc_master_update before update on adc_master
for each row execute procedure f_adc_master_update();

create trigger t_adc_manifiesto_before_delete before delete on adc_manifiesto
for each row execute procedure f_adc_manifiesto_before_delete();


drop function f_adc_house_delete(char(2), int4, int4, int4) cascade;
drop function f_adc_house_delete() cascade;
drop function f_adc_house_update() cascade;
drop function f_adc_house_to_facturacion(char(2), int4, int4, int4) cascade;
drop function f_adc_house_factura1_delete() cascade;


create function f_adc_house_delete(char(2), int4, int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ai_linea_house alias for $4;
    r_factura1 record;
begin
    select into r_factura1 factura1.* from adc_house_factura1, factura1, factmotivos
    where adc_house_factura1.almacen = factura1.almacen
    and adc_house_factura1.tipo = factura1.tipo
    and adc_house_factura1.num_documento = factura1.num_documento
    and factura1.tipo = factmotivos.tipo
    and factmotivos.factura = ''S''
    and adc_house_factura1.compania = as_compania
    and adc_house_factura1.consecutivo = ai_consecutivo
    and adc_house_factura1.linea_master = ai_linea_master
    and adc_house_factura1.linea_house = ai_linea_house;
    if found then
        return 0;
    end if;
    
    delete from adc_house_factura1
    where adc_house_factura1.compania = as_compania
    and adc_house_factura1.consecutivo = ai_consecutivo
    and adc_house_factura1.linea_master = ai_linea_master
    and adc_house_factura1.linea_house = ai_linea_house;

    return 1;
end;
' language plpgsql;

create function f_adc_house_to_facturacion(char(2), int4, int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ai_linea_house alias for $4;
    r_adc_master record;
    r_adc_manifiesto record;
    r_navieras record;
    r_adc_parametros_contables record;
    r_fact_referencias record;
    r_factmotivos record;
    r_cglcuentas record;
    r_clientes record;
    ls_ciudad char(10);
    ls_agente char(10);
    ls_aux1 char(10);
    ls_observacion text;
    li_consecutivo int4;
    li_num_documento int4;
    r_adc_house record;
    r_factura1 record;
    r_articulos_por_almacen record;
    r_adc_house_factura1 record;
    r_factura4 record;
    li_linea integer;
    ldc_total decimal;
begin
    select into r_adc_house * from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and linea_house = ai_linea_house;
    if not found then
        raise exception ''no encontre el house'';
    end if;
    
    ldc_total := 0;
    
    if (r_adc_house.cargo = 0 and r_adc_house.gtos_d_origen = 0) or
        (r_adc_house.cargo_prepago = ''S'' and r_adc_house.gtos_prepago = ''S'') then
        return 0;
    end if;
    
    if r_adc_house.cargo_prepago = ''S'' and r_adc_house.gtos_d_origen = 0 then
        return 0;
    end if;
    
    select into r_adc_house_factura1 * 
    from factura1, adc_house_factura1, factmotivos
    where factura1.almacen = adc_house_factura1.almacen
    and factura1.tipo = adc_house_factura1.tipo
    and factura1.num_documento = adc_house_factura1.num_documento
    and factura1.tipo = factmotivos.tipo
    and factmotivos.factura = ''S''
    and factura1.status <> ''A''
    and adc_house_factura1.compania = as_compania
    and adc_house_factura1.consecutivo = ai_consecutivo
    and adc_house_factura1.linea_master = ai_linea_master
    and adc_house_factura1.linea_house = ai_linea_house;
    if found then
        return 0;
    end if;
    
    select into r_factmotivos * from factmotivos where cotizacion = ''S'';
    
    select into r_adc_master * from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        return 0;
    end if;
    
    select into r_clientes * from clientes
    where cliente = r_adc_house.cliente;
    
    select into r_adc_manifiesto * from adc_manifiesto
    where compania = as_compania
    and consecutivo = ai_consecutivo;
    
   
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
    
    
    select into r_adc_parametros_contables * from adc_parametros_contables
    where referencia = r_adc_manifiesto.referencia
    and trim(ciudad) = trim(ls_ciudad);
    if not found then
        Raise Exception ''Manifiesto % no tiene afectacion contable definida...Verifique'', ai_consecutivo;
    end if;
    
    select into r_articulos_por_almacen * from articulos_por_almacen
    where trim(cuenta) = trim(r_adc_parametros_contables.cta_ingreso)
    and almacen = r_adc_house.almacen;
    if not found then
        Raise Exception ''No existe articulo para la cuenta % en el almacen %...Verifique'', r_adc_parametros_contables.cta_ingreso, r_adc_house.almacen;
    end if;
    
    select into r_cglcuentas * from cglcuentas
    where cuenta = r_adc_parametros_contables.cta_costo
    and auxiliar_1 = ''S'';
    if found then
        ls_aux1 := ls_agente;
    else
        ls_aux1 := null;
    end if;        
        
    ls_observacion := ''LOTE: '' || trim(r_adc_manifiesto.no_referencia) || ''  MASTER: '' || trim(r_adc_master.no_bill);
    
    li_num_documento := 0;
    
    select into r_factura1 * from factura1
    where almacen = r_adc_house.almacen
    and tipo = r_factmotivos.tipo
    and cliente = r_adc_house.cliente
    and fecha_factura = r_adc_manifiesto.fecha
    and no_referencia = r_adc_manifiesto.no_referencia
    and mbl =r_adc_master.no_bill
    and hbl = r_adc_house.no_house
    and vapor = r_adc_manifiesto.vapor;
    if found then
        li_num_documento = r_factura1.num_documento;
    else
        loop
            li_num_documento := li_num_documento + 1;    
        
            select into r_factura1 * from factura1
            where almacen = r_adc_house.almacen
            and tipo = r_factmotivos.tipo
            and num_documento = li_num_documento;
            if not found then
                exit;
            end if;
        end loop;
    
        insert into factura1(almacen, tipo, num_documento, cliente, forma_pago, codigo_vendedor,
            nombre_cliente, descto_porcentaje, descto_monto, usuario_captura, usuario_postea,
            fecha_vencimiento, fecha_captura, fecha_postea, fecha_factura, status,
            num_cotizacion, num_factura, observacion, despachar, documento, aplicacion,
            referencia, no_referencia, mbl, hbl, vapor, embarcador, direccion1, direccion2,
            cod_destino, cod_naviera, ciudad_origen, ciudad_destino, agente, bultos, peso, facturar)
        values (r_adc_house.almacen, r_factmotivos.tipo, li_num_documento,
            r_adc_house.cliente, r_clientes.forma_pago, r_clientes.vendedor, r_clientes.nomb_cliente, 
            0, 0, current_user, current_user, current_date, current_timestamp, current_date, 
            r_adc_manifiesto.fecha,
            ''R'', 0, 0, trim(r_adc_house.observacion), ''N'', 0, ''FAC'', r_adc_manifiesto.referencia, 
            r_adc_manifiesto.no_referencia, r_adc_master.no_bill, r_adc_house.no_house, 
            r_adc_manifiesto.vapor, r_adc_house.embarcador, r_adc_house.direccion1, r_adc_house.direccion2, 
            r_adc_house.cod_destino, r_adc_manifiesto.cod_naviera, r_adc_manifiesto.ciudad_origen,
            r_adc_manifiesto.ciudad_destino, ls_agente, 0, 0, ''N'');
    end if;
    
    if r_fact_referencias.medio = ''M'' then
        ls_observacion := ''CONTENEDOR: '' || trim(r_adc_master.container) || ''  '' || 
                            ''SELLO: '' || trim(r_adc_master.sello) || '' / '' || trim(r_adc_master.tamanio) ||
                            '' PIES.  '' || ''SON '' || 
                            r_adc_house.pkgs || '' CTNS, '' || r_adc_house.kgs || ''KGS, '' || 
                            r_adc_house.cbm || ''CBM'';
    else
        ls_observacion := ''COMPUESTO POR '' || r_adc_house.pkgs || '' PIEZAS: '' || 
                            r_adc_house.kgs || '' KGS, '' || r_adc_house.cbm || ''CBM'';
    end if;
    
    li_linea := 1;
    select into li_linea Max(linea) from factura2
    where almacen = r_factura1.almacen
    and tipo = r_factura1.tipo
    and num_documento = r_factura1.num_documento;
    if li_linea is null then
        li_linea := 1;
    else
        li_linea := li_linea + 1;
    end if;


    if r_adc_house.cargo <> 0 and r_adc_house.cargo_prepago = ''N'' then        
        insert into factura2 (almacen, tipo, num_documento, linea,
            articulo, cantidad, precio, descuento_linea, descuento_global,
            observacion, cif)
        values (r_adc_house.almacen, r_factmotivos.tipo, li_num_documento, li_linea,
            r_articulos_por_almacen.articulo, 1, r_adc_house.cargo, 0, 0, ls_observacion,
            0);
        ldc_total := ldc_total + r_adc_house.cargo;
    end if;            


    if r_adc_house.gtos_d_origen <> 0 and r_adc_house.gtos_prepago = ''N'' then
        li_linea := li_linea + 1;
        
        ls_observacion := ''DTHC'';
        insert into factura2 (almacen, tipo, num_documento, linea,
            articulo, cantidad, precio, descuento_linea, descuento_global,
            observacion, cif)
        values (r_adc_house.almacen, r_factmotivos.tipo, li_num_documento, li_linea,
            r_articulos_por_almacen.articulo, 1, r_adc_house.gtos_d_origen, 0, 0, ls_observacion,
            0);
            
        ldc_total := ldc_total + r_adc_house.gtos_d_origen;
    end if;
    
    select into r_factura4 * from factura4
    where almacen = r_adc_house.almacen
    and tipo = r_factmotivos.tipo
    and num_documento = li_num_documento
    and rubro_fact_cxc = ''SUB-TOTAL'';
    if not found then
        select into r_factura1 * from factura1
        where almacen = r_adc_house.almacen
        and tipo = r_factmotivos.tipo
        and num_documento = li_num_documento;
        if found then
            insert into factura4 (almacen, tipo, num_documento, rubro_fact_cxc, monto)
            values (r_adc_house.almacen, r_factmotivos.tipo, li_num_documento, ''SUB-TOTAL'',
                ldc_total);
        end if;
    else
        update factura4
        set monto = monto + ldc_total
        where almacen = r_adc_house.almacen
        and tipo = r_factmotivos.tipo
        and num_documento = li_num_documento
        and rubro_fact_cxc = ''SUB-TOTAL'';
    end if;
        
    insert into adc_house_factura1 (compania, consecutivo, linea_master, linea_house,
        almacen, tipo, num_documento)
    values (r_adc_house.compania, r_adc_house.consecutivo, r_adc_house.linea_master,
        r_adc_house.linea_house, r_adc_house.almacen, r_factmotivos.tipo, li_num_documento);

    return 1;
end;
' language plpgsql;


create function f_adc_house_factura1_delete() returns trigger as '
declare
    r_factura1 record;
begin
    select into r_factura1 factura1.* from factura1, factmotivos
    where factura1.tipo = factmotivos.tipo
    and factmotivos.factura = ''S''
    and factura1.status <> ''A''
    and factura1.almacen = old.almacen
    and factura1.tipo = old.tipo
    and factura1.num_documento = old.num_documento;
    if found then
        Raise Exception ''House no se puede modificar o eliminar...Tiene facturas asociadas...Verifique'';
    end if;
    
    delete from factura1
    where almacen = old.almacen
    and tipo = old.tipo
    and num_documento = old.num_documento;
    
    return old;
end;
' language plpgsql;



create function f_adc_house_delete() returns trigger as '
declare
    i integer;
    r_factura1 record;
begin
    i := f_adc_house_delete(old.compania, old.consecutivo, old.linea_master, old.linea_house);
    return old;
end;
' language plpgsql;


create function f_adc_house_update() returns trigger as '
declare
    i integer;
    r_factura1 record;
begin
    i := f_adc_house_delete(old.compania, old.consecutivo, old.linea_master, old.linea_house);
    return new;
end;
' language plpgsql;



create trigger t_adc_house_factura1_delete after delete or update on adc_house_factura1
for each row execute procedure f_adc_house_factura1_delete();

create trigger t_adc_house_delete before delete on adc_house
for each row execute procedure f_adc_house_delete();

create trigger t_adc_house_update before update on adc_house
for each row execute procedure f_adc_house_update();

drop function f_adc_manejo_delete() cascade;
drop function f_adc_manejo_update() cascade;
drop function f_adc_manejo_delete(char(2), int4, int4, int4, int4);
drop function f_adc_manejo_factura1_delete() cascade;
drop function f_adc_manejo_to_facturacion(char(2), int4, int4, int4) cascade;

create function f_adc_manejo_to_facturacion(char(2), int4, int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ai_linea_house alias for $4;
    r_adc_master record;
    r_adc_manifiesto record;
    r_navieras record;
    r_adc_parametros_contables record;
    r_fact_referencias record;
    r_factmotivos record;
    r_cglcuentas record;
    r_clientes record;
    ls_ciudad char(10);
    ls_agente char(10);
    ls_aux1 char(10);
    ls_observacion text;
    li_consecutivo int4;
    li_num_documento int4;
    r_adc_house record;
    r_factura1 record;
    r_articulos_por_almacen record;
    r_adc_manejo record;
    ldc_cargo decimal;
    r_adc_manejo_factura1 record;
    ls_desc_larga text;
    ls_work text;
begin
    select into r_adc_manejo * from adc_manejo
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and linea_house = ai_linea_house;
    if not found then
        return 0;
    end if;
    
    select into r_adc_manejo_factura1 adc_manejo_factura1.* 
    from adc_manejo_factura1, factmotivos, factura1
    where factura1.almacen = adc_manejo_factura1.almacen
    and factura1.tipo = adc_manejo_factura1.tipo
    and factura1.num_documento = adc_manejo_factura1.num_documento
    and factura1.tipo = factmotivos.tipo
    and factura1.status <> ''A''
    and factmotivos.factura = ''S''
    and adc_manejo_factura1.compania = as_compania
    and adc_manejo_factura1.consecutivo = ai_consecutivo
    and adc_manejo_factura1.linea_master = ai_linea_master
    and adc_manejo_factura1.linea_house = ai_linea_house;
    if found then
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
    
    li_num_documento := 0;
    
    loop
        li_num_documento := li_num_documento + 1;    
        
        select into r_factura1 * from factura1
        where almacen = r_adc_manejo.almacen
        and tipo = r_factmotivos.tipo
        and num_documento = li_num_documento;
        if not found then
            exit;
        end if;
    end loop;
    
    insert into factura1(almacen, tipo, num_documento, cliente, forma_pago, codigo_vendedor,
        nombre_cliente, descto_porcentaje, descto_monto, usuario_captura, usuario_postea,
        fecha_vencimiento, fecha_captura, fecha_postea, fecha_factura, status,
        num_cotizacion, num_factura, observacion, despachar, documento, aplicacion,
        referencia, no_referencia, mbl, hbl, vapor, embarcador, direccion1, direccion2,
        cod_destino, cod_naviera, ciudad_origen, ciudad_destino, agente, bultos, peso, facturar)
    values (r_adc_manejo.almacen, r_factmotivos.tipo, li_num_documento,
        r_adc_house.cliente, r_clientes.forma_pago, r_clientes.vendedor, r_clientes.nomb_cliente, 
        0, 0, current_user, current_user, current_date, current_timestamp, current_date, 
        r_adc_manifiesto.fecha,
        ''R'', 0, 0, trim(r_adc_house.observacion), ''N'', 0, ''FAC'', r_adc_manifiesto.referencia, 
        r_adc_manifiesto.no_referencia, r_adc_master.no_bill, r_adc_house.no_house, 
        r_adc_manifiesto.vapor, r_adc_house.embarcador, r_adc_house.direccion1, r_adc_house.direccion2, 
        r_adc_house.cod_destino, r_adc_manifiesto.cod_naviera, r_adc_manifiesto.ciudad_origen,
        r_adc_manifiesto.ciudad_destino, ls_agente, 0, 0, ''N'');

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

    ldc_cargo := 0;
    for r_adc_manejo in select * from adc_manejo
                        where compania = as_compania
                        and consecutivo = ai_consecutivo
                        and linea_master = ai_linea_master
                        and linea_house = ai_linea_house
                        order by articulo
    loop
        if r_adc_manejo.articulo = ''02'' then
            if r_adc_manejo.observacion is null then
                ls_work :=  ls_observacion;
            else
                ls_work := trim(ls_observacion) || ''  '' || trim(r_adc_manejo.observacion);
            end if;
        else
            ls_work := trim(r_adc_manejo.observacion);
        end if;
            
        insert into factura2 (almacen, tipo, num_documento, linea,
            articulo, cantidad, precio, descuento_linea, descuento_global,
            observacion, cif)
        values (r_adc_manejo.almacen, r_factmotivos.tipo, li_num_documento, r_adc_manejo.linea_manejo,
            r_adc_manejo.articulo, 1, r_adc_manejo.cargo, 0, 0, ls_work,
            0);
        
        select into r_adc_manejo_factura1 * from adc_manejo_factura1
        where compania = r_adc_manejo.compania
        and consecutivo = r_adc_manejo.consecutivo
        and linea_master = r_adc_manejo.linea_master
        and linea_house = r_adc_manejo.linea_house
        and linea_manejo= r_adc_manejo.linea_manejo;
        if not found then
            insert into adc_manejo_factura1 (compania, consecutivo, linea_master, linea_house,
                linea_manejo,
                almacen, tipo, num_documento)
            values (r_adc_manejo.compania, r_adc_manejo.consecutivo, r_adc_manejo.linea_master,
                r_adc_manejo.linea_house, r_adc_manejo.linea_manejo, r_adc_manejo.almacen, r_factmotivos.tipo, li_num_documento);
        end if;
        
        ldc_cargo := ldc_cargo + r_adc_manejo.cargo;            
    end loop;    
    
    
    select into r_factura1 * from factura1
    where almacen = r_adc_house.almacen
    and tipo = r_factmotivos.tipo
    and num_documento = li_num_documento;
    if found then
        insert into factura4 (almacen, tipo, num_documento, rubro_fact_cxc, monto)
        values (r_adc_house.almacen, r_factmotivos.tipo, li_num_documento, ''SUB-TOTAL'', ldc_cargo);
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
    and factmotivos.factura = ''S''
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
    
    delete from factura1
    where almacen = old.almacen
    and tipo = old.tipo
    and num_documento = old.num_documento;
    
    
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


drop function f_afi_cglposteo(char(2), int4, int4) cascade;
drop function f_rela_afi_cglposteo_delete() cascade;
drop function f_rela_activos_cglposteo_delete() cascade;
drop function f_sec_activo(char(2));
drop function f_activos_cglposteo(char(2), char(15));

create function f_activos_cglposteo(char(2), char(15)) returns integer as '
declare
    as_compania alias for $1;
    as_codigo alias for $2;
    ls_cta_pte_activos char(24);
    r_afi_tipo_activo record;    
    r_activos record;
    li_consecutivo int4;
    ls_descripcion char(200);
begin
    ls_cta_pte_activos  =   Trim(f_gralparaxcia(as_compania, ''AFI'', ''cta_pte_activos''));

    delete from rela_activos_cglposteo
    where compania = as_compania
    and codigo = as_codigo;
    
    select into r_activos * from activos
    where compania = as_compania
    and codigo = as_codigo;
    
    select into r_afi_tipo_activo * from afi_tipo_activo
    where codigo = r_activos.tipo_activo;
    
    ls_descripcion = trim(r_activos.descripcion) || ''  '' || trim(r_activos.codigo);

    li_consecutivo := f_cglposteo(as_compania, ''AFI'', r_activos.fecha_compra,
                        trim(ls_cta_pte_activos), null, null,
                        r_afi_tipo_activo.tipo_comp, trim(ls_descripcion) , -r_activos.costo_inicial);
                        
    if li_consecutivo > 0 then
       insert into rela_activos_cglposteo (consecutivo, codigo, compania)
       values (li_consecutivo, as_codigo, as_compania);
    end if;
    
    li_consecutivo := f_cglposteo(as_compania, ''AFI'', r_activos.fecha_compra,
                        trim(r_afi_tipo_activo.cuenta_activo), null, null,
                        r_afi_tipo_activo.tipo_comp, trim(ls_descripcion) , r_activos.costo_inicial);
                        
    if li_consecutivo > 0 then
       insert into rela_activos_cglposteo (consecutivo, codigo, compania)
       values (li_consecutivo, as_codigo, as_compania);
    end if;
    
    
    return 1;    
end;
' language plpgsql;

create function f_sec_activo(char(2)) returns char(4) as '
declare
    as_compania alias for $1;
    ls_retornar char(4);
    r_work record;
    secuencia int4;
begin
    secuencia := to_number(f_gralparaxapli(''AFI'',''sec_activo''),''9999999999'');
    
    loop
        secuencia := secuencia + 1;
        ls_retornar := trim(to_char(secuencia,''0009''));
        
        select into r_work * from activos
        where compania = as_compania
        and codigo = ls_retornar;
        if not found then
            exit;
        end if;
    end loop;
    
    update gralparaxapli
    set valor = trim(to_char(secuencia,''999999999''))
    where parametro = ''sec_activo''
    and aplicacion = ''AFI'';
    
    return Trim(ls_retornar);
end;
' language plpgsql;




create function f_afi_cglposteo(char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_year alias for $2;
    ai_periodo alias for $3;
    li_consecutivo int4;
    r_work record;
begin
    delete from rela_afi_cglposteo
    where compania = as_compania
    and year = ai_year
    and periodo = ai_periodo;
    
    for r_work in select afi_tipo_activo.cuenta_gasto, afi_tipo_activo.cuenta_depreciacion, 
                         afi_tipo_activo.descripcion, afi_tipo_activo.tipo_comp, 
                         gralperiodos.final, sum(afi_depreciacion.depreciacion) as monto
                    from activos, afi_tipo_activo, afi_depreciacion, gralperiodos
                    where activos.tipo_activo = afi_tipo_activo.codigo
                    and activos.compania = afi_depreciacion.compania
                    and activos.codigo = afi_depreciacion.codigo
                    and afi_depreciacion.compania = gralperiodos.compania
                    and afi_depreciacion.aplicacion = gralperiodos.aplicacion
                    and afi_depreciacion.year = gralperiodos.year
                    and afi_depreciacion.periodo = gralperiodos.periodo
                    and afi_depreciacion.compania = as_compania
                    and afi_depreciacion.year = ai_year
                    and afi_depreciacion.periodo = ai_periodo
                    group by 1, 2, 3, 4, 5
                    order by 1, 2, 3, 4
    loop
    
        li_consecutivo := f_cglposteo(as_compania, ''AFI'', r_work.final,
                            r_work.cuenta_gasto, null, null,
                            r_work.tipo_comp, r_work.descripcion, r_work.monto);
                            
        if li_consecutivo > 0 then
           insert into rela_afi_cglposteo (codigo, compania, aplicacion, year, periodo, consecutivo)
            (select afi_depreciacion.codigo, afi_depreciacion.compania, afi_depreciacion.aplicacion,
                    afi_depreciacion.year, afi_depreciacion.periodo, li_consecutivo
             from   afi_depreciacion, afi_tipo_activo, activos
             where  activos.tipo_activo = afi_tipo_activo.codigo
             and    activos.compania = afi_depreciacion.compania
             and    activos.codigo = afi_depreciacion.codigo
             and    afi_depreciacion.compania = as_compania
             and    afi_depreciacion.aplicacion = ''AFI''
             and    afi_depreciacion.year = ai_year
             and    afi_depreciacion.periodo = ai_periodo
             and    afi_tipo_activo.cuenta_gasto = r_work.cuenta_gasto
             and    afi_tipo_activo.tipo_comp = r_work.tipo_comp);
        end if;
        
        li_consecutivo := f_cglposteo(as_compania, ''AFI'', r_work.final,
                            r_work.cuenta_depreciacion, null, null,
                            r_work.tipo_comp, r_work.descripcion, -r_work.monto);
        if li_consecutivo > 0 then
           insert into rela_afi_cglposteo (codigo, compania, aplicacion, year, periodo, consecutivo)
            (select afi_depreciacion.codigo, afi_depreciacion.compania, afi_depreciacion.aplicacion,
                    afi_depreciacion.year, afi_depreciacion.periodo, li_consecutivo
             from   afi_depreciacion, afi_tipo_activo, activos
             where  activos.tipo_activo = afi_tipo_activo.codigo
             and    activos.compania = afi_depreciacion.compania
             and    activos.codigo = afi_depreciacion.codigo
             and    afi_depreciacion.compania = as_compania
             and    afi_depreciacion.aplicacion = ''AFI''
             and    afi_depreciacion.year = ai_year
             and    afi_depreciacion.periodo = ai_periodo
             and    afi_tipo_activo.cuenta_gasto = r_work.cuenta_depreciacion
             and    afi_tipo_activo.tipo_comp = r_work.tipo_comp);
        end if;
        
    end loop;
    return 1;
end;
' language plpgsql;


create function f_rela_afi_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;

create function f_rela_activos_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;

create trigger t_rela_afi_cglposteo_delete after delete on rela_afi_cglposteo
for each row execute procedure f_rela_afi_cglposteo_delete();

create trigger t_rela_activos_cglposteo_delete after delete on rela_activos_cglposteo
for each row execute procedure f_rela_activos_cglposteo_delete();



drop function f_bcotransac1_bcocircula_insert() cascade;
drop function f_bcotransac1_bcocircula_delete() cascade;
drop function f_bcotransac1_bcocircula_update() cascade;

drop function f_bcocheck1_bcocircula_insert() cascade;
drop function f_bcocheck1_bcocircula_delete() cascade;
drop function f_bcocheck1_bcocircula_update() cascade;

drop function f_bcocheck1_bcocircula(char(2), char(2), int4) cascade;
drop function f_bcotransac1_bcocircula(char(2), int4) cascade;

drop function f_bcotransac1_cglposteo(char(3), int4);
drop function f_rela_bcotransac1_cglposteo_delete() cascade;

drop function f_bcocheck1_cglposteo(char(3), char(2), int4);
drop function f_rela_bcocheck1_cglposteo_delete() cascade;

create function f_bcocheck1_cglposteo(char(3), char(2), int4) returns integer as '
declare
    as_cod_ctabco alias for $1;
    as_motivo_bco alias for $2;
    ai_no_cheque alias for $3;
    li_consecutivo int4;
    r_bcoctas record;
    r_bcocheck1 record;
    r_bcocheck2 record;
    r_cglcuentas record;
    r_work record;
    r_bcomotivos record;
    r_proveedores record;
    r_cglauxiliares record;
    ls_auxiliar_1 char(10);
    ldc_sum_bcocheck1 decimal(10,2);
    ldc_sum_bcocheck2 decimal(10,2);
    ldc_sum_bcocheck3 decimal(10,2);
begin

    select into r_bcocheck1 * from bcocheck1
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    if not found then
       return 0;
    end if;

    
        
    if r_bcocheck1.status = ''A'' then
       return 0;
    end if;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = r_bcocheck1.motivo_bco;
    if r_bcomotivos.solicitud_cheque = ''S'' then
       return 0;
    end if;
    

    
    select into ldc_sum_bcocheck1 monto from bcocheck1
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    
    select into ldc_sum_bcocheck2 sum(monto) from bcocheck2
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    if ldc_sum_bcocheck2 is null then
       ldc_sum_bcocheck2 := 0;
    end if;
    
    
    select into ldc_sum_bcocheck3 sum(monto) from bcocheck3
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    if ldc_sum_bcocheck3 is null then
       ldc_sum_bcocheck3 := 0;
    end if;
    
    if ldc_sum_bcocheck1 <> ldc_sum_bcocheck2 + ldc_sum_bcocheck3 then
       raise exception ''Transaccion % esta desbalanceada...Verifique'',r_bcocheck1.no_cheque;
    end if;

    
    delete from rela_bcocheck1_cglposteo
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = r_bcocheck1.cod_ctabco;
    

    if r_bcocheck1.en_concepto_de is null then
       r_bcocheck1.en_concepto_de := ''CHEQUE # '' || r_bcocheck1.no_cheque;
    else
       r_bcocheck1.en_concepto_de := ''CHEQUE # '' || r_bcocheck1.no_cheque || ''  '' || trim(r_bcocheck1.en_concepto_de);
    end if;
    
    
    
    
    li_consecutivo := f_cglposteo(r_bcoctas.compania, r_bcocheck1.aplicacion, 
                            r_bcocheck1.fecha_posteo, 
                            r_bcoctas.cuenta, null, null,
                            r_bcomotivos.tipo_comp, r_bcocheck1.en_concepto_de, 
                            (r_bcocheck1.monto*r_bcomotivos.signo));
            
    if li_consecutivo > 0 then
        insert into rela_bcocheck1_cglposteo (consecutivo, no_cheque, cod_ctabco, motivo_bco)
        values (li_consecutivo, r_bcocheck1.no_cheque, r_bcocheck1.cod_ctabco, r_bcocheck1.motivo_bco);
    end if;

   
    for r_work in select bcocheck2.cuenta, bcocheck2.auxiliar1, bcocheck2.auxiliar2, bcocheck2.monto
                    from bcocheck2
                    where bcocheck2.cod_ctabco = as_cod_ctabco
                    and bcocheck2.no_cheque = ai_no_cheque
                    and bcocheck2.motivo_bco = as_motivo_bco
                    order by 1
    loop
        li_consecutivo := f_cglposteo(r_bcoctas.compania, r_bcocheck1.aplicacion, r_bcocheck1.fecha_posteo, 
                            r_work.cuenta, r_work.auxiliar1, r_work.auxiliar2,
                            r_bcomotivos.tipo_comp, r_bcocheck1.en_concepto_de,
                            -(r_work.monto*r_bcomotivos.signo));
        if li_consecutivo > 0 then
           insert into rela_bcocheck1_cglposteo (consecutivo, no_cheque, cod_ctabco, motivo_bco)
           values (li_consecutivo, r_bcocheck1.no_cheque, r_bcocheck1.cod_ctabco, r_bcocheck1.motivo_bco);
        end if;
    end loop;
    

    
    if r_bcocheck1.proveedor is null then
       return 1;
    end if;
    

    for r_work in select proveedores.cuenta, bcocheck1.proveedor, sum(bcocheck3.monto) as monto
                    from bcocheck1, bcocheck3, proveedores
                    where bcocheck1.cod_ctabco = bcocheck3.cod_ctabco
                    and bcocheck1.no_cheque = bcocheck3.no_cheque
                    and bcocheck1.motivo_bco = bcocheck3.motivo_bco
                    and bcocheck1.proveedor = proveedores.proveedor
                    and bcocheck1.cod_ctabco = as_cod_ctabco
                    and bcocheck1.no_cheque = ai_no_cheque
                    and bcocheck1.motivo_bco = as_motivo_bco
                    group by 1, 2
                    order by 1, 2
    loop
        select into r_cglcuentas * from cglcuentas
        where cuenta = r_work.cuenta
        and auxiliar_1 = ''S'';
        if not found then
            ls_auxiliar_1 := null;
        else
            ls_auxiliar_1 := r_work.proveedor;
            
            select into r_proveedores * from proveedores
            where proveedor = r_work.proveedor;
            
            select into r_cglauxiliares * from cglauxiliares
            where trim(auxiliar) = trim(ls_auxiliar_1);
            if not found then
                insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
                values (ls_auxiliar_1, trim(r_proveedores.nomb_proveedor), ''1'', ''A'');
            end if;
            
        end if;
    
        li_consecutivo := f_cglposteo(r_bcoctas.compania, r_bcocheck1.aplicacion, r_bcocheck1.fecha_posteo, 
                            r_work.cuenta, ls_auxiliar_1, null,
                            r_bcomotivos.tipo_comp, r_bcocheck1.en_concepto_de,
                            -(r_work.monto*r_bcomotivos.signo));
        if li_consecutivo > 0 then
           insert into rela_bcocheck1_cglposteo (consecutivo, no_cheque, cod_ctabco, motivo_bco)
           values (li_consecutivo, r_bcocheck1.no_cheque, r_bcocheck1.cod_ctabco, r_bcocheck1.motivo_bco);
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;



create function f_rela_bcocheck1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;



create function f_bcotransac1_cglposteo(char(3), int4) returns integer as '
declare
    as_cod_ctabco alias for $1;
    ai_sec_transacc alias for $2;
    li_consecutivo int4;
    r_bcoctas record;
    r_bcotransac1 record;
    r_bcotransac2 record;
    r_work record;
    r_proveedores record;
    r_bcomotivos record;
    ldc_sum_bcotransac1 decimal(10,2);
    ldc_sum_bcotransac2 decimal(10,2);
    ldc_sum_bcotransac3 decimal(10,2);
begin

    select into r_bcotransac1 * from bcotransac1
    where cod_ctabco = as_cod_ctabco
    and sec_transacc = ai_sec_transacc;
    if not found then
       return 0;
    end if;
    
    select into ldc_sum_bcotransac1 monto from bcotransac1
    where cod_ctabco = as_cod_ctabco
    and sec_transacc = ai_sec_transacc;
    
    select into ldc_sum_bcotransac2 sum(monto) from bcotransac2
    where cod_ctabco = as_cod_ctabco
    and sec_transacc = ai_sec_transacc;
    if ldc_sum_bcotransac2 is null then
       ldc_sum_bcotransac2 := 0;
    end if;
    
    select into ldc_sum_bcotransac3 sum(monto) from bcotransac3
    where cod_ctabco = as_cod_ctabco
    and sec_transacc = ai_sec_transacc;
    if ldc_sum_bcotransac3 is null then
       ldc_sum_bcotransac3 := 0;
    end if;
    
    if ldc_sum_bcotransac1 <> ldc_sum_bcotransac2 + ldc_sum_bcotransac3 then
       raise exception ''Transaccion % esta desbalanceada...Verifique'',r_bcotransac1.sec_transacc;
    end if;
    
    
    
    delete from rela_bcotransac1_cglposteo
    where cod_ctabco = r_bcotransac1.cod_ctabco
    and sec_transacc = r_bcotransac1.sec_transacc;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = r_bcotransac1.motivo_bco;
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = r_bcotransac1.cod_ctabco;
    

    if r_bcotransac1.obs_transac_bco is null then
       r_bcotransac1.obs_transac_bco := ''TRANSACCION #  '' || r_bcotransac1.sec_transacc;
    else
       r_bcotransac1.obs_transac_bco := ''TRANSACCION #  '' || r_bcotransac1.sec_transacc || ''   '' || trim(r_bcotransac1.obs_transac_bco);
    end if;
    
    
    li_consecutivo := f_cglposteo(r_bcoctas.compania, ''BCO'', r_bcotransac1.fecha_posteo, 
                            r_bcoctas.cuenta, r_bcoctas.auxiliar1, r_bcoctas.auxiliar2,
                            r_bcomotivos.tipo_comp, r_bcotransac1.obs_transac_bco, 
                            (r_bcotransac1.monto*r_bcomotivos.signo));
    if li_consecutivo > 0 then
        insert into rela_bcotransac1_cglposteo (consecutivo, sec_transacc, cod_ctabco)
        values (li_consecutivo, r_bcotransac1.sec_transacc, r_bcotransac1.cod_ctabco);
    end if;
    
    for r_work in select bcotransac2.cuenta, bcotransac2.auxiliar1, bcotransac2.auxiliar2, bcotransac2.monto
                    from bcotransac2
                    where bcotransac2.cod_ctabco = r_bcotransac1.cod_ctabco
                    and bcotransac2.sec_transacc = r_bcotransac1.sec_transacc
                    order by 1, 2
    loop
        li_consecutivo := f_cglposteo(r_bcoctas.compania, ''BCO'', r_bcotransac1.fecha_posteo, 
                            r_work.cuenta, r_work.auxiliar1, r_work.auxiliar2,
                            r_bcomotivos.tipo_comp, r_bcotransac1.obs_transac_bco,
                            -(r_work.monto*r_bcomotivos.signo));
        if li_consecutivo > 0 then
           insert into rela_bcotransac1_cglposteo (consecutivo, sec_transacc, cod_ctabco)
           values (li_consecutivo, r_bcotransac1.sec_transacc, r_bcotransac1.cod_ctabco);
        end if;
    end loop;
    
    
    if ldc_sum_bcotransac3 <> 0 then
        select into r_proveedores * from proveedores
        where proveedor = r_bcotransac1.proveedor;
        if not found then
            return 0;
        end if;
        
        li_consecutivo := f_cglposteo(r_bcoctas.compania, ''BCO'', r_bcotransac1.fecha_posteo, 
                            r_proveedores.cuenta, null, null,
                            r_bcomotivos.tipo_comp, r_bcotransac1.obs_transac_bco,
                            -(ldc_sum_bcotransac3*r_bcomotivos.signo));
        if li_consecutivo > 0 then
           insert into rela_bcotransac1_cglposteo (consecutivo, sec_transacc, cod_ctabco)
           values (li_consecutivo, r_bcotransac1.sec_transacc, r_bcotransac1.cod_ctabco);
        end if;
    end if;        

    
    return 1;
end;
' language plpgsql;


create function f_rela_bcotransac1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;


create function f_bcocheck1_bcocircula(char(2), char(2), int4) returns integer as '
declare
    as_cod_ctabco alias for $1;
    as_motivo_bco alias for $2;
    ai_no_cheque alias for $3;
    r_bcomotivos record;
    r_bcocircula record;
    r_bcocheck1 record;
begin
    select into r_bcocheck1 * from bcocheck1
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    if not found then
       return 0;
    end if;
    
    if r_bcocheck1.monto = 0 then
        return 0;
    end if;
    
    if r_bcocheck1.status = ''A'' then
        return 0;
    end if;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = r_bcocheck1.motivo_bco;
    if not found then
       return 0;
    end if;
    
    if r_bcomotivos.aplica_cheques = ''S'' then
        select into r_bcocircula * from bcocircula
        where cod_ctabco = r_bcocheck1.cod_ctabco
        and motivo_bco = r_bcocheck1.motivo_bco
        and no_docmto_sys = r_bcocheck1.no_cheque
        and fecha_posteo = r_bcocheck1.fecha_posteo;
        if not found then
           insert into bcocircula (sec_docmto_circula, cod_ctabco, motivo_bco, proveedor,
            no_docmto_sys, no_docmto_fuente, fecha_transacc, fecha_posteo, status, usuario,
            fecha_captura, a_nombre, desc_documento, monto, aplicacion)
           VALUES (0, r_bcocheck1.cod_ctabco, r_bcocheck1.motivo_bco, r_bcocheck1.proveedor, 
            r_bcocheck1.no_cheque, r_bcocheck1.docmto_fuente, r_bcocheck1.fecha_posteo, 
            r_bcocheck1.fecha_posteo, ''R'', current_user, current_timestamp, 
            r_bcocheck1.paguese_a, r_bcocheck1.en_concepto_de, r_bcocheck1.monto, r_bcocheck1.aplicacion);
        else
           update bcocircula
           set    proveedor             = r_bcocheck1.proveedor,
                  no_docmto_fuente      = r_bcocheck1.docmto_fuente,
                  fecha_transacc        = r_bcocheck1.fecha_posteo,
                  fecha_posteo          = r_bcocheck1.fecha_posteo,
                  usuario               = current_user,
                  fecha_captura         = current_timestamp,
                  a_nombre              = substring(r_bcocheck1.paguese_a from 1 for 60),
                  desc_documento        = r_bcocheck1.en_concepto_de,
                  monto                 = r_bcocheck1.monto
           where  cod_ctabco            = r_bcocheck1.cod_ctabco
           and    motivo_bco            = r_bcocheck1.motivo_bco
           and    no_docmto_sys         = r_bcocheck1.no_cheque
           and    fecha_posteo          = r_bcocheck1.fecha_posteo
           and    status                <> ''C'';
        end if;
    end if;
    return 1;
end;
' language plpgsql;




create function f_bcotransac1_bcocircula(char(2), int4) returns integer as '
declare
    as_cod_ctabco alias for $1;
    ai_sec_transacc alias for $2;
    r_bcotransac1 record;
    r_bcocircula record;
begin
    select into r_bcotransac1 * from bcotransac1
    where cod_ctabco = as_cod_ctabco
    and sec_transacc = ai_sec_transacc;
    if not found then
       return 0;
    end if;
    
    if r_bcotransac1.monto = 0 then
        return 0;
    end if;
    
    select into r_bcocircula * from bcocircula
    where cod_ctabco = r_bcotransac1.cod_ctabco
    and motivo_bco = r_bcotransac1.motivo_bco
    and no_docmto_sys = r_bcotransac1.sec_transacc
    and fecha_posteo = r_bcotransac1.fecha_posteo;
    if not found then
        insert into bcocircula (sec_docmto_circula, cod_ctabco, motivo_bco, proveedor,
        no_docmto_sys, no_docmto_fuente, fecha_transacc, fecha_posteo, status, usuario,
        fecha_captura, a_nombre, desc_documento, monto, aplicacion)
        VALUES (0, r_bcotransac1.cod_ctabco, r_bcotransac1.motivo_bco, r_bcotransac1.proveedor, 
        r_bcotransac1.sec_transacc, r_bcotransac1.no_docmto, r_bcotransac1.fecha_posteo, 
        r_bcotransac1.fecha_posteo, ''R'', current_user, current_timestamp, 
        substring(r_bcotransac1.obs_transac_bco from 1 for 60), 
        r_bcotransac1.obs_transac_bco, r_bcotransac1.monto, ''BCO'');
    else
       update bcocircula
       set    proveedor             = r_bcotransac1.proveedor,
              no_docmto_fuente      = r_bcotransac1.no_docmto,
              fecha_transacc        = r_bcotransac1.fecha_posteo,
              fecha_posteo          = r_bcotransac1.fecha_posteo,
              usuario               = current_user,
              fecha_captura         = current_timestamp,
              a_nombre              = substring(r_bcotransac1.obs_transac_bco from 1 for 60),
              desc_documento        = r_bcotransac1.obs_transac_bco,
              monto                 = r_bcotransac1.monto
       where  cod_ctabco            = r_bcotransac1.cod_ctabco
       and    motivo_bco            = r_bcotransac1.motivo_bco
       and    no_docmto_sys         = r_bcotransac1.sec_transacc
       and    fecha_posteo          = r_bcotransac1.fecha_posteo
       and    status                <> ''C'';
    end if;
    return 1;
end;
' language plpgsql;



create function f_bcotransac1_bcocircula_insert() returns trigger as '
declare
    i integer;
begin
    i := f_bcotransac1_bcocircula(new.cod_ctabco, new.sec_transacc);
    return new;
end;
' language plpgsql;

create function f_bcotransac1_bcocircula_delete() returns trigger as '
begin
    delete from bcocircula
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_docmto_sys = old.sec_transacc
    and fecha_posteo = old.fecha_posteo
    and status <> ''C'';
    
    delete from rela_bcotransac1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and sec_transacc = old.sec_transacc;
    
    return old;
end;
' language plpgsql;

create function f_bcotransac1_bcocircula_update() returns trigger as '
declare
    r_bcocircula record;
    i integer;
begin
    delete from bcocircula
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_docmto_sys = old.sec_transacc
    and fecha_posteo = old.fecha_posteo
    and status <> ''C''; 
    
    delete from rela_bcotransac1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and sec_transacc = old.sec_transacc;
    
    i := f_bcotransac1_bcocircula(new.cod_ctabco, new.sec_transacc);
    
    return new;
end;
' language plpgsql;



create function f_bcocheck1_bcocircula_insert() returns trigger as '
declare
    r_bcomotivos record;
    r_bcocircula record;
    i integer;
begin
    i := f_bcocheck1_bcocircula(new.cod_ctabco, new.motivo_bco, new.no_cheque);
    
    return new;
end;
' language plpgsql;



create function f_bcocheck1_bcocircula_delete() returns trigger as '
begin
    delete from bcocircula
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_docmto_sys = old.no_cheque
    and fecha_posteo = old.fecha_posteo
    and status <> ''C'';
    return old;
end;
' language plpgsql;


create function f_bcocheck1_bcocircula_update() returns trigger as '
declare
    r_bcomotivos record;
    r_bcocircula record;
    i integer;
begin

    delete from bcocircula
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_docmto_sys = old.no_cheque
    and fecha_posteo = old.fecha_posteo
    and status <> ''C'';
    
    i := f_bcocheck1_bcocircula(new.cod_ctabco, new.motivo_bco, new.no_cheque);
    return new;
end;
' language plpgsql;




create trigger t_bcocheck1_bcocircula_insert after insert on bcocheck1
for each row execute procedure f_bcocheck1_bcocircula_insert();

create trigger t_bcocheck1_bcocircula_delete after delete on bcocheck1
for each row execute procedure f_bcocheck1_bcocircula_delete();

create trigger t_bcocheck1_bcocircula_update after update on bcocheck1
for each row execute procedure f_bcocheck1_bcocircula_update();



create trigger t_bcotransac1_bcocircula_insert after insert on bcotransac1
for each row execute procedure f_bcotransac1_bcocircula_insert();

create trigger t_bcotransac1_bcocircula_delete after delete on bcotransac1
for each row execute procedure f_bcotransac1_bcocircula_delete();

create trigger t_bcotransac1_bcocircula_update after update on bcotransac1
for each row execute procedure f_bcotransac1_bcocircula_update();


create trigger t_rela_bcotransac1_cglposteo_delete after delete on rela_bcotransac1_cglposteo
for each row execute procedure f_rela_bcotransac1_cglposteo_delete();

create trigger t_rela_bcocheck1_cglposteo_delete after delete on rela_bcocheck1_cglposteo
for each row execute procedure f_rela_bcocheck1_cglposteo_delete();



drop function f_caja_trx1_update() cascade;
drop function f_caja_trx2_update() cascade;
drop function f_caja_trx1_cglposteo(char(3), int4);
drop function f_rela_caja_trx1_cglposteo_delete() cascade;


create function f_caja_trx1_cglposteo(char(3), int4) returns integer as '
declare
    as_caja alias for $1;
    ai_numero_trx alias for $2;
    li_consecutivo int4;
    r_cajas record;
    r_caja_trx1 record;
    r_caja_trx2 record;
    r_work record;
    r_caja_tipo_trx record;
    ldc_sum_caja_trx1 decimal(10,2);
    ldc_sum_caja_trx2 decimal(10,2);
begin
    select into r_caja_trx1 * from caja_trx1
    where caja = as_caja
    and numero_trx = ai_numero_trx;
    if not found then
       return 0;
    end if;
    
    select into ldc_sum_caja_trx1 monto from caja_trx1
    where caja = as_caja
    and numero_trx = ai_numero_trx;
    
    select into ldc_sum_caja_trx2 sum(monto) from caja_trx2
    where caja = as_caja
    and numero_trx = ai_numero_trx;
    if ldc_sum_caja_trx2 is null then
       ldc_sum_caja_trx2 := 0;
    end if;
    
    if ldc_sum_caja_trx1 <> ldc_sum_caja_trx2 then
       raise exception ''Transaccion % esta desbalanceada...Verifique'',ai_numero_trx;
    end if;
    
    delete from rela_caja_trx1_cglposteo
    where caja = r_caja_trx1.caja
    and numero_trx = r_caja_trx1.numero_trx;
    
    select into r_caja_tipo_trx * from caja_tipo_trx
    where tipo_trx = r_caja_trx1.tipo_trx;
    
    select into r_cajas * from cajas
    where caja = r_caja_trx1.caja;
    

    if r_caja_trx1.concepto is null then
       r_caja_trx1.concepto := ''CAJA  '' || trim(r_caja_trx1.caja) || '' NUMERO DE TRANSACCION '' || r_caja_trx1.numero_trx;
    else
       r_caja_trx1.concepto := trim(r_caja_trx1.concepto) || ''CAJA  '' || trim(r_caja_trx1.caja) || ''  NUMERO DE TRANSACCION  '' || r_caja_trx1.numero_trx;
    end if;
    
    
    li_consecutivo := f_cglposteo(r_cajas.compania, ''CAJ'', r_caja_trx1.fecha_posteo, 
                            r_cajas.cuenta, r_cajas.auxiliar_1, r_cajas.auxiliar_2,
                            r_caja_tipo_trx.tipo_comp, r_caja_trx1.concepto, 
                            (r_caja_trx1.monto*r_caja_tipo_trx.signo));
    if li_consecutivo > 0 then
        insert into rela_caja_trx1_cglposteo (consecutivo, numero_trx, caja)
        values (li_consecutivo, r_caja_trx1.numero_trx, r_caja_trx1.caja);
    end if;
    
    for r_work in select caja_trx2.cuenta, caja_trx2.auxiliar_1, caja_trx2.auxiliar_2, caja_trx2.monto
                    from caja_trx2
                    where caja_trx2.caja = r_caja_trx1.caja
                    and caja_trx2.numero_trx = r_caja_trx1.numero_trx
                    order by 1
    loop
        li_consecutivo := f_cglposteo(r_cajas.compania, ''CAJ'', r_caja_trx1.fecha_posteo, 
                            r_work.cuenta, r_work.auxiliar_1, r_work.auxiliar_2,
                            r_caja_tipo_trx.tipo_comp, r_caja_trx1.concepto, 
                            -(r_work.monto*r_caja_tipo_trx.signo));
        if li_consecutivo > 0 then
           insert into rela_caja_trx1_cglposteo (consecutivo, numero_trx, caja)
           values (li_consecutivo, r_caja_trx1.numero_trx, r_caja_trx1.caja);
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;


create function f_rela_caja_trx1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;

create function f_caja_trx1_update() returns trigger as '
begin
    delete from rela_caja_trx1_cglposteo
    where caja = old.caja
    and numero_trx = old.numero_trx;
    
    return old;
end;
' language plpgsql;

create function f_caja_trx2_update() returns trigger as '
begin
    delete from rela_caja_trx1_cglposteo
    where caja = old.caja
    and numero_trx = old.numero_trx;
    
    return old;
end;
' language plpgsql;



create trigger t_rela_caja_trx1_cglposteo_delete after delete on rela_caja_trx1_cglposteo
for each row execute procedure f_rela_caja_trx1_cglposteo_delete();

create trigger t_caja_trx1_update after delete or update on caja_trx1
for each row execute procedure f_caja_trx1_update();

create trigger t_caja_trx2_update after delete or update on caja_trx2
for each row execute procedure f_caja_trx2_update();


drop function f_cglcomprobante1_cglposteo(char(2), char(3), int4, int4, int4) cascade;
drop function f_cgl_comprobante1_cglposteo(char(2), int4) cascade;
drop function f_cglsldocuenta(char(2), char(24), int4, int4, decimal(10,2), decimal(10,2));
drop function f_cglsldoaux1(char(2), char(24), char(10), int4, int4, decimal(10,2), decimal(10,2));
drop function f_balance_inicio_cglsldocuenta(char(2), char(24), int4, int4);
drop function f_balance_inicio_cglsldoaux1(char(2), char(24), char(10), int4, int4);
drop function f_cglsldocuenta_update_niveles(char(2), char(24), int4, int4, decimal(10,2), decimal(10,2), decimal(10,2));
drop function f_update_balances_y_niveles(char(2));
drop function f_cglsldocuenta_update_balance_inicio(char(2), char(24), int4, int4) cascade;

drop function f_rela_cglcomprobante1_cglposteo_insert() cascade;
drop function f_rela_cglcomprobante1_cglposteo_update() cascade;
drop function f_rela_cglcomprobante1_cglposteo_delete() cascade;

drop function f_rela_cgl_comprobante1_cglposteo_insert() cascade;
drop function f_rela_cgl_comprobante1_cglposteo_update() cascade;
drop function f_rela_cgl_comprobante1_cglposteo_delete() cascade;


create function f_cgl_comprobante1_cglposteo(char(2), int4) returns integer as '
declare
    as_compania alias for $1;
    ai_secuencia alias for $2;
    li_consecutivo int4;
    r_cgl_comprobante1 record;
    r_cgl_comprobante2 record;
    r_cglcuentas record;
    ldc_work decimal(10,2);
    ldc_work2 decimal(10,2);
begin
    
    delete from rela_cgl_comprobante1_cglposteo
    where compania = as_compania
    and secuencia = ai_secuencia;

    select into r_cgl_comprobante1 * from cgl_comprobante1
    where compania = as_compania
    and secuencia = ai_secuencia;
    if not found then
       return 0;
    end if;

    select into ldc_work sum(monto) from cgl_comprobante2
    where compania = as_compania
    and secuencia = ai_secuencia;
    if ldc_work is null or ldc_work <> 0 then
       Raise Exception ''Comprobante % esta en desbalance...Verifique %'',ai_secuencia, ldc_work;
       Return 0;
    end if;
    
    
    for r_cgl_comprobante2 in select * from cgl_comprobante2
                                where compania = as_compania
                                and secuencia = ai_secuencia
                                order by cuenta
    loop
       li_consecutivo := f_cglposteo(as_compania, ''CGL'', r_cgl_comprobante1.fecha,
                            r_cgl_comprobante2.cuenta, r_cgl_comprobante2.auxiliar, null,
                            ''00'', r_cgl_comprobante1.concepto, r_cgl_comprobante2.monto);
        if li_consecutivo > 0 then
            insert into rela_cgl_comprobante1_cglposteo (compania, secuencia, consecutivo)
            values (as_compania, ai_secuencia, li_consecutivo);
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;


create function f_cglsldocuenta_update_balance_inicio(char(2), char(24), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    as_cuenta alias for $2;
    ai_year alias for $3;
    ai_periodo alias for $4;
    r_cglsldocuenta record;
    r_gralperiodos record;
    ldc_balance_final decimal(10,2);
    li_year integer;
    li_periodo integer;
    ld_inicio date;
begin
    select into r_cglsldocuenta * from cglsldocuenta
    where cglsldocuenta.cuenta = as_cuenta
    and cglsldocuenta.compania = as_compania
    and cglsldocuenta.year = ai_year
    and cglsldocuenta.periodo = ai_periodo;
    if found then                            
       ldc_balance_final := r_cglsldocuenta.balance_inicio + r_cglsldocuenta.debito -
                            r_cglsldocuenta.credito;        
    else
       ldc_balance_final := 0;
    end if;

    select into ld_inicio inicio from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and year = ai_year
    and periodo = ai_periodo;
    if not found then
       return 0;
    end if;

    for r_gralperiodos in select * from gralperiodos
                            where compania = as_compania
                            and inicio > ld_inicio
                            and aplicacion = ''CGL''
                            and estado = ''A''
                            order by year, periodo
    loop
        select into r_cglsldocuenta * from cglsldocuenta
        where compania = as_compania
        and year = r_gralperiodos.year
        and periodo = r_gralperiodos.periodo
        and cuenta = as_cuenta;
        if not found then
            insert into cglsldocuenta (compania, cuenta, year, periodo, balance_inicio,
                debito, credito)
            values (as_compania, as_cuenta, r_gralperiodos.year, r_gralperiodos.periodo, 
                ldc_balance_final, 0, 0);
        else
            update cglsldocuenta
            set balance_inicio = ldc_balance_final
            where compania = as_compania
            and year = r_gralperiodos.year
            and periodo = r_gralperiodos.periodo
            and cuenta = as_cuenta;
            
            ldc_balance_final := ldc_balance_final + r_cglsldocuenta.debito - r_cglsldocuenta.credito;
        end if;
    end loop;
    
        
    return 1;
end;
' language plpgsql;


create function f_update_balances_y_niveles(char(2)) returns integer as '
declare
    as_compania alias for $1;
    r_gralperiodos record;
    r_gralperiodos2 record;
    r_cglsldocuenta record;
    r_cglsldocuenta2 record;
    r_cglsldoaux1 record;
    r_cglsldoaux12 record;
    r_work record;
    r_cglcuentas record;
    ld_work date;
    i integer;
    ldc_balance_final decimal(10,2);
    li_year integer;
    li_periodo integer;
begin
    select into ld_work Max(inicio) from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and estado = ''I''
    and inicio <= current_date;
    if not found or ld_work is null then
       return 0;
    end if;

    select into r_gralperiodos * from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and inicio = ld_work;
    
    delete from cglsldocuenta
    where cglsldocuenta.compania = gralperiodos.compania
    and cglsldocuenta.year = gralperiodos.year
    and cglsldocuenta.periodo = gralperiodos.periodo
    and cglsldocuenta.compania = as_compania
    and gralperiodos.aplicacion = ''CGL''
    and gralperiodos.estado = ''A''
    and gralperiodos.inicio > ld_work
    and cglsldocuenta.balance_inicio = 0 
    and cglsldocuenta.debito = 0
    and cglsldocuenta.credito = 0;
    

    update cglsldocuenta
    set balance_inicio = 0
    where cglsldocuenta.compania = gralperiodos.compania
    and cglsldocuenta.year = gralperiodos.year
    and cglsldocuenta.periodo = gralperiodos.periodo
    and cglsldocuenta.compania = as_compania
    and gralperiodos.aplicacion = ''CGL''
    and gralperiodos.estado = ''A''
    and gralperiodos.inicio > ld_work;
    
    update cglsldoaux1
    set balance_inicio = 0
    where cglsldoaux1.compania = gralperiodos.compania
    and cglsldoaux1.year = gralperiodos.year
    and cglsldoaux1.periodo = gralperiodos.periodo
    and cglsldoaux1.compania = as_compania
    and gralperiodos.aplicacion = ''CGL''
    and gralperiodos.estado = ''A''
    and gralperiodos.inicio > ld_work;
    
    
    for r_cglcuentas in select * from cglcuentas, cglniveles
                            where cglcuentas.nivel = cglniveles.nivel
                            and cglniveles.recibe = ''S''
                            order by cglcuentas.cuenta    
    loop
        i := f_cglsldocuenta_update_balance_inicio(as_compania, r_cglcuentas.cuenta, r_gralperiodos.year, r_gralperiodos.periodo);
        
       
        for r_work in select auxiliar from cglsldoaux1
                            where cuenta = r_cglcuentas.cuenta
                            and compania = as_compania
                            group by 1
                            order by 1
        loop
            i := f_balance_inicio_cglsldoaux1(as_compania, r_cglcuentas.cuenta, r_work.auxiliar, r_gralperiodos.year, r_gralperiodos.periodo);
        end loop;

        
/*        
        for r_cglsldoaux1 in select * from cglsldoaux1
            where cglsldoaux1.cuenta = r_cglcuentas.cuenta
            and cglsldoaux1.compania = as_compania
            and cglsldoaux1.year = r_gralperiodos.year
            and cglsldoaux1.periodo = r_gralperiodos.periodo
            order by auxiliar
        loop
            i := f_balance_inicio_cglsldoaux1(as_compania, r_cglcuentas.cuenta, r_cglsldoaux1.auxiliar, r_gralperiodos.year, r_gralperiodos.periodo);
        end loop;    
*/        
    end loop;

    return 1;
end;
' language plpgsql;



create function f_cglsldocuenta_update_niveles(char(2), char(24), int4, int4, decimal(10,2), decimal(10,2), decimal(10,2)) returns integer as '
declare
    as_compania alias for $1;
    as_cuenta alias for $2;
    ai_year alias for $3;
    ai_periodo alias for $4;
    adc_balance_inicio alias for $5;
    adc_debito alias for $6;
    adc_credito alias for $7;
    r_cglniveles record;
    r_cglcuentas record;
    r_cglsldocuenta record;
    ls_cuenta char(24);
    r_work record;
begin
    select into r_cglcuentas cglcuentas.* from cglcuentas, cglniveles
    where cglcuentas.nivel = cglniveles.nivel
    and cglniveles.recibe = ''N''
    and cglcuentas.cuenta = as_cuenta;
    if found then
       return 0;
    end if;

    select into r_cglcuentas * from cglcuentas
    where cuenta = as_cuenta;
    
    if adc_balance_inicio = 0 and adc_debito = 0 and adc_credito = 0 then
        return 0;
    end if;
    
    for r_cglniveles in select * from cglniveles
                            where recibe = ''N'' 
                            order by posicion_inicial desc
    loop
        ls_cuenta = substring(as_cuenta from 1 for r_cglniveles.posicion_final);
        
        select into r_cglcuentas * from cglcuentas
        where trim(cuenta) = trim(ls_cuenta);
        if not found then
        
            select into r_cglcuentas * from cglcuentas
            where cuenta = as_cuenta;
        
           insert into cglcuentas (cuenta, nombre, nivel, naturaleza,
    		auxiliar_1, auxiliar_2, efectivo, tipo_cuenta, status)
    	   values (trim(ls_cuenta), ''GENERADA POR ABACO '' || trim(ls_cuenta), 
            r_cglniveles.nivel, r_cglcuentas.naturaleza, ''N'', ''N'', 
            ''N'', r_cglcuentas.tipo_cuenta, ''A'');
            
        end if;
        
        select into r_cglsldocuenta * from cglsldocuenta
        where compania = as_compania
        and trim(cuenta) = trim(ls_cuenta)
        and year = ai_year
        and periodo = ai_periodo;
        if not found then
            insert into cglsldocuenta (compania, cuenta, year, periodo, balance_inicio,
                debito, credito)
            values (as_compania, ls_cuenta, ai_year, ai_periodo, adc_balance_inicio,
                adc_debito, adc_credito);
        else
            update cglsldocuenta
            set    debito         = debito + adc_debito,
                   credito        = credito + adc_credito,
                   balance_inicio = balance_inicio + adc_balance_inicio
            where  compania       = as_compania
            and    trim(cuenta)   = trim(ls_cuenta)
            and    year           = ai_year
            and    periodo        = ai_periodo;
        end if;
    end loop;
 
    return 1;
end;
' language plpgsql;


create function f_balance_inicio_cglsldoaux1(char(2), char(24), char(10), int4, int4) returns decimal(10,2) as '
declare
    as_compania alias for $1;
    as_cuenta alias for $2;
    as_auxiliar alias for $3;
    ai_year alias for $4;
    ai_periodo alias for $5;
    r_gralperiodos record;
    r_cglsldoaux1 record;
    ldc_balance_inicio decimal(10,2);
    ldc_balance_final decimal(10,2);
    li_year int4;
    li_periodo int4;
    ld_fecha date;
    ld_inicio date;
    r_cglsldocuenta record;
begin
    select into r_cglsldoaux1 * from cglsldoaux1
    where cglsldoaux1.cuenta = as_cuenta
    and cglsldoaux1.auxiliar = as_auxiliar
    and cglsldoaux1.compania = as_compania
    and cglsldoaux1.year = ai_year
    and cglsldoaux1.periodo = ai_periodo;
    if found then                            
       ldc_balance_final := r_cglsldoaux1.balance_inicio + r_cglsldoaux1.debito -
                            r_cglsldoaux1.credito;        
    else
       ldc_balance_final := 0;
    end if;
    
    select into ld_inicio inicio from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and year = ai_year
    and periodo = ai_periodo;
    if not found then
       return 0;
    end if;
    
    for r_gralperiodos in select * from gralperiodos
                            where compania = as_compania
                            and inicio > ld_inicio
                            and aplicacion = ''CGL''
                            and estado = ''A''
                            order by year, periodo
    loop
        select into r_cglsldoaux1 * from cglsldoaux1
        where compania = as_compania
        and year = r_gralperiodos.year
        and periodo = r_gralperiodos.periodo
        and cuenta = as_cuenta
        and auxiliar = as_auxiliar;
        if not found then
            if ldc_balance_final <> 0 then
                select into r_cglsldocuenta * from cglsldocuenta
                where compania = as_compania 
                and cuenta = as_cuenta
                and year = r_gralperiodos.year
                and periodo = r_gralperiodos.periodo;
                if found then
                    insert into cglsldoaux1 (compania, cuenta, auxiliar, year, periodo, balance_inicio,
                        debito, credito)
                    values (as_compania, as_cuenta, as_auxiliar, r_gralperiodos.year, r_gralperiodos.periodo, 
                        ldc_balance_final, 0, 0);
                end if;
            end if;
        else
            update cglsldoaux1
            set balance_inicio = ldc_balance_final
            where compania = as_compania
            and year = r_gralperiodos.year
            and periodo = r_gralperiodos.periodo
            and cuenta = as_cuenta
            and auxiliar = as_auxiliar;
            
            ldc_balance_final := ldc_balance_final + r_cglsldoaux1.debito - r_cglsldoaux1.credito;
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;


create function f_cglsldocuenta(char(2), char(24), int4, int4, decimal(10,2), decimal(10,2)) returns integer as '
declare
    as_compania alias for $1;
    as_cuenta alias for $2;
    ai_year alias for $3;
    ai_periodo alias for $4;
    adc_debito alias for $5;
    adc_credito alias for $6;
    r_cglsldocuenta record;
    ldc_balance_final decimal(10,2);
    ldc_balance_inicio decimal(10,2);
    li_year int4;
    li_periodo int4;
    i integer;
begin

    select into r_cglsldocuenta * from cglsldocuenta
    where compania = as_compania
    and cuenta = as_cuenta
    and year = ai_year
    and periodo = ai_periodo;
    if not found then
       ldc_balance_inicio := f_balance_inicio_cglsldocuenta(as_compania, as_cuenta, ai_year, ai_periodo);
       insert into cglsldocuenta (compania, cuenta, year, periodo, balance_inicio,debito, credito)
       values (as_compania, as_cuenta, ai_year, ai_periodo, ldc_balance_inicio, adc_debito, adc_credito);
    else
       update cglsldocuenta
       set    debito       = debito + adc_debito,
              credito      = credito + adc_credito
       where  compania     = as_compania
       and    cuenta       = as_cuenta
       and    year         = ai_year
       and    periodo      = ai_periodo;
       ldc_balance_inicio := r_cglsldocuenta.balance_inicio;
    end if;
    
    i := f_cglsldocuenta_update_balance_inicio(as_compania, as_cuenta, ai_year, ai_periodo);

    return 1;
end;
' language plpgsql;



create function f_balance_inicio_cglsldocuenta(char(2), char(24), int4, int4) returns decimal(10,2) as '
declare
    as_compania alias for $1;
    as_cuenta alias for $2;
    ai_year alias for $3;
    ai_periodo alias for $4;
    r_gralperiodos record;
    r_cglsldocuenta record;
    ldc_balance_inicio decimal(10,2);
    li_year int4;
    li_periodo int4;
    ld_fecha date;
begin
    ldc_balance_inicio := 0;
        
    select into ld_fecha Max(inicio) from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and estado = ''I'';
    if not found or ld_fecha is null then
       return 0;
    end if;
    
    
    select into r_gralperiodos * from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and inicio = ld_fecha;
    if not found then
        return 0;
    end if;
    
    li_year := r_gralperiodos.year;
    li_periodo := r_gralperiodos.periodo;
    
    while 1=1 loop
        select into r_cglsldocuenta * from cglsldocuenta
        where compania = as_compania
        and cuenta = as_cuenta
        and year = li_year
        and periodo = li_periodo;
        if found then
            ldc_balance_inicio := ldc_balance_inicio + r_cglsldocuenta.balance_inicio + r_cglsldocuenta.debito - r_cglsldocuenta.credito;
        end if;
        
        li_periodo := li_periodo + 1;
        if li_periodo > 13 then
           li_year := li_year + 1;
           li_periodo := 1;
        end if;
        if li_year = ai_year and li_periodo = ai_periodo then
           exit;
        end if;
        
    end loop;
    
    return ldc_balance_inicio;
end;
' language plpgsql;



create function f_cglsldoaux1(char(2), char(24), char(10), int4, int4, decimal(10,2), decimal(10,2)) returns integer as '
declare
    as_compania alias for $1;
    as_cuenta alias for $2;
    as_auxiliar alias for $3;
    ai_year alias for $4;
    ai_periodo alias for $5;
    adc_debito alias for $6;
    adc_credito alias for $7;
    r_cglsldoaux1 record;
    r_cglsldocuenta record;
    ldc_balance_final decimal(10,2);
    li_year int4;
    li_periodo int4;
begin
    select into r_cglsldoaux1 * from cglsldoaux1
    where compania = as_compania
    and cuenta = as_cuenta
    and auxiliar = as_auxiliar
    and year = ai_year
    and periodo = ai_periodo;
    if not found then
        select into r_cglsldocuenta * from cglsldocuenta
        where compania = as_compania
        and cuenta = as_cuenta
        and year = ai_year
        and periodo = ai_periodo;
        if found then
--           r_cglsldoaux1.balance_inicio := f_balance_inicio_cglsldoaux1(as_compania, 
--                                               as_cuenta, as_auxiliar, ai_year, ai_periodo);
            r_cglsldoaux1.balance_inicio := 0;            
           insert into cglsldoaux1 (compania, cuenta, auxiliar, year, periodo, balance_inicio,
                        debito, credito)
           values (as_compania, as_cuenta, as_auxiliar, ai_year, ai_periodo, 
                        r_cglsldoaux1.balance_inicio, adc_debito, adc_credito);
        end if;                        
    else
       update cglsldoaux1
       set    debito       = debito + adc_debito,
              credito      = credito + adc_credito
       where  compania = as_compania
       and    cuenta = as_cuenta
       and    auxiliar = as_auxiliar
       and    year = ai_year
       and    periodo = ai_periodo;
    end if;
    
--    r_cglsldoaux1.balance_inicio := f_balance_inicio_cglsldoaux1(as_compania, 
--                                      as_cuenta, as_auxiliar, ai_year, ai_periodo);

    return 1;
end;
' language plpgsql;


create function f_cglcomprobante1_cglposteo(char(2), char(3), int4, int4, int4) returns integer as '
declare
    as_compania alias for $1;
    as_aplicacion alias for $2;
    ai_year alias for $3;
    ai_periodo alias for $4;
    ai_secuencia alias for $5;
    li_consecutivo int4;
    r_cglcomprobante1 record;
    r_cglcomprobante2 record;
    r_cglcomprobante3 record;
    r_cglcuentas record;
    ldc_work decimal(10,2);
    ldc_work2 decimal(10,2);
begin
    
    select into r_cglcomprobante1 * from cglcomprobante1
    where compania = as_compania
    and aplicacion = as_aplicacion
    and year = ai_year
    and periodo = ai_periodo
    and secuencia = ai_secuencia;
    if not found then
       return 0;
    end if;

    select into r_cglcomprobante2 * from cglcomprobante1
    where compania = as_compania
    and aplicacion = as_aplicacion
    and year = ai_year
    and periodo = ai_periodo
    and secuencia = ai_secuencia;
    if not found then
       Raise Exception ''Comprobante % No Tiene Detalle...Verifique '',ai_secuencia;
       return 0;
    else
        select into ldc_work sum(debito-credito) from cglcomprobante2
        where compania = as_compania
        and aplicacion = as_aplicacion
        and year = ai_year
        and periodo = ai_periodo
        and secuencia = ai_secuencia
        and debito = 0 and credito = 0;
        if ldc_work = 0 then
           Raise Exception ''Comprobante % esta en cero ...Verifique'',ai_secuencia;
           Return 0;
        end if;
    end if;
    
    
    select into ldc_work sum(debito-credito) from cglcomprobante2
    where compania = as_compania
    and aplicacion = as_aplicacion
    and year = ai_year
    and periodo = ai_periodo
    and secuencia = ai_secuencia;
    if ldc_work is null or ldc_work <> 0 then
--       Raise Exception ''Comprobante % esta en desbalance...Verifique %'',ai_secuencia, ldc_work;
       Return 0;
    end if;
    
    delete from rela_cglcomprobante1_cglposteo
    where compania = as_compania
    and aplicacion = as_aplicacion
    and year = ai_year
    and periodo = ai_periodo
    and secuencia = ai_secuencia;
    
    for r_cglcomprobante2 in select * from cglcomprobante2
                                where compania = as_compania
                                and aplicacion = as_aplicacion
                                and year = ai_year
                                and periodo = ai_periodo
                                and secuencia = ai_secuencia
                                and (debito <> 0 or credito <> 0)
                                order by cuenta
    loop
        select into r_cglcuentas * from cglcuentas
        where cuenta = r_cglcomprobante2.cuenta
        and auxiliar_1 = ''S'';
        if found then
           select into ldc_work sum(debito-credito) from cglcomprobante3
            where compania = as_compania
            and aplicacion = as_aplicacion
            and year = ai_year
            and periodo = ai_periodo
            and secuencia = ai_secuencia
            and linea = r_cglcomprobante2.linea;
            if ldc_work is null then
               Raise Exception ''Comprobante % esta en desbalance.  Verifica cuenta %  %'',ai_secuencia, r_cglcomprobante2.cuenta,ldc_work;
            end if;
            
            ldc_work := ldc_work - (r_cglcomprobante2.debito-r_cglcomprobante2.credito);
            if ldc_work <> 0 then
               Raise Exception ''Comprobante % esta en desbalance.  Verifica cuenta %  '',ai_secuencia, r_cglcomprobante2.cuenta;
            end if;
            
        end if;
    end loop;
    
    
    for r_cglcomprobante2 in select * from cglcomprobante2
                                where compania = as_compania
                                and aplicacion = as_aplicacion
                                and year = ai_year
                                and periodo = ai_periodo
                                and secuencia = ai_secuencia
                                and (debito <> 0 or credito <> 0)
                                order by cuenta
    loop
        select into r_cglcuentas * from cglcuentas
        where cuenta = r_cglcomprobante2.cuenta
        and auxiliar_1 = ''S'';
        if found then
           for r_cglcomprobante3 in select * from cglcomprobante3
                                    where compania = as_compania
                                    and aplicacion = as_aplicacion
                                    and year = ai_year
                                    and periodo = ai_periodo
                                    and secuencia = ai_secuencia
                                    and linea = r_cglcomprobante2.linea
           loop
           
               li_consecutivo := f_cglposteo(as_compania, as_aplicacion, r_cglcomprobante1.fecha_comprobante,
                                    r_cglcomprobante2.cuenta, r_cglcomprobante3.auxiliar, null,
                                    r_cglcomprobante1.tipo_comp, r_cglcomprobante2.descripcion,
                                    (r_cglcomprobante3.debito-r_cglcomprobante3.credito));
                if li_consecutivo > 0 then
                    insert into rela_cglcomprobante1_cglposteo (compania, aplicacion, year, periodo, secuencia, consecutivo)
                    values (as_compania, as_aplicacion, ai_year, ai_periodo, ai_secuencia, li_consecutivo);
                end if;
                
           end loop;
        else
        
           li_consecutivo := f_cglposteo(as_compania, as_aplicacion, r_cglcomprobante1.fecha_comprobante,
                                r_cglcomprobante2.cuenta, null, null,
                                r_cglcomprobante1.tipo_comp, r_cglcomprobante2.descripcion,
                                (r_cglcomprobante2.debito-r_cglcomprobante2.credito));
            if li_consecutivo > 0 then
                insert into rela_cglcomprobante1_cglposteo (compania, aplicacion, year, periodo, secuencia, consecutivo)
                values (as_compania, as_aplicacion, ai_year, ai_periodo, ai_secuencia, li_consecutivo);
            end if;
            
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;


create function f_rela_cglcomprobante1_cglposteo_insert() returns trigger as '
begin
    update cglposteo
    set secuencia = new.secuencia
    where consecutivo = new.consecutivo;
    return new;
end;
' language plpgsql;


create function f_rela_cglcomprobante1_cglposteo_update() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return new;
end;
' language plpgsql;

create function f_rela_cglcomprobante1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;


create function f_rela_cgl_comprobante1_cglposteo_insert() returns trigger as '
begin
    update cglposteo
    set secuencia = new.secuencia
    where cglposteo.consecutivo = new.consecutivo;
    return new;
end;
' language plpgsql;

create function f_rela_cgl_comprobante1_cglposteo_update() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return new;
end;
' language plpgsql;


create function f_rela_cgl_comprobante1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;




create trigger t_rela_cgl_comprobante1_cglposteo_insert after insert on rela_cgl_comprobante1_cglposteo
for each row execute procedure f_rela_cgl_comprobante1_cglposteo_insert();

create trigger t_rela_cgl_comprobante1_cglposteo_update after update on rela_cgl_comprobante1_cglposteo
for each row execute procedure f_rela_cgl_comprobante1_cglposteo_update();

create trigger t_rela_cgl_comprobante1_cglposteo_delete after delete on rela_cgl_comprobante1_cglposteo
for each row execute procedure f_rela_cgl_comprobante1_cglposteo_delete();


create trigger t_rela_cglcomprobante1_cglposteo_insert after insert on rela_cglcomprobante1_cglposteo
for each row execute procedure f_rela_cglcomprobante1_cglposteo_insert();

create trigger t_rela_cglcomprobante1_cglposteo_update after update on rela_cglcomprobante1_cglposteo
for each row execute procedure f_rela_cglcomprobante1_cglposteo_update();

create trigger t_rela_cglcomprobante1_cglposteo_delete after delete on rela_cglcomprobante1_cglposteo
for each row execute procedure f_rela_cglcomprobante1_cglposteo_delete();


drop function f_cglposteo_insert() cascade;
drop function f_cglposteo_delete() cascade;
drop function f_cglposteo_update() cascade;
drop function f_cglposteoaux1_insert() cascade;
drop function f_cglposteoaux1_delete() cascade;
drop function f_cglposteoaux1_update() cascade;
drop function f_cglposteo_consecutivo();
drop function f_cglposteoaux1(int4, char(24), char(10), decimal(10,2));
drop function f_cglposteo(char(2), char(3), date, char(24), char(10), char(10), char(3), text, decimal(10,2));
drop function f_cglposteoaux1_cxpdocm(int4, char(10), int4) cascade;
drop function f_cglposteoaux1_cxcdocm(int4, char(10), int4) cascade;
drop function f_cglposteo_before_delete() cascade;

create function f_cglposteoaux1_cxcdocm(int4, char(10), int4) returns integer as '
declare
    ai_consecutivo alias for $1;
    as_auxiliar alias for $2;
    ai_secuencial alias for $3;
    r_cglposteoaux1 record;
    r_cglposteo record;
    r_cglctasxaplicacion record;
    r_clientes record;
    r_cglauxiliares record;
    r_cxcmotivos record;
    r_almacen record;
    ls_telefono char(15);
    ls_id char(30);
    ls_dv char(3);
    ls_direccion char(40);
    ldc_monto decimal(10,2);
    ldc_signo decimal(10,2);
    ls_documento char(25);
    ls_almacen char(2);
begin
    select into r_cglposteoaux1 * from cglposteoaux1
    where consecutivo = ai_consecutivo
    and auxiliar = as_auxiliar
    and secuencial = ai_secuencial;
    if not found then
        return 0;
    end if;
    
    select into r_cglposteo * from cglposteo
    where consecutivo = ai_consecutivo;
    if not found then
        return 0;
    end if;
    
    select into r_cglctasxaplicacion * from cglctasxaplicacion
    where trim(cuenta) = trim(r_cglposteo.cuenta)
    and aplicacion = ''CXC'';
    if not found then
        return 0;
    end if;
    
    select into r_clientes * from clientes
    where trim(cliente) = trim(as_auxiliar);
    if not found then
        select into r_cglauxiliares * from cglauxiliares
        where trim(auxiliar) = trim(as_auxiliar);
        
        if r_cglauxiliares.telefono is null then
            ls_telefono := ''1'';
        else
            ls_telefono := r_cglauxiliares.telefono;
        end if;
        
        if r_cglauxiliares.id is null then
            ls_id := ''1'';
        else
            ls_id := trim(r_cglauxiliares.id);
        end if;
        
        if r_cglauxiliares.dv is null then
            ls_dv := ''1'';
        else
            ls_dv := trim(r_cglauxiliares.dv);
        end if;
        
        if r_cglauxiliares.direccion is null then
            ls_direccion := ''1'';
        else
            ls_direccion := trim(r_cglauxiliares.direccion);
        end if;
        
        insert into clientes(cliente, forma_pago, cuenta, cli_cliente, vendedor,
            nomb_cliente, fecha_apertura, fecha_cierre, status, usuario,
            fecha_captura, tel1_cliente, direccion1, limite_credito, promedio_dias_cobro,
            estado_cuenta, categoria_abc)
        values (trim(as_auxiliar), ''30'', r_cglposteo.cuenta, trim(as_auxiliar), ''00'',
            r_cglauxiliares.nombre, current_date, current_date, ''A'', current_user,
            current_timestamp, ls_telefono, ls_direccion, 0, 0, ''S'', ''X'');
        
        
    end if;
    
    ldc_monto := r_cglposteoaux1.debito - r_cglposteoaux1.credito;
    ldc_signo := ldc_monto / Abs(ldc_monto);
    
    select into r_cxcmotivos * from cxcmotivos
    where signo = ldc_signo
    and ajustes = ''S'';
    if not found then
        Raise Exception ''No existe ningun motivo en cxcmotivos con la naturaleza %'',ldc_signo;
    end if;
   
   ls_documento := r_cglposteo.aplicacion_origen || trim(to_char(r_cglposteo.consecutivo, ''999999999''));


    ls_almacen := f_gralparaxcia(r_cglposteo.compania, ''INV'', ''alma_default'');
    
    select into r_almacen * from almacen
    where compania = r_cglposteo.compania
    and almacen = ls_almacen;
    if not found then
        select into r_almacen * from almacen
        where compania = r_cglposteo.compania;
        ls_almacen := r_almacen.almacen;
    end if;
    
    insert into cxcdocm(almacen, cliente, documento, docmto_aplicar, motivo_cxc, 
        docmto_ref, motivo_ref, fecha_posteo, fecha_docmto, fecha_vmto,
        fecha_cancelo, fecha_captura, usuario, obs_docmto, uso_interno, status, aplicacion_origen,
        monto)
    values(ls_almacen, trim(as_auxiliar), trim(ls_documento), trim(ls_documento),
        r_cxcmotivos.motivo_cxc, trim(ls_documento), r_cxcmotivos.motivo_cxc,
        r_cglposteo.fecha_comprobante, r_cglposteo.fecha_comprobante, 
        r_cglposteo.fecha_comprobante, r_cglposteo.fecha_comprobante, current_timestamp,
        current_user, trim(r_cglposteo.descripcion), ''N'', ''P'', 
        r_cglposteo.aplicacion_origen, Abs(ldc_monto));

    return 1;
end;
' language plpgsql;


create function f_cglposteoaux1_cxpdocm(int4, char(10), int4) returns integer as '
declare
    ai_consecutivo alias for $1;
    as_auxiliar alias for $2;
    ai_secuencial alias for $3;
    r_cglposteoaux1 record;
    r_cglposteo record;
    r_cglctasxaplicacion record;
    r_proveedores record;
    r_cglauxiliares record;
    r_cxpmotivos record;
    ls_telefono char(15);
    ls_id char(30);
    ls_dv char(3);
    ls_direccion char(40);
    ldc_monto decimal(10,2);
    ldc_signo decimal(10,2);
    ls_documento char(25);
    
begin
    select into r_cglposteoaux1 * from cglposteoaux1
    where consecutivo = ai_consecutivo
    and auxiliar = as_auxiliar
    and secuencial = ai_secuencial;
    if not found then
        return 0;
    end if;
    
    select into r_cglposteo * from cglposteo
    where consecutivo = ai_consecutivo;
    
    select into r_cglctasxaplicacion * from cglctasxaplicacion
    where cuenta = r_cglposteo.cuenta
    and aplicacion = ''CXP'';
    if not found then
        return 0;
    end if;
    
    select into r_proveedores * from proveedores
    where trim(proveedor) = trim(as_auxiliar);
    if not found then
        select into r_cglauxiliares * from cglauxiliares
        where trim(auxiliar) = trim(as_auxiliar);
        
        if r_cglauxiliares.telefono is null then
            ls_telefono := ''1'';
        else
            ls_telefono := r_cglauxiliares.telefono;
        end if;
        
        if r_cglauxiliares.id is null then
            ls_id := ''1'';
        else
            ls_id := trim(r_cglauxiliares.id);
        end if;
        
        if r_cglauxiliares.dv is null then
            ls_dv := ''1'';
        else
            ls_dv := trim(r_cglauxiliares.dv);
        end if;
        
        if r_cglauxiliares.direccion is null then
            ls_direccion := ''1'';
        else
            ls_direccion := trim(r_cglauxiliares.direccion);
        end if;
        
        
        insert into proveedores (proveedor, forma_pago, cuenta, nomb_proveedor,
            tel1_proveedor, id_proveedor, dv_proveedor, status, usuario, fecha_captura,
            limite_credito, fecha_apertura, direccion1)
        values (trim(as_auxiliar), ''30'', r_cglposteo.cuenta, r_cglauxiliares.nombre,
            trim(ls_telefono), trim(ls_id), trim(ls_dv), ''A'', current_user, current_timestamp,
            99999, current_date, trim(ls_direccion));
    end if;
    
    ldc_monto := r_cglposteoaux1.debito - r_cglposteoaux1.credito;
    ldc_signo := ldc_monto / Abs(ldc_monto);
    
    select into r_cxpmotivos * from cxpmotivos
    where signo = ldc_signo
    and ajuste = ''S'';
    if not found then
        Raise Exception ''No existe ningun motivo en cxpmotivos con la naturaleza %'',ldc_signo;
    end if;
   
   ls_documento := r_cglposteo.aplicacion_origen || trim(to_char(r_cglposteo.consecutivo, ''999999999''));

   
   insert into cxpdocm (proveedor, compania, documento, docmto_aplicar,
    motivo_cxp, docmto_aplicar_ref, motivo_cxp_ref, aplicacion_origen,
    uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo, status,
    usuario, fecha_captura, obs_docmto, fecha_cancelo)
   values (as_auxiliar, r_cglposteo.compania, trim(ls_documento), trim(ls_documento),
    r_cxpmotivos.motivo_cxp, trim(ls_documento), r_cxpmotivos.motivo_cxp, r_cglposteo.aplicacion_origen,
    ''N'', r_cglposteo.fecha_comprobante, r_cglposteo.fecha_comprobante, Abs(ldc_monto),
    r_cglposteo.fecha_comprobante, ''P'', current_user, current_timestamp, trim(r_cglposteo.descripcion),
    current_date);
   
    return 1;
end;
' language plpgsql;


create function f_cglposteo(char(2), char(3), date, char(24), char(10), char(10), char(3), text, decimal(10,2)) returns int4 as '
declare
    as_compania alias for $1;
    as_aplicacion alias for $2;
    ad_fecha alias for $3;
    as_cuenta alias for $4;
    as_aux1 alias for $5;
    as_aux2 alias for $6;
    as_tipo_comp alias for $7;
    as_descripcion alias for $8;
    adc_monto alias for $9;
    r_gralperiodos record;
    r_cglcuentas record;
    r_cglauxiliares record;
    li_consecutivo int4;
    ldc_debito decimal(10,2);
    ldc_credito decimal(10,2);
    i integer;
begin

    if adc_monto = 0 then
       return 0;
    end if;
    
    if adc_monto > 0 then
       ldc_debito  := adc_monto;
       ldc_credito := 0;
    else
       ldc_debito  := 0;
       ldc_credito := -adc_monto;
    end if;
    
    select into r_gralperiodos * from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and ad_fecha between inicio and final
    and estado = ''A'';
    if not found then
       raise exception ''Fecha % corresponde a un periodo cerrado...Verifique'',ad_fecha;
    end if;
    
    if as_cuenta is null then
       Raise Exception ''Cuenta % no puede ser nula...Verifique'',as_cuenta;
    end if;
    
    select into r_cglcuentas * from cglcuentas
    where cuenta = as_cuenta
    and status = ''I'';
    if found Then
       Raise Exception ''Cuenta % Esta Inactiva...Verifique'',as_cuenta;
    end if;
    
    select into r_cglcuentas cglcuentas.* from cglcuentas, cglniveles
    where cglcuentas.nivel = cglniveles.nivel
    and cglniveles.recibe = ''N''
    and cuenta = as_cuenta;
    if found then
       Raise Exception ''Cuenta % NO Recibe Movimientos...Verifique'',as_cuenta;
    end if;

    select into r_cglcuentas * from cglcuentas
    where cuenta = as_cuenta
    and auxiliar_1 = ''S'';
    if found and as_aux1 is null then
       Raise Exception ''Cuenta % lleva auxiliar...Verifique '',as_cuenta;
    end if;
    
    select into r_cglauxiliares * from cglauxiliares
    where auxiliar = as_aux1
    and status = ''I'';
    if found then
        Raise Exception ''Auxliar % esta Inactivo...Verifique'', as_aux1;
    end if;
    
    
    select into r_gralperiodos * from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and ad_fecha between inicio and final
    and estado = ''A''
    order by inicio;
    
    
    li_consecutivo := f_cglposteo_consecutivo();
    
    insert into cglposteo (consecutivo, secuencia, compania, aplicacion, year, periodo,
        cuenta, tipo_comp, aplicacion_origen, usuario_captura, usuario_actualiza,
        fecha_comprobante, fecha_captura, fecha_actualiza, descripcion, debito, credito,
        status, linea)
    values (li_consecutivo, 0, as_compania, ''CGL'', r_gralperiodos.year, 
        r_gralperiodos.periodo, as_cuenta, as_tipo_comp, as_aplicacion, current_user, 
        current_user, ad_fecha, current_timestamp, current_date, as_descripcion, 
        ldc_debito, ldc_credito, ''R'', 0);

    i := f_cglposteoaux1(li_consecutivo, as_cuenta, as_aux1, adc_monto);
    
    return li_consecutivo;
end;
' language plpgsql;


create function f_cglposteo_consecutivo() returns int4 as '
declare
    r_gralparaxapli record;
    r_work record;
    secuencia int4;
begin
    select into r_gralparaxapli gralparaxapli.* from gralparaxapli
    where aplicacion = ''CGL''
    and parametro = ''consec_posteo'';
    if not found then
        secuencia := 0;
    else
        secuencia := to_number(r_gralparaxapli.valor, ''99999999999999'');
    end if;
    
    loop
        secuencia := secuencia + 1;
        
        select into r_work * from cglposteo
        where consecutivo = secuencia;
        if not found then
           exit;
        end if;
    end loop;
    
    update gralparaxapli
    set valor = trim(to_char(secuencia, ''99999999999''))
    where parametro = ''consec_posteo''
    and aplicacion = ''CGL'';
     
    return secuencia;
end;
' language plpgsql;


create function f_cglposteoaux1(int4, char(24), char(10), decimal(10,2)) returns int4 as '
declare
    ai_consecutivo alias for $1;
    as_cuenta alias for $2;
    as_auxiliar alias for $3;
    adc_monto alias for $4;
    r_cglcuentas record;
    ldc_debito decimal(10,2);
    ldc_credito decimal(10,2);
    r_cglposteo record;
    r_cglposteoaux1 record;
    li_secuencial integer;
begin
    if adc_monto = 0 then
       return 0;
    end if;

    select into r_cglcuentas * from cglcuentas
    where trim(cuenta) = trim(as_cuenta)
    and trim(auxiliar_1) = ''S'';
    if found then
       if adc_monto > 0 then
          ldc_debito  := adc_monto;
          ldc_credito := 0;
       else
          ldc_debito  := 0;
          ldc_credito := -adc_monto;
       end if;
       
       select into r_cglposteo * from cglposteo
       where consecutivo = ai_consecutivo;
       if found then
            li_secuencial := 1;
            loop
                select into r_cglposteoaux1 * from cglposteoaux1
                where consecutivo = ai_consecutivo
                and auxiliar = as_auxiliar
                and secuencial = li_secuencial;
                if not found then
                   insert into cglposteoaux1 (consecutivo, auxiliar, secuencial, debito, credito)
                   values (ai_consecutivo, as_auxiliar, li_secuencial, ldc_debito, ldc_credito);
                   exit;
                else
                    li_secuencial := li_secuencial + 1;
                end if;
            end loop;                
        end if;           
    end if;
    return ai_consecutivo;
end;
' language plpgsql;



create function f_cglposteo_insert() returns trigger as '
declare
    r_cglniveles record;
    r_cglcuentas record;
    r_cglsldocuenta record;
    ls_cuenta char(24);
    i integer;
begin
    select into r_cglniveles cglniveles.* from cglcuentas, cglniveles
    where cglcuentas.nivel = cglniveles.nivel
    and cglcuentas.cuenta = new.cuenta
    and cglniveles.recibe = ''N'';
    if found then
       raise exception ''Cuenta % no recibe movimientos...Verifique'', new.cuenta;
    end if;
    
    i := f_cglsldocuenta(new.compania, new.cuenta, new.year, new.periodo, new.debito, new.credito);

/*
    update cglsldocuenta
    set debito = 0, credito = 0
    where compania = new.compania
    and year = new.year
    and periodo = new.periodo;
    
    update cglsldocuenta
    set debito = v_cglposteo.debito, credito = v_cglposteo.credito
    where cglsldocuenta.compania = v_cglposteo.compania
    and cglsldocuenta.cuenta = v_cglposteo.cuenta
    and cglsldocuenta.year = v_cglposteo.year
    and cglsldocuenta.periodo = v_cglposteo.periodo
    and cglsldocuenta.compania = new.compania
    and cglsldocuenta.year = new.year
    and cglsldocuenta.periodo = new.periodo;
*/
    
    
    return new;
end;
' language plpgsql;


create function f_cglposteoaux1_insert() returns trigger as '
declare
    i integer;
    r_cglposteo record;
begin
    select into r_cglposteo * from cglposteo
    where consecutivo = new.consecutivo;
    if found then
       i := f_cglsldoaux1(r_cglposteo.compania, r_cglposteo.cuenta, new.auxiliar, r_cglposteo.year, r_cglposteo.periodo, new.debito, new.credito);
    end if;
    
--    i := f_cglposteoaux1_cxpdocm(new.consecutivo, new.auxiliar, new.secuencial);
--    i := f_cglposteoaux1_cxcdocm(new.consecutivo, new.auxiliar, new.secuencial);


    
    return new;
end;
' language plpgsql;

create function f_cglposteoaux1_delete() returns trigger as '
declare
    i integer;
    r_cglposteo record;
begin
    
    select into r_cglposteo * from cglposteo
    where consecutivo = old.consecutivo;
    if found then
        i := f_cglsldoaux1(r_cglposteo.compania, r_cglposteo.cuenta, old.auxiliar, r_cglposteo.year, r_cglposteo.periodo, -old.debito, -old.credito);
    end if;
    
    return old;
end;
' language plpgsql;


create function f_cglposteoaux1_update() returns trigger as '
declare
    i integer;
    r_cglposteo record;
begin
    select into r_cglposteo * from cglposteo
    where consecutivo = old.consecutivo;
    if found then
       i := f_cglsldoaux1(r_cglposteo.compania, r_cglposteo.cuenta, old.auxiliar, r_cglposteo.year, r_cglposteo.periodo, -old.debito, -old.credito);
    end if;
    
    select into r_cglposteo * from cglposteo
    where consecutivo = new.consecutivo;
    
    i := f_cglsldoaux1(r_cglposteo.compania, r_cglposteo.cuenta, new.auxiliar, r_cglposteo.year, r_cglposteo.periodo, new.debito, new.credito);

--    i := f_cglposteaux1_cxpdocm(new.consecutivo, new.auxiliar, new.secuencia);
--    i := f_cglposteaux1_cxcdocm(new.consecutivo, new.auxiliar, new.secuencia);
    
    return new;
end;
' language plpgsql;


create function f_cglposteo_delete() returns trigger as '
declare
    r_cglniveles record;
    r_cglcuentas record;
    r_cglsldocuenta record;
    r_cglposteoaux1 record;
    ls_cuenta char(24);
    ldc_debito decimal(12,2);
    ldc_credito decimal(12,2);
    ls_documento char(25);
    i integer;
    r_gralperiodos record;
begin

    select into r_gralperiodos * from gralperiodos
    where compania = old.compania
    and aplicacion = ''CGL''
    and old.fecha_comprobante between inicio and final
    and estado = ''I'';
    if found then
       raise exception ''Fecha % corresponde a un periodo cerrado no se puede eliminar...Verifique'',old.fecha_comprobante;
    end if;
    
    select into r_cglniveles cglniveles.* from cglcuentas, cglniveles
    where cglcuentas.nivel = cglniveles.nivel
    and cglcuentas.cuenta = old.cuenta
    and cglniveles.recibe = ''N'';
    if found then
       raise exception ''Cuenta % no recibe movimientos...Verifique'', old.cuenta;
    end if;
    
    select into r_cglcuentas * from cglcuentas
    where cuenta = old.cuenta;

 
    i := f_cglsldocuenta(old.compania, old.cuenta, old.year, old.periodo, -old.debito, -old.credito);


    ls_documento := trim(old.aplicacion_origen) || trim(to_char(old.consecutivo, ''99999999''));
    
/*
    delete from cxpdocm
    where compania = old.compania
    and trim(documento) = trim(ls_documento)
    and trim(docmto_aplicar) = trim(ls_documento);
    
    delete from cxcdocm
    where trim(documento) = trim(ls_documento)
    and trim(docmto_aplicar) = trim(ls_documento)
    and almacen in (select almacen from almacen where compania = old.compania);
*/    


    update cglsldoaux1
    set debito = 0, credito = 0
    where cglsldoaux1.compania = old.compania
    and cglsldoaux1.year = old.year
    and cglsldoaux1.periodo = old.periodo
    and cglsldoaux1.cuenta = old.cuenta;


    update cglsldoaux1
    set debito = v_cglsldoaux1.debito,
    credito = v_cglsldoaux1.credito
    where cglsldoaux1.compania = v_cglsldoaux1.compania
    and cglsldoaux1.cuenta = v_cglsldoaux1.cuenta
    and cglsldoaux1.auxiliar = v_cglsldoaux1.auxiliar
    and cglsldoaux1.year = v_cglsldoaux1.year
    and cglsldoaux1.periodo = v_cglsldoaux1.periodo
    and cglsldoaux1.compania = old.compania
    and cglsldoaux1.year = old.year
    and cglsldoaux1.periodo = old.periodo
    and cglsldoaux1.cuenta = old.cuenta;
    

    return old;
end;
' language plpgsql;

create function f_cglposteo_update() returns trigger as '
declare
    r_bcocircula record;
begin
    return new;
end;
' language plpgsql;


create function f_cglposteo_before_delete() returns trigger as '
declare
    r_cglposteoaux1 record;
    i integer;
    ls_sql text;
    ls_tabla text;
    r_pg_class1 record;
    r_pg_class2 record;
    r_pg_constraint record;
    r_pg_attribute record;
    r_gralperiodos record;
begin
    select into r_gralperiodos * from gralperiodos
    where compania = old.compania
    and aplicacion = ''CGL''
    and old.fecha_comprobante between inicio and final
    and estado = ''I'';
    if found then
       raise exception ''Fecha % corresponde a un periodo cerrado...Verifique'',old.fecha_comprobante;
    end if;


    for r_cglposteoaux1 in select * from cglposteoaux1
                                where consecutivo = old.consecutivo
    loop
        i := f_cglsldoaux1(old.compania, old.cuenta, r_cglposteoaux1.auxiliar, old.year, old.periodo, -r_cglposteoaux1.debito, -r_cglposteoaux1.credito);
    end loop;

    for r_pg_constraint in select pg_constraint.* from pg_class, pg_constraint
                        where pg_class.relname = ''cglposteo''
                        and pg_constraint.confrelid = pg_class.oid
    loop
        select into r_pg_class2 * from pg_class
        where oid = r_pg_constraint.conrelid and relkind = ''r'';
        if found then
            select into r_pg_attribute * from pg_attribute
            where pg_attribute.attrelid = r_pg_constraint.conrelid
            and pg_attribute.attnum = r_pg_constraint.conkey[1];
        
            ls_sql := ''delete from '' || trim(r_pg_class2.relname) || '' where '' || trim(r_pg_attribute.attname) || '' = '' || old.consecutivo;
            execute ls_sql;
        end if;
        
    end loop;                   
    
    
    return old;
end;
' language plpgsql;



--create trigger t_cglposteo_before_delete before delete on cglposteo
--for each row execute procedure f_cglposteo_before_delete();

create trigger t_cglposteo_insert after insert on cglposteo
for each row execute procedure f_cglposteo_insert();

create trigger t_cglposteo_delete after delete on cglposteo
for each row execute procedure f_cglposteo_delete();

create trigger t_cglposteo_update after update on cglposteo
for each row execute procedure f_cglposteo_update();


--create trigger t_cglposteoaux1_update after update on cglposteoaux1
--for each row execute procedure f_cglposteoaux1_update();

--create trigger t_cglposteoaux1_delete after delete on cglposteoaux1
--for each row execute procedure f_cglposteoaux1_delete();

create trigger t_cglposteoaux1_insert after insert on cglposteoaux1
for each row execute procedure f_cglposteoaux1_insert();

drop function f_factura1_delete() cascade;
drop function f_factura1_update() cascade;
drop function f_factura1_insert() cascade;
drop function f_factura_cxcdocm(char(2), char(3), integer);
drop function f_saldo_docmto_cxc(char(2), char(10), char(25),  char(3), date);
drop function f_saldo_cliente(char(2), char(10), date);
drop function f_cxctrx1_delete() cascade;
drop function f_cxctrx1_update() cascade;
drop function f_cxctrx1_cxcdocm(char(2), int4);
drop function f_cxctrx1_cglposteo(char(2), int4);
drop function f_rela_cxctrx1_cglposteo_delete() cascade;
drop function f_cxctrx2_delete() cascade;
drop function f_cxctrx2_insert() cascade;
drop function f_cxctrx2_update() cascade;
drop function f_cxctrx3_delete() cascade;
drop function f_cxcdocm_insert() cascade;
drop function f_cxcdocm_delete() cascade;
drop function f_cxcdocm_update() cascade;

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


create function f_cxcdocm_delete() returns trigger as '
declare
    r_cxctrx1 record;
    r_cxcdocm record;
    r_gralperiodos record;
    r_almacen record;
    r_cxcmotivos record;
    r_cxcbalance record;
begin
    if old.monto = 0 then
        return old;
    end if;
    
    select into r_almacen * from almacen
    where almacen = old.almacen;
    
    select into r_gralperiodos * from gralperiodos
    where compania = r_almacen.compania 
    and aplicacion = ''CXC''
    and old.fecha_posteo between inicio and final;
    if not found then
        return old;
    end if;
    
    select into r_cxcmotivos * from cxcmotivos
    where motivo_cxc = old.motivo_cxc;
    
    update cxcbalance
    set saldo = saldo + (old.monto * -r_cxcmotivos.signo)
    where compania = r_almacen.compania
    and cliente = old.cliente
    and aplicacion = ''CXC''
    and year = r_gralperiodos.year
    and periodo = r_gralperiodos.periodo;
    
    return old;
end;
' language plpgsql;

create function f_cxcdocm_update() returns trigger as '
declare
    r_cxctrx1 record;
    r_cxcdocm record;
    r_gralperiodos record;
    r_almacen record;
    r_cxcmotivos record;
    r_cxcbalance record;
begin
    if old.monto = 0 then
        return old;
    end if;
    
    select into r_almacen * from almacen
    where almacen = old.almacen;
    
    select into r_gralperiodos * from gralperiodos
    where compania = r_almacen.compania 
    and aplicacion = ''CXC''
    and old.fecha_posteo between inicio and final;
    if not found then
        return old;
    end if;
    
    select into r_cxcmotivos * from cxcmotivos
    where motivo_cxc = old.motivo_cxc;
    
    update cxcbalance
    set saldo = saldo + (old.monto * -r_cxcmotivos.signo)
    where compania = r_almacen.compania
    and cliente = old.cliente
    and aplicacion = ''CXC''
    and year = r_gralperiodos.year
    and periodo = r_gralperiodos.periodo;
    
    return new;
end;
' language plpgsql;



create function f_cxcdocm_insert() returns trigger as '
declare
    r_cxctrx1 record;
    r_cxcdocm record;
    r_gralperiodos record;
    r_almacen record;
    r_cxcmotivos record;
    r_cxcbalance record;
    ldc_saldo decimal(12,2);
begin
    if new.monto = 0 then
        return new;
    end if;
    
    select into r_almacen * from almacen
    where almacen = new.almacen;
    
    select into r_gralperiodos * from gralperiodos
    where compania = r_almacen.compania 
    and aplicacion = ''CXC''
    and new.fecha_posteo between inicio and final;
    if not found then
        return new;
    end if;
    
    select into r_cxcmotivos * from cxcmotivos
    where motivo_cxc = new.motivo_cxc;
    
    select into r_cxcbalance * from cxcbalance
    where compania = r_almacen.compania
    and cliente = new.cliente
    and aplicacion = ''CXC''
    and year = r_gralperiodos.year
    and periodo = r_gralperiodos.periodo;
    if not found then
        ldc_saldo   =   f_saldo_cliente(r_almacen.compania, new.cliente, r_gralperiodos.final);
        insert into cxcbalance (aplicacion, compania, cliente, year, periodo, saldo)
        values (''CXC'', r_almacen.compania,  new.cliente, r_gralperiodos.year,
        r_gralperiodos.periodo, ldc_saldo);
    else
        update cxcbalance
        set saldo = saldo + (new.monto * r_cxcmotivos.signo)
        where compania = r_almacen.compania
        and cliente = new.cliente
        and aplicacion = ''CXC''
        and year = r_gralperiodos.year
        and periodo = r_gralperiodos.periodo;
    end if;
    
    return new;
end;
' language plpgsql;




create function f_factura1_insert() returns trigger as '
declare
    li_work integer;
begin
    li_work := f_factura_cxcdocm(new.almacen, new.tipo, new.num_documento);
    return new;
end;
' language plpgsql;


create function f_factura1_update() returns trigger as '
declare
    li_work integer;
begin
    if old.almacen <> new.almacen
        or old.tipo <> new.tipo
        or old.num_documento <> new.num_documento then
        delete from cxcdocm
        where documento = trim(to_char(old.num_documento, ''9999999999''))
        and docmto_aplicar = trim(to_char(old.num_documento, ''9999999999''))
        and cliente = old.cliente
        and motivo_cxc = old.tipo
        and almacen = old.almacen;
    end if;       
    
    li_work := f_factura_cxcdocm(new.almacen, new.tipo, new.num_documento);
    
    if new.status = ''A'' then
        delete from factura2_eys2
        where almacen = old.almacen
        and tipo = old.tipo
        and num_documento = old.num_documento;
    end if;
    
    return new;
end;
' language plpgsql;


create function f_factura1_delete() returns trigger as '
begin
    delete from cxcdocm
    where documento = trim(to_char(old.num_documento, ''9999999999''))
    and docmto_aplicar = trim(to_char(old.num_documento, ''9999999999''))
    and cliente = old.cliente
    and motivo_cxc = old.tipo
    and almacen = old.almacen;
    return old;
end;
' language plpgsql;



create function f_cxctrx1_update() returns trigger as '
declare
    li_work integer;
begin
    if old.almacen <> new.almacen
        or old.docm_ajuste_cxc <> new.docm_ajuste_cxc 
        or old.cliente <> new.cliente 
        or old.motivo_cxc <> new.motivo_cxc then
        delete from cxcdocm
        where documento = old.docm_ajuste_cxc
        and cliente = old.cliente
        and motivo_cxc = old.motivo_cxc
        and almacen = old.almacen;
    end if;        
    
    li_work := f_cxctrx1_cxcdocm(new.almacen, new.sec_ajuste_cxc);
    
    return new;
end;
' language plpgsql;


create function f_cxctrx1_delete() returns trigger as '
begin
    delete from cxcdocm
    where trim(documento) = trim(old.docm_ajuste_cxc)
    and trim(cliente) = trim(old.cliente)
    and trim(motivo_cxc) = trim(old.motivo_cxc)
    and trim(almacen) = trim(old.almacen);
    return old;
end;
' language plpgsql;

create function f_cxctrx2_insert() returns trigger as '
declare
    r_cxctrx1 record;
    r_cxcdocm record;
begin
    if new.monto = 0 then
        return old;
    end if;
    
    delete from rela_cxctrx1_cglposteo
    where almacen = new.almacen
    and sec_ajuste_cxc = new.sec_ajuste_cxc;
    
    select into r_cxctrx1 * from cxctrx1
    where almacen = new.almacen
    and sec_ajuste_cxc = new.sec_ajuste_cxc;
    if not found then
       return old;
    end if;
    
    select into r_cxcdocm * from cxcdocm
    where almacen = r_cxctrx1.almacen
    and cliente = r_cxctrx1.cliente
    and documento = new.aplicar_a
    and docmto_aplicar = new.aplicar_a
    and motivo_cxc = new.motivo_cxc;
    if found then
        insert into cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen, 
            docmto_ref, motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, 
            fecha_vmto, monto, fecha_posteo, status, usuario, fecha_captura, obs_docmto,
            fecha_cancelo, referencia) 
        values (r_cxctrx1.docm_ajuste_cxc, new.aplicar_a, r_cxctrx1.cliente,
            r_cxctrx1.motivo_cxc, r_cxctrx1.almacen, new.aplicar_a, new.motivo_cxc,
            ''CXC'', ''N'', r_cxctrx1.fecha_posteo_ajuste_cxc, r_cxctrx1.fecha_posteo_ajuste_cxc, 
            new.monto, r_cxctrx1.fecha_posteo_ajuste_cxc, ''R'', current_user, current_timestamp,
            r_cxctrx1.obs_ajuste_cxc, current_date, r_cxctrx1.referencia);
    end if;            
    
    
    return new;
end;
' language plpgsql;


create function f_cxctrx2_update() returns trigger as '
declare
    r_cxctrx1 record;
    r_cxcdocm record;
begin
    if old.monto = 0 and new.monto = 0 then
        return old;
    end if;
    
    delete from rela_cxctrx1_cglposteo
    where almacen = old.almacen
    and sec_ajuste_cxc = old.sec_ajuste_cxc;
    
    select into r_cxctrx1 * from cxctrx1
    where almacen = old.almacen
    and sec_ajuste_cxc = old.sec_ajuste_cxc;
    if not found then
       return old;
    end if;
    
    delete from cxcdocm
    where almacen = r_cxctrx1.almacen
    and cliente = r_cxctrx1.cliente
    and motivo_cxc = r_cxctrx1.motivo_cxc
    and documento = r_cxctrx1.docm_ajuste_cxc
    and docmto_aplicar = old.aplicar_a;
    
    
    if new.monto = 0 then
        return new;
    end if;
    select into r_cxctrx1 * from cxctrx1
    where almacen = new.almacen
    and sec_ajuste_cxc = new.sec_ajuste_cxc;
    if not found then
       return old;
    end if;
    
    select into r_cxcdocm * from cxcdocm
    where almacen = r_cxctrx1.almacen
    and cliente = r_cxctrx1.cliente
    and documento = new.aplicar_a
    and docmto_aplicar = new.aplicar_a
    and motivo_cxc = new.motivo_cxc;
    if found then
        insert into cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen, 
            docmto_ref, motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, 
            fecha_vmto, monto, fecha_posteo, status, usuario, fecha_captura, obs_docmto,
            fecha_cancelo, referencia) 
        values (r_cxctrx1.docm_ajuste_cxc, new.aplicar_a, r_cxctrx1.cliente,
            r_cxctrx1.motivo_cxc, r_cxctrx1.almacen, new.aplicar_a, new.motivo_cxc,
            ''CXC'', ''N'', r_cxctrx1.fecha_posteo_ajuste_cxc, r_cxctrx1.fecha_posteo_ajuste_cxc, 
            new.monto, r_cxctrx1.fecha_posteo_ajuste_cxc, ''R'', current_user, current_timestamp,
            r_cxctrx1.obs_ajuste_cxc, current_date, r_cxctrx1.referencia);
    end if;            
    
    return new;
end;
' language plpgsql;


create function f_cxctrx2_delete() returns trigger as '
declare
    r_cxctrx1 record;
begin
    if old.monto = 0 then
        return old;
    end if;
    
    delete from rela_cxctrx1_cglposteo
    where almacen = old.almacen
    and sec_ajuste_cxc = old.sec_ajuste_cxc;
    
    select into r_cxctrx1 * from cxctrx1
    where almacen = old.almacen
    and sec_ajuste_cxc = old.sec_ajuste_cxc;
    if not found then
       return old;
    end if;
    
    delete from cxcdocm
    where almacen = r_cxctrx1.almacen
    and cliente = r_cxctrx1.cliente
    and motivo_cxc = r_cxctrx1.motivo_cxc
    and documento = r_cxctrx1.docm_ajuste_cxc
    and docmto_aplicar = old.aplicar_a;
    
    return old;
end;
' language plpgsql;

create function f_cxctrx3_delete() returns trigger as '
declare
    r_cxctrx1 record;
begin
    if old.monto = 0 then
        return old;
    end if;
    
    delete from rela_cxctrx1_cglposteo
    where almacen = old.almacen
    and sec_ajuste_cxc = old.sec_ajuste_cxc;
    
    return old;
end;
' language plpgsql;


create function f_cxctrx1_cglposteo(char(2), int4) returns integer as '
declare
    as_almacen alias for $1;
    ai_sec_ajuste_cxc alias for $2;
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
    and sec_ajuste_cxc = ai_sec_ajuste_cxc;
    if not found then
       return 0;
    end if;
    
    
    select into ldc_sum_cxctrx1 (efectivo + cheque) from cxctrx1
    where almacen = as_almacen
    and sec_ajuste_cxc = ai_sec_ajuste_cxc;
    
    select into ldc_sum_cxctrx2 sum(monto) from cxctrx2
    where almacen = as_almacen
    and sec_ajuste_cxc = ai_sec_ajuste_cxc;
    if ldc_sum_cxctrx2 is null then
       ldc_sum_cxctrx2 := 0;
    end if;
    
    select into ldc_sum_cxctrx3 sum(monto) from cxctrx3
    where almacen = as_almacen
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
    and sec_ajuste_cxc = r_cxctrx1.sec_ajuste_cxc;
    
    select into r_cxcmotivos * from cxcmotivos
    where motivo_cxc = r_cxctrx1.motivo_cxc;
    
    select into r_almacen * from almacen
    where almacen = r_cxctrx1.almacen;
    
    select into r_clientes * from clientes
    where cliente = r_cxctrx1.cliente;
    
    if r_cxctrx1.obs_ajuste_cxc is null then
       r_cxctrx1.obs_ajuste_cxc := ''TRANSACCION #  '' || r_cxctrx1.docm_ajuste_cxc;
    else
       r_cxctrx1.obs_ajuste_cxc := ''TRANSACCION #  '' || r_cxctrx1.docm_ajuste_cxc || ''  '' || trim(r_cxctrx1.obs_ajuste_cxc);
    end if;
    
    select into ls_cuenta trim(valor) from invparal
    where almacen = r_cxctrx1.almacen
    and parametro = ''cta_cxc''
    and aplicacion =  ''INV'';
    if not found then
       ls_cuenta := r_clientes.cuenta;
    end if;
    
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
        insert into rela_cxctrx1_cglposteo (almacen, sec_ajuste_cxc, consecutivo)
        values (r_cxctrx1.almacen, r_cxctrx1.sec_ajuste_cxc, li_consecutivo);
    end if;
    for r_work in select cxctrx3.cuenta, cxctrx3.auxiliar1, cxctrx3.auxiliar2, cxctrx3.monto
                    from cxctrx3
                    where cxctrx3.almacen = r_cxctrx1.almacen
                    and cxctrx3.sec_ajuste_cxc = r_cxctrx1.sec_ajuste_cxc
                    order by 1
    loop
        li_consecutivo := f_cglposteo(r_almacen.compania, ''CXC'', r_cxctrx1.fecha_posteo_ajuste_cxc, 
                                r_work.cuenta, r_work.auxiliar1, r_work.auxiliar2,
                                r_cxcmotivos.tipo_comp, r_cxctrx1.obs_ajuste_cxc, 
                                -(r_work.monto*r_cxcmotivos.signo));
        if li_consecutivo > 0 then
            insert into rela_cxctrx1_cglposteo (almacen, sec_ajuste_cxc, consecutivo)
            values (r_cxctrx1.almacen, r_cxctrx1.sec_ajuste_cxc, li_consecutivo);
        end if;
    end loop;
    return 1;
end;
' language plpgsql;


create function f_rela_cxctrx1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;



drop function anio(date) cascade;
create function anio(date) returns float
as 'select extract("year" from $1) as anio' language 'sql';



drop function mes(date);
create function mes(date) returns float
as 'select extract("month" from $1) as mes' language 'sql';


drop function today();
create function today() returns date
as 'select current_date as fecha' language 'sql';


create function f_saldo_docmto_cxc(char(2), char(10), char(25),  char(3), date) returns decimal(10,2)
as 'select  sum(a.monto*b.signo) as saldo from cxcdocm a, cxcmotivos b
where           a.motivo_cxc                    =  b.motivo_cxc
and             a.almacen                       =  $1
and             a.cliente                       =  $2
and             a.motivo_ref                    =  $4
and             a.docmto_ref                    =  $3
and             a.docmto_aplicar                =  $3
and             a.fecha_docmto                 <=  $5;' language 'sql';



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
--            raise exception ''documento %, documento aplicar %'', lc_documento, lc_docmto_aplicar;

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


create trigger t_cxctrx1_delete after delete on cxctrx1
for each row execute procedure f_cxctrx1_delete();

create trigger t_cxctrx1_update after update on cxctrx1
for each row execute procedure f_cxctrx1_update();

create trigger t_factura1_insert after insert on factura1
for each row execute procedure f_factura1_insert();

create trigger t_factura1_delete after delete on factura1
for each row execute procedure f_factura1_delete();

create trigger t_factura1_update after update on factura1
for each row execute procedure f_factura1_update();

create trigger t_rela_cxctrx1_cglposteo_delete after delete on rela_cxctrx1_cglposteo
for each row execute procedure f_rela_cxctrx1_cglposteo_delete();

create trigger t_cxctrx3_delete after delete or update on cxctrx3
for each row execute procedure f_cxctrx3_delete();

create trigger t_cxctrx2_delete after delete on cxctrx2
for each row execute procedure f_cxctrx2_delete();

create trigger t_cxctrx2_update after update on cxctrx2
for each row execute procedure f_cxctrx2_update();

create trigger t_cxctrx2_insert after insert on cxctrx2
for each row execute procedure f_cxctrx2_insert();

create trigger t_cxcdocm_insert after insert on cxcdocm
for each row execute procedure f_cxcdocm_insert();

create trigger t_cxcdocm_delete after delete on cxcdocm
for each row execute procedure f_cxcdocm_delete();

create trigger t_cxcdocm_update1 after update on cxcdocm
for each row execute procedure f_cxcdocm_update();

create trigger t_cxcdocm_update2 after update on cxcdocm
for each row execute procedure f_cxcdocm_insert();


drop function f_recibo_cxcdocm(char(2), int4) cascade;
drop function f_cxc_recibo1_delete() cascade;
drop function f_cxc_recibo1_update() cascade;
drop function f_cxc_recibo2_delete() cascade;
drop function f_cxc_recibo2_update() cascade;
drop function f_cxc_recibo2_insert() cascade;
drop function f_cxc_recibo1_cglposteo(char(2), int4) cascade;
drop function f_rela_cxc_recibo1_cglposteo_delete() cascade;


create function f_cxc_recibo1_update() returns trigger as '
declare
    li_work integer;
begin
    delete from rela_cxc_recibo1_cglposteo
    where almacen = old.almacen
    and cxc_consecutivo = old.consecutivo;
    

    delete from cxcdocm
    where trim(documento) = trim(old.documento)
    and trim(cliente) = trim(old.cliente)
    and trim(motivo_cxc) = trim(old.motivo_cxc)
    and trim(almacen) = trim(old.almacen);

--    li_work := f_recibo_cxcdocm(new.almacen, new.consecutivo);  
    return new;
end;
' language plpgsql;


create function f_cxc_recibo1_delete() returns trigger as '
begin
    delete from rela_cxc_recibo1_cglposteo
    where almacen = old.almacen
    and cxc_consecutivo = old.consecutivo;


    delete from cxcdocm
    where trim(documento) = trim(old.documento)
    and trim(cliente) = trim(old.cliente)
    and trim(motivo_cxc) = trim(old.motivo_cxc)
    and trim(almacen) = trim(old.almacen);
    
    
    return old;
end;
' language plpgsql;

create function f_cxc_recibo2_insert() returns trigger as '
declare
    li_work integer;
    r_cxc_recibo1 record;
    r_cxcdocm record;
begin
    if new.monto_aplicar = 0 then
        return new;
    end if;
    
    select into r_cxc_recibo1 * from cxc_recibo1
    where almacen = new.almacen
    and consecutivo = new.consecutivo;
    if not found then
        return new;
    end if;
    

    delete from cxcdocm
    where almacen = r_cxc_recibo1.almacen
    and cliente = r_cxc_recibo1.cliente
    and documento = r_cxc_recibo1.documento
    and docmto_aplicar = new.documento_aplicar
    and motivo_cxc = r_cxc_recibo1.motivo_cxc;
    
    select into r_cxcdocm * from cxcdocm
    where almacen = r_cxc_recibo1.almacen
    and cliente = r_cxc_recibo1.cliente
    and documento = new.documento_aplicar
    and docmto_aplicar = new.documento_aplicar
    and motivo_cxc = new.motivo_aplicar;
    if found then
        insert into cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen, 
            docmto_ref, motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, 
            fecha_vmto, monto, fecha_posteo, status, usuario, fecha_captura, obs_docmto,
            fecha_cancelo, referencia) 
        values (r_cxc_recibo1.documento, new.documento_aplicar, r_cxc_recibo1.cliente,
            r_cxc_recibo1.motivo_cxc, r_cxc_recibo1.almacen, new.documento_aplicar,
            new.motivo_aplicar, ''CXC'',  ''N'', r_cxc_recibo1.fecha, r_cxc_recibo1.fecha,
            new.monto_aplicar, r_cxc_recibo1.fecha, ''R'', current_user, current_timestamp,
            r_cxc_recibo1.observacion, current_date, r_cxc_recibo1.referencia);
    end if;            
        
    return new;
end;
' language plpgsql;


create function f_cxc_recibo2_update() returns trigger as '
declare
    li_work integer;
    r_cxc_recibo1 record;
    r_cxcdocm record;
begin
    if old.monto_aplicar = 0 and new.monto_aplicar = 0 then
        return new;
    end if;
    
    delete from rela_cxc_recibo1_cglposteo
    where almacen = old.almacen
    and cxc_consecutivo = old.consecutivo;
    
    select into r_cxc_recibo1 * from cxc_recibo1
    where almacen = old.almacen
    and consecutivo = old.consecutivo;
    if not found then
        return new;
    end if;
    

    delete from cxcdocm
    where almacen = r_cxc_recibo1.almacen
    and cliente = r_cxc_recibo1.cliente
    and documento = r_cxc_recibo1.documento
    and docmto_aplicar = old.documento_aplicar
    and motivo_cxc = r_cxc_recibo1.motivo_cxc;
    

    if new.monto_aplicar = 0 then
        return new;
    end if;
    
    select into r_cxc_recibo1 * from cxc_recibo1
    where almacen = new.almacen
    and consecutivo = new.consecutivo;
    if not found then
        return new;
    end if;
    

    delete from cxcdocm
    where almacen = r_cxc_recibo1.almacen
    and cliente = r_cxc_recibo1.cliente
    and documento = r_cxc_recibo1.documento
    and docmto_aplicar = new.documento_aplicar
    and motivo_cxc = r_cxc_recibo1.motivo_cxc;
    
    select into r_cxcdocm * from cxcdocm
    where almacen = r_cxc_recibo1.almacen
    and cliente = r_cxc_recibo1.cliente
    and documento = new.documento_aplicar
    and docmto_aplicar = new.documento_aplicar
    and motivo_cxc = new.motivo_aplicar;
    if found then
        insert into cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen, 
            docmto_ref, motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, 
            fecha_vmto, monto, fecha_posteo, status, usuario, fecha_captura, obs_docmto,
            fecha_cancelo, referencia) 
        values (r_cxc_recibo1.documento, new.documento_aplicar, r_cxc_recibo1.cliente,
            r_cxc_recibo1.motivo_cxc, r_cxc_recibo1.almacen, new.documento_aplicar,
            new.motivo_aplicar, ''CXC'',  ''N'', r_cxc_recibo1.fecha, r_cxc_recibo1.fecha,
            new.monto_aplicar, r_cxc_recibo1.fecha, ''R'', current_user, current_timestamp,
            r_cxc_recibo1.observacion, current_date, r_cxc_recibo1.referencia);
    end if;            
        
    return new;
end;
' language plpgsql;

create function f_cxc_recibo2_delete() returns trigger as '
declare
    li_work integer;
    r_cxc_recibo1 record;
    r_cxcdocm record;
begin
    if old.monto_aplicar = 0 then
        return new;
    end if;
    
    delete from rela_cxc_recibo1_cglposteo
    where almacen = old.almacen
    and cxc_consecutivo = old.consecutivo;

    select into r_cxc_recibo1 * from cxc_recibo1
    where almacen = old.almacen
    and consecutivo = old.consecutivo;
    if not found then
        return new;
    end if;
    
    delete from cxcdocm
    where almacen = r_cxc_recibo1.almacen
    and cliente = r_cxc_recibo1.cliente
    and documento = r_cxc_recibo1.documento
    and docmto_aplicar = old.documento_aplicar
    and motivo_cxc = r_cxc_recibo1.motivo_cxc;
        
    return old;
end;
' language plpgsql;




create function f_cxc_recibo1_cglposteo(char(2), int4) returns integer as '
declare
    as_almacen alias for $1;
    ai_consecutivo alias for $2;
    li_consecutivo int4;
    r_almacen record;
    r_cxc_recibo1 record;
    r_cxc_recibo2 record;
    r_work record;
    r_clientes record;
    r_cxcmotivos record;
    r_cglcuentas record;
    r_cglauxiliares record;
    ldc_sum_cxc_recibo1 decimal(10,2);
    ldc_sum_cxc_recibo2 decimal(10,2);
    ldc_sum_cxc_recibo3 decimal(10,2);
    ls_cuenta char(24);
    ls_aux1 char(10);
begin
    select into r_cxc_recibo1 * from cxc_recibo1
    where almacen = as_almacen
    and consecutivo = ai_consecutivo;
    if not found then
       return 0;
    end if;
    
    delete from rela_cxc_recibo1_cglposteo
    where almacen = r_cxc_recibo1.almacen
    and cxc_consecutivo = r_cxc_recibo1.consecutivo;
    
    if r_cxc_recibo1.status = ''A'' then
        return 0;
    end if;
    
    
    select into ldc_sum_cxc_recibo1 (efectivo + cheque + otro) from cxc_recibo1
    where almacen = as_almacen
    and consecutivo = ai_consecutivo;
    if ldc_sum_cxc_recibo1 is null or ldc_sum_cxc_recibo1 = 0 then
       return 0;
    end if;
    
    select into ldc_sum_cxc_recibo2 sum(monto_aplicar) from cxc_recibo2
    where almacen = as_almacen
    and consecutivo = ai_consecutivo;
    if ldc_sum_cxc_recibo2 is null then
       ldc_sum_cxc_recibo2 := 0;
    end if;
    
    select into ldc_sum_cxc_recibo3 sum(monto) from cxc_recibo3
    where almacen = as_almacen
    and consecutivo = ai_consecutivo;
    if ldc_sum_cxc_recibo3 is null then
       ldc_sum_cxc_recibo3 := 0;
    end if;
    
    if ldc_sum_cxc_recibo2 <> 0 and ldc_sum_cxc_recibo2 <> ldc_sum_cxc_recibo1 then
       raise exception ''Transaccion % esta desbalanceada...Verifique'',r_cxc_recibo1.consecutivo;
    end if;
    
    if ldc_sum_cxc_recibo1 <> ldc_sum_cxc_recibo3 then
       raise exception ''Transaccion % esta desbalanceada...Verifique'',r_cxc_recibo1.consecutivo;
    end if;
    
    
    select into r_cxcmotivos * from cxcmotivos
    where motivo_cxc = r_cxc_recibo1.motivo_cxc;
    
    select into r_almacen * from almacen
    where almacen = r_cxc_recibo1.almacen;
    
    select into r_clientes * from clientes
    where cliente = r_cxc_recibo1.cliente;
    
    if r_cxc_recibo1.observacion is null then
       r_cxc_recibo1.observacion := ''RECIBO #  '' || r_cxc_recibo1.documento;
    else
       r_cxc_recibo1.observacion := ''RECIBO #  '' || r_cxc_recibo1.documento || ''  '' || trim(r_cxc_recibo1.observacion);
    end if;
    
    select into ls_cuenta trim(valor) from invparal
    where almacen = r_cxc_recibo1.almacen
    and parametro = ''cta_cxc''
    and aplicacion =  ''INV'';
    if not found then
       ls_cuenta := r_clientes.cuenta;
    end if;
    
    
    select into r_cglcuentas * from cglcuentas
    where trim(cuenta) = trim(ls_cuenta) and auxiliar_1 = ''S'';
    if not found then
        ls_aux1 := null;
    else
        ls_aux1 := r_cxc_recibo1.cliente;
        select into r_cglauxiliares * from cglauxiliares
        where trim(auxiliar) = trim(ls_aux1);
        if not found then
            insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
            values (r_clientes.cliente, r_clientes.nomb_cliente, ''1'', ''A'');
        end if;
        
    end if;        
    

    li_consecutivo := f_cglposteo(r_almacen.compania, ''CXC'', r_cxc_recibo1.fecha, 
                            ls_cuenta, ls_aux1, null,
                            r_cxcmotivos.tipo_comp, r_cxc_recibo1.observacion, 
                            (ldc_sum_cxc_recibo1*r_cxcmotivos.signo));
    if li_consecutivo > 0 then
        insert into rela_cxc_recibo1_cglposteo (almacen, cxc_consecutivo, consecutivo)
        values (r_cxc_recibo1.almacen, r_cxc_recibo1.consecutivo, li_consecutivo);
    end if;
    for r_work in select cxc_recibo3.cuenta, cxc_recibo3.auxiliar, cxc_recibo3.monto
                    from cxc_recibo3
                    where cxc_recibo3.almacen = r_cxc_recibo1.almacen
                    and cxc_recibo3.consecutivo = r_cxc_recibo1.consecutivo
                    order by 1
    loop
        li_consecutivo := f_cglposteo(r_almacen.compania, ''CXC'', r_cxc_recibo1.fecha, 
                                r_work.cuenta, r_work.auxiliar, null,
                                r_cxcmotivos.tipo_comp, r_cxc_recibo1.observacion, 
                                -(r_work.monto*r_cxcmotivos.signo));
        if li_consecutivo > 0 then
            insert into rela_cxc_recibo1_cglposteo (almacen, cxc_consecutivo, consecutivo)
            values (r_cxc_recibo1.almacen, r_cxc_recibo1.consecutivo, li_consecutivo);
        end if;
    end loop;
    return 1;
end;
' language plpgsql;


create function f_rela_cxc_recibo1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;


create function f_recibo_cxcdocm(char(2), int4) returns integer as '
declare
    as_almacen alias for $1;
    ai_consecutivo alias for $2;
    r_cxc_recibo1 record;
    r_cxc_recibo2 record;
    r_cxcdocm record;
    r_cxcdocm2 record;
    li_work int4;
    ldc_sum_cxc_recibo2 decimal(10,2);
begin
    select into r_cxc_recibo1 cxc_recibo1.* from cxc_recibo1
    where almacen = as_almacen
    and consecutivo = ai_consecutivo;
    if not found then
        return 0;
    end if;
    
    if r_cxc_recibo1.status = ''A'' then
        return 0;
    end if;
        
    select into ldc_sum_cxc_recibo2 sum(monto_aplicar) from cxc_recibo2
    where almacen = as_almacen
    and consecutivo = ai_consecutivo;
    if ldc_sum_cxc_recibo2 is null or ldc_sum_cxc_recibo2 = 0 then
        select into r_cxcdocm * from cxcdocm
        where almacen = r_cxc_recibo1.almacen
        and cliente = r_cxc_recibo1.cliente
        and motivo_cxc = r_cxc_recibo1.motivo_cxc
        and documento = r_cxc_recibo1.documento
        and docmto_aplicar = r_cxc_recibo1.documento;
        if not found then
            insert into cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen, 
                docmto_ref, motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, 
                fecha_vmto, monto, fecha_posteo, status, usuario, fecha_captura, obs_docmto,
                fecha_cancelo, referencia) 
            values (r_cxc_recibo1.documento, r_cxc_recibo1.documento, 
                r_cxc_recibo1.cliente, r_cxc_recibo1.motivo_cxc, r_cxc_recibo1.almacen, 
                r_cxc_recibo1.documento, 
                r_cxc_recibo1.motivo_cxc, ''CXC'', ''N'', r_cxc_recibo1.fecha, 
                r_cxc_recibo1.fecha, (r_cxc_recibo1.efectivo + r_cxc_recibo1.cheque + r_cxc_recibo1.otro), 
                r_cxc_recibo1.fecha, 
                ''R'', current_user, current_timestamp, trim(r_cxc_recibo1.observacion), current_date, trim(r_cxc_recibo1.referencia));
        end if;
    end if;

    select into li_work count(*) from cxc_recibo2
    where almacen = as_almacen
    and consecutivo = ai_consecutivo
    and monto_aplicar <> 0;
    if li_work is null or li_work = 0 then
    
       select into r_cxcdocm * from cxcdocm
       where almacen = r_cxc_recibo1.almacen
       and cliente = r_cxc_recibo1.cliente
       and motivo_cxc = r_cxc_recibo1.motivo_cxc
       and documento = r_cxc_recibo1.documento
       and docmto_aplicar = r_cxc_recibo1.documento;
       if not found then
          insert into cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen, 
            docmto_ref, motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, 
            fecha_vmto, monto, fecha_posteo, status, usuario, fecha_captura, obs_docmto,
            fecha_cancelo, referencia) 
          values (r_cxc_recibo1.documento, r_cxc_recibo1.documento, 
            r_cxc_recibo1.cliente, r_cxc_recibo1.motivo_cxc, r_cxc_recibo1.almacen, 
            r_cxc_recibo1.documento, 
            r_cxc_recibo1.motivo_cxc, ''CXC'', ''N'', r_cxc_recibo1.fecha, 
            r_cxc_recibo1.fecha, (r_cxc_recibo1.efectivo + r_cxc_recibo1.cheque + r_cxc_recibo1.otro), 
            r_cxc_recibo1.fecha, 
            ''R'', current_user, current_timestamp, trim(r_cxc_recibo1.observacion), current_date, trim(r_cxc_recibo1.referencia));
        else
            update  cxcdocm
            set     fecha_docmto = r_cxc_recibo1.fecha,
                    fecha_vmto = r_cxc_recibo1.fecha,
                    monto = (r_cxc_recibo1.efectivo + r_cxc_recibo1.cheque + r_cxc_recibo1.otro),
                    fecha_posteo = r_cxc_recibo1.fecha,
                    usuario = current_user,
                    fecha_captura = current_timestamp,
                    obs_docmto = trim(r_cxc_recibo1.observacion),
                    referencia = trim(r_cxc_recibo1.referencia)
            where   almacen = r_cxc_recibo1.almacen
            and     cliente = r_cxc_recibo1.cliente
            and     motivo_cxc = r_cxc_recibo1.motivo_cxc
            and     documento = trim(r_cxc_recibo1.documento)
            and     docmto_aplicar = trim(r_cxc_recibo1.documento);
        end if;
    else
        for r_cxc_recibo2 in select cxc_recibo2.* from cxc_recibo2
                            where almacen = as_almacen
                            and consecutivo = ai_consecutivo
                            and monto_aplicar <> 0
        loop
          select into r_cxcdocm * from cxcdocm
           where almacen = r_cxc_recibo2.almacen_aplicar
           and cliente = r_cxc_recibo1.cliente
           and motivo_cxc = r_cxc_recibo1.motivo_cxc
           and documento = r_cxc_recibo1.documento
           and docmto_aplicar = r_cxc_recibo2.documento_aplicar;
           if not found then
              select into r_cxcdocm2 * from cxcdocm
               where almacen = r_cxc_recibo2.almacen_aplicar
               and cliente = r_cxc_recibo1.cliente
               and motivo_cxc = r_cxc_recibo2.motivo_aplicar
               and documento = r_cxc_recibo2.documento_aplicar
               and docmto_aplicar = r_cxc_recibo2.documento_aplicar;
              if found then
                 insert into cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen, 
                    docmto_ref, motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, 
                    fecha_vmto, monto, fecha_posteo, status, usuario, fecha_captura, obs_docmto,
                    fecha_cancelo, referencia) 
                 values (r_cxc_recibo1.documento, r_cxc_recibo2.documento_aplicar, 
                    r_cxc_recibo1.cliente, r_cxc_recibo1.motivo_cxc, r_cxc_recibo2.almacen_aplicar, 
                    r_cxc_recibo2.documento_aplicar, r_cxc_recibo2.motivo_aplicar, ''CXC'', ''N'', 
                    r_cxc_recibo1.fecha, r_cxc_recibo1.fecha, 
                    r_cxc_recibo2.monto_aplicar, r_cxc_recibo1.fecha, ''R'', 
                    current_user, current_timestamp, trim(r_cxc_recibo1.observacion), 
                    current_date, trim(r_cxc_recibo1.referencia));
              else
                return 0;
              end if;
            else
                update  cxcdocm
                set     fecha_docmto = r_cxc_recibo1.fecha,
                        fecha_vmto = r_cxc_recibo1.fecha,
                        monto = r_cxc_recibo2.monto_aplicar,
                        fecha_posteo = r_cxc_recibo1.fecha,
                        usuario = current_user,
                        fecha_captura = current_timestamp,
                        obs_docmto = trim(r_cxc_recibo1.observacion),
                        referencia = trim(r_cxc_recibo1.referencia)
               where almacen = r_cxc_recibo2.almacen_aplicar
               and cliente = r_cxc_recibo1.cliente
               and motivo_cxc = r_cxc_recibo1.motivo_cxc
               and documento = r_cxc_recibo1.documento
               and docmto_aplicar = r_cxc_recibo2.documento_aplicar;
            end if; 
        end loop; 
    end if;
  
    return 1;
end;
' language plpgsql;    


create trigger t_cxc_recibo1_delete after delete on cxc_recibo1
for each row execute procedure f_cxc_recibo1_delete();

create trigger t_cxc_recibo1_update after update on cxc_recibo1
for each row execute procedure f_cxc_recibo1_update();

create trigger t_rela_cxc_recibo1_cglposteo_delete after delete on rela_cxc_recibo1_cglposteo
for each row execute procedure f_rela_cxc_recibo1_cglposteo_delete();

create trigger t_cxc_recibo2_insert after insert on cxc_recibo2
for each row execute procedure f_cxc_recibo2_insert();

create trigger t_cxc_recibo2_update after update on cxc_recibo2
for each row execute procedure f_cxc_recibo2_update();

create trigger t_cxc_recibo2_delete after delete on cxc_recibo2
for each row execute procedure f_cxc_recibo2_delete();

drop function f_cxpfact1_delete() cascade;
drop function f_cxpfact1_update() cascade;
drop function f_cxpfact2_delete() cascade;
drop function f_cxpfact2_update() cascade;
drop function f_rela_cxpfact1_cglposteo_delete() cascade;
drop function f_rela_cxpfact1_cglposteo_update() cascade;

drop function f_monto_factura_cxp(char(2), char(6), char(25));
drop function f_saldo_docmto_cxp(char(2), char(6), char(10),  char(3), date);
drop function f_cxpfact1_cxpdocm(char(2), char(6), char(25));
drop function f_cxpfact1_cglposteo(char(2), char(6), char(25));


create function f_cxpfact1_cxpdocm(char(2), char(6), char(25)) returns integer as '
declare
    as_compania alias for $1;
    as_proveedor alias for $2;
    as_fact_proveedor alias for $3;
    r_cxpfact1 record;
    r_cxpdocm record;
    r_work record;
    ldc_monto decimal(12,2);
begin
    select into r_cxpfact1 * from cxpfact1
    where compania = as_compania
    and proveedor = as_proveedor
    and trim(fact_proveedor) = trim(as_fact_proveedor);
    if not found then
       return 0;
    end if;
    
    
    select into r_work cglcuentas.* from cglcuentas, proveedores
    where cglcuentas.cuenta = proveedores.cuenta
    and proveedores.proveedor = r_cxpfact1.proveedor
    and cglcuentas.naturaleza = 1;
    if found then
       return 0;
    end if;
    
    select into ldc_monto sum(cxpfact2.monto*rubros_fact_cxp.signo_rubro_fact_cxp)
    from cxpfact2, rubros_fact_cxp
    where cxpfact2.rubro_fact_cxp = rubros_fact_cxp.rubro_fact_cxp
    and cxpfact2.compania = as_compania
    and cxpfact2.proveedor = as_proveedor
    and cxpfact2.fact_proveedor = as_fact_proveedor;
    if ldc_monto is null or ldc_monto = 0 then
       return 0;
    end if;

    
    select into r_cxpdocm * from cxpdocm
    where compania = r_cxpfact1.compania
    and proveedor = r_cxpfact1.proveedor
    and documento = r_cxpfact1.fact_proveedor
    and docmto_aplicar = r_cxpfact1.fact_proveedor
    and motivo_cxp = r_cxpfact1.motivo_cxp;
    if not found then
        insert into cxpdocm (compania, proveedor, documento, docmto_aplicar, motivo_cxp,
            docmto_aplicar_ref, motivo_cxp_ref, aplicacion_origen,
            uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo, status,
            usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
        values (r_cxpfact1.compania, r_cxpfact1.proveedor, r_cxpfact1.fact_proveedor,
            r_cxpfact1.fact_proveedor, trim(r_cxpfact1.motivo_cxp), r_cxpfact1.fact_proveedor,
            trim(r_cxpfact1.motivo_cxp), r_cxpfact1.aplicacion_origen, ''N'', r_cxpfact1.fecha_posteo_fact_cxp,
            r_cxpfact1.vence_fact_cxp, ldc_monto, r_cxpfact1.fecha_posteo_fact_cxp,
            ''R'', current_user, current_timestamp, r_cxpfact1.obs_fact_cxp,
            current_date, null);
    else
        update cxpdocm
        set fecha_docmto = r_cxpfact1.fecha_posteo_fact_cxp,
            monto = ldc_monto,
            fecha_posteo = r_cxpfact1.fecha_posteo_fact_cxp
        where compania = r_cxpfact1.compania
        and proveedor = r_cxpfact1.proveedor
        and documento = r_cxpfact1.fact_proveedor
        and docmto_aplicar = r_cxpfact1.fact_proveedor
        and motivo_cxp = r_cxpfact1.motivo_cxp;
    end if;            
  
return 1;
    
end;
' language plpgsql;    


create function f_cxpfact1_update() returns trigger as '
declare 
    i integer;
begin
    
    delete from rela_cxpfact1_cglposteo
    where compania = old.compania
    and proveedor = old.proveedor
    and fact_proveedor = old.fact_proveedor;

    if old.proveedor <> new.proveedor
        or old.fact_proveedor <> new.fact_proveedor
        or old.motivo_cxp <> new.motivo_cxp then    
        delete from cxpdocm
        where proveedor = old.proveedor
        and compania = old.compania
        and documento = old.fact_proveedor
        and docmto_aplicar = old.fact_proveedor
        and motivo_cxp = old.motivo_cxp;
    end if;        
    

    i := f_cxpfact1_cxpdocm(new.compania, new.proveedor, new.fact_proveedor);
    
    return new;
end;
' language plpgsql;


create function f_cxpfact1_delete() returns trigger as '
begin
    delete from rela_cxpfact1_cglposteo
    where compania = old.compania
    and proveedor = old.proveedor
    and fact_proveedor = old.fact_proveedor;
    
    delete from cxpdocm
    where proveedor = old.proveedor
    and compania = old.compania
    and documento = old.fact_proveedor
    and docmto_aplicar = old.fact_proveedor
    and motivo_cxp = old.motivo_cxp;
    
    return old;
end;
' language plpgsql;

create function f_cxpfact2_delete() returns trigger as '
declare 
    r_cxpfact1 record;
    i integer;
begin
    if old.monto = 0 then
        return old;
    end if;
    
    select into r_cxpfact1 * from cxpfact1
    where compania = old.compania
    and proveedor = old.proveedor
    and fact_proveedor = old.fact_proveedor;
    if not found then
        return old;
    end if;
    
    delete from rela_cxpfact1_cglposteo
    where compania = r_cxpfact1.compania
    and proveedor = r_cxpfact1.proveedor
    and fact_proveedor = r_cxpfact1.fact_proveedor;
    

    delete from cxpdocm
    where compania = r_cxpfact1.compania
    and proveedor = r_cxpfact1.proveedor
    and documento = r_cxpfact1.fact_proveedor
    and docmto_aplicar = r_cxpfact1.fact_proveedor
    and motivo_cxp = r_cxpfact1.motivo_cxp;
    
    
    return old;
end;
' language plpgsql;


create function f_cxpfact2_update() returns trigger as '
declare 
    r_cxpfact1 record;
    i integer;
begin
    if old.monto = 0 and new.monto = 0 then
        return new;
    end if;
    
    select into r_cxpfact1 * from cxpfact1
    where compania = old.compania
    and proveedor = old.proveedor
    and fact_proveedor = old.fact_proveedor;
    if not found then
        return new;
    end if;
    
    delete from rela_cxpfact1_cglposteo
    where compania = r_cxpfact1.compania
    and proveedor = r_cxpfact1.proveedor
    and fact_proveedor = r_cxpfact1.fact_proveedor;
    

    delete from cxpdocm
    where compania = r_cxpfact1.compania
    and proveedor = r_cxpfact1.proveedor
    and documento = r_cxpfact1.fact_proveedor
    and docmto_aplicar = r_cxpfact1.fact_proveedor
    and motivo_cxp = r_cxpfact1.motivo_cxp;
    
    i := f_cxpfact1_cxpdocm(new.compania, new.proveedor, new.fact_proveedor);
    
    return new;
end;
' language plpgsql;


create function f_monto_factura_cxp(char(2), char(6), char(25)) returns decimal(12,2) as '
declare
    ldc_retorno decimal(12,2);
begin
    select into ldc_retorno -sum(cxpfact2.monto*rubros_fact_cxp.signo_rubro_fact_cxp*cxpmotivos.signo)
    from cxpfact2, rubros_fact_cxp, cxpmotivos, cxpfact1
    where cxpfact2.rubro_fact_cxp = rubros_fact_cxp.rubro_fact_cxp
    and cxpfact1.compania = cxpfact2.compania
    and cxpfact1.proveedor = cxpfact2.proveedor
    and cxpfact1.fact_proveedor = cxpfact2.fact_proveedor
    and cxpfact1.motivo_cxp = cxpmotivos.motivo_cxp
    and cxpfact1.compania = $1
    and cxpfact1.proveedor = $2
    and cxpfact1.fact_proveedor = $3;
    if ldc_retorno is null then
       ldc_retorno := 0;
    end if;
    
    return ldc_retorno;
end;
' language plpgsql;

create function f_cxpfact1_cglposteo(char(2), char(6), char(25)) returns integer as '
declare
    as_compania alias for $1;
    as_proveedor alias for $2;
    as_fact_proveedor alias for $3;
    r_cxpfact1 record;
    r_cxpfact2 record;
    r_rubros_fact_cxp record;
    r_proveedores record;
    r_cxpmotivos record;
    r_cglcuentas record;
    r_cglauxiliares record;
    r_work record;
    ldc_monto_factura_cxp decimal(10,2);
    li_consecutivo int4;
    ls_cuenta char(24);
    ls_aux1 char(10);
begin
    select into r_cxpfact1 * from cxpfact1
    where compania = as_compania
    and proveedor = as_proveedor
    and fact_proveedor = as_fact_proveedor;
    if not found then
       return 0;
    end if;
    
    
    delete from rela_cxpfact1_cglposteo
    where compania = as_compania
    and proveedor = as_proveedor
    and fact_proveedor = as_fact_proveedor;
    
    select into r_proveedores * from proveedores
    where proveedor = r_cxpfact1.proveedor;
    
    select into r_cxpmotivos * from cxpmotivos
    where motivo_cxp = r_cxpfact1.motivo_cxp;
    
    
    ldc_monto_factura_cxp := f_monto_factura_cxp(r_cxpfact1.compania, r_cxpfact1.proveedor,
                                r_cxpfact1.fact_proveedor);

                                
    if r_cxpfact1.obs_fact_cxp is null then
       r_cxpfact1.obs_fact_cxp := ''FACTURA #  '' || r_cxpfact1.fact_proveedor;
    else
       r_cxpfact1.obs_fact_cxp := ''FACTURA #  '' || r_cxpfact1.fact_proveedor || ''  '' || trim(r_cxpfact1.obs_fact_cxp);
    end if;
    
    ls_cuenta   :=  r_proveedores.cuenta;
    ls_aux1     :=  null;
    select into r_cglcuentas * from cglcuentas
    where trim(cuenta) = trim(ls_cuenta)
    and auxiliar_1 = ''S'';
    if found then
        ls_aux1 :=   r_proveedores.proveedor;
        select into r_cglauxiliares * from cglauxiliares
        where trim(auxiliar) = trim(ls_aux1);
        if not found then
            insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
            values (ls_aux1, trim(r_proveedores.nomb_proveedor), ''1'', ''A'');
        end if;
    end if;

    li_consecutivo := f_cglposteo(r_cxpfact1.compania, r_cxpfact1.aplicacion_origen, r_cxpfact1.fecha_posteo_fact_cxp, 
                            ls_cuenta, ls_aux1, null,
                            r_cxpmotivos.tipo_comp, r_cxpfact1.obs_fact_cxp, 
                            (ldc_monto_factura_cxp*r_cxpmotivos.signo));
    if li_consecutivo > 0 then
        insert into rela_cxpfact1_cglposteo (compania, proveedor, fact_proveedor, consecutivo)
        values (r_cxpfact1.compania, r_cxpfact1.proveedor, r_cxpfact1.fact_proveedor, li_consecutivo);
    end if;
    
    
    for r_cxpfact2 in select * from cxpfact2
                    where cxpfact2.compania = r_cxpfact1.compania
                    and cxpfact2.proveedor = r_cxpfact1.proveedor
                    and cxpfact2.fact_proveedor = r_cxpfact1.fact_proveedor
                    and cxpfact2.monto <> 0
                    order by 1
    loop
        select into r_rubros_fact_cxp * from rubros_fact_cxp
        where rubro_fact_cxp = r_cxpfact2.rubro_fact_cxp;
        
        if r_cxpfact2.cuenta is null then
           for r_work in select articulos_por_almacen.cuenta, sum(eys2.costo) as monto
                            from eys4, eys2, articulos_por_almacen
                            where eys4.articulo = eys2.articulo
                            and eys4.almacen = eys2.almacen
                            and eys4.no_transaccion = eys2.no_transaccion
                            and eys4.inv_linea = eys2.linea
                            and eys2.almacen = articulos_por_almacen.almacen
                            and eys2.articulo = articulos_por_almacen.articulo
                            and eys4.compania = r_cxpfact2.compania
                            and eys4.proveedor = r_cxpfact2.proveedor
                            and eys4.fact_proveedor = r_cxpfact2.fact_proveedor
                            and eys4.cxp_linea = r_cxpfact2.linea
                            and eys4.rubro_fact_cxp = r_cxpfact2.rubro_fact_cxp
                            group by 1
                            order by 1
           loop
            li_consecutivo := f_cglposteo(r_cxpfact1.compania, r_cxpfact1.aplicacion_origen, r_cxpfact1.fecha_posteo_fact_cxp, 
                                    r_work.cuenta, null, null,
                                    r_cxpmotivos.tipo_comp, r_cxpfact1.obs_fact_cxp, 
                                    (r_work.monto*r_rubros_fact_cxp.signo_rubro_fact_cxp));
            if li_consecutivo > 0 then
                insert into rela_cxpfact1_cglposteo (compania, proveedor, fact_proveedor, consecutivo)
                values (r_cxpfact1.compania, r_cxpfact1.proveedor, r_cxpfact1.fact_proveedor, li_consecutivo);
            end if; 
           end loop;
        else
            li_consecutivo := f_cglposteo(r_cxpfact1.compania, r_cxpfact1.aplicacion_origen, r_cxpfact1.fecha_posteo_fact_cxp, 
                                    r_cxpfact2.cuenta, r_cxpfact2.auxiliar1, r_cxpfact2.auxiliar2,
                                    r_cxpmotivos.tipo_comp, r_cxpfact1.obs_fact_cxp, 
                                    (r_cxpfact2.monto*r_rubros_fact_cxp.signo_rubro_fact_cxp));
            if li_consecutivo > 0 then
                insert into rela_cxpfact1_cglposteo (compania, proveedor, fact_proveedor, consecutivo)
                values (r_cxpfact1.compania, r_cxpfact1.proveedor, r_cxpfact1.fact_proveedor, li_consecutivo);
            end if; 
        end if;
        
    end loop;
     
   
    return 1;
end;
' language plpgsql;


create function f_rela_cxpfact1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;

create function f_rela_cxpfact1_cglposteo_update() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return new;
end;
' language plpgsql;


create function f_saldo_docmto_cxp(char(2), char(6), char(10),  char(3), date) returns decimal(10,2)
as 
'select sum(a.monto*b.signo*-1) as saldo from cxpdocm a, cxpmotivos b
where		a.motivo_cxp			=	b.motivo_cxp
and		a.compania				=	$1
and		a.proveedor				=	$2
and		a.motivo_cxp_ref		=	$4
and		a.docmto_aplicar_ref	=	$3
and		a.docmto_aplicar		=	$3
and		a.fecha_docmto			<= $5;' language 'sql';



create trigger t_cxpfact1_update after update on cxpfact1
for each row execute procedure f_cxpfact1_update();

create trigger t_cxpfact1_delete after delete on cxpfact1
for each row execute procedure f_cxpfact1_delete();

create trigger t_cxpfact2_delete after delete on cxpfact2
for each row execute procedure f_cxpfact2_delete();

create trigger t_cxpfact2_update after update on cxpfact2
for each row execute procedure f_cxpfact2_update();

create trigger t_rela_cxpfact1_cglposteo_delete after delete on rela_cxpfact1_cglposteo
for each row execute procedure f_rela_cxpfact1_cglposteo_delete();

create trigger t_rela_cxpfact1_cglposteo_update after update on rela_cxpfact1_cglposteo
for each row execute procedure f_rela_cxpfact1_cglposteo_update();

drop function f_cxpajuste1_delete() cascade;
drop function f_cxpajuste1_update() cascade;

drop function f_cxpajuste2_delete() cascade;
drop function f_cxpajuste2_update() cascade;

drop function f_cxpajuste3_delete() cascade;
drop function f_cxpajuste3_update() cascade;

drop function f_cxpajuste1_cxpdocm(char(2), int4) cascade;
drop function f_cxpajuste1_cglposteo(char(2), int4) cascade;
drop function f_rela_cxpajuste1_cglposteo_delete() cascade;


create function f_cxpajuste1_delete() returns trigger as '
begin
    delete from cxpdocm
    where proveedor = old.proveedor
    and compania = old.compania
    and documento = old.docm_ajuste_cxp
    and motivo_cxp = old.motivo_cxp;
    
    return old;
end;
' language plpgsql;


create function f_cxpajuste1_update() returns trigger as '
declare
    i integer;
begin
    if old.proveedor <> new.proveedor
        or old.docm_ajuste_cxp <> new.docm_ajuste_cxp
        or old.motivo_cxp <> new.motivo_cxp then
        delete from cxpdocm
        where trim(proveedor) = trim(old.proveedor)
        and trim(compania) = trim(old.compania)
        and trim(documento) = trim(old.docm_ajuste_cxp)
        and trim(motivo_cxp) = trim(old.motivo_cxp);
    end if;        
    
    
    i := f_cxpajuste1_cxpdocm(new.compania, new.sec_ajuste_cxp);
    
    return new;
end;
' language plpgsql;

create function f_cxpajuste2_delete() returns trigger as '
declare
    i integer;
    r_cxpajuste1 record;
begin
    if old.monto = 0 then
        return old;
    end if;
    
    select into r_cxpajuste1 * from cxpajuste1
    where compania = old.compania
    and sec_ajuste_cxp = old.sec_ajuste_cxp;
    if not found then
        return old;
    end if;
    
    
    delete from cxpdocm
    where compania = r_cxpajuste1.compania
    and proveedor = r_cxpajuste1.proveedor
    and documento = r_cxpajuste1.docm_ajuste_cxp
    and docmto_aplicar = old.aplicar_a
    and motivo_cxp = r_cxpajuste1.motivo_cxp;
    
    
    return old;
end;
' language plpgsql;


create function f_cxpajuste2_update() returns trigger as '
declare
    i integer;
    r_cxpajuste1 record;
begin
    if old.monto = 0 and new.monto = 0 then
        return old;
    end if;
    
    select into r_cxpajuste1 * from cxpajuste1
    where compania = old.compania
    and sec_ajuste_cxp = old.sec_ajuste_cxp;
    if not found then
        return old;
    end if;
    
    delete from cxpdocm
    where compania = r_cxpajuste1.compania
    and proveedor = r_cxpajuste1.proveedor
    and documento = r_cxpajuste1.docm_ajuste_cxp
    and docmto_aplicar = old.aplicar_a
    and motivo_cxp = r_cxpajuste1.motivo_cxp;
    
    return new;
end;
' language plpgsql;


create function f_cxpajuste3_update() returns trigger as '
declare
    i integer;
    r_cxpajuste1 record;
begin
    if old.monto = 0 and new.monto = 0 then
        return old;
    end if;
    
    select into r_cxpajuste1 * from cxpajuste1
    where compania = old.compania
    and sec_ajuste_cxp = old.sec_ajuste_cxp;
    if not found then
        return old;
    end if;
    
    delete from cxpdocm
    where compania = r_cxpajuste1.compania
    and proveedor = r_cxpajuste1.proveedor
    and documento = r_cxpajuste1.docm_ajuste_cxp
    and docmto_aplicar = r_cxpajuste1.docm_ajuste_cxp
    and motivo_cxp = r_cxpajuste1.motivo_cxp;
    
    return new;
end;
' language plpgsql;


create function f_cxpajuste3_delete() returns trigger as '
declare
    i integer;
    r_cxpajuste1 record;
begin
    if old.monto = 0 then
        return old;
    end if;
    
    select into r_cxpajuste1 * from cxpajuste1
    where compania = old.compania
    and sec_ajuste_cxp = old.sec_ajuste_cxp;
    if not found then
        return old;
    end if;
    
    delete from cxpdocm
    where compania = r_cxpajuste1.compania
    and proveedor = r_cxpajuste1.proveedor
    and documento = r_cxpajuste1.docm_ajuste_cxp
    and docmto_aplicar = r_cxpajuste1.docm_ajuste_cxp
    and motivo_cxp = r_cxpajuste1.motivo_cxp;
    
    return old;
end;
' language plpgsql;



create function f_rela_cxpajuste1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;


create function f_cxpajuste1_cglposteo(char(2), int4) returns integer as '
declare
    as_compania alias for $1;
    ai_sec_ajuste_cxp alias for $2;
    li_consecutivo int4;
    r_cxpajuste1 record;
    r_cxpajuste2 record;
    r_work record;
    r_proveedores record;
    r_cxpmotivos record;
    r_cglcuentas record;
    r_cglauxiliares record;
    ldc_sum_cxpajuste2 decimal(10,2);
    ldc_sum_cxpajuste3 decimal(10,2);
    ls_aux1 char(10);
begin
    select into r_cxpajuste1 * from cxpajuste1
    where compania = as_compania
    and sec_ajuste_cxp = ai_sec_ajuste_cxp;
    if not found then
       return 0;
    end if;
    
    
    select into ldc_sum_cxpajuste2 sum(monto) from cxpajuste2
    where compania = as_compania
    and sec_ajuste_cxp = ai_sec_ajuste_cxp;
    if ldc_sum_cxpajuste2 is null then
       ldc_sum_cxpajuste2 := 0;
    end if;
    
    select into ldc_sum_cxpajuste3 sum(monto) from cxpajuste3
    where compania = as_compania
    and sec_ajuste_cxp = ai_sec_ajuste_cxp;
    if ldc_sum_cxpajuste3 is null then
       ldc_sum_cxpajuste3 := 0;
    end if;
    
    if ldc_sum_cxpajuste2 <> 0 and ldc_sum_cxpajuste2 <> ldc_sum_cxpajuste3 then
       raise exception ''Transaccion % esta desbalanceada...Verifique'',r_cxpajuste1.sec_ajuste_cxp;
    end if;
    
    delete from rela_cxpajuste1_cglposteo
    where compania = r_cxpajuste1.compania
    and sec_ajuste_cxp = r_cxpajuste1.sec_ajuste_cxp;
    
    select into r_cxpmotivos * from cxpmotivos
    where motivo_cxp = r_cxpajuste1.motivo_cxp;
    
    select into r_proveedores * from proveedores
    where proveedor = r_cxpajuste1.proveedor;
    
    if r_cxpajuste1.obs_ajuste_cxp is null then
       r_cxpajuste1.obs_ajuste_cxp := ''TRANSACCION #  '' || r_cxpajuste1.sec_ajuste_cxp;
    else
       r_cxpajuste1.obs_ajuste_cxp := ''TRANSACCION #  '' || r_cxpajuste1.sec_ajuste_cxp || ''  '' || trim(r_cxpajuste1.obs_ajuste_cxp);
    end if;
    
    ls_aux1 := null;
    select into r_cglcuentas * from cglcuentas
    where cuenta = r_proveedores.cuenta
    and auxiliar_1 = ''S'';
    if found then
        ls_aux1 :=   r_proveedores.proveedor;
        select into r_cglauxiliares * from cglauxiliares
        where trim(auxiliar) = trim(ls_aux1);
        if not found then
            insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
            values (ls_aux1, trim(r_proveedores.nomb_proveedor), ''1'', ''A'');
        end if;
    end if;
    

    li_consecutivo := f_cglposteo(r_cxpajuste1.compania, ''CXP'', r_cxpajuste1.fecha_posteo_ajuste_cxp, 
                            r_proveedores.cuenta, ls_aux1, null,
                            r_cxpmotivos.tipo_comp, r_cxpajuste1.obs_ajuste_cxp, 
                            (ldc_sum_cxpajuste3*r_cxpmotivos.signo));
    if li_consecutivo > 0 then
        insert into rela_cxpajuste1_cglposteo (compania, sec_ajuste_cxp, consecutivo)
        values (r_cxpajuste1.compania, r_cxpajuste1.sec_ajuste_cxp, li_consecutivo);
    end if;
    
    for r_work in select cxpajuste3.cuenta, cxpajuste3.auxiliar1, cxpajuste3.auxiliar2, cxpajuste3.monto
                    from cxpajuste3
                    where cxpajuste3.compania = r_cxpajuste1.compania
                    and cxpajuste3.sec_ajuste_cxp = r_cxpajuste1.sec_ajuste_cxp
                    order by 1
    loop
        li_consecutivo := f_cglposteo(r_cxpajuste1.compania, ''CXP'', r_cxpajuste1.fecha_posteo_ajuste_cxp, 
                                r_work.cuenta, r_work.auxiliar1, r_work.auxiliar2,
                                r_cxpmotivos.tipo_comp, r_cxpajuste1.obs_ajuste_cxp, 
                                -(r_work.monto*r_cxpmotivos.signo));
        if li_consecutivo > 0 then
            insert into rela_cxpajuste1_cglposteo (compania, sec_ajuste_cxp, consecutivo)
            values (r_cxpajuste1.compania, r_cxpajuste1.sec_ajuste_cxp, li_consecutivo);
        end if;
    end loop;
    return 1;
end;
' language plpgsql;




create function f_cxpajuste1_cxpdocm(char(2), int4) returns integer as '
declare
    as_compania alias for $1;
    ai_sec_ajuste_cxp alias for $2;
    r_cxpajuste1 record;
    r_cxpajuste3 record;
    r_cxpajuste2 record;
    r_cxpdocm record;
    r_cxpdocm2 record;
    ldc_monto decimal(10,2);
    li_work integer;
begin
    
    select into r_cxpajuste1 * from cxpajuste1
    where compania = as_compania
    and sec_ajuste_cxp = ai_sec_ajuste_cxp;
    
    
    select into li_work count(*) from cxpajuste2
    where compania = as_compania
    and sec_ajuste_cxp = ai_sec_ajuste_cxp
    and monto <> 0;
    
   
    if li_work is null or li_work = 0 then
       select into ldc_monto sum(monto) from cxpajuste3
       where compania = as_compania
       and   sec_ajuste_cxp = ai_sec_ajuste_cxp;
       
       select into r_cxpdocm * from cxpdocm
       where compania = r_cxpajuste1.compania
       and proveedor = r_cxpajuste1.proveedor
       and documento = r_cxpajuste1.docm_ajuste_cxp
       and docmto_aplicar = r_cxpajuste1.docm_ajuste_cxp
       and motivo_cxp = r_cxpajuste1.motivo_cxp;
       if not found then
           insert into cxpdocm (proveedor, compania, documento, docmto_aplicar,
            motivo_cxp, docmto_aplicar_ref, motivo_cxp_ref, aplicacion_origen,
            uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo, status,
            usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
           values (r_cxpajuste1.proveedor, r_cxpajuste1.compania, trim(r_cxpajuste1.docm_ajuste_cxp),
            trim(r_cxpajuste1.docm_ajuste_cxp), r_cxpajuste1.motivo_cxp, trim(r_cxpajuste1.docm_ajuste_cxp),
            r_cxpajuste1.motivo_cxp, ''CXP'', ''N'', r_cxpajuste1.fecha_posteo_ajuste_cxp,
            r_cxpajuste1.fecha_posteo_ajuste_cxp, ldc_monto, r_cxpajuste1.fecha_posteo_ajuste_cxp,
            ''R'', current_user, current_timestamp, trim(r_cxpajuste1.obs_ajuste_cxp),
            current_date, trim(r_cxpajuste1.referencia));
       else
          update cxpdocm
          set    fecha_docmto         = r_cxpajuste1.fecha_posteo_ajuste_cxp,
                 fecha_vmto           = r_cxpajuste1.fecha_posteo_ajuste_cxp,
                 monto                = ldc_monto,
                 fecha_posteo         = r_cxpajuste1.fecha_posteo_ajuste_cxp,
                 usuario              = current_user,
                 fecha_captura        = current_timestamp,
                 obs_docmto           = r_cxpajuste1.obs_ajuste_cxp
          where  compania             = r_cxpajuste1.compania
          and    proveedor            = r_cxpajuste1.proveedor
          and    documento            = r_cxpajuste1.docm_ajuste_cxp
          and    docmto_aplicar       = r_cxpajuste1.docm_ajuste_cxp
          and    motivo_cxp           = r_cxpajuste1.motivo_cxp;
       end if;
    else
       for r_cxpajuste2 in select cxpajuste2.* from cxpajuste2
                            where compania = as_compania
                            and sec_ajuste_cxp = ai_sec_ajuste_cxp
                            and monto <> 0
       loop
        select into r_cxpdocm * from cxpdocm
        where  proveedor            = r_cxpajuste1.proveedor
        and    compania             = r_cxpajuste1.compania
        and    documento            = r_cxpajuste1.docm_ajuste_cxp
        and    docmto_aplicar       = r_cxpajuste2.aplicar_a
        and    motivo_cxp           = r_cxpajuste1.motivo_cxp;
        if not found then
        
           select into r_cxpdocm2 * from cxpdocm
           where  proveedor            = r_cxpajuste1.proveedor
           and    compania             = r_cxpajuste1.compania
           and    documento            = r_cxpajuste2.aplicar_a
           and    docmto_aplicar       = r_cxpajuste2.aplicar_a
           and    motivo_cxp           = r_cxpajuste2.motivo_cxp;
           if found then
              insert into cxpdocm (proveedor, compania, documento, docmto_aplicar,
                motivo_cxp, docmto_aplicar_ref, motivo_cxp_ref, aplicacion_origen,
                uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo, status,
                usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
              values (r_cxpajuste1.proveedor, r_cxpajuste1.compania, trim(r_cxpajuste1.docm_ajuste_cxp),
                trim(r_cxpajuste2.aplicar_a), r_cxpajuste1.motivo_cxp, trim(r_cxpajuste2.aplicar_a),
                r_cxpajuste2.motivo_cxp, ''CXP'', ''N'', r_cxpajuste1.fecha_posteo_ajuste_cxp,
                r_cxpajuste1.fecha_posteo_ajuste_cxp, r_cxpajuste2.monto, r_cxpajuste1.fecha_posteo_ajuste_cxp,
                ''R'', current_user, current_timestamp, trim(r_cxpajuste1.obs_ajuste_cxp),
                current_date, trim(r_cxpajuste1.referencia));
           else
              return 0;
           end if;
           
        else
           update cxpdocm
           set    fecha_docmto         = r_cxpajuste1.fecha_posteo_ajuste_cxp,
                  fecha_vmto           = r_cxpajuste1.fecha_posteo_ajuste_cxp,
                  monto                = r_cxpajuste2.monto,
                  fecha_posteo         = r_cxpajuste1.fecha_posteo_ajuste_cxp,
                  usuario              = current_user,
                  fecha_captura        = current_timestamp,
                  obs_docmto           = r_cxpajuste1.obs_ajuste_cxp
           where  proveedor            = r_cxpajuste1.proveedor
           and    compania             = r_cxpajuste1.compania
           and    documento            = r_cxpajuste1.docm_ajuste_cxp
           and    docmto_aplicar       = r_cxpajuste2.aplicar_a
           and    motivo_cxp           = r_cxpajuste1.motivo_cxp;
        end if;
       end loop;
    end if;

    return 1;
end;
' language plpgsql;    

create trigger t_rela_cxpajuste1_cglposteo_delete after delete on rela_cxpajuste1_cglposteo
for each row execute procedure f_rela_cxpajuste1_cglposteo_delete();

create trigger t_cxpajuste1_delete after delete on cxpajuste1
for each row execute procedure f_cxpajuste1_delete();

create trigger t_cxpajuste1_update after update on cxpajuste1
for each row execute procedure f_cxpajuste1_update();

create trigger t_cxpajuste2_delete after delete on cxpajuste2
for each row execute procedure f_cxpajuste2_delete();

create trigger t_cxpajuste2_update after update on cxpajuste2
for each row execute procedure f_cxpajuste2_update();

create trigger t_cxpajuste3_delete after delete on cxpajuste3
for each row execute procedure f_cxpajuste3_delete();

create trigger t_cxpajuste3_update after update on cxpajuste3
for each row execute procedure f_cxpajuste3_update();

drop function f_bcocheck1_cxpdocm_delete() cascade;
drop function f_bcocheck1_cxpdocm_update() cascade;
drop function f_bcocheck1_cxpdocm(char(2), char(2), int4) cascade;

drop function f_bcocheck3_cxpdocm_insert() cascade;
drop function f_bcocheck3_cxpdocm_delete() cascade;
drop function f_bcocheck3_cxpdocm_update() cascade;

drop function f_bcotransac1_cxpdocm_delete() cascade;
drop function f_bcotransac1_cxpdocm_update() cascade;
drop function f_bcotransac1_cxpdocm(char(2), int4) cascade;
drop function f_bcotransac3_cxpdocm_delete() cascade;


create function f_bcocheck1_cxpdocm_update() returns trigger as '
declare
    r_bcomotivos record;
    r_bcoctas record;
    i integer;
begin

    select into r_bcoctas * from bcoctas
    where cod_ctabco = old.cod_ctabco;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = old.motivo_bco;
    
    delete from cxpdocm
    where proveedor = old.proveedor
    and trim(compania) = trim(r_bcoctas.compania)
    and trim(documento) = trim(to_char(old.no_cheque, ''999999999999999''))
    and trim(motivo_cxp) = trim(r_bcomotivos.motivo_cxp);

    i := f_bcocheck1_cxpdocm(new.cod_ctabco, new.motivo_bco, new.no_cheque);
    
    return new;
end;
' language plpgsql;


create function f_bcocheck1_cxpdocm_delete() returns trigger as '
declare
    r_bcomotivos record;
    r_bcoctas record;
    i integer;
begin
    select into r_bcoctas * from bcoctas
    where cod_ctabco = old.cod_ctabco;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = old.motivo_bco;
    
    delete from cxpdocm
    where trim(proveedor) = trim(old.proveedor)
    and trim(compania) = trim(r_bcoctas.compania)
    and trim(documento) = trim(to_char(old.no_cheque, ''999999999999999''))
    and trim(motivo_cxp) = trim(r_bcomotivos.motivo_cxp);
    
    return old;
end;
' language plpgsql;


create function f_bcocheck3_cxpdocm_insert() returns trigger as '
declare
    r_bcomotivos record;
    r_bcoctas record;
    r_cxpdocm record;
    r_bcocheck1 record;
    ls_documento char(25);
    i integer;
begin
    
    if new.monto = 0 then
        return new;
    end if;
    
    select into r_bcocheck1 * from bcocheck1
    where cod_ctabco = new.cod_ctabco
    and motivo_bco = new.motivo_bco
    and no_cheque = new.no_cheque;
    if not found then
        return new;
    end if;
    
    if r_bcocheck1.proveedor is null then
        return new;
    end if;
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = r_bcocheck1.cod_ctabco;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = r_bcocheck1.motivo_bco;
    
    if r_bcomotivos.aplica_cheques = ''N'' then
        return new;
    end if;
    
    ls_documento := trim(to_char(new.no_cheque, ''999999999999999''));
    
    select into r_cxpdocm * from cxpdocm
    where compania = r_bcoctas.compania
    and proveedor = r_bcocheck1.proveedor
    and documento = new.aplicar_a
    and docmto_aplicar = new.aplicar_a
    and motivo_cxp = new.motivo_cxp;
    if found then
        delete from cxpdocm
        where compania = r_bcoctas.compania
        and proveedor = r_bcocheck1.proveedor
        and documento = ls_documento
        and docmto_aplicar = new.aplicar_a
        and motivo_cxp = r_bcomotivos.motivo_cxp;
        
        insert into cxpdocm (proveedor, compania, documento, docmto_aplicar,
            motivo_cxp, docmto_aplicar_ref, motivo_cxp_ref, aplicacion_origen,
            uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo, status,
            usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
        values (r_bcocheck1.proveedor, r_bcoctas.compania, ls_documento,
            new.aplicar_a, r_bcomotivos.motivo_cxp, new.aplicar_a,
            new.motivo_cxp, ''BCO'', ''N'', r_bcocheck1.fecha_posteo,
            r_bcocheck1.fecha_posteo, new.monto, r_bcocheck1.fecha_posteo,
            ''R'', current_user, current_timestamp, trim(r_bcocheck1.en_concepto_de),
            current_date, null);
    end if;     

    return new;
end;
' language plpgsql;


create function f_bcocheck3_cxpdocm_update() returns trigger as '
declare
    r_bcomotivos record;
    r_bcoctas record;
    r_bcocheck1 record;
    r_cxpdocm record;
    ls_documento char(25);
    i integer;
begin
    if old.monto = 0 and new.monto = 0 then
        return new;
    end if;
    
    select into r_bcocheck1 * from bcocheck1
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_cheque = old.no_cheque;
    if not found then
        return new;
    end if;
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = r_bcocheck1.cod_ctabco;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = r_bcocheck1.motivo_bco;
    
    if r_bcomotivos.aplica_cheques = ''N'' then
        return new;
    end if;
    
    
    ls_documento := trim(to_char(old.no_cheque, ''999999999999999''));
    

    delete from cxpdocm
    where compania = r_bcoctas.compania
    and proveedor = r_bcocheck1.proveedor
    and motivo_cxp = r_bcomotivos.motivo_cxp
    and documento = ls_documento
    and docmto_aplicar = old.aplicar_a;
    
    if new.monto = 0 then
        return new;
    end if;    
    
    
    select into r_bcocheck1 * from bcocheck1
    where cod_ctabco = new.cod_ctabco
    and motivo_bco = new.motivo_bco
    and no_cheque = new.no_cheque;
    if not found then
        return new;
    end if;
    
    if r_bcocheck1.proveedor is null then
        return new;
    end if;
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = r_bcocheck1.cod_ctabco;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = r_bcocheck1.motivo_bco;
    
    ls_documento := trim(to_char(new.no_cheque, ''999999999999999''));
    
    select into r_cxpdocm * from cxpdocm
    where compania = r_bcoctas.compania
    and proveedor = r_bcocheck1.proveedor
    and documento = new.aplicar_a
    and docmto_aplicar = new.aplicar_a
    and motivo_cxp = new.motivo_cxp;
    if found then
        insert into cxpdocm (proveedor, compania, documento, docmto_aplicar,
            motivo_cxp, docmto_aplicar_ref, motivo_cxp_ref, aplicacion_origen,
            uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo, status,
            usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
        values (r_bcocheck1.proveedor, r_bcoctas.compania, ls_documento,
            new.aplicar_a, r_bcomotivos.motivo_cxp, new.aplicar_a,
            new.motivo_cxp, ''BCO'', ''N'', r_bcocheck1.fecha_posteo,
            r_bcocheck1.fecha_posteo, new.monto, r_bcocheck1.fecha_posteo,
            ''R'', current_user, current_timestamp, trim(r_bcocheck1.en_concepto_de),
            current_date, null);
    end if;     
    
    return old;
end;
' language plpgsql;


create function f_bcocheck3_cxpdocm_delete() returns trigger as '
declare
    r_bcomotivos record;
    r_bcoctas record;
    ls_documento char(25);
    r_bcocheck1 record;
    i integer;
begin
    if old.monto = 0 then
        return old;
    end if;
    
    select into r_bcocheck1 * from bcocheck1
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_cheque = old.no_cheque;
    if not found then
        return old;
    end if;
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = r_bcocheck1.cod_ctabco;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = r_bcocheck1.motivo_bco;
    
    ls_documento := trim(to_char(old.no_cheque, ''999999999999999''));
    

    delete from cxpdocm
    where compania = r_bcoctas.compania
    and proveedor = r_bcocheck1.proveedor
    and motivo_cxp = r_bcomotivos.motivo_cxp
    and documento = ls_documento
    and docmto_aplicar = old.aplicar_a;

    return old;
end;
' language plpgsql;



create function f_bcotransac1_cxpdocm_update() returns trigger as '
declare 
    r_bcotransac1 record;
    r_bcomotivos record;
    r_bcoctas record;
    i integer;
begin
    if old.monto = 0 and new.monto = 0 then
        return old;
    end if;
    
    if old.proveedor is null then
       return old;
    end if;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = old.motivo_bco;
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = old.cod_ctabco;
    
    delete from cxpdocm
    where trim(proveedor) = trim(old.proveedor)
    and trim(compania) = trim(r_bcoctas.compania)
    and trim(documento) = trim(old.no_docmto)
    and trim(motivo_cxp) = trim(r_bcomotivos.motivo_cxp);
    
    i := f_bcotransac1_cxpdocm(new.cod_ctabco, new.sec_transacc);
    
    return old;
end;
' language plpgsql;


create function f_bcotransac1_cxpdocm_delete() returns trigger as '
declare 
    r_bcotransac1 record;
    r_bcomotivos record;
    r_bcoctas record;
begin
    
    if old.proveedor is null then
       return old;
    end if;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = old.motivo_bco;
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = old.cod_ctabco;
    
    delete from cxpdocm
    where trim(proveedor) = trim(old.proveedor)
    and trim(compania) = trim(r_bcoctas.compania)
    and trim(documento) = trim(old.no_docmto)
    and trim(motivo_cxp) = trim(old.motivo_cxp);
    
    return old;
end;
' language plpgsql;


create function f_bcotransac3_cxpdocm_delete() returns trigger as '
declare 
    r_bcotransac1 record;
    r_bcomotivos record;
    r_bcoctas record;
begin
    if old.monto = 0 and new.monto = 0 then
        return old;
    end if;
    
    select into r_bcotransac1 * from bcotransac1
    where cod_ctabco = old.cod_ctabco
    and sec_transacc = old.sec_transacc;
    if not found then
        return old;
    end if;
    
    if r_bcotransac1.proveedor is null then
       return old;
    end if;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = r_bcotransac1.motivo_bco;
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = old.cod_ctabco;
    
    delete from cxpdocm
    where compania = r_bcoctas.compania
    and proveedor = r_bcotransac1.proveedor
    and documento = r_bcotransac1.no_docmto
    and motivo_cxp = r_bcomotivos.motivo_cxp;
    
    return old;
end;
' language plpgsql;


create function f_bcocheck1_cxpdocm(char(2), char(2), int4) returns integer as '
declare
    as_cod_ctabco alias for $1;
    as_motivo_bco alias for $2;
    ai_no_cheque alias for $3;
    r_bcocheck1 record;
    r_bcocheck3 record;
    r_bcomotivos record;
    r_bcoctas record;
    r_cxpdocm record;
    ls_documento char(25);
begin

    select into r_bcocheck1 * from bcocheck1
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    if not found then
       return 0;
    end if;
    
    if r_bcocheck1.status = ''A'' then
        return 0;
    end if;
    
    
    if r_bcocheck1.proveedor is null then
       return 0;
    end if;

    select into r_bcomotivos * from bcomotivos
    where motivo_bco = r_bcocheck1.motivo_bco;
    
    
    if r_bcomotivos.aplica_cheques = ''N'' then
       return 0;
    end if;
    
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = r_bcocheck1.cod_ctabco;

    ls_documento := trim(to_char(r_bcocheck1.no_cheque, ''99999999999999''));
    
    
    for r_bcocheck3 in select * from bcocheck3
                        where cod_ctabco = as_cod_ctabco
                        and motivo_bco = as_motivo_bco
                        and no_cheque = ai_no_cheque
                        and monto <> 0
    loop
    
       select into r_cxpdocm * from cxpdocm
       where proveedor = r_bcocheck1.proveedor
       and compania = r_bcoctas.compania
       and documento = r_bcocheck3.aplicar_a
       and docmto_aplicar = r_bcocheck3.aplicar_a
       and motivo_cxp = r_bcocheck3.motivo_cxp;
       
       if found then
          select into r_cxpdocm * from cxpdocm
          where proveedor = r_bcocheck1.proveedor
          and compania = r_bcoctas.compania
          and documento = ls_documento
          and docmto_aplicar = r_bcocheck3.aplicar_a
          and motivo_cxp = r_bcomotivos.motivo_cxp;
          if not found then
             insert into cxpdocm (proveedor, compania, documento, docmto_aplicar,
                motivo_cxp, docmto_aplicar_ref, motivo_cxp_ref, aplicacion_origen,
                uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo, status,
                usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
             values (r_bcocheck1.proveedor, r_bcoctas.compania, ls_documento,
                r_bcocheck3.aplicar_a, r_bcomotivos.motivo_cxp, r_bcocheck3.aplicar_a,
                r_bcocheck3.motivo_cxp, ''BCO'', ''N'', r_bcocheck1.fecha_posteo,
                r_bcocheck1.fecha_posteo, r_bcocheck3.monto, r_bcocheck1.fecha_posteo,
                ''R'', current_user, current_timestamp, trim(r_bcocheck1.en_concepto_de),
                current_date, null);
          else
             update cxpdocm
             set    fecha_docmto         = r_bcocheck1.fecha_posteo,
                    fecha_vmto           = r_bcocheck1.fecha_posteo,
                    monto                = r_bcocheck3.monto,
                    fecha_posteo         = r_bcocheck1.fecha_posteo,
                    usuario              = current_user,
                    fecha_captura        = current_timestamp,
                    obs_docmto           = trim(r_bcocheck1.en_concepto_de)
             where proveedor = r_bcocheck1.proveedor
             and compania = r_bcoctas.compania
             and documento = ls_documento
             and docmto_aplicar = r_bcocheck3.aplicar_a
             and motivo_cxp = r_bcomotivos.motivo_cxp;
          end if;
       end if;
       
    end loop;
    
    return 1;
end;
' language plpgsql;    



create function f_bcotransac1_cxpdocm(char(2), int4) returns integer as '
declare
    as_cod_ctabco alias for $1;
    ai_sec_transacc alias for $2;
    r_bcotransac1 record;
    r_bcotransac3 record;
    r_bcomotivos record;
    r_bcoctas record;
    r_cxpdocm record;
begin
    select into r_bcotransac1 * from bcotransac1
    where cod_ctabco = as_cod_ctabco
    and sec_transacc = ai_sec_transacc;
    if not found then
        return 0;
    end if;
    
    
    if r_bcotransac1.proveedor is null then
       return 0;
    end if;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = r_bcotransac1.motivo_bco;
    if not found or r_bcomotivos.motivo_cxp is null then
       raise exception ''Para este tipo de transaccion % el motivo de cxp es obligatorio'',r_bcotransac1.motivo_bco;
    end if;
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = r_bcotransac1.cod_ctabco;
    
    for r_bcotransac3 in select * from bcotransac3
                         where cod_ctabco = r_bcotransac1.cod_ctabco
                         and sec_transacc = r_bcotransac1.sec_transacc
                         and monto <> 0
    loop
       select into r_cxpdocm * from cxpdocm
       where proveedor = r_bcotransac1.proveedor
       and compania = r_bcoctas.compania
       and documento = r_bcotransac3.aplicar_a
       and docmto_aplicar = r_bcotransac3.aplicar_a
       and motivo_cxp = r_bcotransac3.motivo_cxp;
       if found then
          select into r_cxpdocm * from cxpdocm
          where proveedor = r_bcotransac1.proveedor
          and compania = r_bcoctas.compania
          and documento = r_bcotransac1.no_docmto
          and docmto_aplicar = r_bcotransac3.aplicar_a
          and motivo_cxp = r_bcomotivos.motivo_cxp;
          if not found then
             insert into cxpdocm (proveedor, compania, documento, docmto_aplicar,
                motivo_cxp, docmto_aplicar_ref, motivo_cxp_ref, aplicacion_origen,
                uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo, status,
                usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
             values (r_bcotransac1.proveedor, r_bcoctas.compania, r_bcotransac1.no_docmto,
                r_bcotransac3.aplicar_a, r_bcomotivos.motivo_cxp, r_bcotransac3.aplicar_a,
                r_bcotransac3.motivo_cxp, ''BCO'', ''N'', r_bcotransac1.fecha_posteo,
                r_bcotransac1.fecha_posteo, r_bcotransac3.monto, r_bcotransac1.fecha_posteo,
                ''R'', current_user, current_timestamp, trim(r_bcotransac1.obs_transac_bco),
                current_date, null);
          else
             update cxpdocm
             set    fecha_docmto         = r_bcotransac1.fecha_posteo,
                    fecha_vmto           = r_bcotransac1.fecha_posteo,
                    monto                = r_bcotransac3.monto,
                    fecha_posteo         = r_bcotransac1.fecha_posteo,
                    usuario              = current_user,
                    fecha_captura        = current_timestamp,
                    obs_docmto           = trim(r_bcotransac1.obs_transac_bco)
             where proveedor = r_bcotransac1.proveedor
             and compania = r_bcoctas.compania
             and documento = trim(r_bcotransac1.no_docmto)
             and docmto_aplicar = r_bcotransac3.aplicar_a
             and motivo_cxp = r_bcomotivos.motivo_cxp;
          end if;
       end if;
    end loop;
    
    return 1;
end;
' language plpgsql;





create trigger t_bcocheck1_cxpdocm_delete after delete on bcocheck1
for each row execute procedure f_bcocheck1_cxpdocm_delete();

create trigger t_bcocheck1_cxpdocm_update after update on bcocheck1
for each row execute procedure f_bcocheck1_cxpdocm_update();

create trigger t_bcocheck3_cxpdocm_insert after insert on bcocheck3
for each row execute procedure f_bcocheck3_cxpdocm_insert();

create trigger t_bcocheck3_cxpdocm_delete after delete on bcocheck3
for each row execute procedure f_bcocheck3_cxpdocm_delete();

create trigger t_bcocheck3_cxpdocm_update after update on bcocheck3
for each row execute procedure f_bcocheck3_cxpdocm_update();


create trigger t_bcotransac1_cxpdocm_delete after delete on bcotransac1
for each row execute procedure f_bcotransac1_cxpdocm_delete();

create trigger t_bcotransac1_cxpdocm_update after update on bcotransac1
for each row execute procedure f_bcotransac1_cxpdocm_update();


create trigger t_bcotransac3_cxpdocm_delete after delete or update on bcotransac3
for each row execute procedure f_bcotransac3_cxpdocm_delete();

drop function f_factura1_cglposteo(char(2), char(3), int4) cascade;
drop function f_rela_factura1_cglposteo_delete() cascade;
drop function f_monto_factura(char(2), char(3), int4) cascade;
drop function f_factura_x_rubro(char(2), char(3), int4, char(15)) cascade;
drop function f_factura1_delete() cascade;
drop function f_factura1_after_update() cascade;

create function f_factura1_cglposteo(char(2), char(3), int4) returns integer as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    li_consecutivo int4;
    r_almacen record;
    r_factura1 record;
    r_factura2 record;
    r_factura4 record;
    r_gral_forma_de_pago record;
    r_clientes record;
    r_work record;
    r_factmotivos record;
    r_cglcuentas record;
    r_articulos_por_almacen record;
    r_articulos record;
    r_cglauxiliares record;
    r_clientes_exentos record;
    ldc_sum_factura1 decimal(10,2);
    ldc_sum_factura2 decimal(10,2);
    ldc_sum_factura3 decimal(10,2);
    ldc_sum_factura4 decimal(10,2);
    ldc_monto_factura decimal(10,2);
    ldc_monto_factura2 decimal(10,2);
    ldc_work decimal(10,2);
    ldc_desbalance decimal(10,2);
    ls_cuenta char(24);
    ls_aux1 char(10);
    ls_rubro_subtotal char(60);
    ls_observacion text;
begin

    select into r_factura1 * from factura1
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    if not found then
       return 0;
    end if;
    
    delete from rela_factura1_cglposteo
    where almacen = r_factura1.almacen
    and tipo = r_factura1.tipo
    and num_documento = r_factura1.num_documento;
    
    if r_factura1.status = ''A'' then
       return 0;
    end if;
    
    select into r_factmotivos * from factmotivos
    where tipo = r_factura1.tipo;
    if r_factmotivos.cotizacion = ''S'' or r_factmotivos.donacion = ''S'' then
       return 0;
    end if;
    
    ldc_monto_factura := f_monto_factura(as_almacen, as_tipo, ai_num_documento);
    if ldc_monto_factura = 0 or ldc_monto_factura is null then
       Raise Exception ''Monto de Factura % no puede ser cero...Verifique'',ai_num_documento;
    end if;
    
    select into ldc_sum_factura2 sum((cantidad*precio)-descuento_linea-descuento_global) 
    from factura2
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    if ldc_sum_factura2 is null then
       ldc_sum_factura2 := 0;
    end if;
    
    select into ldc_sum_factura3 sum(monto) 
    from factura3
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    if ldc_sum_factura3 is null then
       ldc_sum_factura3 := 0;
    end if;

    ldc_monto_factura := (ldc_sum_factura2 + ldc_sum_factura3) * r_factmotivos.signo;
    if ldc_monto_factura < 0 then
        ldc_monto_factura2 := -ldc_monto_factura;
    else
        ldc_monto_factura2 := ldc_monto_factura;
    end if;    

    ldc_desbalance := ldc_monto_factura2 - ldc_sum_factura2 - ldc_sum_factura3;
--    if ldc_desbalance <= -1 or ldc_desbalance >= 1 then
    if ldc_desbalance <> 0 then
       raise exception ''Factura % esta desbalanceada...Verifique %  Total % Factura2 % Impuesto %'',
        ai_num_documento, ldc_desbalance, ldc_monto_factura2, ldc_sum_factura2, ldc_sum_factura3;
    end if;
    
    
    select into r_almacen * from almacen
    where almacen = r_factura1.almacen;
    
    r_factura1.observacion := ''FACTURA # '' || ai_num_documento;
    
    if r_factura1.mbl is not null then
       r_factura1.observacion := trim(r_factura1.observacion) || ''  '' || trim(r_factura1.mbl);
    end if;
    
    if r_factura1.hbl is not null then
       r_factura1.observacion := trim(r_factura1.observacion) || ''  '' || trim(r_factura1.hbl);
    end if;
    
    
    ldc_sum_factura2 := 0;
    for r_work in select factura2.almacen, factura2.articulo, -sum((factmotivos.signo*cantidad*precio)-descuento_linea-descuento_global) as monto
                        from factura2, factmotivos
                        where factura2.tipo = factmotivos.tipo
                        and factura2.almacen = r_factura1.almacen
                        and factura2.tipo = r_factura1.tipo
                        and factura2.num_documento = r_factura1.num_documento
                        group by 1, 2
                        order by 1, 2
    loop
        ls_aux1 := null;
        select into r_articulos * from articulos
        where articulo = r_work.articulo and servicio = ''S'';
        if found then
            select into r_articulos_por_almacen * from articulos_por_almacen
            where almacen = r_work.almacen
            and articulo = r_work.articulo;
            ls_cuenta := r_articulos_por_almacen.cuenta;
            
            select into r_cglcuentas * from cglcuentas
            where cuenta = ls_cuenta and auxiliar_1 = ''S'';
            if found then
                if r_factura1.referencia = ''1'' or r_factura1.referencia = ''2'' or r_factura1.referencia = ''7'' then
                    ls_aux1 := r_factura1.ciudad_origen;
                else
                    ls_aux1 := r_factura1.ciudad_destino;
                end if;
                
                ls_aux1 := r_factura1.agente;
                
                if ls_aux1 is null then
                    select into r_cglauxiliares * from cglauxiliares
                    where trim(auxiliar) = trim(r_factura1.cliente);
                    if not found then
                        insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
                        values (r_factura1.cliente, r_clientes.nomb_cliente, ''1'', ''A'');
                    end if;
                    ls_aux1 = r_factura1.cliente;
                end if;
            end if;
        else
            select into ls_cuenta facparamcgl.cuenta_ingreso from articulos_agrupados, facparamcgl
            where r_work.articulo = articulos_agrupados.articulo
            and facparamcgl.almacen = r_work.almacen
            and facparamcgl.codigo_valor_grupo = articulos_agrupados.codigo_valor_grupo;
            if ls_cuenta is null or not found then
                select into ls_cuenta fac_parametros_contables.cta_de_ingreso from fac_parametros_contables, articulos_agrupados
                where articulos_agrupados.codigo_valor_grupo = fac_parametros_contables.codigo_valor_grupo
                and articulos_agrupados.articulo = r_work.articulo
                and fac_parametros_contables.almacen = r_work.almacen
                and fac_parametros_contables.referencia = r_factura1.referencia;
                if ls_cuenta is null or not found then
                    Raise Exception ''En la Factura # % El articulo % no tiene definido cuenta de ingreso...Verifique'',r_factura1.num_documento, r_work.articulo;
                end if;
            end if;
        end if;
        
        select into r_clientes_exentos * from clientes_exentos
        where cliente = r_factura1.cliente;
        if found then
            ls_cuenta := r_clientes_exentos.cuenta;
        end if;

        if ls_cuenta is null then
            Raise Exception ''En la Factura # % El articulo % no tiene definido cuenta de ingreso...Verifique'',r_factura1.num_documento, r_work.articulo;
        end if;

        li_consecutivo := f_cglposteo(r_almacen.compania, ''FAC'', r_factura1.fecha_factura, 
                                Trim(ls_cuenta), ls_aux1, null, r_factmotivos.tipo_comp, 
                                trim(r_factura1.observacion), Round(r_work.monto,2));
        if li_consecutivo > 0 then
            insert into rela_factura1_cglposteo (almacen, tipo, num_documento, consecutivo)
            values (r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento, li_consecutivo);
        end if;
        ldc_sum_factura2 := ldc_sum_factura2 + Round(r_work.monto,2);
    end loop;
    
    ls_rubro_subtotal := f_gralparaxcia(r_almacen.compania, ''FAC'', ''rubro_subtotal'');
    select into ldc_sum_factura4 sum(monto*rubros_fact_cxc.signo_rubro_fact_cxc) 
    from factura4, rubros_fact_cxc
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and trim(factura4.rubro_fact_cxc) = trim(rubros_fact_cxc.rubro_fact_cxc)
    and trim(factura4.rubro_fact_cxc) <> ''ITBMS'';
    if found then
        ldc_work := (r_factmotivos.signo*ldc_sum_factura4) - ldc_sum_factura2;
        if ldc_work <> 0 then
            ls_observacion := ''FACTURA # '' || ai_num_documento || '' AJUSTE POR REDONDEO '';
    
            if ls_cuenta is null then
                Raise Exception ''En la Factura # % no tiene cuenta de ajuste...Verifique'',r_factura1.num_documento;
            end if;
            li_consecutivo := f_cglposteo(r_almacen.compania, ''FAC'', r_factura1.fecha_factura, 
                                    Trim(ls_cuenta), ls_aux1, null, r_factmotivos.tipo_comp, 
                                    trim(ls_observacion), (ldc_work*r_factmotivos.signo));
            if li_consecutivo > 0 then
                insert into rela_factura1_cglposteo (almacen, tipo, num_documento, consecutivo)
                values (r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento, li_consecutivo);
            end if;
        end if;
    end if;
    
    ldc_sum_factura3 := 0;    
    for r_work in select gral_impuestos.cuenta, -sum(monto*factmotivos.signo) as monto
                    from factura3, gral_impuestos, factmotivos
                    where factura3.impuesto = gral_impuestos.impuesto
                    and factura3.almacen = r_factura1.almacen
                    and factura3.tipo = r_factura1.tipo
                    and factura3.num_documento = r_factura1.num_documento
                    and factura3.tipo = factmotivos.tipo
                    group by 1
                    order by 1
    loop
        if r_work.cuenta is null then
            Raise Exception ''En la Factura # % no tiene cuenta de impuestos...Verifique'',r_factura1.num_documento;
        end if;
        
        li_consecutivo := f_cglposteo(r_almacen.compania, ''FAC'', r_factura1.fecha_factura, 
                                Trim(r_work.cuenta), null, null, r_factmotivos.tipo_comp, 
                                trim(r_factura1.observacion), r_work.monto);
        if li_consecutivo > 0 then
            insert into rela_factura1_cglposteo (almacen, tipo, num_documento, consecutivo)
            values (r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento, li_consecutivo);
        end if;
        ldc_sum_factura3 := ldc_sum_factura3 + r_work.monto;
    end loop;
    
    select into r_factura4 * from factura4
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento
    and trim(rubro_fact_cxc) = ''ITBMS'';
    if found then
        ldc_work := (r_factura4.monto*r_factmotivos.signo) + ldc_sum_factura3;
        if ldc_work <> 0 then
            ls_observacion := ''FACTURA # '' || ai_num_documento || '' AJUSTE POR REDONDEO '';
    
            li_consecutivo := f_cglposteo(r_almacen.compania, ''FAC'', r_factura1.fecha_factura, 
                                    Trim(r_work.cuenta), ls_aux1, null, r_factmotivos.tipo_comp, 
                                    trim(ls_observacion), (ldc_work));
            if li_consecutivo > 0 then
                insert into rela_factura1_cglposteo (almacen, tipo, num_documento, consecutivo)
                values (r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento, li_consecutivo);
            end if;
        end if;
    end if;        
    
    ldc_monto_factura := -(ldc_sum_factura2 + ldc_sum_factura3);
    
    select into r_clientes * from clientes
    where cliente = r_factura1.cliente;
    
    select into r_gral_forma_de_pago * from gral_forma_de_pago
    where forma_pago = r_factura1.forma_pago;
    
    if r_gral_forma_de_pago.dias > 0 then
       select into ls_cuenta trim(valor) from invparal
       where almacen = r_factura1.almacen
       and parametro = ''cta_cxc''
       and aplicacion =  ''INV'';
       if not found then
          ls_cuenta := r_clientes.cuenta;
       end if;
    else
       select into ls_cuenta trim(valor) from invparal
       where almacen = r_factura1.almacen
       and parametro = ''cta_caja''
       and aplicacion =  ''INV'';
       if not found then
          Raise Exception ''Parametro cta_caja no existe en el almacen % ...Verifique'',r_factura1.almacen;
       end if;
    end if;
    
    
    ls_aux1 :=  null;
    select into r_cglcuentas * from cglcuentas
    where trim(cuenta) = trim(ls_cuenta)
    and auxiliar_1 = ''S'';
    if found then
        ls_aux1 :=   r_factura1.cliente;
        select into r_cglauxiliares * from cglauxiliares
        where trim(auxiliar) = trim(ls_aux1);
        if not found then
            insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
            values (r_factura1.cliente, r_clientes.nomb_cliente, ''1'', ''A'');
        end if;
    end if;

    li_consecutivo := f_cglposteo(r_almacen.compania, ''FAC'', r_factura1.fecha_factura, 
                            ls_cuenta, ls_aux1, null, r_factmotivos.tipo_comp, 
                            trim(r_factura1.observacion), ldc_monto_factura);
    if li_consecutivo > 0 then
        insert into rela_factura1_cglposteo (almacen, tipo, num_documento, consecutivo)
        values (r_factura1.almacen, r_factura1.tipo, r_factura1.num_documento, li_consecutivo);
    end if;

    return 1;
end;
' language plpgsql;


create function f_factura_x_rubro(char(2), char(3), int4, char(15)) returns decimal(10,2)
as 'select -sum(d.monto*a.signo*b.signo_rubro_fact_cxc) from factmotivos a, rubros_fact_cxc b, factura1 c, factura4 d
where c.almacen = d.almacen
and c.tipo = d.tipo
and c.num_documento = d.num_documento
and c.tipo = a.tipo
and d.rubro_fact_cxc = b.rubro_fact_cxc
and c.almacen = $1
and c.tipo = $2
and c.num_documento = $3
and b.rubro_fact_cxc = $4;' language 'sql';




create function f_rela_factura1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;

create function f_factura1_delete() returns trigger as '
declare
    ls_documento char(25);
    i integer;
begin
    
    ls_documento    :=   old.num_documento;
    
    select into i count(*) from cxcdocm
    where almacen = old.almacen
    and cliente = old.cliente
    and docmto_ref = ls_documento
    and docmto_aplicar = ls_documento
    and motivo_ref = old.tipo;
    if i is null then
        i := 0;
    end if;
    
    if i > 1 then
        raise exception ''Factura % tiene documentos aplicando a ella...No se puede modificar/eliminar...Verifique'', old.num_documento;
    end if;
    
    delete from cxcdocm
    where almacen = old.almacen
    and cliente = old.cliente
    and motivo_cxc = old.tipo
    and trim(documento) = trim(ls_documento)
    and trim(docmto_aplicar) = trim(ls_documento);
    
    
    return old;
end;
' language plpgsql;

create function f_factura1_after_update() returns trigger as '
begin

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
    
    return new;
end;
' language plpgsql;




create function f_monto_factura(char(2), char(3), int4) returns decimal(10,2)
as 'select -sum(d.monto*a.signo*b.signo_rubro_fact_cxc) from factmotivos a, rubros_fact_cxc b, factura1 c, factura4 d
where c.almacen = d.almacen
and c.tipo = d.tipo
and c.num_documento = d.num_documento
and c.tipo = a.tipo
and d.rubro_fact_cxc = b.rubro_fact_cxc
and c.almacen = $1
and c.tipo = $2
and c.num_documento = $3;' language 'sql';



create trigger t_rela_factura1_cglposteo_delete after delete on rela_factura1_cglposteo
for each row execute procedure f_rela_factura1_cglposteo_delete();

create trigger t_factura1_delete after delete on factura1
for each row execute procedure f_factura1_delete();

create trigger t_factura1_after_update after update on factura1
for each row execute procedure f_factura1_after_update();
drop function f_gralparaxcia(char(2), char(3), char(20));
drop function f_gralparaxapli(char(3), char(20));

create function f_gralparaxapli(char(3), char(20)) returns char(20) as '
declare
    as_aplicacion alias for $1;
    as_parametro alias for $2;
    r_gralparaxapli record;
begin
    select into r_gralparaxapli * from gralparaxapli
    where aplicacion = as_aplicacion
    and parametro = as_parametro;
    if not found then
        Raise Exception ''Parametro % No Existe en la aplicacion % gralparaxapli'',as_parametro, as_aplicacion;
    end if;

    return Trim(r_gralparaxapli.valor);
end;
' language plpgsql;


create function f_gralparaxcia(char(2), char(3), char(20)) returns char(60) as '
declare
    as_compania alias for $1;
    as_aplicacion alias for $2;
    as_parametro alias for $3;
    ls_retorno char(60);
begin
    select into ls_retorno valor from gralparaxcia
    where compania = as_compania
    and aplicacion = as_aplicacion
    and parametro = as_parametro;
    if not found then
       Raise Exception ''Parametro % no Existen en la Aplicacion % de la Cia %'',as_parametro,as_aplicacion,as_compania;
    end if;
    
    return trim(ls_retorno);
end;
' language plpgsql;

drop function f_eys1_cglposteo(char(2), int4) cascade;
drop function f_rela_eys1_cglposteo_delete() cascade;
drop function f_factura2_eys2_delete() cascade;
drop function f_eys4_delete() cascade;
drop function f_cos_consumo_eys2_delete() cascade;
drop function f_cos_produccion_eys2_delete() cascade;
drop function f_eys2_eys6() cascade;
drop function f_costos_inventario(char(2), int4) cascade;
drop function f_costos_inventario_fifo(char(2), int4) cascade;
drop function f_eys1_poner_cuentas(char(2), int4) cascade;
drop function f_eys2_insert() cascade;
drop function f_eys2_delete() cascade;
drop function f_eys2_update() cascade;
drop function f_factura_inventario(char(2), char(3), integer) cascade;
drop function f_update_existencias(char(2), char(15)) cascade;
drop function f_compras_inventario(char(2), char(6), char(25)) cascade;
drop function f_sec_inventario(char(2)) cascade;
drop function f_stock(char(2), char(15), date, int4, int4, text) cascade;
drop function f_inv_fisico2_after_update() cascade;


create function f_inv_fisico2_after_update() returns trigger as '
begin
    if new.ubicacion is not null then
        update articulos_por_almacen
        set ubicacion = new.ubicacion
        where almacen = new.almacen
        and articulo = new.articulo;
    end if;
    return new;
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
    set valor = ls_valor
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
    
    delete from rela_eys1_cglposteo
    where almacen = as_almacen
    and no_transaccion = ai_no_transaccion;
    
    select into r_invmotivos * from invmotivos
    where motivo = r_eys1.motivo;
    if r_invmotivos.costo = ''N'' then
        return 0;
    end if;
    
    for r_work in select almacen.compania, articulos_por_almacen.cuenta, sum(eys2.costo) as monto
                    from eys2, articulos_por_almacen, almacen
                    where eys2.almacen = almacen.almacen
                    and eys2.almacen = articulos_por_almacen.almacen
                    and eys2.articulo = articulos_por_almacen.articulo
                    and eys2.almacen = as_almacen
                    and eys2.no_transaccion = ai_no_transaccion
                    group by 1, 2
                    order by 1, 2
    loop
        if r_eys1.observacion is null then
           r_eys1.observacion := ''ALMACEN  '' || trim(r_eys1.almacen) || ''   TRANSACCION #  '' || ai_no_transaccion;
        else
           r_eys1.observacion := ''ALMACEN  '' || trim(r_eys1.almacen) || ''   TRANSACCION #  '' || ai_no_transaccion || ''  ''  || r_eys1.observacion;
        end if;
        li_consecutivo := f_cglposteo(r_work.compania, r_eys1.aplicacion_origen, r_eys1.fecha, r_work.cuenta,
                            null, null, r_invmotivos.tipo_comp, r_eys1.observacion, 
                            (r_work.monto*r_invmotivos.signo));
        if li_consecutivo > 0 then
           insert into rela_eys1_cglposteo (consecutivo, almacen, no_transaccion)
           values (li_consecutivo, as_almacen, ai_no_transaccion);
        end if;
    end loop;
    
    for r_work in select almacen.compania, eys3.cuenta, eys3.auxiliar1, sum(eys3.monto) as monto
                    from eys3, almacen
                    where eys3.almacen = almacen.almacen
                    and eys3.almacen = as_almacen
                    and eys3.no_transaccion = ai_no_transaccion
                    group by 1, 2, 3
                    order by 1, 2, 3
    loop
        li_consecutivo := f_cglposteo(r_work.compania, r_eys1.aplicacion_origen, r_eys1.fecha, 
                            r_work.cuenta, r_work.auxiliar1, null, r_invmotivos.tipo_comp, 
                            r_eys1.observacion, -(r_work.monto*r_invmotivos.signo));
        if li_consecutivo > 0 then
           insert into rela_eys1_cglposteo (consecutivo, almacen, no_transaccion)
           values (li_consecutivo, as_almacen, ai_no_transaccion);
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;


create function f_rela_eys1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
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
    
    select into r_eys1 eys1.* from eys1, eys4
    where eys1.no_transaccion = eys4.no_transaccion
    and eys1.almacen = eys4.almacen
    and eys4.compania = as_compania
    and eys4.proveedor = as_proveedor
    and eys4.fact_proveedor = as_fact_proveedor;
    if not found then
       return 0;
    end if;
    
    if r_eys1.status = ''P'' then
       return 0;
    end if;
    
    for r_eys2 in select eys2.* from eys2, articulos, eys4
                        where eys2.articulo = articulos.articulo
                        and eys2.articulo = eys4.articulo
                        and eys2.almacen = eys4.almacen
                        and eys2.no_transaccion = eys4.no_transaccion
                        and eys2.linea = eys4.inv_linea
                        and articulos.servicio = ''N''
                        and articulos.valorizacion in (''F'', ''L'')
                        and eys4.compania = as_compania
                        and eys4.proveedor = as_proveedor
                        and eys4.fact_proveedor = as_fact_proveedor
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



create function f_eys2_insert() returns trigger as '
declare
    i integer;
begin
    i := f_update_existencias(new.almacen, new.articulo);
    return new;
end;
' language plpgsql;


create function f_eys2_delete() returns trigger as '
declare
    i integer;
begin
    i := f_update_existencias(old.almacen, old.articulo);
    return new;
end;
' language plpgsql;

create function f_eys2_update() returns trigger as '
declare
    i integer;
begin
    if old.articulo = new.articulo then
       i := f_update_existencias(new.almacen, new.articulo);
    else
       i := f_update_existencias(old.almacen, old.articulo);
       i := f_update_existencias(new.almacen, new.articulo);
    end if;
       
    return new;
end;
' language plpgsql;



create function f_update_existencias(char(2), char(15)) returns integer as '
declare
    ldc_existencia decimal(12,4);
    ldc_costo decimal(12,4);
begin
    ldc_existencia := f_stock($1, $2, ''2300-01-01'', 0, 0, ''STOCK'');
    ldc_costo := f_stock($1, $2, ''2300-01-01'', 0, 0, ''COSTO'');

    update articulos_por_almacen
    set existencia = ldc_existencia, costo = ldc_costo
    where articulos_por_almacen.almacen = $1
    and articulos_por_almacen.articulo = $2;
    
    return 1;
end;
' language plpgsql;


create function f_factura_inventario(char(2), char(3), integer) returns integer as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    r_factmotivos record;
    r_factura1 record;
    r_factura2 record;
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
begin

    update factura1
    set documento = trim(to_char(num_documento, ''9999999999999999'')), aplicacion = ''FAC''
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    
    delete from factura2_eys2
    where almacen = as_almacen
    and tipo = as_tipo
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
    
    select into r_eys2 eys2.* from factura2_eys2, eys1
    where factura2_eys2.almacen = eys1.almacen
    and factura2_eys2.no_transaccion = eys1.no_transaccion
    and factura2_eys2.almacen = as_almacen
    and factura2_eys2.tipo = as_tipo
    and factura2_eys2.num_documento = ai_num_documento
    and eys1.status = ''P'';
    if found then
       return 0;
    end if;
    
    
    select into r_factura1 * from factura1
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    
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
       r_eys1.almacen             :=  as_almacen;
       r_eys1.no_transaccion      :=  f_sec_inventario(as_almacen); 
       r_eys1.motivo              :=  r_factmotivos.motivo;
       r_eys1.aplicacion_origen   :=  ''FAC'';
       r_eys1.usuario             :=  ''dba'';
       r_eys1.fecha_captura       :=  Today();
       r_eys1.status              :=  ''R'';
       r_eys1.fecha               :=  r_factura1.fecha_despacho;
       
        INSERT INTO eys1 ( almacen, no_transaccion, motivo, aplicacion_origen, 
        fecha, usuario, fecha_captura, status ) 
        VALUES ( r_eys1.almacen, r_eys1.no_transaccion, r_eys1.motivo, ''FAC'', 
        r_eys1.fecha, current_user, current_timestamp, ''R'');

    end if;
    

    
    for r_factura2 in select factura2.* from factura2, articulos 
                        where factura2.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and factura2.almacen = as_almacen 
                        and factura2.tipo = as_tipo 
                        and factura2.num_documento = ai_num_documento
    loop
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
            and factura2.num_documento = r_factura1.num_factura;
            if not found then
                ldc_cu  :=  f_stock(r_factura2.almacen, r_factura2.articulo, r_factura1.fecha_factura, 0, 0, ''CU'');
            end if;
        else
              ldc_cu  :=   f_stock(r_factura2.almacen, r_factura2.articulo,r_factura1.fecha_factura, 0, 0, ''CU'');
        end if;
        
        select into li_linea max(eys2.linea) from eys2
        where almacen = r_eys1.almacen
        and no_transaccion = r_eys1.no_transaccion;
        if li_linea is null then
            li_linea := 1;
        else
            li_linea := li_linea + 1;
        end if;
        
--        raise exception ''costo %'', ldc_cu;
        if ldc_cu is null then
            raise exception ''costo unitario no puede ser nulo...documento %'', ai_num_documento;
        end if;
        
        INSERT INTO eys2 ( articulo, almacen, no_transaccion, linea, cantidad, costo ) 
        VALUES (r_factura2.articulo, r_factura2.almacen, r_eys1.no_transaccion,
        li_linea, r_factura2.cantidad, (ldc_cu * r_factura2.cantidad));
        
        
        insert into factura2_eys2 (articulo, almacen, no_transaccion, eys2_linea,
        tipo, num_documento, factura2_linea)
        values (r_factura2.articulo, r_factura2.almacen, r_eys1.no_transaccion,
        li_linea, r_factura2.tipo, r_factura2.num_documento, r_factura2.linea);
        
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
        
        
    end  loop;
        
    return 1;
end;
' language plpgsql;


create function f_costos_inventario(char(2), int4) returns integer as '
declare
    as_compania alias for $1;
    ai_secuencia alias for $2;
    r_cos_produccion record;
    r_cos_consumo record;
    r_invmotivos record;
    r_cos_trx record;
    r_eys1 record;
    r_eys2 record;
    r_eys6 record;
    ls_tdt_consumo char(2);
    ls_tdt_produccion char(2);
    li_work integer;
    li_linea integer;
    ls_work text;
    ldc_cu decimal(12,4);
    r_cos_consumo_eys2 record;
begin
    select into r_cos_trx * from cos_trx
    where compania = as_compania and secuencia = ai_secuencia;
    
    select into li_work count(*) from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and final >= r_cos_trx.fecha
    and estado = ''I'';
    if li_work is null or li_work > 0 then
       return 0;
    end if;
    
    select into ls_work trim(valor) from gralparaxapli
    where aplicacion = ''INV'' and parametro = ''tdt_consumo'';
    if not found then
       raise exception ''no existe valor para parametro tdt_consumo a nivel de aplicacion'';
    end if;
    ls_tdt_consumo := trim(ls_work);
    
    
    select into ls_work trim(valor) from gralparaxapli
    where aplicacion = ''INV'' and parametro = ''tdt_produccion'';
    if not found then
       raise exception ''no existe valor para parametro tdt_produccion a nivel de aplicacion'';
    end if;
    ls_tdt_produccion := trim(ls_work);
    
    select into r_invmotivos * from invmotivos
    where motivo = ls_tdt_consumo;
    if not found then
       raise exception ''tipo de transaccion para consumo no existe en invmotivos %'', ls_tdt_consumo;
    end if;
    
--    raise exception ''llegue %'',r_cos_trx.fecha;
    
    select into r_invmotivos * from invmotivos
    where motivo = ls_tdt_produccion;
    if not found then
       raise exception ''tipo de transaccion para produccion no existe en invmotivos %'', ls_tdt_consumo;
    end if;
    
    delete from cos_consumo_eys2
    where compania = as_compania
    and secuencia = ai_secuencia;
    
    delete from cos_produccion_eys2
    where compania = as_compania
    and secuencia = ai_secuencia;

    for r_cos_consumo in select cos_consumo.* from cos_consumo, articulos 
                        where cos_consumo.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and cos_consumo.compania = as_compania
                        and cos_consumo.secuencia = ai_secuencia
    loop
        select into r_eys1 eys1.* from eys1
        where almacen = r_cos_consumo.almacen
        and motivo = ls_tdt_consumo
        and aplicacion_origen = ''COS''
        and fecha = r_cos_trx.fecha;
        if not found then
           r_eys1.almacen             :=  r_cos_consumo.almacen;
           r_eys1.no_transaccion      :=  f_sec_inventario(r_cos_consumo.almacen); 
           r_eys1.motivo              :=  ls_tdt_consumo;
           r_eys1.aplicacion_origen   :=  ''COS'';
           r_eys1.usuario             :=  current_user;
           r_eys1.fecha_captura       :=  current_timestamp;
           r_eys1.observacion         :=  r_cos_trx.observacion;
           r_eys1.status              :=  ''R'';
           r_eys1.fecha               :=  r_cos_trx.fecha;
       
            INSERT INTO eys1 ( almacen, no_transaccion, motivo, aplicacion_origen, 
            fecha, usuario, fecha_captura, status, observacion ) 
            VALUES ( r_eys1.almacen, r_eys1.no_transaccion, r_eys1.motivo, ''COS'', 
            r_eys1.fecha, current_user, current_timestamp, ''R'', trim(r_eys1.observacion));
        end if;

              
        li_linea := 0;
        li_work := 0;
        while li_work = 0 loop
            li_linea := li_linea + 1;
            select into r_eys2 * from eys2
            where almacen = r_cos_consumo.almacen
            and no_transaccion = r_eys1.no_transaccion
            and linea = li_linea;
            if not found then
               li_work := 1;
            end if;
        end loop;
        
        ldc_cu  :=   f_stock(r_cos_consumo.almacen, r_cos_consumo.articulo, r_cos_trx.fecha, 0, 0, ''CU'');
        INSERT INTO eys2 ( articulo, almacen, no_transaccion, linea, cantidad, costo ) 
        VALUES (r_cos_consumo.articulo, r_cos_consumo.almacen, r_eys1.no_transaccion,
        li_linea, r_cos_consumo.cantidad, (ldc_cu * r_cos_consumo.cantidad));
        
        
        insert into cos_consumo_eys2 (secuencia, compania, linea, articulo, almacen,
            no_transaccion, eys2_linea)
        values (r_cos_trx.secuencia, r_cos_trx.compania, r_cos_consumo.linea,
            r_cos_consumo.articulo, r_cos_consumo.almacen, r_eys1.no_transaccion,
            li_linea);

        update eys1
        set    usuario = current_user,
               fecha_captura = current_timestamp
        where  almacen = r_cos_consumo.almacen
        and    no_transaccion = r_eys1.no_transaccion;
        
    end  loop;
    
    for r_cos_produccion in select cos_produccion.* from cos_produccion, articulos 
                        where cos_produccion.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and cos_produccion.compania = as_compania
                        and cos_produccion.secuencia = ai_secuencia
    loop
        select into r_eys1 eys1.* from eys1
        where almacen = r_cos_produccion.almacen
        and motivo = ls_tdt_produccion
        and aplicacion_origen = ''COS''
        and fecha = r_cos_trx.fecha;
        if not found then
           r_eys1.almacen             :=  r_cos_produccion.almacen;
           r_eys1.no_transaccion      :=  f_sec_inventario(r_cos_produccion.almacen); 
           r_eys1.motivo              :=  ls_tdt_produccion;
           r_eys1.aplicacion_origen   :=  ''COS'';
           r_eys1.usuario             :=  current_user;
           r_eys1.fecha_captura       :=  current_timestamp;
           r_eys1.observacion         :=  r_cos_trx.observacion;
           r_eys1.status              :=  ''R'';
           r_eys1.fecha               :=  r_cos_trx.fecha;
       
            INSERT INTO eys1 ( almacen, no_transaccion, motivo, aplicacion_origen, 
            fecha, usuario, fecha_captura, status, observacion ) 
            VALUES ( r_eys1.almacen, r_eys1.no_transaccion, r_eys1.motivo, ''COS'', 
            r_eys1.fecha, current_user, current_timestamp, ''R'', trim(r_eys1.observacion));
        end if;

              
        li_linea := 0;
        li_work := 0;
        while li_work = 0 loop
            li_linea := li_linea + 1;
            select into r_eys2 * from eys2
            where almacen = r_cos_produccion.almacen
            and no_transaccion = r_eys1.no_transaccion
            and linea = li_linea;
            if not found then
               li_work := 1;
            end if;
        end loop;
        
        ldc_cu := 0;        
        INSERT INTO eys2 ( articulo, almacen, no_transaccion, linea, cantidad, costo ) 
        VALUES (r_cos_produccion.articulo, r_cos_produccion.almacen, r_eys1.no_transaccion,
        li_linea, r_cos_produccion.cantidad, (ldc_cu * r_cos_produccion.cantidad));
        
        
        insert into cos_produccion_eys2 (secuencia, compania, linea, articulo, almacen,
            no_transaccion, eys2_linea)
        values (r_cos_trx.secuencia, r_cos_trx.compania, r_cos_produccion.linea,
            r_cos_produccion.articulo, r_cos_produccion.almacen, r_eys1.no_transaccion,
            li_linea);
            
            
            
        update eys1
        set    usuario = current_user,
               fecha_captura = current_timestamp
        where  almacen = r_cos_produccion.almacen
        and    no_transaccion = r_eys1.no_transaccion;
        
    end  loop;
    
    
        
    return 1;
end;
' language plpgsql;


create function f_costos_inventario_fifo(char(2), int4) returns integer as '
declare
    as_compania alias for $1;
    ai_secuencia alias for $2;
    r_cos_consumo_eys2 record;
    r_eys6 record;
    r_eys2 record;
    r_articulos record;
    i integer;
    ldc_costo decimal(12,2);
begin
    for r_cos_consumo_eys2 in select cos_consumo_eys2.* from cos_consumo_eys2, articulos 
                        where cos_consumo_eys2.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and cos_consumo_eys2.compania = as_compania
                        and cos_consumo_eys2.secuencia = ai_secuencia
    loop
        select into r_articulos * from articulos
        where articulo = r_cos_consumo_eys2.articulo;
        if r_articulos.valorizacion = ''L'' or r_articulos.valorizacion = ''F'' then
            ldc_costo := 0;
            for r_eys6 in select * from eys6
                            where articulo = r_cos_consumo_eys2.articulo
                            and almacen = r_cos_consumo_eys2.almacen
                            and no_transaccion = r_cos_consumo_eys2.no_transaccion
                            and linea = r_cos_consumo_eys2.eys2_linea
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
            where articulo = r_cos_consumo_eys2.articulo
            and almacen = r_cos_consumo_eys2.almacen
            and no_transaccion = r_cos_consumo_eys2.no_transaccion
            and linea = r_cos_consumo_eys2.eys2_linea;
                  
            select into r_eys2 * from eys2
            where articulo = r_cos_consumo_eys2.articulo
            and almacen = r_cos_consumo_eys2.almacen
            and no_transaccion = r_cos_consumo_eys2.no_transaccion
            and linea = r_cos_consumo_eys2.eys2_linea;
          
            update cos_consumo
            set costo = r_eys2.costo
            where secuencia = r_cos_consumo_eys2.secuencia
            and compania = r_cos_consumo_eys2.compania
            and linea = r_cos_consumo_eys2.linea;
        else
            select into r_eys2 * from eys2
            where articulo = r_cos_consumo_eys2.articulo
            and almacen = r_cos_consumo_eys2.almacen
            and no_transaccion = r_cos_consumo_eys2.no_transaccion
            and linea = r_cos_consumo_eys2.eys2_linea;
          
            update cos_consumo
            set costo = r_eys2.costo
            where secuencia = r_cos_consumo_eys2.secuencia
            and compania = r_cos_consumo_eys2.compania
            and linea = r_cos_consumo_eys2.linea;
        end if;
        
        i := f_eys1_poner_cuentas(r_cos_consumo_eys2.almacen, r_cos_consumo_eys2.no_transaccion);
        if i = 0 then
           raise exception ''transaccion % no tiene definido cuenta de costo...verifique '', r_cos_consumo_eys2.no_transaccion;
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;

create function f_eys1_poner_cuentas(char(2), int4) returns integer as '
declare
    as_almacen alias for $1;
    ai_no_transaccion alias for $2;
    r_work record;
    r_facparamcgl record;
    r_eys3 record;
    li_work integer;
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
    li_work := f_eys1_cglposteo(as_almacen, ai_no_transaccion);
    return 1;
end;
' language plpgsql;



create function f_eys2_eys6() returns trigger as '
declare
    r_eys1 record;
    r_eys2 record;
    r_articulos record;
    r_compras record;
    r_invmotivos record;
    ldc_cantidad decimal(12,4);
    ldc_cantidad_eys6 decimal(12,4);
begin
    
    select into r_articulos * from articulos
    where articulo = new.articulo
    and valorizacion in (''F'', ''L'');
    if not found then
       return new;
    end if;
    
    if new.cantidad = 0 then
       return new;
    end if;
    
    select into r_eys1 * from eys1
    where almacen = new.almacen
    and no_transaccion = new.no_transaccion;    
    if not found then
        return new;
    end if;
    
    select into r_invmotivos * from invmotivos
    where motivo = r_eys1.motivo;
    
    
    delete from eys6
    where articulo = new.articulo
    and almacen = new.almacen
    and no_transaccion = new.no_transaccion
    and linea = new.linea;
    
--    raise exception ''entre'';
    ldc_cantidad := new.cantidad;
    
    if r_invmotivos.signo = -1 then
        for r_compras in select eys1.almacen, eys6.articulo,   
                                 eys1.fecha,   
                                 eys6.compra_no_transaccion,   
                                 eys6.compra_linea,   
                                 sum(eys6.cantidad) as saldo FROM eys1, eys6  
                           WHERE eys1.almacen = eys6.almacen
                           and  eys1.no_transaccion = eys6.compra_no_transaccion
                           and eys1.almacen = new.almacen
                           and eys6.articulo = new.articulo
                           and exists 
                           (select * from eys1 where almacen = eys6.almacen 
                           and no_transaccion = eys6.no_transaccion and fecha <= r_eys1.fecha)
                    GROUP BY eys1.almacen,   
                             eys1.fecha,   
                             eys6.articulo,   
                             eys6.compra_no_transaccion,   
                             eys6.compra_linea  
                    ORDER BY eys1.fecha ASC
        loop
            if r_compras.saldo > 0 then
                if r_compras.saldo >= ldc_cantidad then
                   ldc_cantidad_eys6 := ldc_cantidad;
                   ldc_cantidad := 0;
                else
                   ldc_cantidad_eys6 := r_compras.saldo;
                   ldc_cantidad := ldc_cantidad - r_compras.saldo;
                end if;
        
                if ldc_cantidad_eys6 <> 0 then
                    insert into eys6 (articulo, almacen, no_transaccion, linea, compra_no_transaccion,
                        compra_linea, cantidad)
                    values (new.articulo, new.almacen, new.no_transaccion, new.linea, 
                        r_compras.compra_no_transaccion, r_compras.compra_linea, -ldc_cantidad_eys6);
                end if;
                if ldc_cantidad <= 0 then
                   exit;
                end if;
            end if;
        end loop;
    else
        insert into eys6 (articulo, almacen, no_transaccion, linea, compra_no_transaccion,
            compra_linea, cantidad)
        values (new.articulo, new.almacen, new.no_transaccion, new.linea, 
            new.no_transaccion, new.linea, new.cantidad);
    end if;
    
    return new;
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
    r_articulos record;
    r_eys2 record;
    li_year integer;
    li_periodo integer;
    ldc_existencia1 decimal(12,4);
    ldc_existencia2 decimal(12,4);
    ldc_costo1 decimal(12,4);
    ldc_costo2 decimal(12,4);
    ldc_retornar decimal(12,4);
    ldc_costo decimal(12,4);
    ldc_cantidad decimal(12,4);
begin
    stock := 0;
    select into r_articulos * from articulos
    where articulos.articulo = as_articulo;
    if r_articulos.servicio = ''S'' then
       return 0;
    end if;
        
    select Max(final) into ld_ultimo_cierre from gralperiodos, almacen
    where almacen.compania = gralperiodos.compania
    and almacen.almacen = as_almacen
    and aplicacion = ''INV'' 
    and estado = ''I''
    and final < ad_fecha;

    if ld_ultimo_cierre is null then
        ld_ultimo_cierre := ''1960-01-01'';
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

    select existencia, costo into ldc_existencia1, ldc_costo1 from invbalance
    where almacen = as_almacen
    and articulo = as_articulo
    and year = li_year
    and periodo = li_periodo;
    if ldc_existencia1 is null then
        ldc_existencia1 := 0;
    end if;
    
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
        select sum(eys2.cantidad * invmotivos.signo), sum(eys2.costo * invmotivos.signo) 
        into ldc_existencia2, ldc_costo2 from eys1, eys2, invmotivos
        where eys1.almacen = eys2.almacen
        and eys1.no_transaccion = eys2.no_transaccion
        and eys1.motivo = invmotivos.motivo
        and eys1.almacen = as_almacen
        and eys2.articulo = as_articulo
        and eys1.fecha > ld_ultimo_cierre
        and eys1.fecha <= ad_fecha;
    end if;


    
    if ldc_existencia2 is null then
        ldc_existencia2 := 0;
    end if;
    
    if ldc_costo2 is null then
        ldc_costo2 := 0;
    end if;
    ldc_retornar := 0;
    if as_retornar = ''CU'' then
       if r_articulos.valorizacion = ''F'' or r_articulos.valorizacion = ''L'' then
          ldc_retornar := 0;
       else
          ldc_retornar := ldc_existencia1 + ldc_existencia2;
          if ldc_retornar = 0 then
             ldc_retornar := 0;
          else
             ldc_retornar := (ldc_costo1 + ldc_costo2) / ldc_retornar;
          end if;
       end if;
    else
        if as_retornar = ''COSTO'' then
            ldc_retornar := ldc_costo1 + ldc_costo2;
        else
            ldc_retornar := ldc_existencia1 + ldc_existencia2;
        end if;
    end if;
    
    return ldc_retornar;
end;
' language plpgsql;




create function f_cos_produccion_eys2_delete() returns trigger as '
begin
    delete from eys2
    where articulo = old.articulo
    and almacen = old.almacen
    and no_transaccion = old.no_transaccion
    and linea = old.eys2_linea;
    return old;
end;
' language plpgsql;


create function f_cos_consumo_eys2_delete() returns trigger as '
begin
    delete from eys2
    where articulo = old.articulo
    and almacen = old.almacen
    and no_transaccion = old.no_transaccion
    and linea = old.eys2_linea;
    return old;
end;
' language plpgsql;


create function f_eys4_delete() returns trigger as '
begin
    delete from eys2
    where articulo = old.articulo
    and almacen = old.almacen
    and no_transaccion = old.no_transaccion
    and linea = old.inv_linea;
    return old;
end;
' language plpgsql;



create function f_factura2_eys2_delete() returns trigger as '
begin
    delete from eys2
    where articulo = old.articulo
    and almacen = old.almacen
    and no_transaccion = old.no_transaccion
    and linea = old.eys2_linea;
    return old;
end;
' language plpgsql;


create trigger t_factura2_eys2_delete after delete on factura2_eys2 
for each row execute procedure f_factura2_eys2_delete();

create trigger t_eys4_delete after delete on eys4
for each row execute procedure f_eys4_delete();

create trigger t_cos_consumo_eys2_delete after delete on cos_consumo_eys2
for each row execute procedure f_cos_consumo_eys2_delete();

create trigger t_cos_produccion_eys2_delete after delete on cos_produccion_eys2
for each row execute procedure f_cos_produccion_eys2_delete();

create trigger t_eys2_delete after delete on eys2
for each row execute procedure f_eys2_delete();

create trigger t_eys2_update after update on eys2
for each row execute procedure f_eys2_update();

create trigger t_eys2_insert after insert on eys2
for each row execute procedure f_eys2_insert();

create trigger t_rela_eys1_cglposteo_delete after delete on rela_eys1_cglposteo
for each row execute procedure f_rela_eys1_cglposteo_delete();

create trigger t_eys2_eys6 after insert or update on eys2
for each row execute procedure f_eys2_eys6();

create trigger t_inv_fisico2_after_update after insert or update on inv_fisico2
for each row execute procedure f_inv_fisico2_after_update();

drop function f_rela_nomctrac_cglposteo_delete() cascade;
drop function f_rela_pla_reservas_cglposteo_delete() cascade;
drop function f_nomctrac_cglposteo(char(2), char(7), char(2), char(2), int4, int4) cascade;
drop function f_rhuempl_update() cascade;
drop function f_nomctrac_update() cascade;
drop function f_pla_reservas_update() cascade;
drop function f_pla_reservas_cglposteo(char(7), char(2), char(2), char(3), char(2), int4, int4, char(30), char(3));
drop function f_nomctrac_pla_reservas(char(2), char(7), char(2), char(2), int4, int4, char(30), char(3));


create function f_nomctrac_pla_reservas(char(2), char(7), char(2), char(2), int4, int4, char(30), char(3)) returns integer as '
declare
    as_compania alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_calculo alias for $3;
    as_tipo_planilla alias for $4;
    ai_numero_planilla alias for $5;
    ai_year alias for $6;
    as_numero_documento alias for $7;
    as_cod_concepto_planilla alias for $8;
    r_nomconce record;
    r_nomctrac record;
    ldc_reserva decimal(10,2);
    li_signo integer;
    ls_rp char(20);
    ldc_porcentaje decimal(15,5);
begin
    delete from pla_reservas
    where codigo_empleado = as_codigo_empleado
    and compania = as_compania
    and tipo_calculo = as_tipo_calculo
    and cod_concepto_planilla = as_cod_concepto_planilla
    and tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and year = ai_year
    and numero_documento = as_numero_documento;
    
    select into r_nomctrac * from nomctrac
    where codigo_empleado = as_codigo_empleado
    and compania = as_compania
    and tipo_calculo = as_tipo_calculo
    and cod_concepto_planilla = as_cod_concepto_planilla
    and tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and year = ai_year
    and numero_documento = as_numero_documento;
    
    select into li_signo signo from nomconce
    where cod_concepto_planilla = as_cod_concepto_planilla;
    
    ls_rp := Trim(f_gralparaxapli(''PLA'', ''rp''));
    
    
    for r_nomconce in select nomconce.* from nomconce, nom_conceptos_para_calculo
                        where nomconce.cod_concepto_planilla = nom_conceptos_para_calculo.cod_concepto_planilla
                        and nomconce.solo_patrono = ''S'' and nomconce.porcentaje > 0
                        and nom_conceptos_para_calculo.concepto_aplica = as_cod_concepto_planilla
                        and nomconce.tipodeconcepto = ''R''
    loop
        
        if trim(ls_rp) = trim(r_nomconce.cod_concepto_planilla) then
            ldc_porcentaje := f_gralparaxcia(as_compania, ''PLA'', ''porcentaje_rp'');
        else
            ldc_porcentaje := r_nomconce.porcentaje;
        end if;
            
        ldc_reserva := (r_nomctrac.monto*li_signo) * (ldc_porcentaje/100);
        
        insert into pla_reservas (codigo_empleado, compania, tipo_calculo, cod_concepto_planilla,
            tipo_planilla, numero_planilla, year, numero_documento, concepto_reserva, monto)
        values (as_codigo_empleado, as_compania, as_tipo_calculo, as_cod_concepto_planilla,
            as_tipo_planilla, ai_numero_planilla, ai_year, as_numero_documento, 
            r_nomconce.cod_concepto_planilla, ldc_reserva);
    end loop;
    return 1;
end;
' language plpgsql;


create function f_pla_reservas_cglposteo(char(7), char(2), char(2), char(3), char(2), int4, int4, char(30), char(3)) returns integer as '
declare
    as_codigo_empleado alias for $1;
    as_compania alias for $2;
    as_tipo_calculo alias for $3;
    as_cod_concepto_planilla alias for $4;
    as_tipo_planilla alias for $5;
    ai_numero_planilla alias for $6;
    ai_year alias for $7;
    as_numero_documento alias for $8;
    as_concepto_reserva alias for $9;
    li_consecutivo int4;
    ls_tipo_de_comprobante char(3);
    ls_cta_pte_planilla char(24);
    ls_descripcion text;
    r_rhuempl record;
    r_pla_afectacion_contable record;
    r_nomtpla2 record;
    ldc_monto decimal(10,2);
    r_nomconce record;
    ls_auxiliar char(10);
    r_nomacrem record;
    r_cglcuentas record;
    r_pla_reservas record;
    i integer;
    li_signo integer;
begin
    delete from rela_pla_reservas_cglposteo
    where codigo_empleado = as_codigo_empleado
    and compania = as_compania
    and tipo_calculo = as_tipo_calculo
    and cod_concepto_planilla = as_cod_concepto_planilla
    and tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and year = ai_year
    and numero_documento = as_numero_documento
    and concepto_reserva = as_concepto_reserva;
    

    select into r_pla_reservas * from pla_reservas
    where codigo_empleado = as_codigo_empleado
    and compania = as_compania
    and tipo_calculo = as_tipo_calculo
    and cod_concepto_planilla = as_cod_concepto_planilla
    and tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and year = ai_year
    and numero_documento = as_numero_documento
    and concepto_reserva = as_concepto_reserva;
    if not found then
       return 0;
    end if;

    ls_tipo_de_comprobante := f_gralparaxcia(as_compania, ''PLA'', ''tipo_d_comprobante'');
    
    
    select into r_nomtpla2 * from nomtpla2
    where tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and year = ai_year;
    
    select into r_rhuempl * from rhuempl
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado;
    
    ls_descripcion := r_rhuempl.nombre_del_empleado;
    ldc_monto := 0;
    
    select into i count(*) from pla_afectacion_contable
    where departamento = r_rhuempl.departamento
    and cod_concepto_planilla = as_concepto_reserva;
    if not found or i <= 1 then
        Raise Exception ''Empleado % no tiene afectacion contable en el departamento % y el concepto de reserva %'',as_codigo_empleado,
            r_rhuempl.departamento, as_concepto_reserva;
    end if;

    
    li_signo := -1;
    for r_pla_afectacion_contable in select * from pla_afectacion_contable
                        where departamento = r_rhuempl.departamento
                        and cod_concepto_planilla = as_concepto_reserva
                        order by cuenta
    loop
        select into r_nomconce * from nomconce
        where cod_concepto_planilla = as_concepto_reserva;
        
        li_consecutivo := f_cglposteo(as_compania, ''PLA'', r_nomtpla2.dia_d_pago,
                            r_pla_afectacion_contable.cuenta, null, null,
                            ls_tipo_de_comprobante, ls_descripcion,
                            (r_pla_reservas.monto*li_signo));
        if li_consecutivo > 0 then
           insert into rela_pla_reservas_cglposteo(codigo_empleado, compania, tipo_calculo,
            cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento,
            concepto_reserva, consecutivo)
           values (as_codigo_empleado, as_compania, as_tipo_calculo, 
            as_cod_concepto_planilla, as_tipo_planilla, ai_numero_planilla, 
            ai_year, as_numero_documento, as_concepto_reserva, li_consecutivo);
        end if;
        li_signo := li_signo * -1;
    end loop;

    
    return 1;
end;
' language plpgsql;



create function f_nomctrac_update() returns trigger as '
declare
    i integer;
begin
/*
    i := f_nomctrac_pla_reservas(new.compania, new.codigo_empleado, new.tipo_calculo,
            new.tipo_planilla, new.numero_planilla, new.year, new.numero_documento,
            new.cod_concepto_planilla);
*/            
    return new;
end;
' language plpgsql;



create function f_nomctrac_cglposteo(char(2), char(7), char(2), char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_calculo alias for $3;
    as_tipo_planilla alias for $4;
    ai_numero_planilla alias for $5;
    ai_year alias for $6;
    li_consecutivo int4;
    r_nomctrac record;
    ls_tipo_de_comprobante char(3);
    ls_cta_pte_planilla char(24);
    ls_descripcion text;
    r_rhuempl record;
    r_pla_afectacion_contable record;
    r_nomtpla2 record;
    ldc_monto decimal(10,2);
    r_nomconce record;
    ls_auxiliar char(10);
    r_nomacrem record;
    r_cglcuentas record;
begin
    select into ldc_monto sum(nomctrac.monto*nomconce.signo) from nomctrac, nomconce
    where nomctrac.cod_concepto_planilla = nomconce.cod_concepto_planilla
    and nomctrac.compania = as_compania
    and nomctrac.codigo_empleado = as_codigo_empleado
    and nomctrac.tipo_calculo = as_tipo_calculo
    and nomctrac.tipo_planilla = as_tipo_planilla
    and nomctrac.numero_planilla = ai_numero_planilla
    and nomctrac.year = ai_year
    and nomctrac.no_cheque is null;
    if not found or ldc_monto = 0 then
       return 0;
    end if;

    ls_tipo_de_comprobante := f_gralparaxcia(as_compania, ''PLA'', ''tipo_d_comprobante'');
    ls_cta_pte_planilla := f_gralparaxcia(as_compania, ''PLA'', ''cta_pte_planilla'');
    
    delete from rela_nomctrac_cglposteo
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado
    and tipo_calculo = as_tipo_calculo
    and tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and year = ai_year;
    
    select into r_nomtpla2 * from nomtpla2
    where tipo_planilla = as_tipo_planilla
    and numero_planilla = ai_numero_planilla
    and year = ai_year;
    
    select into r_rhuempl * from rhuempl
    where compania = as_compania
    and codigo_empleado = as_codigo_empleado;
    
    ls_descripcion := r_rhuempl.nombre_del_empleado;
    ldc_monto := 0;
    
        
    for r_nomctrac in select * from nomctrac
                        where compania = as_compania
                        and codigo_empleado = as_codigo_empleado
                        and tipo_calculo = as_tipo_calculo
                        and tipo_planilla = as_tipo_planilla
                        and numero_planilla = ai_numero_planilla
                        and year = ai_year
                        and monto <> 0
                        and no_cheque is null
    loop
        select into r_pla_afectacion_contable * from pla_afectacion_contable
        where departamento = r_rhuempl.departamento
        and cod_concepto_planilla = r_nomctrac.cod_concepto_planilla;
        if not found then
            Raise Exception ''Empleado % no tiene afectacion contable en el departamento % y el concepto %'',as_codigo_empleado,
                r_rhuempl.departamento, r_nomctrac.cod_concepto_planilla;
        end if;
        
        select into r_nomconce * from nomconce
        where cod_concepto_planilla = r_nomctrac.cod_concepto_planilla;
        if not found or r_nomctrac.cod_concepto_planilla is null then
            Raise Exception ''Empleado %, Tipo calculo %, Tipo de Planilla %, Numero de Planilla % no existe concepto %'',as_codigo_empleado,
                as_tipo_calculo, as_tipo_planilla, ai_numero_planilla, r_nomctrac.cod_concepto_planilla;
        end if;        
        ls_auxiliar := null;
        select into r_cglcuentas * from cglcuentas
        where cuenta = r_pla_afectacion_contable.cuenta and auxiliar_1 = ''S'';
        if found then
           select into r_nomacrem nomacrem.* from nomdescuentos, nomacrem
           where nomacrem.numero_documento = nomdescuentos.numero_documento
           and nomacrem.codigo_empleado = nomdescuentos.codigo_empleado
           and nomacrem.cod_concepto_planilla = nomdescuentos.cod_concepto_planilla
           and nomacrem.compania = nomdescuentos.compania
           and nomdescuentos.compania = as_compania
           and nomdescuentos.codigo_empleado = as_codigo_empleado
           and nomdescuentos.tipo_calculo = as_tipo_calculo
           and nomdescuentos.tipo_planilla = as_tipo_planilla
           and nomdescuentos.numero_planilla = ai_numero_planilla
           and nomdescuentos.year = ai_year
           and nomdescuentos.numero_documento = r_nomctrac.numero_documento;
           if found then
            if r_nomacrem.hacer_cheque = ''S'' then
                ls_auxiliar := r_nomacrem.cod_acreedores;
              else
                ls_auxiliar := as_codigo_empleado;
              end if;
           else
               ls_auxiliar := as_codigo_empleado;
           end if;
        end if;
        ldc_monto := ldc_monto + (r_nomctrac.monto * r_nomconce.signo);
        
        li_consecutivo := f_cglposteo(as_compania, ''PLA'', r_nomtpla2.dia_d_pago,
                            r_pla_afectacion_contable.cuenta, ls_auxiliar, null,
                            ls_tipo_de_comprobante, ls_descripcion,
                            (r_nomctrac.monto*r_nomconce.signo));
        if li_consecutivo > 0 then
           insert into rela_nomctrac_cglposteo (codigo_empleado, compania, tipo_calculo,
            cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento,
            consecutivo)
           values (as_codigo_empleado, as_compania, as_tipo_calculo, 
            r_nomctrac.cod_concepto_planilla, as_tipo_planilla, ai_numero_planilla, 
            ai_year, r_nomctrac.numero_documento, li_consecutivo);
        end if;
        
    end loop;
    
    li_consecutivo := f_cglposteo(as_compania, ''PLA'', r_nomtpla2.dia_d_pago,
                        ls_cta_pte_planilla, null, null,
                        ls_tipo_de_comprobante, ls_descripcion, -ldc_monto);
    if li_consecutivo > 0 then
       insert into rela_nomctrac_cglposteo (codigo_empleado, compania, tipo_calculo,
        cod_concepto_planilla, tipo_planilla, numero_planilla, year, numero_documento,
        consecutivo)
       values (as_codigo_empleado, as_compania, as_tipo_calculo, 
       r_nomctrac.cod_concepto_planilla, as_tipo_planilla, ai_numero_planilla, 
       ai_year, r_nomctrac.numero_documento, li_consecutivo);
    end if;

    return 1;
end;
' language plpgsql;

create function f_rela_pla_reservas_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;

create function f_pla_reservas_update() returns trigger as '
declare
    i   integer;
begin
/*
    i := f_pla_reservas_cglposteo(new.codigo_empleado, new.compania, new.tipo_calculo, 
            new.cod_concepto_planilla, new.tipo_planilla, new.numero_planilla,
            new.year, new.numero_documento, new.concepto_reserva);
*/    
    return new;
end;
' language plpgsql;




create function f_rela_nomctrac_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;

create function f_rhuempl_update() returns trigger as '
declare
    r_cglauxilares record;
begin
    select into r_cglauxilares * from cglauxiliares
    where trim(auxiliar) = trim(new.codigo_empleado);
    if not found then
        insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
        values (trim(new.codigo_empleado), substring(new.nombre_del_empleado from 1 for 30), ''1'', ''A'');
    else
        update cglauxiliares
        set nombre = substring(trim(new.nombre_del_empleado) from 1 for 30)
        where trim(auxiliar) = trim(new.codigo_empleado);
    end if;
    return new;
end;
' language plpgsql;





/*create function f_nomtpla2_update() returns trigger as '
declare
    i integer;
begin
    delete from rela_nomctrac_cglposteo
    where tipo_planilla = new.tipo_planilla 
    and numero_planilla = new.numero_planilla
    and year = new.year;
    
    if trim(new.status) = ''C'' then
        select into i f_nomctrac_cglposteo(compania, codigo_empleado, tipo_calculo,
            tipo_planilla, numero_planilla, year)
        from nomctrac
        where tipo_planilla = new.tipo_planilla
        and numero_planilla = new.numero_planilla
        and year = new.year
        and no_cheque is null
        group by compania, codigo_empleado, tipo_calculo, tipo_planilla, numero_planilla, year;
    end if;

    return new;
end;
' language plpgsql;


create trigger t_nomtpla2_update after update on nomtpla2
for each row execute procedure f_nomtpla2_update();
*/


create trigger t_rela_nomctrac_cglposteo_delete after delete on rela_nomctrac_cglposteo
for each row execute procedure f_rela_nomctrac_cglposteo_delete();

create trigger t_rhuempl_update after insert or update on rhuempl
for each row execute procedure f_rhuempl_update();

create trigger t_nomctrac_update after insert or update on nomctrac
for each row execute procedure f_nomctrac_update();

create trigger t_rela_pla_reservas_cglposteo_delete after delete on rela_pla_reservas_cglposteo
for each row execute procedure f_rela_pla_reservas_cglposteo_delete();

create trigger t_pla_reservas_update after insert or update on pla_reservas
for each row execute procedure f_pla_reservas_update();

drop function f_stock(char(2), char(15), date, int4, int4, text);
drop function f_tal_ot2_eys2_delete() cascade;
drop function f_tal_ot2_update() cascade;
drop function f_tal_ot2_inventario(char(2), int, char(1), int, char(15));


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
    r_oc2 record;
    r_eys1 record;
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
        
    delete from tal_ot2_eys2
    where no_orden = ai_no_orden
    and tipo = as_tipo
    and almacen = as_almacen
    and linea_tal_ot2 = ai_linea
    and articulo = as_articulo;
    
    delete from eys1
    where aplicacion_origen = ''TAL''
    and not exists
        (select * from eys2
            where eys2.almacen = eys1.almacen
            and eys2.no_transaccion = eys1.no_transaccion);
    
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
        ldc_cu  :=  r_oc2.costo / r_oc2.cantidad;
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
        
        
        
    select into ls_cuenta_costo fac_parametros_contables.cta_de_costo
    from articulos_agrupados, fac_parametros_contables
    where articulos_agrupados.codigo_valor_grupo = fac_parametros_contables.codigo_valor_grupo
    and articulos_agrupados.articulo = r_tal_ot2.articulo
    and fac_parametros_contables.almacen = r_tal_ot2.almacen
    and fac_parametros_contables.referencia = ''1'';
    if Not Found or ls_cuenta_costo is null then
        raise exception ''No existe cuenta de costo para el articulo % en la orden %'', r_tal_ot2.articulo, r_tal_ot2.no_orden;
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



create function f_tal_ot2_eys2_delete() returns trigger as '
begin
    delete from eys2
    where articulo = old.articulo
    and almacen = old.almacen
    and no_transaccion = old.no_transaccion
    and linea = old.linea_eys2;
    return old;
end;
' language plpgsql;

create function f_tal_ot2_update() returns trigger as '
declare
    i integer;
begin
    delete from tal_ot2_eys2
    where no_orden = old.no_orden
    and tipo = old.tipo
    and almacen = old.almacen
    and linea_tal_ot2 = old.linea
    and articulo =old.articulo;
    
    if new.despachar = ''S'' then
        i := f_tal_ot2_inventario(new.almacen, new.no_orden, new.tipo, new.linea, new.articulo);
    end if;
    
    return old;
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

create trigger t_tal_ot2_eys2_delete after delete on tal_ot2_eys2
for each row execute procedure f_tal_ot2_eys2_delete();

create trigger t_tal_ot2_update after update on tal_ot2
for each row execute procedure f_tal_ot2_update();


drop function f_eys1_cglposteo(char(2), int4) cascade;
drop function f_rela_eys1_cglposteo_delete() cascade;
drop function f_factura2_eys2_delete() cascade;
drop function f_eys4_delete() cascade;
drop function f_cos_consumo_eys2_delete() cascade;
drop function f_cos_produccion_eys2_delete() cascade;
drop function f_eys2_eys6() cascade;
drop function f_costos_inventario(char(2), int4) cascade;
drop function f_costos_inventario_fifo(char(2), int4) cascade;
drop function f_eys1_poner_cuentas(char(2), int4) cascade;
drop function f_eys2_insert() cascade;
drop function f_eys2_delete() cascade;
drop function f_eys2_update() cascade;
drop function f_factura_inventario(char(2), char(3), integer) cascade;
drop function f_update_existencias(char(2), char(15)) cascade;
drop function f_compras_inventario(char(2), char(6), char(25)) cascade;
drop function f_sec_inventario(char(2)) cascade;
drop function f_stock(char(2), char(15), date, int4, int4, text) cascade;
drop function f_inv_fisico2_after_update() cascade;
drop function f_eys4_after_delete() cascade;


create function f_eys4_after_delete() returns trigger as '
begin
    delete from eys2
    where articulo = old.articulo
    and almacen = old.almacen
    and no_transaccion = old.no_transaccion
    and linea = old.inv_linea;
    return old;
end;
' language plpgsql;


create function f_inv_fisico2_after_update() returns trigger as '
begin
    if new.ubicacion is not null then
        update articulos_por_almacen
        set ubicacion = new.ubicacion
        where almacen = new.almacen
        and articulo = new.articulo;
    end if;
    return new;
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
    set valor = ls_valor
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
    
    delete from rela_eys1_cglposteo
    where almacen = as_almacen
    and no_transaccion = ai_no_transaccion;
    
    select into r_invmotivos * from invmotivos
    where motivo = r_eys1.motivo;
    if r_invmotivos.costo = ''N'' then
        return 0;
    end if;
    
    for r_work in select almacen.compania, articulos_por_almacen.cuenta, sum(eys2.costo) as monto
                    from eys2, articulos_por_almacen, almacen
                    where eys2.almacen = almacen.almacen
                    and eys2.almacen = articulos_por_almacen.almacen
                    and eys2.articulo = articulos_por_almacen.articulo
                    and eys2.almacen = as_almacen
                    and eys2.no_transaccion = ai_no_transaccion
                    group by 1, 2
                    order by 1, 2
    loop
        if r_eys1.observacion is null then
           r_eys1.observacion := ''ALMACEN  '' || trim(r_eys1.almacen) || ''   TRANSACCION #  '' || ai_no_transaccion;
        else
           r_eys1.observacion := ''ALMACEN  '' || trim(r_eys1.almacen) || ''   TRANSACCION #  '' || ai_no_transaccion || ''  ''  || r_eys1.observacion;
        end if;
        li_consecutivo := f_cglposteo(r_work.compania, r_eys1.aplicacion_origen, r_eys1.fecha, r_work.cuenta,
                            null, null, r_invmotivos.tipo_comp, r_eys1.observacion, 
                            (r_work.monto*r_invmotivos.signo));
        if li_consecutivo > 0 then
           insert into rela_eys1_cglposteo (consecutivo, almacen, no_transaccion)
           values (li_consecutivo, as_almacen, ai_no_transaccion);
        end if;
    end loop;
    
    for r_work in select almacen.compania, eys3.cuenta, eys3.auxiliar1, sum(eys3.monto) as monto
                    from eys3, almacen
                    where eys3.almacen = almacen.almacen
                    and eys3.almacen = as_almacen
                    and eys3.no_transaccion = ai_no_transaccion
                    group by 1, 2, 3
                    order by 1, 2, 3
    loop
        li_consecutivo := f_cglposteo(r_work.compania, r_eys1.aplicacion_origen, r_eys1.fecha, 
                            r_work.cuenta, r_work.auxiliar1, null, r_invmotivos.tipo_comp, 
                            r_eys1.observacion, -(r_work.monto*r_invmotivos.signo));
        if li_consecutivo > 0 then
           insert into rela_eys1_cglposteo (consecutivo, almacen, no_transaccion)
           values (li_consecutivo, as_almacen, ai_no_transaccion);
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;


create function f_rela_eys1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
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
    
    select into r_eys1 eys1.* from eys1, eys4
    where eys1.no_transaccion = eys4.no_transaccion
    and eys1.almacen = eys4.almacen
    and eys4.compania = as_compania
    and eys4.proveedor = as_proveedor
    and eys4.fact_proveedor = as_fact_proveedor;
    if not found then
       return 0;
    end if;
    
    if r_eys1.status = ''P'' then
       return 0;
    end if;
    
    for r_eys2 in select eys2.* from eys2, articulos, eys4
                        where eys2.articulo = articulos.articulo
                        and eys2.articulo = eys4.articulo
                        and eys2.almacen = eys4.almacen
                        and eys2.no_transaccion = eys4.no_transaccion
                        and eys2.linea = eys4.inv_linea
                        and articulos.servicio = ''N''
                        and articulos.valorizacion in (''F'', ''L'')
                        and eys4.compania = as_compania
                        and eys4.proveedor = as_proveedor
                        and eys4.fact_proveedor = as_fact_proveedor
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



create function f_eys2_insert() returns trigger as '
declare
    i integer;
begin
    i := f_update_existencias(new.almacen, new.articulo);
    return new;
end;
' language plpgsql;


create function f_eys2_delete() returns trigger as '
declare
    i integer;
begin
    i := f_update_existencias(old.almacen, old.articulo);
    return new;
end;
' language plpgsql;

create function f_eys2_update() returns trigger as '
declare
    i integer;
begin
    if old.articulo = new.articulo then
       i := f_update_existencias(new.almacen, new.articulo);
    else
       i := f_update_existencias(old.almacen, old.articulo);
       i := f_update_existencias(new.almacen, new.articulo);
    end if;
       
    return new;
end;
' language plpgsql;



create function f_update_existencias(char(2), char(15)) returns integer as '
declare
    ldc_existencia decimal(12,4);
    ldc_costo decimal(12,4);
begin
    ldc_existencia := f_stock($1, $2, ''2300-01-01'', 0, 0, ''STOCK'');
    ldc_costo := f_stock($1, $2, ''2300-01-01'', 0, 0, ''COSTO'');

    update articulos_por_almacen
    set existencia = ldc_existencia, costo = ldc_costo
    where articulos_por_almacen.almacen = $1
    and articulos_por_almacen.articulo = $2;
    
    return 1;
end;
' language plpgsql;


create function f_factura_inventario(char(2), char(3), integer) returns integer as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    r_factmotivos record;
    r_factura1 record;
    r_factura2 record;
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
begin

    update factura1
    set documento = trim(to_char(num_documento, ''9999999999999999'')), aplicacion = ''FAC''
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    
    delete from factura2_eys2
    where almacen = as_almacen
    and tipo = as_tipo
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
    
    select into r_eys2 eys2.* from factura2_eys2, eys1
    where factura2_eys2.almacen = eys1.almacen
    and factura2_eys2.no_transaccion = eys1.no_transaccion
    and factura2_eys2.almacen = as_almacen
    and factura2_eys2.tipo = as_tipo
    and factura2_eys2.num_documento = ai_num_documento
    and eys1.status = ''P'';
    if found then
       return 0;
    end if;
    
    
    select into r_factura1 * from factura1
    where almacen = as_almacen
    and tipo = as_tipo
    and num_documento = ai_num_documento;
    
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
       r_eys1.almacen             :=  as_almacen;
       r_eys1.no_transaccion      :=  f_sec_inventario(as_almacen); 
       r_eys1.motivo              :=  r_factmotivos.motivo;
       r_eys1.aplicacion_origen   :=  ''FAC'';
       r_eys1.usuario             :=  ''dba'';
       r_eys1.fecha_captura       :=  Today();
       r_eys1.status              :=  ''R'';
       r_eys1.fecha               :=  r_factura1.fecha_despacho;
       
        INSERT INTO eys1 ( almacen, no_transaccion, motivo, aplicacion_origen, 
        fecha, usuario, fecha_captura, status ) 
        VALUES ( r_eys1.almacen, r_eys1.no_transaccion, r_eys1.motivo, ''FAC'', 
        r_eys1.fecha, current_user, current_timestamp, ''R'');

    end if;
    

    
    for r_factura2 in select factura2.* from factura2, articulos 
                        where factura2.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and factura2.almacen = as_almacen 
                        and factura2.tipo = as_tipo 
                        and factura2.num_documento = ai_num_documento
    loop
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
            and factura2.num_documento = r_factura1.num_factura;
            if not found then
                ldc_cu  :=  f_stock(r_factura2.almacen, r_factura2.articulo, r_factura1.fecha_factura, 0, 0, ''CU'');
            end if;
        else
              ldc_cu  :=   f_stock(r_factura2.almacen, r_factura2.articulo,r_factura1.fecha_factura, 0, 0, ''CU'');
        end if;
        
        select into li_linea max(eys2.linea) from eys2
        where almacen = r_eys1.almacen
        and no_transaccion = r_eys1.no_transaccion;
        if li_linea is null then
            li_linea := 1;
        else
            li_linea := li_linea + 1;
        end if;
        
--        raise exception ''costo %'', ldc_cu;
        if ldc_cu is null then
            raise exception ''costo unitario no puede ser nulo...documento %'', ai_num_documento;
        end if;
        
        INSERT INTO eys2 ( articulo, almacen, no_transaccion, linea, cantidad, costo ) 
        VALUES (r_factura2.articulo, r_factura2.almacen, r_eys1.no_transaccion,
        li_linea, r_factura2.cantidad, (ldc_cu * r_factura2.cantidad));
        
        
        insert into factura2_eys2 (articulo, almacen, no_transaccion, eys2_linea,
        tipo, num_documento, factura2_linea)
        values (r_factura2.articulo, r_factura2.almacen, r_eys1.no_transaccion,
        li_linea, r_factura2.tipo, r_factura2.num_documento, r_factura2.linea);
        
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
        
        
    end  loop;
        
    return 1;
end;
' language plpgsql;


create function f_costos_inventario(char(2), int4) returns integer as '
declare
    as_compania alias for $1;
    ai_secuencia alias for $2;
    r_cos_produccion record;
    r_cos_consumo record;
    r_invmotivos record;
    r_cos_trx record;
    r_eys1 record;
    r_eys2 record;
    r_eys6 record;
    ls_tdt_consumo char(2);
    ls_tdt_produccion char(2);
    li_work integer;
    li_linea integer;
    ls_work text;
    ldc_cu decimal(12,4);
    r_cos_consumo_eys2 record;
begin
    select into r_cos_trx * from cos_trx
    where compania = as_compania and secuencia = ai_secuencia;
    
    select into li_work count(*) from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and final >= r_cos_trx.fecha
    and estado = ''I'';
    if li_work is null or li_work > 0 then
       return 0;
    end if;
    
    select into ls_work trim(valor) from gralparaxapli
    where aplicacion = ''INV'' and parametro = ''tdt_consumo'';
    if not found then
       raise exception ''no existe valor para parametro tdt_consumo a nivel de aplicacion'';
    end if;
    ls_tdt_consumo := trim(ls_work);
    
    
    select into ls_work trim(valor) from gralparaxapli
    where aplicacion = ''INV'' and parametro = ''tdt_produccion'';
    if not found then
       raise exception ''no existe valor para parametro tdt_produccion a nivel de aplicacion'';
    end if;
    ls_tdt_produccion := trim(ls_work);
    
    select into r_invmotivos * from invmotivos
    where motivo = ls_tdt_consumo;
    if not found then
       raise exception ''tipo de transaccion para consumo no existe en invmotivos %'', ls_tdt_consumo;
    end if;
    
--    raise exception ''llegue %'',r_cos_trx.fecha;
    
    select into r_invmotivos * from invmotivos
    where motivo = ls_tdt_produccion;
    if not found then
       raise exception ''tipo de transaccion para produccion no existe en invmotivos %'', ls_tdt_consumo;
    end if;
    
    delete from cos_consumo_eys2
    where compania = as_compania
    and secuencia = ai_secuencia;
    
    delete from cos_produccion_eys2
    where compania = as_compania
    and secuencia = ai_secuencia;

    for r_cos_consumo in select cos_consumo.* from cos_consumo, articulos 
                        where cos_consumo.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and cos_consumo.compania = as_compania
                        and cos_consumo.secuencia = ai_secuencia
    loop
        select into r_eys1 eys1.* from eys1
        where almacen = r_cos_consumo.almacen
        and motivo = ls_tdt_consumo
        and aplicacion_origen = ''COS''
        and fecha = r_cos_trx.fecha;
        if not found then
           r_eys1.almacen             :=  r_cos_consumo.almacen;
           r_eys1.no_transaccion      :=  f_sec_inventario(r_cos_consumo.almacen); 
           r_eys1.motivo              :=  ls_tdt_consumo;
           r_eys1.aplicacion_origen   :=  ''COS'';
           r_eys1.usuario             :=  current_user;
           r_eys1.fecha_captura       :=  current_timestamp;
           r_eys1.observacion         :=  r_cos_trx.observacion;
           r_eys1.status              :=  ''R'';
           r_eys1.fecha               :=  r_cos_trx.fecha;
       
            INSERT INTO eys1 ( almacen, no_transaccion, motivo, aplicacion_origen, 
            fecha, usuario, fecha_captura, status, observacion ) 
            VALUES ( r_eys1.almacen, r_eys1.no_transaccion, r_eys1.motivo, ''COS'', 
            r_eys1.fecha, current_user, current_timestamp, ''R'', trim(r_eys1.observacion));
        end if;

              
        li_linea := 0;
        li_work := 0;
        while li_work = 0 loop
            li_linea := li_linea + 1;
            select into r_eys2 * from eys2
            where almacen = r_cos_consumo.almacen
            and no_transaccion = r_eys1.no_transaccion
            and linea = li_linea;
            if not found then
               li_work := 1;
            end if;
        end loop;
        
        ldc_cu  :=   f_stock(r_cos_consumo.almacen, r_cos_consumo.articulo, r_cos_trx.fecha, 0, 0, ''CU'');
        INSERT INTO eys2 ( articulo, almacen, no_transaccion, linea, cantidad, costo ) 
        VALUES (r_cos_consumo.articulo, r_cos_consumo.almacen, r_eys1.no_transaccion,
        li_linea, r_cos_consumo.cantidad, (ldc_cu * r_cos_consumo.cantidad));
        
        
        insert into cos_consumo_eys2 (secuencia, compania, linea, articulo, almacen,
            no_transaccion, eys2_linea)
        values (r_cos_trx.secuencia, r_cos_trx.compania, r_cos_consumo.linea,
            r_cos_consumo.articulo, r_cos_consumo.almacen, r_eys1.no_transaccion,
            li_linea);

        update eys1
        set    usuario = current_user,
               fecha_captura = current_timestamp
        where  almacen = r_cos_consumo.almacen
        and    no_transaccion = r_eys1.no_transaccion;
        
    end  loop;
    
    for r_cos_produccion in select cos_produccion.* from cos_produccion, articulos 
                        where cos_produccion.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and cos_produccion.compania = as_compania
                        and cos_produccion.secuencia = ai_secuencia
    loop
        select into r_eys1 eys1.* from eys1
        where almacen = r_cos_produccion.almacen
        and motivo = ls_tdt_produccion
        and aplicacion_origen = ''COS''
        and fecha = r_cos_trx.fecha;
        if not found then
           r_eys1.almacen             :=  r_cos_produccion.almacen;
           r_eys1.no_transaccion      :=  f_sec_inventario(r_cos_produccion.almacen); 
           r_eys1.motivo              :=  ls_tdt_produccion;
           r_eys1.aplicacion_origen   :=  ''COS'';
           r_eys1.usuario             :=  current_user;
           r_eys1.fecha_captura       :=  current_timestamp;
           r_eys1.observacion         :=  r_cos_trx.observacion;
           r_eys1.status              :=  ''R'';
           r_eys1.fecha               :=  r_cos_trx.fecha;
       
            INSERT INTO eys1 ( almacen, no_transaccion, motivo, aplicacion_origen, 
            fecha, usuario, fecha_captura, status, observacion ) 
            VALUES ( r_eys1.almacen, r_eys1.no_transaccion, r_eys1.motivo, ''COS'', 
            r_eys1.fecha, current_user, current_timestamp, ''R'', trim(r_eys1.observacion));
        end if;

              
        li_linea := 0;
        li_work := 0;
        while li_work = 0 loop
            li_linea := li_linea + 1;
            select into r_eys2 * from eys2
            where almacen = r_cos_produccion.almacen
            and no_transaccion = r_eys1.no_transaccion
            and linea = li_linea;
            if not found then
               li_work := 1;
            end if;
        end loop;
        
        ldc_cu := 0;        
        INSERT INTO eys2 ( articulo, almacen, no_transaccion, linea, cantidad, costo ) 
        VALUES (r_cos_produccion.articulo, r_cos_produccion.almacen, r_eys1.no_transaccion,
        li_linea, r_cos_produccion.cantidad, (ldc_cu * r_cos_produccion.cantidad));
        
        
        insert into cos_produccion_eys2 (secuencia, compania, linea, articulo, almacen,
            no_transaccion, eys2_linea)
        values (r_cos_trx.secuencia, r_cos_trx.compania, r_cos_produccion.linea,
            r_cos_produccion.articulo, r_cos_produccion.almacen, r_eys1.no_transaccion,
            li_linea);
            
            
            
        update eys1
        set    usuario = current_user,
               fecha_captura = current_timestamp
        where  almacen = r_cos_produccion.almacen
        and    no_transaccion = r_eys1.no_transaccion;
        
    end  loop;
    
    
        
    return 1;
end;
' language plpgsql;


create function f_costos_inventario_fifo(char(2), int4) returns integer as '
declare
    as_compania alias for $1;
    ai_secuencia alias for $2;
    r_cos_consumo_eys2 record;
    r_eys6 record;
    r_eys2 record;
    r_articulos record;
    i integer;
    ldc_costo decimal(12,2);
begin
    for r_cos_consumo_eys2 in select cos_consumo_eys2.* from cos_consumo_eys2, articulos 
                        where cos_consumo_eys2.articulo = articulos.articulo
                        and articulos.servicio = ''N''
                        and cos_consumo_eys2.compania = as_compania
                        and cos_consumo_eys2.secuencia = ai_secuencia
    loop
        select into r_articulos * from articulos
        where articulo = r_cos_consumo_eys2.articulo;
        if r_articulos.valorizacion = ''L'' or r_articulos.valorizacion = ''F'' then
            ldc_costo := 0;
            for r_eys6 in select * from eys6
                            where articulo = r_cos_consumo_eys2.articulo
                            and almacen = r_cos_consumo_eys2.almacen
                            and no_transaccion = r_cos_consumo_eys2.no_transaccion
                            and linea = r_cos_consumo_eys2.eys2_linea
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
            where articulo = r_cos_consumo_eys2.articulo
            and almacen = r_cos_consumo_eys2.almacen
            and no_transaccion = r_cos_consumo_eys2.no_transaccion
            and linea = r_cos_consumo_eys2.eys2_linea;
                  
            select into r_eys2 * from eys2
            where articulo = r_cos_consumo_eys2.articulo
            and almacen = r_cos_consumo_eys2.almacen
            and no_transaccion = r_cos_consumo_eys2.no_transaccion
            and linea = r_cos_consumo_eys2.eys2_linea;
          
            update cos_consumo
            set costo = r_eys2.costo
            where secuencia = r_cos_consumo_eys2.secuencia
            and compania = r_cos_consumo_eys2.compania
            and linea = r_cos_consumo_eys2.linea;
        else
            select into r_eys2 * from eys2
            where articulo = r_cos_consumo_eys2.articulo
            and almacen = r_cos_consumo_eys2.almacen
            and no_transaccion = r_cos_consumo_eys2.no_transaccion
            and linea = r_cos_consumo_eys2.eys2_linea;
          
            update cos_consumo
            set costo = r_eys2.costo
            where secuencia = r_cos_consumo_eys2.secuencia
            and compania = r_cos_consumo_eys2.compania
            and linea = r_cos_consumo_eys2.linea;
        end if;
        
        i := f_eys1_poner_cuentas(r_cos_consumo_eys2.almacen, r_cos_consumo_eys2.no_transaccion);
        if i = 0 then
           raise exception ''transaccion % no tiene definido cuenta de costo...verifique '', r_cos_consumo_eys2.no_transaccion;
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;

create function f_eys1_poner_cuentas(char(2), int4) returns integer as '
declare
    as_almacen alias for $1;
    ai_no_transaccion alias for $2;
    r_work record;
    r_facparamcgl record;
    r_eys3 record;
    li_work integer;
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
    li_work := f_eys1_cglposteo(as_almacen, ai_no_transaccion);
    return 1;
end;
' language plpgsql;



create function f_eys2_eys6() returns trigger as '
declare
    r_eys1 record;
    r_eys2 record;
    r_articulos record;
    r_compras record;
    r_invmotivos record;
    ldc_cantidad decimal(12,4);
    ldc_cantidad_eys6 decimal(12,4);
begin
    
    select into r_articulos * from articulos
    where articulo = new.articulo
    and valorizacion in (''F'', ''L'');
    if not found then
       return new;
    end if;
    
    if new.cantidad = 0 then
       return new;
    end if;
    
    select into r_eys1 * from eys1
    where almacen = new.almacen
    and no_transaccion = new.no_transaccion;    
    if not found then
        return new;
    end if;
    
    select into r_invmotivos * from invmotivos
    where motivo = r_eys1.motivo;
    
    
    delete from eys6
    where articulo = new.articulo
    and almacen = new.almacen
    and no_transaccion = new.no_transaccion
    and linea = new.linea;
    
--    raise exception ''entre'';
    ldc_cantidad := new.cantidad;
    
    if r_invmotivos.signo = -1 then
        for r_compras in select eys1.almacen, eys6.articulo,   
                                 eys1.fecha,   
                                 eys6.compra_no_transaccion,   
                                 eys6.compra_linea,   
                                 sum(eys6.cantidad) as saldo FROM eys1, eys6  
                           WHERE eys1.almacen = eys6.almacen
                           and  eys1.no_transaccion = eys6.compra_no_transaccion
                           and eys1.almacen = new.almacen
                           and eys6.articulo = new.articulo
                           and exists 
                           (select * from eys1 where almacen = eys6.almacen 
                           and no_transaccion = eys6.no_transaccion and fecha <= r_eys1.fecha)
                    GROUP BY eys1.almacen,   
                             eys1.fecha,   
                             eys6.articulo,   
                             eys6.compra_no_transaccion,   
                             eys6.compra_linea  
                    ORDER BY eys1.fecha ASC
        loop
            if r_compras.saldo > 0 then
                if r_compras.saldo >= ldc_cantidad then
                   ldc_cantidad_eys6 := ldc_cantidad;
                   ldc_cantidad := 0;
                else
                   ldc_cantidad_eys6 := r_compras.saldo;
                   ldc_cantidad := ldc_cantidad - r_compras.saldo;
                end if;
        
                if ldc_cantidad_eys6 <> 0 then
                    insert into eys6 (articulo, almacen, no_transaccion, linea, compra_no_transaccion,
                        compra_linea, cantidad)
                    values (new.articulo, new.almacen, new.no_transaccion, new.linea, 
                        r_compras.compra_no_transaccion, r_compras.compra_linea, -ldc_cantidad_eys6);
                end if;
                if ldc_cantidad <= 0 then
                   exit;
                end if;
            end if;
        end loop;
    else
        insert into eys6 (articulo, almacen, no_transaccion, linea, compra_no_transaccion,
            compra_linea, cantidad)
        values (new.articulo, new.almacen, new.no_transaccion, new.linea, 
            new.no_transaccion, new.linea, new.cantidad);
    end if;
    
    return new;
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
    r_articulos record;
    r_eys2 record;
    li_year integer;
    li_periodo integer;
    ldc_existencia1 decimal(12,4);
    ldc_existencia2 decimal(12,4);
    ldc_costo1 decimal(12,4);
    ldc_costo2 decimal(12,4);
    ldc_retornar decimal(12,4);
    ldc_costo decimal(12,4);
    ldc_cantidad decimal(12,4);
begin
    stock := 0;
    select into r_articulos * from articulos
    where articulos.articulo = as_articulo;
    if r_articulos.servicio = ''S'' then
       return 0;
    end if;
        
    select Max(final) into ld_ultimo_cierre from gralperiodos, almacen
    where almacen.compania = gralperiodos.compania
    and almacen.almacen = as_almacen
    and aplicacion = ''INV'' 
    and estado = ''I''
    and final < ad_fecha;

    if ld_ultimo_cierre is null then
        ld_ultimo_cierre := ''1960-01-01'';
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

    select existencia, costo into ldc_existencia1, ldc_costo1 from invbalance
    where almacen = as_almacen
    and articulo = as_articulo
    and year = li_year
    and periodo = li_periodo;
    if ldc_existencia1 is null then
        ldc_existencia1 := 0;
    end if;
    
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
        select sum(eys2.cantidad * invmotivos.signo), sum(eys2.costo * invmotivos.signo) 
        into ldc_existencia2, ldc_costo2 from eys1, eys2, invmotivos
        where eys1.almacen = eys2.almacen
        and eys1.no_transaccion = eys2.no_transaccion
        and eys1.motivo = invmotivos.motivo
        and eys1.almacen = as_almacen
        and eys2.articulo = as_articulo
        and eys1.fecha > ld_ultimo_cierre
        and eys1.fecha <= ad_fecha;
    end if;


    
    if ldc_existencia2 is null then
        ldc_existencia2 := 0;
    end if;
    
    if ldc_costo2 is null then
        ldc_costo2 := 0;
    end if;
    ldc_retornar := 0;
    if as_retornar = ''CU'' then
       if r_articulos.valorizacion = ''F'' or r_articulos.valorizacion = ''L'' then
          ldc_retornar := 0;
       else
          ldc_retornar := ldc_existencia1 + ldc_existencia2;
          if ldc_retornar = 0 then
             ldc_retornar := 0;
          else
             ldc_retornar := (ldc_costo1 + ldc_costo2) / ldc_retornar;
          end if;
       end if;
    else
        if as_retornar = ''COSTO'' then
            ldc_retornar := ldc_costo1 + ldc_costo2;
        else
            ldc_retornar := ldc_existencia1 + ldc_existencia2;
        end if;
    end if;
    
    return ldc_retornar;
end;
' language plpgsql;




create function f_cos_produccion_eys2_delete() returns trigger as '
begin
    delete from eys2
    where articulo = old.articulo
    and almacen = old.almacen
    and no_transaccion = old.no_transaccion
    and linea = old.eys2_linea;
    return old;
end;
' language plpgsql;


create function f_cos_consumo_eys2_delete() returns trigger as '
begin
    delete from eys2
    where articulo = old.articulo
    and almacen = old.almacen
    and no_transaccion = old.no_transaccion
    and linea = old.eys2_linea;
    return old;
end;
' language plpgsql;


create function f_eys4_delete() returns trigger as '
begin
    delete from eys2
    where articulo = old.articulo
    and almacen = old.almacen
    and no_transaccion = old.no_transaccion
    and linea = old.inv_linea;
    return old;
end;
' language plpgsql;



create function f_factura2_eys2_delete() returns trigger as '
begin
    delete from eys2
    where articulo = old.articulo
    and almacen = old.almacen
    and no_transaccion = old.no_transaccion
    and linea = old.eys2_linea;
    return old;
end;
' language plpgsql;

create trigger t_eys4_after_delete after delete on eys4
for each row execute procedure f_eys4_after_delete();

create trigger t_factura2_eys2_delete after delete on factura2_eys2 
for each row execute procedure f_factura2_eys2_delete();

create trigger t_eys4_delete after delete on eys4
for each row execute procedure f_eys4_delete();

create trigger t_cos_consumo_eys2_delete after delete on cos_consumo_eys2
for each row execute procedure f_cos_consumo_eys2_delete();

create trigger t_cos_produccion_eys2_delete after delete on cos_produccion_eys2
for each row execute procedure f_cos_produccion_eys2_delete();

create trigger t_eys2_delete after delete on eys2
for each row execute procedure f_eys2_delete();

create trigger t_eys2_update after update on eys2
for each row execute procedure f_eys2_update();

create trigger t_eys2_insert after insert on eys2
for each row execute procedure f_eys2_insert();

create trigger t_rela_eys1_cglposteo_delete after delete on rela_eys1_cglposteo
for each row execute procedure f_rela_eys1_cglposteo_delete();

create trigger t_eys2_eys6 after insert or update on eys2
for each row execute procedure f_eys2_eys6();

create trigger t_inv_fisico2_after_update after insert or update on inv_fisico2
for each row execute procedure f_inv_fisico2_after_update();

drop function f_clientes_cglauxiliares() cascade;

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



create trigger t_clientes_cglauxiliares after insert or update on clientes
for each row execute procedure f_clientes_cglauxiliares();



drop function f_bcotransac1_bcocircula_insert() cascade;
drop function f_bcotransac1_bcocircula_delete() cascade;
drop function f_bcotransac1_bcocircula_update() cascade;

drop function f_bcocheck1_bcocircula_insert() cascade;
drop function f_bcocheck1_bcocircula_delete() cascade;
drop function f_bcocheck1_bcocircula_update() cascade;

drop function f_bcocheck1_bcocircula(char(2), char(2), int4) cascade;
drop function f_bcotransac1_bcocircula(char(2), int4) cascade;

drop function f_bcotransac1_cglposteo(char(3), int4);
drop function f_rela_bcotransac1_cglposteo_delete() cascade;

drop function f_bcocheck1_cglposteo(char(3), char(2), int4);
drop function f_rela_bcocheck1_cglposteo_delete() cascade;

create function f_bcocheck1_cglposteo(char(3), char(2), int4) returns integer as '
declare
    as_cod_ctabco alias for $1;
    as_motivo_bco alias for $2;
    ai_no_cheque alias for $3;
    li_consecutivo int4;
    r_bcoctas record;
    r_bcocheck1 record;
    r_bcocheck2 record;
    r_cglcuentas record;
    r_work record;
    r_bcomotivos record;
    r_proveedores record;
    r_cglauxiliares record;
    ls_auxiliar_1 char(10);
    ldc_sum_bcocheck1 decimal(10,2);
    ldc_sum_bcocheck2 decimal(10,2);
    ldc_sum_bcocheck3 decimal(10,2);
begin

    select into r_bcocheck1 * from bcocheck1
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    if not found then
       return 0;
    end if;

    
        
    if r_bcocheck1.status = ''A'' then
       return 0;
    end if;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = r_bcocheck1.motivo_bco;
    if r_bcomotivos.solicitud_cheque = ''S'' then
       return 0;
    end if;
    

    
    select into ldc_sum_bcocheck1 monto from bcocheck1
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    
    select into ldc_sum_bcocheck2 sum(monto) from bcocheck2
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    if ldc_sum_bcocheck2 is null then
       ldc_sum_bcocheck2 := 0;
    end if;
    
    
    select into ldc_sum_bcocheck3 sum(monto) from bcocheck3
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    if ldc_sum_bcocheck3 is null then
       ldc_sum_bcocheck3 := 0;
    end if;
    
    if ldc_sum_bcocheck1 <> ldc_sum_bcocheck2 + ldc_sum_bcocheck3 then
       raise exception ''Transaccion % esta desbalanceada...Verifique'',r_bcocheck1.no_cheque;
    end if;

    
    delete from rela_bcocheck1_cglposteo
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = r_bcocheck1.cod_ctabco;
    

    if r_bcocheck1.en_concepto_de is null then
       r_bcocheck1.en_concepto_de := ''CHEQUE # '' || r_bcocheck1.no_cheque || ''  '' || trim(r_bcocheck1.paguese_a);
    else
       r_bcocheck1.en_concepto_de := ''CHEQUE # '' || r_bcocheck1.no_cheque || ''  '' || trim(r_bcocheck1.paguese_a) || ''   '' || trim(r_bcocheck1.en_concepto_de);
    end if;
    
    
    
    
    li_consecutivo := f_cglposteo(r_bcoctas.compania, r_bcocheck1.aplicacion, 
                            r_bcocheck1.fecha_posteo, 
                            r_bcoctas.cuenta, null, null,
                            r_bcomotivos.tipo_comp, r_bcocheck1.en_concepto_de, 
                            (r_bcocheck1.monto*r_bcomotivos.signo));
            
    if li_consecutivo > 0 then
        insert into rela_bcocheck1_cglposteo (consecutivo, no_cheque, cod_ctabco, motivo_bco)
        values (li_consecutivo, r_bcocheck1.no_cheque, r_bcocheck1.cod_ctabco, r_bcocheck1.motivo_bco);
    end if;

   
    for r_work in select bcocheck2.cuenta, bcocheck2.auxiliar1, bcocheck2.auxiliar2, bcocheck2.monto
                    from bcocheck2
                    where bcocheck2.cod_ctabco = as_cod_ctabco
                    and bcocheck2.no_cheque = ai_no_cheque
                    and bcocheck2.motivo_bco = as_motivo_bco
                    order by 1
    loop
        li_consecutivo := f_cglposteo(r_bcoctas.compania, r_bcocheck1.aplicacion, r_bcocheck1.fecha_posteo, 
                            r_work.cuenta, r_work.auxiliar1, r_work.auxiliar2,
                            r_bcomotivos.tipo_comp, r_bcocheck1.en_concepto_de,
                            -(r_work.monto*r_bcomotivos.signo));
        if li_consecutivo > 0 then
           insert into rela_bcocheck1_cglposteo (consecutivo, no_cheque, cod_ctabco, motivo_bco)
           values (li_consecutivo, r_bcocheck1.no_cheque, r_bcocheck1.cod_ctabco, r_bcocheck1.motivo_bco);
        end if;
    end loop;
    

    
    if r_bcocheck1.proveedor is null then
       return 1;
    end if;
    

    for r_work in select proveedores.cuenta, bcocheck1.proveedor, sum(bcocheck3.monto) as monto
                    from bcocheck1, bcocheck3, proveedores
                    where bcocheck1.cod_ctabco = bcocheck3.cod_ctabco
                    and bcocheck1.no_cheque = bcocheck3.no_cheque
                    and bcocheck1.motivo_bco = bcocheck3.motivo_bco
                    and bcocheck1.proveedor = proveedores.proveedor
                    and bcocheck1.cod_ctabco = as_cod_ctabco
                    and bcocheck1.no_cheque = ai_no_cheque
                    and bcocheck1.motivo_bco = as_motivo_bco
                    group by 1, 2
                    order by 1, 2
    loop
        select into r_cglcuentas * from cglcuentas
        where cuenta = r_work.cuenta
        and auxiliar_1 = ''S'';
        if not found then
            ls_auxiliar_1 := null;
        else
            ls_auxiliar_1 := r_work.proveedor;
            
            select into r_proveedores * from proveedores
            where proveedor = r_work.proveedor;
            
            select into r_cglauxiliares * from cglauxiliares
            where trim(auxiliar) = trim(ls_auxiliar_1);
            if not found then
                insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
                values (ls_auxiliar_1, trim(r_proveedores.nomb_proveedor), ''1'', ''A'');
            end if;
            
        end if;
    
        li_consecutivo := f_cglposteo(r_bcoctas.compania, r_bcocheck1.aplicacion, r_bcocheck1.fecha_posteo, 
                            r_work.cuenta, ls_auxiliar_1, null,
                            r_bcomotivos.tipo_comp, r_bcocheck1.en_concepto_de,
                            -(r_work.monto*r_bcomotivos.signo));
        if li_consecutivo > 0 then
           insert into rela_bcocheck1_cglposteo (consecutivo, no_cheque, cod_ctabco, motivo_bco)
           values (li_consecutivo, r_bcocheck1.no_cheque, r_bcocheck1.cod_ctabco, r_bcocheck1.motivo_bco);
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;



create function f_rela_bcocheck1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;



create function f_bcotransac1_cglposteo(char(3), int4) returns integer as '
declare
    as_cod_ctabco alias for $1;
    ai_sec_transacc alias for $2;
    li_consecutivo int4;
    r_bcoctas record;
    r_bcotransac1 record;
    r_bcotransac2 record;
    r_work record;
    r_proveedores record;
    r_bcomotivos record;
    ldc_sum_bcotransac1 decimal(10,2);
    ldc_sum_bcotransac2 decimal(10,2);
    ldc_sum_bcotransac3 decimal(10,2);
begin

    select into r_bcotransac1 * from bcotransac1
    where cod_ctabco = as_cod_ctabco
    and sec_transacc = ai_sec_transacc;
    if not found then
       return 0;
    end if;
    
    select into ldc_sum_bcotransac1 monto from bcotransac1
    where cod_ctabco = as_cod_ctabco
    and sec_transacc = ai_sec_transacc;
    
    select into ldc_sum_bcotransac2 sum(monto) from bcotransac2
    where cod_ctabco = as_cod_ctabco
    and sec_transacc = ai_sec_transacc;
    if ldc_sum_bcotransac2 is null then
       ldc_sum_bcotransac2 := 0;
    end if;
    
    select into ldc_sum_bcotransac3 sum(monto) from bcotransac3
    where cod_ctabco = as_cod_ctabco
    and sec_transacc = ai_sec_transacc;
    if ldc_sum_bcotransac3 is null then
       ldc_sum_bcotransac3 := 0;
    end if;
    
    if ldc_sum_bcotransac1 <> ldc_sum_bcotransac2 + ldc_sum_bcotransac3 then
       raise exception ''Transaccion % esta desbalanceada...Verifique'',r_bcotransac1.sec_transacc;
    end if;
    
    
    
    delete from rela_bcotransac1_cglposteo
    where cod_ctabco = r_bcotransac1.cod_ctabco
    and sec_transacc = r_bcotransac1.sec_transacc;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = r_bcotransac1.motivo_bco;
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = r_bcotransac1.cod_ctabco;
    

    if r_bcotransac1.obs_transac_bco is null then
       r_bcotransac1.obs_transac_bco := ''TRANSACCION #  '' || r_bcotransac1.sec_transacc;
    else
       r_bcotransac1.obs_transac_bco := ''TRANSACCION #  '' || r_bcotransac1.sec_transacc || ''   '' || trim(r_bcotransac1.obs_transac_bco);
    end if;
    
    
    li_consecutivo := f_cglposteo(r_bcoctas.compania, ''BCO'', r_bcotransac1.fecha_posteo, 
                            r_bcoctas.cuenta, r_bcoctas.auxiliar1, r_bcoctas.auxiliar2,
                            r_bcomotivos.tipo_comp, r_bcotransac1.obs_transac_bco, 
                            (r_bcotransac1.monto*r_bcomotivos.signo));
    if li_consecutivo > 0 then
        insert into rela_bcotransac1_cglposteo (consecutivo, sec_transacc, cod_ctabco)
        values (li_consecutivo, r_bcotransac1.sec_transacc, r_bcotransac1.cod_ctabco);
    end if;
    
    for r_work in select bcotransac2.cuenta, bcotransac2.auxiliar1, bcotransac2.auxiliar2, bcotransac2.monto
                    from bcotransac2
                    where bcotransac2.cod_ctabco = r_bcotransac1.cod_ctabco
                    and bcotransac2.sec_transacc = r_bcotransac1.sec_transacc
                    order by 1, 2
    loop
        li_consecutivo := f_cglposteo(r_bcoctas.compania, ''BCO'', r_bcotransac1.fecha_posteo, 
                            r_work.cuenta, r_work.auxiliar1, r_work.auxiliar2,
                            r_bcomotivos.tipo_comp, r_bcotransac1.obs_transac_bco,
                            -(r_work.monto*r_bcomotivos.signo));
        if li_consecutivo > 0 then
           insert into rela_bcotransac1_cglposteo (consecutivo, sec_transacc, cod_ctabco)
           values (li_consecutivo, r_bcotransac1.sec_transacc, r_bcotransac1.cod_ctabco);
        end if;
    end loop;
    
    
    if ldc_sum_bcotransac3 <> 0 then
        select into r_proveedores * from proveedores
        where proveedor = r_bcotransac1.proveedor;
        if not found then
            return 0;
        end if;
        
        li_consecutivo := f_cglposteo(r_bcoctas.compania, ''BCO'', r_bcotransac1.fecha_posteo, 
                            r_proveedores.cuenta, null, null,
                            r_bcomotivos.tipo_comp, r_bcotransac1.obs_transac_bco,
                            -(ldc_sum_bcotransac3*r_bcomotivos.signo));
        if li_consecutivo > 0 then
           insert into rela_bcotransac1_cglposteo (consecutivo, sec_transacc, cod_ctabco)
           values (li_consecutivo, r_bcotransac1.sec_transacc, r_bcotransac1.cod_ctabco);
        end if;
    end if;        

    
    return 1;
end;
' language plpgsql;


create function f_rela_bcotransac1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;


create function f_bcocheck1_bcocircula(char(2), char(2), int4) returns integer as '
declare
    as_cod_ctabco alias for $1;
    as_motivo_bco alias for $2;
    ai_no_cheque alias for $3;
    r_bcomotivos record;
    r_bcocircula record;
    r_bcocheck1 record;
begin
    select into r_bcocheck1 * from bcocheck1
    where cod_ctabco = as_cod_ctabco
    and motivo_bco = as_motivo_bco
    and no_cheque = ai_no_cheque;
    if not found then
       return 0;
    end if;
    
    if r_bcocheck1.monto = 0 then
        return 0;
    end if;
    
    if r_bcocheck1.status = ''A'' then
        return 0;
    end if;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = r_bcocheck1.motivo_bco;
    if not found then
       return 0;
    end if;
    
    if r_bcomotivos.aplica_cheques = ''S'' then
        select into r_bcocircula * from bcocircula
        where cod_ctabco = r_bcocheck1.cod_ctabco
        and motivo_bco = r_bcocheck1.motivo_bco
        and no_docmto_sys = r_bcocheck1.no_cheque
        and fecha_posteo = r_bcocheck1.fecha_posteo;
        if not found then
           insert into bcocircula (sec_docmto_circula, cod_ctabco, motivo_bco, proveedor,
            no_docmto_sys, no_docmto_fuente, fecha_transacc, fecha_posteo, status, usuario,
            fecha_captura, a_nombre, desc_documento, monto, aplicacion)
           VALUES (0, r_bcocheck1.cod_ctabco, r_bcocheck1.motivo_bco, r_bcocheck1.proveedor, 
            r_bcocheck1.no_cheque, r_bcocheck1.docmto_fuente, r_bcocheck1.fecha_posteo, 
            r_bcocheck1.fecha_posteo, ''R'', current_user, current_timestamp, 
            r_bcocheck1.paguese_a, r_bcocheck1.en_concepto_de, r_bcocheck1.monto, r_bcocheck1.aplicacion);
        else
           update bcocircula
           set    proveedor             = r_bcocheck1.proveedor,
                  no_docmto_fuente      = r_bcocheck1.docmto_fuente,
                  fecha_transacc        = r_bcocheck1.fecha_posteo,
                  fecha_posteo          = r_bcocheck1.fecha_posteo,
                  usuario               = current_user,
                  fecha_captura         = current_timestamp,
                  a_nombre              = substring(r_bcocheck1.paguese_a from 1 for 60),
                  desc_documento        = r_bcocheck1.en_concepto_de,
                  monto                 = r_bcocheck1.monto
           where  cod_ctabco            = r_bcocheck1.cod_ctabco
           and    motivo_bco            = r_bcocheck1.motivo_bco
           and    no_docmto_sys         = r_bcocheck1.no_cheque
           and    fecha_posteo          = r_bcocheck1.fecha_posteo
           and    status                <> ''C'';
        end if;
    end if;
    return 1;
end;
' language plpgsql;




create function f_bcotransac1_bcocircula(char(2), int4) returns integer as '
declare
    as_cod_ctabco alias for $1;
    ai_sec_transacc alias for $2;
    r_bcotransac1 record;
    r_bcocircula record;
begin
    select into r_bcotransac1 * from bcotransac1
    where cod_ctabco = as_cod_ctabco
    and sec_transacc = ai_sec_transacc;
    if not found then
       return 0;
    end if;
    
    if r_bcotransac1.monto = 0 then
        return 0;
    end if;
    
    select into r_bcocircula * from bcocircula
    where cod_ctabco = r_bcotransac1.cod_ctabco
    and motivo_bco = r_bcotransac1.motivo_bco
    and no_docmto_sys = r_bcotransac1.sec_transacc
    and fecha_posteo = r_bcotransac1.fecha_posteo;
    if not found then
        insert into bcocircula (sec_docmto_circula, cod_ctabco, motivo_bco, proveedor,
        no_docmto_sys, no_docmto_fuente, fecha_transacc, fecha_posteo, status, usuario,
        fecha_captura, a_nombre, desc_documento, monto, aplicacion)
        VALUES (0, r_bcotransac1.cod_ctabco, r_bcotransac1.motivo_bco, r_bcotransac1.proveedor, 
        r_bcotransac1.sec_transacc, r_bcotransac1.no_docmto, r_bcotransac1.fecha_posteo, 
        r_bcotransac1.fecha_posteo, ''R'', current_user, current_timestamp, 
        substring(r_bcotransac1.obs_transac_bco from 1 for 60), 
        r_bcotransac1.obs_transac_bco, r_bcotransac1.monto, ''BCO'');
    else
       update bcocircula
       set    proveedor             = r_bcotransac1.proveedor,
              no_docmto_fuente      = r_bcotransac1.no_docmto,
              fecha_transacc        = r_bcotransac1.fecha_posteo,
              fecha_posteo          = r_bcotransac1.fecha_posteo,
              usuario               = current_user,
              fecha_captura         = current_timestamp,
              a_nombre              = substring(r_bcotransac1.obs_transac_bco from 1 for 60),
              desc_documento        = r_bcotransac1.obs_transac_bco,
              monto                 = r_bcotransac1.monto
       where  cod_ctabco            = r_bcotransac1.cod_ctabco
       and    motivo_bco            = r_bcotransac1.motivo_bco
       and    no_docmto_sys         = r_bcotransac1.sec_transacc
       and    fecha_posteo          = r_bcotransac1.fecha_posteo
       and    status                <> ''C'';
    end if;
    return 1;
end;
' language plpgsql;



create function f_bcotransac1_bcocircula_insert() returns trigger as '
declare
    i integer;
begin
    i := f_bcotransac1_bcocircula(new.cod_ctabco, new.sec_transacc);
    return new;
end;
' language plpgsql;

create function f_bcotransac1_bcocircula_delete() returns trigger as '
begin
    delete from bcocircula
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_docmto_sys = old.sec_transacc
    and fecha_posteo = old.fecha_posteo
    and status <> ''C'';
    
    delete from rela_bcotransac1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and sec_transacc = old.sec_transacc;
    
    return old;
end;
' language plpgsql;

create function f_bcotransac1_bcocircula_update() returns trigger as '
declare
    r_bcocircula record;
    i integer;
begin
    delete from bcocircula
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_docmto_sys = old.sec_transacc
    and fecha_posteo = old.fecha_posteo
    and status <> ''C''; 
    
    delete from rela_bcotransac1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and sec_transacc = old.sec_transacc;
    
    i := f_bcotransac1_bcocircula(new.cod_ctabco, new.sec_transacc);
    
    return new;
end;
' language plpgsql;



create function f_bcocheck1_bcocircula_insert() returns trigger as '
declare
    r_bcomotivos record;
    r_bcocircula record;
    i integer;
begin
    i := f_bcocheck1_bcocircula(new.cod_ctabco, new.motivo_bco, new.no_cheque);
    
    return new;
end;
' language plpgsql;



create function f_bcocheck1_bcocircula_delete() returns trigger as '
begin
    delete from bcocircula
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_docmto_sys = old.no_cheque
    and fecha_posteo = old.fecha_posteo
    and status <> ''C'';
    return old;
end;
' language plpgsql;


create function f_bcocheck1_bcocircula_update() returns trigger as '
declare
    r_bcomotivos record;
    r_bcocircula record;
    i integer;
begin

    delete from bcocircula
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_docmto_sys = old.no_cheque
    and fecha_posteo = old.fecha_posteo
    and status <> ''C'';
    
    i := f_bcocheck1_bcocircula(new.cod_ctabco, new.motivo_bco, new.no_cheque);
    return new;
end;
' language plpgsql;




create trigger t_bcocheck1_bcocircula_insert after insert on bcocheck1
for each row execute procedure f_bcocheck1_bcocircula_insert();

create trigger t_bcocheck1_bcocircula_delete after delete on bcocheck1
for each row execute procedure f_bcocheck1_bcocircula_delete();

create trigger t_bcocheck1_bcocircula_update after update on bcocheck1
for each row execute procedure f_bcocheck1_bcocircula_update();



create trigger t_bcotransac1_bcocircula_insert after insert on bcotransac1
for each row execute procedure f_bcotransac1_bcocircula_insert();

create trigger t_bcotransac1_bcocircula_delete after delete on bcotransac1
for each row execute procedure f_bcotransac1_bcocircula_delete();

create trigger t_bcotransac1_bcocircula_update after update on bcotransac1
for each row execute procedure f_bcotransac1_bcocircula_update();


create trigger t_rela_bcotransac1_cglposteo_delete after delete on rela_bcotransac1_cglposteo
for each row execute procedure f_rela_bcotransac1_cglposteo_delete();

create trigger t_rela_bcocheck1_cglposteo_delete after delete on rela_bcocheck1_cglposteo
for each row execute procedure f_rela_bcocheck1_cglposteo_delete();








