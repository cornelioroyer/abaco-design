drop view v_adc_importacion_maritima;
create view v_adc_importacion_maritima as
select adc_manifiesto.no_referencia, adc_manifiesto.ciudad_origen,
adc_manifiesto.fecha_arrive, Anio(adc_manifiesto.fecha_arrive),
Mes(adc_manifiesto.fecha_arrive), 
adc_master.tamanio, adc_master.no_bill, adc_master.container,
case when adc_master.tamanio = 'NO' then adc_master.cbm else 0 end as cbm, 
case when adc_master.tamanio = 'NO' then 0 else adc_containers.teus end as teus,
fac_ciudades.nombre,
fac_regiones.region, fac_regiones.nombre as nombre_region,
adc_manifiesto.referencia,
adc_master.tipo, adc_tipo_de_contenedor.clase
from adc_manifiesto, adc_master, fac_ciudades, adc_containers, fac_paises, fac_regiones,
adc_tipo_de_contenedor
where adc_manifiesto.compania = adc_master.compania
and adc_master.tipo = adc_tipo_de_contenedor.tipo
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.ciudad_origen = fac_ciudades.ciudad
and adc_master.tamanio = adc_containers.tamanio
and fac_ciudades.pais = fac_paises.pais
and fac_paises.region = fac_regiones.region