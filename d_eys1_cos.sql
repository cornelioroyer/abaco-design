/*
delete from cglposteo
where aplicacion_origen in ('COS', 'INV')
and fecha_comprobante >= '2006-06-01';
*/


begin work;
delete from eys1
where fecha >= '2012-11-01'
and aplicacion_origen in ('COS','FAC');
commit work;
