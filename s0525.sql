select adc_manejo_factura1.compania, cglposteo.cuenta, sum(cglposteo.debito) as debito, sum(cglposteo.credito) as credito
from rela_factura1_cglposteo, cglposteo, adc_manejo_factura1
where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
and adc_manejo_factura1.almacen = rela_factura1_cglposteo.almacen
and adc_manejo_factura1.tipo = rela_factura1_cglposteo.tipo
and adc_manejo_factura1.num_documento = rela_factura1_cglposteo.num_documento
and rela_factura1_cglposteo.num_documento = 55209
group by 1,2
order by cglposteo.cuenta

