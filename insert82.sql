insert into bcocheck2
select b.linea, b.cuenta, b.cod_ctabco,
a.no_cheque, b.auxiliar1, b.auxiliar2,
a.motivo_bco, b.monto
from bcocheck1 a, tmp_bcocheck2 b
where a.cod_ctabco = b.cod_ctabco
and a.no_solicitud = b.no_cheque