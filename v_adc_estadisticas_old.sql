drop view v_adc_estadisticas;
create view v_adc_estadisticas as
select trim(adc_manifiesto.no_referencia) as no_referencia, adc_manifiesto.ciudad_origen, 
adc_manifiesto.fecha_departure as fecha_salida,
adc_manifiesto.fecha_arrive, Anio(adc_manifiesto.fecha_arrive) as anio,
Mes(adc_manifiesto.fecha_arrive) as mes, 
adc_master.tamanio, adc_master.no_bill, adc_master.container, 1 as contenedor,
adc_manifiesto.cod_naviera, navieras.descripcion as nombre_naviera,
adc_master.tipo, 
case when adc_master.tamanio = 'NO' then adc_master.cbm else 0 end as cbm, 
case when adc_master.tamanio = 'NO' then 0 else adc_containers.teus end as teus,
fac_ciudades.nombre as origen,
fac_regiones.region, fac_regiones.nombre as nombre_region,
adc_manifiesto.referencia,
fact_referencias.medio, 0 as monto, 0 as manejo,
fact_referencias.tipo as import_export
from adc_manifiesto, adc_master, fac_ciudades, adc_containers, fac_paises, fac_regiones,
fact_referencias
where adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.ciudad_origen = fac_ciudades.ciudad
and adc_master.tamanio = adc_containers.tamanio
and fac_ciudades.pais = fac_paises.pais
and fac_paises.region = fac_regiones.region
and fact_referencias.tipo = 'I'
union
select trim(adc_manifiesto.no_referencia), adc_manifiesto.ciudad_origen, 
adc_manifiesto.fecha_departure as fecha_salida,
adc_manifiesto.fecha_arrive, Anio(adc_manifiesto.fecha_arrive),
Mes(adc_manifiesto.fecha_arrive), 
adc_master.tamanio, adc_master.no_bill, adc_master.container, 0 as contenedor,
adc_manifiesto.cod_naviera, navieras.descripcion as nombre_naviera,
adc_master.tipo,
0, 0, fac_ciudades.nombre as origen,
fac_regiones.region, fac_regiones.nombre as nombre_region,
adc_manifiesto.referencia,
fact_referencias.medio,
sum(cglposteo.debito-cglposteo.credito), 0, fact_referencias.tipo
from adc_manifiesto, adc_master, fac_ciudades, adc_containers, fac_paises, fac_regiones,
fact_referencias, rela_adc_master_cglposteo, cglposteo, cglcuentas
where adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.ciudad_origen = fac_ciudades.ciudad
and adc_master.tamanio = adc_containers.tamanio
and fac_ciudades.pais = fac_paises.pais
and fac_paises.region = fac_regiones.region
and fact_referencias.tipo = 'I'
and adc_master.compania = rela_adc_master_cglposteo.compania
and adc_master.consecutivo = rela_adc_master_cglposteo.consecutivo
and adc_master.linea_master = rela_adc_master_cglposteo.linea_master
and rela_adc_master_cglposteo.cgl_consecutivo = cglposteo.consecutivo
and cglposteo.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'R'
group by adc_manifiesto.no_referencia, adc_manifiesto.ciudad_origen, 
adc_manifiesto.fecha_departure,
adc_manifiesto.fecha_arrive,
adc_master.tamanio, adc_master.no_bill, adc_master.container, 
adc_manifiesto.cod_naviera, navieras.descripcion,
adc_master.tipo, fac_ciudades.nombre,
fac_regiones.region, fac_regiones.nombre,
adc_manifiesto.referencia,
fact_referencias.medio, fact_referencias.tipo

/*
union
select trim(adc_manifiesto.no_referencia), adc_manifiesto.ciudad_origen, 
adc_manifiesto.fecha_departure as fecha_salida,
adc_manifiesto.fecha_arrive, Anio(adc_manifiesto.fecha_arrive),
Mes(adc_manifiesto.fecha_arrive), 
null, null, null, 0 as contenedor,
adc_manifiesto.cod_naviera, navieras.descripcion as nombre_naviera,
null, 0, 0, fac_ciudades.nombre as origen,
fac_regiones.region, fac_regiones.nombre as nombre_region,
adc_manifiesto.referencia,
fact_referencias.medio, sum(cglposteo.debito-cglposteo.credito), 0, fact_referencias.tipo
from adc_manifiesto, fac_ciudades, adc_containers, fac_paises, fac_regiones,
fact_referencias, cglposteo, cglcuentas, rela_adc_cxc_1_cglposteo
where adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.ciudad_origen = fac_ciudades.ciudad
and adc_master.tamanio = adc_containers.tamanio
and fac_ciudades.pais = fac_paises.pais
and fac_paises.region = fac_regiones.region
and fact_referencias.tipo = 'I'
and adc_manifiesto.compania = rela_adc_cxc_1_cglposteo.compania
and adc_manifiesto.consecutivo = rela_adc_cxc_1_cglposteo.consecutivo
and rela_adc_cxc_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
and cglposteo.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'R'
group by adc_manifiesto.no_referencia, adc_manifiesto.ciudad_origen, 
adc_manifiesto.fecha_departure,
adc_manifiesto.fecha_arrive,
adc_master.tamanio, adc_master.no_bill, adc_master.container, 
adc_manifiesto.cod_naviera, navieras.descripcion,
adc_master.tipo, fac_ciudades.nombre,
fac_regiones.region, fac_regiones.nombre,
adc_manifiesto.referencia,
fact_referencias.medio, fact_referencias.tipo
union
select trim(adc_manifiesto.no_referencia), adc_manifiesto.ciudad_origen, 
adc_manifiesto.fecha_departure as fecha_salida,
adc_manifiesto.fecha_arrive, Anio(adc_manifiesto.fecha_arrive),
Mes(adc_manifiesto.fecha_arrive), 
null, null, null, 0 as contenedor,
adc_manifiesto.cod_naviera, navieras.descripcion as nombre_naviera,
null, 0, 0, fac_ciudades.nombre as origen,
fac_regiones.region, fac_regiones.nombre as nombre_region,
adc_manifiesto.referencia,
fact_referencias.medio, sum(cglposteo.debito-cglposteo.credito), 0, fact_referencias.tipo
from adc_manifiesto, fac_ciudades, adc_containers, fac_paises, fac_regiones,
fact_referencias, cglposteo, cglcuentas, rela_adc_cxp_1_cglposteo
where adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.ciudad_origen = fac_ciudades.ciudad
and adc_master.tamanio = adc_containers.tamanio
and fac_ciudades.pais = fac_paises.pais
and fac_paises.region = fac_regiones.region
and fact_referencias.tipo = 'I'
and adc_manifiesto.compania = rela_adc_cxp_1_cglposteo.compania
and adc_manifiesto.consecutivo = rela_adc_cxp_1_cglposteo.consecutivo
and rela_adc_cxp_1_cglposteo.cgl_consecutivo = cglposteo.consecutivo
and cglposteo.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'R'
group by adc_manifiesto.no_referencia, adc_manifiesto.ciudad_origen, 
adc_manifiesto.fecha_departure,
adc_manifiesto.fecha_arrive,
adc_master.tamanio, adc_master.no_bill, adc_master.container, 
adc_manifiesto.cod_naviera, navieras.descripcion,
adc_master.tipo, fac_ciudades.nombre,
fac_regiones.region, fac_regiones.nombre,
adc_manifiesto.referencia,
fact_referencias.medio, fact_referencias.tipo
union
select trim(adc_manifiesto.no_referencia), adc_manifiesto.ciudad_origen, 
adc_manifiesto.fecha_departure as fecha_salida,
adc_manifiesto.fecha_arrive, Anio(adc_manifiesto.fecha_arrive),
Mes(adc_manifiesto.fecha_arrive), 
adc_master.tamanio, adc_master.no_bill, adc_master.container, 0 as contenedor,
adc_manifiesto.cod_naviera, navieras.descripcion as nombre_naviera,
adc_master.tipo,
0, 0, fac_ciudades.nombre as origen,
fac_regiones.region, fac_regiones.nombre as nombre_region,
adc_manifiesto.referencia,
fact_referencias.medio,
-sum(cglposteo.debito-cglposteo.credito), 0, fact_referencias.tipo
from adc_manifiesto, adc_master, adc_house_factura1, fac_ciudades, adc_containers, fac_paises, fac_regiones,
fact_referencias, rela_factura1_cglposteo, cglposteo, cglcuentas
where adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.ciudad_origen = fac_ciudades.ciudad
and adc_master.tamanio = adc_containers.tamanio
and adc_master.compania = adc_house_factura1.compania
and adc_master.consecutivo = adc_house_factura1.consecutivo
and adc_master.linea_master = adc_house_factura1.linea_master
and rela_factura1_cglposteo.almacen = adc_house_factura1.almacen
and rela_factura1_cglposteo.tipo = adc_house_factura1.tipo
and rela_factura1_cglposteo.num_documento = adc_house_factura1.num_documento
and rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
and fac_ciudades.pais = fac_paises.pais
and fac_paises.region = fac_regiones.region
and fact_referencias.tipo = 'I'
and cglposteo.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'R'
group by adc_manifiesto.no_referencia, adc_manifiesto.ciudad_origen, 
adc_manifiesto.fecha_departure,
adc_manifiesto.fecha_arrive,
adc_master.tamanio, adc_master.no_bill, adc_master.container, 
adc_manifiesto.cod_naviera, navieras.descripcion,
adc_master.tipo, fac_ciudades.nombre,
fac_regiones.region, fac_regiones.nombre,
adc_manifiesto.referencia,
fact_referencias.medio, fact_referencias.tipo
union
select trim(adc_manifiesto.no_referencia), adc_manifiesto.ciudad_origen, 
adc_manifiesto.fecha_departure as fecha_salida,
adc_manifiesto.fecha_arrive, Anio(adc_manifiesto.fecha_arrive),
Mes(adc_manifiesto.fecha_arrive), 
adc_master.tamanio, adc_master.no_bill, adc_master.container, 0 as contenedor,
adc_manifiesto.cod_naviera, navieras.descripcion as nombre_naviera,
adc_master.tipo,
0, 0, fac_ciudades.nombre as origen,
fac_regiones.region, fac_regiones.nombre as nombre_region,
adc_manifiesto.referencia,
fact_referencias.medio, 0,
-sum(cglposteo.debito-cglposteo.credito), fact_referencias.tipo
from adc_manifiesto, adc_master, adc_manejo_factura1, fac_ciudades, adc_containers, fac_paises, fac_regiones,
fact_referencias, rela_factura1_cglposteo, cglposteo, cglcuentas
where adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.ciudad_origen = fac_ciudades.ciudad
and adc_master.tamanio = adc_containers.tamanio
and adc_master.compania = adc_manejo_factura1.compania
and adc_master.consecutivo = adc_manejo_factura1.consecutivo
and adc_master.linea_master = adc_manejo_factura1.linea_master
and rela_factura1_cglposteo.almacen = adc_manejo_factura1.almacen
and rela_factura1_cglposteo.tipo = adc_manejo_factura1.tipo
and rela_factura1_cglposteo.num_documento = adc_manejo_factura1.num_documento
and rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
and fac_ciudades.pais = fac_paises.pais
and fac_paises.region = fac_regiones.region
and fact_referencias.tipo = 'I'
and cglposteo.cuenta = cglcuentas.cuenta
and cglcuentas.tipo_cuenta = 'R'
group by adc_manifiesto.no_referencia, adc_manifiesto.ciudad_origen, 
adc_manifiesto.fecha_departure,
adc_manifiesto.fecha_arrive,
adc_master.tamanio, adc_master.no_bill, adc_master.container, 
adc_manifiesto.cod_naviera, navieras.descripcion,
adc_master.tipo, fac_ciudades.nombre,
fac_regiones.region, fac_regiones.nombre,
adc_manifiesto.referencia,
fact_referencias.medio, fact_referencias.tipo;
*/

