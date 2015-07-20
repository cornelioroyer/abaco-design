select * from bcocircula
where aplicacion <> 'SET' and status <> 'C'
and not exists
(select * from bcotransac1
where bcocircula.cod_ctabco = bcotransac1.cod_ctabco
and bcocircula.no_docmto_sys = bcotransac1.sec_transacc)
and not exists
(select * from bcocheck1
where bcocircula.cod_ctabco = bcocheck1.cod_ctabco
and bcocircula.no_docmto_sys = bcocheck1.no_cheque
and bcocircula.motivo_bco = bcocheck1.motivo_bco
and bcocheck1.status <> 'A'
and bcocheck1.motivo_bco in (select motivo_bco from bcomotivos where aplica_cheques = 'S'));

