
set search_path to planilla;

drop function f_poner_proyecto_en_pla_dinero(int4, char(2), char(2), int4, int4) cascade;
drop function f_pla_dinero_update_reservas(int4) cascade;
drop function f_restaura_marcaciones(int4, char(2), int4, int4) cascade;
drop function f_poner_departamentos(int4) cascade;
drop function f_copy_parametros_contables(int4, int4) cascade;
drop function f_fill_pla_cuentas_conceptos(int4) cascade;
drop function f_tmp_departamentos() cascade;
drop function f_insert_pla_empleados() cascade;
drop function f_crear_cuentas_x_proyecto_mecstore() cascade;
drop function f_diferenciar_cuentas_contables() cascade;
drop function f_poner_cuentas_x_proyecto_mecstore() cascade;
--drop function f_crear_empleados_chong() cascade;
drop function f_poner_turnos_en_pla_marcaciones() cascade;
drop function f_cargar_acumulados_chong() cascade;

--drop function f_crear_empleados_decal() returns integer as '
drop function f_cargar_acumulados_decal() cascade;
drop function f_cargar_empleados_seceyco() cascade;
drop function f_poner_proyecto_en_pla_marcaciones(int4) cascade;
drop function f_cargar_pla_empleados_viveros() cascade;
drop function f_poner_turnos_en_pla_marcaciones_viveros() cascade;
drop function f_poner_entrada_y_salida_en_pla_marcaciones(int4, char(2), int4, int4) cascade;
drop function f_eliminar_duplicados_pla_reloj_01(int4) cascade;
drop function f_pla_cuentas_x_concepto(int4) cascade;
drop function f_eliminar_duplicados_pla_marcaciones(int4) cascade;
drop function f_ajustar_fecha_inicio(int4) cascade;
drop function f_copy_pla_retenciones(int4, int4) cascade;
drop function f_crear_pla_retenciones(int4) cascade;
drop function f_crear_pla_retenciones_chong(int4) cascade;
drop function f_cambiar_fecha_eventos(int4) cascade;
drop function f_cargar_certificados_medicos(int4, int4) cascade;
drop function f_update_saldo_pla_retenciones(int4, int4) cascade;
drop function f_saldo_pla_retenciones_pase(int4) cascade;


create function f_update_saldo_pla_retenciones(int4, int4) returns integer as '
declare
    ai_cia_1 alias for $1;
    ai_cia_2 alias for $2;
    r_pla_cuentas record;
    r_pla_cuentas_2 record;
    r_pla_cuentas_conceptos record;
    r_pla_acreedores record;
    r_pla_retenciones record;
    r_pla_retener record;
    r_work record;
    li_id int4;
    ldc_saldo decimal;
    li_id_pla_cuentas int4;
    li_id_pla_cuentas_2 int4;
begin
    for r_pla_retenciones in
        select * from pla_retenciones
        where compania = ai_cia_2
        order by id
    loop
        select into r_work *
        from pla_retenciones
        where compania = ai_cia_1
        and codigo_empleado = r_pla_retenciones.codigo_empleado
        and acreedor = r_pla_retenciones.acreedor
        and numero_documento = r_pla_retenciones.numero_documento;
        if found then
            ldc_saldo   =   f_saldo_pla_retenciones_pase(r_work.id);
            
            if ldc_saldo > 0 then
                update pla_retenciones
                set monto_original_deuda = ldc_saldo
                where id = r_pla_retenciones.id;
            end if;      
        end if;
    end loop;

    
    return 1;
end;
' language plpgsql;


create function f_saldo_pla_retenciones_pase(int4) returns decimal as '
declare
    ai_id alias for $1;
    r_pla_retenciones record;
    r_pla_deducciones record;
    r_pla_empleados record;
    ldc_saldo decimal;
    ldc_pagos decimal;
begin
    ldc_saldo = 0;
    
    select into r_pla_deducciones * from pla_deducciones
    where id_pla_dinero = ai_id;
    if not found then
        return 0;
    end if;
    
    select into r_pla_retenciones * from pla_retenciones
    where id = r_pla_deducciones.id_pla_retenciones;
    if not found then
        return 0;
    end if;
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_retenciones.compania
    and codigo_empleado = r_pla_retenciones.codigo_empleado;
    if not found then
        return 0;
    end if;
    
    if r_pla_empleados.status = ''I'' or r_pla_empleados.status = ''E'' then
        return 0;
    end if;
    
    if r_pla_retenciones.status <> ''A'' then
        return 0;
    end if;
    
        
    select into ldc_pagos sum(pla_dinero.monto) 
    from pla_dinero, pla_deducciones
    where pla_dinero.id = pla_deducciones.id_pla_dinero
    and pla_deducciones.id_pla_retenciones = r_pla_retenciones.id;
    
    if ldc_pagos is null then
        ldc_pagos = 0;
    end if;
    
    ldc_saldo = r_pla_retenciones.monto_original_deuda - ldc_pagos;
    
    return Round(ldc_saldo,2);
end;
' language plpgsql;



create function f_cargar_certificados_medicos(int4, int4) returns integer as '
declare
    ai_cia1 alias for $1;
    ai_cia2 alias for $2;
    r_pla_cuentas record;
    r_pla_cuentas_2 record;
    r_pla_cuentas_conceptos record;
    r_pla_acreedores record;
    r_pla_retenciones record;
    r_pla_retener record;
    r_tmp_chong record;
    r_pla_eventos record;
    r_pla_certificados_medico record;
    r_pla_empleados record;
    r_work record;
    li_id int4;
    li_id_pla_cuentas int4;
    li_id_pla_cuentas_2 int4;
    ld_fecha date;
    lt_hora_entrada time;
    lt_hora_salida time;
    lt_hora_desde time;
    lt_hora_hasta time;
    lts_desde timestamp;
    lts_hasta timestamp;
begin

    for r_pla_certificados_medico in select * from pla_certificados_medico
                            where compania = ai_cia1
                            order by codigo_empleado, desde
    loop
        select into r_pla_empleados *
        from pla_empleados
        where compania = ai_cia2
        and codigo_empleado = r_pla_certificados_medico.codigo_empleado;
        if found then
            select into r_work *
            from pla_certificados_medico
            where compania = r_pla_empleados.compania
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and fecha = r_pla_certificados_medico.fecha;
            if not found then
                insert into pla_certificados_medico(compania, codigo_empleado, fecha,
                    desde, hasta, pagado, observacion, year, numero_planilla, minutos, usuario)
                values(r_pla_empleados.compania, r_pla_empleados.codigo_empleado,
                    r_pla_certificados_medico.fecha, r_pla_certificados_medico.desde,
                    r_pla_certificados_medico.hasta, r_pla_certificados_medico.pagado,
                    r_pla_certificados_medico.observacion, 0, 0, r_pla_certificados_medico.minutos,
                    r_pla_certificados_medico.usuario);                    
            end if;
        end if;

    end loop;
    
    
    
    return 1;
end;
' language plpgsql;



create function f_cambiar_fecha_eventos(int4) returns integer as '
declare
    ai_cia alias for $1;
    r_pla_cuentas record;
    r_pla_cuentas_2 record;
    r_pla_cuentas_conceptos record;
    r_pla_acreedores record;
    r_pla_retenciones record;
    r_pla_retener record;
    r_tmp_chong record;
    r_pla_eventos record;
    r_work record;
    li_id int4;
    li_id_pla_cuentas int4;
    li_id_pla_cuentas_2 int4;
    ld_fecha date;
    lt_hora_entrada time;
    lt_hora_salida time;
    lt_hora_desde time;
    lt_hora_hasta time;
    lts_desde timestamp;
    lts_hasta timestamp;
begin
--                            and codigo_empleado = ''0003''

    for r_pla_eventos in select * from pla_eventos
                            where compania = ai_cia
                            and f_to_date(desde) between ''2015-06-11'' and ''2015-06-15''
                            order by codigo_empleado, desde
    loop
        lt_hora_desde     =   f_extract_time(r_pla_eventos.desde);
        lt_hora_hasta      =   f_extract_time(r_pla_eventos.hasta);
        ld_fecha    =   f_to_date(r_pla_eventos.desde);
        
        ld_fecha = ld_fecha + 5;

        loop
            select into r_work *
            from pla_eventos
            where compania = ai_cia
            and codigo_empleado = r_pla_eventos.codigo_empleado
            and f_to_date(desde) = ld_fecha;
            if not found then
                lts_desde    = f_timestamp(ld_fecha, lt_hora_desde);
                lts_hasta   = f_timestamp(ld_fecha, lt_hora_hasta);
                update pla_eventos
                set desde = lts_desde, hasta = lts_hasta
                where id = r_pla_eventos.id;
                exit;
            else
                ld_fecha = ld_fecha + 1;                
            end if;
        end loop;                
    end loop;
    
    
    
    return 1;
end;
' language plpgsql;



create function f_crear_pla_retenciones_chong(int4) returns integer as '
declare
    ai_cia_1 alias for $1;
    r_pla_cuentas record;
    r_pla_cuentas_2 record;
    r_pla_cuentas_conceptos record;
    r_pla_acreedores record;
    r_pla_retenciones record;
    r_pla_retener record;
    r_tmp_chong record;
    r_work record;
    li_id int4;
    li_id_pla_cuentas int4;
    li_id_pla_cuentas_2 int4;
begin

    for r_tmp_chong in
        select * from tmp_chong
        where codigo is not null
        order by codigo
    loop
    
        select into r_pla_retenciones *
        from pla_retenciones
        where compania = ai_cia_1
        and trim(codigo_empleado) = trim(r_tmp_chong.codigo)
        and trim(acreedor) = ''SITRACA''
        and trim(numero_documento) = ''SITRACAMAYARP'';
        if found then
            continue;
        end if;
                    
        insert into pla_retenciones(compania, codigo_empleado, acreedor, 
            concepto, numero_documento, descripcion_descuento,
            monto_original_deuda, letras_a_pagar, fecha_inidescto,
            fecha_finaldescto, observacion, hacer_cheque, incluir_deduc_carta_trabajo,
            aplica_diciembre, tipo_descuento, status)
        values(ai_cia_1, trim(r_tmp_chong.codigo), ''SITRACA'', ''150'', ''SITRACAMAYARP'', ''SINDICATO SITRACAMAYARP'',
            0, 0, ''2015-05-01'',
            null, null, ''S'', ''S'', ''S'', ''M'', ''A'');            
    
        li_id = lastval();

        insert into pla_retener(id_pla_retenciones, periodo, monto)
        values(li_id, 1, 0.50);

        insert into pla_retener(id_pla_retenciones, periodo, monto)
        values(li_id, 2, 0.50);

    end loop;
    

/*            
    for r_pla_acreedores in
        select * from pla_acreedores
        where compania = ai_cia_1
        order by acreedor
    loop
        insert into pla_acreedores(compania, acreedor, concepto, nombre,
            status, telefono, direccion, observacion, prioridad, ahorro)
        values(ai_cia_2, r_pla_acreedores.acreedor, r_pla_acreedores.concepto,
            r_pla_acreedores.nombre, r_pla_acreedores.status, r_pla_acreedores.telefono,
            r_pla_acreedores.direccion, r_pla_acreedores.observacion,
            r_pla_acreedores.prioridad, r_pla_acreedores.ahorro);            
    end loop;
    
    for r_pla_retenciones in
        select * from pla_retenciones
        where compania = ai_cia_1
        order by id
    loop
        insert into pla_retenciones(compania, codigo_empleado, acreedor, 
            concepto, numero_documento, descripcion_descuento,
            monto_original_deuda, letras_a_pagar, fecha_inidescto,
            fecha_finaldescto, observacion, hacer_cheque, incluir_deduc_carta_trabajo,
            aplica_diciembre, tipo_descuento, status)
        values(ai_cia_2, r_pla_retenciones.codigo_empleado, r_pla_retenciones.acreedor,
            r_pla_retenciones.concepto, r_pla_retenciones.numero_documento, r_pla_retenciones.descripcion_descuento,
            r_pla_retenciones.monto_original_deuda, r_pla_retenciones.letras_a_pagar, r_pla_retenciones.fecha_inidescto,
            r_pla_retenciones.fecha_finaldescto, r_pla_retenciones.observacion,
            r_pla_retenciones.hacer_cheque, r_pla_retenciones.incluir_deduc_carta_trabajo,
            r_pla_retenciones.aplica_diciembre, r_pla_retenciones.tipo_descuento, r_pla_retenciones.status);            
    
        li_id = lastval();
    
        for r_pla_retener in
            select pla_retener.* from pla_retener
            where pla_retener.id_pla_retenciones = r_pla_retenciones.id
            order by periodo
        loop            
            insert into pla_retener(id_pla_retenciones, periodo, monto)
            values(li_id, r_pla_retener.periodo, r_pla_retener.monto);

        end loop;
    end loop;
*/
    
    return 1;
end;
' language plpgsql;



create function f_crear_pla_retenciones(int4) returns integer as '
declare
    ai_cia_1 alias for $1;
    r_pla_cuentas record;
    r_pla_cuentas_2 record;
    r_pla_cuentas_conceptos record;
    r_pla_acreedores record;
    r_pla_retenciones record;
    r_pla_retener record;
    r_work record;
    li_id int4;
    li_id_pla_cuentas int4;
    li_id_pla_cuentas_2 int4;
begin
    for r_pla_acreedores in
        select * from pla_acreedores
        where compania = ai_cia_1
        order by acreedor
    loop
        insert into pla_acreedores(compania, acreedor, concepto, nombre,
            status, telefono, direccion, observacion, prioridad, ahorro)
        values(ai_cia_2, r_pla_acreedores.acreedor, r_pla_acreedores.concepto,
            r_pla_acreedores.nombre, r_pla_acreedores.status, r_pla_acreedores.telefono,
            r_pla_acreedores.direccion, r_pla_acreedores.observacion,
            r_pla_acreedores.prioridad, r_pla_acreedores.ahorro);            
    end loop;
    
    for r_pla_retenciones in
        select * from pla_retenciones
        where compania = ai_cia_1
        order by id
    loop
        insert into pla_retenciones(compania, codigo_empleado, acreedor, 
            concepto, numero_documento, descripcion_descuento,
            monto_original_deuda, letras_a_pagar, fecha_inidescto,
            fecha_finaldescto, observacion, hacer_cheque, incluir_deduc_carta_trabajo,
            aplica_diciembre, tipo_descuento, status)
        values(ai_cia_2, r_pla_retenciones.codigo_empleado, r_pla_retenciones.acreedor,
            r_pla_retenciones.concepto, r_pla_retenciones.numero_documento, r_pla_retenciones.descripcion_descuento,
            r_pla_retenciones.monto_original_deuda, r_pla_retenciones.letras_a_pagar, r_pla_retenciones.fecha_inidescto,
            r_pla_retenciones.fecha_finaldescto, r_pla_retenciones.observacion,
            r_pla_retenciones.hacer_cheque, r_pla_retenciones.incluir_deduc_carta_trabajo,
            r_pla_retenciones.aplica_diciembre, r_pla_retenciones.tipo_descuento, r_pla_retenciones.status);            
    
        li_id = lastval();
    
        for r_pla_retener in
            select pla_retener.* from pla_retener
            where pla_retener.id_pla_retenciones = r_pla_retenciones.id
            order by periodo
        loop            
            insert into pla_retener(id_pla_retenciones, periodo, monto)
            values(li_id, r_pla_retener.periodo, r_pla_retener.monto);

        end loop;
    end loop;

    
    return 1;
end;
' language plpgsql;




create function f_copy_pla_retenciones(int4, int4) returns integer as '
declare
    ai_cia_1 alias for $1;
    ai_cia_2 alias for $2;
    r_pla_cuentas record;
    r_pla_cuentas_2 record;
    r_pla_cuentas_conceptos record;
    r_pla_acreedores record;
    r_pla_retenciones record;
    r_pla_retener record;
    r_work record;
    li_id int4;
    li_id_pla_cuentas int4;
    li_id_pla_cuentas_2 int4;
begin
    for r_pla_acreedores in
        select * from pla_acreedores
        where compania = ai_cia_1
        order by acreedor
    loop
        insert into pla_acreedores(compania, acreedor, concepto, nombre,
            status, telefono, direccion, observacion, prioridad, ahorro)
        values(ai_cia_2, r_pla_acreedores.acreedor, r_pla_acreedores.concepto,
            r_pla_acreedores.nombre, r_pla_acreedores.status, r_pla_acreedores.telefono,
            r_pla_acreedores.direccion, r_pla_acreedores.observacion,
            r_pla_acreedores.prioridad, r_pla_acreedores.ahorro);            
    end loop;
    
    for r_pla_retenciones in
        select * from pla_retenciones
        where compania = ai_cia_1
        order by id
    loop
        insert into pla_retenciones(compania, codigo_empleado, acreedor, 
            concepto, numero_documento, descripcion_descuento,
            monto_original_deuda, letras_a_pagar, fecha_inidescto,
            fecha_finaldescto, observacion, hacer_cheque, incluir_deduc_carta_trabajo,
            aplica_diciembre, tipo_descuento, status)
        values(ai_cia_2, r_pla_retenciones.codigo_empleado, r_pla_retenciones.acreedor,
            r_pla_retenciones.concepto, r_pla_retenciones.numero_documento, r_pla_retenciones.descripcion_descuento,
            r_pla_retenciones.monto_original_deuda, r_pla_retenciones.letras_a_pagar, r_pla_retenciones.fecha_inidescto,
            r_pla_retenciones.fecha_finaldescto, r_pla_retenciones.observacion,
            r_pla_retenciones.hacer_cheque, r_pla_retenciones.incluir_deduc_carta_trabajo,
            r_pla_retenciones.aplica_diciembre, r_pla_retenciones.tipo_descuento, r_pla_retenciones.status);            
    
        li_id = lastval();
    
        for r_pla_retener in
            select pla_retener.* from pla_retener
            where pla_retener.id_pla_retenciones = r_pla_retenciones.id
            order by periodo
        loop            
            insert into pla_retener(id_pla_retenciones, periodo, monto)
            values(li_id, r_pla_retener.periodo, r_pla_retener.monto);

        end loop;
    end loop;

    
    return 1;
end;
' language plpgsql;


create function f_ajustar_fecha_inicio(int4) returns integer as '
declare
    ai_cia alias for $1;
    r_pla_empleados record;
    ld_ultima_liquidacion date;
begin

    for r_pla_empleados in select * from pla_empleados
                            where compania = ai_cia
                            and status in (''A'',''V'')
                            and codigo_empleado not in (''99992461'')
                            order by codigo_empleado
    loop
        ld_ultima_liquidacion = null;
        select into ld_ultima_liquidacion Max(fecha)
        from pla_liquidacion
        where compania = r_pla_empleados.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado;
        
--        raise exception ''% %'',ld_ultima_liquidacion, r_pla_empleados.fecha_inicio;
        if ld_ultima_liquidacion is not null then
            if ld_ultima_liquidacion >= r_pla_empleados.fecha_inicio then
                update pla_empleados
                set fecha_inicio = ld_ultima_liquidacion + 1
                where compania = r_pla_empleados.compania
                and codigo_empleado = r_pla_empleados.codigo_empleado;
            end if;                    
        end if;
    end loop;  
    return 1;
end;
' language plpgsql;



create function f_eliminar_duplicados_pla_marcaciones(int4) returns integer as '
declare
    ai_cia alias for $1;
    r_pla_reloj_01 record;
    r_pla_marcaciones record;
    r_work record;
    lb_primero boolean;
    lvc_codigo_reloj varchar(32);
    lts_fecha timestamp;
begin

    for r_work in select pla_tarjeta_tiempo.compania, pla_tarjeta_tiempo.codigo_empleado, 
                    pla_marcaciones.entrada, pla_marcaciones.salida, count(*)
                    from pla_tarjeta_tiempo, pla_marcaciones, pla_periodos
                    where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
                    and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
                    and pla_tarjeta_tiempo.compania = ai_cia
                    and date(pla_marcaciones.entrada) >= ''2014-07-01''
                    group by 1, 2, 3, 4
                    having count(*) > 1
                    order by 1, 2
    loop
        for r_pla_marcaciones in select pla_marcaciones.*
                                    from pla_marcaciones, pla_tarjeta_tiempo
                                    where pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
                                    and pla_marcaciones.entrada = r_work.entrada
                                    and pla_marcaciones.salida = r_work.salida
                                    and pla_tarjeta_tiempo.codigo_empleado = r_work.codigo_empleado
                                    and pla_tarjeta_tiempo.compania = r_work.compania
                                    order by pla_marcaciones.entrada
        loop
            delete from pla_marcaciones
            where id = r_pla_marcaciones.id;
            exit;
        end loop;
    end loop;  
    return 1;
end;
' language plpgsql;




create function f_pla_cuentas_x_concepto(int4) returns integer as '
declare
    ai_cia alias for $1;
    r_pla_cuentas record;
begin
    select into r_pla_cuentas *
    from pla_cuentas
    where cuenta = ''2103''
    and compania = ai_cia;
    if found then
        insert into pla_cuentas_x_concepto(compania, concepto, id_pla_cuentas, id_pla_cuentas_2)
        select ai_cia, concepto, r_pla_cuentas.id,  r_pla_cuentas.id
        from pla_conceptos;
    end if;
    return 1;
end;
' language plpgsql;





create function f_eliminar_duplicados_pla_reloj_01(int4) returns integer as '
declare
    ai_cia alias for $1;
    r_pla_reloj_01 record;
    lb_primero boolean;
    lvc_codigo_reloj varchar(32);
    lts_fecha timestamp;
begin

    lb_primero = true;
    for r_pla_reloj_01 in select * from pla_reloj_01
                            where compania = ai_cia
                            order by codigo_reloj, fecha
    loop
        if lb_primero then
            lb_primero = false;
            lvc_codigo_reloj    = r_pla_reloj_01.codigo_reloj;
            lts_fecha           = r_pla_reloj_01.fecha;
            continue;
        end if;
        
        if r_pla_reloj_01.codigo_reloj = lvc_codigo_reloj
            and r_pla_reloj_01.fecha = lts_fecha then
            delete from pla_reloj_01
            where id = r_pla_reloj_01.id;
        else
            lvc_codigo_reloj    = r_pla_reloj_01.codigo_reloj;
            lts_fecha           = r_pla_reloj_01.fecha;
        end if;    
            
    end loop;
    
    return 1;
end;
' language plpgsql;





create function f_poner_entrada_y_salida_en_pla_marcaciones(int4, char(2), int4, int4) returns integer as '
declare
    ai_compania alias for $1;
    ac_tipo_de_planilla alias for $2;
    ai_year alias for $3;
    ai_numero_planilla alias for $4;
    r_pla_tarjeta_tiempo record;
    r_pla_marcaciones record;
    r_pla_turnos record;
    lts_entrada timestamp;
    lts_salida timestamp;
    lts_entrada_descanso timestamp;
    lts_salida_descanso timestamp;
    ld_fecha date;
begin
    for r_pla_tarjeta_tiempo in select pla_tarjeta_tiempo.* 
                                from pla_tarjeta_tiempo, pla_periodos
                                where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
                                and pla_periodos.compania = ai_compania
                                and pla_periodos.tipo_de_planilla = ac_tipo_de_planilla
                                and pla_periodos.year = ai_year
                                and pla_periodos.numero_planilla = ai_numero_planilla
                                order by pla_tarjeta_tiempo.id
    loop
        for r_pla_marcaciones in select pla_marcaciones.* 
                                    from pla_marcaciones
                                    where id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
                                    and turno is not null
                                    order by pla_marcaciones.id
        loop
        
            select into r_pla_turnos *
            from pla_turnos
            where compania = ai_compania
            and turno = r_pla_marcaciones.turno;


            ld_fecha    =   f_to_date(r_pla_marcaciones.entrada);
            lts_entrada =   f_timestamp(ld_fecha, r_pla_turnos.hora_inicio);
            
            if r_pla_turnos.hora_inicio_descanso is null then
                lts_entrada_descanso = null;
                lts_salida_descanso = null;
            else
                lts_entrada_descanso    =   f_timestamp(ld_fecha, r_pla_turnos.hora_inicio_descanso);
                lts_salida_descanso     =   f_timestamp(ld_fecha, r_pla_turnos.hora_salida_descanso);
            end if;
            
            
            if r_pla_turnos.hora_salida < r_pla_turnos.hora_inicio then
                ld_fecha    =   ld_fecha + 1;
            end if;
            lts_salida  =   f_timestamp(ld_fecha, r_pla_turnos.hora_salida);

            update pla_marcaciones
            set entrada = lts_entrada, salida = lts_salida, entrada_descanso = lts_entrada_descanso,
                salida_descanso = lts_salida_descanso
            where id = r_pla_marcaciones.id;

        end loop;                            
    end loop;                                
    return 1;
end;
' language plpgsql;


create function f_poner_turnos_en_pla_marcaciones_viveros() returns integer as '
declare
    ai_compania integer;
    r_pla_conceptos record;
    r_pla_cuentas record;
    r_pla_departamentos record;
    r_pla_proyectos record;
    r_pla_empleados record;
    r_tmp_empleados record;
    r_pla_marcaciones record;
    r_pla_horarios record;
    r_pla_tarjeta_tiempo record;
    r_work record;
    r_pla_dias_feriados record;
    ls_cuenta_salarios_por_pagar char(24);
    li_id int4;
    li_contador int4;
    li_dow int4;
    ld_work date;
    lts_work timestamp;
    lt_hora time;
begin
    ai_compania = 1240;

    for r_pla_tarjeta_tiempo in select pla_tarjeta_tiempo.* 
                                from pla_tarjeta_tiempo, pla_periodos
                                where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
                                and pla_periodos.compania = ai_compania
                                and pla_periodos.year = 2013
                                and pla_tarjeta_tiempo.codigo_empleado <> ''9999422''
                                and pla_periodos.numero_planilla = 23
                                and pla_periodos.tipo_de_planilla = ''3''
                                order by pla_tarjeta_tiempo.id
    loop
        for r_pla_marcaciones in select pla_marcaciones.* 
                                    from pla_marcaciones
                                    where id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
                                    order by pla_marcaciones.id
        loop

            ld_work     =   f_to_date(r_pla_marcaciones.entrada);
            
            select into r_pla_dias_feriados *
            from pla_dias_feriados
            where compania = ai_compania
            and fecha = ld_work;
            if found then
                update pla_marcaciones
                set status = ''R''
                where id = r_pla_marcaciones.id;
            end if;
/*        
            li_dow = extract(dow from r_pla_marcaciones.entrada);
            if li_dow = 6 then
                ld_work     =   f_to_date(r_pla_marcaciones.salida);
                lt_hora     =   ''10:00:00.00'';
                lts_work    =   f_timestamp(ld_work, lt_hora);
                update pla_marcaciones
                set turno = ''4'', salida = lts_work
                where id = r_pla_marcaciones.id;
            end if;          
*/            
/*            
            select into r_pla_horarios *
            from pla_horarios
            where compania = r_pla_tarjeta_tiempo.compania
            and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
            and dia = li_dow;
            if found then
                update pla_marcaciones
                set turno = r_pla_horarios.turno
                where id = r_pla_marcaciones.id;
            end if;
*/            
        end loop;                            
    end loop;                                
    return 1;
end;
' language plpgsql;



create function f_cargar_pla_empleados_viveros() returns integer as '
declare
    r_tmp_empleados_viveros record;
    r_pla_departamentos record;
    r_pla_acreedores record;
    r_pla_cargos record;
    r_pla_proyectos record;
    r_pla_empleados record;
    r_tmp_proyectos record;
    r_pla_retener record;
    r_pla_retenciones record;
    r_tmp_acreedores_viveros record;
    r_tmp_descuentos_viveros record;
    lc_tipo_de_contrato char(1);
    lc_forma_de_pago char(1);
    lc_sexo char(1);
    lc_codigo_empleado char(7);
    lc_departamento char(3);
    lc_cargo char(3);
    lc_proyecto char(20);
    lc_grupo char(1);
    lc_estado_civil char(1);
    lc_tipo_descuento char(1);
    lc_dv char(2);
    lc_tipo_de_planilla char(2);
    lc_acreedor char(10);
    li_dependientes int4;
    li_compania int4;
    ldc_salario_bruto decimal;
    ldc_porcentaje decimal;
    ldc_letra decimal;
    ldc_monto decimal;
    ldc_saldo decimal;
begin
    
    for r_tmp_empleados_viveros in
        select * from tmp_empleados_viveros
        order by compania, numero
    loop
        lc_departamento     =   trim(to_char(r_tmp_empleados_viveros.depto, ''999999''));
        lc_codigo_empleado  =   trim(to_char(r_tmp_empleados_viveros.numero, ''9999999''));
        lc_cargo            =   trim(to_char(r_tmp_empleados_viveros.posicion, ''999999''));
        lc_proyecto         =   trim(lc_departamento);
        lc_estado_civil     =   trim(r_tmp_empleados_viveros.estado_civil);
        lc_dv               =   trim(to_char(r_tmp_empleados_viveros.dv, ''99''));
        li_compania         =   r_tmp_empleados_viveros.compania;
        
        
        select into r_tmp_proyectos *
        from tmp_proyectos
        where cia = r_tmp_empleados_viveros.cia
        and codigo = r_tmp_empleados_viveros.depto;
        if not found then
            continue;    
        end if;

        
        select into r_pla_departamentos *
        from pla_departamentos
        where compania = r_tmp_empleados_viveros.compania
        and Trim(departamento) = Trim(lc_departamento);
        if not found then
            insert into pla_departamentos (compania, departamento, descripcion, status)
            values(r_tmp_empleados_viveros.compania, lc_departamento, 
                trim(r_tmp_proyectos.descripcion),1);
                
            select into r_pla_departamentos *
            from pla_departamentos
            where compania = r_tmp_empleados_viveros.compania
            and Trim(departamento) = Trim(lc_departamento);
               
        end if;
        
        
        select into r_pla_proyectos *
        from pla_proyectos
        where compania = r_tmp_empleados_viveros.compania
        and trim(proyecto) = trim(lc_proyecto);
        if not found then
            insert into pla_proyectos(compania, proyecto, descripcion)
            values(r_tmp_empleados_viveros.compania, lc_proyecto, 
                trim(r_tmp_proyectos.descripcion));

            select into r_pla_proyectos *
            from pla_proyectos
            where compania = r_tmp_empleados_viveros.compania
            and trim(proyecto) = trim(lc_proyecto);

        end if;


        select into r_pla_cargos *
        from pla_cargos
        where compania = r_tmp_empleados_viveros.compania
        and Trim(cargo) = Trim(lc_cargo);
        if not found then
            insert into pla_cargos(compania, cargo, descripcion, status, monto)
            values(r_tmp_empleados_viveros.compania, lc_cargo, lc_cargo, 1, 0);

            select into r_pla_cargos *
            from pla_cargos
            where compania = r_tmp_empleados_viveros.compania
            and Trim(cargo) = Trim(lc_cargo);

        end if;

        if Trim(r_tmp_empleados_viveros.tipo_contrato) = ''True'' then
            lc_tipo_de_contrato = ''P'';
        else
            lc_tipo_de_contrato = ''T'';
        end if;

        if Trim(r_tmp_empleados_viveros.forma_pago) = ''E'' then
            lc_forma_de_pago = ''E'';
        else
            lc_forma_de_pago = ''C'';
        end if;

        if Substring(Trim(r_tmp_empleados_viveros.sexo) from 1 for 1) = ''F'' then
            lc_sexo = ''F'';
        else
            lc_sexo = ''M'';
        end if;


        if trim(r_tmp_empleados_viveros.tipo_planilla) = ''B'' then
            lc_tipo_de_planilla = ''3'';
        else
            lc_tipo_de_planilla = ''2'';
        end if;

        lc_grupo        =   substring(trim(r_tmp_empleados_viveros.clave_isr) from 1 for 1);
        li_dependientes =   f_string_to_integer(substring(trim(r_tmp_empleados_viveros.clave_isr) from 1 for 1));
        
        if li_dependientes is null then
            li_dependientes = 0;
        end if;

        if trim(lc_tipo_de_planilla) = ''2'' then
            ldc_salario_bruto   =   (r_tmp_empleados_viveros.tasa_por_hora * 48 * 52) / 24;
        else
            ldc_salario_bruto   =   r_tmp_empleados_viveros.tasa_por_hora * 96;
        end if;
        
        select into r_pla_empleados *
        from pla_empleados
        where compania = r_tmp_empleados_viveros.compania
        and Trim(codigo_empleado) = Trim(lc_codigo_empleado);
        if not found then
            insert into pla_empleados(compania, codigo_empleado,
                tipo_de_planilla, grupo, dependientes, nombre, apellido,
                tipo_contrato, estado_civil, fecha_inicio, 
                fecha_nacimiento, tipo_de_salario, forma_de_pago, tipo_calculo_ir, status,
                sexo, cedula, dv, declarante, ss, direccion1, direccion2, tasa_por_hora, salario_bruto, email,
                cargo, departamento, id_pla_proyectos, telefono_1, telefono_2, direccion4, direccion3)
            values(r_tmp_empleados_viveros.compania, trim(lc_codigo_empleado), trim(lc_tipo_de_planilla), 
                lc_grupo, li_dependientes, 
                Trim(r_tmp_empleados_viveros.nombre), Trim(r_tmp_empleados_viveros.apellido),
                lc_tipo_de_contrato, lc_estado_civil, ''2013-01-01'',
                ''2013-01-01'', ''H'', lc_forma_de_pago, ''R'', ''A'',
                lc_sexo,
                trim(r_tmp_empleados_viveros.cedula), lc_dv, ''1'', trim(to_char(r_tmp_empleados_viveros.seguro_social,''9999999999999'')),
                Substring(Trim(r_tmp_empleados_viveros.direccion) from 1 for 50), r_tmp_empleados_viveros.fecha_liquidacion,
                r_tmp_empleados_viveros.tasa_por_hora, ldc_salario_bruto, '''', r_pla_cargos.id, r_pla_departamentos.id,
                r_pla_proyectos.id, trim(r_tmp_empleados_viveros.telefono), null, 
                trim(r_tmp_empleados_viveros.fecha_ingreso), trim(r_tmp_empleados_viveros.fecha_nacimiento));
        else
        
--            update pla_empleados
--            set telefono_1 = r_tmp_empleados.telefono_1, telefono_2 = r_tmpl_empleados.telefono_2
--            where compania = 893
--            and Trim(codigo_empleado) = Trim(lc_codigo_empleado);
/*
            update pla_empleados
            set salario_bruto = r_tmp_empleados_viveros.salario_base
            where compania = r_tmp_empleados_viveros.compania
            and Trim(codigo_empleado) = Trim(lc_codigo_empleado);
*/
            
        end if;            

        for r_tmp_descuentos_viveros in
            select * from tmp_descuentos_viveros
            where tmp_descuentos_viveros.cia = r_tmp_empleados_viveros.cia
            and tmp_descuentos_viveros.empleado = r_tmp_empleados_viveros.numero
            order by no_descuento
        loop        
            ldc_porcentaje  =   r_tmp_descuentos_viveros.porcentaje;
            ldc_letra       =   r_tmp_descuentos_viveros.letra;
            
            select into r_tmp_acreedores_viveros *
            from tmp_acreedores_viveros
            where cia = r_tmp_descuentos_viveros.cia
            and numero = r_tmp_descuentos_viveros.no_acreedor;
            if not found then
                continue;
            end if;
            
            lc_acreedor =   trim(to_char(r_tmp_acreedores_viveros.numero, ''99999999''));
            select into r_pla_acreedores *
            from pla_acreedores
            where compania = li_compania
            and trim(acreedor) = trim(lc_acreedor);
            if not found then
                insert into pla_acreedores(compania, acreedor, concepto, nombre,
                    status, prioridad, ahorro)
                values(li_compania, trim(lc_acreedor), ''113'',
                    trim(r_tmp_acreedores_viveros.descripcion), ''A'',
                    100, ''N'');

                select into r_pla_acreedores *
                from pla_acreedores
                where compania = r_tmp_empleados_viveros.compania
                and trim(acreedor) = trim(lc_acreedor);

            end if;

            lc_tipo_descuento = ''M'';
            
            if r_tmp_descuentos_viveros.porcentaje > 0 then
                lc_tipo_descuento = ''P'';
            end if;
            
            select into r_pla_retenciones *
            from pla_retenciones
            where compania = li_compania
            and trim(codigo_empleado) = trim(lc_codigo_empleado)
            and trim(acreedor) = trim(lc_acreedor);
            if not found then
                insert into pla_retenciones(compania, codigo_empleado,
                    acreedor, concepto, numero_documento,
                    descripcion_descuento, monto_original_deuda,
                    letras_a_pagar, fecha_inidescto,
                    hacer_cheque, incluir_deduc_carta_trabajo, aplica_diciembre,
                    tipo_descuento, status)
                values(li_compania, trim(lc_codigo_empleado), 
                    trim(lc_acreedor),
                    ''113'', trim(to_char(r_tmp_descuentos_viveros.no_descuento,''9999999'')),
                    trim(r_tmp_descuentos_viveros.descripcion_2), 
                    r_tmp_descuentos_viveros.monto_inicial,
                    0, ''2012-01-01'', ''S'', ''S'', ''S'',
                    lc_tipo_descuento, r_tmp_descuentos_viveros.estado);
            else
/*            
                update pla_retenciones
                set monto_original_deuda = r_tmp_descuentos_viveros.saldo
                where compania = li_compania
                and trim(codigo_empleado) = trim(lc_codigo_empleado)
                and trim(acreedor) = trim(lc_acreedor);
*/

                if r_tmp_descuentos_viveros.saldo = 0 then
                    update pla_retenciones
                    set status = ''I''
                    where compania = li_compania
                    and trim(codigo_empleado) = trim(lc_codigo_empleado)
                    and trim(acreedor) = trim(lc_acreedor);
                end if;
            end if;

            if lc_tipo_descuento = ''P'' then
                ldc_monto   =   ldc_porcentaje * 100;
            else
                ldc_monto   =   ldc_letra;
            end if;
            
            select into r_pla_retenciones *
            from pla_retenciones
            where compania = li_compania
            and trim(codigo_empleado) = trim(lc_codigo_empleado)
            and trim(acreedor) = trim(lc_acreedor);
            if found then
                select into r_pla_retener *
                from pla_retener
                where id_pla_retenciones = r_pla_retenciones.id
                and periodo = 1;
                if not found then
                    insert into pla_retener(id_pla_retenciones, periodo, monto)
                    values(r_pla_retenciones.id, 1, ldc_monto);
                end if;

                select into r_pla_retener *
                from pla_retener
                where id_pla_retenciones = r_pla_retenciones.id
                and periodo = 2;
                if not found then
                    insert into pla_retener(id_pla_retenciones, periodo, monto)
                    values(r_pla_retenciones.id, 2, ldc_monto);
                end if;
            end if;
        end loop;
    end loop;            
    return 1;
end;
' language plpgsql;




create function f_poner_proyecto_en_pla_marcaciones(int4) returns integer as '
declare
    ai_cia alias for $1;
    r_pla_tipos_de_planilla record;
    r_pla_empleados record;
    r_pla_proyectos record;
    r_pla_periodos record;
    r_pla_dinero record;
    r_pla_marcaciones record;
    li_id_pla_proyectos int4;
    i integer;
    lb_sw boolean;
begin

    for r_pla_marcaciones in select * from pla_marcaciones
                            where id_pla_proyectos is null
                            and compania = ai_cia
                            and entrada >= ''2012-09-01''
                            order by id
    loop
        select into r_pla_periodos pla_periodos.*
        from pla_tarjeta_tiempo, pla_periodos
        where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
        and pla_tarjeta_tiempo.id = r_pla_marcaciones.id_tarjeta_de_tiempo
        and pla_periodos.status = ''A'';
        if found then
            for r_pla_proyectos in select * from pla_proyectos
                                    where compania = r_pla_marcaciones.compania
                                    order by id
            loop
                update pla_marcaciones
                set id_pla_proyectos = r_pla_proyectos.id
                where id = r_pla_marcaciones.id;
                exit;
            end loop;
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;



create function f_cargar_empleados_seceyco() returns integer as '
declare
    ai_compania integer;
    r_pla_preelaboradas record;
    r_pla_empleados record;
    r_tmp_acumulados_decal record;
    r_tmp_empleados_seceyco record;
    r_pla_retenciones record;
    r_pla_retener record;
    r_pla_acreedores record;
    r_pla_cargos record;
    r_tmp_descuentos_seceyco record;
    ld_fecha date;
    lc_work char(20);
    lc_codigo_empleado char(20);
    lc_ss char(20);
    lc_cargo char(3);
    lc_estatus char(1);
    ld_fecha_inicio date;
    ld_fecha_nacimiento date;
    li_anio integer;
    li_mes integer;
    li_dia integer;
    li_id_pla_cargos int4;
    
begin
    ai_compania = 1046;

    for r_tmp_empleados_seceyco in select * from tmp_empleados_seceyco
                                    order by codigo_empleado
    loop
--        lc_codigo_empleado  =   trim(to_char(r_tmp_empleados_seceyco.codigo_empleado,''9999999''));
        lc_cargo            =   trim(to_char(r_tmp_empleados_seceyco.cargo, ''999''));
        lc_codigo_empleado  =   trim(r_tmp_empleados_seceyco.codigo_empleado);
        lc_ss               =   Trim(To_char(r_tmp_empleados_seceyco.ss, ''999999999''));

        if r_tmp_empleados_seceyco.estatus = 6 then
            lc_estatus = ''I'';
        else
            lc_estatus = ''A'';
        end if;
        
        select into r_pla_cargos *
        from pla_cargos
        where compania = ai_compania
        and trim(cargo) = trim(lc_cargo);
        if not found then
            insert into pla_cargos(compania, cargo, descripcion, status, monto)
            values(ai_compania, trim(lc_cargo), trim(r_tmp_empleados_seceyco.descripcion_cargo),
                1, 0);
        end if;

        select into r_pla_cargos *
        from pla_cargos
        where compania = ai_compania
        and trim(cargo) = trim(lc_cargo);
        if found then
            li_id_pla_cargos = r_pla_cargos.id;
        end if;


        lc_work =   Trim(To_Char(r_tmp_empleados_seceyco.fecha_inicio, ''99999999''));
        li_anio =   To_Number(Substring(Trim(lc_work) from 1 for 4), ''9999'');
        li_mes  =   To_Number(Substring(Trim(lc_work) from 5 for 2), ''9999'');
        li_dia  =   To_Number(Substring(Trim(lc_work) from 7 for 2), ''9999'');
        ld_fecha_inicio =   f_to_date(li_anio, li_mes, li_dia);
       
        lc_work =   Trim(To_Char(r_tmp_empleados_seceyco.fecha_nacimiento,''99999999''));
        li_anio =   To_Number(Substring(Trim(lc_work) from 1 for 4), ''9999'');
        li_mes  =   To_Number(Substring(Trim(lc_work) from 5 for 2), ''9999'');
        li_dia  =   To_Number(Substring(Trim(lc_work) from 7 for 2), ''9999'');
        ld_fecha_nacimiento =   f_to_date(li_anio, li_mes, li_dia);
        
        
        select into r_pla_empleados *
        from pla_empleados
        where compania = ai_compania
        and trim(codigo_empleado) = trim(lc_codigo_empleado);
        if not found then
            insert into pla_empleados(compania, codigo_empleado,
            apellido, nombre, cargo, departamento, id_pla_proyectos,
            tipo_de_planilla, grupo, dependientes, dependientes_no_declarados,
            tipo_contrato, estado_civil, fecha_inicio, fecha_nacimiento,
            tipo_de_salario, forma_de_pago, tipo_calculo_ir,
            status, sexo, tipo, cedula, dv, declarante, ss, direccion1,
            tasa_por_hora, salario_bruto, email)
            values(ai_compania, lc_codigo_empleado,
            r_tmp_empleados_seceyco.apellido, r_tmp_empleados_seceyco.nombre,
            1575, 1359, 928, ''2'', ''A'', 0, 0, 
            ''P'', ''C'', ld_fecha_inicio, ld_fecha_nacimiento, 
            ''F'',''T'', ''A'', ''A'', r_tmp_empleados_seceyco.sexo, ''1'', 
            Trim(r_tmp_empleados_seceyco.cedula), ''00'', ''N'', Trim(lc_ss), 
            ''poner'', r_tmp_empleados_seceyco.tasa_por_hora, 
            r_tmp_empleados_seceyco.salario_mensual/2, '''');
        
        else
        
            
            update pla_empleados
            set apellido = trim(r_tmp_empleados_seceyco.apellido),
                nombre = trim(r_tmp_empleados_seceyco.nombre),
                cargo = li_id_pla_cargos,
                fecha_inicio = ld_fecha_inicio,
                fecha_nacimiento = ld_fecha_nacimiento,
                cedula = trim(r_tmp_empleados_seceyco.cedula),
                status = lc_estatus,
                ss = trim(lc_ss),
                tasa_por_hora = r_tmp_empleados_seceyco.tasa_x_hora,
                salario_bruto = r_tmp_empleados_seceyco.salario_mensual/2,
                departamento = 1489
            where compania = ai_compania
            and trim(codigo_empleado) = trim(lc_codigo_empleado);
        end if;


        for r_tmp_descuentos_seceyco in
                select * from tmp_descuentos_seceyco
                where trim(codigo_empleado) = trim(lc_codigo_empleado)
        loop
            select into r_pla_acreedores *
            from pla_acreedores
            where compania = ai_compania
            and trim(acreedor) = trim(r_tmp_descuentos_seceyco.codigo_acreedor);
            if not found then
                insert into pla_acreedores(compania, acreedor, concepto,
                    nombre, status, prioridad, ahorro)
                values(ai_compania, trim(r_tmp_descuentos_seceyco.codigo_acreedor),
                    ''113'',
                    SubString(Trim(r_tmp_descuentos_seceyco.descripcion_acreedor) from 1 for 40),
                    ''A'', 100, ''N'');
            end if;
            
            
            select into r_pla_retenciones *
            from pla_retenciones
            where compania = ai_compania
            and trim(codigo_empleado) = trim(lc_codigo_empleado)
            and trim(acreedor) = trim(r_tmp_descuentos_seceyco.codigo_acreedor);
            if not found then
                insert into pla_retenciones(compania, codigo_empleado,
                    acreedor, concepto, numero_documento,
                    descripcion_descuento, monto_original_deuda,
                    letras_a_pagar, fecha_inidescto,
                    hacer_cheque, incluir_deduc_carta_trabajo, aplica_diciembre,
                    tipo_descuento, status)
                values(ai_compania, trim(lc_codigo_empleado), 
                    trim(r_tmp_descuentos_seceyco.codigo_acreedor),
                    ''113'', ''1234'', ''DESCUENTO'', r_tmp_descuentos_seceyco.saldo_inicial,
                    0, ''2012-01-01'', trim(r_tmp_descuentos_seceyco.emite_cheque),
                    ''S'', trim(r_tmp_descuentos_seceyco.descontar_diciembre),
                    ''M'', ''A'');
            end if;

            select into r_pla_retenciones *
            from pla_retenciones
            where compania = ai_compania
            and trim(codigo_empleado) = trim(lc_codigo_empleado)
            and trim(acreedor) = trim(r_tmp_descuentos_seceyco.codigo_acreedor);
            if found then
                select into r_pla_retener *
                from pla_retener
                where id_pla_retenciones = r_pla_retenciones.id
                and periodo = 1;
                if not found then
                    insert into pla_retener(id_pla_retenciones, periodo, monto)
                    values(r_pla_retenciones.id, 1, r_tmp_descuentos_seceyco.descuento_x_periodo);
                end if;

                select into r_pla_retener *
                from pla_retener
                where id_pla_retenciones = r_pla_retenciones.id
                and periodo = 2;
                if not found then
                    insert into pla_retener(id_pla_retenciones, periodo, monto)
                    values(r_pla_retenciones.id, 2, r_tmp_descuentos_seceyco.descuento_x_periodo);
                end if;
            end if;
        end loop;
        
/*
        for r_tmp_pagos_2006 in select * from tmp_pagos_2006
                                where trim(codigo_empleado) = trim(lc_codigo_empleado)
                                order by anio, mes
        loop
            li_anio         =   r_tmp_pagos_2006.anio;
            li_mes          =   r_tmp_pagos_2006.mes;
            li_dia          =   r_tmp_pagos_2006.dia;
            ld_fecha_inicio =   f_to_date(li_anio, li_mes, li_dia);
             
        end loop;
*/
        
        
    end loop;
    return 1;
end;
' language plpgsql;



create function f_cargar_acumulados_decal() returns integer as '
declare
    ai_compania integer;
    r_pla_preelaboradas record;
    r_pla_empleados record;
    r_tmp_acumulados_decal record;
    ld_fecha date;
begin
    ai_compania = 1043;

    for r_tmp_acumulados_decal in select * from tmp_acumulados_decal
                                    order by fecha, codigo_empleado
    loop
        ld_fecha = r_tmp_acumulados_decal.fecha;
        
        select into r_pla_empleados *
        from pla_empleados
        where compania = ai_compania
        and trim(cedula) = trim(r_tmp_acumulados_decal.cedula);
        if found then

            select into r_pla_preelaboradas *
            from pla_preelaboradas
            where compania = ai_compania
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and fecha = ld_fecha
            and concepto = ''03'';
            if not found and r_tmp_acumulados_decal.salario is not null then
                insert into pla_preelaboradas(compania, codigo_empleado,
                    concepto, fecha, monto)
                values(ai_compania, r_pla_empleados.codigo_empleado,
                    ''03'', ld_fecha, r_tmp_acumulados_decal.salario);
            end if;
            
            if r_tmp_acumulados_decal.gasto is not null
                and r_tmp_acumulados_decal.gasto > 0 then
                select into r_pla_preelaboradas *
                from pla_preelaboradas
                where compania = ai_compania
                and codigo_empleado = r_pla_empleados.codigo_empleado
                and fecha = ld_fecha
                and concepto = ''73'';
                if not found then
                    insert into pla_preelaboradas(compania, codigo_empleado,
                        concepto, fecha, monto)
                    values(ai_compania, r_pla_empleados.codigo_empleado,
                        ''73'', ld_fecha, r_tmp_acumulados_decal.gasto);
                end if;
            end if;
        end if;
    end loop;
    return 1;
end;
' language plpgsql;


/*
create function f_crear_empleados_decal() returns integer as '
declare
    ai_compania integer;
    r_pla_conceptos record;
    r_pla_cuentas record;
    r_pla_departamentos record;
    r_pla_proyectos record;
    r_pla_empleados record;
    r_tmp_empleados record;
    r_work record;
    r_tmp_empleados_decal record;
    r_tmp_retenciones_decal record;
    ls_cuenta_salarios_por_pagar char(24);
    li_id int4;
    li_contador int4;
begin
    ai_compania = 1043;

   
    select into r_pla_proyectos *
    from pla_proyectos
    where compania = ai_compania
    order by id;
    
    
    for r_tmp_empleados in
        select * from tmp_empleados
        order by codigo_empleado_new
    loop
    
        select into r_pla_empleados * 
        from pla_empleados
        where compania = ai_compania
        and Trim(codigo_empleado) = Trim(r_tmp_empleados.codigo_empleado);
        if not found then
            insert into pla_empleados(compania, codigo_empleado, apellido, nombre, cargo,
                departamento, id_pla_proyectos, tipo_de_planilla, grupo, dependientes,
                dependientes_no_declarados, tipo_contrato, estado_civil, fecha_inicio,
                fecha_terminacion_contrato, fecha_terminacion_real,
                fecha_nacimiento, tipo_de_salario, forma_de_pago, tipo_calculo_ir,
                telefono_1, telefono_2, status, sexo, tipo, cedula, dv, declarante,
                ss, direccion1, direccion2, tasa_por_hora, salario_brupo);
            values
                (ai_compania, r_tmp_empleados.codigo_empleado_new,
                r_tmp_empleados.apellido, r_tmp_empleados.nombre, r_pla_cargos.id,
                r_pla_departamentos.departamento, r_pla_proyectos.id,
                ''2'', ''A'', 0, 0, ''P'', ''C'', ''2010-01-01'', null,
                null, ''1991-01-01'', ''F'', ''E'', ''R'', null, null, ''A'',
                r_tmp_empleados.sexo, ''1'', r_tmp_empleados.cedula,
                ''00'', ''N'', r_tmp_empleados.ss, null, null, r_tmp_empleados.tasa_x_hora,
                (r_tmp_empleados.tasa_x_hora*48*52/12));
        else
        
        end if;
    end loop;
    return 1;
end;
' language plpgsql;
*/


create function f_cargar_acumulados_chong() returns integer as '
declare
    ai_compania integer;
    r_tmp_acumulados_chong record;
    r_pla_preelaboradas record;
    r_pla_empleados record;
    ld_mayo date;
    ld_junio date;
begin
    ai_compania = 992;
    ld_mayo     = ''2011-04-30'';
    ld_junio    = ''2011-06-30'';

    for r_tmp_acumulados_chong in select * from tmp_acumulados_chong
                                    order by cedula
    loop
        select into r_pla_empleados *
        from pla_empleados
        where compania = ai_compania
        and trim(cedula) = trim(r_tmp_acumulados_chong.cedula);
        if found then
            select into r_pla_preelaboradas *
            from pla_preelaboradas
            where compania = ai_compania
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and fecha = ld_mayo
            and concepto = ''03'';
            if not found and r_tmp_acumulados_chong.salario is not null then
                insert into pla_preelaboradas(compania, codigo_empleado,
                    concepto, fecha, monto)
                values(ai_compania, r_pla_empleados.codigo_empleado,
                    ''03'', ld_mayo, r_tmp_acumulados_chong.salario);
            end if;
            
            select into r_pla_preelaboradas *
            from pla_preelaboradas
            where compania = ai_compania
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and fecha = ld_mayo
            and concepto = ''106'';
            if not found and r_tmp_acumulados_chong.isr is not null then
                insert into pla_preelaboradas(compania, codigo_empleado,
                    concepto, fecha, monto)
                values(ai_compania, r_pla_empleados.codigo_empleado,
                    ''106'', ld_mayo, r_tmp_acumulados_chong.isr);
            end if;

            select into r_pla_preelaboradas *
            from pla_preelaboradas
            where compania = ai_compania
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and fecha = ld_mayo
            and concepto = ''109'';
            if not found and r_tmp_acumulados_chong.xiii is not null then
                insert into pla_preelaboradas(compania, codigo_empleado,
                    concepto, fecha, monto)
                values(ai_compania, r_pla_empleados.codigo_empleado,
                    ''109'', ld_mayo, r_tmp_acumulados_chong.xiii);
            end if;
            
/*
            select into r_pla_preelaboradas *
            from pla_preelaboradas
            where compania = ai_compania
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and fecha = ld_junio
            and concepto = ''03'';
            if not found and r_tmp_acumulados_chong.junio is not null then
                insert into pla_preelaboradas(compania, codigo_empleado,
                    concepto, fecha, monto)
                values(ai_compania, r_pla_empleados.codigo_empleado,
                    ''03'', ld_junio, r_tmp_acumulados_chong.junio);
            end if;
            
            select into r_pla_preelaboradas *
            from pla_preelaboradas
            where compania = ai_compania
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and fecha = ld_junio
            and concepto = ''106'';
            if not found and r_tmp_acumulados_chong.isr_junio is not null then
                insert into pla_preelaboradas(compania, codigo_empleado,
                    concepto, fecha, monto)
                values(ai_compania, r_pla_empleados.codigo_empleado,
                    ''106'', ld_junio, r_tmp_acumulados_chong.isr_junio);
            end if;

            select into r_pla_preelaboradas *
            from pla_preelaboradas
            where compania = ai_compania
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and fecha = ld_junio
            and concepto = ''109'';
            if not found and r_tmp_acumulados_chong.xiii_junio is not null then
                insert into pla_preelaboradas(compania, codigo_empleado,
                    concepto, fecha, monto)
                values(ai_compania, r_pla_empleados.codigo_empleado,
                    ''109'', ld_junio, r_tmp_acumulados_chong.xiii_junio);
            end if;
*/            
        end if;
    end loop;
    return 1;
end;
' language plpgsql;


create function f_poner_turnos_en_pla_marcaciones() returns integer as '
declare
    ai_compania integer;
    r_pla_conceptos record;
    r_pla_cuentas record;
    r_pla_departamentos record;
    r_pla_proyectos record;
    r_pla_empleados record;
    r_tmp_empleados record;
    r_pla_marcaciones record;
    r_pla_horarios record;
    r_pla_tarjeta_tiempo record;
    r_work record;
    ls_cuenta_salarios_por_pagar char(24);
    li_id int4;
    li_contador int4;
    li_dow int4;
    
begin
    ai_compania = 880;

    for r_pla_tarjeta_tiempo in select pla_tarjeta_tiempo.* 
                                from pla_tarjeta_tiempo, pla_periodos
                                where pla_tarjeta_tiempo.id_periodos = pla_periodos.id
                                and pla_periodos.compania = ai_compania
                                and pla_periodos.year = 2011
                                and pla_periodos.numero_planilla = 30
                                and pla_periodos.tipo_de_planilla = ''1''
                                order by pla_tarjeta_tiempo.id
    loop
        for r_pla_marcaciones in select pla_marcaciones.* 
                                    from pla_marcaciones
                                    where id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
                                    order by pla_marcaciones.id
        loop
            li_dow = extract(dow from r_pla_marcaciones.entrada);
            select into r_pla_horarios *
            from pla_horarios
            where compania = r_pla_tarjeta_tiempo.compania
            and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
            and dia = li_dow;
            if found then
                update pla_marcaciones
                set turno = r_pla_horarios.turno
                where id = r_pla_marcaciones.id;
            end if;
        end loop;                            
    end loop;                                
    return 1;
end;
' language plpgsql;



/*
create function f_crear_empleados_chong() returns integer as '
declare
    ai_compania integer;
    r_pla_conceptos record;
    r_pla_cuentas record;
    r_pla_departamentos record;
    r_pla_proyectos record;
    r_pla_empleados record;
    r_tmp_empleados record;
    r_work record;
    ls_cuenta_salarios_por_pagar char(24);
    li_id int4;
    li_contador int4;
begin
    ai_compania = 987;

   
    select into r_pla_proyectos *
    from pla_proyectos
    where compania = ai_compania
    order by id;
    
    
    for r_tmp_empleados in
        select * from tmp_empleados
        order by codigo_empleado_new
    loop
    
        select into r_pla_empleados * 
        from pla_empleados
        where compania = ai_compania
        and Trim(codigo_empleado) = Trim(r_tmp_empleados.codigo_empleado);
        if not found then
            insert into pla_empleados(compania, codigo_empleado, apellido, nombre, cargo,
                departamento, id_pla_proyectos, tipo_de_planilla, grupo, dependientes,
                dependientes_no_declarados, tipo_contrato, estado_civil, fecha_inicio,
                fecha_terminacion_contrato, fecha_terminacion_real,
                fecha_nacimiento, tipo_de_salario, forma_de_pago, tipo_calculo_ir,
                telefono_1, telefono_2, status, sexo, tipo, cedula, dv, declarante,
                ss, direccion1, direccion2, tasa_por_hora, salario_brupo);
            values
                (ai_compania, r_tmp_empleados.codigo_empleado_new,
                r_tmp_empleados.apellido, r_tmp_empleados.nombre, r_pla_cargos.id,
                r_pla_departamentos.departamento, r_pla_proyectos.id,
                ''2'', ''A'', 0, 0, ''P'', ''C'', ''2010-01-01'', null,
                null, ''1991-01-01'', ''F'', ''E'', ''R'', null, null, ''A'',
                r_tmp_empleados.sexo, ''1'', r_tmp_empleados.cedula,
                ''00'', ''N'', r_tmp_empleados.ss, null, null, r_tmp_empleados.tasa_x_hora,
                (r_tmp_empleados.tasa_x_hora*48*52/12));
        else
        
        end if;
    end loop;
    return 1;
end;
' language plpgsql;
*/


create function f_poner_cuentas_x_proyecto_mecstore() returns integer as '
declare
    ai_compania integer;
    r_pla_conceptos record;
    r_pla_cuentas record;
    r_pla_cuentas_x_proyecto record;
    r_pla_proyectos record;
    r_work record;
    ls_cuenta_salarios_por_pagar char(24);
    li_id int4;
begin
    ai_compania = 745;

    for r_pla_cuentas_x_proyecto in
        select * from pla_cuentas_x_proyecto
        where compania = ai_compania
        and id_pla_proyectos = 619
        order by concepto
    loop
        for r_pla_proyectos in 
            select * from pla_proyectos
            where compania = ai_compania
            and id not in (619, 10)
            order by id
        loop
            select into r_work * from pla_cuentas_x_proyecto
            where compania = ai_compania
            and id_pla_proyectos = r_pla_proyectos.id
            and concepto = r_pla_cuentas_x_proyecto.concepto;
            if not found then
                insert into pla_cuentas_x_proyecto(compania, id_pla_proyectos,
                    concepto, id_pla_cuentas, id_pla_cuentas_2)
                values(ai_compania, r_pla_proyectos.id, r_pla_cuentas_x_proyecto.concepto,
                    r_pla_cuentas_x_proyecto.id_pla_cuentas, r_pla_cuentas_x_proyecto.id_pla_cuentas_2);
            else
                update pla_cuentas_x_proyecto
                set id_pla_cuentas = r_pla_cuentas_x_proyecto.id_pla_cuentas,
                    id_pla_cuentas_2 = r_pla_cuentas_x_proyecto.id_pla_cuentas_2
                where compania = ai_compania
                and id_pla_proyectos = r_pla_proyectos.id
                and concepto = r_pla_cuentas_x_proyecto.concepto;
            end if;            
        end loop;
    end loop;
    
    return 1;
end;
' language plpgsql;



create function f_diferenciar_cuentas_contables() returns integer as '
declare
    ai_compania integer;
    r_pla_conceptos record;
    r_pla_cuentas record;
    r_pla_cuentas_x_proyecto record;
    r_pla_cuentas_x_departamento record;
    r_pla_cuentas_x_concepto record;
    r_pla_proyectos record;
    ls_cuenta_salarios_por_pagar char(24);
    li_id int4;
begin
    for r_pla_cuentas_x_proyecto in
        select * from pla_cuentas_x_proyecto
        where id_pla_cuentas = id_pla_cuentas_2
        order by id
    loop    
        for r_pla_cuentas in
            select * from pla_cuentas
            where compania = r_pla_cuentas_x_proyecto.compania
            order by cuenta
        loop
            update pla_cuentas_x_proyecto
            set id_pla_cuentas_2 = r_pla_cuentas.id
            where id = r_pla_cuentas_x_proyecto.id;
            exit;
        end loop;
    end loop;



    for r_pla_cuentas_x_departamento in
        select * from pla_cuentas_x_departamento
        where id_pla_cuentas = id_pla_cuentas_2
        order by id
    loop    
        for r_pla_cuentas in
            select * from pla_cuentas
            where compania = r_pla_cuentas_x_departamento.compania
            order by cuenta
        loop
            update pla_cuentas_x_departamento
            set id_pla_cuentas_2 = r_pla_cuentas.id
            where id = r_pla_cuentas_x_departamento.id;
            exit;
        end loop;
    end loop;
    
    for r_pla_cuentas_x_concepto in
        select * from pla_cuentas_x_concepto
        where id_pla_cuentas = id_pla_cuentas_2
        order by id
    loop    
        for r_pla_cuentas in
            select * from pla_cuentas
            where compania = r_pla_cuentas_x_concepto.compania
            order by cuenta
        loop
            update pla_cuentas_x_concepto
            set id_pla_cuentas_2 = r_pla_cuentas.id
            where id = r_pla_cuentas_x_concepto.id;
            exit;
        end loop;
    end loop;
    
    return 1;
end;
' language plpgsql;



create function f_crear_cuentas_x_proyecto_mecstore() returns integer as '
declare
    ai_compania integer;
    r_pla_conceptos record;
    r_pla_cuentas record;
    r_pla_cuentas_x_proyecto record;
    r_pla_proyectos record;
    ls_cuenta_salarios_por_pagar char(24);
    li_id int4;
begin
    ai_compania = 745;
    ls_cuenta_salarios_por_pagar    = Trim(f_pla_parametros(ai_compania, ''cuenta_salarios_por_pagar'',''1'',''GET''));
    
    select into r_pla_cuentas *
    from pla_cuentas 
    where compania = ai_compania
    and trim(cuenta) = Trim(ls_cuenta_salarios_por_pagar);
    if not found then
        raise exception ''No existe cuenta de salarios por pagar'';
    end if;
    

    for r_pla_proyectos in
        select * from pla_proyectos
        where compania = ai_compania
        and proyecto <> ''03''
        order by proyecto
    loop    
        for r_pla_conceptos in
            select * from pla_conceptos
            order by concepto
        loop
            select into r_pla_cuentas_x_proyecto *
            from pla_cuentas_x_proyecto
            where compania = ai_compania
            and id_pla_proyectos = r_pla_proyectos.id
            and concepto = r_pla_conceptos.concepto;
            if not found then
                insert into pla_cuentas_x_proyecto(compania, id_pla_proyectos, concepto,
                    id_pla_cuentas, id_pla_cuentas_2)
                values(ai_compania, r_pla_proyectos.id, r_pla_conceptos.concepto,
                        r_pla_cuentas.id, r_pla_cuentas.id);
            end if;
        end loop;
    end loop;
    
    return 1;
end;
' language plpgsql;


create function f_insert_pla_empleados() returns integer as '
declare
    r_tmp_empleados record;
    r_pla_departamentos record;
    r_pla_cargos record;
    r_pla_proyectos record;
    r_pla_empleados record;
    lc_tipo_de_contrato char(1);
    lc_estado_civil char(1);
    lc_forma_de_pago char(1);
    lc_sexo char(1);
    lc_codigo_empleado char(7);
begin
    
    
    for r_tmp_empleados in
        select * from tmp_empleados
        order by codigo
        
    loop
        if r_tmp_empleados.codigo is null then
            continue;
        end if;
        
        lc_codigo_empleado = r_tmp_empleados.codigo;
        
        select into r_pla_cargos *
        from pla_cargos
        where compania = 893
        and Trim(cargo) = Trim(r_tmp_empleados.cargo);
        if not found then
            raise exception ''Cargo no Existe'';
        end if;
        
        select into r_pla_departamentos *
        from pla_departamentos
        where compania = 893
        and Trim(departamento) = Trim(r_tmp_empleados.departamento);
        
        select into r_pla_proyectos *
        from pla_proyectos
        where compania = 893
        and Trim(proyecto) = Trim(r_tmp_empleados.proyecto);
        
        
        
        if Trim(r_tmp_empleados.tipo_de_contrato) = ''Temporal'' then
            lc_tipo_de_contrato = ''T'';
        else
            lc_tipo_de_contrato = ''P'';
        end if;
        
        if Trim(r_tmp_empleados.estado_civil) = ''Soltero'' or
            Trim(r_tmp_empleados.estado_civil) = ''Soltera'' then
            lc_estado_civil = ''S'';
        else
            lc_estado_civil = ''C'';
        end if;
        
        if Trim(r_tmp_empleados.forma_pago) = ''Cheque'' then
            lc_forma_de_pago = ''C'';
        else
            lc_forma_de_pago = ''T'';
        end if;
        
        if r_tmp_empleados.fecha_nacimiento is null then
            r_tmp_empleados.fecha_nacimiento = ''1980-01-01'';
        end if;
        
        if r_tmp_empleados.fecha_ingreso is null then
            r_tmp_empleados.fecha_ingreso = ''2010-01-01'';
        end if;
        
        if r_tmp_empleados.nombre is null then
            r_tmp_empleados.nombre = ''PONER NOMBRE'';
        end if;
        
        if r_tmp_empleados.apellido is null then
            r_tmp_empleados.apellido = ''PONER APELLIDO'';
        end if;
        
        if r_tmp_empleados.codigo is null then
            r_tmp_empleados.codigo = f_secuencia_empleados(893, ''0'');
        end if;
        
        if Substring(Trim(r_tmp_empleados.sexo) from 1 for 1) = ''F'' then
            lc_sexo = ''F'';
        else
            lc_sexo = ''M'';
        end if;
        
        if r_tmp_empleados.cedula is null then
            r_tmp_empleados.cedula = ''xxx'';
        end if;
        
        select into r_pla_empleados *
        from pla_empleados
        where compania = 893
        and Trim(codigo_empleado) = Trim(lc_codigo_empleado);
        if not found then
            insert into pla_empleados(compania, codigo_empleado,
                tipo_de_planilla, grupo, dependientes, nombre, apellido,
                tipo_contrato, estado_civil, fecha_inicio, 
                fecha_nacimiento, tipo_de_salario, forma_de_pago, tipo_calculo_ir, status,
                sexo, cedula, dv, declarante, ss, direccion1, direccion2, tasa_por_hora, salario_bruto, email,
                cargo, departamento, id_pla_proyectos, telefono_1, telefono_2)
            values(893, r_tmp_empleados.codigo, ''2'', ''A'', 0,
                Trim(r_tmp_empleados.nombre), Trim(r_tmp_empleados.apellido),
                lc_tipo_de_contrato, lc_estado_civil, r_tmp_empleados.fecha_ingreso,
                r_tmp_empleados.fecha_nacimiento, ''F'', lc_forma_de_pago, ''R'', ''A'',
                lc_sexo,
                r_tmp_empleados.cedula, ''00'', ''1'', r_tmp_empleados.ss,
                Substring(Trim(r_tmp_empleados.direccion) from 1 for 50), null,
                r_tmp_empleados.salario_bruto * 12 / 52 / 48,
                r_tmp_empleados.salario_bruto / 2, '''', r_pla_cargos.id, r_pla_departamentos.id,
                r_pla_proyectos.id, r_tmp_empleados.telefono_1, r_tmp_empleados.telefono_2);
        else
            update pla_empleados
            set telefono_1 = r_tmp_empleados.telefono_1, telefono_2 = r_tmpl_empleados.telefono_2
            where compania = 893
            and Trim(codigo_empleado) = Trim(lc_codigo_empleado);
        end if;            
    end loop;            
    return 1;
end;
' language plpgsql;



create function f_tmp_departamentos() returns integer as '
declare
    r_tmp_departamentos record;
    r_tmp_empleados record;
    li_departamento integer;
    lc_departamento char(3);
begin
    
    li_departamento = 0;
    for r_tmp_departamentos in
        select * from tmp_departamentos
        order by codigo
    loop
        If Length(trim(r_tmp_departamentos.codigo)) > 3 then
            li_departamento = li_departamento + 1;
            lc_departamento = li_departamento;
            
            update tmp_departamentos
            set codigo = lc_departamento
            where codigo = r_tmp_departamentos.codigo;
            
            update tmp_empleados
            set departamento = lc_departamento
            where departamento = r_tmp_departamentos.codigo;
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;


create function f_fill_pla_cuentas_conceptos(int4) returns integer as '
declare
    ai_compania alias for $1;
    r_pla_conceptos record;
    r_pla_cuentas record;
    r_pla_cuentas_x_concepto record;
    ls_cuenta_salarios_por_pagar char(24);
    li_id int4;
begin
    ls_cuenta_salarios_por_pagar    = Trim(f_pla_parametros(ai_compania, ''cuenta_salarios_por_pagar'',''1'',''GET''));
    
    select into r_pla_cuentas *
    from pla_cuentas 
    where compania = ai_compania
    and trim(cuenta) = Trim(ls_cuenta_salarios_por_pagar);
    if not found then
        for r_pla_cuentas in
            select * from pla_cuentas
            where compania = ai_compania
            order by cuenta desc
        loop
            ls_cuenta_salarios_por_pagar = r_pla_cuentas.cuenta;
            exit;
        end loop;
    end if;
    
    for r_pla_conceptos in
        select * from pla_conceptos
        order by concepto
    loop
        select into r_pla_cuentas_x_concepto pla_cuentas_x_concepto.*
        from pla_cuentas, pla_cuentas_x_concepto
        where pla_cuentas.id = pla_cuentas_x_concepto.id_pla_cuentas
        and pla_cuentas.compania = ai_compania
        and pla_cuentas_x_concepto.concepto = r_pla_conceptos.concepto;
        if not found then
            insert into pla_cuentas_x_concepto (compania, concepto, id_pla_cuentas, id_pla_cuentas_2)
            values (ai_compania, r_pla_conceptos.concepto, r_pla_cuentas.id, r_pla_cuentas.id);        
        else
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;



create function f_copy_parametros_contables(int4, int4) returns integer as '
declare
    ai_cia_1 alias for $1;
    ai_cia_2 alias for $2;
    r_pla_cuentas record;
    r_pla_cuentas_2 record;
    r_pla_cuentas_conceptos record;
    r_work record;
    li_id_pla_cuentas int4;
    li_id_pla_cuentas_2 int4;
begin
    delete from pla_cuentas_conceptos
    using pla_cuentas
    where pla_cuentas.id = pla_cuentas_conceptos.id_pla_cuentas
    and pla_cuentas.compania = ai_cia_2;
    
    for r_pla_cuentas in
        select * from pla_cuentas
        where compania = ai_cia_1
        order by id
    loop
        select into r_pla_cuentas_2 *
        from pla_cuentas
        where compania = ai_cia_2
        and cuenta = r_pla_cuentas.cuenta;
        if not found then
            insert into pla_cuentas(cuenta, compania, nombre, nivel, naturaleza,
                tipo_cuenta, status, departamentos, acreedores, empleados, proyectos)
            values(r_pla_cuentas.cuenta, ai_cia_2, r_pla_cuentas.nombre, 
                r_pla_cuentas.nivel, r_pla_cuentas.naturaleza, r_pla_cuentas.tipo_cuenta,
                r_pla_cuentas.status, r_pla_cuentas.departamentos, r_pla_cuentas.acreedores,
                r_pla_cuentas.empleados, r_pla_cuentas.proyectos);
        end if;
    end loop;
    
    for r_pla_cuentas_conceptos in
        select pla_cuentas_conceptos.* from pla_cuentas_conceptos, pla_cuentas
        where pla_cuentas_conceptos.id_pla_cuentas = pla_cuentas.id
        and pla_cuentas.compania = ai_cia_1
        order by concepto
    loop
        select into r_pla_cuentas *
        from pla_cuentas
        where id = r_pla_cuentas_conceptos.id_pla_cuentas;
        
        select into r_pla_cuentas_2 *
        from pla_cuentas
        where id = r_pla_cuentas_conceptos.id_pla_cuentas_2;
        
        select into li_id_pla_cuentas id
        from pla_cuentas
        where compania = ai_cia_2
        and cuenta = r_pla_cuentas.cuenta;
        
        select into li_id_pla_cuentas_2 id
        from pla_cuentas
        where compania = ai_cia_2
        and cuenta = r_pla_cuentas_2.cuenta;
    
        select into r_work *
        from pla_cuentas_conceptos
        where concepto = r_pla_cuentas_conceptos.concepto
        and id_pla_cuentas = li_id_pla_cuentas;
        if not found then
            insert into pla_cuentas_conceptos (concepto, id_pla_cuentas, id_pla_cuentas_2)
            values(r_pla_cuentas_conceptos.concepto, li_id_pla_cuentas, li_id_pla_cuentas_2);
        end if;
    end loop;
    
    
    return 1;
end;
' language plpgsql;




create function f_poner_departamentos(int4) returns integer as '
declare
    ai_compania alias for $1;
    r_pla_departamentos record;
    r_pla_proyectos record;
    r_pla_cargos record;
    r_pla_empleados record;
    li_id int4;
begin
    for r_pla_departamentos in
        select * from pla_departamentos
        where compania = ai_compania
        order by id
    loop
        update pla_empleados
        set departamento = r_pla_departamentos.id
        where compania = ai_compania
        and departamento is null;
        exit;
    end loop;
    
    update pla_empleados
    set departamento = 4
    where compania = ai_compania
    and departamento is null;
    
    for r_pla_proyectos in
        select * from pla_proyectos
        where compania = ai_compania
        order by id
    loop
        update pla_empleados
        set id_pla_proyectos = r_pla_proyectos.id
        where compania = ai_compania
        and id_pla_proyectos is null;
        exit;
    end loop;
    
    select Min(id) into li_id
    from pla_proyectos;

    update pla_empleados
    set id_pla_proyectos = li_id
    where compania = ai_compania
    and id_pla_proyectos is null;
    
    
    for r_pla_cargos in
        select * from pla_cargos
        where compania = ai_compania
        order by id
    loop
        update pla_empleados
        set cargo = r_pla_cargos.id
        where compania = ai_compania
        and cargo is null;
        exit;
    end loop;
    
    select Min(id) into li_id
    from pla_cargos;

    update pla_empleados
    set cargo = li_id
    where compania = ai_compania
    and cargo is null;
    
    return 1;
end;
' language plpgsql;


create function f_pla_dinero_update_reservas(int4) returns integer as '
declare
    ai_compania alias for $1;
    r_pla_dinero record;
    r_pla_periodos record;
    r_pla_conceptos_acumulan record;
    r_pla_cuentas_conceptos record;
    r_pla_conceptos record;
    ldc_monto decimal(10,2);
    ldc_porcentaje_rp decimal(10,2);
begin
    for r_pla_dinero in
        select pla_dinero.* from pla_dinero, pla_periodos
        where pla_dinero.compania = ai_compania
        and pla_periodos.id = pla_dinero.id_periodos
        and pla_periodos.year >= 2011
        order by id
    loop
        select into r_pla_periodos * from pla_periodos
        where id = r_pla_dinero.id_periodos;
    
        delete from pla_reservas_pp
        where id_pla_dinero = r_pla_dinero.id;
        
    
        for r_pla_conceptos_acumulan 
            in select * from pla_conceptos_acumulan
                where concepto_aplica = r_pla_dinero.concepto
                order by concepto
        loop
            if r_pla_conceptos_acumulan.concepto = ''402'' then
                ldc_monto   =   r_pla_dinero.monto * 0.1175;
            elsif r_pla_conceptos_acumulan.concepto = ''403'' then
                ldc_monto   =   r_pla_dinero.monto * 0.1075;
            elsif r_pla_conceptos_acumulan.concepto = ''404'' then
                ldc_monto   =   r_pla_dinero.monto * 0.015;
            elsif r_pla_conceptos_acumulan.concepto = ''408'' then
                ldc_monto   =   r_pla_dinero.monto/11;
            elsif r_pla_conceptos_acumulan.concepto = ''409'' then
                ldc_monto   =   (r_pla_dinero.monto/12) + ((r_pla_dinero.monto/11)/12);
--                ldc_monto   =   (r_pla_dinero.monto/12);
            elsif r_pla_conceptos_acumulan.concepto = ''410'' then
                ldc_porcentaje_rp   =   f_pla_parametros(r_pla_dinero.compania, ''porcentaje_rp'', ''2.1'', ''GET'');
                ldc_monto           =   r_pla_dinero.monto * (ldc_porcentaje_rp/100);
            elsif r_pla_conceptos_acumulan.concepto = ''420'' then
                ldc_monto   =   (r_pla_dinero.monto/52) + ((r_pla_dinero.monto/11)/52);        
--                ldc_monto   =   (r_pla_dinero.monto/52);
            elsif r_pla_conceptos_acumulan.concepto = ''430'' then
                if Trim(f_pla_parametros(r_pla_dinero.compania, ''reserva_indemnizacion'', ''N'', ''GET'')) = ''N'' then
                    ldc_monto   =   0;
                else
                    ldc_monto   =   ((r_pla_dinero.monto/52)*3.4) + (((r_pla_dinero.monto/11)/52)*3.4);
                    ldc_monto   =   ldc_monto / 5;
--                    ldc_monto   =   ((r_pla_dinero.monto/52)*3.4);
                end if;
            else
                ldc_monto   =   0;
            end if;
        
            if f_pla_parametros(r_pla_dinero.compania, ''paga_exceso_9_horas_empleados_semanales'', ''S'', ''GET'') = ''N'' and
                r_pla_periodos.tipo_de_planilla = ''1'' then
                if r_pla_conceptos_acumulan.concepto = ''408'' or
                   r_pla_conceptos_acumulan.concepto = ''409'' or
                   r_pla_conceptos_acumulan.concepto = ''420'' or
                   r_pla_conceptos_acumulan.concepto = ''430'' then
                   ldc_monto = 0;
                end if;
            end if;
        
            select into r_pla_cuentas_conceptos pla_cuentas_conceptos.*
            from pla_cuentas_conceptos, pla_cuentas
            where pla_cuentas_conceptos.id_pla_cuentas = pla_cuentas.id
            and pla_cuentas.compania = r_pla_dinero.compania
            and pla_cuentas_conceptos.concepto = r_pla_conceptos_acumulan.concepto;
        
            if ldc_monto <> 0 then
                select into r_pla_conceptos * from pla_conceptos
                where concepto = r_pla_dinero.concepto;
        
                ldc_monto = ldc_monto * r_pla_conceptos.signo;
            
                insert into pla_reservas_pp(id_pla_dinero, id_pla_cuentas, concepto, monto)
                values(r_pla_dinero.id, r_pla_cuentas_conceptos.id_pla_cuentas, 
                    r_pla_conceptos_acumulan.concepto, ldc_monto);
            end if;
        end loop;

    end loop;
    
    return 1;
end;
' language plpgsql;


create function f_restaura_marcaciones(int4, char(2), int4, int4) returns integer as '
declare
    ai_cia alias for $1;
    as_tipo_de_planilla alias for $2;
    ai_year alias for $3;
    ai_numero_planilla alias for $4;
    r_pla_periodos record;
    r_pla_tarjeta_tiempo_tmp record;
    r_pla_tarjeta_tiempo record;
    r_pla_marcaciones record;
    r_pla_marcaciones_tmp record;
    r_pla_horas record;
    r_pla_horas_tmp record;
    li_id_pla_marcaciones int4;
begin
    select into r_pla_periodos *
    from pla_periodos
    where compania = ai_cia
    and tipo_de_planilla = as_tipo_de_planilla
    and year = ai_year
    and numero_planilla = ai_numero_planilla;
    if not found then
        raise exception ''no existe periodo'';
    end if;
    
    for r_pla_tarjeta_tiempo_tmp
        in select pla_tarjeta_tiempo_tmp.* from pla_tarjeta_tiempo_tmp, pla_empleados
            where pla_tarjeta_tiempo_tmp.compania = pla_empleados.compania
            and pla_tarjeta_tiempo_tmp.codigo_empleado = pla_empleados.codigo_empleado
            and id_periodos = r_pla_periodos.id
            order by pla_tarjeta_tiempo_tmp.id
    loop    
        select into r_pla_tarjeta_tiempo *
        from pla_tarjeta_tiempo
        where compania = r_pla_tarjeta_tiempo_tmp.compania
        and codigo_empleado = r_pla_tarjeta_tiempo_tmp.codigo_empleado
        and id_periodos = r_pla_tarjeta_tiempo_tmp.id_periodos;
        if not found then
            insert into pla_tarjeta_tiempo(compania, codigo_empleado, id_periodos)
            values(r_pla_tarjeta_tiempo_tmp.compania, r_pla_tarjeta_tiempo_tmp.codigo_empleado,
                r_pla_tarjeta_tiempo_tmp.id_periodos);
                
            select into r_pla_tarjeta_tiempo *
            from pla_tarjeta_tiempo
            where compania = r_pla_tarjeta_tiempo_tmp.compania
            and codigo_empleado = r_pla_tarjeta_tiempo_tmp.codigo_empleado
            and id_periodos = r_pla_tarjeta_tiempo_tmp.id_periodos;
        end if;
        
        for r_pla_marcaciones_tmp in
            select pla_marcaciones_tmp.*
            from pla_marcaciones_tmp
            where pla_marcaciones_tmp.id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo_tmp.id
            order by pla_marcaciones_tmp.id
        loop
            select into r_pla_marcaciones *
            from pla_marcaciones
            where id_tarjeta_de_tiempo = r_pla_tarjeta_tiempo.id
            and compania = r_pla_tarjeta_tiempo.compania
            and entrada = r_pla_marcaciones_tmp.entrada;
            if found then
                continue;
            end if;
            
            insert into pla_marcaciones(id_tarjeta_de_tiempo, id_pla_proyectos,
                compania, turno, entrada, salida, entrada_descanso, salida_descanso,
                status)
            values(r_pla_tarjeta_tiempo.id, r_pla_marcaciones_tmp.id_pla_proyectos,
                r_pla_marcaciones_tmp.compania, r_pla_marcaciones_tmp.turno,
                r_pla_marcaciones_tmp.entrada, r_pla_marcaciones_tmp.salida,
                r_pla_marcaciones_tmp.entrada_descanso, r_pla_marcaciones_tmp.salida_descanso,
                r_pla_marcaciones_tmp.status);
            
            li_id_pla_marcaciones = LastVal();
            
            for r_pla_horas_tmp in
                select pla_horas_tmp.* from pla_horas_tmp
                where id_marcaciones = r_pla_marcaciones_tmp.id
                order by id
            loop
                insert into pla_horas(id_marcaciones, tipo_de_hora, minutos,
                    tasa_por_minuto, aplicar, acumula, forma_de_registro)
                values(li_id_pla_marcaciones, r_pla_horas_tmp.tipo_de_hora,
                    r_pla_horas_tmp.minutos, r_pla_horas_tmp.tasa_por_minuto,
                    r_pla_horas_tmp.aplicar, r_pla_horas_tmp.acumula,
                    r_pla_horas_tmp.forma_de_registro);
            end loop;
        end loop;
    end loop;
    
    return 1;
end;
' language plpgsql;


create function f_poner_proyecto_en_pla_dinero(int4, char(2), char(2), int4, int4) returns integer as '
declare
    ai_cia alias for $1;
    as_tipo_de_calculo alias for $2;
    as_tipo_de_planilla alias for $3;
    ai_year alias for $4;
    ai_numero_planilla alias for $5;
    r_pla_tipos_de_planilla record;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_dinero record;
    li_id_pla_proyectos int4;
    i integer;
    lb_sw boolean;
begin

    for r_pla_dinero in select pla_dinero.* from pla_dinero, pla_periodos
                            where pla_dinero.id_periodos = pla_periodos.id
                            and pla_dinero.id_pla_proyectos is null
                            and pla_dinero.compania = ai_cia
                            and pla_dinero.tipo_de_calculo = trim(as_tipo_de_calculo)
                            and pla_periodos.tipo_de_planilla = trim(as_tipo_de_planilla)
                            and pla_periodos.year = ai_year
                            and pla_periodos.numero_planilla = ai_numero_planilla
                            order by pla_dinero.id
    loop
        lb_sw = false;
        for li_id_pla_proyectos in select pla_marcaciones.id_pla_proyectos 
                                    from pla_marcaciones, pla_tarjeta_tiempo
                                    where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
                                    and pla_tarjeta_tiempo.id_periodos = r_pla_dinero.id_periodos
                                    and pla_tarjeta_tiempo.compania = r_pla_dinero.compania
                                    and pla_tarjeta_tiempo.codigo_empleado = r_pla_dinero.codigo_empleado
                                    and pla_marcaciones.id_pla_proyectos is not null
        loop
            lb_sw = true;
            exit;
        end loop;
    
        if lb_sw then
            update pla_dinero
            set id_pla_proyectos = li_id_pla_proyectos
            where id = r_pla_dinero.id;
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;
