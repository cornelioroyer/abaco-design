drop function f_cglposteo_consecutivo();
drop function f_cglposteoaux1(int4, char(24), char(10), decimal(10,2));
drop function f_cglposteoaux2(int4, char(24), char(10), decimal(10,2));
drop function f_cglposteo(char(2), char(3), date, char(24), char(10), char(10), char(3), text, decimal(10,2));
drop function f_cglposteoaux1_cxpdocm(int4, char(10), int4) cascade;
drop function f_cglposteoaux1_cxcdocm(int4, char(10), int4) cascade;
drop function f_update_cglsldoaux1(char(2)) cascade;


create function f_cglposteoaux2(int4, char(24), char(10), decimal(10,2)) returns int4 as '
declare
    ai_consecutivo alias for $1;
    as_cuenta alias for $2;
    as_auxiliar alias for $3;
    adc_monto alias for $4;
    r_cglcuentas record;
    ldc_debito decimal(10,2);
    ldc_credito decimal(10,2);
    r_cglposteo record;
    r_cglposteoaux1 record;
    r_cglposteoaux2 record;
    li_secuencial integer;
begin
    if adc_monto = 0 then
       return 0;
    end if;
    
    select into r_cglcuentas * from cglcuentas
    where trim(cuenta) = trim(as_cuenta);
    if not found then
        Raise Exception ''Cuenta % no Existe...Verifique'', as_cuenta;
    end if;
    
    if Trim(r_cglcuentas.auxiliar_2) = ''S'' then
       if adc_monto > 0 then
          ldc_debito  := adc_monto;
          ldc_credito := 0;
       else
          ldc_debito  := 0;
          ldc_credito := -adc_monto;
       end if;
       
       select into r_cglposteo * from cglposteo
       where consecutivo = ai_consecutivo;
       if found then
            li_secuencial := 1;
            loop
                select into r_cglposteoaux2 * from cglposteoaux2
                where consecutivo = ai_consecutivo
                and auxiliar = as_auxiliar
                and secuencial = li_secuencial;
                if not found then
                   insert into cglposteoaux2 (consecutivo, auxiliar, secuencial, debito, credito)
                   values (ai_consecutivo, as_auxiliar, li_secuencial, ldc_debito, ldc_credito);
                   exit;
                else
                    li_secuencial := li_secuencial + 1;
                end if;
            end loop;                
        end if;           
    end if;
    
    return ai_consecutivo;
end;
' language plpgsql;



create function f_update_cglsldoaux1(char(2)) returns integer as '
declare
    as_cia char(2);
    r_gralperiodos record;
begin
    for r_gralperiodos in select * from gralperiodos
                            where aplicacion = ''CGL''
                            and compania = as_cia
                            and estado = ''A''
                            order by inicio
    loop
        update cglsldoaux1
        set debito = 0, credito = 0
        where cglsldoaux1.year = r_gralperiodos.year
        and cglsldoaux1.periodo = r_gralperiodos.periodo
        and cglsldoaux1.compania = as_cia;
        
        update cglsldoaux1
        set debito = v_cglsldoaux1.debito,
        credito = v_cglsldoaux1.credito
        where cglsldoaux1.compania = v_cglsldoaux1.compania
        and cglsldoaux1.cuenta = v_cglsldoaux1.cuenta
        and trim(cglsldoaux1.auxiliar) = trim(v_cglsldoaux1.auxiliar)
        and cglsldoaux1.year = v_cglsldoaux1.year
        and cglsldoaux1.periodo = v_cglsldoaux1.periodo
        and cglsldoaux1.year = r_gralperiodos.year
        and cglsldoaux1.periodo = r_gralperiodos.periodo
        and cglsldoaux1.compania = as_cia;

/*
		insert into cglsldoaux1 (compania, cuenta, auxiliar, year, periodo, balance_inicio, debito, credito)
		select compania, cuenta, auxiliar, year, periodo, 0, debito, credito from v_cglsldoaux1
		where compania = as_cia
		and year = r_gralperiodos.year
		and periodo = r_gralperiodos.periodo
		and not exists
			(select * from cglsldoaux1
				where cglsldoaux1.compania = v_cglsldoaux1.compania
				and cglsldoaux1.cuenta = v_cglsldoaux1.cuenta
				and cglsldoaux1.auxiliar = v_cglsldoaux1.auxiliar
				and cglsldoaux1.year = v_cglsldoaux1.year
				and cglsldoaux1.periodo = v_cglsldoaux1.periodo);
*/
                
    end loop;

    return 1;
end;
' language plpgsql;



create function f_cglposteo(char(2), char(3), date, char(24), char(10), char(10), char(3), text, decimal(10,2)) returns int4 as '
declare
    as_compania alias for $1;
    as_aplicacion alias for $2;
    ad_fecha alias for $3;
    as_cuenta alias for $4;
    as_aux1 alias for $5;
    as_aux2 alias for $6;
    as_tipo_comp alias for $7;
    as_descripcion alias for $8;
    adc_monto alias for $9;
    r_gralperiodos record;
    r_cglcuentas record;
    r_cglauxiliares record;
    li_consecutivo int4;
    ldc_debito decimal(20,2);
    ldc_credito decimal(20,2);
    i integer;
    lc_aux1 char(10);
begin
    lc_aux1 = trim(as_aux1);
    if adc_monto = 0 then
       return 0;
    end if;
    
    if adc_monto > 0 then
       ldc_debito  := adc_monto;
       ldc_credito := 0;
    else
       ldc_debito  := 0;
       ldc_credito := -adc_monto;
    end if;

    
    i = f_valida_fecha(as_compania, ''CGL'', ad_fecha);
    
    if as_cuenta is null then
       Raise Exception ''Cuenta % no puede ser nula...Verifique'',as_cuenta;
    end if;
    

    select into r_cglcuentas * from cglcuentas
    where cuenta = as_cuenta
    and status = ''I'';
    if found Then
       Raise Exception ''Cuenta % Esta Inactiva...Verifique'',as_cuenta;
    end if;

    
    select into r_cglcuentas cglcuentas.* from cglcuentas, cglniveles
    where cglcuentas.nivel = cglniveles.nivel
    and cglniveles.recibe = ''N''
    and cuenta = as_cuenta;
    if found then
       Raise Exception ''Cuenta % NO Recibe Movimientos...Verifique'',as_cuenta;
    end if;

    
    select into r_cglcuentas * from cglcuentas
    where trim(cuenta) = trim(as_cuenta);
    if not found then
        Raise Exception ''Cuenta % no existe...Verifique'',as_cuenta;
    else
        if r_cglcuentas.auxiliar_1 = ''S'' then
            if as_aux1 is null then
                lc_aux1 = ''000'';
            end if;
    --       Raise Exception ''Cuenta % lleva auxiliar...Verifique '',as_cuenta;

            select into r_cglauxiliares * from cglauxiliares
            where auxiliar = lc_aux1;
            if not found then
                Raise Exception ''Auxiliar % no Existe...Verifique'', lc_aux1;
            else
                if r_cglauxiliares.status = ''I'' then
                    Raise Exception ''Auxliar % esta Inactivo...Verifique'', as_aux1;
                end if;
            end if;
        end if;
        
        if r_cglcuentas.auxiliar_2 = ''S'' then
            if as_aux2 is null then
                Raise Exception ''Auxiliar 2 es Obligatorio para cuenta %'', as_cuenta;
            end if;
            
            select into r_cglauxiliares * from cglauxiliares
            where auxiliar = as_aux2;
            if not found then
                Raise Exception ''Auxiliar 2 % no Existe...Verifique'', as_aux2;
            else
                if r_cglauxiliares.status = ''I'' then
                    Raise Exception ''Auxiliar 2 % esta Inactivo...Verifique'', as_aux2;
                end if;
            end if;
        end if;
    end if;

    select into r_gralperiodos * from gralperiodos
    where compania = as_compania
    and aplicacion = ''CGL''
    and ad_fecha between inicio and final
    and estado = ''A''
    order by inicio;
    if not found then
        raise exception ''Fecha % no tiene periodo abierto en CGL'',ad_fecha;
    end if;
    
    li_consecutivo = f_cglposteo_consecutivo();    


/*
    
    insert into temporal_tmp(descripcion, monto1, monto2) values(to_char(ldc_debito, ''9999999999D99''), 0, 0);

    if as_cuenta <> ''1101001'' and as_cuenta <> ''1106000'' then
        raise exception ''entre %'', as_cuenta;
    else
        raise exception '' diferente entre %'', as_cuenta;
    end if;        
*/    

    insert into cglposteo (consecutivo, secuencia, compania, aplicacion, year, periodo,
        cuenta, tipo_comp, aplicacion_origen, usuario_captura, usuario_actualiza,
        fecha_comprobante, fecha_captura, fecha_actualiza, descripcion, debito, credito,
        status, linea)
    values (li_consecutivo, 0, as_compania, ''CGL'', r_gralperiodos.year, 
        r_gralperiodos.periodo, as_cuenta, as_tipo_comp, as_aplicacion, current_user, 
        current_user, ad_fecha, current_timestamp, current_date, as_descripcion, 
        Round(ldc_debito,2), Round(ldc_credito,2), ''R'', 0);


    
    i = f_cglposteoaux1(li_consecutivo, as_cuenta, lc_aux1, adc_monto);
    
    i = f_cglposteoaux2(li_consecutivo, as_cuenta, as_aux2, adc_monto);
    


--    raise exception ''entre'';
    
    return li_consecutivo;
end;
' language plpgsql;


create function f_cglposteo_consecutivo() returns int4 as '
declare
    r_gralparaxapli record;
    r_work record;
    li_secuencia int4;
begin
    select into r_gralparaxapli gralparaxapli.* from gralparaxapli
    where aplicacion = ''CGL''
    and parametro = ''consec_posteo'';
    if not found then
        li_secuencia := 0;
    else
        li_secuencia := to_number(r_gralparaxapli.valor, ''99999999999999'');
    end if;
    
    loop
        li_secuencia := li_secuencia + 1;
        
        select into r_work * from cglposteo
        where consecutivo = li_secuencia;
        if not found then
           exit;
        end if;
    end loop;
    
    update gralparaxapli
    set valor = trim(to_char(li_secuencia, ''99999999999''))
    where parametro = ''consec_posteo''
    and aplicacion = ''CGL'';
     
    return li_secuencia;
end;
' language plpgsql;


create function f_cglposteoaux1_cxcdocm(int4, char(10), int4) returns integer as '
declare
    ai_consecutivo alias for $1;
    as_auxiliar alias for $2;
    ai_secuencial alias for $3;
    r_cglposteoaux1 record;
    r_cglposteo record;
    r_cglctasxaplicacion record;
    r_clientes record;
    r_cglauxiliares record;
    r_cxcmotivos record;
    r_almacen record;
    ls_telefono char(15);
    ls_id char(30);
    ls_dv char(3);
    ls_direccion char(40);
    ldc_monto decimal(10,2);
    ldc_signo decimal(10,2);
    ls_documento char(25);
    ls_almacen char(2);
begin
    select into r_cglposteoaux1 * from cglposteoaux1
    where consecutivo = ai_consecutivo
    and auxiliar = as_auxiliar
    and secuencial = ai_secuencial;
    if not found then
        return 0;
    end if;
    
    select into r_cglposteo * from cglposteo
    where consecutivo = ai_consecutivo;
    if not found then
        return 0;
    end if;
    
    select into r_cglctasxaplicacion * from cglctasxaplicacion
    where trim(cuenta) = trim(r_cglposteo.cuenta)
    and aplicacion = ''CXC'';
    if not found then
        return 0;
    end if;
    
    select into r_clientes * from clientes
    where trim(cliente) = trim(as_auxiliar);
    if not found then
        select into r_cglauxiliares * from cglauxiliares
        where trim(auxiliar) = trim(as_auxiliar);
        
        if r_cglauxiliares.telefono is null then
            ls_telefono := ''1'';
        else
            ls_telefono := r_cglauxiliares.telefono;
        end if;
        
        if r_cglauxiliares.id is null then
            ls_id := ''1'';
        else
            ls_id := trim(r_cglauxiliares.id);
        end if;
        
        if r_cglauxiliares.dv is null then
            ls_dv := ''1'';
        else
            ls_dv := trim(r_cglauxiliares.dv);
        end if;
        
        if r_cglauxiliares.direccion is null then
            ls_direccion := ''1'';
        else
            ls_direccion := trim(r_cglauxiliares.direccion);
        end if;
        
        insert into clientes(cliente, forma_pago, cuenta, cli_cliente, vendedor,
            nomb_cliente, fecha_apertura, fecha_cierre, status, usuario,
            fecha_captura, tel1_cliente, direccion1, limite_credito, promedio_dias_cobro,
            estado_cuenta, categoria_abc)
        values (trim(as_auxiliar), ''30'', r_cglposteo.cuenta, trim(as_auxiliar), ''00'',
            r_cglauxiliares.nombre, current_date, current_date, ''A'', current_user,
            current_timestamp, ls_telefono, ls_direccion, 0, 0, ''S'', ''X'');
        
        
    end if;
    
    ldc_monto := r_cglposteoaux1.debito - r_cglposteoaux1.credito;
    ldc_signo := ldc_monto / Abs(ldc_monto);
    
    select into r_cxcmotivos * from cxcmotivos
    where signo = ldc_signo
    and ajustes = ''S'';
    if not found then
        Raise Exception ''No existe ningun motivo en cxcmotivos con la naturaleza %'',ldc_signo;
    end if;
   
   ls_documento := r_cglposteo.aplicacion_origen || trim(to_char(r_cglposteo.consecutivo, ''999999999''));


    ls_almacen := f_gralparaxcia(r_cglposteo.compania, ''INV'', ''alma_default'');
    
    select into r_almacen * from almacen
    where compania = r_cglposteo.compania
    and almacen = ls_almacen;
    if not found then
        select into r_almacen * from almacen
        where compania = r_cglposteo.compania;
        ls_almacen := r_almacen.almacen;
    end if;
    
    insert into cxcdocm(almacen, cliente, documento, docmto_aplicar, motivo_cxc, 
        docmto_ref, motivo_ref, fecha_posteo, fecha_docmto, fecha_vmto,
        fecha_cancelo, fecha_captura, usuario, obs_docmto, uso_interno, status, aplicacion_origen,
        monto)
    values(ls_almacen, trim(as_auxiliar), trim(ls_documento), trim(ls_documento),
        r_cxcmotivos.motivo_cxc, trim(ls_documento), r_cxcmotivos.motivo_cxc,
        r_cglposteo.fecha_comprobante, r_cglposteo.fecha_comprobante, 
        r_cglposteo.fecha_comprobante, r_cglposteo.fecha_comprobante, current_timestamp,
        current_user, trim(r_cglposteo.descripcion), ''N'', ''P'', 
        r_cglposteo.aplicacion_origen, Abs(ldc_monto));

    return 1;
end;
' language plpgsql;


create function f_cglposteoaux1_cxpdocm(int4, char(10), int4) returns integer as '
declare
    ai_consecutivo alias for $1;
    as_auxiliar alias for $2;
    ai_secuencial alias for $3;
    r_cglposteoaux1 record;
    r_cglposteo record;
    r_cglctasxaplicacion record;
    r_proveedores record;
    r_cglauxiliares record;
    r_cxpmotivos record;
    ls_telefono char(15);
    ls_id char(30);
    ls_dv char(3);
    ls_direccion char(40);
    ldc_monto decimal(10,2);
    ldc_signo decimal(10,2);
    ls_documento char(25);
    
begin
    select into r_cglposteoaux1 * from cglposteoaux1
    where consecutivo = ai_consecutivo
    and auxiliar = as_auxiliar
    and secuencial = ai_secuencial;
    if not found then
        return 0;
    end if;
    
    select into r_cglposteo * from cglposteo
    where consecutivo = ai_consecutivo;
    
    select into r_cglctasxaplicacion * from cglctasxaplicacion
    where cuenta = r_cglposteo.cuenta
    and aplicacion = ''CXP'';
    if not found then
        return 0;
    end if;
    
    select into r_proveedores * from proveedores
    where trim(proveedor) = trim(as_auxiliar);
    if not found then
        select into r_cglauxiliares * from cglauxiliares
        where trim(auxiliar) = trim(as_auxiliar);
        
        if r_cglauxiliares.telefono is null then
            ls_telefono := ''1'';
        else
            ls_telefono := r_cglauxiliares.telefono;
        end if;
        
        if r_cglauxiliares.id is null then
            ls_id := ''1'';
        else
            ls_id := trim(r_cglauxiliares.id);
        end if;
        
        if r_cglauxiliares.dv is null then
            ls_dv := ''1'';
        else
            ls_dv := trim(r_cglauxiliares.dv);
        end if;
        
        if r_cglauxiliares.direccion is null then
            ls_direccion := ''1'';
        else
            ls_direccion := trim(r_cglauxiliares.direccion);
        end if;
        
        
        insert into proveedores (proveedor, forma_pago, cuenta, nomb_proveedor,
            tel1_proveedor, id_proveedor, dv_proveedor, status, usuario, fecha_captura,
            limite_credito, fecha_apertura, direccion1)
        values (trim(as_auxiliar), ''30'', r_cglposteo.cuenta, r_cglauxiliares.nombre,
            trim(ls_telefono), trim(ls_id), trim(ls_dv), ''A'', current_user, current_timestamp,
            99999, current_date, trim(ls_direccion));
    end if;
    
    ldc_monto := r_cglposteoaux1.debito - r_cglposteoaux1.credito;
    ldc_signo := ldc_monto / Abs(ldc_monto);
    
    select into r_cxpmotivos * from cxpmotivos
    where signo = ldc_signo
    and ajuste = ''S'';
    if not found then
        Raise Exception ''No existe ningun motivo en cxpmotivos con la naturaleza %'',ldc_signo;
    end if;
   
   ls_documento := r_cglposteo.aplicacion_origen || trim(to_char(r_cglposteo.consecutivo, ''999999999''));

   
   insert into cxpdocm (proveedor, compania, documento, docmto_aplicar,
    motivo_cxp, docmto_aplicar_ref, motivo_cxp_ref, aplicacion_origen,
    uso_interno, fecha_docmto, fecha_vmto, monto, fecha_posteo, status,
    usuario, fecha_captura, obs_docmto, fecha_cancelo)
   values (as_auxiliar, r_cglposteo.compania, trim(ls_documento), trim(ls_documento),
    r_cxpmotivos.motivo_cxp, trim(ls_documento), r_cxpmotivos.motivo_cxp, r_cglposteo.aplicacion_origen,
    ''N'', r_cglposteo.fecha_comprobante, r_cglposteo.fecha_comprobante, Abs(ldc_monto),
    r_cglposteo.fecha_comprobante, ''P'', current_user, current_timestamp, trim(r_cglposteo.descripcion),
    current_date);
   
    return 1;
end;
' language plpgsql;




create function f_cglposteoaux1(int4, char(24), char(10), decimal(10,2)) returns int4 as '
declare
    ai_consecutivo alias for $1;
    as_cuenta alias for $2;
    as_auxiliar alias for $3;
    adc_monto alias for $4;
    r_cglcuentas record;
    ldc_debito decimal(10,2);
    ldc_credito decimal(10,2);
    r_cglposteo record;
    r_cglposteoaux1 record;
    li_secuencial integer;
begin
    if adc_monto = 0 then
       return 0;
    end if;
    
    select into r_cglcuentas * from cglcuentas
    where trim(cuenta) = trim(as_cuenta);
    if not found then
        Raise Exception ''Cuenta % no Existe...Verifique'', as_cuenta;
    end if;
    
    if Trim(r_cglcuentas.auxiliar_1) = ''S'' then
       if adc_monto > 0 then
          ldc_debito  := adc_monto;
          ldc_credito := 0;
       else
          ldc_debito  := 0;
          ldc_credito := -adc_monto;
       end if;
       
       select into r_cglposteo * from cglposteo
       where consecutivo = ai_consecutivo;
       if found then
            li_secuencial := 1;
            loop
                select into r_cglposteoaux1 * from cglposteoaux1
                where consecutivo = ai_consecutivo
                and auxiliar = as_auxiliar
                and secuencial = li_secuencial;
                if not found then
                   insert into cglposteoaux1 (consecutivo, auxiliar, secuencial, debito, credito)
                   values (ai_consecutivo, as_auxiliar, li_secuencial, ldc_debito, ldc_credito);
                   exit;
                else
                    li_secuencial := li_secuencial + 1;
                end if;
            end loop;                
        end if;           
    end if;
    
    return ai_consecutivo;
end;
' language plpgsql;
