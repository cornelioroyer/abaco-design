update oc1
set status = 'C'
where exists
(select * from cxpfact1
where cxpfact1.compania = oc1.compania
and cxpfact1.numero_oc = oc1.numero_oc);
