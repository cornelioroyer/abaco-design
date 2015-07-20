drop function f_adc_cxp_1_cglposteo(char(2), int4, int4) cascade;
drop function f_adc_cxp_1_before_update() cascade;
drop function f_adc_cxp_1_before_delete() cascade;
drop function f_adc_cxp_1_before_insert() cascade;
drop function f_adc_cxp_2_before_delete() cascade;
drop function f_adc_cxp_2_before_update() cascade;
drop function f_rela_adc_cxp_1_cglposteo_after_delete() cascade;


create function f_adc_cxp_1_before_insert() returns trigger as '
declare
    r_cxpdocm record;
    i integer;
begin

    i := f_valida_fecha(new.compania, ''CGL'', new.fecha);


    select into r_cxpdocm * 
    from cxpdocm
    where compania = new.compania
    and proveedor = new.proveedor
    and documento = new.documento
    and motivo_cxp = new.motivo_cxp;
    if found then
        raise exception ''Documento % ya existe...Verifique'',new.documento;
    end if;
    
    return new;
    
end;
' language plpgsql;



create function f_adc_cxp_2_before_update() returns trigger as '
declare
    r_adc_cxp_1 record;
begin
    delete from rela_adc_cxp_1_cglposteo
    where compania = old.compania
    and consecutivo = old.consecutivo
    and secuencia = old.secuencia;

    select into r_adc_cxp_1 * from adc_cxp_1
    where compania = old.compania
    and consecutivo = old.consecutivo
    and secuencia = old.secuencia;
    
    delete from cxpdocm
    where compania = r_adc_cxp_1.compania
    and documento = r_adc_cxp_1.documento
    and docmto_aplicar = r_adc_cxp_1.documento
    and proveedor = r_adc_cxp_1.proveedor
    and motivo_cxp = r_adc_cxp_1.motivo_cxp;
    
    return new;
    
end;
' language plpgsql;


create function f_adc_cxp_2_before_delete() returns trigger as '
declare
    r_adc_cxp_1 record;
begin
    delete from rela_adc_cxp_1_cglposteo
    where compania = old.compania
    and consecutivo = old.consecutivo
    and secuencia = old.secuencia;

    select into r_adc_cxp_1 * from adc_cxp_1
    where compania = old.compania
    and consecutivo = old.consecutivo
    and secuencia = old.secuencia;
    
    delete from cxpdocm
    where compania = r_adc_cxp_1.compania
    and documento = r_adc_cxp_1.documento
    and docmto_aplicar = r_adc_cxp_1.documento
    and proveedor = r_adc_cxp_1.proveedor
    and motivo_cxp = r_adc_cxp_1.motivo_cxp;
    
    return old;
    
end;
' language plpgsql;


create function f_adc_cxp_1_before_delete() returns trigger as '
begin

    delete from rela_adc_cxp_1_cglposteo
    where compania = old.compania
    and consecutivo = old.consecutivo
    and secuencia = old.secuencia;
    
    delete from cxpdocm
    where compania = old.compania
    and documento = old.documento
    and docmto_aplicar = old.documento
    and proveedor = old.proveedor
    and motivo_cxp = old.motivo_cxp;
    
    return old;
    
end;
' language plpgsql;

create function f_adc_cxp_1_before_update() returns trigger as '
declare
    i integer;
begin

    i := f_valida_fecha(new.compania, ''CGL'', old.fecha);
    i := f_valida_fecha(new.compania, ''CGL'', new.fecha);


    delete from rela_adc_cxp_1_cglposteo
    where compania = old.compania
    and consecutivo = old.consecutivo
    and secuencia = old.secuencia;
    
    delete from cxpdocm
    where compania = old.compania
    and documento = old.documento
    and docmto_aplicar = old.documento
    and proveedor = old.proveedor
    and motivo_cxp = old.motivo_cxp;
    
    return new;
    
end;
' language plpgsql;




create function f_adc_cxp_1_cglposteo(char(2), int4, int4) returns integer as '
declare
    as_cia alias for $1;
    ai_consecutivo alias for $2;
    ai_secuencia alias for $3;
    li_consecutivo int4;
    r_almacen record;
    r_cxptrx1 record;
    r_cxptrx2 record;
    r_work record;
    r_clientes record;
    r_cxpmotivos record;
    r_cglauxiliares record;
    r_cglcuentas record;
    r_adc_cxp_1 record;
    r_adc_cxp_2 record;
    r_adc_manifiesto record;
    r_fact_referencias record;
    r_navieras record;
    r_proveedores record;
    ldc_sum_cxptrx1 decimal(10,2);
    ldc_sum_adc_cxp_2 decimal(10,2);
    ldc_sum_cxptrx3 decimal(10,2);
    ldc_balance decimal(10,2);
    ls_cuenta char(24);
    ls_aux1 char(10);
    ls_cliente char(10);
begin
    delete from rela_adc_cxp_1_cglposteo
    where compania = as_cia
    and consecutivo = ai_consecutivo
    and secuencia = ai_secuencia;

    select into r_adc_cxp_1 * from adc_cxp_1
    where compania = as_cia
    and consecutivo = ai_consecutivo
    and secuencia = ai_secuencia;
    
    if r_adc_cxp_1.status = ''A'' then
        return 0;
    end if;
    
    select into r_adc_manifiesto * from adc_manifiesto
    where compania = as_cia
    and consecutivo = ai_consecutivo;
    
    select into r_navieras * from navieras
    where cod_naviera = r_adc_manifiesto.cod_naviera;
    
    select into r_cxpmotivos * from cxpmotivos
    where motivo_cxp = r_adc_cxp_1.motivo_cxp;
    
    select into ldc_sum_adc_cxp_2 sum(monto) from adc_cxp_2
    where compania = as_cia
    and consecutivo = ai_consecutivo
    and secuencia = ai_secuencia;
    if ldc_sum_adc_cxp_2 is null then
       ldc_sum_adc_cxp_2 = 0;
    end if;
    ldc_balance = (r_cxpmotivos.signo*r_adc_cxp_1.monto) + ldc_sum_adc_cxp_2;
    if ldc_balance <> 0 then
       raise exception ''Transaccion % esta desbalanceada %...Verifique'',ai_secuencia, ldc_balance;
    end if;
    
    if r_adc_cxp_1.proveedor is null then
        select into r_proveedores * from proveedores
        where proveedor = r_navieras.proveedor;
    else
        select into r_proveedores * from proveedores
        where proveedor = r_adc_cxp_1.proveedor;
    end if;    
    if r_adc_cxp_1.observacion is null then
       r_adc_cxp_1.observacion = ''TRANSACCION #  '' || ai_secuencia;
    else
       r_adc_cxp_1.observacion = ''TRANSACCION #  '' || ai_secuencia || ''  '' || trim(r_adc_cxp_1.observacion);
    end if;
    
    ls_cuenta := r_proveedores.cuenta;
    
    select into r_cglcuentas * from cglcuentas
    where trim(cuenta) = trim(ls_cuenta) and auxiliar_1 = ''S'';
    if not found then
        ls_aux1 := null;
    else
        ls_aux1 := r_adc_cxp_1.proveedor;
        select into r_cglauxiliares * from cglauxiliares
        where trim(auxiliar) = trim(ls_aux1);
        if not found then
            insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
            values (r_clientes.cliente, r_proveedores.nomb_proveedor, ''1'', ''A'');
        end if;
        
    end if;        
    
    li_consecutivo := f_cglposteo(as_cia, ''CXP'', r_adc_cxp_1.fecha,
                            ls_cuenta, ls_aux1, null,
                            r_cxpmotivos.tipo_comp, r_adc_cxp_1.observacion,
                            (r_adc_cxp_1.monto*r_cxpmotivos.signo));
    if li_consecutivo > 0 then
        insert into rela_adc_cxp_1_cglposteo (cgl_consecutivo, compania, consecutivo, secuencia)
        values (li_consecutivo, as_cia, ai_consecutivo, ai_secuencia);
    end if;
    
    for r_adc_cxp_2 in select * from adc_cxp_2
                    where compania = as_cia
                    and consecutivo = ai_consecutivo
                    and secuencia = ai_secuencia
                    order by cuenta
    loop
        li_consecutivo := f_cglposteo(as_cia, ''CXP'', r_adc_cxp_1.fecha,
                                r_adc_cxp_2.cuenta, r_adc_cxp_2.auxiliar, null,
                                r_cxpmotivos.tipo_comp, r_adc_cxp_1.observacion,
                                r_adc_cxp_2.monto);
        if li_consecutivo > 0 then
            insert into rela_adc_cxp_1_cglposteo (cgl_consecutivo, compania, consecutivo, secuencia)
            values (li_consecutivo, as_cia, ai_consecutivo, ai_secuencia);
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;


create function f_rela_adc_cxp_1_cglposteo_after_delete() returns trigger as '
begin

    delete from cglposteo
    where consecutivo = old.cgl_consecutivo;
    
    return old;
    
end;
' language plpgsql;



create trigger t_rela_adc_cxp_1_cglposteo_after_delete after delete on rela_adc_cxp_1_cglposteo
for each row execute procedure f_rela_adc_cxp_1_cglposteo_after_delete();

create trigger t_adc_cxp_1_before_delete before delete on adc_cxp_1
for each row execute procedure f_adc_cxp_1_before_delete();

create trigger t_adc_cxp_1_before_update before update on adc_cxp_1
for each row execute procedure f_adc_cxp_1_before_update();

create trigger t_adc_cxp_1_before_insert before insert on adc_cxp_1
for each row execute procedure f_adc_cxp_1_before_insert();

create trigger t_adc_cxp_2_before_update before update on adc_cxp_2
for each row execute procedure f_adc_cxp_2_before_update();

create trigger t_adc_cxp_2_before_delete before delete on adc_cxp_2
for each row execute procedure f_adc_cxp_2_before_delete();
