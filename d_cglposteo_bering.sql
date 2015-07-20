delete from cglposteo
where compania = '01'
and fecha_comprobante between '2006-12-01' and '2006-12-31'
and aplicacion_origen in ('CXP','COM');