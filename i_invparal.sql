insert into invparal (almacen, parametro,
aplicacion, valor)
select '10', parametro, aplicacion, valor
from invparal
where almacen = '01';