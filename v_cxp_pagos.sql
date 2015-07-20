drop view v_cxp_pagos;

create view v_cxp_pagos as
select bcoctas.compania, bcocheck1.proveedor, bcocheck1.docmto_fuente, 
bcocheck3.aplicar_a, bcomotivos.motivo_cxp as motivo_bco, bcocheck3.motivo_cxp, bcocheck3.monto, bcocheck1.fecha_posteo
from bcocheck1, bcocheck3, bcoctas, bcomotivos, cxpdocm
where bcocheck1.cod_ctabco = bcocheck3.cod_ctabco 
and bcocheck1.no_cheque = bcocheck3.no_cheque 
and bcocheck1.motivo_bco = bcocheck3.motivo_bco 
and bcocheck1.cod_ctabco = bcoctas.cod_ctabco 
and bcocheck1.motivo_bco = bcomotivos.motivo_bco and bcocheck1.status <> 'A' 
and cxpdocm.compania = bcoctas.compania and cxpdocm.proveedor = bcocheck1.proveedor 
and cxpdocm.documento = bcocheck3.aplicar_a and cxpdocm.docmto_aplicar = bcocheck3.aplicar_a 
and cxpdocm.motivo_cxp = bcocheck3.motivo_cxp and bcomotivos.aplica_cheques = 'S' 
and bcocheck1.proveedor is not null and bcocheck3.monto <> 0
and bcomotivos.motivo_cxp is not null
union
select bcoctas.compania, bcotransac1.proveedor, bcotransac1.no_docmto,
bcotransac3.aplicar_a, bcomotivos.motivo_cxp as motivo_bco, bcotransac3.motivo_cxp,
bcotransac3.monto, bcotransac1.fecha_posteo
from bcotransac1, bcotransac3, bcoctas, cxpdocm, bcomotivos
where bcotransac1.cod_ctabco = bcotransac3.cod_ctabco
and bcotransac1.sec_transacc = bcotransac3.sec_transacc
and bcotransac1.cod_ctabco = bcoctas.cod_ctabco
and cxpdocm.compania = bcoctas.compania
and cxpdocm.proveedor = bcotransac1.proveedor
and cxpdocm.documento = bcotransac3.aplicar_a and cxpdocm.docmto_aplicar = bcotransac3.aplicar_a
and cxpdocm.motivo_cxp = bcotransac3.motivo_cxp 
and bcotransac1.proveedor is not null
and bcotransac1.motivo_bco = bcomotivos.motivo_bco
and bcomotivos.motivo_cxp is not null;





