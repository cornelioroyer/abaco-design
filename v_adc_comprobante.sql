select adc_master.compania, adc_master.consecutivo, adc_master.linea_master, adc_manifiesto.no_referencia,
    adc_master.no_bill, adc_master.container, cglposteo.cuenta, cglposteo.debito, cglposteo.credito
from adc_master, cglposteo, rela_adc_master_cglposteo, adc_manifiesto
where adc_master.compania = rela_adc_master_cglposteo.compania
and adc_master.consecutivo = rela_adc_master_cglposteo.consecutivo
and adc_master.linea_master = rela_adc_master_cglposteo.linea_master
and rela_adc_master_cglposteo.consecutivo = cglposteo.consecutivo
and adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
union
select rela_factura1_cglposteo.almacen, rela_factura1_cglposteo.num_documento, adc_master.linea_master, adc_manifiesto.no_referencia,
    adc_master.no_bill, adc_master.container, cglposteo.cuenta, cglposteo.debito, cglposteo.credito
from adc_manifiesto, adc_master, adc_house, adc_house_factura1, rela_factura1_cglposteo, cglposteo
where adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_house.compania = adc_house_factura1.compania
and adc_house.consecutivo = adc_house_factura1.consecutivo
and adc_house.linea_master = adc_house_factura1.linea_house
and adc_house.linea_house = adc_house_factura1.linea_house
and adc_house_factura1.almacen = rela_factura1_cglposteo.almacen
and adc_house_factura1.tipo = rela_factura1_cglposteo.tipo
and adc_house_factura1.num_documento = rela_factura1_cglposteo.num_documento
and rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
union
select rela_factura1_cglposteo.almacen, rela_factura1_cglposteo.num_documento, adc_master.linea_master, adc_manifiesto.no_referencia,
    adc_master.no_bill, adc_master.container, cglposteo.cuenta, cglposteo.debito, cglposteo.credito
from adc_manifiesto, adc_master, adc_house, adc_manejo, adc_manejo_factura1, rela_factura1_cglposteo, cglposteo
where adc_manifiesto.compania = adc_master.compania
and adc_manifiesto.consecutivo = adc_master.consecutivo
and adc_master.compania = adc_house.compania
and adc_master.consecutivo = adc_house.consecutivo
and adc_master.linea_master = adc_house.linea_master
and adc_house.compania = adc_manejo.compania
and adc_house.consecutivo = adc_manejo.consecutivo
and adc_house.linea_master = adc_manejo.linea_house
and adc_house.linea_house = adc_manejo.linea_house
and adc_manejo.compania = adc_manejo_factura1.compania
and adc_manejo.consecutivo = adc_manejo_factura1.consecutivo
and adc_manejo.linea_master = adc_manejo_factura1.linea_master
and adc_manejo.linea_house = adc_manejo_factura1.linea_house
and adc_manejo.linea_manejo = adc_manejo_factura1.linea_manejo
and adc_manejo_factura1.almacen = rela_factura1_cglposteo.almacen
and adc_manejo_factura1.tipo = rela_factura1_cglposteo.tipo
and adc_manejo_factura1.num_documento = rela_factura1_cglposteo.num_documento
and rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo;



