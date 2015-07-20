drop function f_poner_ausencias(int4, char(2)) cascade;


create function f_poner_ausencias(int4, char(2)) returns integer as '
declare
    ai_cia alias for $1;
    as_tipo_de_planilla alias for $2;
    r_pla_tipos_de_planilla record;
    r_pla_empleados record;
    r_pla_periodos record;
    r_pla_marcaciones record;
    r_pla_reloj_01 record;
    r_pla_dias_feriados record;
    r_bitacora record;
    i integer;
    lb_procesar boolean;
    ld_work date;
begin
    lb_procesar   =   f_valida_fecha(ai_cia, current_date);
    
    select into r_pla_tipos_de_planilla * from pla_tipos_de_planilla
    where compania = ai_cia
    and tipo_de_planilla = as_tipo_de_planilla;
    if not found then
        raise exception ''Tipo de Planilla % No Existe...Verifique'',as_tipo_de_planilla;
    end if;
    
    select into r_pla_periodos * from pla_periodos
    where compania = ai_cia
    and tipo_de_planilla = as_tipo_de_planilla
    and numero_planilla = r_pla_tipos_de_planilla.planilla_actual
    and status = ''A'';
    if not found then
        raise exception ''Numero de Planilla % no Existe'',r_pla_tipos_de_planilla.planilla_actual;
    else
        if r_pla_periodos.status = ''C'' then
            raise exception ''Numero de Planilla % esta Cerrada'',r_pla_tipos_de_planilla.planilla_actual;
        end if;
    end if;

    i   =   f_activa_empleados_en_vacaciones(r_pla_periodos.id);

--                            and status in (''A'', ''V'')
--                            and fecha_terminacion_real is null

    for r_pla_empleados in select * from pla_empleados
                            where compania = ai_cia
                            and tipo_de_planilla = as_tipo_de_planilla
                            and reloj is true
                            and codigo_empleado in (''0924'')
                            order by codigo_empleado
    loop
        for r_pla_marcaciones in select pla_marcaciones.* 
                                    from pla_marcaciones, pla_tarjeta_tiempo
                                    where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
                                    and pla_tarjeta_tiempo.compania = r_pla_empleados.compania
                                    and pla_tarjeta_tiempo.codigo_empleado = r_pla_empleados.codigo_empleado
                                    and pla_tarjeta_tiempo.id_periodos = r_pla_periodos.id
                                    and f_to_date(pla_marcaciones.entrada) <= r_pla_periodos.hasta
                                    order by pla_marcaciones.id
        loop
            ld_work =   f_to_date(r_pla_marcaciones.entrada);
            
            select into r_bitacora *
            from bitacora
            where trim(tabla) = ''pla_marcaciones''
            and id_tabla = r_pla_marcaciones.id
            and trim(operacion) = ''UPDATE'';
            if found then
                continue;
            end if;
            
            select into r_pla_dias_feriados *
            from pla_dias_feriados
            where compania = r_pla_empleados.compania
            and fecha = ld_work;
            if found then
                continue;
            end if;
            if r_pla_empleados.compania = 1261 
                and extract(dow from r_pla_marcaciones.entrada) = 0 then
                update pla_marcaciones
                set status = ''L''
                where id = r_pla_marcaciones.id;
            else        
                select into r_pla_reloj_01 *
                from pla_reloj_01
                where compania = r_pla_empleados.compania
                and trim(codigo_reloj) = trim(r_pla_empleados.codigo_empleado)
                and trim(to_char(r_pla_marcaciones.entrada, ''yyyy-mm-dd'')) = trim(to_char(pla_reloj_01.fecha,''yyyy-mm-dd''));
                if not found then
                    update pla_marcaciones
                    set status = ''I''
                    where id = r_pla_marcaciones.id;
                end if;
            end if;
        end loop;
    end loop;
    
    
    
    return 1;
end;
' language plpgsql;
