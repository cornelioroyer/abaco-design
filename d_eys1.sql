/*
delete from cglposteo
where aplicacion_origen in ('COS', 'INV')
and fecha_comprobante >= '2006-06-01';
*/

begin work;
delete from eys1
where fecha between '2014-03-01' and '2014-04-19'
and aplicacion_origen in ('COS', 'FAC');
commit work;
