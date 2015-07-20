update articulos
set status_articulo = 'I'
where articulo in 
(select articulo 
from tmp_existencias
where cantidad <= 0 or costo <= 0)
