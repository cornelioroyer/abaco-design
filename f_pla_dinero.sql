
drop function f_pla_dinero(int4, char(7), int4) cascade;

create function f_pla_dinero(int4, char(7), int4) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_turnos record;
    r_pla_vacaciones record;
    r_pla_periodos record;
    r_pla_conceptos record;
    r_v_pla_horas_valorizadas record;
    r_v_pla_implementos_valorizados record;
    r_pla_dinero record;
    r_pla_work record;
    r_work record;
    ldt_entrada_turno timestamp;
    ldt_salida_turno timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    li_minutos_regulares int4;
    ldc_work decimal;
    ldc_suma decimal;
    ldc_salario_regular decimal;
    ldc_salario_neto decimal;
    ldc_gto_representacion decimal;
    ldc_monto decimal;
    i int4;
    li_count int4;
    lb_vacaciones boolean;
    ld_work date;
    ld_desde date;
    lc_pagar_salario_en_vacaciones varchar(10);
    lc_primer_salario_completo varchar(10);
begin
    lc_pagar_salario_en_vacaciones      =   Trim(f_pla_parametros(ai_cia, ''pagar_salario_en_vacaciones'', ''N'', ''GET''));
    lc_primer_salario_completo          =   Trim(f_pla_parametros(ai_cia, ''primer_salario_completo'', ''N'', ''GET''));

    
    delete from pla_dinero
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and forma_de_registro = ''A''
    and tipo_de_calculo = ''1''
    and id_periodos = ai_id_periodos
    and id_pla_cheques_1 is null;

    ld_work = current_date - 5;


    select into r_pla_periodos *
    from pla_periodos
    where id = ai_id_periodos;
    
/*
    select into r_pla_dinero *
    from pla_dinero, pla_periodos
    where pla_dinero.compania = ai_cia
    and pla_dinero.id_periodos = pla_periodos.id
    and codigo_empleado = as_codigo_empleado
    and pla_periodos.dia_d_pago >= r_pla_periodos.desde
    and tipo_de_calculo = ''7''
    and pla_dinero.monto <> 0;
    if found then
        return 0;
    end if;    
*/
    
    for r_pla_dinero in 
        select * from pla_dinero
        where compania = ai_cia
        and id_periodos = ai_id_periodos
        and codigo_empleado = as_codigo_empleado
        and tipo_de_calculo = ''1''
        and id_pla_cheques_1 is not null
    loop
        return 0;
    end loop;


    i = 0;
    select count(*) into i
    from pla_tarjeta_tiempo, pla_marcaciones
    where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
    and pla_tarjeta_tiempo.compania = ai_cia
    and pla_tarjeta_tiempo.codigo_empleado = as_codigo_empleado
    and pla_tarjeta_tiempo.id_periodos = ai_id_periodos;
    if not found or i = 0 or i is null then
        return 0;
    end if;

    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    
    
    if r_pla_empleados.status = ''L'' 
        or r_pla_empleados.status = ''I'' 
        or r_pla_empleados.status = ''E'' then
        return 0;
    end if;

    if r_pla_empleados.status = ''V'' 
        and trim(lc_pagar_salario_en_vacaciones) = ''N'' then
        return 0;
    end if;

--raise exception ''entre'';    

    select into r_pla_periodos * from pla_periodos
    where id = ai_id_periodos;
    
    i   =   f_pla_bonos_de_produccion(ai_cia, as_codigo_empleado, ai_id_periodos);

    select into r_pla_vacaciones * 
    from pla_vacaciones
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and (r_pla_periodos.desde between pagar_desde and pagar_hasta
    or r_pla_periodos.hasta between pagar_desde and pagar_hasta);
    if found then
        lb_vacaciones = true;
--        ld_desde = r_pla_vacaciones.pagar_hasta+1;
        ld_desde    =   r_pla_periodos.desde;
    else
        lb_vacaciones = false;
        ld_desde = r_pla_empleados.fecha_inicio;
    end if;

    if r_pla_vacaciones.status = ''A'' then
        lb_vacaciones = true;
    else
        lb_vacaciones = false;
    end if;

--raise exception ''entre % %'',lb_vacaciones, ld_desde;
    
    ld_work = ''2100-01-01'';
    select into ld_work Min(fecha)
    from v_pla_horas_valorizadas
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and id_periodos = ai_id_periodos;
    if ld_work is null or not found then
        ld_work = ''2100-01-01'';
    else
        if ld_work < ld_desde then
            ld_desde = ld_work;
        end if;
    end if;
    

    li_count = 0;
    select into li_count Count(*)
    from v_pla_horas_valorizadas
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and id_periodos = ai_id_periodos
    and id_pla_proyectos in (1838,2012);
    if li_count is null then
        li_count = 0;
    end if;
    
    if li_count > 0 then
        r_pla_empleados.tipo_de_salario = ''H'';
    end if;


    
    if (r_pla_empleados.fecha_inicio 
        between r_pla_periodos.desde and r_pla_periodos.dia_d_pago
        and r_pla_empleados.tipo_de_salario = ''F'' 
        and extract(day from r_pla_empleados.fecha_inicio) <> 1)
        or 
        (r_pla_empleados.fecha_inicio 
        between r_pla_periodos.desde and r_pla_periodos.dia_d_pago
        and r_pla_empleados.tipo_de_salario = ''F'' 
        and trim(lc_primer_salario_completo) = ''N'') 
        or 
        (r_pla_empleados.fecha_terminacion_real
        between r_pla_periodos.desde and r_pla_periodos.dia_d_pago) then
        for r_v_pla_horas_valorizadas in
            select * from v_pla_horas_valorizadas
            where compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''1''
            and id_periodos = ai_id_periodos
            and fecha >= ld_desde
            order by fecha
        loop
            select into r_pla_conceptos * from pla_conceptos
            where concepto = r_v_pla_horas_valorizadas.concepto;


/*            
            if ai_cia = 1142 and r_pla_empleados.tipo = ''2''
                and (r_v_pla_horas_valorizadas.tipo_de_hora = ''30'' or r_v_pla_horas_valorizadas.tipo_de_hora = ''93'') then
                r_v_pla_horas_valorizadas.monto = 22;
                raise exception ''entre'';
            end if;
*/

            select into r_pla_dinero * from pla_dinero
            where id_periodos = ai_id_periodos
            and compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''1''
            and concepto = r_v_pla_horas_valorizadas.concepto
            and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos
            and forma_de_registro = ''M'';
            if found then
                continue;
            end if;

            
            select into r_pla_dinero * from pla_dinero
            where id_periodos = ai_id_periodos
            and compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''1''
            and concepto = r_v_pla_horas_valorizadas.concepto
            and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos;
            if found then
                ldc_monto   =   r_pla_dinero.monto + (r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo);
                
                if trim(r_v_pla_horas_valorizadas.concepto) = ''03''
                    and ldc_monto > r_pla_empleados.salario_bruto then
                    ldc_monto = r_pla_empleados.salario_bruto;
                end if;
                
                update pla_dinero
                set monto = ldc_monto 
                where id_periodos = ai_id_periodos
                and compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and tipo_de_calculo = ''1''
                and forma_de_registro = ''A''
                and id_pla_cheques_1 is null
                and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos
                and concepto = r_v_pla_horas_valorizadas.concepto;
            else

                insert into pla_dinero(id_periodos, compania, codigo_empleado,
                    tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                    monto, id_pla_proyectos, id_pla_departamentos)
                values(ai_id_periodos, ai_cia, as_codigo_empleado, ''1'',r_v_pla_horas_valorizadas.concepto,
                    ''A'', r_v_pla_horas_valorizadas.descripcion, Mes(r_pla_periodos.dia_d_pago),
                    r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo,
                    r_v_pla_horas_valorizadas.id_pla_proyectos,
                    r_v_pla_horas_valorizadas.id_pla_departamentos);
            end if;
        end loop;
        
    elsif r_pla_empleados.tipo_de_salario = ''H'' or 
        r_pla_empleados.fecha_terminacion_real is not null or lb_vacaciones then

        if r_pla_empleados.tipo_de_salario = ''F'' and not lb_vacaciones then
--            ld_desde    =   f_primer_dia_del_mes(r_pla_periodos.hasta);
        end if;
        
--raise exception ''%'',ld_desde;
        
        for r_v_pla_horas_valorizadas in
            select * from v_pla_horas_valorizadas
            where compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and id_periodos = ai_id_periodos
            and fecha >= ld_desde
            order by fecha
        loop
            select into r_pla_conceptos * from pla_conceptos
            where concepto = r_v_pla_horas_valorizadas.concepto;


/*            
            if ai_cia = 1142 and r_pla_empleados.tipo = ''2''
                and (r_v_pla_horas_valorizadas.tipo_de_hora = ''30'' or r_v_pla_horas_valorizadas.tipo_de_hora = ''93'') then
                r_v_pla_horas_valorizadas.monto = 22;
                raise exception ''entre'';
            end if;
*/          
        
            select into r_pla_dinero * from pla_dinero
            where id_periodos = ai_id_periodos
            and compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''1''
            and concepto = r_v_pla_horas_valorizadas.concepto
            and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos
            and forma_de_registro = ''M'';
            if found then
                continue;
            end if;
            
            select into r_pla_dinero * from pla_dinero
            where id_periodos = ai_id_periodos
            and compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''1''
            and concepto = r_v_pla_horas_valorizadas.concepto
            and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos;
            if found then
                update pla_dinero
                set monto = monto + (r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo)
                where id_periodos = ai_id_periodos
                and compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and tipo_de_calculo = ''1''
                and forma_de_registro = ''A''
                and id_pla_cheques_1 is null
                and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos
                and concepto = r_v_pla_horas_valorizadas.concepto;
            else
                insert into pla_dinero(id_periodos, compania, codigo_empleado,
                    tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                    monto, id_pla_proyectos, id_pla_departamentos)
                values(ai_id_periodos, ai_cia, as_codigo_empleado, ''1'',r_v_pla_horas_valorizadas.concepto,
                    ''A'', r_v_pla_horas_valorizadas.descripcion, Mes(r_pla_periodos.dia_d_pago),
                    r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo,
                    r_v_pla_horas_valorizadas.id_pla_proyectos,
                    r_v_pla_horas_valorizadas.id_pla_departamentos);

/*
            i   =   f_pla_dinero_insert(ai_id_periodos, ai_cia, as_codigo_empleado,
                        ''1'', r_v_pla_horas_valorizadas.concepto,r_v_pla_horas_valorizadas.descripcion, Mes(r_pla_periodos.dia_d_pago),
                        (r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo));
*/
            end if;
        end loop;
        
        for r_v_pla_implementos_valorizados in
            select * from v_pla_implementos_valorizados
            where compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and id_periodos = ai_id_periodos
            and fecha >= ld_desde
            order by fecha
        loop
            select into r_pla_conceptos * from pla_conceptos
            where concepto = r_v_pla_implementos_valorizados.concepto;

        
            select into r_pla_dinero * from pla_dinero
            where id_periodos = ai_id_periodos
            and compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''1''
            and concepto = r_v_pla_implementos_valorizados.concepto
            and id_pla_proyectos = r_v_pla_implementos_valorizados.id_pla_proyectos
            and forma_de_registro = ''M'';
            if found then
                continue;
            end if;
            
            select into r_pla_dinero * from pla_dinero
            where id_periodos = ai_id_periodos
            and compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''1''
            and concepto = r_v_pla_implementos_valorizados.concepto
            and id_pla_proyectos = r_v_pla_implementos_valorizados.id_pla_proyectos;
            if found then
                update pla_dinero
                set monto = monto + (r_v_pla_implementos_valorizados.monto*r_pla_conceptos.signo)
                where id_periodos = ai_id_periodos
                and compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and tipo_de_calculo = ''1''
                and forma_de_registro = ''A''
                and id_pla_cheques_1 is null
                and id_pla_proyectos = r_v_pla_implementos_valorizados.id_pla_proyectos
                and concepto = r_v_pla_implementos_valorizados.concepto;
            else
                insert into pla_dinero(id_periodos, compania, codigo_empleado,
                    tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                    monto, id_pla_proyectos, id_pla_departamentos)
                values(ai_id_periodos, ai_cia, as_codigo_empleado, ''1'',r_v_pla_implementos_valorizados.concepto,
                    ''A'', r_v_pla_implementos_valorizados.descripcion, Mes(r_pla_periodos.dia_d_pago),
                    r_v_pla_implementos_valorizados.monto*r_pla_conceptos.signo,
                    r_v_pla_implementos_valorizados.id_pla_proyectos,
                    r_v_pla_implementos_valorizados.id_pla_departamentos);

/*
            i   =   f_pla_dinero_insert(ai_id_periodos, ai_cia, as_codigo_empleado,
                        ''1'', r_v_pla_horas_valorizadas.concepto,r_v_pla_horas_valorizadas.descripcion, Mes(r_pla_periodos.dia_d_pago),
                        (r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo));
*/
            end if;
        end loop;

    else

        select into r_pla_vacaciones * from pla_vacaciones
        where compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and (r_pla_periodos.desde between pagar_desde and pagar_hasta
        or r_pla_periodos.hasta between pagar_desde and pagar_hasta)
        and status = ''A'';
        if found then
            for r_v_pla_horas_valorizadas in
                select * from v_pla_horas_valorizadas
                where compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and fecha > r_pla_vacaciones.pagar_hasta
                and id_periodos = ai_id_periodos
                order by fecha
            loop
                select into r_pla_dinero * from pla_dinero
                where id_periodos = ai_id_periodos
                and compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and tipo_de_calculo = ''1''
                and concepto = r_v_pla_horas_valorizadas.concepto;
                if found then
                    if r_pla_dinero.forma_de_registro = ''A'' then
                        update pla_dinero
                        set monto = monto + r_v_pla_horas_valorizadas.monto
                        where id_periodos = ai_id_periodos
                        and compania = ai_cia
                        and codigo_empleado = as_codigo_empleado
                        and tipo_de_calculo = ''1''
                        and id_pla_cheques_1 is null
                        and concepto = r_v_pla_horas_valorizadas.concepto;
                    end if;
                else
                    insert into pla_dinero(id_periodos, compania, codigo_empleado, tipo_de_calculo,
                        concepto, forma_de_registro, descripcion, mes, monto, id_pla_departamentos, id_pla_proyectos)
                    values (ai_id_periodos, ai_cia, as_codigo_empleado, ''1'', r_v_pla_horas_valorizadas.concepto,
                        ''A'', r_v_pla_horas_valorizadas.descripcion, Mes(r_pla_periodos.dia_d_pago),
                        r_v_pla_horas_valorizadas.monto,
                        r_v_pla_horas_valorizadas.id_pla_departamentos,
                        r_v_pla_horas_valorizadas.id_pla_proyectos);
/*                        
                    i   =   f_pla_dinero_insert(ai_id_periodos, ai_cia, as_codigo_empleado,
                                ''1'', r_v_pla_horas_valorizadas.concepto,r_v_pla_horas_valorizadas.descripcion, Mes(r_pla_periodos.dia_d_pago),
                                r_v_pla_horas_valorizadas.monto);
*/                                
                        
                end if;
            end loop; 
        else
            select into ldc_suma sum(monto) from v_pla_horas_valorizadas
            where compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and id_periodos = ai_id_periodos
            and tipo_de_calculo = ''1''
            and recargo = 1
            and signo = 1
            and tipo_de_hora not in (''00'',''91'',''26'')
            and fecha >= r_pla_periodos.desde;
            if not found or ldc_suma is null then
                ldc_suma = 0;
            end if;
        
            select into r_pla_work * from pla_empleados
            where compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and fecha_inicio > r_pla_periodos.desde;
            if found then
                if r_pla_work.tipo_de_planilla = ''2'' then
                    r_pla_empleados.salario_bruto = f_primer_pago(ai_cia, as_codigo_empleado, ai_id_periodos);
                else
                    r_pla_empleados.salario_bruto = f_pla_primer_salario(ai_cia, as_codigo_empleado, ai_id_periodos);
                end if;
            end if;
            
            ldc_salario_regular = r_pla_empleados.salario_bruto - ldc_suma;
            select into r_pla_dinero * from pla_dinero
            where id_periodos = ai_id_periodos
            and compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and tipo_de_calculo = ''1''
            and concepto = ''03'';
            if not found then
                for r_work in
                    select id_pla_proyectos, pla_conceptos.concepto, sum(monto*pla_conceptos.signo) as monto
                    from v_pla_horas_valorizadas, pla_conceptos
                    where compania = ai_cia
                    and codigo_empleado = as_codigo_empleado
                    and id_periodos = ai_id_periodos
                    and pla_conceptos.concepto = ''03''
                    and id_pla_proyectos <> r_pla_empleados.id_pla_proyectos
                    and v_pla_horas_valorizadas.concepto = pla_conceptos.concepto
                    group by 1, 2
                    order by 1, 2
                loop
                    insert into pla_dinero(id_periodos, compania, codigo_empleado,
                        tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                        monto, id_pla_departamentos, id_pla_proyectos)
                    values(ai_id_periodos, ai_cia, as_codigo_empleado, ''1'',''03'',
                        ''A'', ''SALARIO REGULAR'', Mes(r_pla_periodos.dia_d_pago),
                        r_work.monto, r_pla_empleados.departamento, r_work.id_pla_proyectos);
                    ldc_salario_regular = ldc_salario_regular - r_work.monto;
                end loop;

                
                insert into pla_dinero(id_periodos, compania, codigo_empleado,
                    tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                    monto, id_pla_departamentos, id_pla_proyectos)
                values(ai_id_periodos, ai_cia, as_codigo_empleado, ''1'',''03'',
                    ''A'', ''SALARIO REGULAR'', Mes(r_pla_periodos.dia_d_pago),
                    ldc_salario_regular, r_pla_empleados.departamento, r_pla_empleados.id_pla_proyectos);
                    
            end if;
            
            for r_v_pla_horas_valorizadas in
                select * from v_pla_horas_valorizadas
                where compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and tipo_de_calculo = ''1''
                and id_periodos = ai_id_periodos
                and tipo_de_hora not in (''00'', ''50'')
                order by fecha
            loop
                select into r_pla_conceptos * from pla_conceptos
                where concepto = r_v_pla_horas_valorizadas.concepto;
                
                select into r_pla_dinero * from pla_dinero
                where id_periodos = ai_id_periodos
                and compania = ai_cia
                and codigo_empleado = as_codigo_empleado
                and tipo_de_calculo = ''1''
                and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos
                and concepto = r_v_pla_horas_valorizadas.concepto;
                if found then
                    update pla_dinero
                    set monto = monto + (r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo)
                    where id_periodos = ai_id_periodos
                    and compania = ai_cia
                    and codigo_empleado = as_codigo_empleado
                    and tipo_de_calculo = ''1''
                    and forma_de_registro = ''A''
                    and id_pla_cheques_1 is null
                    and id_pla_proyectos = r_v_pla_horas_valorizadas.id_pla_proyectos
                    and concepto = r_v_pla_horas_valorizadas.concepto;
                else
                    insert into pla_dinero(id_periodos, compania, codigo_empleado,
                        tipo_de_calculo, concepto, forma_de_registro, descripcion, mes,
                        monto, id_pla_departamentos, id_pla_proyectos)
                    values(ai_id_periodos, ai_cia, as_codigo_empleado, ''1'',r_v_pla_horas_valorizadas.concepto,
                        ''A'', r_v_pla_horas_valorizadas.descripcion, Mes(r_pla_periodos.dia_d_pago),
                        r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo, 
                        r_v_pla_horas_valorizadas.id_pla_departamentos,
                        r_v_pla_horas_valorizadas.id_pla_proyectos);
                        
/*                        
                    i   =   f_pla_dinero_insert(ai_id_periodos, ai_cia, as_codigo_empleado,
                                ''1'', r_v_pla_horas_valorizadas.concepto,r_v_pla_horas_valorizadas.descripcion, Mes(r_pla_periodos.dia_d_pago),
                                (r_v_pla_horas_valorizadas.monto*r_pla_conceptos.signo));
*/                                
                end if;
            end loop;
        end if;
    end if;
    
    if f_pla_parametros(ai_cia, ''paga_exceso_9_horas_empleados_semanales'', ''S'', ''GET'') = ''N'' 
        and (r_pla_empleados.tipo_de_planilla = ''1'' or r_pla_empleados.tipo_de_planilla = ''3'') then
            if ai_cia <> 745 then
                i   =   f_pla_liquida_semana(ai_cia, as_codigo_empleado, ai_id_periodos);    
            end if;
    end if;
    

    i = f_pla_otros_ingresos(ai_cia, as_codigo_empleado, ai_id_periodos, ''1'');

    i = f_pla_seguro_social(ai_cia, as_codigo_empleado,ai_id_periodos, ''1'');
    
    i = f_pla_seguro_educativo(ai_cia, as_codigo_empleado,ai_id_periodos, ''1'');
    i = f_pla_sindicato(ai_cia, as_codigo_empleado,ai_id_periodos, ''1'');
    
    i = f_pla_retenciones(ai_cia, as_codigo_empleado, ai_id_periodos,''1'');
    
    if f_pla_salario_neto(ai_cia, as_codigo_empleado, ''1'', ai_id_periodos) < 0 then
        delete from pla_dinero
        where compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and forma_de_registro = ''A''
        and tipo_de_calculo = ''1''
        and id_periodos = ai_id_periodos
        and (id_pla_cheques_1 is null or monto = 0);
    end if;
    
    delete from pla_dinero
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado
    and forma_de_registro = ''A''
    and tipo_de_calculo = ''1''
    and id_periodos = ai_id_periodos
    and monto = 0;

    return 1;
end;
' language plpgsql;

