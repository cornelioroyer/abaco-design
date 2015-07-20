drop view v_adc_manifiesto_contable;
create view v_adc_manifiesto_contable as
select 'COSTOS' AS rubro, adc_master.compania, adc_master.consecutivo, 
adc_master.linea_master, adc_manifiesto.no_referencia, adc_master.no_bill, 
adc_master.container, cglposteo.cuenta, cglposteo.debito, cglposteo.credito, 0 AS factura, 
adc_manifiesto.fecha, adc_manifiesto.cod_naviera, fact_referencias.descripcion, 
fact_referencias.tipo, adc_manifiesto.to_agent, adc_manifiesto.from_agent, 
adc_manifiesto.ciudad_origen, adc_manifiesto.ciudad_destino, adc_manifiesto.vapor, adc_master.observacion
FROM adc_master, cglposteo, rela_adc_master_cglposteo, adc_manifiesto, fact_referencias 
WHERE adc_master.compania = rela_adc_master_cglposteo.compania 
and adc_master.consecutivo = rela_adc_master_cglposteo.consecutivo
AND adc_master.linea_master = rela_adc_master_cglposteo.linea_master
AND rela_adc_master_cglposteo.cgl_consecutivo = cglposteo.consecutivo
AND adc_manifiesto.compania = adc_master.compania
AND adc_manifiesto.consecutivo = adc_master.consecutivo
AND adc_manifiesto.referencia = fact_referencias.referencia 
UNION 
SELECT 'INGRESOS' AS rubro, adc_master.compania, adc_master.consecutivo, 0 AS linea_master, 
adc_manifiesto.no_referencia, adc_master.no_bill, NULL AS container, cglposteo.cuenta, 
cglposteo.debito, cglposteo.credito, adc_house_factura1.num_documento AS factura, 
adc_manifiesto.fecha, adc_manifiesto.cod_naviera, fact_referencias.descripcion, 
fact_referencias.tipo, adc_manifiesto.to_agent, adc_manifiesto.from_agent, 
adc_manifiesto.ciudad_origen, adc_manifiesto.ciudad_destino, adc_manifiesto.vapor, ''
FROM adc_manifiesto, adc_master, adc_house, adc_house_factura1, 
rela_factura1_cglposteo, cglposteo, fact_referencias 
WHERE adc_manifiesto.compania = adc_master.compania
AND adc_manifiesto.consecutivo = adc_master.consecutivo
AND adc_master.compania = adc_house.compania
AND adc_master.consecutivo = adc_house.consecutivo
AND adc_master.linea_master = adc_house.linea_master
AND adc_house.compania = adc_house_factura1.compania
AND adc_house.consecutivo = adc_house_factura1.consecutivo
AND adc_house.linea_master = adc_house_factura1.linea_master
AND adc_house.linea_house = adc_house_factura1.linea_house
AND adc_house_factura1.almacen = rela_factura1_cglposteo.almacen
AND adc_house_factura1.tipo = rela_factura1_cglposteo.tipo
AND adc_house_factura1.num_documento = rela_factura1_cglposteo.num_documento
AND rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
AND adc_manifiesto.referencia = fact_referencias.referencia
GROUP BY adc_master.compania, adc_master.consecutivo, adc_manifiesto.no_referencia, 
adc_master.no_bill, cglposteo.cuenta, cglposteo.debito, cglposteo.credito, 
adc_house_factura1.num_documento, adc_manifiesto.fecha, adc_manifiesto.cod_naviera, 
fact_referencias.descripcion, fact_referencias.tipo, adc_manifiesto.to_agent, 
adc_manifiesto.from_agent, adc_manifiesto.ciudad_origen, adc_manifiesto.ciudad_destino, 
adc_manifiesto.vapor
UNION 
SELECT 'INGRESOS' AS rubro, adc_master.compania, adc_master.consecutivo, 
adc_master.linea_master, adc_manifiesto.no_referencia, adc_master.no_bill, adc_master.container, 
cglposteo.cuenta, cglposteo.debito, cglposteo.credito, 
adc_manejo_factura1.num_documento AS factura, adc_manifiesto.fecha, 
adc_manifiesto.cod_naviera, fact_referencias.descripcion, fact_referencias.tipo, 
adc_manifiesto.to_agent, adc_manifiesto.from_agent, adc_manifiesto.ciudad_origen, 
adc_manifiesto.ciudad_destino, adc_manifiesto.vapor, ''
FROM adc_manifiesto, adc_master, adc_house, adc_manejo, adc_manejo_factura1, 
rela_factura1_cglposteo, cglposteo, fact_referencias 
WHERE adc_manifiesto.compania = adc_master.compania
AND adc_manifiesto.consecutivo = adc_master.consecutivo
AND adc_master.compania = adc_house.compania
AND adc_master.consecutivo = adc_house.consecutivo
AND adc_master.linea_master = adc_house.linea_master
 AND adc_house.compania = adc_manejo.compania
  AND adc_house.consecutivo = adc_manejo.consecutivo
  AND adc_house.linea_master = adc_manejo.linea_master
  AND adc_house.linea_house = adc_manejo.linea_house
AND adc_manejo.compania = adc_manejo_factura1.compania
AND adc_manejo.consecutivo = adc_manejo_factura1.consecutivo
 AND adc_manejo.linea_master = adc_manejo_factura1.linea_master
 AND adc_manejo.linea_house = adc_manejo_factura1.linea_house
 AND adc_manejo.linea_manejo = adc_manejo_factura1.linea_manejo
 AND adc_manejo_factura1.almacen = rela_factura1_cglposteo.almacen
  AND adc_manejo_factura1.tipo = rela_factura1_cglposteo.tipo
   AND adc_manejo_factura1.num_documento = rela_factura1_cglposteo.num_documento
    AND rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
    AND adc_manifiesto.referencia = fact_referencias.referencia;

