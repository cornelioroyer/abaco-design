select * from bcocircula
where not exists
(select * from v_bcocircula
where v_bcocircula.cod_ctabco = bcocircula.cod_ctabco
and v_bcocircula.motivo_bco = bcocircula.motivo_bco
and v_bcocircula.no_docmto_sys = bcocircula.no_docmto_sys
and v_bcocircula.fecha_posteo = bcocircula.fecha_posteo
and v_bcocircula.monto = bcocircula.monto);