




/*

insert into precios_por_cliente_2 (secuencia, articulo, almacen, precio)
select secuencia, articulo, '09', precio
from precios_por_cliente_2
where almacen = '01'
and secuencia in
(select secuencia from precios_por_cliente_1
where fecha_hasta >= '2014-01-01');


SELECT pla_liquidacion_acumulados.*
FROM pla_liquidacion_acumulados, pla_liquidacion_calculo
where pla_liquidacion_acumulados.id_pla_liquidacion_calculo = pla_liquidacion_calculo.id
and pla_liquidacion_calculo.id_pla_liquidacion = 1880
and pla_liquidacion_calculo.concepto = '220'


*/

