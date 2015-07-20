drop view v_cxp_ajustes_madres;

create view v_cxp_ajustes_madres as
select cxpajuste1.compania, cxpajuste1.proveedor, cxpajuste1.docm_ajuste_cxp, 
cxpajuste1.motivo_cxp, cxpajuste1.fecha_posteo_ajuste_cxp,
sum(cxpajuste3.monto) as monto
from cxpajuste1, cxpajuste3
where cxpajuste1.compania = cxpajuste3.compania and cxpajuste1.sec_ajuste_cxp = cxpajuste3.sec_ajuste_cxp 
and not exists 
(select * from cxpajuste2 
where cxpajuste2.compania = cxpajuste1.compania 
and cxpajuste2.sec_ajuste_cxp = cxpajuste1.sec_ajuste_cxp
and cxpajuste2.monto <> 0)
group by 1, 2, 3, 4, 5

