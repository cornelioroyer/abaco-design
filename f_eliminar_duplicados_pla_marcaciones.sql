

drop function f_eliminar_duplicados_pla_marcaciones(int4) cascade;

create function f_eliminar_duplicados_pla_marcaciones(int4) returns integer as '
declare
    ai_cia alias for $1;
    r_pla_reloj_01 record;
    r_pla_marcaciones record;
    r_work record;
    lb_primero boolean;
    lvc_codigo_reloj varchar(32);
    lts_fecha timestamp;
begin

    for r_work in select pla_tarjeta_tiempo.compania, pla_tarjeta_tiempo.codigo_empleado, 
                    pla_marcaciones.entrada, pla_marcaciones.salida, count(*)
                    from pla_tarjeta_tiempo, pla_marcaciones, pla_periodos
                    where pla_tarjeta_tiempo.id = pla_marcaciones.id_tarjeta_de_tiempo
                    and pla_tarjeta_tiempo.id_periodos = pla_periodos.id
                    and pla_tarjeta_tiempo.compania = ai_cia
                    and date(pla_marcaciones.entrada) >= ''2014-07-01''
                    group by 1, 2, 3, 4
                    having count(*) > 1
                    order by 1, 2
    loop
        for r_pla_marcaciones in select pla_marcaciones.*
                                    from pla_marcaciones, pla_tarjeta_tiempo
                                    where pla_marcaciones.id_tarjeta_de_tiempo = pla_tarjeta_tiempo.id
                                    and pla_marcaciones.entrada = r_work.entrada
                                    and pla_marcaciones.salida = r_work.salida
                                    and pla_tarjeta_tiempo.codigo_empleado = r_work.codigo_empleado
                                    and pla_tarjeta_tiempo.compania = r_work.compania
                                    order by pla_marcaciones.entrada
        loop
            delete from pla_marcaciones
            where id = r_pla_marcaciones.id;
            exit;
        end loop;
    end loop;  
    return 1;
end;
' language plpgsql;



