insert into bcocircula (sec_docmto_circula,
 cod_ctabco, motivo_bco, proveedor, no_docmto_sys,
 no_docmto_fuente, fecha_transacc, fecha_posteo,
 status, usuario, fecha_captura,
 desc_documento, monto, aplicacion)
select 0, bcotransac1.cod_ctabco,
bcotransac1.motivo_bco, bcotransac1.proveedor,
bcotransac1.sec_transacc, bcotransac1.no_docmto,
bcotransac1.fecha_posteo, bcotransac1.fecha_posteo,
'R', 'dba', today(), bcotransac1.obs_transac_bco, bcotransac1.monto,'BCO' 
from bcotransac1
where monto > 0 and status <> 'A' 
and cod_ctabco = '02'
and not exists
(select * from bcocircula
where bcocircula.cod_ctabco = bcotransac1.cod_ctabco
and bcocircula.no_docmto_sys = bcotransac1.sec_transacc);