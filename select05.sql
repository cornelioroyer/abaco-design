select sum(bcocircula.monto*bcomotivos.signo) from bcocircula, bcomotivos
where bcocircula.motivo_bco = bcomotivos.motivo_bco
and bcocircula.fecha_posteo between '2001-4-4'
and '2001-4-4' and bcocircula.cod_ctabco = '01';

select sum(debito-credito) from cglposteo
where cuenta = '11.03' and
fecha_comprobante between '2001-4-4' and
'2001-4-4';
