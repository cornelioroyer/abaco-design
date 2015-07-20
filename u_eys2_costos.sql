update eys2
set costo = 0
where costo <> 0
and exists
(select * from eys1
where almacen in ('01', '02')
and fecha >= '2005-09-01');

