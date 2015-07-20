delete from articulos_agrupados
where articulo like 'CAM%';

insert into articulos_agrupados
select articulo, 'SI'
from articulos
where articulo like 'CAM%';

insert into articulos_agrupados
select articulo, 'PM'
from articulos
where articulo like 'CAM%';

insert into articulos_agrupados
select articulo, '02'
from articulos
where articulo like 'CAM%';
