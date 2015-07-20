
select eys1.almacen, eys1.no_transaccion, sum(cglposteo.debito-cglposteo.credito)
from eys1, rela_eys1_cglposteo, cglposteo
where eys1.almacen = rela_eys1_cglposteo.almacen
and eys1.no_transaccion = rela_eys1_cglposteo.no_transaccion
and rela_eys1_cglposteo.consecutivo = cglposteo.consecutivo
and eys1.fecha >= '2013-10-01'
and eys1.aplicacion_origen = 'FAC'
group by 1, 2
having sum(cglposteo.debito-cglposteo.credito) <> 0
order by 1, 2
