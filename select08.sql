select documento, aplicar, cliente, motivo_cxc, count(*) from trmes
group by documento, aplicar, cliente, motivo_cxc
having count(*) > 1