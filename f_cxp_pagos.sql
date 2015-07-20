drop view cxp_pagos;

create view cxp_pagos as
select a.aplicacion, bcoctas.compania, a.proveedor, a.docmto_fuente, bcocheck3.aplicar_a, a.motivo_bco, bcocheck3.motivo_cxp, bcocheck3.monto, a.fecha_posteo
from bcocheck1 a, bcocheck3, bcoctas, bcomotivos, cxpdocm
where a.cod_ctabco = bcocheck3.cod_ctabco 
and a.no_cheque = bcocheck3.no_cheque 
and a.motivo_bco = bcocheck3.motivo_bco 
and a.cod_ctabco = bcoctas.cod_ctabco 
and a.motivo_bco = bcomotivos.motivo_bco 
and a.status <> 'A' and cxpdocm.compania = bcoctas.compania 
and cxpdocm.proveedor = a.proveedor and cxpdocm.documento = bcocheck3.aplicar_a 
and cxpdocm.docmto_aplicar = bcocheck3.aplicar_a and cxpdocm.motivo_cxp = bcocheck3.motivo_cxp 
and bcomotivos.aplica_cheques = 'S' and bcocheck3.monto <> 0;



