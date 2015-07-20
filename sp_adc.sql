rollback work;
drop function f_adc_master_cxpdocm(char(2), int4, int4) cascade;
drop function f_adc_master_delete(char(2), int4, int4) cascade;
drop function f_adc_master_cglposteo(char(2), int4, int4) cascade;
drop function f_adc_master_cargo(char(2), int4, int4) cascade;
drop function f_adc_master_manejo(char(2), int4, int4) cascade;
drop function f_adc_agente(char(2), int4) cascade;
drop function f_adc_house_flete(char(2), int4, int4, int4) cascade;
drop function f_adc_house_manejo(char(2), int4, int4, int4) cascade;
drop function f_adc_master_tipo_de_carga(char(2), int4, int4) cascade;
drop function f_adc_ciudad(char(2), int4) cascade;
drop function f_adc_region(char(2), int4) cascade;
drop function f_adc_flete(char(2), int4, char(20)) cascade;
drop function f_adc_bultos_entregados(char(2), int4, int4, int4) cascade;
drop function f_adc_saldo_house(char(2), int4, int4, int4) cascade;
drop function f_adc_cliente_entrega_mercancia(char(2), int4) cascade;
drop function f_adc_master_flete(char(2), int4, int4) cascade;
--drop function f_adc_master(char(2), int4, int4, char(20)) cascade;
--drop function f_adc_house(char(2), int4, int4, int4, char(20)) cascade;
drop function f_adc_facturas_manejo(char(2), int4) cascade;
drop function f_adc_no_operacion(char(2), char(6), char(25)) cascade;
drop function f_adc_agente(char(2), int4, char(20)) cascade;
drop function f_adc_f_notificacion(char(2), int4, int4, int4) cascade;
drop function f_adc_location(char(2), int4, char(20)) cascade;
drop function f_adc_clase_carga(char(2), char(2), int4) cascade;
drop function f_adc_cxp(char(2), int4, int4, char(20)) cascade;
drop function f_adc_facturas_notas_debito(char(2), int4) cascade;
drop function f_adc_inconsistencias_cxc_cxp(char(2), int4) cascade;
drop function f_adc_valida_cuenta(char(2), int4, char(24)) cascade;
drop function f_adc_tipo_de_carga(char(2), int4) cascade;

create function f_adc_tipo_de_carga(char(2), int4) returns char(100) as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    r_adc_manifiesto record;
    r_adc_master record;
    r_fact_referencias record;
    r_clientes record;
    ls_retornar char(100);
begin
    ls_retornar = null;
    
    for r_adc_master in select * from adc_master
                        where compania = as_compania
                        and consecutivo = ai_consecutivo
                        order by linea_master
    loop
        return trim(r_adc_master.tipo);
    end loop;

    
    return ls_retornar;
end;
' language plpgsql;



create function f_adc_valida_cuenta(char(2), int4, char(24)) returns integer as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ac_cuenta alias for $3;
    r_adc_manifiesto record;
    r_fact_referencias record;
    r_adc_parametros_contables record;
    r_cglcuentas record;
    ls_ciudad varchar(100);
    lvc_cuenta varchar(100);
begin
    return 1;

    if substring(trim(ac_cuenta) from 1 for 1) = ''8'' 
        or substring(trim(ac_cuenta) from 1 for 2) = ''46'' then
        return 1;
    end if;
    
    lvc_cuenta = trim(ac_cuenta);
    
    select into r_cglcuentas *
    from cglcuentas
    where trim(cuenta) = trim(lvc_cuenta);
    if not found then
        return 0;
    else
        if r_cglcuentas.tipo_cuenta = ''B'' then
            return 0;
        end if;
    end if;
    
    select into r_adc_manifiesto * from adc_manifiesto
    where compania = as_compania
    and consecutivo = ai_consecutivo;
    
    select into r_fact_referencias * from fact_referencias
    where referencia = r_adc_manifiesto.referencia;
    
    if r_fact_referencias.tipo = ''E'' then
        ls_ciudad = trim(r_adc_manifiesto.ciudad_destino);
    else
        ls_ciudad = trim(r_adc_manifiesto.ciudad_origen);
    end if;        
    
--  raise exception ''% %'', ls_ciudad, ac_cuenta;
    
    select into r_adc_parametros_contables * 
    from adc_parametros_contables
    where referencia = r_adc_manifiesto.referencia
    and trim(ciudad) = trim(ls_ciudad)
    and (cta_ingreso = ac_cuenta
    or cta_costo = ac_cuenta
    or cta_gasto = ac_cuenta);
    
    if not found then
        Raise Exception ''Esta cuenta % no puede ser utilizada en esta transaccion'',lvc_cuenta;
    end if;
    
    
    return 1;    
end;
' language plpgsql;



create function f_adc_inconsistencias_cxc_cxp(char(2), int4) returns integer as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    r_work record;
    r_factura1 record;
    r_adc_manifiesto record;
    r_adc_cxc_1 record;
    r_adc_cxp_1 record;
    r_almacen record;
    lc_mensaje varchar(200);
begin

    select into r_adc_manifiesto *
    from adc_manifiesto
    where compania = as_compania
    and consecutivo = ai_consecutivo;
    if not found then
        return 0;
    end if;
    
    for r_adc_cxc_1 in select * from adc_cxc_1
                    where compania = as_compania
                    and consecutivo = ai_consecutivo
                    order by fecha, secuencia
    loop
        
        if Anio(r_adc_manifiesto.fecha) <> Anio(r_adc_cxc_1.fecha) or
            Mes(r_adc_manifiesto.fecha) <> Mes(r_adc_cxc_1.fecha) then
            
            lc_mensaje = ''Fecha de Ajuste CXC '' || Trim(to_char(r_adc_cxc_1.secuencia, ''99999999'')) || '' no es igual al costo '';

            insert into inconsistencias(usuario, mensaje, codigo, fecha)
            values(current_user, trim(lc_mensaje), r_adc_cxc_1.consecutivo, r_adc_manifiesto.fecha);                        
        end if;
        
    end loop;


    for r_adc_cxp_1 in select * from adc_cxp_1
                    where compania = as_compania
                    and consecutivo = ai_consecutivo
                    order by fecha, secuencia
    loop
        
        if Anio(r_adc_manifiesto.fecha) <> Anio(r_adc_cxp_1.fecha) or
            Mes(r_adc_manifiesto.fecha) <> Mes(r_adc_cxp_1.fecha) then
            
            lc_mensaje = ''Fecha de Ajuste CXP '' || Trim(to_char(r_adc_cxp_1.secuencia, ''99999999'')) || '' no es igual al costo '';

            insert into inconsistencias(usuario, mensaje, codigo, fecha)
            values(current_user, trim(lc_mensaje), r_adc_cxp_1.consecutivo, r_adc_manifiesto.fecha);                        
        end if;
        
    end loop;
    
    return 1;    
end;
' language plpgsql;



create function f_adc_facturas_notas_debito(char(2), int4) returns integer as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    r_work record;
    r_factura1 record;
    r_adc_manifiesto record;
    r_almacen record;
    lc_mensaje varchar(200);
begin

    select into r_adc_manifiesto *
    from adc_manifiesto
    where compania = as_compania
    and consecutivo = ai_consecutivo;
    if not found then
        return 0;
    end if;

    for r_work in select adc_notas_debito_1.almacen, adc_notas_debito_1.caja, adc_notas_debito_1.tipo, adc_notas_debito_1.num_documento, adc_notas_debito_1.consecutivo
                     from adc_notas_debito_1
                    where compania = as_compania
                    and consecutivo = ai_consecutivo
                    group by 1, 2, 3, 4, 5
                    order by 1, 2, 3
    loop
        insert into adc_manifiesto_contable (compania, consecutivo, cgl_consecutivo, numero_rubro, 
        rubro, usuario, no_bill, container, factura, observacion)
		select compania, ai_consecutivo, consecutivo, 5, ''INGRESOS POR NOTAS DEBITO'',
        current_user, null, null, num_documento, null
        from v_factura1_cglposteo
        where almacen = r_work.almacen
        and tipo = r_work.tipo
        and caja = r_work.caja
        and num_documento = r_work.num_documento;
        
        select into r_factura1 *
        from factura1
        where almacen = r_work.almacen
        and caja = r_work.caja
        and tipo = r_work.tipo
        and num_documento = r_work.num_documento;
        if not found then
            continue;
        end if;
        
        
        if Anio(r_adc_manifiesto.fecha) <> Anio(r_factura1.fecha_factura) or
            Mes(r_adc_manifiesto.fecha) <> Mes(r_factura1.fecha_factura) then
            
            lc_mensaje = ''Fecha de Factura '' || Trim(to_char(r_factura1.num_documento, ''999999'')) || '' de Nota Debito no es igual al costo '';

            insert into inconsistencias(usuario, mensaje, codigo, fecha)
            values(current_user, trim(lc_mensaje), r_work.consecutivo, r_adc_manifiesto.fecha);                        
        end if;
        
    end loop;
    
    return 1;    
end;
' language plpgsql;



create function f_adc_cxp(char(2), int4, int4, char(20)) returns char(100) as '
declare
    as_cia alias for $1;
    ai_consecutivo alias for $2;
    ai_secuencia alias for $3;
    as_retornar alias for $4;
    r_adc_cxp_1 record;
    r_adc_cxp_2 record;
    r_adc_house record;
    r_adc_master record;
    ls_retornar char(200);
    ldc_work decimal;
begin
    ls_retornar = null;
    
    select into r_adc_cxp_1 * from adc_cxp_1
    where adc_cxp_1.compania = as_cia
    and adc_cxp_1.consecutivo = ai_consecutivo
    and adc_cxp_1.secuencia = ai_secuencia;
    if not found then
        return ls_retornar;
    end if;
    
    if trim(as_retornar) = ''HBL'' then
        for r_adc_cxp_2 in select * from adc_cxp_2
                            where adc_cxp_2.compania = as_cia
                            and adc_cxp_2.consecutivo = ai_consecutivo
                            and adc_cxp_2.secuencia = ai_secuencia
                            and adc_cxp_2.no_house is not null
                            order by no_house
        loop
            if ls_retornar is null then
                ls_retornar = Trim(r_adc_cxp_2.no_house);
            else
                ls_retornar = trim(ls_retornar) || '', '' || trim(r_adc_cxp_2.no_house);
            end if;
        end loop;
        
    elsif trim(as_retornar) = ''MBL'' then
        for r_adc_cxp_2 in select * from adc_cxp_2
                            where adc_cxp_2.compania = as_cia
                            and adc_cxp_2.consecutivo = ai_consecutivo
                            and adc_cxp_2.secuencia = ai_secuencia
                            and adc_cxp_2.no_house is not null
                            order by no_house
        loop
            for r_adc_house in select * from adc_house
                                where adc_house.compania = as_cia
                                and adc_house.consecutivo = ai_consecutivo
                                and adc_house.no_house = r_adc_cxp_2.no_house
                                order by linea_house
            loop
                select into r_adc_master * from adc_master
                where compania = r_adc_house.compania
                and consecutivo = r_adc_house.consecutivo
                and linea_master = r_adc_house.linea_master;
                if found then
                    if ls_retornar is null then
                        ls_retornar = Trim(r_adc_master.no_bill);
                    else
                        ls_retornar = trim(ls_retornar) || '', '' || trim(r_adc_master.no_bill);
                    end if;
                end if;
            end loop;
        end loop;
        
    elsif trim(as_retornar) = ''CONTENEDOR'' then
        for r_adc_cxp_2 in select * from adc_cxp_2
                            where adc_cxp_2.compania = as_cia
                            and adc_cxp_2.consecutivo = ai_consecutivo
                            and adc_cxp_2.secuencia = ai_secuencia
                            and adc_cxp_2.no_house is not null
                            order by no_house
        loop
            for r_adc_house in select * from adc_house
                                where adc_house.compania = as_cia
                                and adc_house.consecutivo = ai_consecutivo
                                and adc_house.no_house = r_adc_cxp_2.no_house
                                order by linea_house
            loop
                select into r_adc_master * from adc_master
                where compania = r_adc_house.compania
                and consecutivo = r_adc_house.consecutivo
                and linea_master = r_adc_house.linea_master;
                if found then
                    if ls_retornar is null then
                        ls_retornar = substring(Trim(r_adc_master.container) from 1 for 99);
                    else
                        ls_retornar = trim(ls_retornar) || '', '' || trim(r_adc_master.container);
                    end if;
                end if;
            end loop;
        end loop;
        
    elsif trim(as_retornar) = ''BULTOS'' then
        ldc_work = 0;
        for r_adc_cxp_2 in select * from adc_cxp_2
                            where adc_cxp_2.compania = as_cia
                            and adc_cxp_2.consecutivo = ai_consecutivo
                            and adc_cxp_2.secuencia = ai_secuencia
                            and adc_cxp_2.no_house is not null
                            order by no_house
        loop
            for r_adc_house in select * from adc_house
                                where adc_house.compania = as_cia
                                and adc_house.consecutivo = ai_consecutivo
                                and adc_house.no_house = r_adc_cxp_2.no_house
                                order by linea_house
            loop
                ldc_work = ldc_work + r_adc_house.pkgs;
            end loop;
        end loop;
        ls_retornar = Trim(to_char(ldc_work, ''9,999,999.999999''));    
    
    elsif trim(as_retornar) = ''PESO'' then
        ldc_work = 0;
        for r_adc_cxp_2 in select * from adc_cxp_2
                            where adc_cxp_2.compania = as_cia
                            and adc_cxp_2.consecutivo = ai_consecutivo
                            and adc_cxp_2.secuencia = ai_secuencia
                            and adc_cxp_2.no_house is not null
                            order by no_house
        loop
            for r_adc_house in select * from adc_house
                                where adc_house.compania = as_cia
                                and adc_house.consecutivo = ai_consecutivo
                                and adc_house.no_house = r_adc_cxp_2.no_house
                                order by linea_house
            loop
                ldc_work = ldc_work + r_adc_house.kgs;
            end loop;
        end loop;
        ls_retornar = Trim(to_char(ldc_work, ''9,999,999.999999''));    
    
    elsif trim(as_retornar) = ''NOMBRE_CLIENTE'' then
        for r_adc_cxp_2 in select * from adc_cxp_2
                            where adc_cxp_2.compania = as_cia
                            and adc_cxp_2.consecutivo = ai_consecutivo
                            and adc_cxp_2.secuencia = ai_secuencia
                            and adc_cxp_2.no_house is not null
                            order by no_house
        loop
            for r_adc_house in select * from adc_house
                                where adc_house.compania = as_cia
                                and adc_house.consecutivo = ai_consecutivo
                                and adc_house.no_house = r_adc_cxp_2.no_house
                                order by linea_house
            loop
                select into ls_retornar clientes.nomb_cliente
                from clientes
                where cliente = r_adc_house.cliente;
                if found then
                    return ls_retornar;
                end if;
            end loop;
        end loop;
        
    elsif trim(as_retornar) = ''CODIGO_CLIENTE'' then
        for r_adc_cxp_2 in select * from adc_cxp_2
                            where adc_cxp_2.compania = as_cia
                            and adc_cxp_2.consecutivo = ai_consecutivo
                            and adc_cxp_2.secuencia = ai_secuencia
                            and adc_cxp_2.no_house is not null
                            order by no_house
        loop
            for r_adc_house in select * from adc_house
                                where adc_house.compania = as_cia
                                and adc_house.consecutivo = ai_consecutivo
                                and adc_house.no_house = r_adc_cxp_2.no_house
                                order by linea_house
            loop
                select into ls_retornar clientes.cliente
                from clientes
                where cliente = r_adc_house.cliente;
                if found then
                    return substring(Trim(ls_retornar) from 1 for 99);
                end if;
            end loop;
        end loop;
        
    elsif trim(as_retornar) = ''EMBARCADOR'' then
        for r_adc_cxp_2 in select * from adc_cxp_2
                            where adc_cxp_2.compania = as_cia
                            and adc_cxp_2.consecutivo = ai_consecutivo
                            and adc_cxp_2.secuencia = ai_secuencia
                            and adc_cxp_2.no_house is not null
                            order by no_house
        loop
            for r_adc_house in select * from adc_house
                                where adc_house.compania = as_cia
                                and adc_house.consecutivo = ai_consecutivo
                                and adc_house.no_house = r_adc_cxp_2.no_house
                                order by linea_house
            loop
                return substring(trim(r_adc_house.embarcador) from 1 for 99);
            end loop;
        end loop;
        
    elsif trim(as_retornar) = ''CARPETA'' then
        for r_adc_cxp_2 in select * from adc_cxp_2
                            where adc_cxp_2.compania = as_cia
                            and adc_cxp_2.consecutivo = ai_consecutivo
                            and adc_cxp_2.secuencia = ai_secuencia
                            and adc_cxp_2.no_house is not null
                            order by no_house
        loop
            for r_adc_house in select * from adc_house
                                where adc_house.compania = as_cia
                                and adc_house.consecutivo = ai_consecutivo
                                and adc_house.no_house = r_adc_cxp_2.no_house
                                order by linea_house
            loop
                select into ls_retornar adc_manifiesto.operacion
                from adc_manifiesto
                where compania = r_adc_house.compania
                and consecutivo = r_adc_house.consecutivo;
                if found then
                    return substring(trim(ls_retornar) from 1 for 99);
                end if;
            end loop;
        end loop;
        
    end if;
    return substring(Trim(ls_retornar) from 1 for 99);
end;
' language plpgsql;


create function f_adc_clase_carga(char(2), char(2), int4) returns char(100) as '
declare
    as_almacen alias for $1;
    as_tipo alias for $2;
    ai_num_documento alias for $3;
    r_adc_master record;
    r_adc_house_factura1 record;
    r_adc_tipo_de_contenedor record;
    ls_retornar char(100);
begin
    ls_retornar = null;
    
    for r_adc_house_factura1 in select * from adc_house_factura1
                    where almacen = as_almacen
                    and tipo = as_tipo
                    and num_documento = ai_num_documento
    loop
        for r_adc_master in select * from adc_master
                                where compania = r_adc_house_factura1.compania
                                and consecutivo = r_adc_house_factura1.consecutivo
                                and linea_master = r_adc_house_factura1.linea_master
        loop
            select into r_adc_tipo_de_contenedor *
            from adc_tipo_de_contenedor
            where tipo = r_adc_master.tipo;
            if found then
                ls_retornar = r_adc_tipo_de_contenedor.clase;
            end if;
        end loop;
    end loop;
    
    
    return ls_retornar;
end;
' language plpgsql;



create function f_adc_location(char(2), int4, char(20)) returns char(100) as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    as_retornar alias for $3;
    r_adc_manifiesto record;
    r_fact_referencias record;
    r_clientes record;
    ls_retornar char(100);
begin
    ls_retornar = null;

    select into r_adc_manifiesto adc_manifiesto.*
    from adc_manifiesto
    where adc_manifiesto.compania = as_compania
    and adc_manifiesto.consecutivo = ai_consecutivo;
    if not found then
        return ls_retornar;
    end if;

    select into r_fact_referencias *
    from fact_referencias
    where referencia = r_adc_manifiesto.referencia;
    if not found then
        return ls_retornar;
    end if;

    
    if trim(as_retornar) = ''CIUDAD'' then
        if r_fact_referencias.tipo = ''I'' then
            select into ls_retornar nombre
            from fac_ciudades
            where ciudad = r_adc_manifiesto.ciudad_origen;
        else
            select into ls_retornar nombre
            from fac_ciudades
            where ciudad = r_adc_manifiesto.ciudad_destino;
        end if;
        
    elsif trim(as_retornar) = ''REGION'' then
        if r_fact_referencias.tipo = ''I'' then
            select into ls_retornar fac_regiones.nombre
            from fac_ciudades, fac_paises, fac_regiones
            where fac_ciudades.pais = fac_paises.pais
            and fac_paises.region = fac_regiones.region
            and fac_ciudades.ciudad = r_adc_manifiesto.ciudad_origen;
        else
            select into ls_retornar fac_regiones.nombre
            from fac_ciudades, fac_paises, fac_regiones
            where fac_ciudades.pais = fac_paises.pais
            and fac_paises.region = fac_regiones.region
            and fac_ciudades.ciudad = r_adc_manifiesto.ciudad_destino;
        end if;
    else
        if r_fact_referencias.tipo = ''I'' then
            select into ls_retornar fac_paises.nombre
            from fac_ciudades, fac_paises, fac_regiones
            where fac_ciudades.pais = fac_paises.pais
            and fac_paises.region = fac_regiones.region
            and fac_ciudades.ciudad = r_adc_manifiesto.ciudad_origen;
        else
            select into ls_retornar fac_paises.nombre
            from fac_ciudades, fac_paises, fac_regiones
            where fac_ciudades.pais = fac_paises.pais
            and fac_paises.region = fac_regiones.region
            and fac_ciudades.ciudad = r_adc_manifiesto.ciudad_destino;
        end if;
    end if;    
    
    return ls_retornar;
end;
' language plpgsql;



create function f_adc_f_notificacion(char(2), int4, int4, int4) returns date as '
declare
    as_cia alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ai_linea_house alias for $4;
    r_adc_house record;
    r_adc_manifiesto record;
begin
    select into r_adc_house * from adc_house
    where compania = as_cia
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and linea_house = ai_linea_house;
    if not found then
        return current_date;
    end if;
    
    select into r_adc_manifiesto * from adc_manifiesto
    where compania = as_cia
    and consecutivo = ai_consecutivo;
    if not found then
        return current_date;
    end if;
    
    if r_adc_manifiesto.confirmado = ''S'' then
        if r_adc_house.f_aviso_final is null then
            return current_date;
        else
            return r_adc_house.f_aviso_final;
        end if;
    else
        if r_adc_house.f_preaviso is null then
            return current_date;
        else
            return r_adc_house.f_preaviso;
        end if;
    end if;
    
    return current_date;
end;
' language plpgsql;



create function f_adc_agente(char(2), int4, char(20)) returns char(100) as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    as_retornar alias for $3;
    r_adc_manifiesto record;
    r_fact_referencias record;
    r_clientes record;
    ls_retornar char(100);
begin
    ls_retornar = null;
    select into r_adc_manifiesto *
    from adc_manifiesto
    where compania = as_compania
    and consecutivo = ai_consecutivo;
    if not found then
        return ls_retornar;
    end if;
    
    select into r_fact_referencias *
    from fact_referencias
    where referencia = r_adc_manifiesto.referencia;
    if not found then
        return ls_retornar;
    end if;
    
    if r_fact_referencias.tipo = ''I'' then
        if trim(as_retornar) = ''CONTACTO'' then
            select into ls_retornar direccion3
            from clientes
            where cliente = r_adc_manifiesto.from_agent;
        elsif trim(as_retornar) = ''MAIL'' then
            select into ls_retornar mail
            from clientes
            where cliente = r_adc_manifiesto.from_agent;
        elsif trim(as_retornar) = ''FECHA_APERTURA'' then
            select into ls_retornar fecha_apertura
            from clientes
            where cliente = r_adc_manifiesto.from_agent;
        elsif trim(as_retornar) = ''CODIGO'' then
            ls_retornar = r_adc_manifiesto.from_agent;
        else
            select into ls_retornar nomb_cliente 
            from clientes
            where cliente = r_adc_manifiesto.from_agent;
        end if;
        
    else
        if trim(as_retornar) = ''CONTACTO'' then
            select into ls_retornar direccion3
            from clientes
            where cliente = r_adc_manifiesto.to_agent;
        elsif trim(as_retornar) = ''MAIL'' then
            select into ls_retornar mail
            from clientes
            where cliente = r_adc_manifiesto.to_agent;
        elsif trim(as_retornar) = ''FECHA_APERTURA'' then
            select into ls_retornar fecha_apertura
            from clientes
            where cliente = r_adc_manifiesto.to_agent;
        elsif trim(as_retornar) = ''CODIGO'' then
            ls_retornar = r_adc_manifiesto.to_agent;
        else
            select into ls_retornar nomb_cliente
            from clientes
            where cliente = r_adc_manifiesto.to_agent;
        end if;
    end if;
    
    return ls_retornar;
end;
' language plpgsql;



create function f_adc_no_operacion(char(2), char(6), char(25)) returns char(20) as '
declare
    as_compania alias for $1;
    as_proveedor alias for $2;
    as_container alias for $3;
    lc_no_operacion char(20);
    r_work record;
begin
    lc_no_operacion =   null;
    
    for r_work in select adc_manifiesto.operacion, adc_manifiesto.fecha
                    from adc_manifiesto, adc_master, navieras
                    where adc_manifiesto.compania = adc_master.compania
                    and adc_manifiesto.consecutivo = adc_master.consecutivo
                    and adc_manifiesto.cod_naviera = navieras.cod_naviera
                    and navieras.proveedor = as_proveedor
                    and adc_manifiesto.compania = as_compania
                    and trim(adc_master.container) = as_container
                    order by 2 desc
    loop
        lc_no_operacion =   r_work.operacion;
        exit;
    end loop;
    
    
    return Trim(lc_no_operacion);
end;
' language plpgsql;




create function f_adc_facturas_manejo(char(2), int4) returns integer as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    r_work record;
    r_factura1 record;
    r_adc_manifiesto record;
    r_almacen record;
    lc_mensaje varchar(200);
begin
    for r_work in select adc_manejo_factura1.almacen, adc_manejo_factura1.caja, adc_manejo_factura1.tipo, 
                            adc_manejo_factura1.num_documento
                     from adc_manejo_factura1
                    where compania = as_compania
                    and consecutivo = ai_consecutivo
                    group by 1, 2, 3, 4
                    order by 1, 2, 3, 4
    loop
        insert into adc_manifiesto_contable (compania, consecutivo, cgl_consecutivo, numero_rubro, 
        rubro, usuario, no_bill, container, factura, observacion)
		select compania, ai_consecutivo, consecutivo, 3, ''INGRESOS POR MANEJO'',
        current_user, null, null, num_documento, null
        from v_factura1_cglposteo
        where almacen = r_work.almacen
        and tipo = r_work.tipo
        and caja = r_work.caja
        and num_documento = r_work.num_documento;

        select into r_adc_manifiesto *
        from adc_manifiesto
        where compania = as_compania
        and consecutivo = ai_consecutivo;
        if not found then
            continue;
        end if;
    
        select into r_factura1 *
        from factura1
        where almacen = r_work.almacen
        and tipo = r_work.tipo
        and caja = r_work.caja
        and num_documento = r_work.num_documento;
        if not found then
            continue;
        end if;
    
        if Anio(r_adc_factura1.fecha_factura) <> Anio(r_adc_manifiesto.fecha)
            or Mes(r_adc_factura1.fecha_factura) <> Mes(r_adc_factura1.fecha_factura) then

            lc_mensaje = ''Fecha de Factura de Manejo'' || Trim(to_char(r_factura1.num_documento, ''(999999'')) || '' no es igual al costo '';

            insert into inconsistencias(usuario, mensaje, codigo, fecha)
            values(current_user, trim(lc_mensaje), ai_consecutivo, r_adc_manifiesto.fecha);                        
    
        end if;
        
    end loop;
    
    
             
    return 1;    
end;
' language plpgsql;



/*
create function f_adc_ingresos_manifiesto(char(2), int4, char(20)) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    as_retornar alias for $3;
begin
    ldc_work_manejo =   0;
    ldc_work_flete  =   0;
    for r_work in select adc_manejo_factura1.almacen, adc_manejo_factura1.tipo,
                    adc_manejo_factura1.num_documento
                  from adc_manejo_factura1
                  where adc_manejo_factura1.compania = as_compania
                    and adc_manejo_factura1.consecutivo = ai_consecutivo
                  group by 1, 2, 3
                  order by 1, 2, 3
    loop
        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo, cglcuentas
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento
        and cglposteo.cuenta between ''4600'' and ''4610'';
        if ldc_work is null then
            ldc_work = 0;
        end if;
        
        ldc_work_manejo =   ldc_work_manejo + ldc_work;
        
        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo, cglcuentas
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento;
        if ldc_work is null then
            ldc_work = 0;
        end if;
        
        ldc_work_flete      =   ldc_work_flete + ldc_work;
    end loop;    
    ldc_flete   =   ldc_flete + ldc_work_flete - ldc_work_manejo;
    ldc_manejo  =   ldc_manejo + ldc_work_manejo;
    

    ldc_work_flete  =   0;
    ldc_work_manejo =   0;    
    for r_work in 
        select adc_house_factura1.almacen, adc_house_factura1.tipo, 
                adc_house_factura1.num_documento
        from adc_house_factura1
        where compania = as_compania
        and consecutivo = ai_consecutivo
        group by 1, 2, 3
    loop
        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo, cglcuentas
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento
        and cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R'';
        if ldc_work is null then
            ldc_work = 0;
        end if;
        ldc_work_flete  =   ldc_work_flete + ldc_work;
        
       
        
        select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento
        and cglposteo.cuenta between ''4600'' and ''4610'';
        if ldc_work is null then
            ldc_work = 0;
        end if;
        ldc_work_manejo =   ldc_work_manejo + ldc_work;
    end loop;
    ldc_flete   =   ldc_flete + ldc_work_flete - ldc_work_manejo;
    ldc_manejo  =   ldc_manejo + ldc_work_manejo;
    
    
    if trim(as_retornar) = ''FLETE'' then
        ldc_retorno =   ldc_flete;
    else
        ldc_retorno =   ldc_manejo;
    end if;
    
    return ldc_retorno;

end;
' language plpgsql;


create function f_adc_master(char(2), int4, char(20)) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    as_retornar alias for $3;
begin
    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglposteo, rela_adc_cxc_1_cglposteo, cglcuentas
    where cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_cxc_1_cglposteo.cgl_consecutivo
    and rela_adc_cxc_1_cglposteo.compania = as_compania
    and rela_adc_cxc_1_cglposteo.consecutivo = ai_consecutivo;
    if ldc_work is null then
        ldc_work = 0;
    end if;
    ldc_flete   =   ldc_flete + ldc_work;

    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglposteo, rela_adc_cxc_1_cglposteo, cglcuentas
    where cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_cxc_1_cglposteo.cgl_consecutivo
    and rela_adc_cxc_1_cglposteo.compania = as_compania
    and rela_adc_cxc_1_cglposteo.consecutivo = ai_consecutivo
    and cglposteo.cuenta between ''4600'' and ''4610'';
    if ldc_work is null then
        ldc_work = 0;
    end if;
    ldc_manejo  =   ldc_manejo + ldc_work;
    ldc_flete   =   ldc_flete - ldc_work;
    
    
    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglposteo, rela_adc_cxp_1_cglposteo, cglcuentas
    where cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_cxp_1_cglposteo.cgl_consecutivo
    and rela_adc_cxp_1_cglposteo.compania = as_compania
    and rela_adc_cxp_1_cglposteo.consecutivo = ai_consecutivo;
    if ldc_work is null then
        ldc_work = 0;
    end if;
    ldc_flete   =   ldc_flete + ldc_work;

    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglposteo, rela_adc_cxp_1_cglposteo, cglcuentas
    where cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_cxp_1_cglposteo.cgl_consecutivo
    and rela_adc_cxp_1_cglposteo.compania = as_compania
    and rela_adc_cxp_1_cglposteo.consecutivo = ai_consecutivo
    and cglposteo.cuenta between ''4600'' and ''4610'';
    if ldc_work is null then
        ldc_work = 0;
    end if;
    ldc_manejo  =   ldc_manejo + ldc_work;
    ldc_flete   =   ldc_flete - ldc_work;
    
    if trim(as_retornar) = ''FLETE'' then
        ldc_retorno =   ldc_flete;
    else
        ldc_retorno =   ldc_manejo;
    end if;
    
    return ldc_retorno;
end;
' language plpgsql;
    
create function f_adc_ajustes(char(2), int4, char(20)) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    as_retornar alias for $3;
begin
    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglposteo, rela_adc_cxc_1_cglposteo, cglcuentas
    where cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_cxc_1_cglposteo.cgl_consecutivo
    and rela_adc_cxc_1_cglposteo.compania = as_compania
    and rela_adc_cxc_1_cglposteo.consecutivo = ai_consecutivo;
    if ldc_work is null then
        ldc_work = 0;
    end if;
    ldc_flete   =   ldc_flete + ldc_work;

    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglposteo, rela_adc_cxc_1_cglposteo, cglcuentas
    where cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_cxc_1_cglposteo.cgl_consecutivo
    and rela_adc_cxc_1_cglposteo.compania = as_compania
    and rela_adc_cxc_1_cglposteo.consecutivo = ai_consecutivo
    and cglposteo.cuenta between ''4600'' and ''4610'';
    if ldc_work is null then
        ldc_work = 0;
    end if;
    ldc_manejo  =   ldc_manejo + ldc_work;
    ldc_flete   =   ldc_flete - ldc_work;
    
    
    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglposteo, rela_adc_cxp_1_cglposteo, cglcuentas
    where cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_cxp_1_cglposteo.cgl_consecutivo
    and rela_adc_cxp_1_cglposteo.compania = as_compania
    and rela_adc_cxp_1_cglposteo.consecutivo = ai_consecutivo;
    if ldc_work is null then
        ldc_work = 0;
    end if;
    ldc_flete   =   ldc_flete + ldc_work;

    select into ldc_work -sum(cglposteo.debito-cglposteo.credito)
    from cglposteo, rela_adc_cxp_1_cglposteo, cglcuentas
    where cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and cglposteo.consecutivo = rela_adc_cxp_1_cglposteo.cgl_consecutivo
    and rela_adc_cxp_1_cglposteo.compania = as_compania
    and rela_adc_cxp_1_cglposteo.consecutivo = ai_consecutivo
    and cglposteo.cuenta between ''4600'' and ''4610'';
    if ldc_work is null then
        ldc_work = 0;
    end if;
    ldc_manejo  =   ldc_manejo + ldc_work;
    ldc_flete   =   ldc_flete - ldc_work;
    
    if trim(as_retornar) = ''FLETE'' then
        ldc_retorno =   ldc_flete;
    else
        ldc_retorno =   ldc_manejo;
    end if;
    
    return ldc_retorno;
end;
' language plpgsql;
*/    




/*
create function f_adc_master(char(2), int4, int4, char(20)) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    as_retornar alias for $4;
    r_adc_master record;
    r_work record;
    li_masters integer;
    ldc_costos decimal;
    ldc_ingresos decimal;
    ldc_manejos decimal;
    ldc_manejos_flete decimal;
    ldc_work decimal;
    ldc_adc_cxc_flete decimal;
    ldc_adc_cxc_manejo decimal;
    ldc_adc_cxp_flete decimal;
    ldc_adc_cxp_manejo decimal;
    ldc_cargo decimal;
    ldc_dthc decimal;
    ldc_gtos_d_origen decimal;
    ldc_flete decimal;
begin
    select into r_adc_master * from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        return 0;
    end if;
    
    ldc_adc_cxc_flete = 0;
    ldc_adc_cxp_flete = 0;
    ldc_adc_cxc_manejo = 0;
    ldc_adc_cxp_manejo = 0;
    select count(*) into li_masters 
    from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo;
    
    ldc_manejos_flete = 0;
    for r_work in select adc_manejo_factura1.almacen, adc_manejo_factura1.tipo,
                    adc_manejo_factura1.num_documento
                  from adc_manejo_factura1
                  where adc_manejo_factura1.compania = as_compania
                    and adc_manejo_factura1.consecutivo = ai_consecutivo
                    and adc_manejo_factura1.linea_master = ai_linea_master
                  group by 1, 2, 3
                  order by 1, 2, 3
    loop
        select into ldc_work -sum(debito-credito)
        from v_factura1_cglposteo
        where (cuenta like ''4%'' or cuenta like ''9%'')
        and almacen = r_work.almacen
        and tipo = r_work.tipo
        and num_documento = r_work.num_documento;
        
        if ldc_work is null then
            ldc_work = 0;
        end if;
        
        ldc_manejos_flete = ldc_manejos_flete + ldc_work;
    end loop;
    
    ldc_manejos = 0;
    for r_work in select adc_manejo_factura1.almacen, adc_manejo_factura1.tipo,
                    adc_manejo_factura1.num_documento
                  from adc_manejo_factura1
                  where adc_manejo_factura1.compania = as_compania
                    and adc_manejo_factura1.consecutivo = ai_consecutivo
                    and adc_manejo_factura1.linea_master = ai_linea_master
                  group by 1, 2, 3
                  order by 1, 2, 3
    loop
        select into ldc_work -sum(debito-credito)
        from v_factura1_cglposteo
        where cuenta between ''4600'' and ''4610''
        and almacen = r_work.almacen
        and tipo = r_work.tipo
        and num_documento = r_work.num_documento;
        
        if ldc_work is null then
            ldc_work = 0;
        end if;
        
        ldc_manejos = ldc_manejos + ldc_work;
    end loop;
    
    select into ldc_adc_cxc_manejo -sum(cglposteo.debito-cglposteo.credito)
    from rela_adc_cxc_1_cglposteo, cglposteo
    where rela_adc_cxc_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
    and cglposteo.cuenta between ''4600'' and ''4610''
    and rela_adc_cxc_1_cglposteo.compania = as_compania
    and rela_adc_cxc_1_cglposteo.consecutivo = ai_consecutivo;

    select into ldc_adc_cxp_manejo -sum(cglposteo.debito-cglposteo.credito)
    from rela_adc_cxp_1_cglposteo, cglposteo
    where rela_adc_cxp_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
    and cglposteo.cuenta between ''4600'' and ''4610''
    and rela_adc_cxp_1_cglposteo.compania = as_compania
    and rela_adc_cxp_1_cglposteo.consecutivo = ai_consecutivo;
    
    if ldc_adc_cxc_manejo is null then
        ldc_adc_cxc_manejo = 0;
    end if;
    
    if ldc_adc_cxp_manejo is null then
        ldc_adc_cxp_manejo = 0;
    end if;
    
    if ldc_manejos is null then
        ldc_manejos = 0;
    end if;
    
    ldc_work    =   (ldc_adc_cxc_manejo + ldc_adc_cxp_manejo) / li_masters;
    ldc_manejos =   ldc_manejos + ldc_work;

    select into ldc_costos sum(cglposteo.debito-cglposteo.credito)
    from rela_adc_master_cglposteo, cglposteo, cglcuentas
    where rela_adc_master_cglposteo.cgl_consecutivo = cglposteo.consecutivo
    and cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and rela_adc_master_cglposteo.compania = as_compania
    and rela_adc_master_cglposteo.consecutivo = ai_consecutivo
    and rela_adc_master_cglposteo.linea_master = ai_linea_master;

    select into ldc_cargo sum(cargo) from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and cargo_prepago = ''N'';
            
    select into ldc_dthc sum(dthc) from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and dthc_prepago = ''N'';
    

    select into ldc_gtos_d_origen sum(gtos_d_origen) from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and gtos_prepago = ''N'';
    
    select into ldc_adc_cxc_flete -sum(cglposteo.debito-cglposteo.credito)
    from rela_adc_cxc_1_cglposteo, cglposteo
    where rela_adc_cxc_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
    and (cglposteo.cuenta like ''4%'' or cglposteo.cuenta like ''9%'')
    and rela_adc_cxc_1_cglposteo.compania = as_compania
    and rela_adc_cxc_1_cglposteo.consecutivo = ai_consecutivo;


    select into ldc_adc_cxp_flete -sum(cglposteo.debito-cglposteo.credito)
    from rela_adc_cxp_1_cglposteo, cglposteo
    where rela_adc_cxp_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
    and (cglposteo.cuenta like ''4%'' or cglposteo.cuenta like ''9%'')
    and rela_adc_cxp_1_cglposteo.compania = as_compania
    and rela_adc_cxp_1_cglposteo.consecutivo = ai_consecutivo;


    if ldc_adc_cxc_flete is null then
        ldc_adc_cxc_flete = 0;
    end if;
    
    if ldc_adc_cxc_manejo is null then
        ldc_adc_cxc_manejo = 0;
    end if;
    
    if ldc_adc_cxp_flete is null then
        ldc_adc_cxp_flete = 0;
    end if;
    
    if ldc_adc_cxp_manejo is null then
        ldc_adc_cxp_manejo = 0;
    end if;
    
    if ldc_gtos_d_origen is null then
        ldc_gtos_d_origen = 0;
    end if;
    ldc_work    =   (ldc_adc_cxc_flete + ldc_adc_cxp_flete )/li_masters;
    ldc_work    =   ldc_gtos_d_origen + ldc_cargo + ldc_dthc - ldc_costos + ldc_work;
    ldc_flete   =   ldc_work + ldc_manejos_flete;
    
    if trim(as_retornar) = ''FLETE'' then
        return ldc_flete - ldc_manejos;    
    else
        return ldc_manejos;
    end if;
    
end;
' language plpgsql;
*/

create function f_adc_master_flete(char(2), int4, int4) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ldc_ingreso decimal(10,2);
    ldc_cargos decimal(10,2);
    ldc_cargos_totales decimal(10,2);
    ldc_ajustes_cxc decimal;
    ldc_ajustes_cxp decimal;
    ldc_retorno decimal;
    r_adc_master record;
    r_adc_house record;
begin
    select into r_adc_master * from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        return 0;
    end if;
    
    if r_adc_master.dthc_prepago is null then
        r_adc_master.dthc_prepago = ''N'';
    end if;
    
    if r_adc_master.dthc is null then
        r_adc_master.dthc = 0;
    end if;


    ldc_ingreso = 0;    
    for r_adc_house in select adc_house.* from adc_house
                        where compania = as_compania
                        and consecutivo = ai_consecutivo
                        and linea_master = ai_linea_master
    loop
        if r_adc_house.cargo is null then
            r_adc_house.cargo = 0;
        end if;
        
        if r_adc_house.gtos_d_origen is null then
            r_adc_house.gtos_d_origen = 0;
        end if;
        
        if r_adc_house.dthc is null then
            r_adc_house.dthc = 0;
        end if;
        
        ldc_ingreso = ldc_ingreso + r_adc_house.cargo + r_adc_house.gtos_d_origen + r_adc_house.dthc;
    end loop;        
    
    select into ldc_ajustes_cxc sum(cxcmotivos.signo*adc_cxc_1.monto)
    from adc_cxc_1, cxcmotivos
    where adc_cxc_1.motivo_cxc = cxcmotivos.motivo_cxc
    and adc_cxc_1.compania = as_compania
    and adc_cxc_1.consecutivo = ai_consecutivo;
    
    
    if ldc_ajustes_cxc is null then
        ldc_ajustes_cxc = 0;
    end if;
    
    select into ldc_ajustes_cxp sum(cxpmotivos.signo*adc_cxp_1.monto)
    from adc_cxp_1, cxpmotivos
    where adc_cxp_1.motivo_cxp = cxpmotivos.motivo_cxp
    and adc_cxp_1.compania = as_compania
    and adc_cxp_1.consecutivo = ai_consecutivo;
    
    if ldc_ajustes_cxp is null then
        ldc_ajustes_cxp = 0;
    end if;
    
    
    select into ldc_cargos_totales sum(cargo+gtos_d_origen+gtos_destino+dthc)
    from adc_master
    where adc_master.compania = as_compania
    and adc_master.consecutivo = ai_consecutivo;

    ldc_cargos  =   r_adc_master.cargo - r_adc_master.gtos_d_origen - r_adc_master.gtos_destino + r_adc_master.dthc;
    
    if ldc_cargos_totales <> 0 then
        ldc_ajustes_cxc =   (ldc_cargos/ldc_cargos_totales)*ldc_ajustes_cxc;
        ldc_ajustes_cxp =   (ldc_cargos/ldc_cargos_totales)*ldc_ajustes_cxp;
    end if;
    
    ldc_retorno =   ldc_ingreso - ldc_cargos + ldc_ajustes_cxc - ldc_ajustes_cxp;
    if ldc_retorno is null then
        ldc_retorno = 0;
    end if;
    
    return ldc_retorno;
end;
' language plpgsql;



create function f_adc_cliente_entrega_mercancia(char(2), int4) returns char(10) as '
declare
    as_compania alias for $1;
    ai_sec_entrega alias for $2;
    r_factura1 record;
    r_adc_facturas_recibos record;
    ls_retorno char(10);
begin
    for r_adc_facturas_recibos in select * from adc_facturas_recibos
                                where compania = as_compania
                                and sec_entrega = ai_sec_entrega
    loop
        select into r_factura1 * from factura1
        where almacen = r_adc_facturas_recibos.fac_almacen
        and tipo = r_adc_facturas_recibos.tipo
        and num_documento = r_adc_facturas_recibos.num_documento;
        if found then
            return r_factura1.cliente;
        end if;
    end loop;
    
    return ls_retorno;
end;
' language plpgsql;
    

create function f_adc_saldo_house(char(2), int4, int4, int4) returns decimal as '
declare
    as_cia alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ai_linea_house alias for $4;
    r_adc_house_factura1 record;
begin
    return 0;
    for r_adc_house_factura1 in select * from adc_house_factura1, factmotivos
                                where compania = as_compania
                                    and consecutivo = ai_consecutivo
                                    and linea_master = ai_linea_master
                                    and linea_house = ai_linea_house
    loop
    
    end loop;
    
    
    
    return 0;
end;
' language plpgsql;



create function f_adc_bultos_entregados(char(2), int4, int4, int4) returns int4 as '
declare
    as_cia alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ai_linea_house alias for $4;
    r_adc_house record;
    li_bultos int4;
begin
    select into r_adc_house * from adc_house
    where compania = as_cia
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and linea_house = ai_linea_house;
    if not found then
        return 0;
    end if;
    
    select into li_bultos sum(adc_entrega_mercancia.bultos)
    from adc_entrega_mercancia
    where compania = as_cia
    and trim(no_house) = trim(r_adc_house.no_house);
    
    if li_bultos is null then
        li_bultos = 0;
    end if;
    
    return li_bultos;
end;
' language plpgsql;



create function f_adc_flete(char(2), int4, char(20)) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    as_retorno alias for $3;
    ldc_flete decimal;
    ldc_manejo decimal;
    ldc_flete2 decimal;
    ldc_manejo2 decimal;
    r_work record;
begin
    ldc_flete = 0;
    ldc_manejo = 0;


    select into ldc_flete sum(monto)
    from v_adc_verificador_contable
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and (cuenta like ''4%'' or cuenta like ''9%'');
    
    select into ldc_manejo sum(monto)
    from v_adc_verificador_contable
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and cuenta between ''4600'' and ''4610'';
    
    if ldc_flete is null then
        ldc_flete = 0;
    end if;
    
    if ldc_manejo is null then
        ldc_manejo = 0;
    end if;
    
    for r_work in 
        select adc_manejo_factura1.almacen, adc_manejo_factura1.tipo, 
                adc_manejo_factura1.num_documento
        from adc_manejo_factura1
        where compania = as_compania
        and consecutivo = ai_consecutivo
        group by 1, 2, 3
    loop
        select into ldc_flete2 -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento
        and (cglposteo.cuenta like ''4%'' or cglposteo.cuenta like ''9%'');
        
        select into ldc_manejo2 -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento
        and cglposteo.cuenta between ''4600'' and ''4610'';
        
        if ldc_flete2 is null then
            ldc_flete2 = 0;
        end if;
        
        if ldc_manejo2 is null then
            ldc_manejo2 = 0;
        end if;
        
        ldc_flete = ldc_flete + ldc_flete2;
        ldc_manejo = ldc_manejo + ldc_manejo2;
        
    end loop;
    
    
    for r_work in 
        select adc_house_factura1.almacen, adc_house_factura1.tipo, 
                adc_house_factura1.num_documento
        from adc_house_factura1
        where compania = as_compania
        and consecutivo = ai_consecutivo
        group by 1, 2, 3
    loop
        select into ldc_flete2 -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento
        and (cglposteo.cuenta like ''4%'' or cglposteo.cuenta like ''9%'');
        
        select into ldc_manejo2 -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento
        and cglposteo.cuenta between ''4600'' and ''4610'';
        
        if ldc_flete2 is null then
            ldc_flete2 = 0;
        end if;
        
        if ldc_manejo2 is null then
            ldc_manejo2 = 0;
        end if;
        
        ldc_flete = ldc_flete + ldc_flete2;
        ldc_manejo = ldc_manejo + ldc_manejo2;
        
    end loop;
    


    if trim(as_retorno) = ''FLETE'' then
        return ldc_flete - ldc_manejo;
    else
        return ldc_manejo;
    end if;
end;
' language plpgsql;



create function f_adc_region(char(2), int4) returns char(100) as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    r_adc_manifiesto record;
    r_fact_referencias record;
    r_clientes record;
    ls_retornar char(100);
begin
    ls_retornar = null;
    select into r_adc_manifiesto adc_manifiesto.*
    from adc_manifiesto
    where adc_manifiesto.compania = as_compania
    and adc_manifiesto.consecutivo = ai_consecutivo;
    if not found then
        return ls_retornar;
    end if;
    
    select into r_fact_referencias *
    from fact_referencias
    where referencia = r_adc_manifiesto.referencia;
    if not found then
        return ls_retornar;
    end if;

    if r_fact_referencias.tipo = ''I'' then
        select into ls_retornar fac_regiones.nombre
        from fac_ciudades, fac_paises, fac_regiones
        where fac_ciudades.pais = fac_paises.pais
        and fac_paises.region = fac_regiones.region
        and fac_ciudades.ciudad = r_adc_manifiesto.ciudad_origen;
    else
        select into ls_retornar fac_regiones.nombre
        from fac_ciudades, fac_paises, fac_regiones
        where fac_ciudades.pais = fac_paises.pais
        and fac_paises.region = fac_regiones.region
        and fac_ciudades.ciudad = r_adc_manifiesto.ciudad_destino;
    end if;
    
    return ls_retornar;
end;
' language plpgsql;



create function f_adc_ciudad(char(2), int4) returns char(100) as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    r_adc_manifiesto record;
    r_fact_referencias record;
    r_clientes record;
    ls_retornar char(100);
begin
    ls_retornar = null;
    select into r_adc_manifiesto adc_manifiesto.*
    from adc_manifiesto
    where adc_manifiesto.compania = as_compania
    and adc_manifiesto.consecutivo = ai_consecutivo;
    if not found then
        return ls_retornar;
    end if;
    
    select into r_fact_referencias *
    from fact_referencias
    where referencia = r_adc_manifiesto.referencia;
    if not found then
        return ls_retornar;
    end if;

    if r_fact_referencias.tipo = ''I'' then
        select into ls_retornar nombre
        from fac_ciudades
        where ciudad = r_adc_manifiesto.ciudad_origen;
    else
        select into ls_retornar nombre
        from fac_ciudades
        where ciudad = r_adc_manifiesto.ciudad_destino;
    end if;
    
    return ls_retornar;
end;
' language plpgsql;


create function f_adc_master_tipo_de_carga(char(2), int4, int4) returns char(20) as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    r_adc_master record;
    r_adc_house record;
    ls_tipo_de_carga char(20);
begin
    select into r_adc_master * from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        return 0;
    end if;
    
    ls_tipo_de_carga = ''NORMAL'';
    for r_adc_house in select * from adc_house
                        where compania = as_compania
                                and consecutivo = ai_consecutivo
                                and linea_master = ai_linea_master
                                order by linea_house
    loop
        if r_adc_house.tipo = ''3'' then
            ls_tipo_de_carga = ''TRIANGULAR'';
        elsif r_adc_house.tipo = ''2'' then
                ls_tipo_de_carga = ''TRANSITO'';
        else
                ls_tipo_de_carga = ''NORMAL'';
        end if;
    end loop;
    return ls_tipo_de_carga;
end;
' language plpgsql;


create function f_adc_house_manejo(char(2), int4, int4, int4) returns decimal as '
declare
    as_cia alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ai_linea_house alias for $4;
    ldc_manejo decimal;
begin
    select into ldc_manejo sum(cargo) from adc_manejo
    where compania = as_cia
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and linea_house = ai_linea_house;
    if not found then
        return 0;
    end if;
    
    if ldc_manejo is null then
        return 0;
    end if;
    
    return ldc_manejo;
end;
' language plpgsql;


create function f_adc_house_flete(char(2), int4, int4, int4) returns decimal as '
declare
    as_cia alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ai_linea_house alias for $4;
    r_adc_house record;
    r_adc_master record;
    r_adc_manifiesto record;
    ldc_ingresos decimal;
    ldc_ingreso_house decimal;
    ldc_flete decimal;
    ldc_cargos decimal;
begin
    select into r_adc_manifiesto * from adc_manifiesto
    where compania = as_cia
    and consecutivo = ai_consecutivo;
    if not found then
        return 0;
    end if;
  
    select into r_adc_master * from adc_master
    where compania = as_cia
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        return 0;
    end if;

    select into r_adc_house * from adc_house
    where compania = as_cia
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and linea_house = ai_linea_house;
    if not found then
        return 0;
    end if;
    
    if r_adc_house.dthc is null then
        r_adc_house.dthc = 0;
    end if;
    
    if r_adc_master.dthc is null then
        r_adc_master.dthc = 0;
    end if;
    
    ldc_cargos          =   r_adc_master.cargo + r_adc_master.gtos_d_origen + r_adc_master.gtos_destino + r_adc_master.dthc;
    
    select into ldc_ingresos sum(cargo+gtos_d_origen+dthc) 
    from adc_house
    where compania = as_cia
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if ldc_ingresos is null or ldc_ingresos = 0 then
        return ldc_cargos;
    end if;

    ldc_ingreso_house   =   r_adc_house.cargo + r_adc_house.gtos_d_origen + r_adc_house.dthc;
    ldc_flete           =   ldc_cargos * (ldc_ingreso_house/ldc_ingresos);
    
    if ldc_flete is null then
        ldc_flete = 0;
    end if;
    
    if r_adc_manifiesto.divisor is null or r_adc_manifiesto.divisor = 0 then
        r_adc_manifiesto.divisor = 1;
    end if;
    
    return (ldc_ingreso_house - ldc_flete) / r_adc_manifiesto.divisor;
end;
' language plpgsql;



create function f_adc_agente(char(2), int4) returns char(100) as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    r_adc_manifiesto record;
    r_fact_referencias record;
    r_clientes record;
    ls_retornar char(100);
begin
    ls_retornar = null;
    select into r_adc_manifiesto *
    from adc_manifiesto
    where compania = as_compania
    and consecutivo = ai_consecutivo;
    if not found then
        return ls_retornar;
    end if;
    
    select into r_fact_referencias *
    from fact_referencias
    where referencia = r_adc_manifiesto.referencia;
    if not found then
        return ls_retornar;
    end if;
    
    if r_fact_referencias.tipo = ''I'' then
        select into ls_retornar nomb_cliente 
        from clientes
        where cliente = r_adc_manifiesto.from_agent;
    else
        select into ls_retornar nomb_cliente
        from clientes
        where cliente = r_adc_manifiesto.to_agent;
    end if;
    
    return ls_retornar;
end;
' language plpgsql;



create function f_adc_master_manejo(char(2), int4, int4) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ldc_manejo decimal;
begin
    select into ldc_manejo sum(cargo) from adc_manejo
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        return 0;
    end if;
    
    if ldc_manejo is null then
        ldc_manejo = 0;
    end if;
    return ldc_manejo;
end;
' language plpgsql;


create function f_adc_master_cargo(char(2), int4, int4) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    r_adc_master record;
    ldc_retorno decimal;
    ldc_cargo decimal;
    ldc_dthc decimal;
    ldc_gtos_d_origen decimal;
begin
    select into r_adc_master * from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        return 0;
    end if;
    
    if r_adc_master.dthc_prepago is null then
        r_adc_master.dthc_prepago = ''N'';
    end if;
    
    if r_adc_master.dthc is null then
        r_adc_master.dthc = 0;
    end if;
        
    if r_adc_master.dthc_prepago = ''N'' then
        ldc_dthc = r_adc_master.dthc;
    else
        ldc_dthc = 0;
    end if;
    
    if r_adc_master.cargo_prepago = ''N'' then
        ldc_cargo = r_adc_master.cargo;
    else
        ldc_cargo = 0;
    end if;
    
    if  r_adc_master.gtos_prepago = ''N'' then
        ldc_gtos_d_origen = r_adc_master.gtos_d_origen;
    else
        ldc_gtos_d_origen = 0;
    end if;
    
    return ldc_dthc + ldc_cargo + ldc_gtos_d_origen + r_adc_master.gtos_destino;
end;
' language plpgsql;







create function f_adc_master_cglposteo(char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    r_adc_master record;
    r_adc_manifiesto record;
    r_navieras record;
    r_adc_parametros_contables record;
    r_fact_referencias record;
    r_cxpmotivos record;
    r_cxpdocm record;
    r_cglcuentas record;
    r_proveedores record;
    ls_ciudad char(10);
    ls_agente char(10);
    ls_aux1 char(10);
    ls_observacion text;
    li_consecutivo int4;
    ldc_cargo decimal;
    ldc_dthc decimal;
    ldc_gtos_d_origen decimal;
begin
    select into r_adc_master * from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        return 0;
    end if;
    
    if r_adc_master.dthc_prepago is null then
        r_adc_master.dthc_prepago = ''N'';
    end if;
    
    if r_adc_master.dthc is null then
        r_adc_master.dthc = 0;
    end if;
    
    
    select into r_adc_manifiesto * from adc_manifiesto
    where compania = as_compania
    and consecutivo = ai_consecutivo;

    
    select into r_navieras * from navieras
    where cod_naviera = r_adc_manifiesto.cod_naviera;
    
    select into r_proveedores * from proveedores
    where proveedor = r_navieras.proveedor;
    
    select into r_fact_referencias * from fact_referencias
    where referencia = r_adc_manifiesto.referencia;
    
    if r_fact_referencias.tipo = ''E'' then
        ls_ciudad := r_adc_manifiesto.ciudad_destino;
        ls_agente := r_adc_manifiesto.to_agent;
    else
        ls_ciudad := r_adc_manifiesto.ciudad_origen;
        ls_agente := r_adc_manifiesto.from_agent;
    end if;        
    
    select into r_adc_parametros_contables * from adc_parametros_contables
    where referencia = r_adc_manifiesto.referencia
    and trim(ciudad) = trim(ls_ciudad);
    if not found then
        Raise Exception ''Manifiesto % no tiene afectacion contable definida...Verifique'', ai_consecutivo;
    end if;
    
    select into r_cxpmotivos * from cxpmotivos
    where factura = ''S'';
    if not found then
        Raise Exception ''Motivo de Factura no existe en cxpmotivos...Verifique'';
    end if;
    
    select into r_cglcuentas * from cglcuentas
    where cuenta = r_adc_parametros_contables.cta_costo
    and auxiliar_1 = ''S'';
    if found then
        ls_aux1 := ls_agente;
    else
        ls_aux1 := null;
    end if;        
        
    ls_observacion := ''LOTE: '' || trim(r_adc_manifiesto.no_referencia) || ''  MASTER: '' || trim(r_adc_master.no_bill) || ''  /  '' || trim(r_adc_master.container);
    

    delete from rela_adc_master_cglposteo
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    
    select into r_cglcuentas * from cglcuentas
    where cuenta = r_adc_parametros_contables.cta_costo
    and auxiliar_1 = ''S'';
    if found then
        ls_aux1 := ls_agente;
    else
        ls_aux1 := null;
    end if;


    ldc_cargo = 0;    
    ldc_dthc = 0;
    ldc_gtos_d_origen = 0;
    if r_adc_master.cargo_prepago = ''N'' then
        ldc_cargo = r_adc_master.cargo;
    end if;    
    
    if r_adc_master.gtos_prepago = ''N'' then
        ldc_gtos_d_origen = r_adc_master.gtos_d_origen;
    end if;
    
    if r_adc_master.dthc_prepago = ''N'' then
        ldc_dthc = r_adc_master.dthc;
    end if;
    
    if r_adc_master.gtos_destino <> 0 then
        li_consecutivo := f_cglposteo(as_compania, ''CXP'', r_adc_manifiesto.fecha,
                                r_adc_parametros_contables.cta_costo, ls_aux1, null,
                                r_cxpmotivos.tipo_comp, trim(ls_observacion),
                                r_adc_master.gtos_destino);
        if li_consecutivo > 0 then
            insert into rela_adc_master_cglposteo (compania, consecutivo, linea_master, cgl_consecutivo)
            values (as_compania, ai_consecutivo, ai_linea_master, li_consecutivo);
        end if;
    end if;
    
    if ldc_cargo <> 0 then
        li_consecutivo := f_cglposteo(as_compania, ''CXP'', r_adc_manifiesto.fecha,
                                r_adc_parametros_contables.cta_costo, ls_aux1, null,
                                r_cxpmotivos.tipo_comp, trim(ls_observacion), ldc_cargo);
        if li_consecutivo > 0 then
            insert into rela_adc_master_cglposteo (compania, consecutivo, linea_master, cgl_consecutivo)
            values (as_compania, ai_consecutivo, ai_linea_master, li_consecutivo);
        end if;
    end if;
    
    if ldc_dthc <> 0 then
        li_consecutivo := f_cglposteo(as_compania, ''CXP'', r_adc_manifiesto.fecha,
                                r_adc_parametros_contables.cta_costo, ls_aux1, null,
                                r_cxpmotivos.tipo_comp, trim(ls_observacion), ldc_dthc);
        if li_consecutivo > 0 then
            insert into rela_adc_master_cglposteo (compania, consecutivo, linea_master, cgl_consecutivo)
            values (as_compania, ai_consecutivo, ai_linea_master, li_consecutivo);
        end if;
    end if;
    
    if ldc_gtos_d_origen <> 0 then
        li_consecutivo := f_cglposteo(as_compania, ''CXP'', r_adc_manifiesto.fecha,
                                r_adc_parametros_contables.cta_costo, ls_aux1, null,
                                r_cxpmotivos.tipo_comp, trim(ls_observacion), ldc_gtos_d_origen);
        if li_consecutivo > 0 then
            insert into rela_adc_master_cglposteo (compania, consecutivo, linea_master, cgl_consecutivo)
            values (as_compania, ai_consecutivo, ai_linea_master, li_consecutivo);
        end if;
    end if;


    li_consecutivo := f_cglposteo(as_compania, ''CXP'', r_adc_manifiesto.fecha,
                            r_proveedores.cuenta, null, null,
                            r_cxpmotivos.tipo_comp, trim(ls_observacion),
                            -(ldc_cargo + ldc_dthc + ldc_gtos_d_origen + r_adc_master.gtos_destino));
    if li_consecutivo > 0 then
        insert into rela_adc_master_cglposteo (compania, consecutivo, linea_master, cgl_consecutivo)
        values (as_compania, ai_consecutivo, ai_linea_master, li_consecutivo);
    end if;
    
    return 1;
end;
' language plpgsql;


create function f_adc_master_delete(char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    r_adc_master record;
    r_adc_manifiesto record;
    r_navieras record;
    r_adc_parametros_contables record;
    r_cxpmotivos record;
    r_cxpdocm record;
    r_cglcuentas record;
    r_proveedores record;
begin
    select into r_adc_master * from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        return 0;
    end if;
    
    select into r_adc_manifiesto * from adc_manifiesto
    where compania = as_compania
    and consecutivo = ai_consecutivo;

    select into r_navieras * from navieras
    where cod_naviera = r_adc_manifiesto.cod_naviera;
    
    select into r_proveedores * from proveedores
    where proveedor = r_navieras.proveedor;
    
    select into r_cxpmotivos * from cxpmotivos
    where factura = ''S'';
    if not found then
        Raise Exception ''Motivo de Factura no existe en cxpmotivos...Verifique'';
    end if;
    
    select into r_cxpdocm * from cxpdocm
    where compania = as_compania
    and proveedor = r_navieras.proveedor
    and trim(docmto_aplicar) = trim(r_adc_master.container)
    and trim(docmto_aplicar_ref) = trim(r_adc_master.container)
    and motivo_cxp_ref = r_cxpmotivos.motivo_cxp
    and trim(documento) <> trim(docmto_aplicar);
    if found then
--        Raise Exception ''Container % tiene movimientos aplicando a ella no se puede modificar'', r_adc_master.container;
        return 0;
    end if;

    delete from cxpdocm
    where trim(compania) = trim(as_compania)
    and trim(proveedor) = trim(r_navieras.proveedor)
    and trim(docmto_aplicar) = trim(r_adc_master.container)
    and trim(docmto_aplicar_ref) = trim(r_adc_master.container)
    and trim(motivo_cxp_ref) = trim(r_cxpmotivos.motivo_cxp);
    
    return 1;
end;
' language plpgsql;



create function f_adc_master_cxpdocm(char(2), int4, int4) returns integer as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    r_adc_master record;
    r_adc_manifiesto record;
    r_navieras record;
    r_adc_parametros_contables record;
    r_fact_referencias record;
    r_cxpmotivos record;
    r_cxpdocm record;
    r_cglcuentas record;
    r_proveedores record;
    ls_ciudad char(10);
    ls_agente char(10);
    ls_aux1 char(10);
    ls_observacion text;
    li_consecutivo int4;
    ldc_cargo decimal;
    ldc_monto decimal;
    ldc_gtos_d_origen decimal;
    ldc_dthc decimal;
begin
    select into r_adc_master * from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        return 0;
    end if;
    
    if r_adc_master.dthc_prepago is null then
        r_adc_master.dthc_prepago = ''N'';
    end if;
    
    if r_adc_master.dthc is null then
        r_adc_master.dthc = 0;
    end if;
    
    select into r_adc_manifiesto * from adc_manifiesto
    where compania = as_compania
    and consecutivo = ai_consecutivo;

    
    select into r_navieras * from navieras
    where cod_naviera = r_adc_manifiesto.cod_naviera;
    
    select into r_proveedores * from proveedores
    where proveedor = r_navieras.proveedor;
    
    select into r_fact_referencias * from fact_referencias
    where referencia = r_adc_manifiesto.referencia;
    
    select into r_cxpmotivos * from cxpmotivos
    where factura = ''S'';
    if not found then
        Raise Exception ''Motivo de Factura no existe en cxpmotivos...Verifique'';
    end if;
    
    ls_observacion := trim(r_adc_master.no_bill) || '' / '' || trim(r_adc_manifiesto.no_referencia);
    
    select into r_cxpdocm * from cxpdocm
    where compania = as_compania
    and proveedor = r_navieras.proveedor
    and trim(docmto_aplicar) = trim(r_adc_master.container)
    and trim(docmto_aplicar_ref) = trim(r_adc_master.container)
    and motivo_cxp_ref = r_cxpmotivos.motivo_cxp
    and trim(documento) <> trim(docmto_aplicar);
    if found then
        Raise Exception ''Container % tiene movimientos aplicando a ella no se puede modificar'', r_adc_master.container;
    end if;
    
    ldc_cargo = 0;
    ldc_gtos_d_origen = 0;
    ldc_monto = 0;
    ldc_dthc = 0;
    if r_adc_master.cargo_prepago = ''S'' then
        ldc_cargo = 0;
    else
        ldc_cargo = r_adc_master.cargo;
    end if;
    
    if r_adc_master.gtos_prepago = ''S'' then
        ldc_gtos_d_origen = 0;
    else
        ldc_gtos_d_origen = r_adc_master.gtos_d_origen;
    end if;
    
    if r_adc_master.dthc_prepago = ''S'' then
        ldc_dthc = 0;
    else
        ldc_dthc = r_adc_master.dthc;
    end if;
    
    ldc_monto = ldc_cargo + ldc_gtos_d_origen + r_adc_master.gtos_destino + ldc_dthc;
    if ldc_monto = 0 then
        return 0;
    end if;
    
    select into r_cxpdocm * from cxpdocm
    where trim(compania) = trim(as_compania)
    and trim(proveedor) = trim(r_navieras.proveedor)
    and trim(docmto_aplicar) = trim(r_adc_master.container)
    and trim(docmto_aplicar_ref) = trim(r_adc_master.container)
    and trim(motivo_cxp_ref) = trim(r_cxpmotivos.motivo_cxp);
    if not found then
        insert into cxpdocm (compania, proveedor, documento, docmto_aplicar, motivo_cxp,
            docmto_aplicar_ref, motivo_cxp_ref, fecha_docmto, fecha_vmto, fecha_posteo,
            fecha_cancelo, fecha_captura, usuario, status, obs_docmto, referencia,
            uso_interno, aplicacion_origen, monto)
        values (as_compania, r_navieras.proveedor, trim(r_adc_master.container), trim(r_adc_master.container),
            r_cxpmotivos.motivo_cxp, trim(r_adc_master.container), r_cxpmotivos.motivo_cxp,
            r_adc_manifiesto.fecha, r_adc_manifiesto.fecha, r_adc_manifiesto.fecha, r_adc_manifiesto.fecha,
            current_timestamp, current_user, ''P'', trim(ls_observacion), trim(r_adc_manifiesto.no_referencia),
            ''N'', ''CXP'', ldc_monto);
    else
        update cxpdocm
        set proveedor = r_navieras.proveedor,
            documento = trim(r_adc_master.container),
            docmto_aplicar = trim(r_adc_master.container),
            docmto_aplicar_ref = trim(r_adc_master.container),
            fecha_posteo = r_adc_manifiesto.fecha,
            obs_docmto = trim(ls_observacion),
            referencia = trim(r_adc_manifiesto.no_referencia),
            monto = monto + ldc_monto
        where trim(compania) = trim(as_compania)
        and trim(proveedor) = trim(r_navieras.proveedor)
        and trim(docmto_aplicar) = trim(r_adc_master.container)
        and trim(docmto_aplicar_ref) = trim(r_adc_master.container)
        and trim(motivo_cxp_ref) = trim(r_cxpmotivos.motivo_cxp);
    end if;
    
    return 1;
end;
' language plpgsql;






/*
create function f_adc_house(char(2), int4, int4, int4, char(20)) returns decimal as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ai_linea_master alias for $3;
    ai_linea_house alias for $4;
    as_retornar alias for $5;
    r_adc_house record;
    r_adc_master record;
    r_adc_manifiesto record;
    r_work record;
    ldc_ingresos_house decimal;
    ldc_retorno decimal;
    ldc_total_ingresos decimal;
    ldc_porcentaje_costos decimal;
    ldc_costos decimal;
    ldc_cxc decimal;
    ldc_cxc_manejo decimal;
    ldc_cxp decimal;
    ldc_cxp_manejo decimal;
    ldc_manejo_flete decimal;
    ldc_manejo decimal;
    ldc_work_manejo decimal;
    ldc_work_flete decimal;
    ldc_work decimal;
    ldc_cargo_total decimal;
    ldc_cargo decimal;
    ldc_dthc_total decimal;
    ldc_dthc decimal;
    ldc_gtos_d_origen decimal;
    ldc_gtos_d_origen_total decimal;
    ldc_ingresos_lote decimal;
    ldc_porcentaje_lote decimal;
    ldc_dthc_lote decimal;
    ldc_gtos_d_origen_lote decimal;
    ldc_cargo_lote decimal;
begin
    select into r_adc_manifiesto * from adc_manifiesto
    where compania = as_compania
    and consecutivo = ai_consecutivo;
    if not found then
        return 0;
    end if;
  
    select into r_adc_master * from adc_master
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master;
    if not found then
        return 0;
    end if;

    select into r_adc_house * from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and linea_house = ai_linea_house;
    if not found then
        return 0;
    end if;
    
    select into ldc_cargo_lote sum(cargo) from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and cargo_prepago = ''N'';
    if ldc_cargo_lote is null then
        ldc_cargo_lote = 0;
    end if;

    select into ldc_gtos_d_origen_lote sum(gtos_d_origen) from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and gtos_prepago = ''N'';
    if ldc_gtos_d_origen_lote is null then
        ldc_gtos_d_origen_lote = 0;
    end if;

    select into ldc_dthc_lote sum(dthc) from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and dthc_prepago = ''N'';
    if ldc_dthc_lote is null then
        ldc_dthc_lote = 0;
    end if;
    
    ldc_ingresos_lote   =   ldc_dthc_lote + ldc_gtos_d_origen_lote + ldc_cargo_lote;
    
    select into ldc_cargo_total sum(cargo) from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and cargo_prepago = ''N'';
    if ldc_cargo_total is null then
        ldc_cargo_total = 0;
    end if;

    select into ldc_gtos_d_origen_total sum(gtos_d_origen) from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and gtos_prepago = ''N'';
    if ldc_gtos_d_origen_total is null then
        ldc_gtos_d_origen_total = 0;
    end if;

    select into ldc_dthc_total sum(dthc) from adc_house
    where compania = as_compania
    and consecutivo = ai_consecutivo
    and linea_master = ai_linea_master
    and dthc_prepago = ''N'';
    if ldc_dthc_total is null then
        ldc_dthc_total = 0;
    end if;

    ldc_total_ingresos = ldc_dthc_total + ldc_gtos_d_origen_total + ldc_cargo_total;
    
    if r_adc_house.cargo_prepago = ''N'' then
        ldc_cargo = r_adc_house.cargo;
    else
        ldc_cargo = 0;
    end if;
    
    if r_adc_house.gtos_prepago = ''N'' then
        ldc_gtos_d_origen = r_adc_house.gtos_d_origen;
    else
        ldc_gtos_d_origen = 0;
    end if;
    
    if r_adc_house.dthc_prepago = ''N'' then
        ldc_dthc = r_adc_house.dthc;
    else
        ldc_dthc = 0;
    end if;
    
    ldc_ingresos_house  =   ldc_cargo + ldc_gtos_d_origen + ldc_dthc;

    if ldc_total_ingresos <> 0 then
        ldc_porcentaje_costos = ldc_ingresos_house / ldc_total_ingresos;
    else
        ldc_porcentaje_costos = 0;
    end if;
    
    if ldc_ingresos_lote <> 0 then
        ldc_porcentaje_lote = ldc_ingresos_house / -ldc_ingresos_lote;
    else
        ldc_porcentaje_lote = 0;
    end if;
    
    select into ldc_costos -sum(cglposteo.debito-cglposteo.credito)
    from rela_adc_master_cglposteo, cglposteo, cglcuentas
    where rela_adc_master_cglposteo.cgl_consecutivo = cglposteo.consecutivo
    and cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and rela_adc_master_cglposteo.compania = as_compania
    and rela_adc_master_cglposteo.consecutivo = ai_consecutivo
    and rela_adc_master_cglposteo.linea_master = ai_linea_master;
    if ldc_costos is null then
        ldc_costos = 0;
    end if;
    ldc_costos = ldc_costos * ldc_porcentaje_costos;
    
    select into ldc_cxc_manejo -sum(cglposteo.debito-cglposteo.credito)
    from rela_adc_cxc_1_cglposteo, cglposteo, cglcuentas
    where rela_adc_cxc_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
    and cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and rela_adc_cxc_1_cglposteo.compania = as_compania
    and rela_adc_cxc_1_cglposteo.consecutivo = ai_consecutivo
    and cglposteo.cuenta between ''4600'' and ''4610'';
    if ldc_cxc_manejo is null then
        ldc_cxc_manejo = 0;
    end if;
    
    select into ldc_cxp_manejo -sum(cglposteo.debito-cglposteo.credito)
    from rela_adc_cxp_1_cglposteo, cglposteo, cglcuentas
    where rela_adc_cxp_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
    and cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and rela_adc_cxp_1_cglposteo.compania = as_compania
    and rela_adc_cxp_1_cglposteo.consecutivo = ai_consecutivo
    and cglposteo.cuenta between ''4600'' and ''4610'';
    if ldc_cxp_manejo is null then
        ldc_cxp_manejo = 0;
    end if;
    
    select into ldc_cxc -sum(cglposteo.debito-cglposteo.credito)
    from rela_adc_cxc_1_cglposteo, cglposteo, cglcuentas
    where rela_adc_cxc_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
    and cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and rela_adc_cxc_1_cglposteo.compania = as_compania
    and rela_adc_cxc_1_cglposteo.consecutivo = ai_consecutivo;
    if ldc_cxc is null then
        ldc_cxc = 0;
    end if;
    ldc_cxc =   ldc_cxc - ldc_cxc_manejo;
    ldc_cxc =   ldc_cxc * ldc_porcentaje_lote;

    
    select into ldc_cxp -sum(cglposteo.debito-cglposteo.credito)
    from rela_adc_cxp_1_cglposteo, cglposteo, cglcuentas
    where rela_adc_cxp_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
    and cglposteo.cuenta = cglcuentas.cuenta
    and cglcuentas.tipo_cuenta = ''R''
    and rela_adc_cxp_1_cglposteo.compania = as_compania
    and rela_adc_cxp_1_cglposteo.consecutivo = ai_consecutivo;
    if ldc_cxp is null then
        ldc_cxp = 0;
    end if;
    ldc_cxp =   ldc_cxp - ldc_cxp_manejo;
    ldc_cxp =   ldc_cxp * ldc_porcentaje_lote;
    
    
    ldc_manejo_flete    =   0;
    ldc_manejo          =   0;

    for r_work in select adc_manejo_factura1.almacen, adc_manejo_factura1.tipo,
                    adc_manejo_factura1.num_documento
                  from adc_manejo_factura1
                  where adc_manejo_factura1.compania = as_compania
                    and adc_manejo_factura1.consecutivo = ai_consecutivo
                  group by 1, 2, 3
                  order by 1, 2, 3
    loop
        select into ldc_work_manejo -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo, cglcuentas
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento
        and cglposteo.cuenta between ''4600'' and ''4610'';
        if ldc_work_manejo is null then
            ldc_work_manejo = 0;
        end if;
        
        select into ldc_work_flete -sum(cglposteo.debito-cglposteo.credito)
        from rela_factura1_cglposteo, cglposteo, cglcuentas
        where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
        and cglposteo.cuenta = cglcuentas.cuenta
        and cglcuentas.tipo_cuenta = ''R''
        and rela_factura1_cglposteo.almacen = r_work.almacen
        and rela_factura1_cglposteo.tipo = r_work.tipo
        and rela_factura1_cglposteo.num_documento = r_work.num_documento;
        if ldc_work_flete is null then
            ldc_work_flete = 0;
        end if;
        
        ldc_work_flete      =   ldc_work_flete - ldc_work_manejo;
        
        ldc_manejo_flete    =   ldc_manejo_flete + ldc_work_flete;
        ldc_manejo          =   ldc_manejo + ldc_work_manejo;
    end loop;    
    ldc_manejo_flete    =   ldc_manejo_flete * ldc_porcentaje_lote;
    ldc_manejo          =   ldc_manejo * ldc_porcentaje_lote;
    
    if trim(as_retornar) = ''MANEJO'' then
        return -ldc_manejo - ldc_cxc_manejo - ldc_cxp_manejo;
    else
        return ldc_ingresos_house + ldc_costos - ldc_cxc - ldc_cxp - ldc_manejo_flete;
    end if;
end;
' language plpgsql;
*/
