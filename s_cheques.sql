select cod_ctabco, bcocheck1.motivo_bco, Anio(bcocheck1.fecha_cheque), Mes(bcocheck1.fecha_cheque), count(*)
from bcocheck1, bcomotivos
where bcocheck1.motivo_bco = bcomotivos.motivo_bco
and bcomotivos.aplica_cheques = 'S'
and bcocheck1.status <> 'A'
and bcocheck1.fecha_cheque >= '2007-01-01'
group by 1, 2, 3, 4
order by 1, 2, 3, 4;

select cod_ctabco, bcocheck1.motivo_bco, count(*)
from bcocheck1, bcomotivos
where bcocheck1.motivo_bco = bcomotivos.motivo_bco
and bcomotivos.aplica_cheques = 'S'
and bcocheck1.status <> 'A'
and bcocheck1.fecha_cheque between '2007-01-01' and '2007-10-31'
group by 1, 2
order by 1, 2