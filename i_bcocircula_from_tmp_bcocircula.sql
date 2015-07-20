

insert into bcocircula (sec_docmto_circula,
cod_ctabco, motivo_bco, no_docmto_sys,
no_docmto_fuente, fecha_transacc, fecha_posteo,
status, usuario, fecha_captura, monto, aplicacion) 
select documento, 'BG','CH', documento, documento,
fecha, fecha, 'R', current_user, current_timestamp, monto, 'SET'
from tmp_bcocircula;
