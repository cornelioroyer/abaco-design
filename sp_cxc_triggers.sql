

drop function f_rela_cxc_recibo1_cglposteo_after_delete() cascade;
drop function f_cxc_recibo1_after_delete() cascade;
drop function f_cxc_recibo1_before_update() cascade;
drop function f_cxc_recibo2_before_insert() cascade;
drop function f_cxc_recibo2_before_delete() cascade;
drop function f_cxc_recibo2_before_update() cascade;
drop function f_cxc_recibo2_after_delete() cascade;
drop function f_cxc_recibo2_after_update() cascade;

drop function f_cxc_recibo3_before_delete() cascade;
drop function f_cxc_recibo3_before_update() cascade;
drop function f_cxc_recibo3_after_delete() cascade;
drop function f_cxc_recibo3_after_update() cascade;

drop function f_cxctrx1_before_insert() cascade;
drop function f_cxctrx1_before_update() cascade;
drop function f_cxctrx1_before_delete() cascade;
drop function f_cxctrx1_after_delete() cascade;
drop function f_cxctrx1_after_update() cascade;

drop function f_rela_cxctrx1_cglposteo_after_delete() cascade;

drop function f_cxctrx2_before_insert() cascade;
drop function f_cxctrx2_before_update() cascade;
drop function f_cxctrx2_before_delete() cascade;
drop function f_cxctrx2_after_update() cascade;
drop function f_cxctrx2_after_delete() cascade;

drop function f_cxctrx3_before_insert() cascade;
drop function f_cxctrx3_before_delete() cascade;
drop function f_cxctrx3_before_update() cascade;
drop function f_cxctrx3_after_delete() cascade;
drop function f_cxctrx3_after_update() cascade;


drop function f_clientes_before_update() cascade;
drop function f_clientes_before_insert() cascade;
drop function f_clientes_after_insert() cascade;
drop function f_clientes_after_update() cascade;
drop function f_cxc_recibo1_before_insert() cascade;

drop function f_cxcdocm_after_insert() cascade;
drop function f_cxcdocm_after_delete() cascade;
drop function f_cxcdocm_after_update() cascade;
drop function f_cxcdocm_before_insert() cascade;
drop function f_cxcdocm_before_update() cascade;
drop function f_cxcdocm_before_delete() cascade;

drop function f_cxc_recibo3_before_insert() cascade;
drop function f_cxc_recibo4_before_insert() cascade;
drop function f_cxc_recibo5_before_insert() cascade;
drop function f_cxcmorosidad_before_insert() cascade;
drop function f_cxc_recibo1_before_delete() cascade;
drop function f_cxc_recibo1_after_insert() cascade;
drop function f_cxc_recibo_before_insert() cascade;
drop function f_cxc_recibo_detalle_before_insert() cascade;
drop function f_cxc_edc_winsoft_before_insert() cascade;


create function f_cxc_edc_winsoft_before_insert() returns trigger as '
declare
    i int4;
begin
    new.morosidad1  =   0;
    new.morosidad2  =   0;
    new.morosidad3  =   0;
    new.morosidad4  =   0;
    new.morosidad5  =   0;
    
    new.mes1        =   ''mes1'';
    new.mes2        =   ''mes2'';
    new.mes3        =   ''mes3'';
    new.mes4        =   ''mes4'';
    new.mes5        =   ''mes5'';
    

    
    return new;
end;
' language plpgsql;




create function f_cxc_recibo_before_insert() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
    r_fac_cajas record;
begin
    select into r_fac_cajas *
    from fac_cajas
    where almacen = new.almacen
    and status = ''A'';
    if found then
        new.caja = r_fac_cajas.caja;
    else
        Raise Exception ''No existe caja activa...Verifique'';        
    end if;
    
    return new;
end;
' language plpgsql;


create function f_cxc_recibo_detalle_before_insert() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
    r_fac_cajas record;
begin
    select into r_fac_cajas *
    from fac_cajas
    where almacen = new.almacen
    and status = ''A'';
    if found then
        new.caja = r_fac_cajas.caja;
    else
        Raise Exception ''Caja Activa no Existe...Verifique'';        
    end if;
    
    return new;
end;
' language plpgsql;


create function f_cxc_recibo1_after_insert() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/    
    return new;
end;
' language plpgsql;


create function f_cxc_recibo1_before_delete() returns trigger as '
declare
    li_work integer;
    i integer;
    r_almacen record;
begin

--    and caja = old.caja

    delete from cxcdocm
    where almacen = old.almacen
    and cliente = old.cliente
    and motivo_cxc = old.motivo_cxc
    and fecha_posteo = old.fecha
    and trim(documento) = trim(old.documento);


    i   =   f_delete_rela_cxc_recibo1_cglposteo(old.almacen, old.caja, old.consecutivo);

    i   =   f_cxc_recibo1_before_delete(old.almacen, old.caja, old.consecutivo);

    return old;
end;
' language plpgsql;



create function f_cxcmorosidad_before_insert() returns trigger as '
declare
    r_fac_cajas record;
begin

    select into r_fac_cajas * from fac_cajas
    where almacen = new.almacen
    and status = ''A'';
    if not found then
        Raise Exception ''Caja no Existe en Almacen %'', new.almacen;
    end if;
    
    new.caja = r_fac_cajas.caja;
    
    return new;
end;
' language plpgsql;



create function f_cxctrx3_before_insert() returns trigger as '
declare
    r_cxctrx2 record;
    r_cxctrx1 record;
    r_cxcdocm record;
    r_fac_cajas record;
    r_cxctrx3 record;
begin

    select into r_fac_cajas * from fac_cajas
    where almacen = new.almacen
    and status = ''A'';
    if not found then
        Raise Exception ''Caja no Existe en Almacen %'', new.almacen;
    end if;
    
    new.caja = r_fac_cajas.caja;
    
    while 1=1 loop
        select into r_cxctrx3 *
        from cxctrx3
        where almacen = new.almacen
        and sec_ajuste_cxc = new.sec_ajuste_cxc
        and caja = new.caja
        and linea = new.linea;
        if found then
            new.linea = new.linea + 1;
        else
            exit;
        end if;            
    end loop;
    
    return new;
end;
' language plpgsql;



create function f_cxc_recibo5_before_insert() returns trigger as '
declare
    li_work integer;
    r_cxc_recibo1 record;
    r_cxc_recibo2 record;
    r_cxcdocm record;
    r_fac_cajas record;
begin


    if new.caja is null then
        select into r_fac_cajas *
        from fac_cajas
        where almacen = new.almacen
        and status = ''A'';
        if not found then
            Raise Exception ''No existe caja para el almacen %'',new.almacen;
        else
            new.caja = r_fac_cajas.caja;
        end if;        
        
    end if;
    
    new.usuario = current_user;


    return new;
end;
' language plpgsql;


create function f_cxc_recibo4_before_insert() returns trigger as '
declare
    li_work integer;
    r_cxc_recibo1 record;
    r_cxc_recibo2 record;
    r_cxcdocm record;
    r_fac_cajas record;
begin

    if new.caja is null then
        select into r_fac_cajas *
        from fac_cajas
        where almacen = new.almacen
        and status = ''A'';
        if not found then
            Raise Exception ''No existe caja para el almacen %'',new.almacen;
        else
            new.caja = r_fac_cajas.caja;
        end if;        
    end if;


    return new;
end;
' language plpgsql;




create function f_cxc_recibo3_before_insert() returns trigger as '
declare
    li_work integer;
    r_cxc_recibo1 record;
    r_cxc_recibo2 record;
    r_cxcdocm record;
    r_fac_cajas record;
begin

        select into r_fac_cajas *
        from fac_cajas
        where almacen = new.almacen
        and status = ''A'';
        if not found then
            Raise Exception ''No existe caja para el almacen %'',new.almacen;
        else
            new.caja = r_fac_cajas.caja;
        end if;        


    return new;
end;
' language plpgsql;




create function f_cxctrx1_before_insert() returns trigger as '
declare
    r_clientes record;
    r_almacen record;
    r_fac_cajas record;
    i integer;
begin
    select into r_clientes * from clientes
    where cliente = new.cliente and status = ''I'';
    if found then
        raise exception ''Cliente % Esta Inactivo...Verifique'',new.cliente;
    end if;
    
    
    select into r_almacen * from almacen
    where almacen = new.almacen;
    if not found then
        Raise Exception ''Almacen % no Existe'', new.almacen;
    end if;

    if new.caja is null then    
        select into r_fac_cajas * from fac_cajas
        where almacen = new.almacen
        and status = ''A'';
        if not found then
            Raise Exception ''Caja no Existe en Almacen %'', new.almacen;
        end if;
    
        new.caja = r_fac_cajas.caja;
    end if;    
    
    i := f_valida_fecha(r_almacen.compania, ''CXC'', new.fecha_posteo_ajuste_cxc);
    i := f_valida_fecha(r_almacen.compania, ''CGL'', new.fecha_posteo_ajuste_cxc);
    
    return new;
end;
' language plpgsql;



create function f_cxc_recibo1_before_insert() returns trigger as '
declare
    r_clientes record;
    r_fac_cajas record;
begin
    select into r_clientes * from clientes
    where cliente = new.cliente and status = ''I'';
    if found then
        raise exception ''Cliente % Esta Inactivo...Verifique'',new.cliente;
    end if;
    
    if new.caja is null then
        select into r_fac_cajas *
        from fac_cajas
        where almacen = new.almacen
        and status = ''A'';
        if not found then
            Raise Exception ''No existe caja para el almacen %'',new.almacen;
        else
            new.caja = r_fac_cajas.caja;
        end if;        
    else
        select into r_fac_cajas *
        from fac_cajas
        where almacen = new.almacen
        and caja = new.caja;
        if not found then
            Raise Exception ''Caja % No existe para el almacen %'',new.caja, new.almacen;
        else
            if r_fac_cajas.status = ''I'' then
                Raise Exception ''Caja % en Almacen % esta Inactiva'', new.caja, new.almacen;
            end if;            
        end if;        
    end if;
    
    return new;
end;
' language plpgsql;



create function f_cxc_recibo2_before_insert() returns trigger as '
declare
    li_work integer;
    r_cxc_recibo1 record;
    r_cxc_recibo2 record;
    r_cxcdocm record;
    r_fac_cajas record;
begin
    if new.monto_aplicar = 0 then
        return new;
    end if;
    
    if new.caja is null then
        Raise Exception ''Caja no puede ser nula en cxc_recibo2'';
    end if;        

    select into r_cxc_recibo1 * from cxc_recibo1
    where almacen = new.almacen
    and caja = new.caja
    and consecutivo = new.consecutivo;
    if not found then
        raise exception ''Recibo % del Almacen % no existe en cxc_recibo1'',new.consecutivo, new.almacen;
    end if;

    select into r_fac_cajas *
    from fac_cajas
    where almacen = new.almacen
    and status = ''A'';
    if not found then
        Raise Exception ''No existe caja para el almacen %'',new.almacen;
    else
        new.caja = r_fac_cajas.caja;
    end if;        

    if new.caja_aplicar is null then
        select into r_fac_cajas *
        from fac_cajas
        where almacen = new.almacen_aplicar
        and status = ''A'';
        if not found then
            Raise Exception ''No existe caja para el almacen %'',new.almacen;
        else
            new.caja_aplicar = r_fac_cajas.caja;
        end if;        
    end if;

    

    select into r_cxc_recibo2 * from cxc_recibo2
    where almacen = new.almacen
    and consecutivo = new.consecutivo
    and documento_aplicar = new.documento_aplicar
    and monto_aplicar <> 0;
    if found then
        raise exception ''No se puede aplicar al mismo documento % dos veces...Verifique'',new.documento_aplicar;
    end if;
    
    
    select into r_cxc_recibo1 * from cxc_recibo1
    where almacen = new.almacen
    and consecutivo = new.consecutivo
    and documento = new.documento_aplicar
    and motivo_cxc = new.motivo_aplicar;
    if found then
        raise exception ''No se puede aplicar al mismo documento %'',new.documento_aplicar;
    end if;
    
    select into r_cxc_recibo1 * from cxc_recibo1
    where almacen = new.almacen
    and consecutivo = new.consecutivo;
    

    select into r_cxcdocm * from cxcdocm
    where almacen = new.almacen_aplicar
    and cliente = r_cxc_recibo1.cliente
    and documento = new.documento_aplicar
    and docmto_aplicar = new.documento_aplicar
    and motivo_cxc = new.motivo_aplicar;
    if not found then
        raise exception ''Documento Aplicar % no existe en el almacen %...Verifique'',new.documento_aplicar,new.almacen_aplicar;
    end if;

    return new;
end;
' language plpgsql;



create function f_cxc_recibo2_before_delete() returns trigger as '
declare
    li_work integer;
    r_cxc_recibo1 record;
    r_cxcdocm record;
    i integer;
begin

    i   =   f_delete_rela_cxc_recibo1_cglposteo(old.almacen, old.caja, old.consecutivo);
    i   =   f_cxc_recibo1_before_delete(old.almacen, old.caja, old.consecutivo);

    return old;
end;
' language plpgsql;

create function f_cxc_recibo2_before_update() returns trigger as '
declare
    li_work integer;
    r_cxc_recibo1 record;
    r_cxcdocm record;
    i integer;
begin

    i   =   f_delete_rela_cxc_recibo1_cglposteo(old.almacen, old.caja, old.consecutivo);
    i   =   f_cxc_recibo1_before_delete(old.almacen, old.caja, old.consecutivo);

    return new;
end;
' language plpgsql;


create function f_rela_cxc_recibo1_cglposteo_after_delete() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/

    delete from cglposteo
    where consecutivo = old.consecutivo;

    
    return old;
end;
' language plpgsql;




create function f_cxc_recibo3_before_update() returns trigger as '
declare
    r_cxc_recibo1 record;
    i integer;
begin
    i   =   f_delete_rela_cxc_recibo1_cglposteo(old.almacen, old.caja, old.consecutivo);

    i   =   f_cxc_recibo1_before_delete(old.almacen, old.caja, old.consecutivo);

/*
    delete from rela_cxc_recibo1_cglposteo
    where almacen = old.almacen
    and cxc_consecutivo = old.consecutivo;
    
    select into r_cxc_recibo1 * from cxc_recibo1
    where almacen = old.almacen
    and consecutivo = old.consecutivo;
    if not found then
        return old;
    end if;
    
    delete from cxcdocm
    where cliente = r_cxc_recibo1.cliente
    and documento = r_cxc_recibo1.documento
    and fecha_posteo = r_cxc_recibo1.fecha
    and motivo_cxc = r_cxc_recibo1.motivo_cxc;
*/
        
    return new;
end;
' language plpgsql;


create function f_cxc_recibo3_before_delete() returns trigger as '
declare
    r_cxc_recibo1 record;
    i integer;
begin
    i   =   f_delete_rela_cxc_recibo1_cglposteo(old.almacen, old.caja, old.consecutivo);

    i   =   f_cxc_recibo1_before_delete(old.almacen, old.caja, old.consecutivo);

    return old;
end;
' language plpgsql;


create function f_cxc_recibo3_after_delete() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin

/*
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    
/*
    delete from rela_cxc_recibo1_cglposteo
    where almacen = old.almacen
    and cxc_consecutivo = old.consecutivo;
*/    
    return old;
end;
' language plpgsql;


create function f_cxc_recibo3_after_update() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/    
/*
    delete from rela_cxc_recibo1_cglposteo
    where almacen = old.almacen
    and cxc_consecutivo = old.consecutivo;
*/
    
    return new;
end;
' language plpgsql;



create function f_cxc_recibo1_before_update() returns trigger as '
declare
    li_work integer;
    i integer;
    r_almacen record;
begin
    delete from cxcdocm
    where almacen = old.almacen
    and caja = old.caja
    and cliente = old.cliente
    and motivo_cxc = old.motivo_cxc
    and fecha_posteo = old.fecha;

    i   =   f_delete_rela_cxc_recibo1_cglposteo(old.almacen, old.caja, old.consecutivo);

    i   =   f_cxc_recibo1_before_delete(old.almacen, old.caja, old.consecutivo);


    return new;
end;
' language plpgsql;


create function f_cxc_recibo1_after_delete() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/

/*
    delete from rela_cxc_recibo1_cglposteo
    where almacen = old.almacen
    and cxc_consecutivo = old.consecutivo;


    delete from cxcdocm
    where trim(documento) = trim(old.documento)
    and trim(cliente) = trim(old.cliente)
    and trim(motivo_cxc) = trim(old.motivo_cxc)
    and fecha_posteo = old.fecha
    and trim(almacen) = trim(old.almacen);
*/    
    
    return old;
end;
' language plpgsql;


create function f_cxc_recibo2_after_update() returns trigger as '
declare
    li_work integer;
    r_cxc_recibo1 record;
    r_cxcdocm record;
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    
/*
    delete from rela_cxc_recibo1_cglposteo
    where almacen = old.almacen
    and cxc_consecutivo = old.consecutivo;
    
    if old.monto_aplicar = 0 and new.monto_aplicar = 0 then
        return new;
    end if;
    
    
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
    and fecha_posteo = r_cxc_recibo1.fecha
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
    and fecha_posteo = r_cxc_recibo1.fecha
    and motivo_cxc = r_cxc_recibo1.motivo_cxc;
*/    
    return new;
end;
' language plpgsql;


create function f_cxc_recibo2_after_delete() returns trigger as '
declare
    li_work integer;
    r_cxc_recibo1 record;
    r_cxcdocm record;
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    
/*
    delete from rela_cxc_recibo1_cglposteo
    where almacen = old.almacen
    and cxc_consecutivo = old.consecutivo;
    
    if old.monto_aplicar = 0 then
        return new;
    end if;
    

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
    and fecha_posteo = r_cxc_recibo1.fecha
    and motivo_cxc = r_cxc_recibo1.motivo_cxc;
*/        
    return old;
end;
' language plpgsql;



create function f_clientes_after_insert() returns trigger as '
declare
    r_cglauxiliares record;
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    

    if trim(f_gralparaxapli(''CXC'',''crea_clte_como_aux'')) = ''S'' then
        select into r_cglauxiliares * from cglauxiliares
        where trim(auxiliar) = trim(new.cliente);
        if not found then
            insert into cglauxiliares(auxiliar, nombre, tipo_persona, status, id, dv)
            values (new.cliente, substring(new.nomb_cliente from 1 for 30),new.tipo_de_persona,''A'', new.id, new.dv);
        end if;
    end if;
    
    i   =   f_insert_agrupaciones_clientes(new.cliente);
    return new;
end;
' language plpgsql;


create function f_clientes_after_update() returns trigger as '
declare
    r_cglauxiliares record;
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    if trim(f_gralparaxapli(''CXC'',''crea_clte_como_aux'')) = ''S'' then
        update cglauxiliares
        set nombre = substring(new.nomb_cliente from 1 for 30),
        id = new.id, dv = new.dv, tipo_persona = new.tipo_de_persona
        where trim(auxiliar) = trim(new.cliente);
    end if;

    i   =   f_insert_agrupaciones_clientes(new.cliente);
    
    return new;
end;
' language plpgsql;


create function f_clientes_before_insert() returns trigger as '
declare
    r_cxcdocm record;
    r_cglcuentas record;
    r_cglniveles record;
    r_rhuempl record;
begin
    if trim(f_gralparaxapli(''CXC'',''crea_clte_como_aux'')) = ''S'' then
        if f_gralparaxcia(''02'', ''PLA'', ''metodo_calculo'') <> ''coolhouse'' then
            select into r_rhuempl * from rhuempl
            where trim(codigo_empleado) = trim(new.cliente);
            if found then
                raise exception ''Codigo de Cliente % Ya Existe como codigo de Empleado...Verifique'',new.cliente;
            end if;
        end if;
    end if;
        
    select into r_cglcuentas * from cglcuentas
    where cuenta = new.cuenta;
    if not found then
        raise exception ''Cuenta contable % no Existe'',new.cuenta;
    end if;
    
    select into r_cglniveles * from cglniveles
    where nivel = r_cglcuentas.nivel;
    if not found then
        raise exception ''Cuenta contable % no pertenece a ningun nivel valido'',new.cuenta;
    end if;
    
    if r_cglniveles.recibe = ''N'' then
        raise exception ''Cuenta contable % no recibe movimientos'',new.cuenta;
    end if;
    
    return new;
end;
' language plpgsql;

create function f_clientes_before_update() returns trigger as '
declare
    r_cxcdocm record;
    r_cglcuentas record;
    r_cglniveles record;
begin
    select into r_cglcuentas * from cglcuentas
    where cuenta = new.cuenta;
    if not found then
        raise exception ''Cuenta contable % no Existe'',new.cuenta;
    end if;
    
    select into r_cglniveles * from cglniveles
    where nivel = r_cglcuentas.nivel;
    if not found then
        raise exception ''Cuenta contable % no pertenece a ningun nivel valido'',new.cuenta;
    end if;
    
    if r_cglniveles.recibe = ''N'' then
        raise exception ''Cuenta contable % no recibe movimientos'',new.cuenta;
    end if;

    select into r_cglcuentas *
    from cglcuentas
    where cuenta = old.cuenta;

    if old.cuenta <> new.cuenta and r_cglcuentas.naturaleza = 1 then
        select into r_cxcdocm * from cxcdocm
        where cliente = new.cliente;
        if found then
            raise exception ''Cuenta Contable no puede ser Modificada por que tiene movimientos...Verifique'';
        end if;
    end if;
    return new;
end;
' language plpgsql;


create function f_cxcdocm_before_update() returns trigger as '
declare
    li_count integer;
    r_almacen record;
    r_cxcdocm record;
    i integer;
begin
    if old.fecha_posteo <= ''2012-11-30'' then
        Raise Exception ''no se puede modificar'';
    end if;


    if old.monto = 0 and new.monto = 0 then
        return new;
    end if;
    
    select into r_almacen * from almacen
    where almacen = old.almacen;
    
    if Trim(f_gralparaxcia(r_almacen.compania, ''CXC'', ''validar_fecha'')) = ''S'' then
        i := f_valida_fecha(r_almacen.compania, ''CGL'', old.fecha_posteo);
        i := f_valida_fecha(r_almacen.compania, ''CXC'', old.fecha_posteo);
    end if;
        
    if new.documento <> new.docmto_aplicar then    
        select into r_cxcdocm * from cxcdocm
        where almacen = new.almacen
        and cliente = new.cliente
        and documento = new.docmto_aplicar
        and docmto_aplicar = new.docmto_ref
        and motivo_cxc = new.motivo_ref;
        if not found then
            raise exception ''Documento Madre Almacen % Cliente % Documento % Motivo % No Existe...Verifique'',new.almacen, new.cliente, new.docmto_aplicar, new.motivo_ref;
        else
            if r_cxcdocm.fecha_posteo > new.fecha_posteo then
                raise exception ''Documento Madre Almacen % Cliente % Documento % Motivo % tiene fecha % posterior %...Verifique'',new.almacen, new.cliente, new.docmto_aplicar, new.motivo_ref,r_cxcdocm.fecha_posteo, new.fecha_posteo;
            end if;
        end if;
    end if;
    
    
    if old.documento = old.docmto_aplicar
        and old.motivo_cxc = old.motivo_ref then
        li_count = 0;
        select into li_count count(*) from cxcdocm
        where almacen = old.almacen
        and cliente = old.cliente
        and docmto_aplicar = old.docmto_aplicar
        and docmto_ref = old.docmto_ref
        and motivo_ref = old.motivo_ref;
        if li_count > 1 then
            raise exception ''Documento % de Cliente % no puede ser modificado.  Tiene aplicaciones...Verifique'', old.docmto_aplicar, old.cliente;
        end if;
    end if;    
    return new;
end;
' language plpgsql;


create function f_cxcdocm_before_delete() returns trigger as '
declare
    li_count integer;
    r_almacen record;
    i integer;
begin
/*
    if old.fecha_posteo <= ''2012-11-30'' then
        Raise Exception ''no se puede borrar'';
    end if;
*/
    
    if old.monto = 0 then
        return old;
    end if;
    
    select into r_almacen * from almacen
    where almacen = old.almacen;
    
    if Trim(f_gralparaxcia(r_almacen.compania, ''CXC'', ''validar_fecha'')) = ''S'' then
        i := f_valida_fecha(r_almacen.compania, ''CGL'', old.fecha_posteo);
        i := f_valida_fecha(r_almacen.compania, ''CXC'', old.fecha_posteo);
    end if;
    
    if old.documento = old.docmto_aplicar
        and old.motivo_cxc = old.motivo_ref then
        li_count = 0;
        select into li_count count(*) from cxcdocm
        where almacen = old.almacen
        and cliente = old.cliente
        and caja = old.caja
        and docmto_aplicar = old.docmto_aplicar
        and docmto_ref = old.docmto_ref
        and motivo_ref = old.motivo_ref;
    
        if li_count > 1 then
            raise exception ''Documento % de Cliente % no puede ser eliminado.  Tiene aplicaciones...Verifique'', old.docmto_aplicar, old.cliente;
        end if;
    end if;    
    return old;
end;
' language plpgsql;


create function f_cxcdocm_after_delete() returns trigger as '
declare
    r_cxctrx1 record;
    r_cxcdocm record;
    r_gralperiodos record;
    r_almacen record;
    r_cxcmotivos record;
    r_cxcbalance record;
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/

    if old.monto = 0 then
        return old;
    end if;
    
    select into r_almacen * from almacen
    where almacen = old.almacen;

    
    
    select into r_gralperiodos * from gralperiodos
    where compania = r_almacen.compania
    and aplicacion = ''CXC''
    and old.fecha_posteo between inicio and final;
    
    
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


create function f_cxcdocm_after_update() returns trigger as '
declare
    r_cxctrx1 record;
    r_cxcdocm record;
    r_gralperiodos record;
    r_almacen record;
    r_cxcmotivos record;
    r_cxcbalance record;
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/

    if old.monto = 0 then
        return old;
    end if;
    
    select into r_almacen * from almacen
    where almacen = old.almacen;

    i := f_valida_fecha(r_almacen.compania, ''CGL'', old.fecha_posteo);
    i := f_valida_fecha(r_almacen.compania, ''CXC'', old.fecha_posteo);
    
    
    select into r_cxcmotivos * from cxcmotivos
    where motivo_cxc = old.motivo_cxc;
    
    select into r_gralperiodos * from gralperiodos
    where compania = r_almacen.compania
    and aplicacion = ''CXC''
    and old.fecha_posteo between inicio and final;
    
    
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



create function f_cxcdocm_before_insert() returns trigger as '
declare
    r_cxctrx1 record;
    r_cxcdocm record;
    r_gralperiodos record;
    r_almacen record;
    r_cxcmotivos record;
    r_cxcbalance record;
    r_fac_cajas record;
    ldc_saldo decimal(12,2);
    i integer;
begin

/*
    if new.fecha_posteo <= ''2012-11-30'' then
        Raise Exception ''no se puede insertar'';
    end if;
*/

    if new.monto = 0 then
        return new;
    end if;
    
    if new.almacen_ref is null then
        new.almacen_ref = new.almacen;
    end if;
    
    if new.caja_ref is null then
        new.caja_ref = new.caja;
    end if;
    
    
    select into r_almacen * from almacen
    where almacen = new.almacen;

    if new.caja is null then    
        select into r_fac_cajas * from fac_cajas
        where almacen = new.almacen and status = ''A'';
        if not found then
            Raise Exception ''Caja no Existe'';
        else
            new.caja = r_fac_cajas.caja;
        end if;
    end if;


    if Trim(f_gralparaxcia(r_almacen.compania, ''CXC'', ''validar_fecha'')) = ''S'' then
        i := f_valida_fecha(r_almacen.compania, ''CGL'', new.fecha_posteo);
        i := f_valida_fecha(r_almacen.compania, ''CXC'', new.fecha_posteo);
    end if;

    if new.documento <> new.docmto_aplicar and new.caja is null then    
        select into r_cxcdocm * from cxcdocm
        where almacen = new.almacen
        and cliente = new.cliente
        and caja in (select caja from fac_cajas where almacen = new.almacen)
        and documento = new.docmto_aplicar
        and docmto_aplicar = new.docmto_ref
        and motivo_cxc = new.motivo_ref;
        if not found then
            raise exception ''Documento Madre Almacen % Cliente % Documento % Motivo % No Existe...Verifique'',new.almacen, new.cliente, new.docmto_aplicar, new.motivo_ref;
        else
            new.caja = r_cxcdocm.caja;
            if r_cxcdocm.fecha_posteo > new.fecha_posteo then
                raise exception ''Documento Madre Almacen % Cliente % Documento % Motivo % tiene fecha % posterior %...Verifique %'',new.almacen, new.cliente, new.docmto_aplicar, new.motivo_ref,r_cxcdocm.fecha_posteo,new.fecha_posteo, new.documento;
            end if;
        end if;
    end if;
    
    
    select into r_cxcdocm * from cxcdocm
    where almacen = new.almacen
    and cliente = new.cliente
    and trim(caja) = trim(new.caja)
    and trim(documento) = trim(new.documento)
    and trim(docmto_aplicar) = trim(new.docmto_aplicar)
    and motivo_cxc = new.motivo_cxc;
    if found then
        raise exception ''Cliente % Documento % Aplicar % Tipo % Ya Existe...Verifique'',new.cliente, new.documento, new.docmto_aplicar, new.motivo_cxc;
    end if;
    
    select into r_almacen * from almacen
    where almacen = new.almacen;
    
    select into r_cxcmotivos * from cxcmotivos
    where motivo_cxc = new.motivo_cxc;
    if not found then
        raise exception ''Motivo % no existe'',new.motivo_cxc;
    end if;    
    
    select into r_gralperiodos * from gralperiodos
    where compania = r_almacen.compania 
    and aplicacion = ''CXC''
    and new.fecha_posteo between inicio and final;
    if not found then
        return new;
    end if;
    

    if new.caja is null then
        raise exception ''cja nula'';
    end if;
/*    
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
        if new.monto is null then
            new.monto = 0;
        end if;
        
        update cxcbalance
        set saldo = saldo + (new.monto * r_cxcmotivos.signo)
        where compania = r_almacen.compania
        and cliente = new.cliente
        and aplicacion = ''CXC''
        and year = r_gralperiodos.year
        and periodo = r_gralperiodos.periodo;
    end if;
*/    
    
    return new;
end;
' language plpgsql;



create function f_cxcdocm_after_insert() returns trigger as '
declare
    r_cxctrx1 record;
    r_cxcdocm record;
    r_gralperiodos record;
    r_almacen record;
    r_cxcmotivos record;
    r_cxcbalance record;
    ldc_saldo decimal(12,2);
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
  
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
    if not found then
        raise exception ''Motivo % no Existe'',new.motivo_cxc;
    end if;
    
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



create function f_cxctrx1_before_delete() returns trigger as '
declare
    r_almacen record;
    i integer;
begin

    delete from cxcdocm
    where almacen = old.almacen
    and trim(documento) = trim(old.docm_ajuste_cxc)
    and cliente = old.cliente
    and motivo_cxc = old.motivo_cxc
    and fecha_posteo = old.fecha_posteo_ajuste_cxc;

    i   =   f_delete_rela_cxctrx1_cglposteo(old.almacen, old.caja, old.sec_ajuste_cxc);
    
/*    
    delete from rela_cxctrx1_cglposteo
    where almacen = old.almacen
    and sec_ajuste_cxc = old.sec_ajuste_cxc;
    
    delete from cxcdocm
    where trim(documento) = trim(old.docm_ajuste_cxc)
    and trim(cliente) = trim(old.cliente)
    and trim(motivo_cxc) = trim(old.motivo_cxc)
    and trim(almacen) = trim(old.almacen)
    and fecha_posteo = old.fecha_posteo_ajuste_cxc;
    
    select into r_almacen * from almacen
    where almacen = old.almacen;
    
    i := f_valida_fecha(r_almacen.compania, ''CXC'', old.fecha_posteo_ajuste_cxc);
    i := f_valida_fecha(r_almacen.compania, ''CGL'', old.fecha_posteo_ajuste_cxc);
*/
    
    return old;
end;
' language plpgsql;

create function f_cxctrx1_before_update() returns trigger as '
declare
    r_almacen record;
    i integer;
begin
    delete from cxcdocm
    where almacen = old.almacen
    and caja = old.caja
    and trim(documento) = trim(old.docm_ajuste_cxc)
    and cliente = old.cliente
    and motivo_cxc = old.motivo_cxc
    and fecha_posteo = old.fecha_posteo_ajuste_cxc;

    i   =   f_delete_rela_cxctrx1_cglposteo(old.almacen, old.caja, old.sec_ajuste_cxc);

/*
    delete from rela_cxctrx1_cglposteo
    where almacen = old.almacen
    and sec_ajuste_cxc = old.sec_ajuste_cxc;

    select into r_almacen * from almacen
    where almacen = old.almacen;
    i := f_valida_fecha(r_almacen.compania, ''CXC'', old.fecha_posteo_ajuste_cxc);
    i := f_valida_fecha(r_almacen.compania, ''CGL'', old.fecha_posteo_ajuste_cxc);
    
    select into r_almacen * from almacen
    where almacen = new.almacen;
    i := f_valida_fecha(r_almacen.compania, ''CXC'', new.fecha_posteo_ajuste_cxc);
    i := f_valida_fecha(r_almacen.compania, ''CGL'', new.fecha_posteo_ajuste_cxc);
*/
    
    return new;
end;
' language plpgsql;


create function f_cxctrx1_after_update() returns trigger as '
declare
    li_work integer;
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/

/*
    delete from rela_cxctrx1_cglposteo
    where almacen = old.almacen
    and sec_ajuste_cxc = old.sec_ajuste_cxc;
    
    if old.almacen <> new.almacen
        or old.docm_ajuste_cxc <> new.docm_ajuste_cxc 
        or old.cliente <> new.cliente 
        or old.motivo_cxc <> new.motivo_cxc then
        delete from cxcdocm
        where documento = old.docm_ajuste_cxc
        and cliente = old.cliente
        and motivo_cxc = old.motivo_cxc
        and almacen = old.almacen
        and fecha_posteo = old.fecha_posteo_ajuste_cxc;
    end if;        
    
--    li_work := f_cxctrx1_cxcdocm(new.almacen, new.sec_ajuste_cxc);
*/
    
    return new;
end;
' language plpgsql;


create function f_cxctrx1_after_delete() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/


/*
    delete from rela_cxctrx1_cglposteo
    where almacen = old.almacen
    and sec_ajuste_cxc = old.sec_ajuste_cxc;


    delete from cxcdocm
    where trim(documento) = trim(old.docm_ajuste_cxc)
    and trim(cliente) = trim(old.cliente)
    and trim(motivo_cxc) = trim(old.motivo_cxc)
    and trim(almacen) = trim(old.almacen
    and fecha_posteo = old.fecha_posteo_ajuste_cxc);
*/

    return old;
end;
' language plpgsql;


create function f_cxctrx2_after_update() returns trigger as '
declare
    r_cxctrx1 record;
    r_cxcdocm record;
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    
    if old.monto = 0 and new.monto = 0 then
        return new;
    end if;
    
    delete from rela_cxctrx1_cglposteo
    where almacen = old.almacen
    and sec_ajuste_cxc = old.sec_ajuste_cxc;
    
    select into r_cxctrx1 * from cxctrx1
    where almacen = old.almacen
    and sec_ajuste_cxc = old.sec_ajuste_cxc;
    if not found then
       return new;
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
       return new;
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


create function f_cxctrx2_before_update() returns trigger as '
declare
    r_cxctrx1 record;
    r_cxcdocm record;
    i integer;
begin

    i   =   f_delete_rela_cxctrx1_cglposteo(old.almacen, old.caja, old.sec_ajuste_cxc);

/*
    delete from rela_cxctrx1_cglposteo
    where almacen = old.almacen
    and sec_ajuste_cxc = old.sec_ajuste_cxc;
    
    select into r_cxctrx1 * from cxctrx1
    where almacen = old.almacen
    and sec_ajuste_cxc = old.sec_ajuste_cxc;
    if not found then
       return new;
    end if;
    
    delete from cxcdocm
    where almacen = r_cxctrx1.almacen
    and cliente = r_cxctrx1.cliente
    and motivo_cxc = r_cxctrx1.motivo_cxc
    and documento = r_cxctrx1.docm_ajuste_cxc
    and docmto_aplicar = old.aplicar_a;
*/
    
    return new;
end;
' language plpgsql;


create function f_cxctrx2_before_insert() returns trigger as '
declare
    r_cxctrx2 record;
    r_cxctrx1 record;
    r_cxcdocm record;
    r_fac_cajas record;
begin
    delete from rela_cxctrx1_cglposteo
    where almacen = new.almacen
    and sec_ajuste_cxc = new.sec_ajuste_cxc;

    select into r_fac_cajas * from fac_cajas
    where almacen = new.almacen
    and status = ''A'';
    if not found then
        Raise Exception ''Caja no Existe en Almacen %'', new.almacen;
    end if;
    
    new.caja = r_fac_cajas.caja;

    if new.monto <> 0 then    
        select into r_cxctrx2 * from cxctrx2
        where trim(aplicar_a) = trim(new.aplicar_a)
        and sec_ajuste_cxc = new.sec_ajuste_cxc
        and almacen = new.almacen
        and monto <> 0;
        if found then
            raise exception ''No se puede aplicar dos veces al mismo documento % en esta transaccion...Verifique'', new.aplicar_a;
        end if;
    
        select into r_cxctrx1 * from cxctrx1
        where almacen = new.almacen
        and sec_ajuste_cxc = new.sec_ajuste_cxc
        and docm_ajuste_cxc = new.aplicar_a
        and motivo_cxc = new.motivo_cxc;
        if found and new.monto <> 0 then
            raise exception ''No se puede aplicar al mismo documento % en esta transaccion...Verifique'', new.aplicar_a;
        end if;
    
        select into r_cxctrx1 * from cxctrx1
        where almacen = new.almacen
        and sec_ajuste_cxc = new.sec_ajuste_cxc;
        if not found then
            raise exception ''Transaccion % No existe en el Almacen %'',new.sec_ajuste_cxc, new.almacen;
        end if;
    
    
        select into r_cxcdocm * from cxcdocm
        where almacen = new.almacen
        and caja = new.caja_aplicar
        and cliente = r_cxctrx1.cliente
        and documento = new.aplicar_a
        and docmto_aplicar = new.aplicar_a
        and motivo_cxc = new.motivo_cxc;
        if not found then
            raise exception ''Documento % no existe para el cliente % en el almacen %'',new.aplicar_a, r_cxctrx1.cliente, new.almacen;
        end if;
    
    end if;    
    
    return new;
end;
' language plpgsql;




create function f_cxctrx2_before_delete() returns trigger as '
declare
    r_cxctrx1 record;
    r_cxcdocm record;
    i integer;
begin
    i   =   f_delete_rela_cxctrx1_cglposteo(old.almacen, old.caja, old.sec_ajuste_cxc);

/*
    delete from rela_cxctrx1_cglposteo
    where almacen = old.almacen
    and sec_ajuste_cxc = old.sec_ajuste_cxc;
    
    if old.monto = 0 then
        return old;
    end if;
    
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
*/
    
    return old;
end;
' language plpgsql;



create function f_cxctrx2_after_delete() returns trigger as '
declare
    r_cxctrx1 record;
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    
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



create function f_cxctrx3_before_delete() returns trigger as '
declare
    r_cxctrx1 record;
    i integer;
begin
    i   =   f_delete_rela_cxctrx1_cglposteo(old.almacen, old.caja, old.sec_ajuste_cxc);

/*
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
    and documento = r_cxctrx1.docm_ajuste_cxc;
*/
    
    return old;
end;
' language plpgsql;


create function f_cxctrx3_before_update() returns trigger as '
declare
    r_cxctrx1 record;
    i integer;
begin

    i   =   f_delete_rela_cxctrx1_cglposteo(old.almacen, old.caja, old.sec_ajuste_cxc);

/*
    if old.monto = 0 then
        return new;
    end if;
    
    delete from rela_cxctrx1_cglposteo
    where almacen = old.almacen
    and sec_ajuste_cxc = old.sec_ajuste_cxc;
    
    select into r_cxctrx1 * from cxctrx1
    where almacen = old.almacen
    and sec_ajuste_cxc = old.sec_ajuste_cxc;
    if not found then
       return new;
    end if;
    
    delete from cxcdocm
    where almacen = r_cxctrx1.almacen
    and cliente = r_cxctrx1.cliente
    and motivo_cxc = r_cxctrx1.motivo_cxc
    and documento = r_cxctrx1.docm_ajuste_cxc;
*/

    
    return new;
end;
' language plpgsql;



create function f_cxctrx3_after_delete() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/

/*
    if old.monto = 0 then
        return old;
    end if;
    
    delete from rela_cxctrx1_cglposteo
    where almacen = old.almacen
    and sec_ajuste_cxc = old.sec_ajuste_cxc;
*/
    
    return old;
end;
' language plpgsql;


create function f_cxctrx3_after_update() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    
/*
    if old.monto = 0 then
        return old;
    end if;
    
    delete from rela_cxctrx1_cglposteo
    where almacen = old.almacen
    and sec_ajuste_cxc = old.sec_ajuste_cxc;
*/    
    return new;
end;
' language plpgsql;


create function f_rela_cxctrx1_cglposteo_after_delete() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
/*
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    
/*
    delete from cglposteo
    where consecutivo = old.consecutivo;
*/    
    return old;
end;
' language plpgsql;




create trigger t_cxctrx1_before_delete before delete on cxctrx1
for each row execute procedure f_cxctrx1_before_delete();
create trigger t_cxctrx1_before_update before update on cxctrx1
for each row execute procedure f_cxctrx1_before_update();

create trigger t_cxctrx1_after_delete after delete on cxctrx1
for each row execute procedure f_cxctrx1_after_delete();
create trigger t_cxctrx1_after_update after update on cxctrx1
for each row execute procedure f_cxctrx1_after_update();


create trigger t_rela_cxctrx1_cglposteo_after_delete after delete on rela_cxctrx1_cglposteo
for each row execute procedure f_rela_cxctrx1_cglposteo_after_delete();


create trigger t_cxctrx2_before_insert before insert on cxctrx2
for each row execute procedure f_cxctrx2_before_insert();
create trigger t_cxctrx2_before_delete before delete on cxctrx2
for each row execute procedure f_cxctrx2_before_delete();
create trigger t_cxctrx2_before_update before update on cxctrx2
for each row execute procedure f_cxctrx2_before_update();
create trigger t_cxctrx2_after_delete after delete on cxctrx2
for each row execute procedure f_cxctrx2_after_delete();
create trigger t_cxctrx2_after_update after update on cxctrx2
for each row execute procedure f_cxctrx2_after_update();

create trigger t_cxctrx3_before_delete before delete on cxctrx3
for each row execute procedure f_cxctrx3_before_delete();
create trigger t_cxctrx3_before_update before update on cxctrx3
for each row execute procedure f_cxctrx3_before_update();
create trigger t_cxctrx3_after_delete after delete on cxctrx3
for each row execute procedure f_cxctrx3_after_delete();
create trigger t_cxctrx3_after_update after update on cxctrx3
for each row execute procedure f_cxctrx3_after_update();


create trigger t_cxcdocm_before_insert before insert on cxcdocm
for each row execute procedure f_cxcdocm_before_insert();
create trigger t_cxcdocm_before_update before update on cxcdocm
for each row execute procedure f_cxcdocm_before_update();
create trigger t_cxcdocm_before_delete before delete on cxcdocm
for each row execute procedure f_cxcdocm_before_delete();


create trigger t_cxcdocm_after_insert after insert on cxcdocm
for each row execute procedure f_cxcdocm_after_insert();
create trigger t_cxcdocm_after_delete after delete on cxcdocm
for each row execute procedure f_cxcdocm_after_delete();
create trigger t_cxcdocm_after_update after update on cxcdocm
for each row execute procedure f_cxcdocm_after_update();

create trigger t_clientes_before_update before update on clientes
for each row execute procedure f_clientes_before_update();
create trigger t_clientes_before_insert before insert on clientes
for each row execute procedure f_clientes_before_insert();
create trigger t_clientes_after_insert after insert on clientes
for each row execute procedure f_clientes_after_insert();
create trigger t_clientes_after_update after update on clientes
for each row execute procedure f_clientes_after_update();

create trigger t_cxc_recibo1_before_delete before delete on cxc_recibo1
for each row execute procedure f_cxc_recibo1_before_delete();


create trigger t_cxc_recibo1_after_delete after delete on cxc_recibo1
for each row execute procedure f_cxc_recibo1_after_delete();
create trigger t_cxc_recibo1_before_update before update on cxc_recibo1
for each row execute procedure f_cxc_recibo1_before_update();




create trigger t_cxc_recibo2_before_insert before insert on cxc_recibo2
for each row execute procedure f_cxc_recibo2_before_insert();
create trigger t_cxc_recibo2_before_delete before delete on cxc_recibo2
for each row execute procedure f_cxc_recibo2_before_delete();
create trigger t_cxc_recibo2_before_update before update on cxc_recibo2
for each row execute procedure f_cxc_recibo2_before_update();
create trigger t_cxc_recibo2_after_update after update on cxc_recibo2
for each row execute procedure f_cxc_recibo2_after_update();
create trigger t_cxc_recibo2_after_delete after delete on cxc_recibo2
for each row execute procedure f_cxc_recibo2_after_delete();

create trigger t_cxc_recibo3_before_delete before delete on cxc_recibo3
for each row execute procedure f_cxc_recibo3_before_delete();

create trigger t_cxc_recibo3_before_update before update on cxc_recibo3
for each row execute procedure f_cxc_recibo3_before_update();

create trigger t_cxc_recibo3_after_delete after delete on cxc_recibo3
for each row execute procedure f_cxc_recibo3_after_delete();

create trigger t_cxc_recibo3_after_update after update on cxc_recibo3
for each row execute procedure f_cxc_recibo3_after_update();

create trigger t_rela_cxc_recibo1_cglposteo_after_delete after delete on rela_cxc_recibo1_cglposteo
for each row execute procedure f_rela_cxc_recibo1_cglposteo_after_delete();

create trigger t_cxc_recibo1_before_insert before insert on cxc_recibo1
for each row execute procedure f_cxc_recibo1_before_insert();

create trigger t_cxctrx1_before_insert before insert on cxctrx1
for each row execute procedure f_cxctrx1_before_insert();

create trigger t_cxc_recibo3_before_insert before insert on cxc_recibo3
for each row execute procedure f_cxc_recibo3_before_insert();

create trigger t_cxc_recibo4_before_insert before insert on cxc_recibo4
for each row execute procedure f_cxc_recibo4_before_insert();

create trigger t_cxc_recibo5_before_insert before insert on cxc_recibo5
for each row execute procedure f_cxc_recibo5_before_insert();

create trigger t_cxctrx3_before_insert before insert on cxctrx3
for each row execute procedure f_cxctrx3_before_insert();

create trigger t_cxcmorosidad_before_insert before insert on cxcmorosidad
for each row execute procedure f_cxcmorosidad_before_insert();

create trigger t_cxc_recibo1_after_insert after insert on cxc_recibo1
for each row execute procedure f_cxc_recibo1_after_insert();

create trigger t_cxc_recibo_before_insert before insert on cxc_recibo
for each row execute procedure f_cxc_recibo_before_insert();

create trigger t_cxc_recibo_detalle_before_insert before insert on cxc_recibo_detalle
for each row execute procedure f_cxc_recibo_detalle_before_insert();

create trigger t_cxc_edc_winsoft_before_insert before insert on cxc_edc_winsoft
for each row execute procedure f_cxc_edc_winsoft_before_insert();
