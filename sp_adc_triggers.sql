

drop function f_rela_adc_cxc_1_cglposteo_after_delete() cascade;
drop function f_adc_cxc_1_before_insert() cascade;
drop function f_adc_cxc_1_before_update() cascade;
drop function f_adc_cxc_1_before_delete() cascade;
drop function f_adc_cxc_2_before_delete() cascade;
drop function f_adc_cxc_2_before_update() cascade;
drop function f_adc_house_factura1_delete() cascade;
drop function f_adc_house_before_delete() cascade;
drop function f_adc_house_before_update() cascade;
drop function f_adc_house_before_insert() cascade;
drop function f_adc_master_before_delete() cascade;
drop function f_adc_master_before_update() cascade;
drop function f_rela_adc_master_cglposteo_delete() cascade;
drop function f_adc_manifiesto_before_delete() cascade;
drop function f_adc_entrega_mercancia_before_insert() cascade;
drop function f_adc_entrega_mercancia_after_insert() cascade;
drop function f_adc_entrega_mercancia_before_delete() cascade;
drop function f_adc_entrega_mercancia_before_update() cascade;
drop function f_rela_adc_master_cglposteo_before_delete() cascade;
drop function f_adc_manifiesto_before_update() cascade;
drop function f_adc_si_before_update() cascade;
drop function f_adc_master_before_insert() cascade;
drop function f_adc_manejo_factura1_before_delete() cascade;
drop function f_adc_house_after_insert_update() cascade;
drop function f_adc_si_after_insert_update() cascade;
drop function f_adc_pl_after_insert_update() cascade;
drop function f_adc_manifiesto_before_insert_update() cascade;
drop function f_adc_si_before_insert_update() cascade;
drop function f_adc_control_de_contenedores_before_insert_update() cascade;
drop function f_adc_manejo_before_delete() cascade;
drop function f_adc_manejo_before_update() cascade;
drop function f_adc_notas_debito_2_before_update() cascade;
drop function f_adc_notas_debito_2_before_delete() cascade;
drop function f_adc_notas_debito_1_before_delete() cascade;
drop function f_adc_notas_debito_1_before_update() cascade;
drop function f_adc_house_factura1_before_delete() cascade;
drop function f_adc_cxc_2_before_insert() cascade;
drop function f_adc_cxp_2_before_insert() cascade;
drop function f_adc_cxp_2_before_update() cascade;
drop function f_adc_manifiesto_after_insert() cascade;
drop function f_adc_manifiesto_after_update() cascade;
drop function f_adc_manifiesto_after_delete() cascade;
--drop function f_adc_cxp_2_before_insert_update() cascade;
drop function f_adc_master_after_insert() cascade;
drop function f_adc_master_after_update() cascade;
drop function f_adc_master_after_delete() cascade;

drop function f_adc_cxp_1_after_insert() cascade;
drop function f_adc_cxp_1_after_update() cascade;
drop function f_adc_cxp_1_after_delete() cascade;


create function f_adc_cxp_1_after_delete() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
    
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);

    return new;
end;
' language plpgsql;



create function f_adc_cxp_1_after_insert() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
    
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);

    return new;
end;
' language plpgsql;


create function f_adc_cxp_1_after_update() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
    
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);

    return new;
end;
' language plpgsql;





create function f_adc_master_after_insert() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
    
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);

    return new;
end;
' language plpgsql;


create function f_adc_master_after_update() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
    
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);

    return new;
end;
' language plpgsql;


create function f_adc_master_after_delete() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
    
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);

    return new;
end;
' language plpgsql;


create function f_adc_manifiesto_after_insert() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
    
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);

    return new;
end;
' language plpgsql;


create function f_adc_manifiesto_after_update() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);

    return new;
end;
' language plpgsql;


create function f_adc_manifiesto_after_delete() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);

    return old;
end;
' language plpgsql;



create function f_adc_cxp_2_before_insert() returns trigger as '
declare
    i integer;
    r_adc_house record;
begin
    if new.no_house is not null then
        select into r_adc_house * from adc_house
        where consecutivo = new.consecutivo
        and no_house = new.no_house;
        if not found then
            raise exception ''Numero de House no Existe % '',new.no_house;
        end if;
    end if;
    
    i   =   f_adc_valida_cuenta(new.compania, new.consecutivo, new.cuenta);    
    return new;
end;
' language plpgsql;



create function f_adc_cxc_2_before_insert() returns trigger as '
declare
    r_adc_cxc_1 record;
    r_adc_manifiesto record;
    li_count int4;
    lc_work varchar(100);
    i integer;
begin
    select into r_adc_cxc_1 * from adc_cxc_1
    where compania = new.compania
    and consecutivo = new.consecutivo
    and secuencia = new.secuencia;
    if not found then
        Raise Exception ''Registro no existe en adc_cxc_1'';
    end if;
    
    i   =   f_adc_valida_cuenta(new.compania, new.consecutivo, new.cuenta);
    
    return new;
    
end;
' language plpgsql;



create function f_adc_house_factura1_before_delete() returns trigger as '
declare
    r_factmotivos record;
    r_factura1 record;
begin
    select into r_factmotivos *
    from factmotivos
    where tipo = old.tipo
    and factura_fiscal = ''S'';
    if found then
        select into r_factura1 *
        from factmotivos, factura1
        where factura1.tipo = factmotivos.tipo
        and factmotivos.devolucion = ''S''
        and factura1.status <> ''A''
        and factura1.almacen_aplica = old.almacen
        and factura1.caja_aplica = old.caja
        and factura1.num_factura = old.num_documento;
        if not found then
            Raise exception ''Registro no puede ser eliminado en adc_house_factura1 tiene factura %'',old.num_documento;
        end if;
    end if;
    return old;
end;
' language plpgsql;


create function f_adc_notas_debito_2_before_update() returns trigger as '
declare
    r_factura1 record;
    r_adc_house record;
    r_adc_house_factura1 record;
    r_adc_manejo_factura1 record;
    r_adc_notas_debito_1 record;
    r_adc_manejo record;
    ls_factura char(25);
    i integer;
begin
    select into r_adc_notas_debito_1 *
    from adc_notas_debito_1
    where compania = old.compania
    and secuencia = old.secuencia;
    if found then
        select into r_factura1 factura1.* 
        from factura1, factmotivos
        where factura1.tipo = factmotivos.tipo
        and factmotivos.factura_fiscal = ''S''
        and almacen = r_adc_notas_debito_1.almacen
        and factura1.caja = r_adc_notas_debito_1.caja
        and factura1.tipo = r_adc_notas_debito_1.tipo
        and num_documento = r_adc_notas_debito_1.num_documento;
        if found then
            select into r_factura1 factura1.*
            from factura1, factmotivos
            where factura1.tipo = factmotivos.tipo
            and factura1.almacen = r_adc_notas_debito_1.almacen
            and factura1.caja = r_adc_notas_debito_1.caja
            and factmotivos.devolucion = ''S''
            and factura1.num_factura = r_adc_notas_debito_1.num_documento;
            if not found then
--                Raise Exception ''Nota Debito # % tiene factura % no se puede modificar'',old.secuencia, r_adc_notas_debito_1.num_documento;
            end if;
        end if;    
    end if;

    update adc_notas_debito_1
    set almacen = null, tipo = null, num_documento = null
    where compania = old.compania
    and secuencia = old.secuencia;
    
    return new;
end;
' language plpgsql;



create function f_adc_notas_debito_2_before_delete() returns trigger as '
declare
    r_factura1 record;
    r_adc_house record;
    r_adc_house_factura1 record;
    r_adc_manejo_factura1 record;
    r_adc_manejo record;
    r_adc_notas_debito_1 record;
    ls_factura char(25);
    i integer;
begin
    select into r_adc_notas_debito_1 *
    from adc_notas_debito_1
    where compania = old.compania
    and secuencia = old.secuencia;
    if found then
        select into r_factura1 factura1.* 
        from factura1, factmotivos
        where factura1.tipo = factmotivos.tipo
        and factmotivos.factura_fiscal = ''S''
        and almacen = r_adc_notas_debito_1.almacen
        and factura1.caja = r_adc_notas_debito_1.caja
        and factura1.tipo = r_adc_notas_debito_1.tipo
        and num_documento = r_adc_notas_debito_1.num_documento;
        if not found then
--            Raise Exception ''Nota Debito # % tiene factura % no se puede eliminar'',old.secuencia, r_adc_notas_debito_1.num_documento;
        end if;    
    end if;

    update adc_notas_debito_1
    set almacen = null, tipo = null, num_documento = null
    where compania = old.compania
    and secuencia = old.secuencia;

    return old;
end;
' language plpgsql;




create function f_adc_notas_debito_1_before_update() returns trigger as '
declare
    r_factura1 record;
    r_adc_house record;
    r_adc_house_factura1 record;
    r_adc_manejo_factura1 record;
    r_adc_manejo record;
    r_fac_cajas record;
    ls_factura char(25);
    i integer;
begin

   
    select into r_factura1 factura1.* 
    from factura1, factmotivos
    where factura1.tipo = factmotivos.tipo
    and factmotivos.factura_fiscal = ''S''
    and factura1.almacen = old.almacen
    and factura1.tipo = old.tipo
    and factura1.caja = old.caja
    and num_documento = old.num_documento;
    if found then
        select into r_factura1 factura1.*
        from factura1, factmotivos
        where factura1.tipo = factmotivos.tipo
        and factura1.almacen = old.almacen
        and factura1.caja = old.caja
        and factmotivos.devolucion = ''S''
        and factura1.num_factura = old.num_documento;
        if not found then
--            Raise Exception ''Nota Debito # % tiene factura % no se puede modificar'',old.secuencia, old.num_documento;
        end if;
    end if;



    if new.consecutivo <> old.consecutivo
        or new.cliente <> old.cliente
        or new.documento <> old.documento
        or new.observacion_1 <> old.observacion_1
        or new.observacion_2 <> old.observacion_2
        or new.observacion_3 <> old.observacion_3
        or new.observacion_4 <> old.observacion_4 then
        new.almacen         =   null;
        new.tipo            =   null;
        new.num_documento   =   null;
    end if;    
    
    if new.almacen is not null then
        select into r_fac_cajas * from fac_cajas
        where almacen = new.almacen
        and status = ''A'';
        if not found then
            Raise Exception ''No Existe caja para el almacen %'',new.almacen;
        else
            new.caja = r_fac_cajas.caja;
        end if;
    end if;
    
    return new;
end;
' language plpgsql;


create function f_adc_notas_debito_1_before_delete() returns trigger as '
declare
    r_factura1 record;
    r_adc_house record;
    r_adc_house_factura1 record;
    r_adc_manejo_factura1 record;
    r_adc_manejo record;
    ls_factura char(25);
    i integer;
begin
    select into r_factura1 factura1.* 
    from factura1, factmotivos
    where factura1.tipo = factmotivos.tipo
    and factmotivos.factura_fiscal = ''S''
    and almacen = old.almacen
    and factura1.tipo = old.tipo
    and factura1.caja = old.caja
    and num_documento = old.num_documento;
    if found then
        select into r_factura1 factura1.*
        from factura1, factmotivos
        where factura1.tipo = factmotivos.tipo
        and factura1.almacen = old.almacen
        and factura1.caja = old.caja
        and factmotivos.devolucion = ''S''
        and factura1.num_factura = old.num_documento;
        if not found then
--            Raise Exception ''Nota Debito # % tiene factura % no se puede eliminar'',old.secuencia, old.num_documento;
        end if;
    end if;    
    return old;
end;
' language plpgsql;


create function f_adc_manejo_before_update() returns trigger as '
declare
    r_factura1 record;
    r_adc_house record;
    r_adc_house_factura1 record;
    r_adc_manejo_factura1 record;
    r_adc_manejo record;
    ls_factura char(25);
    i integer;
begin
    delete from adc_house_factura1
    where compania = old.compania
    and consecutivo = old.consecutivo
    and linea_master = old.linea_master
    and linea_house = old.linea_house
    and linea_manejo = old.linea_manejo
    and tipo in (select tipo from factmotivos where cotizacion = ''S'');

    if trim(old.articulo) <> trim(new.articulo) 
        or old.almacen <> new.almacen 
        or old.cargo <> new.cargo 
        or old.observacion <> new.observacion then
        select into r_adc_house_factura1 adc_house_factura1.* 
        from adc_house_factura1, factmotivos, factura1
        where adc_house_factura1.tipo = factmotivos.tipo
        and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
        and adc_house_factura1.compania = old.compania
        and adc_house_factura1.consecutivo = old.consecutivo
        and adc_house_factura1.linea_master = old.linea_master
        and adc_house_factura1.linea_manejo = old.linea_manejo
        and adc_house_factura1.linea_house = old.linea_house
        and factura1.almacen = adc_house_factura1.almacen
        and factura1.tipo = adc_house_factura1.tipo
        and factura1.num_documento = adc_house_factura1.num_documento
        and factura1.status <> ''A'';
        if found then
            raise exception ''Linea de manejo % no puede ser modificada...tiene la factura %'',old.articulo, r_adc_house_factura1.num_documento;
        end if;
    end if;

    i := f_adc_manejo_delete(old.compania, old.consecutivo, old.linea_master, 
            old.linea_house, old.linea_manejo);
    
    return new;
end;
' language plpgsql;


create function f_adc_manejo_before_delete() returns trigger as '
declare
    r_factura1 record;
    r_adc_house record;
    r_adc_house_factura1 record;
    r_adc_manejo_factura1 record;
    r_adc_manejo record;
    ls_factura char(25);
    li_work integer;
begin

/*
    select into r_adc_house_factura1 adc_house_factura1.* from adc_house_factura1, factmotivos
    where adc_house_factura1.tipo = factmotivos.tipo
    and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
    and adc_house_factura1.compania = old.compania
    and adc_house_factura1.consecutivo = old.consecutivo
    and adc_house_factura1.linea_master = old.linea_master
    and adc_house_factura1.linea_manejo = old.linea_manejo;
    if found then
        raise exception ''Linea de manejo % no puede ser eliminada...tiene la factura'',old.articulo;
    end if;
*/    
    
    li_work =   f_adc_manejo_delete(old.compania, old.consecutivo, old.linea_master,
                    old.linea_manejo, old.linea_house);
    return old;
end;
' language plpgsql;



create function f_adc_cxp_2_before_update() returns trigger as '
declare
    i integer;
    r_adc_house record;
begin
    if new.no_house is not null then
        select into r_adc_house * from adc_house
        where consecutivo = new.consecutivo
        and no_house = new.no_house;
        if not found then
            raise exception ''Numero de House no Existe % '',new.no_house;
        end if;
    end if;

    i   =   f_adc_valida_cuenta(new.compania, new.consecutivo, new.cuenta);    

    
    return new;
end;
' language plpgsql;




create function f_adc_control_de_contenedores_before_insert_update() returns trigger as '
declare
    i integer;
begin
    if new.fecha_regresa is not null then
        if new.fecha_regresa > current_date then
            raise exception ''Las devoluciones no pueden ser con fecha posterior'';
        end if;
        
        if new.fecha_regresa < new.fecha_retira then
            raise exception ''Las devoluciones deben ser posterior a la fecha de retiro'';
        end if;
    end if;
    
    return new;
end;
' language plpgsql;



create function f_adc_si_before_insert_update() returns trigger as '
declare
    i integer;
begin
    if new.vendedor is null then
        raise exception ''Vendedor es obligatorio...Verifique'';
    end if;
    
    return new;
end;
' language plpgsql;



create function f_adc_manifiesto_before_insert_update() returns trigger as '
declare
    i integer;
    r_fact_referencias record;
    r_adc_parametros_contables record;
begin

    if new.puerto_descarga is null then
        Raise Exception ''Puerto de Descarga es Obligatorio...Verifique'';
    end if;
    
    i := f_valida_fecha(new.compania, ''CGL'', new.fecha);

    select into r_fact_referencias *
    from fact_referencias
    where referencia = new.referencia;
    if not found then
        Raise Exception ''Referencia % No Existe...Verifique'', new.referencia;
    else
        if r_fact_referencias.tipo = ''E'' then
            if not (Anio(new.fecha) = Anio(new.fecha_arrive)
                        and Mes(new.fecha) = Mes(new.fecha_arrive)) then
                Raise Exception ''Fecha de Llegada debe esta en el mismo mes'';
            end if;
        end if;
    end if;
    
/*
    if new.fecha < new.fecha_arrive then
        Raise Exception ''Fecha del Lote % Debe ser igual o mayor a fecha de llegada %'',new.fecha, new.fecha_arrive;
    end if;    
*/

    select into r_adc_parametros_contables *
    from adc_parametros_contables
    where referencia = new.referencia
    and ciudad = new.ciudad_origen;
    if not found then
        Raise Exception ''Ciudad Origen % no tiene afectacion contable'', new.ciudad_origen;
    end if;

    select into r_adc_parametros_contables *
    from adc_parametros_contables
    where referencia = new.referencia
    and ciudad = new.ciudad_destino;
    if not found then
        Raise Exception ''Ciudad Destino % no tiene afectacion contable'', new.ciudad_destino;
    end if;
    
    
    
    return new;
end;
' language plpgsql;



create function f_adc_pl_after_insert_update() returns trigger as '
declare
    r_adc_parametros_contables record;
    r_adc_si record;
    r_adc_manejo record;
    r_adc_house record;
begin

    select into r_adc_si * 
    from adc_si
    where compania = new.compania
    and anio = new.anio
    and secuencia = new.secuencia;
    if not found then
        raise exception ''Shipping % no existe'',new.secuencia;
    end if;
    
    if r_adc_si.consecutivo_manifiesto is null then
        return new;
    end if;
    
    select into r_adc_parametros_contables adc_parametros_contables.*
    from adc_parametros_contables, articulos_por_almacen
    where adc_parametros_contables.cta_ingreso = articulos_por_almacen.cuenta
    and articulos_por_almacen.almacen = new.almacen
    and articulos_por_almacen.articulo = new.articulo;
    if not found then
        select into r_adc_manejo *
        from adc_manejo
        where compania = new.compania
        and consecutivo = r_adc_si.consecutivo_manifiesto
        and linea_master = 1
        and linea_house = 1
        and linea_manejo = 1;
        if not found and new.venta_real > 0 then
            select into r_adc_house *
            from adc_house
            where compania = new.compania
            and consecutivo = r_adc_si.consecutivo_manifiesto
            and linea_master = 1
            and linea_house = 1;
            if found then
                insert into adc_manejo(compania, consecutivo, linea_master, linea_house,
                    linea_manejo, articulo, almacen, cargo, observacion, fecha)
                values (new.compania, r_adc_si.consecutivo_manifiesto, 1, 1,
                    1, new.articulo, new.almacen, new.venta_real, new.observacion, r_adc_si.fecha);
            end if;
        end if;
    end if;
    
    
    
    return new;
end;
' language plpgsql;



create function f_adc_house_after_insert_update() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin

    lt_new_dato =   Row(New.*);
--    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
    
    if new.secuencia is not null then
        update adc_si
        set consecutivo_manifiesto = new.consecutivo
        where compania = new.compania
        and anio = new.anio
        and secuencia = new.secuencia;
    end if;
    
    return new;
end;
' language plpgsql;



create function f_adc_si_after_insert_update() returns trigger as '
declare
    r_adc_manifiesto record;
    r_adc_house record;
    r_adc_master record;
    r_fact_referencias record;
    r_adc_parametros_contables record;
    ls_valor char(60);
    li_consecutivo int4;
    ls_ciudad_origen char(10);
    ls_ciudad_destino char(10);
    ls_puerto_descarga char(2);
    ls_port_of_departure char(2);
    ls_tamanio char(5);
    ls_cargo_prepago char(1);
    ls_to_agent char(10);
    ls_from_agent char(10);
    ls_embarcador varchar(100);
begin


    if new.consecutivo_manifiesto is not null then
        return new;
    end if;
    
    if new.no_referencia is null
        or new.mbl is null
        or new.container is null
        or new.hbl is null 
        or new.sh_naviera is null 
        or new.t_agente_destino is null then
        return new;
    end if;

--raise exception ''entre'';    
    
    select into r_fact_referencias * from fact_referencias
    where referencia = new.sh_referencia;
    
    
    if r_fact_referencias.tipo = ''I'' then
        select into r_adc_manifiesto * 
        from adc_manifiesto
        where compania = new.compania
        and no_referencia = new.no_referencia
        and from_agent = new.t_agente_destino;
        if found then
            return new;
        end if;
        ls_ciudad_origen        = new.s_ciudad;
        ls_ciudad_destino       = new.c_ciudad;
        ls_port_of_departure    = new.s_puerto;
        ls_puerto_descarga      = new.c_puerto;
        ls_to_agent             = ''0821'';
        ls_from_agent           = new.t_agente_destino;
        ls_embarcador           = Trim(new.s_company);
    else        
        select into r_adc_manifiesto * 
        from adc_manifiesto
        where compania = new.compania
        and no_referencia = new.no_referencia
        and to_agent = new.t_agente_destino;
        if found then
            return new;
        end if;
        ls_ciudad_origen = new.c_ciudad;
        ls_ciudad_destino = new.s_ciudad;
        ls_port_of_departure = new.c_puerto;
        ls_puerto_descarga = new.s_puerto;
        ls_to_agent = new.t_agente_destino;
        ls_from_agent = ''0821'';
        ls_embarcador = Trim(new.c_company);
    end if;
    
    if new.sh_contenedores > 0 then
        ls_tamanio = new.sh_tamanio;
    elsif new.sh_contenedores2 > 0 then
        ls_tamanio = new.sh_tamanio2;
    elsif new.sh_contenedores3 > 0 then
        ls_tamanio = new.sh_tamanio3;
    elsif new.sh_contenedores4 > 0 then
        ls_tamanio = new.sh_tamanio4;
    elsif new.sh_contenedores5 > 0 then
        ls_tamanio = new.sh_tamanio5;
    end if;        
    
    li_consecutivo = to_number(f_gralparaxcia(new.compania, ''FAC'', ''sec_manifiesto''),''9999999'');

    while 1=1 loop
        li_consecutivo = li_consecutivo + 1;
        select into r_adc_manifiesto *
        from adc_manifiesto
        where compania = new.compania
        and consecutivo = li_consecutivo;
        if not found then
            exit;
        end if;
    end loop;
    
    ls_valor = trim(to_char(li_consecutivo,''9999999''));
    update gralparaxcia
    set valor = ls_valor
    where compania = new.compania
    and parametro = ''sec_manifiesto''
    and aplicacion = ''FAC'';
    
    
    insert into adc_manifiesto(compania, consecutivo, referencia, no_referencia,
        to_agent, from_agent, ciudad_origen, ciudad_destino, fecha_departure,
        fecha_arrive, fecha, cod_naviera, vendedor, puerto_descarga, port_of_departure,
        vapor, usuario_captura, fecha_captura, confirmado, divisor)
    values(new.compania, li_consecutivo, new.sh_referencia, new.no_referencia,
        ls_to_agent, ls_from_agent, ls_ciudad_origen, ls_ciudad_destino,
        new.fecha, new.fecha, new.fecha, new.sh_naviera, new.vendedor, ls_puerto_descarga, ls_port_of_departure,
        ''XXXXX'', current_user, current_timestamp, ''N'', 2);
    
    
    if new.sh_mbl = ''P'' then
        ls_cargo_prepago = ''S'';
    else
        ls_cargo_prepago = ''N'';
    end if;
        
    insert into adc_master(compania, consecutivo, linea_master, no_bill,
        tamanio, tipo, container, cargo, cargo_prepago, gtos_d_origen,
        gtos_prepago, gtos_destino, dthc, dthc_prepago, pkgs, cbm,
        kgs)
    values(new.compania, li_consecutivo, 1, new.mbl, ls_tamanio, new.sh_tipo,
        new.container, new.costo, ls_cargo_prepago, 0, ''N'', 0, 0, ''N'', 0,
        new.sh_volumen, new.sh_peso);
        
/*    
    insert into adc_house(compania, consecutivo, linea_master, linea_house,
        cliente, almacen, vendedor, ciudad, anio,
        secuencia, embarcador, no_house, cargo, cargo_prepago,
        gtos_d_origen, gtos_prepago, dthc, dthc_prepago, direccion1, direccion2,
        pkgs, cbm, kgs, tipo, cod_destino)
    values(new.compania, li_consecutivo, 1, 1, new.c_cliente,
        new.sh_almacen, new.vendedor, new.c_ciudad,
        new.anio, new.secuencia, Trim(ls_embarcador), new.hbl,
        0, ''N'', 0, ''N'', 0, ''N'', new.c_direccion_1, new.c_direccion_2,
        0, new.sh_volumen, new.sh_peso, ''N'', ls_puerto_descarga);
*/
    
    return new;
end;
' language plpgsql;



create function f_adc_manejo_factura1_before_delete() returns trigger as '
declare
    r_factura1 record;
    r_adc_house record;
    r_adc_house_factura1 record;
    r_adc_manejo_factura1 record;
    r_adc_manejo record;
    ls_factura char(25);
begin
    select into r_factura1 factura1.* from factura1, factmotivos
    where factura1.tipo = factmotivos.tipo
    and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
    and factura1.status <> ''A''
    and factura1.almacen = old.almacen
    and factura1.tipo = old.tipo
    and factura1.caja = old.caja
    and factura1.num_documento = old.num_documento;
    if found then
        raise exception ''Linea de manejo % no puede ser eliminada...tiene la factura %'',old.linea_manejo, old.num_documento;
    end if;
    return old;
end;
' language plpgsql;


create function f_adc_master_before_insert() returns trigger as '
declare
    i integer;
    r_adc_manifiesto record;
    lc_cod_naviera char(4);
begin
    select into r_adc_manifiesto * 
    from adc_manifiesto
    where adc_manifiesto.compania = new.compania
    and adc_manifiesto.consecutivo = new.consecutivo;
    if not found then
        raise exception ''Manifiesto % no existe'',new.consecutivo;
    end if;
    
    lc_cod_naviera = r_adc_manifiesto.cod_naviera;
    
    i := f_valida_fecha(r_adc_manifiesto.compania, ''CGL'', r_adc_manifiesto.fecha);
    
    select into r_adc_manifiesto *
    from adc_manifiesto, adc_master
    where adc_manifiesto.compania = adc_master.compania
    and adc_manifiesto.consecutivo = adc_master.consecutivo
    and adc_manifiesto.cod_naviera = lc_cod_naviera
    and adc_master.container = new.container;
    if found then
        Raise Exception ''Numero de Contenedor % Esta duplicado para esta naviera %'',new.container, lc_cod_naviera;
    end if;
    
    return new;
end;
' language plpgsql;


create function f_adc_si_before_update() returns trigger as '
declare
    r_clientes record;
begin
    select into r_clientes * from clientes
    where trim(nomb_cliente) = trim(new.c_company);
    if not found then
--        raise exception ''Cliente % No Existe'',new.c_company;
    else
        new.c_cliente = r_clientes.cliente;
    end if;
    
    if new.costo is null then
        new.costo = 0;
    end if;
    return new;
end;
' language plpgsql;



create function f_adc_entrega_mercancia_before_update() returns trigger as '
declare
    r_factura1 record;
    r_adc_house record;
    r_adc_house_factura1 record;
    r_adc_manejo_factura1 record;
    r_adc_manejo record;
    ls_factura char(25);
begin
    if trim(current_user) = ''keyla'' then
        return new;
    end if;
    
    if not f_supervisor(trim(new.usuario_captura)) and old.status = ''I'' then
        raise exception ''Orden de Entrega Impresa no puede ser Modificada...Verifique'';
    end if;
    return new;
end;
' language plpgsql;




create function f_adc_entrega_mercancia_before_delete() returns trigger as '
declare
    r_factura1 record;
    r_adc_house record;
    r_adc_house_factura1 record;
    r_adc_manejo_factura1 record;
    r_adc_manejo record;
    ls_factura char(25);
begin
    if not f_supervisor(old.usuario_captura) and old.status = ''I'' then
        raise exception ''Orden de Entrega Impresa no puede ser Eliminada...Verifique'';
    end if;
    return old;
end;
' language plpgsql;



create function f_adc_entrega_mercancia_after_insert() returns trigger as '
declare
    r_factura1 record;
    r_cxcdocm record;
    r_cxc_recibo2 record;
    ls_factura char(25);
begin
    for r_factura1 in select * from factura1
                        where trim(hbl) = trim(new.no_house)
    loop
        ls_factura  =   to_char(r_factura1.num_documento,''99999999999999'');
        for r_cxc_recibo2 in select cxc_recibo2.* from cxc_recibo1, cxc_recibo2
                            where cxc_recibo1.almacen = cxc_recibo2.almacen
                            and cxc_recibo1.consecutivo = cxc_recibo2.consecutivo
                            and cxc_recibo1.cliente = r_factura1.cliente
                            and cxc_recibo2.almacen_aplicar = r_factura1.almacen
                            and cxc_recibo2.motivo_aplicar = r_factura1.tipo
                            and trim(cxc_recibo2.documento_aplicar) = trim(ls_factura)
        loop
            insert into adc_facturas_recibos (compania, sec_entrega, fac_almacen,
                tipo, num_documento, cxc_almacen, consecutivo)
            values (new.compania, new.sec_entrega, r_factura1.almacen, r_factura1.tipo,
                r_factura1.num_documento, r_cxc_recibo2.almacen, r_cxc_recibo2.consecutivo);        
        end loop;                            
    end loop;
    
    return new;
end;
' language plpgsql;


create function f_adc_entrega_mercancia_before_insert() returns trigger as '
declare
    r_factura1 record;
    r_adc_house record;
    r_adc_house_factura1 record;
    r_adc_manejo_factura1 record;
    r_adc_manejo record;
    ls_factura char(25);
    ldc_work decimal;
begin
    select into r_adc_house *
    from adc_house
    where trim(no_house) = trim(new.no_house);
    if not found then
        raise exception ''Numero de house no Existe...Verifique'';
    end if;
    
    select into r_factura1 factura1.*
    from factura1, factmotivos
    where factura1.tipo = factmotivos.tipo
    and (factmotivos.factura = ''S''  or factmotivos.factura_fiscal = ''S'')
    and factura1.status <> ''A''
    and trim(factura1.hbl) = trim(new.no_house);
    if not found then
        raise exception ''House no ha sido facturado...Verifique'';
    end if;
    
    for r_adc_house in select * from adc_house
                            where compania = new.compania 
                            and trim(no_house) = trim(new.no_house)
    loop
        if (r_adc_house.cargo > 0 and r_adc_house.cargo_prepago = ''N'') or 
            (r_adc_house.gtos_d_origen > 0 and r_adc_house.gtos_prepago = ''N'') then
            
            select into r_adc_house_factura1 adc_house_factura1.*
            from adc_house_factura1, factmotivos
            where adc_house_factura1.tipo = factmotivos.tipo
            and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
            and adc_house_factura1.compania = r_adc_house.compania
            and adc_house_factura1.consecutivo = r_adc_house.consecutivo
            and adc_house_factura1.linea_master = r_adc_house.linea_master
            and adc_house_factura1.linea_house = r_adc_house.linea_house;
            if not found then
                raise exception ''En este House % el flete ha sido facturado...Verifique'',r_adc_house.no_house;
            else
                select into r_factura1 * from factura1
                where almacen = r_adc_house_factura1.almacen
                and tipo = r_adc_house_factura1.tipo
                and num_documento = r_adc_house_factura1.num_documento;
                if found then                
                    ls_factura  =   to_char(r_factura1.num_documento,''99999999999999'');
                    if f_saldo_documento_cxc(r_factura1.almacen, r_factura1.cliente, r_factura1.tipo,
                        trim(ls_factura), current_date) > 0 then
                       raise exception ''Factura % no ha sido pagada...Verifique'',ls_factura; 
                    end if;
                end if;
            end if;
        end if;

        for r_adc_house in select * from adc_house
                                where compania = new.compania 
                                and trim(no_house) = trim(new.no_house)
        loop
            for r_adc_manejo in select * from adc_manejo
                where compania = r_adc_house.compania
                and consecutivo = r_adc_house.consecutivo
                and linea_master = r_adc_house.linea_master
                and linea_house = r_adc_house.linea_house
            loop
                if r_adc_manejo.cargo > 0 then
                    select into r_adc_manejo_factura1 * from adc_manejo_factura1, factmotivos
                    where adc_manejo_factura1.tipo = factmotivos.tipo
                    and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
                    and adc_manejo_factura1.compania = r_adc_manejo.compania
                    and adc_manejo_factura1.consecutivo = r_adc_manejo.consecutivo
                    and adc_manejo_factura1.linea_master = r_adc_manejo.linea_master
                    and adc_manejo_factura1.linea_house = r_adc_manejo.linea_house
                    and adc_manejo_factura1.linea_manejo = r_adc_manejo.linea_manejo;
                    if found then
                        select into r_factura1 * from factura1
                        where almacen = r_adc_manejo_factura1.almacen
                        and tipo = r_adc_manejo_factura1.tipo
                        and num_documento = r_adc_manejo_factura1.num_documento;
                        if found then                
                            ls_factura  =   r_factura1.num_documento;
                            if f_saldo_documento_cxc(r_factura1.almacen, r_factura1.cliente, r_factura1.tipo,
                                trim(ls_factura), current_date) > 0 then
                               raise exception ''Factura % no ha sido pagada...Verifique'',ls_factura; 
                            end if;
                        end if;
                    else
                        select into r_adc_house_factura1 * from adc_house_factura1, factmotivos
                        where adc_house_factura1.tipo = factmotivos.tipo
                        and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
                        and adc_house_factura1.compania = r_adc_manejo.compania
                        and adc_house_factura1.consecutivo = r_adc_manejo.consecutivo
                        and adc_house_factura1.linea_master = r_adc_manejo.linea_master
                        and adc_house_factura1.linea_house = r_adc_manejo.linea_house
                        and adc_house_factura1.linea_manejo = r_adc_manejo.linea_manejo;
                        if found then
                            select into r_factura1 * from factura1
                            where almacen = r_adc_manejo_factura1.almacen
                            and tipo = r_adc_manejo_factura1.tipo
                            and num_documento = r_adc_manejo_factura1.num_documento;
                            if found then                
                                ls_factura  =   r_factura1.num_documento;
                                if f_saldo_documento_cxc(r_factura1.almacen, r_factura1.cliente, r_factura1.tipo,
                                    trim(ls_factura), current_date) > 0 then
                                   raise exception ''Factura % no ha sido pagada...Verifique'',ls_factura; 
                                end if;
                            end if;
                        else
                            raise exception ''En este House % el manejo no ha sido facturado...Verifique'',r_adc_house.no_house;
                        end if;
                    end if;
                end if;
            end loop;
        end loop;
    end loop;
    return new;
end;
' language plpgsql;


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
    and factura1.caja = adc_house_factura1.caja
    and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
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
    and factura1.caja = adc_manejo_factura1.caja
    and factura1.num_documento = adc_manejo_factura1.num_documento
    and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
    and factura1.status <> ''A''
    and adc_manejo_factura1.compania = old.compania
    and adc_manejo_factura1.consecutivo = old.consecutivo;
    if found then
        raise exception ''No se puede eliminar este manifiesto % por que tiene facturas de manejo relacionadas...Verifique'', old.consecutivo;
    end if;
    
    delete from rela_adc_master_cglposteo
    where compania = old.compania 
    and consecutivo = old.consecutivo;
    
    return old;
end;
' language plpgsql;


create function f_adc_manifiesto_before_update() returns trigger as '
declare
    i integer;
    r_factura1 record;
    r_navieras record;
    r_adc_master record;
    r_adc_parametros_contables record;
    r_cxpmotivos record;
begin

/*
    if new.fecha < new.fecha_arrive then
        Raise Exception ''Fecha del Lote % Debe ser igual o mayor a fecha de llegada %'',new.fecha, new.fecha_arrive;
    end if;    
*/
    
    delete from rela_adc_master_cglposteo
    where compania = old.compania 
    and consecutivo = old.consecutivo;
    
    select into r_navieras * from navieras
    where cod_naviera = old.cod_naviera;
    if not found then
        raise exception ''no encontre la naviera'';
    end if;
    
    select into r_cxpmotivos * from cxpmotivos
    where factura = ''S'';
    
    for r_adc_master in select * from adc_master
                            where compania = new.compania
                            and consecutivo = new.consecutivo
    loop
--        raise exception ''proveedor %'',r_cxpmotivos.motivo_cxp;
        delete from cxpdocm
        where compania = new.compania
        and proveedor = r_navieras.proveedor
        and trim(documento) = trim(r_adc_master.container)
        and trim(docmto_aplicar) = trim(r_adc_master.container)
        and motivo_cxp = r_cxpmotivos.motivo_cxp;
    end loop;    
    
    select into r_adc_parametros_contables *
    from adc_parametros_contables
    where referencia = new.referencia
    and ciudad = new.ciudad_origen;
    if not found then
        Raise Exception ''Ciudad Origen % no tiene afectacion contable'', new.ciudad_origen;
    end if;

    select into r_adc_parametros_contables *
    from adc_parametros_contables
    where referencia = new.referencia
    and ciudad = new.ciudad_destino;
    if not found then
        Raise Exception ''Ciudad Destino % no tiene afectacion contable'', new.ciudad_destino;
    end if;
    
    
    
    return new;
end;
' language plpgsql;



create function f_adc_cxc_1_before_insert() returns trigger as '
declare
    r_adc_cxc_1 record;
    r_cxctrx1 record;
    r_adc_manifiesto record;
    r_clientes record;
    r_fact_referencias record;
    r_gral_usuarios record;
    r_almacen record;
    ls_usuario char(10);
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin

    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
    
    new.usuario         =   current_user;
    new.fecha_captura   =   current_timestamp;
    
    if new.almacen is null then
        Raise Exception ''Almacen es Obligatorio'';
    end if;
    
    
    select into r_almacen *
    from almacen
    where almacen = new.almacen;
    if not found then
        Raise Exception ''Almacen % no Existe'',new.almacen;
    end if;
    
    select into r_adc_cxc_1 * from adc_cxc_1
    where almacen = new.almacen
    and documento = new.documento;
    if found then
        raise exception ''Documento % Ya Existe En el Almacen % en ajustes cxc de manifiesto...Verifique'',new.documento,new.almacen;
    end if;
    
    select into r_cxctrx1 * from cxctrx1
    where almacen = new.almacen
    and docm_ajuste_cxc = new.documento;
    if found then
        raise exception ''Documento % Ya Existe En el Almacen % en transacciones de cxc...Verifique'',new.documento,new.almacen;
    end if;
    
    select into r_adc_manifiesto * from adc_manifiesto
    where compania = new.compania
    and consecutivo = new.consecutivo;
    if not found then
        raise exception ''Manifiesto % no Existe...Verifique'',new.consecutivo;
    end if;
    
    select into r_fact_referencias * from fact_referencias
    where referencia = r_adc_manifiesto.referencia;
    
    if new.cliente is null then
        if r_fact_referencias.tipo = ''I'' then
            new.cliente = r_adc_manifiesto.from_agent;
        else
            new.cliente = r_adc_manifiesto.to_agent;
        end if;
    end if;
    
    
    select into r_clientes * from clientes
    where cliente = new.cliente;
    if not found then
        raise exception ''Codigo de Cliente % No Existe'',new.cliente;
    end if;
    
    ls_usuario = current_user;
    select into r_gral_usuarios * from gral_usuarios
    where trim(usuario) = trim(ls_usuario) and supervisor = ''S'';
    if not found then
        if Anio(r_adc_manifiesto.fecha) <> Anio(new.fecha)
            or Mes(r_adc_manifiesto.fecha) <> Mes(new.fecha) then
            raise exception ''Fecha del Ajuste Tiene que estar dentro del mes el registro del manifiesto'';
        end if;
    end if; 

    i := f_valida_fecha(new.compania, ''CXC'', new.fecha);
    i := f_valida_fecha(new.compania, ''CGL'', new.fecha);

    
    return new;
    
end;
' language plpgsql;



create function f_adc_cxc_2_before_update() returns trigger as '
declare
    r_adc_cxc_1 record;
    r_adc_manifiesto record;
    li_count int4;
    lc_work varchar(100);
    i integer;
begin
    delete from rela_adc_cxc_1_cglposteo
    where compania = old.compania
    and consecutivo = old.consecutivo
    and secuencia = old.secuencia;

    select into r_adc_cxc_1 * from adc_cxc_1
    where compania = old.compania
    and consecutivo = old.consecutivo
    and secuencia = old.secuencia;

    delete from cxcdocm
    where almacen = r_adc_cxc_1.almacen
    and documento = r_adc_cxc_1.documento
    and docmto_aplicar = r_adc_cxc_1.documento
    and motivo_cxc = r_adc_cxc_1.motivo_cxc;
    

    i   =   f_adc_valida_cuenta(new.compania, new.consecutivo, new.cuenta);
    
    return new;
    
end;
' language plpgsql;


create function f_adc_cxc_2_before_delete() returns trigger as '
declare
    r_adc_cxc_1 record;
begin
    delete from rela_adc_cxc_1_cglposteo
    where compania = old.compania
    and consecutivo = old.consecutivo
    and secuencia = old.secuencia;

    select into r_adc_cxc_1 * from adc_cxc_1
    where compania = old.compania
    and consecutivo = old.consecutivo
    and secuencia = old.secuencia;
    
    delete from cxcdocm
    where almacen = r_adc_cxc_1.almacen
    and documento = r_adc_cxc_1.documento
    and docmto_aplicar = r_adc_cxc_1.documento
    and motivo_cxc = r_adc_cxc_1.motivo_cxc;
    
    return old;
    
end;
' language plpgsql;



create function f_adc_cxc_1_before_delete() returns trigger as '
declare
    i integer;
begin

    delete from rela_adc_cxc_1_cglposteo
    where compania = old.compania
    and consecutivo = old.consecutivo
    and secuencia = old.secuencia;
    
    delete from cxcdocm
    where almacen = old.almacen
    and trim(documento) = trim(old.documento)
    and trim(docmto_aplicar) = trim(old.documento)
    and motivo_cxc = old.motivo_cxc;
    
    i := f_valida_fecha(old.compania, ''CXC'', old.fecha);
    i := f_valida_fecha(old.compania, ''CGL'', old.fecha);
    
    
    return old;
    
end;
' language plpgsql;

create function f_adc_cxc_1_before_update() returns trigger as '
declare
    r_adc_cxc_1 record;
    r_cxctrx1 record;
    r_adc_manifiesto record;
    r_clientes record;
    r_fact_referencias record;
    r_gral_usuarios record;
    r_almacen record;
    ls_usuario char(10);
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin

    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
    
    new.usuario         =   current_user;
    new.fecha_captura   =   current_timestamp;

    if new.almacen is null then
        Raise Exception ''Almacen es Obligatorio'';
    end if;
    
    
    select into r_almacen *
    from almacen
    where almacen = new.almacen;
    if not found then
        Raise Exception ''Almacen % no Existe'',new.almacen;
    end if;

    
    delete from rela_adc_cxc_1_cglposteo
    where compania = old.compania
    and consecutivo = old.consecutivo
    and secuencia = old.secuencia;
    
    delete from cxcdocm
    where almacen = old.almacen
    and trim(documento) = trim(old.documento)
    and trim(docmto_aplicar) = trim(old.documento)
    and motivo_cxc = old.motivo_cxc;

    if old.documento <> new.documento then
        select into r_adc_cxc_1 * from adc_cxc_1
        where almacen = new.almacen
        and documento = new.documento;
        if found then
            raise exception ''Documento % Ya Existe En el Almacen % en ajustes cxc de manifiesto...Verifique'',new.documento,new.almacen;
        end if;
    end if;
    
    select into r_cxctrx1 * from cxctrx1
    where almacen = new.almacen
    and docm_ajuste_cxc = new.documento;
    if found then
        raise exception ''Documento % Ya Existe En el Almacen % en transacciones de cxc...Verifique'',new.documento,new.almacen;
    end if;
    
    select into r_adc_manifiesto * from adc_manifiesto
    where compania = new.compania
    and consecutivo = new.consecutivo;
    if not found then
        raise exception ''Manifiesto % no Existe...Verifique'',new.consecutivo;
    end if;
    
    select into r_fact_referencias * from fact_referencias
    where referencia = r_adc_manifiesto.referencia;
    
    if new.cliente is null then
        if r_fact_referencias.tipo = ''I'' then
            new.cliente = r_adc_manifiesto.from_agent;
        else
            new.cliente = r_adc_manifiesto.to_agent;
        end if;
    end if;
    
    select into r_clientes * from clientes
    where cliente = new.cliente;
    if not found then
        raise exception ''Codigo de Cliente % No Existe'',new.cliente;
    end if;
    
    ls_usuario = current_user;
    select into r_gral_usuarios * from gral_usuarios
    where trim(usuario) = trim(ls_usuario) and supervisor = ''S'';
    if not found then
        if Anio(r_adc_manifiesto.fecha) <> Anio(new.fecha)
            or Mes(r_adc_manifiesto.fecha) <> Mes(new.fecha) then
            raise exception ''Fecha del Ajuste Tiene que estar dentro del mes el registro del manifiesto'';
        end if;
    end if; 
    
    i := f_valida_fecha(new.compania, ''CXC'', new.fecha);
    i := f_valida_fecha(new.compania, ''CGL'', new.fecha);
    
    return new;
    
end;
' language plpgsql;


create function f_rela_adc_cxc_1_cglposteo_after_delete() returns trigger as '
begin

    delete from cglposteo
    where consecutivo = old.cgl_consecutivo;
    
    return old;
    
end;
' language plpgsql;


create function f_adc_house_factura1_delete() returns trigger as '
declare
    r_factura1 record;
begin
    delete from factura1
    where almacen = old.almacen
    and tipo = old.tipo
    and num_documento = old.num_documento
    and caja = old.caja
    and tipo in (select tipo from factmotivos where cotizacion = ''S'');

    select into r_factura1 factura1.* from factura1, factmotivos
    where factura1.tipo = factmotivos.tipo
    and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
    and factura1.status <> ''A''
    and factura1.almacen = old.almacen
    and factura1.tipo = old.tipo
    and factura1.caja = old.caja
    and factura1.num_documento = old.num_documento;
    if found then
        select into r_factura1 factura1.*
        from factura1
        where almacen_aplica = old.almacen
        and caja_aplica = old.caja
        and tipo in (select tipo from factmotivos where devolucion = ''S'')
        and num_factura = old.num_documento;
        if not found then
            Raise Exception ''House no se puede modificar o eliminar...Tiene facturas asociadas...Verifique'';
        end if;
    end if;

    
    return old;
end;
' language plpgsql;



create function f_adc_house_before_delete() returns trigger as '
declare
    i integer;
    r_factura1 record;
begin
    select into r_factura1 factura1.* from factura1, adc_house_factura1, factmotivos
    where factura1.almacen = adc_house_factura1.almacen
    and factura1.tipo = adc_house_factura1.tipo
    and factura1.num_documento = adc_house_factura1.num_documento
    and factura1.tipo = factmotivos.tipo
    and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
    and adc_house_factura1.compania = old.compania
    and adc_house_factura1.consecutivo = old.consecutivo
    and adc_house_factura1.linea_master = old.linea_master
    and adc_house_factura1.linea_house = old.linea_house;
    if found then
        raise exception ''House % no puede ser eliminado pertenece a factura %'',old.no_house, r_factura1.num_documento;
    end if;
    
    i := f_adc_house_delete(old.compania, old.consecutivo, old.linea_master, old.linea_house);
    return old;
end;
' language plpgsql;


create function f_adc_house_before_update() returns trigger as '
declare
    i integer;
    r_factura1 record;
begin
    delete from adc_house_factura1
    where compania = old.compania
    and consecutivo = old.consecutivo
    and linea_master = old.linea_master
    and linea_house = old.linea_house
    and tipo in (select tipo from factmotivos where cotizacion = ''S'');
    
    if new.dthc is null then
        new.dthc = 0;
    end if;
    
    if new.dthc_prepago is null then
        new.dthc_prepago = ''N'';
    end if;



    if (old.fecha_sice is null and new.fecha_sice is not null) or
        (old.fecha_entrega is null and new.fecha_entrega is not null) or
        (old.fecha_inicio_almacenaje is null and new.fecha_inicio_almacenaje is not null) or
        (old.fecha_entrega <> new.fecha_entrega) or
        (old.observacion <> new.observacion) then
        return new;
    end if;

    if old.cliente = new.cliente and
        old.almacen = new.almacen and
        old.no_house = new.no_house and
        old.cargo = new.cargo and
        old.gtos_d_origen = new.gtos_d_origen then
        return new;
    end if;
    
    select into r_factura1 factura1.* from factura1, adc_house_factura1, factmotivos
    where factura1.almacen = adc_house_factura1.almacen
    and factura1.tipo = adc_house_factura1.tipo
    and factura1.num_documento = adc_house_factura1.num_documento
    and factura1.tipo = factmotivos.tipo
    and (factmotivos.factura = ''S'' or factmotivos.factura_fiscal = ''S'')
    and adc_house_factura1.compania = old.compania
    and adc_house_factura1.consecutivo = old.consecutivo
    and adc_house_factura1.linea_master = old.linea_master
    and adc_house_factura1.linea_house = old.linea_house
    and adc_house_factura1.linea_manejo is null;
    if found then
        raise exception ''House % no puede ser modificado pertenece a factura %'',old.no_house, r_factura1.num_documento;
    end if;
    
    
    i := f_adc_house_delete(old.compania, old.consecutivo, old.linea_master, old.linea_house);
    
    return new;
end;
' language plpgsql;

create function f_adc_house_before_insert() returns trigger as '
declare
    i integer;
    r_factura1 record;
    r_adc_house record;
begin
    if new.dthc is null then
        new.dthc = 0;
    end if;
    
    if new.dthc_prepago is null then
        new.dthc_prepago = ''N'';
    end if;
    
    
    if new.ciudad is null then
        raise exception ''Codigo de Ciudad es Obligatorio'';
    end if;
    
    if new.tipo is null then
        raise exception ''Tipo es Obligatorio'';
    end if;
    
    loop
        select into r_adc_house * from adc_house
        where compania = new.compania
        and consecutivo = new.consecutivo
        and linea_master = new.linea_master
        and linea_house = new.linea_house;
        if not found then
            exit;
        else
            new.linea_house = new.linea_house + 1;
        end if;
    end loop;
    return new;
end;
' language plpgsql;

create function f_rela_adc_master_cglposteo_delete() returns trigger as '
begin

    delete from cglposteo
    where consecutivo = old.cgl_consecutivo;
    
    return old;
    
end;
' language plpgsql;


create function f_rela_adc_master_cglposteo_before_delete() returns trigger as '
begin

    delete from cglposteo
    where consecutivo = old.cgl_consecutivo;
    
    return old;
    
end;
' language plpgsql;



create function f_adc_master_before_delete() returns trigger as '
declare
    i integer;
    r_navieras record;
    r_adc_manifiesto record;
begin
    select into r_adc_manifiesto * 
    from adc_manifiesto
    where adc_manifiesto.compania = old.compania
    and adc_manifiesto.consecutivo = old.consecutivo;
    if found then
        i := f_valida_fecha(old.compania, ''CGL'', r_adc_manifiesto.fecha);
    end if;
    
    select into r_navieras *
    from navieras
    where cod_naviera = r_adc_manifiesto.cod_naviera;
    
    
    delete from cxpdocm
    where compania = old.compania
    and proveedor = r_navieras.proveedor
    and trim(documento) = trim(old.container)
    and trim(docmto_aplicar) = trim(old.container)
    and motivo_cxp in (select motivo_cxp from cxpmotivos where factura = ''S'');
    
   
    delete from rela_adc_master_cglposteo
    where compania = old.compania
    and consecutivo = old.consecutivo
    and linea_master = old.linea_master;
    
--    i := f_adc_master_delete(old.compania, old.consecutivo, old.linea_master);
    return old;
end;
' language plpgsql;


create function f_adc_master_before_update() returns trigger as '
declare
    i integer;
    r_adc_manifiesto record;
    r_navieras record;
begin
    select into r_adc_manifiesto * 
    from adc_manifiesto
    where adc_manifiesto.compania = old.compania
    and adc_manifiesto.consecutivo = old.consecutivo;
    if found then
        i := f_valida_fecha(old.compania, ''CGL'', r_adc_manifiesto.fecha);
    end if;
    
    select into r_navieras *
    from navieras
    where cod_naviera = r_adc_manifiesto.cod_naviera;

    delete from cxpdocm
    where compania = old.compania
    and proveedor = r_navieras.proveedor
    and trim(documento) = trim(old.container)
    and trim(docmto_aplicar) = trim(old.container)
    and motivo_cxp in (select motivo_cxp from cxpmotivos where factura = ''S'');


    delete from rela_adc_master_cglposteo
    where compania = old.compania
    and consecutivo = old.consecutivo
    and linea_master = old.linea_master;
    
--    i := f_adc_master_delete(old.compania, old.consecutivo, old.linea_master);
    return new;
end;
' language plpgsql;


create trigger t_rela_adc_master_cglposteo_delete after delete or update on rela_adc_master_cglposteo
for each row execute procedure f_rela_adc_master_cglposteo_delete();

create trigger t_rela_adc_master_cglposteo_before_delete before delete or update on rela_adc_master_cglposteo
for each row execute procedure f_rela_adc_master_cglposteo_before_delete();


create trigger t_adc_master_before_delete before delete on adc_master
for each row execute procedure f_adc_master_before_delete();

create trigger t_adc_master_before_update before update on adc_master
for each row execute procedure f_adc_master_before_update();

create trigger t_adc_master_before_insert before insert on adc_master
for each row execute procedure f_adc_master_before_insert();


create trigger t_adc_manifiesto_before_delete before delete on adc_manifiesto
for each row execute procedure f_adc_manifiesto_before_delete();

create trigger t_adc_manifiesto_before_update before update on adc_manifiesto
for each row execute procedure f_adc_manifiesto_before_update();


create trigger t_adc_entrega_mercancia_before_insert before insert on adc_entrega_mercancia
for each row execute procedure f_adc_entrega_mercancia_before_insert();


create trigger t_adc_entrega_mercancia_after_insert after insert on adc_entrega_mercancia
for each row execute procedure f_adc_entrega_mercancia_after_insert();

create trigger t_adc_entrega_mercancia_before_delete before delete on adc_entrega_mercancia
for each row execute procedure f_adc_entrega_mercancia_before_delete();

create trigger t_adc_entrega_mercancia_before_update before update on adc_entrega_mercancia
for each row execute procedure f_adc_entrega_mercancia_before_update();


create trigger t_adc_house_factura1_delete after delete or update on adc_house_factura1
for each row execute procedure f_adc_house_factura1_delete();

create trigger t_adc_house_before_delete before delete on adc_house
for each row execute procedure f_adc_house_before_delete();

create trigger t_adc_house_before_update before update on adc_house
for each row execute procedure f_adc_house_before_update();

create trigger t_adc_house_before_insert before insert on adc_house
for each row execute procedure f_adc_house_before_insert();


create trigger t_rela_adc_cxc_1_cglposteo_after_delete after delete on rela_adc_cxc_1_cglposteo
for each row execute procedure f_rela_adc_cxc_1_cglposteo_after_delete();

create trigger t_adc_cxc_1_before_insert before insert on adc_cxc_1
for each row execute procedure f_adc_cxc_1_before_insert();

create trigger t_adc_cxc_1_before_update before update on adc_cxc_1
for each row execute procedure f_adc_cxc_1_before_update();

create trigger t_adc_houser_after_insert_update after insert or update on adc_house
for each row execute procedure f_adc_house_after_insert_update();


create trigger t_adc_cxc_1_before_delete before delete on adc_cxc_1
for each row execute procedure f_adc_cxc_1_before_delete();

create trigger t_adc_cxc_2_before_insert before insert on adc_cxc_2
for each row execute procedure f_adc_cxc_2_before_insert();

create trigger t_adc_cxc_2_before_update before update on adc_cxc_2
for each row execute procedure f_adc_cxc_2_before_update();

create trigger t_adc_cxc_2_before_delete before delete on adc_cxc_2
for each row execute procedure f_adc_cxc_2_before_delete();

create trigger t_adc_si_before_update before insert or update on adc_si
for each row execute procedure f_adc_si_before_update();

create trigger t_adc_manejo_factura1 before delete on adc_manejo_factura1
for each row execute procedure f_adc_manejo_factura1_before_delete();

create trigger t_adc_si_after_insert_update after insert or update on adc_si
for each row execute procedure f_adc_si_after_insert_update();

create trigger t_adc_pl_after_insert_update after insert or update on adc_pl
for each row execute procedure f_adc_pl_after_insert_update();

create trigger t_adc_manifiesto_before_insert_update after insert or update on adc_manifiesto
for each row execute procedure f_adc_manifiesto_before_insert_update();

create trigger t_adc_si_before_insert_update before insert or update on adc_si
for each row execute procedure f_adc_si_before_insert_update();

create trigger t_adc_control_de_contenedores_before_insert_update before insert or update on adc_control_de_contenedores
for each row execute procedure f_adc_control_de_contenedores_before_insert_update();

create trigger t_adc_cxp_2_before_update before update on adc_cxp_2
for each row execute procedure f_adc_cxp_2_before_update();

create trigger t_adc_cxp_2_before_insert before insert on adc_cxp_2
for each row execute procedure f_adc_cxp_2_before_insert();


create trigger t_adc_manejo_before_update before update on adc_manejo
for each row execute procedure f_adc_manejo_before_update();

create trigger t_adc_manejo_before_delete before delete on adc_manejo
for each row execute procedure f_adc_manejo_before_delete();

create trigger t_adc_notas_debito_1_before_delete before delete on adc_notas_debito_1
for each row execute procedure f_adc_notas_debito_1_before_delete();

create trigger t_adc_notas_debito_1_before_update before update on adc_notas_debito_1
for each row execute procedure f_adc_notas_debito_1_before_update();

create trigger t_adc_notas_debito_2_before_update before update on adc_notas_debito_2
for each row execute procedure f_adc_notas_debito_2_before_update();

create trigger t_adc_notas_debito_2_before_delete before delete on adc_notas_debito_2
for each row execute procedure f_adc_notas_debito_2_before_delete();

create trigger t_adc_house_factura1_before_delete before delete on adc_house_factura1
for each row execute procedure f_adc_house_factura1_before_delete();

create trigger t_adc_manifiesto_after_insert after insert on adc_manifiesto
for each row execute procedure f_adc_manifiesto_after_insert();

create trigger t_adc_manifiesto_after_update after update on adc_manifiesto
for each row execute procedure f_adc_manifiesto_after_update();

create trigger t_adc_manifiesto_after_delete after delete on adc_manifiesto
for each row execute procedure f_adc_manifiesto_after_delete();

create trigger t_adc_master_after_insert after insert on adc_master
for each row execute procedure f_adc_master_after_insert();

create trigger t_adc_master_after_update after update on adc_master
for each row execute procedure f_adc_master_after_update();

create trigger t_adc_master_after_delete after delete on adc_master
for each row execute procedure f_adc_master_after_delete();

create trigger t_adc_cxp_1_after_delete after delete on adc_cxp_1
for each row execute procedure f_adc_cxp_1_after_delete();

create trigger t_adc_cxp_1_after_insert after insert on adc_cxp_1
for each row execute procedure f_adc_cxp_1_after_insert();

create trigger t_adc_cxp_1_after_update after update on adc_cxp_1
for each row execute procedure f_adc_cxp_1_after_update();
