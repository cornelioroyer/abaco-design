drop view v_adc_control_entrega;
create view v_adc_control_entrega as
select gralcompanias.nombre, gralcompanias.compania, adc_manifiesto.consecutivo, adc_manifiesto.no_referencia,
    adc_master.no_bill, adc_master.tamanio, adc_master.tipo, adc_manifiesto.fecha_arrive as fecha,
    adc_master.container, adc_house.no_house, adc_house.cliente, clientes.nomb_cliente,
    adc_house.pkgs as bultos, 
    f_adc_bultos_entregados(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house) as bultos_entregados,
    f_adc_saldo_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house) as saldo
from adc_manifiesto, adc_master, adc_house, clientes, gralcompanias
where adc_manifiesto.compania = gralcompanias.compania
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_house.cliente = clientes.cliente
and exists
    (select * from adc_house_factura1, factmotivos
    where adc_house_factura1.tipo = factmotivos.tipo
    and factmotivos.factura = 'S'
    and adc_house_factura1.compania = adc_house.compania
    and adc_house_factura1.consecutivo = adc_house.consecutivo
    and adc_house_factura1.linea_master = adc_house.linea_master
    and adc_house_factura1.linea_house = adc_house.linea_house);
    

drop function f_adc_cliente_entrega_mercancia(char(2), int4) cascade;

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
    
    