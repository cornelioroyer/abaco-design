drop function f_monto_factura_cxp(char(2), char(6), char(25));
drop function f_saldo_docmto_cxp(char(2), char(6), char(10),  char(3), date);
drop function f_cxpfact1_cxpdocm(char(2), char(6), char(25));
drop function f_cxpfact1_cglposteo(char(2), char(6), char(25));
drop function f_postea_cxp(char(2)) cascade;
drop function f_update_cxpdocm(char(2)) cascade;
drop function f_delete_cxpdocm(char(2)) cascade;
drop function f_cxpfact2(char(2), char(6), char(25), char(10)) cascade;
drop function f_cxpajuste1(char(2), int4, char(10)) cascade;
drop function f_cerrar_cxp(char(2),int4, int4) cascade;


create function f_cerrar_cxp(char(2),int4, int4) returns integer as '
declare
    as_cia alias for $1;
    ai_anio alias for $2;
    ai_mes alias for $3;
    r_work record;
    r_gralperiodos record;
begin

    select into r_gralperiodos *
    from gralperiodos
    where compania = as_cia
    and aplicacion = ''CXP''
    and year = ai_anio
    and periodo = ai_mes;
    if not found then
        Raise Exception ''No existe Anio % y Mes % en Inventario'',ai_anio, ai_mes;
    end if;
    
    if r_gralperiodos.estado <> ''A'' then
        return 0;
    end if;

	delete from cxpbalance
	where compania = as_cia
	and aplicacion = ''CXP''
	and year = ai_anio
	and periodo = ai_mes;

    insert into cxpbalance(compania, aplicacion, year, periodo, proveedor, saldo)
    select cxpdocm.compania,''CXP'',ai_anio,ai_mes,proveedor, 
    sum(cxpdocm.monto*cxpmotivos.signo)
    from cxpdocm, cxpmotivos
    where cxpdocm.motivo_cxp = cxpmotivos.motivo_cxp
    and cxpdocm.fecha_posteo <= r_gralperiodos.final
    and cxpdocm.compania = as_cia
    group by cxpdocm.compania,proveedor;    
    
    return f_cerrar_aplicacion(as_cia, ''CXP'', ai_anio, ai_mes);
end;


' language plpgsql;

create function f_cxpajuste1(char(2), int4, char(10)) returns decimal(12,2) as '
declare
    ac_compania alias for $1;
    ai_sec_ajuste_cxp alias for $2;
    ac_recuperar alias for $3;
    ldc_retorno decimal(12,2);
begin
    ldc_retorno = 0;
    if trim(ac_recuperar) = ''ITBMS'' then
        select into ldc_retorno sum(cglposteo.debito-cglposteo.credito) 
        from rela_cxpajuste1_cglposteo, cglposteo
        where rela_cxpajuste1_cglposteo.consecutivo = cglposteo.consecutivo
        and rela_cxpajuste1_cglposteo.compania = ac_compania
        and rela_cxpajuste1_cglposteo.sec_ajuste_cxp = ai_sec_ajuste_cxp
        and cglposteo.cuenta in (select cuenta from gral_impuestos);
    else
        select into ldc_retorno sum(cglposteo.debito-cglposteo.credito) 
        from rela_cxpajuste1_cglposteo, cglposteo
        where rela_cxpajuste1_cglposteo.consecutivo = cglposteo.consecutivo
        and rela_cxpajuste1_cglposteo.compania = ac_compania
        and rela_cxpajuste1_cglposteo.sec_ajuste_cxp = ai_sec_ajuste_cxp
        and cglposteo.cuenta not in (select cuenta from gral_impuestos);
    end if;    
    
    if ldc_retorno is null then
       ldc_retorno := 0;
    end if;
    
    return ldc_retorno;
end;
' language plpgsql;


create function f_cxpfact2(char(2), char(6), char(25), char(10)) returns decimal(12,2) as '
declare
    as_compania alias for $1;
    as_proveedor alias for $2;
    as_fact_proveedor alias for $3;
    as_recuperar alias for $4;
    ldc_retorno decimal(12,2);
begin
    ldc_retorno = 0;
    if trim(as_recuperar) = ''ITBMS'' then
        select into ldc_retorno -sum(cxpfact2.monto*rubros_fact_cxp.signo_rubro_fact_cxp*cxpmotivos.signo)
        from cxpfact2, rubros_fact_cxp, cxpmotivos, cxpfact1
        where cxpfact2.rubro_fact_cxp = rubros_fact_cxp.rubro_fact_cxp
        and cxpfact1.compania = cxpfact2.compania
        and cxpfact1.proveedor = cxpfact2.proveedor
        and cxpfact1.fact_proveedor = cxpfact2.fact_proveedor
        and cxpfact1.motivo_cxp = cxpmotivos.motivo_cxp
        and cxpfact1.compania = as_compania
        and cxpfact1.proveedor = as_proveedor
        and cxpfact1.fact_proveedor = as_fact_proveedor
        and trim(cxpfact2.rubro_fact_cxp) like ''%ITBM%'';
    else
        select into ldc_retorno -sum(cxpfact2.monto*rubros_fact_cxp.signo_rubro_fact_cxp*cxpmotivos.signo)
        from cxpfact2, rubros_fact_cxp, cxpmotivos, cxpfact1
        where cxpfact2.rubro_fact_cxp = rubros_fact_cxp.rubro_fact_cxp
        and cxpfact1.compania = cxpfact2.compania
        and cxpfact1.proveedor = cxpfact2.proveedor
        and cxpfact1.fact_proveedor = cxpfact2.fact_proveedor
        and cxpfact1.motivo_cxp = cxpmotivos.motivo_cxp
        and cxpfact1.compania = as_compania
        and cxpfact1.proveedor = as_proveedor
        and cxpfact1.fact_proveedor = as_fact_proveedor
        and trim(cxpfact2.rubro_fact_cxp) not like ''%ITBM%'';
    end if;
    
    if ldc_retorno is null then
       ldc_retorno := 0;
    end if;
    
    return ldc_retorno;
end;
' language plpgsql;


create function f_delete_cxpdocm(char(2))returns integer as '
declare
    as_cia alias for $1;
    ld_fecha date;
    i integer;
    r_cxc_recibo1 record;
    r_cxctrx1 record;
    r_adc_cxc_1 record;
begin
    select into ld_fecha Min(inicio) from gralperiodos
    where compania = as_cia
    and aplicacion = ''CXP''
    and estado = ''A''
    and inicio >= ''2009-01-01'';
    if not found then
        return 0;
    end if;
    

    delete from cxpdocm 
    where compania = as_cia
    and (documento <> docmto_aplicar or motivo_cxp <> motivo_cxp_ref)
    and fecha_posteo >= ld_fecha;

--raise exception ''entre'';

    delete from cxpdocm 
    where compania = as_cia
    and fecha_posteo >= ld_fecha;
    
    return 1;
end;
' language plpgsql;    



create function f_postea_cxp(char(2))returns integer as '
declare
    as_cia alias for $1;
    ld_fecha date;
    r_cxpfact1 record;
    r_cxpajuste1 record;
    r_adc_master record;
    r_adc_cxp_1 record;
    i integer;
begin
    select into ld_fecha Min(inicio) from gralperiodos
    where compania = as_cia
    and aplicacion = ''CXP''
    and estado = ''A'';
    if not found then
        return 0;
    end if;
    
    for r_cxpfact1 in select * from cxpfact1
                    where cxpfact1.compania = as_cia
                    and cxpfact1.fecha_posteo_fact_cxp >= ld_fecha
                    and not exists
                        (select * from rela_cxpfact1_cglposteo
                        where rela_cxpfact1_cglposteo.compania = cxpfact1.compania
                        and rela_cxpfact1_cglposteo.proveedor = cxpfact1.proveedor
                        and rela_cxpfact1_cglposteo.fact_proveedor = cxpfact1.fact_proveedor)
                    order by fecha_posteo_fact_cxp                        
    loop
        i := f_cxpfact1_cglposteo(r_cxpfact1.compania, r_cxpfact1.proveedor, r_cxpfact1.fact_proveedor);
    end loop;        
    
    for r_cxpajuste1 in select * from cxpajuste1
                    where cxpajuste1.compania = as_cia
                    and cxpajuste1.fecha_posteo_ajuste_cxp >= ld_fecha
                    and not exists
                        (select * from rela_cxpajuste1_cglposteo
                        where rela_cxpajuste1_cglposteo.compania = cxpajuste1.compania
                        and rela_cxpajuste1_cglposteo.sec_ajuste_cxp = cxpajuste1.sec_ajuste_cxp)
                    order by fecha_posteo_ajuste_cxp                        
    loop
        i := f_cxpajuste1_cglposteo(r_cxpajuste1.compania, r_cxpajuste1.sec_ajuste_cxp);
    end loop;        

    for r_adc_master in select adc_master.* from adc_master, adc_manifiesto
                            where adc_master.compania = adc_manifiesto.compania
                            and adc_master.consecutivo = adc_manifiesto.consecutivo
                            and adc_manifiesto.compania = as_cia
                            and adc_manifiesto.fecha >= ld_fecha
                            and not exists
                                (select * from rela_adc_master_cglposteo
                                    where rela_adc_master_cglposteo.compania = adc_master.compania
                                    and rela_adc_master_cglposteo.consecutivo = adc_master.consecutivo
                                    and rela_adc_master_cglposteo.linea_master = adc_master.linea_master)                        
    loop
        i = f_adc_master_cglposteo(r_adc_master.compania, r_adc_master.consecutivo, r_adc_master.linea_master);
    end loop;
    
    for r_adc_cxp_1 in select * from adc_cxp_1
                        where compania = as_cia
                        and fecha >= ld_fecha
                        and not exists
                            (select * from rela_adc_cxp_1_cglposteo
                            where rela_adc_cxp_1_cglposteo.compania = adc_cxp_1.compania
                            and rela_adc_cxp_1_cglposteo.consecutivo = adc_cxp_1.consecutivo
                            and rela_adc_cxp_1_cglposteo.secuencia = adc_cxp_1.secuencia)
                        order by fecha
    loop
        i = f_adc_cxp_1_cglposteo(r_adc_cxp_1.compania, r_adc_cxp_1.consecutivo, r_adc_cxp_1.secuencia);
    end loop;                        
    
    return 1;
    
end;
' language plpgsql;    


create function f_update_cxpdocm(char(2))returns integer as '
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


	insert into cxpdocm (compania, proveedor, documento, docmto_aplicar, motivo_cxp, 
	docmto_aplicar_ref, motivo_cxp_ref, aplicacion_origen, uso_interno, fecha_docmto, fecha_vmto,
	monto, fecha_posteo, status, usuario, fecha_captura, fecha_cancelo, obs_docmto)
	(select compania, proveedor, documento, docmto_aplicar, motivo_cxp,
	docmto_aplicar, motivo_cxp_ref, aplicacion_origen, ''N'', fecha_posteo, fecha_vencimiento,
	sum(monto), fecha_posteo, ''R'', current_user, current_timestamp, current_date, obs_docmto
	from v_cxpdocm
	where trim(documento) = trim(docmto_aplicar)
    and trim(motivo_cxp) = trim(motivo_cxp_ref)
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
	where (trim(documento) <> trim(docmto_aplicar)
    or trim(motivo_cxp) <> trim(motivo_cxp_ref))
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
    
return 1;
    
end;
' language plpgsql;    





create function f_cxpfact1_cxpdocm(char(2), char(6), char(25)) returns integer as '
declare
    as_compania alias for $1;
    as_proveedor alias for $2;
    as_fact_proveedor alias for $3;
    r_cxpfact1 record;
    r_cxpdocm record;
    r_work record;
    ldc_monto decimal(12,2);
begin
    select into r_cxpfact1 * from cxpfact1
    where compania = as_compania
    and proveedor = as_proveedor
    and trim(fact_proveedor) = trim(as_fact_proveedor);
    if not found then
       return 0;
    end if;
    
    
    select into r_work cglcuentas.* from cglcuentas, proveedores
    where cglcuentas.cuenta = proveedores.cuenta
    and proveedores.proveedor = r_cxpfact1.proveedor
    and cglcuentas.naturaleza = 1;
    if found then
       return 0;
    end if;
    
    select into ldc_monto sum(cxpfact2.monto*rubros_fact_cxp.signo_rubro_fact_cxp)
    from cxpfact2, rubros_fact_cxp
    where cxpfact2.rubro_fact_cxp = rubros_fact_cxp.rubro_fact_cxp
    and cxpfact2.compania = as_compania
    and cxpfact2.proveedor = as_proveedor
    and cxpfact2.fact_proveedor = as_fact_proveedor;
    if ldc_monto is null or ldc_monto = 0 then
       return 0;
    end if;

    select into r_cxpdocm * from cxpdocm
    where compania = r_cxpfact1.compania
    and proveedor = r_cxpfact1.proveedor
    and documento = r_cxpfact1.fact_proveedor
    and docmto_aplicar = r_cxpfact1.fact_proveedor
    and motivo_cxp = r_cxpfact1.motivo_cxp;
    if not found then
        insert into cxpdocm (compania, proveedor, documento, docmto_aplicar, motivo_cxp,
            docmto_aplicar_ref, motivo_cxp_ref, aplicacion_origen,
            uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo, status,
            usuario, fecha_captura, obs_docmto, fecha_cancelo, referencia)
        values (r_cxpfact1.compania, r_cxpfact1.proveedor, r_cxpfact1.fact_proveedor,
            r_cxpfact1.fact_proveedor, trim(r_cxpfact1.motivo_cxp), r_cxpfact1.fact_proveedor,
            trim(r_cxpfact1.motivo_cxp), r_cxpfact1.aplicacion_origen, ''N'', r_cxpfact1.fecha_posteo_fact_cxp,
            r_cxpfact1.vence_fact_cxp, ldc_monto, r_cxpfact1.fecha_posteo_fact_cxp,
            ''R'', current_user, current_timestamp, r_cxpfact1.obs_fact_cxp,
            current_date, null);
    else
        update cxpdocm
        set fecha_docmto = r_cxpfact1.fecha_posteo_fact_cxp,
            monto = ldc_monto,
            fecha_posteo = r_cxpfact1.fecha_posteo_fact_cxp
        where compania = r_cxpfact1.compania
        and proveedor = r_cxpfact1.proveedor
        and documento = r_cxpfact1.fact_proveedor
        and docmto_aplicar = r_cxpfact1.fact_proveedor
        and motivo_cxp = r_cxpfact1.motivo_cxp;
    end if;            
  
return 1;
    
end;
' language plpgsql;    



create function f_monto_factura_cxp(char(2), char(6), char(25)) returns decimal(12,2) as '
declare
    ldc_retorno decimal(12,2);
begin
    select into ldc_retorno -sum(cxpfact2.monto*rubros_fact_cxp.signo_rubro_fact_cxp*cxpmotivos.signo)
    from cxpfact2, rubros_fact_cxp, cxpmotivos, cxpfact1
    where cxpfact2.rubro_fact_cxp = rubros_fact_cxp.rubro_fact_cxp
    and cxpfact1.compania = cxpfact2.compania
    and cxpfact1.proveedor = cxpfact2.proveedor
    and cxpfact1.fact_proveedor = cxpfact2.fact_proveedor
    and cxpfact1.motivo_cxp = cxpmotivos.motivo_cxp
    and cxpfact1.compania = $1
    and cxpfact1.proveedor = $2
    and cxpfact1.fact_proveedor = $3;
    if ldc_retorno is null then
       ldc_retorno := 0;
    end if;
    
    return ldc_retorno;
end;
' language plpgsql;


create function f_cxpfact1_cglposteo(char(2), char(6), char(25)) returns integer as '
declare
    as_compania alias for $1;
    as_proveedor alias for $2;
    as_fact_proveedor alias for $3;
    r_cxpfact1 record;
    r_cxpfact2 record;
    r_rubros_fact_cxp record;
    r_proveedores record;
    r_cxpmotivos record;
    r_cglcuentas record;
    r_cglauxiliares record;
    r_work record;
    r_gral_forma_de_pago record;
    ldc_monto_factura_cxp decimal(10,2);
    li_consecutivo int4;
    ls_cuenta char(24);
    ls_aux1 char(10);
    ls_numero_oc char(10);
    ldc_balance decimal(10,2);
begin
    select into r_cxpfact1 * from cxpfact1
    where compania = as_compania
    and proveedor = as_proveedor
    and fact_proveedor = as_fact_proveedor;
    if not found then
       return 0;
    end if;
    
    select into r_gral_forma_de_pago * from gral_forma_de_pago
    where forma_pago = r_cxpfact1.forma_pago;
    
    
    delete from rela_cxpfact1_cglposteo
    where compania = as_compania
    and proveedor = as_proveedor
    and fact_proveedor = as_fact_proveedor;
    
    select into r_proveedores * from proveedores
    where proveedor = r_cxpfact1.proveedor;
    
    select into r_cxpmotivos * from cxpmotivos
    where motivo_cxp = r_cxpfact1.motivo_cxp;
    
    
    ldc_monto_factura_cxp = f_monto_factura_cxp(r_cxpfact1.compania, r_cxpfact1.proveedor,
                                r_cxpfact1.fact_proveedor);

    ls_numero_oc = r_cxpfact1.numero_oc;
    
    if ls_numero_oc is null then
        ls_numero_oc = ''  '';
    end if;
    
    if r_cxpfact1.obs_fact_cxp is null then
       r_cxpfact1.obs_fact_cxp := ''FACTURA #  '' || trim(r_cxpfact1.fact_proveedor) || ''  O.C. '' || trim(ls_numero_oc);
    else
       r_cxpfact1.obs_fact_cxp := ''FACTURA #  '' || r_cxpfact1.fact_proveedor || ''  '' || trim(r_cxpfact1.obs_fact_cxp) || '' O.C. '' || trim(ls_numero_oc);
    end if;
    
    if r_gral_forma_de_pago.dias > 0 then
        ls_cuenta   :=  r_proveedores.cuenta;
    else
        ls_cuenta   :=  f_gralparaxcia(r_cxpfact1.compania, ''CXP'', ''cta_anticipo'');
    end if;
    
    ls_aux1     :=  null;
    select into r_cglcuentas * from cglcuentas
    where trim(cuenta) = trim(ls_cuenta)
    and auxiliar_1 = ''S'';
    if found then
        ls_aux1 :=   r_proveedores.proveedor;
        select into r_cglauxiliares * from cglauxiliares
        where trim(auxiliar) = trim(ls_aux1);
        if not found then
            insert into cglauxiliares (auxiliar, nombre, tipo_persona, status)
            values (ls_aux1, trim(r_proveedores.nomb_proveedor), ''1'', ''A'');
        end if;
    end if;

    ldc_balance = ldc_monto_factura_cxp * r_cxpmotivos.signo;
    li_consecutivo := f_cglposteo(r_cxpfact1.compania, r_cxpfact1.aplicacion_origen, r_cxpfact1.fecha_posteo_fact_cxp, 
                            ls_cuenta, ls_aux1, null,
                            r_cxpmotivos.tipo_comp, r_cxpfact1.obs_fact_cxp, 
                            (ldc_monto_factura_cxp*r_cxpmotivos.signo));
    if li_consecutivo > 0 then
        insert into rela_cxpfact1_cglposteo (compania, proveedor, fact_proveedor, consecutivo)
        values (r_cxpfact1.compania, r_cxpfact1.proveedor, r_cxpfact1.fact_proveedor, li_consecutivo);
    end if;
    
    
    for r_cxpfact2 in select * from cxpfact2
                    where cxpfact2.compania = r_cxpfact1.compania
                    and cxpfact2.proveedor = r_cxpfact1.proveedor
                    and cxpfact2.fact_proveedor = r_cxpfact1.fact_proveedor
                    and cxpfact2.monto <> 0
                    order by 1
    loop
        select into r_rubros_fact_cxp * from rubros_fact_cxp
        where rubro_fact_cxp = r_cxpfact2.rubro_fact_cxp;
        
        if r_cxpfact2.cuenta is null then
           for r_work in select articulos_por_almacen.cuenta, sum(eys2.costo) as monto
                            from eys2, articulos_por_almacen
                            where eys2.almacen = articulos_por_almacen.almacen
                            and eys2.articulo = articulos_por_almacen.articulo
                            and eys2.compania = r_cxpfact2.compania
                            and eys2.proveedor = r_cxpfact2.proveedor
                            and eys2.fact_proveedor = r_cxpfact2.fact_proveedor
                            group by 1
                            order by 1
           loop
            ldc_balance = ldc_balance + (r_work.monto*r_rubros_fact_cxp.signo_rubro_fact_cxp);
            li_consecutivo := f_cglposteo(r_cxpfact1.compania, r_cxpfact1.aplicacion_origen, r_cxpfact1.fecha_posteo_fact_cxp, 
                                    r_work.cuenta, null, null,
                                    r_cxpmotivos.tipo_comp, r_cxpfact1.obs_fact_cxp, 
                                    (r_work.monto*r_rubros_fact_cxp.signo_rubro_fact_cxp));
            if li_consecutivo > 0 then
                insert into rela_cxpfact1_cglposteo (compania, proveedor, fact_proveedor, consecutivo)
                values (r_cxpfact1.compania, r_cxpfact1.proveedor, r_cxpfact1.fact_proveedor, li_consecutivo);
            end if; 
           end loop;
        else
            ldc_balance = ldc_balance + (r_cxpfact2.monto*r_rubros_fact_cxp.signo_rubro_fact_cxp);
            li_consecutivo := f_cglposteo(r_cxpfact1.compania, r_cxpfact1.aplicacion_origen, r_cxpfact1.fecha_posteo_fact_cxp, 
                                    r_cxpfact2.cuenta, r_cxpfact2.auxiliar1, r_cxpfact2.auxiliar2,
                                    r_cxpmotivos.tipo_comp, r_cxpfact1.obs_fact_cxp, 
                                    (r_cxpfact2.monto*r_rubros_fact_cxp.signo_rubro_fact_cxp));
            if li_consecutivo > 0 then
                insert into rela_cxpfact1_cglposteo (compania, proveedor, fact_proveedor, consecutivo)
                values (r_cxpfact1.compania, r_cxpfact1.proveedor, r_cxpfact1.fact_proveedor, li_consecutivo);
            end if; 
        end if;
        
    end loop;
    
    if ldc_balance <= -0.02 or ldc_balance >= 0.02 then
        raise exception ''Factura % esta en desbalance %'',as_fact_proveedor,ldc_balance;
    end if;
   
    return 1;
end;
' language plpgsql;




create function f_saldo_docmto_cxp(char(2), char(6), char(10),  char(3), date) returns decimal(10,2)
as 
'select sum(a.monto*b.signo*-1) as saldo from cxpdocm a, cxpmotivos b
where		a.motivo_cxp			=	b.motivo_cxp
and		a.compania				=	$1
and		a.proveedor				=	$2
and		a.motivo_cxp_ref		=	$4
and		a.docmto_aplicar_ref	=	$3
and		a.docmto_aplicar		=	$3
and		a.fecha_docmto			<= $5;' language 'sql';
