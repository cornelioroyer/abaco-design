begin work;
delete from cglposteo
where aplicacion_origen in ('FAC','COM','INV')
and fecha_comprobante between '2007-01-01' and '2007-03-20';
commit work;