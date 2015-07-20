
insert into tmp_cxcmov (cliente, motivo, fecha, documento, monto, aplicar)
select cliente, motivo, to_date(fecha, 'dd/mm/yyyy'), documento, monto, aplicar
from cxcmov;



