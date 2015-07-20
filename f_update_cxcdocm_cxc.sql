drop function f_update_cxcdocm_cxc(char(2)) cascade;

create function f_update_cxcdocm_cxc(char(2)) returns integer as '
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
    
	insert into cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen, docmto_ref,
	motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
	status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
	select documento, docmto_aplicar, cliente, motivo_cxc, v_cxcdocm_cxc.almacen, docmto_ref,
	motivo_ref, aplicacion_origen, ''N'', fecha_docmto, fecha_vmto, monto, fecha_posteo,
	''R'', current_user, current_timestamp, obs_docmto, current_date, referencia
	from v_cxcdocm_cxc, almacen
	where trim(documento)= trim(docmto_aplicar)
    and trim(motivo_cxc) = trim(motivo_ref)
	and fecha_posteo >= ld_fecha
	and v_cxcdocm_cxc.almacen = almacen.almacen
    and almacen.compania = as_cia
	and not exists
	(select * from cxcdocm
	where cxcdocm.almacen = v_cxcdocm_cxc.almacen
	and cxcdocm.cliente = v_cxcdocm_cxc.cliente
	and trim(cxcdocm.documento) = trim(v_cxcdocm_cxc.documento)
	and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_cxc.docmto_aplicar)
	and cxcdocm.motivo_cxc = v_cxcdocm_cxc.motivo_cxc
    and cxcdocm.fecha_posteo >= ld_fecha);

/*    
	insert into cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen, docmto_ref,
	motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
	status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
	select documento, docmto_aplicar, cliente, motivo_cxc, v_cxcdocm_cxc.almacen, docmto_ref,
	motivo_ref, aplicacion_origen, ''N'', fecha_docmto, fecha_vmto, monto, fecha_posteo,
	''R'', current_user, current_timestamp, obs_docmto, current_date, referencia
	from v_cxcdocm_cxc, almacen
	where documento <> docmto_aplicar
	and fecha_posteo >= ld_fecha
	and v_cxcdocm_cxc.almacen = almacen.almacen
    and almacen.compania = as_cia
	and not exists
	(select * from cxcdocm
	where cxcdocm.almacen = v_cxcdocm_cxc.almacen
	and cxcdocm.cliente = v_cxcdocm_cxc.cliente
	and cxcdocm.documento = v_cxcdocm_cxc.documento
	and cxcdocm.docmto_aplicar = v_cxcdocm_cxc.docmto_aplicar
	and cxcdocm.motivo_cxc = v_cxcdocm_cxc.motivo_cxc
    and cxcdocm.fecha_posteo >= ld_fecha);
*/    
    return 1;
end;
' language plpgsql;    
