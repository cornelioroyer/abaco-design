

delete from fac_parametros_contables where referencia = '2';

insert into fac_parametros_contables(almacen, referencia, codigo_valor_grupo,
cta_de_ingreso, cta_de_costo, vtas_exentas, cta_de_gasto)
select almacen, '2', codigo_valor_grupo,
cta_de_ingreso, cta_de_costo, vtas_exentas, cta_de_gasto
from fac_parametros_contables
where referencia = '1';



