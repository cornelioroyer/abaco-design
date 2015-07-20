
update caja_trx2
set auxiliar_1 = '000'
from caja_trx1, cglcuentas
where caja_trx1.caja = caja_trx2.caja
and caja_trx1.numero_trx = caja_trx2.numero_trx
and caja_trx2.cuenta = cglcuentas.cuenta
and cglcuentas.auxiliar_1 = 'S'
and caja_trx2.auxiliar_1 is null
and caja_trx1.fecha_trx >= '2015-01-01';





