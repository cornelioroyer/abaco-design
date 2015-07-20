
drop view v_adc_estadisticas_x_cliente;

create view v_adc_estadisticas_x_cliente as
select adc_manifiesto.consecutivo, trim(adc_manifiesto.no_referencia) as no_referencia, 
f_adc_region(adc_manifiesto.compania, adc_manifiesto.consecutivo) as region,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo) as agente,
f_adc_ciudad(adc_manifiesto.compania, adc_manifiesto.consecutivo) as ciudad,
clientes.nomb_cliente, clientes.cliente,
(select destinos.descripcion from destinos where destinos.cod_destino = adc_manifiesto.puerto_descarga) as puerto_descarga,
(select navieras.descripcion from navieras where navieras.cod_naviera = adc_manifiesto.cod_naviera) as naviera,
adc_manifiesto.fecha_departure as etd, 
adc_manifiesto.fecha_arrive as eta, 
Anio(adc_manifiesto.fecha_arrive) as anio,
Mes(adc_manifiesto.fecha_arrive) as mes, 
adc_master.tamanio, adc_master.no_bill, adc_house.no_house, adc_master.container, 
case when adc_master.tamanio = 'NO' then 0 else 1 end as contenedor,
case when adc_master.tamanio = 'NO' then adc_master.cbm else 0 end as cbm, 
adc_house.pkgs, adc_house.kgs,
fact_referencias.descripcion as desc_referencia, fact_referencias.medio, 
fact_referencias.tipo as import_export, adc_tipo_de_contenedor.clase,
adc_tipo_de_contenedor.tipo as tipo,
f_adc_master_tipo_de_carga(adc_master.compania, adc_master.consecutivo, adc_master.linea_master) as tipo_de_carga,
f_adc_house_flete(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house) as flete,
f_adc_house_manejo(adc_house.compania, adc_house.consecutivo, adc_house.linea_master, adc_house.linea_house) as manejo
from adc_manifiesto, adc_master, adc_containers, fact_referencias, adc_tipo_de_contenedor, adc_house, clientes
where adc_master.tipo = adc_tipo_de_contenedor.tipo
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_master.tamanio = adc_containers.tamanio
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_house.cliente = clientes.cliente;




