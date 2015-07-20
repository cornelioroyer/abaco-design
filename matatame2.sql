
/*
select sum(cxcdocm_2013_05_20.monto*cxcmotivos.signo)
from cxcdocm_2013_05_20, cxcmotivos, almacen
where cxcdocm_2013_05_20.motivo_cxc = cxcmotivos.motivo_cxc
and cxcdocm_2013_05_20.almacen = almacen.almacen
and almacen.compania = '01'
and fecha_posteo between '2012-12-05' and '2012-12-05';

select sum(cxcdocm.monto*cxcmotivos.signo)
from cxcdocm, cxcmotivos, almacen
where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
and cxcdocm.almacen = almacen.almacen
and almacen.compania = '01'
and fecha_posteo between '2012-12-05' and '2012-12-05'
*/

select cxcdocm_2013_05_20.documento, cxcdocm_2013_05_20.monto
from cxcdocm_2013_05_20, cxcmotivos, almacen
where cxcdocm_2013_05_20.motivo_cxc = cxcmotivos.motivo_cxc
and cxcdocm_2013_05_20.almacen = almacen.almacen
and almacen.compania = '01'
and fecha_posteo between '2012-12-05' and '2012-12-05'
order by 1;

select cxcdocm.documento, cxcdocm.monto
from cxcdocm, cxcmotivos, almacen
where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
and cxcdocm.almacen = almacen.almacen
and almacen.compania = '01'
and fecha_posteo between '2012-12-05' and '2012-12-05'
order by 1;


