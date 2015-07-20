select bcocheck3.* from bcocheck1, bcocheck3, bcoctas
where bcocheck1.cod_ctabco = bcocheck3.cod_ctabco
and bcocheck1.motivo_bco = bcocheck3.motivo_bco
and bcocheck1.no_cheque = bcocheck3.no_cheque
and bcocheck1.cod_ctabco = bcoctas.cod_ctabco
and bcocheck3.monto <> 0
and bcocheck1.fecha_cheque >= '2010-10-01'
and bcocheck1.status <> 'A'
and not exists
(select * from cxpdocm
where cxpdocm.compania = bcoctas.compania
and cxpdocm.documento = bcocheck3.aplicar_a
and cxpdocm.docmto_aplicar = bcocheck3.aplicar_a
and cxpdocm.motivo_cxp = cxpdocm.motivo_cxp_ref
and cxpdocm.motivo_cxp = bcocheck3.motivo_cxp)
