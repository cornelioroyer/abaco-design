drop view cxc_hijos;

create view cxc_hijos as
select 'CXC' as aplicacion, a.almacen, a.cliente, a.docm_ajuste_cxc, b.aplicar_a, a.motivo_cxc, 
b.motivo_cxc as motivo_ref, a.fecha_posteo_ajuste_cxc as fecha_posteo, sum(b.monto) as monto
from cxctrx1 a, cxctrx2 b, cxcdocm c
where a.sec_ajuste_cxc = b.sec_ajuste_cxc 
and a.almacen = b.almacen 
and c.almacen = b.almacen 
and c.cliente = a.cliente 
and c.documento = b.aplicar_a 
and c.docmto_aplicar = b.aplicar_a 
and c.motivo_cxc = b.motivo_cxc
and b.monto <> 0
group by a.almacen, a.cliente, a.docm_ajuste_cxc, b.aplicar_a, a.motivo_cxc, b.motivo_cxc, a.fecha_posteo_ajuste_cxc

