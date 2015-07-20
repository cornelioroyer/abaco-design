select sum(cxcdocm.monto*cxcmotivos.signo) from cxcdocm 
where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc 
and cxcdocm.fecha_posteo between '2001-5-1' and '2001-5-15'
and aplicacion_origen = 'SET';


select sum(debito-credito) from cglposteo 
where cuenta = '12.05' and fecha_comprobante between '2001-5-1' and '2001-5-15'
and aplicacion_origen = 'CXC';

