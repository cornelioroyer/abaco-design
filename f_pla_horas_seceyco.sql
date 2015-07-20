

drop function f_pla_horas_seceyco(int4, char(7), int4) cascade;

create function f_pla_horas_seceyco(int4, char(7), int4) returns integer as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ai_id_periodos alias for $3;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_turnos record;
    r_pla_certificados_medico record;
    r_pla_permisos record;
    r_pla_marcaciones_2 record;
    r_pla_desglose_regulares record;
    r_pla_periodos record;
    r_work record;
    r_pla_incremento record;
    r_pla_horas record;
    ldt_entrada_turno timestamp;
    ldt_salida_turno timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    li_minutos_regulares int4;
    ldc_tiempo_minimo_de_descanso decimal;
    ldc_descanso decimal;
    i integer;
    li_count integer;
    li_id_marcacion_anterior int4;
    li_minutos_ampliacion int4;
    li_minutos_transporte int4;
    li_minutos_trabajados int4;
    li_work int4;
    lc_tipo_de_hora_incremento char(2);
begin
    for r_pla_marcaciones in select pla_marcaciones.*, pla_proyectos.proyecto, pla_empleados.tasa_por_hora,
                                pla_empleados.cargo
                                from pla_tarjeta_tiempo, pla_marcaciones, pla_proyectos, pla_empleados
                                where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
                                and pla_marcaciones.id_pla_proyectos = pla_proyectos.id
                                and pla_tarjeta_tiempo.compania = pla_empleados.compania
                                and pla_tarjeta_tiempo.codigo_empleado = pla_empleados.codigo_empleado
                                and pla_tarjeta_tiempo.compania = ai_cia
                                and pla_tarjeta_tiempo.codigo_empleado = as_codigo_empleado
                                and pla_tarjeta_tiempo.id_periodos = ai_id_periodos
                                and pla_proyectos.proyecto in (''GUPCA'',''GUPCP'')
                                order by pla_marcaciones.entrada
    loop

        if Date(r_pla_marcaciones.entrada) >= ''2015-01-01'' then
            lc_tipo_de_hora_incremento = ''51'';
        else
            lc_tipo_de_hora_incremento = ''51'';
        end if;
        
        li_count = 0;
        li_minutos_trabajados = 0;
        
        select into r_pla_incremento *
        from pla_incremento
        where id_pla_proyectos = r_pla_marcaciones.id_pla_proyectos
        and id_pla_cargos = r_pla_marcaciones.cargo;
        if not found then
            continue;
        end if;

        select into li_count count(*)
        from pla_horas
        where id_marcaciones = r_pla_marcaciones.id;
        if li_count is null then
            li_count = 0;
        end if;


        select into li_minutos_trabajados sum(minutos)
        from pla_horas
        where id_marcaciones = r_pla_marcaciones.id;
        if li_minutos_trabajados is null then
            li_minutos_trabajados = 0;
        end if;

        if li_count = 1 then
            select into r_pla_horas *
            from pla_horas
            where id_marcaciones = r_pla_marcaciones.id;
            
            delete from pla_horas
            where id_marcaciones = r_pla_marcaciones.id;
            
            if r_pla_marcaciones.proyecto = ''GUPCP'' then
                li_minutos_ampliacion   =   r_pla_horas.minutos - 120;
            else
                li_minutos_ampliacion   =   r_pla_horas.minutos - 180;
            end if;

            insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                tasa_por_minuto, aplicar, acumula, forma_de_registro, minutos_ampliacion)
            values (r_pla_marcaciones.id, lc_tipo_de_hora_incremento, li_minutos_ampliacion, 
                r_pla_marcaciones.tasa_por_hora/60*r_pla_incremento.recargo, ''N'', ''N'', ''A'', li_minutos_ampliacion);


            insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                tasa_por_minuto, aplicar, acumula, forma_de_registro)
            values (r_pla_marcaciones.id, r_pla_horas.tipo_de_hora, r_pla_horas.minutos - li_minutos_ampliacion, 
                r_pla_marcaciones.tasa_por_hora/60, ''N'', ''N'', ''A'');
                
        else

            if r_pla_marcaciones.proyecto = ''GUPCP'' then
                li_minutos_transporte   =   60;
            else
                li_minutos_transporte   =   90;
            end if;

            select into r_pla_horas *
            from pla_horas
            where id_marcaciones = r_pla_marcaciones.id
            and tipo_de_hora in (''00'');
            if found then

                li_minutos_ampliacion   =   r_pla_horas.minutos - li_minutos_transporte;

            
                delete from pla_horas
                where id_marcaciones = r_pla_marcaciones.id
                and tipo_de_hora in (''00'',lc_tipo_de_hora_incremento);
            
/*
                if r_pla_marcaciones.proyecto = ''GUPCP'' then
                    li_minutos_ampliacion   =   r_pla_horas.minutos - 60;
                else
                    li_minutos_ampliacion   =   r_pla_horas.minutos - 90;
                end if;
*/                

                insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                    tasa_por_minuto, aplicar, acumula, forma_de_registro)
                values (r_pla_marcaciones.id, r_pla_horas.tipo_de_hora, r_pla_horas.minutos - li_minutos_ampliacion, 
                    r_pla_marcaciones.tasa_por_hora/60, ''N'', ''N'', ''A'');

                insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                    tasa_por_minuto, aplicar, acumula, forma_de_registro, minutos_ampliacion)
                values (r_pla_marcaciones.id, lc_tipo_de_hora_incremento, li_minutos_ampliacion, 
                    r_pla_marcaciones.tasa_por_hora/60*r_pla_incremento.recargo, ''N'', ''N'', ''A'', li_minutos_ampliacion);
            end if;                

            
            for r_pla_horas in select * from pla_horas, pla_tipos_de_horas
                                where pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
                                and pla_horas.id_marcaciones = r_pla_marcaciones.id
                                and pla_tipos_de_horas.recargo > 1
                                order by pla_tipos_de_horas.recargo

            loop
                update pla_horas
                set tasa_por_minuto = tasa_por_minuto * r_pla_incremento.recargo
                where id = r_pla_horas.id;
            end loop;
            
/*            
-- para el tema del sobre tiempo.
            li_work = 0;
            select sum(minutos) into li_work
            from pla_horas, pla_tipos_de_horas
            where pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
            and pla_horas.id_marcaciones = r_pla_marcaciones.id
            and pla_horas.minutos_ampliacion is null
            and pla_tipos_de_horas.recargo > 1;
            if li_work is null then
                li_work =   0;
            end if;
            
            if li_work > 0 then
                li_minutos_ampliacion = li_work - li_minutos_transporte;
            end if;
            
            if li_minutos_ampliacion > 0 then
                li_work =   0;
                for r_pla_horas in select * from pla_horas, pla_tipos_de_horas
                                    where pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
                                    and pla_horas.id_marcaciones = r_pla_marcaciones.id
                                    and pla_horas.minutos_ampliacion is null
                                    and pla_tipos_de_horas.recargo > 1
                                    order by pla_tipos_de_horas.recargo
                loop
                    if li_minutos_ampliacion <= 0 then
                        exit;
                    end if;
                    
                    if li_minutos_ampliacion > r_pla_horas.minutos then
                        delete from pla_horas
                        where id_marcaciones = r_pla_marcaciones.id
                        and tipo_de_hora not in (''00'',''51'')
                        and tipo_de_hora = r_pla_horas.tipo_de_hora;
            
                        insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                            tasa_por_minuto, aplicar, acumula, forma_de_registro, minutos_ampliacion)
                        values (r_pla_marcaciones.id, r_pla_horas.tipo_de_hora, r_pla_horas.minutos, 
                            r_pla_marcaciones.tasa_por_hora/60*r_pla_incremento.recargo, ''N'', ''N'', ''A'', li_minutos_ampliacion);
                        
                        li_minutos_ampliacion = li_minutos_ampliacion - r_pla_horas.minutos;
                    else
                        delete from pla_horas
                        where id_marcaciones = r_pla_marcaciones.id
                        and tipo_de_hora not in (''00'',''51'')
                        and tipo_de_hora = r_pla_horas.tipo_de_hora;

/*            
                        insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                            tasa_por_minuto, aplicar, acumula, forma_de_registro, minutos_ampliacion)
                        values (r_pla_horas.id_marcaciones, ''00'', li_minutos_ampliacion, 
                            r_pla_marcaciones.tasa_por_hora/60*r_pla_incremento.recargo, ''N'', ''N'', ''A'', li_minutos_ampliacion);
*/

                        if r_pla_horas.minutos > li_minutos_ampliacion then
                            insert into pla_horas(id_marcaciones, tipo_de_hora, minutos, 
                                tasa_por_minuto, aplicar, acumula, forma_de_registro)
                            values (r_pla_marcaciones.id, r_pla_horas.tipo_de_hora, r_pla_horas.minutos - li_minutos_ampliacion, 
                                r_pla_marcaciones.tasa_por_hora/60, ''N'', ''N'', ''A'');
                        end if;                
                        exit;                        
                    end if;
                end loop;            
            end if;
*/            
        end if;    
    end loop;

    return 1;
end;
' language plpgsql;
