select cglcuentas.nombre, bcocheck1.fecha_cheque, bcocheck1.no_cheque,
bcocheck1.monto, bcocheck1.paguese_a
from bcoctas, bcocheck1, cglcuentas
where bcoctas.cod_ctabco = bcocheck1.cod_ctabco
and cglcuentas.cuenta = bcoctas.cuenta
and bcocheck1.fecha_cheque between '2009-01-01' and '2009-12-31'
order by 1, 2, 3