update bcocircula
set status = 'C', fecha_conciliacion = '2004-12-31'
where cod_ctabco = '4'
and fecha_posteo <= '2004-12-31'
and (fecha_conciliacion is null or status = 'R')