drop function f_crear_empleados_chong() cascade;


create function f_crear_empleados_chong() returns integer as '
declare
    ai_compania integer;
    r_pla_conceptos record;
    r_pla_cuentas record;
    r_pla_departamentos record;
    r_pla_proyectos record;
    r_pla_empleados record;
    r_tmp_empleados record;
    r_pla_cargos record;
    r_pla_acreedores record;
    r_tmp_retenciones record;
    r_pla_retenciones record;
    r_work record;
    ls_cuenta_salarios_por_pagar char(24);
    li_id int4;
    li_contador int4;
begin
    ai_compania = 992;
    li_contador = 0;

    for r_work in select acreedor, nombre_acreedor from tmp_retenciones
                    where acreedor is not null
                    group by 1, 2
                    order by 1, 2
    loop
        select into r_pla_acreedores *
        from pla_acreedores
        where compania = ai_compania
        and trim(acreedor) = Trim(to_char(r_work.acreedor, ''000''));
        if not found then
            insert into pla_acreedores(compania, acreedor, concepto, nombre,
                status, prioridad, ahorro)
            values (ai_compania, trim(to_char(r_work.acreedor, ''000'')), ''113'', trim(r_work.nombre_acreedor),
                ''A'', 100, ''N'');
        end if;
    end loop;
    
    for r_work in select departamento from tmp_empleados
                    where departamento is not null
                    group by departamento
                    order by departamento
    loop
        select into r_pla_departamentos *
        from pla_departamentos
        where compania = ai_compania
        and trim(descripcion) = Trim(r_work.departamento);
        if not found then
            li_contador = li_contador + 1;
            insert into pla_departamentos (compania, departamento, descripcion, status)
            values (ai_compania, Trim(to_char(li_contador,''000'')), Trim(r_work.departamento), 1);
        end if;
    end loop;
       

    select into r_pla_cargos *
    from pla_cargos
    where compania = ai_compania
    order by id;
    
    select into r_pla_proyectos *
    from pla_proyectos
    where compania = ai_compania
    order by id;
    

    for r_tmp_empleados in
        select * from tmp_empleados
        order by codigo_empleado_new
    loop
        select into r_pla_departamentos *
        from pla_departamentos
        where compania = ai_compania
        and Trim(descripcion) = Trim(r_tmp_empleados.departamento);
        if not found then
            continue;
        end if;
    
        if r_tmp_empleados.cedula is null then
            r_tmp_empleados.cedula = ''9999'';
        end if;
        
        if r_tmp_empleados.sexo is null then
            r_tmp_empleados.sexo = ''M'';
        end if;
        select into r_pla_empleados * 
        from pla_empleados
        where compania = ai_compania
        and Trim(codigo_empleado) = Trim(r_tmp_empleados.codigo_empleado_new);
        if not found then
            insert into pla_empleados(compania, codigo_empleado, apellido, nombre, cargo,
                departamento, id_pla_proyectos, tipo_de_planilla, grupo, dependientes,
                dependientes_no_declarados, tipo_contrato, estado_civil, fecha_inicio,
                fecha_terminacion_contrato, fecha_terminacion_real,
                fecha_nacimiento, tipo_de_salario, forma_de_pago, tipo_calculo_ir,
                telefono_1, telefono_2, status, sexo, tipo, cedula, dv, declarante,
                ss, direccion1, direccion2, tasa_por_hora, salario_bruto, email)
            values
                (ai_compania, r_tmp_empleados.codigo_empleado_new,
                r_tmp_empleados.apellido, r_tmp_empleados.nombre, r_pla_cargos.id,
                r_pla_departamentos.id, r_pla_proyectos.id,
                ''2'', ''A'', 0, 0, ''P'', ''C'', ''2010-01-01'', null,
                null, ''1991-01-01'', ''F'', ''E'', ''R'', null, null, ''A'',
                r_tmp_empleados.sexo, ''1'', r_tmp_empleados.cedula,
                ''00'', ''N'', r_tmp_empleados.ss, null, null, r_tmp_empleados.tasa_x_hora,
                (r_tmp_empleados.tasa_x_hora*48*52/12), ''1'');
        else
        
        end if;
     
    end loop;
    
    
    for r_tmp_retenciones in select * from tmp_retenciones
                                where acreedor is not null
                                and descuento is not null
                                order by acreedor_new, codigo_empleado_new
    loop
        select into r_pla_empleados *
        from pla_empleados
        where compania = ai_compania
        and trim(codigo_empleado) = trim(r_tmp_retenciones.codigo_empleado_new);
        if not found then
            continue;
        end if;
    
        select into r_pla_retenciones *
        from pla_retenciones
        where compania = ai_compania
        and trim(codigo_empleado) = trim(r_tmp_retenciones.codigo_empleado_new)
        and trim(acreedor) = trim(r_tmp_retenciones.acreedor_new);
        if not found then
            insert into pla_retenciones (compania, codigo_empleado, acreedor, concepto,
                numero_documento, descripcion_descuento, monto_original_deuda,
                letras_a_pagar, fecha_inidescto, observacion, hacer_cheque, 
                incluir_deduc_carta_trabajo, aplica_diciembre, tipo_descuento, status)
            values (ai_compania, trim(r_tmp_retenciones.codigo_empleado_new),
                trim(r_tmp_retenciones.acreedor_new), ''113'', trim(to_char(r_tmp_retenciones.descuento, ''00000'')),
                ''DESCUENTO'', r_tmp_retenciones.saldo, 0, ''2010-01-01'',
                trim(r_tmp_retenciones.observacion), ''S'', ''S'', ''S'', ''M'', ''A'');
                
            select into r_pla_retenciones *
            from pla_retenciones
            where compania = ai_compania
            and trim(codigo_empleado) = trim(r_tmp_retenciones.codigo_empleado_new)
            and trim(acreedor) = trim(r_tmp_retenciones.acreedor_new);
            if found then
                insert into pla_retener(id_pla_retenciones, periodo, monto)
                values(r_pla_retenciones.id, 1, r_tmp_retenciones.monto);

                insert into pla_retener(id_pla_retenciones, periodo, monto)
                values(r_pla_retenciones.id, 2, r_tmp_retenciones.monto);
                
            end if;                
        end if;
    end loop;
    
    
    
    return 1;
end;
' language plpgsql;
