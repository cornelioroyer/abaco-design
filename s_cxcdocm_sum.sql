
select trim(to_char(sum(cxcdocm.monto*cxcmotivos.signo), '999,999,999.99'))
from cxcdocm, cxcmotivos, almacen
where cxcdocm.motivo_cxc = cxcmotivos.motivo_cxc
and fecha_posteo <= '2013-12-31'
and cxcdocm.almacen = almacen.almacen
and almacen.compania = '01';


select trim(to_char(sum(debito-credito), '9999,999,999.99'))
from cglposteo
where compania = '01'
and fecha_comprobante <= '2013-12-31'
and cuenta = '1106000';
