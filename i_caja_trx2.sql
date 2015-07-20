insert into caja_trx2 (numero_trx, caja, linea, cuenta, monto)
select numero_trx, caja, 1, '125000', monto
from caja_trx1
where not exists
(select * from caja_trx2
where caja_trx2.caja = caja_trx1.caja
and caja_trx2.numero_trx = caja_trx1.numero_trx);