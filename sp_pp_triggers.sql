set search_path to 'planilla';

rollback work;

drop function f_pla_marcaciones_before_insert() cascade;
drop function f_pla_marcaciones_before_update() cascade;
drop function f_pla_marcaciones_before_delete() cascade;
drop function f_pla_companias_after_insert() cascade;
drop function f_pla_companias_before_insert() cascade;
drop function f_pla_empleados_after_insert() cascade;
drop function f_pla_empleados_before_insert() cascade;
drop function f_pla_empleados_before_update() cascade;
drop function f_pla_vacaciones_before_insert() cascade;
drop function f_pla_vacaciones_after_insert() cascade;
drop function f_pla_vacaciones_after_update() cascade;
drop function f_pla_vacaciones_after_delete() cascade;
drop function f_pla_permisos_before_insert() cascade;
drop function f_pla_permisos_before_update() cascade;
drop function f_pla_permisos_before_delete() cascade;
drop function f_pla_tarjeta_tiempo_before_insert() cascade;
drop function f_pla_certificados_medico_before_insert() cascade;
drop function f_pla_certificados_medico_before_update() cascade;
drop function f_pla_certificados_medico_before_delete() cascade;
drop function f_pla_periodos_before_insert() cascade;
drop function f_pla_periodos_before_update() cascade;
drop function f_pla_xiii_before_insert() cascade;
drop function f_pla_xiii_before_update() cascade;
drop function f_pla_xiii_before_delete() cascade;
drop function f_pla_xiii_after_insert() cascade;
drop function f_pla_liquidacion_after_insert() cascade;
drop function f_pla_liquidacion_after_update() cascade;
drop function f_pla_auxiliares_before_update() cascade;
drop function f_pla_dinero_before_insert() cascade;
drop function f_pla_dinero_before_delete() cascade;
drop function f_pla_dinero_before_update() cascade;
drop function f_pla_empleados_after_update() cascade;
drop function f_pla_acreedores_after_update() cascade;
drop function f_pla_acreedores_after_insert() cascade;
drop function f_pla_departamentos_after_insert() cascade;
drop function f_pla_desglose_regulares_before_insert() cascade;
drop function f_pla_turnos_before_insert() cascade;
drop function f_pla_otros_ingresos_fijos_before_insert() cascade;
drop function f_pla_riesgos_profesionales_before_insert() cascade;
drop function f_pla_cheques_1_before_update() cascade;
drop function f_pla_cheques_1_before_delete() cascade;
drop function f_pla_cheques_1_after_update() cascade;
drop function f_pla_cargos_before_insert() cascade;
drop function f_pla_horas_before_delete() cascade;
drop function f_pla_horas_before_update() cascade;
drop function f_pla_horas_before_insert() cascade;
drop function f_pla_marcaciones_after_delete() cascade;
drop function f_pla_cuentas_x_proyecto_before_insert() cascade;
drop function f_pla_cuentas_x_departamento_before_insert() cascade;
drop function f_pla_cuentas_x_concepto_before_insert() cascade;
drop function f_pla_proyectos_after_insert() cascade;
drop function f_pla_vacaciones_before_delete() cascade;
drop function f_pla_vacaciones_before_update() cascade;
drop function f_pla_liquidacion_before_insert() cascade;
drop function f_pla_liquidacion_before_update() cascade;
drop function f_pla_liquidacion_before_delete() cascade;
drop function f_pla_liquidacion_after_delete() cascade;
drop function f_pla_marcaciones_after_update() cascade;
drop function f_pla_reloj_01_before_insert() cascade;
drop function f_pla_turnos_rotativos_before_insert() cascade;
drop function f_pla_eventos_before_insert() cascade;
drop function f_pla_eventos_before_update() cascade;
drop function f_pla_reclamos_before_insert() cascade;
drop function f_pla_reclamos_before_update() cascade;
drop function f_pla_reclamos_before_delete() cascade;
drop function f_pla_reclamos_after_insert() cascade;
drop function f_pla_reclamos_after_update() cascade;
drop function f_pla_deducciones_before_insert() cascade;
drop function f_pla_acreedores_before_insert() cascade;
drop function f_pla_acreedores_before_update() cascade;
drop function f_pla_marcaciones_after_insert() cascade;
drop function f_pla_dinero_after_delete() cascade;
drop function f_pla_dinero_after_insert() cascade;
drop function f_pla_dinero_after_update() cascade;
drop function f_pla_preelaboradas_before_insert() cascade;
drop function f_pla_horarios_suntracs_before_insert() cascade;
drop function f_pla_horarios_suntracs_after_insert() cascade;
drop function f_pla_periodos_after_update() cascade;
drop function f_pla_horas_after_update() cascade;
drop function f_pla_horas_after_delete() cascade;
drop function f_pla_horas_after_insert() cascade;
drop function f_pla_horarios_after_update() cascade;
drop function f_pla_horarios_after_delete() cascade;
drop function f_pla_horarios_after_insert() cascade;
drop function f_pla_turnos_x_dia_after_insert() cascade;
drop function f_pla_marcaciones_movicell_after_insert() cascade;


create function f_pla_marcaciones_movicell_after_insert() returns trigger as '
declare
    r_pla_marcaciones record;
    r_pla_marcaciones_movicell record;
    lts_entrada timestamp;
    lts_salida timestamp;
    lts_entrada_descanso timestamp;
    lts_salida_descanso timestamp;
    lt_new_dato text;
    lt_old_dato text;
    i int4;
    lc_status char(1);
begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), new.id, trim(lt_old_dato), trim(lt_new_dato), null);

/*
        lts_entrada             =   f_timestamp(f_to_date(r_pla_marcaciones.entrada), r_pla_turnos.hora_inicio);
        lts_salida              =   f_timestamp(f_to_date(r_pla_marcaciones.salida), r_pla_turnos.hora_salida);
        lts_entrada_descanso    =   f_timestamp(f_to_date(r_pla_marcaciones.entrada_descanso), r_pla_turnos.hora_inicio_descanso);
        lts_salida_descanso     =   f_timestamp(f_to_date(r_pla_marcaciones.salida_descanso), r_pla_turnos.hora_salida_descanso);
*/

        
    if new.entrada is null or new.salida is null then
        return new;
    end if;
       

    select into r_pla_marcaciones *
    from pla_marcaciones, pla_tarjeta_tiempo, pla_periodos
    where pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
    and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
    and pla_periodos.status = ''A''
    and pla_tarjeta_tiempo.codigo_empleado = new.codigo_empleado
    and pla_tarjeta_tiempo.compania = new.compania
    and f_to_date(pla_marcaciones.entrada) = new.fecha;
    if found then
        lc_status = r_pla_marcaciones.status;
        
        select into r_pla_marcaciones_movicell *
        from pla_marcaciones_movicell
        where compania = new.compania
        and codigo_empleado = new.codigo_empleado
        and fecha = new.fecha
        and id <> new.id;
        if found then
            lts_entrada_descanso            =   f_timestamp(f_to_date(r_pla_marcaciones.entrada), r_pla_marcaciones_movicell.salida);
            lts_salida_descanso             =   f_timestamp(f_to_date(r_pla_marcaciones.entrada), new.entrada);
            lts_salida                      =   f_timestamp(f_to_date(r_pla_marcaciones.salida), new.salida);

            if lc_status = ''I'' then
                lc_status = ''R'';
            end if;
            
            update pla_marcaciones
            set entrada_descanso = lts_entrada_descanso, salida_descanso = lts_salida_descanso, salida = lts_salida, status = lc_status
            where id = r_pla_marcaciones.id;
        else
            lts_entrada             =   f_timestamp(f_to_date(r_pla_marcaciones.entrada), new.entrada);
            lts_salida              =   f_timestamp(f_to_date(r_pla_marcaciones.entrada), new.salida);
        
            if lc_status = ''I'' then
                lc_status = ''R'';
            end if;
        
            update pla_marcaciones
            set entrada = lts_entrada, salida = lts_salida, status = lc_status
            where id = r_pla_marcaciones.id;
    
        end if;
    end if;

    return new;
end;
' language plpgsql;


create function f_pla_turnos_x_dia_after_insert() returns trigger as '
declare
    r_pla_marcaciones record;
    r_pla_turnos record;
    lts_entrada timestamp;
    lts_salida timestamp;
    lts_entrada_descanso timestamp;
    lts_salida_descanso timestamp;
    lt_new_dato text;
    lt_old_dato text;
    i int4;
begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), new.id, trim(lt_old_dato), trim(lt_new_dato), null);

    select into r_pla_turnos *
    from pla_turnos
    where compania = new.compania
    and turno = new.turno;
    if not found then
        Raise Exception ''Turno % no existe'', new.turno;
    end if;

    if new.entrada is not null then
        r_pla_turnos.hora_inicio = new.entrada;
    end if;
    
    if new.salida is not null then
        r_pla_turnos.hora_salida = new.salida;
    end if;

    select into r_pla_marcaciones *
    from pla_marcaciones, pla_tarjeta_tiempo, pla_periodos
    where pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
    and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
    and pla_periodos.status = ''A''
    and pla_tarjeta_tiempo.codigo_empleado = new.codigo_empleado
    and pla_tarjeta_tiempo.compania = new.compania
    and f_to_date(pla_marcaciones.entrada) = new.fecha;
    if found then
        lts_entrada             =   f_timestamp(f_to_date(r_pla_marcaciones.entrada), r_pla_turnos.hora_inicio);
        lts_salida              =   f_timestamp(f_to_date(r_pla_marcaciones.salida), r_pla_turnos.hora_salida);
        lts_entrada_descanso    =   f_timestamp(f_to_date(r_pla_marcaciones.entrada_descanso), r_pla_turnos.hora_inicio_descanso);
        lts_salida_descanso     =   f_timestamp(f_to_date(r_pla_marcaciones.salida_descanso), r_pla_turnos.hora_salida_descanso);
        
        if r_pla_turnos.hora_salida < r_pla_turnos.hora_inicio then
            lts_salida          =   f_timestamp((f_to_date(r_pla_marcaciones.entrada)+1), r_pla_turnos.hora_salida);
        end if;
        
        if new.compania = 1075 and new.turno = 3 then
            lts_salida = lts_salida + Interval ''90 minute'';
        end if;
        
        if r_pla_marcaciones.status = ''I'' and new.status = ''R'' then
            new.status = ''I'';
        end if;
        
        update pla_marcaciones
        set turno = new.turno, status = new.status, autorizado = new.autorizado,
            entrada = lts_entrada, salida = lts_salida, entrada_descanso = lts_entrada_descanso, salida_descanso = lts_salida_descanso,
            id_pla_proyectos = new.id_pla_proyectos
        where id = r_pla_marcaciones.id;
    end if;

    return new;
end;
' language plpgsql;





create function f_pla_horarios_after_delete() returns trigger as '
declare
    r_pla_tarjeta_tiempo record;
    r_pla_periodos record;
    r_pla_certificados_medico record;
    ld_fecha date;
    lt_new_dato text;
    lt_old_dato text;
    i int4;

begin
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
    
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), old.id, trim(lt_old_dato), 
                        trim(lt_new_dato), null, old.compania, old.usuario);
    
    return new;
end;
' language plpgsql;


create function f_pla_horarios_after_insert() returns trigger as '
declare
    r_pla_tarjeta_tiempo record;
    r_pla_periodos record;
    r_pla_certificados_medico record;
    ld_fecha date;
    lt_new_dato text;
    lt_old_dato text;
    i int4;

begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
    
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), new.id, trim(lt_old_dato), 
                        trim(lt_new_dato), null, new.compania, new.usuario);
    
    return new;
end;
' language plpgsql;



create function f_pla_horarios_after_update() returns trigger as '
declare
    r_pla_tarjeta_tiempo record;
    r_pla_periodos record;
    r_pla_certificados_medico record;
    ld_fecha date;
    lt_new_dato text;
    lt_old_dato text;
    li_minutos int4;
    i int4;

begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);

    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), old.id, trim(lt_old_dato), 
                        trim(lt_new_dato), null, new.compania, new.usuario);
    
    return new;
end;
' language plpgsql;





create function f_pla_horas_after_delete() returns trigger as '
declare
    r_pla_tarjeta_tiempo record;
    r_pla_periodos record;
    r_pla_certificados_medico record;
    ld_fecha date;
    lt_new_dato text;
    lt_old_dato text;
    i int4;

begin
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
    
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), old.id, trim(lt_old_dato), 
                        trim(lt_new_dato), null, old.compania, old.usuario);
    
    return new;
end;
' language plpgsql;


create function f_pla_horas_after_insert() returns trigger as '
declare
    r_pla_tarjeta_tiempo record;
    r_pla_periodos record;
    r_pla_certificados_medico record;
    ld_fecha date;
    lt_new_dato text;
    lt_old_dato text;
    i int4;

begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
    
    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), new.id, trim(lt_old_dato), 
                        trim(lt_new_dato), null, new.compania, new.usuario);
    
    return new;
end;
' language plpgsql;



create function f_pla_horas_after_update() returns trigger as '
declare
    r_pla_tarjeta_tiempo record;
    r_pla_periodos record;
    r_pla_certificados_medico record;
    ld_fecha date;
    lt_new_dato text;
    lt_old_dato text;
    li_minutos int4;
    i int4;

begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);

    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), old.id, trim(lt_old_dato), 
                        trim(lt_new_dato), null, new.compania, new.usuario);
    
    return new;
end;
' language plpgsql;




create function f_pla_periodos_after_update() returns trigger as '
declare
    r_pla_tarjeta_tiempo record;
    r_pla_periodos record;
    r_pla_certificados_medico record;
    ld_fecha date;
    lt_new_dato text;
    lt_old_dato text;
    li_minutos int4;
    i int4;

begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);

    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), old.id, trim(lt_old_dato), 
                        trim(lt_new_dato), null, new.compania, new.usuario);
    
    return new;
end;
' language plpgsql;



create function f_pla_horarios_suntracs_before_insert() returns trigger as '
declare
    r_pla_conceptos record;
    r_pla_empleados record;
    r_pla_companias record;
    r_pla_turnos record;
begin
    new.id_pla_proyectos = 2886;

    if new.status is null then
        new.status = ''R'';
    end if;
                
    if new.entrada1 is null or new.salida1 is null then
        select into r_pla_turnos *
        from pla_turnos
        where compania = new.compania
        and turno = new.turno;
        if found then
            if new.entrada1 is null then
                new.entrada1    =   r_pla_turnos.hora_inicio;
            end if;
            
            if new.salida1 is null then                
                new.salida1     =   r_pla_turnos.hora_salida;
            end if;                
        end if;
    end if;

/*
    if new.numero_de_planilla is null then
        new.numero_de_planilla = 7;
    end if;
*/    
     
    if new.autorizado is null then
        new.autorizado = ''S'';
    end if;
    
    return new;
end;
' language plpgsql;


create function f_pla_horarios_suntracs_after_insert() returns trigger as '
declare
    r_pla_conceptos record;
    r_pla_empleados record;
    r_pla_companias record;
    i integer;
begin

    if new.numero_de_planilla is null then
        return new;
    end if;
            
    i   =   f_insertar_pla_marcaciones_apra(new.compania, new.codigo_empleado, 
                new.numero_de_planilla,
                new.turno, new.id_pla_proyectos, new.fecha, new.entrada1, new.salida1, 
                new.implemento, new.entrada2, new.salida2,
                new.entrada3, new.salida3, new.status);
    
    
    return new;
end;
' language plpgsql;


create function f_pla_liquidacion_after_delete() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;

begin
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), old.id, trim(lt_old_dato), trim(lt_new_dato), null);
    
    return old;
end;
' language plpgsql;



create function f_pla_preelaboradas_before_insert() returns trigger as '
declare
    r_pla_conceptos record;
    r_pla_empleados record;
    r_pla_companias record;
begin
    if new.concepto is null then
        Raise Exception ''Concepto de Pago es Obligatorio'';
    end if;

    select into r_pla_conceptos *
    from pla_conceptos
    where concepto = new.concepto;
    if not found then
        Raise Exception ''Concepto de Pago % no Existe'', new.concepto;
    end if;

/*    
    if new.monto <= 0 then
        Raise Exception ''Monto debe ser mayor a cero'';
    end if;
*/    
    
    select into r_pla_empleados *
    from pla_empleados
    where compania = new.compania
    and codigo_empleado = new.codigo_empleado;
    if not found then
        Raise Exception ''Codigo de Empleado % no Existe'', new.codigo_empleado;
    end if;
    
    select into r_pla_companias *
    from pla_companias
    where compania = new.compania;
    if not found then
        Raise Exception ''Compania no existe %'', new.compania;
    end if;
    
    if new.fecha > r_pla_companias.fecha_de_apertura then
        if r_pla_companias.compania <> 1185 and r_pla_companias.compania <> 1290 
            and r_pla_companias.compania <> 1321 then
            Raise Exception ''Fecha % no puede ser posterior a la fecha de apertura % de la compania '',new.fecha, r_pla_companias.fecha_de_apertura;
        end if;            
    end if;
        
    return new;
end;
' language plpgsql;




/*
create function f_pla_periodos_after_insert() returns trigger as '
declare
    r_pla_periodos record;
    li_count integer;
begin
    if new.status = ''C'' then
        return new;
    end if;
    
    li_count = 0;
    select into li_count count(*) from pla_periodos
    where compania = new.compania
    and numero_planilla = new.numero_planilla
    and tipo_de_planilla = new.tipo_de_planilla
    and status = ''A'';
    
    if li_count is null then
        li_count = 0;
    end if;
    
    if li_count > 1 then
        raise exception ''No pueden estar abiertas dos planillas con el mismo numero % tipo %'',new.numero_planilla,new.tipo_de_planilla;
    end if;
    
    if new.desde > new.hasta then
        Raise Exception ''Hasta % debe ser posterior a Desde %'',new.hasta, new.desde;
    end if;    

    if new.desde > new.dia_d_pago then
        Raise Exception ''Dia de Pago % debe ser posterior a Desde %'',new.dia_d_pago, new.desde;
    end if;    
    
    
    return new;
end;
' language plpgsql;
*/


create function f_pla_dinero_after_delete() returns trigger as '
declare
    r_pla_conceptos_acumulan record;
    r_pla_periodos record;
    r_pla_cuentas_conceptos record;
    r_pla_conceptos record;
    r_pla_empleados record;
    ldc_porcentaje_rp decimal;
    ldc_monto decimal;
    ldc_salario_neto decimal;
    lvc_accion varchar(100);
    lt_new_dato text;
    lt_old_dato text;
    i integer;
begin
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), old.id, trim(lt_old_dato), trim(lt_new_dato), null);

    return old;
end;
' language plpgsql;



create function f_pla_dinero_after_update() returns trigger as '
declare
    r_pla_conceptos_acumulan record;
    r_pla_periodos record;
    r_pla_cuentas_conceptos record;
    r_pla_conceptos record;
    r_pla_empleados record;
    ldc_porcentaje_rp decimal;
    ldc_monto decimal;
    ldc_salario_neto decimal;
    lvc_accion varchar(100);
    lt_new_dato text;
    lt_old_dato text;
    i integer;
begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), old.id, trim(lt_old_dato), trim(lt_new_dato), null);
    
    i           =   f_pla_dinero_pla_reservas_pp(new.id);

    return new;
end;
' language plpgsql;



create function f_pla_dinero_after_insert() returns trigger as '
declare
    r_pla_conceptos_acumulan record;
    r_pla_periodos record;
    r_pla_cuentas_conceptos record;
    r_pla_conceptos record;
    r_pla_empleados record;
    ldc_porcentaje_rp decimal;
    ldc_monto decimal;
    ldc_salario_neto decimal;
    lvc_accion varchar(100);
    lt_new_dato text;
    lt_old_dato text;
    i integer;
begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), new.id, trim(lt_old_dato), trim(lt_new_dato), null);

    i           =   f_pla_dinero_pla_reservas_pp(new.id);

    return new;
end;
' language plpgsql;



create function f_pla_marcaciones_after_insert() returns trigger as '
declare
    r_pla_tarjeta_tiempo record;
    r_pla_periodos record;
    r_pla_certificados_medico record;
    ld_fecha date;
    lt_new_dato text;
    lt_old_dato text;
    i int4;

begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), new.id, trim(lt_old_dato), trim(lt_new_dato), null, new.compania, new.usuario);

    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = new.id_tarjeta_de_tiempo;
    if not found then
        raise exception ''Registro % no existe en pla_tarjeta_tiempo'',old.id_tarjeta_de_tiempo;
    end if;
    
    select into r_pla_periodos *
    from pla_periodos
    where id = r_pla_tarjeta_tiempo.id_periodos;
/*
    if r_pla_periodos.compania = 1365 or r_pla_periodos.compania = 1353 or r_pla_periodos.compania = 1316 
         or r_pla_periodos.compania = 754 then    
*/         
         
    if f_pla_parametros(r_pla_tarjeta_tiempo.compania, ''plantilla_web'', ''N'', ''GET'') = ''S'' then
        i = f_pla_marcaciones_horarios(new.id);
    end if;        


    if new.status <> ''C'' then
        return new;
    end if;
    
    ld_fecha = new.entrada;
    
    select into r_pla_certificados_medico *
    from pla_certificados_medico
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
    and fecha = ld_fecha;
    if not found then
        insert into pla_certificados_medico(compania, codigo_empleado, fecha, pagado,
            year, numero_planilla, minutos) 
        values(r_pla_tarjeta_tiempo.compania, r_pla_tarjeta_tiempo.codigo_empleado,
            ld_fecha, ''N'', r_pla_periodos.year, r_pla_periodos.numero_planilla, 480);
    end if;    


    
    return new;
end;
' language plpgsql;



create function f_pla_acreedores_before_update() returns trigger as '
declare
    r_pla_conceptos record;
begin
    if new.concepto is null then
        Raise Exception ''Concepto de Pago es Obligatorio'';
    end if;
    
    select into r_pla_conceptos *
    from pla_conceptos
    where concepto = new.concepto;
    if not found then
        Raise Exception ''Concepto de Pago % no Existe'', new.concepto;
    end if;
    
    if trim(new.concepto) <> ''123''
        and trim(new.concepto) <> ''124''
        and trim(new.concepto) <> ''126''
        and trim(new.concepto) <> ''113''
        and trim(new.concepto) <> ''114''
        and trim(new.concepto) <> ''131''
        and trim(new.concepto) <> ''132''
        and trim(new.concepto) <> ''133''
        and trim(new.concepto) <> ''116''
        and trim(new.concepto) <> ''201''
        and trim(new.concepto) <> ''202''
        and trim(new.concepto) <> ''203'' then
        Raise Exception ''Concepto de Pago % no es permitido...Verifique'', new.concepto;        
    end if;
        
    return new;
end;
' language plpgsql;



create function f_pla_acreedores_before_insert() returns trigger as '
declare
    r_pla_conceptos record;
begin
    if new.concepto is null then
        Raise Exception ''Concepto de Pago es Obligatorio'';
    end if;
    
    select into r_pla_conceptos *
    from pla_conceptos
    where concepto = new.concepto;
    if not found then
        Raise Exception ''Concepto de Pago % no Existe'', new.concepto;
    end if;
    
    if trim(new.concepto) <> ''123''
        and trim(new.concepto) <> ''124''
        and trim(new.concepto) <> ''126''
        and trim(new.concepto) <> ''113''
        and trim(new.concepto) <> ''114''
        and trim(new.concepto) <> ''131''
        and trim(new.concepto) <> ''132''
        and trim(new.concepto) <> ''116''
        and trim(new.concepto) <> ''133''
        and trim(new.concepto) <> ''128''
        and trim(new.concepto) <> ''201''
        and trim(new.concepto) <> ''202''
        and trim(new.concepto) <> ''203'' then
        Raise Exception ''Concepto de Pago % no es permitido...Verifique'', new.concepto;        
    end if;
        
    return new;
end;
' language plpgsql;


create function f_pla_deducciones_before_insert() returns trigger as '
declare
    i integer;
    r_pla_deducciones record;
    r_pla_dinero record;
begin
    
    select into r_pla_dinero *
    from pla_dinero
    where id = new.id_pla_dinero;
    
    select into r_pla_deducciones *
    from pla_deducciones
    where id_pla_dinero = new.id_pla_dinero;
    if found then
        Raise Exception ''Empleado % No se puede hacer el mismo descuento dos veces...Verifique'', r_pla_dinero.codigo_empleado;
    end if;
    
    return new;
end;
' language plpgsql;




create function f_pla_reclamos_before_insert() returns trigger as '
declare
    i integer;
    r_pla_periodos record;
    r_pla_empleados record;
    r_pla_tipos_de_horas record;
    r_pla_proyectos record;
begin
    select into r_pla_tipos_de_horas *
    from pla_tipos_de_horas
    where tipo_de_hora = new.tipo_de_hora;
    if not found then
        raise exception ''Tipo de Horas % no existe'',new.tipo_de_hora;
    end if;
    
    select into r_pla_empleados *
    from pla_empleados
    where compania = new.compania
    and codigo_empleado = new.codigo_empleado;
    if not found then
        raise exception ''Codigo de Empleado % no Existe'',new.codigo_empleado;
    end if;
    
    new.tipo_de_planilla        =   r_pla_empleados.tipo_de_planilla;
    new.tasa_por_hora           =   r_pla_empleados.tasa_por_hora;
    new.id_pla_proyectos        =   r_pla_empleados.id_pla_proyectos;
    new.id_pla_departamentos    =   r_pla_empleados.departamento;
    
    if new.id_pla_proyectos is null then
        for r_pla_proyectos in
            select * from pla_proyectos
            where compania = new.compania
            order by id
        loop
            new.id_pla_proyectos    =   r_pla_proyectos.id;
            exit;
        end loop;
    end if;
    
    select into r_pla_periodos *
    from pla_periodos
    where compania = new.compania
    and year = new.year
    and numero_planilla = new.numero_planilla
    and tipo_de_planilla = new.tipo_de_planilla;
    if not found then
        raise exception ''Numero de Planilla % no existe'',new.numero_planilla;
    end if;

    if r_pla_periodos.status = ''C'' then
        Raise Exception ''Numero de Planilla % esta cerrado'',new.numero_planilla;
    end if;
    
    return new;
end;
' language plpgsql;


create function f_pla_reclamos_before_update() returns trigger as '
declare
    i integer;
    r_pla_periodos record;
    r_pla_empleados record;
    r_pla_tipos_de_horas record;
begin
    select into r_pla_empleados *
    from pla_empleados
    where compania = old.compania
    and codigo_empleado = old.codigo_empleado;
    if not found then
        raise exception ''Codigo de Empleado % no Existe'', old.codigo_empleado;
    end if;
    
    select into r_pla_periodos *
    from pla_periodos
    where compania = old.compania
    and year = old.year
    and numero_planilla = old.numero_planilla
    and tipo_de_planilla = old.tipo_de_planilla;

    if r_pla_periodos.status = ''C'' then
        Raise Exception ''Numero de Planilla % esta cerrado'', old.numero_planilla;
    end if;
    

    select into r_pla_tipos_de_horas *
    from pla_tipos_de_horas
    where tipo_de_hora = new.tipo_de_hora;
    if not found then
        raise exception ''Tipo de Horas % no existe'',new.tipo_de_hora;
    end if;
    
    select into r_pla_empleados *
    from pla_empleados
    where compania = new.compania
    and codigo_empleado = new.codigo_empleado;
    if not found then
        raise exception ''Codigo de Empleado % no Existe'',new.codigo_empleado;
    end if;
    
    new.tipo_de_planilla        =   r_pla_empleados.tipo_de_planilla;
    new.tasa_por_hora           =   r_pla_empleados.tasa_por_hora;
    new.id_pla_proyectos        =   r_pla_empleados.id_pla_proyectos;
    new.id_pla_departamentos    =   r_pla_empleados.departamento;
    
    select into r_pla_periodos *
    from pla_periodos
    where compania = new.compania
    and year = new.year
    and numero_planilla = new.numero_planilla
    and tipo_de_planilla = new.tipo_de_planilla;
    if not found then
        raise exception ''Numero de Planilla % no existe'',new.numero_planilla;
    end if;

    if r_pla_periodos.status = ''C'' then
        Raise Exception ''Numero de Planilla % esta cerrado'',new.numero_planilla;
    end if;
    
    return new;
end;
' language plpgsql;


create function f_pla_reclamos_before_delete() returns trigger as '
declare
    i integer;
    r_pla_periodos record;
    r_pla_empleados record;
    r_pla_tipos_de_horas record;
begin
    select into r_pla_empleados *
    from pla_empleados
    where compania = old.compania
    and codigo_empleado = old.codigo_empleado;
    if not found then
        raise exception ''Codigo de Empleado % no Existe'', old.codigo_empleado;
    end if;
    
    select into r_pla_periodos *
    from pla_periodos
    where compania = old.compania
    and year = old.year
    and numero_planilla = old.numero_planilla
    and tipo_de_planilla = old.tipo_de_planilla;

    if r_pla_periodos.status = ''C'' then
        Raise Exception ''Numero de Planilla % esta cerrado'', old.numero_planilla;
    end if;
    
    return old;
end;
' language plpgsql;


create function f_pla_reclamos_after_insert() returns trigger as '
declare
    i integer;
    r_pla_periodos record;
    r_pla_empleados record;
    r_pla_tipos_de_horas record;
    lt_new_dato text;
    lt_old_dato text;

begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), new.id, trim(lt_old_dato), trim(lt_new_dato), null);

    select into r_pla_empleados *
    from pla_empleados
    where compania = new.compania
    and codigo_empleado = new.codigo_empleado;
    if not found then
        raise exception ''Codigo de Empleado % no Existe'',new.codigo_empleado;
    end if;
    
    new.tipo_de_planilla = r_pla_empleados.tipo_de_planilla;
    
    select into r_pla_periodos *
    from pla_periodos
    where compania = new.compania
    and year = new.year
    and numero_planilla = new.numero_planilla
    and tipo_de_planilla = new.tipo_de_planilla;
    if not found then
        raise exception ''Numero de Planilla % no existe'',new.numero_planilla;
    end if;

    if r_pla_periodos.status = ''C'' then
        Raise Exception ''Numero de Planilla % esta cerrado'',new.numero_planilla;
    end if;

    i   =   f_pla_reclamos_pla_dinero(new.compania, new.codigo_empleado, new.tipo_de_planilla, new.year, new.numero_planilla);
    i   =   f_pla_seguro_social(new.compania, new.codigo_empleado, r_pla_periodos.id, ''5'');
    i   =   f_pla_seguro_educativo(new.compania, new.codigo_empleado, r_pla_periodos.id, ''5'');
    return new;
end;
' language plpgsql;


create function f_pla_reclamos_after_update() returns trigger as '
declare
    i integer;
    r_pla_periodos record;
    r_pla_empleados record;
    r_pla_tipos_de_horas record;
    lt_new_dato text;
    lt_old_dato text;

begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), old.id, trim(lt_old_dato), trim(lt_new_dato), null);

    select into r_pla_periodos *
    from pla_periodos
    where compania = old.compania
    and year = old.year
    and numero_planilla = old.numero_planilla
    and tipo_de_planilla = old.tipo_de_planilla;
    if not found then
        raise exception ''Numero de Planilla % no existe'',new.numero_planilla;
    end if;

    if r_pla_periodos.status = ''C'' then
        Raise Exception ''Numero de Planilla % esta cerrado no se puede modificar'',new.numero_planilla;
    end if;


    select into r_pla_empleados *
    from pla_empleados
    where compania = new.compania
    and codigo_empleado = new.codigo_empleado;
    if not found then
        raise exception ''Codigo de Empleado % no Existe'',new.codigo_empleado;
    end if;
    
    new.tipo_de_planilla = r_pla_empleados.tipo_de_planilla;
    
    select into r_pla_periodos *
    from pla_periodos
    where compania = new.compania
    and year = new.year
    and numero_planilla = new.numero_planilla
    and tipo_de_planilla = new.tipo_de_planilla;
    if not found then
        raise exception ''Numero de Planilla % no existe'',new.numero_planilla;
    end if;

    if r_pla_periodos.status = ''C'' then
        Raise Exception ''Numero de Planilla % esta cerrado'',new.numero_planilla;
    end if;

    i   =   f_pla_reclamos_pla_dinero(new.compania, new.codigo_empleado, new.tipo_de_planilla, new.year, new.numero_planilla);
    i   =   f_pla_seguro_social(new.compania, new.codigo_empleado, r_pla_periodos.id, ''5'');
    i   =   f_pla_seguro_educativo(new.compania, new.codigo_empleado, r_pla_periodos.id, ''5'');
    return new;
end;
' language plpgsql;



create function f_pla_eventos_before_update() returns trigger as '
declare
    r_pla_tarjeta_tiempo record;
    r_pla_periodos record;
    r_pla_certificados_medico record;
    r_pla_eventos record;
    r_pla_empleados record;
    ld_fecha date;
    li_work int4;
begin
    if trim(new.implemento) = ''25'' then
        return new;
    end if;        


    select into r_pla_eventos *
    from pla_eventos
    where compania = new.compania
    and codigo_empleado = new.codigo_empleado
    and new.desde > desde
    and new.desde < hasta
    and id <> new.id;
    if found then
        Raise Exception ''En esta fecha hora % % ya se cargaron implementos % %'', new.desde, new.hasta, new.codigo_empleado, new.compania;
    end if;
    
    return new;
end;
' language plpgsql;



create function f_pla_eventos_before_insert() returns trigger as '
declare
    r_pla_tarjeta_tiempo record;
    r_pla_periodos record;
    r_pla_certificados_medico record;
    r_pla_eventos record;
    r_pla_empleados record;
    ld_fecha date;
    li_work int4;
begin

    if trim(new.implemento) = ''25'' then
        return new;
    end if;        

    if new.id is null then
        select into li_work Max(id) from pla_eventos;
        if li_work is null then
            li_work = 0;
        else
            li_work = li_work + 1;
        end if;
        new.id = li_work;
   end if;

    select into r_pla_eventos *
    from pla_eventos
    where compania = new.compania
    and codigo_empleado = new.codigo_empleado
    and new.desde > desde
    and new.desde < hasta;
    if found then
        Raise Exception ''En esta fecha hora % % ya se cargaron implementos % %'', new.desde, new.hasta, new.codigo_empleado, new.compania;
    end if;
    
    return new;
end;
' language plpgsql;



create function f_pla_turnos_rotativos_before_insert() returns trigger as '
declare
    r_pla_tarjeta_tiempo record;
    r_pla_periodos record;
    r_pla_certificados_medico record;
    r_pla_empleados record;
    ld_fecha date;
    li_work int4;
begin

    select into r_pla_empleados *
    from pla_empleados
    where compania = new.compania
    and codigo_empleado = new.codigo_empleado;
    if not found then
        Raise Exception ''No Existe Codigo de Empleado %'',new.codigo_empleado;
    else
        if r_pla_empleados.status = ''I'' then
            Raise Exception ''Empleado Esta Inactivo..Verifique'';
        end if;
        
        if r_pla_empleados.fecha_terminacion_real is not null then
            Raise Exception ''Empleado Tiene fecha de terminacion real...Verifique'';
        end if;
    end if;    
    return new;
end;
' language plpgsql;




create function f_pla_reloj_01_before_insert() returns trigger as '
declare
    r_pla_tarjeta_tiempo record;
    r_pla_periodos record;
    r_pla_certificados_medico record;
    r_pla_empleados record;
    r_pla_reloj_01 record;
    ld_fecha date;
    li_work int4;
begin
    
    
    if new.compania = 1135 then
        li_work             =   new.codigo_reloj;
        
        new.codigo_reloj    =   trim(to_char(li_work,''9999999''));    
    end if;
    
    if new.compania = 1075 then
        li_work =   f_string_to_integer(trim(new.codigo_reloj));
        
        new.codigo_reloj    =   trim(to_char(li_work, ''0009''));
    end if;
    
    if new.compania = 1261 or new.compania = 1357 or new.compania = 1363 then
        if Length(Trim(new.codigo_reloj)) = 3 then
            new.codigo_reloj    =   ''0''||Trim(new.codigo_reloj);
        end if;
    end if;


/*
    select into r_pla_empleados *
    from pla_empleados
    where compania = new.compania
    and trim(codigo_empleado) = trim(new.codigo_reloj);
    if not found then
        Raise Exception ''Codigo de Empleado % no Existe'', new.codigo_reloj;
    end if;
*/

/*    
    select into r_pla_reloj_01 * 
    from pla_reloj_01
    where compania = new.compania
    and codigo_reloj = new.codigo_reloj
    and fecha = new.fecha;
    if found then
        Raise Exception ''Marcacion Empleado % Fecha % ya existe'',new.codigo_reloj, new.fecha;
    end if;
*/

    return new;
end;
' language plpgsql;


create function f_pla_marcaciones_after_update() returns trigger as '
declare
    r_pla_tarjeta_tiempo record;
    r_pla_periodos record;
    r_pla_certificados_medico record;
    ld_fecha date;
    lt_new_dato text;
    lt_old_dato text;
    li_minutos int4;
    i int4;

begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), old.id, trim(lt_old_dato), trim(lt_new_dato), null);
    
    
    if new.status <> ''C'' then
        return new;
    end if;
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = old.id_tarjeta_de_tiempo;
    if not found then
        raise exception ''Registro % no existe en pla_tarjeta_tiempo'',old.id_tarjeta_de_tiempo;
    end if;
    
    select into r_pla_periodos *
    from pla_periodos
    where id = r_pla_tarjeta_tiempo.id_periodos;
    
    ld_fecha = new.entrada;
    
    select into r_pla_certificados_medico *
    from pla_certificados_medico
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
    and fecha = ld_fecha;
    if not found then
        li_minutos  =   f_intervalo(new.entrada, new.salida);
        if li_minutos > 480 then
            li_minutos = 480;
        end if;
        
        insert into pla_certificados_medico(compania, codigo_empleado, fecha, pagado,
            year, numero_planilla, minutos) 
        values(r_pla_tarjeta_tiempo.compania, r_pla_tarjeta_tiempo.codigo_empleado,
            ld_fecha, ''N'', r_pla_periodos.year, r_pla_periodos.numero_planilla, li_minutos);
    end if;    
    return new;
end;
' language plpgsql;




create function f_pla_liquidacion_before_delete() returns trigger as '
declare
    i integer;
    r_pla_empleados record;
    r_pla_periodos record;
begin
    select into r_pla_empleados *
    from pla_empleados
    where compania = old.compania
    and codigo_empleado = old.codigo_empleado;
    
    select into r_pla_periodos *
    from pla_periodos
    where compania = old.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and old.fecha_d_pago between desde and dia_d_pago
    and status = ''A'';
    if not found then
        Raise Exception ''No Existe Planilla abierta en esta fecha %'',old.fecha_d_pago;
    else
        delete from pla_dinero
        using pla_periodos
        where pla_dinero.id_periodos = pla_periodos.id
        and pla_dinero.compania = old.compania
        and codigo_empleado = old.codigo_empleado
        and pla_periodos.desde >= r_pla_periodos.desde
        and tipo_de_calculo = ''7'';
    end if;

    delete from pla_dinero
    where id_pla_liquidacion = old.id;
    
    update pla_empleados
    set fecha_terminacion_real = null, status = ''A''
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado;
    
    return old;
end;
' language plpgsql;



create function f_pla_liquidacion_before_update() returns trigger as '
declare
    i integer;
    r_pla_empleados record;
    r_pla_periodos record;
begin

    new.preliminar = ''N'';
    
    if new.fecha_d_pago is null then
        new.fecha_d_pago = new.fecha;
    end if;

    if new.fecha_indemnizacion is null then
        new.fecha_indemnizacion = new.fecha;
    end if;

    
    select into r_pla_empleados *
    from pla_empleados
    where compania = new.compania
    and codigo_empleado = new.codigo_empleado;
    
    select into r_pla_periodos *
    from pla_periodos
    where compania = new.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and new.fecha_d_pago between desde and dia_d_pago
    and status = ''A'';
    if not found then
        Raise Exception ''No Existe Planilla abierta en esta fecha %'',new.fecha_d_pago;
    end if;

    delete from pla_dinero
    where id_pla_liquidacion = old.id;

    
    return new;
end;
' language plpgsql;



create function f_pla_liquidacion_before_insert() returns trigger as '
declare
    i integer;
    r_pla_empleados record;
    r_pla_periodos record;
    r_work record;
begin
    
    new.preliminar = ''N'';
    
    if new.fecha_d_pago is null then
        new.fecha_d_pago = new.fecha;
    end if;
    
    if new.fecha_indemnizacion is null then
        new.fecha_indemnizacion = new.fecha;
    end if;
    
    select into r_pla_empleados *
    from pla_empleados
    where compania = new.compania
    and codigo_empleado = new.codigo_empleado;
    if not found then
        Raise Exception ''Codigo de Empleado % no Existe'', new.codigo_empleado;
    end if;
    
    if r_pla_empleados.fecha_terminacion_real is not null then
        Raise Exception ''Codigo de Empleado % ya esta liquidado...Verifique'', new.codigo_empleado;
    end if;
    
    select into r_pla_periodos *
    from pla_periodos
    where compania = new.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and new.fecha_d_pago between desde and dia_d_pago
    and status = ''A'';
    if not found then
        Raise Exception ''No Existe Planilla abierta en esta fecha %'',new.fecha_d_pago;
    end if;

    select into r_work *
    from v_pla_dinero_detallado
    where compania = new.compania
    and codigo_empleado = new.codigo_empleado
    and fecha > (new.fecha+2);
    if found then
--        Raise Exception ''Empleado % tiene registros posteriores a la fecha de corte %'',new.codigo_empleado, new.fecha;
    end if;
    
    if new.fecha_d_pago < new.fecha then
        Raise Exception ''Fecha de Pago % debe ser mayor o igual a fecha de corte %'',new.fecha_d_pago, new.fecha;
    end if;
    
    return new;
end;
' language plpgsql;



create function f_pla_tarjeta_tiempo_before_insert() returns trigger as '
declare
    r_pla_companias record;
    r_pla_periodos record;
    r_pla_empleados record;
begin
    select into r_pla_empleados *
    from pla_empleados
    where compania = new.compania
    and codigo_empleado = new.codigo_empleado;
    if not found then
        raise exception ''Empleado % no Existe...'',new.codigo_empleado;
    end if;

/*    
    if r_pla_empleados.fecha_terminacion_real is not null then
        Raise Exception ''Empleado % tiene fecha de terminacion real'',new.codigo_empleado;
    end if;
*/    


    select into r_pla_companias * from pla_companias
    where compania = new.compania;
    
    if current_date > r_pla_companias.fecha_de_expiracion then
        raise exception ''Esta compania expiro el %'',r_pla_companias.fecha_de_expiracion;
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where id = new.id_periodos;
    if not found then
        raise exception ''Periodos % no existe'',new.id_periodos;
    else
        if r_pla_periodos.status = ''C'' then
            raise exception ''Periodo % Esta Cerrado'',new.id_periodos;
        end if;
    end if;
        
    
    return new;
end;
' language plpgsql;


create function f_pla_vacaciones_before_delete() returns trigger as '
declare
    i integer;
    r_pla_dinero record;
begin
    select into r_pla_dinero *
    from pla_dinero
    where id_pla_vacaciones = old.id;
    if found then
        delete from pla_dinero
        where compania = r_pla_dinero.compania
        and codigo_empleado = r_pla_dinero.codigo_empleado
        and tipo_de_calculo = ''2''
        and id_periodos = r_pla_dinero.id_periodos;
    end if;

    delete from pla_dinero
    where id_pla_vacaciones = old.id;
    
    return old;
end;
' language plpgsql;


create function f_pla_vacaciones_before_update() returns trigger as '
declare
    i integer;
    r_pla_dinero record;
begin
    if new.status = ''I'' then
        return new;
    end if;
    
    select into r_pla_dinero *
    from pla_dinero
    where id_pla_vacaciones = old.id;
    if found then
        delete from pla_dinero
        where compania = r_pla_dinero.compania
        and codigo_empleado = r_pla_dinero.codigo_empleado
        and tipo_de_calculo = ''2''
        and id_periodos = r_pla_dinero.id_periodos;
    end if;

    delete from pla_dinero
    where id_pla_vacaciones = old.id;
    
    return new;
end;
' language plpgsql;


create function f_pla_proyectos_after_insert() returns trigger as '
declare
    r_pla_cuentas_x_proyecto record;
    r_work record;
begin
    if new.compania = 745 then
        for r_pla_cuentas_x_proyecto in
            select * from pla_cuentas_x_proyecto
            where compania = new.compania
            and id_pla_proyectos = 619
            order by concepto
        loop
            select into r_work * from pla_cuentas_x_proyecto
            where compania = new.compania
            and id_pla_proyectos = new.id
            and concepto = r_pla_cuentas_x_proyecto.concepto;
            if not found then
                insert into pla_cuentas_x_proyecto(compania, id_pla_proyectos,
                    concepto, id_pla_cuentas, id_pla_cuentas_2)
                values(new.compania, new.id, r_pla_cuentas_x_proyecto.concepto,
                    r_pla_cuentas_x_proyecto.id_pla_cuentas, r_pla_cuentas_x_proyecto.id_pla_cuentas_2);
            else
                update pla_cuentas_x_proyecto
                set id_pla_cuentas = r_pla_cuentas_x_proyecto.id_pla_cuentas,
                    id_pla_cuentas_2 = r_pla_cuentas_x_proyecto.id_pla_cuentas_2
                where compania = new.compania
                and id_pla_proyectos = new.id
                and concepto = r_pla_cuentas_x_proyecto.concepto;
            end if;            
        end loop;
    end if;
    return new;
end;
' language plpgsql;


create function f_pla_cuentas_x_proyecto_before_insert() returns trigger as '
begin
/*
    if new.id_pla_cuentas = new.id_pla_cuentas_2 then
        raise exception ''En concepto % Proyecto % Cuentas contable % no pueden ser iguales'', new.concepto, new.id_pla_proyectos, new.id_pla_cuentas;
    end if;
*/    
    return new;
end;
' language plpgsql;


create function f_pla_cuentas_x_departamento_before_insert() returns trigger as '
begin
/*
    if new.id_pla_cuentas = new.id_pla_cuentas_2 then
        raise exception ''En concepto % Cuentas contable no pueden ser iguales'', new.concepto;
    end if;
*/
    
    return new;
end;
' language plpgsql;


create function f_pla_cuentas_x_concepto_before_insert() returns trigger as '
begin
/*
    if new.id_pla_cuentas = new.id_pla_cuentas_2 then
        raise exception ''En concepto % Cuentas contable '', new.concepto;
    end if;
*/    
    return new;
end;
' language plpgsql;


create function f_pla_marcaciones_after_delete() returns trigger as '
declare
    r_pla_tarjeta_tiempo record;
    lt_new_dato text;
    lt_old_dato text;
    i int4;

begin
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), old.id, trim(lt_old_dato), trim(lt_new_dato), null);
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = old.id_tarjeta_de_tiempo;
    if not found then
        raise exception ''Registro % no existe en pla_tarjeta_tiempo'',old.id_tarjeta_de_tiempo;
    end if;
    
    delete from pla_dinero
    where id_periodos = r_pla_tarjeta_tiempo.id
    and compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
    and tipo_de_calculo = ''1'';

    return old;
end;
' language plpgsql;



create function f_pla_horas_before_insert() returns trigger as '
declare
    i integer;
    r_pla_periodos record;
    r_pla_marcaciones record;
    r_pla_tarjeta_tiempo record;
    r_pla_dinero record;
    r_pla_tipos_de_horas record;
    r_pla_empleados record;
    r_pla_incremento record;
    ld_work date;
begin


    select into r_pla_marcaciones * from pla_marcaciones
    where id = new.id_marcaciones;
    if not found then
        raise exception ''Marcacion % no existe'',new.id_marcaciones;
    end if;
    
    ld_work =   r_pla_marcaciones.entrada;
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    if not found then
        raise exception ''Tarjeta de tiempo % no existe'',r_pla_marcaciones.id_tarjeta_de_tiempo;
    end if;


    select into r_pla_empleados *
    from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;
    
    if r_pla_empleados.tipo_de_salario = ''F'' and r_pla_empleados.status = ''V'' 
        and (new.tipo_de_hora = ''00'' or new.tipo_de_hora = ''30'')then
--        new.minutos = 0;
    end if;
    
    if r_pla_empleados.compania = 1142 and r_pla_empleados.tipo_de_salario = ''H''
        and r_pla_empleados.sindicalizado = ''S'' and ld_work <= ''2014-06-30'' then
        new.tasa_por_minuto = (100*new.tasa_por_minuto) / 111;
    end if;

/*
    if r_pla_empleados.tipo_de_salario = ''F'' and r_pla_empleados.fecha_terminacion_real is not null
        and (new.tipo_de_hora = ''00'' or new.tipo_de_hora = ''30'')then
        new.minutos = 0;
    end if;
*/    

/*
    if r_pla_marcaciones.compania = 1142 and r_pla_empleados.tipo = ''2'' 
        and (new.tipo_de_hora = ''30'') then
        
        new.tasa_por_minuto = (22.0000 / 8.0000) / 60.000000;
        
    end if;
*/
    
    
/*
    select into r_pla_incremento *
    from pla_incremento
    where id_pla_cargos = r_pla_empleados.cargo
    and id_pla_proyectos = r_pla_marcaciones.id_pla_proyectos;
    if found then
        new.tasa_por_minuto = new.tasa_por_minuto * r_pla_incremento.recargo;
    end if;
*/    


    select into r_pla_periodos * from pla_periodos
    where id = r_pla_tarjeta_tiempo.id_periodos;
    if not found then
        raise exception ''Periodo % no existe'',r_pla_tarjeta_tiempo.id_periodos;
    end if;
    
    if r_pla_periodos.status = ''C'' then
        Raise Exception ''Registro % no se puede insertar. Periodo % esta cerrado'',new.id, r_pla_periodos.id;
    end if;
    
    for r_pla_dinero in 
        select * from pla_dinero
        where id_periodos = r_pla_periodos.id
        and compania = r_pla_periodos.compania
        and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
        and tipo_de_calculo = ''1''
        and id_pla_cheques_1 is not null
    loop
        raise exception ''No se puede insertar horas a esta tarjeta...Tiene cheque impreso'';
    end loop;
    
    select into r_pla_tipos_de_horas *
    from pla_tipos_de_horas
    where tipo_de_hora = new.tipo_de_hora;
    if not found then
        raise exception ''Tipo de hora % no existe...Verifique'',new.tipo_de_hora;
    end if;
    
    if new.forma_de_registro = ''M'' and r_pla_tipos_de_horas.sobretiempo = ''S'' and 
        r_pla_tipos_de_horas.recargo > 1 then
        new.acumula = ''S'';
    end if;
    
    if new.forma_de_registro = ''A'' and new.tipo_de_hora = ''01'' 
        and new.minutos > 180 then
        raise exception ''Tipo de horas 01 no puede tener mas de tres horas Empleado % Fecha %'', r_pla_tarjeta_tiempo.codigo_empleado, r_pla_marcaciones.entrada ;
    end if;

    if new.minutos_implemento is null then
        new.minutos_implemento = 0;
    end if;

    if new.minutos is null then
        new.minutos = 0;
    end if;    
    
    if r_pla_empleados.compania = 1316 and new.minutos > 480 then 
        new.minutos = 480;
    end if;
    
    if new.tipo_de_hora = ''20'' and new.minutos > 480 then
        new.minutos = 480;
    end if;        
    
    return new;
end;
' language plpgsql;


create function f_pla_horas_before_update() returns trigger as '
declare
    i integer;
    r_pla_periodos record;
    r_pla_marcaciones record;
    r_pla_tarjeta_tiempo record;
    r_pla_dinero record;
    r_pla_tipos_de_horas record;
begin
    select into r_pla_marcaciones * from pla_marcaciones
    where id = old.id_marcaciones;
    if not found then
        return new;
    end if;

    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    if not found then
        raise exception ''Tarjeta de Tiempo % no existe'',r_pla_marcaciones.id_tarjeta_de_tiempo;
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where id = r_pla_tarjeta_tiempo.id_periodos;
    if not found then
        raise exception ''Periodo % no existe'',r_pla_tarjeta_tiempo.id_periodos;
    end if;
    
    if r_pla_periodos.status = ''C'' then
        Raise Exception ''Registro % no se puede modificar. Periodo % esta cerrado'',old.id, r_pla_periodos.id;
    end if;
    
    for r_pla_dinero in 
        select * from pla_dinero
        where id_periodos = r_pla_periodos.id
        and compania = r_pla_periodos.compania
        and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
        and tipo_de_calculo = ''1''
        and id_pla_cheques_1 is not null
    loop
        raise exception ''No se puede modificar horas a esta tarjeta...Tiene cheque impreso'';
    end loop;
    
    select into r_pla_tipos_de_horas *
    from pla_tipos_de_horas
    where tipo_de_hora = new.tipo_de_hora;
    if not found then
        raise exception ''Tipo de hora % no existe...Verifique'',new.tipo_de_hora;
    end if;
    
    if new.forma_de_registro = ''M'' and r_pla_tipos_de_horas.sobretiempo = ''S'' and 
        r_pla_tipos_de_horas.recargo > 1 then
        new.acumula = ''S'';
    end if;

/*
    if new.forma_de_registro = ''A'' and new.tipo_de_hora = ''01'' 
        and new.minutos > 180 then
        raise exception ''Tipo de horas 01 no puede tener mas de tres horas'';
    end if;
*/

    if new.minutos is null then
        new.minutos = 0;
    end if;    
    

    return new;
end;
' language plpgsql;



create function f_pla_horas_before_delete() returns trigger as '
declare
    i integer;
    r_pla_periodos record;
    r_pla_marcaciones record;
    r_pla_tarjeta_tiempo record;
    r_pla_dinero record;
begin
    if old.minutos = 0 then
        return old;
    end if;
    
    select into r_pla_marcaciones * from pla_marcaciones
    where id = old.id_marcaciones;
    if not found then
        return old;
    end if;
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    if not found then
        raise exception ''Tarjeta de tiempo % no existe'',r_pla_marcaciones.id_tarjeta_de_tiempo;
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where id = r_pla_tarjeta_tiempo.id_periodos;
    if not found then
        raise exception ''Periodo % no existe'',r_pla_tarjeta_tiempo.id_periodos;
    end if;
    
    if r_pla_periodos.status = ''C'' then
        Raise Exception ''Registro % no se puede eliminar. Periodo % esta cerrado'',old.id, r_pla_periodos.id;
    end if;
    
    for r_pla_dinero in 
        select * from pla_dinero
        where id_periodos = r_pla_periodos.id
        and compania = r_pla_periodos.compania
        and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
        and tipo_de_calculo = ''1''
        and id_pla_cheques_1 is not null
    loop
        raise exception ''No se puede borrar horas a esta tarjeta...Tiene cheque impreso'';
    end loop;
    return old;
end;
' language plpgsql;



create function f_pla_marcaciones_before_delete() returns trigger as '
declare
    i integer;
    r_pla_periodos record;
    r_pla_marcaciones record;
    r_pla_tarjeta_tiempo record;
    r_pla_dinero record;
begin
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = old.id_tarjeta_de_tiempo;
    if not found then
        raise exception ''Registro % no existe en pla_tarjeta_tiempo'',old.id_tarjeta_de_tiempo;
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where id = r_pla_tarjeta_tiempo.id_periodos;
    if not found then
        raise exception ''Periodo % no existe'',r_pla_tarjeta_tiempo.id_periodos;
    end if;
    
    if r_pla_periodos.status = ''C'' then
        Raise Exception ''Registro % no se puede eliminar. Periodo % esta cerrado'',old.id, r_pla_periodos.id;
    end if;
    
    for r_pla_dinero in 
        select * from pla_dinero
        where id_periodos = r_pla_periodos.id
        and compania = r_pla_periodos.compania
        and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
        and tipo_de_calculo = ''1''
        and id_pla_cheques_1 is not null
    loop
        raise exception ''No se puede borrar marcaciones a esta tarjeta...Tiene cheque impreso'';
    end loop;    
    
    
    return old;
end;
' language plpgsql;



create function f_pla_cargos_before_insert() returns trigger as '
begin
    if new.monto is null then
        new.monto = 0;
    end if;    
    return new;
end;
' language plpgsql;



create function f_pla_cheques_1_after_update() returns trigger as '
declare
    r_pla_bancos_old record;
    r_pla_bancos_new record;
    r_pla_cuentas record;
begin
    if new.status = ''A'' then
        update pla_dinero
        set id_pla_cheques_1 = null
        where id_pla_cheques_1 = old.id;
        
            
        update pla_deducciones
        set id_pla_cheques_1 = null
        where id_pla_cheques_1 = old.id;
    end if;


    update pla_dinero
    set id_pla_cheques_1 = null
    where id_pla_cheques_1 in
        (select pla_cheques_1.id from pla_cheques_1
        where status = ''A'');
    
    update pla_deducciones
    set id_pla_cheques_1 = null
    where id_pla_cheques_1 in
        (select pla_cheques_1.id from pla_cheques_1
        where status = ''A'');
        
    select into r_pla_bancos_old * from pla_bancos
    where id = old.id_pla_bancos;
    
    select into r_pla_bancos_new * from pla_bancos
    where id = new.id_pla_bancos;
    
    if r_pla_bancos_old.id <> r_pla_bancos_new.id then
        select into r_pla_cuentas * from pla_cuentas
        where id = r_pla_bancos_new.id_pla_cuentas;
        
        update pla_cheques_2
        set id_pla_cuentas = r_pla_bancos_new.id_pla_cuentas,
        descripcion = Trim(r_pla_cuentas.nombre)
        where id_pla_cheques_1 = new.id
        and id_pla_cuentas = r_pla_bancos_old.id_pla_cuentas;
    end if;
    
    return new;
end;
' language plpgsql;


create function f_pla_dinero_before_insert() returns trigger as '
declare
    r_pla_cheques_1 record;
    r_pla_periodos record;
    r_pla_empleados record;
    r_pla_proyectos record;
    r_pla_dinero record;
    r_pla_cuentas_conceptos record;
    r_pla_conceptos record;
    li_id_pla_proyectos int4;
    lb_sw boolean;
begin
    if new.monto is null then
        new.monto = 0;
    end if;
        

    if new.descripcion is null or new.descripcion = '''' then
        select into r_pla_conceptos *
        from pla_conceptos
        where concepto = new.concepto;
        
        new.descripcion = trim(r_pla_conceptos.descripcion);
    end if;


    select into r_pla_empleados *
    from pla_empleados
    where compania = new.compania
    and trim(codigo_empleado) = trim(new.codigo_empleado);
    if not found then
        raise exception ''Codigo de Empleado % no Existe en compania % '',new.codigo_empleado,new.compania;
    end if;

    if new.compania = 1142 and new.concepto = ''130'' and r_pla_empleados.sindicalizado = ''S'' then
        new.descripcion = ''INDEMNIZACION 6%'';
    end if;

    if trim(new.concepto) = ''260'' or trim(new.concepto) = ''74'' then
        if r_pla_empleados.tipo_de_planilla = 2 and new.monto > r_pla_empleados.salario_bruto*2 then
            Raise Exception ''Gratificacion/Aguinaldo Excento no puede ser mayor al salario'';
        end if;
    end if;
    
    new.id_pla_departamentos = r_pla_empleados.departamento;
    
    select into r_pla_periodos *
    from pla_periodos
    where id = new.id_periodos;
    if not found then
        raise exception ''Periodo % no Existe'',new.id_periodos;
    end if;
    
    if new.mes is null then
        new.mes =   Mes(r_pla_periodos.dia_d_pago);
    end if;

/*    
    if new.concepto = ''109'' then
        select into r_pla_dinero *
        from pla_dinero, pla_periodos
        where pla_dinero.id_periodos = pla_periodos.id
        and pla_dinero.compania = new.compania
        and codigo_empleado = new.codigo_empleado
        and pla_periodos.year = r_pla_periodos.year
        and tipo_de_calculo = ''3''
        and mes = Mes(r_pla_periodos.dia_d_pago)
        and monto <> 0
        and concepto = ''109'';
        if found then
            Raise Exception ''No se puede grabar dos veces un xiii mes en un mismo mes Empleado %'',new.codigo_empleado;
        end if;
    end if;
*/    
    if r_pla_periodos.status = ''C'' then
        raise exception ''Tipo de Planilla % Anio % Numero de Planilla % esta cerrado'',r_pla_periodos.tipo_de_planilla,
            r_pla_periodos.year, r_pla_periodos.numero_planilla;
    end if;

    
    if new.id_pla_proyectos is null and
        f_pla_parametros(new.compania, ''proyecto_obligatorio_semanales'', ''N'', ''GET'') = ''S'' then
        lb_sw = false;
        for li_id_pla_proyectos in select pla_marcaciones.id_pla_proyectos 
                                    from pla_marcaciones, pla_tarjeta_tiempo
                                    where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
                                    and pla_tarjeta_tiempo.id_periodos = new.id_periodos
                                    and pla_tarjeta_tiempo.compania = new.compania
                                    and pla_tarjeta_tiempo.codigo_empleado = new.codigo_empleado
                                    and pla_marcaciones.id_pla_proyectos is not null
        loop
            lb_sw = true;
            exit;
        end loop;
    
        if lb_sw then
            new.id_pla_proyectos    =   li_id_pla_proyectos;
        else
            new.id_pla_proyectos    =   r_pla_empleados.id_pla_proyectos;
        end if;
    
    end if;
    
    select into r_pla_proyectos *
    from pla_proyectos
    where id = new.id_pla_proyectos
    and compania = new.compania;
    if not found then
        new.id_pla_proyectos    =   r_pla_empleados.id_pla_proyectos;
/*        
        for li_id_pla_proyectos in select id
                                    from pla_proyectos
                                    where compania = new.compania
                                    order by id
        loop
            new.id_pla_proyectos    =   li_id_pla_proyectos;
            exit;
        end loop;
*/        
    end if;
    
    if new.id_pla_proyectos is null then
        new.id_pla_proyectos    =   r_pla_empleados.id_pla_proyectos;
    end if;    
    
    for r_pla_dinero in 
        select * from pla_dinero, pla_cheques_1
        where compania = new.compania
        and codigo_empleado = new.codigo_empleado
        and id_periodos = new.id_periodos
        and tipo_de_calculo = new.tipo_de_calculo
        and id_pla_cheques_1 is not null
        and id_pla_cheques_1 = pla_cheques_1.id
        and pla_cheques_1.tipo_transaccion in (''CH'',''C'')
        and pla_cheques_1.status <> ''A''
    loop
        raise exception ''Este calculo ya tiene un cheque asignado'';
    end loop;
    
    select into r_pla_cuentas_conceptos pla_cuentas_conceptos.*
    from pla_cuentas_conceptos, pla_cuentas
    where pla_cuentas_conceptos.id_pla_cuentas = pla_cuentas.id
    and pla_cuentas.compania = new.compania
    and pla_cuentas_conceptos.concepto = new.concepto;
    if found then
        new.id_pla_cuentas  =   r_pla_cuentas_conceptos.id_pla_cuentas;
    end if;

    if new.compania = 893 then
        new.id_pla_proyectos    =   r_pla_empleados.id_pla_proyectos;
    end if;    

    
    return new;
end;
' language plpgsql;



create function f_pla_certificados_medico_before_delete() returns trigger as '
declare
    r_pla_empleados record;
    r_pla_periodos record;
begin

    select into r_pla_empleados * from pla_empleados
    where compania = old.compania
    and trim(codigo_empleado) = trim(old.codigo_empleado);
    if not found then
        raise exception ''Empleado % no Existe en la cia %'',old.codigo_empleado, old.compania;
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where compania = old.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and year = old.year
    and numero_planilla = old.numero_planilla;
    if not found then
        raise exception ''Numero de Planilla % Del Anio % no Existe'',old.numero_planilla,old.year;
    end if;
    
    if r_pla_periodos.status = ''C'' then
        raise exception ''Certificado Medico no se puede borrar.  Pertenece a un periodo cerrado'';
    end if;
  
/*    
    if f_valida_fecha(old.compania, r_pla_empleados.tipo_de_planilla, r_pla_periodos.dia_d_pago) then
    end if;
*/    
    
    return old;
end;
' language plpgsql;


create function f_pla_certificados_medico_before_update() returns trigger as '
declare
    r_pla_empleados record;
    r_pla_periodos record;
begin
    select into r_pla_empleados * from pla_empleados
    where compania = old.compania
    and Trim(codigo_empleado) = Trim(old.codigo_empleado);
    if not found then
        raise exception ''Empleado % no Existe en la cia %'',old.codigo_empleado, old.compania;
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where compania = old.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and year = old.year
    and numero_planilla = old.numero_planilla;
    if not found then
        raise exception ''Numero de Planilla % Del Anio % no Existe'',old.numero_planilla,old.year;
    end if;
    
    if r_pla_periodos.status = ''C'' then
        raise exception ''Certificado Medico no se puede modificar.  Pertenece a un periodo cerrado'';
    end if;
    

/*    
    if f_valida_fecha(old.compania, r_pla_empleados.tipo_de_planilla, r_pla_periodos.dia_d_pago) then
    end if;
*/    
    
    select into r_pla_empleados * from pla_empleados
    where compania = new.compania
    and trim(codigo_empleado) = trim(new.codigo_empleado);
    if not found then
        raise exception ''Empleado % no Existe en la cia %'',new.codigo_empleado, new.compania;
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where compania = new.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and year = new.year
    and numero_planilla = new.numero_planilla;
    if not found then
        raise exception ''Numero de Planilla % Del Anio % no Existe'',new.numero_planilla,new.year;
    end if;

    
    if r_pla_periodos.status = ''C'' then
        raise exception ''Certificado Medico no se puede borrar.  Pertenece a un periodo cerrado'';
    end if;
    
    
    if new.minutos > 480 then
        new.minutos = 480;
    end if;

    if new.fecha > r_pla_periodos.hasta then
        Raise Exception ''Fecha de Certificado Medico % Debe ser anterior o igual a fecha de corte del periodo %'',new.fecha, r_pla_periodos.hasta;
    end if;

    
    return new;
end;
' language plpgsql;

create function f_pla_certificados_medico_before_insert() returns trigger as '
declare
    r_pla_empleados record;
    r_pla_periodos record;
begin
    select into r_pla_empleados * from pla_empleados
    where compania = new.compania
    and trim(codigo_empleado) = trim(new.codigo_empleado);
    if not found then
        raise exception ''Empleado % no Existe en la cia %'',new.codigo_empleado, new.compania;
    end if;


    if new.year <> 0 and new.numero_planilla <> 0 then    
        select into r_pla_periodos * from pla_periodos
        where compania = new.compania
        and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
        and year = new.year
        and numero_planilla = new.numero_planilla;
        if not found then
            raise exception ''Numero de Planilla % Del Anio % no Existe'',new.numero_planilla,new.year;
        end if;
    
    
        if r_pla_periodos.status = ''C'' then
            raise exception ''Certificado Medico no se puede insertar.  Pertenece a un periodo cerrado'';
        end if;
    
        if new.fecha > r_pla_periodos.hasta then
            Raise Exception ''Fecha de Certificado Medico % Debe ser anterior o igual a fecha de corte del periodo %'',new.fecha, r_pla_periodos.hasta;
        end if;
    end if;
    
    if new.minutos > 480 then
        new.minutos = 480;
    end if;

        
    return new;
end;
' language plpgsql;






create function f_pla_cheques_1_before_update() returns trigger as '
declare
    r_pla_cheques_1 record;
begin
    if old.tipo_transaccion = ''SC'' and new.tipo_transaccion = ''C'' then
        while 1=1 loop
            select into r_pla_cheques_1 *
            from pla_cheques_1
            where id_pla_bancos = new.id_pla_bancos
            and tipo_transaccion = new.tipo_transaccion
            and no_cheque = new.no_cheque;
            if not found then
                return new;
            else
                new.no_cheque = new.no_cheque + 1;
            end if;
        end loop;
    end if;
    
    return new;
end;
' language plpgsql;


create function f_pla_cheques_1_before_delete() returns trigger as '
begin

    update pla_dinero
    set id_pla_cheques_1 = null
    where id_pla_cheques_1 = old.id;
    
    update pla_deducciones
    set id_pla_cheques_1 = null
    where id_pla_cheques_1 = old.id;
    
    return old;
end;
' language plpgsql;


create function f_pla_riesgos_profesionales_before_insert() returns trigger as '
begin
    new.concepto    =   ''295'';    
    return new;
end;
' language plpgsql;


create function f_pla_otros_ingresos_fijos_before_insert() returns trigger as '
begin
    if new.periodo > 5 then
        raise exception ''En un mes no pueden haber mas de 5 periodos...Verifique'';
    end if;
    
    return new;
end;
' language plpgsql;



create function f_pla_turnos_before_insert() returns trigger as '
declare
    li_regulares interval;
    li_descanso interval;
    ldc_maximo_horas_por_turno decimal(10,2);
    ldc_horas decimal(10,2);
    r_pla_turnos record;
begin
/*
    select into r_pla_turnos *
    from pla_turnos
    where compania = new.compania
    and turno = new.turno;
    if found then
        Raise Exception ''Codigo de Turno % ya existe ...Verifique'',new.turno;
    end if;
*/    
    
    if new.hora_inicio_descanso = new.hora_salida_descanso then
        Raise Exception ''La hora de entrada % y salida % de descanso no puede ser igual...Verifique'',new.hora_inicio_descanso, new.hora_salida_descanso;
    end if;
    
    ldc_maximo_horas_por_turno  =   f_pla_parametros(new.compania, ''maximo_horas_por_turno'',''8'',''GET'');

    li_regulares    =   new.hora_salida - new.hora_inicio;
    li_descanso     =   new.hora_salida_descanso - new.hora_inicio_descanso;
    ldc_horas       =   f_interval_to_horas(li_regulares) - f_interval_to_horas(li_descanso);
    
    if ldc_horas > ldc_maximo_horas_por_turno then
        raise exception ''Cantidad de horas de este turno % excede el numero de horas permitidas por turno %'',ldc_horas, ldc_maximo_horas_por_turno;
    end if;


    
    if new.hora_salida_descanso >= new.hora_salida then
--        Raise Exception ''Hora de Salida del Descanso % No puede ser posterior a salida de jornada %'', new.hora_salida_descanso, new.hora_salida;
    end if;
    return new;
end;
' language plpgsql;


create function f_pla_desglose_regulares_before_insert() returns trigger as '
declare
    r_pla_marcaciones record;
    ldc_maximo_horas_por_turno decimal;
begin
    select into r_pla_marcaciones *
    from pla_marcaciones
    where id = new.id_pla_marcaciones;
    
    ldc_maximo_horas_por_turno  =   f_pla_parametros(r_pla_marcaciones.compania, ''maximo_horas_por_turno'',''8'',''GET'');

    if new.regulares > (ldc_maximo_horas_por_turno * 60) then
        raise exception ''Horas Regulares % No puede ser de 8 horas '',new.regulares;
    end if;
    return new;
end;
' language plpgsql;


create function f_pla_departamentos_after_insert() returns trigger as '
begin
    insert into pla_auxiliares(id_pla_departamentos)
    values (new.id);
    return new;
end;
' language plpgsql;

create function f_pla_acreedores_after_insert() returns trigger as '
begin
    insert into pla_auxiliares(compania, acreedor)
    values (new.compania, new.acreedor);
    return new;
end;
' language plpgsql;

create function f_pla_acreedores_after_update() returns trigger as '
declare
    r_pla_auxiliares record;
begin
    select into r_pla_auxiliares * 
    from pla_auxiliares
    where compania = new.compania
    and acreedor = new.acreedor;
    if not found then
        insert into pla_auxiliares(compania, acreedor)
        values (new.compania, new.acreedor);
    end if;
    return new;
end;
' language plpgsql;


create function f_pla_empleados_after_update() returns trigger as '
declare
    r_pla_auxiliares record;
    i integer;
    lt_new_dato text;
    lt_old_dato text;
begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
    

    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), 0, trim(lt_old_dato), 
                        trim(lt_new_dato), null, new.compania, new.usuario);

/*
    

    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), null, trim(lt_old_dato), 
                        trim(lt_new_dato), null, new.compania, new.usuario);
*/                        


    select into r_pla_auxiliares * 
    from pla_auxiliares
    where compania = new.compania
    and codigo_empleado = new.codigo_empleado;
    if not found then
        insert into pla_auxiliares(compania, codigo_empleado)
        values (new.compania, new.codigo_empleado);
    end if;

--    i = f_zktime_hr_employee(new.compania, new.codigo_empleado);    
    if new.compania <> 1362 then
        i = f_zktime_hr_employee(new.compania, new.codigo_empleado);    
    end if;        
    
    return new;
end;
' language plpgsql;



create function f_pla_dinero_before_delete() returns trigger as '
declare
    r_pla_cheques_1 record;
    r_pla_periodos record;
    r_pla_empleados record;
    r_pla_pagos_ach record;
    r_pla_deducciones record;
begin

    select into r_pla_empleados *
    from pla_empleados
    where compania = old.compania
    and codigo_empleado = old.codigo_empleado;
    if r_pla_empleados.forma_de_pago = ''T'' then
        select into r_pla_pagos_ach *
        from pla_pagos_ach
        where tipo_de_calculo = old.tipo_de_calculo
        and id_pla_periodos = old.id_periodos;
        if found then
            raise exception ''Registro no puede ser eliminado ya se hizo pago con ACH al empleado %'',old.codigo_empleado;
        end if;
    end if;
    
    if old.id_pla_cheques_1 is not null then
        select into r_pla_cheques_1 pla_cheques_1.*
        from pla_cheques_1
        where tipo_transaccion in (''C'',''CH'')
        and pla_cheques_1.id = old.id_pla_cheques_1
        and pla_cheques_1.status <> ''A'';
        if found then
            raise exception ''Registro no se puede eliminar con cheques impresos %'',old.id_pla_cheques_1;
        else
            delete from pla_cheques_1
            where id = old.id_pla_cheques_1;
        end if;
    end if;    
    

    delete from pla_reservas_pp where id_pla_dinero = old.id;
    
    select into r_pla_periodos *
    from pla_periodos
    where id = old.id_periodos;
    if not found then
        raise exception ''Periodo % no Existe'',old.id_periodos;
    end if;
    
    if r_pla_periodos.status = ''C'' then
        raise exception ''Tipo de Planilla % Anio % Numero de Planilla % esta cerrado'',r_pla_periodos.tipo_de_planilla,
            r_pla_periodos.year, r_pla_periodos.numero_planilla;
    end if;
    
    select into r_pla_deducciones *
    from pla_deducciones, pla_cheques_1
    where pla_deducciones.id_pla_cheques_1 = pla_cheques_1.id
    and pla_cheques_1.tipo_transaccion = ''C''
    and pla_cheques_1.status <> ''A''
    and pla_deducciones.id_pla_dinero = old.id;
    if found then
        Raise Exception ''No se puede borrar registro con cheque de acreedor impreso'';
    end if;
    
    return old;
end;
' language plpgsql;


create function f_pla_dinero_before_update() returns trigger as '
declare
    r_pla_cheques_1 record;
    r_pla_periodos record;
    r_pla_empleados record;
    r_pla_deducciones record;
    li_id_pla_proyectos int4;
    lb_sw boolean;
begin


    if old.id_pla_cheques_1 is not null and 
        old.codigo_empleado = new.codigo_empleado then
        select into r_pla_cheques_1 pla_cheques_1.*
        from pla_cheques_1
        where pla_cheques_1.tipo_transaccion in (''CH'',''C'')
        and pla_cheques_1.id = old.id_pla_cheques_1
        and pla_cheques_1.status <> ''A'';
        if found then
            raise exception ''Registro no se puede modificar con cheques impresos'';
        else
/*        
            delete from pla_cheques_1
            where id = old.id_pla_cheques_1;
*/            
        end if;
    end if;    
    
    
    delete from pla_reservas_pp where id_pla_dinero = old.id;
    
    select into r_pla_empleados *
    from pla_empleados
    where compania = new.compania
    and codigo_empleado = new.codigo_empleado;
    if not found then
        raise exception ''Empleado % no existe'',new.codigo_empleado;
    end if;
    
    if new.id_pla_departamentos is null then
        new.id_pla_departamentos = r_pla_empleados.departamento;
    end if;
    
    if new.id_pla_proyectos is null then
        lb_sw = false;
        for li_id_pla_proyectos in select pla_marcaciones.id_pla_proyectos 
                                    from pla_marcaciones, pla_tarjeta_tiempo
                                    where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
                                    and pla_tarjeta_tiempo.id_periodos = new.id_periodos
                                    and pla_tarjeta_tiempo.compania = new.compania
                                    and pla_tarjeta_tiempo.codigo_empleado = new.codigo_empleado
                                    and pla_marcaciones.id_pla_proyectos is not null
        loop
            lb_sw = true;
            exit;
        end loop;
    
        if lb_sw then
            new.id_pla_proyectos    =   li_id_pla_proyectos;
        else
            new.id_pla_proyectos    =   r_pla_empleados.id_pla_proyectos;
        end if;
    
    end if;
    
    
    select into r_pla_periodos *
    from pla_periodos
    where id = old.id_periodos;
    if not found then
        raise exception ''Periodo % no Existe'',old.id_periodos;
    end if;
    
    if r_pla_periodos.status = ''C'' then
        if old.id_pla_cheques_1 = new.id_pla_cheques_1 then
            raise exception ''Tipo de Planilla % Anio % Numero de Planilla % esta cerrado'',r_pla_periodos.tipo_de_planilla,
                r_pla_periodos.year, r_pla_periodos.numero_planilla;
        end if;
    end if;
    
    select into r_pla_periodos *
    from pla_periodos
    where id = new.id_periodos;
    if not found then
        raise exception ''Periodo % no Existe'',new.id_periodos;
    end if;
    
    
    if r_pla_periodos.status = ''C'' then
        if old.id_pla_cheques_1 = new.id_pla_cheques_1 then
            raise exception ''Tipo de Planilla % Anio % Numero de Planilla % esta cerrado'',r_pla_periodos.tipo_de_planilla,
                r_pla_periodos.year, r_pla_periodos.numero_planilla;
        end if;
    end if;

    if new.monto <> old.monto then
        select into r_pla_deducciones *
        from pla_deducciones, pla_cheques_1
        where pla_deducciones.id_pla_cheques_1 = pla_cheques_1.id
        and pla_cheques_1.tipo_transaccion = ''C''
        and pla_cheques_1.status <> ''A''
        and pla_deducciones.id_pla_dinero = old.id;
        if found then
            Raise Exception ''No se puede modificar registro con cheque de acreedor impreso'';
        end if;
    end if;
    
    return new;
end;
' language plpgsql;



create function f_pla_auxiliares_before_update() returns trigger as '
begin
    if new.compania is null and new.codigo_empleado is null and new.id_pla_departamentos is null and
        new.acreedor is null then
        raise exception ''Todos los Campos en Auxiliares no pueden ser nulos'';
    end if;
    
    return new;
end;
' language plpgsql;


create function f_pla_liquidacion_after_insert() returns trigger as '
declare
    i integer;
    lt_new_dato text;
    lt_old_dato text;
begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), new.id, trim(lt_old_dato), trim(lt_new_dato), null);

--    i = f_pla_liquidacion(new.id);

    if new.preliminar = true then
        update pla_empleados
        set fecha_terminacion_real = null
        where compania = new.compania
        and codigo_empleado = new.codigo_empleado;
    else
        update pla_empleados
        set fecha_terminacion_real = new.fecha
        where compania = new.compania
        and codigo_empleado = new.codigo_empleado;
    end if;
        
    return new;
end;
' language plpgsql;


create function f_pla_liquidacion_after_update() returns trigger as '
declare
    i integer;
    lt_new_dato text;
    lt_old_dato text;
begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), old.id, trim(lt_old_dato), trim(lt_new_dato), null);

--    i = f_pla_liquidacion(new.id);
    if new.preliminar = true then
        update pla_empleados
        set fecha_terminacion_real = null
        where compania = new.compania
        and codigo_empleado = new.codigo_empleado;
    else
        update pla_empleados
        set fecha_terminacion_real = new.fecha
        where compania = new.compania
        and codigo_empleado = new.codigo_empleado;
    end if;
    return new;
end;
' language plpgsql;



create function f_pla_xiii_after_insert() returns trigger as '
declare
    i integer;
begin
    if new.status = ''A'' then
        i = f_pla_xiii(new.id);
    end if;
    return new;
end;
' language plpgsql;



create function f_pla_xiii_before_delete() returns trigger as '
begin
/*
    if f_valida_fecha(old.compania, old.dia_d_pago, old.tipo_de_planilla) then
    end if;
*/    

    return old;
end;
' language plpgsql;



create function f_pla_xiii_before_insert() returns trigger as '
declare
    li_count integer;
begin
    if new.acum_desde > new.acum_hasta then
        raise exception ''Fecha Desde % Debe ser inferior a fecha hasta %'',new.acum_desde, new.acum_hasta;
    end if;

    if (new.acum_hasta - current_date) >= 65 then
        Raise Exception ''No se puede registrar XIII con tanto tiempo de anticipacion %'',new.acum_hasta;
    end if;    

    if new.status = ''A'' then
        if f_valida_fecha(new.compania, new.dia_d_pago, new.tipo_de_planilla) then
            select into li_count count(*) from pla_xiii
            where compania = new.compania
            and tipo_de_planilla = new.tipo_de_planilla
            and status = ''A'';
            if li_count is null then
                li_count = 0;
            end if;
            
            if li_count >= 1 then
                raise exception ''Solo puede estar abierto un periodo del xiii por tipo de planilla'';
            end if;
        end if;
    end if;
    
    return new;
end;
' language plpgsql;

create function f_pla_xiii_before_update() returns trigger as '
declare
    li_count integer;
begin
    if new.acum_desde > new.acum_hasta then
        raise exception ''Fecha Desde % Debe ser inferior a fecha hasta %'',new.acum_desde, new.acum_hasta;
    end if;

    if (new.acum_hasta - current_date) >= 65 then
        Raise Exception ''No se puede registrar XIII con tanto tiempo de anticipacion %'',new.acum_hasta;
    end if;    
    
    if new.status = ''A'' then
        if f_valida_fecha(new.compania, new.dia_d_pago, new.tipo_de_planilla) then
            select into li_count count(*) from pla_xiii
            where compania = new.compania
            and tipo_de_planilla = new.tipo_de_planilla
            and status = ''A'';
            if li_count is null then
                li_count = 0;
            end if;
            
            if li_count > 1 then
                raise exception ''Solo puede estar abierto un periodo del xiii por tipo de planilla'';
            end if;
        end if;
    end if;
    
    return new;
end;
' language plpgsql;




create function f_pla_vacaciones_before_insert() returns trigger as '
declare
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_vacaciones record;
begin
    if new.acum_hasta > current_date+30 then
        Raise Exception ''Fecha de Acumulado Hasta % no puede ser mayor a fecha actual %'',new.acum_hasta, current_date;
    end if;

    if new.acum_desde > new.acum_hasta then
        Raise Exception ''Fecha de Acumulado Hasta % debe ser posterior de Acumulado Desde %'',new.acum_hasta, new.acum_desde;
    end if;
    
    if new.compania <> 1185 then
        select into r_pla_vacaciones *
        from pla_vacaciones
        where compania = new.compania
        and trim(codigo_empleado) = trim(new.codigo_empleado)
        and ((new.acum_desde between acum_desde and acum_hasta)
        or (new.acum_hasta between acum_desde and acum_hasta));
        if found then
            Raise Exception ''Este Rango que Vacaciones % % tiene fechas que ya fueron pagada...Verifique'',new.acum_desde, new.acum_hasta;
        end if;    
    end if;

    select into r_pla_empleados * from pla_empleados
    where compania = new.compania
    and trim(codigo_empleado) = trim(new.codigo_empleado);
    if not found then
        raise exception ''Codigo de Empleado % No Existe...Verifique'',new.codigo_empleado;
    else
        if r_pla_empleados.status <> ''A'' and r_pla_empleados.status <> ''V'' then
            raise exception ''No se puede crear vacaciones a empleados Inactivos'';
        end if;
    end if;
    
    if new.status = ''A'' then
        select into r_pla_periodos * from pla_periodos
        where compania = new.compania
        and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
        and new.dia_d_pago between desde and dia_d_pago
        and status = ''C'';
        if found then
            raise exception ''Fecha de Pago % Pertenece a un periodo cerrado'',new.dia_d_pago;
        end if;
        
        if new.acum_desde > new.acum_hasta then
            raise exception ''Acumular Desde % Debe ser Menor a Acumular Hasta %'',new.acum_desde, new.acum_hasta;
        end if;
        
        if new.pagar_desde > new.pagar_hasta then
            raise exception ''Pagar Desde % Debe ser Menor a Pagar Hasta %'',new.pagar_desde, new.pagar_hasta;
        end if;
    end if;
    
    
    return new;
end;
' language plpgsql;


create function f_pla_periodos_before_update() returns trigger as '
declare
    r_pla_periodos record;
    li_count integer;
begin
    if new.status = ''C'' then
        return new;
    end if;
    
    li_count = 0;
    select into li_count count(*) from pla_periodos
    where compania = new.compania
    and numero_planilla = new.numero_planilla
    and tipo_de_planilla = new.tipo_de_planilla
    and status = ''A'';
    
    if li_count is null then
        li_count = 0;
    end if;
    
    if li_count > 1 then
        raise exception ''No pueden estar abiertas dos planillas con el mismo numero % tipo %'',new.numero_planilla,new.tipo_de_planilla;
    end if;
    
    if new.desde > new.hasta then
        Raise Exception ''Hasta % debe ser posterior a Desde %'',new.hasta, new.desde;
    end if;    

    if new.desde > new.dia_d_pago then
        Raise Exception ''Dia de Pago % debe ser posterior a Desde %'',new.dia_d_pago, new.desde;
    end if;    


    select into r_pla_periodos *
    from pla_periodos
    where compania = new.compania
    and tipo_de_planilla = new.tipo_de_planilla
    and (year <> new.year or numero_planilla <> new.numero_planilla)
    and ((new.desde between desde and hasta) or (new.hasta between desde and hasta));
    if found then
--        Raise Exception ''Compania % Rango de fecha % ya fue contemplado en planilla % del anio % Tipo de Planilla %'',new.compania, r_pla_periodos.dia_d_pago, r_pla_periodos.numero_planilla, r_pla_periodos.year, r_pla_periodos.tipo_de_planilla;
    end if;    
    
    
    return new;
end;
' language plpgsql;



create function f_pla_periodos_before_insert() returns trigger as '
declare
    r_pla_periodos record;
    li_count integer;
begin
    if new.status = ''C'' then
        return new;
    end if;
    
    li_count = 0;
    select into li_count count(*) 
    from pla_periodos
    where compania = new.compania
    and numero_planilla = new.numero_planilla
    and tipo_de_planilla = new.tipo_de_planilla
    and status = ''A'';
    
    if new.desde > new.hasta then
        Raise Exception ''Hasta % debe ser posterior a Desde %'',new.hasta, new.desde;
    end if;    
    
    if new.desde > new.dia_d_pago then
        Raise Exception ''Dia de Pago % debe ser posterior a Desde %'',new.dia_d_pago, new.desde;
    end if;    
    
    if li_count is not null then
        if li_count >= 1 then
            raise exception ''No pueden estar abiertas dos planillas con el mismo numero % tipo %'',new.numero_planilla,new.tipo_de_planilla;
        end if;
    end if;

    select into r_pla_periodos *
    from pla_periodos
    where compania = new.compania
    and tipo_de_planilla = new.tipo_de_planilla
    and ((new.desde between desde and hasta) or (new.hasta between desde and hasta));
    if found then
        Raise Exception ''Rango de fecha ya fue contemplado en planilla % del anio %'',r_pla_periodos.numero_planilla, r_pla_periodos.year;
    end if;    
    
    
    return new;
end;
' language plpgsql;




create function f_pla_permisos_before_insert() returns trigger as '
declare
    ld_fecha date;
    r_pla_empleados record;
    r_pla_periodos record;
begin
    select into r_pla_empleados * from pla_empleados
    where compania = new.compania
    and Trim(codigo_empleado) = trim(new.codigo_empleado);
    if not found then
        raise exception ''Empleado % no Existe en la cia %'',new.codigo_empleado, new.compania;
    end if;
    
    
    select into r_pla_periodos * from pla_periodos
    where compania = new.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and year = new.year
    and numero_planilla = new.numero_planilla;
    if not found then
        raise exception ''Numero de Planilla % Del Anio % no Existe'',new.numero_planilla,new.year;
    else
        if r_pla_periodos.status <> ''A'' then
            raise exception ''Numero de Planilla % Del Anio % Esta Cerrado'',new.numero_planilla,new.year;
        
        end if;        
    end if;
  
    
/*    
    if f_valida_fecha(new.compania, r_pla_empleados.tipo_de_planilla, r_pla_periodos.dia_d_pago) then
    end if;
*/    
    
    
    return new;
end;
' language plpgsql;


create function f_pla_permisos_before_update() returns trigger as '
declare
    ld_fecha date;
    r_pla_empleados record;
    r_pla_periodos record;
begin
    select into r_pla_empleados * from pla_empleados
    where compania = old.compania
    and trim(codigo_empleado) = trim(old.codigo_empleado);
    if not found then
        raise exception ''Empleado % no Existe en la cia %'',old.codigo_empleado, old.compania;
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where compania = old.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and year = old.year
    and numero_planilla = old.numero_planilla;
    if not found then
        raise exception ''Numero de Planilla % Del Anio % no Existe'',old.numero_planilla,old.year;
    end if;
    
    if f_valida_fecha(old.compania, r_pla_empleados.tipo_de_planilla, r_pla_periodos.dia_d_pago) then
    end if;
    

    select into r_pla_empleados * from pla_empleados
    where compania = new.compania
    and trim(codigo_empleado) = trim(new.codigo_empleado);
    if not found then
        raise exception ''Empleado % no Existe en la cia %'',new.codigo_empleado, new.compania;
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where compania = new.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and year = new.year
    and numero_planilla = new.numero_planilla;
    if not found then
        raise exception ''Numero de Planilla % Del Anio % no Existe'',new.numero_planilla,new.year;
    end if;
    
    
    if f_valida_fecha(new.compania, r_pla_empleados.tipo_de_planilla, r_pla_periodos.dia_d_pago) then
    end if;
    
    return new;
end;
' language plpgsql;


create function f_pla_permisos_before_delete() returns trigger as '
declare
    r_pla_empleados record;
    r_pla_periodos record;
begin
    select into r_pla_empleados * from pla_empleados
    where compania = old.compania
    and trim(codigo_empleado) = trim(old.codigo_empleado);
    if not found then
        raise exception ''Empleado % no Existe en la cia %'',old.codigo_empleado, old.compania;
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where compania = old.compania
    and tipo_de_planilla = r_pla_empleados.tipo_de_planilla
    and year = old.year
    and numero_planilla = old.numero_planilla;
    if not found then
        raise exception ''Numero de Planilla % Del Anio % no Existe'',old.numero_planilla,old.year;
    end if;
    
    if f_valida_fecha(old.compania, r_pla_empleados.tipo_de_planilla, r_pla_periodos.dia_d_pago) then
    end if;

    return old;
end;
' language plpgsql;




create function f_pla_empleados_before_insert() returns trigger as '
declare
    r_pla_departamentos record;
    r_pla_proyectos record;
    r_pla_cargos record;
    r_pla_empleados record;
begin

    if new.tipo_cta_bco is not null then
        if Length(Trim(new.tipo_cta_bco)) > 2 then
            Raise Exception ''Tipo de cuenta de Banco % debe ser como maximo 2 caracteres...Verifique'',new.tipo_cta_bco;
        end if;
    end if;

       
    select into r_pla_empleados *
    from pla_empleados
    where compania = new.compania
    and cedula = new.cedula;
    if found then
        Raise Exception ''Ya existe empleado con este numero de cedula % '',new.cedula;
    end if;
    
    if new.reloj is null then
        new.reloj = true;
    end if;
    
    if new.cargo is null then
        for r_pla_cargos in
            select * from pla_cargos
            where compania = new.compania
        order by id
        loop
            new.cargo = r_pla_cargos.id;
            exit;
        end loop;
    end if;
    
    if new.id_pla_proyectos is null then
        for r_pla_proyectos in
            select * from pla_proyectos
            where compania = new.compania
            order by id
        loop
            new.id_pla_proyectos = r_pla_proyectos.id;
            exit;
        end loop;
    end if;
    
    if new.departamento is null then
        for r_pla_departamentos in
            select * from pla_departamentos
            where compania = new.compania
            order by id
        loop
            new.departamento = r_pla_departamentos.id;
            exit;
        end loop;
    end if;
    
            
    if new.nombre is null then
        raise exception ''Nombre del Empleado Es Obligatorio...Verifique'';
    end if;
    
    if new.apellido is null then
        raise exception ''Apellido es Obligatorio...Verifique'';
    end if;
    
    if new.salario_bruto <= 0 then
        raise exception ''Salario Bruto Es Obligatorio...Verifique'';
    end if;
    
    if new.tasa_por_hora <= 0 then
        raise exception ''Tasa Por Hora Es Obligatorio...Verifique'';
    end if;
    
    if new.sindicalizado is null then
        new.sindicalizado = ''N'';
    end if;

    if new.fecha_inicio > current_date + 30 then
        Raise Exception ''Fecha de Inicio % no puede ser fecha del futuro'',new.fecha_inicio;
    end if;
    
    return new;
end;
' language plpgsql;


create function f_pla_empleados_before_update() returns trigger as '
declare
    ld_ultima_liquidacion date;
begin
    if new.nombre is null then
        raise exception ''Nombre del Empleado Es Obligatorio...Verifique'';
    end if;
    
    if new.apellido is null then
        raise exception ''Apellido es Obligatorio...Verifique'';
    end if;
    
    if new.salario_bruto <= 0 then
        raise exception ''Salario Bruto Es Obligatorio...Verifique'';
    end if;
    
    if new.tasa_por_hora <= 0 then
        raise exception ''Tasa Por Hora Es Obligatorio...Verifique'';
    end if;

    if new.fecha_terminacion_real is null then
        ld_ultima_liquidacion = null;            
        
        select into ld_ultima_liquidacion Max(fecha)
        from pla_liquidacion
        where compania = new.compania
        and codigo_empleado = new.codigo_empleado;
        if ld_ultima_liquidacion is not null then
            if new.fecha_inicio <= ld_ultima_liquidacion then
--                Raise Exception ''Fecha de Inicio % Debe ser posterior a ultima liquidacion %'',new.fecha_inicio, ld_ultima_liquidacion;
            end if;
        end if;
        
    end if;

    if new.fecha_inicio > current_date + 30 then
        Raise Exception ''Fecha de Inicio % no puede ser fecha del futuro'',new.fecha_inicio;
    end if;

    
    return new;
end;
' language plpgsql;



create function f_pla_vacaciones_after_insert() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;

begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), new.id, trim(lt_old_dato), trim(lt_new_dato), null);

    if new.status = ''A'' then
        update pla_empleados
        set status = ''V''
        where compania = new.compania
        and codigo_empleado = new.codigo_empleado;
        i = f_pla_vacaciones(new.id);
    else
        update pla_empleados
        set status = ''A''
        where compania = new.compania
        and codigo_empleado = new.codigo_empleado;
    end if;        

    return new;
end;
' language plpgsql;


create function f_pla_vacaciones_after_update() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;

begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   Row(Old.*);
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), new.id, trim(lt_old_dato), trim(lt_new_dato), null);
    
    if new.status = ''A'' then
        update pla_empleados
        set status = ''V''
        where compania = new.compania
        and codigo_empleado = new.codigo_empleado;
        i = f_pla_vacaciones(new.id);
    else
        update pla_empleados
        set status = ''A''
        where compania = new.compania
        and status = ''V''
        and codigo_empleado = new.codigo_empleado;
    end if;        

    return new;
end;
' language plpgsql;


create function f_pla_vacaciones_after_delete() returns trigger as '
declare
    lt_new_dato text;
    lt_old_dato text;
    i int4;

begin
    lt_new_dato =   null;
    lt_old_dato =   Row(Old.*);
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), old.id, trim(lt_old_dato), trim(lt_new_dato), null);

    update pla_empleados
    set status = ''A''
    where compania = old.compania
    and codigo_empleado = old.codigo_empleado;
    
    return old;
end;
' language plpgsql;




create function f_pla_empleados_after_insert() returns trigger as '
declare
    r_pla_turnos record;
    lt_new_dato text;
    lt_old_dato text;
    i int4;

begin
    lt_new_dato =   Row(New.*);
    lt_old_dato =   null;
--    i           =   f_bitacora(trim(tg_op),  trim(tg_table_name), null, trim(lt_old_dato), trim(lt_new_dato), null);

    select into r_pla_turnos *
    from pla_turnos
    where compania = new.compania;
    if not found then
        raise exception ''En esta compania no existen turnos...Verifique'';
    end if;
    
    
    for r_pla_turnos in select * from pla_turnos
                            where compania = new.compania
                            order by turno
    loop
    
        for i in 1..6 loop
            insert into pla_horarios (compania, codigo_empleado, dia, turno)
            values (new.compania, new.codigo_empleado, i, r_pla_turnos.turno);
        end loop;
        exit;
    end loop;
    
    insert into pla_auxiliares(compania, codigo_empleado)
    values(new.compania, new.codigo_empleado);

    if new.compania <> 1362 then
        i = f_zktime_hr_employee(new.compania, new.codigo_empleado);    
    end if;        
    
    return new;
end;
' language plpgsql;




create function f_pla_companias_before_insert() returns trigger as '
begin
    if Trim(new.nombre) = '''' then
        raise exception ''Nombre de Compania es Obligatorio'';
    end if;
    
    new.fecha_de_apertura = current_date;
    new.fecha_de_expiracion = current_date + 90;
    new.status = 1;
    return new;
end;
' language plpgsql;


create function f_pla_companias_after_insert() returns trigger as '
declare
    r_pla_tipos_de_planilla record;
    r_pla_departamentos record;
    r_pla_cargos record;
    r_pla_parametros_x_cia record;
    r_pla_cuentas record;
    i integer;
    li_year int4;
begin
    select into r_pla_tipos_de_planilla * from pla_tipos_de_planilla
    where compania = new.compania
    and tipo_de_planilla = ''1'';
    if not found then
        insert into pla_tipos_de_planilla (compania, tipo_de_planilla,
            descripcion, planilla_actual)
        values (new.compania, ''1'', ''SEMANAL'', 1);
    end if;
    
    li_year = Anio(current_date);
    
    select into r_pla_tipos_de_planilla * from pla_tipos_de_planilla
    where compania = new.compania
    and tipo_de_planilla = ''2'';
    if not found then
        insert into pla_tipos_de_planilla (compania, tipo_de_planilla,
            descripcion, planilla_actual)
        values (new.compania, ''2'', ''QUINCENAL'', 1);
    end if;
    
    select into r_pla_tipos_de_planilla * from pla_tipos_de_planilla
    where compania = new.compania
    and tipo_de_planilla = ''3'';
    if not found then
        insert into pla_tipos_de_planilla (compania, tipo_de_planilla,
            descripcion, planilla_actual)
        values (new.compania, ''3'', ''BISEMANAL'', 1);
    end if;

    select into r_pla_tipos_de_planilla * from pla_tipos_de_planilla
    where compania = new.compania
    and tipo_de_planilla = ''4'';
    if not found then
        insert into pla_tipos_de_planilla (compania, tipo_de_planilla,
            descripcion, planilla_actual)
        values (new.compania, ''4'', ''MENSUAL'', 1);
    end if;
    
    select into r_pla_departamentos * from pla_departamentos
    where compania = new.compania
    and departamento = ''NA'';
    if not found then
        insert into pla_departamentos(compania, departamento, descripcion, status)
        values (new.compania,''NA'',''NO APLICA'',1);
    end if;
    
    select into r_pla_cargos * from pla_cargos
    where compania = new.compania
    and cargo = ''NA'';
    if not found then
        insert into pla_cargos(compania, cargo, descripcion, status)
        values (new.compania, ''NA'', ''NO APLICA'',1);
    end if;
    i = f_pla_crear_periodos(new.compania, li_year);
    
    insert into pla_turnos(compania, turno, hora_inicio, hora_salida, hora_inicio_descanso,
        hora_salida_descanso, tolerancia_de_entrada, tolerancia_de_salida, tipo_de_jornada,
        tolerancia_descanso)
    values(new.compania, ''01'', ''08:00'', ''17:00'', ''12:00'', ''13:00'', ''08:05'',
        ''17:30'', ''D'',''13:00'');
        
    insert into pla_proyectos (compania, proyecto, descripcion)
    values(new.compania, ''NO'', ''NO APLICA'');
    
    
    insert into pla_cuentas(cuenta, compania, nombre, nivel, naturaleza,
        tipo_cuenta, status, departamentos, acreedores, empleados, proyectos)
    select cuenta, new.compania, nombre, ''1'', naturaleza, tipo_cuenta, ''A'',
        true, true, true, true
        from pla_cuentas_pp;
        
    select into r_pla_cuentas *
    from pla_cuentas
    where cuenta = ''2103''
    and compania = new.compania;
    if found then
        insert into pla_cuentas_x_concepto(compania, concepto, id_pla_cuentas, id_pla_cuentas_2)
        select new.compania, concepto, r_pla_cuentas.id,  r_pla_cuentas.id
        from pla_conceptos;
    end if;
        
    return new;
end;
' language plpgsql;


create function f_pla_marcaciones_before_insert() returns trigger as '
declare
    i integer;
    r_pla_periodos record;
    r_pla_marcaciones record;
    r_pla_tarjeta_tiempo record;
    r_pla_dinero record;
    r_pla_empleados record;
    r_pla_turnos_rotativos record;
    r_pla_certificados_medico record;
    r_pla_cheques_1 record;
    r_pla_bancos record;
    r_pla_proyectos record;
    r_work record;
    ldc_maximo_horas_por_turno decimal(10,2);    
    ldc_horas decimal(10,2);
    li_regulares interval;
    li_descanso interval;
    ld_entrada date;
    li_work int4;
    ld_work date;
begin
/*
    if new.compania = 1075 and new.turno = 3 then
        if Extract(hour from new.salida) = 5 then
            new.salida  =   new.salida + cast((90 || ''minutes'') as interval);
        end if;
    end if;
*/    
    
    if new.entrada_descanso = new.salida_descanso then
        new.entrada_descanso = null;
        new.salida_descanso = null;
    end if;

    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = new.id_tarjeta_de_tiempo;
    if not found then
        raise exception ''Registro % no existe en pla_tarjeta_tiempo'',new.id_tarjeta_de_tiempo;
    end if;
    
    select into r_work *
    from pla_tarjeta_tiempo, pla_marcaciones
    where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
    and pla_tarjeta_tiempo.compania = r_pla_tarjeta_tiempo.compania
    and pla_tarjeta_tiempo.codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
    and pla_marcaciones.entrada = new.entrada
    and pla_marcaciones.salida = new.salida;
    if found then
--        raise exception ''Marcacion de la fecha % ya existe para este empleado %'',new.entrada, r_pla_tarjeta_tiempo.codigo_empleado;
    end if;
    
    
    select into r_pla_turnos_rotativos *
    from pla_turnos_rotativos
    where compania = new.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
    and Date(new.entrada) between desde and hasta
    and turno is null;
    if found then
        new.status = ''L'';
    end if;
    
    select into r_pla_empleados * 
    from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;
    
    if new.id_pla_proyectos is null then
        new.id_pla_proyectos = r_pla_empleados.id_pla_proyectos;
    else
        select into r_pla_proyectos * 
        from pla_proyectos
        where id = new.id_pla_proyectos
        and compania = r_pla_empleados.compania;
        if not found then
            new.id_pla_proyectos = r_pla_empleados.id_pla_proyectos;
        end if;        
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where id = r_pla_tarjeta_tiempo.id_periodos;
    if not found then
        raise exception ''Periodo % no existe'',r_pla_tarjeta_tiempo.id_periodos;
    end if;
    
    if r_pla_periodos.status = ''C'' then
        Raise Exception ''Periodo % esta cerrado'',r_pla_periodos.id;
    end if;
    
    ld_work = f_to_date(new.entrada);
    if ld_work > r_pla_periodos.dia_d_pago then
        Raise Exception ''Fecha % no puede ser posterior a dia de pago % Empleado %'', ld_work, r_pla_periodos.dia_d_pago, r_pla_empleados.codigo_empleado;
    end if;
    
    if r_pla_empleados.tipo_de_salario = ''H''
        and ld_work > r_pla_periodos.hasta then
        Raise Exception ''Fecha % no puede ser posterior a fecha de cierre %'', ld_work, r_pla_periodos.hasta;
    end if;

    if new.entrada > new.salida then
        raise exception ''Hora de entrada % no puede ser mayor a salida %'',new.entrada,new.salida;
    end if;
    
    if new.entrada_descanso > new.salida_descanso and new.entrada_descanso is not null then
        raise exception ''Hora de Entrada de Descanso % no puede ser mayor a salida de descanso %'',new.entrada_descanso,new.salida_descanso;
    end if;
    
    if new.compania <> 1341 then
        if new.entrada >= new.entrada_descanso then
            raise exception ''Inicio de descanso % tiene que ser posterior a hora de entrada % %'',new.entrada_descanso, new.entrada, r_pla_empleados.codigo_empleado;
        end if;
    end if;
      
    if new.compania <> 1341 then  
        if new.salida_descanso >= new.salida then
            raise exception ''Salida de descanso % no puede ser posterior a salida de jornada % empleado %'',new.salida_descanso,new.salida, r_pla_tarjeta_tiempo.codigo_empleado;
        end if;
    end if;        
    
/*    
    ld_entrada = new.entrada;
    select into r_pla_certificados_medico *
    from pla_certificados_medico
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and fecha = ld_entrada;
    if found then
        Raise Exception ''Este dia ya tiene un certificado medico ingresado'';
    end if;
*/
    
    for r_pla_dinero in 
        select * from pla_dinero
        where id_periodos = r_pla_periodos.id
        and compania = r_pla_periodos.compania
        and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
        and tipo_de_calculo = ''1''
        and id_pla_cheques_1 is not null
    loop
        select into r_pla_cheques_1 *
        from pla_cheques_1
        where id = r_pla_dinero.id_pla_cheques_1;
        
        select into r_pla_bancos *
        from pla_bancos
        where id = r_pla_cheques_1.id_pla_bancos;
        
        
        
        raise exception ''No se puede agregar marcaciones a esta tarjeta...Tiene cheque impreso % %'',r_pla_cheques_1.no_cheque, r_pla_bancos.nombre;
    end loop;    

/*
    for r_pla_marcaciones in 
        select pla_marcaciones.*
        from pla_tarjeta_tiempo, pla_marcaciones
        where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
        and entrada < new.entrada
        and pla_marcaciones.id_tarjeta_de_tiempo = new.id_tarjeta_de_tiempo
        order by pla_marcaciones.entrada desc
    loop
        if r_pla_marcaciones.salida >= new.entrada then
            raise exception ''Entrada % no puede ser antes de salida anterior %'',new.entrada,r_pla_marcaciones.salida;
        end if;
        exit;
    end loop;
*/
    
    li_work =   f_intervalo(new.entrada, new.salida);
    
    if li_work > 2880 then
        Raise Exception ''Una persona % en la fecha % no puede trabajar mas de dos dias seguidos'', r_pla_empleados.codigo_empleado, new.entrada;
    end if;

    
    new.autorizado = Trim(f_pla_parametros(new.compania, ''autorizado_default'', ''N'', ''GET''));
    
    return new;
end;
' language plpgsql;


create function f_pla_marcaciones_before_update() returns trigger as '
declare
    i integer;
    r_pla_periodos record;
    r_pla_marcaciones record;
    r_pla_tarjeta_tiempo record;
    r_pla_empleados record;
    r_pla_dinero record;
    r_pla_turnos record;
    r_pla_cheques_1 record;
    li_work int4;
begin

/*
    if new.compania = 1075 and new.turno = 3 then
        if old.salida > new.salida then
            new.salida = old.salida;
        end if;
    end if;
*/

    if new.entrada_descanso = new.salida_descanso then
        new.entrada_descanso = null;
        new.salida_descanso = null;
    end if;

    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = new.id_tarjeta_de_tiempo;
    if not found then
        raise exception ''Registro % no existe en pla_tarjeta_tiempo'',new.id_tarjeta_de_tiempo;
    end if;
    
    select into r_pla_empleados *
    from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;
    
    
    if new.id_pla_proyectos is null then
        new.id_pla_proyectos = r_pla_empleados.id_pla_proyectos;
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where id = r_pla_tarjeta_tiempo.id_periodos;
    if not found then
        raise exception ''Periodo % no existe'',r_pla_tarjeta_tiempo.id_periodos;
    end if;
    
    if r_pla_periodos.status = ''C'' then
        Raise Exception ''Periodo % esta cerrado'',r_pla_periodos.id;
    end if;

    
    if new.entrada > new.salida then
        if r_pla_tarjeta_tiempo.compania = 1075 then
--            new.turno = null;
        else
--                raise exception ''Hora de entrada % no puede ser mayor a salida %'',new.entrada, new.salida;
        end if;
    end if;

    if new.compania <> 1316 then    
        if new.entrada_descanso >= new.salida_descanso 
            and new.entrada_descanso is not null and old.salida_descanso <> new.salida_descanso then
--                raise exception ''Hora de Entrada de Descanso % no puede ser mayor a salida %'', new.entrada_descanso, new.salida_descanso;
        end if;

/*
        if new.salida_descanso > new.salida then
            raise exception ''Salida de descanso no puede ser posterior a salida de jornada'';
        end if;
*/        

        if new.compania <> 1341 then
--            if new.salida_descanso > new.salida and old.salida_descanso <> new.salida_descanso then
            if new.salida_descanso > new.salida then
--                    raise exception ''Salida de descanso % no puede ser posterior a salida de jornada % empleado %'',new.salida_descanso,new.salida, r_pla_tarjeta_tiempo.codigo_empleado;
            end if;
        end if;

    end if;    
    
    
    if new.compania <> 1341 then
    if new.entrada >= new.entrada_descanso then
        if r_pla_tarjeta_tiempo.compania = 1075 then
--            new.turno = null;
        else
--                raise exception ''Inicio de descanso % tiene que ser posterior a hora de entrada % %'',new.entrada_descanso, new.entrada, r_pla_empleados.codigo_empleado;
        end if;            
    end if;
    end if;

/*    
    for r_pla_marcaciones in 
        select pla_marcaciones.*
        from pla_tarjeta_tiempo, pla_marcaciones
        where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
        and entrada < new.entrada
        and pla_marcaciones.id_tarjeta_de_tiempo = new.id_tarjeta_de_tiempo
        order by pla_marcaciones.entrada desc
    loop
        if r_pla_marcaciones.salida >= new.entrada then
            raise exception ''Entrada % no puede ser antes de salida anterior %'',new.entrada,r_pla_marcaciones.salida;
        end if;
        exit;
    end loop;
*/    

    li_work =   f_intervalo(new.entrada, new.salida);
    
    if li_work > 2880 then
        Raise Exception ''Una persona % en la fecha % no puede trabajar mas de dos dias seguidos'', r_pla_empleados.codigo_empleado, new.entrada;
    end if;


    for r_pla_dinero in 
        select * from pla_dinero
        where id_periodos = r_pla_periodos.id
        and compania = r_pla_periodos.compania
        and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
        and tipo_de_calculo = ''1''
        and id_pla_cheques_1 is not null
    loop
        select into r_pla_cheques_1 *
        from pla_cheques_1
        where id = r_pla_dinero.id_pla_cheques_1;
        
        raise exception ''No se puede modificar marcaciones a esta tarjeta...Tiene cheque % impreso'', r_pla_cheques_1.no_cheque;
    end loop;    
    
    if new.autorizado is null then
        new.autorizado = ''N'';
    end if;
    
    return new;
end;
' language plpgsql;


create trigger t_pla_turnos_x_dia_after_insert after insert on pla_turnos_x_dia
for each row execute procedure f_pla_turnos_x_dia_after_insert();


create trigger t_pla_marcaciones_movicell_after_insert after insert on pla_marcaciones_movicell
for each row execute procedure f_pla_marcaciones_movicell_after_insert();


create trigger t_pla_reloj_01_before_insert before insert on pla_reloj_01
for each row execute procedure f_pla_reloj_01_before_insert();


create trigger t_pla_riesgos_profesionales_before_insert before insert on pla_riesgos_profesionales
for each row execute procedure f_pla_riesgos_profesionales_before_insert();

create trigger t_pla_marcaciones_before_delete before delete on pla_marcaciones
for each row execute procedure f_pla_marcaciones_before_delete();

create trigger t_pla_marcaciones_after_update after update on pla_marcaciones
for each row execute procedure f_pla_marcaciones_after_update();

create trigger t_pla_marcaciones_after_insert after insert on pla_marcaciones
for each row execute procedure f_pla_marcaciones_after_insert();


create trigger t_pla_marcaciones_before_update before update on pla_marcaciones
for each row execute procedure f_pla_marcaciones_before_update();

create trigger t_pla_marcaciones_before_insert before insert on pla_marcaciones
for each row execute procedure f_pla_marcaciones_before_insert();

create trigger t_pla_companias_after_insert after insert on pla_companias
for each row execute procedure f_pla_companias_after_insert();

create trigger t_pla_companias_before_insert before insert on pla_companias
for each row execute procedure f_pla_companias_before_insert();

create trigger t_pla_empleados_after_insert after insert on pla_empleados
for each row execute procedure f_pla_empleados_after_insert();

create trigger t_pla_empleados_after_update after update on pla_empleados
for each row execute procedure f_pla_empleados_after_update();

create trigger t_pla_empleados_before_insert before insert on pla_empleados
for each row execute procedure f_pla_empleados_before_insert();

create trigger t_pla_empleados_before_update before update on pla_empleados
for each row execute procedure f_pla_empleados_before_update();

create trigger t_pla_permisos_before_insert before insert on pla_permisos
for each row execute procedure f_pla_permisos_before_insert();

create trigger t_pla_permisos_before_update before update on pla_permisos
for each row execute procedure f_pla_permisos_before_update();

create trigger t_pla_permisos_before_delete before delete on pla_permisos
for each row execute procedure f_pla_permisos_before_delete();

create trigger t_pla_tarjeta_tiempo before insert on pla_tarjeta_tiempo
for each row execute procedure f_pla_tarjeta_tiempo_before_insert();

create trigger t_pla_certificados_medico_before_insert before insert on pla_certificados_medico
for each row execute procedure f_pla_certificados_medico_before_insert();

create trigger t_pla_certificados_medico_before_update before update on pla_certificados_medico
for each row execute procedure f_pla_certificados_medico_before_update();

create trigger t_pla_certificados_medico_before_delete before delete on pla_certificados_medico
for each row execute procedure f_pla_certificados_medico_before_delete();

create trigger t_pla_periodos_before_insert before insert on pla_periodos
for each row execute procedure f_pla_periodos_before_insert();

create trigger t_pla_periodos_before_update before update on pla_periodos
for each row execute procedure f_pla_periodos_before_update();

create trigger t_pla_vacaciones_before_insert before insert on pla_vacaciones
for each row execute procedure f_pla_vacaciones_before_insert();

create trigger t_pla_vacaciones_before_update before update on pla_vacaciones
for each row execute procedure f_pla_vacaciones_before_update();

create trigger t_pla_vacaciones_after_insert after insert on pla_vacaciones
for each row execute procedure f_pla_vacaciones_after_insert();

create trigger t_pla_vacaciones_after_update after update on pla_vacaciones
for each row execute procedure f_pla_vacaciones_after_update();


create trigger t_pla_xiii_before_insert before insert on pla_xiii
for each row execute procedure f_pla_xiii_before_insert();

create trigger t_pla_xiii_before_update before update on pla_xiii
for each row execute procedure f_pla_xiii_before_update();

create trigger t_pla_xiii_before_delete before delete on pla_xiii
for each row execute procedure f_pla_xiii_before_delete();

create trigger t_pla_xiii_after_insert after insert or update on pla_xiii
for each row execute procedure f_pla_xiii_after_insert();

create trigger t_pla_auxiliares_before_update before insert or update on pla_auxiliares
for each row execute procedure f_pla_auxiliares_before_update();

create trigger t_pla_dinero_before_insert before insert on pla_dinero
for each row execute procedure f_pla_dinero_before_insert();

create trigger t_pla_dinero_before_update before update on pla_dinero
for each row execute procedure f_pla_dinero_before_update();

create trigger t_pla_dinero_before_delete before delete on pla_dinero
for each row execute procedure f_pla_dinero_before_delete();

create trigger t_pla_dinero_after_insert after insert on pla_dinero
for each row execute procedure f_pla_dinero_after_insert();

create trigger t_pla_dinero_after_update after update on pla_dinero
for each row execute procedure f_pla_dinero_after_update();

create trigger t_pla_dinero_after_delete after delete on pla_dinero
for each row execute procedure f_pla_dinero_after_delete();


create trigger t_pla_acreedores_after_update after update on pla_acreedores
for each row execute procedure f_pla_acreedores_after_update();

create trigger t_pla_acreedores_after_insert after insert on pla_acreedores
for each row execute procedure f_pla_acreedores_after_insert();

create trigger t_pla_departamentos_after_insert after insert on pla_departamentos
for each row execute procedure f_pla_departamentos_after_insert();

create trigger t_pla_desglose_regulares_before_insert before insert on pla_desglose_regulares
for each row execute procedure f_pla_desglose_regulares_before_insert();

create trigger t_pla_turnos_before_insert before insert or update on pla_turnos
for each row execute procedure f_pla_turnos_before_insert();

create trigger t_pla_otros_ingresos_fijos_before_insert before insert or update on pla_otros_ingresos_fijos
for each row execute procedure f_pla_otros_ingresos_fijos_before_insert();

create trigger t_pla_cheques_1_before_delete before delete on pla_cheques_1
for each row execute procedure f_pla_cheques_1_before_delete();

create trigger t_pla_cheques_1_before_update before update on pla_cheques_1
for each row execute procedure f_pla_cheques_1_before_update();

create trigger t_pla_cheques_1_after_update after update on pla_cheques_1
for each row execute procedure f_pla_cheques_1_after_update();

create trigger t_pla_cargos_before_insert before insert on pla_cargos
for each row execute procedure f_pla_cargos_before_insert();

create trigger t_pla_horas_before_delete before delete on pla_horas
for each row execute procedure f_pla_horas_before_delete();

create trigger t_pla_horas_before_update before update on pla_horas
for each row execute procedure f_pla_horas_before_update();

create trigger t_pla_horas_before_insert before insert on pla_horas
for each row execute procedure f_pla_horas_before_insert();

create trigger t_pla_marcaciones_after_delete after delete on pla_marcaciones
for each row execute procedure f_pla_marcaciones_after_delete();

create trigger t_pla_cuentas_x_proyecto before update or insert on pla_cuentas_x_proyecto
for each row execute procedure f_pla_cuentas_x_proyecto_before_insert();

create trigger t_pla_cuentas_x_departamento before update or insert on pla_cuentas_x_departamento
for each row execute procedure f_pla_cuentas_x_departamento_before_insert();

create trigger t_pla_cuentas_x_concepto before update or insert on pla_cuentas_x_concepto
for each row execute procedure f_pla_cuentas_x_concepto_before_insert();


create trigger t_pla_proyectos_after_insert after update or insert on pla_proyectos
for each row execute procedure f_pla_proyectos_after_insert();


create trigger t_pla_vacaciones_before_delete before delete on pla_vacaciones
for each row execute procedure f_pla_vacaciones_before_delete();

create trigger t_pla_tarjeta_tiempo_before_insert before insert on pla_tarjeta_tiempo
for each row execute procedure f_pla_tarjeta_tiempo_before_insert();

create trigger t_pla_liquidacion_before_insert before insert on pla_liquidacion
for each row execute procedure f_pla_liquidacion_before_insert();

create trigger t_pla_liquidacion_before_update before update on pla_liquidacion
for each row execute procedure f_pla_liquidacion_before_update();

create trigger t_pla_liquidacion_before_delete before delete on pla_liquidacion
for each row execute procedure f_pla_liquidacion_before_delete();

create trigger t_pla_liquidacion_after_update after update on pla_liquidacion
for each row execute procedure f_pla_liquidacion_after_update();

create trigger t_pla_liquidacion_after_insert after insert on pla_liquidacion
for each row execute procedure f_pla_liquidacion_after_insert();

create trigger t_pla_liquidacion_after_delete after delete on pla_liquidacion
for each row execute procedure f_pla_liquidacion_after_delete();

create trigger t_pla_turnos_rotativos_before_insert before insert on pla_turnos_rotativos
for each row execute procedure f_pla_turnos_rotativos_before_insert();

create trigger t_pla_eventos_before_insert before insert on pla_eventos
for each row execute procedure f_pla_eventos_before_insert();

create trigger t_pla_eventos_before_update before update on pla_eventos
for each row execute procedure f_pla_eventos_before_update();



create trigger t_pla_reclamos_before_update before update on pla_reclamos
for each row execute procedure f_pla_reclamos_before_update();

create trigger t_pla_reclamos_before_delete before delete on pla_reclamos
for each row execute procedure f_pla_reclamos_before_delete();

create trigger t_pla_reclamos_before_insert before insert on pla_reclamos
for each row execute procedure f_pla_reclamos_before_insert();

create trigger t_pla_reclamos_after_insert after insert on pla_reclamos
for each row execute procedure f_pla_reclamos_after_insert();

create trigger t_pla_reclamos_after_update after update on pla_reclamos
for each row execute procedure f_pla_reclamos_after_update();

create trigger t_pla_deducciones_before_insert before insert on pla_deducciones
for each row execute procedure f_pla_deducciones_before_insert();

create trigger t_pla_acreedores_before_insert before insert on pla_acreedores
for each row execute procedure f_pla_acreedores_before_insert();

create trigger t_pla_acreedores_before_update before update on pla_acreedores
for each row execute procedure f_pla_acreedores_before_update();

create trigger t_pla_preelaboradas_before_insert before insert on pla_preelaboradas
for each row execute procedure f_pla_preelaboradas_before_insert();

create trigger t_pla_horarios_suntracs_before_insert before insert on pla_horarios_suntracs
for each row execute procedure f_pla_horarios_suntracs_before_insert();

create trigger t_pla_horarios_suntracs_after_insert after insert on pla_horarios_suntracs
for each row execute procedure f_pla_horarios_suntracs_after_insert();

create trigger t_pla_periodos_after_update after update on pla_periodos
for each row execute procedure f_pla_periodos_after_update();



/*
create trigger t_pla_horas_after_update after update on pla_horas
for each row execute procedure f_pla_horas_after_update();

create trigger t_pla_horas_after_insert after insert on pla_horas
for each row execute procedure f_pla_horas_after_insert();

create trigger t_pla_horas_after_delete after delete on pla_horas
for each row execute procedure f_pla_horas_after_delete();

create trigger t_pla_horarios_after_update after update on pla_horarios
for each row execute procedure f_pla_horarios_after_update();

create trigger t_pla_horarios_after_insert after insert on pla_horarios
for each row execute procedure f_pla_horarios_after_insert();

create trigger t_pla_horarios_after_delete after delete on pla_horarios
for each row execute procedure f_pla_horarios_after_delete();
*/
