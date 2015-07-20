

set search_path to planilla;

drop function f_pla_planilla_03(int4, int4) cascade;
drop function f_pla_meses_trabajados(int4, char(7), int4) cascade;

create function f_pla_meses_trabajados(int4, char(7), int4) returns integer as '
declare
    ai_cia alias for $1;
    ac_codigo_empleado alias for $2;
    ai_anio alias for $3;
    r_pla_empleados record;
    r_pla_dinero record;
    li_meses_trabajados integer;
    ld_desde date;
    ld_hasta date;
    ld_work_1 date;
    ld_work_2 date;
begin

    select into r_pla_empleados *
    from pla_empleados
    where compania = ai_cia
    and trim(codigo_empleado) = Trim(ac_codigo_empleado);
    if not found then
        return 0;
    end if;
    
    
    li_meses_trabajados = 1;
    
    select Min(fecha) into ld_work_1
    from pla_preelaboradas
    where compania = ai_cia
    and codigo_empleado = ac_codigo_empleado
    and Anio(fecha) = ai_anio;
    if not found or ld_work_1 is null then
        ld_work_1 = current_date;
    end if;
    
    select Min(pla_periodos.dia_d_pago) into ld_work_2
    from pla_periodos, pla_dinero
    where pla_periodos.id = pla_dinero.id_periodos
    and pla_periodos.year = ai_anio
    and pla_periodos.compania = ai_cia
    and pla_dinero.codigo_empleado = ac_codigo_empleado;
    if not found or ld_work_2 is null then
        ld_work_2 = current_date;
    end if;
    
    if ld_work_1 < ld_work_2 then
        ld_desde = ld_work_1;
    else
        ld_desde = ld_work_2;
    end if;
    
    if r_pla_empleados.fecha_inicio > ld_desde 
        and ai_anio = Anio(r_pla_empleados.fecha_inicio) then
        ld_desde = r_pla_empleados.fecha_inicio;
    end if;
    
/*    
    if r_pla_empleados.fecha_inicio < ld_desde then
        ld_desde = to_char(ai_anio,''9999'') || ''-01-01'';
    end if;
*/    

    
    select Max(pla_periodos.dia_d_pago) into ld_hasta
    from pla_periodos, pla_dinero
    where pla_periodos.id = pla_dinero.id_periodos
    and pla_periodos.year = ai_anio
    and pla_periodos.compania = ai_cia
    and pla_dinero.monto <> 0
    and pla_dinero.codigo_empleado = ac_codigo_empleado;
    if ld_hasta is null then
        ld_hasta = ''1930-01-01'';
    end if;


    
    select Max(fecha) into ld_work_1
    from pla_preelaboradas
    where compania = ai_cia
    and codigo_empleado = ac_codigo_empleado
    and Anio(fecha) = ai_anio;
    if ld_work_1 is null then
        ld_work_1 = ''1930-01-01'';
    end if;
    
    if ld_work_1 > ld_hasta then
        ld_hasta = ld_work_1;
    end if;    
    
    li_meses_trabajados = Mes(ld_hasta) - Mes(ld_desde) + 1;
    
    
    if li_meses_trabajados is null then
        li_meses_trabajados = 1;
    end if;
    
/*    
    if li_meses_trabajados > 1 then
        select into r_pla_dinero pla_dinero.*
        from pla_periodos, pla_dinero
        where pla_periodos.id = pla_dinero.id_periodos
        and pla_periodos.year = ai_anio
        and pla_periodos.compania = ai_cia
        and trim(pla_dinero.tipo_de_calculo) = ''7''
        and pla_dinero.codigo_empleado = ac_codigo_empleado;
        if found then
            li_meses_trabajados = li_meses_trabajados - 1;
        end if;
    end if;
*/  

    if li_meses_trabajados < 0 then
        li_meses_trabajados = 1;
    end if;  
    
    if li_meses_trabajados > 12 then
        li_meses_trabajados = 12;
    end if;
    
    return li_meses_trabajados;
end;
' language plpgsql;


create function f_pla_planilla_03(int4, int4) returns integer as '
declare
    ai_cia alias for $1;
    ai_anio alias for $2;
    r_pla_empleados record;
    r_pla_isr record;
    ls_grupo_renta char(1);
    li_meses_trabajados integer;
    ldc_work1 decimal;
    ldc_work2 decimal;
    ldc_work decimal;
    ldc_remuneraciones decimal;
    ldc_fisco decimal;
    ldc_empleado decimal;
    ldc_gastos_de_representacion decimal;
    ldc_deduccion_basica decimal;
    ldc_seguro_educativo decimal;
    ldc_renta_neta decimal;
    ldc_impuesto_causado decimal;
    ldc_retencion_salario decimal;
    ldc_retencion_gasto decimal;
    ldc_ajuste_a_favor decimal;
    ldc_diferencia decimal;
    ldc_work_1 decimal;
    ldc_periodos_pagos decimal;
    ls_nombre_empleado char(80);
    lc_tipo_de_planilla char(2);
    r_pla_planilla_03 record;
    r_pla_ajuste_de_renta record;
begin
    delete from pla_planilla_03 where compania = ai_cia;

    if ai_anio <= 2009 then
        for r_pla_empleados in select * from pla_empleados
                            where compania = ai_cia
                            order by codigo_empleado
        loop
            if r_pla_empleados.grupo = ''E'' then
                ls_grupo_renta = ''4'';
            elsif r_pla_empleados.grupo = ''A'' then
                ls_grupo_renta = ''1'';
            elsif r_pla_empleados.grupo = ''B'' then
                ls_grupo_renta = ''2'';
            else
                ls_grupo_renta = ''3'';
            end if;

            if r_pla_empleados.status = ''I'' then
                if Anio(r_pla_empleados.fecha_inicio) < ai_anio then
                    li_meses_trabajados = 12;
                elsif r_pla_empleados.fecha_terminacion_real is null then
                    li_meses_trabajados = 1;
                elsif r_pla_empleados.fecha_inicio > r_pla_empleados.fecha_terminacion_real then
                    li_meses_trabajados = 1;
                elsif Anio(r_pla_empleados.fecha_inicio) = ai_anio then
                    li_meses_trabajados = Mes(r_pla_empleados.fecha_terminacion_real) - Mes(r_pla_empleados.fecha_inicio);
                else
                    li_meses_trabajados = 12;
                end if;
            else
                if Anio(r_pla_empleados.fecha_inicio) = ai_anio then
                    li_meses_trabajados = 12 - Mes(r_pla_empleados.fecha_inicio);
                else
                    li_meses_trabajados = 12;
                end if;
            end if;
        
            if li_meses_trabajados < 0 then
                li_meses_trabajados = 1;
            end if;
        
            ldc_remuneraciones              =   f_acumulado_para(ai_cia, r_pla_empleados.codigo_empleado, ''106'', ai_anio);
            ldc_gastos_de_representacion    =   f_acumulado(ai_cia, r_pla_empleados.codigo_empleado, ''125'',ai_anio) +
                                                f_acumulado(ai_cia, r_pla_empleados.codigo_empleado, ''73'', ai_anio);
            if r_pla_empleados.grupo = ''E'' then
                ldc_deduccion_basica =   1600 + (250 * r_pla_empleados.dependientes);
            else
                ldc_deduccion_basica =   800 + (250 * r_pla_empleados.dependientes);
            end if;
            ldc_seguro_educativo    =   -f_acumulado(ai_cia, r_pla_empleados.codigo_empleado, ''104'', ai_anio);
            ldc_renta_neta          =   ldc_remuneraciones - ldc_deduccion_basica - ldc_seguro_educativo;

            li_meses_trabajados             =   f_pla_meses_trabajados(ai_cia, r_pla_empleados.codigo_empleado, ai_anio);

            select into lc_tipo_de_planilla pla_periodos.tipo_de_planilla
            from pla_dinero, pla_periodos
            where pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = r_pla_empleados.codigo_empleado
            and pla_periodos.year = ai_anio
            group by 1;
            if found then
                r_pla_empleados.tipo_de_planilla = lc_tipo_de_planilla;
            end if;
        
            if li_meses_trabajados = 12 then
        
                select into r_pla_isr * from pla_isr
                where ldc_renta_neta between sbruto_inicial and sbruto_final;
                if found then
                    ldc_work                =   ldc_renta_neta - r_pla_isr.sbruto_inicial;
                    ldc_impuesto_causado    =   r_pla_isr.renta_fija + (ldc_work * r_pla_isr.excedente_aplicar/100);
                else
                    ldc_impuesto_causado = 0;
                end if;
            else
                ldc_periodos_pagos  =   f_periodos_pago(ai_cia, r_pla_empleados.codigo_empleado, r_pla_empleados.tipo_de_planilla, ai_anio);

                ldc_work_1          =   ldc_remuneraciones / ldc_periodos_pagos;
            
                ldc_work_1          =   f_renta_exacta(ai_cia, r_pla_empleados.codigo_empleado, r_pla_empleados.tipo_de_planilla, ldc_work_1);

                ldc_impuesto_causado=   ldc_work_1 * ldc_periodos_pagos;
            
            end if;        


            if li_meses_trabajados > 12 then
                li_meses_trabajados = 12;
            end if;

            ldc_retencion_salario       =   -f_acumulado(ai_cia, r_pla_empleados.codigo_empleado, ''106'', ai_anio);
            ldc_retencion_gasto         =   -f_acumulado(ai_cia, r_pla_empleados.codigo_empleado, ''310'', ai_anio);
        
            if li_meses_trabajados < 12 then
                ldc_impuesto_causado    =   ldc_retencion_salario;
            end if;

            ldc_ajuste_a_favor = 0;


        
            ldc_diferencia  =   ldc_impuesto_causado - ldc_retencion_salario - ldc_ajuste_a_favor;
        
            if ldc_diferencia > 0 then
                ldc_fisco       =   ldc_diferencia;
                ldc_empleado    =   0;
            else
                ldc_fisco       =   0;
                ldc_empleado    =   ldc_diferencia;
            end if;
            
            if li_meses_trabajados < 12 then
                ldc_fisco = 0;
            end if;


            

            ls_nombre_empleado  =   trim(r_pla_empleados.apellido) || '' '' || trim(r_pla_empleados.nombre);
        
            insert into pla_planilla_03 (anio, compania, codigo_empleado, declara,
                tipo_persona, cedula, dv, nombre, grupo_renta, dependientes,
                meses_trabajados, remuneraciones, salarios_en_especie,
                gastos_de_representacion, remuneraciones_sr, deduccion_basica, seguro_educativo,
                int_hipotecarios, int_educativos, prima_seguro, jubilacion, total_deducciones,
                renta_neta, impuesto_causado, ajuste_causado, exencion, retencion_salario,
                retencion_gasto, ajuste_a_favor, column_29, fisco, empleado)
            values (ai_anio, ai_cia, r_pla_empleados.codigo_empleado, r_pla_empleados.declarante,
                ''1'',r_pla_empleados.cedula, r_pla_empleados.dv, ls_nombre_empleado,
                ls_grupo_renta, r_pla_empleados.dependientes, li_meses_trabajados, ldc_remuneraciones,
                0, ldc_gastos_de_representacion, 0, ldc_deduccion_basica, ldc_seguro_educativo,
                0,0,0,0,(ldc_deduccion_basica+ldc_seguro_educativo),
                ldc_renta_neta, ldc_impuesto_causado, 0, 0, ldc_retencion_salario, ldc_retencion_gasto,
                ldc_ajuste_a_favor, (ldc_retencion_salario + ldc_retencion_gasto + ldc_ajuste_a_favor),
                ldc_fisco, ldc_empleado);
        end loop;
    else
        for r_pla_empleados in select * from pla_empleados
                            where compania = ai_cia
                            and (fecha_terminacion_real is null
                            or Anio(fecha_terminacion_real) >= ai_anio)
                            order by fecha_inicio, codigo_empleado
        loop
        
        
            if r_pla_empleados.grupo = ''E'' then
                ls_grupo_renta = ''6'';
            else
                ls_grupo_renta = ''5'';
            end if;



            ldc_remuneraciones              =   f_acumulado_para_03(ai_cia, r_pla_empleados.codigo_empleado, ''106'', ai_anio);
            ldc_gastos_de_representacion    =   f_acumulado(ai_cia, r_pla_empleados.codigo_empleado, ''125'',ai_anio) +
                                                f_acumulado(ai_cia, r_pla_empleados.codigo_empleado, ''107'', ai_anio) +
                                                f_acumulado(ai_cia, r_pla_empleados.codigo_empleado, ''73'', ai_anio);
            if r_pla_empleados.grupo = ''E'' then
                ldc_deduccion_basica =   800;
            else
                ldc_deduccion_basica =   0;
            end if;
            
            ldc_seguro_educativo    =   0;
            ldc_renta_neta          =   ldc_remuneraciones - ldc_deduccion_basica - ldc_seguro_educativo;

            li_meses_trabajados     =   f_pla_meses_trabajados(ai_cia, r_pla_empleados.codigo_empleado, ai_anio);
            if li_meses_trabajados > 12 then
                li_meses_trabajados = 12;
            end if;

            select into lc_tipo_de_planilla pla_periodos.tipo_de_planilla
            from pla_dinero, pla_periodos
            where pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = r_pla_empleados.codigo_empleado
            and pla_periodos.year = ai_anio
            group by 1;
            if found then
                r_pla_empleados.tipo_de_planilla = lc_tipo_de_planilla;
            end if;

            if li_meses_trabajados = 12 then
                if ldc_renta_neta <= 11000 then
                    ldc_impuesto_causado = 0;
                else
                    if ldc_renta_neta >= 50000 then
                        ldc_impuesto_causado = 5850 + ((ldc_renta_neta-50000) * .25);
                    else
                        ldc_impuesto_causado = (ldc_renta_neta - 11000) * .15;
                    end if;
                end if;
            else
                ldc_periodos_pagos  =   f_periodos_pago(ai_cia, r_pla_empleados.codigo_empleado, r_pla_empleados.tipo_de_planilla, ai_anio);

                ldc_work_1          =   ldc_remuneraciones / ldc_periodos_pagos;
            
                ldc_work_1          =   f_renta_exacta(ai_cia, r_pla_empleados.codigo_empleado, r_pla_empleados.tipo_de_planilla, ldc_work_1);

                ldc_impuesto_causado=   ldc_work_1 * ldc_periodos_pagos;
            
            end if;        


            ldc_retencion_salario       =   -f_acumulado(ai_cia, r_pla_empleados.codigo_empleado, ''106'', ai_anio);
            ldc_retencion_gasto         =   -f_acumulado(ai_cia, r_pla_empleados.codigo_empleado, ''310'', ai_anio);


        
            if (ai_cia = 749 or ai_cia = 838) and li_meses_trabajados < 12 then
                ldc_impuesto_causado    =   ldc_retencion_salario;
            end if;
            
            if r_pla_empleados.declarante = ''2'' then
                ldc_impuesto_causado    =   ldc_retencion_salario;
            end if;

            ldc_ajuste_a_favor = 0;
            select into r_pla_ajuste_de_renta *
            from pla_ajuste_de_renta
            where compania = ai_cia
            and trim(codigo_empleado) = trim(r_pla_empleados.codigo_empleado)
            and anio = ai_anio;
            if not found then
                r_pla_ajuste_de_renta.monto = 0;
            end if;
            
            ldc_ajuste_a_favor = r_pla_ajuste_de_renta.monto;

            if li_meses_trabajados < 12 then
                ldc_impuesto_causado = ldc_retencion_salario;
                ldc_fisco = 0;
            end if;
        
            ldc_diferencia  =   ldc_impuesto_causado - ldc_retencion_salario - ldc_ajuste_a_favor;
        
            if ldc_diferencia > 0 then
                ldc_fisco       =   ldc_diferencia;
                ldc_empleado    =   0;
            else
                ldc_fisco       =   0;
                ldc_empleado    =   ldc_diferencia;
            end if;



            
            ldc_work    =   ldc_impuesto_causado - ldc_retencion_salario;

/*
if trim(r_pla_empleados.codigo_empleado) = ''160002'' then
    raise exception ''%'', ldc_work;
end if;                
*/
            if ai_cia = 1199 and ldc_work >= 0.01 and ldc_work <= 0.07 and ai_anio = 2014 then
                ldc_impuesto_causado    = ldc_retencion_salario;
                ldc_fisco               =   0;
            end if;
    
            ls_nombre_empleado  =   trim(r_pla_empleados.apellido) || '' '' || trim(r_pla_empleados.nombre);
        
            select into r_pla_planilla_03 *
            from pla_planilla_03
            where compania = ai_cia
                    and anio = ai_anio
                    and trim(cedula) = trim(r_pla_empleados.cedula);
            if found then
            
                if r_pla_planilla_03.meses_trabajados >= 12 then
                    li_meses_trabajados = 12 - r_pla_planilla_03.meses_trabajados;
                end if;

                update pla_planilla_03
                set remuneraciones = remuneraciones + ldc_remuneraciones,
                    seguro_educativo = seguro_educativo + ldc_seguro_educativo,
                    total_deducciones = total_deducciones + ldc_seguro_educativo,
                    renta_neta = renta_neta + ldc_renta_neta,
                    impuesto_causado = impuesto_causado + ldc_impuesto_causado,
                    retencion_salario = retencion_salario + ldc_retencion_salario,
                    retencion_gasto = retencion_gasto + ldc_retencion_gasto,
                    ajuste_a_favor = ajuste_a_favor + ldc_ajuste_a_favor,
                    column_29 = column_29 + (ldc_retencion_salario + ldc_retencion_gasto + ldc_ajuste_a_favor),
                    fisco = fisco + ldc_fisco,
                    empleado = empleado + ldc_empleado
                where anio = ai_anio
                and compania = ai_cia
                and trim(cedula) = trim(r_pla_empleados.cedula);

/*                
                update pla_planilla_03
                set meses_trabajados = meses_trabajados + li_meses_trabajados,
                    remuneraciones = remuneraciones + ldc_remuneraciones,
                    seguro_educativo = seguro_educativo + ldc_seguro_educativo,
                    total_deducciones = total_deducciones + ldc_seguro_educativo,
                    renta_neta = renta_neta + ldc_renta_neta,
                    impuesto_causado = impuesto_causado + ldc_impuesto_causado,
                    retencion_salario = retencion_salario + ldc_retencion_salario,
                    retencion_gasto = retencion_gasto + ldc_retencion_gasto,
                    ajuste_a_favor = ajuste_a_favor + ldc_ajuste_a_favor,
                    column_29 = column_29 + (ldc_retencion_salario + ldc_retencion_gasto + ldc_ajuste_a_favor),
                    fisco = fisco + ldc_fisco,
                    empleado = empleado + ldc_empleado
                where anio = ai_anio
                and compania = ai_cia
                and trim(cedula) = trim(r_pla_empleados.cedula);
*/
                
            else
                insert into pla_planilla_03 (anio, compania, codigo_empleado, declara,
                    tipo_persona, cedula, dv, nombre, grupo_renta, dependientes,
                    meses_trabajados, remuneraciones, salarios_en_especie,
                    gastos_de_representacion, remuneraciones_sr, deduccion_basica, seguro_educativo,
                    int_hipotecarios, int_educativos, prima_seguro, jubilacion, total_deducciones,
                    renta_neta, impuesto_causado, ajuste_causado, exencion, retencion_salario,
                    retencion_gasto, ajuste_a_favor, column_29, fisco, empleado)
                values (ai_anio, ai_cia, r_pla_empleados.codigo_empleado, r_pla_empleados.declarante,
                    ''1'',r_pla_empleados.cedula, r_pla_empleados.dv, ls_nombre_empleado,
                    ls_grupo_renta, r_pla_empleados.dependientes, li_meses_trabajados, ldc_remuneraciones,
                    0, ldc_gastos_de_representacion, 0, ldc_deduccion_basica, ldc_seguro_educativo,
                    0,0,0,0,(ldc_deduccion_basica+ldc_seguro_educativo),
                    ldc_renta_neta, ldc_impuesto_causado, 0, 0, ldc_retencion_salario, ldc_retencion_gasto,
                    ldc_ajuste_a_favor, (ldc_retencion_salario + ldc_retencion_gasto + ldc_ajuste_a_favor),
                    ldc_fisco, ldc_empleado);
            end if;                    
        end loop;
    
    end if;    
    
    delete from pla_planilla_03
    where remuneraciones <= 0;

    update pla_planilla_03
    set meses_trabajados = f_pla_meses_trabajados(compania, codigo_empleado, ai_anio)
    where compania = ai_cia;
    
    return 1;
end;
' language plpgsql;    

/*


copy (SELECT pla_planilla_03.declara,   
         pla_planilla_03.tipo_persona,   
         pla_planilla_03.cedula,   
         pla_planilla_03.dv,   
         pla_planilla_03.nombre,   
         pla_planilla_03.grupo_renta,   
         pla_planilla_03.dependientes,   
         pla_planilla_03.meses_trabajados,   
         pla_planilla_03.remuneraciones,   
         pla_planilla_03.salarios_en_especie,   
         pla_planilla_03.gastos_de_representacion,   
         pla_planilla_03.remuneraciones_sr,   
         pla_planilla_03.deduccion_basica,   
         pla_planilla_03.seguro_educativo,   
         pla_planilla_03.int_hipotecarios,   
         pla_planilla_03.int_educativos,   
         pla_planilla_03.prima_seguro,   
         pla_planilla_03.jubilacion,   
         pla_planilla_03.total_deducciones,   
         pla_planilla_03.renta_neta,   
         pla_planilla_03.impuesto_causado,   
         pla_planilla_03.ajuste_causado,   
         pla_planilla_03.exencion,   
         pla_planilla_03.retencion_salario,   
         pla_planilla_03.retencion_gasto,   
         pla_planilla_03.ajuste_a_favor,   
         pla_planilla_03.column_29,   
         pla_planilla_03.fisco,   
         pla_planilla_03.empleado  
    FROM pla_planilla_03
    where compania = ai_cia) to ''/tmp/planilla_03.txt'';
*/
    
