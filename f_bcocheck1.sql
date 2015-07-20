select * from bcocheck1
where monto > 0 and status <> 'A' and motivo_bco in 
(select motivo_bco from bcomotivos
where aplica_cheques = 'S') and
not exists
(select * from bcocircula
where bcocircula.cod_ctabco = bcocheck1.cod_ctabco
and bcocircula.motivo_bco = bcocheck1.motivo_bco
and bcocircula.no_docmto_sys = bcocheck1.no_cheque);
