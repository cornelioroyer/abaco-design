select desc_articulo, count(*)
from articulos
group by desc_articulo
having count(*) > 1