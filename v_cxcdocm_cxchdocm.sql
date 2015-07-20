drop view v_cxcdocm_cxchdocm;
create view v_cxcdocm_cxchdocm as
select almacen.compania, cxcdocm.almacen, cliente, cxcdocm.motivo_cxc, documento, docmto_aplicar, docmto_ref, motivo_ref, fecha_posteo as fecha, (cxcdocm.monto*cxcmotivos.signo) as monto 
from cxcdocm, cxcmotivos, almacen
where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
and cxcdocm.almacen = almacen.almacen
union
select almacen.compania, cxchdocm.almacen, cliente, cxchdocm.motivo_cxc, documento, docmto_aplicar, docmto_ref, motivo_ref, fecha_posteo, (cxchdocm.monto*cxcmotivos.signo) 
from cxchdocm, cxcmotivos, almacen
where cxchdocm.motivo_cxc = cxcmotivos.motivo_cxc
and cxchdocm.almacen = almacen.almacen