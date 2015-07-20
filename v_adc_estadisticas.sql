
drop view v_adc_estadisticas;

create view v_adc_estadisticas as
select adc_manifiesto.consecutivo, trim(adc_manifiesto.no_referencia) as no_referencia, 
f_adc_region(adc_manifiesto.compania, adc_manifiesto.consecutivo) as region,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo) as agente,
f_adc_ciudad(adc_manifiesto.compania, adc_manifiesto.consecutivo) as ciudad,
(select destinos.descripcion from destinos where destinos.cod_destino = adc_manifiesto.puerto_descarga) as puerto_descarga,
(select navieras.descripcion from navieras where navieras.cod_naviera = adc_manifiesto.cod_naviera) as naviera,
adc_manifiesto.fecha_departure as etd, 
adc_manifiesto.fecha_arrive as eta, 
Anio(adc_manifiesto.fecha_arrive) as anio,
Mes(adc_manifiesto.fecha_arrive) as mes, 
adc_master.tamanio, adc_master.no_bill, adc_master.container, 
case when adc_master.tamanio = 'NO' then 0 else 1 end as contenedor,
case when adc_master.tamanio = 'NO' then adc_master.cbm else 0 end as cbm, 
adc_master.pkgs, adc_master.kgs,
fact_referencias.descripcion as desc_referencia, fact_referencias.medio, 
fact_referencias.tipo as import_export, adc_tipo_de_contenedor.clase,
adc_tipo_de_contenedor.tipo as tipo,
f_adc_master_tipo_de_carga(adc_master.compania, adc_master.consecutivo, adc_master.linea_master) as tipo_de_carga,
f_adc_master_flete(adc_master.compania, adc_master.consecutivo, adc_master.linea_master) as flete,
f_adc_master_manejo(adc_master.compania, adc_master.consecutivo, adc_master.linea_master) as manejo
from adc_manifiesto, adc_master, adc_containers, fact_referencias, adc_tipo_de_contenedor
where adc_master.tipo = adc_tipo_de_contenedor.tipo
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_master.tamanio = adc_containers.tamanio