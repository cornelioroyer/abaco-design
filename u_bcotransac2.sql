update bcotransac2
set cuenta = '2604'
where cuenta = '2221'
and exists
(select * from bcotransac1
where bcotransac1.cod_ctabco = bcotransac2.cod_ctabco
and bcotransac1.sec_transacc = bcotransac2.sec_transacc
and bcotransac1.cod_ctabco = '1'
and bcotransac1.fecha_posteo >= '2004-01-01')