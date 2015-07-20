drop view v_bcocircula;
create view v_bcocircula as
select cod_ctabco, motivo_bco, proveedor,
sec_transacc as no_docmto_sys, no_docmto, fecha_posteo,
'' as concepto, substring(trim(obs_transac_bco) from 1 for 60) as a_nombre, monto
from bcotransac1
union 
select bcocheck1.cod_ctabco, bcocheck1.motivo_bco, bcocheck1.proveedor,
bcocheck1.no_cheque as no_docmto_sys, bcocheck1.docmto_fuente, bcocheck1.fecha_posteo,
bcocheck1.en_concepto_de as concepto, bcocheck1.paguese_a as a_nombre, bcocheck1.monto
from bcocheck1, bcomotivos
where bcocheck1.status <> 'A'
and bcocheck1.motivo_bco = bcomotivos.motivo_bco
and bcomotivos.aplica_cheques = 'S'

