drop function f_pla_comprobante_contable(int4, date, date) cascade;
--drop function f_pla_comprobante_contable(int4, char(7), int4, int4, int4, date, date, decimal, decimal) cascade;
--drop function f_pla_comprobante_contable(int4, char(7), int4, int4, int4, int4, char(2), date, date, decimal, decimal) cascade;
drop function f_pla_comprobante_contable(int4, char(7), int4, int4, int4, int4, char(2), date, date, decimal, decimal, char(60)) cascade;
drop function f_nombre_cuenta(int4) cascade;

create function f_nombre_cuenta(int4) returns char(100) as '
declare
    ai_id alias for $1;
    r_pla_cuentas record;
    lc_retorno char(100);
begin
    lc_retorno = null;
    select into r_pla_cuentas *
    from pla_cuentas
    where id = ai_id;
    if found then
        return Trim(r_pla_cuentas.nombre);
    else
        return trim(lc_retorno);
    end if;
end;
' language plpgsql;


create function f_pla_comprobante_contable(int4, date, date) returns integer as '
declare
    ai_cia alias for $1;
    ad_desde alias for $2;
    ad_hasta alias for $3;
    r_pla_dinero record;
    r_pla_reservas_pp record;  
    r_pla_comprobante_contable record;
    r_pla_cuentas_conceptos record;
    r_pla_conceptos record;
    r_pla_conceptos_dinero record;
    r_pla_bancos record;
    r_pla_cuentas record;
    r_pla_empleados record;
    r_pla_proyectos record;
    r_pla_acreedores record;
    r_pla_cuentas_x_proyecto record;
    r_pla_cuentas_x_departamento record;
    r_pla_cuentas_x_concepto record;
    ldc_monto decimal(10,2);
    ldc_monto_debito decimal(10,2);
    ldc_monto_credito decimal(10,2);
    ls_cuenta char(24);
    i integer;
    lb_continue boolean;
    li_cta_debito int4;
    li_cta_credito int4;
    ls_d_cta_debito char(100);
    ls_d_cta_credito char(100);
    li_cta_salarios_x_pagar int4;
    ls_d_cta_salarios_x_pagar char(100);
begin

    ls_cuenta   =   Trim(f_pla_parametros(ai_cia, ''cuenta_salarios_por_pagar'',''1'',''GET''));
    
    select into r_pla_cuentas pla_cuentas.*
    from pla_cuentas
    where pla_cuentas.compania = ai_cia
    and Trim(pla_cuentas.cuenta) = Trim(ls_cuenta);
    if not found then
        raise exception ''Cuenta de Salarios por Pagar % no Existe'',ls_cuenta;
    else
        li_cta_salarios_x_pagar     =   r_pla_cuentas.id;
        ls_d_cta_salarios_x_pagar   =   r_pla_cuentas.nombre;
    end if;

    delete from pla_comprobante_contable
    where compania = ai_cia;
    
    for r_pla_dinero in
        select pla_dinero.* from pla_dinero, pla_periodos
        where pla_dinero.id_periodos = pla_periodos.id
        and pla_dinero.compania = ai_cia
        and pla_periodos.dia_d_pago between ad_desde and ad_hasta
        and monto <> 0
        order by id
    loop
        lb_continue = false;

        if r_pla_dinero.id_pla_departamentos is null then
            select into r_pla_empleados *
            from pla_empleados
            where compania = r_pla_dinero.compania
            and codigo_empleado = r_pla_dinero.codigo_empleado;
            if found then
                r_pla_dinero.id_pla_departamentos = r_pla_empleados.departamento;
            end if;
        end if;
        
        if r_pla_dinero.id_pla_proyectos is null then
            select into r_pla_empleados *
            from pla_empleados
            where compania = r_pla_dinero.compania
            and codigo_empleado = r_pla_dinero.codigo_empleado;
            if found then
                r_pla_dinero.id_pla_proyectos = r_pla_empleados.id_pla_proyectos;
            end if;
        
        end if;
        
        select into r_pla_conceptos *
        from pla_conceptos
        where concepto = r_pla_dinero.concepto;
        if not found then
            continue;
        end if;
        
        ldc_monto   =   r_pla_conceptos.signo * r_pla_dinero.monto;

        select into r_pla_cuentas_x_proyecto pla_cuentas_x_proyecto.*
        from pla_cuentas_x_proyecto
        where compania = ai_cia
        and concepto = r_pla_dinero.concepto
        and id_pla_proyectos = r_pla_dinero.id_pla_proyectos;
        if found then
            li_cta_debito       =   r_pla_cuentas_x_proyecto.id_pla_cuentas;
            li_cta_credito      =   r_pla_cuentas_x_proyecto.id_pla_cuentas_2;
            ls_d_cta_debito     =   trim(r_pla_conceptos.descripcion);
            ls_d_cta_credito    =   trim(r_pla_conceptos.descripcion);
            
            
            if li_cta_debito = li_cta_salarios_x_pagar then
                ls_d_cta_debito = ls_d_cta_salarios_x_pagar;
            end if;
            
            if li_cta_credito = li_cta_salarios_x_pagar then
                ls_d_cta_credito = ls_d_cta_salarios_x_pagar;
            end if;
  
            if r_pla_conceptos.signo > 0 then
                if ldc_monto > 0 then
                    ldc_monto_debito    =   ldc_monto;
                    ldc_monto_credito   =   -ldc_monto;
                else
                    ldc_monto_debito    =   ldc_monto;
                    ldc_monto_credito   =   -ldc_monto;
                end if;
            else
                if ldc_monto < 0 then
                    ldc_monto_debito    =   -ldc_monto;
                    ldc_monto_credito   =   ldc_monto;
                else
                    ldc_monto_debito    =   ldc_monto;
                    ldc_monto_credito   =   -ldc_monto;
                end if;
            end if;
            
            i   =   f_pla_comprobante_contable(ai_cia, 
                        r_pla_dinero.codigo_empleado, 
                        r_pla_dinero.id_pla_departamentos,
                        r_pla_dinero.id_pla_proyectos, 
                        li_cta_debito, r_pla_dinero.id_periodos, 
                        r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, ldc_monto_debito, 
                        trim(ls_d_cta_debito));
        

            i   =   f_pla_comprobante_contable(ai_cia, 
                        r_pla_dinero.codigo_empleado, 
                        r_pla_dinero.id_pla_departamentos,
                        r_pla_dinero.id_pla_proyectos, 
                        li_cta_credito, r_pla_dinero.id_periodos, 
                        r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, ldc_monto_credito, 
                        trim(ls_d_cta_credito));
        else
            select into r_pla_cuentas_x_departamento pla_cuentas_x_departamento.*
            from pla_cuentas_x_departamento
            where compania = ai_cia
            and concepto = r_pla_dinero.concepto
            and id_pla_departamentos = r_pla_dinero.id_pla_departamentos;
            if found then
                li_cta_debito       =   r_pla_cuentas_x_departamento.id_pla_cuentas;
                li_cta_credito      =   r_pla_cuentas_x_departamento.id_pla_cuentas_2;
                ls_d_cta_debito     =   trim(r_pla_conceptos.descripcion);
                ls_d_cta_credito    =   trim(r_pla_conceptos.descripcion);
                 
                if li_cta_debito = li_cta_salarios_x_pagar then
                    ls_d_cta_debito = ls_d_cta_salarios_x_pagar;
                end if;
            
                if li_cta_credito = li_cta_salarios_x_pagar then
                    ls_d_cta_credito = ls_d_cta_salarios_x_pagar;
                end if;


                if r_pla_conceptos.signo > 0 then
                    if ldc_monto > 0 then
                        ldc_monto_debito    =   ldc_monto;
                        ldc_monto_credito   =   -ldc_monto;
                    else
                        ldc_monto_debito    =   ldc_monto;
                        ldc_monto_credito   =   -ldc_monto;
                    end if;
                else
                    if ldc_monto < 0 then
                        ldc_monto_debito    =   -ldc_monto;
                        ldc_monto_credito   =   ldc_monto;
                    else
                        ldc_monto_debito    =   ldc_monto;
                        ldc_monto_credito   =   -ldc_monto;
                    end if;
                end if;
            
                
                i   =   f_pla_comprobante_contable(ai_cia, 
                            r_pla_dinero.codigo_empleado, 
                            r_pla_dinero.id_pla_departamentos,
                            r_pla_dinero.id_pla_proyectos, 
                            li_cta_debito, r_pla_dinero.id_periodos, 
                            r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, ldc_monto_debito, 
                            trim(ls_d_cta_debito));
        

                i   =   f_pla_comprobante_contable(ai_cia, 
                            r_pla_dinero.codigo_empleado, 
                            r_pla_dinero.id_pla_departamentos,
                            r_pla_dinero.id_pla_proyectos, 
                            li_cta_credito, r_pla_dinero.id_periodos, 
                            r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, ldc_monto_credito, 
                            trim(ls_d_cta_credito));
            else
                select into r_pla_cuentas_x_concepto pla_cuentas_x_concepto.*
                from pla_cuentas_x_concepto
                where compania = ai_cia
                and concepto = r_pla_dinero.concepto;
                if found then
                    li_cta_debito       =   r_pla_cuentas_x_concepto.id_pla_cuentas;
                    li_cta_credito      =   r_pla_cuentas_x_concepto.id_pla_cuentas_2;
                    ls_d_cta_debito     =   trim(r_pla_conceptos.descripcion);
                    ls_d_cta_credito    =   trim(r_pla_conceptos.descripcion);

                    if li_cta_debito = li_cta_salarios_x_pagar then
                        ls_d_cta_debito = ls_d_cta_salarios_x_pagar;
                    end if;
            
                    if li_cta_credito = li_cta_salarios_x_pagar then
                        ls_d_cta_credito = ls_d_cta_salarios_x_pagar;
                    end if;

                    if r_pla_conceptos.signo > 0 then
                        if ldc_monto > 0 then
                            ldc_monto_debito    =   ldc_monto;
                            ldc_monto_credito   =   -ldc_monto;
                        else
                            ldc_monto_debito    =   ldc_monto;
                            ldc_monto_credito   =   -ldc_monto;
                        end if;
                    else
                        if ldc_monto < 0 then
                            ldc_monto_debito    =   -ldc_monto;
                            ldc_monto_credito   =   ldc_monto;
                        else
                            ldc_monto_debito    =   ldc_monto;
                            ldc_monto_credito   =   -ldc_monto;
                            
                            li_cta_debito       =   r_pla_cuentas_x_concepto.id_pla_cuentas_2;
                            li_cta_credito      =   r_pla_cuentas_x_concepto.id_pla_cuentas;
                            ls_d_cta_debito     =   trim(r_pla_conceptos.descripcion);
                            ls_d_cta_credito    =   trim(r_pla_conceptos.descripcion);


                            if li_cta_debito = li_cta_salarios_x_pagar then
                                ls_d_cta_debito = ls_d_cta_salarios_x_pagar;
                            end if;
            
                            if li_cta_credito = li_cta_salarios_x_pagar then
                                ls_d_cta_credito = ls_d_cta_salarios_x_pagar;
                            end if;

                            
                        end if;
                    end if;
            

                    i   =   f_pla_comprobante_contable(ai_cia, 
                                r_pla_dinero.codigo_empleado, 
                                r_pla_dinero.id_pla_departamentos,
                                r_pla_dinero.id_pla_proyectos, 
                                li_cta_debito, r_pla_dinero.id_periodos, 
                                r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, ldc_monto_debito, 
                                trim(ls_d_cta_debito));
        

                    i   =   f_pla_comprobante_contable(ai_cia, 
                                r_pla_dinero.codigo_empleado, 
                                r_pla_dinero.id_pla_departamentos,
                                r_pla_dinero.id_pla_proyectos, 
                                li_cta_credito, r_pla_dinero.id_periodos, 
                                r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, ldc_monto_credito, 
                                trim(ls_d_cta_credito));
  
                else
                    Raise Exception ''Concepto % no tiene cuenta contable...Verifique'', r_pla_dinero.concepto;
                end if;
            end if;
        end if;


        for r_pla_reservas_pp in
            select * from pla_reservas_pp
            where id_pla_dinero = r_pla_dinero.id
            order by id
        loop
            select into r_pla_conceptos *
            from pla_conceptos
            where concepto = r_pla_reservas_pp.concepto;
            
            ldc_monto   =   r_pla_reservas_pp.monto;

            select into r_pla_cuentas_x_proyecto pla_cuentas_x_proyecto.*
            from pla_cuentas_x_proyecto
            where compania = ai_cia
            and concepto = r_pla_reservas_pp.concepto
            and id_pla_proyectos = r_pla_dinero.id_pla_proyectos;
            if found then
                li_cta_debito       =   r_pla_cuentas_x_proyecto.id_pla_cuentas;
                li_cta_credito      =   r_pla_cuentas_x_proyecto.id_pla_cuentas_2;
                ls_d_cta_debito     =   f_nombre_cuenta(li_cta_debito);
                ls_d_cta_credito    =   f_nombre_cuenta(li_cta_credito);

                if ldc_monto > 0 then
                    ldc_monto_debito    =   ldc_monto;
                    ldc_monto_credito   =   -ldc_monto;
                else
                    ldc_monto_debito    =   -ldc_monto;
                    ldc_monto_credito   =   ldc_monto;
                    li_cta_debito       =   r_pla_cuentas_x_proyecto.id_pla_cuentas_2;
                    li_cta_credito      =   r_pla_cuentas_x_proyecto.id_pla_cuentas;
                    ls_d_cta_debito     =   f_nombre_cuenta(li_cta_credito);
                    ls_d_cta_credito    =   f_nombre_cuenta(li_cta_debito);

                end if;

                i   =   f_pla_comprobante_contable(ai_cia, 
                            r_pla_dinero.codigo_empleado, 
                            r_pla_dinero.id_pla_departamentos,
                            r_pla_dinero.id_pla_proyectos, 
                            li_cta_debito, r_pla_dinero.id_periodos, 
                            r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, ldc_monto_debito, 
                            r_pla_conceptos.descripcion);


                i   =   f_pla_comprobante_contable(ai_cia, 
                            r_pla_dinero.codigo_empleado, 
                            r_pla_dinero.id_pla_departamentos,
                            r_pla_dinero.id_pla_proyectos, 
                            li_cta_credito, r_pla_dinero.id_periodos, 
                            r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, ldc_monto_credito, 
                            r_pla_conceptos.descripcion);
            else
                select into r_pla_cuentas_x_departamento pla_cuentas_x_departamento.*
                from pla_cuentas_x_departamento
                where compania = ai_cia
                and concepto = r_pla_reservas_pp.concepto
                and id_pla_departamentos = r_pla_dinero.id_pla_departamentos;
                if found then
                    li_cta_debito       =   r_pla_cuentas_x_departamento.id_pla_cuentas;
                    li_cta_credito      =   r_pla_cuentas_x_departamento.id_pla_cuentas_2;
                    ls_d_cta_debito     =   f_nombre_cuenta(li_cta_debito);
                    ls_d_cta_credito    =   f_nombre_cuenta(li_cta_credito);

                    if ldc_monto > 0 then
                        ldc_monto_debito    =   ldc_monto;
                        ldc_monto_credito   =   -ldc_monto;
                    else
                        ldc_monto_debito    =   -ldc_monto;
                        ldc_monto_credito   =   ldc_monto;
                        li_cta_debito       =   r_pla_cuentas_x_departamento.id_pla_cuentas_2;
                        li_cta_credito      =   r_pla_cuentas_x_departamento.id_pla_cuentas;
                        ls_d_cta_debito     =   f_nombre_cuenta(li_cta_credito);
                        ls_d_cta_credito    =   f_nombre_cuenta(li_cta_debito);
                    end if;

                    i   =   f_pla_comprobante_contable(ai_cia, 
                                r_pla_dinero.codigo_empleado, 
                                r_pla_dinero.id_pla_departamentos,
                                r_pla_dinero.id_pla_proyectos, 
                                li_cta_debito, r_pla_dinero.id_periodos, 
                                r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, ldc_monto_debito, 
                                r_pla_conceptos.descripcion);


                    i   =   f_pla_comprobante_contable(ai_cia, 
                                r_pla_dinero.codigo_empleado, 
                                r_pla_dinero.id_pla_departamentos,
                                r_pla_dinero.id_pla_proyectos, 
                                li_cta_credito, r_pla_dinero.id_periodos, 
                                r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, ldc_monto_credito, 
                                r_pla_conceptos.descripcion);

                else
                    select into r_pla_cuentas_x_concepto pla_cuentas_x_concepto.*
                    from pla_cuentas_x_concepto
                    where compania = ai_cia
                    and concepto = r_pla_reservas_pp.concepto;
                    if found then
                        li_cta_debito       =   r_pla_cuentas_x_concepto.id_pla_cuentas;
                        li_cta_credito      =   r_pla_cuentas_x_concepto.id_pla_cuentas_2;
                        ls_d_cta_debito     =   f_nombre_cuenta(li_cta_debito);
                        ls_d_cta_credito    =   f_nombre_cuenta(li_cta_credito);

                        if ldc_monto > 0 then
                            ldc_monto_debito    =   ldc_monto;
                            ldc_monto_credito   =   -ldc_monto;
                        else
                            ldc_monto_debito    =   -ldc_monto;
                            ldc_monto_credito   =   ldc_monto;
                            li_cta_debito       =   r_pla_cuentas_x_concepto.id_pla_cuentas_2;
                            li_cta_credito      =   r_pla_cuentas_x_concepto.id_pla_cuentas;
                            ls_d_cta_debito     =   f_nombre_cuenta(li_cta_credito);
                            ls_d_cta_credito    =   f_nombre_cuenta(li_cta_debito);
                            
                        end if;

                        i   =   f_pla_comprobante_contable(ai_cia, 
                                    r_pla_dinero.codigo_empleado, 
                                    r_pla_dinero.id_pla_departamentos,
                                    r_pla_dinero.id_pla_proyectos, 
                                    li_cta_debito, r_pla_dinero.id_periodos, 
                                    r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, ldc_monto_debito, 
                                    r_pla_conceptos.descripcion);


                        i   =   f_pla_comprobante_contable(ai_cia, 
                                    r_pla_dinero.codigo_empleado, 
                                    r_pla_dinero.id_pla_departamentos,
                                    r_pla_dinero.id_pla_proyectos, 
                                    li_cta_credito, r_pla_dinero.id_periodos, 
                                    r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, ldc_monto_credito, 
                                    r_pla_conceptos.descripcion);

                    else
                        Raise Exception ''Concepto % no tiene cuenta contable...Verifique'', r_pla_reservas_pp.concepto;
                    end if;
                end if;
            end if;
        end loop;
    end loop;
    
    delete from pla_comprobante_contable where monto = 0;
    
    return 1;
    update pla_comprobante_contable
    set porcentaje = monto / base * 100
    where compania = ai_cia
    and base <> 0;
    
    return 1;
end;
' language plpgsql;


create function f_pla_comprobante_contable(int4, char(7), int4, int4, int4, int4, char(2), date, date, decimal, decimal, char(60)) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_pla_departamentos alias for $3;
    ai_id_pla_proyectos alias for $4;
    ai_id_pla_cuentas alias for $5;
    ai_id_pla_periodos alias for $6;
    as_tipo_de_calculo alias for $7;
    ad_desde alias for $8;
    ad_hasta alias for $9;
    adc_base alias for $10;
    adc_monto alias for $11;
    as_descripcion alias for $12;
    r_pla_comprobante_contable record;
begin
        select into r_pla_comprobante_contable *
        from pla_comprobante_contable
        where compania = ai_cia
        and codigo_empleado = as_codigo_empleado
        and id_pla_departamentos = ai_id_pla_departamentos
        and id_pla_proyectos = ai_id_pla_proyectos
        and id_pla_cuentas = ai_id_pla_cuentas
        and id_pla_periodos = ai_id_pla_periodos
        and tipo_de_calculo = as_tipo_de_calculo
        and descripcion = as_descripcion
        and desde = ad_desde
        and hasta = ad_hasta;
        if not found then
            insert into pla_comprobante_contable(compania, codigo_empleado,
                id_pla_departamentos, id_pla_proyectos,
                id_pla_cuentas, desde, hasta, base, monto, porcentaje, id_pla_periodos, 
                tipo_de_calculo, descripcion)
            values(ai_cia, as_codigo_empleado, ai_id_pla_departamentos,
                ai_id_pla_proyectos, ai_id_pla_cuentas,
                ad_desde, ad_hasta, adc_base, adc_monto, 0, ai_id_pla_periodos, 
                as_tipo_de_calculo, as_descripcion);
        else
            update pla_comprobante_contable
            set monto = monto + adc_monto, base = base + adc_base
            where compania = ai_cia
            and codigo_empleado = as_codigo_empleado
            and id_pla_departamentos = ai_id_pla_departamentos
            and id_pla_proyectos = ai_id_pla_proyectos
            and id_pla_cuentas = ai_id_pla_cuentas
            and id_pla_periodos = ai_id_pla_periodos
            and tipo_de_calculo = as_tipo_de_calculo
            and descripcion = as_descripcion
            and desde = ad_desde
            and hasta = ad_hasta;
        end if;
        
    return 1;
end;
' language plpgsql;





/*        

            if ai_cia = 745 or ai_cia = 746 or ai_cia = 747 then
                select into r_pla_proyectos * 
                from pla_proyectos
                where id = r_pla_dinero.id_pla_proyectos
                and compania = ai_cia
                and trim(proyecto) in (''NO'');
                if found then
                    i   =   f_pla_comprobante_contable(ai_cia, 
                                r_pla_dinero.codigo_empleado, 
                                r_pla_dinero.id_pla_departamentos,
                                r_pla_dinero.id_pla_proyectos, 
                                r_pla_cuentas_conceptos.id_pla_cuentas, 
                                r_pla_dinero.id_periodos, r_pla_dinero.tipo_de_calculo, 
                                ad_desde, ad_hasta, 
                                (r_pla_dinero.monto*r_pla_conceptos_dinero.signo),
                                ldc_monto, r_pla_conceptos.descripcion);
                else
                    select into r_pla_proyectos * 
                    from pla_proyectos
                    where id = r_pla_dinero.id_pla_proyectos
                    and compania = ai_cia
                    and trim(proyecto) in (''03'');
                    if found then
                        if r_pla_reservas_pp.concepto = ''408'' then
                            ls_cuenta   =   ''55002'';
                        elsif r_pla_dinero.concepto = ''402'' 
                                or r_pla_dinero.concepto = ''403''
                                or r_pla_dinero.concepto = ''410''
                                or r_pla_dinero.concepto = ''404'' then
                            ls_cuenta   =   ''55005'';
                        elsif r_pla_dinero.concepto = ''409'' then
                            ls_cuenta   =   ''55003'';
                        elsif r_pla_dinero.concepto = ''420'' then
                            ls_cuenta   =   ''55004'';
                        elsif r_pla_dinero.concepto = ''430'' then
                            ls_cuenta   =   ''61600'';
                        else
                            ls_cuenta   =   ''55005'';
                        end if;
                        
                        select into r_pla_cuentas *
                        from pla_cuentas
                        where compania = ai_cia
                        and cuenta = ls_cuenta;
                        i   =   f_pla_comprobante_contable(ai_cia, 
                                    r_pla_dinero.codigo_empleado, 
                                    r_pla_dinero.id_pla_departamentos,
                                    r_pla_dinero.id_pla_proyectos, 
                                    r_pla_cuentas.id, 
                                    r_pla_dinero.id_periodos, r_pla_dinero.tipo_de_calculo, 
                                    ad_desde, ad_hasta, 
                                    (r_pla_dinero.monto*r_pla_conceptos_dinero.signo),
                                    ldc_monto, r_pla_conceptos.descripcion);
                    else
                        select into r_pla_cuentas *
                        from pla_cuentas
                        where compania = ai_cia
                        and cuenta = ''13000'';
                        i   =   f_pla_comprobante_contable(ai_cia, 
                                    r_pla_dinero.codigo_empleado, 
                                    r_pla_dinero.id_pla_departamentos,
                                    r_pla_dinero.id_pla_proyectos, 
                                    r_pla_cuentas.id, 
                                    r_pla_dinero.id_periodos, r_pla_dinero.tipo_de_calculo, 
                                    ad_desde, ad_hasta, 
                                    (r_pla_dinero.monto*r_pla_conceptos_dinero.signo),
                                    ldc_monto, r_pla_conceptos.descripcion);
                    end if;
                end if;
                
                i   =   f_pla_comprobante_contable(ai_cia, 
                            r_pla_dinero.codigo_empleado, 
                            r_pla_dinero.id_pla_departamentos,
                            r_pla_dinero.id_pla_proyectos, 
                            r_pla_cuentas_conceptos.id_pla_cuentas_2, 
                            r_pla_dinero.id_periodos, r_pla_dinero.tipo_de_calculo, 
                            ad_desde, ad_hasta, 0, -ldc_monto, 
                            r_pla_conceptos.descripcion);
            else
                i   =   f_pla_comprobante_contable(ai_cia, 
                            r_pla_dinero.codigo_empleado, 
                            r_pla_dinero.id_pla_departamentos,
                            r_pla_dinero.id_pla_proyectos, 
                            r_pla_cuentas_conceptos.id_pla_cuentas, 
                            r_pla_dinero.id_periodos, r_pla_dinero.tipo_de_calculo, 
                            ad_desde, ad_hasta, 
                            (r_pla_dinero.monto*r_pla_conceptos_dinero.signo),
                            ldc_monto, r_pla_conceptos.descripcion);
        
                i   =   f_pla_comprobante_contable(ai_cia, 
                            r_pla_dinero.codigo_empleado, 
                            r_pla_dinero.id_pla_departamentos,
                            r_pla_dinero.id_pla_proyectos, 
                            r_pla_cuentas_conceptos.id_pla_cuentas_2, 
                            r_pla_dinero.id_periodos, r_pla_dinero.tipo_de_calculo, 
                            ad_desde, ad_hasta, 0, -ldc_monto, 
                            r_pla_conceptos.descripcion);
            end if;

        if ai_cia = 745 or ai_cia = 746 or ai_cia = 747 then
            select into r_pla_proyectos * 
            from pla_proyectos
            where id = r_pla_dinero.id_pla_proyectos
            and compania = ai_cia
            and trim(proyecto) in (''NO'');
            if found 
                or r_pla_dinero.concepto = ''102'' 
                or r_pla_dinero.concepto = ''104'' 
                or r_pla_dinero.concepto = ''103''
                or r_pla_dinero.concepto = ''106'' then

                if r_pla_dinero.concepto = ''73'' then
                    ls_cuenta   =   f_pla_parametros(ai_cia, ''cuenta_salarios_por_pagar'',''1'',''GET'');
                    select into r_pla_cuentas pla_cuentas.*
                    from pla_cuentas
                    where pla_cuentas.compania = ai_cia
                    and pla_cuentas.cuenta = ls_cuenta;
                    i   =   f_pla_comprobante_contable(ai_cia, 
                                r_pla_dinero.codigo_empleado, 
                                r_pla_dinero.id_pla_departamentos,
                                r_pla_dinero.id_pla_proyectos, 
                                r_pla_cuentas.id, r_pla_dinero.id_periodos, 
                                r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, ldc_monto, r_pla_cuentas.nombre);
                else                
                    i   =   f_pla_comprobante_contable(ai_cia, 
                                r_pla_dinero.codigo_empleado, 
                                r_pla_dinero.id_pla_departamentos,
                                r_pla_dinero.id_pla_proyectos, 
                                r_pla_cuentas.id, r_pla_dinero.id_periodos, 
                                r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, ldc_monto, r_pla_cuentas.nombre);
                end if;
                
            else
                select into r_pla_proyectos * 
                from pla_proyectos
                where id = r_pla_dinero.id_pla_proyectos
                and compania = ai_cia
                and trim(proyecto) in (''03'');
                if found then
                    if r_pla_dinero.concepto = ''109'' then
                        ls_cuenta   =   ''55003'';
                    elsif r_pla_dinero.concepto = ''220'' then
                        ls_cuenta   =   ''55004'';
                    elsif r_pla_dinero.concepto = ''108'' then
                        ls_cuenta   =   ''55002'';
                    elsif r_pla_dinero.concepto = ''73'' then
                        ls_cuenta   =   f_pla_parametros(ai_cia, ''cuenta_salarios_por_pagar'',''1'',''GET'');
                    else
                        ls_cuenta   =   ''55001'';
                    end if;
                    
                    
                    select into r_pla_cuentas *
                    from pla_cuentas
                    where compania = ai_cia
                    and cuenta = ls_cuenta;
                    i   =   f_pla_comprobante_contable(ai_cia, 
                                r_pla_dinero.codigo_empleado, 
                                r_pla_dinero.id_pla_departamentos,
                                r_pla_dinero.id_pla_proyectos, 
                                r_pla_cuentas.id, r_pla_dinero.id_periodos, 
                                r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, ldc_monto, r_pla_conceptos.descripcion);
                else
                    select into r_pla_cuentas *
                    from pla_cuentas
                    where compania = ai_cia
                    and cuenta = ''13000'';
                    i   =   f_pla_comprobante_contable(ai_cia, 
                                r_pla_dinero.codigo_empleado, 
                                r_pla_dinero.id_pla_departamentos,
                                r_pla_dinero.id_pla_proyectos, 
                                r_pla_cuentas.id, r_pla_dinero.id_periodos, 
                                r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, ldc_monto, r_pla_conceptos.descripcion);
                end if;
            end if;
        else
            i   =   f_pla_comprobante_contable(ai_cia, 
                        r_pla_dinero.codigo_empleado, 
                        r_pla_dinero.id_pla_departamentos,
                        r_pla_dinero.id_pla_proyectos, 
                        r_pla_cuentas.id, r_pla_dinero.id_periodos, 
                        r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, ldc_monto, 
                        r_pla_cuentas.nombre);
        end if;


            i   =   f_pla_comprobante_contable(ai_cia, 
                        r_pla_dinero.codigo_empleado, 
                        r_pla_dinero.id_pla_departamentos,
                        r_pla_dinero.id_pla_proyectos, 
                        r_pla_cuentas.id, r_pla_dinero.id_periodos, 
                        r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, ldc_monto, 
                        r_pla_cuentas.nombre);
    

        
        ls_cuenta   =   f_pla_parametros(ai_cia, ''cuenta_salarios_por_pagar'',''1'',''GET'');
        select into r_pla_cuentas *
        from pla_cuentas
        where compania = ai_cia
        and cuenta = ls_cuenta;
        if not found then
            raise exception ''Cuenta % no Existe'',ls_cuenta;
        end if;
        
        i   =   f_pla_comprobante_contable(ai_cia, 
                    r_pla_dinero.codigo_empleado, 
                    r_pla_dinero.id_pla_departamentos,
                    r_pla_dinero.id_pla_proyectos, 
                    r_pla_cuentas.id, r_pla_dinero.id_periodos, 
                    r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, -ldc_monto, r_pla_cuentas.nombre);
    

        
        if r_pla_dinero.id_pla_cheques_1 is null then
            ls_cuenta   =   f_pla_parametros(ai_cia, ''cuenta_salarios_por_pagar'',''1'',''GET'');
            select into r_pla_cuentas *
            from pla_cuentas
            where compania = ai_cia
            and cuenta = ls_cuenta;
            if not found then
                raise exception ''Cuenta % no Existe'',ls_cuenta;
            end if;
            
            i   =   f_pla_comprobante_contable(ai_cia, 
                        r_pla_dinero.codigo_empleado, 
                        r_pla_dinero.id_pla_departamentos,
                        r_pla_dinero.id_pla_proyectos, 
                        r_pla_cuentas.id, r_pla_dinero.id_periodos, 
                        r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, -ldc_monto, r_pla_cuentas.nombre);
        else
            select into r_pla_bancos pla_bancos.*
            from pla_cheques_1, pla_bancos
            where pla_bancos.id = pla_cheques_1.id_pla_bancos
            and pla_cheques_1.id = r_pla_dinero.id_pla_cheques_1;
            if found then
                i   =   f_pla_comprobante_contable(ai_cia, 
                            r_pla_dinero.codigo_empleado, 
                            r_pla_dinero.id_pla_departamentos,
                            r_pla_dinero.id_pla_proyectos, 
                            r_pla_bancos.id_pla_cuentas, 
                            r_pla_dinero.id_periodos, 
                            r_pla_dinero.tipo_de_calculo, ad_desde, ad_hasta, 0, -ldc_monto, r_pla_bancos.nombre);
            end if;
        end if;
*/        
        
