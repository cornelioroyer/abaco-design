drop function f_to_date(integer, integer, integer) cascade;
drop function f_acumulado(char(2), char(7), int4, char(3)) cascade;
drop function f_acumulado_para(char(2), char(7), int4, char(3)) cascade;
drop function f_pla_anexo_03(char(2), int4) cascade;
drop function f_etax_07(char(2), date, date) cascade;


create function f_etax_07(char(2), date, date) returns integer as '
declare
    as_cia alias for $1;
    ad_desde alias for $2;
    ad_hasta alias for $3;
    r_div_movimientos record;
    r_etax_07 record;
    lc_usuario char(10);
begin
    delete from etax_07;
    
    lc_usuario = current_user;
    
    for r_div_movimientos in select div_movimientos.*, div_socios.*, bcocheck1.*
                        from div_movimientos, div_socios, bcocheck1, bcoctas
                        where div_socios.socio = div_movimientos.socio
                        and bcocheck1.cod_ctabco = bcoctas.cod_ctabco
                        and div_movimientos.cod_ctabco = bcocheck1.cod_ctabco
                        and div_movimientos.no_cheque = bcocheck1.no_cheque
                        and div_movimientos.motivo_bco = bcocheck1.motivo_bco
                        and bcoctas.compania = as_cia
                        and div_socios.compania = as_cia
                        and div_movimientos.compania = as_cia
                        and div_movimientos.fecha between ad_desde and ad_hasta
                        and bcocheck1.status <> ''A''
                        and div_movimientos.no_cheque is not null
                        and div_socios.ruc is not null
                        and div_socios.dv is not null
                        order by bcocheck1.fecha_cheque, bcocheck1.no_cheque
    loop
        select into r_etax_07 *
        from etax_07
        where usuario = lc_usuario
        and ruc = r_div_movimientos.ruc;
        if not found then
            insert into etax_07 (usuario, tipo_d_persona,
                ruc, dv, nombre, operacion, monto)
            values (current_user, r_div_movimientos.tipo_d_persona, r_div_movimientos.ruc, r_div_movimientos.dv, 
                r_div_movimientos.paguese_a, ''6'',
                r_div_movimientos.dividendo);
        else
            update etax_07
            set monto = monto + r_div_movimientos.dividendo
            where usuario = lc_usuario
            and ruc = r_div_movimientos.ruc;
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;



create function f_pla_anexo_03(char(2), int4) returns integer as '
declare
    as_cia alias for $1;
    ai_anio alias for $2;
    r_rhuempl record;
    r_nomimrta record;
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
    li_dias integer;
    ld_inicio date;
begin
    delete from pla_anexo_03;
    
    if ai_anio <= 2009 then
        for r_rhuempl in select * from rhuempl
                            where compania = as_cia
                            order by codigo_empleado
        loop
            if r_rhuempl.grup_impto_renta = ''E'' then
                ls_grupo_renta = ''4'';
            elsif r_rhuempl.grup_impto_renta = ''A'' then
                ls_grupo_renta = ''1'';
            elsif r_rhuempl.grup_impto_renta = ''B'' then
                ls_grupo_renta = ''2'';
            else
                ls_grupo_renta = ''3'';
            end if;

            if r_rhuempl.status = ''I'' then
                if r_rhuempl.fecha_terminacion is null then
                    li_meses_trabajados = 1;
                elsif r_rhuempl.fecha_terminacion is not null then
                    li_dias             =   r_rhuempl.fecha_terminacion - r_rhuempl.fecha_inicio;
                    li_meses_trabajados =   li_dias / 30;
                elsif r_rhuempl.fecha_inicio > r_rhuempl.fecha_terminacion then
                    li_meses_trabajados = 1;
                elsif Anio(r_rhuempl.fecha_inicio) = ai_anio then
                    li_meses_trabajados = Mes(r_rhuempl.fecha_terminacion) - Mes(r_rhuempl.fecha_inicio) + 1;
                else
                    li_meses_trabajados = 12;
                end if;
            else
                if r_rhuempl.fecha_terminacion is null then
                    if Anio(r_rhuempl.fecha_inicio) = ai_anio then
                        li_meses_trabajados = 12 - Mes(r_rhuempl.fecha_inicio);
                    else
                        li_meses_trabajados = 12;
                    end if;
                else
                    li_dias             =   r_rhuempl.fecha_terminacion - r_rhuempl.fecha_inicio;
                    li_meses_trabajados =   li_dias / 30;
                end if;
            end if;

            ldc_remuneraciones              =   f_acumulado_para(as_cia, r_rhuempl.codigo_empleado, ai_anio, ''106'');
        
            ldc_gastos_de_representacion    =   f_acumulado(as_cia, r_rhuempl.codigo_empleado, ai_anio, ''125'') +
                                                f_acumulado(as_cia, r_rhuempl.codigo_empleado, ai_anio, ''200'');
        

            if r_rhuempl.grup_impto_renta = ''E'' then
                ldc_deduccion_basica =   1600 + (250 * r_rhuempl.num_dependiente);
            else
                ldc_deduccion_basica =   800 + (250 * r_rhuempl.num_dependiente);
            end if;
        
            ldc_seguro_educativo    =   -f_acumulado(as_cia, r_rhuempl.codigo_empleado, ai_anio, ''104'');
        
        
            ldc_renta_neta          =   ldc_remuneraciones - ldc_deduccion_basica - ldc_seguro_educativo;
        
            select into r_nomimrta * from nomimrta
            where ldc_renta_neta between sbruto_inicial and sbruto_final;
            if found then
                ldc_work                =   ldc_renta_neta - r_nomimrta.sbruto_inicial;
                ldc_impuesto_causado    =   r_nomimrta.renta_fija + (ldc_work * r_nomimrta.excedente_aplicar/100);
            else
                ldc_impuesto_causado = 0;
            end if;
        
        
            ldc_retencion_salario       =   -f_acumulado(as_cia, r_rhuempl.codigo_empleado, ai_anio, ''106'');
            ldc_retencion_gasto         =   -f_acumulado(as_cia, r_rhuempl.codigo_empleado, ai_anio, ''310'');
        
        
            select into ldc_ajuste_a_favor monto
            from pla_ajuste_renta
            where compania = as_cia
            and codigo_empleado = r_rhuempl.codigo_empleado
            and anio = ai_anio;
        
            if ldc_ajuste_a_favor is null then
                ldc_ajuste_a_favor = 0;
            end if;
        
            ldc_diferencia  =   ldc_impuesto_causado - ldc_retencion_salario - ldc_ajuste_a_favor;
        
            if ldc_diferencia > 0 then
                ldc_fisco       =   ldc_diferencia;
                ldc_empleado    =   0;
            else
                ldc_fisco       =   0;
                ldc_empleado    =   ldc_diferencia;
            end if;

            if r_rhuempl.declarante <> ''1'' and r_rhuempl.declarante <> ''2'' then
                r_rhuempl.declarante = ''1'';
            end if;
            
            insert into pla_anexo_03 (usuario, anio, compania, codigo_empleado, declara,
                tipo_persona, cedula, dv, nombre, grupo_renta, dependientes,
                meses_trabajados, remuneraciones, salarios_en_especie,
                gastos_de_representacion, remuneraciones_sr, deduccion_basica, seguro_educativo,
                int_hipotecarios, int_educativos, prima_seguro, jubilacion, total_deducciones,
                renta_neta, impuesto_causado, ajuste_causado, exencion, retencion_salario,
                retencion_gasto, ajuste_a_favor, column_29, fisco, empleado)
            values (current_user, ai_anio, as_cia, r_rhuempl.codigo_empleado, r_rhuempl.declarante,
                ''1'',Trim(r_rhuempl.numero_cedula), r_rhuempl.dv, Trim(r_rhuempl.nombre_del_empleado),
                ls_grupo_renta, r_rhuempl.num_dependiente, li_meses_trabajados, ldc_remuneraciones,
                0, ldc_gastos_de_representacion, 0, ldc_deduccion_basica, ldc_seguro_educativo,
                0,0,0,0,(ldc_deduccion_basica+ldc_seguro_educativo),
                ldc_renta_neta, ldc_impuesto_causado, 0, 0, ldc_retencion_salario, ldc_retencion_gasto,
                ldc_ajuste_a_favor, (ldc_retencion_salario + ldc_retencion_gasto + ldc_ajuste_a_favor),
                ldc_fisco, ldc_empleado);
        end loop;
    else
        for r_rhuempl in select * from rhuempl
                            where compania = as_cia
                            order by codigo_empleado
        loop
            if r_rhuempl.grup_impto_renta = ''E'' then
                ls_grupo_renta = ''6'';
            else
                ls_grupo_renta = ''5'';
            end if;

            if r_rhuempl.status = ''I'' or r_rhuempl.status = ''E'' then
                if r_rhuempl.fecha_terminacion is null then
                    li_meses_trabajados = 1;
                elsif r_rhuempl.fecha_terminacion is not null then
                    if Anio(r_rhuempl.fecha_inicio) < ai_anio then
                        ld_inicio           =   f_to_date(ai_anio, 1, 1);
                        li_dias             =   r_rhuempl.fecha_terminacion - ld_inicio;
                        li_meses_trabajados =   li_dias / 30;
                    else
                        li_dias             =   r_rhuempl.fecha_terminacion - r_rhuempl.fecha_inicio;
                        li_meses_trabajados =   li_dias / 30;
                    end if;
                elsif r_rhuempl.fecha_inicio > r_rhuempl.fecha_terminacion then
                    li_meses_trabajados = 1;
                elsif Anio(r_rhuempl.fecha_inicio) = ai_anio then
                    li_meses_trabajados = Mes(r_rhuempl.fecha_terminacion) - Mes(r_rhuempl.fecha_inicio) + 1;
                else
                    li_meses_trabajados = 12;
                end if;
            else
                if r_rhuempl.fecha_terminacion is null then
                    if Anio(r_rhuempl.fecha_inicio) = ai_anio then
                        li_meses_trabajados = 12 - Mes(r_rhuempl.fecha_inicio);
                    else
                        li_meses_trabajados = 12;
                    end if;
                else
                    li_dias             =   r_rhuempl.fecha_terminacion - r_rhuempl.fecha_inicio;
                    li_meses_trabajados =   li_dias / 30;
                end if;
            end if;

            if li_meses_trabajados < 1 then
                li_meses_trabajados = 1;
            end if;
            
            if li_meses_trabajados > 12 then
                li_meses_trabajados = 12;
            end if;

            ldc_remuneraciones              =   f_acumulado_para(as_cia, r_rhuempl.codigo_empleado, ai_anio, ''106'');
        
            ldc_gastos_de_representacion    =   f_acumulado(as_cia, r_rhuempl.codigo_empleado, ai_anio, ''125'') +
                                                f_acumulado(as_cia, r_rhuempl.codigo_empleado, ai_anio, ''200'');
        

            if r_rhuempl.grup_impto_renta = ''E'' then
                ldc_deduccion_basica =   800;
            else
                ldc_deduccion_basica =   0;
            end if;
        
            ldc_seguro_educativo    =   0;
        
        
            ldc_renta_neta          =   ldc_remuneraciones - ldc_deduccion_basica - ldc_seguro_educativo;
        
        
            if ldc_renta_neta <= 11000 then
                ldc_impuesto_causado = 0;
            else
                ldc_impuesto_causado = (ldc_renta_neta - 11000) * .15;
            end if;
        
        
            
            ldc_retencion_salario       =   -f_acumulado(as_cia, r_rhuempl.codigo_empleado, ai_anio, ''106'');
            ldc_retencion_gasto         =   -f_acumulado(as_cia, r_rhuempl.codigo_empleado, ai_anio, ''310'');
        
            if li_meses_trabajados < 12 then
                ldc_impuesto_causado = ldc_retencion_salario;
            end if;


            select into ldc_ajuste_a_favor monto
            from pla_ajuste_renta
            where compania = as_cia
            and codigo_empleado = r_rhuempl.codigo_empleado
            and anio = ai_anio;
        
            if ldc_ajuste_a_favor is null then
                ldc_ajuste_a_favor = 0;
            end if;
        
        
            ldc_diferencia  =   ldc_impuesto_causado - ldc_retencion_salario - ldc_ajuste_a_favor;
        
            if ldc_diferencia > 0 then
                ldc_fisco       =   ldc_diferencia;
                ldc_empleado    =   0;
            else
                ldc_fisco       =   0;
                ldc_empleado    =   ldc_diferencia;
            end if;

            if (r_rhuempl.declarante <> ''1'' and r_rhuempl.declarante <> ''2'') or r_rhuempl.declarante is null then
                r_rhuempl.declarante = ''1'';
                update rhuempl
                set declarante = ''1''
                where compania = r_rhuempl.compania
                and codigo_empleado = r_rhuempl.codigo_empleado;
            end if;
            insert into pla_anexo_03 (usuario, anio, compania, codigo_empleado, declara,
                tipo_persona, cedula, dv, nombre, grupo_renta, dependientes,
                meses_trabajados, remuneraciones, salarios_en_especie,
                gastos_de_representacion, remuneraciones_sr, deduccion_basica, seguro_educativo,
                int_hipotecarios, int_educativos, prima_seguro, jubilacion, total_deducciones,
                renta_neta, impuesto_causado, ajuste_causado, exencion, retencion_salario,
                retencion_gasto, ajuste_a_favor, column_29, fisco, empleado)
            values (current_user, ai_anio, as_cia, r_rhuempl.codigo_empleado, r_rhuempl.declarante,
                ''1'',Trim(r_rhuempl.numero_cedula), r_rhuempl.dv, Trim(r_rhuempl.nombre_del_empleado),
                ls_grupo_renta, r_rhuempl.num_dependiente, li_meses_trabajados, ldc_remuneraciones,
                0, ldc_gastos_de_representacion, 0, ldc_deduccion_basica, ldc_seguro_educativo,
                0,0,0,0,(ldc_deduccion_basica+ldc_seguro_educativo),
                ldc_renta_neta, ldc_impuesto_causado, 0, 0, ldc_retencion_salario, ldc_retencion_gasto,
                ldc_ajuste_a_favor, (ldc_retencion_salario + ldc_retencion_gasto + ldc_ajuste_a_favor),
                ldc_fisco, ldc_empleado);
        end loop;
    
    end if;    
    
    delete from pla_anexo_03
    where remuneraciones <= 0;
    
    return 1;
end;
' language plpgsql;


create function f_acumulado(char(2), char(7), int4, char(3)) returns decimal as '
declare
    as_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_anio alias for $3;
    as_concepto alias for $4;
    ldc_work1 decimal;
    ldc_work2 decimal;
begin
    ldc_work1 = 0;
    ldc_work2 = 0;
    
    select into ldc_work1 sum(pla_preelaborada.monto*nomconce.signo) from pla_preelaborada, nomconce
    where pla_preelaborada.cod_concepto_planilla = nomconce.cod_concepto_planilla
    and pla_preelaborada.compania = as_cia
    and pla_preelaborada.codigo_empleado = as_codigo_empleado
    and Anio(fecha) = ai_anio
    and pla_preelaborada.cod_concepto_planilla = as_concepto;
        
    select into ldc_work2 sum(nomconce.signo*nomctrac.monto)
    from nomconce, nomctrac
    where nomconce.cod_concepto_planilla = nomctrac.cod_concepto_planilla
    and nomctrac.compania = as_cia
    and nomctrac.codigo_empleado = as_codigo_empleado
    and nomctrac.year = ai_anio
    and nomctrac.cod_concepto_planilla = as_concepto;
    
    
    if ldc_work1 is null then
        ldc_work1 = 0;
    end if;
    
    if ldc_work2 is null then
        ldc_work2 = 0;
    end if;
    
    return ldc_work1 + ldc_work2;
end;
' language plpgsql;


create function f_acumulado_para(char(2), char(7), int4, char(3)) returns decimal as '
declare
    as_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_anio alias for $3;
    as_concepto alias for $4;
    ldc_work1 decimal;
    ldc_work2 decimal;
begin
    ldc_work1 = 0;
    ldc_work2 = 0;
    
    select into ldc_work1 sum(pla_preelaborada.monto*nomconce.signo) from pla_preelaborada, nomconce
    where pla_preelaborada.cod_concepto_planilla = nomconce.cod_concepto_planilla
    and compania = as_cia
    and codigo_empleado = as_codigo_empleado
    and Anio(fecha) = ai_anio
    and pla_preelaborada.cod_concepto_planilla in
        (select concepto_aplica from nom_conceptos_para_calculo
        where nom_conceptos_para_calculo.cod_concepto_planilla = as_concepto);
        
        
        
    select into ldc_work2 sum(nomconce.signo*nomctrac.monto)
    from nomconce, nomctrac
    where nomconce.cod_concepto_planilla = nomctrac.cod_concepto_planilla
    and nomctrac.compania = as_cia
    and nomctrac.codigo_empleado = as_codigo_empleado
    and nomctrac.year = ai_anio
    and nomctrac.cod_concepto_planilla in
        (select concepto_aplica from nom_conceptos_para_calculo
        where nom_conceptos_para_calculo.cod_concepto_planilla = as_concepto);
    
    
    if ldc_work1 is null then
        ldc_work1 = 0;
    end if;
    
    if ldc_work2 is null then
        ldc_work2 = 0;
    end if;
    
    return ldc_work1 + ldc_work2;
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
