drop function f_renta_exacta_2010(char(2), char(7), char(2), decimal) cascade;
drop function f_renta_causada(char(2), char(7), integer) cascade;
drop function f_periodos_pagos(char(2), char(7), integer) cascade;
drop function f_renta(char(2), char(7), char(2), char(2), integer, integer) cascade;
drop function f_renta_exacta(char(2), char(7), char(2), decimal) cascade;


create function f_renta_exacta(char(2), char(7), char(2), decimal) returns decimal as '
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
    r_rhuempl record;
    r_rhuclvim record;
    r_nomimrta record;
begin
    ldc_renta = 0;
    if Anio(current_date) >= 2010 then
        return f_renta_exacta_2010(ai_cia, as_codigo_empleado, as_tipo_de_planilla, adc_monto);
    end if;
    
    select into r_rhuempl * from rhuempl
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    select into r_rhuclvim * from rhuclvim
    where grup_impto_renta = r_rhuempl.grup_impto_renta
    and num_dependiente = r_rhuempl.num_dependiente;
    if not found then
        return 0;
    end if;

    ldc_deduccion_basica = r_rhuclvim.deducible_basico + 
                            r_rhuclvim.deducible_x_esposa + 
                            (r_rhuclvim.num_dependiente * r_rhuclvim.deducible_x_dependte);
                            
    
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
        select into r_nomimrta * from nomimrta
        where ldc_ingresos_gravables >= sbruto_inicial and ldc_ingresos_gravables < sbruto_final;
        if not found then
            return 0;
        else
            ldc_work = (ldc_ingresos_gravables - r_nomimrta.sbruto_inicial) * (r_nomimrta.excedente_aplicar/100);
            
            ldc_renta = r_nomimrta.renta_fija + 
                        ((ldc_ingresos_gravables - r_nomimrta.sbruto_inicial) * 
                        (r_nomimrta.excedente_aplicar/100));
        end if;        
    end if;
    
    
    if ldc_periodos > 0 then
        ldc_renta = ldc_renta / ldc_periodos;
    end if;
    
    return ldc_renta;
end;
' language plpgsql;


create function f_renta(char(2), char(7), char(2), char(2), integer, integer) returns integer as '
declare
    ac_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ac_tipo_calculo alias for $3;
    ac_tipo_planilla alias for $4;
    ai_year alias for $5;
    ai_numero_planilla alias for $6;
    ldc_renta_causada decimal(10,2);
    ldc_renta_pagada decimal(10,2);
    ldc_renta_pendiente decimal(10,2);
    ldc_porcentaje decimal(10,2);
    ldc_neto decimal;
    ldc_gto_repre decimal;
    ldc_gto_repre_anual decimal;
    ldc_work decimal;
    r_rhuempl record;
    r_nomctrac record;
    r_nomtpla2 record;
begin
    select into r_rhuempl * from rhuempl
    where compania = ac_compania
    and codigo_empleado = ac_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    select into r_nomtpla2 * from nomtpla2
    where tipo_planilla = ac_tipo_planilla
    and year = ai_year
    and numero_planilla = ai_numero_planilla;
    if not found then
        return 0;
    end if;
    
    if r_nomtpla2.mes is null then
        r_nomtpla2.mes = Mes(r_nomtpla2.dia_d_pago);
    end if;
    
    delete from nomctrac
    where compania = ac_compania
    and codigo_empleado = ac_codigo_empleado
    and tipo_calculo = ac_tipo_calculo
    and tipo_planilla = ac_tipo_planilla
    and year = ai_year
    and numero_planilla = ai_numero_planilla
    and cod_concepto_planilla in (''106'', ''310'')
    and forma_de_registro = ''A'';
    
    ldc_gto_repre = 0;
    select into ldc_gto_repre sum(monto)
    from nomctrac
    where compania = ac_compania
    and codigo_empleado = ac_codigo_empleado
    and tipo_calculo = ac_tipo_calculo
    and tipo_planilla = ac_tipo_planilla
    and year = ai_year
    and numero_planilla = ai_numero_planilla
    and cod_concepto_planilla in (''125'', ''200'', ''107'');
    if ldc_gto_repre is null then
        ldc_gto_repre = 0;
    end if;
    
    if ldc_gto_repre > 0 then
        ldc_gto_repre_anual = 0;
        select into ldc_gto_repre_anual sum(monto)
        from nomctrac
        where compania = ac_compania
        and codigo_empleado = ac_codigo_empleado
        and tipo_planilla = ac_tipo_planilla
        and year = ai_year
        and cod_concepto_planilla in (''125'', ''200'', ''107'');
        if ldc_gto_repre_anual is null then
            ldc_gto_repre_anual = 0;
        end if;
    
        if ldc_gto_repre_anual >= 25000 then
            ldc_porcentaje = 0.15;
        else
            ldc_porcentaje = 0.10;
        end if;
        
        select into r_nomctrac *
        from nomctrac
        where compania = ac_compania
        and codigo_empleado = ac_codigo_empleado
        and tipo_calculo = ac_tipo_calculo
        and tipo_planilla = ac_tipo_planilla
        and year = ai_year
        and numero_planilla = ai_numero_planilla
        and cod_concepto_planilla in (''310'');
        if not found then
            insert into nomctrac(compania, codigo_empleado, tipo_calculo, tipo_planilla,
                            year, numero_planilla, numero_documento, cod_concepto_planilla,
                            mes, usuario, fecha_actualiza, status, forma_de_registro, monto, descripcion)
            values(ac_compania, ac_codigo_empleado, ac_tipo_calculo, ac_tipo_planilla,
                    ai_year, ai_numero_planilla, ''0'', ''310'', r_nomtpla2.mes, 
                    current_user, current_date, ''R'', ''A'', ldc_gto_repre * ldc_porcentaje, ''IMPUESTO SOBRE LA RENTA DEL GTO. DE REPRE.'' );
        end if;
    end if;
    
    ldc_renta_pagada = 0;
    select into ldc_renta_pagada sum(monto)
    from nomctrac
    where compania = ac_compania
    and codigo_empleado = ac_codigo_empleado
    and cod_concepto_planilla = ''106''
    and year = ai_year;
    
    ldc_work = 0;
    select into ldc_work sum(monto)
    from pla_ajuste_renta
    where compania = ac_compania
    and codigo_empleado = ac_codigo_empleado
    and anio = ai_year;
    
    if ldc_work is null then
        ldc_work = 0;
    end if;

    if not found or ldc_renta_pagada is null then
        ldc_renta_pagada = 0;
    end if;
    
    ldc_renta_causada   = f_renta_causada(ac_compania, ac_codigo_empleado, ai_year);
    
    ldc_renta_pendiente = ldc_renta_causada - ldc_renta_pagada - ldc_work;
    
    if ldc_renta_pendiente = 0 then
        return 1;
    end if;
    
    if ldc_renta_pendiente > 0 then
        ldc_neto = 0;
        select into ldc_neto sum(nomctrac.monto*nomconce.signo)
        from nomctrac, nomconce
        where nomctrac.cod_concepto_planilla = nomconce.cod_concepto_planilla
        and nomctrac.compania = ac_compania
        and nomctrac.codigo_empleado = ac_codigo_empleado
        and nomctrac.tipo_calculo = ac_tipo_calculo
        and nomctrac.tipo_planilla = ac_tipo_planilla
        and nomctrac.numero_planilla = ai_numero_planilla
        and nomctrac.year = ai_year;
        if ldc_neto is null then
            ldc_neto = 0;
        end if;
        
        if ldc_renta_pendiente >= ldc_neto then
            ldc_renta_pendiente = ldc_neto * .75;
        end if;
        
        select into r_nomctrac *
        from nomctrac
        where compania = ac_compania
        and codigo_empleado = ac_codigo_empleado
        and tipo_calculo = ac_tipo_calculo
        and tipo_planilla = ac_tipo_planilla
        and year = ai_year
        and numero_planilla = ai_numero_planilla
        and cod_concepto_planilla in (''106'');
        if not found then
            insert into nomctrac(compania, codigo_empleado, tipo_calculo, tipo_planilla,
                            year, numero_planilla, numero_documento, cod_concepto_planilla,
                            mes, usuario, fecha_actualiza, status, forma_de_registro, monto, descripcion)
            values(ac_compania, ac_codigo_empleado, ac_tipo_calculo, ac_tipo_planilla,
                    ai_year, ai_numero_planilla, ''0'', ''106'', r_nomtpla2.mes, 
                    current_user, current_date, ''R'', ''A'', ldc_renta_pendiente, ''IMPUESTO SOBRE LA RENTA'');
        end if;
        
    else
        ldc_renta_pendiente = -ldc_renta_pendiente;  
        ldc_work = 0;
        select sum(monto) into ldc_work
        from nomctrac, nomtpla2
        where nomctrac.tipo_planilla = nomtpla2.tipo_planilla
        and nomctrac.year = nomtpla2.year
        and nomctrac.numero_planilla = nomtpla2.numero_planilla
        and nomctrac.compania = ac_compania
        and codigo_empleado = ac_codigo_empleado
        and nomctrac.year = ai_year
        and Mes(nomtpla2.dia_d_pago) = Mes(r_nomtpla2.dia_d_pago)
        and cod_concepto_planilla in (''106'');
        if ldc_work is null then
            ldc_work = 0;
        end if;
    
        if ldc_work > ldc_renta_pendiente then
            ldc_renta_pendiente = -ldc_renta_pendiente;
              
            select into r_nomctrac *
            from nomctrac
            where compania = ac_compania
            and codigo_empleado = ac_codigo_empleado
            and tipo_calculo = ac_tipo_calculo
            and tipo_planilla = ac_tipo_planilla
            and year = ai_year
            and numero_planilla = ai_numero_planilla
            and cod_concepto_planilla in (''106'');
            if not found then
                insert into nomctrac(compania, codigo_empleado, tipo_calculo, tipo_planilla,
                                year, numero_planilla, numero_documento, cod_concepto_planilla,
                                mes, usuario, fecha_actualiza, status, forma_de_registro, monto, descripcion)
                values(ac_compania, ac_codigo_empleado, ac_tipo_calculo, ac_tipo_planilla,
                        ai_year, ai_numero_planilla, ''0'', ''106'', r_nomtpla2.mes, 
                        current_user, current_date, ''R'', ''A'', ldc_renta_pendiente, ''IMPUESTO SOBRE LA RENTA'');
            end if;
        end if;        
    end if;

    return 1;
end;
' language plpgsql;


create function f_periodos_pagos(char(2), char(7), integer) returns decimal as '
declare
    ac_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ai_year alias for $3;
    r_rhuempl record;
    r_nomtpla2 record;
    r_nomtpla2_xiii record;
    li_numero_planilla integer;
    li_numero_planilla_xiii integer;
    li_periodos_pagos decimal;
    li_xiii_pagos decimal;
    ldc_periodos_pagos decimal;
    ldc_renta_causada decimal;
    ldc_acumulado decimal;
    ldc_renta_exacta decimal;
    ldc_periodos decimal;
    ldc_ingresos_promedios decimal;
    ld_vacacion_hasta date;
    ld_hasta date;
begin
    ldc_periodos_pagos = 0;
    select into r_rhuempl * from rhuempl
    where compania = ac_compania
    and codigo_empleado = ac_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    li_numero_planilla = 0;
    select into li_numero_planilla Max(numero_planilla)
    from nomctrac
    where compania = r_rhuempl.compania
    and codigo_empleado = r_rhuempl.codigo_empleado
    and tipo_calculo <> ''3''
    and year = ai_year;
    if not found then
        return 0;
    end if;
    
    li_numero_planilla_xiii = 0;
    select into li_numero_planilla_xiii Max(numero_planilla)
    from nomctrac
    where compania = r_rhuempl.compania
    and codigo_empleado = r_rhuempl.codigo_empleado
    and tipo_calculo = ''3''
    and year = ai_year;
    if not found or li_numero_planilla_xiii is null then
        li_numero_planilla_xiii = 0;
    end if;
    
    if li_numero_planilla_xiii > 0 then
        select into r_nomtpla2_xiii * from nomtpla2
        where tipo_planilla = r_rhuempl.tipo_planilla
        and year = ai_year
        and numero_planilla = li_numero_planilla_xiii;
        if not found then
            return 0;
        end if;
    end if;    
    
    select into r_nomtpla2 * from nomtpla2
    where tipo_planilla = r_rhuempl.tipo_planilla
    and year = ai_year
    and numero_planilla = li_numero_planilla;
    if not found then
        return 0;
    end if;
    
    select into ld_vacacion_hasta Max(pagar_hasta)
    from pla_vacacion
    where compania = r_rhuempl.compania
    and codigo_empleado = r_rhuempl.codigo_empleado
    and pagar_hasta > r_nomtpla2.dia_d_pago;
    if ld_vacacion_hasta is null then
        ld_hasta = r_nomtpla2.dia_d_pago;
    else
        ld_hasta = ld_vacacion_hasta;
    end if;

    
    if Anio(r_rhuempl.fecha_inicio) = ai_year then
        li_periodos_pagos = 0;
        select into li_periodos_pagos Count(*)
        from nomtpla2
        where tipo_planilla = r_rhuempl.tipo_planilla
        and year = ai_year
        and dia_d_pago between r_rhuempl.fecha_inicio and ld_hasta;
        if not found or li_periodos_pagos is null then
            li_periodos_pagos = 0;
        end if;
        
--        raise exception ''%'',li_periodos_pagos;
        
        if li_numero_planilla_xiii > 0 then
            if r_nomtpla2_xiii.dia_d_pago > ld_hasta then
                ld_hasta = r_nomtpla2_xiii.dia_d_pago;
            end if;
        end if;
        
        
        li_xiii_pagos = 0;
        select into li_xiii_pagos count(*)
        from nomctrac, nomtpla2
        where nomctrac.tipo_planilla = nomtpla2.tipo_planilla
        and nomctrac.year = nomtpla2.year
        and nomctrac.numero_planilla = nomtpla2.numero_planilla
        and compania = r_rhuempl.compania
        and codigo_empleado = r_rhuempl.codigo_empleado
        and tipo_calculo = ''3''
        and cod_concepto_planilla = ''103''
        and nomctrac.year = ai_year
        and nomtpla2.dia_d_pago >= r_rhuempl.fecha_inicio;
        if not found or li_xiii_pagos is null then
            li_xiii_pagos = 0;
        end if;
        
        ldc_acumulado = 0;
        select into ldc_acumulado sum(monto) from v_pla_acumulados
        where compania = r_rhuempl.compania
        and codigo_empleado = r_rhuempl.codigo_empleado
        and fecha between r_rhuempl.fecha_inicio and ld_hasta
        and anio = ai_year
        and cod_concepto_planilla = ''106''
        and descripcion <> ''RIESGOS PROF.'';
        if not found or ldc_acumulado is null then
            return 0;
        end if;
        
    else
        li_periodos_pagos = 0;
        select into li_periodos_pagos Count(*)
        from nomtpla2
        where tipo_planilla = r_rhuempl.tipo_planilla
        and year = ai_year
        and dia_d_pago <= ld_hasta;
        if not found or li_periodos_pagos is null then
            li_periodos_pagos = 0;
        end if;


        if li_numero_planilla_xiii > 0 then
            if r_nomtpla2_xiii.dia_d_pago > ld_hasta then
                ld_hasta = r_nomtpla2_xiii.dia_d_pago;
            end if;
        end if;
        
        li_xiii_pagos = 0;
        select into li_xiii_pagos count(*)
        from nomctrac, nomtpla2
        where nomctrac.tipo_planilla = nomtpla2.tipo_planilla
        and nomctrac.year = nomtpla2.year
        and nomctrac.numero_planilla = nomtpla2.numero_planilla
        and compania = r_rhuempl.compania
        and codigo_empleado = r_rhuempl.codigo_empleado
        and tipo_calculo = ''3''
        and cod_concepto_planilla = ''103''
        and nomctrac.year = ai_year
        and nomtpla2.dia_d_pago <= ld_hasta;
        if not found or li_xiii_pagos is null then
            li_xiii_pagos = 0;
        end if;
        
        ldc_acumulado = 0;
        select into ldc_acumulado sum(monto) from v_pla_acumulados
        where compania = r_rhuempl.compania
        and codigo_empleado = r_rhuempl.codigo_empleado
        and fecha <= ld_hasta
        and anio = ai_year
        and cod_concepto_planilla = ''106''
        and descripcion <> ''RIESGOS PROF.'';
        if not found or ldc_acumulado is null then
            return 0;
        end if;
        
    end if;

    ldc_periodos = 0.000;
    
    if r_rhuempl.tipo_planilla = ''1'' then
        ldc_periodos = li_periodos_pagos + ((li_xiii_pagos * (52.00/12.00)) / 3);
        
    elsif r_rhuempl.tipo_planilla = ''2'' then
        ldc_periodos = li_periodos_pagos + ((li_xiii_pagos * 2.00) / 3.00);
        
    elsif r_rhuempl.tipo_planilla = ''3'' then
        ldc_periodos = li_periodos_pagos + ((li_xiii_pagos * (26.00/12.00)) / 3.00);
    else
        ldc_periodos = li_periodos_pagos + (li_xiii_pagos/3);
    end if;
    
    return ldc_periodos;
end;
' language plpgsql;



create function f_renta_causada(char(2), char(7), integer) returns decimal as '
declare
    ac_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ai_year alias for $3;
    r_rhuempl record;
    r_nomtpla2 record;
    li_numero_planilla integer;
    li_periodos_pagos integer;
    li_xiii_pagos integer;
    ldc_periodos_pagos decimal;
    ldc_renta_causada decimal;
    ldc_renta_pendiente decimal;
    ldc_acumulado decimal;
    ldc_renta_exacta decimal;
    ldc_periodos decimal;
    ldc_ingresos_promedios decimal;
    ld_vacacion_hasta date;
    ld_hasta date;
begin
    select into r_rhuempl * from rhuempl
    where compania = ac_compania
    and codigo_empleado = ac_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    li_numero_planilla = 0;
    select into li_numero_planilla Max(numero_planilla)
    from nomctrac
    where compania = r_rhuempl.compania
    and codigo_empleado = r_rhuempl.codigo_empleado
    and year = ai_year;
    if not found then
        return 0;
    end if;
    
    select into r_nomtpla2 * from nomtpla2
    where tipo_planilla = r_rhuempl.tipo_planilla
    and year = ai_year
    and numero_planilla = li_numero_planilla;
    if not found then
        return 0;
    end if;
    
    select into ld_vacacion_hasta Max(pagar_hasta)
    from pla_vacacion
    where compania = r_rhuempl.compania
    and codigo_empleado = r_rhuempl.codigo_empleado
    and pagar_hasta > r_nomtpla2.dia_d_pago;
    if ld_vacacion_hasta is null then
        ld_hasta = r_nomtpla2.dia_d_pago;
    else
        ld_hasta = ld_vacacion_hasta;
    end if;

    
    if Anio(r_rhuempl.fecha_inicio) = ai_year then
        
        ldc_acumulado = 0;
        select into ldc_acumulado sum(monto) from v_pla_acumulados
        where compania = r_rhuempl.compania
        and codigo_empleado = r_rhuempl.codigo_empleado
        and fecha between r_rhuempl.fecha_inicio and ld_hasta
        and anio = ai_year
        and cod_concepto_planilla = ''106''
        and descripcion <> ''RIESGOS PROF.'';
        if not found or ldc_acumulado is null then
            return 0;
        end if;
        
    else
        ldc_acumulado = 0;
        select into ldc_acumulado sum(monto) from v_pla_acumulados
        where compania = r_rhuempl.compania
        and codigo_empleado = r_rhuempl.codigo_empleado
        and fecha <= ld_hasta
        and anio = ai_year
        and cod_concepto_planilla = ''106''
        and descripcion <> ''RIESGOS PROF.'';
        if not found or ldc_acumulado is null then
            return 0;
        end if;
        
    end if;

    
    ldc_periodos_pagos      = f_periodos_pagos(ac_compania, ac_codigo_empleado, ai_year);

    ldc_ingresos_promedios  = ldc_acumulado / ldc_periodos_pagos;

    
    ldc_renta_exacta        = f_renta_exacta_2010(ac_compania, ac_codigo_empleado, 
                                r_rhuempl.tipo_planilla, ldc_ingresos_promedios);
    
    
    ldc_renta_causada       =   ldc_renta_exacta * ldc_periodos_pagos;
    
    return ldc_renta_causada;
end;
' language plpgsql;


create function f_renta_exacta_2010(char(2), char(7), char(2), decimal) returns decimal as '
declare
    ac_compania alias for $1;
    ac_codigo_empleado alias for $2;
    ac_tipo_de_planilla alias for $3;
    adc_monto alias for $4;
    r_rhuempl record;
    ldc_periodos decimal(10,2);
    ldc_ingresos_anuales decimal(10,2);
    ldc_renta_anual decimal(10,2);
    ldc_ingresos_gravables decimal(10,2);
    ldc_deduccion_basica decimal(10,2);
    ldc_xiii_anual decimal(10,2);
    ldc_seguro_educativo decimal(10,2);
begin
    select into r_rhuempl * from rhuempl
    where compania = ac_compania
    and codigo_empleado = ac_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    if trim(ac_tipo_de_planilla) = ''1'' then
        ldc_periodos            = 52 + (52/12);
        ldc_ingresos_anuales    = adc_monto * 52;
        
    elsif trim(ac_tipo_de_planilla) = ''2'' then
        ldc_periodos            = 24 + (24/12);
        ldc_ingresos_anuales    = adc_monto * 24;
    
    elsif trim(ac_tipo_de_planilla) = ''3'' then
        ldc_periodos            = 26 + (26/12);
        ldc_ingresos_anuales    = adc_monto * 26;
        
    elsif trim(ac_tipo_de_planilla) = ''4'' then
        ldc_periodos            = 13;
        ldc_ingresos_anuales    = adc_monto * 12;
        
    else
        return 0;
    end if;
    
    ldc_deduccion_basica = 0;
    if r_rhuempl.grup_impto_renta = ''E'' then
        ldc_deduccion_basica = 800;
    end if;
    
    
    ldc_xiii_anual = ldc_ingresos_anuales / 12;
    
   
    ldc_ingresos_gravables = ldc_ingresos_anuales - ldc_deduccion_basica + ldc_xiii_anual;
    
    if ldc_ingresos_gravables <= 11000 then
        return 0;
    elsif ldc_ingresos_gravables > 50000 then
            ldc_renta_anual = 5850 + ((ldc_ingresos_gravables - 50000) * 0.25);
    else
            ldc_renta_anual = (ldc_ingresos_gravables - 11000) * 0.15;
    end if;    
    
    if ldc_periodos > 0 then
        return ldc_renta_anual / ldc_periodos;
    end if;
    
    return 0;
end;
' language plpgsql;


/*




*/
