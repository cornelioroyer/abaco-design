select Mes(a.fecha), b.articulo, c.desc_articulo, sum(b.cantidad), sum(b.costo) from cos_trx a, cos_consumo b, articulos c
where a.compania = b.compania
and a.secuencia = b.secuencia 
and b.articulo = c.articulo
group by Mes(a.fecha), c.desc_articulo, b.articulo
order by Mes(a.fecha), c.desc_articulo, b.articulo
