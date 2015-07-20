
delete from bcocheck3;
insert into bcocheck3
select tmp_bcocheck3.* from tmp_bcocheck3, bcocheck1
where tmp_bcocheck3.cod_ctabco = bcocheck1.cod_ctabco
and tmp_bcocheck3.no_cheque = bcocheck1.no_cheque
and tmp_bcocheck3.motivo_bco = bcocheck1.motivo_bco;
