
drop function f_update_pla_marcaciones_with_pla_reloj_python(int4) cascade;

create function f_update_pla_marcaciones_with_pla_reloj_python(int4) returns integer as '
declare
    ai_id alias for $1;
    r_pla_tarjeta_tiempo record;
    r_pla_marcaciones record;
    r_pla_reloj_python record;
    i integer;
    li_contador integer;
    li_cuantas_veces_marco integer;
    ld_fecha date;
    lts_entrada timestamp;
    lts_salida timestamp;
    lts_entrada_descanso timestamp;
    lts_salida_descanso timestamp;
    lc_status char(1);
begin
    select into r_pla_marcaciones *
    from pla_marcaciones
    where id = ai_id;
    if not found then
        return 0;
    end if;

    select into r_pla_tarjeta_tiempo *
    from pla_tarjeta_tiempo
    where id = r_pla_marcaciones.id_tarjeta_de_tiempo;
    if not found then
        return 0;
    end if;        

    lc_status               =   r_pla_marcaciones.status;
    lts_entrada             =   r_pla_marcaciones.entrada;
    lts_salida              =   r_pla_marcaciones.salida;
    lts_entrada_descanso    =   r_pla_marcaciones.entrada_descanso;
    lts_salida_descanso     =   r_pla_marcaciones.salida_descanso;
    ld_fecha                =   f_to_date(lts_entrada);
    li_contador             =   0;
    li_cuantas_veces_marco  =   0;
    
    select into li_cuantas_veces_marco count(*)
    from pla_reloj_python
    where compania = r_pla_tarjeta_tiempo.compania
        and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
        and f_to_date(punch_time) = ld_fecha;
    if li_cuantas_veces_marco is null or li_cuantas_veces_marco = 0 then
        return 0;
    end if;        
        

    if li_cuantas_veces_marco >= 3 then
        for r_pla_reloj_python in select * from pla_reloj_python
                                    where compania = r_pla_tarjeta_tiempo.compania
                                        and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                        and f_to_date(punch_time) = ld_fecha
                                    order by punch_time
        loop
            li_contador =   li_contador + 1;
            if r_pla_reloj_python.pla_marcaciones_id is not null then
                continue;
            end if;                
            if li_contador = 1 then
                lts_entrada =   r_pla_reloj_python.punch_time;
            elsif li_contador = 2 then
                lts_entrada_descanso =   r_pla_reloj_python.punch_time;
            elsif li_contador = 3 then
                lts_salida_descanso =   r_pla_reloj_python.punch_time;
            else            
                lts_salida =   r_pla_reloj_python.punch_time;
            end if;
        end loop;
    else
        for r_pla_reloj_python in select * from pla_reloj_python
                                    where compania = r_pla_tarjeta_tiempo.compania
                                        and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
                                        and f_to_date(punch_time) = ld_fecha
                                    order by punch_time
        loop
            li_contador =   li_contador + 1;
            if r_pla_reloj_python.pla_marcaciones_id is not null then
                continue;
            end if;                
            if li_contador = 1 then
                lts_entrada =   r_pla_reloj_python.punch_time;
            else            
                lts_salida =   r_pla_reloj_python.punch_time;
            end if;
        end loop;
    end if;
        
    if li_contador > 0 then
        if lc_status = ''I'' then
            lc_status = ''R'';
        end if;
                    
        update pla_marcaciones
        set entrada_descanso = lts_entrada_descanso, salida_descanso = lts_salida_descanso,
            salida = lts_salida, status = lc_status
        where id = ai_id;            
        
        update pla_reloj_python
        set pla_marcaciones_id = ai_id
        where compania = r_pla_tarjeta_tiempo.compania
            and codigo_empleado = r_pla_tarjeta_tiempo.codigo_empleado
            and f_to_date(punch_time) = ld_fecha;
    end if;

    return 1;
end;
' language plpgsql;

