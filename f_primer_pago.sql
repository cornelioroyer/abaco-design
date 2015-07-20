
drop function f_primer_pago(int4, char(7)) cascade;

create function f_primer_pago(int4, char(7)) returns decimal as '
declare
    ai_cia alias for $1;
    as_codigo_empleado alias for $2;
    ldc_primer_pago decimal;
    r_pla_empleados record;
    r_pla_turnos record;
    r_pla_horarios record;
    ld_hasta date;
    ld_work date;
    ld_desde date;
    li_dow integer;
    ldt_entrada timestamp;
    ldt_salida timestamp;
    ldt_entrada_descanso timestamp;
    ldt_salida_descanso timestamp;
    li_minutos_regulares int4;
    li_dias_trabajados int4;
    ldc_salario decimal;
begin
    ldc_primer_pago = 0;
    
    select into r_pla_empleados * from pla_empleados
    where compania = ai_cia
    and codigo_empleado = as_codigo_empleado;
    
    if extract(day from r_pla_empleados.fecha_inicio) = 16 or
        extract(day from r_pla_empleados.fecha_inicio) = 1 then
        return r_pla_empleados.salario_bruto;
    end if;

    if extract(day from r_pla_empleados.fecha_inicio) > 15 then
        ld_hasta = f_ultimo_dia_del_mes(r_pla_empleados.fecha_inicio);
    else
        ld_hasta = to_char(Anio(r_pla_empleados.fecha_inicio),''9999'')||''-''||trim(to_char(Mes(r_pla_empleados.fecha_inicio),''99''))||''-15'';
    end if;

    li_dias_trabajados  =   ld_hasta - r_pla_empleados.fecha_inicio;
    
    if li_dias_trabajados >= 10 and r_pla_empleados.tipo_de_planilla = ''2'' then
        if extract(day from r_pla_empleados.fecha_inicio) > 15 then
            ld_desde = to_char(Anio(r_pla_empleados.fecha_inicio),''9999'')||''-''||trim(to_char(Mes(r_pla_empleados.fecha_inicio),''99''))||''-15'';
        else
            ld_desde = to_char(Anio(r_pla_empleados.fecha_inicio),''9999'')||''-''||trim(to_char(Mes(r_pla_empleados.fecha_inicio),''99''))||''-01'';
        end if;

        ld_hasta = r_pla_empleados.fecha_inicio;

        while ld_desde < ld_hasta loop
        
            li_dow = extract(dow from ld_desde);
            select into r_pla_horarios * from pla_horarios
            where compania = ai_cia
            and codigo_empleado = r_pla_empleados.codigo_empleado
            and dia = li_dow;
            if found then
                select into r_pla_turnos * from pla_turnos
                where compania = ai_cia
                and turno = r_pla_horarios.turno;
                ldt_entrada = to_timestamp(f_concat_fecha_hora(ld_desde, r_pla_turnos.hora_inicio),''YYYY/MM/DD HH:MI'');
                if r_pla_turnos.hora_salida < r_pla_turnos.hora_inicio then
                    ldt_salida = to_timestamp(f_concat_fecha_hora(ld_desde+1, r_pla_turnos.hora_salida),''YYYY/MM/DD HH:MI'');
                else
                    ldt_salida = to_timestamp(f_concat_fecha_hora(ld_desde, r_pla_turnos.hora_salida),''YYYY/MM/DD HH:MI'');
                end if;
                if r_pla_turnos.hora_inicio_descanso is null then
                    ldt_entrada_descanso = null;
                else
                    ldt_entrada_descanso = to_timestamp(f_concat_fecha_hora(ld_desde, r_pla_turnos.hora_inicio_descanso),''YYYY/MM/DD HH:MI'');
                end if;

                if r_pla_turnos.hora_salida_descanso is null then
                    ldt_salida_descanso = null;
                else
                    ldt_salida_descanso = to_timestamp(f_concat_fecha_hora(ld_desde, r_pla_turnos.hora_salida_descanso),''YYYY/MM/DD HH:MI'');
                end if;

                li_minutos_regulares = f_intervalo(ldt_entrada,ldt_salida)
                                        - f_intervalo(ldt_entrada_descanso, ldt_salida_descanso);

                ldc_primer_pago = ldc_primer_pago + (li_minutos_regulares/60*r_pla_empleados.tasa_por_hora);
                
            end if;
            ld_desde = ld_desde + 1;
        end loop;

        ldc_salario   =   r_pla_empleados.salario_bruto - ldc_primer_pago;
        return ldc_salario;
    end if;
    
    if extract(day from r_pla_empleados.fecha_inicio) > 15 then
        ld_hasta = f_ultimo_dia_del_mes(r_pla_empleados.fecha_inicio);
    else
        ld_hasta = to_char(Anio(r_pla_empleados.fecha_inicio),''9999'')||''-''||trim(to_char(Mes(r_pla_empleados.fecha_inicio),''99''))||''-15'';
    end if;

    ld_work = r_pla_empleados.fecha_inicio;
    while ld_work <= ld_hasta loop
        li_dow = extract(dow from ld_work);
        select into r_pla_horarios * from pla_horarios
        where compania = ai_cia
        and codigo_empleado = r_pla_empleados.codigo_empleado
        and dia = li_dow;
        if found then
            select into r_pla_turnos * from pla_turnos
            where compania = ai_cia
            and turno = r_pla_horarios.turno;
        
            ldt_entrada = to_timestamp(f_concat_fecha_hora(ld_work, r_pla_turnos.hora_inicio),''YYYY/MM/DD HH:MI'');
            if r_pla_turnos.hora_salida < r_pla_turnos.hora_inicio then
                ldt_salida = to_timestamp(f_concat_fecha_hora(ld_work+1, r_pla_turnos.hora_salida),''YYYY/MM/DD HH:MI'');
            else
                ldt_salida = to_timestamp(f_concat_fecha_hora(ld_work, r_pla_turnos.hora_salida),''YYYY/MM/DD HH:MI'');
            end if;
            if r_pla_turnos.hora_inicio_descanso is null then
                ldt_entrada_descanso = null;
            else
                ldt_entrada_descanso = to_timestamp(f_concat_fecha_hora(ld_work, r_pla_turnos.hora_inicio_descanso),''YYYY/MM/DD HH:MI'');
            end if;

            if r_pla_turnos.hora_salida_descanso is null then
                ldt_salida_descanso = null;
            else
                ldt_salida_descanso = to_timestamp(f_concat_fecha_hora(ld_work, r_pla_turnos.hora_salida_descanso),''YYYY/MM/DD HH:MI'');
            end if;

            li_minutos_regulares = f_intervalo(ldt_entrada,ldt_salida)
                                    - f_intervalo(ldt_entrada_descanso, ldt_salida_descanso);

            ldc_primer_pago = ldc_primer_pago + (li_minutos_regulares/60*r_pla_empleados.tasa_por_hora);
        end if;
        ld_work = ld_work + 1;
    end loop;
    
    if ldc_primer_pago >= r_pla_empleados.salario_bruto then
        return r_pla_empleados.salario_bruto;
    else
        return ldc_primer_pago;
    end if;
end;
' language plpgsql;

