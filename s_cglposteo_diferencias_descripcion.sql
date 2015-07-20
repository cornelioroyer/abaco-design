/*
delete from cglposteo
where aplicacion_origen = 'FAC'
and fecha_comprobante = '2011-02-28';

select f_factura1_cglposteo(almacen, tipo, num_documento)
from factura1
where fecha_factura = '2011-02-28';
*/


select cglposteo.descripcion, aplicacion_origen, fecha_comprobante, sum(debito-credito)
from cglposteo
where fecha_comprobante = '2013-09-16'
group by 1, 2, 3
having sum(debito-credito) <> 0
order by 1, 2, 3;


/*
select rela_factura1_cglposteo.almacen, rela_factura1_cglposteo.tipo, 
rela_factura1_cglposteo.num_documento, sum(cglposteo.debito-cglposteo.credito)
from rela_factura1_cglposteo, cglposteo
where rela_factura1_cglposteo.consecutivo = cglposteo.consecutivo
and cglposteo.fecha_comprobante >= '2011-05-01'
group by 1, 2, 3
having sum(cglposteo.debito-cglposteo.credito) <> 0
*/
