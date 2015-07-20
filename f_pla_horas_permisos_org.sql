drop function f_pla_horas_permisos(int4) cascade;

create function f_pla_horas_permisos(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_turnos record;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_tarjeta_tiempo record;
    r_pla_permisos record;
    r_pla_horas record;
    r_pla_tipos_de_permisos record;
    r_pla_periodos record;
    r_pla_tipos_de_horas record;
    ldt_entrada_turno timestamp;
    ldt_salida_turno timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    lts_salida_turno timestamp;
    li_minutos_regulares int4;
    li_minutos_certificados_pendientes int4;
    ls_tipo_de_hora char(2);
    li_minutos_permiso int4;
    li_min_acum int4;
    li_minutos int4;
    li_work int4;
    li_retorno integer;
begin
--
-- En esta rutina si un empleado se retira antes de su hora de salida
-- el sistema le descuenta ese tiempo.
--
-- Si el empleado justifica el tiempo que se ausento, el sistema
-- le devuelve el dinero
--
    select into r_pla_marcaciones * from pla_marcaciones
    where id = ai_id;
    if r_pla_marcaciones.status = ''I'' or r_pla_marcaciones.status = ''C'' or
        r_pla_marcaciones.turno is null then
        return 0;
    end if;
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;
    
    select into r_pla_periodos * from pla_periodos
    where id = r_pla_tarjeta_tiempo.id_periodos;
    
    
    if r_pla_marcaciones.turno is null then
        return 0;
    end if;
    
    select into r_pla_turnos * from pla_turnos
    where compania = r_pla_marcaciones.compania
    and turno = r_pla_marcaciones.turno;
    if not found then
        return 0;
    end if;
    
    lts_salida_turno    =   f_timestamp(Date(r_pla_marcaciones.salida),r_pla_turnos.hora_salida);
    
-- Para hacer todo el proceso lo primero que hace esta rutina es verificar que el empleado
-- halla salido antes de su hora reglamentaria de salida.    
    if r_pla_marcaciones.salida < lts_salida_turno then
        li_minutos_permiso = f_intervalo(r_pla_marcaciones.salida, lts_salida_turno);

-- Si el empleado no tiene ningun permiso registrado se procece a descontar este tiempo.
-- En este sentido se controla cuando son dias de domingo o dias nacionales.
-- El sistema descuenta dependiendo del tipo de dia
        select into r_pla_permisos * from pla_permisos
        where compania = r_pla_empleados.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and date(desde) = date(r_pla_marcaciones.entrada)
        and year = r_pla_periodos.year
        and numero_planilla = r_pla_periodos.numero_planilla;
        if not found then
            li_min_acum = 0;
            for r_pla_horas in select pla_horas.* from pla_horas, pla_tipos_de_horas
                                where pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
                                and pla_tipos_de_horas.sobretiempo = ''N''
                                and pla_horas.id_marcaciones = r_pla_marcaciones.id
                                order by pla_horas.id
            loop
                if r_pla_horas.minutos + li_min_acum > li_minutos_permiso then
                    li_work = li_minutos_permiso - li_min_acum;
                else
                    li_work = r_pla_horas.minutos;
                end if;
                if r_pla_horas.tipo_de_hora = ''00'' then
                    li_retorno  =   f_pla_horas(r_pla_marcaciones.id, ''75'', li_work, 
                                        r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
                else
                    li_retorno  =   f_pla_horas(r_pla_marcaciones.id, r_pla_horas.tipo_de_hora, 
                                        -li_work, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
                end if;
                li_min_acum = li_min_acum + li_work;
            end loop;                                
        else
-- Aqui entra si el empleado tiene algun permiso registrado.        
            if r_pla_permisos.desde >= r_pla_permisos.hasta then
                return 0;
            end if;
            
            select into r_pla_tipos_de_permisos * from pla_tipos_de_permisos
            where tipo_de_permiso = r_pla_permisos.tipo_de_permiso;

-- Si los minutos registrados en permisos son mayor a los minutos que tomo el empleado
-- entonces se graban los minutos que tomo.
-- Ya que por error se registro mas minutos de los que tomo.
            
            if r_pla_permisos.minutos >= li_minutos_permiso then
                li_minutos = li_minutos_permiso;
            else
                li_minutos = r_pla_permisos.minutos;
            end if;
            
            select into r_pla_tipos_de_horas * from pla_tipos_de_horas
            where tipo_de_hora = r_pla_tipos_de_permisos.tipo_de_hora;
            if r_pla_tipos_de_horas.signo = 1 then
                li_retorno = f_pla_horas(r_pla_marcaciones.id, r_pla_tipos_de_permisos.tipo_de_hora,
                                li_minutos, r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
            
            
                li_min_acum = 0;
                for r_pla_horas in select pla_horas.* from pla_horas, pla_tipos_de_horas
                                    where pla_horas.tipo_de_hora = pla_tipos_de_horas.tipo_de_hora
                                    and pla_tipos_de_horas.sobretiempo = ''N''
                                    and pla_horas.id_marcaciones = r_pla_marcaciones.id
                                    and pla_horas.tipo_de_horas <> r_pla_tipos_de_permisos.tipo_de_hora
                                    order by pla_horas.id
                loop
                    if r_pla_horas.minutos + li_min_acum > li_minutos then
                        li_work = li_minutos - li_min_acum;
                    else
                        li_work = r_pla_horas.minutos;
                    end if;
                
                    li_retorno  =   f_pla_horas(r_pla_marcaciones.id, 
                                        r_pla_horas.tipo_de_hora, -li_work, 
                                        r_pla_empleados.tasa_por_hora/60, 
                                        ''N'', ''N'');
                    
                    li_min_acum = li_min_acum + li_work;
                end loop;                                
            end if;                            
        end if;
    end if;
    return 1;
end;
' language plpgsql;
