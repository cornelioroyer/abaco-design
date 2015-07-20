


select clientes.cuenta, trim(to_char(sum(cxcdocm_2013_05_16.monto*cxcmotivos.signo), '999,999,999.99'))
from cxcdocm_2013_05_16, cxcmotivos, almacen, clientes
where cxcdocm_2013_05_16.motivo_cxc = cxcmotivos.motivo_cxc
and fecha_posteo <= '2013-01-31'
and cxcdocm_2013_05_16.almacen = almacen.almacen
and cxcdocm_2013_05_16.cliente = clientes.cliente
and almacen.compania = '03'
group by 1
order by 1;

/*
select trim(to_char(sum(debito-credito), '9999,999,999.99'))
from cglposteo
where compania = '01'
and fecha_comprobante <= '2013-01-31'
and cuenta = '1106000';
*/
