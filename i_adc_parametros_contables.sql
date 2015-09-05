
insert into adc_parametros_contables(referencia, ciudad,
cta_ingreso, cta_costo, cta_gasto)
select '11', ciudad, '4000', '9000', '9000'
from fac_ciudades
where not exists
(select * from adc_parametros_contables
where adc_parametros_contables.referencia = '11'
and adc_parametros_contables.ciudad = fac_ciudades.ciudad)
