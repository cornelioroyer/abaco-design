

drop function f_cxpfact1_before_delete() cascade;
drop function f_cxpfact1_before_update() cascade;
drop function f_cxpfact1_after_insert() cascade;
drop function f_cxpfact1_after_delete() cascade;
drop function f_cxpfact1_after_update() cascade;
drop function f_cxpfact2_after_delete() cascade;
drop function f_cxpfact2_after_update() cascade;
drop function f_rela_cxpfact1_cglposteo_delete() cascade;
drop function f_rela_cxpfact1_cglposteo_update() cascade;
drop function f_cxpfact2_before_delete() cascade;
drop function f_cxpfact2_before_update() cascade;
drop function f_proveedores_before_update() cascade;
drop function f_proveedores_after_insert() cascade;
drop function f_proveedores_after_update() cascade;
drop function f_cxpajuste1_after_delete() cascade;
drop function f_cxpajuste1_after_update() cascade;
drop function f_cxpajuste2_before_delete() cascade;
drop function f_cxpajuste2_before_update() cascade;
drop function f_cxpajuste3_before_delete() cascade;
drop function f_cxpajuste3_before_update() cascade;
drop function f_rela_cxpajuste1_cglposteo_after_delete() cascade;
drop function f_cxpajuste2_before_insert() cascade;
drop function f_cxpfact2_before_insert() cascade;
drop function f_cxpdocm_after_delete() cascade;
drop function f_cxpdocm_after_update() cascade;
drop function f_cxpdocm_before_delete() cascade;
drop function f_cxpdocm_before_update() cascade;
drop function f_cxpdocm_before_insert() cascade;
drop function f_cxpajuste1_before_delete() cascade;
drop function f_cxpajuste1_before_update() cascade;
drop function f_cxpajuste3_before_insert() cascade;

create function f_cxpajuste3_before_insert() returns trigger as '
declare
    i integer;
    r_cxpajuste1 record;
    r_cglctasxaplicacion record;
begin
    delete from rela_cxpajuste1_cglposteo
    where compania = old.compania
    and sec_ajuste_cxp = old.sec_ajuste_cxp;
    
    select into r_cxpajuste1 * from cxpajuste1
    where compania = old.compania
    and sec_ajuste_cxp = old.sec_ajuste_cxp;
    if not found then
        return new;
    end if;

    select into r_cglctasxaplicacion *
    from cglctasxaplicacion
    where trim(cuenta) = trim(new.cuenta)
    and aplicacion = ''CXP''
    and status = ''A'';
    if found then
        Raise Exception ''Cuenta % no puede ser utilizada directamente'', new.cuenta;
    end if;


    delete from cxpdocm
    where compania = r_cxpajuste1.compania
    and proveedor = r_cxpajuste1.proveedor
    and documento = r_cxpajuste1.docm_ajuste_cxp
    and motivo_cxp = r_cxpajuste1.motivo_cxp;
    
    return new;
end;
' language plpgsql;





create function f_cxpajuste1_before_delete() returns trigger as '
begin
    delete from rela_cxpajuste1_cglposteo
    where compania = old.compania
    and sec_ajuste_cxp = old.sec_ajuste_cxp;
    
    delete from cxpdocm
    where proveedor = old.proveedor
    and compania = old.compania
    and documento = old.docm_ajuste_cxp
    and motivo_cxp = old.motivo_cxp;
    
    return old;
end;
' language plpgsql;


create function f_cxpajuste1_before_update() returns trigger as '
begin
    delete from rela_cxpajuste1_cglposteo
    where compania = old.compania
    and sec_ajuste_cxp = old.sec_ajuste_cxp;
    
    delete from cxpdocm
    where proveedor = old.proveedor
    and compania = old.compania
    and documento = old.docm_ajuste_cxp
    and motivo_cxp = old.motivo_cxp;
    
    return new;
end;
' language plpgsql;


create function f_cxpfact2_before_insert() returns trigger as '
declare
    i integer;
    r_cxpfact1 record;
    r_cxpfact2 record;
    r_cglctasxaplicacion record;
begin
    if new.monto = 0 then
        return new;
    end if;
    
    select into r_cxpfact1 * from cxpfact1
    where compania = new.compania
    and proveedor = new.proveedor
    and fact_proveedor = new.fact_proveedor;
    if not found then
        raise exception ''Factura % de Proveedor % No Existe en cxpfact1'',new.fact_proveedor, new.proveedor;
    end if;
    
    select into r_cxpfact2 * from cxpfact2
    where compania = new.compania
    and proveedor = new.proveedor
    and fact_proveedor = new.fact_proveedor
    and rubro_fact_cxp = new.rubro_fact_cxp
    and linea = new.linea;
    if found then
        raise exception ''Compania % Proveedor % Factura % Rubro % Linea % ya existe en cxpfact2'',new.compania, new.proveedor,new.fact_proveedor, new.rubro_fact_cxp, new.linea;
    end if;
    
    if new.cuenta is not null then
        select into r_cglctasxaplicacion *
        from cglctasxaplicacion
        where trim(cuenta) = trim(new.cuenta)
        and aplicacion = ''CXP''
        and status = ''A'';
        if found then
            Raise Exception ''Cuenta % no puede ser utilizada directamente'', new.cuenta;
        end if;
    end if;
 

    return new;
end;
' language plpgsql;



create function f_cxpajuste1_after_delete() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin

    lt_new_dato =   null;
    lt_old_dato =   Row(old.*);
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);

    delete from rela_cxpajuste1_cglposteo
    where compania = old.compania
    and sec_ajuste_cxp = old.sec_ajuste_cxp;
    
    delete from cxpdocm
    where proveedor = old.proveedor
    and compania = old.compania
    and documento = old.docm_ajuste_cxp
    and motivo_cxp = old.motivo_cxp;
    
    return old;
end;
' language plpgsql;


create function f_cxpajuste1_after_update() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
    lt_new_dato =   Row(new.*);
    lt_old_dato =   Row(old.*);
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);

    delete from rela_cxpajuste1_cglposteo
    where compania = old.compania
    and sec_ajuste_cxp = old.sec_ajuste_cxp;

    if old.proveedor <> new.proveedor
        or old.docm_ajuste_cxp <> new.docm_ajuste_cxp
        or old.motivo_cxp <> new.motivo_cxp then
        delete from cxpdocm
        where trim(proveedor) = trim(old.proveedor)
        and trim(compania) = trim(old.compania)
        and trim(documento) = trim(old.docm_ajuste_cxp)
        and trim(motivo_cxp) = trim(old.motivo_cxp);
    end if;        
    
    
--    i := f_cxpajuste1_cxpdocm(new.compania, new.sec_ajuste_cxp);
    
    return new;
end;
' language plpgsql;


create function f_cxpajuste2_before_delete() returns trigger as '
declare
    i integer;
    r_cxpajuste1 record;
begin
    delete from rela_cxpajuste1_cglposteo
    where compania = old.compania
    and sec_ajuste_cxp = old.sec_ajuste_cxp;
    
    
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
    and motivo_cxp = r_cxpajuste1.motivo_cxp;
    
    return old;
end;
' language plpgsql;


create function f_cxpajuste2_before_update() returns trigger as '
declare
    i integer;
    r_cxpajuste1 record;
begin
    delete from rela_cxpajuste1_cglposteo
    where compania = old.compania
    and sec_ajuste_cxp = old.sec_ajuste_cxp;
    
    if old.monto = 0 and new.monto = 0 then
        return new;
    end if;
    
    select into r_cxpajuste1 * from cxpajuste1
    where compania = old.compania
    and sec_ajuste_cxp = old.sec_ajuste_cxp;
    if not found then
        return new;
    end if;
    
    delete from cxpdocm
    where compania = r_cxpajuste1.compania
    and proveedor = r_cxpajuste1.proveedor
    and documento = r_cxpajuste1.docm_ajuste_cxp
    and motivo_cxp = r_cxpajuste1.motivo_cxp;
    
    return new;
end;
' language plpgsql;

create function f_cxpajuste2_before_insert() returns trigger as '
declare
    i integer;
    r_cxpajuste1 record;
    r_cxpajuste2 record;
    r_cxpdocm record;
begin
    delete from rela_cxpajuste1_cglposteo
    where compania = new.compania
    and sec_ajuste_cxp = new.sec_ajuste_cxp;
    
    if new.monto = 0 then
        return new;
    end if;
    
    select into r_cxpajuste2 * from cxpajuste2
    where compania = new.compania
    and sec_ajuste_cxp = new.sec_ajuste_cxp
    and aplicar_a = new.aplicar_a
    and monto <> 0;
    if found then
        raise exception ''No se puede aplicar al mismo documento % en esta transaccion '',new.aplicar_a;
    end if;
    
    
    select into r_cxpajuste1 * from cxpajuste1
    where compania = new.compania
    and sec_ajuste_cxp = new.sec_ajuste_cxp;
    if not found then
        raise exception ''No existe Transaccion % en Compania %'',new.sec_ajuste_cxp,new.compania;
    end if;
    
    select into r_cxpdocm * from cxpdocm
    where compania = new.compania
    and proveedor = r_cxpajuste1.proveedor
    and documento = new.aplicar_a
    and docmto_aplicar = new.aplicar_a
    and motivo_cxp = new.motivo_cxp;
    if not found then
        raise exception ''Documento Aplicar % No existe para el Proveedor %'',new.aplicar_a, r_cxpajuste1.proveedor;
    end if;
    
    return new;
end;
' language plpgsql;



create function f_cxpajuste3_before_update() returns trigger as '
declare
    i integer;
    r_cxpajuste1 record;
    r_cglctasxaplicacion record;
begin
    delete from rela_cxpajuste1_cglposteo
    where compania = old.compania
    and sec_ajuste_cxp = old.sec_ajuste_cxp;
    
    select into r_cxpajuste1 * from cxpajuste1
    where compania = old.compania
    and sec_ajuste_cxp = old.sec_ajuste_cxp;
    if not found then
        return new;
    end if;

    select into r_cglctasxaplicacion *
    from cglctasxaplicacion
    where trim(cuenta) = trim(new.cuenta)
    and aplicacion = ''CXP''
    and status = ''A'';
    if found then
        Raise Exception ''Cuenta % no puede ser utilizada directamente'', new.cuenta;
    end if;

    
    delete from cxpdocm
    where compania = r_cxpajuste1.compania
    and proveedor = r_cxpajuste1.proveedor
    and documento = r_cxpajuste1.docm_ajuste_cxp
    and motivo_cxp = r_cxpajuste1.motivo_cxp;
    
    return new;
end;
' language plpgsql;


create function f_cxpajuste3_before_delete() returns trigger as '
declare
    i integer;
    r_cxpajuste1 record;
begin
    delete from rela_cxpajuste1_cglposteo
    where compania = old.compania
    and sec_ajuste_cxp = old.sec_ajuste_cxp;
    
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
    and motivo_cxp = r_cxpajuste1.motivo_cxp;
    
    return old;
end;
' language plpgsql;


create function f_rela_cxpajuste1_cglposteo_after_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;

create function f_proveedores_after_update() returns trigger as '
declare
    r_cglauxiliares record;
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
    lt_new_dato =   Row(new.*);
    lt_old_dato =   Row(old.*);
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);

    if trim(f_gralparaxapli(''CXP'',''crea_prov_como_aux'')) = ''S'' then
        select into r_cglauxiliares * from cglauxiliares
        where trim(auxiliar) = trim(new.proveedor);
        if not found then
            insert into cglauxiliares(auxiliar, nombre, tipo_persona, status, id, dv)
            values (new.proveedor, substring(new.nomb_proveedor from 1 for 30),new.tipo_de_persona,''A'', new.id_proveedor, new.dv_proveedor);
        else
            update cglauxiliares
            set nombre = substring(new.nomb_proveedor from 1 for 30),
            id = new.id_proveedor, dv = new.dv_proveedor, tipo_persona = new.tipo_de_persona
            where trim(auxiliar) = trim(new.proveedor);
        end if;
    end if;
    return new;
end;
' language plpgsql;


create function f_proveedores_after_insert() returns trigger as '
declare
    r_cglauxiliares record;
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
    lt_new_dato =   Row(new.*);
    lt_old_dato =   null;
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
    if trim(f_gralparaxapli(''CXP'',''crea_prov_como_aux'')) = ''S'' then
        select into r_cglauxiliares * from cglauxiliares
        where trim(auxiliar) = trim(new.proveedor);
        if not found then
            insert into cglauxiliares(auxiliar, nombre, tipo_persona, status, id, dv)
            values (new.proveedor, substring(new.nomb_proveedor from 1 for 30),new.tipo_de_persona,''A'', new.id_proveedor, new.dv_proveedor);
        end if;
    end if;
    
    return new;
end;
' language plpgsql;


create function f_cxpdocm_after_update() returns trigger as '
declare 
    r_gralperiodos record;
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
    lt_new_dato =   Row(new.*);
    lt_old_dato =   Row(old.*);
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);

    return new;
end;
' language plpgsql;



create function f_cxpdocm_after_delete() returns trigger as '
declare 
    r_gralperiodos record;
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin

--    return old;
    
    lt_new_dato =   null;
    lt_old_dato =   Row(old.*);

--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);

    if old.monto = 0 then
        return old;
    end if;

    return old;
end;
' language plpgsql;


create function f_cxpdocm_before_delete() returns trigger as '
declare 
    i integer;
begin

    if old.monto = 0 then
        return old;
    end if;
    
    if Trim(f_gralparaxcia(old.compania, ''CXP'', ''validar_fecha'')) = ''S'' then
        i := f_valida_fecha(old.compania, ''CXP'', old.fecha_posteo);
        i := f_valida_fecha(old.compania, ''CGL'', old.fecha_posteo);
    end if;


        
    if old.documento = old.docmto_aplicar and
        old.motivo_cxp = old.motivo_cxp_ref then

        i = 0;
        select into i count(*) from cxpdocm
        where compania = old.compania
        and proveedor = old.proveedor
        and docmto_aplicar = old.docmto_aplicar
        and docmto_aplicar_ref = old.docmto_aplicar_ref
        and motivo_cxp_ref = old.motivo_cxp_ref;
        if i > 1 then
            raise exception ''Documento % Fecha % de Proveedor % No puede ser eliminado. Tiene documentos aplicandole...Verifique'',old.documento, old.fecha_posteo, old.proveedor;
        end if;
    end if;    

    return old;
end;
' language plpgsql;


create function f_cxpdocm_before_update() returns trigger as '
declare 
    i integer;
begin
    i := f_valida_fecha(old.compania, ''CXP'', old.fecha_posteo);
    i := f_valida_fecha(old.compania, ''CGL'', old.fecha_posteo);
    i := f_valida_fecha(new.compania, ''CXP'', new.fecha_posteo);
    i := f_valida_fecha(new.compania, ''CGL'', new.fecha_posteo);
    
    if old.documento = old.docmto_aplicar and
        old.motivo_cxp = old.motivo_cxp_ref then
        i = 0;
        select into i count(*) from cxpdocm
        where compania = old.compania
        and proveedor = old.proveedor
        and docmto_aplicar = old.docmto_aplicar
        and docmto_aplicar_ref = old.docmto_aplicar_ref
        and motivo_cxp_ref = old.motivo_cxp_ref;
        if i > 1 then
            raise exception ''Documento % de Proveedor % No puede ser modificado. Tiene documentos aplicandole...Verifique'',old.documento, old.proveedor;
        end if;
    end if;    
    return new;
end;
' language plpgsql;


create function f_cxpdocm_before_insert() returns trigger as '
declare 
    i integer;
    r_cxpdocm record;
    ls_validar_fecha char(20);
begin

    
    ls_validar_fecha    =   Trim(f_gralparaxcia(new.compania, ''CXP'', ''validar_fecha''));


    select into r_cxpdocm * from cxpdocm
    where compania = new.compania
    and documento = new.documento
    and docmto_aplicar = new.docmto_aplicar
    and motivo_cxp = new.motivo_cxp
    and proveedor = new.proveedor;
    if found then
        raise exception ''Documento % Aplicar % Fecha % Ya Existe...Verifique'',r_cxpdocm.documento,r_cxpdocm.docmto_aplicar, new.fecha_posteo;
    end if;

    
    if new.documento <> new.docmto_aplicar or new.motivo_cxp <> new.motivo_cxp_ref then
        select into r_cxpdocm * from cxpdocm
        where compania = new.compania
        and proveedor = new.proveedor
        and documento = new.docmto_aplicar
        and docmto_aplicar = new.docmto_aplicar
        and motivo_cxp = new.motivo_cxp_ref;
        if not found then
            raise exception ''Documento Aplicar % No existe...Verifique'',new.docmto_aplicar;
        else
            if new.fecha_posteo >= ''2014-01-01'' then
                if r_cxpdocm.fecha_posteo > new.fecha_posteo then
                    raise exception ''Documento Aplicar % de fecha % debe ser posterior a Documento Hijo % de fecha %'',new.docmto_aplicar,r_cxpdocm.fecha_posteo,new.documento,new.fecha_posteo;
                end if;            
            end if;            
        end if;
    end if;
    
--    if Trim(ls_validar_fecha) = ''S'' then
        i := f_valida_fecha(new.compania, ''CXP'', new.fecha_posteo);
        i := f_valida_fecha(new.compania, ''CGL'', new.fecha_posteo);
--    end if;
    
    return new;
end;
' language plpgsql;



create function f_cxpfact1_after_update() returns trigger as '
declare 
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
    lt_new_dato =   Row(new.*);
    lt_old_dato =   Row(old.*);
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
    
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
    
    if new.numero_oc is not null then
        update oc1
        set status = ''C''
        where compania = new.compania
        and numero_oc = new.numero_oc;
    end if;

    return new;
end;
' language plpgsql;



create function f_cxpfact1_after_insert() returns trigger as '
declare 
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
    lt_new_dato =   Row(new.*);
    lt_old_dato =   null;
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);

    if new.numero_oc is not null then
        update oc1
        set status = ''C''
        where compania = new.compania
        and numero_oc = new.numero_oc;
    end if;


    return new;
end;
' language plpgsql;


create function f_cxpfact2_after_delete() returns trigger as '
declare 
    r_cxpfact1 record;
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
    lt_new_dato =   null;
    lt_old_dato =   Row(old.*);
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);

    delete from rela_cxpfact1_cglposteo
    where compania = old.compania
    and proveedor = old.proveedor
    and fact_proveedor = old.fact_proveedor;
    
    select into r_cxpfact1 * from cxpfact1
    where compania = old.compania
    and proveedor = old.proveedor
    and fact_proveedor = old.fact_proveedor;
    if not found then
        return old;
    end if;
    
    delete from cxpdocm
    where compania = r_cxpfact1.compania
    and proveedor = r_cxpfact1.proveedor
    and documento = r_cxpfact1.fact_proveedor
    and docmto_aplicar = r_cxpfact1.fact_proveedor
    and motivo_cxp = r_cxpfact1.motivo_cxp;
    
    
    return old;
end;
' language plpgsql;


create function f_cxpfact1_after_delete() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
    lt_new_dato =   null;
    lt_old_dato =   Row(old.*);
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
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
    
    if old.numero_oc is not null then
        update oc1
        set status = ''O''
        where compania = old.compania
        and numero_oc = old.numero_oc;
    end if;
    
    return old;
end;
' language plpgsql;



create function f_cxpfact2_after_update() returns trigger as '
declare 
    r_cxpfact1 record;
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
    lt_new_dato =   Row(new.*);
    lt_old_dato =   Row(old.*);
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);

    delete from rela_cxpfact1_cglposteo
    where compania = old.compania
    and proveedor = old.proveedor
    and fact_proveedor = old.fact_proveedor;
    
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
    
    delete from cxpdocm
    where trim(compania) = trim(r_cxpfact1.compania)
    and trim(proveedor) = trim(r_cxpfact1.proveedor)
    and trim(documento) = trim(r_cxpfact1.fact_proveedor)
    and trim(docmto_aplicar) = trim(r_cxpfact1.fact_proveedor)
    and trim(motivo_cxp) = trim(r_cxpfact1.motivo_cxp);
    
    return new;
end;
' language plpgsql;




create function f_rela_cxpfact1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;


create function f_cxpfact2_before_delete() returns trigger as '
begin
    if old.monto = 0 then
        return old;
    end if;
    
    delete from rela_cxpfact1_cglposteo
    where compania = old.compania
    and proveedor = old.proveedor
    and fact_proveedor = old.fact_proveedor;
    
    delete from eys4
    where compania = old.compania
    and proveedor = old.proveedor
    and fact_proveedor = old.fact_proveedor;
    
    return old;
end;
' language plpgsql;


create function f_cxpfact2_before_update() returns trigger as '
begin
    delete from rela_cxpfact1_cglposteo
    where compania = old.compania
    and proveedor = old.proveedor
    and fact_proveedor = old.fact_proveedor;
    
    delete from eys4
    where compania = old.compania
    and proveedor = old.proveedor
    and fact_proveedor = old.fact_proveedor;
    
    return new;
end;
' language plpgsql;



create function f_cxpfact1_before_delete() returns trigger as '
declare
    r_cxpdocm record;
begin
    select into r_cxpdocm *
    from cxpdocm
    where compania = old.compania
    and proveedor = old.proveedor
    and (documento <> docmto_aplicar or motivo_cxp <> motivo_cxp_ref)
    and trim(docmto_aplicar) = trim(old.fact_proveedor)
    and trim(docmto_aplicar_ref) = trim(old.fact_proveedor)
    and motivo_cxp_ref = old.motivo_cxp;
    if found then
        Raise Exception ''Factura % no puede ser eliminada...Tiene documentos aplicandole'', old.fact_proveedor;
    end if;

    delete from cxpdocm
    where compania = old.compania
    and proveedor = old.proveedor
    and trim(documento) = trim(old.fact_proveedor)
    and trim(docmto_aplicar) = trim(old.fact_proveedor)
    and motivo_cxp = old.motivo_cxp;
    
    delete from rela_cxpfact1_cglposteo
    where compania = old.compania
    and proveedor = old.proveedor
    and fact_proveedor = old.fact_proveedor;
    
    delete from eys2
    where compania = old.compania
    and proveedor = old.proveedor
    and fact_proveedor = old.fact_proveedor;
    
    return old;
end;
' language plpgsql;


create function f_proveedores_before_update() returns trigger as '
declare
    r_cxpdocm record;
begin
    if old.cuenta <> new.cuenta then
        select into r_cxpdocm *
        from cxpdocm
        where proveedor = new.proveedor;
        if found then
            raise exception ''Cuenta Contable No Puede Ser Modificada Existen Movimientos...Verifique'';
        end if;
    end if;
    
    return new;
end;
' language plpgsql;



create function f_cxpfact1_before_update() returns trigger as '
declare
    r_cxpdocm record;
begin
    select into r_cxpdocm *
    from cxpdocm
    where compania = old.compania
    and proveedor = old.proveedor
    and (documento <> docmto_aplicar or motivo_cxp <> motivo_cxp_ref)
    and trim(docmto_aplicar) = trim(old.fact_proveedor)
    and trim(docmto_aplicar_ref) = trim(old.fact_proveedor)
    and motivo_cxp_ref = old.motivo_cxp;
    if found then
        Raise Exception ''Factura % no puede ser eliminada...Tiene documentos aplicandole'', old.fact_proveedor;
    end if;

    delete from cxpdocm
    where compania = old.compania
    and proveedor = old.proveedor
    and trim(documento) = trim(old.fact_proveedor)
    and trim(docmto_aplicar) = trim(old.fact_proveedor)
    and motivo_cxp = old.motivo_cxp;

    delete from rela_cxpfact1_cglposteo
    where compania = old.compania
    and proveedor = old.proveedor
    and fact_proveedor = old.fact_proveedor;
    
    delete from eys2
    where compania = old.compania
    and proveedor = old.proveedor
    and fact_proveedor = old.fact_proveedor;
    
    return new;
end;
' language plpgsql;


create function f_rela_cxpfact1_cglposteo_update() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return new;
end;
' language plpgsql;




create trigger t_cxpfact1_after_update after update on cxpfact1
for each row execute procedure f_cxpfact1_after_update();

create trigger t_cxpfact1_after_insert after insert on cxpfact1
for each row execute procedure f_cxpfact1_after_insert();

create trigger t_cxpfact1_after_delete after delete on cxpfact1
for each row execute procedure f_cxpfact1_after_delete();

create trigger t_cxpfact2_after_delete after delete on cxpfact2
for each row execute procedure f_cxpfact2_after_delete();

create trigger t_cxpfact2_after_update after update on cxpfact2
for each row execute procedure f_cxpfact2_after_update();

create trigger t_rela_cxpfact1_cglposteo_delete after delete on rela_cxpfact1_cglposteo
for each row execute procedure f_rela_cxpfact1_cglposteo_delete();

create trigger t_rela_cxpfact1_cglposteo_update after update on rela_cxpfact1_cglposteo
for each row execute procedure f_rela_cxpfact1_cglposteo_update();


create trigger t_cxpdocm_after_delete after delete on cxpdocm
for each row execute procedure f_cxpdocm_after_delete();

create trigger t_cxpdocm_after_update after update on cxpdocm
for each row execute procedure f_cxpdocm_after_update();

create trigger t_cxpdocm_before_delete before delete on cxpdocm
for each row execute procedure f_cxpdocm_before_delete();

create trigger t_cxpdocm_before_update before update on cxpdocm
for each row execute procedure f_cxpdocm_before_update();

create trigger t_cxpdocm_before_insert before insert on cxpdocm
for each row execute procedure f_cxpdocm_before_insert();

create trigger t_cxpfact2_before_delete before delete on cxpfact2
for each row execute procedure f_cxpfact2_before_delete();

create trigger t_cxpfact2_before_update before update on cxpfact2
for each row execute procedure f_cxpfact2_before_update();


create trigger t_cxpfact1_before_delete before delete on cxpfact1
for each row execute procedure f_cxpfact1_before_delete();

create trigger t_cxpfact1_before_update before update on cxpfact1
for each row execute procedure f_cxpfact1_before_update();

create trigger t_cxpfact2_before_insert before insert on cxpfact2
for each row execute procedure f_cxpfact2_before_insert();


create trigger t_proveedores_before_update before update on proveedores
for each row execute procedure f_proveedores_before_update();

create trigger t_proveedores_after_update after update on proveedores
for each row execute procedure f_proveedores_after_update();

create trigger t_proveedores_after_insert after insert on proveedores
for each row execute procedure f_proveedores_after_insert();


create trigger t_cxpajuste1_before_delete before delete on cxpajuste1
for each row execute procedure f_cxpajuste1_before_delete();

create trigger t_cxpajuste1_before_update before update on cxpajuste1
for each row execute procedure f_cxpajuste1_before_update();


create trigger t_cxpajuste1_after_delete after delete on cxpajuste1
for each row execute procedure f_cxpajuste1_after_delete();
create trigger t_cxpajuste1_after_update after update on cxpajuste1
for each row execute procedure f_cxpajuste1_after_update();


create trigger t_cxpajuste2_before_delete before delete on cxpajuste2
for each row execute procedure f_cxpajuste2_before_delete();
create trigger t_cxpajuste2_before_update before update on cxpajuste2
for each row execute procedure f_cxpajuste2_before_update();
create trigger t_cxpajuste2_before_insert before insert on cxpajuste2
for each row execute procedure f_cxpajuste2_before_insert();

create trigger t_cxpajuste3_before_delete before delete on cxpajuste3
for each row execute procedure f_cxpajuste3_before_delete();
create trigger t_cxpajuste3_before_update before update on cxpajuste3
for each row execute procedure f_cxpajuste3_before_update();
create trigger t_cxpajuste3_before_insert before update on cxpajuste3
for each row execute procedure f_cxpajuste3_before_insert();


create trigger t_rela_cxpajuste1_cglposteo_after_delete after delete on rela_cxpajuste1_cglposteo
for each row execute procedure f_rela_cxpajuste1_cglposteo_after_delete();
