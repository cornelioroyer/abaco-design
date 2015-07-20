update nomdescuentos
set cod_ctabco = null, no_cheque = null, motivo_bco = null
where nomdescuentos.cod_ctabco = bcocheck1.cod_ctabco
and nomdescuentos.no_cheque = bcocheck1.no_cheque
and nomdescuentos.motivo_bco = bcocheck1.motivo_bco
and bcocheck1.status = 'A'