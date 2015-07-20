

insert into adc_house_factura1(compania, consecutivo,
linea_master, linea_house, almacen, tipo, num_documento)
values ('03', 25166, 1, 1, '01', '17', 6473);

/*
insert into adc_house_factura1(compania, consecutivo,
linea_master, linea_house, almacen, tipo, num_documento)
select compania, consecutivo, linea_master, linea_house,
'01', '17', 100
from adc_house
where consecutivo = 17001
and not exists
(select * from adc_house_factura1
where adc_house_factura1.compania = adc_house.compania
and adc_house_factura1.consecutivo = adc_house.consecutivo
and adc_house_factura1.linea_master = adc_house.linea_master
and adc_house_factura1.linea_house = adc_house.linea_house);

insert into adc_house_factura1(compania, consecutivo,
linea_master, linea_house, linea_manejo, almacen, tipo, num_documento)
select compania, consecutivo, linea_master, linea_house, linea_manejo,
'01', '17', 100
from adc_manejo
where consecutivo = 17001
and not exists
(select * from adc_house_factura1
where adc_house_factura1.compania = adc_manejo.compania
and adc_house_factura1.consecutivo = adc_manejo.consecutivo
and adc_house_factura1.linea_master = adc_manejo.linea_master
and adc_house_factura1.linea_house = adc_manejo.linea_house
and adc_house_factura1.linea_manejo = adc_manejo.linea_manejo);
*/
