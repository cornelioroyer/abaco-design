
drop function f_update_cxcdocm_fac(char(2)) cascade;
create function f_update_cxcdocm_fac(char(2)) returns integer as '
declare
    as_cia alias for $1;
    ld_fecha date;
begin
    select into ld_fecha Min(inicio) from gralperiodos
    where compania = as_cia
    and aplicacion = ''CXC''
    and estado = ''A'';
    if not found then
        return 0;
    end if;

--    ld_fecha    =   ''2010-12-01'';
    
	insert into cxcdocm (caja, documento, docmto_aplicar, cliente, motivo_cxc, almacen, docmto_ref,
	motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
	status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
	select trim(caja), trim(documento), trim(docmto_aplicar), trim(cliente), trim(motivo_cxc), 
    trim(v_cxcdocm_fac.almacen), trim(docmto_ref),
	trim(motivo_ref), aplicacion_origen, ''N'', fecha_docmto, fecha_vmto, sum(monto), fecha_posteo,
	''R'', current_user, current_timestamp, obs_docmto, current_date, trim(referencia)
	from v_cxcdocm_fac, almacen
	where v_cxcdocm_fac.almacen = almacen.almacen
    and almacen.compania = as_cia
    and trim(motivo_cxc) = trim(motivo_ref)
    and trim(documento) = trim(docmto_aplicar)
	and fecha_posteo >= ld_fecha
	and not exists
	(select * from cxcdocm
	where cxcdocm.almacen = v_cxcdocm_fac.almacen
	and cxcdocm.cliente = v_cxcdocm_fac.cliente
    and cxcdocm.caja = v_cxcdocm_fac.caja
	and trim(cxcdocm.documento) = trim(v_cxcdocm_fac.documento)
	and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_fac.docmto_aplicar)
	and cxcdocm.motivo_cxc = v_cxcdocm_fac.motivo_cxc
    and cxcdocm.fecha_posteo >= ld_fecha)
    group by caja, documento, docmto_aplicar, cliente, motivo_cxc, v_cxcdocm_fac.almacen, docmto_ref,
	motivo_ref, aplicacion_origen, fecha_docmto, fecha_vmto, fecha_posteo,
	obs_docmto, referencia;


	insert into cxcdocm (caja, documento, docmto_aplicar, cliente, motivo_cxc, almacen, docmto_ref,
	motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
	status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
	select trim(caja), trim(documento), trim(docmto_aplicar), trim(cliente), trim(motivo_cxc), 
    trim(v_cxcdocm_fac.almacen), trim(docmto_ref),
	trim(motivo_ref), aplicacion_origen, ''N'', fecha_docmto, fecha_vmto, monto, fecha_posteo,
	''R'', current_user, current_timestamp, trim(obs_docmto), current_date, trim(referencia)
	from v_cxcdocm_fac, almacen
    where v_cxcdocm_fac.almacen = almacen.almacen
    and almacen.compania = as_cia
	and (trim(documento) <> trim(docmto_aplicar)
    or trim(motivo_cxc) <> trim(motivo_ref))
	and fecha_posteo >= ld_fecha
	and not exists
	(select * from cxcdocm
	where cxcdocm.almacen = v_cxcdocm_fac.almacen
	and cxcdocm.cliente = v_cxcdocm_fac.cliente
    and cxcdocm.caja = v_cxcdocm_fac.caja
	and trim(cxcdocm.documento) = trim(v_cxcdocm_fac.documento)
	and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_fac.docmto_aplicar)
	and cxcdocm.motivo_cxc = v_cxcdocm_fac.motivo_cxc
    and cxcdocm.fecha_posteo >= ld_fecha)
    and exists
    (select * from cxcdocm
    where cxcdocm.almacen = v_cxcdocm_fac.almacen
    and cxcdocm.cliente = v_cxcdocm_fac.cliente
    and cxcdocm.caja = v_cxcdocm_fac.caja
    and trim(cxcdocm.documento) = trim(v_cxcdocm_fac.docmto_aplicar)
    and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_fac.docmto_aplicar)
    and trim(cxcdocm.motivo_cxc) = trim(v_cxcdocm_fac.motivo_ref));


	insert into cxcdocm (caja, documento, docmto_aplicar, cliente, motivo_cxc, almacen, docmto_ref,
	motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
	status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
	select trim(caja), trim(documento), trim(docmto_aplicar), trim(cliente), trim(motivo_cxc), 
    trim(v_cxcdocm_fac_fiscal.almacen), trim(docmto_ref),
	trim(motivo_ref), aplicacion_origen, ''N'', fecha_docmto, fecha_vmto, sum(monto), fecha_posteo,
	''R'', current_user, current_timestamp, obs_docmto, current_date, trim(referencia)
	from v_cxcdocm_fac_fiscal, almacen
	where v_cxcdocm_fac_fiscal.almacen = almacen.almacen
    and almacen.compania = as_cia
    and trim(motivo_cxc) = trim(motivo_ref)
    and trim(documento) = trim(docmto_aplicar)
	and fecha_posteo >= ld_fecha
	and not exists
	(select * from cxcdocm
	where cxcdocm.almacen = v_cxcdocm_fac_fiscal.almacen
	and cxcdocm.cliente = v_cxcdocm_fac_fiscal.cliente
    and cxcdocm.caja = v_cxcdocm_fac_fiscal.caja
	and trim(cxcdocm.documento) = trim(v_cxcdocm_fac_fiscal.documento)
	and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_fac_fiscal.docmto_aplicar)
	and cxcdocm.motivo_cxc = v_cxcdocm_fac_fiscal.motivo_cxc
    and cxcdocm.fecha_posteo >= ld_fecha)
    group by caja, documento, docmto_aplicar, cliente, motivo_cxc, v_cxcdocm_fac_fiscal.almacen, 
    docmto_ref,
	motivo_ref, aplicacion_origen, fecha_docmto, fecha_vmto, fecha_posteo,
	obs_docmto, referencia;


	insert into cxcdocm (caja, documento, docmto_aplicar, cliente, motivo_cxc, almacen, docmto_ref,
	motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
	status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
	select trim(caja), trim(documento), trim(docmto_aplicar), trim(cliente), trim(motivo_cxc), 
    trim(v_cxcdocm_fac_fiscal.almacen), trim(docmto_ref),
	trim(motivo_ref), aplicacion_origen, ''N'', fecha_docmto, fecha_vmto, monto, fecha_posteo,
	''R'', current_user, current_timestamp, trim(obs_docmto), current_date, trim(referencia)
	from v_cxcdocm_fac_fiscal, almacen
    where v_cxcdocm_fac_fiscal.almacen = almacen.almacen
    and almacen.compania = as_cia
	and (trim(documento) <> trim(docmto_aplicar)
    or trim(motivo_cxc) <> trim(motivo_ref))
	and fecha_posteo >= ld_fecha
	and not exists
	(select * from cxcdocm
	where cxcdocm.almacen = v_cxcdocm_fac_fiscal.almacen
    and cxcdocm.caja = v_cxcdocm_fac_fiscal.caja
	and cxcdocm.cliente = v_cxcdocm_fac_fiscal.cliente
	and trim(cxcdocm.documento) = trim(v_cxcdocm_fac_fiscal.documento)
	and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_fac_fiscal.docmto_aplicar)
	and cxcdocm.motivo_cxc = v_cxcdocm_fac_fiscal.motivo_cxc
    and cxcdocm.fecha_posteo >= ld_fecha)
    and exists
    (select * from cxcdocm
    where cxcdocm.almacen = v_cxcdocm_fac_fiscal.almacen
    and cxcdocm.caja = v_cxcdocm_fac_fiscal.caja
    and cxcdocm.cliente = v_cxcdocm_fac_fiscal.cliente
    and trim(cxcdocm.documento) = trim(v_cxcdocm_fac_fiscal.docmto_aplicar)
    and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_fac_fiscal.docmto_aplicar)
    and trim(cxcdocm.motivo_cxc) = trim(v_cxcdocm_fac_fiscal.motivo_ref));

  
    
    return 1;
end;
' language plpgsql;    

select f_update_cxcdocm_fac('02');
