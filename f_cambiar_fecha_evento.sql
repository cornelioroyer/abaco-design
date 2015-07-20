
drop function f_cambiar_fecha_eventos(int4) cascade;


create function f_cambiar_fecha_eventos(int4) returns integer as '
declare
    ai_cia alias for $1;
    r_pla_cuentas record;
    r_pla_cuentas_2 record;
    r_pla_cuentas_conceptos record;
    r_pla_acreedores record;
    r_pla_retenciones record;
    r_pla_retener record;
    r_tmp_chong record;
    r_pla_eventos record;
    r_work record;
    li_id int4;
    li_id_pla_cuentas int4;
    li_id_pla_cuentas_2 int4;
    ld_fecha date;
    lt_hora_entrada time;
    lt_hora_salida time;
    lt_hora_desde time;
    lt_hora_hasta time;
    lts_desde timestamp;
    lts_hasta timestamp;
begin
--                            and codigo_empleado = ''0003''

    for r_pla_eventos in select * from pla_eventos
                            where compania = ai_cia
                            and f_to_date(desde) between ''2015-06-11'' and ''2015-06-15''
                            order by codigo_empleado, desde
    loop
        lt_hora_desde     =   f_extract_time(r_pla_eventos.desde);
        lt_hora_hasta      =   f_extract_time(r_pla_eventos.hasta);
        ld_fecha    =   f_to_date(r_pla_eventos.desde);
        
        ld_fecha = ld_fecha + 5;

        loop
            select into r_work *
            from pla_eventos
            where compania = ai_cia
            and codigo_empleado = r_pla_eventos.codigo_empleado
            and f_to_date(desde) = ld_fecha;
            if not found then
                lts_desde    = f_timestamp(ld_fecha, lt_hora_desde);
                lts_hasta   = f_timestamp(ld_fecha, lt_hora_hasta);
                update pla_eventos
                set desde = lts_desde, hasta = lts_hasta
                where id = r_pla_eventos.id;
                exit;
            else
                ld_fecha = ld_fecha + 1;                
            end if;
        end loop;                
    end loop;
    
    
    
    return 1;
end;
' language plpgsql;
