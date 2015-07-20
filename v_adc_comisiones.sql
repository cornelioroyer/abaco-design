drop view v_adc_comisiones_verificador;
drop view v_adc_comisiones;

create view v_adc_comisiones as
select adc_manifiesto.compania, Anio(adc_manifiesto.fecha) as anio,
Mes(adc_manifiesto.fecha) as mes,
adc_manifiesto.consecutivo, adc_manifiesto.no_referencia,
adc_house.no_house,
adc_house.anio as anio_si, adc_house.secuencia as num_si,
clientes.nomb_cliente as nombre_cliente,
adc_house.cliente as codigo_cliente,
adc_house.embarcador, vendedores.nombre as vendedor,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo) as agente,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FECHA_FACTURA_FLETE') as fecha_factura_flete,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'NUMERO_FACTURA_FLETE') as numero_factura_flete,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'RECIBO_FACTURA_FLETE') as recibo_factura_flete,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FECHA_RECIBO_FACTURA_FLETE') as fecha_recibo_factura_flete,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'SALDO_FACTURA_FLETE') as saldo_factura_flete,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FECHA_FACTURA_MANEJO') as fecha_factura_manejo,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'NUMERO_FACTURA_MANEJO') as numero_factura_manejo,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'RECIBO_FACTURA_MANEJO') as recibo_factura_manejo,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FECHA_RECIBO_FACTURA_MANEJO') as fecha_recibo_factura_manejo,
f_adc_house_datos(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'SALDO_FACTURA_MANEJO') as saldo_factura_manejo,
f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FLETE') as flete,
-f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'COSTOS_FLETE') as costos_flete,
f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'MANEJO') as manejo
from adc_manifiesto, adc_house, clientes, vendedores
where adc_manifiesto.compania = adc_house.compania
and adc_manifiesto.consecutivo = adc_house.consecutivo
and adc_house.cliente = clientes.cliente
and adc_house.vendedor = vendedores.codigo
and adc_manifiesto.fecha >= '2009-06-01';


create view v_adc_comisiones_verificador as
SELECT Anio(fecha) as anio, Mes(fecha) as mes, adc_manifiesto.consecutivo,
f_adc_manifiesto(adc_manifiesto.compania, adc_manifiesto.consecutivo,'FLETE') as flete_manifiesto , 
f_adc_manifiesto(adc_manifiesto.compania, adc_manifiesto.consecutivo,'MANEJO') as manejo_manifiesto,
sum(f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FLETE')) as flete_house,
-sum(f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'COSTOS_FLETE')) as costos_flete,
sum(f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'MANEJO')) as manejo_house
FROM adc_house, adc_manifiesto
WHERE adc_house.compania = adc_manifiesto.compania
and adc_house.consecutivo = adc_manifiesto.consecutivo
and adc_manifiesto.fecha >= '2009-06-01'
group by 1, 2, 3, 4, 5;