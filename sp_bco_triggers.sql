drop function f_bcotransac1_bcocircula_insert() cascade;
drop function f_bcotransac1_bcocircula_delete() cascade;
drop function f_bcotransac1_bcocircula_update() cascade;
drop function f_rela_bcotransac1_cglposteo_delete() cascade;
drop function f_rela_bcocheck1_cglposteo_delete() cascade;
drop function f_rela_bcocheck1_cglposteo_before_delete() cascade;
drop function f_bcotransac2_after_update() cascade;
drop function f_bcotransac2_after_delete() cascade;
drop function f_bcocheck2_after_delete() cascade;
drop function f_bcocheck2_after_update() cascade;
drop function f_bcotransac3_after_delete() cascade;
drop function f_bcotransac3_after_update() cascade;
drop function f_bcotransac1_before_delete() cascade;
drop function f_bcotransac1_before_update() cascade;
drop function f_bcocircula_before_insert() cascade;
drop function f_bcocircula_before_update() cascade;
drop function f_bcocircula_before_delete() cascade;
drop function f_bcocheck1_before_delete() cascade;
drop function f_bcocheck1_before_update() cascade;
drop function f_bcocheck1_bcocircula_insert() cascade;
drop function f_bcocheck1_bcocircula_delete() cascade;
drop function f_bcocheck1_bcocircula_update() cascade;
drop function f_bcocheck3_before_insert() cascade;
drop function f_bcocheck2_before_insert() cascade;
drop function f_bcotransac1_after_insert() cascade;
drop function f_bcotransac1_after_update() cascade;
drop function f_bcotransac1_after_delete() cascade;
drop function f_bcocheck1_after_update() cascade;
drop function f_bcocheck1_after_delete() cascade;
drop function f_bcocheck1_after_insert() cascade;
drop function f_bcotransac2_before_insert() cascade;


create function f_bcotransac2_before_insert() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
    r_cglctasxaplicacion record;
begin
    delete from rela_bcotransac1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and sec_transacc = old.sec_transacc;

/*
    lt_new_dato =   null;
    lt_old_dato =   Row(old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    
    select into r_cglctasxaplicacion *
    from cglctasxaplicacion
    where cuenta = new.cuenta
    and status = ''A'';
    if found then
        Raise Exception ''Cuenta % no puede ser utilizada directamente'', new.cuenta;
    end if;

    return new;
end;
' language plpgsql;




create function f_bcocheck1_after_update() returns trigger as '
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
    return new;
end;
' language plpgsql;

create function f_bcocheck1_after_insert() returns trigger as '
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
    
    return new;
end;
' language plpgsql;


create function f_bcocheck1_after_delete() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
/*
    lt_new_dato =   null;
    lt_old_dato =   Row(old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    
    return old;
end;
' language plpgsql;



create function f_bcotransac2_after_delete() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;

begin
    delete from rela_bcotransac1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and sec_transacc = old.sec_transacc;

/*
    lt_new_dato =   null;
    lt_old_dato =   Row(old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    
    return old;
end;
' language plpgsql;


create function f_bcotransac1_after_insert() returns trigger as '
declare
    r_cglctasxaplicacion record;
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
/*
    lt_new_dato =   Row(new.*);
    lt_old_dato =   null;
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    
    return new;
end;
' language plpgsql;


create function f_bcotransac1_after_update() returns trigger as '
declare
    r_cglctasxaplicacion record;
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
/*
    lt_new_dato =   Row(new.*);
    lt_old_dato =   Row(old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    
    return new;
end;
' language plpgsql;


create function f_bcotransac1_after_delete() returns trigger as '
declare
    r_cglctasxaplicacion record;
    lt_new_dato text;
    lt_old_dato text;
    lt_sentencia_sql text;
    i int4;
begin
/*
    lt_old_dato =   Row(old.*);
    lt_new_dato =   null;
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/    
    return old;
end;
' language plpgsql;


create function f_bcocheck2_before_insert() returns trigger as '
declare
    r_cglctasxaplicacion record;
begin
    select into r_cglctasxaplicacion *
    from cglctasxaplicacion
    where cuenta = new.cuenta
    and aplicacion = ''CXP'';
    if found then
        Raise Exception ''Cuenta % no puede ser utilizada directamente'', new.cuenta;
    end if;
    return new;
end;
' language plpgsql;



create function f_bcocheck3_before_insert() returns trigger as '
declare
    r_bcocheck3 record;
begin
    if new.monto <> 0 then
        select into r_bcocheck3 *
        from bcocheck3
        where cod_ctabco = new.cod_ctabco
        and motivo_bco = new.motivo_bco
        and no_cheque = new.no_cheque
        and monto <> 0
        and aplicar_a = new.aplicar_a;
        if found then
            Raise Exception ''No se puede aplicar a documentos iguales % con el mismo cheque '', new.aplicar_a;
        end if;
    end if;    
    return new;
end;
' language plpgsql;


create function f_bcocircula_before_insert() returns trigger as '
declare
    r_bcoctas record;
    i integer;
begin
    select into r_bcoctas * from bcoctas
    where cod_ctabco = new.cod_ctabco;
    
    i = f_valida_fecha(r_bcoctas.compania, ''BCO'', new.fecha_posteo);
    
    return new;
end;
' language plpgsql;


create function f_bcocircula_before_update() returns trigger as '
declare
    r_bcoctas record;
    i integer;
begin
    select into r_bcoctas * from bcoctas
    where cod_ctabco = old.cod_ctabco;
    
    if old.status = ''C'' then    
--        i = f_valida_fecha(r_bcoctas.compania, ''BCO'', old.fecha_conciliacion);
    end if;
    
    if new.status = ''C'' then    
--        i = f_valida_fecha(r_bcoctas.compania, ''BCO'', new.fecha_conciliacion);
    end if;
    
    
    return new;
end;
' language plpgsql;


create function f_bcocircula_before_delete() returns trigger as '
declare
    r_bcoctas record;
    i integer;
begin
    select into r_bcoctas * from bcoctas
    where cod_ctabco = old.cod_ctabco;
    
    i = f_valida_fecha(r_bcoctas.compania, ''BCO'', old.fecha_posteo);
    
    return old;
end;
' language plpgsql;



create function f_rela_bcocheck1_cglposteo_before_delete() returns trigger as '
begin
/*
    delete from cglposteo
    where consecutivo = old.consecutivo;
*/    
    return old;
end;
' language plpgsql;


create function f_bcotransac1_before_update() returns trigger as '
declare
    r_bcoctas record;
    r_bcocircula record;
    i integer;
begin
    select into r_bcoctas * from bcoctas
    where cod_ctabco = old.cod_ctabco;

    i = f_valida_fecha(r_bcoctas.compania, ''BCO'', old.fecha_posteo);
    i = f_valida_fecha(r_bcoctas.compania, ''CGL'', old.fecha_posteo);
    
    select into r_bcocircula * from bcocircula
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_docmto_sys = old.sec_transacc
    and fecha_posteo = old.fecha_posteo
    and status = ''C'';
    if found then
        raise exception ''No se puede modificar una transaccion % conciliada...Verifique'',old.sec_transacc;
    end if;

    return new;
end;
' language plpgsql;



create function f_bcotransac1_before_delete() returns trigger as '
declare
    r_bcoctas record;
    r_bcocircula record;
    i integer;
begin
    select into r_bcoctas * from bcoctas
    where cod_ctabco = old.cod_ctabco;

    i = f_valida_fecha(r_bcoctas.compania, ''BCO'', old.fecha_posteo);
    i = f_valida_fecha(r_bcoctas.compania, ''CGL'', old.fecha_posteo);
    
    select into r_bcocircula * from bcocircula
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_docmto_sys = old.sec_transacc
    and fecha_posteo = old.fecha_posteo
    and status = ''C'';
    if found then
        raise exception ''No se puede eliminar una transaccion % conciliada...Verifique'',old.sec_transacc;
    end if;
    

    return old;
end;
' language plpgsql;



create function f_rela_bcocheck1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
end;
' language plpgsql;




create function f_rela_bcotransac1_cglposteo_delete() returns trigger as '
begin
    delete from cglposteo
    where consecutivo = old.consecutivo;
    return old;
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
declare
    r_bcoctas record;
    r_bcomotivos record;
begin
    delete from bcocircula
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_docmto_sys = old.no_cheque
    and fecha_posteo = old.fecha_posteo
    and status <> ''C'';
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = old.cod_ctabco;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = old.motivo_bco;

/*    
    delete from cxpdocm
    where compania = r_bcoctas.compania
    and proveedor = old.proveedor
    and trim(documento) = trim(to_char(old.no_cheque, ''9999999999''))
    and motivo_cxp = r_bcomotivos.motivo_cxp;
*/    
    return old;
end;
' language plpgsql;


create function f_bcocheck1_bcocircula_update() returns trigger as '
declare
    r_bcomotivos record;
    r_bcocircula record;
    i integer;
begin
    delete from rela_bcocheck1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_cheque = old.no_cheque;
    
    delete from bcocircula
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_docmto_sys = old.no_cheque
    and fecha_posteo = old.fecha_posteo
    and status <> ''C'';
    
    update nomdescuentos
    set cod_ctabco = null, no_cheque = null, motivo_bco = null
    where exists 
        (select * from bcocheck1
        where nomdescuentos.cod_ctabco = bcocheck1.cod_ctabco
        and nomdescuentos.no_cheque = bcocheck1.no_cheque
        and nomdescuentos.motivo_bco = bcocheck1.motivo_bco
        and bcocheck1.status = ''A'');

    i := f_bcocheck1_bcocircula(new.cod_ctabco, new.motivo_bco, new.no_cheque);
    return new;
end;
' language plpgsql;


create function f_bcocheck2_after_update() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
    delete from rela_bcocheck1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_cheque = old.no_cheque;
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/    
    return new;
end;
' language plpgsql;


create function f_bcocheck2_after_delete() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;

begin
    delete from rela_bcocheck1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_cheque = old.no_cheque;
  
/*    
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    
    return old;
end;
' language plpgsql;


create function f_bcotransac3_after_update() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;

begin
    delete from rela_bcotransac1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and sec_transacc = old.sec_transacc;
/*
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), trim(lt_old_dato), trim(lt_new_dato), null);
*/
    
    return new;
end;
' language plpgsql;

create function f_bcotransac3_after_delete() returns trigger as '
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
    delete from rela_bcotransac1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and sec_transacc = old.sec_transacc;
    
    return old;
end;
' language plpgsql;


create function f_bcotransac2_after_update() returns trigger as '
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
    delete from rela_bcotransac1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and sec_transacc = old.sec_transacc;
    
    return new;
end;
' language plpgsql;


create function f_bcocheck1_before_delete() returns trigger as '
declare
    i integer;
    r_bcoctas record;
    r_bcomotivos record;
    r_bcocircula record;
    ld_fecha date;
begin

    select into r_bcoctas * from bcoctas
    where cod_ctabco = old.cod_ctabco;

    select into ld_fecha Min(inicio) from gralperiodos
    where compania = r_bcoctas.compania
    and aplicacion = ''CXP''
    and estado = ''A'';
    if not found then
        ld_fecha := old.fecha_posteo;
    end if;

    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = old.motivo_bco;
    

    if r_bcomotivos.solicitud_cheque = ''N'' then
        i = f_valida_fecha(r_bcoctas.compania, ''BCO'', old.fecha_posteo);
        i = f_valida_fecha(r_bcoctas.compania, ''CGL'', old.fecha_posteo);
    end if;
        
    select into r_bcocircula * from bcocircula
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_docmto_sys = old.no_cheque
    and fecha_posteo = old.fecha_posteo
    and status = ''C'';
    if found then
        raise exception ''No se puede eliminar un cheque % conciliado...Verifique'',old.no_cheque;
    end if;
    
    
    delete from rela_bcocheck1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_cheque = old.no_cheque;
    
    delete from bcocircula
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_docmto_sys = old.no_cheque
    and fecha_posteo = old.fecha_posteo
    and status <> ''C'';

    
    if r_bcomotivos.solicitud_cheque = ''N'' then
        delete from cxpdocm
        where trim(proveedor) = trim(old.proveedor)
        and trim(compania) = trim(r_bcoctas.compania)
        and trim(documento) = trim(to_char(old.no_cheque, ''999999999999999''))
        and trim(motivo_cxp) = trim(r_bcomotivos.motivo_cxp)
        and fecha_posteo >= ld_fecha;
    end if;    
    
    return old;
end;
' language plpgsql;


create function f_bcocheck1_before_update() returns trigger as '
declare
    i integer;
    r_bcoctas record;
    r_bcomotivos record;
    r_bcocircula record;
    r_bcocheck1 record;
    ld_fecha date;
begin
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = old.cod_ctabco;
    if not found then
        Raise Exception ''No encontro cuenta de banco %'',old.cod_ctabco;
    end if;

    select into ld_fecha Min(inicio) from gralperiodos
    where compania = r_bcoctas.compania
    and aplicacion = ''CXP''
    and estado = ''A'';
    if not found then
        ld_fecha := old.fecha_posteo;
    end if;

    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = old.motivo_bco;
    if not found then
        Raise Exception ''No encontro el tipo de transacion %'',old.motivo_bco;
    end if;

    
    if r_bcomotivos.solicitud_cheque = ''N'' then
        i = f_valida_fecha(r_bcoctas.compania, ''BCO'', old.fecha_cheque);
        i = f_valida_fecha(r_bcoctas.compania, ''CGL'', old.fecha_cheque);
    end if;
    
    if old.cod_ctabco <> new.cod_ctabco
        or old.motivo_bco <> new.motivo_bco
        or old.no_cheque <> new.no_cheque then
        
        select into r_bcocheck1 * from bcocheck1
        where cod_ctabco = new.cod_ctabco
        and motivo_bco = new.motivo_bco
        and no_cheque = new.no_cheque;
        if found then
            raise exception ''Numero de cheque % Ya Existe...Verifique'',new.no_cheque;
        end if;        
                
    end if;
    
    
    select into r_bcocircula * from bcocircula
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_docmto_sys = old.no_cheque
    and fecha_posteo = old.fecha_posteo
    and status = ''C'';
    if found then
        raise exception ''No se puede modificar un cheque % conciliado...Verifique'',old.no_cheque;
    end if;
    
    
    delete from rela_bcocheck1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_cheque = old.no_cheque;
    
    delete from bcocircula
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_docmto_sys = old.no_cheque
    and fecha_posteo = old.fecha_posteo
    and status <> ''C'';

    if old.proveedor is not null then    

--    RAISE EXCEPTION ''ENTRE update % % % %'', old.proveedor, r_bcoctas.compania, old.no_cheque, r_bcomotivos.motivo_cxp;

        delete from cxpdocm
        where trim(compania) = trim(r_bcoctas.compania)
        and trim(proveedor) = trim(old.proveedor)        
        and (documento <> docmto_aplicar or motivo_cxp <> motivo_cxp_ref)
        and trim(motivo_cxp) = trim(r_bcomotivos.motivo_cxp)
        and trim(documento) = trim(to_char(old.no_cheque, ''999999999999999''))
        and fecha_posteo >= ld_fecha;
        
        /*
        and (documento <> docmto_aplicar or motivo_cxp <> motivo_cxp_ref)
        */

/*
        delete from cxpdocm
        where trim(proveedor) = trim(old.proveedor)
        and trim(compania) = trim(r_bcoctas.compania)
        and trim(documento) = trim(to_char(old.no_cheque, ''999999999999999''))
        and trim(motivo_cxp) = trim(r_bcomotivos.motivo_cxp)
        and fecha_posteo >= ld_fecha;
*/        
    end if;    
    
    if new.status = ''A'' and old.aplicacion = ''PLA'' then
        update nomctrac
        set cod_ctabco = null, no_cheque = null, motivo_bco = null
        where no_cheque is not null
        and cod_ctabco = old.cod_ctabco
        and motivo_bco = old.motivo_bco
        and no_cheque = old.no_cheque;
        
        update nomdescuentos
        set cod_ctabco = null, no_cheque = null, motivo_bco = null
        where no_cheque is not null
        and cod_ctabco = old.cod_ctabco
        and motivo_bco = old.motivo_bco
        and no_cheque = old.no_cheque;
    end if;    
    
    return new;
end;
' language plpgsql;


create trigger t_bcocheck1_before_delete before delete on bcocheck1
for each row execute procedure f_bcocheck1_before_delete();


create trigger t_bcocheck1_before_update before update on bcocheck1
for each row execute procedure f_bcocheck1_before_update();



create trigger t_bcocheck1_bcocircula_insert after insert on bcocheck1
for each row execute procedure f_bcocheck1_bcocircula_insert();

create trigger t_bcocheck1_bcocircula_delete after delete on bcocheck1
for each row execute procedure f_bcocheck1_bcocircula_delete();

create trigger t_bcocheck1_bcocircula_update after update on bcocheck1
for each row execute procedure f_bcocheck1_bcocircula_update();


create trigger t_bcocheck1_after_insert after insert on bcocheck1
for each row execute procedure f_bcocheck1_after_insert();

create trigger t_bcocheck1_after_update after update on bcocheck1
for each row execute procedure f_bcocheck1_after_update();

create trigger t_bcocheck1_after_delete after delete on bcocheck1
for each row execute procedure f_bcocheck1_after_delete();

create trigger t_bcocheck2_after_delete after delete on bcocheck2
for each row execute procedure f_bcocheck2_after_delete();

create trigger t_bcocheck2_after_update after update on bcocheck2
for each row execute procedure f_bcocheck2_after_update();

create trigger t_bcotransac2_after_delete after delete on bcotransac2
for each row execute procedure f_bcotransac2_after_delete();

create trigger t_bcotransac2_after_update after update on bcotransac2
for each row execute procedure f_bcotransac2_after_update();

create trigger t_bcotransac1_bcocircula_insert after insert on bcotransac1
for each row execute procedure f_bcotransac1_bcocircula_insert();

create trigger t_bcotransac1_bcocircula_delete after delete on bcotransac1
for each row execute procedure f_bcotransac1_bcocircula_delete();

create trigger t_bcotransac1_before_delete before delete on bcotransac1
for each row execute procedure f_bcotransac1_before_delete();

create trigger t_bcotransac1_before_update before update on bcotransac1
for each row execute procedure f_bcotransac1_before_update();

create trigger t_bcotransac1_bcocircula_update after update on bcotransac1
for each row execute procedure f_bcotransac1_bcocircula_update();

create trigger t_rela_bcotransac1_cglposteo_delete after delete on rela_bcotransac1_cglposteo
for each row execute procedure f_rela_bcotransac1_cglposteo_delete();

create trigger t_rela_bcocheck1_cglposteo_delete after delete on rela_bcocheck1_cglposteo
for each row execute procedure f_rela_bcocheck1_cglposteo_delete();

create trigger t_rela_bcocheck1_cglposteo_before_delete before delete on rela_bcocheck1_cglposteo
for each row execute procedure f_rela_bcocheck1_cglposteo_before_delete();

create trigger t_bcotransac3_after_delete after delete on bcotransac3
for each row execute procedure f_bcotransac3_after_delete();

create trigger t_bcotransac3_after_update after update on bcotransac3
for each row execute procedure f_bcotransac3_after_update();

create trigger t_bcocircula_before_insert before insert on bcocircula
for each row execute procedure f_bcocircula_before_insert();

create trigger t_bcocircula_before_update before update on bcocircula
for each row execute procedure f_bcocircula_before_update();

create trigger t_bcocircula_before_delete before delete on bcocircula
for each row execute procedure f_bcocircula_before_delete();

create trigger t_bcocheck3_before_insert before insert on bcocheck3
for each row execute procedure f_bcocheck3_before_insert();

create trigger t_bcocheck2_before_insert before insert on bcocheck2
for each row execute procedure f_bcocheck2_before_insert();

create trigger t_bcotrasac1_after_insert after insert on bcotransac1
for each row execute procedure f_bcotransac1_after_insert();

create trigger t_bcotrasac1_after_update after update on bcotransac1
for each row execute procedure f_bcotransac1_after_update();

create trigger t_bcotrasac1_after_delete after delete on bcotransac1
for each row execute procedure f_bcotransac1_after_delete();
