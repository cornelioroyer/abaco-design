drop view v_adc_estadisticas_venta;
create view v_adc_estadisticas_venta as
select adc_manifiesto.compania, vendedores.nombre as nombre_vendedor, vendedores.codigo as codigo_vendedor, 
clientes.nomb_cliente as nombre_cliente,
clientes.cliente as codigo_cliente,
Anio(fecha) as anio, Mes(fecha) as mes,
sum(f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'FLETE')) as flete,
sum(f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house, 'MANEJO')) as manejo
from adc_manifiesto, adc_house, vendedores, clientes
where Anio(fecha) >= 2008
and adc_house.vendedor = vendedores.codigo
and adc_manifiesto.compania = adc_house.compania
and adc_manifiesto.consecutivo = adc_house.consecutivo
and adc_house.cliente = clientes.cliente
group by 1, 2, 3, 4, 5, 6, 7;

