

delete from cxpajuste2
where not exists
(select * from cxpajuste1
where cxpajuste1.compania = cxpajuste2.compania
and cxpajuste1.sec_ajuste_cxp = cxpajuste2.sec_ajuste_cxp);

/*

delete from cxpajuste3
where not exists
(select * from cxpajuste1
where cxpajuste1.compania = cxpajuste3.compania
and cxpajuste1.sec_ajuste_cxp = cxpajuste3.sec_ajuste_cxp);


*/

