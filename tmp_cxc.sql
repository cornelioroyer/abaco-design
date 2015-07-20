
drop trigger t_rela_cxc_recibo1_cglposteo_delete on rela_cxc_recibo1_cglposteo;
drop function f_cxc_recibo1_cglposteo(char(2), int4);
drop function f_rela_cxc_recibo1_cglposteo_delete() cascade;

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
    ldc_sum_cxc_recibo1 decimal(10,2);
    ldc_sum_cxc_recibo2 decimal(10,2);
    ldc_sum_cxc_recibo3 decimal(10,2);
    ls_cuenta char(24);
begin
    select into r_cxc_recibo1 * from cxc_recibo1
    where almacen = as_almacen
    and consecutivo = ai_consecutivo;
    if not found then
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
    
    delete from rela_cxc_recibo1_cglposteo
    where almacen = r_cxc_recibo1.almacen
    and consecutivo = r_cxc_recibo1.consecutivo;
    
    select into r_cxcmotivos * from cxcmotivos
    where motivo_cxc = r_cxc_recibo1.motivo_cxc;
    
    select into r_almacen * from almacen
    where almacen = r_cxc_recibo1.almacen;
    
    select into r_clientes * from clientes
    where cliente = r_cxc_recibo1.cliente;
    
    if r_cxc_recibo1.observacion is null then
       r_cxc_recibo1.observacion := ''RECIBO #  '' || r_cxc_recibo1.consecutivo;
    else
       r_cxc_recibo1.observacion := ''RECIBO #  '' || r_cxc_recibo1.consecutivo || trim(r_cxc_recibo1.observacion);
    end if;
    
    select into ls_cuenta trim(valor) from invparal
    where almacen = r_cxc_recibo1.almacen
    and parametro = ''cta_cxc''
    and aplicacion =  ''INV'';
    if not found then
       ls_cuenta := r_clientes.cuenta;
    end if;

    li_consecutivo := f_cglposteo(r_almacen.compania, ''CXC'', r_cxc_recibo1.fecha, 
                            ls_cuenta, null, null,
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
                                (r_work.monto*r_cxcmotivos.signo));
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


create trigger t_rela_cxc_recibo1_cglposteo_delete after delete on rela_cxc_recibo1_cglposteo
for each row execute procedure f_rela_cxc_recibo1_cglposteo_delete();

