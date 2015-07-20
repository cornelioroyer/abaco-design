delete from adc_house_factura1
where exists
(select * from adc_manejo_factura1
where adc_house_factura1.almacen = adc_manejo_factura1.almacen
and adc_house_factura1.tipo = adc_manejo_factura1.tipo
and adc_house_factura1.num_documento = adc_manejo_factura1.num_documento);


select * from adc_house_factura1
where exists
(select * from adc_manejo_factura1
where adc_house_factura1.almacen = adc_manejo_factura1.almacen
and adc_house_factura1.tipo = adc_manejo_factura1.tipo
and adc_house_factura1.num_documento = adc_manejo_factura1.num_documento)
