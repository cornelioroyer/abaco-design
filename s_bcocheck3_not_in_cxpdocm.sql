select bcocheck3.*
from bcocheck3, bcocheck1
where bcocheck3.cod_ctabco = bcocheck1.cod_ctabco
and bcocheck3.motivo_bco = bcocheck1.motivo_bco
and bcocheck3.no_cheque = bcocheck1.no_cheque
and bcocheck3.monto <> 0
and bcocheck1.fecha_cheque >= '2013-07-01'
and not exists
(select * from cxpdocm
where cxpdocm.proveedor = bcocheck1.proveedor
and cxpdocm.documento = bcocheck3.aplicar_a
and cxpdocm.docmto_aplicar = bcocheck3.aplicar_a
and cxpdocm.motivo_cxp = bcocheck3.motivo_cxp)
order by bcocheck3.no_cheque;

