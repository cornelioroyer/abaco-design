delete from cxcdocm where motivo_cxc = '6' 
and fecha_posteo >= '2001-5-1' and aplicacion_origen <> 'SET';

update cxctrx1 set status = 'R' where fecha_posteo_ajuste_cxc >= '2001-5-1';




