/*
drop function f_recibo_cxcdocm(char(2), int4) cascade;
drop function f_cxc_recibo1_delete() cascade;
drop function f_cxc_recibo1_update() cascade;
drop function f_cxc_recibo2_delete() cascade;
drop function f_cxc_recibo2_update() cascade;
drop function f_cxc_recibo2_insert() cascade;
drop function f_cxc_recibo1_cglposteo(char(2), int4) cascade;
drop function f_rela_cxc_recibo1_cglposteo_delete() cascade;
drop function f_cxc_recibo3_after_delete() cascade;
drop function f_cxc_recibo3_after_update() cascade;
drop function f_cxc_recibo2_before_delete() cascade;
drop function f_cxc_recibo2_before_update() cascade;
*/

-- drop function f_cxc_recibo1_cglposteo(char(2), int4) cascade;

set search_path to dba;

drop function f_recibo_cxcdocm(char(2), int4) cascade;
drop function f_cxc_recibo1_cglposteo(char(2), char(3), int4) cascade;
drop function f_delete_rela_cxc_recibo1_cglposteo(char(2), char(3), int4) cascade;
drop function f_delete_rela_cxctrx1_cglposteo(char(2), char(3), int4) cascade;



create function f_delete_rela_cxctrx1_cglposteo(char(2), char(3), int4) returns integer as '
declare
    as_almacen alias for $1;
    as_caja alias for $2;
    ai_sec_ajuste_cxc alias for $3;
    li_consecutivo int4;
    r_rela_cxc_recibo1_cglposteo record;
    r_almacen record;
    r_cxc_recibo1 record;
    r_cxc_recibo2 record;
    r_work record;
    r_clientes record;
    r_cxcmotivos record;
    r_cglcuentas record;
    r_cxctrx1 record;
    r_rela_cxctrx1_cglposteo record;
    r_cglauxiliares record;
    ldc_sum_cxc_recibo1 decimal(10,2);
    ldc_sum_cxc_recibo2 decimal(10,2);
    ldc_sum_cxc_recibo3 decimal(10,2);
    ls_cuenta char(24);
    ls_aux1 char(10);
    i integer;
begin

    select into r_almacen *
    from almacen
    where almacen = as_almacen;
    

    select into r_cxctrx1 *
    from cxctrx1
    where almacen = as_almacen
    and caja = as_caja
    and sec_ajuste_cxc = ai_sec_ajuste_cxc;
    if not found then
        return 0;
    end if;
    
    delete from cxcdocm
    where almacen = as_almacen
    and trim(documento) = trim(r_cxctrx1.docm_ajuste_cxc)
    and cliente = r_cxctrx1.cliente
    and motivo_cxc = r_cxctrx1.motivo_cxc
    and fecha_posteo = r_cxctrx1.fecha_posteo_ajuste_cxc;
    
    i := f_valida_fecha(r_almacen.compania, ''CXC'', r_cxctrx1.fecha_posteo_ajuste_cxc);
    i := f_valida_fecha(r_almacen.compania, ''CGL'', r_cxctrx1.fecha_posteo_ajuste_cxc);
    
    for r_rela_cxctrx1_cglposteo in 
            select * from rela_cxctrx1_cglposteo
            where almacen = as_almacen
            and caja = as_caja
            and sec_ajuste_cxc = ai_sec_ajuste_cxc
            order by consecutivo
    loop
        delete from cglposteo
        where consecutivo = r_rela_cxctrx1_cglposteo.consecutivo;    
    end loop;
    
    delete from rela_cxctrx1_cglposteo
    where almacen = as_almacen
    and caja = as_caja
    and sec_ajuste_cxc = ai_sec_ajuste_cxc;

    return 1;
end;
' language plpgsql;




create function f_delete_rela_cxc_recibo1_cglposteo(char(2), char(3), int4) returns integer as '
declare
    as_almacen alias for $1;
    as_caja alias for $2;
    ai_consecutivo alias for $3;
    li_consecutivo int4;
    r_rela_cxc_recibo1_cglposteo record;
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
    i integer;
begin


    select into r_almacen *
    from almacen
    where almacen = as_almacen;
    
    
    select into r_cxc_recibo1 *
    from cxc_recibo1
    where almacen = as_almacen
    and caja = as_caja
    and consecutivo = ai_consecutivo;
    if not found then
        return 0;
    end if;

    i := f_valida_fecha(r_almacen.compania, ''CXC'', r_cxc_recibo1.fecha);
    i := f_valida_fecha(r_almacen.compania, ''CGL'', r_cxc_recibo1.fecha);

/*
    and trim(documento) = trim(r_cxc_recibo1.documento)

    delete from cxcdocm
    where almacen = r_cxc_recibo1.almacen
    and cliente = r_cxc_recibo1.cliente
    and motivo_cxc = r_cxc_recibo1.motivo_cxc
    and trim(documento) = trim(r_cxc_recibo1.documento)
    and fecha_posteo = r_cxc_recibo1.fecha;
*/

    for r_rela_cxc_recibo1_cglposteo in 
            select * from rela_cxc_recibo1_cglposteo
            where almacen = as_almacen
            and caja = as_caja
            and cxc_consecutivo = ai_consecutivo
            order by consecutivo
    loop
        delete from cglposteo
        where consecutivo = r_rela_cxc_recibo1_cglposteo.consecutivo;    
    end loop;
    
    delete from rela_cxc_recibo1_cglposteo
    where almacen = as_almacen
    and caja = as_caja
    and cxc_consecutivo = ai_consecutivo;

    return 1;
end;
' language plpgsql;




create function f_cxc_recibo1_cglposteo(char(2), char(3), int4) returns integer as '
declare
    as_almacen alias for $1;
    as_caja alias for $2;
    ai_consecutivo alias for $3;
    li_consecutivo int4;
    r_almacen record;
    r_cxc_recibo1 record;
    r_cxc_recibo2 record;
    r_work record;
    r_clientes record;
    r_cxcmotivos record;
    r_cglcuentas record;
    r_cglauxiliares record;
    ldc_sum_cxc_recibo1 decimal(20,2);
    ldc_sum_cxc_recibo2 decimal(20,2);
    ldc_sum_cxc_recibo3 decimal(20,2);
    ls_cuenta char(24);
    ls_aux1 char(10);
    i integer;
begin

    select into r_cxc_recibo1 * from cxc_recibo1
    where almacen = as_almacen
    and caja = as_caja
    and consecutivo = ai_consecutivo;
    if not found then
       return 0;
    end if;

   
    i   =   f_delete_rela_cxc_recibo1_cglposteo(r_cxc_recibo1.almacen, r_cxc_recibo1.caja, r_cxc_recibo1.consecutivo);

    
/*    
    delete from rela_cxc_recibo1_cglposteo
    where almacen = r_cxc_recibo1.almacen
    and caja = r_cxc_recibo1.caja
    and cxc_consecutivo = r_cxc_recibo1.consecutivo;
*/    
    
    if r_cxc_recibo1.status = ''A'' then
        return 0;
    end if;
    
    
    select into ldc_sum_cxc_recibo1 (efectivo + cheque + otro) 
    from cxc_recibo1
    where almacen = as_almacen
    and caja = r_cxc_recibo1.caja
    and consecutivo = ai_consecutivo;
    if ldc_sum_cxc_recibo1 is null or ldc_sum_cxc_recibo1 = 0 then
       return 0;
    end if;

    
    select into ldc_sum_cxc_recibo2 sum(monto_aplicar) 
    from cxc_recibo2
    where almacen = as_almacen
    and caja = r_cxc_recibo1.caja
    and consecutivo = ai_consecutivo;
    if ldc_sum_cxc_recibo2 is null then
       ldc_sum_cxc_recibo2 = 0;
    end if;

    if ldc_sum_cxc_recibo1 <> 0 and ldc_sum_cxc_recibo2 <> 0 and ldc_sum_cxc_recibo1 <> ldc_sum_cxc_recibo2 then
       raise exception ''Recibo % Monto de Encabezado debe ser igual documentos aplicados ...Verifique'',r_cxc_recibo1.consecutivo;
    end if;
    
    select into ldc_sum_cxc_recibo3 sum(monto) from cxc_recibo3
    where almacen = as_almacen
    and caja = r_cxc_recibo1.caja
    and consecutivo = ai_consecutivo;
    if ldc_sum_cxc_recibo3 is null then
       ldc_sum_cxc_recibo3 := 0;
    end if;
    
    if ldc_sum_cxc_recibo2 <> 0 and ldc_sum_cxc_recibo2 <> ldc_sum_cxc_recibo1 then
       raise exception ''Recibo % esta desbalanceada...Verifique'',r_cxc_recibo1.consecutivo;
    end if;
    
    if ldc_sum_cxc_recibo1 <> ldc_sum_cxc_recibo3 then
       raise exception ''Recibo % esta desbalanceada...Verifique'',r_cxc_recibo1.consecutivo;
    end if;
    
    
    select into r_cxcmotivos * from cxcmotivos
    where motivo_cxc = r_cxc_recibo1.motivo_cxc;
    
    select into r_almacen * from almacen
    where almacen = r_cxc_recibo1.almacen;
    
    select into r_clientes * from clientes
    where cliente = r_cxc_recibo1.cliente;
    
    if r_cxc_recibo1.observacion is null then
       r_cxc_recibo1.observacion = ''RECIBO #  '' || r_cxc_recibo1.documento;
    else
       r_cxc_recibo1.observacion = ''RECIBO #  '' || r_cxc_recibo1.documento || ''  '' || trim(r_cxc_recibo1.observacion);
    end if;

/*    
    select into ls_cuenta trim(valor) from invparal
    where almacen = r_cxc_recibo1.almacen
    and parametro = ''cta_cxc''
    and aplicacion =  ''INV'';
    if not found then
       ls_cuenta := r_clientes.cuenta;
    end if;
*/

    ls_cuenta = r_clientes.cuenta;
    
    
    
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

    
    li_consecutivo = f_cglposteo(r_almacen.compania, ''CXC'', r_cxc_recibo1.fecha, 
                            ls_cuenta, ls_aux1, null,
                            r_cxcmotivos.tipo_comp, r_cxc_recibo1.observacion, 
                            (ldc_sum_cxc_recibo1*r_cxcmotivos.signo));

    if li_consecutivo > 0 then
        insert into rela_cxc_recibo1_cglposteo (almacen, caja, cxc_consecutivo, consecutivo)
        values (r_cxc_recibo1.almacen, as_caja, r_cxc_recibo1.consecutivo, li_consecutivo);
    end if;
    
    for r_work in select cxc_recibo3.cuenta, cxc_recibo3.auxiliar, cxc_recibo3.monto
                    from cxc_recibo3
                    where cxc_recibo3.almacen = r_cxc_recibo1.almacen
                    and cxc_recibo3.caja = r_cxc_recibo1.caja
                    and cxc_recibo3.consecutivo = r_cxc_recibo1.consecutivo
                    order by 1
    loop

        li_consecutivo = f_cglposteo(r_almacen.compania, ''CXC'', r_cxc_recibo1.fecha, 
                                r_work.cuenta, r_work.auxiliar, null,
                                r_cxcmotivos.tipo_comp, r_cxc_recibo1.observacion, 
                                -(r_work.monto*r_cxcmotivos.signo));

--        raise exception ''entre %'', r_work.monto;

        if li_consecutivo > 0 then
            insert into rela_cxc_recibo1_cglposteo (almacen, caja, cxc_consecutivo, consecutivo)
            values (r_cxc_recibo1.almacen, as_caja, r_cxc_recibo1.consecutivo, li_consecutivo);
        end if;
    end loop;
    return 1;
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
