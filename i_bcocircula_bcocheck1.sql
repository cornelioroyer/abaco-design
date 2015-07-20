insert into bcocircula (sec_docmto_circula,
cod_ctabco, motivo_bco, proveedor, no_docmto_sys,
no_docmto_fuente, fecha_transacc, fecha_posteo,
status, usuario, fecha_captura, a_nombre,
desc_documento, monto, aplicacion)
select 0, bcocheck1.cod_ctabco,
bcocheck1.motivo_bco, bcocheck1.proveedor,
bcocheck1.no_cheque, cast(bcocheck1.no_cheque as char),
bcocheck1.fecha_posteo, bcocheck1.fecha_posteo,
'R', 'dba', today(), bcocheck1.paguese_a,
bcocheck1.en_concepto_de, bcocheck1.monto,'BCO' from bcocheck1
where monto > 0 and status <> 'A' 
and cod_ctabco = '4'
and motivo_bco in 
(select motivo_bco from bcomotivos
where aplica_cheques = 'S') and
not exists
(select * from bcocircula
where bcocircula.cod_ctabco = bcocheck1.cod_ctabco
and bcocircula.motivo_bco = bcocheck1.motivo_bco
and bcocircula.no_docmto_sys = bcocheck1.no_cheque);