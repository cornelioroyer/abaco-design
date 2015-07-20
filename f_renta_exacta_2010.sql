drop function f_renta_exacta_2010(int4, char(7), char(2), decimal) cascade;

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
    
    ldc_ingresos_gravables = ldc_ingresos_anuales - ldc_deduccion_basica - ldc_xiii_anual;
    

    if ldc_ingresos_gravables <= 11000 then
        return 0;
    elsif ldc_ingresos_gravables > 50000 then
        ldc_renta = 5850 + ((ldc_ingresos_gravables - 50000) * .25);
    else
        ldc_renta = (ldc_ingresos_gravables - 11000) * .15;
    end if;
    
    if ldc_periodos > 0 then
        ldc_renta = ldc_renta / ldc_periodos;
    end if;
    
    return ldc_renta;
end;
' language plpgsql;

