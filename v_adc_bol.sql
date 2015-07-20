
drop view v_adc_bol;
drop view v_adc_bol_air;
drop function f_adc_bol(char(2), int4, char(20)) cascade;

create function f_adc_bol(char(2), int4, char(20)) returns varchar(100) as '
declare
    as_compania alias for $1;
    ai_consecutivo alias for $2;
    ac_retorno alias for $3;
    r_adc_manifiesto record;
    r_adc_tipo_de_contenedor record;
    r_adc_house record;
    r_adc_master record;
    r_clientes record;
    r_vendedores record;
    r_adc_containers record;
    ldc_work decimal;
    li_work integer;
begin

    select into r_adc_manifiesto *
    from adc_manifiesto
    where compania = as_compania
    and consecutivo = ai_consecutivo;
    if not found then
        return '''';
    end if;
    

    ldc_work    =   0;
    li_work     =   0;
    
    if trim(ac_retorno) = ''CBM_LCL'' then
    
        select into r_adc_tipo_de_contenedor adc_tipo_de_contenedor.*
        from adc_master, adc_tipo_de_contenedor
        where adc_master.tipo = adc_tipo_de_contenedor.tipo    
        and adc_master.compania = as_compania
        and adc_master.consecutivo = ai_consecutivo;
        if found then
            if trim(r_adc_tipo_de_contenedor.clase) = ''CONSOLIDATED'' then
                select sum(cbm) into ldc_work from adc_master
                where adc_master.compania = as_compania
                and adc_master.consecutivo = ai_consecutivo;
                if ldc_work is null then
                    ldc_work = 0;
                end if;
            end if;
        end if; 
        return trim(to_char(ldc_work, ''9999999.9999''));
        
    elsif trim(ac_retorno) = ''BILL_NO'' then

/*
            ldc_work = 0;    
            select into ldc_work sum(kgs)
            from adc_master
            where adc_master.compania = as_compania
            and adc_master.consecutivo = ai_consecutivo;
            
            if ldc_work is null then
                ldc_work = 0;
            end if;
            
            return trim(to_char(ldc_work, ''9999999.99''));
*/            


    elsif trim(ac_retorno) = ''GROSS_WEIGHT'' then
            ldc_work = 0;    
            select into ldc_work sum(kgs)
            from adc_master
            where adc_master.compania = as_compania
            and adc_master.consecutivo = ai_consecutivo;
            
            if ldc_work is null then
                ldc_work = 0;
            end if;
            
            return trim(to_char(ldc_work, ''9999999.99''));

    elsif trim(ac_retorno) = ''20'' then
            select into r_adc_tipo_de_contenedor adc_tipo_de_contenedor.*
            from adc_master, adc_tipo_de_contenedor
            where adc_master.tipo = adc_tipo_de_contenedor.tipo    
            and adc_master.compania = as_compania
            and adc_master.consecutivo = ai_consecutivo;
            if found then
                if trim(r_adc_tipo_de_contenedor.clase) = ''INTACTS'' then
                    select count(*) into li_work 
                    from adc_master
                    where adc_master.compania = as_compania
                    and adc_master.consecutivo = ai_consecutivo
                    and adc_master.tamanio in (''20'');
                    if li_work is null then
                        li_work = 0;
                    end if;
                end if;
            end if;
            return trim(to_char(li_work, ''9999999''));

    elsif trim(ac_retorno) = ''40'' then
            select into r_adc_tipo_de_contenedor adc_tipo_de_contenedor.*
            from adc_master, adc_tipo_de_contenedor
            where adc_master.tipo = adc_tipo_de_contenedor.tipo    
            and adc_master.compania = as_compania
            and adc_master.consecutivo = ai_consecutivo;
            if found then
                if trim(r_adc_tipo_de_contenedor.clase) = ''INTACTS'' then
                    select count(*) into li_work 
                    from adc_master
                    where adc_master.compania = as_compania
                    and adc_master.consecutivo = ai_consecutivo
                    and adc_master.tamanio in (''40'');
                    if li_work is null then
                        li_work = 0;
                    end if;
                end if;
            end if;
            return trim(to_char(li_work, ''9999999''));

    elsif trim(ac_retorno) = ''45'' then
            select into r_adc_tipo_de_contenedor adc_tipo_de_contenedor.*
            from adc_master, adc_tipo_de_contenedor
            where adc_master.tipo = adc_tipo_de_contenedor.tipo    
            and adc_master.compania = as_compania
            and adc_master.consecutivo = ai_consecutivo;
            if found then
                if trim(r_adc_tipo_de_contenedor.clase) = ''INTACTS'' then
                    select count(*) into li_work 
                    from adc_master
                    where adc_master.compania = as_compania
                    and adc_master.consecutivo = ai_consecutivo
                    and adc_master.tamanio not in (''20'',''40'');
                    if li_work is null then
                        li_work = 0;
                    end if;
                end if;
            end if;
            return trim(to_char(li_work, ''9999999''));

    elsif trim(ac_retorno) = ''CODIGO_CLIENTE'' then
            select into r_adc_house *
            from adc_house
            where compania = as_compania
            and consecutivo = ai_consecutivo;
            if found then
                return ''PTY''||trim(r_adc_house.cliente);
            end if;

    elsif trim(ac_retorno) = ''NOMBRE_CLIENTE'' then
            select into r_clientes clientes.*
            from adc_house, clientes
            where adc_house.cliente = clientes.cliente
            and compania = as_compania
            and consecutivo = ai_consecutivo;
            if found then
                return trim(r_clientes.nomb_cliente);
            end if;
            
    elsif trim(ac_retorno) = ''PAYMENT_TYPE'' then
            select into r_adc_house *
            from adc_house
            where compania = as_compania
            and consecutivo = ai_consecutivo;
            if found then
                if trim(r_adc_house.cargo_prepago) = ''S'' then 
                    return ''P'';
                else
                    return ''C'';
                end if;    
            end if;

    elsif trim(ac_retorno) = ''POD'' then
            select into r_adc_house *
            from adc_house
            where compania = as_compania
            and consecutivo = ai_consecutivo;
            if found then
                return trim(r_adc_house.cod_destino);
            end if;

    elsif trim(ac_retorno) = ''VENDEDOR'' then
            select into r_vendedores vendedores.*
            from adc_house, vendedores
            where compania = as_compania
            and adc_house.vendedor = vendedores.codigo
            and consecutivo = ai_consecutivo;
            if found then
                return trim(r_vendedores.nombre);
            end if;

    elsif trim(ac_retorno) = ''SHIPPER_CODE'' then
            select into r_adc_house *
            from adc_house
            where compania = as_compania
            and consecutivo = ai_consecutivo;
            if found then
                return trim(r_adc_house.embarcador);
            end if;


    elsif trim(ac_retorno) = ''SHIPPER'' then
            select into r_adc_house *
            from adc_house
            where compania = as_compania
            and consecutivo = ai_consecutivo;
            if found then
                return trim(r_adc_house.embarcador);
            end if;

    elsif trim(ac_retorno) = ''TEUS'' then
            select into r_adc_tipo_de_contenedor adc_tipo_de_contenedor.*
            from adc_master, adc_tipo_de_contenedor, adc_containers
            where adc_master.tipo = adc_tipo_de_contenedor.tipo
            and adc_master.tamanio = adc_containers.tamanio
            and adc_master.compania = as_compania
            and adc_master.consecutivo = ai_consecutivo;
            if found then
                if trim(r_adc_tipo_de_contenedor.clase) = ''INTACTS'' then
                    select sum(adc_containers.teus) into li_work 
                    from adc_master, adc_containers
                    where adc_master.compania = as_compania
                    and adc_master.consecutivo = ai_consecutivo
                    and adc_master.tamanio = adc_containers.tamanio;
                    if li_work is null then
                        li_work = 0;
                    end if;
                end if;
            end if;
            return trim(to_char(li_work, ''9999999''));
            
    elsif trim(ac_retorno) = ''FCL/LCL'' then
            select into r_adc_master adc_master.*
            from adc_master
            where adc_master.compania = as_compania
            and adc_master.consecutivo = ai_consecutivo
            and trim(adc_master.tipo) = trim(ac_retorno);
            if found then
                return ''L'';
            end if;
        
    elsif trim(ac_retorno) = ''OWNER'' then
            select into r_adc_house adc_house.*
            from adc_house
            where adc_house.compania = as_compania
            and adc_house.consecutivo = ai_consecutivo;
            if found then
                if r_adc_house.almacen = ''01'' then
                    return ''213'';
                else
                    return ''214'';
                end if;   
            end if;                 
            
    elsif trim(ac_retorno) = ''WAYBILL_TYPE'' then
            select into r_adc_manifiesto *
            from adc_manifiesto, adc_house
            where adc_manifiesto.compania = adc_house.compania
            and adc_manifiesto.consecutivo = adc_house.consecutivo
            and trim(adc_manifiesto.no_referencia) = trim(adc_house.no_house)
            and adc_manifiesto.compania = as_compania
            and adc_manifiesto.consecutivo = ai_consecutivo;
            if found then
                return ''D'';
            else
                return ''H'';
            end if;
            
    end if;


    return '''';    
end;
' language plpgsql;




create view v_adc_bol as
select trim(adc_manifiesto.no_referencia) as bl_no,
trim(adc_manifiesto.cod_naviera) as carrier,
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'CBM_LCL') as cbm_lcl,
trim(f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'CODIGO')) as consigneee_code,
trim(f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'NOMBRE')) as consigneee,
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, '20') as t_20,
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, '40') as t_40,
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, '45') as t_45,
trim(adc_manifiesto.from_agent) as controlling_party,
adc_manifiesto.fecha_arrive as eta,
adc_manifiesto.fecha_departure as etd,
trim(fact_referencias.tipo) as shipment_type,
trim(f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'CODIGO_CLIENTE')) as codigo_cliente,
trim(f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'NOMBRE_CLIENTE')) as nombre_cliente,
trim(f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'PAYMENT_TYPE')) as payment_type,
adc_manifiesto.ciudad_origen as pld_ciudad_origen,
adc_manifiesto.ciudad_destino as plr_ciudad_destino,
trim(f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'POD')) as pod,
adc_manifiesto.ciudad_origen as pol_ciudad_origen,
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'CBM_LCL') as cbm,
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'VENDEDOR') as salesman,
case when fact_referencias.medio = 'M' then 'S' else 'A' end as service_type,
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'SHIPER_CODE') as shipper_code,
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'SHIPER') as shipper,
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'TEUS') as teus,
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'WAYBILL_TYPE') as waybill_type,
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'FCL/LCL') as fcl_lcl,
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'OWNER') as owner,
'' as delete
from adc_manifiesto, fact_referencias, navieras
where adc_manifiesto.cod_naviera = navieras.cod_naviera
and fact_referencias.referencia = adc_manifiesto.referencia
and fact_referencias.medio = 'M'
and adc_manifiesto.fecha >= '2013-01-01';


create view v_adc_bol_air as
select trim(adc_manifiesto.no_referencia) as bill_no,
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'WAYBILL_TYPE') as type,
trim(adc_manifiesto.cod_naviera) as airline,
trim(f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'CODIGO')) as consigneee_to,
trim(adc_manifiesto.from_agent) as controlling_party,
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'SHIPER_CODE') as shipper_code,
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'SHIPER') as shipper,
trim(f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'CODIGO')) as consigneee_code,
trim(f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'NOMBRE')) as consigneee,
trim(f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'CODIGO_CLIENTE')) as notify_party_code,
trim(f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'NOMBRE_CLIENTE')) as notify_party_name,
trim(fact_referencias.tipo) as shipment_type,
'' as debtor_party_code,
'' as deptor_party_name,
trim(f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'PAYMENT_TYPE')) as payment_type,
trim(adc_manifiesto.port_of_departure) as airport_departure,
trim(adc_manifiesto.puerto_descarga) as airport_destination,
'A' as service_type,
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'VENDEDOR') as salesman,
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'GROSS_WEIGHT') as gross_weight,
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'GROSS_WEIGHT') as chargeable_weight,
adc_manifiesto.fecha_arrive as eta,
adc_manifiesto.fecha_departure as etd,
'Y' as co_loader,
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'OWNER') as owner,
'' as delete
from adc_manifiesto, fact_referencias, navieras
where adc_manifiesto.cod_naviera = navieras.cod_naviera
and fact_referencias.referencia = adc_manifiesto.referencia
and fact_referencias.medio = 'A'
and adc_manifiesto.fecha >= '2013-01-01';




/*
f_adc_bol(adc_manifiesto.compania, adc_manifiesto.consecutivo, 'CBM_LCL') as cbm_lcl,
    
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
*/
