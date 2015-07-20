

select f_adc_house_to_facturacion(adc_manifiesto.compania, adc_manifiesto.consecutivo, 
adc_house.linea_master, adc_house.linea_house)
from adc_house, adc_manifiesto
where adc_manifiesto.compania = adc_house.compania
and adc_manifiesto.consecutivo = adc_house.consecutivo
and adc_manifiesto.consecutivo = 27081



/*

select f_adc_house_to_facturacion(adc_manifiesto.compania, adc_manifiesto.consecutivo, 
adc_house.linea_master, adc_house.linea_house)
from adc_house, adc_manifiesto
where adc_manifiesto.compania = adc_house.compania
and adc_manifiesto.consecutivo = adc_house.consecutivo
and adc_manifiesto.fecha >= '2011-06-01'

*/




