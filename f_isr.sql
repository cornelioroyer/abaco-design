
drop function f_isr(int4, char(7), char(2), int4) cascade;
drop function f_isr_causado(int4, char(7), char(2), int4) cascade;


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
    
    if ai_cia = 1193 then
        if Anio(r_pla_empleados.fecha_inicio) = ai_anio and r_pla_empleados.tipo_de_planilla = ''2'' then
            ldc_periodos_faltantes  =   26 - ldc_periodos_pago;
            ldc_salario_proyectado  =   (r_pla_empleados.salario_bruto * ldc_periodos_faltantes) + ldc_acumulado_isr;
            
            
            if ldc_salario_proyectado < 11000 then
-- raise exception ''salario proyectado %'', ldc_salario_proyectado;
                ldc_isr = 0;
            end if;
        end if;
    end if;
    
    return ldc_isr;
end;
' language plpgsql;
