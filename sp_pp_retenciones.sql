set search_path to planilla;

drop function f_pla_seguro_social(int4, char(7), int4, char(2)) cascade;
drop function f_pla_seguro_educativo(int4, char(7), int4, char(2)) cascade;
drop function f_pla_sindicato(int4, char(7), int4, char(2)) cascade;
drop function f_pla_sinticop(int4, char(7), int4, char(2)) cascade;
drop function f_pla_sindicato_chong(int4, char(7), int4, char(2)) cascade;

create function f_pla_sindicato_chong(int4, char(7), int4, char(2)) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    as_tipo_de_calculo alias for $4;
    r_pla_periodos record;
    r_pla_dinero record;
    r_pla_conceptos record;
    r_pla_empleados record;
    ldc_work decimal;
    i int4;
begin
-- SINTICOP = 203
-- SUNTRACTS = 202
-- SINDICATO = 150

   if ai_cia <> 992 then
        return 0;
    end if;
    
    
    select into r_pla_periodos * from pla_periodos
    where id = ai_id_periodos;
    
    select into r_pla_conceptos * from pla_conceptos
    where concepto = ''150'';
    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    
    if r_pla_empleados.sindicalizado <> ''S'' then
        return 0;
    end if;
    
    select into ldc_work sum(pla_dinero.monto*pla_conceptos.signo)
    from pla_dinero, pla_conceptos, pla_conceptos_acumulan
    where pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
    and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_dinero.id_periodos = ai_id_periodos
    and pla_dinero.compania = ai_cia
    and pla_conceptos_acumulan.concepto = ''150'';
    if ldc_work is null then
        ldc_work = 0;
    end if;
    
    ldc_work = ldc_work * .015;
    
    select into r_pla_dinero *
    from pla_dinero
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and tipo_de_calculo = as_tipo_de_calculo
    and id_periodos = ai_id_periodos
    and concepto = ''150'';
    
    delete from pla_dinero
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and tipo_de_calculo = as_tipo_de_calculo
    and id_periodos = ai_id_periodos
    and id_pla_cheques_1 is null
    and concepto = ''150''
    and id_pla_cheques_1 is null;

    
    select into r_pla_dinero *
    from pla_dinero
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and tipo_de_calculo = as_tipo_de_calculo
    and id_periodos = ai_id_periodos
    and concepto = ''150'';
    if not found then
        if ldc_work <> 0 then
        insert into pla_dinero(id_pla_departamentos, id_periodos, compania, codigo_empleado, tipo_de_calculo,
            concepto, forma_de_registro, descripcion, mes, monto)
        values (r_pla_empleados.departamento, ai_id_periodos, ai_cia, as_codigo_empleado, as_tipo_de_calculo, ''150'',
            ''A'', ''CUOTA SINDICAL GRUPO CHONG'', Mes(r_pla_periodos.dia_d_pago), ldc_work);
        end if;
    end if;
    
    return 1;
end;
' language plpgsql;



create function f_pla_sinticop(int4, char(7), int4, char(2)) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    as_tipo_de_calculo alias for $4;
    r_pla_periodos record;
    r_pla_dinero record;
    r_pla_conceptos record;
    r_pla_empleados record;
    ldc_work decimal;
    i int4;
begin
-- SINTICOP = 203
-- SUNTRACTS = 202


    if ai_cia <> 1046 then
        return 1;
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where id = ai_id_periodos;
    
    select into r_pla_conceptos * from pla_conceptos
    where concepto = ''203'';
    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    
    if r_pla_empleados.sindicalizado <> ''S'' then
        return 0;
    end if;
    
    select into ldc_work sum(pla_dinero.monto*pla_conceptos.signo)
    from pla_dinero, pla_conceptos, pla_conceptos_acumulan
    where pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
    and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_dinero.id_periodos = ai_id_periodos
    and pla_dinero.compania = ai_cia
    and pla_conceptos_acumulan.concepto = ''203'';
    if ldc_work is null then
        ldc_work = 0;
    end if;
    
    ldc_work = ldc_work * .01;
    
    select into r_pla_dinero *
    from pla_dinero
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and tipo_de_calculo = as_tipo_de_calculo
    and id_periodos = ai_id_periodos
    and concepto = ''203'';
    
    delete from pla_dinero
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and tipo_de_calculo = as_tipo_de_calculo
    and id_periodos = ai_id_periodos
    and id_pla_cheques_1 is null
    and concepto = ''203''
    and id_pla_cheques_1 is null;

    
    select into r_pla_dinero *
    from pla_dinero
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and tipo_de_calculo = as_tipo_de_calculo
    and id_periodos = ai_id_periodos
    and concepto = ''203'';
    if not found then
        if ldc_work <> 0 then
        insert into pla_dinero(id_pla_departamentos, id_periodos, compania, codigo_empleado, tipo_de_calculo,
            concepto, forma_de_registro, descripcion, mes, monto)
        values (r_pla_empleados.departamento, ai_id_periodos, ai_cia, as_codigo_empleado, as_tipo_de_calculo, ''203'',
            ''A'', ''SINTICOP'', Mes(r_pla_periodos.dia_d_pago), ldc_work);
        end if;
    end if;        

/*

    esta rutiona se comento por peticion de seceyco.
    viernes 26-diciembre-2014 seceyco. lirieth franas solicito eliminarla
    
    if as_tipo_de_calculo = ''1'' then
        ldc_work = 0;
        select into ldc_work sum(pla_horas.minutos_ampliacion*pla_horas.tasa_por_minuto)
        from pla_horas, pla_marcaciones, pla_tarjeta_tiempo
        where pla_horas.id_marcaciones = pla_marcaciones.id
        and pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
        and pla_horas.minutos_ampliacion is not null
        and pla_tarjeta_tiempo.compania = ai_cia
        and pla_tarjeta_tiempo.codigo_empleado = as_codigo_empleado
        and pla_tarjeta_tiempo.id_periodos = ai_id_periodos;
        if ldc_work is null then
            ldc_work = 0;
        end if;

        ldc_work    =   ldc_work * .02;

        select into r_pla_dinero *
        from pla_dinero
        where compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and tipo_de_calculo = as_tipo_de_calculo
        and id_periodos = ai_id_periodos
        and concepto = ''202'';
        if not found then
            if ldc_work <> 0 then
            insert into pla_dinero(id_pla_departamentos, id_periodos, compania, codigo_empleado, tipo_de_calculo,
                concepto, forma_de_registro, descripcion, mes, monto)
            values (r_pla_empleados.departamento, ai_id_periodos, ai_cia, as_codigo_empleado, as_tipo_de_calculo, ''202'',
                ''A'', ''SUNTRACTS'', Mes(r_pla_periodos.dia_d_pago), ldc_work);
            end if;
        end if;        
    end if;    
*/    
    return 1;
end;
' language plpgsql;


create function f_pla_sindicato(int4, char(7), int4, char(2)) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    as_tipo_de_calculo alias for $4;
    r_pla_periodos record;
    r_pla_dinero record;
    r_pla_conceptos record;
    r_pla_empleados record;
    ldc_work decimal;
    i int4;
begin
-- SINTICOP = 203
-- SUNTRACTS = 202

   if ai_cia = 1046 then
        return 1;
    end if;
    
    if trim(f_pla_parametros(ai_cia, ''suntracs'', ''N'', ''GET'')) <> ''S'' then
        return 1;
    end if;
       
    
    select into r_pla_periodos * from pla_periodos
    where id = ai_id_periodos;
    
    select into r_pla_conceptos * from pla_conceptos
    where concepto = ''202'';
    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    
    if r_pla_empleados.sindicalizado <> ''S'' then
        return 0;
    end if;
    
    select into ldc_work sum(pla_dinero.monto*pla_conceptos.signo)
    from pla_dinero, pla_conceptos, pla_conceptos_acumulan
    where pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
    and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_dinero.id_periodos = ai_id_periodos
    and pla_dinero.compania = ai_cia
    and pla_conceptos_acumulan.concepto = ''202'';
    if ldc_work is null then
        ldc_work = 0;
    end if;
    
    ldc_work = ldc_work * .02;
    
    select into r_pla_dinero *
    from pla_dinero
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and tipo_de_calculo = as_tipo_de_calculo
    and id_periodos = ai_id_periodos
    and concepto = ''202'';
    
    delete from pla_dinero
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and tipo_de_calculo = as_tipo_de_calculo
    and id_periodos = ai_id_periodos
    and id_pla_cheques_1 is null
    and concepto = ''202''
    and id_pla_cheques_1 is null;

    
    select into r_pla_dinero *
    from pla_dinero
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and tipo_de_calculo = as_tipo_de_calculo
    and id_periodos = ai_id_periodos
    and concepto = ''202'';
    if not found then
        if ldc_work <> 0 then
        insert into pla_dinero(id_pla_departamentos, id_periodos, compania, codigo_empleado, tipo_de_calculo,
            concepto, forma_de_registro, descripcion, mes, monto)
        values (r_pla_empleados.departamento, ai_id_periodos, ai_cia, as_codigo_empleado, as_tipo_de_calculo, ''202'',
            ''A'', ''SUNTRACS'', Mes(r_pla_periodos.dia_d_pago), ldc_work);
        end if;
    end if;
    
    
    if ai_cia = 1341 and r_pla_periodos.periodo = 2 then
        select into r_pla_dinero *
        from pla_dinero
        where compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and tipo_de_calculo = as_tipo_de_calculo
        and id_periodos = ai_id_periodos
        and concepto = ''131'';
        if not found then
            ldc_work = 2.25;
            insert into pla_dinero(id_pla_departamentos, id_periodos, compania, codigo_empleado, tipo_de_calculo,
                concepto, forma_de_registro, descripcion, mes, monto)
            values (r_pla_empleados.departamento, ai_id_periodos, ai_cia, as_codigo_empleado, as_tipo_de_calculo, ''131'',
                ''A'', ''SEGURO COLECTIVO'', Mes(r_pla_periodos.dia_d_pago), ldc_work);
        end if;
    end if;

    return 1;
end;
' language plpgsql;




create function f_pla_seguro_educativo(int4, char(7), int4, char(2)) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    as_tipo_de_calculo alias for $4;
    r_pla_periodos record;
    r_pla_dinero record;
    r_pla_conceptos record;
    r_pla_empleados record;
    ldc_work decimal;
    ldc_prima_produccion decimal;
    ldc_ss decimal;
    ldc_salario decimal;
    i int4;
begin
    delete from pla_dinero
    where pla_dinero.compania = ai_cia
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_dinero.id_periodos = ai_id_periodos
    and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
    and pla_dinero.concepto in (''104'')
    and id_pla_cheques_1 is null;


    select into r_pla_periodos * from pla_periodos
    where id = ai_id_periodos;
    
    select into r_pla_conceptos * from pla_conceptos
    where concepto = ''104'';
    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    else
        if r_pla_empleados.retiene_ss = ''N'' then
            return 0;
        end if;
    end if;


    ldc_prima_produccion = 0;
    select into ldc_prima_produccion sum(pla_dinero.monto*pla_conceptos.signo)
    from pla_dinero, pla_conceptos, pla_periodos
    where pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.id_periodos = pla_periodos.id
    and pla_dinero.compania = ai_cia
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
    and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
    and pla_periodos.dia_d_pago <= r_pla_periodos.dia_d_pago
    and pla_dinero.concepto = ''81'';
    if ldc_prima_produccion is null then
        ldc_prima_produccion = 0;
    end if;
 
     if ai_cia = 1142 then
        ldc_prima_produccion = 0;
    end if;

    
    if ldc_prima_produccion = 0 then
        select into ldc_work sum(pla_dinero.monto*pla_conceptos.signo)
        from pla_dinero, pla_conceptos, pla_conceptos_acumulan
        where pla_dinero.concepto = pla_conceptos.concepto
        and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
        and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
        and pla_dinero.codigo_empleado = as_codigo_empleado
        and pla_dinero.id_periodos = ai_id_periodos
        and pla_dinero.compania = ai_cia
        and pla_conceptos_acumulan.concepto = ''104'';
        if ldc_work is null then
            ldc_work = 0;
        end if;
    else
        if Extract(Day from r_pla_periodos.dia_d_pago) > 15 then
            ldc_salario = 0;
            select into ldc_salario sum(pla_dinero.monto*pla_conceptos.signo)
            from pla_dinero, pla_conceptos, pla_conceptos_acumulan, pla_periodos
            where pla_dinero.concepto = pla_conceptos.concepto
            and pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = as_codigo_empleado
            and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
            and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
            and pla_conceptos_acumulan.concepto = ''104'';
            if ldc_salario is null then
                ldc_salario = 0;
            end if;

            ldc_prima_produccion = 0;
            select into ldc_prima_produccion sum(pla_dinero.monto*pla_conceptos.signo)
            from pla_dinero, pla_conceptos, pla_periodos
            where pla_dinero.concepto = pla_conceptos.concepto
            and pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = as_codigo_empleado
            and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
            and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
            and pla_dinero.concepto = ''81'';
            if ldc_prima_produccion is null then
                ldc_prima_produccion = 0;
            end if;

            ldc_ss = 0;
            select into ldc_ss sum(pla_dinero.monto*pla_conceptos.signo)
            from pla_dinero, pla_conceptos, pla_periodos
            where pla_dinero.concepto = pla_conceptos.concepto
            and pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = as_codigo_empleado
            and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
            and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
            and pla_dinero.concepto = ''104'';
            if ldc_ss is null then
                ldc_ss = 0;
            end if;

            if ldc_prima_produccion > ldc_salario / 2 then
                ldc_work    =   ldc_salario + (ldc_prima_produccion - (ldc_salario/2));

                ldc_work    =   (ldc_work * (r_pla_conceptos.porcentaje/100));

                ldc_ss      =   ldc_work + ldc_ss;

                ldc_work    =   ldc_ss / (r_pla_conceptos.porcentaje/100);
            else
                select into ldc_work sum(pla_dinero.monto*pla_conceptos.signo)
                from pla_dinero, pla_conceptos, pla_conceptos_acumulan
                where pla_dinero.concepto = pla_conceptos.concepto
                and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
                and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
                and pla_dinero.codigo_empleado = as_codigo_empleado
                and pla_dinero.id_periodos = ai_id_periodos
                and pla_dinero.compania = ai_cia
                and pla_conceptos_acumulan.concepto = ''104'';
                if ldc_work is null then
                    ldc_work = 0;
                end if;
            end if;
        else
            ldc_salario = 0;
            select into ldc_salario sum(pla_dinero.monto*pla_conceptos.signo)
            from pla_dinero, pla_conceptos, pla_conceptos_acumulan, pla_periodos
            where pla_dinero.concepto = pla_conceptos.concepto
            and pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = as_codigo_empleado
            and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
            and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
            and pla_periodos.dia_d_pago <= r_pla_periodos.dia_d_pago
            and pla_conceptos_acumulan.concepto = ''104'';
            if ldc_salario is null then
                ldc_salario = 0;
            end if;

            
            ldc_prima_produccion = 0;
            select into ldc_prima_produccion sum(pla_dinero.monto*pla_conceptos.signo)
            from pla_dinero, pla_conceptos, pla_periodos
            where pla_dinero.concepto = pla_conceptos.concepto
            and pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = as_codigo_empleado
            and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
            and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
            and pla_periodos.dia_d_pago <= r_pla_periodos.dia_d_pago
            and pla_dinero.concepto = ''81'';
            if ldc_prima_produccion is null then
                ldc_prima_produccion = 0;
            end if;

            ldc_ss = 0;
            select into ldc_ss sum(pla_dinero.monto*pla_conceptos.signo)
            from pla_dinero, pla_conceptos, pla_periodos
            where pla_dinero.concepto = pla_conceptos.concepto
            and pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = as_codigo_empleado
            and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
            and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
            and pla_periodos.dia_d_pago <= r_pla_periodos.dia_d_pago
            and pla_dinero.concepto = ''104'';
            if ldc_ss is null then
                ldc_ss = 0;
            end if;


            if ldc_prima_produccion > ldc_salario then
                ldc_work    =   ldc_salario + (ldc_prima_produccion - ldc_salario);
            else
                ldc_work    =   ldc_salario;
            end if;



            ldc_work    =   (ldc_work * (r_pla_conceptos.porcentaje/100));

            ldc_ss      =   ldc_work + ldc_ss;


            
            ldc_work    =   ldc_ss / (r_pla_conceptos.porcentaje/100);
        end if;
    end if;    
    
    
    ldc_work = ldc_work * (r_pla_conceptos.porcentaje/100);
  
    
/*    
    select into r_pla_dinero *
    from pla_dinero
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and tipo_de_calculo = as_tipo_de_calculo
    and id_periodos = ai_id_periodos
    and concepto = ''104'';
    
    
    delete from pla_dinero
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and tipo_de_calculo = as_tipo_de_calculo
    and id_periodos = ai_id_periodos
    and id_pla_cheques_1 is null
    and concepto = ''104''
    and id_pla_cheques_1 is null;
*/
  
if ldc_work <> 0 then    
    select into r_pla_dinero *
    from pla_dinero
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and tipo_de_calculo = as_tipo_de_calculo
    and id_periodos = ai_id_periodos
    and concepto = ''104'';
    if not found then
 -- raise exception ''entre % %'', ldc_work, ldc_ss;
        insert into pla_dinero(id_pla_departamentos, id_periodos, compania, codigo_empleado, tipo_de_calculo,
            concepto, forma_de_registro, descripcion, mes, monto)
        values (r_pla_empleados.departamento, ai_id_periodos, ai_cia, as_codigo_empleado, as_tipo_de_calculo, ''104'',
            ''A'', ''SEGURO EDUCATIVO'', Mes(r_pla_periodos.dia_d_pago), ldc_work);
    end if;        
end if;
    
    return 1;
end;
' language plpgsql;





create function f_pla_seguro_social(int4, char(7), int4, char(2)) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    as_tipo_de_calculo alias for $4;
    r_pla_periodos record;
    r_pla_dinero record;
    r_pla_conceptos record;
    r_pla_empleados record;
    i int4;
    ls_concepto char(3);
    lvc_suntracs varchar(50);
    ldc_work decimal;
    ldc_ss_gto decimal;
    ldc_gto_representacion decimal;
    ldc_work2 decimal;
    ldc_isr decimal;
    ldc_salario_neto decimal;
    ldc_prima_produccion decimal;
    ldc_salario decimal;
    ldc_aguinaldo_navidad decimal;
    ldc_ss decimal;
begin

-- 74  = Gratificaciones y Aguinaldo
-- 81  = Prima de produccion
-- 106 = isr
-- 107 = vacaciones del gto de representacion
-- 108 = vacaciones
-- 109 = xiii mes
-- 125 = xiii mes del gto de representacion
-- 310 = isr del gto de representaicon
-- 102 = Seguro Social (salario)
-- 103 = Seguro Social (xiii mes)
-- 104 = Seguro Educativo
-- 203 = SINTICOP
-- 202 = SUNTRACTS

    lvc_suntracs    =   trim(f_pla_parametros(ai_cia, ''suntracs'', ''N'', ''GET''));

    delete from pla_dinero
    where pla_dinero.compania = ai_cia
    and Trim(pla_dinero.codigo_empleado) = trim(as_codigo_empleado)
    and pla_dinero.id_periodos = ai_id_periodos
    and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
    and pla_dinero.concepto in (''102'',''103'')
    and id_pla_cheques_1 is null;

    
    select into r_pla_empleados * 
    from pla_empleados
    where compania = ai_cia
    and trim(codigo_empleado) = trim(as_codigo_empleado);
    if not found then
        return 0;
    else
        if r_pla_empleados.retiene_ss = ''N'' then
            return 0;
        end if;
    end if;
    
    ldc_work = 0;
    ldc_ss_gto = 0;
    
    delete from pla_dinero
    where pla_dinero.compania = ai_cia
    and Trim(pla_dinero.codigo_empleado) = Trim(as_codigo_empleado)
    and pla_dinero.id_periodos = ai_id_periodos
    and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
    and pla_dinero.concepto in (''106'',''310'')
    and forma_de_registro = ''A''
    and id_pla_cheques_1 is null;
    
    
    ldc_salario_neto = f_pla_salario_neto(ai_cia, as_codigo_empleado, as_tipo_de_calculo, ai_id_periodos);
    if ldc_salario_neto < 0 then
        delete from pla_dinero
        where pla_dinero.compania = ai_cia
        and pla_dinero.codigo_empleado = as_codigo_empleado
        and pla_dinero.id_periodos = ai_id_periodos
        and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
        and forma_de_registro = ''A'';
    
--        Raise Exception ''Salario Neto debe ser mayor a cero  Empleado % Periodo %   Salario %'',as_codigo_empleado, ai_id_periodos, ldc_salario_neto;
    end if;
    
    select into ldc_work sum(pla_dinero.monto*pla_conceptos.signo)
    from pla_dinero, pla_conceptos
    where pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.compania = ai_cia
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_dinero.id_periodos = ai_id_periodos
    and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
    and pla_dinero.id_pla_cheques_1 is null;
    if ldc_work is null or ldc_work = 0 then
        return 0;
    end if;
    
    
    select into r_pla_periodos * from pla_periodos
    where id = ai_id_periodos;
    if r_pla_periodos.status = ''C'' then
        return 0;
    end if;
    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;


    select into r_pla_conceptos * from pla_conceptos
    where concepto = ''102'';
    if not found then
        return 0;
    else
        if r_pla_periodos.dia_d_pago >= ''2013-01-01'' then
            r_pla_conceptos.porcentaje = 9.75;
        elsif r_pla_periodos.dia_d_pago >= ''2011-01-01'' then
            r_pla_conceptos.porcentaje = 9;
        elsif r_pla_periodos.dia_d_pago >= ''2008-06-01'' then
            r_pla_conceptos.porcentaje = 8;
        end if;
    end if;

    ldc_aguinaldo_navidad = 0;
    select into ldc_aguinaldo_navidad sum(pla_dinero.monto*pla_conceptos.signo)
    from pla_dinero, pla_conceptos, pla_periodos
    where pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.id_periodos = pla_periodos.id
    and pla_dinero.compania = ai_cia
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
    and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
    and pla_periodos.dia_d_pago <= r_pla_periodos.dia_d_pago
    and pla_dinero.concepto = ''74'';
    if ldc_aguinaldo_navidad is null then
        ldc_aguinaldo_navidad = 0;
    end if;

    ldc_prima_produccion = 0;
    select into ldc_prima_produccion sum(pla_dinero.monto*pla_conceptos.signo)
    from pla_dinero, pla_conceptos, pla_periodos
    where pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.id_periodos = pla_periodos.id
    and pla_dinero.compania = ai_cia
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
    and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
    and pla_periodos.dia_d_pago <= r_pla_periodos.dia_d_pago
    and pla_dinero.concepto = ''81'';
    if ldc_prima_produccion is null then
        ldc_prima_produccion = 0;
    end if;
    
    if ai_cia = 1142 then
        ldc_prima_produccion = 0;
    end if;

    
    if ldc_prima_produccion = 0 and ldc_aguinaldo_navidad = 0 then
        ldc_work = 0;
        select into ldc_work sum(pla_dinero.monto*pla_conceptos.signo)
        from pla_dinero, pla_conceptos, pla_conceptos_acumulan
        where pla_dinero.concepto = pla_conceptos.concepto
        and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
        and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
        and pla_dinero.codigo_empleado = as_codigo_empleado
        and pla_dinero.id_periodos = ai_id_periodos
        and pla_dinero.compania = ai_cia
        and pla_conceptos_acumulan.concepto = ''102'';
        if ldc_work is null then
            ldc_work = 0;
        end if;
        
    elsif ldc_aguinaldo_navidad > 0 then
        if Extract(Day from r_pla_periodos.dia_d_pago) > 15 then

            ldc_salario = 0;
            select into ldc_salario sum(pla_dinero.monto*pla_conceptos.signo)
            from pla_dinero, pla_conceptos, pla_conceptos_acumulan, pla_periodos
            where pla_dinero.concepto = pla_conceptos.concepto
            and pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = as_codigo_empleado
            and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
            and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
            and pla_conceptos_acumulan.concepto = ''102'';
            if ldc_salario is null then
                ldc_salario = 0;
            end if;


            ldc_aguinaldo_navidad = 0;
            select into ldc_aguinaldo_navidad sum(pla_dinero.monto*pla_conceptos.signo)
            from pla_dinero, pla_conceptos, pla_periodos
            where pla_dinero.concepto = pla_conceptos.concepto
            and pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = as_codigo_empleado
            and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
            and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
            and pla_dinero.concepto = ''74'';
            if ldc_aguinaldo_navidad is null then
                ldc_aguinaldo_navidad = 0;
            end if;

            ldc_ss = 0;
            select into ldc_ss sum(pla_dinero.monto*pla_conceptos.signo)
            from pla_dinero, pla_conceptos, pla_periodos
            where pla_dinero.concepto = pla_conceptos.concepto
            and pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = as_codigo_empleado
            and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
            and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
            and pla_dinero.concepto = ''102'';
            if ldc_ss is null then
                ldc_ss = 0;
            end if;

            if ldc_aguinaldo_navidad > ldc_salario then
                ldc_work    =   ldc_salario + (ldc_aguinaldo_navidad - ldc_salario);

--raise exception ''%'', ldc_work;

                ldc_work    =   (ldc_work * (r_pla_conceptos.porcentaje/100));

                ldc_ss      =   ldc_work + ldc_ss;

                ldc_work    =   ldc_ss / (r_pla_conceptos.porcentaje/100);
            else
                ldc_work = 0;
                select into ldc_work sum(pla_dinero.monto*pla_conceptos.signo)
                from pla_dinero, pla_conceptos, pla_conceptos_acumulan
                where pla_dinero.concepto = pla_conceptos.concepto
                and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
                and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
                and pla_dinero.codigo_empleado = as_codigo_empleado
                and pla_dinero.id_periodos = ai_id_periodos
                and pla_dinero.compania = ai_cia
                and pla_conceptos_acumulan.concepto = ''102'';
                if ldc_work is null then
                    ldc_work = 0;
                end if;
            end if;
        else
            ldc_salario = 0;
            select into ldc_salario sum(pla_dinero.monto*pla_conceptos.signo)
            from pla_dinero, pla_conceptos, pla_conceptos_acumulan, pla_periodos
            where pla_dinero.concepto = pla_conceptos.concepto
            and pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = as_codigo_empleado
            and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
            and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
            and pla_periodos.dia_d_pago <= r_pla_periodos.dia_d_pago
            and pla_conceptos_acumulan.concepto = ''102'';
            if ldc_salario is null then
                ldc_salario = 0;
            end if;

            
            ldc_aguinaldo_navidad = 0;
            select into ldc_prima_produccion sum(pla_dinero.monto*pla_conceptos.signo)
            from pla_dinero, pla_conceptos, pla_periodos
            where pla_dinero.concepto = pla_conceptos.concepto
            and pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = as_codigo_empleado
            and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
            and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
            and pla_periodos.dia_d_pago <= r_pla_periodos.dia_d_pago
            and pla_dinero.concepto = ''74'';
            if ldc_aguinaldo_navidad is null then
                ldc_aguinaldo_navidad = 0;
            end if;

            ldc_ss = 0;
            select into ldc_ss sum(pla_dinero.monto*pla_conceptos.signo)
            from pla_dinero, pla_conceptos, pla_periodos
            where pla_dinero.concepto = pla_conceptos.concepto
            and pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = as_codigo_empleado
            and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
            and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
            and pla_periodos.dia_d_pago <= r_pla_periodos.dia_d_pago
            and pla_dinero.concepto = ''102'';
            if ldc_ss is null then
                ldc_ss = 0;
            end if;

            if ldc_aguinaldo_navidad > ldc_salario then
                ldc_work    =   ldc_salario + (ldc_aguinaldo_navidad - ldc_salario);
            else
                ldc_work    =   ldc_salario;
            end if;

            ldc_work    =   (ldc_work * (r_pla_conceptos.porcentaje/100));

            ldc_ss      =   ldc_work + ldc_ss;
            
            ldc_work    =   ldc_ss / (r_pla_conceptos.porcentaje/100);
        end if;
    else

        if Extract(Day from r_pla_periodos.dia_d_pago) > 15 then
            ldc_salario = 0;
            select into ldc_salario sum(pla_dinero.monto*pla_conceptos.signo)
            from pla_dinero, pla_conceptos, pla_conceptos_acumulan, pla_periodos
            where pla_dinero.concepto = pla_conceptos.concepto
            and pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = as_codigo_empleado
            and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
            and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
            and pla_conceptos_acumulan.concepto = ''102'';
            if ldc_salario is null then
                ldc_salario = 0;
            end if;


            ldc_prima_produccion = 0;
            select into ldc_prima_produccion sum(pla_dinero.monto*pla_conceptos.signo)
            from pla_dinero, pla_conceptos, pla_periodos
            where pla_dinero.concepto = pla_conceptos.concepto
            and pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = as_codigo_empleado
            and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
            and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
            and pla_dinero.concepto = ''81'';
            if ldc_prima_produccion is null then
                ldc_prima_produccion = 0;
            end if;

            ldc_ss = 0;
            select into ldc_ss sum(pla_dinero.monto*pla_conceptos.signo)
            from pla_dinero, pla_conceptos, pla_periodos
            where pla_dinero.concepto = pla_conceptos.concepto
            and pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = as_codigo_empleado
            and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
            and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
            and pla_dinero.concepto = ''102'';
            if ldc_ss is null then
                ldc_ss = 0;
            end if;

            
            if ldc_prima_produccion > ldc_salario / 2 then
                ldc_work    =   ldc_salario + (ldc_prima_produccion - (ldc_salario/2));


                ldc_work    =   (ldc_work * (r_pla_conceptos.porcentaje/100));

                ldc_ss      =   ldc_work + ldc_ss;

                ldc_work    =   ldc_ss / (r_pla_conceptos.porcentaje/100);
            else
                ldc_work = 0;
                select into ldc_work sum(pla_dinero.monto*pla_conceptos.signo)
                from pla_dinero, pla_conceptos, pla_conceptos_acumulan
                where pla_dinero.concepto = pla_conceptos.concepto
                and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
                and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
                and pla_dinero.codigo_empleado = as_codigo_empleado
                and pla_dinero.id_periodos = ai_id_periodos
                and pla_dinero.compania = ai_cia
                and pla_conceptos_acumulan.concepto = ''102'';
                if ldc_work is null then
                    ldc_work = 0;
                end if;
            end if;
        else
            ldc_salario = 0;
            select into ldc_salario sum(pla_dinero.monto*pla_conceptos.signo)
            from pla_dinero, pla_conceptos, pla_conceptos_acumulan, pla_periodos
            where pla_dinero.concepto = pla_conceptos.concepto
            and pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = as_codigo_empleado
            and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
            and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
            and pla_periodos.dia_d_pago <= r_pla_periodos.dia_d_pago
            and pla_conceptos_acumulan.concepto = ''102'';
            if ldc_salario is null then
                ldc_salario = 0;
            end if;

            
            ldc_prima_produccion = 0;
            select into ldc_prima_produccion sum(pla_dinero.monto*pla_conceptos.signo)
            from pla_dinero, pla_conceptos, pla_periodos
            where pla_dinero.concepto = pla_conceptos.concepto
            and pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = as_codigo_empleado
            and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
            and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
            and pla_periodos.dia_d_pago <= r_pla_periodos.dia_d_pago
            and pla_dinero.concepto = ''81'';
            if ldc_prima_produccion is null then
                ldc_prima_produccion = 0;
            end if;

            ldc_ss = 0;
            select into ldc_ss sum(pla_dinero.monto*pla_conceptos.signo)
            from pla_dinero, pla_conceptos, pla_periodos
            where pla_dinero.concepto = pla_conceptos.concepto
            and pla_dinero.id_periodos = pla_periodos.id
            and pla_dinero.compania = ai_cia
            and pla_dinero.codigo_empleado = as_codigo_empleado
            and Mes(pla_periodos.dia_d_pago) = Mes(r_pla_periodos.dia_d_pago)
            and Anio(pla_periodos.dia_d_pago) = Anio(r_pla_periodos.dia_d_pago)
            and pla_periodos.dia_d_pago <= r_pla_periodos.dia_d_pago
            and pla_dinero.concepto = ''102'';
            if ldc_ss is null then
                ldc_ss = 0;
            end if;

            if ldc_prima_produccion > ldc_salario then
                ldc_work    =   ldc_salario + (ldc_prima_produccion - ldc_salario);
            else
                ldc_work    =   ldc_salario;
            end if;

            ldc_work    =   (ldc_work * (r_pla_conceptos.porcentaje/100));

            ldc_ss      =   ldc_work + ldc_ss;
            
            ldc_work    =   ldc_ss / (r_pla_conceptos.porcentaje/100);
            
        end if;
    end if;    
    
    ldc_work    =   (ldc_work * (r_pla_conceptos.porcentaje/100));
    
    if ldc_work > 0 then
        insert into pla_dinero(id_pla_departamentos, id_periodos, compania, codigo_empleado, tipo_de_calculo,
            concepto, forma_de_registro, descripcion, mes, monto)
        values (r_pla_empleados.departamento, ai_id_periodos, ai_cia, as_codigo_empleado, as_tipo_de_calculo, 
            ''102'', ''A'', ''SEGURO SOCIAL'', Mes(r_pla_periodos.dia_d_pago), ldc_work);
    end if;

--    i   =   f_reservas_ss_pdp(ai_cia, as_codigo_empleado, Anio(r_pla_periodos.dia_d_pago), Mes(r_pla_periodos.dia_d_pago));
    
    select into r_pla_conceptos * from pla_conceptos
    where concepto in (''103'');
    if not found then
        return 0;
    else
        if r_pla_periodos.dia_d_pago >= ''2008-06-01'' then
            r_pla_conceptos.porcentaje = 7.25;
        end if;
    end if;

    ldc_work = 0;
    select into ldc_work sum(pla_dinero.monto*pla_conceptos.signo)
    from pla_dinero, pla_conceptos, pla_conceptos_acumulan
    where pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.concepto = pla_conceptos_acumulan.concepto_aplica
    and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_dinero.id_periodos = ai_id_periodos
    and pla_dinero.compania = ai_cia
    and pla_conceptos_acumulan.concepto = ''103'';
    if ldc_work is null then
        ldc_work = 0;
    end if;

    ldc_work    =   (ldc_work * (r_pla_conceptos.porcentaje/100));

    if ldc_work > 0 then
        insert into pla_dinero(id_pla_departamentos, id_periodos, compania, codigo_empleado, tipo_de_calculo,
            concepto, forma_de_registro, descripcion, mes, monto)
        values (r_pla_empleados.departamento, ai_id_periodos, ai_cia, as_codigo_empleado, as_tipo_de_calculo, 
            ''103'', ''A'', ''SEGURO SOCIAL DEL XIII'', Mes(r_pla_periodos.dia_d_pago), ldc_work);
    end if;


    if ai_cia = 1046 then
        i   =   f_pla_sinticop(ai_cia, as_codigo_empleado, ai_id_periodos, as_tipo_de_calculo);
    else
        if trim(lvc_suntracs) = ''S'' and r_pla_empleados.sindicalizado = ''S'' then
            i   =   f_pla_sindicato(ai_cia, as_codigo_empleado, ai_id_periodos, as_tipo_de_calculo);
        end if;
    end if;        

    i   =   f_isr(ai_id_periodos, as_codigo_empleado, as_tipo_de_calculo);

    return 1;
end;
' language plpgsql;
