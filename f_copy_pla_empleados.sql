

drop function f_copy_pla_empleados(int4, int4) cascade;


create function f_copy_pla_empleados(int4, int4) returns integer as '
declare
    ai_cia_1 alias for $1;
    ai_cia_2 alias for $2;
    r_pla_cuentas_2 record;
    r_pla_cuentas_conceptos record;
    r_pla_acreedores record;
    r_pla_retenciones record;
    r_pla_retener record;
    r_pla_empleados record;
    r_pla_turnos record;
    r_work record;
    r_pla_cuentas record;
    r_pla_bancos record;
    r_pla_departamentos record;
    r_pla_cargos record;
    li_id int4;
    li_id_pla_cuentas int4;
    li_id_pla_cuentas_2 int4;
    ldc_retenido decimal;
    ldc_saldo decimal;
    lc_status char(1);
begin
/*
    for r_pla_turnos in
        select * from pla_turnos
        where compania = ai_cia_1
        order by turno
    loop
        select into r_work *
        from pla_turnos
        where compania = ai_cia_2
        and turno = r_pla_turnos.turno;
        if not found then
            insert into pla_turnos(compania, turno, hora_inicio, hora_salida,
                hora_inicio_descanso, hora_salida_descanso, tolerancia_de_entrada,
                tolerancia_de_salida, tolerancia_descanso, tipo_de_jornada)
            values(ai_cia_2, r_pla_turnos.turno, r_pla_turnos.hora_inicio, 
                r_pla_turnos.hora_salida, r_pla_turnos.hora_inicio_descanso,
                r_pla_turnos.hora_salida_descanso, r_pla_turnos.tolerancia_de_entrada,
                r_pla_turnos.tolerancia_de_salida, r_pla_turnos.tolerancia_descanso,
                r_pla_turnos.tipo_de_jornada);                
        end if;
    end loop;        


    select into r_pla_cuentas *
    from pla_cuentas
    where compania = ai_cia_2
    order by 1
    limit 1;

    for r_pla_acreedores in
        select * from pla_acreedores
        where compania = ai_cia_1
        order by acreedor
    loop
        select into r_work *
        from pla_acreedores
        where compania = ai_cia_2
        and acreedor = r_pla_acreedores.acreedor;
        if not found then
            insert into pla_acreedores(compania, acreedor, concepto, nombre,
                status, telefono, direccion, observacion, prioridad, ahorro)
            values(ai_cia_2, r_pla_acreedores.acreedor, r_pla_acreedores.concepto,
                r_pla_acreedores.nombre, r_pla_acreedores.status, r_pla_acreedores.telefono,
                r_pla_acreedores.direccion, r_pla_acreedores.observacion,
                r_pla_acreedores.prioridad, r_pla_acreedores.ahorro);           
        end if;                
    end loop;


    for r_pla_departamentos in
        select * from pla_departamentos
        where compania = ai_cia_1
        order by id
    loop
        select into r_work *
        from pla_departamentos
        where compania = ai_cia_2
        and trim(departamento) = trim(r_pla_departamentos.departamento);
        if not found then
            insert into pla_departamentos(compania, departamento, descripcion, status)
            values(ai_cia_2, r_pla_departamentos.departamento, r_pla_departamentos.departamento,
                r_pla_departamentos.status);
        end if;
    end loop;        

    for r_pla_cargos in
        select * from pla_cargos
        where compania = ai_cia_1
        order by id
    loop
        select into r_work *
        from pla_cargos
        where compania = ai_cia_2
        and trim(cargo) = trim(r_pla_cargos.cargo);
        if not found then
            insert into pla_cargos(compania, cargo, descripcion, status, monto)
            values(ai_cia_2, r_pla_cargos.cargo, r_pla_cargos.descripcion, r_pla_cargos.status,
                r_pla_cargos.monto);
        end if;
    end loop;
            

    for r_pla_bancos in
        select * from pla_bancos
        where compania = ai_cia_1
        order by id
    loop
        select into r_work *
        from pla_bancos
        where trim(nombre) = Trim(r_pla_bancos.nombre)
        and compania = ai_cia_2;
        if not found then
            insert into pla_bancos(id_pla_cuentas, compania, nombre, status, sec_cheques, 
                sec_solicitudes,  ruta_ach)
            values(r_pla_cuentas.id, ai_cia_2, r_pla_bancos.nombre, r_pla_bancos.status,
                r_pla_bancos.sec_cheques, r_pla_bancos.sec_solicitudes, r_pla_bancos.ruta_ach);
        end if;    
    end loop;
*/        


/*    
    for r_pla_empleados in 
    select * from pla_empleados
    where compania = ai_cia_1
    order by codigo_empleado
    loop
        select into r_work *
        from pla_bancos
        where id = r_pla_empleados.id_pla_bancos;

        select into r_pla_bancos *
        from pla_bancos
        where compania = ai_cia_2
        and trim(nombre) = trim(r_work.nombre);

        select into r_work *
        from pla_departamentos
        where id = r_pla_empleados.departamento;
        
        select into r_pla_departamentos *
        from pla_departamentos
        where compania = ai_cia_2
        and trim(departamento) = trim(r_work.departamento);


        select into r_work *
        from pla_cargos
        where id = r_pla_empleados.cargo;
        
        select into r_pla_cargos *
        from pla_cargos
        where compania = ai_cia_2
        and trim(cargo) = trim(r_work.cargo);
        

        select into r_work *
        from pla_empleados
        where compania = ai_cia_2
        and trim(cedula) = trim(r_pla_empleados.cedula);
        if not found then
            insert into pla_empleados(compania, codigo_empleado,
                tipo_de_planilla, grupo, dependientes, nombre, apellido,
                tipo_contrato, estado_civil, fecha_inicio, 
                fecha_nacimiento, tipo_de_salario, forma_de_pago, tipo_calculo_ir, status,
                sexo, cedula, dv, declarante, ss, direccion1, direccion2, 
                tasa_por_hora, salario_bruto, email, id_pla_bancos, cargo, departamento,
                tipo_cta_bco, cta_bco_empleado)
            values (ai_cia_2, r_pla_empleados.codigo_empleado, r_pla_empleados.tipo_de_planilla,
                r_pla_empleados.grupo, r_pla_empleados.dependientes, r_pla_empleados.nombre,
                r_pla_empleados.apellido, r_pla_empleados.tipo_contrato, r_pla_empleados.estado_civil,
                r_pla_empleados.fecha_inicio, r_pla_empleados.fecha_nacimiento,
                r_pla_empleados.tipo_de_salario, r_pla_empleados.forma_de_pago,
                r_pla_empleados.tipo_calculo_ir, r_pla_empleados.status, r_pla_empleados.sexo,
                r_pla_empleados.cedula, r_pla_empleados.dv, r_pla_empleados.declarante,
                r_pla_empleados.ss, r_pla_empleados.direccion1, r_pla_empleados.direccion2,
                r_pla_empleados.tasa_por_hora, r_pla_empleados.salario_bruto, 
                r_pla_empleados.email, r_pla_bancos.id, r_pla_cargos.id, r_pla_departamentos.id,
                r_pla_empleados.tipo_cta_bco, r_pla_empleados.cta_bco_empleado);
        else
            update pla_empleados
            set id_pla_bancos = r_pla_bancos.id,
                cargo = r_pla_cargos.id,
                departamento = r_pla_departamentos.id,
                tipo_cta_bco = r_pla_empleados.tipo_cta_bco,
                cta_bco_empleado = r_pla_empleados.cta_bco_empleado
            where compania = r_work.compania
            and codigo_empleado = r_work.codigo_empleado;
        end if;        
    end loop;


    for r_pla_retenciones in
        select * from pla_retenciones
        where compania = ai_cia_1
        order by id
    loop
        ldc_retenido = 0;
        select sum(pla_dinero.monto) into ldc_retenido
        from pla_deducciones, pla_dinero
        where pla_deducciones.id_pla_dinero = pla_dinero.id
        and pla_deducciones.id_pla_retenciones = r_pla_retenciones.id;
        if not found or ldc_retenido is null then
            ldc_retenido = 0;
        end if;
        
        ldc_saldo = r_pla_retenciones.monto_original_deuda - ldc_retenido;
        
        if ldc_saldo <= 0 and r_pla_retenciones.monto_original_deuda <> 0 then
            lc_status = ''I'';
        else
            lc_status = ''A'';            
        end if;
    
        if lc_status = ''A'' and r_pla_retenciones.status = ''I'' then
            lc_status = ''I'';
        end if;            
    
        select into r_work *
        from pla_retenciones
        where compania = ai_cia_2
        and codigo_empleado = r_pla_retenciones.codigo_empleado
        and numero_documento = r_pla_retenciones.numero_documento
        and acreedor = r_pla_retenciones.acreedor;
        if not found then
            insert into pla_retenciones(compania, codigo_empleado, acreedor, 
                concepto, numero_documento, descripcion_descuento,
                monto_original_deuda, letras_a_pagar, fecha_inidescto,
                fecha_finaldescto, observacion, hacer_cheque, incluir_deduc_carta_trabajo,
                aplica_diciembre, tipo_descuento, status)
            values(ai_cia_2, r_pla_retenciones.codigo_empleado, r_pla_retenciones.acreedor,
                r_pla_retenciones.concepto, r_pla_retenciones.numero_documento, r_pla_retenciones.descripcion_descuento,
                r_pla_retenciones.monto_original_deuda, r_pla_retenciones.letras_a_pagar, r_pla_retenciones.fecha_inidescto,
                r_pla_retenciones.fecha_finaldescto, r_pla_retenciones.observacion,
                r_pla_retenciones.hacer_cheque, r_pla_retenciones.incluir_deduc_carta_trabajo,
                r_pla_retenciones.aplica_diciembre, r_pla_retenciones.tipo_descuento, lc_status);            
    
            li_id = lastval();
    
            for r_pla_retener in
                select pla_retener.* from pla_retener
                where pla_retener.id_pla_retenciones = r_pla_retenciones.id
                order by periodo
            loop            
                insert into pla_retener(id_pla_retenciones, periodo, monto)
                values(li_id, r_pla_retener.periodo, r_pla_retener.monto);

            end loop;
        else
            update pla_retenciones
            set status = lc_status
            where id = r_work.id;            
        end if;            
    end loop;
*/            


    delete from pla_preelaboradas
    where compania = ai_cia_2;
    
    insert into pla_preelaboradas(compania, codigo_empleado, concepto, fecha, monto)
    select ai_cia_2, codigo_empleado, concepto, fecha, sum(monto)
    from v_pla_dinero_detallado
    where compania = ai_cia_1
    and exists 
    (select * from pla_empleados
    where pla_empleados.compania = ai_cia_2
    and pla_empleados.codigo_empleado = v_pla_dinero_detallado.codigo_empleado)
    group by codigo_empleado, concepto, fecha;

    insert into pla_preelaboradas(compania, codigo_empleado, concepto, fecha, monto)
    select ai_cia_2, codigo_empleado, concepto, fecha, monto
    from pla_preelaboradas
    where compania = ai_cia_1
    and exists
    (select * from pla_empleados
    where pla_empleados.compania = ai_cia_2
    and pla_empleados.codigo_empleado = pla_preelaboradas.codigo_empleado);
        
    return 1;
end;
' language plpgsql;
