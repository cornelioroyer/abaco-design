
set search_path to 'planilla';

drop function f_relative_dmy(char(20), date, int4) cascade;
drop function f_isleapyear(integer) cascade;
drop function f_days_in_month(integer) cascade;
drop function f_to_date(integer, integer, integer) cascade;

drop function f_timestamp(date, time) cascade;
drop function f_intervalo(timestamp, timestamp) cascade;
drop function f_acumulado_para(int4, char(7), char(3), int4) cascade;
drop function f_concepto_pagado(int4, char(7), char(3), int4) cascade;
drop function f_acumulado_para(int4, char(7), char(3), date, date) cascade;
drop function f_pla_dinero_insert(int4, int4, char(7), char(2), char(3), char(60), integer, decimal);
drop function f_valida_fecha(int4, date) cascade;
drop function f_ultimo_dia_del_mes(date) cascade;
drop function anio(date) cascade;
drop function mes(date) cascade;
drop function f_concat_fecha_hora(date, time) cascade;
drop function f_pla_nombre_auxiliar(int4) cascade;
drop function f_mes(int4) cascade;
drop function f_sysmeca(int4, char(7), char(3), date, date) cascade;
drop function f_tipo_de_jornada(timestamp, timestamp) cascade;
drop function f_pla_parametros(int4, varchar(50), varchar(50),char(10)) cascade;
drop function f_secuencia_empleados(int4, char(7)) cascade;
drop function f_valida_fecha(int4, date, char(2)) cascade;
drop function f_interval_to_horas(interval) cascade;
drop function f_pla_dinero_insert(int4, int4, char(7), char(2), int4, int4, char(3), char(60), integer, decimal) cascade;
drop function f_valida_fecha(int4, char(2), date) cascade;
drop function f_pla_descanso_entre_turno(int4) cascade;
drop function f_acumulado(int4, char(7), char(3), int4) cascade;
drop function f_turno_asignado(int4, char(7), date) cascade;
drop function f_saldo_pla_retenciones(int4) cascade;
drop function f_saldo_pla_retenciones(int4, char(7), int4) cascade;
drop function f_pla_dinero_pla_reservas_pp(int4) cascade;
drop function f_ausencias(int4, char(7), int4) cascade;
drop function f_to_date(timestamp) cascade;
drop function f_turno_asignado_para_reloj(int4, char(7), date) cascade;
drop function f_acumulado_para_03(int4, char(7), char(3), int4) cascade;
drop function f_primer_dia_del_mes(date) cascade;
drop function f_pla_reserva_ss_se_pdp(int4) cascade;
drop function f_string_to_integer(varchar(100)) cascade;
drop function f_pla_reclamos_pla_dinero(int4, char(6), char(2), int4, int4) cascade;
drop function f_acumulado_para_comprobante(int4, char(7), char(3), date) cascade;
-- drop function f_caja_default(char(2)) cascade;
drop function f_relative_mes(date, integer);
drop function f_bitacora(text, text, integer, text, text, text) cascade;
drop function f_extract_time(timestamp with time zone) cascade;
drop function f_saldo_pla_retenciones(int4, date) cascade;
drop function f_bitacora(text, text, integer, text, text, text, int4, varchar(50)) cascade;
drop function f_pla_turnos_x_dia(int4, char(7), int4, date, char(1), char(1), varchar(20), time, time) cascade;
drop function f_pla_marcaciones_movicell(int4, char(7), date, time, time) cascade;
drop function f_pla_marcaciones_horarios(int4) cascade;
drop function f_pla_periodo_actual(int4, char(2)) cascade;
drop function f_relative_minutes(time, integer) cascade;


create function f_relative_minutes(time, integer) returns time as '
declare
    at_time alias for $1;
    ai_minutes alias for $2;
    lt_time time;
begin
    return at_time + cast((ai_minutes || ''minutes'') as interval);
end;
' language plpgsql;


create function f_pla_periodo_actual(int4, char(2)) returns int4 as '
declare
    ai_cia alias for $1;
    ac_tipo_de_planilla alias for $2;
    r_pla_tipos_de_planilla record;
    r_pla_periodos record;
    i integer;
begin

    select into r_pla_tipos_de_planilla * 
    from pla_tipos_de_planilla
    where compania = ai_cia
    and tipo_de_planilla = ac_tipo_de_planilla;
    if not found then
        Raise exception ''Tipo de planilla % no Existe'', ac_tipo_de_planilla;
    end if;        
    
    select into r_pla_periodos * 
    from pla_periodos
    where compania = ai_cia
    and tipo_de_planilla = r_pla_tipos_de_planilla.tipo_de_planilla
    and numero_planilla = r_pla_tipos_de_planilla.planilla_actual
    and status = ''A'';
    if not found then
        Raise Exception ''Tipo de Planilla % Numero de Planilla % no esta abierto'', ac_tipo_de_planilla, r_pla_tipos_de_planilla.planilla_actual;
    end if;
    
    return r_pla_periodos.id;
end;
' language plpgsql;



create function f_pla_marcaciones_horarios(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_companias record;
    r_hr_company record;
    r_pla_departamentos record;
    r_pla_empleados record;
    r_pla_marcaciones record;
    r_pp_horarios record;
    r_pla_tarjeta_tiempo record;
    r_pla_periodos record;
    r_pp_usuario record;
    i integer;
begin
    select into r_pla_marcaciones *
    from pla_marcaciones
    where id = ai_id;
    if not found then
        return 0;
    end if;

    select into r_pp_horarios *
    from pp_horarios
    where pla_marcaciones_id = ai_id;
    if found then
        return 0;
    end if;        
    
    select into r_pla_tarjeta_tiempo *
    from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    
    select into r_pla_periodos *
    from pla_periodos
    where id = r_pla_tarjeta_tiempo.id_periodos;
            
    select into r_pp_usuario *
    from pp_usuario
    where trim(usuario) = ''cornelio'';            

    insert into pp_horarios(compania, codigo_empleado, turno, numero_planilla,
        fecha, status, autorizado, entrada1, descanso_inicio, descanso_fin,
        salida1, pla_proyectos_id, pla_periodos_id, pla_marcaciones_id, pp_usuario_id)
    values(r_pla_tarjeta_tiempo.compania, r_pla_tarjeta_tiempo.codigo_empleado,
        r_pla_marcaciones.turno, r_pla_periodos.numero_planilla,
        f_to_date(r_pla_marcaciones.entrada), r_pla_marcaciones.status,
        r_pla_marcaciones.autorizado, 
        f_extract_time(r_pla_marcaciones.entrada), f_extract_time(r_pla_marcaciones.entrada_descanso),
        f_extract_time(r_pla_marcaciones.salida_descanso), f_extract_time(r_pla_marcaciones.salida),
        r_pla_marcaciones.id_pla_proyectos, r_pla_periodos.id, r_pla_marcaciones.id, r_pp_usuario.id);
    
    
    return 1;
end;
' language plpgsql;




create function f_pla_marcaciones_movicell(int4, char(7), date, time, time) returns integer as '
declare
    ai_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ad_fecha alias for $3;
    at_entrada alias for $4;
    at_salida alias for $5;
    r_pla_empleados record;
    r_pla_marcaciones_movicell record;
    li_compania int4;
begin

    li_compania = ai_compania;
   
    if li_compania is null then
        li_compania = 1316;
    end if;

    

    select into r_pla_empleados *
    from pla_empleados
    where compania = li_compania
    and trim(codigo_empleado) = trim(ac_codigo_empleado);
    if not found then
        return 0;
    end if;
    
    select into r_pla_marcaciones_movicell *
    from pla_marcaciones_movicell
    where compania = li_compania
    and trim(codigo_empleado) = trim(ac_codigo_empleado)
    and fecha = ad_fecha
    and entrada = at_entrada
    and salida = at_salida;
    if not found then
        insert into pla_marcaciones_movicell(compania, codigo_empleado, fecha, entrada, salida)
        values(li_compania, trim(ac_codigo_empleado), ad_fecha, at_entrada, at_salida);
    else
        return 0;        
    end if;    
    
    return 1;
end;
' language plpgsql;




create function f_pla_turnos_x_dia(int4, char(7), int4, date, char(1), char(1), varchar(20), time, time) returns int4 as '
declare
    ai_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ai_turno alias for $3;
    ad_fecha alias for $4;
    ac_status alias for $5;
    ac_autorizado alias for $6;
    avc_proyecto alias for $7;
    at_entrada alias for $8;
    at_salida alias for $9;
    r_pla_turnos_x_dia record;
    r_pla_empleados record;
    r_pla_turnos record;
    r_pla_proyectos record;
    r_pla_horarios record;
    li_retorno int4;
    li_turno int4;
    li_dow integer;
    lt_entrada time;
    lt_salida time;
    lc_status char(1);
begin
    li_turno    =   ai_turno;
    lt_entrada  =   at_entrada;
    lt_salida   =   at_salida;
    li_dow      =   Extract(dow from ad_fecha);
    lc_status   =   ac_status;
    
    if lc_status is null then
        lc_status = ''R'';
    end if;
    
    if lt_entrada > lt_salida then
        lt_salida   =   lt_salida + interval ''12 hours'';
    end if;
    
    select into r_pla_empleados *
    from pla_empleados
    where compania = ai_compania
    and codigo_empleado = ac_codigo_empleado;
    if not found then
        Raise Exception ''Codigo de Empleado % no existe'',ac_codigo_empleado;
    end if;


    if li_turno is null or li_turno = 0 then
        select into r_pla_horarios *
        from pla_horarios
        where compania = ai_compania
        and codigo_empleado = ac_codigo_empleado
        and dia = li_dow;
        if not found then
            select Min(turno) into li_turno
            from pla_turnos
            where compania = ai_compania;
        else
            li_turno    =   r_pla_horarios.turno;            
        end if;
    end if;        


    select into r_pla_turnos *
    from pla_turnos
    where compania = ai_compania
    and turno = li_turno;
    if not found then
        Raise Exception ''Codigo de Turno % no existe'', ai_turno;
    end if;


    select into r_pla_proyectos *
    from pla_proyectos
    where compania = ai_compania
    and trim(proyecto) = trim(avc_proyecto);
    if not found then
        select into r_pla_proyectos *
        from pla_proyectos
        where compania = ai_compania
        and id = r_pla_empleados.id_pla_proyectos;
    end if;


    
    select into r_pla_turnos_x_dia *
    from pla_turnos_x_dia
    where compania = ai_compania
    and codigo_empleado = ac_codigo_empleado
    and fecha = ad_fecha;
    if not found then
        insert into pla_turnos_x_dia(compania, codigo_empleado, turno, fecha, status, autorizado, id_pla_proyectos, entrada, salida)
        values (ai_compania, ac_codigo_empleado, li_turno, ad_fecha, lc_status, ac_autorizado, r_pla_proyectos.id, lt_entrada, lt_salida);
    else
--        insert into pla_turnos_x_dia(compania, codigo_empleado, turno, fecha, status, autorizado, id_pla_proyectos, entrada, salida)
--        values (ai_compania, ac_codigo_empleado, li_turno, ad_fecha, ac_status, ac_autorizado, r_pla_proyectos.id, lt_entrada, lt_salida);
        return 0;
    end if; 
    
    return 1;
end;
' language plpgsql;



create function f_bitacora(text, text, integer, text, text, text, int4, varchar(50)) returns integer as '
declare
    ac_operacion alias for $1;
    at_tabla alias for $2;
    ai_id_tabla alias for $3;
    at_old_dato alias for $4;
    at_new_dato alias for $5;
    at_sentencia_sql alias for $6;
    ai_compania alias for $7;
    avc_usuario alias for $8;
begin
    
    if trim(ac_operacion) = ''UPDATE''
        and trim(at_old_dato) = trim(at_new_dato) then
        return 1;
    end if;
    
    
    
    insert into bitacora(operacion, tabla, id_tabla, fecha_hora,
         old_dato, new_dato, sentencia_sql, compania, usuario)
    values (trim(ac_operacion), trim(at_tabla), ai_id_tabla, current_timestamp,
         at_old_dato, at_new_dato, at_sentencia_sql, ai_compania, trim(avc_usuario));

    return 1;
end;
' language plpgsql;


create function f_saldo_pla_retenciones(int4, date) returns decimal as '
declare
    ai_id alias for $1;
    ad_fecha alias for $2;
    r_pla_retenciones record;
    r_pla_deducciones record;
    r_pla_empleados record;
    ldc_saldo decimal;
    ldc_pagos decimal;
begin
    ldc_saldo = 0;

    select into r_pla_retenciones * 
    from pla_retenciones
    where id = ai_id;
    if not found then
        return 0;
    end if;

    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_retenciones.compania
    and codigo_empleado = r_pla_retenciones.codigo_empleado;
    if not found then
        return 0;
    end if;
    
    if r_pla_retenciones.hacer_cheque = ''S'' 
        or r_pla_retenciones.monto_original_deuda <= 0 then
        return 0;
    end if;
    
    if r_pla_retenciones.status <> ''A'' then
        return 0;
    end if;

    ldc_pagos = 0;
    select into ldc_pagos sum(pla_dinero.monto) 
    from pla_dinero, pla_deducciones, pla_periodos, pla_retenciones
    where pla_dinero.id = pla_deducciones.id_pla_dinero
    and pla_dinero.id_periodos = pla_periodos.id
    and pla_deducciones.id_pla_retenciones = r_pla_retenciones.id
    and pla_retenciones.id = ai_id
    and pla_periodos.dia_d_pago <= ad_fecha;
    
    if ldc_pagos is null then
        ldc_pagos = 0;
    end if;
    
    ldc_saldo = r_pla_retenciones.monto_original_deuda - ldc_pagos;
    
    return Round(ldc_saldo,2);
end;
' language plpgsql;



create function f_extract_time(timestamp with time zone ) returns time as '
declare
    ats_fecha alias for $1;
    lc_hora char(5);
    lt_hora time;
begin
    lc_hora =   to_char(ats_fecha, ''HH24:MI'');
    lt_hora =   lc_hora;
    return lt_hora;
end;
' language plpgsql;



create function f_bitacora(text, text, integer, text, text, text) returns integer as '
declare
    ac_operacion alias for $1;
    at_tabla alias for $2;
    ai_id_tabla alias for $3;
    at_old_dato alias for $4;
    at_new_dato alias for $5;
    at_sentencia_sql alias for $6;
begin
    
    insert into bitacora(operacion, tabla, id_tabla, fecha_hora,
        usuario, old_dato, new_dato, sentencia_sql) 
    values (trim(ac_operacion), trim(at_tabla), ai_id_tabla, current_timestamp,
        current_user, at_old_dato, at_new_dato, at_sentencia_sql);

    return 1;
end;
' language plpgsql;


create function f_relative_mes(date, integer) returns date as '
declare
    ad_fecha alias for $1;
    ai_meses alias for $2;
    ld_retorno date;
    li_work int4;
    li_temp_month int4;
    li_adjust_months int4;
    li_adjust_years int4;
    li_year int4;
    li_month int4;
    li_day int4;
    ls_sql varchar(300);
begin
    ld_retorno = ad_fecha;

    if ai_meses = 0 then
        return ad_fecha;
    end if;

    if ai_meses > 0 then
        li_adjust_months = mod(ai_meses, 12);
        li_adjust_years = (ai_meses / 12);
        li_temp_month = Mes(ad_fecha) + li_adjust_months;
    
        If li_temp_month > 12 Then
        	li_month = li_temp_month - 12;
        	li_adjust_years = li_adjust_years + 1;
        elsif li_temp_month <= 0 Then
        	li_month = li_temp_month + 12;
        	li_adjust_years = li_adjust_years + 1;
        Else
        	li_month = li_temp_month;
        End If;
        li_year = Anio(ad_fecha) + li_adjust_years;
        li_day = extract (day from ad_fecha);


        If li_day > f_days_in_month(li_month) Then
        	If li_month = 2 and f_isleapyear(li_year) Then
        		li_day = 29;
        	Else
        		li_day = f_days_in_month(li_month);
        	end If;
        End IF;
    
        ld_retorno = f_to_date(li_year,li_month,li_day);
    else
        li_adjust_months = mod(ai_meses, 12);
        li_adjust_years = (ai_meses / 12);
        li_temp_month = Mes(ad_fecha) + li_adjust_months;
    
        If li_temp_month > 12 Then
        	li_month = li_temp_month - 12;
        	li_adjust_years = li_adjust_years + 1;
        elsif li_temp_month <= 0 Then
            if ai_meses <= -12 then
            	li_month = li_temp_month + 12;
            	li_adjust_years = li_adjust_years + 1;
            else
            	li_month = li_temp_month + 12;
                li_adjust_years = -1;
            end if;
        Else
        	li_month = li_temp_month;
        End If;
        li_year = Anio(ad_fecha) + li_adjust_years;
        li_day = extract (day from ad_fecha);

        If li_day > f_days_in_month(li_month) Then
        	If li_month = 2 and f_isleapyear(li_year) Then
        		li_day = 29;
        	Else
        		li_day = f_days_in_month(li_month);
        	end If;
        End IF;
    
        ld_retorno = f_to_date(li_year,li_month,li_day);
    end if;    
    
    return ld_retorno;
end;
' language plpgsql;


/*
create function f_caja_default(char(2))returns char(3) as '
declare
    as_almacen alias for $1;
    r_fac_cajas record;
begin
    for r_fac_cajas in select * from fac_cajas where almacen = as_almacen
                        order by caja
    loop
        return r_fac_cajas.caja;
    end loop;
    
    return '''';
end;
' language plpgsql;    
*/


create function f_acumulado_para_comprobante(int4, char(7), char(3), date) returns decimal as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    as_concepto alias for $3;
    ad_hasta alias for $4;
    ldc_acum decimal;
    r_pla_empleados record;
    ld_desde date;
begin
    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    
    if trim(as_concepto) = ''108'' then
        ld_desde    =   f_fecha_desde_vacaciones(ai_cia, as_codigo_empleado, ad_hasta);
    else
        ld_desde    =   f_fecha_desde_xiii(ai_cia, as_codigo_empleado, ad_hasta);
    end if;
    
    ldc_acum    =   0;
    select into ldc_acum sum(monto) from v_pla_acumulados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and concepto_calcula = as_concepto
    and fecha >= ld_desde;
    if ldc_acum is null then
        return 0;
    end if;

    return ldc_acum;
end;
' language plpgsql;




create function f_pla_reclamos_pla_dinero(int4, char(6), char(2), int4, int4) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_de_planilla alias for $3;
    ai_year alias for $4;
    ai_numero_planilla alias for $5;
    r_pla_periodos record;
    r_pla_reclamos record;
    r_pla_dinero record;
    r_work record;
begin
    select into r_pla_periodos * from pla_periodos
    where compania = ai_cia
    and tipo_de_planilla = as_tipo_de_planilla
    and year = ai_year
    and numero_planilla = ai_numero_planilla;
    if not found then
        raise exception ''Numero de planilla % no existe'',ai_numero_planilla;
    else
        if r_pla_periodos.status = ''C'' then
            raise exception ''Numero de planilla % esta cerrado'',ai_numero_planilla;
        end if;
    end if;
    
    for r_pla_dinero in
        select * from pla_dinero
        where compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and id_periodos = r_pla_periodos.id
        and tipo_de_calculo = ''5''
        and id_pla_cheques_1 is not null
    loop
        raise exception ''Este reclamo ya tiene cheque impreso...Verifique'';
    end loop;
    
    delete from pla_dinero
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and id_periodos = r_pla_periodos.id
    and tipo_de_calculo = ''5''
    and forma_de_registro = ''A'';
    
    for r_work in
        select pla_rela_horas_conceptos.concepto, trim(pla_reclamos.descripcion) as descripcion,
        sum(pla_reclamos.tasa_por_hora*pla_tipos_de_horas.recargo*pla_reclamos.horas) as monto
        from pla_reclamos, pla_empleados, pla_rela_horas_conceptos, pla_tipos_de_horas, pla_conceptos
        where pla_conceptos.concepto = pla_rela_horas_conceptos.concepto
        and pla_rela_horas_conceptos.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
        and pla_reclamos.compania = pla_empleados.compania
        and pla_reclamos.codigo_empleado = pla_empleados.codigo_empleado
        and pla_reclamos.tipo_de_hora = pla_rela_horas_conceptos.tipo_de_hora
        and pla_reclamos.compania = ai_cia
        and pla_reclamos.codigo_empleado = as_codigo_empleado
        and pla_reclamos.tipo_de_planilla = as_tipo_de_planilla
        and pla_reclamos.year = ai_year
        and pla_reclamos.numero_planilla = ai_numero_planilla
        group by 1, 2
        order by 1, 2
    loop
        select into r_pla_dinero *
        from pla_dinero
        where compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and tipo_de_calculo = ''5''
        and id_periodos = r_pla_periodos.id
        and concepto = r_work.concepto;
        if not found then
            insert into pla_dinero(id_periodos, compania, codigo_empleado, tipo_de_calculo,
                concepto, forma_de_registro, descripcion, mes, monto)
            values (r_pla_periodos.id, ai_cia, as_codigo_empleado, ''5'',
                r_work.concepto, ''A'', r_work.descripcion, Mes(r_pla_periodos.dia_d_pago),
                r_work.monto);
        end if;
    end loop;
    return 1;
end;
' language plpgsql;



create function f_string_to_integer(varchar(100)) returns integer as '
declare
    avc_numero alias for $1;
    li_largo integer;
    i integer;
    ldc_retorno decimal;
    ldc_decimales decimal;
    ldc_entero decimal;
    lc_work char(1);
    lvc_numero varchar(100);
    lvc_entero varchar(100);
    lvc_decimal varchar(100);
    ldc_work decimal;
    li_entero integer;
begin
    ldc_retorno =   0;
    li_largo    =   Length(trim(avc_numero));
    i           =   0;
    lvc_numero  =   null;
    li_entero   =   1;
    
    for i in 1..li_largo loop
        lc_work =   Substring(trim(avc_numero) from i for 1);
        
        if lc_work = ''0'' or lc_work = ''1'' or lc_work = ''2'' or lc_work = ''3''
            or lc_work = ''4'' or lc_work = ''5'' or lc_work = ''6'' or lc_work = ''7''
            or lc_work = ''8'' or lc_work = ''9'' then
            
            if lvc_entero is null then
                lvc_entero  =   lc_work;
            else
                lvc_entero  =   trim(lvc_entero) || lc_work;
            end if;
        end if;
    end loop;

    li_entero        =   to_number(lvc_entero, ''9999999999999'');

    return li_entero;
end;
' language plpgsql;


create function f_pla_reserva_ss_se_pdp(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_dinero record;
    r_pla_periodos record;
    r_pla_conceptos_acumulan record;
    r_pla_cuentas_conceptos record;
    r_pla_conceptos record;
    r_pla_empleados record;
    ldc_monto decimal(14,4);
    ldc_porcentaje_rp decimal(10,2);
    ldc_porcentaje_indemnizacion decimal(12,4);
    ldc_salario decimal;
    ldc_prima_produccion decimal;
    ldc_ss decimal;
    ldc_work decimal;
    lc_reserva_gto_representacion char(1);
    i integer;
begin    
    select into r_pla_dinero *
    from pla_dinero
    where id = ai_id;
    if not found then
        return 0;
    end if;
    
-- 402  seguro social patronal = 12.25
-- 404  seguro educativo patronal = 1.5
-- 410  riesgos profesionales
-- 81 Prima de Produccion

    
    select into r_pla_conceptos *
    from pla_conceptos
    where concepto = r_pla_dinero.concepto;
    if not found then
        return 0;
    end if;

    select into r_pla_empleados *
    from pla_empleados
    where compania = r_pla_dinero.compania
    and codigo_empleado = r_pla_dinero.codigo_empleado;
    if not found then
        return 0;
    else
        if r_pla_empleados.retiene_ss = ''N'' then
            return 0;
        end if;
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where id = r_pla_dinero.id_periodos;
    
    ldc_prima_produccion = 0;
    select into ldc_prima_produccion sum(pla_dinero.monto*pla_conceptos.signo)
    from pla_dinero, pla_conceptos, pla_periodos
    where pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.id_periodos = pla_periodos.id
    and pla_dinero.compania = r_pla_dinero.compania
    and pla_dinero.codigo_empleado = r_pla_dinero.codigo_empleado
    and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
    and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
    and pla_periodos.dia_d_pago <= r_pla_periodos.dia_d_pago
    and pla_dinero.concepto = ''81'';
    if ldc_prima_produccion is null then
        ldc_prima_produccion = 0;
    end if;
    
    if ldc_prima_produccion = 0 then
        return 0;
    end if;    
    
    if Extract(Day from r_pla_periodos.dia_d_pago) <= 15 then
        ldc_salario = 0;
        select into ldc_salario sum(pla_dinero.monto*pla_conceptos.signo)
        from pla_dinero, pla_conceptos, pla_conceptos_acumulan, pla_periodos
        where pla_dinero.concepto = pla_conceptos.concepto
        and pla_dinero.id_periodos = pla_periodos.id
        and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
        and pla_dinero.compania = r_pla_dinero.compania
        and pla_dinero.codigo_empleado = r_pla_dinero.codigo_empleado
        and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
        and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
        and pla_periodos.dia_d_pago <= r_pla_periodos.dia_d_pago
        and pla_conceptos_acumulan.concepto = ''402'';
        if ldc_salario is null then
            ldc_salario = 0;
        end if;
        

        if ldc_prima_produccion > ldc_salario then
            ldc_work    =   ldc_prima_produccion - ldc_salario;
        else
            ldc_work    =   0;
        end if;

        ldc_ss    =   ldc_work * .1225;

        select into r_pla_cuentas_conceptos pla_cuentas_conceptos.*
        from pla_cuentas_conceptos, pla_cuentas
        where pla_cuentas_conceptos.id_pla_cuentas = pla_cuentas.id
        and pla_cuentas.compania = r_pla_dinero.compania
        and pla_cuentas_conceptos.concepto = ''402'';


        if ldc_ss <> 0 then
            insert into pla_reservas_pp(id_pla_dinero, id_pla_cuentas, concepto, monto)
            values(r_pla_dinero.id, r_pla_cuentas_conceptos.id_pla_cuentas, 
                ''402'', ldc_ss);
        end if;

        ldc_salario = 0;
        select into ldc_salario sum(pla_dinero.monto*pla_conceptos.signo)
        from pla_dinero, pla_conceptos, pla_conceptos_acumulan, pla_periodos
        where pla_dinero.concepto = pla_conceptos.concepto
        and pla_dinero.id_periodos = pla_periodos.id
        and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
        and pla_dinero.compania = r_pla_dinero.compania
        and pla_dinero.codigo_empleado = r_pla_dinero.codigo_empleado
        and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
        and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
        and pla_periodos.dia_d_pago <= r_pla_periodos.dia_d_pago
        and pla_conceptos_acumulan.concepto = ''404'';
        if ldc_salario is null then
            ldc_salario = 0;
        end if;

        if ldc_prima_produccion > ldc_salario then
            ldc_work    =   ldc_prima_produccion - ldc_salario;
        else
            ldc_work    =   0;
        end if;

        ldc_ss    =   ldc_work * .015;

        select into r_pla_cuentas_conceptos pla_cuentas_conceptos.*
        from pla_cuentas_conceptos, pla_cuentas
        where pla_cuentas_conceptos.id_pla_cuentas = pla_cuentas.id
        and pla_cuentas.compania = r_pla_dinero.compania
        and pla_cuentas_conceptos.concepto = ''404'';

        if ldc_ss <> 0 then
            insert into pla_reservas_pp(id_pla_dinero, id_pla_cuentas, concepto, monto)
            values(r_pla_dinero.id, r_pla_cuentas_conceptos.id_pla_cuentas, 
                ''404'', ldc_ss);
        end if;

    else
    
        ldc_salario = 0;
        select into ldc_salario sum(pla_dinero.monto*pla_conceptos.signo)
        from pla_dinero, pla_conceptos, pla_conceptos_acumulan, pla_periodos
        where pla_dinero.concepto = pla_conceptos.concepto
        and pla_dinero.id_periodos = pla_periodos.id
        and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
        and pla_dinero.compania = r_pla_dinero.compania
        and pla_dinero.codigo_empleado = r_pla_dinero.codigo_empleado
        and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
        and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
        and pla_conceptos_acumulan.concepto = ''402'';
        if ldc_salario is null then
            ldc_salario = 0;
        end if;

        ldc_prima_produccion = 0;
        select into ldc_prima_produccion sum(pla_dinero.monto*pla_conceptos.signo)
        from pla_dinero, pla_conceptos, pla_periodos
        where pla_dinero.concepto = pla_conceptos.concepto
        and pla_dinero.id_periodos = pla_periodos.id
        and pla_dinero.compania = r_pla_dinero.compania
        and pla_dinero.codigo_empleado = r_pla_dinero.codigo_empleado
        and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
        and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
        and pla_dinero.concepto = ''81'';
        if ldc_prima_produccion is null then
            ldc_prima_produccion = 0;
        end if;

        ldc_ss = 0;
        select into ldc_ss sum(pla_reservas_pp.monto)
        from pla_reservas_pp, pla_conceptos, pla_periodos, pla_dinero
        where pla_reservas_pp.concepto = pla_conceptos.concepto
        and pla_dinero.id = pla_reservas_pp.id_pla_dinero
        and pla_dinero.id_periodos = pla_periodos.id
        and pla_dinero.compania = r_pla_dinero.compania
        and pla_dinero.codigo_empleado = r_pla_dinero.codigo_empleado
        and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
        and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
        and pla_dinero.concepto = ''81''
        and pla_reservas_pp.concepto = ''402'';
        if ldc_ss is null then
            ldc_ss = 0;
        end if;

        ldc_work    =   (ldc_prima_produccion - (ldc_salario/2));
        
        ldc_work    =   ldc_work * .1225;


        ldc_ss      =   ldc_work - ldc_ss;


        select into r_pla_cuentas_conceptos pla_cuentas_conceptos.*
        from pla_cuentas_conceptos, pla_cuentas
        where pla_cuentas_conceptos.id_pla_cuentas = pla_cuentas.id
        and pla_cuentas.compania = r_pla_dinero.compania
        and pla_cuentas_conceptos.concepto = ''402'';

        if ldc_ss <> 0 then
            insert into pla_reservas_pp(id_pla_dinero, id_pla_cuentas, concepto, monto)
            values(r_pla_dinero.id, r_pla_cuentas_conceptos.id_pla_cuentas, 
                ''402'', ldc_ss);
        end if;
        

        ldc_salario = 0;
        select into ldc_salario sum(pla_dinero.monto*pla_conceptos.signo)
        from pla_dinero, pla_conceptos, pla_conceptos_acumulan, pla_periodos
        where pla_dinero.concepto = pla_conceptos.concepto
        and pla_dinero.id_periodos = pla_periodos.id
        and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
        and pla_dinero.compania = r_pla_dinero.compania
        and pla_dinero.codigo_empleado = r_pla_dinero.codigo_empleado
        and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
        and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
        and pla_conceptos_acumulan.concepto = ''404'';
        if ldc_salario is null then
            ldc_salario = 0;
        end if;

        ldc_prima_produccion = 0;
        select into ldc_prima_produccion sum(pla_dinero.monto*pla_conceptos.signo)
        from pla_dinero, pla_conceptos, pla_periodos
        where pla_dinero.concepto = pla_conceptos.concepto
        and pla_dinero.id_periodos = pla_periodos.id
        and pla_dinero.compania = r_pla_dinero.compania
        and pla_dinero.codigo_empleado = r_pla_dinero.codigo_empleado
        and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
        and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
        and pla_dinero.concepto = ''81'';
        if ldc_prima_produccion is null then
            ldc_prima_produccion = 0;
        end if;

        ldc_ss = 0;
        select into ldc_ss sum(pla_reservas_pp.monto)
        from pla_reservas_pp, pla_conceptos, pla_periodos, pla_dinero
        where pla_reservas_pp.concepto = pla_conceptos.concepto
        and pla_dinero.id = pla_reservas_pp.id_pla_dinero
        and pla_dinero.id_periodos = pla_periodos.id
        and pla_dinero.compania = r_pla_dinero.compania
        and pla_dinero.codigo_empleado = r_pla_dinero.codigo_empleado
        and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
        and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
        and pla_dinero.concepto = ''81''
        and pla_reservas_pp.concepto = ''404'';
        if ldc_ss is null then
            ldc_ss = 0;
        end if;

        ldc_work    =   (ldc_prima_produccion - (ldc_salario/2));
        
        ldc_work    =   ldc_work * .015;

        ldc_ss      =   ldc_work - ldc_ss;


        select into r_pla_cuentas_conceptos pla_cuentas_conceptos.*
        from pla_cuentas_conceptos, pla_cuentas
        where pla_cuentas_conceptos.id_pla_cuentas = pla_cuentas.id
        and pla_cuentas.compania = r_pla_dinero.compania
        and pla_cuentas_conceptos.concepto = ''402'';

        if ldc_ss <> 0 then
            insert into pla_reservas_pp(id_pla_dinero, id_pla_cuentas, concepto, monto)
            values(r_pla_dinero.id, r_pla_cuentas_conceptos.id_pla_cuentas, 
                ''404'', ldc_ss);
        end if;
    end if;
    return 1;
end;
' language plpgsql;




create function f_acumulado_para_03(int4, char(7), char(3), int4) returns decimal as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    as_concepto alias for $3;
    ai_anio alias for $4;
    ldc_acumulado_1 decimal;
    ldc_acumulado_2 decimal;
begin
    ldc_acumulado_1 = 0;
    ldc_acumulado_2 = 0;

    select into ldc_acumulado_1 sum(monto)
    from v_pla_acumulados_03
    where codigo_empleado = as_codigo_empleado
    and anio = ai_anio
    and compania = ai_cia
    and concepto_calcula = as_concepto;    


    if ldc_acumulado_1 is null then
        ldc_acumulado_1 = 0;
    end if;
    
    if ldc_acumulado_2 is null then
        ldc_acumulado_2 = 0;
    end if;
    
    return ldc_acumulado_1 + ldc_acumulado_2;
end;
' language plpgsql;



create function f_turno_asignado_para_reloj(int4, char(7), date) returns int4 as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ad_fecha alias for $3;
    r_pla_marcaciones record;
    li_turno int4;
begin
    for r_pla_marcaciones in
        select pla_marcaciones.* from pla_marcaciones, pla_tarjeta_tiempo
        where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
        and pla_tarjeta_tiempo.compania = ai_cia
        and pla_tarjeta_tiempo.codigo_empleado = as_codigo_empleado
        and ad_fecha between f_to_date(entrada) and f_to_date(salida)
        order by entrada desc
    loop
        li_turno    =   r_pla_marcaciones.turno;
    end loop;


    if li_turno is null then
        li_turno    =   f_turno_asignado(ai_cia, as_codigo_empleado, ad_fecha);
    end if;    
    
    return li_turno;
end;
' language plpgsql;




create function f_to_date(timestamp) returns date as '
declare
    ats_fecha alias for $1;
    li_anio int4;
    li_mes int4;
    li_dia int4;
begin
    li_anio =   Extract(year from ats_fecha);
    li_mes  =   Extract(month from ats_fecha);
    li_dia  =   Extract(day from ats_fecha);
    return f_to_date(li_anio, li_mes, li_dia);
end;
' language plpgsql;



create function f_ausencias(int4, char(7), int4) returns integer as '
declare
    ai_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_reloj_01 record;
    r_pla_tipos_de_planilla record;
    ld_hasta date;
begin

    select into r_pla_empleados *
    from pla_empleados
    where compania = ai_compania
    and trim(codigo_empleado) = trim(ac_codigo_empleado);
    if not found then
        return 0;
    end if;

    if ai_id_periodos is null then
        select into r_pla_tipos_de_planilla *
        from pla_tipos_de_planilla
        where compania = r_pla_empleados.compania
        and tipo_de_planilla = r_pla_empleados.tipo_de_planilla;
        if not found then
            return 0;
        end if;    

        select into r_pla_periodos *
        from pla_periodos
        where compania = r_pla_tipos_de_planilla.compania
        and tipo_de_planilla = r_pla_tipos_de_planilla.tipo_de_planilla
        and numero_planilla = r_pla_tipos_de_planilla.planilla_actual
        and status = ''A'';
        if not found then
            return 0;
        end if;
    else
        select into r_pla_periodos *
        from pla_periodos
        where id = ai_id_periodos;
        if not found then
            return 0;
        end if;
    end if;    
    
    if r_pla_periodos.dia_d_pago > r_pla_periodos.hasta then
        ld_hasta = r_pla_periodos.dia_d_pago;
    else
        ld_hasta = r_pla_periodos.hasta;
    end if;
    
    
    select into r_pla_reloj_01 *
    from pla_reloj_01
    where compania = ai_compania
    and trim(codigo_reloj) = trim(ac_codigo_empleado)
    and fecha between r_pla_periodos.desde and ld_hasta;
    if found then
        return 0;
    end if;
    
    update pla_marcaciones
    set status = ''I'' 
    from pla_tarjeta_tiempo
    where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
    and pla_tarjeta_tiempo.compania = ai_compania
    and trim(pla_tarjeta_tiempo.codigo_empleado) = trim(ac_codigo_empleado)
    and pla_tarjeta_tiempo.id_periodos = r_pla_periodos.id;
    
    return 1;
end;
' language plpgsql;



create function f_pla_dinero_pla_reservas_pp(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_dinero record;
    r_pla_periodos record;
    r_pla_conceptos_acumulan record;
    r_pla_cuentas_conceptos record;
    r_pla_conceptos record;
    r_pla_empleados record;
    ldc_monto decimal(14,4);
    ldc_porcentaje_rp decimal(10,2);
    ldc_porcentaje_indemnizacion decimal(12,4);
    lc_reserva_gto_representacion char(1);
    i integer;
begin
-- 402  seguro social patronal
-- 403  seguro social patronal xiii
-- 404  seguro educativo patronal
-- 408  vacaciones reserva
-- 409  xiii reserva
-- 410  riesgos profesionales
-- 420  prima de antiguead reserva
-- 430  indeminzacion reserav
-- 108  vacaciones empleado
-- 81 prima de produccion
-- 74 Gratificacion y Aguinaldo


    delete from pla_reservas_pp
    where id_pla_dinero = ai_id;
    
    select into r_pla_dinero *
    from pla_dinero
    where id = ai_id;
    if not found then
        return 0;
    else
        if trim(r_pla_dinero.concepto) = ''81'' then
            i = f_pla_reserva_ss_se_pdp(ai_id);
            
        elsif trim(r_pla_dinero.concepto) = ''74'' then

                select into r_pla_cuentas_conceptos pla_cuentas_conceptos.*
                from pla_cuentas_conceptos, pla_cuentas
                where pla_cuentas_conceptos.id_pla_cuentas = pla_cuentas.id
                and pla_cuentas.compania = r_pla_dinero.compania
                and pla_cuentas_conceptos.concepto = ''409'';

                ldc_monto = r_pla_dinero.monto / 11 / 12;
                insert into pla_reservas_pp(id_pla_dinero, id_pla_cuentas, 
                concepto, monto)
                values(r_pla_dinero.id, r_pla_cuentas_conceptos.id_pla_cuentas, 
                    ''409'', ldc_monto);
        
        end if;
    end if;

    
    select into r_pla_conceptos *
    from pla_conceptos
    where concepto = r_pla_dinero.concepto;
    if not found then
        return 0;
    end if;

    lc_reserva_gto_representacion = trim(f_pla_parametros(r_pla_dinero.compania, ''reserva_gto_representacion'', ''S'', ''GET''));
    
    r_pla_dinero.monto = r_pla_dinero.monto * r_pla_conceptos.signo;

        
    select into r_pla_empleados *
    from pla_empleados
    where compania = r_pla_dinero.compania
    and codigo_empleado = r_pla_dinero.codigo_empleado;
    if not found then
        return 0;
    else
        if r_pla_empleados.retiene_ss = ''N'' then
            return 0;
        end if;
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where id = r_pla_dinero.id_periodos;
    
    for r_pla_conceptos_acumulan 
        in select * from pla_conceptos_acumulan
            where concepto_aplica = r_pla_dinero.concepto
            order by concepto
    loop
        if r_pla_conceptos_acumulan.concepto = ''402'' then
            if r_pla_periodos.dia_d_pago >= ''2013-01-01'' then
                ldc_monto   =   r_pla_dinero.monto * .1225;
            else        
                ldc_monto   =   r_pla_dinero.monto * .12;
            end if;                
        elsif r_pla_conceptos_acumulan.concepto = ''403'' then
            ldc_monto   =   r_pla_dinero.monto * 0.1075;
        elsif r_pla_conceptos_acumulan.concepto = ''404'' then
            ldc_monto   =   r_pla_dinero.monto * 0.015;
        elsif r_pla_conceptos_acumulan.concepto = ''408'' then
            if trim(r_pla_dinero.concepto) = ''73'' and lc_reserva_gto_representacion = ''N'' then
                ldc_monto = 0;
            else
                ldc_monto   =   r_pla_dinero.monto/11;
            end if;

        elsif r_pla_conceptos_acumulan.concepto = ''409'' then
            if trim(r_pla_dinero.concepto) = ''73'' and lc_reserva_gto_representacion = ''N'' then
                ldc_monto = 0;
            else
                if r_pla_dinero.concepto = ''108'' then
                    ldc_monto   =   (r_pla_dinero.monto/12);
                else
                    ldc_monto   =   (r_pla_dinero.monto/12) + ((r_pla_dinero.monto/11)/12);
                end if;
                    
            end if;

        
        elsif trim(r_pla_conceptos_acumulan.concepto) = ''410'' then
            ldc_porcentaje_rp   =   f_pla_parametros(r_pla_dinero.compania, ''porcentaje_rp'', ''2.1'', ''GET'');
            ldc_monto           =   r_pla_dinero.monto * (ldc_porcentaje_rp/100);
            
        elsif r_pla_conceptos_acumulan.concepto = ''420'' then
            if trim(r_pla_dinero.concepto) = ''73'' and lc_reserva_gto_representacion = ''N'' then
                ldc_monto = 0;
            else
                if r_pla_empleados.tipo_contrato = ''P'' then
                    if r_pla_dinero.concepto = ''108'' then
                        ldc_monto   =   (r_pla_dinero.monto/52);
--                        ldc_monto   =   0;
                    else
                        ldc_monto   =   (r_pla_dinero.monto/52) + ((r_pla_dinero.monto/11)/52);
--                        ldc_monto   =   (r_pla_dinero.monto/52);
                    end if;
                else
                    ldc_monto   =   0;
                end if;
            end if;
            
        elsif r_pla_conceptos_acumulan.concepto = ''430'' then
            if trim(r_pla_dinero.concepto) = ''73'' and lc_reserva_gto_representacion = ''N'' then
                ldc_monto = 0;
            else
                if Trim(f_pla_parametros(r_pla_dinero.compania, ''reserva_indemnizacion'', ''N'', ''GET'')) = ''N'' then
                    ldc_monto   =   0;
                else
                    if r_pla_empleados.tipo_contrato = ''P'' then
                        if r_pla_dinero.concepto = ''108'' then
                            ldc_monto   =   ((r_pla_dinero.monto/52)*3.4);
                        else
                            ldc_monto   =   ((r_pla_dinero.monto/52)*3.4) + (((r_pla_dinero.monto/11)/52)*3.4);
                        end if;
                        ldc_porcentaje_indemnizacion   =   f_pla_parametros(r_pla_dinero.compania, ''porcentaje_indemnizacion'', ''0.20'', ''GET'');
                        ldc_monto                       =   ldc_monto * (ldc_porcentaje_indemnizacion/100);
                    else
                        ldc_monto = 0;
                    end if;                    
                end if;
            end if;
            
        else
            ldc_monto   =   0;
        end if;


        if r_pla_dinero.compania <> 745 then    
            if f_pla_parametros(r_pla_dinero.compania, ''paga_exceso_9_horas_empleados_semanales'', ''S'', ''GET'') = ''N'' and
                (r_pla_periodos.tipo_de_planilla = ''1'' or r_pla_periodos.tipo_de_planilla = ''3'') then
                if r_pla_conceptos_acumulan.concepto = ''408'' or
                   r_pla_conceptos_acumulan.concepto = ''409'' or
                   r_pla_conceptos_acumulan.concepto = ''420'' or
                   r_pla_conceptos_acumulan.concepto = ''430'' then
                   ldc_monto = 0;
                end if;
            end if;
        end if;
            
        select into r_pla_cuentas_conceptos pla_cuentas_conceptos.*
        from pla_cuentas_conceptos, pla_cuentas
        where pla_cuentas_conceptos.id_pla_cuentas = pla_cuentas.id
        and pla_cuentas.compania = r_pla_dinero.compania
        and pla_cuentas_conceptos.concepto = r_pla_conceptos_acumulan.concepto;

        if ldc_monto <> 0 then
            insert into pla_reservas_pp(id_pla_dinero, id_pla_cuentas, concepto, monto)
            values(r_pla_dinero.id, r_pla_cuentas_conceptos.id_pla_cuentas, 
                r_pla_conceptos_acumulan.concepto, ldc_monto);
        end if;
    end loop;

    return 1;
end;
' language plpgsql;




create function f_saldo_pla_retenciones(int4, char(7), int4) returns decimal as '
declare
    ai_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ai_id_pla_retenciones alias for $3;
    r_pla_retenciones record;
    r_pla_empleados record;
    ldc_saldo decimal;
    ldc_pagos decimal;
begin
    ldc_saldo = 0;
    
    select into r_pla_retenciones * from pla_retenciones
    where id = ai_id_pla_retenciones;
    if not found then
        return 0;
    end if;
    
    if r_pla_retenciones.compania <> ai_compania or
       r_pla_retenciones.codigo_empleado <> ac_codigo_empleado then
       return 0;
    end if;
    
        
    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_compania
    and codigo_empleado = ac_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    if r_pla_empleados.status = ''I'' or r_pla_empleados.status = ''E'' then
        return 0;
    end if;
    
    if r_pla_retenciones.hacer_cheque = ''S'' 
        or r_pla_retenciones.monto_original_deuda <= 0 then
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




create function f_saldo_pla_retenciones(int4) returns decimal as '
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
    
    if r_pla_retenciones.hacer_cheque = ''S'' 
        or r_pla_retenciones.monto_original_deuda <= 0 then
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



create function f_turno_asignado(int4, char(7), date) returns int4 as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ad_fecha alias for $3;
    ldc_acumulado_1 decimal;
    ldc_acumulado_2 decimal;
    r_pla_turnos_rotativos record;
    r_pla_horarios record;
begin
    for r_pla_turnos_rotativos in
        select * from pla_turnos_rotativos
        where compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and ad_fecha between desde and hasta
        order by desde desc
    loop
        return r_pla_turnos_rotativos.turno;
    end loop;
    
    select into r_pla_horarios *
    from pla_horarios
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and dia = extract(dow from ad_fecha);
    if not found then
        return 0;
    else
        return r_pla_horarios.turno;
    end if;
end;
' language plpgsql;




create function f_acumulado(int4, char(7), char(3), int4) returns decimal as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    as_concepto alias for $3;
    ai_anio alias for $4;
    ldc_acumulado_1 decimal;
    ldc_acumulado_2 decimal;
begin
    ldc_acumulado_1 = 0;
    ldc_acumulado_2 = 0;
    
    
    
    select into ldc_acumulado_1 sum(pla_dinero.monto*pla_conceptos.signo)
    from pla_dinero, pla_conceptos, pla_periodos
    where pla_periodos.id = pla_dinero.id_periodos
    and pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_periodos.year = ai_anio
    and pla_dinero.compania = ai_cia
    and pla_dinero.concepto = as_concepto;
    
    
    select into ldc_acumulado_2 sum(pla_preelaboradas.monto*pla_conceptos.signo)
    from pla_preelaboradas, pla_conceptos
    where pla_preelaboradas.concepto = pla_conceptos.concepto
    and pla_preelaboradas.concepto = as_concepto
    and pla_preelaboradas.codigo_empleado = as_codigo_empleado
    and Anio(pla_preelaboradas.fecha) = ai_anio
    and pla_preelaboradas.compania = ai_cia;


    if ldc_acumulado_1 is null then
        ldc_acumulado_1 = 0;
    end if;
    
    if ldc_acumulado_2 is null then
        ldc_acumulado_2 = 0;
    end if;
    
    return ldc_acumulado_1 + ldc_acumulado_2;
end;
' language plpgsql;



create function f_pla_descanso_entre_turno(int4) returns decimal as '
declare
    ai_id_pla_marcaciones alias for $1;
    r_pla_marcaciones record;
    r_pla_tarjeta_tiempo record;
    r_pla_marcaciones_2 record;
    ldc_minutos decimal;
begin
    select into r_pla_marcaciones * from pla_marcaciones
    where id = ai_id_pla_marcaciones;
    if not found then
        return 0;
    end if;
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    if not found then
        raise exception ''entre'';
        return 0;
    end if;
    
    for r_pla_marcaciones_2 in 
        select pla_marcaciones.*
        from pla_tarjeta_tiempo, pla_marcaciones
        where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
        and entrada < r_pla_marcaciones.entrada
        and pla_tarjeta_tiempo.codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
        and pla_tarjeta_tiempo.compania = r_pla_tarjeta_tiempo.compania
        and pla_marcaciones.id <> ai_id_pla_marcaciones
        order by pla_marcaciones.entrada desc
    loop
        ldc_minutos =   Cast(f_intervalo(r_pla_marcaciones_2.salida, r_pla_marcaciones.entrada) as decimal);
        if ldc_minutos <= 0 then
            return 9999999999.99;
        else
            return ldc_minutos / 60;
        end if;
    end loop;
    
    return 9999999999.99;
end;
' language plpgsql;


create function f_valida_fecha(int4, char(2), date) returns boolean as '
declare
    ai_cia alias for $1;
    as_tipo_de_planilla alias for $2;
    ad_fecha alias for $3;
    r_pla_periodos record;
    r_pla_companias record;
begin
    
    select into r_pla_companias * from pla_companias
    where compania = ai_cia;
    
    if current_date > r_pla_companias.fecha_de_expiracion then
        raise exception ''Esta compania expiro el % Llame al 66741218 para continuar utilizando el sistema'',r_pla_companias.fecha_de_expiracion;
    end if;


    select into r_pla_periodos * from pla_periodos
    where compania = ai_cia
    and tipo_de_planilla = as_tipo_de_planilla
    and ad_fecha between desde and dia_d_pago;
    if not found then
        raise exception ''En esta fecha % no Existe Periodo'',ad_fecha;
    else
        if r_pla_periodos.status = ''C'' then
            raise exception ''ID % Cia % En esta fecha % el periodo esta cerrado Tipo de Planilla % '',r_pla_periodos.id, ai_cia, ad_fecha, as_tipo_de_planilla;
        end if;
    end if;
    
    return true;
end;
' language plpgsql;



create function f_pla_dinero_insert(int4, int4, char(7), char(2), int4, int4, char(3), char(60), integer, decimal) returns int4 as '
declare
    ai_id_periodos alias for $1;
    ai_compania alias for $2;
    ac_codigo_empleado alias for $3;
    ac_tipo_de_calculo alias for $4;
    ai_id_pla_departamentos alias for $5;
    ai_id_pla_proyectos alias for $6;
    ac_concepto alias for $7;
    ac_descripcion alias for $8;
    ai_mes alias for $9;
    adc_monto alias for $10;
    r_pla_dinero record;
    li_retorno int4;
begin
    if adc_monto is null then
        return 0;
    end if;
    
    li_retorno = 0;
    select into r_pla_dinero * from pla_dinero
    where id_periodos = ai_id_periodos
    and compania = ai_compania
    and codigo_empleado = ac_codigo_empleado
    and tipo_de_calculo = ac_tipo_de_calculo
    and concepto = ac_concepto
    and id_pla_proyectos = ai_id_pla_proyectos
    and Trim(descripcion) = trim(ac_descripcion);
    if not found then
        insert into pla_dinero(id_periodos, compania, codigo_empleado, tipo_de_calculo,
            concepto, forma_de_registro, descripcion, mes, monto, id_pla_departamentos, id_pla_proyectos)
        values (ai_id_periodos, ai_compania, ac_codigo_empleado, ac_tipo_de_calculo, ac_concepto,
            ''A'', Trim(ac_descripcion), ai_mes, adc_monto, ai_id_pla_departamentos, ai_id_pla_proyectos);
--        li_retorno  =   lastval();

        select into li_retorno id from pla_dinero
        where id_periodos = ai_id_periodos
        and compania = ai_compania
        and codigo_empleado = ac_codigo_empleado
        and tipo_de_calculo = ac_tipo_de_calculo
        and concepto = ac_concepto
        and id_pla_proyectos = ai_id_pla_proyectos
        and Trim(descripcion) = trim(ac_descripcion);
    else
        li_retorno  =   r_pla_dinero.id;
    end if;
    
    return li_retorno;
end;
' language plpgsql;



create function f_interval_to_horas(interval) returns decimal as '
declare
    ai_interval alias for $1;
    ldc_dias decimal;
    ldc_horas decimal;
    ldc_minutos decimal;
    ldc_retorno decimal;
begin
    if ai_interval is null then
        return 0;
    end if;
    ldc_retorno =   0;
    ldc_dias    =   date_part(''day'', ai_interval);
    ldc_horas   =   date_part(''hour'', ai_interval);
    ldc_minutos =   date_part(''minutes'', ai_interval);

    ldc_retorno =   (ldc_dias * 24) + ldc_horas + (ldc_minutos / 60);
    return ldc_retorno;
end;
' language plpgsql;


create function f_valida_fecha(int4, date, char(2)) returns boolean as '
declare
    ai_cia alias for $1;
    ad_fecha alias for $2;
    as_tipo_de_planilla alias for $3;
    r_pla_periodos record;
    r_pla_companias record;
begin
    select into r_pla_companias * from pla_companias
    where compania = ai_cia;
    
    if current_date > r_pla_companias.fecha_de_expiracion then
        raise exception ''Esta compania expiro el % Llame al 66741218 para continuar utilizando el sistema'',r_pla_companias.fecha_de_expiracion;
    end if;


    select into r_pla_periodos * from pla_periodos
    where compania = ai_cia
    and tipo_de_planilla = as_tipo_de_planilla
    and ad_fecha between desde and dia_d_pago;
    if not found then
        raise exception ''En esta fecha % no Existe Periodo'',ad_fecha;
    else
        if r_pla_periodos.status = ''C'' then
            raise exception ''En esta fecha % el periodo esta cerrado'',ad_fecha;
        end if;
    end if;
    
    return true;
end;
' language plpgsql;



create function f_secuencia_empleados(int4, char(7)) returns char(7) as '
declare
    ai_cia alias for $1;
    as_valor alias for $2;
    r_pla_empleados record;
    r_pla_parametros record;
    r_pla_companias record;
    li_secuencia int4;
    li_caracteres integer;
    ls_codigo_empleado char(7);
begin
    if trim(as_valor) <> ''0'' then
        return trim(as_valor);
    end if;
    
    select into r_pla_companias *
    from pla_companias
    where compania = ai_cia;
    if not found then
        Raise Exception ''Compania % no Existe...Verifique'', ai_cia;
    end if;
    
    li_caracteres   =   to_number(f_pla_parametros(ai_cia, ''caracteres_codigo_empleado'',''4'',''GET''),''999999'');
    
    select into r_pla_parametros *
    from pla_parametros
    where compania = ai_cia
    and trim(parametro) = ''sec_empleados'';
    if not found then
        insert into pla_parametros(compania, parametro, valor)
        values (ai_cia, ''sec_empleados'',''0'');
        li_secuencia    =   0;
    else
        li_secuencia    =   r_pla_parametros.valor;
    end if;
    
    li_secuencia = 0;
    while 1=1 loop
        li_secuencia        =   li_secuencia + 1;
        
        ls_codigo_empleado  =   li_secuencia;
    
        if r_pla_companias.att_zone_id is null then    
            ls_codigo_empleado  =   lpad(trim(ls_codigo_empleado),li_caracteres,''0'');
        else
            ls_codigo_empleado  =   trim(ls_codigo_empleado);
        end if;            
        
        
        select into r_pla_empleados * from pla_empleados
        where trim(codigo_empleado) = trim(ls_codigo_empleado)
        and compania = ai_cia;
        if not found then
            update pla_parametros
            set valor = trim(to_char(li_secuencia, ''9999999''))
            where compania = ai_cia
            and trim(parametro) = ''sec_empleados'';
            exit;
        end if;
    end loop;
    
    return ls_codigo_empleado;
end;
' language plpgsql;



create function f_pla_parametros(int4, varchar(50), varchar(50),char(10)) returns varchar(50) as '
declare
    ai_cia alias for $1;
    as_parametro alias for $2;
    as_valor alias for $3;
    as_accion alias for $4;
    r_pla_parametros record;
begin
    select into r_pla_parametros *
    from pla_parametros
    where compania = ai_cia
    and trim(parametro) = trim(as_parametro);
    if found then
        if trim(r_pla_parametros.valor) <> trim(as_valor) and trim(as_accion) = ''UPDATE'' then
            update pla_parametros
            set valor = trim(as_valor)
            where compania = ai_cia
            and trim(parametro) = trim(as_parametro);
        end if;
        return trim(r_pla_parametros.valor);
    else
        return trim(as_valor);
    end if;
end;
' language plpgsql;





create function f_tipo_de_jornada(timestamp, timestamp) returns char(1) as '
declare
    ats_desde alias for $1;
    ats_hasta alias for $2;
    li_minutos int4;
    li_minutos_diurnos int4;
    li_minutos_nocturnos int4;
    lts_inicio_nocturno timestamp;
    lts_fin_nocturno timestamp;
    lts_fin_diurno timestamp;
    lt_inicio_nocturno time;
    lt_fin_nocturno time;
    lt_inicio_turno time;
    lt_work time;
    ld_work date;
    ld_desde date;
    ld_hasta date;
    lt_nocturno time;
    lt_hasta time;
    lt_desde time;
begin
    if ats_hasta < ats_desde then
        raise exception ''Fecha Hasta % No puede ser menor a la fecha Desde %'',ats_hasta, ats_desde;
    end if;

    lt_desde            =   ats_desde;
    lt_hasta            =   ats_hasta;
    ld_desde            =   ats_desde;
    ld_hasta            =   ats_hasta;
    lt_inicio_nocturno  =   ''18:00'';
    lt_fin_nocturno     =   ''06:00'';
    lt_nocturno         =   ''03:00'';
    lt_inicio_turno     =   ats_desde;
    ld_work             =   ats_desde;
    
    li_minutos  =   f_intervalo(ats_desde, ats_hasta);
    if ld_hasta > ld_desde then
        lt_work = ats_desde;
        if lt_work >= lt_inicio_nocturno then
            return ''N'';
        end if;
        
        if lt_work >= ''15:00'' then
            return ''N'';
        end if;
    else
        lt_work = ats_desde;
        if lt_desde >= lt_fin_nocturno and lt_desde <= ''12:00'' then
            return ''D'';
        elsif lt_desde >= lt_fin_nocturno and lt_hasta <= lt_inicio_nocturno then
            return ''D'';
        elsif lt_desde >= lt_nocturno and lt_desde <= lt_inicio_nocturno then
            lts_inicio_nocturno     =   f_timestamp(ld_work, lt_inicio_nocturno);
            li_minutos_diurnos      =   f_intervalo(ats_desde, lts_inicio_nocturno);
            li_minutos_nocturnos    =   f_intervalo(lts_inicio_nocturno, ats_hasta);
            if li_minutos_nocturnos >= 180 then
                return ''N'';
            else
                return ''M'';
            end if;
        elsif lt_desde >= lt_fin_nocturno and lt_hasta >= lt_inicio_nocturno then
            lts_inicio_nocturno     =   f_timestamp(ld_work, lt_inicio_nocturno);
            li_minutos_diurnos      =   f_intervalo(ats_desde, lts_inicio_nocturno);
            li_minutos_nocturnos    =   f_intervalo(lts_inicio_nocturno, ats_hasta);
            if li_minutos_nocturnos >= 180 then
                return ''N'';
            else
                return ''M'';
            end if;
            
        elsif lt_desde < lt_fin_nocturno and lt_hasta >= lt_fin_nocturno then
            lts_fin_nocturno        =   f_timestamp(ld_work, lt_fin_nocturno);
            li_minutos_diurnos      =   f_intervalo(lts_fin_nocturno, ats_hasta);
            li_minutos_nocturnos    =   f_intervalo(ats_desde, lts_fin_nocturno);
            if li_minutos_nocturnos >= 180 then
                return ''N'';
            else
                return ''M'';
/*                
                if li_minutos_diurnos > li_minutos_nocturnos then
                    return ''D'';
                else
                    return ''M'';
                end if;
*/
                
            end if;
        
        elsif lt_work >= lt_inicio_nocturno and li_minutos >= 420 then
            return ''N'';
        elsif lt_work < lt_fin_nocturno and lt_hasta > lt_fin_nocturno then
            return ''M'';
        elsif lt_work <= lt_nocturno then
            return ''N'';
        else
            lt_work = ats_hasta;
            if lt_work  >= lt_inicio_nocturno then
                ld_work = ats_hasta;
                lts_inicio_nocturno     =   f_timestamp(ld_work, lt_inicio_nocturno);
                li_minutos_nocturnos    =   f_intervalo(lts_inicio_nocturno, ats_hasta);
                li_minutos_diurnos      =   f_intervalo(ats_desde, lts_inicio_nocturno);
                
                if lt_inicio_turno < lt_fin_nocturno 
                    and li_minutos_nocturnos >= 60 and li_minutos_diurnos >= 240 then
                    return ''M'';
                end if;
                
                if li_minutos_diurnos >= 240 then
                    return ''D'';
                end if;
                
                if li_minutos_nocturnos >= 240 then
                    return ''N'';
                else
                    return ''M'';
                end if;
            end if;
        end if;
    end if;
    return ''D'';
end;
' language plpgsql;


create function f_sysmeca(int4, char(7), char(3), date, date) returns decimal as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    as_concepto alias for $3;
    ad_desde alias for $4;
    ad_hasta alias for $5;
    ldc_work decimal;
    r_pla_empleados record;
begin
/*
     81 = Prima de produccion
     03 = salario
     73 = gastos de representacion
     75 = bonificaciones
     310 = IMPUESTO SOBRE LA RENTA DEL GASTO DE REPRESENTACION
     106 = IMPUESTO SOBRE LA RENTA
     109 = XIII MES
     125 = XIII MES DEL GASTO DE REPRESENTACION
     107 = VACACIONES DEL gto de representacion
*/     

    select into r_pla_empleados * 
    from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    if r_pla_empleados.retiene_ss is null then
        update pla_empleados
        set retiene_ss = ''S'' 
        where compania = ai_cia
        and codigo_empleado = as_codigo_empleado;
    end if;
    
    if r_pla_empleados.retiene_ss = ''N'' then
        return 0;
    end if;
    
    if trim(as_concepto) = ''03'' then
        select into ldc_work sum(pla_dinero.monto*pla_conceptos.signo)
        from pla_dinero, pla_conceptos, pla_conceptos_acumulan, pla_periodos
        where pla_periodos.id = pla_dinero.id_periodos
        and pla_dinero.concepto = pla_conceptos.concepto
        and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
        and pla_dinero.codigo_empleado = as_codigo_empleado
        and pla_periodos.dia_d_pago between ad_desde and ad_hasta
        and pla_dinero.compania = ai_cia
        and pla_dinero.concepto not in (''73'', ''125'', ''107'')
        and pla_conceptos_acumulan.concepto = ''102'';
        
    elsif trim(as_concepto) = ''73'' then
        select into ldc_work sum(pla_dinero.monto)
        from pla_dinero, pla_periodos
        where pla_periodos.id = pla_dinero.id_periodos
        and pla_dinero.codigo_empleado = as_codigo_empleado
        and pla_periodos.dia_d_pago between ad_desde and ad_hasta
        and pla_dinero.compania = ai_cia
        and pla_dinero.concepto in (''73'',''107'');
    
    elsif trim(as_concepto) = ''75'' then
        select into ldc_work sum(pla_dinero.monto)
        from pla_dinero, pla_periodos
        where pla_periodos.id = pla_dinero.id_periodos
        and pla_dinero.codigo_empleado = as_codigo_empleado
        and pla_periodos.dia_d_pago between ad_desde and ad_hasta
        and pla_dinero.compania = ai_cia
        and pla_dinero.concepto in (''112'');
    
    elsif trim(as_concepto) = ''109'' then
        select into ldc_work sum(pla_dinero.monto)
        from pla_dinero, pla_periodos
        where pla_periodos.id = pla_dinero.id_periodos
        and pla_dinero.codigo_empleado = as_codigo_empleado
        and pla_periodos.dia_d_pago between ad_desde and ad_hasta
        and pla_dinero.compania = ai_cia
        and pla_dinero.concepto in (''109'');
        
    elsif trim(as_concepto) = ''106'' then
        select into ldc_work sum(pla_dinero.monto)
        from pla_dinero, pla_periodos
        where pla_periodos.id = pla_dinero.id_periodos
        and pla_dinero.codigo_empleado = as_codigo_empleado
        and pla_periodos.dia_d_pago between ad_desde and ad_hasta
        and pla_dinero.compania = ai_cia
        and pla_dinero.concepto in (''106'');
        
    elsif trim(as_concepto) = ''310'' then
        select into ldc_work sum(pla_dinero.monto)
        from pla_dinero, pla_periodos
        where pla_periodos.id = pla_dinero.id_periodos
        and pla_dinero.codigo_empleado = as_codigo_empleado
        and pla_periodos.dia_d_pago between ad_desde and ad_hasta
        and pla_dinero.compania = ai_cia
        and pla_dinero.concepto in (''310'');

    elsif trim(as_concepto) = ''125'' then
        select into ldc_work sum(pla_dinero.monto)
        from pla_dinero, pla_periodos
        where pla_periodos.id = pla_dinero.id_periodos
        and pla_dinero.codigo_empleado = as_codigo_empleado
        and pla_periodos.dia_d_pago between ad_desde and ad_hasta
        and pla_dinero.compania = ai_cia
        and pla_dinero.concepto in (''125'');

    elsif trim(as_concepto) = ''81'' then
        select into ldc_work sum(pla_dinero.monto)
        from pla_dinero, pla_periodos
        where pla_periodos.id = pla_dinero.id_periodos
        and pla_dinero.codigo_empleado = as_codigo_empleado
        and pla_periodos.dia_d_pago between ad_desde and ad_hasta
        and pla_dinero.compania = ai_cia
        and pla_dinero.concepto in (''81'');

    end if;
    
    if ldc_work is null then
        ldc_work = 0;
    end if;
    
    return ldc_work;
end;
' language plpgsql;



create function f_mes(int4) returns char(100) as '
declare
    ai_mes alias for $1;
    ls_mes char(100);
begin
    if ai_mes = 1 then
        ls_mes = ''ENERO'';
    elsif ai_mes = 2 then
            ls_mes  =   ''FEBRERO'';
    elsif ai_mes = 3 then
            ls_mes  =   ''MARZO'';
    elsif ai_mes = 4 then
            ls_mes  =   ''ABRIL'';
    elsif ai_mes = 5 then
            ls_mes  =   ''MAYO'';
    elsif ai_mes = 6 then
            ls_mes  =   ''JUNIO'';
    elsif ai_mes = 7 then
            ls_mes  =   ''JULIO'';
    elsif ai_mes = 8 then
            ls_mes  =   ''AGOSTO'';
    elsif ai_mes = 9 then
            ls_mes  =   ''SEPTIEMBRE'';
    elsif ai_mes = 10 then
            ls_mes  =   ''OCTUBRE'';
    elsif ai_mes = 11 then
            ls_mes  =   ''NOVIEMBRE'';
    else
        ls_mes = ''DICIEMBRE'';
    end if;
    
    return ls_mes;
end;
' language plpgsql;



create function f_pla_nombre_auxiliar(int4) returns char(100) as '
declare
    aid alias for $1;
    r_pla_auxiliares record;
    r_pla_empleados record;
    r_pla_acreedores record;
    r_pla_departamentos record;
    ls_nombre char(100);
begin
    ls_nombre = null;
    select into r_pla_auxiliares * from pla_auxiliares
    where id = aid;
    if not found then
        ls_nombre = null;
        return ls_nombre;
    end if;
    
    
    if r_pla_auxiliares.compania is not null and r_pla_auxiliares.codigo_empleado is not null then
        select into ls_nombre nombre from pla_empleados
        where compania = r_pla_auxliares.compania
        and codigo_empleado = r_pla_auxiliares.codigo_empleado;
        if found then
            return ls_nombre;
        else
            ls_nombre = null;
            return ls_nombre;
        end if;
    end if;
    
    
    if r_pla_auxiliares.id_pla_departamentos is not null then
        select into ls_nombre descripcion from pla_departamentos
        where id = r_pla_auxiliares.id_pla_departamentos;
        if found then
            return ls_nombre;
        else
            ls_nombre = null;
            return ls_nombre;
        end if;
    end if;
    
    if r_pla_auxiliares.compania is not null and r_pla_auxiliares.acreedor is not null then
        select into ls_nombre nombre from pla_acreedores
        where compania = r_pla_auxiliares.compania
        and acreedor = r_pla_auxiliares.acreedor;
        if found then
            return ls_nombre;
        else
            ls_nombre = null;
            return ls_nombre;
        end if;
    end if;
    
    return ls_nombre;
end;
' language plpgsql;


create function f_concat_fecha_hora(date, time) returns char(20) as '
declare
    ad_fecha alias for $1;
    at_hora alias for $2;
    ls_fecha char(10);
    ls_hora char(8);
    ls_fecha_hora char(20);
begin
    ls_fecha = ad_fecha;
    ls_hora = at_hora;
    ls_fecha_hora = trim(ls_fecha) || ''  '' || trim(ls_hora);
    return ls_fecha_hora;
end;
' language plpgsql;

create function anio(date) returns float
as 'select extract("year" from $1) as anio' language 'sql';

create function mes(date) returns float
as 'select extract("month" from $1) as mes' language 'sql';


create function f_ultimo_dia_del_mes(date) returns date as '
declare
    ad_fecha alias for $1;
    i integer;
    ld_fecha date;
    li_anio int4;
    
begin
    if Mes(ad_fecha) = 1 or Mes(ad_fecha) = 3 
        or Mes(ad_fecha) = 5 or Mes(ad_fecha) = 7
        or Mes(ad_fecha) = 8 or Mes(ad_fecha) = 10
        or Mes (ad_fecha) = 12 then
        i = 31;
    elsif Mes(ad_fecha) = 2 then
        li_anio = Anio(ad_fecha);
        if f_isleapyear(li_anio) then
            i = 29;
        else
            i = 28;
        end if;
    else
        i = 30;
    end if;
    
    ld_fecha = to_char(Anio(ad_fecha),''9999'')||''-''||trim(to_char(Mes(ad_fecha),''99''))||''-''||trim(to_char(i,''99''));
    
    return ld_fecha;
end;
' language plpgsql;


create function f_primer_dia_del_mes(date) returns date as '
declare
    ad_fecha alias for $1;
    i integer;
    ld_fecha date;
    li_anio int4;
    
begin

    ld_fecha = to_char(Anio(ad_fecha),''9999'')||''-''||trim(to_char(Mes(ad_fecha),''99''))||''-01'';
    
    return ld_fecha;
end;
' language plpgsql;


create function f_valida_fecha(int4, date) returns boolean as '
declare
    ai_cia alias for $1;
    ad_fecha alias for $2;
    r_pla_periodos record;
    r_pla_companias record;
begin
    select into r_pla_companias * from pla_companias
    where compania = ai_cia;
    
    if current_date > r_pla_companias.fecha_de_expiracion then
        raise exception ''Esta compania expiro el % Llame al 66741218 para continuar utilizando el sistema'',r_pla_companias.fecha_de_expiracion;
    end if;

/*
    select into r_pla_periodos * from pla_periodos
    where compania = ai_cia
    and ad_fecha between desde and dia_d_pago;
    if not found then
        raise exception ''En esta fecha % no Existe Periodo'',ad_fecha;
    else
        if r_pla_periodos.status = ''C'' then
            raise exception ''En esta fecha % el periodo esta cerrado'',ad_fecha;
        end if;
    end if;
*/
    
    return true;
end;
' language plpgsql;


create function f_pla_dinero_insert(int4, int4, char(7), char(2), char(3), char(60), integer, decimal) returns int4 as '
declare
    ai_id_periodos alias for $1;
    ai_compania alias for $2;
    ac_codigo_empleado alias for $3;
    ac_tipo_de_calculo alias for $4;
    ac_concepto alias for $5;
    ac_descripcion alias for $6;
    ai_mes alias for $7;
    adc_monto alias for $8;
    r_pla_dinero record;
    li_retorno int4;
begin
    if adc_monto is null then
        return 0;
    end if;
    
    li_retorno = 0;
    select into r_pla_dinero * from pla_dinero
    where id_periodos = ai_id_periodos
    and compania = ai_compania
    and codigo_empleado = ac_codigo_empleado
    and tipo_de_calculo = ac_tipo_de_calculo
    and concepto = ac_concepto
    and Trim(descripcion) = trim(ac_descripcion);
    if not found then
        insert into pla_dinero(id_periodos, compania, codigo_empleado, tipo_de_calculo,
            concepto, forma_de_registro, descripcion, mes, monto)
        values (ai_id_periodos, ai_compania, ac_codigo_empleado, ac_tipo_de_calculo, ac_concepto,
            ''A'', Trim(ac_descripcion), ai_mes, adc_monto);
--        li_retorno  =   lastval();
        
        select into li_retorno id from pla_dinero
        where id_periodos = ai_id_periodos
        and compania = ai_compania
        and codigo_empleado = ac_codigo_empleado
        and tipo_de_calculo = ac_tipo_de_calculo
        and concepto = ac_concepto
        and Trim(descripcion) = trim(ac_descripcion);
        
    else
        li_retorno  =   r_pla_dinero.id;
    end if;
    
    return li_retorno;
end;
' language plpgsql;








create function f_concepto_pagado(int4, char(7), char(3), int4) returns decimal as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    as_concepto alias for $3;
    ai_anio alias for $4;
    r_pla_ajuste_de_renta record;
    ldc_pagado_1 decimal;
    ldc_pagado_2 decimal;
    ldc_pagado_3 decimal;
begin
    ldc_pagado_1 = 0;
    ldc_pagado_2 = 0;
    ldc_pagado_3 = 0;
    select into ldc_pagado_1 sum(pla_dinero.monto*pla_conceptos.signo)
    from pla_dinero, pla_conceptos, pla_periodos
    where pla_periodos.id = pla_dinero.id_periodos
    and pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_dinero.concepto = as_concepto
    and pla_periodos.year = ai_anio
    and pla_dinero.compania = ai_cia;
    
    select into ldc_pagado_2 sum(pla_preelaboradas.monto*pla_conceptos.signo)
    from pla_preelaboradas, pla_conceptos
    where pla_preelaboradas.concepto = pla_conceptos.concepto
    and pla_preelaboradas.codigo_empleado = as_codigo_empleado
    and pla_preelaboradas.concepto = as_concepto
    and Anio(pla_preelaboradas.fecha) = ai_anio
    and pla_preelaboradas.compania = ai_cia;
    
    if as_concepto = ''106'' then
        select into r_pla_ajuste_de_renta *
        from pla_ajuste_de_renta
        where compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and anio = ai_anio;
        if not found then
            r_pla_ajuste_de_renta.monto = 0;
        end if;
        ldc_pagado_3 = -r_pla_ajuste_de_renta.monto;
    end if;
    
    if ldc_pagado_1 is null then
        ldc_pagado_1 = 0;
    end if;
    
    if ldc_pagado_2 is null then
        ldc_pagado_2 = 0;
    end if;
    
    return ldc_pagado_1 + ldc_pagado_2 + ldc_pagado_3;
end;
' language plpgsql;


create function f_acumulado_para(int4, char(7), char(3), date, date) returns decimal as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    as_concepto alias for $3;
    ad_desde alias for $4;
    ad_hasta alias for $5;
    ldc_acumulado_1 decimal;
    ldc_acumulado_2 decimal;
    r_pla_empleados record;
    ld_desde date;
begin
    ldc_acumulado_1 = 0;
    ldc_acumulado_2 = 0;
    
    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    
/*    
    select into ldc_acumulado_1 sum(pla_dinero.monto*pla_conceptos.signo)
    from pla_dinero, pla_conceptos, pla_conceptos_acumulan, pla_periodos
    where pla_periodos.id = pla_dinero.id_periodos
    and pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_periodos.dia_d_pago between ad_desde and ad_hasta
    and pla_dinero.compania = ai_cia
    and pla_conceptos_acumulan.concepto = as_concepto;
    
    
    select into ldc_acumulado_2 sum(pla_preelaboradas.monto*pla_conceptos.signo)
    from pla_preelaboradas, pla_conceptos, pla_conceptos_acumulan
    where pla_preelaboradas.concepto = pla_conceptos.concepto
    and pla_preelaboradas.concepto = pla_conceptos_acumulan.concepto_aplica
    and pla_preelaboradas.codigo_empleado = as_codigo_empleado
    and pla_preelaboradas.fecha between ad_desde and ad_hasta 
    and pla_preelaboradas.compania = ai_cia
    and pla_conceptos_acumulan.concepto = as_concepto;
*/


    if ad_desde < r_pla_empleados.fecha_inicio then
        ld_desde = r_pla_empleados.fecha_inicio;
    else
        ld_desde = ad_desde;
    end if;
    
    select into ldc_acumulado_1 sum(monto)
    from v_pla_acumulados
    where codigo_empleado = as_codigo_empleado
    and fecha between ld_desde and ad_hasta
    and compania = ai_cia
    and concepto_calcula = as_concepto;    

    if ldc_acumulado_1 is null then
        ldc_acumulado_1 = 0;
    end if;
    
    if ldc_acumulado_2 is null then
        ldc_acumulado_2 = 0;
    end if;
    
    return ldc_acumulado_1 + ldc_acumulado_2;
end;
' language plpgsql;





create function f_acumulado_para(int4, char(7), char(3), int4) returns decimal as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    as_concepto alias for $3;
    ai_anio alias for $4;
    ldc_acumulado_1 decimal;
    ldc_acumulado_2 decimal;
begin
    ldc_acumulado_1 = 0;
    ldc_acumulado_2 = 0;

    if trim(as_concepto) = ''106'' then
        select into ldc_acumulado_1 sum(monto)
        from v_pla_acumulados_isr
        where codigo_empleado = as_codigo_empleado
        and anio = ai_anio
        and compania = ai_cia
        and concepto_calcula = as_concepto;    
    else
        select into ldc_acumulado_1 sum(monto)
        from v_pla_acumulados
        where codigo_empleado = as_codigo_empleado
        and anio = ai_anio
        and compania = ai_cia
        and concepto_calcula = as_concepto;    
    end if;

    if ldc_acumulado_1 is null then
        ldc_acumulado_1 = 0;
    end if;
    
    if ldc_acumulado_2 is null then
        ldc_acumulado_2 = 0;
    end if;
    
    return ldc_acumulado_1 + ldc_acumulado_2;
end;
' language plpgsql;





create function f_intervalo(timestamp, timestamp) returns int4 as '
declare
    adt_desde alias for $1;
    adt_hasta alias for $2;
    lt_diferencia interval;
    li_minutos int4;
    li_work int4;
begin
    if adt_desde > adt_hasta then
        return 0;
    end if;
    
    if adt_desde is null or adt_hasta is null then
        return 0;
    end if;
    li_minutos = 0;
    lt_diferencia = adt_hasta - adt_desde;
    li_minutos = (extract(days from lt_diferencia)*24*60) + extract(minutes from lt_diferencia) + (extract(hour from lt_diferencia)*60);
    return li_minutos;
end;
' language plpgsql;

create function f_timestamp(date, time) returns timestamp as '
declare
    ad_fecha alias for $1;
    at_hora alias for $2;
    ls_fecha char(10);
    ls_hora char(8);
    ls_fecha_hora char(20);
    ldt_fechahora timestamp;
begin
    ls_fecha = ad_fecha;
    ls_hora = at_hora;
    ls_fecha_hora = trim(ls_fecha) || ''  '' || trim(ls_hora);
    ldt_fechahora = to_timestamp(ls_fecha_hora,''YYYY/MM/DD HH24:MI'');
    return ldt_fechahora;
end;
' language plpgsql;



create function f_relative_dmy(char(20), date, int4) returns date as '
declare
    as_dmy alias for $1;
    ad_fecha alias for $2;
    ai_dmy alias for $3;
    ld_retorno date;
    li_work int4;
    li_temp_month int4;
    li_adjust_months int4;
    li_adjust_years int4;
    li_year int4;
    li_month int4;
    li_day int4;
begin
    if ai_dmy = 0 then
        return ad_fecha;
    end if;
    
    ld_retorno = ad_fecha;
    if trim(as_dmy) = ''DIA'' or trim(as_dmy) = ''DAY'' then
        ld_retorno = ad_fecha + ai_dmy;
    end if;
    

    if trim(as_dmy) = ''MES'' or trim(as_dmy) = ''MONTH'' then
        li_adjust_months = mod(ai_dmy, 12);
        li_adjust_years = (ai_dmy / 12);
        li_temp_month = Mes(ad_fecha) + li_adjust_months;
        
        If li_temp_month > 12 Then
        	li_month = li_temp_month - 12;
        	li_adjust_years = li_adjust_years + 1;
        elsif li_temp_month <= 0 Then
        	li_month = li_temp_month + 12;
        	li_adjust_years = li_adjust_years + 1;
        Else
        	li_month = li_temp_month;
        End If;
        li_year = Anio(ad_fecha) + li_adjust_years;
        li_day = extract (day from ad_fecha);


        If li_day > f_days_in_month(li_month) Then
        	If li_month = 2 and f_isleapyear(li_year) Then
        		li_day = 29;
        	Else
        		li_day = f_days_in_month(li_month);
        	end If;
        End IF;
        
        ld_retorno = f_to_date(li_year,li_month,li_day);
        
    end if;
    
    if trim(as_dmy) = ''ANIO'' or trim(as_dmy) = ''YEAR'' then
        li_year = Anio(ad_fecha) + ai_dmy;
        li_month = Mes(ad_fecha);
        li_day = extract (day from ad_fecha);

        If li_day > f_days_in_month(li_month) Then
           If li_month = 2 and f_isleapyear(li_year) Then
                 li_day = 29;
           Else
                 li_day = f_days_in_month(li_month);
           end If;
        End IF;

        ld_retorno = f_to_date(li_year,li_month,li_day);
    end if;
    
    
    return ld_retorno;
end;
' language plpgsql;


create function f_days_in_month(integer) returns integer as '
declare
    ai_mes alias for $1;
begin
    if ai_mes = 1 then
        return 31;
    elsif ai_mes = 2 then
            return 28;
    elsif ai_mes = 3 then
            return 31;
    elsif ai_mes = 4 then
            return 30;
    elsif ai_mes = 5 then
            return 31;
    elsif ai_mes = 6 then
            return 30;
    elsif ai_mes = 7 then
            return 31;
    elsif ai_mes = 8 then
            return 31;
    elsif ai_mes = 9 then
            return 30;
    elsif ai_mes = 10 then
            return 31;
    elsif ai_mes = 11 then
            return 30;
    else
        return 31;
    end if;
    
end;
' language plpgsql;

create function f_to_date(integer, integer, integer) returns date as '
declare
    ai_y alias for $1;
    ai_m alias for $2;
    ai_d alias for $3;
    ls_fecha char(10);
begin
    ls_fecha = trim(to_char(ai_y,''9999'')) || ''/'' || trim(to_char(ai_m,''09'')) || ''/'' || trim(to_char(ai_d,''09''));
    return to_date(ls_fecha, ''YYYY/MM/DD'');
end;
' language plpgsql;



create function f_isleapyear(integer) returns boolean as '
declare
    ai_year alias for $1;
begin
    if (ai_year % 4 = 0 and ai_year % 100 <> 0) or ai_year % 400 = 0 then
        return true;
    else
        return false;
    end if;
end;
' language plpgsql;
