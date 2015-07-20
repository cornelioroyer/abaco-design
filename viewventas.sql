create view fact_ventas as
select 
from almacen a, factmotivos b,
factura1 c, factura2 d
where a.almacen = c.almacen
and b.