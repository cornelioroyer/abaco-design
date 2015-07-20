

drop function f_pla_horas_certificadas(int4) cascade;

create function f_pla_horas_certificadas(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_marcaciones record;
    r_pla_empleados record;
    r_pla_tarjeta_tiempo record;
    r_pla_certificados_medico record;
    r_pla_horas record;
    r_pla_turnos record;
    r_pla_periodos record;
    ldt_entrada_turno timestamp;
    ldt_salida_turno timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    ld_work date;
    li_minutos_regulares int4;
    li_minutos_certificados_pendientes int4;
    li_minutos_certificados_a_pagar int4;
    li_minutos_adicionales int4;
    li_work int4;
    li_min_acum int4;
    li_minutos_diarios int4;
    li_minutos_pagados int4;
    li_minutos_no_pagados int4;
    li_minutos_tardanza int4;
    li_retorno integer;
    ls_tipo_de_hora char(2);
    ls_tipo_de_jornada char(1);
    ldc_tasa_por_hora decimal;
    ldc_work decimal;
begin
    li_minutos_adicionales  =   0;
    
    select into r_pla_marcaciones * 
    from pla_marcaciones
    where id = ai_id;
    if not found then
        return 0;
    end if;

    ld_work = r_pla_marcaciones.entrada;
    
    update pla_marcaciones
    set status = ''R''
    where id = ai_id
    and status not in (''I'',''D'',''F'');

    delete from pla_horas
    where id_marcaciones = ai_id
    and forma_de_registro = ''A''
    and tipo_de_hora in (''30'',''93'');
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    
    select into r_pla_periodos * from pla_periodos
    where id = r_pla_tarjeta_tiempo.id_periodos;
    
    select into r_pla_empleados * from pla_empleados
    where compania = r_pla_tarjeta_tiempo.compania
    and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado;


/*
    if r_pla_marcaciones.status <> ''C'' then
        delete from pla_certificados_medico
        where compania = r_pla_empleados.compania
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and fecha = date(r_pla_marcaciones.entrada)
        and year = r_pla_periodos.year
        and numero_planilla = r_pla_periodos.numero_planilla
        and minutos >= 480;
    
        return 0;
    end if;        
*/
    
    select into r_pla_certificados_medico * 
    from pla_certificados_medico
    where compania = r_pla_empleados.compania
    and codigo_empleado = r_pla_empleados.codigo_empleado
    and fecha = date(r_pla_marcaciones.entrada)
    and year = r_pla_periodos.year
    and numero_planilla = r_pla_periodos.numero_planilla;
    if not found then
        return 0;
    else
        update pla_marcaciones
        set status = ''C''
        where id = ai_id
        and status <> ''I'';
    end if;

    li_minutos_certificados_pendientes = f_minutos_certificados_pendientes(r_pla_empleados.compania, r_pla_empleados.codigo_empleado, r_pla_certificados_medico.fecha);
    
    li_minutos_tardanza = 0;
    select sum(minutos) into li_minutos_tardanza 
    from pla_horas
    where id_marcaciones = ai_id
    and tipo_de_hora = ''21'';
    if li_minutos_tardanza is null then
        li_minutos_tardanza = 0;
    end if;
    
--
--    30 = certificados medicos pagados
--    93 = certificados medicos no pagados
--    21 = tardanza
--

    if li_minutos_certificados_pendientes <= 0 then
        update pla_certificados_medico
        set pagado = ''N''
        where compania = r_pla_certificados_medico.compania
        and codigo_empleado = r_pla_certificados_medico.codigo_empleado
        and fecha = r_pla_certificados_medico.fecha;
        
        
        if r_pla_certificados_medico.minutos <> 0 then
            li_retorno  =   f_pla_horas(r_pla_marcaciones.id, ''93'', r_pla_certificados_medico.minutos,
                                r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
        end if;
        
        return 0;
    end if;

    
--
--    30 = certificados medicos pagados
--    93 = certificados medicos no pagados
--    21 = tardanza
--

    if r_pla_certificados_medico.minutos > li_minutos_certificados_pendientes then
        li_minutos_pagados      =   li_minutos_certificados_pendientes;
        li_minutos_no_pagados   =   r_pla_certificados_medico.minutos - li_minutos_pagados;
    else
        li_minutos_pagados      =   r_pla_certificados_medico.minutos;
        li_minutos_no_pagados   =   0;
    end if;
    

    delete from pla_horas
    where id_marcaciones = ai_id
    and forma_de_registro = ''A'';

    
    li_minutos_pagados  =   li_minutos_pagados + li_minutos_adicionales;
    
--    li_minutos_pagados  =   li_minutos_pagados - li_minutos_tardanza;
    
    if (r_pla_marcaciones.status = ''R'' or r_pla_marcaciones.status = ''C'') and li_minutos_no_pagados <> 0 then
        li_retorno          =   f_pla_horas(r_pla_marcaciones.id, ''93'', li_minutos_no_pagados, 
                                    r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
    end if;
    
    if r_pla_marcaciones.turno is not null then
        select into r_pla_turnos *
        from pla_turnos
        where compania = r_pla_marcaciones.compania
        and turno = r_pla_marcaciones.turno;
        if found then
            if r_pla_turnos.tipo_de_jornada = ''N'' and li_minutos_pagados >= 420 and li_minutos_pagados <= 480 then
                li_minutos_pagados  =   li_minutos_pagados + 60;
                if li_minutos_pagados > 480 then
                    li_minutos_pagados = 480;
                end if;
            end if;
        end if;
    end if;


    li_retorno          =   f_pla_horas(r_pla_marcaciones.id, ''30'', li_minutos_pagados, 
                                r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');


/*
    li_retorno          =   f_pla_horas(r_pla_marcaciones.id, ''30'', li_minutos_pagados, 
                                r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');


    ls_tipo_de_hora     =   f_tipo_de_hora(r_pla_empleados.compania, r_pla_empleados.codigo_empleado, ld_work, r_pla_marcaciones.id);
    
    li_retorno          =   f_pla_horas(r_pla_marcaciones.id, ls_tipo_de_hora, -li_minutos_pagados, 
                                r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');

    if li_minutos_pagados >= li_minutos_tardanza then
        li_retorno  =   f_pla_horas(r_pla_marcaciones.id, ''00'', li_minutos_tardanza, 
                                r_pla_empleados.tasa_por_hora/60, ''N'', ''N'');
    end if;
*/    
    
    
    if r_pla_marcaciones.status = ''I'' then
        delete from pla_horas
        where id_marcaciones = ai_id
        and forma_de_registro = ''A''
        and tipo_de_hora in (''00'',''20'');
    end if;
                                
    update pla_certificados_medico
    set pagado = ''S''
    where compania = r_pla_certificados_medico.compania
    and codigo_empleado = r_pla_certificados_medico.codigo_empleado
    and fecha = r_pla_certificados_medico.fecha;
    
    update pla_desglose_regulares
    set certificado = certificado + li_minutos_pagados - li_minutos_no_pagados
    where id_pla_marcaciones = ai_id;
    
    return 1;
end;
' language plpgsql;
