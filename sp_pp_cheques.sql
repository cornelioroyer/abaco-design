drop function f_pla_crear_cheques_empleados(int4, char(2), int4, char(7), char(60));
drop function f_pla_crear_cheques_acreedores(int4);
drop function f_no_cheque(int4, int4) cascade;


create function f_no_cheque(int4, int4) returns integer as '
declare
    ai_id_pla_bancos alias for $1;
    ai_no_cheque alias for $2;
    r_pla_cheques_1 record;
    li_no_cheque int4;
begin
    li_no_cheque = ai_no_cheque;
    
    while 1=1 loop
        select into r_pla_cheques_1 *
        from pla_cheques_1
        where id_pla_bancos = ai_id_pla_bancos
        and no_cheque = li_no_cheque
        and tipo_transaccion = ''C'';
        if not found then
            return li_no_cheque;
        else
            li_no_cheque = li_no_cheque + 1;
        end if;
    end loop;
    
    return 1;
end;
' language plpgsql;



create function f_pla_crear_cheques_acreedores(int4) returns integer as '
declare
    ai_id_pla_dinero alias for $1;
    r_pla_dinero record;
    r_pla_retenciones record;
    r_pla_deducciones record;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_bancos record;
    r_pla_cheques_1 record;
    r_pla_cheques_2 record;
    r_pla_departamentos record;
    r_pla_acreedores record;
    r_pla_parametros_contables record;    
    r_pla_cuentas record;
    r_pla_auxiliares record;
    r_pla_cuentas_x_concepto record;
    r_pla_cheques_concepto record;
    ls_paguese_a char(60);
    ls_en_concepto_de text;
    lvc_work varchar(100);
    lt_work text;
    li_no_cheque int4;
    li_id_pla_cheques_1 int4;
    ld_fecha date;
begin
    ld_fecha    =   current_date;
    
    select into r_pla_dinero *
    from pla_dinero
    where id = ai_id_pla_dinero;
    if not found then
        return 0;
    end if;
  
    select into r_pla_empleados * 
    from pla_empleados
    where compania = r_pla_dinero.compania
    and codigo_empleado = r_pla_dinero.codigo_empleado;
    if not found then
        return 0;
    end if;
    
    select into r_pla_deducciones *
    from pla_deducciones
    where id_pla_dinero = ai_id_pla_dinero
    and id_pla_cheques_1 is null;
    if not found then
        return 0;
    end if;

    select into r_pla_retenciones *
    from pla_retenciones
    where id = r_pla_deducciones.id_pla_retenciones
    and hacer_cheque = ''S'';
    if not found then
        return 0;
    end if;
    
    select into r_pla_periodos *
    from pla_periodos
    where id = r_pla_dinero.id_periodos;
    
  
    select into r_pla_acreedores *
    from pla_acreedores
    where compania = r_pla_retenciones.compania
    and acreedor = r_pla_retenciones.acreedor;
    if not found then
        return 0;
    end if;
    
    if r_pla_retenciones.aplica_diciembre = ''N'' and
        r_pla_dinero.mes = 12 then
        return 0;
    end if;
    
    ls_paguese_a = trim(r_pla_acreedores.nombre);
    
    for r_pla_bancos in
        select * from pla_bancos
        where compania = r_pla_acreedores.compania
        and status is true
        order by id
    loop
    end loop;


    select into r_pla_cheques_1 * 
    from pla_cheques_1
    where id_pla_bancos = r_pla_bancos.id
    and tipo_transaccion = ''SC''
    and trim(paguese_a) = trim(ls_paguese_a);
    if not found then
        li_no_cheque = r_pla_bancos.sec_solicitudes + 1;
        loop
            select into r_pla_cheques_1 *
            from pla_cheques_1
            where id_pla_bancos = r_pla_bancos.id
            and tipo_transaccion = ''SC''
            and no_cheque = li_no_cheque;
            if not found then
--                ld_fecha    =   r_pla_periodos.dia_d_pago;
--                ld_fecha    =   current_date;
                insert into pla_cheques_1(id_pla_bancos, tipo_transaccion,
                    no_cheque, no_solicitud, paguese_a, fecha_solicitud, fecha_cheque,
                    en_concepto_de, status, monto)
                values(r_pla_bancos.id, ''SC'', li_no_cheque,
                    li_no_cheque, ls_paguese_a, ld_fecha, ld_fecha, ls_en_concepto_de,
                    ''R'', r_pla_dinero.monto);
                li_id_pla_cheques_1 = LastVal();
                exit;
            else
                li_no_cheque = li_no_cheque + 1;
            end if;
        end loop;
        
        update pla_bancos
        set sec_solicitudes = li_no_cheque
        where id = r_pla_bancos.id;
        
        
    else
        li_id_pla_cheques_1 = r_pla_cheques_1.id;

--        ld_fecha    =   r_pla_cheques_1.fecha_cheque;
        
        if r_pla_periodos.dia_d_pago > ld_fecha then
--            ld_fecha    =   r_pla_periodos.dia_d_pago;
        end if;
                
        update pla_cheques_1
        set monto = monto + r_pla_dinero.monto, fecha_cheque = ld_fecha, fecha_solicitud = ld_fecha
        where id = r_pla_cheques_1.id;
    end if;

    lvc_work    =   Trim(r_pla_empleados.nombre) || '' '' || Trim(r_pla_empleados.apellido);
 
    select into r_pla_cheques_concepto *
    from pla_cheques_concepto
    where id_pla_cheques_1 = li_id_pla_cheques_1
    and compania = r_pla_empleados.compania
    and trim(concepto) = trim(lvc_work);
    if not found then
        insert into pla_cheques_concepto(id_pla_cheques_1, compania,
            concepto, documento, monto)
        values(li_id_pla_cheques_1, r_pla_empleados.compania, Trim(lvc_work),
            trim(r_pla_empleados.cedula), r_pla_dinero.monto);
    else
        update pla_cheques_concepto
        set monto = monto + r_pla_dinero.monto
        where id_pla_cheques_1 = li_id_pla_cheques_1
        and compania = r_pla_empleados.compania
        and trim(concepto) = trim(lvc_work);
    end if;

    ls_en_concepto_de   =   null;
    for r_pla_cheques_concepto in select concepto, documento, sum(monto) as monto
                                    from pla_cheques_concepto
                                    where id_pla_cheques_1 = li_id_pla_cheques_1
                                    group by 1, 2
                                    order by 1, 2
    loop
   
--        r_pla_cheques_concepto.concepto =   Rpad(Trim(r_pla_cheques_concepto.concepto), 30, ''-'');
--        r_pla_cheques_concepto.documento    =   Rpad(Trim(r_pla_cheques_concepto.documento), 20, ''-'');
        
        if ls_en_concepto_de is null then
            ls_en_concepto_de   =   r_pla_cheques_concepto.concepto || ''    '' ||
                                    r_pla_cheques_concepto.documento || ''    '' ||
                                    Trim(to_char(r_pla_cheques_concepto.monto, ''999,999.99''));
        else
            ls_en_concepto_de   =   ls_en_concepto_de || ''\r\n'' ||
                                    r_pla_cheques_concepto.concepto || ''   '' ||
                                    r_pla_cheques_concepto.documento || ''   '' ||
                                    trim(to_char(r_pla_cheques_concepto.monto, ''999,999.99'')); 
                                    
-- raise exception ''%'', ls_en_concepto_de;
                                               
        end if;                                    
        
    end loop;
  
    
    update pla_cheques_1
    set en_concepto_de = ls_en_concepto_de
    where id = li_id_pla_cheques_1;
    
    
    select into r_pla_cheques_2 *
    from pla_cheques_2
    where id_pla_cheques_1 = li_id_pla_cheques_1
    and id_pla_cuentas = r_pla_bancos.id_pla_cuentas;
    if not found then
        insert into pla_cheques_2 (id_pla_cheques_1, id_pla_cuentas, id_pla_auxiliares, monto)
        values (li_id_pla_cheques_1, r_pla_bancos.id_pla_cuentas, null, -r_pla_dinero.monto);
    else
        update pla_cheques_2
        set monto = -monto - r_pla_dinero.monto
        where id = r_pla_cheques_2.id;
    end if;
    
    select into r_pla_departamentos *
    from pla_departamentos
    where id = r_pla_empleados.departamento;

    select into r_pla_cuentas_x_concepto pla_cuentas_x_concepto.*
    from pla_cuentas_x_concepto, pla_cuentas
    where pla_cuentas_x_concepto.id_pla_cuentas = pla_cuentas.id
    and pla_cuentas.compania = r_pla_dinero.compania
    and concepto = r_pla_dinero.concepto;
    if not found then
        raise exception ''Concepto % no tiene cuenta contable'',r_pla_cuentas_x_concepto.concepto;
    end if;
    

    select into r_pla_cuentas *
    from pla_cuentas
    where id = r_pla_cuentas_x_concepto.id_pla_cuentas;
    if not found then
        return 0;
    end if;
    
    if r_pla_cuentas.acreedores is true then
        select into r_pla_auxiliares *
        from pla_auxiliares
        where acreedor = r_pla_acreedores.acreedor;
        if not found then
            insert into pla_auxiliares (acreedor) values (r_pla_acreedores.acreedor);
            r_pla_auxiliares.id = LastVal();
        end if;
        
        select into r_pla_cheques_2 *
        from pla_cheques_2
        where id_pla_cheques_1 = li_id_pla_cheques_1
        and id_pla_cuentas = r_pla_cuentas_x_concepto.id_pla_cuentas_2
        and id_pla_auxiliares = r_pla_auxiliares.id;
        if not found then
            insert into pla_cheques_2 (id_pla_cheques_1, id_pla_cuentas, id_pla_auxiliares, monto)
            values (li_id_pla_cheques_1, r_pla_cuentas_x_concepto.id_pla_cuentas_2, 
                    r_pla_auxiliares.id, r_pla_dinero.monto);
        else
            update pla_cheques_2
            set monto = monto + r_pla_dinero.monto
            where id = r_pla_cheques_2.id;
        end if;        
    else
        select into r_pla_cheques_2 *
        from pla_cheques_2
        where id_pla_cheques_1 = li_id_pla_cheques_1
        and id_pla_cuentas = r_pla_parametros_contables.id_pla_cuentas;
        if not found then
            insert into pla_cheques_2 (id_pla_cheques_1, id_pla_cuentas, id_pla_auxiliares, monto)
            values (li_id_pla_cheques_1, r_pla_cuentas_x_concepto.id_pla_cuentas, 
                    null, r_pla_dinero.monto);
        else
            update pla_cheques_2
            set monto = monto + r_pla_dinero.monto
            where id = r_pla_cheques_2.id;
        end if;        
    end if;
    
    update pla_deducciones
    set id_pla_cheques_1 = li_id_pla_cheques_1
    where id_pla_retenciones = r_pla_deducciones.id_pla_retenciones
    and id_pla_dinero = r_pla_deducciones.id_pla_dinero;
    
    return 1;
end;
' language plpgsql;




create function f_pla_crear_cheques_empleados(int4, char(2), int4, char(7), char(60)) returns integer as '
declare
    ai_cia alias for $1;
    as_tipo_de_calculo alias for $2;
    ai_periodo alias for $3;
    as_codigo_empleado alias for $4;
    as_paguese_a alias for $5;
    r_pla_dinero record;
    r_pla_empleados record;
    r_pla_bancos record;
    r_pla_tipos_de_transacciones record;
    r_pla_periodos record;
    r_pla_departamentos record;
    r_pla_parametros_contables record;
    r_pla_tipos_de_planilla record;
    r_pla_cheques_1 record;
    r_pla_cheques_2 record;
    r_pla_conceptos record;
    r_v_pla_dinero_cheques record;
    r_pla_cuentas record;
    r_pla_cuentas_x_concepto record;
    r_pla_acreedores record;
    r_pla_deducciones record;
    r_pla_retenciones record;
    r_work record;
    r_pla_liquidacion record;
    r_pla_vacaciones record;
    sw boolean;
    lb_insertar boolean;
    ls_paguese_a char(60);
    ls_en_concepto_de text;
    li_mes integer;
    li_anio integer;
    li_no_cheque int4;
    li_dia int4;
    li_id_pla_cheques_1 int4;
    li_id_pla_auxiliares int4;
    li_id_pla_liquidacion int4;
    id_pla_cheques int4;
    li_work int4;
    ldc_monto_cheque decimal;
    ls_cheque_resumido varchar(50);
    ls_cuenta char(24);
    ls_cuenta_salarios_por_pagar char(24);
    lb_acreedor boolean;
begin
    ls_cheque_resumido              = Trim(f_pla_parametros(ai_cia, ''cheque_resumido'',''S'',''GET''));
    ls_cuenta_salarios_por_pagar    = Trim(f_pla_parametros(ai_cia, ''cuenta_salarios_por_pagar'',''1'',''GET''));
    
    select into r_pla_cuentas *
    from pla_cuentas
    where compania = ai_cia
    and trim(cuenta) = trim(ls_cuenta_salarios_por_pagar);
    if not found then
        for r_pla_cuentas in
            select * from pla_cuentas
            where compania = ai_cia
            order by cuenta
        loop
            ls_cuenta_salarios_por_pagar = r_pla_cuentas.cuenta;
            exit;
        end loop;
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where id = ai_periodo;
    
    select into r_pla_tipos_de_planilla * from pla_tipos_de_planilla
    where compania = r_pla_periodos.compania
    and tipo_de_planilla = r_pla_periodos.tipo_de_planilla;
    
    
    li_mes = Mes(r_pla_periodos.dia_d_pago);
    li_anio = Anio(r_pla_periodos.dia_d_pago);
    if as_tipo_de_calculo = ''7'' then
        select into li_id_pla_liquidacion pla_dinero.id_pla_liquidacion
        from pla_dinero
        where pla_dinero.compania = ai_cia
        and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
        and pla_dinero.id_periodos = ai_periodo
        and pla_dinero.codigo_empleado = as_codigo_empleado
        and pla_dinero.id_pla_liquidacion is not null
        group by 1;

                
        select into r_pla_liquidacion pla_liquidacion.*
        from pla_liquidacion
        where id = li_id_pla_liquidacion;
        if found then
            ls_en_concepto_de   =   ''CHEQUE DE LIQUIDACION AL '' || to_char(r_pla_liquidacion.fecha, ''dd-mm-yyyy'');
        else
            ls_en_concepto_de   =   ''CHEQUE DE LIQUIDACION'';
        end if;

    elsif as_tipo_de_calculo = ''2'' then

        ls_en_concepto_de       =   ''VACACIONES'';


        select into li_work pla_dinero.id_pla_vacaciones
        from pla_dinero
        where pla_dinero.compania = ai_cia
        and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
        and pla_dinero.id_periodos = ai_periodo
        and pla_dinero.codigo_empleado = as_codigo_empleado
        and pla_dinero.id_pla_vacaciones is not null
        group by 1;

    
        select into r_pla_vacaciones *
        from pla_vacaciones
        where id = li_work;
        if found then
            ls_en_concepto_de       =   ''VACACIONES '' || ''\r\n'' ||
                                        ''ACUMULADAS DESDE '' || to_char(r_pla_vacaciones.acum_desde, ''dd-mm-yyyy'') || ''  HASTA '' || to_char(r_pla_vacaciones.acum_hasta, ''dd-mm-yyyy'') || ''\r\n'' ||
                                        ''PAGADAS DESDE '' || to_char(r_pla_vacaciones.pagar_desde, ''dd-mm-yyyy'') || ''  HASTA '' || to_char(r_pla_vacaciones.pagar_hasta, ''dd-mm-yyyy'');
        end if;


    elsif as_tipo_de_calculo = ''3'' then
        ls_en_concepto_de   =   ''DECIMO TERCER MES'';

    else
        if r_pla_periodos.tipo_de_planilla = ''2'' then
            li_dia = extract(day from r_pla_periodos.dia_d_pago);
            if li_dia >= 16 then
                ls_en_concepto_de = ''SEGUNDA QUINCENA DEL MES DE '' || trim(f_mes(li_mes)) || '' DE '' || to_char(li_anio,''9999'');
            else
                ls_en_concepto_de = ''PRIMERA QUINCENA DEL MES DE '' || trim(f_mes(li_mes)) || '' DE '' || to_char(li_anio,''9999'');
            end if;
        else
            ls_en_concepto_de = ''PLANILLA '' || trim(r_pla_tipos_de_planilla.descripcion) || '' DEL: '' || r_pla_periodos.desde || ''  '' || r_pla_periodos.hasta;
        end if;
    end if;    

    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    if not found then
        return 0;
    end if;
    
    if r_pla_empleados.forma_de_pago = ''T'' then
        return 0;
    end if;
    
    
    if r_pla_empleados.forma_de_pago = ''C'' then
        ls_paguese_a = trim(r_pla_empleados.nombre) || ''  '' || trim(r_pla_empleados.apellido);
    else
        ls_paguese_a    =   trim(as_paguese_a);
    end if;
    
    
    select into r_pla_bancos * from pla_bancos
    where compania = ai_cia
    and status is true;
    if not found then
        raise exception ''No existe ningun banco creado para la cia %'',ai_cia;
    end if;
    
    select into ldc_monto_cheque sum(pla_dinero.monto*pla_conceptos.signo)
    from pla_dinero, pla_conceptos
    where pla_dinero.concepto = pla_conceptos.concepto
    and pla_dinero.compania = ai_cia
    and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
    and pla_dinero.codigo_empleado = as_codigo_empleado
    and pla_dinero.id_pla_cheques_1 is null
    and pla_dinero.id_periodos = ai_periodo;
    if not found then
        return 0;
    end if;
    
    
    sw = true;  
    for r_v_pla_dinero_cheques in select * from v_pla_dinero_cheques
                            where compania = ai_cia
                            and tipo_de_calculo = as_tipo_de_calculo
                            and id_periodos = ai_periodo
                            and codigo_empleado = as_codigo_empleado
                            order by tipo_de_concepto, prioridad_impresion, monto desc
    loop
        if sw is true then
            sw = false;
            select into r_pla_cheques_1 * from pla_cheques_1
            where id_pla_bancos = r_pla_bancos.id
            and tipo_transaccion = ''SC''
            and trim(paguese_a) = trim(ls_paguese_a);
            if not found then
                li_no_cheque = 0;
                loop
                    li_no_cheque = li_no_cheque + 1;
                    select into r_pla_cheques_1 * from pla_cheques_1
                    where tipo_transaccion = ''SC''
                    and id_pla_bancos = r_pla_bancos.id
                    and no_cheque = li_no_cheque;
                    if not found then
                        insert into pla_cheques_1(id_pla_bancos, tipo_transaccion,
                            no_cheque, no_solicitud, paguese_a, fecha_solicitud, fecha_cheque,
                            en_concepto_de, status, monto)
                        values(r_pla_bancos.id, ''SC'', li_no_cheque,
                            li_no_cheque, ls_paguese_a, current_date, current_date, ls_en_concepto_de,
                            ''R'', ldc_monto_cheque);
                            
                        select into li_id_pla_cheques_1 id
                        from pla_cheques_1
                        where tipo_transaccion = ''SC''
                        and id_pla_bancos = r_pla_bancos.id
                        and no_cheque = li_no_cheque;
                        
--                        li_id_pla_cheques_1 = LastVal();
                        exit;
                    end if;
                end loop;
--                li_no_cheque = r_pla_bancos.sec_solicitudes + 1;
            else
                li_id_pla_cheques_1 = r_pla_cheques_1.id;
            end if;
        end if;
        
        select into r_pla_departamentos *
        from pla_departamentos
        where id = r_pla_empleados.departamento;

        
        if Trim(ls_cheque_resumido) = ''S'' then
            select into r_pla_cuentas * from pla_cuentas
            where trim(cuenta) = trim(ls_cuenta_salarios_por_pagar)
            and compania = ai_cia;

            r_v_pla_dinero_cheques.id_pla_cuentas = r_pla_cuentas.id;
            lb_insertar = false;
            for r_pla_acreedores in
                select pla_acreedores.* 
                from pla_deducciones, pla_retenciones, pla_acreedores
                where pla_deducciones.id_pla_retenciones = pla_retenciones.id
                and pla_retenciones.acreedor = pla_acreedores.acreedor
                and pla_retenciones.compania = pla_acreedores.compania
                and pla_deducciones.id_pla_dinero = r_v_pla_dinero_cheques.id_pla_dinero
                order by concepto
            loop
                for r_pla_cuentas_x_concepto in
                    select pla_cuentas_x_concepto.* 
                    from pla_cuentas_x_concepto, pla_cuentas
                    where pla_cuentas_x_concepto.id_pla_cuentas = pla_cuentas.id
                    and pla_cuentas.compania = ai_cia
                    and pla_cuentas_x_concepto.concepto = r_pla_acreedores.concepto
                    order by pla_cuentas_x_concepto.concepto
                loop
                    r_v_pla_dinero_cheques.id_pla_cuentas = r_pla_cuentas_x_concepto.id_pla_cuentas_2;
                    r_pla_cuentas.nombre = trim(r_v_pla_dinero_cheques.descripcion);
                    lb_insertar = true;
                    exit;
                end loop;
                exit;
            end loop;


            if ai_cia = 745 or ai_cia = 746 or ai_cia = 747 or ai_cia = 754 then
                if Trim(r_v_pla_dinero_cheques.concepto) = ''73'' then
                    for r_pla_cuentas_x_concepto in
                        select pla_cuentas_x_concepto.* 
                        from pla_cuentas_x_concepto, pla_cuentas
                        where pla_cuentas_x_concepto.id_pla_cuentas = pla_cuentas.id
                        and pla_cuentas.compania = ai_cia
                        and pla_cuentas_x_concepto.concepto = r_v_pla_dinero_cheques.concepto
                        order by pla_cuentas_x_concepto.concepto
                    loop
                        r_v_pla_dinero_cheques.id_pla_cuentas = r_pla_cuentas_x_concepto.id_pla_cuentas;
                        r_pla_cuentas.nombre = trim(r_v_pla_dinero_cheques.descripcion);
                        lb_insertar = true;
                        exit;
                    end loop;
                end if;
            end if;

            
            select into r_pla_cheques_2 * from pla_cheques_2
            where id_pla_cheques_1 = li_id_pla_cheques_1
            and id_pla_cuentas = r_v_pla_dinero_cheques.id_pla_cuentas
            and Trim(descripcion) = Trim(r_pla_cuentas.nombre);
            if found and not lb_insertar then
                update pla_cheques_2
                set monto = monto + r_v_pla_dinero_cheques.monto
                where id = r_pla_cheques_2.id;
            else
                insert into pla_cheques_2 (id_pla_cheques_1, id_pla_cuentas,
                    monto, descripcion)
                values (li_id_pla_cheques_1, r_v_pla_dinero_cheques.id_pla_cuentas, 
                     r_v_pla_dinero_cheques.monto, Trim(r_pla_cuentas.nombre));
            end if;
        else
            select into r_pla_cuentas * from pla_cuentas
            where trim(cuenta) = trim(ls_cuenta_salarios_por_pagar)
            and compania = ai_cia;
        
            r_v_pla_dinero_cheques.id_pla_cuentas = r_pla_cuentas.id;
            lb_acreedor = false;
            
            for r_pla_acreedores in
                select * from pla_acreedores
                where concepto = r_v_pla_dinero_cheques.concepto
                and compania = ai_cia
                order by concepto
            loop
                for r_pla_cuentas_x_concepto in
                    select pla_cuentas_x_concepto.* 
                    from pla_cuentas_x_concepto, pla_cuentas
                    where pla_cuentas_x_concepto.id_pla_cuentas = pla_cuentas.id
                    and pla_cuentas.compania = ai_cia
                    and pla_cuentas_x_concepto.concepto = r_v_pla_dinero_cheques.concepto
                    order by pla_cuentas_x_concepto.concepto
                loop
/*                
                    if ai_cia = 839 then
                        select into r_pla_retenciones pla_retenciones.*
                        from pla_retenciones, pla_deducciones
                        where pla_retenciones.id = pla_deducciones.id_pla_retenciones
                        and pla_deducciones.id_pla_dinero = r_v_pla_dinero_cheques.id_pla_dinero;
                        if found then
                            if r_v_pla_dinero_cheques.concepto = ''201'' then
                                ls_cuenta = ''1260-'' || trim(r_pla_empleados.codigo_empleado);
                            else
                                ls_cuenta = ''2280-'' || trim(r_pla_retenciones.acreedor);
                            end if;
                        end if;
                        lb_acreedor = true;
                    end if;
*/                        
                    
                    select into r_pla_cuentas * 
                    from pla_cuentas
                    where trim(cuenta) = trim(ls_cuenta)
                    and compania = ai_cia;
                    if found then
                        r_v_pla_dinero_cheques.id_pla_cuentas = r_pla_cuentas.id;
                    else
                        if r_v_pla_dinero_cheques.monto <= 0 then
                            r_v_pla_dinero_cheques.id_pla_cuentas = r_pla_cuentas_x_concepto.id_pla_cuentas_2;
                        else
                            r_v_pla_dinero_cheques.id_pla_cuentas = r_pla_cuentas_x_concepto.id_pla_cuentas;
                        end if;
                    end if;
                    exit;
                end loop;
                exit;
            end loop;
            
            
            li_id_pla_auxiliares = null;
            
            
            if ai_cia = 745 or ai_cia = 746 or ai_cia = 747 or ai_cia = 754 then
                if Trim(r_v_pla_dinero_cheques.concepto) = ''73'' then
                    for r_pla_cuentas_x_concepto in
                        select pla_cuentas_x_concepto.* from pla_cuentas_x_concepto, pla_cuentas
                        where pla_cuentas_x_concepto.id_pla_cuentas = pla_cuentas.id
                        and pla_cuentas.compania = ai_cia
                        and pla_cuentas_x_concepto.concepto = r_v_pla_dinero_cheques.concepto
                        order by pla_cuentas_x_concepto.concepto
                    loop
                        r_v_pla_dinero_cheques.id_pla_cuentas = r_pla_cuentas_x_concepto.id_pla_cuentas;
                        r_pla_cuentas.nombre = trim(r_v_pla_dinero_cheques.descripcion);
                        lb_insertar = true;
                        exit;
                    end loop;
                end if;
            end if;
  
/*            
            if ai_cia = 839 and lb_acreedor is false then
                for r_pla_cuentas_x_concepto in
                    select pla_cuentas_x_concepto.* from pla_cuentas_x_concepto, pla_cuentas
                    where pla_cuentas_x_concepto.id_pla_cuentas = pla_cuentas.id
                    and pla_cuentas.compania = ai_cia
                    and pla_cuentas_x_concepto.concepto = r_v_pla_dinero_cheques.concepto
                    order by pla_cuentas_x_concepto.concepto
                loop
                    select into r_pla_cuentas *
                    from pla_cuentas
                    where id = r_pla_cuentas_x_concepto.id_pla_cuentas;
                    
                    r_v_pla_dinero_cheques.id_pla_cuentas = r_pla_cuentas_x_concepto.id_pla_cuentas;
                    lb_insertar = true;
                    exit;
                end loop;
            end if;            
*/            
            
            
            select into r_pla_cheques_2 * 
            from pla_cheques_2
            where id_pla_cheques_1 = li_id_pla_cheques_1
            and trim(descripcion) = Trim(r_v_pla_dinero_cheques.descripcion);
            if found then
                update pla_cheques_2
                set monto = monto + r_v_pla_dinero_cheques.monto
                where id_pla_cheques_1 = li_id_pla_cheques_1
                and descripcion = Trim(r_v_pla_dinero_cheques.descripcion);
            else
                insert into pla_cheques_2 (id_pla_cheques_1, id_pla_cuentas, id_pla_auxiliares, 
                    monto, descripcion)
                values (li_id_pla_cheques_1, r_v_pla_dinero_cheques.id_pla_cuentas, li_id_pla_auxiliares, 
                    r_v_pla_dinero_cheques.monto, Trim(r_v_pla_dinero_cheques.descripcion));
            end if;
        end if;        
    end loop;
    
    
    select into r_pla_cheques_2 * from pla_cheques_2
    where id_pla_cheques_1 = li_id_pla_cheques_1
    and id_pla_cuentas = r_pla_bancos.id_pla_cuentas;
    if not found then
        insert into pla_cheques_2 (id_pla_cheques_1, id_pla_cuentas,
            monto, descripcion)
        values (li_id_pla_cheques_1, r_pla_bancos.id_pla_cuentas, 
             -ldc_monto_cheque, Trim(r_pla_bancos.nombre));
    else
        update pla_cheques_2
        set monto = monto -ldc_monto_cheque
        where id_pla_cheques_1 = li_id_pla_cheques_1
        and id_pla_cuentas = r_pla_bancos.id_pla_cuentas;
    end if;
    

    ldc_monto_cheque = 0;
    select -sum(monto) into ldc_monto_cheque from pla_cheques_2
    where id_pla_cheques_1 = li_id_pla_cheques_1
    and id_pla_cuentas = r_pla_bancos.id_pla_cuentas;
    
    update pla_cheques_1
    set monto = ldc_monto_cheque
    where id = li_id_pla_cheques_1;

    
    if sw is false then
        update pla_dinero 
        set id_pla_cheques_1 = li_id_pla_cheques_1
        where pla_dinero.compania = ai_cia
        and pla_dinero.tipo_de_calculo = as_tipo_de_calculo
        and pla_dinero.codigo_empleado = as_codigo_empleado
        and pla_dinero.id_pla_cheques_1 is null
        and pla_dinero.id_periodos = ai_periodo;
    end if;
    return 1;
end;
' language plpgsql;
