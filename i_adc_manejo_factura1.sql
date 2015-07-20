insert into adc_manejo_factura1 (compania, consecutivo, linea_master, linea_house, linea_manejo,
almacen, tipo, num_documento)
select compania, consecutivo, linea_master, linea_house, linea_manejo,
'01', '1', 72767
from adc_manejo
where consecutivo = 8965
and fecha = '2009-02-02'