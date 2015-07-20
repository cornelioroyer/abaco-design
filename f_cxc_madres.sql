drop view cxc_madres;

create view cxc_madres as
select 'CXC' as aplicacion, almacen, cliente, docm_ajuste_cxc as documento, motivo_cxc, 
fecha_posteo_ajuste_cxc as fecha_posteo, sum(cheque + efectivo) as monto, referencia
from cxctrx1
where  not exists 
(select * from cxctrx2 where cxctrx2.almacen = cxctrx1.almacen 
and cxctrx2.sec_ajuste_cxc = cxctrx1.sec_ajuste_cxc and cxctrx2.monto <> 0)
group by almacen, cliente, documento, motivo_cxc, fecha_posteo, referencia;
