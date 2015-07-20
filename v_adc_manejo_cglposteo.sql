select distinct cglposteo.cuenta, cglposteo.debito, cglposteo.credito, adc_manejo.observacion
from cglposteo, rela_factura1_cglposteo, adc_manejo_factura1, adc_manejo
where cglposteo.consecutivo = rela_factura1_cglposteo.consecutivo
and adc_manejo_factura1.almacen = rela_factura1_cglposteo.almacen
and adc_manejo_factura1.tipo = rela_factura1_cglposteo.tipo
and adc_manejo_factura1.num_documento = rela_factura1_cglposteo.num_documento
and adc_manejo.compania = adc_manejo_factura1.compania
and adc_manejo.consecutivo = adc_manejo_factura1.consecutivo
and adc_manejo.linea_master = adc_manejo_factura1.linea_master
and adc_manejo.linea_house = adc_manejo_factura1.linea_house
and adc_manejo.linea_manejo = adc_manejo_factura1.linea_manejo
and adc_manejo_factura1.consecutivo = 1143
