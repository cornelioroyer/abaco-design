/*
update adc_master
set dthc = 0, dthc_prepago = 'N'
where (dthc is null or dthc_prepago is null)
and exists
(select * from adc_manifiesto
where adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.fecha >= '2007-08-01');
*/

update adc_master
set dthc_prepago = 'N'
where (dthc <> 0 and dthc_prepago is null)
and exists
(select * from adc_manifiesto
where adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_manifiesto.fecha >= '2007-08-01');
