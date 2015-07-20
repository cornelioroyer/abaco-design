select documento, aplicar, count(*)
from trmes
where documento = aplicar and motivo_cxc = 1
group by documento, aplicar
having count(*) > 1;