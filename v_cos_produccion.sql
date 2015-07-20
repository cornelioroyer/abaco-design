
drop view v_cos_produccion;

create view v_cos_produccion as
SELECT Anio(a.fecha) as anio, Mes(a.fecha) as mes, b.articulo, c.desc_articulo, 
Sum(b.cantidad) as cantidad, Sum(b.costo) as costo
FROM cos_trx a, cos_produccion b, articulos c  
WHERE a.compania = b.compania AND a.secuencia = b.secuencia 
AND b.articulo = c.articulo  and Anio(a.fecha) >= 2010 
GROUP BY Anio(a.fecha), Mes(a.fecha), b.articulo, c.desc_articulo  
union  
select Anio(a.fecha), Mes(a.fecha), b.articulo, c.desc_articulo, 
-Sum(b.cantidad), Sum(b.costo)  
from eys1 a, eys2 b, articulos c  
where a.almacen = b.almacen  and a.no_transaccion = b.no_transaccion  
and a.motivo in ('12','20')  and b.articulo = c.articulo  and Anio(a.fecha) >= 2010 
group by Anio(a.fecha), Mes(a.fecha), b.articulo, c.desc_articulo  
