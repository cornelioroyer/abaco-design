
delete from adc_house_factura1
where exists
(select * from factura1
where factura1.almacen_aplica = adc_house_factura1.almacen
and factura1.caja_aplica = adc_house_factura1.caja
and factura1.tipo_aplica = adc_house_factura1.tipo
and factura1.num_factura = adc_house_factura1.num_documento)

