
insert into bcocheck2
select tmp_bcocheck2.* from tmp_bcocheck2, bcocheck1
where tmp_bcocheck2.cod_ctabco = bcocheck1.cod_ctabco
and tmp_bcocheck2.no_cheque = bcocheck1.no_cheque
and tmp_bcocheck2.motivo_bco = bcocheck1.motivo_bco;
