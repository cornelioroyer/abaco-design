drop function f_pla_descanso_entre_turno(int4) cascade;

create function f_pla_descanso_entre_turno(int4) returns decimal as '
declare
    ai_id_pla_marcaciones alias for $1;
    r_pla_marcaciones record;
    r_pla_tarjeta_tiempo record;
    r_pla_marcaciones_2 record;
    ldc_minutos decimal;
begin
    select into r_pla_marcaciones * from pla_marcaciones
    where id = ai_id_pla_marcaciones;
    if not found then
        return 0;
    end if;
    
    select into r_pla_tarjeta_tiempo * from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    if not found then
        raise exception ''entre'';
        return 0;
    end if;
    
    for r_pla_marcaciones_2 in 
        select pla_marcaciones.*
        from pla_tarjeta_tiempo, pla_marcaciones
        where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
        and entrada < r_pla_marcaciones.entrada
        and pla_tarjeta_tiempo.codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
        and pla_tarjeta_tiempo.compania = r_pla_tarjeta_tiempo.compania
        order by pla_marcaciones.entrada desc
    loop
        ldc_minutos =   Cast(f_intervalo(r_pla_marcaciones_2.salida, r_pla_marcaciones.entrada) as decimal);
        if ldc_minutos <= 0 then
            return 9999999999.99;
        else
            return ldc_minutos / 60;
        end if;
    end loop;
    
    return 9999999999.99;
end;
' language plpgsql;

