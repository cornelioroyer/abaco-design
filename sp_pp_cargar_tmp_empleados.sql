set search_path to planilla;

drop function f_cargar_tmp_empleados(int4);
drop function f_cargar_tmp_empleados_fiesta(int4);
drop function f_cargar_tmp_acumulados(int4);

create function f_cargar_tmp_empleados_fiesta(int4) returns integer as '
declare
    ai_cia alias for $1;
    r_tmp_empleados record;
    r_pla_departamentos record;
    r_pla_acreedores record;
    r_pla_cargos record;
    r_pla_proyectos record;
    r_pla_empleados record;
    r_tmp_proyectos record;
    r_pla_retener record;
    r_pla_retenciones record;
    r_tmp_descuentos record;
    r_pla_companias record;
    r_pla_bancos record;
    lc_tipo_de_contrato char(1);
    lc_forma_de_pago char(1);
    lc_sexo char(1);
    lc_codigo_empleado char(7);
    lc_departamento char(3);
    lc_cargo char(3);
    lc_proyecto char(20);
    lc_grupo char(1);
    lc_estado_civil char(1);
    lc_tipo_descuento char(1);
    lc_tipo_de_salario char(1);
    lc_status char(1);
    lc_dv char(2);
    lc_tipo_de_planilla char(2);
    lc_acreedor char(10);
    lc_email char(100);
    lc_numero_documento char(30);
    li_dependientes int4;
    li_compania int4;
    ldc_salario_bruto decimal;
    ldc_porcentaje decimal;
    ldc_letra decimal;
    ldc_monto decimal;
    ldc_saldo decimal;
    ldc_tasa_por_hora decimal;
    ld_fecha_nacimiento date;
    ld_fecha_terminacion_real date;
    ld_fecha_inicio date;
    lc_sindicalizado char(1);
begin

    
    lc_sindicalizado = ''N'';
    
    lc_tipo_de_salario = ''F'';
    
    select into r_pla_companias * from pla_companias
    where compania = ai_cia;
    if not found then
        return 0;
    end if;

    
    for r_tmp_empleados in
        select * from tmp_empleados
        where compania = ai_cia
        and codigo_empleado is not null
        order by codigo_empleado
    loop
        lc_sindicalizado = ''N'';
        
        if r_tmp_empleados.tasa_por_hora is null then
            r_tmp_empleados.tasa_por_hora = 0;
        end if;
        

        r_tmp_empleados.cedula = r_tmp_empleados.codigo_empleado;    
        
        select into r_pla_departamentos *
        from pla_departamentos
        where compania = ai_cia
        order by id;


            select into r_pla_cargos *
            from pla_cargos
            where compania = ai_cia
            order by id;

    
        select into r_pla_proyectos * 
        from pla_proyectos
        where compania = ai_cia
        order by id;
        
        select into r_pla_bancos *
        from pla_bancos
        where compania = ai_cia
        order by id;



        if r_tmp_empleados.salario is null then
--            ldc_salario_bruto   =   2.72 * 104;
        else
            ldc_salario_bruto   =   r_tmp_empleados.salario/2;
        end if;


        lc_tipo_de_contrato =   ''P'';
        ld_fecha_nacimiento =   ''2015-01-01'';
        lc_forma_de_pago    =   ''T'';


        lc_sexo             =   ''M'';
        lc_dv               =   ''00'';
        ld_fecha_inicio     =   r_tmp_empleados.fecha_inicio;

        if ld_fecha_inicio is null then
            ld_fecha_inicio = current_date;
        end if;            

        lc_codigo_empleado  =   trim(r_tmp_empleados.codigo_empleado);

        lc_email = ''cornelioroyer@winsof.com'';       
        
        lc_sexo =   ''M'';
        
        ld_fecha_nacimiento = current_date;

                lc_estado_civil =   ''C'';
        

        lc_status = ''A'';
        
        ldc_tasa_por_hora   =   r_tmp_empleados.tasa_por_hora;
        
        
        lc_grupo        =   ''A'';
        li_dependientes =   0;

 
        select into r_pla_empleados *
        from pla_empleados
        where compania = r_tmp_empleados.compania
        and Trim(codigo_empleado) = trim(lc_codigo_empleado);
        if not found then
            insert into pla_empleados(compania, codigo_empleado,
                tipo_de_planilla, grupo, dependientes, nombre, apellido,
                tipo_contrato, estado_civil, fecha_inicio, 
                fecha_nacimiento, tipo_de_salario, forma_de_pago, tipo_calculo_ir, status,
                sexo, cedula, dv, declarante, ss, direccion1, direccion2, tasa_por_hora, salario_bruto, email,
                cargo, departamento, id_pla_proyectos, telefono_1, telefono_2, direccion4, direccion3,
                tipo_cta_bco, id_pla_bancos, cta_bco_empleado, fecha_terminacion_real, sindicalizado)
            values(ai_cia, trim(lc_codigo_empleado), ''2'' , 
                lc_grupo, li_dependientes, 
                Trim(r_tmp_empleados.nombre), Trim(r_tmp_empleados.apellido),
                lc_tipo_de_contrato, lc_estado_civil, ld_fecha_inicio,
                ld_fecha_nacimiento, lc_tipo_de_salario, lc_forma_de_pago, ''R'', lc_status,
                lc_sexo,
                trim(r_tmp_empleados.cedula), lc_dv, ''1'', ''00'',
                ''no'', 
                ''no'', 
                ldc_tasa_por_hora, ldc_salario_bruto, trim(lc_email), r_pla_cargos.id, r_pla_departamentos.id,
                r_pla_proyectos.id, null, null, null, null, ''04'',
                r_pla_bancos.id, null, ld_fecha_terminacion_real, lc_sindicalizado);

        else
/*        
            update pla_empleados
            set fecha_terminacion_real = ld_fecha_terminacion_real,
                status = lc_status
            where compania = r_tmp_empleados.compania
            and Trim(codigo_empleado) = trim(lc_codigo_empleado);
*/            
        end if;            
        
    end loop;            
    return 1;

end;
' language plpgsql;




create function f_cargar_tmp_acumulados(int4) returns integer as '
declare
    ai_cia alias for $1;
    r_tmp_acumulados record;
    r_pla_conceptos record;
    r_pla_empleados record;
    r_pla_preelaboradas record;
begin

--raise exception ''entre'';


    for r_tmp_acumulados in
        select * from tmp_acumulados
        where compania = ai_cia
        and codigo_empleado is not null
        and monto <> 0
        order by codigo_empleado
    loop
    
--raise exception ''entre'';
    
        select into r_pla_conceptos *
        from pla_conceptos
        where trim(concepto) = trim(r_tmp_acumulados.concepto);
        if not found then
            continue;
        end if;

        
        select into r_pla_empleados *
        from pla_empleados
        where compania = r_tmp_acumulados.compania
        and trim(codigo_empleado) = trim(r_tmp_acumulados.codigo_empleado);
        if not found then
            continue;
        end if;
        
        select into r_pla_preelaboradas *
        from pla_preelaboradas
        where compania = r_tmp_acumulados.compania
        and trim(codigo_empleado) = trim(r_tmp_acumulados.codigo_empleado)
        and trim(concepto) = trim(r_tmp_acumulados.concepto)
        and fecha = r_tmp_acumulados.fecha;
        if not found then
            insert into pla_preelaboradas(compania, codigo_empleado, concepto, fecha, monto)
            values (r_tmp_acumulados.compania, trim(r_tmp_acumulados.codigo_empleado),
                trim(r_tmp_acumulados.concepto), r_tmp_acumulados.fecha,
                r_tmp_acumulados.monto);
        else
            update pla_preelaboradas
            set monto = r_tmp_acumulados.monto                
            where compania = r_tmp_acumulados.compania
            and trim(codigo_empleado) = trim(r_tmp_acumulados.codigo_empleado)
            and trim(concepto) = trim(r_tmp_acumulados.concepto)
            and fecha = r_tmp_acumulados.fecha;
        end if;
        
    end loop;
    
    return 1;

end;
' language plpgsql;


create function f_cargar_tmp_empleados(int4) returns integer as '
declare
    ai_cia alias for $1;
    r_tmp_empleados record;
    r_pla_departamentos record;
    r_pla_acreedores record;
    r_pla_cargos record;
    r_pla_proyectos record;
    r_pla_empleados record;
    r_tmp_proyectos record;
    r_pla_retener record;
    r_pla_retenciones record;
    r_tmp_descuentos record;
    r_pla_companias record;
    r_pla_bancos record;
    lc_tipo_de_contrato char(1);
    lc_forma_de_pago char(1);
    lc_sexo char(1);
    lc_codigo_empleado char(7);
    lc_departamento char(3);
    lc_cargo char(3);
    lc_proyecto char(20);
    lc_grupo char(1);
    lc_estado_civil char(1);
    lc_tipo_descuento char(1);
    lc_tipo_de_salario char(1);
    lc_status char(1);
    lc_dv char(2);
    lc_tipo_de_planilla char(2);
    lc_acreedor char(10);
    lc_email char(100);
    lc_numero_documento char(30);
    li_dependientes int4;
    li_compania int4;
    ldc_salario_bruto decimal;
    ldc_porcentaje decimal;
    ldc_letra decimal;
    ldc_monto decimal;
    ldc_saldo decimal;
    ldc_tasa_por_hora decimal;
    ld_fecha_nacimiento date;
    ld_fecha_terminacion_real date;
    ld_fecha_inicio date;
    lc_sindicalizado char(1);
begin

    
    lc_sindicalizado = ''N'';
    
    lc_tipo_de_salario = ''F'';
    
    select into r_pla_companias * from pla_companias
    where compania = ai_cia;
    if not found then
        return 0;
    end if;

    
    for r_tmp_empleados in
        select * from tmp_empleados
        where compania = ai_cia
        and codigo_empleado is not null
        order by codigo_empleado
    loop


        lc_sindicalizado = ''N'';
        
        if r_tmp_empleados.sindicalizado = ''SI'' then
            lc_sindicalizado = ''S'';
        end if;            
        
        if r_tmp_empleados.tasa_por_hora is null then
            r_tmp_empleados.tasa_por_hora = 0;
        end if;
        
        if r_tmp_empleados.dv is null then
            r_tmp_empleados.dv = ''00'';
        end if;
        
        if r_tmp_empleados.cedula is null then
            r_tmp_empleados.cedula = ''PONER CEDULA'' || trim(r_tmp_empleados.codigo_empleado); 
        end if;
    
        
        select into r_pla_departamentos *
        from pla_departamentos
        where compania = ai_cia
        order by id;


        if r_tmp_empleados.cargo is null then
            select into r_pla_cargos *
            from pla_cargos
            where compania = ai_cia
            order by id;
        else
            select into r_pla_cargos *
            from pla_cargos
            where compania = ai_cia
            and trim(descripcion) = trim(r_tmp_empleados.cargo);
            if not found then
                insert into pla_cargos(compania, cargo, 
                    descripcion, status, monto)
                values(ai_cia, substring(trim(r_tmp_empleados.codigo_empleado) from 2 for 3),
                    trim(r_tmp_empleados.cargo), 1, 0);
            end if;


            select into r_pla_cargos *
            from pla_cargos
            where compania = ai_cia
            and trim(descripcion) = trim(r_tmp_empleados.cargo);

                            
        end if;
    
        select into r_pla_proyectos * 
        from pla_proyectos
        where compania = ai_cia
        order by id;
        
        select into r_pla_bancos *
        from pla_bancos
        where compania = ai_cia
        order by id;



        if r_tmp_empleados.salario_bruto is null then
--            ldc_salario_bruto   =   2.72 * 104;
        else
            ldc_salario_bruto   =   r_tmp_empleados.salario_bruto;
        end if;

        
        if ai_cia = 1341 then
            ldc_salario_bruto = ldc_salario_bruto / 2;
        end if;
--        lc_grupo            =   trim(r_tmp_empleados.grupo);
--        li_dependientes     =   r_tmp_empleados.dependientes;


--        ldc_salario_bruto   =   r_tmp_empleados.salario_bruto/2;

        lc_tipo_de_contrato =   ''P'';
        ld_fecha_nacimiento =   r_tmp_empleados.fecha_nacimiento;
        lc_forma_de_pago    =   ''T'';


        lc_sexo             =   substring(trim(r_tmp_empleados.sexo) from 1 for 1);
        lc_dv               =   r_tmp_empleados.dv;
        ld_fecha_inicio     =   r_tmp_empleados.fecha_inicio;


--        lc_codigo_empleado  =   trim(r_tmp_empleados.codigo_empleado);

--        lc_codigo_empleado  =   trim(to_char(r_tmp_empleados.codigo_empleado, ''99999''));

        lc_codigo_empleado  =   trim(r_tmp_empleados.codigo_empleado);


        if r_tmp_empleados.email is null then
            lc_email = trim(r_pla_companias.e_mail);
        else
            lc_email    =   trim(r_tmp_empleados.email);
        end if;

       
        
        if lc_sexo is null then
            lc_sexo = ''M'';
        end if;
        
        lc_sexo =   ''M'';
        
        if ld_fecha_nacimiento is null then
            ld_fecha_nacimiento = current_date;
        end if;
        
        
        if trim(r_tmp_empleados.estado_civil) = ''Casado'' then
                lc_estado_civil =   ''C'';
        elsif trim(r_tmp_empleados.estado_civil) = ''Unido'' then
                lc_estado_civil =   ''U'';
        else
                lc_estado_civil =   ''S'';
        end if;


        
        if r_tmp_empleados.tasa_por_hora is null then
            ldc_tasa_por_hora   =   ldc_salario_bruto/104;
        else
            ldc_tasa_por_hora   =   r_tmp_empleados.tasa_por_hora;
        end if;
        
        if ldc_tasa_por_hora = 0 then
            ldc_tasa_por_hora = 0.01;
        end if;
        
        if ldc_salario_bruto is null or ldc_salario_bruto = 0 then
            ldc_salario_bruto = 0.01;
        end if;

/*        
        if r_tmp_empleados.email is null then
            r_tmp_empleados.email = ''a@hotmail.com'';
        end if;
*/        
        
        lc_grupo        =   ''A'';
        li_dependientes =   0;

 
        if ld_fecha_inicio is null then
            ld_fecha_inicio = current_date;
        end if;
        
        if r_tmp_empleados.fecha_terminacion_real is null then
            ld_fecha_terminacion_real   = null;
            lc_status                   =   ''A'';
        else
            ld_fecha_terminacion_real   =   r_tmp_empleados.fecha_terminacion_real;
            lc_status                   =   ''I'';
        end if;


        if lc_dv is null then
            lc_dv = ''00'';
        end if;            

        
        select into r_pla_empleados *
        from pla_empleados
        where compania = r_tmp_empleados.compania
        and Trim(codigo_empleado) = trim(lc_codigo_empleado);
        if not found then


            insert into pla_empleados(compania, codigo_empleado,
                tipo_de_planilla, grupo, dependientes, nombre, apellido,
                tipo_contrato, estado_civil, fecha_inicio, 
                fecha_nacimiento, tipo_de_salario, forma_de_pago, tipo_calculo_ir, status,
                sexo, cedula, dv, declarante, ss, direccion1, direccion2, tasa_por_hora, salario_bruto, email,
                cargo, departamento, id_pla_proyectos, telefono_1, telefono_2, direccion4, direccion3,
                tipo_cta_bco, id_pla_bancos, cta_bco_empleado, fecha_terminacion_real, sindicalizado)
            values(ai_cia, trim(lc_codigo_empleado), ''2'' , 
                lc_grupo, li_dependientes, 
                Trim(r_tmp_empleados.nombre), Trim(r_tmp_empleados.apellido),
                lc_tipo_de_contrato, lc_estado_civil, ld_fecha_inicio,
                ld_fecha_nacimiento, lc_tipo_de_salario, lc_forma_de_pago, ''R'', lc_status,
                lc_sexo,
                trim(r_tmp_empleados.cedula), lc_dv, ''1'', trim(r_tmp_empleados.ss),
                Substring(Trim(r_tmp_empleados.direccion1) from 1 for 50), 
                Substring(Trim(r_tmp_empleados.direccion2) from 1 for 50), 
                ldc_tasa_por_hora, ldc_salario_bruto, trim(lc_email), r_pla_cargos.id, r_pla_departamentos.id,
                r_pla_proyectos.id, trim(r_tmp_empleados.telefono1), null, null, null, ''04'',
                r_pla_bancos.id, trim(r_tmp_empleados.cta_bco_empleado), ld_fecha_terminacion_real, lc_sindicalizado);

--raise exception ''entre 1'';

        else
            update pla_empleados
            set fecha_terminacion_real = ld_fecha_terminacion_real,
                status = lc_status
            where compania = r_tmp_empleados.compania
            and Trim(codigo_empleado) = trim(lc_codigo_empleado);
        end if;            
        
/*       
        for r_tmp_descuentos in
                select * from tmp_descuentos
                where trim(codigo_empleado) = trim(r_tmp_empleados.codigo_empleado)
                and acreedor is not null
                order by acreedor
        loop
        
--            r_tmp_descuentos.saldo = 0;
            

            lc_acreedor =   substring(trim(r_tmp_descuentos.acreedor) from 1 for 10);


            select into r_pla_acreedores *
            from pla_acreedores
            where compania = ai_cia
            and trim(acreedor) = trim(lc_acreedor);
            if not found then
                insert into pla_acreedores(compania, acreedor, concepto,
                    nombre, status, prioridad, ahorro)
                values(ai_cia, trim(lc_acreedor), ''113'', trim(r_tmp_descuentos.nombre_acreedor),
                    ''A'', 100, ''N'');
            end if; 
            
            select into r_pla_acreedores *
            from pla_acreedores
            where compania = ai_cia
            and trim(acreedor) = trim(lc_acreedor);

            lc_tipo_descuento = ''M'';
            
            if r_tmp_descuentos.numero_documento is null then
--                lc_numero_documento =   trim(to_char(r_tmp_descuentos.id,''99999''));
                lc_numero_documento =   ''2014'';

            else
--                lc_numero_documento =   trim(r_tmp_descuentos.numero_documento);
                lc_numero_documento =   ''2014'';
            end if;
            
            select into r_pla_retenciones *
            from pla_retenciones
            where compania = ai_cia
            and trim(codigo_empleado) = trim(lc_codigo_empleado)
            and trim(acreedor) = trim(lc_acreedor);
            if not found then
            
                insert into pla_retenciones(compania, codigo_empleado,
                    acreedor, concepto, numero_documento,
                    descripcion_descuento, monto_original_deuda,
                    letras_a_pagar, fecha_inidescto,
                    hacer_cheque, incluir_deduc_carta_trabajo, aplica_diciembre,
                    tipo_descuento, status)
                values(ai_cia, trim(lc_codigo_empleado), 
                    trim(lc_acreedor),
                    ''113'', trim(lc_numero_documento), 
                    trim(r_tmp_descuentos.tipo_descuento), 
                    0,
                    0, ''2012-01-01'', ''S'', ''S'', ''S'',
                    lc_tipo_descuento, ''A'');
                                
            end if;
            
                                
            select into r_pla_retenciones *
            from pla_retenciones
            where compania = ai_cia
            and trim(codigo_empleado) = trim(lc_codigo_empleado)
            and trim(acreedor) = trim(lc_acreedor);
            if found then
                
                delete from pla_retener
                where id_pla_retenciones = r_pla_retenciones.id;
                
            
                ldc_monto   =   r_tmp_descuentos.monto1;
                if ldc_monto is null then
                    ldc_monto = 0;
                end if;
                insert into pla_retener(id_pla_retenciones, periodo, monto)
                values(r_pla_retenciones.id, 1, ldc_monto);

                ldc_monto   =   r_tmp_descuentos.monto2;
                if ldc_monto is null then
                    ldc_monto = 0;
                end if;
                insert into pla_retener(id_pla_retenciones, periodo, monto)
                values(r_pla_retenciones.id, 2, ldc_monto);



/*
                select into r_pla_retener *
                from pla_retener
                where id_pla_retenciones = r_pla_retenciones.id
                and periodo = 1;
                if not found then
                    insert into pla_retener(id_pla_retenciones, periodo, monto)
                    values(r_pla_retenciones.id, 1, ldc_monto);
                end if;


                ldc_monto   =   r_tmp_descuentos.monto2;
                select into r_pla_retener *
                from pla_retener
                where id_pla_retenciones = r_pla_retenciones.id
                and periodo = 2;
                if not found then
                    insert into pla_retener(id_pla_retenciones, periodo, monto)
                    values(r_pla_retenciones.id, 2, ldc_monto);
                end if;
*/                
            end if;
        end loop;
*/        
        
    end loop;            
    return 1;

end;
' language plpgsql;



/*
        lc_grupo        =   substring(trim(r_tmp_empleados_viveros.clave_isr) from 1 for 1);
        li_dependientes =   f_string_to_integer(substring(trim(r_tmp_empleados_viveros.clave_isr) from 1 for 1));
        
        if li_dependientes is null then
            li_dependientes = 0;
        end if;

        if trim(lc_tipo_de_planilla) = ''2'' then
            ldc_salario_bruto   =   (r_tmp_empleados_viveros.tasa_por_hora * 48 * 52) / 24;
        else
            ldc_salario_bruto   =   r_tmp_empleados_viveros.tasa_por_hora * 96;
        end if;
*/        
