
drop function f_cargar_empleados_modus() cascade;


create function f_cargar_empleados_modus() returns integer as '
declare
    ai_compania integer;
    r_pla_preelaboradas record;
    r_pla_empleados record;
    r_tmp_acumulados_decal record;
    r_tmp_empleados_modus record;
    r_pla_retenciones record;
    r_pla_retener record;
    r_pla_acreedores record;
    r_pla_cargos record;
    r_tmp_descuentos_seceyco record;
    r_tmp_work record;
    r_pla_departamentos record;
    ld_fecha date;
    lc_work char(20);
    lc_codigo_empleado char(20);
    lc_ss char(20);
    lc_cargo char(3);
    lc_d_cargo varchar(100);
    lc_d_departamento varchar(100);
    lc_estatus char(1);
    ld_fecha_inicio date;
    ld_fecha_nacimiento date;
    li_anio integer;
    li_mes integer;
    li_dia integer;
    li_id_pla_cargos int4;
    li_work integer;
begin
    ai_compania = 1185;
    
    li_work =   0;
    for r_tmp_work in select trim(cargo) as cargo
                        from tmp_empleados_modus
                        group by 1
                        order by 1
    loop
        li_work =   li_work + 1;
        lc_cargo    =   trim(to_char(li_work, ''9999''));
        
        insert into pla_cargos (compania, cargo, descripcion, status, monto)
        values(ai_compania, lc_cargo, trim(r_tmp_work.cargo), 1, 0);
    end loop;
    
    li_work = 0;
    for r_tmp_work in select trim(departamento) as cargo
                        from tmp_empleados_modus
                        group by 1
                        order by 1
    loop
        li_work =   li_work + 1;
        lc_cargo    =   trim(to_char(li_work, ''9999''));
        
        insert into pla_departamentos (compania, departamento, descripcion, status)
        values(ai_compania, lc_cargo, trim(r_tmp_work.cargo), 1);
    end loop;
    


    for r_tmp_empleados_modus in select * from tmp_empleados_modus
                                    where mail is not null
                                    order by codigo_empleado
    loop
    
    
--        lc_descripcion      =   trim(r_tmp_empleados_modus.cargo);
        lc_codigo_empleado  =   Trim(To_char(r_tmp_empleados_modus.codigo_empleado, ''999999999''));


        select into r_pla_cargos *
        from pla_cargos
        where compania = ai_compania
        and trim(descripcion) = trim(r_tmp_empleados_modus.cargo);
        if not found then
            Raise Exception ''Cargo no Existe %'', lc_cargo;
        end if;
        
        select into r_pla_departamentos *
        from pla_departamentos
        where compania = ai_compania
        and trim(descripcion) = trim(r_tmp_empleados_modus.departamento);
        if not found then
            Raise Exception ''Cargo no Existe %'', lc_cargo;
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
            status, sexo, tipo, cedula, dv, declarante, ss, direccion1, direccion2,
            tasa_por_hora, salario_bruto, email, cta_bco_empleado, telefono_1, telefono_2)
            values(ai_compania, lc_codigo_empleado,
            ''APELLIDO'', trim(r_tmp_empleados_modus.nombre),
            r_pla_cargos.id, r_pla_departamentos.id, 1343, ''2'', ''A'', 0, 0, 
            ''P'', ''C'', ''2013-01-01'', ''2013-01-01'', 
            ''F'',''T'', ''A'', ''A'', ''M'', ''1'', 
            Trim(r_tmp_empleados_modus.cedula), ''00'', ''N'', Trim(r_tmp_empleados_modus.cedula), 
            Substring(trim(r_tmp_empleados_modus.direccion) from 1 for 40),
            Substring(trim(r_tmp_empleados_modus.direccion) from 41 for 40) , 
            r_tmp_empleados_modus.salario_mensual*12/52/44, 
            r_tmp_empleados_modus.salario_mensual/2, trim(r_tmp_empleados_modus.mail),
            trim(r_tmp_empleados_modus.cta_bco), trim(r_tmp_empleados_modus.telefono1), 
            trim(r_tmp_empleados_modus.telefono2));
        end if;
        
    end loop;
    
    return 1;
end;
' language plpgsql;

