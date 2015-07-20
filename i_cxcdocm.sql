drop function f_update_cxcdocm_cxc(char(2), date) cascade;
drop function f_update_cxcdocm_fac(char(2), date) cascade;


update gralparaxcia
set valor = 'N'
where parametro = 'validar_fecha'
and aplicacion = 'CXC';

/*
delete from cxcdocm where documento <> docmto_aplicar;
delete from cxcdocm;
*/

create function f_update_cxcdocm_cxc(char(2), date) returns integer as '
declare
    as_cia alias for $1;
    ad_fecha alias for $2;
    ld_fecha date;
begin
    ld_fecha = ad_fecha;    
	insert into cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen, docmto_ref,
	motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
	status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia, caja)
	select documento, docmto_aplicar, cliente, motivo_cxc, v_cxcdocm_cxc.almacen, docmto_ref,
	motivo_ref, aplicacion_origen, ''N'', fecha_docmto, fecha_vmto, monto, fecha_posteo,
	''R'', current_user, current_timestamp, obs_docmto, current_date, referencia, caja
	from v_cxcdocm_cxc, almacen
	where documento = docmto_aplicar
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

    
	insert into cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen, docmto_ref,
	motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
	status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia, caja)
	select documento, docmto_aplicar, cliente, motivo_cxc, v_cxcdocm_cxc.almacen, docmto_ref,
	motivo_ref, aplicacion_origen, ''N'', fecha_docmto, fecha_vmto, monto, fecha_posteo,
	''R'', current_user, current_timestamp, obs_docmto, current_date, referencia, caja
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
    
    return 1;
end;
' language plpgsql;    


create function f_update_cxcdocm_fac(char(2), date) returns integer as '
declare
    as_cia alias for $1;
    ad_fecha alias for $2;
    ld_fecha date;
begin

    ld_fecha = ad_fecha;
    
	insert into cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen, docmto_ref,
	motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
	status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia, caja)
	select trim(documento), trim(docmto_aplicar), trim(cliente), trim(motivo_cxc), 
    trim(v_cxcdocm_fac.almacen), trim(docmto_ref),
	trim(motivo_ref), aplicacion_origen, ''N'', fecha_docmto, fecha_vmto, sum(monto), fecha_posteo,
	''R'', current_user, current_timestamp, obs_docmto, current_date, trim(referencia), caja
	from v_cxcdocm_fac, almacen
	where v_cxcdocm_fac.almacen = almacen.almacen
    and almacen.compania = as_cia
    and documento = docmto_aplicar
	and fecha_posteo >= ld_fecha
	and not exists
	(select * from cxcdocm
	where cxcdocm.almacen = v_cxcdocm_fac.almacen
	and cxcdocm.cliente = v_cxcdocm_fac.cliente
	and trim(cxcdocm.documento) = trim(v_cxcdocm_fac.documento)
	and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_fac.docmto_aplicar)
	and cxcdocm.motivo_cxc = v_cxcdocm_fac.motivo_cxc
    and cxcdocm.fecha_posteo >= ld_fecha)
    group by documento, docmto_aplicar, cliente, motivo_cxc, v_cxcdocm_fac.almacen, docmto_ref,
	motivo_ref, aplicacion_origen, fecha_docmto, fecha_vmto, fecha_posteo,
	obs_docmto, referencia, caja;


	insert into cxcdocm (documento, docmto_aplicar, cliente, motivo_cxc, almacen, docmto_ref,
	motivo_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo,
	status, usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia, caja)
	select trim(documento), trim(docmto_aplicar), trim(cliente), trim(motivo_cxc), 
    trim(v_cxcdocm_fac.almacen), trim(docmto_ref),
	trim(motivo_ref), aplicacion_origen, ''N'', fecha_docmto, fecha_vmto, monto, fecha_posteo,
	''R'', current_user, current_timestamp, trim(obs_docmto), current_date, trim(referencia), caja
	from v_cxcdocm_fac, almacen
    where v_cxcdocm_fac.almacen = almacen.almacen
    and almacen.compania = as_cia
	and trim(documento) <> trim(docmto_aplicar)
	and fecha_posteo >= ld_fecha
	and not exists
	(select * from cxcdocm
	where cxcdocm.almacen = v_cxcdocm_fac.almacen
	and cxcdocm.cliente = v_cxcdocm_fac.cliente
	and trim(cxcdocm.documento) = trim(v_cxcdocm_fac.documento)
	and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_fac.docmto_aplicar)
	and cxcdocm.motivo_cxc = v_cxcdocm_fac.motivo_cxc
    and cxcdocm.fecha_posteo >= ld_fecha)
    and exists
    (select * from cxcdocm
    where cxcdocm.almacen = v_cxcdocm_fac.almacen
    and cxcdocm.cliente = v_cxcdocm_fac.cliente
    and trim(cxcdocm.documento) = trim(v_cxcdocm_fac.docmto_aplicar)
    and trim(cxcdocm.docmto_aplicar) = trim(v_cxcdocm_fac.docmto_aplicar)
    and trim(cxcdocm.motivo_cxc) = trim(v_cxcdocm_fac.motivo_ref));
    
    
    return 1;
end;
' language plpgsql;    


select f_update_cxcdocm_fac('03','1990-01-01');
select f_update_cxcdocm_cxc('03','1990-01-01');


update gralparaxcia
set valor = 'S'
where parametro = 'validar_fecha'
and aplicacion = 'CXC';
