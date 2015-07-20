delete from cxpbalance
where compania = '03'
and year = 2007
and periodo = 8;

insert into cxpbalance(compania, aplicacion, year, periodo, proveedor, saldo)
select cxpdocm.compania,'CXP',2007,8,proveedor, sum(cxpdocm.monto*cxpmotivos.signo)
from cxpdocm, cxpmotivos
where cxpdocm.motivo_cxp = cxpmotivos.motivo_cxp
and cxpdocm.fecha_posteo <= '2007-08-31'
and cxpdocm.compania = '03'
group by cxpdocm.compania,proveedor;
