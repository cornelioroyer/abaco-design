drop function f_clientes_cglauxiliares() cascade;
--drop function f_cglcuentas_aftert_insert() cascade;
drop function f_cglcuentas_after_insert() cascade;
drop function f_clientes_after_insert_airsea() cascade;
drop function f_bcocheck3_before_insert_airsea() cascade;
drop function f_cglposteo_get(int4, char(20)) cascade;


create function f_cglposteo_get(int4, char(20)) returns char(100) as '
declare
    ai_consecutivo alias for $1;
    as_get alias for $2;
    r_cglposteo record;
    r_rela_factura1_cglposteo record;
    r_factura1 record;
    ls_retornar char(100);
begin
    ls_retornar = null;
    
    select into r_cglposteo * from cglposteo
    where consecutivo = ai_consecutivo;
    
    
    for r_rela_factura1_cglposteo in select * from rela_factura1_cglposteo
                    where consecutivo = ai_consecutivo
    loop
        select into r_factura1 * from factura1
        where almacen = r_rela_factura1_cglposteo.almacen
        and tipo = r_rela_factura1_cglposteo.tipo
        and num_documento = r_rela_factura1_cglposteo.num_documento;
        
        if Trim(as_get) = ''FACTURA'' then
            ls_retornar = r_factura1.num_documento;
        else
            ls_retornar = r_factura1.nombre_cliente;
        end if;
    end loop;
    
    
    return ls_retornar;
end;
' language plpgsql;



create function f_bcocheck3_before_insert_airsea() returns trigger as '
declare
    r_cxpdocm record;
    r_bcocheck1 record;
    r_bcoctas record;
    r_adc_house_factura1 record;
    r_adc_master record;
    r_factura1 record;
    r_gral_usuarios record;
    ls_documento char(25);
    
begin
    
    select into r_gral_usuarios * from gral_usuarios
    where trim(usuario) = trim(current_user)
    and supervisor = ''S'';
    if found then
        return new;
    end if;

    if new.monto <= 0 then
        return new;
    end if;
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = new.cod_ctabco;
    
    
    select into r_bcocheck1 * from bcocheck1
    where cod_ctabco = new.cod_ctabco
    and motivo_bco = new.motivo_bco
    and no_cheque = new.no_cheque;
    if not found then
        raise exception ''No se puede ingresar registro en bcocheck3 no tiene padre en bcocheck1'';
    end if;
    
    if r_bcocheck1.proveedor is null then
        return new;
    end if;
    
    
    select into r_cxpdocm * from cxpdocm
    where compania = r_bcoctas.compania
    and proveedor = r_bcocheck1.proveedor
    and documento = new.aplicar_a
    and docmto_aplicar = new.aplicar_a
    and motivo_cxp = new.motivo_cxp;
    if not found then
        raise exception ''Documento % no Existe'',new.aplicar_a;
    end if;
    
    select into r_adc_master adc_master.*
    from navieras, adc_manifiesto, adc_master
    where navieras.cod_naviera = adc_manifiesto.cod_naviera
    and adc_manifiesto.compania = adc_master.compania
    and adc_manifiesto.consecutivo = adc_master.consecutivo
    and adc_manifiesto.compania = r_cxpdocm.compania
    and navieras.proveedor = r_cxpdocm.proveedor
    and trim(adc_master.container) = trim(r_cxpdocm.documento);
    if not found then
        return new;
    end if;

/*    
    select into r_adc_house_factura1 adc_house_factura1.*
    from adc_house_factura1, factmotivos
    where adc_house_factura1.tipo = factmotivos.tipo
    and factmotivos.factura = ''S''
    and adc_house_factura1.compania = r_adc_master.compania
    and adc_house_factura1.consecutivo = r_adc_master.consecutivo
    and adc_house_factura1.linea_master = r_adc_master.linea_master;
    if not found then
        raise exception ''Factura % no puede ser pagada...Debe facturarse primero'',new.aplicar_a;
    end if;
    
    
    for r_adc_house_factura1 in select adc_house_factura1.*
                                    from adc_house_factura1, factmotivos
                                    where adc_house_factura1.tipo = factmotivos.tipo
                                    and factmotivos.factura = ''S''
                                    and adc_house_factura1.compania = r_adc_master.compania
                                    and adc_house_factura1.consecutivo = r_adc_master.consecutivo
                                    and adc_house_factura1.linea_master = r_adc_master.linea_master
    loop
        select into r_factura1 *
        from factura1
        where factura1.almacen = r_adc_house_factura1.almacen
        and factura1.tipo = r_adc_house_factura1.tipo
        and factura1.num_documento = r_adc_house_factura1.num_documento;
        
        ls_documento    =   trim(to_char(r_factura1.num_documento, ''9999999999''));
        
        if f_saldo_documento_cxc(r_factura1.almacen, r_factura1.cliente,
            r_factura1.tipo, ls_documento, ''2300-01-01'') > 0 then
            raise exception ''Factura % no puede ser pagada...El cliente % debe la factura %'',new.aplicar_a, r_factura1.cliente, r_factura1.num_documento;
        end if;
    end loop;
*/

    
    return new;
end;
' language plpgsql;




create function f_clientes_after_insert_airsea() returns trigger as '
begin
    return new;
    insert into clientes_agrupados(cliente, codigo_valor_grupo)
    values (new.cliente, ''03'');
    
    insert into clientes_agrupados(cliente, codigo_valor_grupo)
    values (new.cliente, ''33'');
    
    insert into clientes_agrupados(cliente, codigo_valor_grupo)
    values (new.cliente, ''60'');
    
    return new;
end;
' language plpgsql;


create function f_cglcuentas_after_insert() returns trigger as '
declare
    r_articulos record;
    r_articulos_por_almacen record;
begin
    if substring(new.cuenta from 1 for 2) = ''40''
        or substring(new.cuenta from 1 for 2) = ''41''
        or substring(new.cuenta from 1 for 2) = ''42''
        or substring(new.cuenta from 1 for 2) = ''43'' then
        select into r_articulos * from articulos
        where trim(articulo) = trim(new.cuenta);
        if not found then
            insert into articulos (articulo, unidad_medida, desc_articulo,
                status_articulo,servicio,valorizacion,orden_impresion)
            values(new.cuenta, ''UNIDAD'', new.nombre,''A'',''S'',''P'',100);
        end if;
        
        select into r_articulos_por_almacen * from articulos_por_almacen
        where almacen = ''01''
        and trim(articulo) = trim(new.cuenta);
        if not found then
            insert into articulos_por_almacen (almacen,articulo,cuenta,precio_venta,
                usuario, fecha_captura, minimo, maximo, dias_piso, existencia,
                costo, precio_fijo)
            values (''01'',new.cuenta,new.cuenta,0,current_user, current_timestamp,0,0,0,0,0,''S'');
        end if;
        
        select into r_articulos_por_almacen * from articulos_por_almacen
        where almacen = ''02''
        and trim(articulo) = trim(new.cuenta);
        if not found then
            insert into articulos_por_almacen (almacen,articulo,cuenta,precio_venta,
                usuario, fecha_captura, minimo, maximo, dias_piso, existencia,
                costo, precio_fijo)
            values (''02'',new.cuenta,new.cuenta,0,current_user, current_timestamp,0,0,0,0,0,''S'');
        end if;
        
    end if;    
    return new;
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


create trigger t_clientes_after_insert_airsea after insert on clientes
for each row execute procedure f_clientes_after_insert_airsea();

create trigger t_clientes_cglauxiliares after insert or update on clientes
for each row execute procedure f_clientes_cglauxiliares();

create trigger t_cglcuentas_after_insert after insert or update on cglcuentas
for each row execute procedure f_cglcuentas_after_insert();

create trigger t_bcocheck3_before_insert_airsea before insert on bcocheck3
for each row execute procedure f_bcocheck3_before_insert_airsea();
