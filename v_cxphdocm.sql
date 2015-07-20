drop view v_cxphdocm;
create view v_cxphdocm as
select proveedores.nomb_proveedor, cxphdocm.proveedor, cxphdocm.fecha_posteo, 
cxphdocm.motivo_cxp, cxphdocm.documento, cxphdocm.docmto_aplicar, 
0 as debito, sum(cxpmotivos.signo*cxphdocm.monto) as credito
from cxphdocm, cxpmotivos, proveedores
where cxphdocm.motivo_cxp = cxpmotivos.motivo_cxp
and cxphdocm.proveedor = proveedores.proveedor
group by 1, 2, 3, 4, 5, 6
having sum(cxpmotivos.signo*cxphdocm.monto) < 0
union
select proveedores.nomb_proveedor, cxphdocm.proveedor, cxphdocm.fecha_posteo, 
cxphdocm.motivo_cxp, cxphdocm.documento, cxphdocm.docmto_aplicar,
sum(cxpmotivos.signo*cxphdocm.monto), 0
from cxphdocm, cxpmotivos, proveedores
where cxphdocm.motivo_cxp = cxpmotivos.motivo_cxp
and cxphdocm.proveedor = proveedores.proveedor
group by 1, 2, 3, 4, 5, 6
having sum(cxpmotivos.signo*cxphdocm.monto) > 0