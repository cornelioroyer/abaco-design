drop view v_adc_contenedores_x_anio;
create view v_adc_contenedores_x_anio as
select fact_referencias.referencia, fact_referencias.descripcion, Anio(adc_manifiesto.fecha), Mes(adc_manifiesto.fecha), 
fac_regiones.nombre as region, fac_ciudades.nombre as ciudades, 
clientes.nomb_cliente, adc_master.tamanio, 
adc_tipo_de_contenedor.tipo as tipo_de_contenedor, adc_tipo_de_contenedor.descripcion as d_tipo_de_contenedor, 
count(*) as contenedores, sum(adc_master.cbm) as cbm
from adc_manifiesto, adc_master, adc_house, fac_ciudades, clientes, fac_paises, 
fac_regiones, fact_referencias, adc_tipo_de_contenedor
where adc_master.tipo = adc_tipo_de_contenedor.tipo
and adc_manifiesto.referencia = fact_referencias.referencia
and fact_referencias.tipo = 'I'
and fact_referencias.medio = 'M'
and fac_ciudades.pais = fac_paises.pais
and fac_paises.region = fac_regiones.region
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_manifiesto.ciudad_origen = fac_ciudades.ciudad
and adc_house.cliente = clientes.cliente
and adc_master.tamanio <> 'NO'
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
union
select fact_referencias.referencia, fact_referencias.descripcion, Anio(adc_manifiesto.fecha), Mes(adc_manifiesto.fecha), 
fac_regiones.nombre as region, fac_ciudades.nombre as ciudades, 
clientes.nomb_cliente, adc_master.tamanio, 
adc_tipo_de_contenedor.tipo, adc_tipo_de_contenedor.descripcion, count(*), sum(adc_master.cbm)
from adc_manifiesto, adc_master, adc_house, fac_ciudades, clientes, fac_paises, 
fac_regiones, fact_referencias, adc_tipo_de_contenedor
where adc_manifiesto.referencia = fact_referencias.referencia
and adc_master.tipo = adc_tipo_de_contenedor.tipo
and fact_referencias.tipo <> 'I'
and fact_referencias.medio = 'M'
and fac_ciudades.pais = fac_paises.pais
and fac_paises.region = fac_regiones.region
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_manifiesto.ciudad_destino = fac_ciudades.ciudad
and adc_house.cliente = clientes.cliente
and adc_master.tamanio <> 'NO'
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10