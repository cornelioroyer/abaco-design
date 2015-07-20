
set search_path to planilla;

drop function f_pla_vacaciones(int4) cascade;
drop function f_pla_xiii(int4) cascade;
drop function f_pla_otros_ingresos_vacaciones(int4, char(7), int4, int4) cascade;

create function f_pla_otros_ingresos_vacaciones(int4, char(7), int4, int4) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    ai_id_pla_vacaciones alias for $4;
    r_pla_periodos record;
    r_pla_dinero record;
    r_pla_conceptos record;
    r_pla_retenciones record;
    r_pla_otros_ingresos_fijos record;
    r_pla_vacaciones record;
    i int4;
    ldc_work decimal;
    ldc_retener decimal;
    ldc_dias_vacaciones decimal;
begin
    select into r_pla_periodos * from pla_periodos
    where id = ai_id_periodos;
    if not found then
        raise exception ''Periodo % no Existe otros ingresos'',ai_id_periodos;
    end if;

    select into r_pla_vacaciones * from pla_vacaciones
    where id = ai_id_pla_vacaciones;
    if not found then
        raise exception ''Vacacion % No Existe'',ai_id_pla_vacaciones;
    end if;

    ldc_dias_vacaciones         = (r_pla_vacaciones.pagar_hasta - r_pla_vacaciones.pagar_desde) + 1;

    
    for r_pla_otros_ingresos_fijos in select * from pla_otros_ingresos_fijos
                                        where compania = ai_cia
                                        and codigo_empleado = as_codigo_empleado
                                        and periodo = r_pla_periodos.periodo
                                        order by concepto
    loop
        select into r_pla_conceptos * from pla_conceptos
        where concepto = r_pla_otros_ingresos_fijos.concepto;
        
        select into r_pla_dinero * from pla_dinero
        where id_periodos = ai_id_periodos
        and compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and tipo_de_calculo = ''2''
        and concepto = r_pla_otros_ingresos_fijos.concepto;
        if not found then        
        
            if trim(r_pla_otros_ingresos_fijos.concepto) = ''73'' then
                r_pla_otros_ingresos_fijos.concepto = ''107'';
                if ldc_dias_vacaciones >= 16 then
                    r_pla_otros_ingresos_fijos.monto = r_pla_otros_ingresos_fijos.monto * 2;
                end if;
            end if;

            
            insert into pla_dinero(id_periodos, compania, codigo_empleado, tipo_de_calculo,
                concepto, forma_de_registro, descripcion, mes, monto)
            values (ai_id_periodos, ai_cia, as_codigo_empleado, ''2'', r_pla_otros_ingresos_fijos.concepto,
                ''A'', r_pla_conceptos.descripcion, Mes(r_pla_periodos.dia_d_pago), r_pla_otros_ingresos_fijos.monto);
                
                
        end if;
        
    end loop;
    

    return 1;
end;
' language plpgsql;



create function f_pla_xiii(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_xiii record;
    r_pla_empleados record;
    r_pla_periodos record;
    r_v_pla_acumulados record;
    r_pla_conceptos record;
    r_pla_dinero record;
    r_pla_otros_ingresos_fijos record;
    r_pla_xiii_2 record;
    r_pla_liquidacion record;
    ldc_acum_xiii decimal;
    ldc_work decimal;
    ldc_salario_neto decimal;
    ldc_xiii decimal;
    ldc_xiii_gr decimal;
    ldc_xiii_pagado decimal;
    ldc_xiii_2 decimal;
    li_mes integer;
    i int4;
    li_periodos int4;
    li_id_pla_dinero int4;
    ls_paga_exceso_9_horas_semanales varchar(10);
    ldc_gto_representacion decimal;
    ld_acum_desde date;
    ld_fecha_liquidacion date;
    li_contador integer;
begin
    select into r_pla_xiii * from pla_xiii
    where id = ai_id;
    if not found then
        raise exception ''Xiii Mes no Existe % No Existe'',ai_id;
    end if;

    if r_pla_xiii.status = ''I'' then
        raise exception ''Periodo del XIII esta cerrado'';
    end if;

    select into r_pla_periodos * from pla_periodos
    where compania = r_pla_xiii.compania
    and tipo_de_planilla = r_pla_xiii.tipo_de_planilla
    and r_pla_xiii.dia_d_pago between desde and dia_d_pago
    and status = ''A'';
    if not found then
        raise exception ''No existe planilla abierta para esta fecha %'',r_pla_xiii.dia_d_pago;
    end if;

    for r_pla_periodos in select * from pla_periodos
                            where compania = r_pla_xiii.compania
                            and tipo_de_planilla = r_pla_xiii.tipo_de_planilla
                            and r_pla_xiii.dia_d_pago between desde and dia_d_pago
                            and status = ''A''
                            order by dia_d_pago
    loop
        exit;
    end loop;
    
    
    delete from pla_dinero
    where id_periodos = r_pla_periodos.id
    and tipo_de_calculo = ''3''
    and compania = r_pla_xiii.compania
    and forma_de_registro = ''A''
    and id_pla_cheques_1 is null;

 
    ls_paga_exceso_9_horas_semanales = f_pla_parametros(r_pla_xiii.compania, ''paga_exceso_9_horas_empleados_semanales'', ''S'', ''GET'');
    
    
    for r_pla_empleados in select * from pla_empleados
                            where compania = r_pla_xiii.compania
                            and tipo_de_planilla = r_pla_xiii.tipo_de_planilla
                            and status in (''A'',''V'',''I'',''L'',''C'',''S'')
                            and fecha_inicio <= r_pla_xiii.acum_hasta
                            and fecha_terminacion_real is null
                            order by codigo_empleado
    loop
        ldc_xiii    = 0;
        ldc_xiii_2  = 0; 
        ldc_xiii_pagado = 0;
        if r_pla_empleados.tipo_de_planilla = ''1'' and 
            Trim(ls_paga_exceso_9_horas_semanales) = ''N'' then
            continue;
        end if;


        ld_acum_desde           =   r_pla_xiii.acum_desde;

        ld_fecha_liquidacion    =   null;
        select Max(fecha_d_pago) into ld_fecha_liquidacion
        from pla_liquidacion
        where compania = r_pla_xiii.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and preliminar = ''N''
        and fecha_d_pago between r_pla_xiii.acum_desde and r_pla_xiii.dia_d_pago;
        if not found then
            ld_fecha_liquidacion = null;
        end if;

/*
if r_pla_empleados.codigo_empleado = ''160011''  then
    raise exception ''entre % % %'', ldc_xiii, ld_acum_desde, r_pla_xiii.acum_hasta;
end if;    
*/
        
        if ld_fecha_liquidacion is not null then        
            ld_acum_desde   =   ld_fecha_liquidacion + 1;
        end if;


        
        if r_pla_empleados.fecha_inicio > ld_acum_desde then
            ld_acum_desde = r_pla_empleados.fecha_inicio;
        end if;
        

/*

if r_pla_xiii.compania =  1075 and r_pla_empleados.codigo_empleado = ''0080'' then

    raise exception ''% %'', ld_acum_desde, ld_fecha_liquidacion;

end if;

        select into r_pla_liquidacion *
        from pla_liquidacion
        where compania = r_pla_xiii.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and fecha = ld_acum_desde;
        if found then
            ld_acum_desde   =   r_pla_liquidacion.fecha + 1;
        end if;
*/        

            
        ldc_xiii = f_acumulado_para(r_pla_empleados.compania, 
                    r_pla_empleados.codigo_empleado, ''109'',
                    ld_acum_desde, r_pla_xiii.acum_hasta);

--raise exception ''%'', r_pla_periodos.dia_d_pago;
                    

        if ldc_xiii > 0 then
            if r_pla_xiii.estima = ''S'' then
                li_periodos = 0;
                select into li_periodos count(*)
                from pla_periodos
                where compania = r_pla_empleados.compania
                and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
                and dia_d_pago between current_date and r_pla_xiii.acum_hasta;
                if li_periodos is null then
                    li_periodos = 0;
                end if;
                
                ldc_xiii = ldc_xiii + (r_pla_empleados.salario_bruto*li_periodos);
            end if;

            
            if r_pla_xiii.ajusta = ''S'' and ld_fecha_liquidacion is null then
                if r_pla_xiii.compania = 1046 then
                    li_contador = 0;
                    for r_pla_xiii_2 in select * from pla_xiii
                                            where compania = r_pla_xiii.compania
                                            and tipo_de_planilla = r_pla_xiii.tipo_de_planilla
                                            and dia_d_pago < r_pla_xiii.dia_d_pago
                                            and id <> r_pla_xiii.id
                                            order by dia_d_pago desc
                    loop
                        li_contador = li_contador + 1;
                        if li_contador > 1 then
                            r_pla_xiii_2.acum_hasta = ld_acum_desde - 1;
                            exit;
                        end if;                            
                    end loop;

                else
                    for r_pla_xiii_2 in select * from pla_xiii
                                            where compania = r_pla_xiii.compania
                                            and tipo_de_planilla = r_pla_xiii.tipo_de_planilla
                                            and dia_d_pago < r_pla_xiii.dia_d_pago
                                            and id <> r_pla_xiii.id
                                            order by dia_d_pago desc
                    loop
                        exit;
                    end loop;
                end if;

                
                ldc_xiii_2 = f_acumulado_para(r_pla_empleados.compania, 
                                r_pla_empleados.codigo_empleado, ''109'',
                                r_pla_xiii_2.acum_desde, r_pla_xiii_2.acum_hasta);


                ldc_xiii_pagado = 0;
                select into ldc_xiii_pagado sum(monto)
                from pla_dinero, pla_periodos
                where pla_periodos.id = pla_dinero.id_periodos
                and pla_dinero.compania = r_pla_empleados.compania
                and pla_dinero.codigo_empleado = r_pla_empleados.codigo_empleado
                and pla_periodos.dia_d_pago between r_pla_xiii_2.acum_desde and r_pla_xiii.dia_d_pago
                and pla_dinero.concepto = ''109'';
                if ldc_xiii_pagado is null then
                    ldc_xiii_pagado = 0;
                end if;
                
            end if;

            if ldc_xiii_2 is null then
                ldc_xiii_2 = 0;
            end if;

            if ldc_xiii is null then
                ldc_xiii = 0;
            end if;


            
            ldc_xiii = ((ldc_xiii + ldc_xiii_2)/12) - ldc_xiii_pagado;



            
            li_mes = Mes(r_pla_periodos.dia_d_pago);
            
            select into r_pla_dinero * from pla_dinero
            where id_periodos = r_pla_periodos.id
            and compania = r_pla_periodos.compania
            and Trim(codigo_empleado) = Trim(r_pla_empleados.codigo_empleado)
            and tipo_de_calculo = ''3''
            and concepto = ''109''
            and Trim(descripcion) = ''XIII MES'';
            if not found then
                insert into pla_dinero(id_periodos, compania, codigo_empleado, tipo_de_calculo,
                    concepto, forma_de_registro, descripcion, mes, monto)
                values (r_pla_periodos.id, r_pla_periodos.compania, 
                    r_pla_empleados.codigo_empleado, ''3'', ''109'',
                    ''A'', ''XIII MES'', li_mes, ldc_xiii);


                select into li_id_pla_dinero id from pla_dinero
                where id_periodos = r_pla_periodos.id
                and compania = r_pla_periodos.compania
                and codigo_empleado = r_pla_empleados.codigo_empleado
                and tipo_de_calculo = ''3''
                and concepto = ''109''
                and Trim(descripcion) = ''XIII MES'';
            else
                li_id_pla_dinero =   r_pla_dinero.id;
            end if;


            ldc_work = 0;            
            ldc_xiii_gr = f_acumulado_para(r_pla_empleados.compania, 
                        r_pla_empleados.codigo_empleado, ''125'',
                        ld_acum_desde, r_pla_xiii.acum_hasta);

/*
            ldc_work = 0;            
            select sum(monto) into ldc_work
            from pla_preelaboradas
            where compania = r_pla_periodos.compania
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and trim(concepto) = ''73''
            and fecha between r_pla_xiii.acum_desde and r_pla_xiii.acum_hasta;
            if ldc_work is null then
                ldc_work = 0;
            end if;


            ldc_xiii_gr = 0;            
            select sum(monto) into ldc_xiii_gr 
            from v_pla_dinero_detallado
            where compania = r_pla_periodos.compania
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and trim(concepto) = ''73''
            and fecha between r_pla_xiii.acum_desde and r_pla_xiii.acum_hasta;
            if ldc_xiii_gr is null then
                ldc_xiii_gr = 0;
            end if;
*/

/*
if r_pla_empleados.codigo_empleado = ''0001'' then 
    raise exception ''desde % %'', r_pla_xiii.acum_desde, ldc_xiii_gr;
end if;    
*/

            ldc_xiii_gr  =   ldc_xiii_gr + ldc_work;

            if ldc_xiii_gr > 0 then
                if r_pla_xiii.estima = ''S'' then
                    select into r_pla_otros_ingresos_fijos *
                    from pla_otros_ingresos_fijos
                    where compania = r_pla_empleados.compania
                    and codigo_empleado = r_pla_empleados.codigo_empleado
                    and periodo = 1
                    and concepto = ''73'';
                    if found then
                        ldc_xiii_gr = ldc_xiii_gr + r_pla_otros_ingresos_fijos.monto;
                    end if;
                end if;

                select into r_pla_dinero * from pla_dinero
                where id_periodos = r_pla_periodos.id
                and compania = r_pla_periodos.compania
                and codigo_empleado = r_pla_empleados.codigo_empleado
                and tipo_de_calculo = ''3''
                and concepto = ''125''
                and Trim(descripcion) = ''XIII MES'';
                if not found then
                    insert into pla_dinero(id_periodos, compania, codigo_empleado, tipo_de_calculo,
                        concepto, forma_de_registro, descripcion, mes, monto)
                    values (r_pla_periodos.id, r_pla_periodos.compania, 
                        r_pla_empleados.codigo_empleado, ''3'', ''125'',
                        ''A'', ''XIII MES'', li_mes, ldc_xiii_gr/12);
            
                else
                    li_id_pla_dinero = r_pla_dinero.id;
                end if;
            end if;            
                    
            for r_v_pla_acumulados in select * from v_pla_acumulados
                                        where compania = r_pla_periodos.compania
                                        and codigo_empleado = r_pla_empleados.codigo_empleado
                                        and concepto_calcula = ''109''
                                        and fecha between r_pla_xiii.acum_desde and r_pla_xiii.acum_hasta
                                        order by fecha
            loop
                if r_v_pla_acumulados.concepto_acumula = ''109'' then
                    continue;
                end if;
                
                select into r_pla_conceptos * from pla_conceptos
                where concepto = r_v_pla_acumulados.concepto_acumula;
                

                insert into pla_acumulados(id_pla_dinero, concepto, fecha, monto)
                values(li_id_pla_dinero, r_v_pla_acumulados.concepto_acumula,  
                    r_v_pla_acumulados.fecha, (r_v_pla_acumulados.monto*r_pla_conceptos.signo));
                    
            end loop;
                    
                    
        end if;
        
        i = f_pla_seguro_social(r_pla_periodos.compania, r_pla_empleados.codigo_empleado, 
                r_pla_periodos.id, ''3'');

    end loop;
    return 1;
end;
' language plpgsql;


create function f_pla_vacaciones(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_vacaciones record;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_dinero record;
    r_pla_conceptos record;
    r_v_pla_acumulados record;
    r_work record;
    ldc_acumulado_vacaciones decimal;
    ldc_dias_vacaciones decimal;
    ldc_salario_actual decimal;
    ldc_salario_promedio decimal;
    ldc_salario_base decimal;
    ldc_salario_neto decimal;
    ldc_vacaciones decimal;
    ldc_work decimal;
    ldc_meses_acumula decimal;
    ldc_dias_acumula decimal;
    ldc_dias_tomados decimal;
    li_mes integer;
    i int4;
    ls_tipo_de_planilla char(2);
begin

    select into r_pla_vacaciones * from pla_vacaciones
    where id = ai_id;
    if not found then
        raise exception ''Vacacion % No Existe'',ai_id;
    end if;

    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_vacaciones.compania
    and codigo_empleado = r_pla_vacaciones.codigo_empleado;


    select into r_pla_periodos * from pla_periodos
    where r_pla_vacaciones.dia_d_pago between desde and dia_d_pago
    and compania = r_pla_vacaciones.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla;
    if not Found then
        Raise Exception ''Periodo no Existe en compania %'',r_pla_vacaciones.compania;
    end if;


    
    ldc_dias_tomados = 0;    
    for r_work in select * from pla_vacaciones
                    where compania = r_pla_periodos.compania
                      and codigo_empleado = r_pla_empleados.codigo_empleado
                      and id <> ai_id
                      and pagar_hasta < r_pla_vacaciones.pagar_hasta
                 order by id
    loop
        ldc_dias_tomados = ldc_dias_tomados + (r_work.pagar_hasta - r_work.pagar_desde);
    end loop;
    
    
    if f_pla_parametros(r_pla_vacaciones.compania, ''paga_exceso_9_horas_empleados_semanales'', ''S'', ''GET'') = ''N'' and
        r_pla_empleados.tipo_de_planilla = ''1'' then
        return 0;
    end if;
        
    
    
    ldc_acumulado_vacaciones    = f_acumulado_para(r_pla_vacaciones.compania, 
                                    r_pla_vacaciones.codigo_empleado, ''108'',
                                    r_pla_vacaciones.acum_desde,
                                    r_pla_vacaciones.acum_hasta);
    ldc_dias_vacaciones         = (r_pla_vacaciones.pagar_hasta - r_pla_vacaciones.pagar_desde) + 1;

    ldc_dias_acumula        =   (r_pla_vacaciones.acum_hasta - r_pla_vacaciones.acum_desde - ldc_dias_tomados);

    ldc_meses_acumula       =   Trunc((ldc_dias_acumula/30), 1);
    
--    ldc_salario_promedio    =   Round((ldc_acumulado_vacaciones / ldc_meses_acumula), 2);

--raise exception ''acumulado % dia %'',ldc_acumulado_vacaciones, ldc_dias_acumula;

    if ldc_dias_acumula <= 181 then
        ldc_salario_promedio    =   ldc_acumulado_vacaciones / 11 * 2;
    else
        ldc_salario_promedio    =   ldc_acumulado_vacaciones / 11;
    end if;    
  
--    ldc_salario_promedio    =   ldc_acumulado_vacaciones / ldc_meses_acumula;  
    
/*
    raise exception ''meses % acumulado % dias %'',ldc_meses_acumula, ldc_acumulado_vacaciones, ldc_dias_acumula;


    raise exception ''% %'', ldc_salario_promedio, ldc_meses_acumula;

    ldc_meses_acumula    =   Round((ldc_meses_acumula/30),1);
    
    
    if ldc_meses_acumula > 11 then
        ldc_meses_acumula = 11;
    end if;
    
    ldc_salario_promedio = ldc_acumulado_vacaciones / ldc_meses_acumula;
*/    
    if r_pla_empleados.tipo_de_planilla = ''1'' then
        ldc_salario_actual = r_pla_empleados.salario_bruto * 52 / 12;
    elsif r_pla_empleados.tipo_de_planilla = ''2'' then
        ldc_salario_actual = r_pla_empleados.salario_bruto * 2;
    elsif r_pla_empleados.tipo_de_planilla = ''3'' then
        ldc_salario_actual = r_pla_empleados.salario_bruto * 26 / 12;
    else
        ldc_salario_actual = r_pla_empleados.salario_bruto;
    end if;
    
    if ldc_salario_actual > ldc_salario_promedio then
        ldc_salario_base = ldc_salario_actual;
    else
        ldc_salario_base = ldc_salario_promedio;
    end if;
    
--raise exception ''%  % %'',ldc_meses_acumula, ldc_salario_actual, ldc_salario_promedio;
    
    if ldc_dias_vacaciones >= 29 then
        ldc_vacaciones = ldc_salario_base;
    else
        ldc_vacaciones = Round(ldc_salario_base / 30 * ldc_dias_vacaciones,2);
    end if;
    
    if ldc_vacaciones <= 0 then
        return 0;
    end if;

    select into r_pla_dinero *
    from pla_dinero
    where id_periodos = r_pla_periodos.id
    and tipo_de_calculo = ''2''
    and compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and id_pla_cheques_1 is not null;
    if found then
        return 0;
    end if;
    
    delete from pla_dinero
    where id_periodos = r_pla_periodos.id
    and tipo_de_calculo = ''2''
    and compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and forma_de_registro = ''A'';
        
    li_mes = Mes(r_pla_periodos.dia_d_pago);
    i = f_pla_dinero_insert(r_pla_periodos.id, r_pla_empleados.compania, 
            r_pla_empleados.codigo_empleado, ''2'', ''108'', ''VACACIONES'', 
            li_mes, ldc_vacaciones);


    update pla_dinero
    set id_pla_vacaciones = ai_id
    where id = i;

    
    for r_v_pla_acumulados in select * from v_pla_acumulados
                                where compania = r_pla_periodos.compania
                                and codigo_empleado = r_pla_empleados.codigo_empleado
                                and concepto_calcula = ''108''
                                and fecha between r_pla_vacaciones.acum_desde and r_pla_vacaciones.acum_hasta
                                order by fecha
    loop
        select into r_pla_conceptos * from pla_conceptos
        where concepto = r_v_pla_acumulados.concepto_acumula;
        insert into pla_acumulados(id_pla_dinero, concepto, fecha, monto)
        values(i, r_v_pla_acumulados.concepto_acumula,  
            r_v_pla_acumulados.fecha, (r_v_pla_acumulados.monto*r_pla_conceptos.signo));
    end loop;

--    i = f_pla_otros_ingresos(r_pla_periodos.compania, r_pla_empleados.codigo_empleado, r_pla_periodos.id, ''2'');

    i = f_pla_otros_ingresos_vacaciones(r_pla_periodos.compania, r_pla_empleados.codigo_empleado, r_pla_periodos.id, ai_id);
    
    i = f_pla_seguro_social(r_pla_periodos.compania, r_pla_empleados.codigo_empleado, r_pla_periodos.id, ''2'');
    
    i = f_pla_seguro_educativo(r_pla_periodos.compania, r_pla_empleados.codigo_empleado, r_pla_periodos.id, ''2'');

    i = f_pla_retenciones(r_pla_empleados.compania, r_pla_empleados.codigo_empleado, r_pla_periodos.id, ''2'');

    return 1;
end;
' language plpgsql;

