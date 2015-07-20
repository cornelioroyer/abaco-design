delete from cglposteo
where compania = '03'
and fecha_comprobante >= '2012-11-01'
and aplicacion_origen in ('PLA','CGL','BCO','CAJ');
