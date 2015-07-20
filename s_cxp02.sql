select bcocheck1.*
from bcocheck1, bcocheck3, bcomotivos, bcoctas
where bcomotivos.motivo_bco = bcocheck1.motivo_bco
and bcocheck1.cod_ctabco = bcocheck3.cod_ctabco
and bcocheck1.motivo_bco = bcocheck3.motivo_bco
and bcocheck1.no_cheque = bcocheck3.no_cheque
and bcocheck1.cod_ctabco = bcoctas.cod_ctabco
and bcomotivos.aplica_cheques = 'S'
and bcocheck1.fecha_posteo >= '2005-11-01'
and bcocheck1.proveedor is null
and not exists
(select * from cxpdocm
where cxpdocm.compania = bcoctas.compania
and cxpdocm.proveedor = bcocheck1.proveedor
and cxpdocm.docmto_aplicar = bcocheck3.aplicar_a
and cxpdocm.docmto_aplicar_ref = bcocheck3.aplicar_a
and cxpdocm.motivo_cxp_ref = bcocheck3.motivo_cxp);

