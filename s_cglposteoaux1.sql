select cglposteo.cuenta, cglposteoaux1.auxiliar, sum(cglposteoaux1.debito-cglposteo.credito)
from cglposteo, cglposteoaux1
where cglposteo.consecutivo = cglposteoaux1.consecutivo
and cglposteo.cuenta = '2106004'
and cglposteo.fecha_comprobante >= '2008-01-01'
group by 1, 2
having sum(cglposteoaux1.debito-cglposteo.credito) > 0
order by 1, 2