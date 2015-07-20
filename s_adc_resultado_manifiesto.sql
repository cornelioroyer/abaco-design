SELECT Anio(fecha), Mes(fecha), adc_manifiesto.consecutivo,
f_adc_manifiesto(adc_manifiesto.compania, adc_manifiesto.consecutivo,'FLETE') , 
f_adc_manifiesto(adc_manifiesto.compania, adc_manifiesto.consecutivo,'MANEJO') ,
sum(f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master,
adc_house.linea_house, 'FLETE')) ,
sum(f_adc_house(adc_house.compania, adc_house.consecutivo, adc_house.linea_master,
adc_house.linea_house, 'MANEJO')) 
FROM adc_house, adc_manifiesto
WHERE adc_house.compania = adc_manifiesto.compania
and adc_house.consecutivo = adc_manifiesto.consecutivo
and adc_manifiesto.fecha >= '2008-09-01'
group by 1, 2, 3, 4, 5
order by 1, 2, 3