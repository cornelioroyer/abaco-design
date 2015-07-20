
insert into bcocircula (sec_docmto_circula,
cod_ctabco, motivo_bco, proveedor, no_docmto_sys,
no_docmto_fuente, fecha_transacc, fecha_posteo,
status, usuario, fecha_captura, a_nombre,
desc_documento, monto, aplicacion)
select 0, cod_ctabco,
motivo_bco, proveedor,
no_docmto_sys, no_docmto,
fecha_posteo, fecha_posteo,
'R', current_user, current_timestamp, a_nombre,
concepto, monto, 'BCO' 
from v_bcocircula
where fecha_posteo >= '2014-01-01'
and not exists
(select * from bcocircula
where bcocircula.cod_ctabco = v_bcocircula.cod_ctabco
and bcocircula.motivo_bco = v_bcocircula.motivo_bco
and bcocircula.no_docmto_sys = v_bcocircula.no_docmto_sys);
