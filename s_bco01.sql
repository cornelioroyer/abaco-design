select f_bcocheck1_cglposteo(cod_ctabco, motivo_bco, no_cheque)
from bcocheck1
where fecha_posteo between '2005-12-01' and '2006-12-31'
and not exists
(select * from rela_bcocheck1_cglposteo
where rela_bcocheck1_cglposteo.cod_ctabco = bcocheck1.cod_ctabco
and rela_bcocheck1_cglposteo.motivo_bco = bcocheck1.motivo_bco
and rela_bcocheck1_cglposteo.no_cheque = bcocheck1.no_cheque);
