drop view v_consumo_trigo;
create view v_consumo_trigo as
select Anio(eys1.fecha) as anio, Mes(eys1.fecha) as mes, 
invmotivos.desc_motivo,
Trim(eys2.articulo) as articulo, 
Trim(articulos.desc_articulo) as desc_articulo, gral_valor_grupos.desc_valor_grupo,
sum(eys2.cantidad*invmotivos.signo) as cantidad, 
(case when sum(eys2.cantidad) = 0 then 0 else (sum(eys2.costo)/sum(eys2.cantidad)) end) as cu,
sum(eys2.costo) as costo
from eys1, eys2, invmotivos, articulos, articulos_agrupados, gral_valor_grupos
where articulos_agrupados.articulo = articulos.articulo
and articulos_agrupados.codigo_valor_grupo = gral_valor_grupos.codigo_valor_grupo
and gral_valor_grupos.grupo = 'SDI'
and eys2.articulo = articulos.articulo
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys1.fecha >= '2009-01-01'
group by 1, 2, 3, 4, 5, 6
order by 1, 2, 3;
