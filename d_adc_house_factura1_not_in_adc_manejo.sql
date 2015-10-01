
delete from adc_house_factura1
where linea_manejo is not null
and not exists
(select * from adc_manejo
where adc_manejo.compania = adc_house_factura1.compania
and adc_manejo.consecutivo = adc_house_factura1.consecutivo
and adc_manejo.linea_master = adc_house_factura1.linea_master
and adc_manejo.linea_house = adc_house_factura1.linea_house
and adc_manejo.linea_manejo = adc_house_factura1.linea_manejo);


select * from adc_house_factura1
where linea_manejo is not null
and not exists
(select * from adc_manejo
where adc_manejo.compania = adc_house_factura1.compania
and adc_manejo.consecutivo = adc_house_factura1.consecutivo
and adc_manejo.linea_master = adc_house_factura1.linea_master
and adc_manejo.linea_house = adc_house_factura1.linea_house
and adc_manejo.linea_manejo = adc_house_factura1.linea_manejo);


