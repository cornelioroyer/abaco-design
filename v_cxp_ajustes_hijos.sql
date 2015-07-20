drop view v_cxp_ajustes_hijos;

/*==============================================================*/
/* View: cxp_ajustes_hijos                                      */
/*==============================================================*/
create view v_cxp_ajustes_hijos as
select  cxpajuste1.compania, cxpajuste1.proveedor, cxpajuste1.docm_ajuste_cxp as documento, 
cxpajuste2.aplicar_a as docmto_aplicar, cxpajuste1.motivo_cxp as motivo_cxp, 
cxpajuste2.motivo_cxp as motivo_cxp_ref, cxpajuste1.fecha_posteo_ajuste_cxp, cxpajuste2.monto as monto
from cxpajuste1, cxpajuste2, cxpdocm
where cxpajuste1.compania = cxpajuste2.compania 
and cxpajuste1.sec_ajuste_cxp = cxpajuste2.sec_ajuste_cxp 
and cxpajuste1.compania = cxpdocm.compania 
and cxpajuste1.proveedor = cxpdocm.proveedor 
and cxpajuste2.aplicar_a = cxpdocm.documento 
and cxpajuste2.aplicar_a = cxpdocm.docmto_aplicar 
and cxpajuste2.motivo_cxp = cxpdocm.motivo_cxp
and cxpajuste2.monto <> 0 

