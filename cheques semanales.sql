drop view v_cheques;

create view v_cheques as
select bcoctas.desc_ctabco, 
Anio(bcocheck1.fecha_cheque) as anio,
Mes(bcocheck1.fecha_cheque) as mes, 
Extract(week from bcocheck1.fecha_cheque) as semana,

bcocheck1.fecha_cheque, 
bcocheck1.no_cheque, bcocheck1.paguese_a, bcocheck1.en_concepto_de
case when bcocheck1.status = 'A' then 0 else bcocheck1.monto
from bcoctas, bcocheck1, bcomotivos
where bcoctas.cod_ctabco = bcocheck1.cod_ctabco
and bcocheck1.motivo_bco = bcomotivos.motivo_bco
and bcomotivos.aplica_cheques = 'S'
