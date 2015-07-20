update cxpajuste3
set cuenta = '2604'
where cuenta = '2221'
and exists
(select * from cxpajuste1
where cxpajuste1.compania = cxpajuste3.compania
and cxpajuste1.sec_ajuste_cxp = cxpajuste3.sec_ajuste_cxp
and cxpajuste1.compania = '01'
and cxpajuste1.fecha_posteo_ajuste_cxp >= '2004-01-01')
