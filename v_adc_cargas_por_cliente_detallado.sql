
drop view v_adc_cargas_por_cliente_detallado;
create view v_adc_cargas_por_cliente_detallado as
select factura1.fecha_factura, factura1.num_documento, clientes.nomb_cliente, factura1.cliente,
f_monto_factura(factura1.almacen, factura1.tipo, factura1.num_documento),
fact_referencias.descripcion, adc_master.no_bill, adc_house.no_house, 
(select nombre from fac_ciudades where fac_ciudades.ciudad = adc_manifiesto.ciudad_origen) as origen,
(select nombre from fac_ciudades where fac_ciudades.ciudad = adc_manifiesto.ciudad_destino) as destino,
trim(adc_house.embarcador) as embarcador, 
case when adc_master.tamanio = '20' then 1 else 0 end as C20,
case when adc_master.tamanio = '40' then 1 else 0 end as C40,
case when adc_master.tamanio = '40HQ' then 1 else 0 end as C40HQ,
case when adc_master.tipo = 'LCL/LCL' then adc_master.cbm else 0 end as clcl
from factura1, adc_house_factura1, adc_house, adc_master, adc_manifiesto,
    fact_referencias, factmotivos, clientes
where factura1.almacen = adc_house_factura1.almacen
and factura1.tipo = adc_house_factura1.tipo
and factura1.num_documento = adc_house_factura1.num_documento
and factura1.tipo = factmotivos.tipo
and factura1.cliente = clientes.cliente
and factmotivos.factura = 'S'
and adc_house_factura1.compania = adc_house.compania
and adc_house_factura1.consecutivo = adc_house.consecutivo
and adc_house_factura1.linea_master = adc_house.linea_master
and adc_house_factura1.linea_house = adc_house.linea_house
and adc_house.compania = adc_master.compania
and adc_house.consecutivo = adc_master.consecutivo
and adc_house.linea_master = adc_master.linea_master
and adc_master.compania = adc_manifiesto.compania
and adc_master.consecutivo = adc_manifiesto.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia

