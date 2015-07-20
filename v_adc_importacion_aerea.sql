drop view v_adc_importacion_aerea;
create view v_adc_importacion_aerea as
select adc_manifiesto.no_referencia, adc_manifiesto.ciudad_origen,
adc_manifiesto.fecha_arrive, Anio(adc_manifiesto.fecha_arrive),
Mes(adc_manifiesto.fecha_arrive), 
adc_master.tamanio, adc_master.no_bill, adc_master.container,
adc_master.kgs,
fac_ciudades.nombre as d_ciudad,
fac_regiones.region, fac_regiones.nombre as d_region,
adc_manifiesto.referencia
from adc_manifiesto, adc_master, fac_ciudades, adc_containers, fac_paises, 
fac_regiones, fact_referencias
where fact_referencias.referencia = adc_manifiesto.referencia
and fact_referencias.tipo = 'I'
and fact_referencias.medio = 'A'
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.ciudad_origen = fac_ciudades.ciudad
and adc_master.tamanio = adc_containers.tamanio
and fac_ciudades.pais = fac_paises.pais
and fac_paises.region = fac_regiones.region

