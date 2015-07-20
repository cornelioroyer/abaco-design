drop view v_adc_house_cglposteo;
create view v_adc_house_cglposteo as
SELECT adc_house.*, adc_house_factura1.num_documento, cglposteo.consecutivo as cgl_consecutivo,
cglposteo.cuenta, cglposteo.debito, cglposteo.credito
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
