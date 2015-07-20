update bcocheck2
set cuenta = '2604'
where cuenta = '2221'
and exists
(select * from bcocheck1
where bcocheck1.cod_ctabco = bcocheck2.cod_ctabco
and bcocheck1.no_cheque = bcocheck2.no_cheque
and bcocheck1.motivo_bco = bcocheck2.motivo_bco
and bcocheck1.fecha_posteo >= '2004-01-01'
and bcocheck1.cod_ctabco = '1')