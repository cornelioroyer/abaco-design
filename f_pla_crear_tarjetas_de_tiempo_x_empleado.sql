
set search_path to planilla;

drop function f_pla_crear_tarjetas_de_tiempo_x_empleado(int4, char(2), char(7), int4) cascade;

create function f_pla_crear_tarjetas_de_tiempo_x_empleado(int4, char(2), char(7), int4) returns integer as '
declare
    ai_cia alias for $1;
    as_tipo_de_planilla alias for $2;
    ac_codigo_empleado alias for $3;
    ai_id_periodos alias for $4;
    r_pla_tipos_de_planilla record;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_horarios record;
    r_pla_tarjeta_tiempo record;
    r_pla_marcaciones record;
    r_pla_turnos record;
    r_pla_dias_feriados record;
    r_pla_turnos_rotativos record;
    r_pla_dinero record;
    r_pla_certificados_medico record;
    ld_work date;
    ld_hasta date;
    ldt_entrada timestamp without time zone;
    ldt_salida timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    li_dow integer;
    i integer;
begin
    select into r_pla_tipos_de_planilla * 
    from pla_tipos_de_planilla
    where compania = ai_cia
    and tipo_de_planilla = as_tipo_de_planilla;
    if not found then
        raise exception ''Tipo de Planilla % No Existe...Verifique'',as_tipo_de_planilla;
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where id = ai_id_periodos
    and compania = ai_cia
    and tipo_de_planilla = as_tipo_de_planilla
    and status = ''A'';
    if not found then
        raise exception ''Numero de Planilla % no Existe'',r_pla_tipos_de_planilla.planilla_actual;
    else
        if r_pla_periodos.status = ''C'' then
            raise exception ''Numero de Planilla % esta Cerrada'',r_pla_tipos_de_planilla.planilla_actual;
        end if;
    end if;
/*
    
    if trim(as_tipo_de_planilla) = ''1'' and
        Trim(f_pla_parametros(ai_cia, ''proyecto_obligatorio_semanales'',''N'',''GET'')) = ''S'' then
        
        delete from pla_marcaciones using pla_periodos, pla_tarjeta_tiempo
        where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
        and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
        and pla_marcaciones.id_pla_proyectos is null
        and pla_tarjeta_tiempo.compania = ai_cia
        and pla_periodos.tipo_de_planilla = ''1''
        and pla_periodos.id = r_pla_periodos.id;
        
        return 0;
    end if;

    delete from pla_marcaciones using pla_periodos, pla_empleados, pla_tarjeta_tiempo
    where pla_periodos.id = pla_tarjeta_tiempo.id_periodos
    and pla_tarjeta_tiempo.compania = pla_empleados.compania
    and pla_tarjeta_tiempo.codigo_empleado = pla_empleados.codigo_empleado
    and pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
    and pla_empleados.status = ''E''
    and pla_periodos.id = r_pla_periodos.id;


    delete from pla_tarjeta_tiempo using pla_periodos, pla_empleados
    where pla_periodos.id = pla_tarjeta_tiempo.id_periodos
    and pla_tarjeta_tiempo.compania = pla_empleados.compania
    and pla_tarjeta_tiempo.codigo_empleado = pla_empleados.codigo_empleado
    and pla_empleados.status = ''E''
    and pla_periodos.id = r_pla_periodos.id;
*/    
    
  
    if trim(as_tipo_de_planilla) = ''3''
        and Trim(f_pla_parametros(ai_cia, ''crear_tarjeta_bisemanales'',''N'',''GET'')) = ''N'' then
        return 0;
    end if;

    
    for r_pla_empleados in select * from pla_empleados
                            where compania = ai_cia
                            and tipo_de_planilla = as_tipo_de_planilla
                            and codigo_empleado = ac_codigo_empleado
                            and status in (''A'',''V'')
                            order by codigo_empleado
    loop
        select into r_pla_dinero *
        from pla_dinero
        where compania = ai_cia
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and tipo_de_calculo = ''1''
        and id_periodos = r_pla_periodos.id
        and id_pla_cheques_1 is not null;
        if not found then
            if r_pla_empleados.tipo_de_salario = ''F'' and
                r_pla_empleados.fecha_inicio between r_pla_periodos.desde and r_pla_periodos.dia_d_pago then
                ld_hasta = r_pla_periodos.dia_d_pago;
            else
                ld_hasta = r_pla_periodos.hasta;
            end if;

            if r_pla_empleados.compania <> 99999999 then
                if r_pla_empleados.tipo_de_planilla = ''2''
                    and r_pla_empleados.tipo_de_salario = ''F'' then
                    ld_hasta = r_pla_periodos.dia_d_pago;
                end if;
            end if;
                            
            ld_work = r_pla_periodos.desde;
            
            if r_pla_empleados.fecha_terminacion_real is not null then
                ld_hasta = r_pla_empleados.fecha_terminacion_real;
            end if;

            while ld_work <= ld_hasta loop
                if r_pla_empleados.tipo_de_planilla = ''2''
                    and r_pla_empleados.tipo_de_salario = ''F''
                    and ld_work > r_pla_periodos.hasta
                    and extract(dow from ld_work) = 0 then
                    ld_work = ld_work + 1;
                    continue;
                end if;

                if r_pla_empleados.fecha_inicio <= ld_work then
                    i = f_crear_tarjeta(ai_cia, r_pla_empleados.codigo_empleado, ld_work, r_pla_periodos.id);
                end if;
                ld_work = ld_work + 1;

            end loop;

            if r_pla_empleados.tipo_de_planilla = ''2''
                and r_pla_empleados.tipo_de_salario = ''F'' then
                update pla_marcaciones
                set status = ''R''
                from pla_tarjeta_tiempo
                where pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
                and pla_tarjeta_tiempo.compania = ai_cia
                and pla_tarjeta_tiempo.codigo_empleado = r_pla_empleados.codigo_empleado
                and pla_tarjeta_tiempo.id_periodos = r_pla_periodos.id
                and pla_marcaciones.status = ''I''
                and date(pla_marcaciones.entrada) > r_pla_periodos.hasta;
           end if;

            
            for r_pla_certificados_medico in select pla_certificados_medico.* 
                                    from pla_certificados_medico, pla_periodos
                                    where pla_certificados_medico.compania = pla_periodos.compania
                                    and pla_certificados_medico.year = pla_periodos.year
                                    and pla_certificados_medico.numero_planilla = pla_periodos.numero_planilla
                                    and pla_certificados_medico.compania = r_pla_empleados.compania
                                    and pla_certificados_medico.codigo_empleado = r_pla_empleados.codigo_empleado
                                    and pla_certificados_medico.year = r_pla_periodos.year
                                    and pla_certificados_medico.numero_planilla = r_pla_periodos.numero_planilla
                                    order by pla_certificados_medico.codigo_empleado desc
            loop
                if r_pla_empleados.fecha_inicio <= r_pla_certificados_medico.fecha then
                    i = f_crear_tarjeta(ai_cia, r_pla_empleados.codigo_empleado, r_pla_certificados_medico.fecha, r_pla_periodos.id);
                end if;
            end loop;

            
        end if;
    end loop;
    
    
    return 1;
end;
' language plpgsql;

