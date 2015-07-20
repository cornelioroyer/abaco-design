drop function f_bcocheck1_cxpdocm_delete() cascade;
drop function f_bcocheck1_cxpdocm_update() cascade;
drop function f_bcocheck1_cxpdocm(char(2), char(2), int4) cascade;

drop function f_bcocheck3_cxpdocm_insert() cascade;
drop function f_bcocheck3_cxpdocm_delete() cascade;
drop function f_bcocheck3_cxpdocm_update() cascade;

drop function f_bcotransac1_cxpdocm_delete() cascade;
drop function f_bcotransac1_cxpdocm_update() cascade;
drop function f_bcotransac1_cxpdocm(char(2), int4) cascade;

drop function f_bcotransac3_after_update() cascade;
drop function f_bcotransac3_after_delete() cascade;


create function f_bcocheck1_cxpdocm_update() returns trigger as '
declare
    r_bcomotivos record;
    r_bcoctas record;
    i integer;
begin
    return new;
    delete from rela_bcocheck1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_cheque = old.no_cheque;
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = old.cod_ctabco;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = old.motivo_bco;
    
    delete from cxpdocm
    where proveedor = old.proveedor
    and trim(compania) = trim(r_bcoctas.compania)
    and trim(documento) = trim(to_char(old.no_cheque, ''999999999999999''))
    and trim(motivo_cxp) = trim(r_bcomotivos.motivo_cxp)
    and fecha_posteo = old.fecha_posteo;

--    i := f_bcocheck1_cxpdocm(new.cod_ctabco, new.motivo_bco, new.no_cheque);
    
    return new;
end;
' language plpgsql;


create function f_bcocheck1_cxpdocm_delete() returns trigger as '
declare
    r_bcomotivos record;
    r_bcoctas record;
    i integer;
begin
    return old;
    delete from rela_bcocheck1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_cheque = old.no_cheque;
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = old.cod_ctabco;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = old.motivo_bco;
    
    delete from cxpdocm
    where trim(proveedor) = trim(old.proveedor)
    and trim(compania) = trim(r_bcoctas.compania)
    and trim(documento) = trim(to_char(old.no_cheque, ''999999999999999''))
    and trim(motivo_cxp) = trim(r_bcomotivos.motivo_cxp)
    and fecha_posteo = old.fecha_posteo;
    
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
    return new;
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
    return new;
    delete from rela_bcocheck1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_cheque = old.no_cheque;

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
    
    return new;
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
    return old;
    delete from rela_bcocheck1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and motivo_bco = old.motivo_bco
    and no_cheque = old.no_cheque;
    
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
    return new;
    delete from rela_bcotransac1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and sec_transacc = old.sec_transacc;
    
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
    
    return new;
end;
' language plpgsql;


create function f_bcotransac1_cxpdocm_delete() returns trigger as '
declare 
    r_bcotransac1 record;
    r_bcomotivos record;
    r_bcoctas record;
begin
    return old;
    delete from rela_bcotransac1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and sec_transacc = old.sec_transacc;
    
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
    
    return old;
end;
' language plpgsql;


create function f_bcotransac3_after_delete() returns trigger as '
declare 
    r_bcotransac1 record;
    r_bcomotivos record;
    r_bcoctas record;
begin
    delete from rela_bcotransac1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and sec_transacc = old.sec_transacc;
    
    if old.monto = 0 then
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


create function f_bcotransac3_after_update() returns trigger as '
declare 
    r_bcotransac1 record;
    r_bcomotivos record;
    r_bcoctas record;
begin
    delete from rela_bcotransac1_cglposteo
    where cod_ctabco = old.cod_ctabco
    and sec_transacc = old.sec_transacc;
    
    if old.monto = 0 and new.monto = 0 then
        return new;
    end if;
    
    select into r_bcotransac1 * from bcotransac1
    where cod_ctabco = old.cod_ctabco
    and sec_transacc = old.sec_transacc;
    if not found then
        return new;
    end if;
    
    if r_bcotransac1.proveedor is null then
       return new;
    end if;
    
    select into r_bcomotivos * from bcomotivos
    where motivo_bco = r_bcotransac1.motivo_bco;
    
    select into r_bcoctas * from bcoctas
    where cod_ctabco = new.cod_ctabco;
    
    delete from cxpdocm
    where compania = r_bcoctas.compania
    and proveedor = r_bcotransac1.proveedor
    and documento = r_bcotransac1.no_docmto
    and motivo_cxp = r_bcomotivos.motivo_cxp;
    
    return new;
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
    return 0;
    
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
    return 0;
    
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

create trigger t_bcotransac3_after_delete after delete on bcotransac3
for each row execute procedure f_bcotransac3_after_delete();

create trigger t_bcotransac3_after_update after update on bcotransac3
for each row execute procedure f_bcotransac3_after_update();




