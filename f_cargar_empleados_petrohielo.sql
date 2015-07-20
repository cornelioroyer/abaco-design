drop function f_cargar_personal_petrohielo() cascade;


create function f_cargar_personal_petrohielo() returns integer as '
declare
    ai_compania integer;
    r_pla_preelaboradas record;
    r_pla_empleados record;
    r_tmp_acumulados_decal record;
    r_tmp_personal_petrohielo record;
    r_pla_retenciones record;
    r_pla_retener record;
    r_pla_acreedores record;
    r_pla_cargos record;
    r_pla_departamentos record;
    r_tmp_deducciones_petrohielo record;
    r_tmp_acreedores_petrohielo record;
    ld_fecha date;
    lc_work char(20);
    lc_codigo_empleado char(20);
    lc_ss char(20);
    lc_cargo char(30);
    lc_estatus char(1);
    ld_fecha_inicio date;
    ld_fecha_nacimiento date;
    li_anio integer;
    li_mes integer;
    li_dia integer;
    li_id_pla_cargos int4;
    li_codigo_cargo int4;
    lc_codigo_cargo char(3);
    li_codigo_departamento int4;
    li_id_pla_departamentos int4;
    lc_departamento char(3);
    lc_estado_civil char(1);
    lc_acreedor char(10);
    lc_numero_documento char(30);
    lc_aplica_diciembre char(1);
begin
    ai_compania             =   1135;
    li_codigo_cargo         =   0;
    li_codigo_departamento  =   0;
    

    for r_tmp_acreedores_petrohielo in select * from tmp_acreedores_petrohielo
                                        where acreedor is not null
                                        order by cod_acr
    loop
        lc_acreedor = Trim(to_char(r_tmp_acreedores_petrohielo.cod_acr, ''9999999''));
        
        select into r_pla_acreedores * 
        from pla_acreedores
        where compania = ai_compania
        and trim(acreedor) = trim(lc_acreedor);
        if not found then
            insert into pla_acreedores(compania, acreedor, concepto, nombre,
                        status, telefono, direccion, observacion, prioridad, ahorro)
            values(ai_compania, Trim(lc_acreedor),
                    ''113'', trim(r_tmp_acreedores_petrohielo.acreedor),
                    ''A'', trim(r_tmp_acreedores_petrohielo.tele1),
                    trim(r_tmp_acreedores_petrohielo.post),
                    null, 100, ''N'');
        end if;
    
    end loop;
    
                                            
    
    for r_tmp_personal_petrohielo in select * from tmp_personal_petrohielo
                                    order by codigo_empleado
    loop
    
        lc_codigo_empleado  =   trim(to_char(r_tmp_personal_petrohielo.codigo_empleado,''9999999''));
        lc_cargo            =   trim(r_tmp_personal_petrohielo.ocup);
        lc_ss               =   Trim(r_tmp_personal_petrohielo.seg_s);
        lc_estatus          =   ''A'';

        select into r_pla_cargos *
        from pla_cargos
        where compania = ai_compania
        and trim(descripcion) = trim(lc_cargo);
        if not found then
            li_codigo_cargo =   li_codigo_cargo + 1;
            lc_codigo_cargo =   trim(to_char(li_codigo_cargo,''999''));
            insert into pla_cargos(compania, cargo, descripcion, status, monto)
            values(ai_compania, trim(lc_codigo_cargo), trim(lc_cargo),
                1, 0);
        end if;


        select into r_pla_cargos *
        from pla_cargos
        where compania = ai_compania
        and trim(descripcion) = trim(lc_cargo);
        if found then
            li_id_pla_cargos = r_pla_cargos.id;
        end if;


        select into r_pla_departamentos *
        from pla_departamentos
        where compania = ai_compania
        and trim(descripcion) = trim(r_tmp_personal_petrohielo.depart);
        if not found then
            li_codigo_departamento = li_codigo_departamento + 1;
            lc_departamento = trim(to_char(li_codigo_departamento, ''999''));
            
            insert into pla_departamentos(compania, departamento, descripcion, status)
            values(ai_compania, lc_departamento, trim(r_tmp_personal_petrohielo.depart), 1);
            
        end if;

        
        select into r_pla_departamentos *
        from pla_departamentos
        where compania = ai_compania
        and trim(descripcion) = trim(r_tmp_personal_petrohielo.depart);
        if found then
            li_id_pla_departamentos = r_pla_departamentos.id;
        end if;        
        
        ld_fecha_inicio     =   r_tmp_personal_petrohielo.f_eng;
        ld_fecha_nacimiento =   r_tmp_personal_petrohielo.f_nac;
        
        if trim(r_tmp_personal_petrohielo.civil) = ''CASADO'' 
            or trim(r_tmp_personal_petrohielo.civil) = ''CASADA'' then
            lc_estado_civil = ''C'';
        elsif trim(r_tmp_personal_petrohielo.civil) = ''SOLTERO'' then
                lc_estado_civil = ''S'';
        elsif trim(r_tmp_personal_petrohielo.civil) = ''UNIDO'' then
                lc_estado_civil = ''U'';
        else
                lc_estado_civil = ''D'';
        end if;
        
        select into r_pla_empleados *
        from pla_empleados
        where compania = ai_compania
        and trim(codigo_empleado) = trim(lc_codigo_empleado);
        if not found then
            insert into pla_empleados(compania, codigo_empleado,
            apellido, nombre, cargo, departamento, id_pla_proyectos,
            tipo_de_planilla, grupo, dependientes, dependientes_no_declarados,
            tipo_contrato, estado_civil, fecha_inicio, fecha_nacimiento,
            tipo_de_salario, forma_de_pago, tipo_calculo_ir,
            status, sexo, tipo, cedula, dv, declarante, ss, direccion1,
            tasa_por_hora, salario_bruto, email)
            values(ai_compania, lc_codigo_empleado,
            trim(r_tmp_personal_petrohielo.apellido), trim(r_tmp_personal_petrohielo.nombre),
            li_id_pla_cargos, li_id_pla_departamentos, 1117, ''2'', ''A'', 0, 0, 
            ''P'', lc_estado_civil, ld_fecha_inicio, ld_fecha_nacimiento, 
            ''F'',''T'', ''A'', ''A'', ''M'', ''1'', 
            Trim(r_tmp_personal_petrohielo.cedula), ''00'', ''N'', Trim(lc_ss), 
            ''poner'', r_tmp_personal_petrohielo.rata0, 
            r_tmp_personal_petrohielo.sbm/2, '''');
            
        else
            update pla_empleados
            set telefono_1 = trim(r_tmp_personal_petrohielo.tele1),
            telefono_2 = Trim(r_tmp_personal_petrohielo.tele2),
            direccion3 = ''OJOS '' || Trim(r_tmp_personal_petrohielo.ojos),
            direccion4 = ''PELO '' || Trim(r_tmp_personal_petrohielo.pelo)
            where compania = ai_compania
            and trim(codigo_empleado) = trim(lc_codigo_empleado);
        end if;

        for r_tmp_deducciones_petrohielo in 
                select * from tmp_deducciones_petrohielo
                where codigo_empleado = r_tmp_personal_petrohielo.codigo_empleado
                order by cod_acr
        loop
            lc_acreedor = Trim(to_char(r_tmp_deducciones_petrohielo.cod_acr, ''9999999''));
            lc_numero_documento =   Trim(to_char(r_tmp_deducciones_petrohielo.desc_n, ''999999999''));

            
            if r_tmp_deducciones_petrohielo.dici = ''0'' then
                lc_aplica_diciembre = ''S'';
            else
                lc_aplica_diciembre = ''N'';
            end if;

            
            select into r_pla_retenciones *
            from pla_retenciones
            where compania = ai_compania
            and codigo_empleado = lc_codigo_empleado
            and acreedor = lc_acreedor
            and concepto = ''113''
            and numero_documento = lc_numero_documento;
            if not found then
                insert into pla_retenciones(compania, codigo_empleado, acreedor,
                    concepto, numero_documento, descripcion_descuento,
                    monto_original_deuda, letras_a_pagar, fecha_inidescto,
                    hacer_cheque, incluir_deduc_carta_trabajo,
                    aplica_diciembre, tipo_descuento, status)
                values(ai_compania, lc_codigo_empleado,
                    lc_acreedor, ''113'', lc_numero_documento, 
                    trim(r_tmp_deducciones_petrohielo.tipo),
                    r_tmp_deducciones_petrohielo.saldo,
                    0, r_tmp_deducciones_petrohielo.apartir,
                    ''S'', ''S'', lc_aplica_diciembre, ''M'', ''A'');
            end if;
            
            select into r_pla_retenciones *
            from pla_retenciones
            where compania = ai_compania
            and codigo_empleado = lc_codigo_empleado
            and acreedor = lc_acreedor
            and concepto = ''113''
            and numero_documento = lc_numero_documento;
            if found then
                insert into pla_retener(id_pla_retenciones, periodo, monto)
                values(r_pla_retenciones.id, 1, r_tmp_deducciones_petrohielo.desc_de);
                
                insert into pla_retener(id_pla_retenciones, periodo, monto)
                values(r_pla_retenciones.id, 2, r_tmp_deducciones_petrohielo.desc_de);
                
            end if;            
        
        end loop; 
                       
    end loop;

    
    return 1;
end;
' language plpgsql;


/*
*/        
/*        
*/            



 /*           
            update pla_empleados
            set apellido = trim(r_tmp_personal_petrohielo.apellido),
                nombre = trim(r_tmp_personal_petrohielo.nombre),
                cargo = li_id_pla_cargos,
                fecha_inicio = ld_fecha_inicio,
                fecha_nacimiento = ld_fecha_nacimiento,
                cedula = trim(r_tmp_personal_petrohielo.cedula),
                status = lc_estatus,
                ss = trim(lc_ss),
                tasa_por_hora = r_tmp_personal_petrohielo.tasa_x_hora,
                salario_bruto = r_tmp_personal_petrohielo.salario_mensual/2,
                departamento = 1489
            where compania = ai_compania
            and trim(codigo_empleado) = trim(lc_codigo_empleado);
        end if;


        for r_tmp_descuentos_petrohielo in
                select * from tmp_descuentos_petrohielo
                where trim(codigo_empleado) = trim(lc_codigo_empleado)
        loop
            select into r_pla_acreedores *
            from pla_acreedores
            where compania = ai_compania
            and trim(acreedor) = trim(r_tmp_descuentos_petrohielo.codigo_acreedor);
            if not found then
                insert into pla_acreedores(compania, acreedor, concepto,
                    nombre, status, prioridad, ahorro)
                values(ai_compania, trim(r_tmp_descuentos_petrohielo.codigo_acreedor),
                    ''113'',
                    SubString(Trim(r_tmp_descuentos_petrohielo.descripcion_acreedor) from 1 for 40),
                    ''A'', 100, ''N'');
            end if;
            
            
            select into r_pla_retenciones *
            from pla_retenciones
            where compania = ai_compania
            and trim(codigo_empleado) = trim(lc_codigo_empleado)
            and trim(acreedor) = trim(r_tmp_descuentos_petrohielo.codigo_acreedor);
            if not found then
                insert into pla_retenciones(compania, codigo_empleado,
                    acreedor, concepto, numero_documento,
                    descripcion_descuento, monto_original_deuda,
                    letras_a_pagar, fecha_inidescto,
                    hacer_cheque, incluir_deduc_carta_trabajo, aplica_diciembre,
                    tipo_descuento, status)
                values(ai_compania, trim(lc_codigo_empleado), 
                    trim(r_tmp_descuentos_petrohielo.codigo_acreedor),
                    ''113'', ''1234'', ''DESCUENTO'', r_tmp_descuentos_petrohielo.saldo_inicial,
                    0, ''2012-01-01'', trim(r_tmp_descuentos_petrohielo.emite_cheque),
                    ''S'', trim(r_tmp_descuentos_petrohielo.descontar_diciembre),
                    ''M'', ''A'');
            end if;

            select into r_pla_retenciones *
            from pla_retenciones
            where compania = ai_compania
            and trim(codigo_empleado) = trim(lc_codigo_empleado)
            and trim(acreedor) = trim(r_tmp_descuentos_petrohielo.codigo_acreedor);
            if found then
                select into r_pla_retener *
                from pla_retener
                where id_pla_retenciones = r_pla_retenciones.id
                and periodo = 1;
                if not found then
                    insert into pla_retener(id_pla_retenciones, periodo, monto)
                    values(r_pla_retenciones.id, 1, r_tmp_descuentos_petrohielo.descuento_x_periodo);
                end if;

                select into r_pla_retener *
                from pla_retener
                where id_pla_retenciones = r_pla_retenciones.id
                and periodo = 2;
                if not found then
                    insert into pla_retener(id_pla_retenciones, periodo, monto)
                    values(r_pla_retenciones.id, 2, r_tmp_descuentos_petrohielo.descuento_x_periodo);
                end if;
            end if;
        end loop;
*/
        
/*
        for r_tmp_pagos_2006 in select * from tmp_pagos_2006
                                where trim(codigo_empleado) = trim(lc_codigo_empleado)
                                order by anio, mes
        loop
            li_anio         =   r_tmp_pagos_2006.anio;
            li_mes          =   r_tmp_pagos_2006.mes;
            li_dia          =   r_tmp_pagos_2006.dia;
            ld_fecha_inicio =   f_to_date(li_anio, li_mes, li_dia);
             
        end loop;
*/
        
        


/*
        lc_work =   Trim(To_Char(r_tmp_personal_petrohielo.fecha_inicio, ''99999999''));
        li_anio =   To_Number(Substring(Trim(lc_work) from 1 for 4), ''9999'');
        li_mes  =   To_Number(Substring(Trim(lc_work) from 5 for 2), ''9999'');
        li_dia  =   To_Number(Substring(Trim(lc_work) from 7 for 2), ''9999'');
        ld_fecha_inicio =   f_to_date(li_anio, li_mes, li_dia);
       
        lc_work =   Trim(To_Char(r_tmp_personal_petrohielo.fecha_nacimiento,''99999999''));
        li_anio =   To_Number(Substring(Trim(lc_work) from 1 for 4), ''9999'');
        li_mes  =   To_Number(Substring(Trim(lc_work) from 5 for 2), ''9999'');
        li_dia  =   To_Number(Substring(Trim(lc_work) from 7 for 2), ''9999'');
        ld_fecha_nacimiento =   f_to_date(li_anio, li_mes, li_dia);
*/        
