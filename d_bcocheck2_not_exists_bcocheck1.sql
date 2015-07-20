delete from bcocheck2
where not exists
(select * from bcocheck1
where bcocheck1.cod_ctabco = bcocheck2.cod_ctabco
and bcocheck1.motivo_bco = bcocheck2.motivo_bco
and bcocheck1.no_cheque = bcocheck2.no_cheque);

