select aplicacion_origen, count(*), Max(fecha_comprobante) from cglposteo
where fecha_comprobante >= '2008-09-01'
and compania = '03'
group by 1
order by 2;