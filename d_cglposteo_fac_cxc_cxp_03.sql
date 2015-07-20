delete from cglposteo
where fecha_comprobante >= '2013-05-01'
and compania = '03'
and aplicacion_origen in ('FAC','CXC','CXP');
