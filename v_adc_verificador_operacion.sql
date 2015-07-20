drop view v_adc_verificador_operacion;
create view v_adc_verificador_operacion as
select 'OPERACION' as grupo, 2 as secuencia, 'COSTOS' as concepto, adc_master.linea_master, gralcompanias.nombre as nombre_cia, adc_manifiesto.compania, 
adc_manifiesto.consecutivo, adc_manifiesto.fecha, 
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo) as cliente,
adc_manifiesto.no_referencia, 
f_adc_ciudad(adc_manifiesto.compania, adc_manifiesto.consecutivo) as ciudad,
destinos.descripcion as destino,
adc_manifiesto.fecha_departure as etd, adc_manifiesto.fecha_arrive as eta, adc_manifiesto.divisor,
navieras.descripcion, adc_manifiesto.vapor, adc_master.container as container_house, 0 as factura,
case when adc_master.cargo_prepago = 'S' then -adc_master.cargo else 0 end as cargo_prepagado, 
case when adc_master.cargo_prepago <> 'S' then -adc_master.cargo else 0 end as cargo,
case when adc_master.gtos_prepago = 'S' then -adc_master.gtos_d_origen else 0 end as gtos_d_origen_prepagado,
case when adc_master.gtos_prepago <> 'S' then -adc_master.gtos_d_origen else 0 end as gtos_d_origen,
-adc_master.gtos_destino as gtos_destino,
case when adc_master.dthc_prepago = 'S' then -adc_master.dthc else 0 end as dthc_prepagado,
case when adc_master.dthc_prepago <> 'S' then -adc_master.dthc else 0 end as dthc
from adc_manifiesto, clientes, adc_master, navieras, fact_referencias, destinos, gralcompanias
where adc_manifiesto.compania = gralcompanias.compania
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.from_agent = clientes.cliente
and adc_manifiesto.puerto_descarga = destinos.cod_destino
union
select 'OPERACION', 1, 'INGRESOS POR FLETE LOCALES', adc_master.linea_master, gralcompanias.nombre, adc_manifiesto.compania, 
adc_manifiesto.consecutivo, adc_manifiesto.fecha,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo),
adc_manifiesto.no_referencia, 
f_adc_ciudad(adc_manifiesto.compania, adc_manifiesto.consecutivo) as ciudad,
destinos.descripcion,
adc_manifiesto.fecha_departure as etd, adc_manifiesto.fecha_arrive as eta,adc_manifiesto.divisor,
navieras.descripcion, adc_manifiesto.vapor, adc_house.no_house, 
(select adc_house_factura1.num_documento from adc_house_factura1, factmotivos
where adc_house_factura1.tipo = factmotivos.tipo
and factmotivos.factura = 'S'
and adc_house_factura1.compania = adc_house.compania
and adc_house_factura1.consecutivo = adc_house.consecutivo
and adc_house_factura1.linea_master = adc_house.linea_master
and adc_house_factura1.linea_house = adc_house.linea_house),
case when adc_house.cargo_prepago = 'S' then adc_house.cargo else 0 end as cargo_prepagado,
case when adc_house.cargo_prepago <> 'S' then adc_house.cargo else 0 end as cargo,
case when adc_house.gtos_prepago = 'S' then adc_house.gtos_d_origen else 0 end,
case when adc_house.gtos_prepago <> 'S' then adc_house.gtos_d_origen else 0 end, 0,
case when adc_house.dthc_prepago = 'S' then adc_house.dthc else 0 end as dthc_prepagado,
case when adc_house.dthc_prepago <> 'S' then adc_house.dthc else 0 end as dthc
from adc_manifiesto, adc_master, navieras, fact_referencias, 
destinos, adc_house, gralcompanias
where adc_manifiesto.compania = gralcompanias.compania
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.puerto_descarga = destinos.cod_destino
union
select 'NOTAS', 4, 'OTROS INGRESOS', 0, gralcompanias.nombre, adc_manifiesto.compania, 
adc_manifiesto.consecutivo, adc_manifiesto.fecha,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo) as cliente,
adc_manifiesto.no_referencia,
f_adc_ciudad(adc_manifiesto.compania, adc_manifiesto.consecutivo) as ciudad,
destinos.descripcion,
adc_manifiesto.fecha_departure as etd, adc_manifiesto.fecha_arrive as eta,adc_manifiesto.divisor,
navieras.descripcion, adc_manifiesto.vapor, adc_cxc_1.documento, adc_cxc_1.consecutivo,
0, -(cxcmotivos.signo*adc_cxc_2.monto), 0, 0, 0, 0, 0
from adc_manifiesto, adc_cxc_1, navieras, fact_referencias, destinos, gralcompanias, adc_cxc_2, cxcmotivos
where adc_manifiesto.compania = gralcompanias.compania
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.puerto_descarga = destinos.cod_destino
and adc_manifiesto.compania = adc_cxc_1.compania
and adc_manifiesto.consecutivo = adc_cxc_1.consecutivo
and adc_cxc_1.compania = adc_cxc_2.compania
and adc_cxc_1.consecutivo = adc_cxc_2.consecutivo
and adc_cxc_1.secuencia = adc_cxc_2.secuencia
and adc_cxc_2.cuenta like '4%'
and adc_cxc_1.motivo_cxc = cxcmotivos.motivo_cxc
union
select 'MANEJO',3, 'INGRESOS POR MANEJO', adc_manejo.linea_manejo, gralcompanias.nombre, adc_manifiesto.compania, 
adc_manifiesto.consecutivo, adc_manifiesto.fecha,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo),
adc_manifiesto.no_referencia,
f_adc_ciudad(adc_manifiesto.compania, adc_manifiesto.consecutivo) as ciudad,
destinos.descripcion,
adc_manifiesto.fecha_departure as etd, adc_manifiesto.fecha_arrive as eta,adc_manifiesto.divisor,
navieras.descripcion, adc_manifiesto.vapor, adc_house.no_house,
(select adc_manejo_factura1.num_documento from adc_manejo_factura1, factmotivos
where adc_manejo_factura1.compania = adc_manejo.compania
and adc_manejo_factura1.consecutivo = adc_manejo.consecutivo
and adc_manejo_factura1.linea_master = adc_manejo.linea_master
and adc_manejo_factura1.linea_house = adc_manejo.linea_house
and adc_manejo_factura1.linea_manejo = adc_manejo.linea_manejo
and adc_manejo_factura1.tipo = factmotivos.tipo
and factmotivos.factura = 'S'),
0, adc_manejo.cargo, 0, 0, 0, 0, 0
from adc_manifiesto, adc_master, navieras, fact_referencias,
destinos, adc_house, adc_manejo, gralcompanias
where adc_manifiesto.compania = gralcompanias.compania
and adc_house.compania = adc_manejo.compania
and adc_house.consecutivo = adc_manejo.consecutivo
and adc_house.linea_master = adc_manejo.linea_master
and adc_house.linea_house = adc_manejo.linea_house
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.puerto_descarga = destinos.cod_destino
and trim(adc_manejo.observacion) not like '%DTHC%'
union
select 'OPERACION', 1, 'INGRESOS POR FLETE LOCALES', adc_manejo.linea_manejo, gralcompanias.nombre, adc_manifiesto.compania, 
adc_manifiesto.consecutivo, adc_manifiesto.fecha,
f_adc_agente(adc_manifiesto.compania, adc_manifiesto.consecutivo),
adc_manifiesto.no_referencia,
f_adc_ciudad(adc_manifiesto.compania, adc_manifiesto.consecutivo) as ciudad,
destinos.descripcion,
adc_manifiesto.fecha_departure as etd, adc_manifiesto.fecha_arrive as eta,adc_manifiesto.divisor,
navieras.descripcion, adc_manifiesto.vapor, adc_house.no_house,
(select adc_manejo_factura1.num_documento from adc_manejo_factura1, factmotivos
where adc_manejo_factura1.compania = adc_manejo.compania
and adc_manejo_factura1.consecutivo = adc_manejo.consecutivo
and adc_manejo_factura1.linea_master = adc_manejo.linea_master
and adc_manejo_factura1.linea_house = adc_manejo.linea_house
and adc_manejo_factura1.linea_manejo = adc_manejo.linea_manejo
and adc_manejo_factura1.tipo = factmotivos.tipo
and factmotivos.factura = 'S'),
0, 0, 0, 0, 0, 0, adc_manejo.cargo
from adc_manifiesto, adc_master, navieras, fact_referencias,
destinos, adc_house, adc_manejo, gralcompanias
where adc_manifiesto.compania = gralcompanias.compania
and adc_house.compania = adc_manejo.compania
and adc_house.consecutivo = adc_manejo.consecutivo
and adc_house.linea_master = adc_manejo.linea_master
and adc_house.linea_house = adc_manejo.linea_house
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.referencia = fact_referencias.referencia
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.puerto_descarga = destinos.cod_destino
and trim(adc_manejo.observacion) like '%DTHC%'




/*
union
union
select 6 as secuencia, 'GASTOS DE DESTINO PAGADOS EN ORIGEN' as concepto, 5, gralcompanias.nombre as nombre_cia, adc_manifiesto.compania, 
adc_manifiesto.consecutivo, adc_manifiesto.fecha, clientes.nomb_cliente, 
adc_manifiesto.no_referencia, fac_ciudades.nombre as ciudad, destinos.descripcion as destino,
adc_manifiesto.fecha_departure as etd, adc_manifiesto.fecha_arrive as eta, adc_manifiesto.divisor,
navieras.descripcion, adc_manifiesto.vapor, adc_cxc_1.documento, adc_cxc_1.secuencia,
adc_cxc_2.monto, 0, 0, 0, 0
from adc_manifiesto, clientes, adc_cxc_1, navieras, fact_referencias, fac_ciudades,
destinos, gralcompanias, adc_cxc_2
where adc_cxc_1.compania = adc_cxc_2.compania
and adc_cxc_1.consecutivo = adc_cxc_2.consecutivo
and adc_cxc_1.secuencia = adc_cxc_2.secuencia
and adc_cxc_1.compania = adc_manifiesto.compania
and adc_cxc_1.consecutivo = adc_manifiesto.consecutivo
and adc_manifiesto.compania = gralcompanias.compania
and adc_manifiesto.referencia = fact_referencias.referencia
and fact_referencias.tipo = 'I'
and adc_manifiesto.cod_naviera = navieras.cod_naviera
and adc_manifiesto.from_agent = clientes.cliente
and adc_manifiesto.ciudad_origen = fac_ciudades.ciudad
and adc_manifiesto.puerto_descarga = destinos.cod_destino
and adc_cxc_1.monto <> 0
and (adc_cxc_2.cuenta like '2%' or adc_cxc_2.cuenta like '46%')
*/