drop trigger t_bcocheck3_cxpdocm_delete on bcocheck3;
drop trigger t_bcocheck3_cxpdocm_update on bcocheck3;
drop trigger t_bcocheck3_cxpdocm_insert on bcocheck3;

drop function f_bcocheck3_cxpdocm_insert() cascade;
drop function f_bcocheck3_cxpdocm_delete() cascade;
drop function f_bcocheck3_cxpdocm_update() cascade;

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
*/
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


create function f_bcocheck3_cxpdocm_update() returns trigger as '
declare
    r_bcomotivos record;
    r_bcoctas record;
    r_bcocheck1 record;
    r_cxpdocm record;
    ls_documento char(25);
    i integer;
begin
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




create trigger t_bcocheck3_cxpdocm_insert after insert on bcocheck3
for each row execute procedure f_bcocheck3_cxpdocm_insert();

create trigger t_bcocheck3_cxpdocm_delete after delete on bcocheck3
for each row execute procedure f_bcocheck3_cxpdocm_delete();

create trigger t_bcocheck3_cxpdocm_update after update on bcocheck3
for each row execute procedure f_bcocheck3_cxpdocm_update();


