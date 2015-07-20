
drop function f_isr(int4, char(7), char(2)) cascade;
drop function f_isr_causado(int4, char(7), char(2), int4) cascade;
drop function f_isr_final(int4, char(7), char(2), int4) cascade;
drop function f_isr(int4, char(7), char(2), int4) cascade;
drop function f_periodos_pago(int4, char(7), char(2), int4) cascade;
drop function f_renta_exacta(int4, char(7), char(2), decimal) cascade;
drop function f_renta_exacta_2010(int4, char(7), char(2), decimal) cascade;


create function f_isr(int4, char(7), char(2)) returns integer as '
declare
    ai_id_pla_periodos alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_de_calculo alias for $3;
    ai_cia int4;
    as_tipo_de_planilla char(2);
    ai_anio int4;
    r_pla_periodos record;
    r_pla_empleados record;
    r_pla_dinero record;
    r_pla_ajuste_de_renta record;
    ldc_work decimal;
    ldc_isr decimal;
    ldc_periodos_pago decimal;
    ldc_acumulado_isr decimal;
    ldc_isr_retenido decimal;
    ldc_ingreso_promedio decimal;
    ldc_ingreso_estimado decimal;
    ldc_renta_exacta decimal;
    ldc_gto_representacion decimal;
    ldc_gto_representacion_anual decimal;
    ldc_isr_gto_representacion_anual decimal;
    ldc_salario_neto decimal;
    ldc_periodos_faltantes decimal;
    ldc_salario_proyectado decimal;
    ldc_periodos_anuales decimal;
    ldc_periodos_pendientes decimal;
    ldc_otros_ingresos_fijos decimal;
begin

-- 106 = isr
-- 107 = vacaciones del gto de representacion
-- 108 = vacaciones
-- 109 = xiii mes
-- 125 = xiii mes del gto de representacion
-- 310 = isr del gto de representaicon
-- 150 = sindicato

    delete from pla_dinero
    where id_periodos = ai_id_pla_periodos
    and tipo_de_calculo = as_tipo_de_calculo
    and trim(codigo_empleado) = trim(as_codigo_empleado)
    and concepto in (''106'',''310'')
    and forma_de_registro = ''A'';
    
    ldc_isr = 0;
    select into r_pla_periodos *
    from pla_periodos
    where id = ai_id_pla_periodos;
    if not found then
        return 0;
    end if;


/*
    if r_pla_periodos.compania = 880 then
        return 0;
    end if;
*/
    
    
    select into r_pla_empleados *
    from pla_empleados
    where compania = r_pla_periodos.compania
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;

    
    select into ldc_gto_representacion sum(pla_dinero.monto*pla_conceptos.signo)
    from pla_dinero, pla_conceptos
    where pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_dinero.id_periodos = ai_id_pla_periodos
    and pla_dinero.compania = r_pla_periodos.compania
    and pla_dinero.concepto in (''73'',''107'', ''125'');
    
    if ldc_gto_representacion is null then
        ldc_gto_representacion = 0;
    end if;
    

    ldc_gto_representacion_anual = 0;
    select into ldc_gto_representacion_anual sum(pla_dinero.monto*pla_conceptos.signo)
    from pla_dinero, pla_conceptos, pla_periodos
    where pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.id_periodos = pla_periodos.id
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_periodos.year = r_pla_periodos.year
    and pla_dinero.compania = r_pla_periodos.compania
    and pla_dinero.concepto in (''73'',''107'', ''125'');
    if ldc_gto_representacion_anual is null then
        ldc_gto_representacion_anual = 0;
    end if;
    
    ldc_isr_gto_representacion_anual = 0;
    select into ldc_isr_gto_representacion_anual sum(pla_dinero.monto*pla_conceptos.signo)
    from pla_dinero, pla_conceptos, pla_periodos
    where pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.id_periodos = pla_periodos.id
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_periodos.year = r_pla_periodos.year
    and pla_dinero.compania = r_pla_periodos.compania
    and pla_dinero.concepto in (''310'');
    if ldc_isr_gto_representacion_anual is null then
        ldc_isr_gto_representacion_anual = 0;
   end if;
    
--    raise exception ''% %'', ldc_gto_representacion_anual, ldc_isr_gto_representacion_anual;
    
    if ldc_gto_representacion_anual >= 25000 then
--        ldc_isr    =   (ldc_gto_representacion*.15);    
        ldc_isr     =   (2500 + ((ldc_gto_representacion_anual - 25000)*.15)) + ldc_isr_gto_representacion_anual;
    else
        ldc_isr    =   (ldc_gto_representacion_anual*.1) + ldc_isr_gto_representacion_anual;
    end if;
    
--raise exception ''%'', ldc_isr;

    
    if Round(ldc_isr,2) > 0 then
        select into r_pla_dinero * from pla_dinero
        where compania = r_pla_periodos.compania
        and codigo_empleado = as_codigo_empleado
        and tipo_de_calculo = as_tipo_de_calculo
        and concepto = ''310''
        and id_periodos = ai_id_pla_periodos;
        if not found then
            insert into pla_dinero(id_periodos, compania, codigo_empleado,
                tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                monto)
            values(ai_id_pla_periodos, r_pla_periodos.compania, as_codigo_empleado, as_tipo_de_calculo,''310'',
                ''A'', ''IMPUESTO SOBRE LA RENTA DEL GTO DE REPRESENTACION'', Mes(r_pla_periodos.dia_d_pago), ldc_isr);
        end if;
    end if;
    
    if r_pla_empleados.tipo_calculo_ir = ''N'' then
        return 0;
    end if;    
    
    ldc_isr = 0;
    ldc_work = 0;
    select into ldc_work sum(pla_dinero.monto*pla_conceptos.signo)
    from pla_dinero, pla_conceptos, pla_conceptos_acumulan
    where pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
    and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_dinero.id_periodos = ai_id_pla_periodos
    and pla_conceptos_acumulan.concepto = ''106'';
    if not found or ldc_work is null or ldc_work < 0 then
        ldc_work = 0;
    end if;
    

    if trim(as_tipo_de_calculo) = ''7'' then
        r_pla_empleados.tipo_calculo_ir = ''E'';
    end if;

    if Mes(r_pla_periodos.dia_d_pago) <= 3 and r_pla_empleados.tipo_calculo_ir = ''E'' then
        if r_pla_empleados.compania = 1199 then
            r_pla_empleados.tipo_calculo_ir = ''P'';
        end if;            
    end if;

    if Mes(r_pla_periodos.dia_d_pago) >= 12 and r_pla_empleados.tipo_calculo_ir = ''P'' then
        r_pla_empleados.tipo_calculo_ir = ''E'';
    end if;
    
    if r_pla_empleados.tipo_calculo_ir = ''N'' then
        ldc_work = 0;
        
    elsif Trim(r_pla_empleados.tipo_calculo_ir) = ''R'' then
            if r_pla_periodos.year >= 2010 then
                ldc_isr = f_renta_exacta_2010(r_pla_periodos.compania, as_codigo_empleado, r_pla_empleados.tipo_de_planilla, ldc_work);
            else
                ldc_isr = f_renta_exacta(r_pla_periodos.compania, as_codigo_empleado, r_pla_empleados.tipo_de_planilla, ldc_work);
            end if;
            
    elsif Trim(r_pla_empleados.tipo_calculo_ir) = ''P'' then
        if r_pla_empleados.tipo_de_planilla = ''1'' then
            ldc_periodos_anuales    =   52 + (52/12);
        elsif r_pla_empleados.tipo_de_planilla = ''2'' then
            ldc_periodos_anuales = 26;
        elsif r_pla_empleados.tipo_de_planilla = ''3'' then
            ldc_periodos_anuales    =   26 + (26/12);
        else
            ldc_periodos_anuales    =   13;
        end if;

        ldc_otros_ingresos_fijos = 0;
        select sum(monto) into ldc_otros_ingresos_fijos
        from pla_otros_ingresos_fijos
        where compania = r_pla_empleados.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and periodo = r_pla_periodos.periodo
        and concepto in (select concepto_aplica from pla_conceptos_acumulan
                                        where concepto = ''106'');
        if ldc_otros_ingresos_fijos is null then
            ldc_otros_ingresos_fijos = 0;
        end if;            
        
--        raise exception ''% %'', ldc_otros_ingresos_fijos, r_pla_periodos.periodo;

        ai_cia                  =   r_pla_periodos.compania;
        as_tipo_de_planilla     =   r_pla_periodos.tipo_de_planilla;
        ai_anio                 =   r_pla_periodos.year;
        ldc_periodos_pago       =   Round(f_periodos_pago(ai_cia, as_codigo_empleado, as_tipo_de_planilla, ai_anio),8);
        ldc_periodos_pendientes =   ldc_periodos_anuales - ldc_periodos_pago;
        ldc_ingreso_estimado    =   (r_pla_empleados.salario_bruto + ldc_otros_ingresos_fijos) * ldc_periodos_pendientes;        
        ldc_acumulado_isr       =   f_acumulado_para(ai_cia, as_codigo_empleado, ''106'', ai_anio) + ldc_ingreso_estimado;
        ldc_isr_retenido        =   f_concepto_pagado(ai_cia, as_codigo_empleado, ''106'', ai_anio);
        ldc_ingreso_promedio    =   ldc_acumulado_isr / ldc_periodos_anuales;
        ldc_renta_exacta        =   f_renta_exacta_2010(ai_cia, as_codigo_empleado, as_tipo_de_planilla, ldc_ingreso_promedio);
        ldc_isr                 =   (ldc_renta_exacta * ldc_periodos_pago) + ldc_isr_retenido;

        if ldc_isr = 0 then
            return 1;
        end if;


        ldc_work = 0;
        select sum(monto) into ldc_work
        from pla_dinero, pla_periodos
        where pla_dinero.id_periodos = pla_periodos.id
        and pla_dinero.compania = ai_cia
        and pla_dinero.codigo_empleado = as_codigo_empleado
        and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
        and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
        and pla_dinero.concepto = ''106'';
        if ldc_work is null then
            ldc_work = 0;
        end if;
        
        if ldc_isr < 0 and -ldc_isr > ldc_work then
            ldc_isr = -ldc_work;
        end if;

    
    else
        ai_cia                  = r_pla_periodos.compania;
        as_tipo_de_planilla     = r_pla_periodos.tipo_de_planilla;
        ai_anio                 = r_pla_periodos.year;
        ldc_periodos_pago       = Round(f_periodos_pago(ai_cia, as_codigo_empleado, as_tipo_de_planilla, ai_anio),8);
        ldc_acumulado_isr       = f_acumulado_para(ai_cia, as_codigo_empleado, ''106'', ai_anio);
        ldc_isr_retenido        = f_concepto_pagado(ai_cia, as_codigo_empleado, ''106'', ai_anio);
        ldc_ingreso_promedio    = ldc_acumulado_isr / ldc_periodos_pago;
        ldc_renta_exacta        = f_renta_exacta_2010(ai_cia, as_codigo_empleado, as_tipo_de_planilla, ldc_ingreso_promedio);
        ldc_isr                 = (ldc_renta_exacta * ldc_periodos_pago) + ldc_isr_retenido;

        if ai_cia = 1193 then
            if Anio(r_pla_empleados.fecha_inicio) = ai_anio and r_pla_empleados.tipo_de_planilla = ''2'' then
                ldc_periodos_faltantes  =   26 - ldc_periodos_pago;
                ldc_salario_proyectado  =   (r_pla_empleados.salario_bruto * ldc_periodos_faltantes) + ldc_acumulado_isr;
            
                if ldc_salario_proyectado < 11000 then
                    ldc_isr = 0;
                end if;
            end if;
        end if;

        if ldc_isr = 0 then
            return 1;
        end if;


        ldc_work = 0;
        select sum(monto) into ldc_work
        from pla_dinero, pla_periodos
        where pla_dinero.id_periodos = pla_periodos.id
        and pla_dinero.compania = ai_cia
        and pla_dinero.codigo_empleado = as_codigo_empleado
        and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
        and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
        and pla_dinero.concepto = ''106'';
        if ldc_work is null then
            ldc_work = 0;
        end if;
        
        if ldc_isr < 0 and -ldc_isr > ldc_work then
            ldc_isr = -ldc_work;
        end if;
        
    end if;

    
    if Round(ldc_isr,2) <> 0 then

        ldc_salario_neto = f_pla_salario_neto(r_pla_periodos.compania, as_codigo_empleado, as_tipo_de_calculo, ai_id_pla_periodos);

        if ldc_isr >= (ldc_salario_neto*0.80) then
            ldc_isr = ldc_salario_neto * .75;
        end if;
        
        select into r_pla_dinero * from pla_dinero
        where compania = r_pla_periodos.compania
        and codigo_empleado = as_codigo_empleado
        and tipo_de_calculo = as_tipo_de_calculo
        and concepto = ''106''
        and id_periodos = ai_id_pla_periodos;
        if not found then
            if Round(ldc_isr,2) <> 0 then
                insert into pla_dinero(id_periodos, compania, codigo_empleado,
                    tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                    monto)
                values(ai_id_pla_periodos, r_pla_periodos.compania, as_codigo_empleado, as_tipo_de_calculo,''106'',
                    ''A'', ''IMPUESTO SOBRE LA RENTA'', Mes(r_pla_periodos.dia_d_pago), ldc_isr);
            end if;        
        end if;
    end if;

    return 1;
end;
' language plpgsql;



create function f_renta_exacta_2010(int4, char(7), char(2), decimal) returns decimal as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_de_planilla alias for $3;
    adc_monto alias for $4;
    ldc_renta decimal;
    ldc_periodos decimal;
    ldc_deduccion_basica decimal;
    ldc_ingresos_anuales decimal;
    ldc_xiii_anual decimal;
    ldc_ingresos_gravables decimal;
    ldc_seguro_educativo decimal;
    ldc_work decimal;
    r_pla_empleados record;
    r_pla_claves_de_renta record;
    r_pla_isr record;
begin
    if adc_monto <= 0 then
        return 0;
    end if;
    
    ldc_renta = 0;
    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    if r_pla_empleados.tipo_calculo_ir = ''N'' then
        return 0;
    end if;    
    
    if r_pla_empleados.grupo = ''E'' then
        ldc_deduccion_basica = 800;
    else
        ldc_deduccion_basica = 0;
    end if;
    
    if trim(as_tipo_de_planilla) = ''1'' then
        ldc_periodos = 52.00 + (52.00/12);
        ldc_ingresos_anuales = adc_monto * 52;
        
    elsif trim(as_tipo_de_planilla) = ''2'' then
        ldc_periodos = 24.00 + (24.00/12.00);
        ldc_ingresos_anuales = adc_monto * 24;
    
    elsif trim(as_tipo_de_planilla) = ''3'' then
        ldc_periodos = 26.00 + (26.00/12.00);
        ldc_ingresos_anuales = adc_monto * 26;
        
    elsif trim(as_tipo_de_planilla) = ''4'' then
        ldc_periodos = 13;
        ldc_ingresos_anuales = adc_monto * 12;
        
    else
        return 0;
    end if;
    
    
    ldc_xiii_anual = ldc_ingresos_anuales / 12;
    
    ldc_ingresos_gravables = ldc_ingresos_anuales - ldc_deduccion_basica + ldc_xiii_anual;
    

    if ldc_ingresos_gravables <= 11000 then
        return 0;
    elsif ldc_ingresos_gravables > 50000 then
        ldc_renta = 5850 + ((ldc_ingresos_gravables - 50000) * .25);
    else
        ldc_renta = (ldc_ingresos_gravables - 11000) * .15;
    end if;
    
-- raise exception ''ingresos gravable % periodos %'', ldc_ingresos_gravables, ldc_periodos;

    if ldc_periodos > 0 then
        ldc_renta = ldc_renta / ldc_periodos;
    end if;
    
    return ldc_renta;
end;
' language plpgsql;


create function f_periodos_pago(int4, char(7), char(2), int4) returns decimal as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_de_planilla alias for $3;
    ai_anio alias for $4;
    ldc_renta decimal;
    ldc_periodos_pago decimal;
    ldc_periodos decimal;
    ldc_deduccion_basica decimal;
    ldc_ingresos_anuales decimal;
    ldc_xiii_anual decimal;
    ldc_work decimal;
    r_pla_empleados record;
    r_pla_claves_de_renta record;
    r_work record;
    r_work_1 record;
    ld_work_1 date;
    ld_work_2 date;
    ld_work_3 date;
    ld_hasta date;
    ld_desde date;
    curs1 refcursor;
begin
    ldc_periodos_pago = 0;
    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    select Min(fecha) into ld_work_1
    from pla_preelaboradas
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and Anio(fecha) = ai_anio;
    if not found or ld_work_1 is null then
        ld_work_1 = current_date+1000;
    end if;
    
    if Anio(ld_work_1) < ai_anio then
        ld_work_1   =   f_to_date(ai_anio, 1, 1);
    end if;
    
    
    ld_work_1 = to_char(Anio(ld_work_1),''9999'')||''-''||trim(to_char(Mes(ld_work_1),''99''))||''-01'';
    
    select into ld_work_2 Min(pla_periodos.dia_d_pago) 
    from pla_periodos, pla_dinero
    where pla_periodos.id = pla_dinero.id_periodos
    and pla_periodos.year = ai_anio
    and pla_dinero.compania = ai_cia
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_periodos.tipo_de_planilla = as_tipo_de_planilla;
    if not found or ld_work_2 is null then
        ld_work_2 = current_date;
    end if;

    if ld_work_1 < ld_work_2 then
        ld_desde = ld_work_1;
    else
        ld_desde = ld_work_2;
    end if;


    select into ld_work_1 Max(pla_periodos.dia_d_pago) 
    from pla_periodos, pla_dinero
    where pla_periodos.id = pla_dinero.id_periodos
    and pla_periodos.year = ai_anio
    and pla_dinero.compania = ai_cia
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_periodos.tipo_de_planilla = as_tipo_de_planilla;
    if not found or ld_work_1 is null then
        ld_work_1 = ''1930-01-01'';
    end if;
    
    select into ld_work_2 Max(pla_vacaciones.pagar_hasta)
    from pla_vacaciones
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and Anio(pla_vacaciones.dia_d_pago) = ai_anio;
    if not found or ld_work_2 is null then
        ld_work_2 = ''1930-01-01'';
    end if;
    
    if extract(day from ld_work_2) = 30 then
        ld_work_2   =   ld_work_2 + 1;
    end if;
    
    
    if ld_work_1 > ld_work_2 then
        ld_hasta = ld_work_1;
    else
        ld_hasta = ld_work_2;
    end if;

/*
    select into r_work *
    from pla_periodos
    where compania = ai_cia
    and tipo_de_planilla = as_tipo_de_planilla
    and year = ai_anio
    and ld_hasta between desde and hasta;
    if found then
        if r_work.dia_d_pago >= ld_hasta then
            ld_hasta = r_work.dia_d_pago;
        end if;
    end if;

    
    select Max(fecha) into ld_work_1
    from pla_preelaboradas
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and Anio(fecha) = ai_anio;
    if not found or ld_work_1 is null then
        ld_work_1 = current_date;
    end if;
    
    if ld_work_1 > ld_hasta then
        ld_hasta = ld_work_1;
    end if;
*/
  
    
    ld_work_1 = null;
    select Max(fecha) into ld_work_1
    from pla_preelaboradas
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and Anio(fecha) = ai_anio;
    if not found or ld_work_1 is null then
        ld_work_1 = ''1930-01-01'';
    end if;

    if ld_work_1 > ld_hasta then
        ld_hasta = ld_work_1;
    end if;
    
    
    select into ldc_periodos count(*) 
    from pla_periodos
    where compania = ai_cia
    and tipo_de_planilla = as_tipo_de_planilla
    and year = ai_anio
    and dia_d_pago between ld_desde and ld_hasta;
    
    
/*    
    if Anio(r_pla_empleados.fecha_inicio) = ai_anio then
        select into ldc_periodos count(*) 
        from pla_periodos
        where compania = ai_cia
        and tipo_de_planilla = as_tipo_de_planilla
        and year = ai_anio
        and desde >= r_pla_empleados.fecha_inicio
        and dia_d_pago <= ld_hasta;
    else
        select into ldc_periodos count(*) 
        from pla_periodos
        where compania = ai_cia
        and tipo_de_planilla = as_tipo_de_planilla
        and year = ai_anio
        and dia_d_pago <= ld_hasta;
    end if;
*/    
    
    select count(*) into ldc_work
    from pla_preelaboradas
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and concepto = ''109''
    and Anio(fecha) = ai_anio;
    if not found then
        ldc_work = 0;
    end if;

--    and fecha < ld_desde

 --Raise Exception ''% %'', ldc_work, ld_desde;    
    
    open curs1 for select pla_dinero.tipo_de_calculo, Count(*) as periodos_xiii
                    from pla_dinero, pla_periodos
                    where pla_periodos.id = pla_dinero.id_periodos
                    and pla_periodos.year = ai_anio
                    and pla_dinero.compania = ai_cia
                    and pla_dinero.codigo_empleado = as_codigo_empleado
                    and pla_dinero.tipo_de_calculo = ''3''
                    and pla_dinero.concepto = ''109''
                    group by 1;
    fetch curs1 into r_work_1;
    if not found then
        r_work_1.periodos_xiii = 0;
    end if;

    r_work_1.periodos_xiii = r_work_1.periodos_xiii + ldc_work;
    
    if r_work_1.periodos_xiii > 3 then
        r_work_1.periodos_xiii = 3;
    end if;
    
    ldc_work  = r_work_1.periodos_xiii;
    if trim(as_tipo_de_planilla) = ''1'' then
        ldc_periodos_pago = ldc_periodos + ((ldc_work*(52/12))/3);
        
    elsif trim(as_tipo_de_planilla) = ''2'' then
            ldc_periodos_pago = ldc_periodos + ((ldc_work*2)/3);

            
    elsif trim(as_tipo_de_planilla) = ''3'' then
            ldc_periodos_pago = ldc_periodos + ((ldc_work*(26/12))/3);
            
    elsif trim(as_tipo_de_planilla) = ''4'' then
            ldc_periodos_pago = ldc_periodos + ((ldc_work*(12/12))/3);
    else
        ldc_periodos_pago = 0;
    end if;


    select into ld_work_1 Max(pla_periodos.dia_d_pago)
    from pla_dinero, pla_periodos
    where pla_periodos.id = pla_dinero.id_periodos
    and pla_periodos.year = ai_anio
    and pla_dinero.compania = ai_cia
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_dinero.tipo_de_calculo in (''1'', ''2'');
    if not found or ld_work_1 is null then
        ld_work_1 = ''1930-01-01'';
    end if;

    select into ld_work_2 Max(pla_vacaciones.pagar_hasta)
    from pla_vacaciones
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and Anio(pla_vacaciones.dia_d_pago) = ai_anio;
    if not found or ld_work_2 is null then
        ld_work_2 = ''1930-01-01'';
    end if;

    if ld_work_2 > ld_work_1 then
        ld_work_1 = ld_work_2;
    end if;

    
    select into ld_work_3 Max(pla_periodos.dia_d_pago)
    from pla_dinero, pla_periodos
    where pla_periodos.id = pla_dinero.id_periodos
    and pla_periodos.year = ai_anio
    and pla_dinero.compania = ai_cia
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_dinero.tipo_de_calculo = ''3''
    and pla_dinero.concepto = ''109'';
    if found then
        if ld_work_3 > ld_work_1 then
            select into ldc_work count(*) 
            from pla_periodos
            where compania = ai_cia
            and tipo_de_planilla = as_tipo_de_planilla
            and year = ai_anio
            and dia_d_pago between ld_work_1 and ld_work_3;
            if not found or ldc_work is null then
                ldc_work = 0;
            else
                ldc_periodos_pago = ldc_periodos_pago - ldc_work + 1;
            end if;
        end if;
    end if;


    if ldc_periodos_pago <= 0 then
        ldc_periodos_pago = 1;
    end if;
    
    return ldc_periodos_pago;
end;
' language plpgsql;




create function f_isr(int4, char(7), char(2), int4) returns decimal as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_de_planilla alias for $3;
    ai_anio alias for $4;
    ldc_renta decimal;
    ldc_periodos decimal;
    ldc_deduccion_basica decimal;
    ldc_ingresos_anuales decimal;
    ldc_xiii_anual decimal;
    ldc_periodos_pago decimal;
    ldc_acumulado_isr decimal;
    ldc_ingreso_promedio decimal;
    ldc_renta_exacta decimal;
    ldc_isr decimal;
    ldc_isr_retenido decimal;
    ldc_periodos_faltantes decimal;
    ldc_salario_proyectado decimal;
    r_pla_empleados record;
    r_pla_claves_de_renta record;
    r_pla_tipos_de_planilla record;
begin
    select into r_pla_tipos_de_planilla * from pla_tipos_de_planilla
    where compania = ai_cia
    and tipo_de_planilla = as_tipo_de_planilla;
    if not found then
        return 0;
    end if;

    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    if r_pla_empleados.tipo_calculo_ir = ''N'' then
        return 0;
    end if;    


    ldc_periodos_pago       = Round(f_periodos_pago(ai_cia, as_codigo_empleado, as_tipo_de_planilla, ai_anio),8);
    ldc_acumulado_isr       = f_acumulado_para(ai_cia, as_codigo_empleado, ''106'', ai_anio);
    ldc_isr_retenido        = f_concepto_pagado(ai_cia, as_codigo_empleado, ''106'', ai_anio);
    ldc_ingreso_promedio    = ldc_acumulado_isr / ldc_periodos_pago;
    if ai_anio >= 2010 then
        ldc_renta_exacta        = f_renta_exacta_2010(ai_cia, as_codigo_empleado, as_tipo_de_planilla, ldc_ingreso_promedio);
    else
        ldc_renta_exacta        = f_renta_exacta(ai_cia, as_codigo_empleado, as_tipo_de_planilla, ldc_ingreso_promedio);
    end if;
    ldc_isr                     = (ldc_renta_exacta * ldc_periodos_pago) + ldc_isr_retenido;


/*    
    if ((r_pla_tipos_de_planilla.tipo_de_planilla = ''1'' and r_pla_tipos_de_planilla.planilla_actual = 52)
        or (r_pla_tipos_de_planilla.tipo_de_planilla = ''2'' and r_pla_tipos_de_planilla.planilla_actual = 24)
        or (r_pla_tipos_de_planilla.tipo_de_planilla = ''3'' and r_pla_tipos_de_planilla.planilla_actual = 26) 
        or (r_pla_tipos_de_planilla.tipo_de_planilla = ''4'' and r_pla_tipos_de_planilla.planilla_actual = 12)) 
        and Anio(r_pla_empleados.fecha_inicio) < ai_anio then
        ldc_isr = f_isr_final(ai_cia, as_codigo_empleado, as_tipo_de_planilla, ai_anio);
    else
        ldc_periodos_pago       = Round(f_periodos_pago(ai_cia, as_codigo_empleado, as_tipo_de_planilla, ai_anio),8);
        ldc_acumulado_isr       = f_acumulado_para(ai_cia, as_codigo_empleado, ''106'', ai_anio);
        ldc_isr_retenido        = f_concepto_pagado(ai_cia, as_codigo_empleado, ''106'', ai_anio);
        ldc_ingreso_promedio    = ldc_acumulado_isr / ldc_periodos_pago;
        if ai_anio >= 2010 then
            ldc_renta_exacta        = f_renta_exacta_2010(ai_cia, as_codigo_empleado, as_tipo_de_planilla, ldc_ingreso_promedio);
        else
            ldc_renta_exacta        = f_renta_exacta(ai_cia, as_codigo_empleado, as_tipo_de_planilla, ldc_ingreso_promedio);
        end if;
        ldc_isr                     = (ldc_renta_exacta * ldc_periodos_pago) + ldc_isr_retenido;
    end if;
*/
    
    if ai_cia = 1193 then
        if Anio(r_pla_empleados.fecha_inicio) = ai_anio and r_pla_empleados.tipo_de_planilla = ''2'' then
            ldc_periodos_faltantes  =   26 - ldc_periodos_pago;
            ldc_salario_proyectado  =   (r_pla_empleados.salario_bruto * ldc_periodos_faltantes) + ldc_acumulado_isr;
            
            if ldc_salario_proyectado < 11000 then
                ldc_isr = 0;
            end if;
        end if;
    end if;
    
    return ldc_isr;
end;
' language plpgsql;



create function f_isr_final(int4, char(7), char(2), int4) returns decimal as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_de_planilla alias for $3;
    ai_year alias for $4;
    ldc_renta decimal;
    ldc_periodos decimal;
    ldc_deduccion_basica decimal;
    ldc_ingresos_anuales decimal;
    ldc_ingresos_gravables decimal;
    ldc_xiii_anual decimal;
    ldc_isr_retenido decimal;
    ldc_xiii decimal;
    ldc_se decimal;
    r_pla_empleados record;
    r_pla_claves_de_renta record;
    r_pla_isr record;
begin
    ldc_renta = 0;
    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    if r_pla_empleados.tipo_calculo_ir = ''N'' then
        return 0;
    end if;    
    
    select into r_pla_claves_de_renta * from pla_claves_de_renta
    where grupo = r_pla_empleados.grupo
    and dependientes = r_pla_empleados.dependientes;
    if not found then
        return 0;
    end if;
    
    ldc_deduccion_basica = r_pla_claves_de_renta.deducible_basico + 
                            r_pla_claves_de_renta.deducible_x_esposa + 
                            (r_pla_claves_de_renta.dependientes * r_pla_claves_de_renta.deducible_x_dependte);
                            
    
    ldc_ingresos_gravables = f_acumulado_para(ai_cia, as_codigo_empleado, ''106'', ai_year);
    ldc_xiii = f_concepto_pagado(ai_cia, as_codigo_empleado, ''109'', ai_year);
    ldc_se = f_concepto_pagado(ai_cia, as_codigo_empleado, ''104'', ai_year);
    ldc_isr_retenido = f_concepto_pagado(ai_cia, as_codigo_empleado, ''106'', ai_year);
    
    ldc_ingresos_gravables = ldc_ingresos_gravables - ldc_deduccion_basica - ldc_se + ldc_xiii;
    
    
    if ldc_ingresos_gravables > 2000000 then
        ldc_renta = ldc_ingresos_gravables * .27;
            
    elsif ldc_ingresos_gravables <= 0 then
            return 0;
            
    else
        select into r_pla_isr * from pla_isr
        where ldc_ingresos_gravables between sbruto_inicial and sbruto_final;
        if not found then
            return 0;
        else
            ldc_renta = r_pla_isr.renta_fija + 
                        ((ldc_ingresos_gravables - r_pla_isr.sbruto_inicial) * 
                        (r_pla_isr.excedente_aplicar/100));
        end if;        
    end if;
    
    ldc_renta = ldc_renta + ldc_isr_retenido;
    if ldc_renta <= 0 then
        ldc_renta = 0;
    end if;
        
    return ldc_renta;
end;
' language plpgsql;




create function f_isr_causado(int4, char(7), char(2), int4) returns decimal as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_de_planilla alias for $3;
    ai_anio alias for $4;
    ldc_renta decimal;
    ldc_periodos decimal;
    ldc_deduccion_basica decimal;
    ldc_ingresos_anuales decimal;
    ldc_xiii_anual decimal;
    ldc_periodos_pago decimal;
    ldc_acumulado_isr decimal;
    ldc_ingreso_promedio decimal;
    ldc_renta_exacta decimal;
    ldc_isr decimal;
    ldc_isr_retenido decimal;
    ldc_periodos_faltantes decimal;
    ldc_salario_proyectado decimal;
    r_pla_empleados record;
    r_pla_claves_de_renta record;
    r_pla_tipos_de_planilla record;
begin
    select into r_pla_tipos_de_planilla * from pla_tipos_de_planilla
    where compania = ai_cia
    and tipo_de_planilla = as_tipo_de_planilla;
    if not found then
        return 0;
    end if;

    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    if r_pla_empleados.tipo_calculo_ir = ''N'' then
        return 0;
    end if;    
    

    ldc_periodos_pago       = Round(f_periodos_pago(ai_cia, as_codigo_empleado, as_tipo_de_planilla, ai_anio),8);
    ldc_acumulado_isr       = f_acumulado_para(ai_cia, as_codigo_empleado, ''106'', ai_anio);
    ldc_isr_retenido        = f_concepto_pagado(ai_cia, as_codigo_empleado, ''106'', ai_anio);
    ldc_ingreso_promedio    = ldc_acumulado_isr / ldc_periodos_pago;
    if ai_anio >= 2010 then
        ldc_renta_exacta        = f_renta_exacta_2010(ai_cia, as_codigo_empleado, as_tipo_de_planilla, ldc_ingreso_promedio);
    else
        ldc_renta_exacta        = f_renta_exacta(ai_cia, as_codigo_empleado, as_tipo_de_planilla, ldc_ingreso_promedio);
    end if;

    ldc_isr                     = (ldc_renta_exacta * ldc_periodos_pago);
    
--raise exception ''periodos % acumulado % % %'', ldc_periodos_pago, ldc_acumulado_isr, ldc_ingreso_promedio, ldc_renta_exacta;
    

/*    
    if ((r_pla_tipos_de_planilla.tipo_de_planilla = ''1'' and r_pla_tipos_de_planilla.planilla_actual = 52)
        or (r_pla_tipos_de_planilla.tipo_de_planilla = ''2'' and r_pla_tipos_de_planilla.planilla_actual = 24)
        or (r_pla_tipos_de_planilla.tipo_de_planilla = ''3'' and r_pla_tipos_de_planilla.planilla_actual = 26) 
        or (r_pla_tipos_de_planilla.tipo_de_planilla = ''4'' and r_pla_tipos_de_planilla.planilla_actual = 12)) 
        and Anio(r_pla_empleados.fecha_inicio) < ai_anio then
        ldc_isr = f_isr_final(ai_cia, as_codigo_empleado, as_tipo_de_planilla, ai_anio);
    else
        ldc_periodos_pago       = Round(f_periodos_pago(ai_cia, as_codigo_empleado, as_tipo_de_planilla, ai_anio),8);
        ldc_acumulado_isr       = f_acumulado_para(ai_cia, as_codigo_empleado, ''106'', ai_anio);
        ldc_isr_retenido        = f_concepto_pagado(ai_cia, as_codigo_empleado, ''106'', ai_anio);
        ldc_ingreso_promedio    = ldc_acumulado_isr / ldc_periodos_pago;
        if ai_anio >= 2010 then
            ldc_renta_exacta        = f_renta_exacta_2010(ai_cia, as_codigo_empleado, as_tipo_de_planilla, ldc_ingreso_promedio);
        else
            ldc_renta_exacta        = f_renta_exacta(ai_cia, as_codigo_empleado, as_tipo_de_planilla, ldc_ingreso_promedio);
        end if;
        ldc_isr                     = (ldc_renta_exacta * ldc_periodos_pago);
    end if;
*/
    
    if ai_cia = 1193 then
        if Anio(r_pla_empleados.fecha_inicio) = ai_anio and r_pla_empleados.tipo_de_planilla = ''2'' then
            ldc_periodos_faltantes  =   26 - ldc_periodos_pago;
            ldc_salario_proyectado  =   (r_pla_empleados.salario_bruto * ldc_periodos_faltantes) + ldc_acumulado_isr;
            if ldc_salario_proyectado < 11000 then
                ldc_isr = 0;
            end if;
        end if;
    end if;
    
    return ldc_isr;
end;
' language plpgsql;

create function f_renta_exacta(int4, char(7), char(2), decimal) returns decimal as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    as_tipo_de_planilla alias for $3;
    adc_monto alias for $4;
    ldc_renta decimal;
    ldc_periodos decimal;
    ldc_deduccion_basica decimal;
    ldc_ingresos_anuales decimal;
    ldc_xiii_anual decimal;
    ldc_ingresos_gravables decimal;
    ldc_seguro_educativo decimal;
    ldc_work decimal;
    r_pla_empleados record;
    r_pla_claves_de_renta record;
    r_pla_isr record;
begin
    ldc_renta = 0;
    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    if adc_monto <= 0 then
        return 0;
    end if;
    
    if r_pla_empleados.tipo_calculo_ir = ''N'' then
        return 0;
    end if;    
    
    
    select into r_pla_claves_de_renta * from pla_claves_de_renta
    where grupo = r_pla_empleados.grupo
    and dependientes = r_pla_empleados.dependientes;
    if not found then
        return 0;
    end if;

    ldc_deduccion_basica = r_pla_claves_de_renta.deducible_basico + 
                            r_pla_claves_de_renta.deducible_x_esposa + 
                            (r_pla_claves_de_renta.dependientes * r_pla_claves_de_renta.deducible_x_dependte);
                            
    
    if trim(as_tipo_de_planilla) = ''1'' then
        ldc_periodos = 52 + (52/12);
        ldc_ingresos_anuales = adc_monto * 52;
        
    elsif trim(as_tipo_de_planilla) = ''2'' then
        ldc_periodos = 24 + (24/12);
        ldc_ingresos_anuales = adc_monto * 24;
    
    elsif trim(as_tipo_de_planilla) = ''3'' then
        ldc_periodos = 26 + (26/12);
        ldc_ingresos_anuales = adc_monto * 26;
        
    elsif trim(as_tipo_de_planilla) = ''4'' then
        ldc_periodos = 13;
        ldc_ingresos_anuales = adc_monto * 12;
        
    else
        return 0;
    end if;
    
    
    ldc_xiii_anual = ldc_ingresos_anuales / 12;
    
    ldc_seguro_educativo = ldc_ingresos_anuales * .0125;
    
    ldc_ingresos_gravables = ldc_ingresos_anuales - ldc_deduccion_basica - ldc_seguro_educativo + ldc_xiii_anual;
    
    
    if ldc_ingresos_gravables > 2000000 then
        ldc_renta = ldc_ingresos_gravables * .30;
            
    elsif ldc_ingresos_gravables <= 0 then
            return 0;
            
    else
        select into r_pla_isr * from pla_isr
        where ldc_ingresos_gravables >= sbruto_inicial and ldc_ingresos_gravables < sbruto_final;
        if not found then
            return 0;
        else
            ldc_work = (ldc_ingresos_gravables - r_pla_isr.sbruto_inicial) * (r_pla_isr.excedente_aplicar/100);
            
            ldc_renta = r_pla_isr.renta_fija + 
                        ((ldc_ingresos_gravables - r_pla_isr.sbruto_inicial) * 
                        (r_pla_isr.excedente_aplicar/100));
        end if;        
    end if;
    
/*
    if as_codigo_empleado = ''070261'' then
        raise exception ''% % %'',r_pla_isr.excedente_aplicar, ldc_renta, ldc_work;
    end if;
*/    
    
    if ldc_periodos > 0 then
        ldc_renta = ldc_renta / ldc_periodos;
    end if;
    
    return ldc_renta;
end;
' language plpgsql;



create view v_status_renta as
SELECT pla_companias.nombre as nombre_cia, pla_companias.compania, 
Trim(pla_empleados.nombre) || ' ' || Trim(pla_empleados.apellido) as nombre_empleado, 
pla_empleados.codigo_empleado, 
Round(f_periodos_pago(pla_empleados.compania, pla_empleados.codigo_empleado, pla_empleados.tipo_de_planilla, Cast(Anio(current_date) as int4)),2) as periodos_pagos,
Round(f_acumulado_para(pla_empleados.compania, pla_empleados.codigo_empleado, '106', Cast(Anio(current_date) as int4) ),2) as acumulado,
Round(f_isr_causado(pla_empleados.compania,pla_empleados.codigo_empleado,pla_empleados.tipo_de_planilla,Cast(Anio(current_date) as int4)),2) as impuesto_causado,
-Round(f_concepto_pagado(pla_empleados.compania, pla_empleados.codigo_empleado, '106', Cast(Anio(current_date) as int4)),2) as impuesto_retenido,
Round(f_isr_causado(pla_empleados.compania,pla_empleados.codigo_empleado,pla_empleados.tipo_de_planilla,Cast(Anio(current_date) as int4)) 
 + f_concepto_pagado(pla_empleados.compania, pla_empleados.codigo_empleado, '106', Cast(Anio(current_date) as int4)),2) as renta_pagar
FROM pla_empleados, pla_companias
WHERE pla_empleados.compania = pla_companias.compania
and pla_empleados.fecha_terminacion_real Is Null 
and pla_empleados.status In ('A','V')
ORDER BY 1, 2, 3;
