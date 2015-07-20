delete from bcocircula
where fecha_posteo >= '20040401' and aplicacion <> 'SET'
and not exists
(select * from v_bcocircula
where bcocircula.cod_ctabco = v_bcocircula.cod_ctabco
and bcocircula.motivo_bco = v_bcocircula.motivo_bco
and bcocircula.no_docmto_sys = v_bcocircula.no_docmto_sys
and bcocircula.fecha_posteo = v_bcocircula.fecha_posteo
and bcocircula.monto = v_bcocircula.monto
and v_bcocircula.fecha_posteo >= '20040401')

