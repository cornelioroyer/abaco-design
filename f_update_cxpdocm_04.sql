
drop function f_update_cxpdocm_04(char(2)) cascade;

create function f_update_cxpdocm_04(char(2))returns integer as '
declare
    as_cia alias for $1;
    ld_fecha date;
begin
    select into ld_fecha Min(inicio) from gralperiodos
    where compania = as_cia
    and aplicacion = ''CXP''
    and estado = ''A'';
    if not found then
        return 0;
    end if;

    update gralparaxcia
    set valor = ''N''
    where compania = ''04''
    and parametro = ''validar_fecha''
    and aplicacion = ''CXP'';
    
    ld_fecha = ''2009-01-01'';
    
	insert into cxpdocm (compania, proveedor, documento, docmto_aplicar, motivo_cxp, 
	docmto_aplicar_ref, motivo_cxp_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto,
	monto, fecha_posteo, status, usuario, fecha_captura, fecha_cancelo, obs_docmto)
	(select compania, proveedor, documento, docmto_aplicar, motivo_cxp,
	docmto_aplicar, motivo_cxp_ref, aplicacion_origen, ''N'', fecha_posteo, fecha_vencimiento,
	sum(monto), fecha_posteo, ''R'', current_user, current_timestamp, current_date, obs_docmto
	from v_cxpdocm
	where trim(documento) = trim(docmto_aplicar)
	and fecha_posteo >= ld_fecha
	and compania = as_cia
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

    
	insert into cxpdocm (compania, proveedor, documento, docmto_aplicar, motivo_cxp, 
	docmto_aplicar_ref, motivo_cxp_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto,
	monto, fecha_posteo, status, usuario, fecha_captura, fecha_cancelo, obs_docmto)
	(select compania, proveedor, documento, docmto_aplicar, motivo_cxp,
	docmto_aplicar, motivo_cxp_ref, aplicacion_origen, ''N'', fecha_posteo, fecha_vencimiento,
	sum(monto), fecha_posteo, ''R'', current_user, current_timestamp, current_date, obs_docmto
	from v_cxpdocm
	where trim(documento) <> trim(docmto_aplicar)
	and fecha_posteo >= ld_fecha
	and compania = as_cia
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

    update gralparaxcia
    set valor = ''S''
    where compania = ''04''
    and parametro = ''validar_fecha''
    and aplicacion = ''CXP'';
    
return 1;
    
end;
' language plpgsql;    


