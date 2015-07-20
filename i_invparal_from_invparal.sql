-- delete from invparal where almacen = '04';

insert into invparal (almacen, parametro,
aplicacion, valor)
select '09', parametro, aplicacion, valor
from invparal
where almacen = '01'
and not exists
(select * from invparal c
where c.almacen = '09'
and c.parametro = invparal.parametro
and c.aplicacion = invparal.aplicacion);
