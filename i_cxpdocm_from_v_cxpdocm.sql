
update gralparaxcia
set valor = 'N'
where parametro = 'validar_fecha'
and aplicacion = 'CXP';

begin work;
    delete from cxpdocm
    where compania = '03'
    and fecha_posteo >= '2010-10-01'
    and documento <> docmto_aplicar;
commit work;


begin work;
    delete from cxpdocm
    where compania = '03'
    and fecha_posteo >= '2010-10-01';
commit work;

begin work;	
    insert into cxpdocm (compania, proveedor, documento, docmto_aplicar, motivo_cxp, 
	docmto_aplicar_ref, motivo_cxp_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto,
	monto, fecha_posteo, status, usuario, fecha_captura, fecha_cancelo, obs_docmto)
	(select compania, proveedor, documento, docmto_aplicar, motivo_cxp,
	docmto_aplicar, motivo_cxp_ref, aplicacion_origen, 'N', fecha_posteo, fecha_vencimiento,
	sum(monto), fecha_posteo, 'R', current_user, current_timestamp, current_date, obs_docmto
	from v_cxpdocm
	where trim(documento) = trim(docmto_aplicar)
	and fecha_posteo >= '2010-10-01'
	and compania = '03'
    and monto <> 0
	and not exists
		(select * from cxpdocm
			where cxpdocm.proveedor = v_cxpdocm.proveedor
			and cxpdocm.compania = v_cxpdocm.compania
			and cxpdocm.documento = v_cxpdocm.documento
			and cxpdocm.docmto_aplicar = v_cxpdocm.docmto_aplicar
			and cxpdocm.motivo_cxp = v_cxpdocm.motivo_cxp)
	group by compania, proveedor, documento, docmto_aplicar, motivo_cxp, motivo_cxp_ref, aplicacion_origen,
	fecha_posteo, fecha_vencimiento, obs_docmto);
commit work;
    
begin work;    
	insert into cxpdocm (compania, proveedor, documento, docmto_aplicar, motivo_cxp, 
	docmto_aplicar_ref, motivo_cxp_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto,
	monto, fecha_posteo, status, usuario, fecha_captura, fecha_cancelo, obs_docmto)
	(select compania, proveedor, documento, docmto_aplicar, motivo_cxp,
	docmto_aplicar, motivo_cxp_ref, aplicacion_origen, 'N', fecha_posteo, fecha_vencimiento,
	sum(monto), fecha_posteo, 'R', current_user, current_timestamp, current_date, obs_docmto
	from v_cxpdocm
	where trim(documento) <> trim(docmto_aplicar)
	and fecha_posteo >= '2010-10-01'
	and compania = '03'
    and monto <> 0
	and not exists
		(select * from cxpdocm
			where cxpdocm.proveedor = v_cxpdocm.proveedor
			and cxpdocm.compania = v_cxpdocm.compania
			and cxpdocm.documento = v_cxpdocm.documento
			and cxpdocm.docmto_aplicar = v_cxpdocm.docmto_aplicar
			and cxpdocm.motivo_cxp = v_cxpdocm.motivo_cxp)
	group by compania, proveedor, documento, docmto_aplicar, motivo_cxp, motivo_cxp_ref, aplicacion_origen,
	fecha_posteo, fecha_vencimiento, obs_docmto);
commit work;

update gralparaxcia
set valor = 'S'
where parametro = 'validar_fecha'
and aplicacion = 'CXP';
