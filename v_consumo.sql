

drop view v_consumo;

create view v_consumo as
select Anio(eys1.fecha), Mes(eys1.fecha), eys2.articulo, articulos.desc_articulo,
-sum(eys2.cantidad*invmotivos.signo) as cantidad, 
case when sum(eys2.cantidad) = 0 then 0  else (sum(eys2.costo)/sum(eys2.cantidad)) end as cu,
sum(eys2.costo) as costo
from eys1, eys2, invmotivos, articulos
where eys2.articulo = articulos.articulo
and eys1.almacen = eys2.almacen
and eys1.no_transaccion = eys2.no_transaccion
and eys1.motivo = invmotivos.motivo
and eys1.aplicacion_origen in ('COS')
and eys1.motivo = '14'
group by 1, 2, 3, 4
order by 1, 2, 3;


